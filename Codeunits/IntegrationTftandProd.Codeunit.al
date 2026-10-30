codeunit 50045 "Integration Tft and Prod"
{

    trigger OnRun()
    var
        test: Record "Production Order" temporary;
        r5405: Record "Production Order";
        r: Record "Production BOM Header";
    begin
        //MESSAGE('%1',cuTypeHelper.RegexReplace('1-FPS-00052','1-','5-'));
        //MESSAGE('%1',GetFirstIntermediateItemProduitByItem  ('7-CFR-00001'));
        //BlockDLC();

        //r.GET('1IQF00062');
        //MESSAGE('%1',GetFirstMP(r,''));
        //r.GET('1IQF00906');
        //MESSAGE('%1',GetAllMP(r,'',10000));
        //MESSAGE('%1',GetTotalMPPerUnit(r,''));
        r5405.Reset;
        r5405.SetRange("Due Date", 20260101D, 20261231D);
        if r5405.FindSet then
            repeat
                r5405."Effectif Nomenclature" := GetEffectifProd(r5405."No.");
                r5405.Modify;
            until r5405.Next = 0;
        Message('ok');
    end;

    var
        Text001: Label 'Les lots sont verrouillés';
        Text002: Label 'Vous n''avez pas l''autorisation de (dé)bloquer la traçabilité';
        cuUtils: Codeunit Utils;
        cuTypeHelper: Codeunit "Type Helper";
        emailmsg: Codeunit "Email Message";
        emailsend: Codeunit Email;

    [EventSubscriber(ObjectType::Codeunit, 5704, 'OnBeforeTransferOrderPostShipment', '', false, false)]
    local procedure CU5704_OnBeforeTftShipment(var TransferHeader: Record "Transfer Header"; CommitIsSuppressed: Boolean)
    var
        FromLocation: Record Location;
        resEntry: Record "Reservation Entry";
        PalletJnl: Record "Pallet Journal";
        TransLine: Record "Transfer Line";
        Items: Record Item;
        ToLocation: Record Location;
        Utils: Codeunit Utils;
    begin
        FromLocation.Get(TransferHeader."Transfer-from Code");
        if FromLocation."Pallet Management" then begin
            resEntry.Reset;
            resEntry.SetRange("Source Type", 5741);
            resEntry.SetRange("Source Subtype", 0);
            resEntry.SetRange("Source ID", TransferHeader."No.");
            if resEntry.Find('-') then begin
                repeat
                    PalletJnl.Reset;
                    PalletJnl.SetRange("Reservation Entry", resEntry."Entry No.");
                    //IF ((NOT PalletJnl.FIND('-')) AND (STRPOS(USERID,'GEOFFREYD') = 0)) THEN ERROR('Préciser la palettisation pour l''article %1 - Lot %2, écriture %3',resEntry."Item No.",resEntry."Lot No.",resEntry."Entry No.");
                    if not PalletJnl.Find('-') then Error('Préciser la palettisation pour l''article %1 - Lot %2, écriture %3', resEntry."Item No.", resEntry."Lot No.", resEntry."Entry No.");
                until resEntry.Next = 0;
            end;
            TransLine.Reset;
            TransLine.SetRange("Document No.", TransferHeader."No.");
            if TransLine.FindSet then
                repeat
                    if (TransLine."Item No." <> '') and Items.Get(TransLine."Item No.") then
                        if Items."Item Tracking Code" = '' then begin
                            PalletJnl.Reset;
                            PalletJnl.SetRange("Journal Template Name", TransferHeader."No.");
                            PalletJnl.SetRange("Journal Line No.", TransLine."Line No.");
                            if not PalletJnl.Find('-') then Error('Préciser la palettisation pour l''article %1', TransLine."Item No.");
                        end;
                until TransLine.Next = 0;
            if GuiAllowed and TransferHeader."Direct Transfer" then
                Error('Transfert direct non autorisé pour les magasins avec palettes');
        end;
        ToLocation.Get(TransferHeader."Transfer-to Code");
        if ToLocation."Pallet Management" then
            if GuiAllowed and TransferHeader."Direct Transfer" then
                Error('Transfert direct non autorisé pour les magasins avec palettes');

        if (TransferHeader."Transfer-from Code" = 'EC STOCK') or (TransferHeader."Transfer-to Code" = 'EC STOCK') then begin
            //IF NOT Utils.IsInGroup('ECTOCK') THEN
            //  ERROR('Vous n''avez pas les droits OTS avec le stock');
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 5705, 'OnBeforeTransferOrderPostReceipt', '', false, false)]
    local procedure CU5705_OnBeforeTftReceipt(var TransferHeader: Record "Transfer Header"; CommitIsSuppressed: Boolean)
    var
        NewLocation: Record Location;
        resEntry: Record "Reservation Entry";
        PalletJnl: Record "Pallet Journal";
        TransLine: Record "Transfer Line";
        Items: Record Item;
    begin

        NewLocation.Get(TransferHeader."Transfer-to Code");
        if NewLocation."Pallet Management" then begin
            resEntry.Reset;
            resEntry.SetRange("Source Type", 5741);
            resEntry.SetRange("Source Subtype", 1);
            resEntry.SetRange("Source ID", TransferHeader."No.");
            if resEntry.Find('-') then begin
                repeat
                    PalletJnl.Reset;
                    PalletJnl.SetRange("Reservation Entry", resEntry."Entry No.");
                    if not PalletJnl.Find('-') then
                        Error('Préciser la palettisation pour l''article %1 - Lot %2',
                               resEntry."Item No.", resEntry."Lot No.");
                until resEntry.Next = 0;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 5705, 'OnAfterTransferOrderPostReceipt', '', false, false)]
    local procedure CU5705_OnAfterTftTReceipt(var TransferHeader: Record "Transfer Header"; CommitIsSuppressed: Boolean; var TransferReceiptHeader: Record "Transfer Receipt Header")
    var
        RecPalletEntry_l: Record "Pallet Ledger Entry";
        RepPrintPalletLabel_l: Report "Print Pallet Label";
        RecPallet_l: Record Pallet;
        sessionId: Integer;
    begin
        //--> ABC GEN 20130702
        if (not TransferHeader.Dedouanement) and not TransferHeader.Auto then begin
            // IF NewLocation."Pallet Management" AND (RecWhseRcptHeader_l.GET(TransRcptHeader."No.")) THEN BEGIN

            RecPalletEntry_l.SetCurrentKey("Document No.", "Posting Date");
            RecPalletEntry_l.SetRange("Document No.", TransferReceiptHeader."No.");
            RecPalletEntry_l.SetRange("Posting Date", TransferReceiptHeader."Posting Date");
            if RecPalletEntry_l.Find('-') then
                //Print Label
                repeat
                    Clear(RepPrintPalletLabel_l);
                    RecPallet_l.Reset;
                    RecPallet_l.SetRange("SSCC No.", RecPalletEntry_l."SSCC No.");
                    if RecPallet_l.Find('-') then begin
                        if RecPallet_l."Inbound Document No." <> 'OF VALIDE' then  //Inutile ? => Auto flag
                        begin
                            StartSession(sessionId, CODEUNIT::"Print palet Etiq", CompanyName, RecPallet_l);
                            //RepPrintPalletLabel_l.USEREQUESTPAGE(FALSE);
                            //RepPrintPalletLabel_l.SETTABLEVIEW(RecPallet_l);
                            //RepPrintPalletLabel_l.RUN;
                        end;

                    end;
                until RecPalletEntry_l.Next = 0;
        end;
        //<-- ABC GEN 20130702
    end;

    [EventSubscriber(ObjectType::Codeunit, 5705, 'OnBeforePostItemJournalLine', '', false, false)]
    local procedure CU5705_OnBeforePostItemJournalLine(var ItemJournalLine: Record "Item Journal Line"; TransferLine: Record "Transfer Line"; TransferReceiptHeader: Record "Transfer Receipt Header"; TransferReceiptLine: Record "Transfer Receipt Line"; CommitIsSuppressed: Boolean)
    begin
        ItemJournalLine."Document No. Pallet" := TransferReceiptHeader."Transfer Order No.";
        ItemJournalLine."Document Line No. Pallet" := TransferLine."Line No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, 99000831, 'OnBeforeUpdateItemTracking', '', false, false)]
    local procedure CU99000831_OnBeforeUpdateItemTracking(var ReservEntry: Record "Reservation Entry"; var TrackingSpecification: Record "Tracking Specification")
    begin
        ReservEntry.Validate("Pallet Qty", TrackingSpecification."Pallet Qty");   // ABC VIE 20130617
    end;

    [EventSubscriber(ObjectType::Report, 99001025, 'OnBeforeCalcProdOrder', '', false, false)]
    local procedure R99001025_OnBeforeRecalculate(var ProductionOrder: Record "Production Order")
    var
        Item: Record Item;
        BomH: Record "Production BOM Header";
        tmp: Decimal;
    begin
        if (DT2Time(ProductionOrder."Starting Date-Time") <> ProductionOrder."Starting Time") then begin
            ProductionOrder."Starting Time" := DT2Time(ProductionOrder."Starting Date-Time");  //recalcul Time, erreur via WebService UTC
            ProductionOrder."Starting Date" := DT2Date(ProductionOrder."Starting Date-Time");
        end;
        if (DT2Time(ProductionOrder."Ending Date-Time") <> ProductionOrder."Ending Time") then begin
            ProductionOrder."Ending Time" := DT2Time(ProductionOrder."Ending Date-Time");
            ProductionOrder."Ending Date" := DT2Date(ProductionOrder."Ending Date-Time");
        end;
        if Item.Get(ProductionOrder."Source No.") then
            if BomH.Get(Item."Production BOM No.") then begin
                tmp := GetTotalMPPerUnit(BomH, ProductionOrder."Production BOM Version");
                if (ProductionOrder."Quantité MP" > 0) and (ProductionOrder.Quantity = 0) then begin
                    if (tmp = 0) then tmp := 1;
                    ProductionOrder.Quantity := ProductionOrder."Quantité MP" / tmp;
                end
                else begin
                    ProductionOrder."Quantité MP" := ProductionOrder.Quantity * tmp;
                end;
                ProductionOrder."Effectif Nomenclature" := GetEffectifProd(ProductionOrder."No.");
            end;
    end;

    [EventSubscriber(ObjectType::Report, 99001025, 'OnAfterRefreshProdOrder', '', false, false)]
    local procedure R99001025_OnAfterRecalculate(var ProductionOrder: Record "Production Order"; ErrorOccured: Boolean)
    begin
        RefreshABC(ProductionOrder."No.");
    end;

    [EventSubscriber(ObjectType::Table, 99000771, 'OnAfterValidateEvent', 'Status', false, false)]
    local procedure T99000771_onChangeStatus(var Rec: Record "Production BOM Header"; var xRec: Record "Production BOM Header"; CurrFieldNo: Integer)
    begin

        if (Rec.Status = Rec.Status::Certified) and (CompanyName = 'EC Démarrage') then begin
            emailmsg.Create(
            'g.dangremont@europacuisson.com;t.massage@europacuisson.com;t.hardy@europacuisson.com;qualite@europacuisson.com'
            , 'Modification nomenclature',
            UserId + ' a modifié la nomenclature  ' + Rec."No.", true);
            emailsend.Send(emailmsg, enum::"Email Scenario"::Default);
        end;
    end;

    [EventSubscriber(ObjectType::Table, 99000779, 'OnAfterValidateEvent', 'Status', false, false)]
    local procedure T99000779_onChangeStatus(var Rec: Record "Production BOM Version"; var xRec: Record "Production BOM Version"; CurrFieldNo: Integer)

    begin

        if (Rec.Status = Rec.Status::Certified) and (CompanyName = 'EC Démarrage') then begin
            emailmsg.Create(
            'g.dangremont@europacuisson.com;t.massage@europacuisson.com;Nabil.Aissal@europacuisson.com;t.hardy@europacuisson.com;qualite@europacuisson.com'
            , 'Modification nomenclature',
                UserId + ' a modifié la nomenclature  ' + Rec."Production BOM No." + ' , version ' + Rec."Version Code", true);
            emailsend.Send(emailmsg, enum::"Email Scenario"::Default);
        end;
    end;

    [EventSubscriber(ObjectType::Table, 83, 'OnBeforeValidateEvent', 'Cap. Unit of Measure Code', false, false)]
    local procedure T83_WC_Ateliers(var Rec: Record "Item Journal Line"; var xRec: Record "Item Journal Line"; CurrFieldNo: Integer)
    var
        Item: Record Item;
        WorkCenter: Record "Work Center";
        recABC: Record "ABC Cost OF";
    begin

        if (Rec.Type = Rec.Type::"Work Center") and (Rec."No." = 'ATELIERS') then
            if Item.Get(Rec."Item No.") then
                if WorkCenter.Get(Rec."No.") then begin
                    recABC.Init;
                    recABC.ID := CreateGuid();
                    recABC."OF" := Rec."Order No.";
                    recABC.Line := Rec."Order Line No.";
                    recABC."Unit Cost" := ABC_GetMatriceCostItem(Rec."Item No.", Rec."Posting Date");
                    recABC.Qty := Rec."Quantity (Base)";
                    recABC.Cost := recABC."Unit Cost" * recABC.Qty;
                    recABC.Insert;
                    WorkCenter.Validate("Direct Unit Cost", 0);
                    WorkCenter.Modify;
                    Rec."Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
                end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 5704, 'OnAfterCreateItemJnlLine', '', false, false)]
    local procedure CU5704_OnAfterCreateItemJournalLine(var ItemJournalLine: Record "Item Journal Line"; TransferLine: Record "Transfer Line"; TransferShipmentHeader: Record "Transfer Shipment Header"; TransferShipmentLine: Record "Transfer Shipment Line")
    begin

        ItemJournalLine."Document No. Pallet" := TransferLine."Document No.";
        ItemJournalLine."Document Line No. Pallet" := TransferLine."Line No.";
    end;

    [EventSubscriber(ObjectType::Table, 83, 'OnAfterCopyItemJnlLineFromPurchLine', '', false, false)]
    local procedure T83_OnCopyFromPurchLine(var ItemJnlLine: Record "Item Journal Line"; PurchLine: Record "Purchase Line")
    begin

        ItemJnlLine."Document No. Pallet" := PurchLine."Document No.";
        ItemJnlLine."Document Line No. Pallet" := PurchLine."Line No.";
    end;

    [EventSubscriber(ObjectType::Table, 5405, 'OnAfterModifyEvent', '', false, false)]
    local procedure T5405_OnModify(var Rec: Record "Production Order"; var xRec: Record "Production Order"; RunTrigger: Boolean)
    var
        SessionId: Integer;
        Prod: Record "Production Order";
        BOMH: Record "Production BOM Header";
        Item: Record Item;
        cuProd: Codeunit "Integration Tft and Prod";
        tmp: Decimal;
        ILE: Record "Item Ledger Entry";
        Reserv: Record "Reservation Entry";
        Comment: Record "Prod. Order Comment Line";
        n: Integer;
        WhereUsed: Codeunit "Where-Used Management";
        recItem: Record Item;
        WhereUsedLine: Record "Where-Used Line";
        ItemToProduce: Code[20];
        CuScan: Codeunit "WS Scan";
    begin
        if RunTrigger and ((CopyStr(Rec."Source No.", 1, 5) = '5-FSV') or (CopyStr(Rec."Source No.", 1, 5) = '5-FPS')) then begin
            Rec.Confirmed := true;
            Rec.Modify(false);
        end;
        if RunTrigger and (Rec.IDVP <> '') and (CopyStr(Rec.IDVP, 1, 2) <> 'WB') then begin
            ILE.Reset;
            ILE.SetRange("Order Type", ILE."Order Type"::Production);
            ILE.SetRange("Order No.", Rec."No.");
            if ILE.FindFirst then exit;

            if ((Rec."Quantité MP" > 0) and (Rec.Quantity = 0)) or (Rec."Quantité MP" <> xRec."Quantité MP") or (Rec.Quantity > 0) then begin
                Reserv.Reset;
                Reserv.SetRange("Source ID", Rec."No.");
                if not Reserv.FindFirst then
                    if Rec."Source No." <> '' then begin

                        Prod.Reset;
                        Prod.SetFilter("No.", Rec."No.");
                        Prod.FindFirst;

                        REPORT.Run(REPORT::"Refresh Production Order", false, true, Prod);
                        //RRefresh.USEREQUESTPAGE(FALSE);
                        //RRefresh.SETTABLEVIEW(Prod);
                        //RRefresh.RUN();

                        if Rec."Source Type" = Rec."Source Type"::Item then
                            if Item.Get(Rec."Source No.") then
                                if BOMH.Get(Item."Production BOM No.") then begin
                                    tmp := GetTotalMPPerUnit(BOMH, Rec."Production BOM Version");
                                    if (Rec."Quantité MP" > 0) and (Rec.Quantity = 0) then begin
                                        if (tmp > 0) then
                                            Rec.Quantity := Round(Rec."Quantité MP" / tmp, 1);
                                    end
                                    else begin
                                        Rec."Quantité MP" := Rec.Quantity * tmp;
                                    end;
                                    //Plus à jour, prob  en venant de VP
                                    //DG040326 remis partiellement
                                    //IF (Item.Cadence > 0) AND (Rec."Ending Date-Time" = Rec."Starting Date-Time") THEN
                                    //   Rec.VALIDATE("Ending Date-Time",Rec."Starting Date-Time" + ROUND((Rec.Quantity / Item.Cadence),0.001)*60*60*1000);
                                    //          ELSE
                                    //IF (STRPOS(Item."No.",'5-CRU') > 0) THEN
                                    //  Rec.VALIDATE("Ending Date-Time",Rec."Starting Date-Time" + 72*60*60*1000)
                                    //ELSE
                                    //  Rec.VALIDATE("Ending Date-Time",Rec."Starting Date-Time" + 3*60*60*1000);

                                    Rec.Modify(false);
                                end;
                        Commit;
                        Prod.Reset;
                        Prod.SetFilter("No.", Rec."No.");
                        Prod.FindFirst;
                        REPORT.Run(REPORT::"Refresh Production Order", false, true, Prod);
                        REPORT.Run(REPORT::"Refresh Production Order", false, true, Prod);
                        /*RRefresh.USEREQUESTPAGE(FALSE);
                        RRefresh.SETTABLEVIEW(Prod);
                        RRefresh.RUN();
                           RRefresh.USEREQUESTPAGE(FALSE);
                        RRefresh.SETTABLEVIEW(Prod);
                        RRefresh.RUN();
                        */
                    end;
                //STARTSESSION(SessionId,CODEUNIT::"Call WS UpdateOF",COMPANYNAME,Rec);
            end;

            Comment.Reset;
            Comment.SetRange(Status, Rec.Status);
            Comment.SetRange("Prod. Order No.", Rec."No.");
            Comment.SetRange(Code, 'VP');
            Comment.DeleteAll();
            Comment.Reset;
            Comment.SetRange(Status, Rec.Status);
            Comment.SetRange("Prod. Order No.", Rec."No.");
            if Comment.FindLast then
                n := Comment."Line No." + 10000
            else
                n := 10000;
            if Rec."Commentaires VP" <> '' then begin
                Comment.Init;
                Comment.Status := Rec.Status;
                Comment."Prod. Order No." := Rec."No.";
                Comment."Line No." := n;
                Comment.Comment := CopyStr(Rec."Commentaires VP", 1, 80);
                Comment.Code := 'VP';
                Comment.Insert;
                n := n + 10000;
            end;

            if Rec."Recyclage VP" <> '' then begin
                Comment.Init;
                Comment.Status := Rec.Status;
                Comment."Prod. Order No." := Rec."No.";
                Comment."Line No." := n;
                Comment.Comment := CopyStr('Recyclage : ' + Rec."Recyclage VP", 1, 80);
                Comment.Code := 'VP';
                Comment.Insert;
                n := n + 10000;
                if StrLen(Rec."Recyclage VP") > 80 then begin
                    Comment.Init;
                    Comment.Status := Rec.Status;
                    Comment."Prod. Order No." := Rec."No.";
                    Comment."Line No." := n;
                    Comment.Comment := CopyStr('Recyclage : ' + Rec."Recyclage VP", 81, 80);
                    Comment.Code := 'VP';
                    Comment.Insert;
                    n := n + 10000;
                end;
                n := n + 10000;
            end;

        end;
        n := 0;

        /*IF RunTrigger AND  ((COPYSTR(Rec."Source No.",1,5) = '5-FSV')) THEN
        BEGIN
          recItem.GET(Rec."Source No.");
          WhereUsed.WhereUsedFromItem(recItem,TODAY,FALSE);
          WHILE (WhereUsed.NextRecord(1,WhereUsedLine) <> 0) DO
          BEGIN
            IF (COPYSTR(WhereUsedLine."Item No.",1,1) = '1') THEN
            BEGIN
              n := n + 1;
              ItemToProduce := WhereUsedLine."Item No.";
            END;
          END;
          IF n = 1 THEN
          BEGIN
            Prod.RESET;
            Prod.SETRANGE("Source No.",ItemToProduce);
            Prod.SETRANGE("Due Date",GetNextWorkingDate(Rec."Starting Date"));
            IF NOT Prod.FINDFIRST THEN
            BEGIN
              Prod.RESET;
              Prod.SETRANGE(IDVP,Rec."No.");
              IF Prod.FINDFIRST THEN
                Prod.DELETE;
        
        
              Prod.RESET;
              Prod.SETRANGE("No.",  CreateOF(ItemToProduce,Rec.Quantity,Rec."Location Code",CREATEDATETIME(GetNextWorkingDate(Rec."Starting Date"),DT2TIME(Rec."Starting Date-Time"))));
              IF Prod.FINDFIRST THEN
              BEGIN
                Prod.IDVP := Rec."No.";
                Prod.MODIFY(FALSE);
              END;
        
            END;
          END;
        END;
        */

    end;

    [EventSubscriber(ObjectType::Codeunit, 5510, 'OnBeforeRunProductionJnl', '', false, false)]
    local procedure CU5510_OnBeforOpenJnlProd(ToTemplateName: Code[10]; ToBatchName: Code[10]; ProdOrder: Record "Production Order"; ActualLineNo: Integer; var PostingDate: Date; var IsHandled: Boolean)
    begin
        PostingDate := ProdOrder."Starting Date";
    end;

    [EventSubscriber(ObjectType::Codeunit, 5510, 'OnBeforeInsertConsumptionJnlLine', '', false, false)]
    local procedure CU5510_OnBeforeInsertConsumptionJnl(var ItemJournalLine: Record "Item Journal Line"; ProdOrderComp: Record "Prod. Order Component"; ProdOrderLine: Record "Prod. Order Line"; Level: Integer)
    begin
        ItemJournalLine."Posting Date" := ProdOrderLine."Starting Date";
    end;

    [EventSubscriber(ObjectType::Codeunit, 5510, 'OnBeforeInsertOutputJnlLine', '', false, false)]
    local procedure CU5510_OnBeforeInsertOutputJnl(var ItemJournalLine: Record "Item Journal Line"; ProdOrderRtngLine: Record "Prod. Order Routing Line"; ProdOrderLine: Record "Prod. Order Line")
    begin
        ItemJournalLine."Posting Date" := ProdOrderLine."Starting Date";
    end;

    [EventSubscriber(ObjectType::Table, 5740, 'OnAfterValidateEvent', 'Blocage des lots', false, false)]
    local procedure T5740_OnModifBlocage(var Rec: Record "Transfer Header"; var xRec: Record "Transfer Header"; CurrFieldNo: Integer)
    begin
        if Rec."Blocage des lots" <> xRec."Blocage des lots" then
            if not cuUtils.IsInGroup('LOT-UNBLOCK') then
                Error(Text002);
    end;

    [EventSubscriber(ObjectType::Table, 5200, 'OnBeforeInsertEvent', '', false, false)]
    local procedure T5200_InsertEmployee(var Rec: Record Employee; RunTrigger: Boolean)
    var
        CU396: Codeunit "No. Series";
        CuUtils: Codeunit Utils;
        CB: Text;
    begin
        CB := CU396.GetNextNo('CB_EMPLOYEE', Today, true);
        Rec.Barcode := CB + CuUtils.EAN13GetCheck(CB);
    end;

    [Scope('OnPrem')]
    procedure GetFirstIntermediateItemProduitByItem(ItemCode: Code[20]) ItemProduit: Code[20]
    var
        ShowLevel: Option Single,Multi;
        WhereUsed: Codeunit "Where-Used Management";
        recItem: Record Item;
        WhereUsedLine: Record "Where-Used Line";
    begin
        recItem.Get(ItemCode);
        WhereUsed.WhereUsedFromItem(recItem, Today, false);
        while (WhereUsed.NextRecord(1, WhereUsedLine) <> 0) do
            if (CopyStr(WhereUsedLine."Item No.", 1, 1) = '5') then
                exit(WhereUsedLine."Item No.");
        exit(ItemCode);
    end;

    [Scope('OnPrem')]
    procedure GetFirstItemProduitByItem(ItemCode: Code[20]) ItemProduit: Code[20]
    var
        ShowLevel: Option Single,Multi;
        WhereUsed: Codeunit "Where-Used Management";
        recItem: Record Item;
        WhereUsedLine: Record "Where-Used Line";
    begin
        recItem.Get(ItemCode);
        WhereUsed.WhereUsedFromItem(recItem, Today, false);
        while (WhereUsed.NextRecord(1, WhereUsedLine) <> 0) do

            exit(WhereUsedLine."Item No.");
        exit(ItemCode);
    end;

    local procedure ABC_Ressource_GetCost("Code": Code[20]; Date: Date): Decimal
    var
        recCout: Record "Historique Cout Ressources";
    begin
        recCout.Reset;
        recCout.SetRange(Ressource, Code);
        recCout.SetFilter(StartDate, '<=%1', Date);
        if recCout.FindLast then
            exit(recCout.Cost);
    end;

    [Scope('OnPrem')]
    procedure ABC_GetParameters(var Params: Record "ABC - Parametres"; "Bom No": Code[20]; "BOM Version": Code[20]; Dt: Date)
    var
        recParams: Record "ABC - Parametres";
        CoutH: Decimal;
        Ress: Record "ABC - Ressources";
        Cout: Decimal;
    begin
        //CoutH := 30;
        Ress.Get('000');
        CoutH := ABC_Ressource_GetCost('000', Dt);


        recParams.Reset;
        recParams.SetRange("Production BOM No", "Bom No");
        recParams.SetRange("BOM Version", "BOM Version");
        if recParams.FindSet then
            repeat
                Cout := CoutH;
                Params.Init;
                Params.TransferFields(recParams, true);
                Ress.Get(Params.Ressource);
                if (Ress.Type = Ress.Type::"Machine (planifiable)") or (Ress.Type = Ress.Type::"Main d'oeuvre production") or (Ress.Type = Ress.Type::"Matériel") or (Ress.Type = Ress.Type::"Prestation externe") then begin
                    if Params.Unité = recParams.Unité::"Kg/Heure" then begin
                        if (Params."Rendement effectif" <> 0) then
                            Params."Hr Prod Kg" := (Params."Nombre d'opérateurs") / Params."Rendement effectif";
                    end;
                    if Params.Unité = recParams.Unité::"Heure/Batch" then begin
                        if (Params."Batch standard" <> 0) then
                            Params."Hr Prod Kg" := (Params."Nombre d'opérateurs" * Params."Rendement effectif") / Params."Batch standard";
                    end;
                end;

                if (Ress.Type <> Ress.Type::"Prestation externe") or (Ress."Type Cout" = Ress."Type Cout"::"€/h") then begin
                    if (ABC_Ressource_GetCost(Ress.Code, Dt) > 0) then
                        Cout := ABC_Ressource_GetCost(Ress.Code, Dt);
                    if Params.Unité = recParams.Unité::"Kg/Heure" then begin
                        if (Params."Rendement effectif" <> 0) then begin
                            Params."Hr Prod Kg" := (Params."Nombre d'opérateurs") / Params."Rendement effectif";
                            Params."Cout Kg" := (Params."Nombre d'opérateurs" * Cout) / Params."Rendement effectif";
                        end;
                    end;
                    if Params.Unité = recParams.Unité::"Heure/Batch" then begin
                        if (Params."Batch standard" <> 0) then begin
                            Params."Hr Prod Kg" := (Params."Nombre d'opérateurs" * Params."Rendement effectif") / Params."Batch standard";
                            Params."Cout Kg" := (Params."Nombre d'opérateurs" * Cout * Params."Rendement effectif") / Params."Batch standard";
                        end;
                    end;
                end
                else  //Prest externe
                begin
                    Cout := ABC_Ressource_GetCost(Ress.Code, Dt);
                    if (Ress."Type Cout" = Ress."Type Cout"::"€/kg") and (Params.Unité = Params.Unité::"Kg/Heure") then begin
                        Params."Cout Kg" := Params."Nombre d'opérateurs" * Cout;
                    end;
                    if Ress."Type Cout" = Ress."Type Cout"::"€/batch" then begin
                        Params."Cout Kg" := Cout / Params."Batch standard";
                    end;
                end;
                Params.Insert;
            until recParams.Next = 0
    end;

    [Scope('OnPrem')]
    procedure ABC_GetCost(ItemNo: Code[20]; Dt: Date): Decimal
    var
        recParams: Record "ABC - Parametres" temporary;
        CoutH: Decimal;
        "Bom No": Code[20];
        "BOM Version": Code[20];
        TotalCost: Decimal;
        Item: Record Item;
        VersionMgt: Codeunit VersionManagement;
    begin

        TotalCost := 0;
        if Item.Get(ItemNo) then begin
            "BOM Version" := VersionMgt.GetBOMVersion(Item."Production BOM No.", Dt, true);
            ABC_GetParameters(recParams, Item."Production BOM No.", "BOM Version", Dt);
            if recParams.FindSet then
                repeat
                    TotalCost += recParams."Cout Kg";
                until recParams.Next = 0;

        end;
        exit(TotalCost);
    end;

    [Scope('OnPrem')]
    procedure ABC_GetTotalCostVariable(ItemNo: Code[20]; Dt: Date): Decimal
    var
        recParams: Record "ABC - Parametres" temporary;
        CoutH: Decimal;
        "Bom No": Code[20];
        "BOM Version": Code[20];
        TotalCost: Decimal;
        Item: Record Item;
        VersionMgt: Codeunit VersionManagement;
        BOML: Record "Production BOM Line";
    begin

        TotalCost := 0;
        if Item.Get(ItemNo) then
            if Item.IsMfgItem then begin
                "BOM Version" := VersionMgt.GetBOMVersion(Item."Production BOM No.", Dt, true);
                ABC_GetParameters(recParams, Item."Production BOM No.", "BOM Version", Dt);
                if recParams.FindSet then
                    repeat
                        TotalCost += recParams."Cout Kg";
                    until recParams.Next = 0;

                BOML.Reset;
                BOML.SetRange("Production BOM No.", Item."Production BOM No.");
                BOML.SetRange("Version Code", "BOM Version");
                if BOML.FindSet then
                    repeat
                        if (BOML.Type = BOML.Type::Item) then
                            TotalCost += ABC_GetTotalCostVariable(BOML."No.", Dt);
                    until BOML.Next = 0;

            end;
        exit(TotalCost);
    end;

    [Scope('OnPrem')]
    procedure ABC_GetMatriceAtelier(var ABC_Params: Record "ABC - Parametres"; var Matrice: Record "Ateliers Liens"; CalculateDate: Date)
    var
        ABC_Activity: Record "ABC - Activites";
        Item: Record Item;
    begin
        if ABC_Params.FindSet then
            repeat
                ABC_Activity.Get(ABC_Params.Activity);

                if ABC_Activity.Atelier <> '' then begin
                    Matrice.Reset;
                    Matrice.SetRange("Centre de charges", ABC_Activity.Atelier);
                    if not Matrice.FindFirst then begin
                        Matrice.Reset;
                        Matrice.Init;
                        Matrice."Centre de charges" := ABC_Activity.Atelier;
                        Matrice.Début := CalculateDate;
                        Matrice.Article := ABC_Params."Production BOM No";
                        Matrice.Pondération := 1;
                        Matrice.Insert;
                    end;
                end;
            until ABC_Params.Next = 0;
        if ABC_Params.FindFirst then begin
            Item.Reset;
            Item.SetRange("Production BOM No.", ABC_Params."Production BOM No");
            Item.SetFilter("No.", '1*');
            if Item.FindFirst then begin
                Matrice.Reset;
                Matrice.Init;
                Matrice."Centre de charges" := '22B.BUREAU PROD GÉNÉ';
                Matrice.Début := CalculateDate;
                Matrice.Article := ABC_Params."Production BOM No";
                Matrice.Pondération := 1;
                Matrice.Insert;
            end;
        end;
        Matrice.Reset;
    end;

    [Scope('OnPrem')]
    procedure ABC_GetMatriceCostItem(ItemCode: Code[20]; CalculateDate: Date): Decimal
    var
        Items: Record Item;
        VersionMgt: Codeunit VersionManagement;
    begin
        Items.Get(ItemCode);
        exit(ABC_GetMatriceCost(Items."Production BOM No.", VersionMgt.GetBOMVersion(Items."Production BOM No.", CalculateDate, true), CalculateDate));
    end;

    [Scope('OnPrem')]
    procedure ABC_GetMatriceCost(BOMNo: Code[20]; Version: Code[20]; CalculateDate: Date): Decimal
    var
        ABC_Params: Record "ABC - Parametres" temporary;
        Matrice_tmp: Record "Ateliers Liens" temporary;
        WC: Record "Work Center";
        Total: Decimal;
    begin
        Total := 0;
        if (BOMNo <> '') then begin
            ABC_Params.DeleteAll;
            ABC_GetParameters(ABC_Params, BOMNo, Version, CalculateDate);
            ABC_GetMatriceAtelier(ABC_Params, Matrice_tmp, CalculateDate);
            if Matrice_tmp.FindSet then
                repeat
                    WC.Get(Matrice_tmp."Centre de charges");
                    Total += WorkCenter_getMatriceCost(CalculateDate, WC);
                until Matrice_tmp.Next = 0;
        end;
        exit(Total);
    end;

    [Scope('OnPrem')]
    procedure WorkCenter_getMatriceCost(Date: Date; WC: Record "Work Center"): Decimal
    var
        MatriceCost: Record "Ateliers Couts";
    begin
        MatriceCost.Reset;
        MatriceCost.SetRange("Centre de charges", WC."No.");
        MatriceCost.SetFilter(Debut, '<=%1', Date);
        MatriceCost.SetFilter(Fin, '%1|>=%2', 0D, Date);
        if MatriceCost.FindLast then
            exit(MatriceCost.Cout);
    end;

    [EventSubscriber(ObjectType::Codeunit, 99000768, 'OnBeforeCopyBOM', '', false, false)]
    local procedure C99000768_OnCopyBOM(var ProdBOMHeader: Record "Production BOM Header"; BOMHeaderNo: Code[20]; FromVersionCode: Code[20]; ToVersionCode: Code[20]; var SkipBOMDeletion: Boolean; var LineNo: Integer)
    var
        ABCParamsSrc: Record "ABC - Parametres";
        ABCParamsDst: Record "ABC - Parametres";
        ProcessSrc: Record ProcessOF;
        ProcessDst: Record ProcessOF;
    begin
        ABCParamsSrc.Reset;
        ABCParamsSrc.SetRange("Production BOM No", ProdBOMHeader."No.");
        ABCParamsSrc.SetRange("BOM Version", FromVersionCode);
        if ABCParamsSrc.FindSet then
            repeat
                ABCParamsDst.Reset;
                ABCParamsDst.Init;
                ABCParamsDst.TransferFields(ABCParamsSrc, true);
                ABCParamsDst."Production BOM No" := BOMHeaderNo;
                ABCParamsDst."BOM Version" := ToVersionCode;
                ABCParamsDst.Insert;

            until ABCParamsSrc.Next = 0;

        ProcessSrc.Reset;
        ProcessSrc.SetRange("Production BOM No", ProdBOMHeader."No.");
        ProcessSrc.SetRange("BOM Version", FromVersionCode);
        if ProcessSrc.FindSet then
            repeat
                ProcessDst.Reset;
                ProcessDst.Init;
                ProcessDst.TransferFields(ProcessSrc, true);
                ProcessDst."Production BOM No" := BOMHeaderNo;
                ProcessDst."BOM Version" := ToVersionCode;
                ProcessDst.Insert;

            until ProcessSrc.Next = 0;
    end;

    [EventSubscriber(ObjectType::Table, 83, 'OnAfterCopyFromWorkCenter', '', false, false)]
    local procedure T83_WC_Ateliers2(var ItemJournalLine: Record "Item Journal Line"; WorkCenter: Record "Work Center")
    var
        Item: Record Item;
        recABC: Record "ABC Cost OF";
    begin
        if (ItemJournalLine.Type = ItemJournalLine.Type::"Work Center") and (ItemJournalLine."No." = 'ATELIERS') then
            if Item.Get(ItemJournalLine."Item No.") then begin
                recABC.Init;
                recABC.ID := CreateGuid();
                recABC."OF" := ItemJournalLine."Order No.";
                recABC.Line := ItemJournalLine."Order Line No.";
                recABC."Unit Cost" := GetMatriceCost(Item."No.", ItemJournalLine."Posting Date");
                recABC.Qty := ItemJournalLine."Quantity (Base)";
                recABC.Cost := recABC."Unit Cost" * recABC.Qty;
                recABC.Insert;
                WorkCenter.Validate("Direct Unit Cost", 0);
                WorkCenter.Modify;
                ItemJournalLine."Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
            end;
    end;

    [Scope('OnPrem')]
    procedure GetFirstMP(rec: Record "Production BOM Header"; Version: Code[50]): Code[20]
    var
        BomLine: Record "Production BOM Line";
        BomH: Record "Production BOM Header";
        VersionMgt: Codeunit VersionManagement;
        Items: Record Item;
        Total: Decimal;
        _code: Code[20];
    begin
        BomLine.Reset;
        BomLine.SetRange("Production BOM No.", rec."No.");
        if Version = '' then
            BomLine.SetRange("Version Code", VersionMgt.GetBOMVersion(rec."No.", WorkDate, true))
        else
            BomLine.SetRange("Version Code", Version);

        BomLine.SetFilter("Starting Date", '%1|..%2', 0D, WorkDate);
        BomLine.SetFilter("Ending Date", '%1|%2..', 0D, WorkDate);
        if BomLine.FindSet then
            repeat
                if BomLine.Type = BomLine.Type::Item then
                    if Items.Get(BomLine."No.") then
                        if ((CopyStr(Items."Item Category Code", 1, 5) = '7-MP1') and (Items."Item Category Code" <> '7-MP1-4DV')) then begin
                            exit(Items."No.");
                        end
                        else begin
                            if Items.IsMfgItem then begin
                                if BomH.Get(Items."Production BOM No.") then begin
                                    _code := GetFirstMP(BomH, '');
                                    if _code <> '' then exit(_code);
                                end;
                            end;
                        end;
            until BomLine.Next = 0;
        exit('');
    end;

    [Scope('OnPrem')]
    procedure GetFirst5(rec: Record "Production BOM Header"; Version: Code[50]): Code[20]
    var
        BomLine: Record "Production BOM Line";
        BomH: Record "Production BOM Header";
        VersionMgt: Codeunit VersionManagement;
        Items: Record Item;
        Total: Decimal;
        _code: Code[20];
    begin
        BomLine.Reset;
        BomLine.SetRange("Production BOM No.", rec."No.");
        if Version = '' then
            BomLine.SetRange("Version Code", VersionMgt.GetBOMVersion(rec."No.", WorkDate, true))
        else
            BomLine.SetRange("Version Code", Version);

        BomLine.SetFilter("Starting Date", '%1|..%2', 0D, WorkDate);
        BomLine.SetFilter("Ending Date", '%1|%2..', 0D, WorkDate);
        if BomLine.FindSet then
            repeat
                if BomLine.Type = BomLine.Type::Item then
                    if Items.Get(BomLine."No.") then
                        if (CopyStr(Items."Item Category Code", 1, 1) = '5') then begin
                            exit(Items."No.");
                        end
                        else begin
                            if Items.IsMfgItem then begin
                                if BomH.Get(Items."Production BOM No.") then begin
                                    _code := GetFirst5(BomH, '');
                                    if _code <> '' then exit(_code);
                                end;
                            end;
                        end;
            until BomLine.Next = 0;
        exit('');
    end;

    [Scope('OnPrem')]
    procedure GetTotalMPPerUnit(rec: Record "Production BOM Header"; Version: Code[50]): Decimal
    var
        BomLine: Record "Production BOM Line";
        BomH: Record "Production BOM Header";
        VersionMgt: Codeunit VersionManagement;
        Items: Record Item;
        Total: Decimal;
    begin
        BomLine.Reset;
        BomLine.SetRange("Production BOM No.", rec."No.");
        if Version = '' then
            BomLine.SetRange("Version Code", VersionMgt.GetBOMVersion(rec."No.", WorkDate, true))
        else
            BomLine.SetRange("Version Code", Version);

        BomLine.SetFilter("Starting Date", '%1|..%2', 0D, WorkDate);
        BomLine.SetFilter("Ending Date", '%1|%2..', 0D, WorkDate);
        if BomLine.FindSet then
            repeat
                if BomLine.Type = BomLine.Type::Item then
                    if Items.Get(BomLine."No.") then
                        if (((CopyStr(Items."Item Category Code", 1, 5) = '7-MP1') or (CopyStr(Items."Item Category Code", 1, 5) = '5-CRU')) and (Items."Item Category Code" <> '7-MP1-4DV')) then begin
                            Total := Total + BomLine.Quantity;//* (1 + BomLine."Scrap %"/100);
                        end
                        else begin
                            if Items.IsMfgItem then begin
                                if BomH.Get(Items."Production BOM No.") then
                                    //Total := Total + (BomLine.Quantity * (1 + BomLine."Scrap %"/100)) * GetTotalMPPerUnit(BomH,'');
                                    Total := Total + BomLine.Quantity * GetTotalMPPerUnit(BomH, '');
                            end;
                        end;
            /*
            IF ((COPYSTR(Items."Item Category Code",1,5) = '7-MP1') OR (COPYSTR(Items."Item Category Code",1,2) = '5-')) AND ((COPYSTR(Items."Item Category Code",1,5) <> '5-MLX')) AND ((COPYSTR(Items."Item Category Code",1,5) <> '5-IQF')) THEN
              Total := Total + BomLine.Quantity ;//* (1 + BomLine."Scrap %"/100);
            IF (COPYSTR(Items."Item Category Code",1,5) = '5-MLX') OR (COPYSTR(Items."Item Category Code",1,5) = '5-IQF') THEN
            BEGIN
              IF BomH.GET(Items."Production BOM No.") THEN
                Total := Total + (BomLine.Quantity * (1 + BomLine."Scrap %"/100)) * GetTotalMPPerUnit(BomH,'');
            END;
            */
            until BomLine.Next = 0;
        exit(Total);

    end;

    [EventSubscriber(ObjectType::Table, 337, 'OnAfterDeleteEvent', '', false, false)]
    local procedure T337_delete(var Rec: Record "Reservation Entry"; RunTrigger: Boolean)
    var
        PalletJnl: Record "Pallet Journal";
    begin
        if (RunTrigger) then begin
            PalletJnl.Reset;
            PalletJnl.SetRange("Reservation Entry", Rec."Entry No.");
            PalletJnl.DeleteAll;
        end;
    end;

    [Scope('OnPrem')]
    procedure xl_ABC_Item(ItemNo: Code[30]; Activity: Code[20]; Ressource: Code[20]; Rendement: Decimal; Unit: Integer; NbreOp: Decimal; Batch: Decimal; LineNo: Integer)
    var
        Item: Record Item;
        BOMV: Record "Production BOM Version";
    begin
        Item.Get(ItemNo);
        xl_ABC_BOM(Item."Production BOM No.", '', Activity, Ressource, Rendement, Unit, NbreOp, Batch, LineNo, ItemNo);
        BOMV.Reset;
        BOMV.SetRange("Production BOM No.", Item."Production BOM No.");
        if BOMV.FindSet then
            repeat
                xl_ABC_BOM(Item."Production BOM No.", BOMV."Version Code", Activity, Ressource, Rendement, Unit, NbreOp, Batch, LineNo, ItemNo);
            until BOMV.Next = 0;
    end;

    local procedure xl_ABC_BOM(BomNo: Code[30]; Version: Code[20]; Activity: Code[20]; Ressource: Code[20]; Rendement: Decimal; Unit: Integer; NbreOp: Decimal; Batch: Decimal; LineNo: Integer; ItemNo: Code[30])
    var
        ABC: Record "ABC - Parametres";
    begin
        ABC.Reset;
        ABC.SetRange("Production BOM No", BomNo);
        ABC.SetRange("BOM Version", Version);
        ABC.SetRange(LineNo, LineNo);
        if ABC.FindFirst then begin
            if (ABC.Activity <> Activity) then Error('Erreur activite %1  %2  %3  %4', ItemNo, ABC.Activity, Activity, BomNo);
            if (ABC.Ressource <> Ressource) then Error('Erreur ressource %1  %2  %3', ItemNo, ABC.Ressource, Ressource);
            if (ABC."Rendement effectif" <> Rendement) then Error('Erreur rendement %1  %2  %3', ItemNo, ABC."Rendement effectif", Rendement);
            if (ABC."Nombre d'opérateurs" <> NbreOp) then Error('Erreur op %1  %2  %3', ItemNo, ABC."Nombre d'opérateurs", NbreOp);
            if (ABC."Batch standard" <> Batch) then Error('Erreur batch %1  %2  %3', ItemNo, ABC."Batch standard", Batch);
        end
        else begin
            ABC.Init;
            ABC."Production BOM No" := BomNo;
            ABC."BOM Version" := Version;
            ABC.LineNo := LineNo;
            ABC.Activity := Activity;
            ABC.Ressource := Ressource;
            ABC."Rendement effectif" := Rendement;
            ABC.Unité := Unit;
            ABC."Nombre d'opérateurs" := NbreOp;
            ABC."Batch standard" := Batch;
            ABC.Insert;

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 7301, 'OnInitWhseEntryCopyFromWhseJnlLine', '', false, false)]
    local procedure CU7301_OnInitWhseEntryCopyFromWhseJnlLine(var WarehouseEntry: Record "Warehouse Entry"; WarehouseJournalLine: Record "Warehouse Journal Line"; OnMovement: Boolean; Sign: Integer)
    var
        RecPalletJnl: Record "Pallet Journal";
        OldPalletEntry: Record "Pallet Ledger Entry";
        RecPalletEntry: Record "Pallet Ledger Entry";
        RecPallet: Record Pallet;
    begin
        //CB1.00 ABSYS VE 20070319 ->
        if WarehouseEntry."Entry Type" = WarehouseEntry."Entry Type"::Movement then begin
            RecPalletJnl.Reset;
            RecPalletJnl.SetRange("Journal Template Name", WarehouseEntry."Journal Template Name");      // VE 20070515
            RecPalletJnl.SetRange("Journal Batch Name", WarehouseEntry."Journal Batch Name");            // VE 20070515
                                                                                                         //    RecPalletJnl.SETRANGE(RecPalletJnl."Journal Line No.",WhseJnlLine."Line No.");         // VE 20070531
            if RecPalletJnl.Find('-') then begin
                OldPalletEntry.Reset;
                if not OldPalletEntry.Find('+') then OldPalletEntry."Entry No." := 0;
                repeat
                    if RecPalletJnl."Treated Quantity" > 0 then begin
                        if RecPallet.Get(RecPalletJnl."SSCC No.") then begin
                            RecPalletEntry.Init;
                            RecPalletEntry."Entry No." := OldPalletEntry."Entry No." + 1;
                            OldPalletEntry."Entry No." := OldPalletEntry."Entry No." + 1;
                            RecPalletEntry."SSCC No." := RecPalletJnl."SSCC No.";
                            RecPalletEntry.User := RecPalletJnl.User;
                            RecPalletEntry."Location Code" := WarehouseEntry."Location Code";
                            RecPalletEntry."Bin Code" := WarehouseEntry."Bin Code";
                            RecPalletEntry."Document No." := WarehouseEntry."Reference No.";
                            RecPalletEntry."Posting Date" := WarehouseEntry."Registering Date";
                            RecPalletEntry.Quantity := WarehouseEntry.Quantity;
                            RecPalletEntry."Item No." := WarehouseEntry."Item No.";
                            RecPalletEntry."Lot No." := WarehouseEntry."Lot No.";
                            if not RecPalletEntry.Insert then RecPalletEntry.Modify;
                            //CB1.00 ABSYS VE 20070531 ->
                            RecPallet.Validate("Location code", WarehouseEntry."Location Code");
                            RecPallet.Validate("Bin code", WarehouseEntry."Bin Code");
                            RecPallet.Validate("Item No.", WarehouseEntry."Item No.");
                            RecPallet.Validate("Lot No.", WarehouseEntry."Lot No.");
                            RecPallet.Modify;
                            if WarehouseEntry.Quantity > 0 then RecPalletJnl.Delete;
                            // <- CB1.00 ABSYS VE 20070531
                        end;
                    end;
                until RecPalletJnl.Next = 0;
            end;
        end;
        // <- CB1.00 ABSYS VE 20070319
    end;

    [EventSubscriber(ObjectType::Codeunit, 5407, 'OnBeforePostFlushItemJnlLine', '', false, false)]
    local procedure CU5407_OnBeforePostFlushItemJnlLine(var ItemJournalLine: Record "Item Journal Line")
    var
        Prod: Record "Production Order";
    begin
        Prod.Reset;
        Prod.SetRange("No.", ItemJournalLine."Order No.");
        if Prod.FindFirst then
            ItemJournalLine."Location Code" := Prod."Location Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, 22, 'OnAfterInitItemLedgEntry', '', false, false)]
    local procedure CU22_OnAfterInitItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer)
    var
        CUScanManagment_l: Codeunit "Scan Management";
    begin
        CUScanManagment_l.PostPallet(ItemJournalLine, NewItemLedgEntry);
    end;

    [EventSubscriber(ObjectType::Codeunit, 22, 'OnBeforeCheckItemTrackingInformation', '', false, false)]
    local procedure CU22_OnBeforeCheckItemTrackingInfo(var ItemJnlLine2: Record "Item Journal Line"; var TrackingSpecification: Record "Tracking Specification"; var ItemTrackingSetup: Record "Item Tracking Setup"; var SignFactor: Decimal; var ItemTrackingCode: Record "Item Tracking Code"; var IsHandled: Boolean; var GlobalItemTrackingCode: Record "Item Tracking Code")
    var
        LotNoInfo: Record "Lot No. Information";
    begin
        if ItemTrackingCode."Lot Specific Tracking" then begin
            AutomaticalyInformationLot(ItemJnlLine2."Item No.", ItemJnlLine2."Variant Code", TrackingSpecification."Lot No.");
            if ItemJnlLine2."Entry Type" = ItemJnlLine2."Entry Type"::Transfer then begin
                AutomaticalyInformationLot(ItemJnlLine2."Item No.", ItemJnlLine2."Variant Code", TrackingSpecification."New Lot No.");
                LotNoInfo.Get(ItemJnlLine2."Item No.", ItemJnlLine2."Variant Code", TrackingSpecification."Lot No.");
                if LotNoInfo.Blocked then begin
                    LotNoInfo.Get(ItemJnlLine2."Item No.", ItemJnlLine2."Variant Code", TrackingSpecification."New Lot No.");
                    LotNoInfo."Previously blocked" := true;
                    LotNoInfo.Modify;
                end;
                if LotNoInfo.Get(ItemJnlLine2."Item No.", ItemJnlLine2."Variant Code", TrackingSpecification."New Lot No.") then
                    if LotNoInfo.Blocked then begin
                        LotNoInfo."Previously blocked" := true;
                        LotNoInfo.Blocked := false;
                        LotNoInfo.Modify;
                    end;
            end;
            if (ItemJnlLine2."Journal Template Name" = 'TRANSFERT') or
               (ItemJnlLine2."Entry Type" = ItemJnlLine2."Entry Type"::Transfer) or
               (ItemJnlLine2."Entry Type" = ItemJnlLine2."Entry Type"::Output) or
               (ItemJnlLine2."Entry Type" = ItemJnlLine2."Entry Type"::"Positive Adjmt.")
               or (ItemJnlLine2."Entry Type" = ItemJnlLine2."Entry Type"::"Negative Adjmt.")
               or (ItemJnlLine2."Document Type" = ItemJnlLine2."Document Type"::"Sales Return Receipt")
               or (ItemJnlLine2."Document Type" = ItemJnlLine2."Document Type"::"Sales Credit Memo") then begin
                LotNoInfo.Get(ItemJnlLine2."Item No.", ItemJnlLine2."Variant Code", TrackingSpecification."Lot No.");
                //rebloqué, Pauline 240623
                //AND (ItemJnlLine2."Location Code" = 'ECCONGEL')
                if LotNoInfo.Blocked then begin
                    LotNoInfo."Previously blocked" := true;
                    LotNoInfo.Blocked := false;
                    LotNoInfo.Modify;
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 22, 'OnAfterCheckItemTrackingInformation', '', false, false)]
    local procedure CU22_OnAfterCheckItemTrackingInfo(var ItemJnlLine2: Record "Item Journal Line"; var TrackingSpecification: Record "Tracking Specification"; ItemTrackingSetup: Record "Item Tracking Setup"; Item: Record Item)
    var
        LotNoInfo: Record "Lot No. Information";
    begin
        if LotNoInfo.Get(ItemJnlLine2."Item No.", ItemJnlLine2."Variant Code", TrackingSpecification."Lot No.") then
            if LotNoInfo."Previously blocked" then begin
                LotNoInfo."Previously blocked" := false;
                LotNoInfo.Blocked := true;
                LotNoInfo.Modify;
            end;
        if TrackingSpecification."New Lot No." <> '' then begin
            LotNoInfo.Get(ItemJnlLine2."Item No.", ItemJnlLine2."Variant Code", TrackingSpecification."New Lot No.");
            if LotNoInfo."Previously blocked" then begin
                LotNoInfo."Previously blocked" := false;
                LotNoInfo.Blocked := true;
                LotNoInfo.Modify;
            end;
        end;
    end;


    procedure AutomaticalyInformationLot(ItemNumber_p: Code[20]; VariantCode_p: Code[20]; LotCode_p: Code[50])
    var
        RecTrackingCode_l: Record "Item Tracking Code";
        RecInformationLot_l: Record "Lot No. Information";
        RecItem_l: Record Item;
    begin

        if RecItem_l.Get(ItemNumber_p) then begin
            if RecTrackingCode_l.Get(RecItem_l."Item Tracking Code") then begin
                if not RecTrackingCode_l."Information Lot Automaticaly" then
                    exit;

                if not RecInformationLot_l.Get(ItemNumber_p, VariantCode_p, LotCode_p) then begin
                    RecInformationLot_l.Init;
                    RecInformationLot_l.Validate("Item No.", ItemNumber_p);
                    RecInformationLot_l.Validate("Variant Code", VariantCode_p);
                    RecInformationLot_l.Validate("Lot No.", LotCode_p);
                    if RecItem_l."Comment blocage lots produits" <> '' then begin
                        RecInformationLot_l.Blocked := true;
                        RecInformationLot_l."Commentaire blocage" := RecItem_l."Comment blocage lots produits";
                        RecInformationLot_l."Raison du blocage" := RecItem_l."Raison blocage";
                        RecInformationLot_l.Decision := 'EN ATTENTE LABO';
                    end;

                    RecInformationLot_l.Insert;
                end;
            end;
        end;
    end;

    [Scope('OnPrem')]
    procedure GetMatriceCost(ItemNo: Code[20]; Date: Date): Decimal
    var
        Matrice: Record "Ateliers Liens";
        Centres: Record "Work Center";
        TotalCost: Decimal;
    begin
        exit(ABC_GetMatriceCostItem(ItemNo, Date));
    end;

    [Scope('OnPrem')]
    procedure GetMatriceCostWithout22A(ItemNo: Code[20]; Date: Date): Decimal
    var
        Matrice: Record "Ateliers Liens";
        Centres: Record "Work Center";
        TotalCost: Decimal;
    begin
        exit(ABC_GetMatriceCostItem(ItemNo, Date));
    end;

    [Scope('OnPrem')]
    procedure GetMatricePonderation(ItemNo: Code[20]; Centre: Code[20]; Date: Date): Decimal
    var
        Matrice: Record "Ateliers Liens";
        Centres: Record "Work Center";
        TotalCost: Decimal;
    begin
        Matrice.Reset;
        Matrice.SetRange(Article, ItemNo);
        Matrice.SetRange("Centre de charges", Centre);
        Matrice.SetFilter(Début, '<=%1', Date);
        Matrice.SetFilter(Fin, '%1|>=%2', 0D, Date);
        if Matrice.FindLast then begin
            exit(Matrice.Pondération);
        end;

        exit(0);
    end;

    [Scope('OnPrem')]
    procedure GetMatriceCostPF(ItemNo: Code[20]; Date: Date): Decimal
    var
        Matrice: Record "Ateliers Liens";
        Centres: Record "Work Center";
        TotalCost: Decimal;
    begin
        exit(ABC_GetMatriceCostItem(ItemNo, Date));
    end;

    [Scope('OnPrem')]
    procedure getMatriceCostCentre(No: Code[20]; Date: Date): Decimal
    var
        MatriceCost: Record "Ateliers Couts";
    begin
        MatriceCost.Reset;
        MatriceCost.SetRange("Centre de charges", No);
        MatriceCost.SetFilter(Debut, '<=%1', Date);
        MatriceCost.SetFilter(Fin, '%1|>=%2', 0D, Date);
        if MatriceCost.FindLast then
            exit(MatriceCost.Cout);
    end;

    [EventSubscriber(ObjectType::Page, 6510, 'OnBeforeSetSourceSpec', '', false, false)]
    local procedure PG6510_OnBeforeSetSourceSpec(var TrackingSpecification: Record "Tracking Specification"; var ReservationEntry: Record "Reservation Entry")
    begin
        TrackingSpecification."Bin Code" := '';
    end;

    [EventSubscriber(ObjectType::Codeunit, 6501, 'OnAfterTransferExpDateFromSummary', '', false, false)]
    local procedure CU6501_OnAfterTransferExpDateFromSummary(var TrackingSpecification: Record "Tracking Specification"; var TempEntrySummary: Record "Entry Summary" temporary)
    begin
        TrackingSpecification."Warranty Date" := TempEntrySummary."Warranty Date";
        TrackingSpecification."New Expiration Date" := TrackingSpecification."Expiration Date"

    end;

    [Scope('OnPrem')]
    procedure AddSalesToOF(recNo: Code[20]; recDtProd: Date; recDocNo: Code[20]; recDocLine: Integer; recQty: Decimal; xrecNo: Code[20]; xrecDtProd: Date; xrecDocNo: Code[20]; xrecDocLine: Integer; TypeOrigine: Integer)
    var
        "OF": Record "Production Order";
        SalesL: Record "Sales Line";
        TotalQty: Decimal;
        Cmds: Text;
        CRLF: Text;
        Prod: Record "Production Order";
        Reserv: Record "Reservation Entry";
        NextNo: Integer;
        Items: Record Item;
        Utils: Codeunit Utils;
        VersionMgt: Codeunit VersionManagement;
        BomL: Record "Production BOM Line";
        TotalQtyProd: Decimal;
        NewDt: Date;
        OldDt: Date;
        No: Code[20];
        WhereUsed: Codeunit "Where-Used Management";
        WhereUsedLine: Record "Where-Used Line";
        n: Integer;
    begin
        CRLF[1] := 13;
        if recDtProd < Today then
            exit;
        n := 0;
        if Items.Get(recNo) then begin
            WhereUsed.WhereUsedFromItem(Items, Today, false);
            while (WhereUsed.NextRecord(1, WhereUsedLine) <> 0) do begin
                if (CopyStr(WhereUsedLine."Item No.", 1, 1) = '1') then
                    n := n + 1;
            end;
            if (n = 1) and (CopyStr(recNo, 1, 5) <> '5-FPS') then
                exit;
        end;
        //Retirer de l'ancien OF
        "OF".Reset;
        "OF".SetRange("Source Type", "OF"."Source Type"::Item);
        "OF".SetRange("Source No.", xrecNo);
        if ((xrecDtProd <> 0D) and (recDtProd <> xrecDtProd)) then begin
            TotalQty := 0;
            Cmds := '';
            "OF".SetRange("Starting Date", xrecDtProd);
            if "OF".FindFirst then begin
                SalesL.Reset;
                SalesL.SetRange("Date de production", "OF"."Starting Date");
                SalesL.SetRange("No.", "OF"."Source No.");
                if SalesL.FindSet then
                    repeat
                        if not ((xrecDocNo = SalesL."Document No.") and (xrecDocLine = SalesL."Line No.")) then begin
                            TotalQty += SalesL."Quantity (Base)";
                            Cmds += SalesL."Document No." + CRLF;
                        end;
                    until SalesL.Next = 0;
                "OF".Validate(Quantity, TotalQty);
                "OF".Modify(true);
                if TotalQty = 0 then begin
                    Reserv.Reset;
                    Reserv.SetRange("Source ID", "OF"."No.");
                    Reserv.SetRange("Source Prod. Order Line", 10000);
                    Reserv.DeleteAll;
                    "OF".Delete(true);

                end
                else begin
                    UpdateOFNote("OF", Cmds);
                    Reserv.Reset;
                    Reserv.SetRange("Source ID", "OF"."No.");
                    Reserv.SetRange("Source Prod. Order Line", 10000);
                    if Reserv.FindFirst then
                        Reserv.Delete;
                    Prod.Reset;
                    Prod.SetFilter("No.", "OF"."No.");
                    Prod.FindFirst;
                    REPORT.Run(REPORT::"Refresh Production Order", false, true, Prod);
                    Reserv.Reset;
                    if Reserv.FindLast then NextNo := Reserv."Entry No." + 1;
                    Reserv.Init;
                    Reserv."Entry No." := NextNo;
                    Reserv."Item No." := "OF"."Source No.";
                    Reserv."Location Code" := 'EC TOURNAI';
                    Reserv.Validate("Quantity (Base)", TotalQty);
                    Reserv."Source Type" := 5406;
                    Reserv."Source Subtype" := 3;
                    Reserv."Source ID" := "OF"."No.";
                    Reserv."Source Prod. Order Line" := 10000;
                    Reserv."Item Tracking" := Reserv."Item Tracking"::"Lot No.";
                    Reserv."Reservation Status" := Reserv."Reservation Status"::Surplus;
                    Reserv."Creation Date" := Today;
                    Reserv."Expected Receipt Date" := "OF"."Starting Date";
                    Items.Get("OF"."Source No.");
                    Reserv."Warranty Date" := CalcDate(Items.FormuleDLC, "OF"."Starting Date");
                    Reserv."Lot No." := Format((Date2DMY("OF"."Starting Date", 3) - 2000)) + '/' + Utils.PadLeft(Format(("OF"."Starting Date" - DMY2Date(1, 1, Date2DMY("OF"."Starting Date", 3))) + 1), '0', 3);
                    Reserv.Insert(true);

                end;
            end;
        end;

        if (TypeOrigine = 37) then begin
            //Traca ligne commande
            Reserv.Reset;
            Reserv.SetRange("Source ID", recDocNo);
            Reserv.SetRange(Reserv."Source Ref. No.", recDocLine);
            if Reserv.FindFirst then
                Reserv.Delete;
        end;

        //Ajout
        "OF".Reset;
        "OF".SetRange("Source Type", "OF"."Source Type"::Item);
        "OF".SetRange("Source No.", recNo);
        "OF".SetRange(Status, "OF".Status::Released);
        //"OF".SETFILTER("Quantité réalisée",'0');
        //"OF".SETFILTER("Quantité utilisée",'0');
        if (recDtProd <> 0D) then begin
            "OF".SetRange("Starting Date", recDtProd);
            if not "OF".FindFirst then begin
                "OF".Init;
                "OF".Status := "OF".Status::Released;
                "OF"."Source Type" := "OF"."Source Type"::Item;
                "OF".Validate("Source No.", recNo);
                "OF".Validate("Due Date", recDtProd);
                "OF"."Location Code" := 'EC TOURNAI';
                "OF".Insert(true);
            end;
            TotalQty := recQty;
            Cmds := recDocNo + CRLF;
            SalesL.Reset;
            SalesL.SetRange("Date de production", "OF"."Starting Date");
            SalesL.SetRange("No.", "OF"."Source No.");
            if SalesL.FindSet then
                repeat
                    if not ((recDocNo = SalesL."Document No.") and (recDocLine = SalesL."Line No.")) then begin
                        TotalQty += SalesL."Quantity (Base)";
                        Cmds += SalesL."Document No." + CRLF;
                    end;
                until SalesL.Next = 0;  // Il faudrait ajouter les 5 venant de VP
            "OF".CalcFields("Quantité réalisée");
            "OF".CalcFields("Quantité utilisée");
            if ("OF"."Quantité réalisée" = 0) and ("OF"."Quantité utilisée" = 0) then begin
                "OF".Validate(Quantity, TotalQty);
                "OF".Modify(true);

                Reserv.Reset;
                Reserv.SetRange("Source ID", "OF"."No.");
                Reserv.SetRange("Source Prod. Order Line", 10000);
                Reserv.DeleteAll;
                Prod.Reset;
                Prod.SetFilter("No.", "OF"."No.");
                Prod.FindFirst;
                REPORT.Run(REPORT::"Refresh Production Order", false, true, Prod);
            end;
            TotalQtyProd := TotalQty;
            UpdateOFNote("OF", Cmds);

            //Traca OF

            if (TypeOrigine = 37) then begin
                //Traca ligne commande
            end;
        end;

        if StrPos("OF"."Source No.", '1-FPS') > 0 then begin
            Items.Get(recNo);
            BomL.Reset;
            BomL.SetRange("Production BOM No.", Items."Production BOM No.");
            BomL.SetRange("Version Code", VersionMgt.GetBOMVersion(Items."Production BOM No.", recDtProd, true));
            BomL.SetFilter("No.", '5-F*');
            TotalQtyProd := recQty;
            if BomL.FindFirst then begin
                NewDt := recDtProd;
                if NewDt <> 0D then
                    NewDt := CalcDate('<-1D>', NewDt);
                OldDt := xrecDtProd;
                if OldDt <> 0D then
                    OldDt := CalcDate('<-1D>', OldDt);
                No := BomL."No.";

                // tous les 1-fps du jour, somme des 5 identiques
                SalesL.Reset;
                SalesL.SetRange("Date de production", "OF"."Starting Date");
                SalesL.SetFilter("No.", '1-FPS-*');
                if SalesL.FindSet then
                    repeat
                        if not ((recDocNo = SalesL."Document No.") and (recDocLine = SalesL."Line No.")) then begin
                            Items.Get(SalesL."No.");
                            BomL.Reset;
                            BomL.SetRange("Production BOM No.", Items."Production BOM No.");
                            BomL.SetRange("Version Code", VersionMgt.GetBOMVersion(Items."Production BOM No.", recDtProd, true));
                            BomL.SetFilter("No.", '5-F*');
                            if BomL.FindFirst then
                                if BomL."No." = No then
                                    TotalQtyProd += SalesL."Quantity (Base)";
                        end;
                    until SalesL.Next = 0;

                AddSalesToOF(No, NewDt, "OF"."No.", 10000, TotalQtyProd, No, OldDt, "OF"."No.", 10000, 5406);

            end;
        end;
    end;

    local procedure UpdateOFNote(recOF: Record "Production Order"; Note: Text)
    var
        CRLF: Text;
        Link: Record "Record Link";
        TypeH: Codeunit "Type Helper";
        recRef: RecordRef;
        mNote: Text;
        Trouve: Boolean;
        NextID: Integer;
    begin
        CRLF[1] := 13;
        Trouve := false;
        recRef.GetTable(recOF);
        Link.SetRange("Record ID", recRef.RecordId());
        Link.SetRange(Type, Link.Type::Note);
        if Link.FindSet then
            repeat
                Link.CalcFields(Note);
                //mNote := TypeH.ReadRecordLinkNote(Link);
                if StrPos(mNote, 'Commandes') > 0 then begin
                    Trouve := true;
                    //TypeH.WriteRecordLinkNote(Link, 'Commandes ' + CRLF + Note);
                    Link.Modify;
                end;
            until Link.Next = 0;
        if not Trouve then begin
            Link.Reset;
            if Link.FindLast then NextID := Link."Link ID" + 1;
            Link.Init;
            Link."Link ID" := NextID;
            Link."Record ID" := recRef.RecordId();
            Link.Type := Link.Type::Note;
            Link.Created := CreateDateTime(Today, Time);
            Link."User ID" := UserId;
            Link.Company := CompanyName;
            Link.Notify := false;
            //TypeH.WriteRecordLinkNote(Link, 'Commandes ' + CRLF + Note);
            Link.Insert;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure T37_OnUpdateQty(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        if (Rec."Location Code" <> 'ECCONGEL') and (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') and (Rec."Date de production" <> 0D) and (Rec."Date de production" > Today) then
            AddSalesToOF(Rec."No.", Rec."Date de production", Rec."Document No.", Rec."Line No.", Rec."Quantity (Base)", xRec."No.", xRec."Date de production", xRec."Document No.", xRec."Line No.", 37);
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterDeleteEvent', '', false, false)]
    local procedure T37_OnDelete(var Rec: Record "Sales Line"; RunTrigger: Boolean)
    begin
        if RunTrigger then
            if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') and (Rec."Date de production" <> 0D) then
                AddSalesToOF(Rec."No.", Rec."Date de production", Rec."Document No.", Rec."Line No.", Rec."Quantity (Base)", Rec."No.", Rec."Date de production", Rec."Document No.", Rec."Line No.", 37);
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'Date de production', false, false)]
    local procedure T37_OnUpdateDtProd(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        Utils: Codeunit Utils;
    begin
        //IF (NOT Utils.IsInGroup('DATEPROD')) AND (Rec."Location Code" IN ['EC TOURNAI','ECCONGEL']) THEN
        //  ERROR('Vous n''êtes pas autorisé à modifier la date de production');
        if (Rec."Location Code" <> 'ECCONGEL') and (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') and ((Rec."Date de production" <> 0D) or (xRec."Date de production" <> 0D)) then
            AddSalesToOF(Rec."No.", Rec."Date de production", Rec."Document No.", Rec."Line No.", Rec."Quantity (Base)", xRec."No.", xRec."Date de production", xRec."Document No.", xRec."Line No.", 37);
    end;

    [Scope('OnPrem')]
    procedure Reopenof(No: Code[20])
    var
        T5405: Record "Production Order";
        T5406: Record "Prod. Order Line";
        T5407: Record "Prod. Order Component";
        T5409: Record "Prod. Order Routing Line";
        CU50012: Codeunit "Prod. Order Status Manageme EC";
    begin
        // A utiliser avec précaution => Plus de recalcul des coûts !!

        T5405.Reset;
        T5405.SetRange("No.", No);
        if T5405.FindSet then
            repeat
                CU50012.ChangeStatusOnProdOrder(T5405, T5405.Status::Released, T5405."Starting Date", false);

            until T5405.Next = 0;
    end;

    [EventSubscriber(ObjectType::Table, 5406, 'OnAfterValidateEvent', 'Production BOM Version Code', false, false)]
    local procedure T5406_OnAfterBOMVersion(var Rec: Record "Prod. Order Line"; var xRec: Record "Prod. Order Line"; CurrFieldNo: Integer)
    var
        ProdHeader: Record "Production Order";
    begin
        ProdHeader.Get(Rec.Status, Rec."Prod. Order No.");
        if (ProdHeader."Production BOM Version" <> '') then begin
            if (Rec."Production BOM Version Code" <> ProdHeader."Production BOM Version") then
                Rec.Validate("Production BOM Version Code", ProdHeader."Production BOM Version");
        end;
    end;

    [EventSubscriber(ObjectType::Table, 5405, 'OnAfterModifyEvent', '', false, false)]
    local procedure T5405_OnAfterModify(var Rec: Record "Production Order"; var xRec: Record "Production Order"; RunTrigger: Boolean)
    var
        ProdOrder: Record "Production Order";
    begin
        if Rec."Production BOM Version" <> xRec."Production BOM Version" then begin
            ProdOrder.SetRange(Status, Rec.Status);
            ProdOrder.SetRange("No.", Rec."No.");
            REPORT.RunModal(REPORT::"Refresh Production Order", false, true, ProdOrder);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 5510, 'OnInsertConsumptionJnlLineOnBeforeCheck', '', false, false)]
    local procedure CU5510_OnInsertConsumptionJnlLineOnBeforeCheck(ProdOrderComponent: Record "Prod. Order Component"; ProdOrderLine: Record "Prod. Order Line"; Item: Record Item; var IsHandled: Boolean)
    begin
        //ItemJnlLine.INIT;
        //  ItemJnlLine."Journal Template Name" := ToTemplateName;
        //  ItemJnlLine."Journal Batch Name" := ToBatchName;
        //  ItemJnlLine."Line No." := NextLineNo;
    end;

    [EventSubscriber(ObjectType::Table, 83, 'OnBeforeValidateEvent', 'Entry Type', false, false)]
    local procedure T83_EntryType(var Rec: Record "Item Journal Line"; var xRec: Record "Item Journal Line"; CurrFieldNo: Integer)
    var
        T337: Record "Reservation Entry";
    begin
        if (Rec."Entry Type" = Rec."Entry Type"::Consumption) and (Rec."Entry Type" <> xRec."Entry Type") then begin
            T337.Reset;
            T337.SetRange("Source Type", 83);
            T337.SetRange("Source Subtype", 5);
            T337.SetRange("Source Ref. No.", Rec."Line No.");
            if T337.FindFirst then
                T337.DeleteAll;

        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, 5407, 'OnBeforeChangeStatusOnProdOrder', '', false, false)]
    local procedure CU5407_OnBeforeChangeStatusOnProdOrder(var ProductionOrder: Record "Production Order"; NewStatus: Option Quote,Planned,"Firm Planned",Released,Finished)
    var
        reserv: Record "Reservation Entry";
    begin
        if NewStatus = NewStatus::Finished then begin
            if ProductionOrder.IDVP <> '' then
                ProductionOrder.IDVP := ProductionOrder.IDVP + '-ok';
            // IF ProductionOrder."Temps total" = 0 THEN
            //   IF NOT CONFIRM('Continuer sans indiquer les heures de travail ?') THEN
            //     ERROR('Modification annulée');
            reserv.Reset;
            reserv.SetRange("Source Type", 5407);
            reserv.SetRange("Source Subtype", 3);
            reserv.SetRange("Source ID", ProductionOrder."No.");
            if reserv.FindFirst then
                Error('Impossible de cloturer, il reste encore des reservations');
        end;
    end;

    [EventSubscriber(ObjectType::Page, 6510, 'OnBeforeClosePage', '', false, false)]
    local procedure P6510_OnBeforeClosePage(var TrackingSpecification: Record "Tracking Specification"; var SkipWriteToDatabase: Boolean)
    begin
        if TrackingSpecification.FindSet then
            repeat
                if (TrackingSpecification."Quantity (Base)" < 0) and (TrackingSpecification."Source ID" = 'CONSOMMATI') and (TrackingSpecification."Appl.-from Item Entry" = 0) then
                    Error('Veuillez indiquer l''écriture à lettre');
            until TrackingSpecification.Next = 0;
    end;

    [EventSubscriber(ObjectType::Table, 5405, 'OnAfterValidateEvent', 'Source No.', false, false)]
    local procedure T5405_ModifItemToEmplacement(var Rec: Record "Production Order"; var xRec: Record "Production Order"; CurrFieldNo: Integer)
    var
        Items: Record Item;
    begin
        if Items.Get(Rec."Source No.") then begin
            if Rec."Location Code" = '' then
                Rec.Validate("Location Code", Items."Default Location Code");
            if StrPos(Items."No.", '1-IQF') > 0 then
                Rec.Validate("Location Code", 'EC TOURNAI');
            if CopyStr(Items."No.", 1, 5) = '5-MLX' then
                Rec.Emplacement := 'MALAXAGEM';
            if (Items.Process = 'Malaxeur') or (Items.Process = 'Malaxeur only') then
                Rec.Emplacement := 'MALAXAGEM';
            if (Items.Process = 'Mélangeur') then
                Rec.Emplacement := 'MALAXAGET';
            if (Items.Process = 'Tumbler') then
                Rec.Emplacement := 'MALAXAGET';
            //    Rec.Emplacement := 'MALAXAGEM|MALAXAGET';
            if CopyStr(Items."No.", 1, 5) = '5-SAU' then
                Rec.Emplacement := 'MALAXAGEM';
            if CopyStr(Items."No.", 1, 5) = '5-FRS' then
                Rec.Emplacement := 'FOUR|GYRO';
            if (Items."No." = '5-SAU-00013') then
                Rec.Emplacement := 'FOUR';
            if CopyStr(Items."No.", 1, 5) = '5-IQF' then
                Rec.Emplacement := 'FOUR';
            if CopyStr(Items."No.", 1, 5) = '5-CRU' then
                Rec.Emplacement := 'MALAXAGET';
            if CopyStr(Items."No.", 1, 5) = '1-IQF' then
                Rec.Emplacement := 'IQF';
            if CopyStr(Items."No.", 1, 5) = '5-FSV' then
                Rec.Emplacement := '5FSV';
            if CopyStr(Items."No.", 1, 5) = '5-HSV' then
                Rec.Emplacement := '5FSV';
            if CopyStr(Items."No.", 1, 5) = '5-FAT' then
                Rec.Emplacement := 'FAT';
            if CopyStr(Items."No.", 1, 5) = '1-FAT' then
                Rec.Emplacement := 'FAT';
            if CopyStr(Items."No.", 1, 5) = '1-FSV' then
                Rec.Emplacement := '1FSV';
            if CopyStr(Items."No.", 1, 5) = '1-FBO' then
                Rec.Emplacement := '1FSV';
            if CopyStr(Items."No.", 1, 5) = '5-FPS' then
                Rec.Emplacement := 'FAT';
            if CopyStr(Items."No.", 1, 5) = '1-FPS' then
                Rec.Emplacement := 'FAT';
            if CopyStr(Items."No.", 1, 11) = '5-FAT-00004' then
                Rec.Emplacement := '5FSV';
            if CopyStr(Items."No.", 1, 11) = '5-FAT-00005' then
                Rec.Emplacement := '5FSV';

            if (StrPos(UpperCase(Items.Description), 'BOUDIN') > 0) then begin
                Rec.Emplacement := 'MALAXAGET';
                Rec.Machine := 'Boudins';
            end;
            if CopyStr(Items."No.", 1, 5) = '5-MLX' then
                Rec.Machine := 'Malaxage';
            if CopyStr(Items."No.", 1, 5) = '5-SAU' then
                Rec.Machine := 'Saumure';

            if (StrPos(UpperCase(Rec.Machine), 'BOUDIN') > 0) then begin
                Rec.Emplacement := 'MALAXAGET';
            end;

            if (Rec.IDVP = '') and (Items."Machine sur écran" <> '') then
                Rec.Machine := Items."Machine sur écran";

            if (Items.Emplacement <> '') then
                Rec.Emplacement := Items.Emplacement;


            if Rec.Machine = '' then Rec.Machine := Rec.Emplacement;
            if Rec.Machine = '5FSV' then Rec.Machine := 'Ligne Sous vide';

        end;
    end;

    [EventSubscriber(ObjectType::Table, 5405, 'OnAfterValidateEvent', 'machine', false, false)]
    local procedure T5405_ModifMachine(var Rec: Record "Production Order"; var xRec: Record "Production Order"; CurrFieldNo: Integer)
    var
        Items: Record Item;
    begin
        if CopyStr(UpperCase(Rec.Machine), 1, 8) = 'MALAXAGE' then
            Rec.Machine := 'Malaxage';
    end;

    [EventSubscriber(ObjectType::Table, 5405, 'OnBeforeValidateEvent', 'Location Code', false, false)]
    local procedure T5405_ModifLocation(var Rec: Record "Production Order"; var xRec: Record "Production Order"; CurrFieldNo: Integer)
    begin
        if Rec."Location Code" = 'EC DORMA' then
            Rec.Emplacement := 'DORMA';
    end;

    [Scope('OnPrem')]
    procedure RefreshABC(ProductionNo: Code[20])
    var
        ABCHeures: Record "Heures ABC";
        ABCParameters: Record "ABC - Parametres";
        ProdL: Record "Prod. Order Line";
        ABCRess: Record "ABC - Ressources";
        ABCActivites: Record "ABC - Activites";
    begin
        ABCHeures.Reset;
        ABCHeures.SetRange("Production No", ProductionNo);
        ABCHeures.SetFilter("h calcule", '<>0');
        ABCHeures.SetFilter(Debut, '<>%1', 0DT);
        if not ABCHeures.FindFirst then begin
            ABCHeures.Reset;
            ABCHeures.SetRange("Production No", ProductionNo);
            ABCHeures.DeleteAll;
            ProdL.Reset;
            ProdL.SetRange("Prod. Order No.", ProductionNo);
            if ProdL.FindSet then
                repeat
                    ABCParameters.Reset;
                    ABCParameters.SetRange("Production BOM No", ProdL."Production BOM No.");
                    ABCParameters.SetRange("BOM Version", ProdL."Production BOM Version Code");
                    if ABCParameters.FindSet then
                        repeat
                            ABCHeures.Reset;
                            ABCHeures.Init;
                            ABCHeures."Production No" := ProductionNo;
                            ABCHeures."Production Line" := ProdL."Line No.";
                            ABCHeures.LineNo := ABCParameters.LineNo;
                            ABCHeures."OF ID" := ProductionNo + '-' + Format(ProdL."Line No.");
                            ABCHeures.Activite := ABCParameters.Activity;
                            ABCHeures.Ressource := ABCParameters.Ressource;
                            ABCRess.Get(ABCParameters.Ressource);
                            ABCHeures."Description Ressource" := ABCRess.Description;
                            ABCActivites.Get(ABCParameters.Activity);
                            ABCHeures.Atelier := ABCActivites.Atelier;
                            ABCHeures."Description Activite" := ABCActivites.Description;
                            ABCHeures.Imputation := ABCActivites.Imputation;
                            ABCHeures."Operateurs prevu" := ABCParameters."Nombre d'opérateurs";
                            ABCHeures."Prod BOM" := ABCParameters."Production BOM No";
                            ABCHeures."Prod BOM Version" := ABCParameters."BOM Version";
                            ABCHeures.Insert;
                        until ABCParameters.Next = 0;
                until ProdL.Next = 0;

        end;
    end;

    [Scope('OnPrem')]
    procedure EndOF(ProdOrderNo: Code[20])
    var
        hABC: Record "Heures ABC";
        ABCparam: Record "ABC - Parametres";
        ProdL: Record "Prod. Order Line";
    begin
        hABC.Reset;
        hABC.SetRange("Production No", ProdOrderNo);
        //hABC.SETFILTER(Activite,'<>S*');
        if hABC.FindSet then
            repeat
                ABCparam.Reset;
                ABCparam.SetRange("Production BOM No", hABC."Prod BOM");
                ABCparam.SetRange("BOM Version", hABC."Prod BOM Version");
                ABCparam.SetRange(Activity, hABC.Activite);
                ABCparam.SetRange(Ressource, hABC.Ressource);
                ProdL.Reset;
                ProdL.SetRange("Prod. Order No.", ProdOrderNo);
                ProdL.SetRange("Line No.", hABC."Production Line");
                if ABCparam.FindFirst and ProdL.FindFirst then begin
                    if ((ABCparam."Rendement effectif" > 0) and (ProdL."Finished Qty. (Base)" > 0)) then begin
                        if ABCparam.Unité = ABCparam.Unité::"Kg/Heure" then begin
                            hABC."h Machine prevu" := ProdL."Finished Qty. (Base)" / ABCparam."Rendement effectif";
                            hABC."h MO prevu" := (ProdL."Finished Qty. (Base)" / ABCparam."Rendement effectif") * ABCparam."Nombre d'opérateurs";
                            hABC."Cout total" := (hABC."h MO" * ABC_Ressource_GetCost('000', ProdL."Starting Date"));
                            hABC."Cout Kg" := (hABC."h MO" * ABC_Ressource_GetCost('000', ProdL."Starting Date")) / ProdL."Finished Qty. (Base)";
                            hABC.Modify;
                        end
                        else begin
                            hABC."h Machine prevu" := ABCparam."Rendement effectif";
                            hABC."h MO prevu" := ABCparam."Rendement effectif" * ABCparam."Nombre d'opérateurs";
                            hABC."Cout total" := (hABC."h MO" * ABC_Ressource_GetCost('000', ProdL."Starting Date"));
                            hABC."Cout Kg" := (hABC."h MO" * ABC_Ressource_GetCost('000', ProdL."Starting Date")) / ProdL."Finished Qty. (Base)";
                            hABC.Modify;

                        end;
                    end;
                end;






            until hABC.Next = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, 5407, 'OnAfterChangeStatusOnProdOrder', '', false, false)]
    local procedure CU5407_OnAfterChangeStatusOnProdOrder(var ProdOrder: Record "Production Order"; var ToProdOrder: Record "Production Order")
    begin
        if ToProdOrder.Status = ToProdOrder.Status::Finished then begin
            EndOF(ToProdOrder."No.");
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 99000773, 'OnCalculateProdOrderDatesOnAfterSetFilters', '', false, false)]
    local procedure "CU99000773_ OnCalculateProdOrderDatesOnAfterSetFilters("(var ProdOrderRoutingLine: Record "Prod. Order Routing Line"; ProductionOrder: Record "Production Order"; ProdOrderLine: Record "Prod. Order Line")
    begin
        ProdOrderRoutingLine.SetFilter("Routing No.", '<>ATELIERS');
    end;

    [EventSubscriber(ObjectType::Table, 50034, 'OnAfterModifyEvent', '', false, false)]
    local procedure T50034_OnAfterModify(var Rec: Record "Heures ABC"; var xRec: Record "Heures ABC"; RunTrigger: Boolean)
    var
        ProdH: Record "Production Order";
        hABC: Record "Heures ABC";
    begin
        if ProdH.Get(ProdH.Status::Released, Rec."Production No") then begin
            ProdH."Temps total" := 0;
            ProdH."Durée (h)" := 0;
            hABC.Reset;
            hABC.SetRange("Production No", Rec."Production No");
            hABC.SetFilter(Activite, '<>S*');
            if hABC.FindSet then
                repeat
                    ProdH."Temps total" += hABC."h MO";
                    ProdH."Durée (h)" += hABC."h MO";
                until hABC.Next = 0;
            ProdH.Modify;
        end;
    end;

    [Scope('OnPrem')]
    procedure BlockDLC()
    var
        ILE: Record "Item Ledger Entry";
        Lots: Record "Lot No. Information";
    begin
        ILE.Reset;
        ILE.SetFilter("Item No.", '7-EPC*|1-IQF-*|5-FRS-*|5-FSV-*|5-IQF*');
        ILE.SetFilter("Remaining Quantity", '>0');
        ILE.SetFilter("Warranty Date", '<%1&<>%2', Today, 0D);
        //ILE.SETFILTER("Item No.",'7-EPC-00204');

        if ILE.FindSet then
            repeat
                Lots.Reset;
                Lots.Get(ILE."Item No.", ILE."Variant Code", ILE."Lot No.");
                Lots.Blocked := true;
                Lots."Commentaire blocage" := 'Blocage DLC Dépassée';
                Lots."Raison du blocage" := 'DLC DEPASSEE';
                Lots.Modify(true);
            until ILE.Next = 0
    end;

    [Scope('OnPrem')]
    procedure PalettesCmd(No: Code[20])
    var
        PaletJnl: Record "Pallet Journal";
        Palet: Record Pallet;
        SalesL: Record "Sales Line";
        Items: Record Item;
        Qty: Decimal;
        Reserv: Record "Reservation Entry";
        SalesH: Record "Sales Header";
        NewPal: Record Pallet;
        Pal: Record Pallet;
        i: Integer;
    begin
        Pal.Reset;
        Pal.SetRange("Outbound Document No.", No);
        //Pal.SETRANGE(Type,NewPal.Type::Expedition);
        if not Pal.FindFirst then begin
            PaletJnl.Reset;
            PaletJnl.SetRange("Document No.", No);
            i := 1;
            if PaletJnl.FindSet then begin
                repeat
                    Palet.Get(PaletJnl."SSCC No.");
                    NewPal.Init;
                    Items.Get(Palet."Item No.");
                    NewPal.Validate("Item No.", Palet."Item No.");
                    NewPal."Lot No." := Palet."Lot No.";
                    NewPal.DLC := Palet.DLC;
                    NewPal."Quantite reception" := Abs(PaletJnl."Treated Quantity");
                    calcBacs(Items, NewPal);
                    NewPal."SSCC No." := '';
                    NewPal."Outbound Document No." := No;
                    NewPal.Type := NewPal.Type::Expedition;
                    NewPal.Insert(true);
                    i := i + 1;
                until PaletJnl.Next = 0;
            end
            else begin
                SalesL.Reset;
                SalesL.SetRange("Document Type", SalesL."Document Type"::Order);
                SalesL.SetRange("Document No.", No);
                SalesL.SetRange(Type, SalesL.Type::Item);
                if SalesL.FindSet then
                    repeat
                        Qty := SalesL."Quantity (Base)";
                        Items.Get(SalesL."No.");
                        Reserv.Reset;
                        Reserv.SetRange("Source ID", No);
                        Reserv.SetRange("Source Ref. No.", SalesL."Line No.");
                        if Reserv.FindSet then begin
                            repeat
                                Qty := -Reserv."Quantity (Base)";
                                if Items.PoidsPalette > 0 then
                                    while (Qty > Items.PoidsPalette) do begin
                                        NewPal.Init;
                                        NewPal.Validate("Item No.", SalesL."No.");
                                        NewPal."Quantite reception" := Items.PoidsPalette;
                                        calcBacs(Items, NewPal);
                                        NewPal."SSCC No." := '';
                                        NewPal."Lot No." := Reserv."Lot No.";
                                        NewPal.DLC := Reserv."Warranty Date";
                                        NewPal."Outbound Document No." := No;
                                        NewPal.Type := NewPal.Type::Expedition;
                                        NewPal.Insert(true);
                                        Qty := Qty - Items.PoidsPalette;
                                    end;

                                if Qty > 0 then begin
                                    NewPal.Init;
                                    NewPal.Validate("Item No.", SalesL."No.");
                                    NewPal."Quantite reception" := Qty;
                                    calcBacs(Items, NewPal);
                                    NewPal."SSCC No." := '';
                                    NewPal."Lot No." := Reserv."Lot No.";
                                    NewPal.DLC := Reserv."Warranty Date";
                                    NewPal."Outbound Document No." := No;
                                    NewPal.Type := NewPal.Type::Expedition;
                                    NewPal.Insert(true);
                                end;
                            until Reserv.Next = 0;
                        end
                        else begin
                            if Items.PoidsPalette > 0 then
                                while (Qty > Items.PoidsPalette) do begin
                                    NewPal.Init;
                                    NewPal.Validate("Item No.", SalesL."No.");
                                    NewPal."Quantite reception" := Items.PoidsPalette;
                                    calcBacs(Items, NewPal);
                                    NewPal."SSCC No." := '';
                                    NewPal."Outbound Document No." := No;
                                    NewPal.Type := NewPal.Type::Expedition;
                                    NewPal.Insert(true);
                                    Qty := Qty - Items.PoidsPalette;
                                end;

                            if Qty > 0 then begin
                                NewPal.Init;
                                NewPal.Validate("Item No.", SalesL."No.");
                                NewPal."Quantite reception" := Qty;
                                calcBacs(Items, NewPal);
                                NewPal."SSCC No." := '';
                                NewPal."Outbound Document No." := No;
                                NewPal.Type := NewPal.Type::Expedition;
                                NewPal.Insert(true);
                            end;
                        end;
                    until SalesL.Next = 0;

            end;
        end;
    end;

    [Scope('OnPrem')]
    procedure PalettesExp(No: Code[20])
    var
        PaletEntry: Record "Pallet Ledger Entry";
        Palet: Record Pallet;
        ShptL: Record "Sales Shipment Line";
        Items: Record Item;
        ShptH: Record "Sales Shipment Header";
        Pal: Record Pallet;
        NewPal: Record Pallet;
        i: Integer;
    begin

        Pal.Reset;
        Pal.SetRange("Outbound Document No.", No);
        //Pal.SETRANGE(Type,NewPal.Type::Expedition);
        if not Pal.FindFirst then begin
            PaletEntry.Reset;
            PaletEntry.SetRange("Document No.", No);
            i := 1;
            if PaletEntry.FindSet then begin
                repeat
                    Palet.Get(PaletEntry."SSCC No.");
                    NewPal.Init;
                    Items.Get(Palet."Item No.");
                    NewPal.Validate("Item No.", Palet."Item No.");
                    NewPal."Lot No." := Palet."Lot No.";
                    NewPal.DLC := Palet.DLC;
                    NewPal."Quantite reception" := Abs(PaletEntry.Quantity);
                    calcBacs(Items, NewPal);
                    NewPal."SSCC No." := '';
                    NewPal."Outbound Document No." := No;
                    NewPal.Type := NewPal.Type::Expedition;
                    NewPal.Insert(true);
                    i := i + 1;
                until PaletEntry.Next = 0;
            end
            else begin
                ShptL.Reset;
                ShptL.SetRange("Document No.", No);
                ShptL.SetRange(Type, ShptL.Type::Item);
                if ShptL.FindSet then
                    repeat
                        NewPal.Init;
                        Items.Get(ShptL."No.");
                        NewPal.Validate("Item No.", ShptL."No.");
                        NewPal."Quantite reception" := ShptL.Quantity;
                        calcBacs(Items, NewPal);
                        NewPal."SSCC No." := '';
                        NewPal."Outbound Document No." := No;
                        NewPal.Type := NewPal.Type::Expedition;
                        NewPal.Insert(true);
                    until ShptL.Next = 0;

            end;

        end;
    end;

    [Scope('OnPrem')]
    procedure calcBacs(recItem: Record Item; var Pal: Record Pallet)
    begin
        if (recItem.PoidsPalette <> 0) and (recItem.BoitesPalette <> 0) then
            Pal."Nbre bacs reception" := Round(Pal."Quantite reception" / (recItem.PoidsPalette / recItem.BoitesPalette), 1, '=');
    end;

    procedure CreateOF(ItemCode: Code[20]; Qty: Decimal; LocationCode: Code[20]; Dt: DateTime): Code[20]
    var
        Cu5510: Codeunit "Production Journal Mgt";
        ProdOrder: Record "Production Order";
        ItemJnlLine: Record "Item Journal Line";
        ReservEntry: Record "Reservation Entry";
        NextSeq: Integer;
        ItemProduit: Code[20];
        CuProd: Codeunit "Integration Tft and Prod";
        ProdOrderLine: Record "Prod. Order Line";
        NewLot: Code[50];
        NewDLC: Date;
    begin
        if (Qty < 0) then Error('La quantité ne peut pas être < 0');

        ProdOrder.Init;
        ProdOrder.Status := ProdOrder.Status::Released;
        ProdOrder.Insert(true);

        ProdOrder.Validate("Starting Date", DT2Date(Dt));
        ProdOrder."Starting Date-Time" := Dt;
        ProdOrder.Validate("Ending Date", DT2Date(Dt));
        ProdOrder."Ending Date-Time" := Dt;
        ProdOrder.Validate("Due Date", DT2Date(Dt));
        ProdOrder.Validate("Quantité MP", Qty);
        ProdOrder.Validate("Source Type", ProdOrder."Source Type"::Item);
        ProdOrder.Validate("Source No.", ItemCode);
        ProdOrder.Validate("Location Code", LocationCode);
        ProdOrder.Validate("Starting Date", Today);
        ProdOrder.Validate("Due Date", ProdOrder."Ending Date");
        ProdOrder.Modify(true);





        ProdOrderLine.Init;
        ProdOrderLine.Status := ProdOrderLine.Status::Released;
        ProdOrderLine."Prod. Order No." := ProdOrder."No.";
        ProdOrderLine."Line No." := 10000;
        ProdOrderLine.Validate("Item No.", ItemProduit);
        ProdOrderLine.Validate("Location Code", LocationCode);
        ProdOrderLine."Qty. per Unit of Measure" := 1;
        ProdOrderLine.Validate(Quantity, Qty);
        ProdOrderLine.Validate("Quantity (Base)", Qty);
        ProdOrderLine.Validate("Due Date", CalcDate('<+3D>', Today));
        ProdOrderLine.Validate("Starting Date", Today);
        ProdOrderLine.Validate("Ending Date", CalcDate('<+3D>', Today));
        ProdOrderLine.Insert;
        ProdOrder.Reset;
        ProdOrder.SetRange("No.", ProdOrder."No.");
        if ProdOrder.FindFirst then begin
            ProdOrder.Validate(Quantity, Qty);
            ProdOrder.Modify;
            REPORT.Run(REPORT::"Refresh Production Order", false, true, ProdOrder);
        end;
        if ProdOrder.FindFirst then begin
            ProdOrder.Validate("Due Date", DT2Date(ProdOrder."Starting Date-Time"));
            ProdOrder.Modify(false);
        end;



        RefreshABC(ProdOrder."No.");
        exit(ProdOrder."No.");
    end;

    local procedure GetNextWorkingDate(Dt: Date): Date
    begin
        Dt := CalcDate('<+1D>', Dt);
        while (Date2DWY(Dt, 1) > 5) do
            Dt := CalcDate('<+1D>', Dt);

        exit(Dt);
    end;

    [EventSubscriber(ObjectType::Report, 99003802, 'OnBeforeToProdOrderLineInsert', '', false, false)]
    local procedure R99003802_OnBeforeCopyLine(var ToProdOrderLine: Record "Prod. Order Line"; FromProdOrderLine: Record "Prod. Order Line")
    begin
        ToProdOrderLine.Emplacement := FromProdOrderLine.Emplacement;
        ToProdOrderLine.Termine := false;
        ToProdOrderLine.Malaxeur := FromProdOrderLine.Malaxeur;
    end;

    [EventSubscriber(ObjectType::Report, 99003802, 'OnBeforeToProdOrderModify', '', false, false)]
    local procedure R99003802_OnBeforeCopyHeader(var ToProdOrder: Record "Production Order"; FromProdOrder: Record "Production Order")
    begin
        ToProdOrder."Quantité MP" := FromProdOrder."Quantité MP";
        ToProdOrder.Machine := FromProdOrder.Machine;
        ToProdOrder."No Ordre" := FromProdOrder."No Ordre";
        ToProdOrder.Ordre := FromProdOrder.Ordre;
        ToProdOrder.Emplacement := FromProdOrder.Emplacement;
        ToProdOrder."Nbre malaxage" := FromProdOrder."Nbre malaxage";
        ToProdOrder.Termine := false;
        ToProdOrder."No malaxage" := FromProdOrder."No malaxage";
        ToProdOrder.Malaxeur := FromProdOrder.Malaxeur;
    end;

    [EventSubscriber(ObjectType::Table, 5406, 'OnAfterModifyEvent', '', false, false)]
    local procedure T5406_OnModify(var Rec: Record "Prod. Order Line"; var xRec: Record "Prod. Order Line"; RunTrigger: Boolean)
    var
        recItem: Record Item;
    begin
        if (RunTrigger) and (Rec."Quantity (Base)" <> xRec."Quantity (Base)") then begin
            recItem.Get(Rec."Item No.");
            if recItem."Stock max" <> 0 then begin
                //recItem.SETFILTER("Date Filter",'..%1',Rec."Due Date");
                recItem.CalcFields("Qty. on Sales Order");
                recItem.CalcFields("Qty. on Prod. Order");
                recItem.CalcFields("Qty. on Component Lines");
                recItem.CalcFields(Inventory);

                if (recItem.Inventory - recItem."Qty. on Sales Order" - recItem."Qty. on Component Lines" + recItem."Qty. on Prod. Order") > recItem."Stock max" + 1 then begin
                    emailmsg.Create(
                 'g.dangremont@europacuisson.com;Nabil.Aissal@europacuisson.com;Encoder2@europacuisson.com;t.hardy@europacuisson.com'
                 , 'Quantité en stock dépassée',
                 'un OF pour ' + recItem."No." + ' a été créé et dépasse le stock maximum autorisé', true);
                    emailsend.Send(emailmsg, enum::"Email Scenario"::Default);

                end;

            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 83, 'OnAfterDeleteEvent', '', false, false)]
    local procedure T83_onDelete(var Rec: Record "Item Journal Line"; RunTrigger: Boolean)
    var
        PalletJnl: Record "Pallet Journal";
    begin
        if RunTrigger then begin
            PalletJnl.SetRange("Journal Template Name", Rec."Journal Template Name");
            PalletJnl.SetRange("Journal Batch Name", Rec."Journal Batch Name");
            PalletJnl.SetRange("Journal Line No.", Rec."Line No.");
            PalletJnl.DeleteAll(false);
        end;
    end;

    [EventSubscriber(ObjectType::Table, 83, 'OnBeforeDisplayErrorIfItemIsBlocked', '', false, false)]
    local procedure T83_OnBEforeDisplayErroeBlocked(var Item: Record Item; var ItemJournalLine: Record "Item Journal Line"; var IsHandled: Boolean)
    begin
        if ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Transfer then
            IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, 5740, 'OnAfterDeleteEvent', '', false, false)]
    local procedure T5740_Delete(var Rec: Record "Transfer Header"; RunTrigger: Boolean)
    var
        PalletJnl: Record "Pallet Journal";
    begin
        PalletJnl.Reset;
        PalletJnl.SetRange("Journal Template Name", Rec."No.");
        PalletJnl.DeleteAll();
    end;

    [EventSubscriber(ObjectType::Table, 5740, 'OnBeforeInsertEvent', '', false, false)]
    local procedure T5740_Insert(var Rec: Record "Transfer Header"; RunTrigger: Boolean)
    begin
        if RunTrigger then begin
            Rec.Departement := 'DIV';
        end;
    end;

    [EventSubscriber(ObjectType::Table, 5405, 'OnBeforeAssignItemNo', '', false, false)]
    local procedure T5405_BeforeAssignItem(var ProdOrder: Record "Production Order"; xProdOrder: Record "Production Order"; var Item: Record Item; CallingFieldNo: Integer)
    begin
        Item.TestField("Purchasing Blocked", false);
    end;

    [EventSubscriber(ObjectType::Table, 5405, 'OnBeforeValidateEvent', 'Due Date', false, false)]
    local procedure T5405_OnDueDate(var Rec: Record "Production Order"; var xRec: Record "Production Order"; CurrFieldNo: Integer)
    begin
        Rec.Validate("No Ordre");
    end;

    [EventSubscriber(ObjectType::Table, 5405, 'OnAdjustStartEndingDateOnBeforeSetDueDate', '', false, false)]
    local procedure T5405_OnAdjustDT(var ProductionOrder: Record "Production Order"; var ProdOrderLine: Record "Prod. Order Line"; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, 6505, 'OnBeforeValidateEvent', 'Blocked', false, false)]
    local procedure T6505_Blocked(var Rec: Record "Lot No. Information"; var xRec: Record "Lot No. Information"; CurrFieldNo: Integer)
    var
        Utils: Codeunit "Absys - tools PJ";
    begin
        if (xRec.Blocked and not Rec.Blocked) then begin
            if not Utils.GetRole('LOT-UNBLOCK') then
                Error('Vous n''êtes pas autorisé à débloquer un lot');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 99000754, 'OnBeforeModifyEvent', '', false, false)]
    local procedure T99000754_Modify(var Rec: Record "Work Center"; var xRec: Record "Work Center"; RunTrigger: Boolean)
    begin
        if RunTrigger then begin
            if Rec."Work Center Group Code" = 'ATELIERS' then
                T99000754_Ateliers(Rec);
        end;
    end;

    [Scope('OnPrem')]
    procedure T99000754_Ateliers(WC: Record "Work Center")
    var
        Liens: Record "Ateliers Liens";
        items: Record Item;
        Couts: Record "Ateliers Couts";
    begin
        items.Reset;
        if items.FindSet then
            repeat
                if WC.Blocked then begin
                    Liens.Reset;
                    Liens.SetRange(Article, items."No.");
                    Liens.SetRange("Centre de charges", WC."No.");
                    Liens.SetRange(Fin, 0D);
                    if Liens.FindFirst then
                        Liens.Fin := Today;
                    Couts.Reset;
                    Couts.SetRange("Centre de charges", WC."No.");
                    Couts.SetRange(Fin, 0D);
                    if Couts.FindFirst then
                        Couts.Fin := Today;

                end
                else begin
                    Liens.Reset;
                    Liens.SetRange(Article, items."No.");
                    Liens.SetRange("Centre de charges", WC."No.");
                    Liens.SetRange(Fin, 0D);
                    if not Liens.FindFirst then begin
                        Liens.Reset;
                        Liens.Init;
                        Liens.Article := items."No.";
                        Liens."Centre de charges" := WC."No.";
                        Liens.Début := Today;
                        Liens.Insert;
                    end;
                    Couts.Reset;
                    Couts.SetRange("Centre de charges", WC."No.");
                    Couts.SetRange(Fin, 0D);
                    if not Couts.FindFirst then begin
                        Couts.Reset;
                        Couts.Init;
                        Couts."Centre de charges" := WC."No.";
                        Couts.Debut := Today;
                        Couts.Insert;
                    end;


                end;
            until items.Next = 0;
    end;

    [Scope('OnPrem')]
    procedure BOM_GetTotalMPPerUnit(BOMH: Record "Production BOM Header"): Decimal
    var
        BomLine: Record "Production BOM Line";
        VersionMgt: Codeunit VersionManagement;
        Items: Record Item;
        Total: Decimal;
    begin
        BomLine.Reset;
        BomLine.SetRange("Production BOM No.", BOMH."No.");
        BomLine.SetRange("Version Code", VersionMgt.GetBOMVersion(BOMH."No.", WorkDate, true));
        //  BomComponent[Level].SETRANGE("Version Code",ProdOrderLine."Production BOM Version Code");
        BomLine.SetFilter("Starting Date", '%1|..%2', 0D, WorkDate);
        BomLine.SetFilter("Ending Date", '%1|%2..', 0D, WorkDate);
        if BomLine.FindSet then
            repeat
                if BomLine.Type = BomLine.Type::Item then
                    if Items.Get(BomLine."No.") then
                        if (CopyStr(Items."Item Category Code", 1, 5) = '7-MP1') or (CopyStr(Items."Item Category Code", 1, 5) = '5-CRU') then
                            Total := Total + BomLine.Quantity * (1 + BomLine."Scrap %" / 100);

            until BomLine.Next = 0;
        exit(Total);
    end;

    [Scope('OnPrem')]
    procedure GetAllMP(rec: Record "Production BOM Header"; Version: Code[50]; TargetQuantity: Decimal): Text
    var
        BomLine: Record "Production BOM Line";
        BomH: Record "Production BOM Header";
        VersionMgt: Codeunit VersionManagement;
        Items: Record Item;
        Total: Text;
        CRLF: Code[3];
    begin
        CRLF[1] := 13;

        BomLine.Reset;
        BomLine.SetRange("Production BOM No.", rec."No.");
        if Version = '' then
            BomLine.SetRange("Version Code", VersionMgt.GetBOMVersion(rec."No.", WorkDate, true))
        else
            BomLine.SetRange("Version Code", Version);

        BomLine.SetFilter("Starting Date", '%1|..%2', 0D, WorkDate);
        BomLine.SetFilter("Ending Date", '%1|%2..', 0D, WorkDate);
        if BomLine.FindSet then
            repeat
                if BomLine.Type = BomLine.Type::Item then
                    if Items.Get(BomLine."No.") then
                        if (((CopyStr(Items."Item Category Code", 1, 4) = '7-MP')) and not Items.IsMfgItem) then begin
                            Total := Total + Items."No." + '  : ' + Format(BomLine.Quantity * TargetQuantity) + CRLF + '\';
                        end
                        else begin
                            if Items.IsMfgItem then begin
                                if BomH.Get(Items."Production BOM No.") then
                                    Total := Total + Format(GetAllMP(BomH, '', BomLine.Quantity * TargetQuantity)) + CRLF + '\';
                            end;
                        end;
            until BomLine.Next = 0;
        exit(Total);
    end;

    [Scope('OnPrem')]
    procedure CloseOF(No: Code[20])
    var
        CU50012: Codeunit "Prod. Order Status Manageme EC";
        T5405: Record "Production Order";
    begin

        T5405.Reset;
        T5405.SetRange("No.", No);
        T5405.SetRange(Status, T5405.Status::Released);
        if T5405.FindSet then
            repeat

                CU50012.ChangeStatusOnProdOrder(T5405, T5405.Status::Finished, T5405."Starting Date", false);

            until T5405.Next = 0;
    end;

    [Scope('OnPrem')]
    procedure MergeTraca(DocumentNo: Code[20]; Ligne: Integer)
    var
        Traca: Record "Reservation Entry";
        Traca2: Record "Reservation Entry";
    begin
        Traca.Reset;
        Traca.SetRange("Source ID", DocumentNo);
        Traca.SetRange("Source Ref. No.", Ligne);
        if Traca.FindSet then
            repeat
                if Traca."Quantity (Base)" <> 0 then begin
                    Traca2.Reset;
                    Traca2.SetRange("Source ID", Traca."Source ID");
                    Traca2.SetRange("Source Ref. No.", Traca."Source Ref. No.");
                    Traca2.SetRange("Location Code", Traca."Location Code");
                    Traca2.SetRange("Source Type", Traca."Source Type");
                    Traca2.SetRange("Source Subtype", Traca."Source Subtype");
                    Traca2.SetRange("Lot No.", Traca."Lot No.");
                    Traca2.SetFilter("Entry No.", '<>%1', Traca."Entry No.");
                    if Traca2.FindSet then
                        repeat
                            Traca."Quantity (Base)" += Traca2."Quantity (Base)";
                            Traca.Quantity += Traca2.Quantity;
                            Traca."Qty. to Handle (Base)" += Traca2."Qty. to Handle (Base)";
                            Traca."Qty. to Invoice (Base)" += Traca2."Qty. to Invoice (Base)";
                            Traca2."Quantity (Base)" := 0;
                            Traca2.Modify;
                        until Traca2.Next = 0;
                    Traca.Modify;
                end;
            until Traca.Next = 0;
        Traca.Reset;
        Traca.SetRange("Source ID", DocumentNo);
        Traca.SetRange("Source Ref. No.", Ligne);
        Traca.SetRange("Quantity (Base)", 0);
        Traca.DeleteAll();
    end;

    [EventSubscriber(ObjectType::Codeunit, 22, 'OnBeforePostLineByEntryType', '', false, false)]
    local procedure CU22_OnBeforePostLineByEntryType(var ItemJournalLine: Record "Item Journal Line"; CalledFromAdjustment: Boolean; CalledFromInvtPutawayPick: Boolean)
    begin
        if (ItemJournalLine."Posting Date" > Today) and (ItemJournalLine."Entry Type" in [ItemJournalLine."Entry Type"::Consumption, ItemJournalLine."Entry Type"::Output]) then
            Error('Impossible de produire dans le futur');
    end;

    [EventSubscriber(ObjectType::Codeunit, 6501, 'OnAfterTransferExpDateFromSummary', '', false, false)]
    local procedure CU6501_OnAfterTransferExpDate(var TrackingSpecification: Record "Tracking Specification"; var TempEntrySummary: Record "Entry Summary" temporary)
    begin
        TrackingSpecification."Warranty Date" := TempEntrySummary."Warranty Date";
    end;

    [Scope('OnPrem')]
    procedure GetEffectifProd(ProdNo: Code[20]): Decimal
    var
        ProdL: Record "Prod. Order Line";
        ABC: Record "ABC - Parametres";
        Effectif: Decimal;
    begin
        ProdL.Reset;
        ProdL.SetRange("Prod. Order No.", ProdNo);
        Effectif := 0;
        if ProdL.FindFirst then begin
            ABC.Reset;
            ABC.SetRange("Production BOM No", ProdL."Production BOM No.");
            ABC.SetRange("BOM Version", ProdL."Production BOM Version Code");
            ABC.SetFilter(Activity, '<>S*');
            ABC.SetFilter(Type, '<>%1', ABC.Type::"Main d'oeuvre");
            ABC.SetRange("Imputation Ressource", ABC."Imputation Ressource"::Direct);
            if ABC.FindSet then
                repeat
                    Effectif += ABC."Nombre d'opérateurs";
                until ABC.Next = 0;


        end;
        exit(Effectif);
    end;
}

