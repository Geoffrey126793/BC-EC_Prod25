codeunit 50046 Integration_Items
{

    trigger OnRun()
    begin

        MinReorder();
        //AlerteStockOF();
    end;

    var
        emailmsg: codeunit "Email Message";
        emailsend: Codeunit Email;
        TempBlob: Codeunit "Temp Blob";
        InStr: InStream;

    [EventSubscriber(ObjectType::Codeunit, 241, 'OnBeforeCode', '', false, false)]
    local procedure CU241_OnBeforePost(var ItemJournalLine: Record "Item Journal Line"; var HideDialog: Boolean)
    var
        ILE: Record "Item Ledger Entry";
    begin
        HideDialog := not GuiAllowed;
        if GuiAllowed then begin
            if (ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Purchase) and (ItemJournalLine."Lot No." <> '') then begin
                ILE.Reset;
                ILE.SetRange("Item No.", ItemJournalLine."Item No.");
                ILE.SetRange("Posting Date", ItemJournalLine."Posting Date");
                ILE.SetRange("Lot No.", ItemJournalLine."Lot No.");
                if ILE.FindFirst then
                    if not Confirm('Un réception existe déjà pour ce lot/date. Continuer ?') then
                        Error('');

            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 5812, 'OnCalcItemOnBeforeShowStrMenu', '', false, false)]
    local procedure CU5812_OnCalcItemOnBeforeShowStrMenu(var Item: Record Item; var ShowStrMenu: Boolean; var NewCalcMultiLevel: Boolean)
    begin
        ShowStrMenu := GuiAllowed;
        ShowStrMenu := false;
        NewCalcMultiLevel := true;
    end;

    [EventSubscriber(ObjectType::Table, 27, 'OnAfterValidateEvent', 'Replenishment System', false, false)]
    local procedure T27_Replenishment_Validate(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    begin
        if ((Rec."Replenishment System" = Rec."Replenishment System"::"Prod. Order") and (CopyStr(UpperCase(CompanyName), 1, 4) = 'EC D')) then
            Rec.Validate("Routing No.", 'ATELIERS');
    end;

    [EventSubscriber(ObjectType::Codeunit, 6501, 'OnAfterTransferExpDateFromSummary', '', false, false)]
    local procedure CU6501_OnAfterTransferExpDateFromSummary(var TrackingSpecification: Record "Tracking Specification"; var TempEntrySummary: Record "Entry Summary" temporary)
    begin
        // !!!   Warranty = DLC chez EC
        TrackingSpecification."Warranty Date" := TempEntrySummary."Warranty Date";
        TrackingSpecification."New Expiration Date" := TrackingSpecification."Expiration Date";

    end;

    [EventSubscriber(ObjectType::Codeunit, 5812, 'OnCalcMfgItemOnBeforeCalculateCosts', '', false, false)]
    local procedure CU5812_OnCalcMfgItemOnBeforeCalculateCosts(var SLMat: Decimal; var SLCap: Decimal; var SLSub: Decimal; var SLCapOvhd: Decimal; var SLMfgOvhd: Decimal; var Item: Record Item; LotSize: Decimal; MfgItemQtyBase: Decimal; Level: Integer; CalculationDate: Date)
    var
        CuProd: Codeunit "Integration Tft and Prod";
    begin
        if Item.IsMfgItem then begin
            SLCap := CuProd.GetMatriceCost(Item."No.", Today);
        end
        else begin
            SLMat := Item."Standard Cost";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 5812, 'OnCalcMfgItemOnBeforeCalcRtngCost', '', false, false)]
    local procedure CU5812_OnCalcMfgItemOnBeforeCalcRtngCost(var Item: Record Item; Level: Integer; var LotSize: Decimal; var MfgItemQtyBase: Decimal)
    begin
        if Item.IsMfgItem then begin

        end
        else begin
            Item."Unit Cost" := Item."Standard Cost";
        end;
    end;

    [EventSubscriber(ObjectType::Table, 27, 'OnBeforeValidateStandardCost', '', false, false)]
    local procedure T27_OnValidateStandardCost(var Item: Record Item; xItem: Record Item; CallingFieldNo: Integer; var IsHandled: Boolean)
    var
        Histo: Record "Histo couts";
    begin

        if (Item."Standard Cost" <> xItem."Standard Cost") then begin
            Histo.Reset;
            Histo.SetRange(Item, Item."No.");
            Histo.SetRange(Date, Today);
            Histo.SetRange(Type, Histo.Type::"Cout standard");
            if Histo.FindFirst then
                Histo.Delete;
            Histo.Reset;
            Histo.Init;
            Histo.Type := Histo.Type::"Cout standard";
            Histo.Item := Item."No.";
            Histo.Date := Today;
            Histo.Cout := Item."Standard Cost";
            Histo.Insert;

        end;
    end;

    [EventSubscriber(ObjectType::Table, 27, 'OnAfterInsertEvent', '', false, false)]
    local procedure T27_OnInsert(var Rec: Record Item; RunTrigger: Boolean)
    var
        Centres: Record "Work Center";
        Liens: Record "Ateliers Liens";
        ItemsUnit: Record "Item Unit of Measure";
        cuVP: Codeunit "Call WS";
    begin
        if RunTrigger then begin
            /*   smtp.CreateMessage('Navision','xerox@europacuisson.com',
                'g.dangremont@europacuisson.com;t.massage@europacuisson.com;p.corbisier@europacuisson.com;h.demeyere@europacuisson.com'
                ,'Modification article',
                USERID+' a créé l''article  '+Rec."No.",TRUE);
                emailsend.Send(emailmsg,Enum::"Email Scenario"::Default);
             */
            emailmsg.Create(
               'g.dangremont@europacuisson.com;comptabilite@europacuisson.com'
               , 'Modification article',
               UserId + ' a créé l''article  ' + Rec."No.", true);
            emailsend.Send(emailmsg, Enum::"Email Scenario"::Default);
            emailsend.Send(emailmsg, Enum::"Email Scenario"::Default);
            Centres.Reset;
            Centres.SetRange("Work Center Group Code", 'ATELIERS');
            Centres.SetRange(Blocked, false);
            if Centres.FindSet then
                repeat
                    Liens.Init;
                    Liens.Article := Rec."No.";
                    Liens."Centre de charges" := Centres."No.";
                    Liens.Début := Today;
                    Liens.Insert;
                until Centres.Next = 0;

            ItemsUnit.Init;
            ItemsUnit."Item No." := Rec."No.";
            ItemsUnit.Code := 'KG';
            ItemsUnit."Qty. per Unit of Measure" := 1;
            if ItemsUnit.Insert then;

            Rec."Base Unit of Measure" := 'KG';
            cuVP.UpdateItem(Rec."No.");
        end;

    end;

    [EventSubscriber(ObjectType::Table, 27, 'OnAfterModifyEvent', '', false, false)]
    local procedure T27_OnModify(var Rec: Record Item; var xRec: Record Item; RunTrigger: Boolean)
    var
        T5405: Record "Production Order";
        cuVP: Codeunit "Call WS";
    begin
        if (Rec.Blocked <> xRec.Blocked) then begin
            emailmsg.Create(
            'g.dangremont@europacuisson.com;t.massage@europacuisson.com', 'Modification article',
            UserId + ' a modifié le blocage sur l''article ' + Rec."No.", true);
            emailsend.Send(emailmsg, Enum::"Email Scenario"::Default);
        end;
        if (Rec."Machine sur écran" <> xRec."Machine sur écran") or (Rec.Process <> xRec.Process) then begin
            T5405.Reset;
            T5405.SetRange(Status, T5405.Status::Released);
            T5405.SetRange("Source No.", Rec."No.");
            if T5405.FindSet then
                repeat
                    T5405.Validate("Source No.", T5405."Source No.");
                    T5405.Modify(false);
                until T5405.Next = 0;
        end;

        if (xRec."Production BOM No." <> '') and (Rec."Production BOM No." = '') then begin
            Error('Impossible de supprimer la nomenclature');
        end;

        if (Rec.Description <> xRec.Description)
        or (Rec."Criteria 4" <> xRec."Criteria 4")
        or (Rec."Criteria 15" <> xRec."Criteria 15")
        or (Rec."Niveau allergene" <> xRec."Niveau allergene")
        or (Rec.Planning <> xRec.Planning)
        or (Rec.Cadence <> xRec.Cadence)
        or (Rec.Blocked <> xRec.Blocked)
        or (Rec."Reorder Quantity" <> xRec."Reorder Quantity")
        or (Rec."Force VP")
        or (Rec."Machines pour VP" <> xRec."Machines pour VP")
        then begin
            //"Force VP" := FALSE;
            // Rec.MODIFY;

            cuVP.UpdateItem(Rec."No.");
        end;
    end;

    [Scope('OnPrem')]
    procedure MinReorder()
    var
        Items: Record Item;
        i: Integer;
        Dispo: Decimal;
        CalcStock: Codeunit "Stock EC";
        Items2: Record Item;
        xl: Record "Excel Buffer" temporary;
        outStr: OutStream;
        fName: Text;
        FileMgmt: Codeunit "File Management";
        mFile: File;
        TempBlob: Codeunit "Temp Blob";
        InStr: InStream;
    begin
        emailmsg.Create('g.dangremont@europacuisson.com;t.hardy@europacuisson.com;YannFoucray@europacuisson.com;Cherazade.Mazari@europacuisson.com;Encoder2@europacuisson.com;Nabil.Aissal@europacuisson.com;Zerouali.Abdeltif@europacuisson.com', 'Stock minimum', '', true);
        //smtp.CreateMessage('Xerox@europacuisson.com','Xerox@europacuisson.com','g.dangremont@europacuisson.com','Stock minimum','',TRUE);
        i := 0;
        Items.Reset;
        Items.SetFilter("Reorder Point", '>0');
        Items.SetRange(Blocked, false);
        if Items.FindSet then
            repeat
                //Voir P50030
                //  Dispo := CalcStock.getInventoryEC(Items) - CalcStock.getInventoryOnSales(Items) + CalcStock.getInventoryOnPurchase(Items) + CalcStock.getInventoryOnOF(Items) - CalcStock.getInventoryOnComponent(Items);
                Dispo := CalcStock.getInventoryEC(Items) - CalcStock.getInventoryOnSales(Items) + CalcStock.getInventoryOnPurchase(Items) + CalcStock.getInventoryOnOF(Items) - CalcStock.getInventoryOnComponent(Items) + CalcStock.getInventoryTft(Items) - +CalcStock.getInventoryBlocked(Items);
                if (CopyStr(Items."No.", 1, 5) = '7-EPC') or (CopyStr(Items."No.", 1, 1) = '8') then begin
                    Items2.Reset;
                    Items2.SetRange("No.", Items."No.");
                    Items2.SetFilter("Location Filter", 'EC STOCK');
                    Items2.FindFirst;
                    Items2.CalcFields(Inventory);
                    if ((Dispo < Items."Reorder Point") or (Items2.Inventory < Items."Reorder Point")) then begin
                        xl.NewRow();
                        xl.AddColumn(Items."No.", false, '', false, false, false, '', xl."Cell Type"::Text);
                        xl.AddColumn(Dispo, false, '', false, false, false, '', xl."Cell Type"::Number);
                        xl.AddColumn(Items."Reorder Point", false, '', false, false, false, '', xl."Cell Type"::Number);
                        xl.AddColumn(Items."Reorder Quantity", false, '', false, false, false, '', xl."Cell Type"::Number);
                        xl.AddColumn(Items2.Inventory, false, '', false, false, false, '', xl."Cell Type"::Number);
                        emailmsg.AppendToBody(Items."No." + '&nbsp;&nbsp;&nbsp;&nbsp;Dispo&nbsp;:&nbsp;' + Format(Dispo) + '&nbsp;Min&nbsp;:&nbsp;' + Format(Items."Reorder Point") + '&nbsp;&nbsp;&nbsp;&nbsp;Reappro standard&nbsp;:&nbsp;' + Format(Items."Reorder Quantity") + '&nbsp;&nbsp;&nbsp;&nbspSTOCK EPICES : ' + Format(Items2.Inventory) + '</BR>');
                        i += 1;
                    end;
                end
                else begin
                    if (Dispo < Items."Reorder Point") then begin
                        xl.NewRow();
                        xl.AddColumn(Items."No.", false, '', false, false, false, '', xl."Cell Type"::Text);
                        xl.AddColumn(Dispo, false, '', false, false, false, '', xl."Cell Type"::Number);
                        xl.AddColumn(Items."Reorder Point", false, '', false, false, false, '', xl."Cell Type"::Number);
                        xl.AddColumn(Items."Reorder Quantity", false, '', false, false, false, '', xl."Cell Type"::Number);
                        xl.AddColumn(0, false, '', false, false, false, '', xl."Cell Type"::Number);
                        xl.AddColumn(CalcStock.getIntermediaireNo(Items), false, '', false, false, false, '', xl."Cell Type"::Number);
                        emailmsg.AppendToBody(Items."No." + '&nbsp;&nbsp;&nbsp;&nbsp;Dispo&nbsp;:&nbsp;' + Format(Dispo) + '&nbsp;Min&nbsp;:&nbsp;' + Format(Items."Reorder Point") + '&nbsp;&nbsp;&nbsp;&nbsp;Reappro standard&nbsp;:&nbsp;' + Format(Items."Reorder Quantity") + '&nbsp;&nbsp;&nbsp;&nbsp' + CalcStock.getIntermediaireNo(Items) + '</BR>');
                        i += 1;
                    end;
                end;
            until Items.Next = 0;
        if i > 0 then begin
            //  xl.CreateBook('StockMini.xlsx','StockMini');
            xl.CreateNewBook('StockMini');
            xl.WriteSheet('StockMini', CompanyName, UserId);
            xl.CloseBook();
            fName := FileMgmt.ServerTempFileName('xlsx');
            mFile.Create(fName);
            mFile.CreateOutStream(outStr);
            xl.SaveToStream(outStr, true);
            mFile.Close;
            FileMgmt.BLOBImportFromServerFile(TempBlob, fName);
            TempBlob.CreateInStream(InStr);
            emailmsg.AddAttachment('StockMini.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', InStr);
            emailsend.Send(emailmsg, enum::"Email Scenario"::Default)
        end;
        Message('%1', i);
    end;

    [Scope('OnPrem')]
    procedure GetTotalMatriceCost(ItemNo: Code[20]; Dt: Date): Decimal
    var
        ProdBOMLine: Record "Production BOM Line";
        Items: Record Item;
        CoutTotal: Decimal;
        VersionMgt: Codeunit VersionManagement;
        CostCalcMgt: Codeunit "Cost Calculation Management";
        CompItemQtyBase: Decimal;
        CuProd: Codeunit "Integration Tft and Prod";
    begin
        Items.Get(ItemNo);
        CoutTotal := CuProd.GetMatriceCost(Items."No.", Dt);
        if Items.IsMfgItem and (Items."Production BOM No." <> '') then begin
            ProdBOMLine.SetRange("Production BOM No.", Items."Production BOM No.");
            ProdBOMLine.SetRange("Version Code", VersionMgt.GetBOMVersion(Items."Production BOM No.", Dt, false));

            ProdBOMLine.SetFilter("Starting Date", '%1|..%2', 0D, Dt);
            ProdBOMLine.SetFilter("Ending Date", '%1|%2..', 0D, Dt);
            if ProdBOMLine.FindSet then
                repeat
                    if Items.Get(ProdBOMLine."No.") then
                        if Items.IsMfgItem then begin
                            CompItemQtyBase := CostCalcMgt.CalcCompItemQtyBase(ProdBOMLine, Dt, CostCalcMgt.CalcQtyAdjdForBOMScrap(1, Items."Scrap %"), Items."Routing No.", true);
                            CoutTotal := CoutTotal + CompItemQtyBase * GetTotalMatriceCost(Items."No.", Dt);
                        end
                until ProdBOMLine.Next = 0;
        end;
        exit(CoutTotal);
    end;

    [EventSubscriber(ObjectType::Table, 27, 'OnAfterValidateEvent', 'CB Souche', false, false)]
    local procedure T27_CalcGS1(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    var
        utils: Codeunit Utils;
    begin
        Rec."EAN13 Code" := '';
        Rec."CB carton" := '';
        if StrLen(Rec."CB Souche") = 12 then begin
            Rec."EAN13 Code" := Rec."CB Souche" + utils.GS1GetCheck(Rec."CB Souche");
            Rec."CB carton" := '1' + Rec."CB Souche" + utils.GS1GetCheck('1' + Rec."CB Souche");
            Rec.GTIN := Rec."EAN13 Code";
        end;
    end;

    [Scope('OnPrem')]
    procedure AlerteStockOF()
    var
        Items: Record Item;
        i: Integer;
        Dispo: Decimal;
        CalcStock: Codeunit "Stock EC";
        rStock: Report "Rupture StockMP1";
        FileMgmt: Codeunit "File Management";
        f: Text;
        TempBlob: Codeunit "Temp Blob";
        InStr: InStream;
    begin
        //smtp.CreateMessage('Xerox@europacuisson.com','Xerox@europacuisson.com','g.dangremont@europacuisson.com;r.mathijs@europacuisson.com;Franck.Szczepanski@europacuisson.com;e.pressez@europacuisson.com','Stock minimum','',TRUE);
        emailmsg.Create('g.dangremont@europacuisson.com;Encoder2@europacuisson.com;YannFoucray@europacuisson.com;Cherazade.Mazari@europacuisson.com', 'Stock minimum', '', true);
        f := FileMgmt.ServerTempFileName('pdf');
        rStock.SaveAsPdf(f);
        if FileMgmt.ServerFileExists(f) then begin
            Clear(TempBlob);
            FileMgmt.BLOBImportFromServerFile(TempBlob, f);
            TempBlob.CreateInStream(InStr);
            emailmsg.AddAttachment('AlertesStock.pdf', 'application/pdf', InStr);
            emailsend.Send(emailmsg, Enum::"Email Scenario"::Default);
        end;

    end;

    [Scope('OnPrem')]
    procedure AlerteDLC()
    var
        Items: Record Item;
        i: Integer;
        Dispo: Decimal;
        CalcStock: Codeunit "Stock EC";
        rDLC: Report "DLC Epices";
        FileMgmt: Codeunit "File Management";
        f: Text;
        TempBlob: Codeunit "Temp Blob";
        InStr: InStream;
    begin
        //smtp.CreateMessage('Xerox@europacuisson.com','Xerox@europacuisson.com','g.dangremont@europacuisson.com;r.mathijs@europacuisson.com;Franck.Szczepanski@europacuisson.com;e.pressez@europacuisson.com','Stock minimum','',TRUE);
        emailmsg.Create('g.dangremont@europacuisson.com;YannFoucray@europacuisson.com;Pauline.Celet@europacuisson.com;encoder2@europacuisson.com;qualite@europacuisson.com;jacques.Ayissi@europacuisson.com;t.hardy@europacuisson.com;Nabil.Aissal@europacuisson.com', 'DLC expirées < 2 mois', '', true);
        f := FileMgmt.ServerTempFileName('pdf');
        rDLC.SaveAsPdf(f);
        if FileMgmt.ServerFileExists(f) then begin
            Clear(TempBlob);
            FileMgmt.BLOBImportFromServerFile(TempBlob, f);
            TempBlob.CreateInStream(InStr);
            emailmsg.AddAttachment('AlertesDLC.pdf', 'application/pdf', InStr);
        end;
        emailsend.Send(emailmsg, Enum::"Email Scenario"::Default);


    end;

    [Scope('OnPrem')]
    procedure "Cmd Retard"()
    var
        i: Integer;
        PurchL: Record "Purchase Line";
    begin
        emailmsg.Create('g.dangremont@europacuisson.com;t.hardy@europacuisson.com;YannFoucray@europacuisson.com', 'Commandes en retard (< 30 jours)', '', true);
        //smtp.CreateMessage('Xerox@europacuisson.com','Xerox@europacuisson.com','g.dangremont@europacuisson.com','Commandes en retard (< 30 jours)','',TRUE);

        i := 0;
        PurchL.SetRange("Document Type", PurchL."Document Type"::Order);
        PurchL.SetRange(Type, PurchL.Type::Item);
        PurchL.SetFilter("No.", '<>11*');
        PurchL.SetFilter("Qty. to Receive (Base)", '>0');
        PurchL.SetFilter("Planned Receipt Date", '%1..%2', CalcDate('<-1M>', Today), Today);
        if PurchL.FindSet then
            repeat
                emailmsg.AppendToBody(PurchL."Document No." + '&nbsp;&nbsp;' + PurchL."Vendor Name" + '&nbsp;&nbsp;&nbsp;&nbsp;Article&nbsp;:&nbsp;' + PurchL."No." + '&nbsp;Qty&nbsp;:&nbsp;' + Format(PurchL."Qty. to Receive (Base)") + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:&nbsp;' + Format(PurchL."Planned Receipt Date") + '</BR>');
                i += 1;

            until PurchL.Next = 0;
        if i > 0 then emailsend.Send(emailmsg, enum::"Email Scenario"::Default);
    end;

    [EventSubscriber(ObjectType::Table, 27, 'OnBeforeValidateStandardCost', '', false, false)]
    local procedure T27_ModifStdCost(var Item: Record Item; xItem: Record Item; CallingFieldNo: Integer; var IsHandled: Boolean)
    begin
        if (Item."Costing Method" = Item."Costing Method"::Standard) and (CallingFieldNo <> 0) and not GuiAllowed then begin
            Item."Standard Cost" := xItem."Standard Cost";
            IsHandled := true;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 27, 'OnBeforeModifyEvent', '', false, false)]
    local procedure T27_onBeforeModify(var Rec: Record Item; var xRec: Record Item; RunTrigger: Boolean)
    begin
        Rec.tmp := 'e';
    end;

    [Scope('OnPrem')]
    procedure AlerteStockCmd()
    var
        Items: Record Item;
        i: Integer;
        Dispo: Decimal;
        CalcStock: Codeunit "Stock EC";
        rStock: Report "Prob cmd";
        FileMgmt: Codeunit "File Management";
        f: Text;
    begin

        emailmsg.Create('g.dangremont@europacuisson.com;ProdToSales@europacuisson.com', 'Problem commandes < 10J', '', true);
        f := FileMgmt.ServerTempFileName('pdf');
        rStock.SaveAsPdf(f);
        if FileMgmt.ServerFileExists(f) then begin
            Clear(TempBlob);
            FileMgmt.BLOBImportFromServerFile(TempBlob, f);
            TempBlob.CreateInStream(InStr);
            emailmsg.AddAttachment('Problemes Cmd.pdf', 'application/pdf', InStr);
            emailsend.Send(emailmsg, Enum::"Email Scenario"::Default);
        end;

    end;

    [Scope('OnPrem')]
    procedure ProdASuivre()
    var
        Items: Record Item;
        i: Integer;
        Dispo: Decimal;
        CalcStock: Codeunit "Stock EC";
        rStock: Report "Prob cmd";
        FileMgmt: Codeunit "File Management";
        f: Text;
        ProdH: Record "Production Order";
        Txt: Text;
    begin

        emailmsg.Create('g.dangremont@europacuisson.com;t.hardy@europacuisson.com;Baptiste.Decat@europacuisson.com;Ugur@europacuisson.com;Hugo.dietsch@europacuisson.com;Celeste.Dete@europacuisson.com', 'Productions a suivre < 7J', '', true);
        ProdH.Reset;
        ProdH.SetFilter("Due Date", '%1..%2', Today, CalcDate('<+7D>', Today));
        Txt := '';
        if ProdH.FindSet then
            repeat
                if Items.Get(ProdH."Source No.") then
                    if Items."A suivre" then
                        Txt += Format(ProdH."Due Date") + '    ' + ProdH."No." + '    ' + ProdH."Source No." + '</BR>';
            until ProdH.Next = 0;
        if Txt <> '' then begin
            emailmsg.AppendToBody(Txt);
            emailsend.Send(emailmsg, Enum::"Email Scenario"::Default);
        end;

    end;

    [EventSubscriber(ObjectType::Table, 27, 'OnBeforeValidateEvent', 'Piece par heartbeat', false, false)]
    local procedure "T27_Validate PiecePerHeartbeat"(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    var
        Codes: Record "Code";
    begin
        Codes.Reset;
        Codes.SetRange("Table No", 27);
        Codes.SetRange("Field No", 8001305);
        Codes.SetRange(Code, Rec."Criteria 5");
        if Codes.FindFirst then begin
            Rec."Kg par heartbeat" := Codes."Poids primaire" * Rec."Piece par heartbeat";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 6501, 'OnAfterCreateEntrySummary2', '', false, false)]
    local procedure C6501_OnAfterCreateEntrySummary2(var TempGlobalEntrySummary: Record "Entry Summary" temporary; var TempGlobalReservEntry: Record "Reservation Entry" temporary)
    begin
        if TempGlobalEntrySummary.FindSet then
            repeat
                TempGlobalEntrySummary."Item No." := TempGlobalReservEntry."Item No.";
                TempGlobalEntrySummary.Modify;
            until TempGlobalEntrySummary.Next = 0;
    end;
}

