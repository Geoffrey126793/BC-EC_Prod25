codeunit 50048 Integration_Sales
{
    // Ligne 40 Eori
    // Ligne 41 Incoterms
    // Ligne 42 Transporteur
    // Ligne 51  liens commande RD
    // Ligne 100  9-VID-00002
    // Ligne 300  9-VID-00015
    // Ligne 200  9-VID-00021
    // Ligne 400  9-VID-00022
    // Ligne 410  9-VID-00037
    // Ligne 415  9-DIV-00035

    Permissions = TableData "Sales Line" = rimd,
                  TableData "Sales Shipment Header" = rim,
                  TableData "Sales Invoice Header" = rim,
                  TableData "Value Entry" = rim;

    trigger OnRun()
    begin
        //CheckCreditClient2('C02880');
        //CheckCreditClientAll();
        //MESSAGE('%1',GetOverdue('C02557',30));
        WorkWithExv('EXV-E26-09462');
        WorkWithExv('EXV-E26-09463');
        WorkWithExv('EXV-E26-09461');
        //WorkWithExv('EXV-E25-00965');
        //WorkWithExv('EXV-E25-00967');
        Message('ok');
    end;

    var
        AB6Tool: Codeunit "Absys - tools PJ";
        Items: Record Item;
        FileMgt: Codeunit "File Management";
        emailmsg: Codeunit "Email Message";
        emailsend: Codeunit Email;
        Text001: Label 'Les lots sont verrouillés';
        cuUtils: Codeunit Utils;
        Text002: Label 'Vous n''avez pas l''autorisation de (dé)bloquer la traçabilité';
        Text003: Label 'Veuillez d''abord valider l''échantillon %1';
        Xl: Record "Excel Buffer" temporary;
        t: Text;
        TempBlob: Codeunit "Temp Blob";
        InStr: InStream;

    local procedure GetEMailScenarioForCustomer(SalesH: record "Sales Header") Scenario: Enum "Email Scenario"
    var
        Salarie: Record Employee;
    begin
        Scenario := Enum::"Email Scenario"::Default;

        Salarie.RESET;
        Salarie.SETRANGE("No.", GetReponsableFromSalesH(SalesH));
        IF NOT Salarie.FINDFIRST THEN ERROR('Vendeur non trouvé');

        if Salarie."Company E-Mail" = 'sales-export@europacuisson.com' THEN exit(Enum::"Email Scenario"::SalesExport);
        if Salarie."Company E-Mail" = 'sales-benelux@europacuisson.com' THEN exit(Enum::"Email Scenario"::SalesBE);
        if Salarie."Company E-Mail" = 'sales-france@europacuisson.com' THEN exit(Enum::"Email Scenario"::SalesFR);


        exit(Enum::"Email Scenario"::Default);
    end;

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnAfterPostSalesDoc', '', false, false)]
    local procedure CU80_OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean; InvtPickPutaway: Boolean)
    var
        ShptPurchOrder: Record "Shipment Purchase Orders";
        Palet: Record Pallet;
        PurchLine: Record "Purchase Line";
        PurchInvLine: Record "Purch. Inv. Line";
        ILE: Record "Item Ledger Entry";
        LotInfo: Record "Lot No. Information";
        RecPalletEntry_l: Record "Pallet Ledger Entry";
        RecPallet_l: Record Pallet;
        sessionId: Integer;
        CUMail: Codeunit Integration_EMail;
        ToAddress: Text;
        R_Exp: Report "Sales - Shipment EC";
        ShpHeader: Record "Sales Shipment Header";
        f: Text;
        Cust: Record Customer;
    begin
        if ((SalesHeader."Document Type" = SalesHeader."Document Type"::Order) and (SalesHeader.Invoice)) then begin
            ShptPurchOrder.Reset;
            ShptPurchOrder.SetRange("Sales Order No.", SalesHeader."No.");
            if (SalesInvHdrNo <> '') and ShptPurchOrder.Find('-') then
                ShptPurchOrder.Rename(SalesHeader."Shipping Agent Code", SalesHeader."Location Code", SalesHeader."Promised Delivery Date", '', SalesInvHdrNo);
            if (SalesHeader."Transport Purchase Order" <> '') then begin
                PurchLine.Reset;
                PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
                PurchLine.SetRange("Document No.", SalesHeader."Transport Purchase Order");
                PurchLine.SetRange("Transport Sales Order No", SalesHeader."No.");
                if PurchLine.Find('-') then begin
                    PurchLine."Transport Sales Order No" := '';
                    PurchLine."Transport Sales Invoice No" := SalesInvHdrNo;
                    PurchLine.Modify;
                end;
            end;
            if (SalesHeader."Transport Purchase Invoice" <> '') then begin
                PurchInvLine.Reset;
                PurchInvLine.SetRange("Document No.", SalesHeader."Transport Purchase Invoice");
                PurchInvLine.SetRange("Transport Sales Order No", SalesHeader."No.");
                if PurchInvLine.Find('-') then begin
                    PurchInvLine."Transport Sales Order No" := '';
                    PurchInvLine."Transport Sales Invoice No" := SalesInvHdrNo;
                    PurchInvLine.Modify;
                end;
            end;
        end;

        if (((SalesHeader."Document Type" = SalesHeader."Document Type"::Order)) and SalesHeader.Ship) then begin
            if (not ((SalesHeader."Status credit" = SalesHeader."Status credit"::Ok) or (SalesHeader."Status credit" = SalesHeader."Status credit"::"Libéré manuellement"))) then
                Error('Commande bloquée');
            if Cust.Get(SalesHeader."Sell-to Customer No.") then
                if Cust.MailEXV <> '' then begin
                    emailmsg.Create(
                    Cust.MailEXV, 'Livraison n°' + SalesShptHdrNo + 'pour client ' + SalesHeader."Sell-to Customer Name",
                    'Livraison validée', true);
                    emailsend.Send(emailmsg, enum::"Email Scenario"::Default);
                end;
            if (SalesHeader."Sell-to Customer No." = 'C03422') then begin
                emailmsg.Create(
                'sales-france@europacuisson.com', 'Livraison n°' + SalesShptHdrNo + 'pour client ' + SalesHeader."Sell-to Customer Name",
                'Livraison validée', true);
                emailsend.Send(emailmsg, enum::"Email Scenario"::Default);
            end;
            if (SalesHeader."Sell-to Customer No." = 'C02557') then begin
                emailmsg.Create(
                'sales-france@europacuisson.com', 'Livraison n°' + SalesShptHdrNo + 'pour client ' + SalesHeader."Sell-to Customer Name",
                'Livraison validée', true);
                emailsend.Send(emailmsg, enum::"Email Scenario"::Default);
            end;
            if (SalesHeader."Sell-to Customer No." = 'C03589') then begin
                emailmsg.Create(
                'sales-france@europacuisson.com', 'Livraison n°' + SalesShptHdrNo + 'pour client ' + SalesHeader."Sell-to Customer Name",
                'Livraison validée', true);
                emailsend.Send(emailmsg, enum::"Email Scenario"::Default);
            end;
            if (SalesHeader."Sell-to Customer No." = 'C02682') then begin
                emailmsg.Create(
                'sales-export@europacuisson.com', 'Livraison n°' + SalesShptHdrNo + 'pour client ' + SalesHeader."Sell-to Customer Name",
                'Livraison validée', true);
                emailsend.Send(emailmsg, enum::"Email Scenario"::Default);
            end;
            if (SalesHeader."Sell-to Customer No." = 'C03608') or (SalesHeader."Sell-to Customer No." = 'C03634') or (SalesHeader."Sell-to Customer No." = 'C01675') or (SalesHeader."Sell-to Customer No." = 'C02392') then begin
                emailmsg.Create(
                'sales-export@europacuisson.com', 'Livraison n°' + SalesShptHdrNo + 'pour client ' + SalesHeader."Sell-to Customer Name",
                'Livraison validée', true);
                emailsend.Send(emailmsg, enum::"Email Scenario"::Default);
            end;
            if ((SalesHeader."Sell-to Customer No." = 'C00909') and (SalesHeader."Ship-to Code" = 'DELIVA')) then begin
                emailmsg.Create(
                'sales-benelux@europacuisson.com', 'Livraison n°' + SalesShptHdrNo + 'pour client ' + SalesHeader."Sell-to Customer Name",
                'Livraison validée  delivery.KAMsupport@metrofsd.be  delivery.stockplanning@metrofsd.be', true);
                emailsend.Send(emailmsg, enum::"Email Scenario"::Default);
            end;
            if ((SalesHeader."Sell-to Customer No." = 'C03561') or (SalesHeader."Sell-to Customer No." = 'C03613')) then begin
                emailmsg.Create(
                'sales-benelux@europacuisson.com', 'Livraison n°' + SalesShptHdrNo + 'pour client ' + SalesHeader."Sell-to Customer Name",
                'Livraison validée', true);
                emailsend.Send(emailmsg, enum::"Email Scenario"::Default);
            end;
            if ((SalesHeader."Sell-to Customer No." = 'C03998') OR (SalesHeader."Sell-to Customer No." = 'C02880') or (SalesHeader."Sell-to Customer No." = 'C00335') or (SalesHeader."Sell-to Customer No." = 'C03561') or (SalesHeader."Sell-to Customer No." = 'C02369') or (SalesHeader."Sell-to Customer No." = 'C03762') or (SalesHeader."Sell-to Customer No." = 'C02916') or (SalesHeader."Sell-to Customer No." = 'C03948') or (SalesHeader."Sell-to Customer No." = 'C03975')) then begin
                emailmsg.Create(
                'Sarra.Louifi@europacuisson.com;sales-benelux@europacuisson.com', 'Livraison n°' + SalesShptHdrNo + 'pour client ' + SalesHeader."Sell-to Customer Name",
                'Livraison validée', true);
                emailsend.Send(emailmsg, enum::"Email Scenario"::Default);
            end;

            ToAddress := CUMail._GetEMailsRespForEntity(DATABASE::Customer, SalesHeader."Sell-to Customer No.", 'S09');
            if ToAddress <> '' then begin
                emailmsg.Create(ToAddress, 'Livraison n°' + SalesShptHdrNo, 'Le départ de votre commande a été validée.</BR>Elle sera livrée, dans le délai convenu, par notre transporteur habituel', true);
                //smtp.AppendBody(ToAddress);
                ShpHeader.Reset;
                ShpHeader.SetFilter("No.", '%1', SalesShptHdrNo);
                if ShpHeader.FindFirst then begin
                    f := FileMgt.ServerTempFileName('.pdf');
                    REPORT.SaveAsPdf(50003, f, ShpHeader);
                    if FileMgt.ServerFileExists(f) then begin
                        Clear(TempBlob);
                        FileMgt.BLOBImportFromServerFile(TempBlob, f);
                        TempBlob.CreateInStream(InStr);
                        emailmsg.AddAttachment('Expedition.pdf', 'application/pdf', InStr);
                    end;

                end;
                emailsend.Send(emailmsg, GetEMailScenarioForCustomer(SalesHeader));
            end;


        end;

        //Palettes expedition
        if (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) then begin
            Palet.Reset;
            Palet.SetRange("Outbound Document No.", SalesHeader."No.");
            Palet.SetRange(Type, Palet.Type::Expedition);
            if Palet.FindFirst then begin
                repeat
                    Palet."Outbound Document No." := SalesShptHdrNo;
                    Palet.Modify;
                until not Palet.FindFirst;
            end
            else begin
                Palet.Reset;
                Palet.SetRange("Outbound Document No.", SalesHeader."No.");
                if Palet.FindFirst then
                    repeat
                        Palet."Outbound Document No." := SalesShptHdrNo;
                        Palet.Modify;
                    until not Palet.FindFirst;
            end;
        end;


        if RetRcpHdrNo <> '' then begin
            ILE.Reset;
            ILE.SetRange("Document No.", RetRcpHdrNo);
            if ILE.FindSet then
                repeat
                    if LotInfo.Get(ILE."Item No.", '', ILE."Lot No.") then begin
                        LotInfo.Blocked := true;
                        LotInfo."Commentaire blocage" := 'RETOUR Client, en attente qualité';
                        LotInfo.Modify(true);
                    end;
                until ILE.Next = 0;

            RecPalletEntry_l.SetCurrentKey("Document No.", "Posting Date");
            RecPalletEntry_l.SetRange("Document No.", RetRcpHdrNo);
            if RecPalletEntry_l.Find('-') then
                repeat
                    RecPallet_l.Reset;
                    RecPallet_l.SetRange("SSCC No.", RecPalletEntry_l."SSCC No.");
                    if RecPallet_l.Find('-') then begin
                        StartSession(sessionId, CODEUNIT::"Print palet Etiq", CompanyName, RecPallet_l);
                    end;
                until RecPalletEntry_l.Next = 0;
        end;

        if (((SalesHeader."Document Type" = SalesHeader."Document Type"::Order)) and SalesHeader.Ship) then begin
            WorkWithExv(SalesShptHdrNo);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnInvoiceSalesShptLine', '', false, false)]
    local procedure CU80_OnInvoiceSalesShpLine(SalesShipmentLine: Record "Sales Shipment Line"; InvoiceNo: Code[20]; InvoiceLineNo: Integer; QtyToInvoice: Decimal; CommitIsSuppressed: Boolean)
    var
        ShipmentInvoiced: Record "Shipment Invoiced";
    begin

        ShipmentInvoiced.Init;
        ShipmentInvoiced."Invoice No." := InvoiceNo;
        ShipmentInvoiced."Shipment No." := SalesShipmentLine."Document No.";
        ShipmentInvoiced."Shipment Line No." := SalesShipmentLine."Line No.";
        ShipmentInvoiced."Invoice Line No." := SalesShipmentLine."Line No.";
        ShipmentInvoiced."Qty. to Invoice" := SalesShipmentLine."Quantity Invoiced";
        ShipmentInvoiced."Qty. to Ship" := SalesShipmentLine.Quantity;
        ShipmentInvoiced."Posting Date" := SalesShipmentLine."Posting Date";
        ;
        ShipmentInvoiced."User ID" := UserId;
        ShipmentInvoiced.Type := SalesShipmentLine.Type.AsInteger();
        ShipmentInvoiced."No." := SalesShipmentLine."No.";
        ShipmentInvoiced."Location Code" := SalesShipmentLine."Location Code";
        ShipmentInvoiced.Description := SalesShipmentLine.Description;
        ShipmentInvoiced."Order No." := SalesShipmentLine."Order No.";
        ShipmentInvoiced."Sell-to Customer No." := SalesShipmentLine."Sell-to Customer No.";
        //ShipmentInvoiced."Sell-to Customer Name" := SalesShipmentLine."Sell-to Customer Name";
        //ShipmentInvoiced."Customer Order No." := SalesShipmentLine."Customer Order No.";
        ShipmentInvoiced."Qty. Shipped Not Invoiced" := SalesShipmentLine."Qty. Shipped Not Invoiced";
        ShipmentInvoiced."Quantity Invoiced" := SalesShipmentLine."Quantity Invoiced";
        ShipmentInvoiced."Shipment Posting Date" := SalesShipmentLine."Posting Date";
        if ShipmentInvoiced.Insert then;   // FR-11-74-PK2U
    end;

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnBeforePostSalesDoc', '', false, false)]
    local procedure CU80_OnBeforePostSalesDoc(var Sender: Codeunit "Sales-Post"; var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var HideProgressWindow: Boolean)
    var
        resEntry: Record "Reservation Entry";
        NewLocation: Record Location;
        PalletJnl: Record "Pallet Journal";
        ItemRef: Record "Item Reference";
        QtyReserv: Decimal;
        QtyOrder: Decimal;
        SalesL: Record "Sales Line";
        ile: Record "Item Ledger Entry";
    begin
        if (((SalesHeader."Document Type" = SalesHeader."Document Type"::Order)) and SalesHeader.Ship) then begin
            if (not ((SalesHeader."Status credit" = SalesHeader."Status credit"::Ok) or (SalesHeader."Status credit" = SalesHeader."Status credit"::"Libéré manuellement"))) then
                Error('Commande bloquée');
        end;
        if (SalesHeader.Ship) and (SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order") then begin
            resEntry.Reset;
            resEntry.SetRange("Source Type", 37);
            resEntry.SetRange("Source Subtype", 5);
            resEntry.SetRange("Source ID", SalesHeader."No.");
            if resEntry.FindSet then
                repeat
                    NewLocation.Get(resEntry."Location Code");
                    if NewLocation."Pallet Management" then begin
                        PalletJnl.Reset;
                        PalletJnl.SetRange("Reservation Entry", resEntry."Entry No.");
                        if not PalletJnl.Find('-') then Error('Préciser la palettisation pour l''article %1 - Lot %2', resEntry."Item No.", resEntry."Lot No.");
                    end;
                until resEntry.Next = 0;
        end;
        if (SalesHeader.Ship) and (SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo") then begin
            resEntry.Reset;
            resEntry.SetRange("Source Type", 37);
            resEntry.SetRange("Source Subtype", 5);
            resEntry.SetRange("Source ID", SalesHeader."No.");
            if resEntry.FindSet then
                repeat
                    NewLocation.Get(resEntry."Location Code");
                    if NewLocation."Pallet Management" then begin
                        PalletJnl.Reset;
                        PalletJnl.SetRange("Reservation Entry", resEntry."Entry No.");
                        if not PalletJnl.Find('-') then Error('Préciser la palettisation pour l''article %1 - Lot %2', resEntry."Item No.", resEntry."Lot No.");
                    end;
                until resEntry.Next = 0;
        end;

        if (SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order") then begin
            resEntry.Reset;
            resEntry.SetRange("Source Type", 37);
            resEntry.SetRange("Source ID", SalesHeader."No.");
            if resEntry.FindSet then
                repeat
                    ile.Reset;
                    ile.SetRange("Item No.", resEntry."Item No.");
                    ile.SetRange("Lot No.", resEntry."Lot No.");
                    ile.SetRange("Entry Type", ile."Entry Type"::Output);
                    if not ile.FindFirst then
                        Error('Le lot %1 n''existe pas en production', resEntry."Lot No.");
                until resEntry.Next = 0;
        end;

        if (SalesHeader.Ship) and (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) then begin
            QtyReserv := 0;
            resEntry.Reset;
            resEntry.SetRange("Source Type", 37);
            resEntry.SetRange("Source Subtype", 1);
            resEntry.SetRange("Source ID", SalesHeader."No.");
            if resEntry.FindSet then
                repeat
                    QtyReserv += resEntry."Qty. to Handle (Base)";
                    ItemRef.Reset;
                    ItemRef.SetRange("Item No.", resEntry."Item No.");
                    ItemRef.SetRange("Reference Type", ItemRef."Reference Type"::Customer);
                    ItemRef.SetRange("Reference Type No.", SalesHeader."Sell-to Customer No.");
                    ItemRef.SetFilter("DLC mini", '>0');
                    if ItemRef.FindFirst then begin
                        if resEntry."Warranty Date" < CalcDate(StrSubstNo('<%1D>', ItemRef."DLC mini"), Today) then
                            Error('DLC mini non respectée pour %1 lot %2', ItemRef."Item No.", resEntry."Warranty Date");
                    end;
                until resEntry.Next = 0;
            QtyOrder := 0;
            SalesL.Reset;
            SalesL.SetRange("Document Type", SalesL."Document Type"::Order);
            SalesL.SetRange("Document No.", SalesHeader."No.");
            SalesL.SetFilter("No.", '1*|2*');
            if SalesL.FindSet then
                repeat
                    if (SalesL."No." <> '1-DIV-00001') then
                        QtyOrder += SalesL."Quantity (Base)";
                until SalesL.Next = 0;
            if QtyOrder <> 0 then
                if Abs(QtyReserv) <> Abs(QtyOrder) then
                    Error('La quantité en traçabilité ne correspond pas à la commande');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnCheckSalesPostRestrictions', '', false, false)]
    local procedure T36_OnCheckSalesPostRestrictions(var Sender: Record "Sales Header")
    var
        AB6Tool: Codeunit "Absys - tools PJ";
        SalesH: Record "Sales Header";
    begin
        if Sender."Document Type" = Sender."Document Type"::"Credit Memo" then
            Sender.TestField(Sender."Status Visa", Sender."Status Visa"::"Visa authorized");
        if (Sender."Document Type" = Sender."Document Type"::Order)
                         and Sender.Ship
                         and not (AB6Tool.GetRole('VISABL')) then
            Error('Pas le droit de livrer');
        if (Sender."Document Type" = Sender."Document Type"::Order)
                        and Sender.Invoice
                        and not (AB6Tool.GetRole('VISAFAC')) then
            Error('Pas le droit de facturer');

        SalesH.Reset;
        SalesH.SetRange("Lié avec commande n°", Sender."No.");
        SalesH.SetRange("Completely Shipped", false);
        if SalesH.FindFirst then Error(Text003, SalesH."No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnBeforePostLines', '', false, false)]
    local procedure CU80_OnBeforePostLines(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean)
    var
        Text50000: Label 'Unit price is required for %1 = %2, %3 = %4, %5 = %6.';
        SalesLine2: Record "Sales Line";
        Text50001: Label 'Toute la quantité n''est pas expédiee  %1 = %2, %3 = %4, %5 = %6.';
    begin
        SalesLine2.SetRange("Document No.", SalesHeader."No.");
        SalesLine2.SetRange(Type, SalesLine2.Type::Item);
        //  SalesLine2.SETRANGE("Unit Price",0);
        SalesLine2.SetFilter("Location Code", '<>%1', 'RD');
        if SalesLine2.Find('-') then
            repeat
                if SalesLine2."Unit Price" = 0 then
                    Error(Text50000,
                    SalesLine2.FieldCaption("Document Type"),
                    SalesLine2."Document Type",
                    SalesLine2.FieldCaption("Document No."),
                    SalesLine2."Document No.",
                    SalesLine2.FieldCaption("Line No."),
                    SalesLine2."Line No.");
                if ((SalesLine2."Document Type" = SalesLine2."Document Type"::Order) and (SalesLine2."Quantity (Base)" <> (SalesLine2."Qty. Shipped (Base)" + SalesLine2."Qty. to Ship (Base)"))) then
                    Error(Text50001,
                    SalesLine2.FieldCaption("Document Type"),
                    SalesLine2."Document Type",
                    SalesLine2.FieldCaption("Document No."),
                    SalesLine2."Document No.",
                    SalesLine2.FieldCaption("Line No."),
                    SalesLine2."Line No.");

            until SalesLine2.Next = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnPostItemJnlLineOnAfterCopyDocumentFields', '', false, false)]
    local procedure CU80_OnPostItemJnlLineOnAfterCopyDocumentFields(var ItemJournalLine: Record "Item Journal Line"; SalesLine: Record "Sales Line"; WarehouseReceiptHeader: Record "Warehouse Receipt Header"; WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    begin
        // ItemJournalLine."Document No. Pallet" := ItemJournalLine."Document No.";
        ItemJournalLine."Document No. Pallet" := SalesLine."Document No.";
        // ItemJournalLine."Document Line No. Pallet" := ItemJournalLine."Line No.";
        ItemJournalLine."Document Line No. Pallet" := SalesLine."Line No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, 81, 'OnAfterConfirmPost', '', false, false)]
    local procedure CU81_OnAfterConfirmSalesPost(var SalesHeader: Record "Sales Header")
    var
        AB6Tool: Codeunit "Absys - tools PJ";
        Text50000: Label 'Voulez-vous remplaçer la date de compatbilisation avec la date d''aujourd''hui?';
        SalesLine: Record "Sales Line";
        Loc: Record Location;
        resEntry: Record "Reservation Entry";
        PalletJnl: Record "Pallet Journal";
    begin

        // On controle la date de l'entete, et on la remplace par la date du jour ci nécessaire
        if (SalesHeader."Posting Date" <> Today) then begin
            if AB6Tool.GetRole('DATECOMPTA') then begin
                SalesHeader.SetHideValidationDialog(true);
                SalesHeader.Validate("Posting Date", Today);
                SalesHeader.Modify;
            end else begin

                if (Confirm(Text50000)) or (not GuiAllowed) then begin
                    SalesHeader.SetHideValidationDialog(true);
                    SalesHeader.Validate("Posting Date", Today);
                    SalesHeader.Modify;
                end;
            end;
        end;

        SalesLine.Reset;
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindSet then
            repeat
                if (StrPos(UpperCase(CompanyName), 'POLAND') = 0) and (SalesHeader."Document Type" <> SalesHeader."Document Type"::"Return Order") then
                    CheckTarif(SalesLine);
                if SalesLine.Type = SalesLine.Type::Item then begin
                    Loc.Get(SalesLine."Location Code");
                    if (Loc."Pallet Management") and SalesHeader.Ship then begin
                        resEntry.Reset;
                        resEntry.SetRange("Source Type", 37);
                        resEntry.SetRange("Source Subtype", 1);
                        resEntry.SetRange("Source ID", SalesHeader."No.");
                        resEntry.SetRange("Source Ref. No.", SalesLine."Line No.");
                        if resEntry.FindSet then
                            repeat
                                PalletJnl.Reset;      //Pas de coh‚rence quantit‚ ?
                                PalletJnl.SetRange("Reservation Entry", resEntry."Entry No.");
                                if not PalletJnl.Find('-') then
                                    Error('Pr‚ciser la palettisation pour l''article %1 - Lot %2, ‚criture %3',
                                 resEntry."Item No.", resEntry."Lot No.", resEntry."Entry No.");
                            until resEntry.Next = 0;
                    end;

                end;
            until SalesLine.Next = 0;
        if SalesHeader.Invoice and (SalesHeader."Location Code" = 'RD') then
            Error('Les commandes d''echantillons ne sont pas facturables');
    end;

    [EventSubscriber(ObjectType::Codeunit, 82, 'OnBeforeConfirmPost', '', false, false)]
    local procedure CU82_OnBeforeConfirmPost(var SalesHeader: Record "Sales Header"; var HideDialog: Boolean; var IsHandled: Boolean; var SendReportAsEmail: Boolean; var DefaultOption: Integer)
    var
        Text50000: Label 'Voulez-vous remplaçer la date de compatbilisation avec la date d''aujourd''hui?';
    begin
        // On controle la date de l'entete, et on la remplace par la date du jour ci n‚cessaire
        if (SalesHeader."Posting Date" <> Today) then begin
            if AB6Tool.GetRole('DATECOMPTA') then begin
                SalesHeader.SetHideValidationDialog(true);
                SalesHeader.Validate("Posting Date", Today);
                SalesHeader.Modify;
            end else begin

                if Confirm(Text50000) then begin
                    SalesHeader.SetHideValidationDialog(true);
                    SalesHeader.Validate("Posting Date", Today);
                    SalesHeader.Modify;
                end;
            end;
        end;
        //

        //TEST DES DROITS DE L'UTILISATEUR
        //AB6.VIR.120310  ---->
        if (SalesHeader."Document Type" = SalesHeader."Document Type"::Order)
           and (not (AB6Tool.GetRole('VISABLOK')))
           and (SalesHeader."Bon Pour Expédition" <> SalesHeader."Bon Pour Expédition"::"Shipment authorized")
           and SalesHeader.Ship
           then
            Error('Pas le droit de valider');
        //AB6.VIR.120310  <----
    end;

    [EventSubscriber(ObjectType::Codeunit, 82, 'OnAfterPost', '', false, false)]
    local procedure CU82_OnAfterPost(var SalesHeader: Record "Sales Header")
    var
        SalesShptHeader: Record "Sales Shipment Header";
    begin
        if SalesHeader.Ship and (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) and (SalesHeader."Order type" = SalesHeader."Order type"::"Surgelé") then begin
            SalesShptHeader.Reset;
            SalesShptHeader.SetRange("Order No.", SalesHeader."No.");
            if SalesShptHeader.FindFirst then
                SalesShptHeader.PrintRecords(false);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 391, 'OnBeforeSalesShptHeaderModify', '', false, false)]
    local procedure CU391_EDitShpt(var SalesShptHeader: Record "Sales Shipment Header"; FromSalesShptHeader: Record "Sales Shipment Header")
    begin
        SalesShptHeader."Nombre de palette" := FromSalesShptHeader."Nombre de palette";
        SalesShptHeader."Nombre de colis" := FromSalesShptHeader."Nombre de colis";
    end;

    [EventSubscriber(ObjectType::Codeunit, 414, 'OnBeforeReleaseSalesDoc', '', false, false)]
    local procedure CU414_OnBeforeReleaseSalesDoc(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean)
    var
        SalesPriceMgt: Codeunit "Sales Price Calc. Mgt.EC";
        lSalesLine: Record "Sales Line";
        Text001: Label 'Veuillez ajouter une ligne de transport';
        Text002: Label 'Pour les enlèvements, la ligne de transport est ristournée à 100%';
        Country: Record "Country/Region";
        CompInfo: Record "Company Information";
        Cust: Record Customer;
        Tpt: Record "Shipping Agent";
        items: Record Item;
        PoidsPlastique: Decimal;
        Codes: Record "Code";
        Txt: Text;
        CuProd: Codeunit "Integration Tft and Prod";
        BOMH: Record "Production BOM Header";
        SalesH: Record "Sales Header";
    begin

        SalesH.Reset;
        SalesH.SetFilter("No.", '<>%1', SalesHeader."No.");
        SalesH.SetRange("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
        SalesH.SetRange("External Document No.", SalesHeader."External Document No.");
        SalesH.SetRange("Order type", SalesHeader."Order type");
        if SalesH.FindFirst then Error('Il existe déjà une autre commande avec ce n° de commande client.');


        if SalesHeader."Location Code" = 'RD' then begin
            emailmsg.Create('PaulineClerbout@europacuisson.com', 'Demande echantillon', UserId + ' a introduit la demande ' + SalesHeader."No.", true);
            // emailsend.Send(emailmsg,enum::"Email Scenario"::Default);
        end;
        //>> ABC(OLL) - 17/07/2017
        if SalesHeader."Document Type" <> SalesHeader."Document Type"::"Return Order" then begin
            if SalesHeader."Document Type" <> SalesHeader."Document Type"::"Credit Memo" then
                SalesPriceMgt.UpdateSalesLinePrice(SalesHeader);
            SalesPriceMgt.TestSalesLinePrice(SalesHeader);
        end;
        //<<


        //IF NOT Country.IsEUCountry(SalesHeader."Ship-to Country/Region Code") THEN
        if (Country.Get(SalesHeader."Ship-to Country/Region Code") and (Country.Code = 'GB') and (SalesHeader."Document Type" = SalesHeader."Document Type"::Order)) then begin
            Txt := UserId + ' a introduit la commande ' + SalesHeader."No." + ' pour ' + SalesHeader."Sell-to Customer Name" + '</BR>';
            Txt += 'Départ demandé ' + Format(SalesHeader."Requested Delivery Date") + '</BR>';
            lSalesLine.Reset;
            lSalesLine.SetRange("Document Type", SalesHeader."Document Type");
            lSalesLine.SetRange("Document No.", SalesHeader."No.");
            lSalesLine.SetRange(Type, lSalesLine.Type::Item);
            lSalesLine.SetFilter("No.", '1-*');
            if lSalesLine.FindSet then
                repeat
                    items.Get(lSalesLine."No.");
                    if items."Production BOM No." <> '' then begin
                        BOMH.Get(items."Production BOM No.");
                        Txt += Format(lSalesLine."Qty. to Ship (Base)") + '  Kg de ' + lSalesLine."No." + '   MP : ' + CuProd.GetFirstMP(BOMH, '') + '</BR>';
                    end;
                until lSalesLine.Next = 0;
            emailmsg.Create('g.dangremont@europacuisson.com;sales-export@europacuisson.com;Cherazade.Mazari@europacuisson.com', 'Commande GB', Txt, true);
            //smtp.CreateMessage('Commande GB','xerox@europacuisson.com','g.dangremont@europacuisson.com','Commande GB',Txt,TRUE);
            //  emailsend.Send(emailmsg,enum::"Email Scenario"::Default);
            if SalesHeader."Shipping Agent Code" <> 'ENL' then begin
                SalesHeader."Transaction Specification" := 'DAP';
                SalesHeader.Modify;
            end;
            CompInfo.Get();
            Cust.Get(SalesHeader."Sell-to Customer No.");
            if lSalesLine.Get(SalesHeader."Document Type", SalesHeader."No.", 40) then
                lSalesLine.Delete;
            lSalesLine.Init;
            lSalesLine.Validate("Document Type", lSalesLine."Document Type"::Order);
            lSalesLine.Validate("Document No.", SalesHeader."No.");
            lSalesLine."Line No." := 40;
            lSalesLine.Validate("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
            lSalesLine.Type := lSalesLine.Type::" ";
            if Cust."N° EORI" <> '' then
                lSalesLine.Description := 'Eori exporter : ' + DelChr(CompInfo."VAT Registration No.", '=', ' .,') + ' - importer : ' + Cust."N° EORI"
            else
                lSalesLine.Description := 'Eori exporter : ' + DelChr(CompInfo."VAT Registration No.", '=', ' .,') + ' - importer : ' + Cust."VAT Registration No.";
            if lSalesLine.Insert(true) then;

            if lSalesLine.Get(SalesHeader."Document Type", SalesHeader."No.", 41) then
                lSalesLine.Delete;
            lSalesLine.Init;
            lSalesLine.Validate("Document Type", lSalesLine."Document Type"::Order);
            lSalesLine.Validate("Document No.", SalesHeader."No.");
            lSalesLine."Line No." := 41;
            lSalesLine.Validate("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
            lSalesLine.Type := lSalesLine.Type::" ";
            lSalesLine.Description := 'Incoterms : ' + SalesHeader."Transaction Specification";
            if CopyStr(SalesHeader."Transaction Specification", 1, 1) = 'D' then
                lSalesLine.Description += '  ' + SalesHeader."Ship-to Country/Region Code" + ' - ' + SalesHeader."Ship-to City";
            if lSalesLine.Insert(true) then;

            if SalesHeader."Shipping Agent Code" <> 'ENL' then begin
                Tpt.Get(SalesHeader."Shipping Agent Code");
                if lSalesLine.Get(SalesHeader."Document Type", SalesHeader."No.", 42) then
                    lSalesLine.Delete;
                lSalesLine.Init;
                lSalesLine.Validate("Document Type", lSalesLine."Document Type"::Order);
                lSalesLine.Validate("Document No.", SalesHeader."No.");
                lSalesLine."Line No." := 42;
                lSalesLine.Validate("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
                lSalesLine.Type := lSalesLine.Type::" ";
                lSalesLine.Description := 'Haulier : ' + Tpt.Name;
                if lSalesLine.Insert(true) then;
            end;
            //IF SalesHeader."Sell-to Country/Region Code" = 'GB' THEN
            //BEGIN
            if lSalesLine.Get(SalesHeader."Document Type", SalesHeader."No.", 45) then
                lSalesLine.Delete;
            lSalesLine.Init;
            lSalesLine.Validate("Document Type", lSalesLine."Document Type"::Order);
            lSalesLine.Validate("Document No.", SalesHeader."No.");
            lSalesLine."Line No." := 45;
            lSalesLine.Validate("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
            lSalesLine.Type := lSalesLine.Type::" ";
            lSalesLine.Description := 'The exporter of the products covered by this';
            if lSalesLine.Insert(true) then;
            if lSalesLine.Get(SalesHeader."Document Type", SalesHeader."No.", 46) then
                lSalesLine.Delete;
            lSalesLine.Init;
            lSalesLine.Validate("Document Type", lSalesLine."Document Type"::Order);
            lSalesLine.Validate("Document No.", SalesHeader."No.");
            lSalesLine."Line No." := 46;
            lSalesLine.Validate("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
            lSalesLine.Type := lSalesLine.Type::" ";
            lSalesLine.Description := 'document - BEREXBE0441357423 - declares ';
            if lSalesLine.Insert(true) then;
            if lSalesLine.Get(SalesHeader."Document Type", SalesHeader."No.", 47) then
                lSalesLine.Delete;
            lSalesLine.Init;
            lSalesLine.Validate("Document Type", lSalesLine."Document Type"::Order);
            lSalesLine.Validate("Document No.", SalesHeader."No.");
            lSalesLine."Line No." := 47;
            lSalesLine.Validate("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
            lSalesLine.Type := lSalesLine.Type::" ";
            lSalesLine.Description := 'that,except where otherwise clearly indicated,';
            if lSalesLine.Insert(true) then;
            lSalesLine.Init;
            lSalesLine.Validate("Document Type", lSalesLine."Document Type"::Order);
            lSalesLine.Validate("Document No.", SalesHeader."No.");
            lSalesLine."Line No." := 48;
            lSalesLine.Validate("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
            lSalesLine.Type := lSalesLine.Type::" ";
            lSalesLine.Description := 'these products are of EU preferential origin.';
            if lSalesLine.Insert(true) then;
            if lSalesLine.Get(SalesHeader."Document Type", SalesHeader."No.", 49) then
                lSalesLine.Delete;

            // END;

            lSalesLine.Reset;
            lSalesLine.SetRange("Document Type", lSalesLine."Document Type"::Order);
            lSalesLine.SetRange("Document No.", SalesHeader."No.");
            lSalesLine.SetRange(Type, lSalesLine.Type::Item);
            lSalesLine.SetFilter("No.", '<>1-DIV*');
            if lSalesLine.FindSet then
                repeat
                    if not IsGB(lSalesLine."No.") then
                        Error('Article non prévu pour GB : ' + lSalesLine."No.");
                until lSalesLine.Next = 0;

        end;

        if (Country.Get(SalesHeader."Ship-to Country/Region Code") and (Country.Code = 'ES') and (SalesHeader."Document Type" = SalesHeader."Document Type"::Order)) then begin
            PoidsPlastique := 0;
            lSalesLine.Reset;
            lSalesLine.SetRange("Document Type", lSalesLine."Document Type"::Order);
            lSalesLine.SetRange("Document No.", SalesHeader."No.");
            lSalesLine.SetRange(Type, lSalesLine.Type::Item);
            lSalesLine.SetFilter("No.", '<>1-DIV*');
            if lSalesLine.FindSet then
                repeat
                    if items.Get(lSalesLine."No.") then
                        if Codes.Get(27, 8001305, items."Criteria 5") then
                            PoidsPlastique += lSalesLine."Quantity (Base)" * Codes."Plastique non recyclable";
                until lSalesLine.Next = 0;
            if PoidsPlastique > 0 then begin
                if lSalesLine.Get(SalesHeader."Document Type", SalesHeader."No.", 51) then
                    lSalesLine.Delete;

                lSalesLine.Init;
                lSalesLine.Validate("Document Type", lSalesLine."Document Type"::Order);
                lSalesLine.Validate("Document No.", SalesHeader."No.");
                lSalesLine."Line No." := 51;
                lSalesLine.Validate("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
                lSalesLine.Type := lSalesLine.Type::" ";
                lSalesLine.Description := 'Non resusable plastic : ' + Format(PoidsPlastique / 1000) + ' Kgs';
                if lSalesLine.Insert(true) then;
            end;
        end;

        Cust.Get(SalesHeader."Sell-to Customer No.");
        //IF SalesHeader."Document Type" = SalesHeader."Document Type"::Order THEN
        // IF (Cust."Customer Price Group" = 'FF') AND (SalesHeader."Location Code" = 'ECCONGEL') AND (SalesHeader."Shipping Agent Code" <> 'ENL') THEN
        //    ERROR('Les commandes FF congelé doivent être en enlèvement');

        if ((SalesHeader."Location Code" <> 'RD') and (SalesHeader."Location Code" <> 'ARYZTA') and (SalesHeader."Location Code" <> 'LEVANTE') and (SalesHeader."Location Code" <> 'DIPER')) then begin
            if (SalesHeader."Order type" = SalesHeader."Order type"::Frais) and (SalesHeader."Location Code" <> 'EC TOURNAI') then
                Error('Le magasin ne correspond pas');
            if (SalesHeader."Order type" = SalesHeader."Order type"::"Surgelé") and (SalesHeader."Location Code" <> 'ECCONGEL') then
                Error('Le magasin ne correspond pas');
        end;
        lSalesLine.Reset;
        lSalesLine.SetRange("Document Type", SalesHeader."Document Type");
        lSalesLine.SetRange("Document No.", SalesHeader."No.");
        lSalesLine.SetRange(Type, lSalesLine.Type::Item);
        lSalesLine.SetFilter("Location Code", '<>''''&<>RD');
        if lSalesLine.FindSet then
            repeat
                if (lSalesLine."Location Code" <> SalesHeader."Location Code") and (SalesHeader."Location Code" <> 'RD') then
                    Error('Les magasins ne correspondent pas');
                items.Get(lSalesLine."No.");
                if items."Delai production" > 0 then
                    if CalcDate('<+' + Format(items."Delai production") + 'D>', Today) > SalesHeader."Requested Delivery Date" then
                        Message('Delai de production non respecté : %2  %1', items."No.", CalcDate('<+' + Format(items."Delai production") + 'D>', Today));
                if (items."Quantité minimum vente" <> 0) and (items."Quantité minimum vente" > lSalesLine."Quantity (Base)") then
                    Message('La quantité minimum pour une commande n''est pas respectée');

            until lSalesLine.Next = 0;

        if (Country.Get(SalesHeader."Ship-to Country/Region Code") and (Country.Code = 'BE') and (SalesHeader."Document Type" = SalesHeader."Document Type"::Order)) then begin
            if Cust."EInvoice EAS" = '' then begin
                Message('Le client n''a pas encore communiqué son identifiant Peppol');
                emailmsg.Create('g.dangremont@europacuisson.com', 'Peppol', SalesHeader."No.", true);
                emailsend.Send(emailmsg, enum::"Email Scenario"::Default);
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterAssignFieldsForNo', '', false, false)]
    local procedure T37_OnmodifItem(var SalesLine: Record "Sales Line"; var xSalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    var
        lSalesLine: Record "Sales Line";
        BomL: Record "Production BOM Line";
        rItem: Record Item;
        VersionMgt: Codeunit VersionManagement;
    begin
        if (SalesLine.Type = SalesLine.Type::Item) and (SalesLine."Document Type" = SalesLine."Document Type"::Order) then begin
            if Items.Get(SalesLine."No.") then
                SalesLine."Poids par palette" := Items.PoidsPalette;
            if rItem.Get(SalesLine."No.") then begin
                BomL.Reset;
                BomL.SetRange("Production BOM No.", rItem."Production BOM No.");
                BomL.SetRange("Version Code", VersionMgt.GetBOMVersion(rItem."Production BOM No.", Today, true));
                BomL.SetFilter("No.", '5-F*');
                if BomL.FindSet then
                    repeat
                        SalesLine.Intermediaire5 := BomL."No.";
                    until BomL.Next = 0;
            end;
            GetItemConditionnement(SalesLine);
        end;
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'Prix unitaire départ', false, false)]
    local procedure T37_OnmodifPxDepart(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        if (Rec.Type = Rec.Type::Item) and (Rec."Document Type" = Rec."Document Type"::Quote) then
            Rec."Unit Price" := Rec."Prix unitaire départ" + Rec."Transport Unit Price";
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'Transport Unit Price', false, false)]
    local procedure T37_OnmodifPxTpt(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        if (Rec.Type = Rec.Type::Item) and (Rec."Document Type" = Rec."Document Type"::Quote) then
            Rec."Unit Price" := Rec."Prix unitaire départ" + Rec."Transport Unit Price";
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnBeforeSetSecurityFilterOnRespCenter', '', false, false)]
    local procedure T36_Filter(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    var
        UserMgt: Codeunit "User Setup Management";
    begin

        if UserMgt.GetRespCenter(0, '') <> '' then begin
            SalesHeader.FilterGroup(2);
            SalesHeader.SetFilter("Salesperson Code", UserMgt.GetRespCenter(0, ''));
            SalesHeader.FilterGroup(0);
            IsHandled := true;
        end;
    end;

    local procedure CheckTarifDepart(SalesHeader: Record "Sales Header"; IsEqual: Boolean)
    var
        lSalesLine: Record "Sales Line";
        RecSalesPrice: Record "Sales PriceEC";
        Cust: Record Customer;
        Text001: Label 'Pas de tarif trouvé';
        Text002: Label 'Si le transport n''est aps facturé, le prix départ doit être inférieur au prix facturé.';
        Text003: Label 'Si le transport est facturé séparément, le prix départ doit être identique au prix facturé.';
    begin
        lSalesLine.Reset;
        lSalesLine.SetRange("Document Type", SalesHeader."Document Type");
        lSalesLine.SetRange("Document No.", SalesHeader."No.");
        lSalesLine.SetRange("Transport line", false);
        lSalesLine.SetRange(Type, lSalesLine.Type::Item);
        if lSalesLine.FindSet then
            repeat
                RecSalesPrice.Reset;
                RecSalesPrice.SetRange(RecSalesPrice."Item No.", lSalesLine."No.");
                RecSalesPrice.SetRange(RecSalesPrice."Sales Type", RecSalesPrice."Sales Type"::Customer);
                RecSalesPrice.SetRange(RecSalesPrice."Sales Code", SalesHeader."Sell-to Customer No.");
                RecSalesPrice.SetFilter(RecSalesPrice."Starting Date", '<=%1', SalesHeader."Posting Date");
                RecSalesPrice.SetFilter(RecSalesPrice."Ending Date", '>=%1', SalesHeader."Posting Date");
                if not RecSalesPrice.FindLast then begin
                    Cust.Get(SalesHeader."Sell-to Customer No.");
                    RecSalesPrice.SetRange(RecSalesPrice."Sales Type", RecSalesPrice."Sales Type"::"Customer Price Group");
                    RecSalesPrice.SetRange(RecSalesPrice."Sales Code", Cust."Customer Price Group");
                end;
                if not RecSalesPrice.FindLast then
                    Error(Text001);
                if IsEqual and (RecSalesPrice."Unit Price" <> RecSalesPrice."Unit Start Price") then
                    Error(Text003);
                if not IsEqual and (RecSalesPrice."Unit Price" <= RecSalesPrice."Unit Start Price") then
                    Error(Text002);
                lSalesLine."Px 3x Net" := RecSalesPrice."Prix 3x Net";
                lSalesLine."Px Depart" := RecSalesPrice."Unit Start Price";
                lSalesLine.Modify;
            until lSalesLine.Next = 0
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterValidateEvent', 'Shipping Agent Code', false, false)]
    local procedure T36_onModifTransporteur(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        lSalesLine: Record "Sales Line";
    begin

        Rec.TestStatusOpen();
        if Rec."Shipping Agent Code" = 'ENL' then begin
            lSalesLine.Reset;
            lSalesLine.SetRange("Document Type", Rec."Document Type");
            lSalesLine.SetRange("Document No.", Rec."No.");
            lSalesLine.SetRange("Transport line", true);
            lSalesLine.SetRange("Free Line", false);
            lSalesLine.SetRange(lSalesLine.Consign, false);
            if not lSalesLine.FindFirst then begin
                if Rec."Transport resource" = '' then
                    Rec."Transport resource" := 'TRFRAIS';
                AddTransportLine(Rec);
            end;
            lSalesLine.Reset;
            lSalesLine.SetRange("Document Type", Rec."Document Type");
            lSalesLine.SetRange("Document No.", Rec."No.");
            lSalesLine.SetRange("Transport line", true);
            lSalesLine.SetRange("Free Line", false);
            lSalesLine.SetRange(lSalesLine.Consign, false);
            if lSalesLine.FindFirst then begin
                lSalesLine.Validate("Line Discount %", 100);
                lSalesLine.Modify;
            end;

        end;
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterValidateEvent', 'Transaction Specification', false, false)]
    local procedure T36_onModifIncoterms(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    begin
        Rec.TestStatusOpen();
    end;

    [Scope('OnPrem')]
    procedure CallPostedItemTrackingDocument(var TempItemLedgEntry: Record "Item Ledger Entry"; DocNum_p: Code[20]; LineNum_p: Integer): Boolean
    var
        ValueEntryRelation: Record "Value Entry Relation";
        ValueEntry: Record "Value Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
        SignFactor: Integer;
        InvoiceRowID: Text[100];
        IntNbr: Integer;
        cu6500: Codeunit "Item Tracking Management";
    begin
        //--> LOG-002 ABSYS GN 20070105
        //-- Permet de retrouver les informations lot lors de l'impression des factures --

        InvoiceRowID := cu6500.ComposeRowID(DATABASE::"Sales Invoice Line", 0, DocNum_p, '', 0, LineNum_p);
        ValueEntryRelation.SetCurrentKey("Source RowId");
        ValueEntryRelation.SetRange("Source RowId", InvoiceRowID);
        if ValueEntryRelation.Find('-') then begin
            //SignFactor := cu6500.TableSignFactor2(InvoiceRowID);
            repeat
                ValueEntry.Get(ValueEntryRelation."Value Entry No.");
                ItemLedgEntry.Get(ValueEntry."Item Ledger Entry No.");
                TempItemLedgEntry := ItemLedgEntry;
                TempItemLedgEntry.Quantity := ValueEntry."Invoiced Quantity";
                if TempItemLedgEntry.Quantity <> 0 then
                    AddTempRecordToSet(TempItemLedgEntry, -1);
            until ValueEntryRelation.Next = 0;
            exit(true);
        end else
            exit(false);

        //<-- LOG-002 ABSYS GN 20070105
    end;

    local procedure AddTempRecordToSet(var TempItemLedgEntry: Record "Item Ledger Entry" temporary; SignFactor: Integer)
    var
        TempItemLedgEntry2: Record "Item Ledger Entry" temporary;
    begin
        if SignFactor <> 1 then begin
            TempItemLedgEntry.Quantity *= SignFactor;
            TempItemLedgEntry."Remaining Quantity" *= SignFactor;
            TempItemLedgEntry."Invoiced Quantity" *= SignFactor;
        end;

        TempItemLedgEntry2 := TempItemLedgEntry;
        TempItemLedgEntry.Reset;
        TempItemLedgEntry.SetRange("Serial No.", TempItemLedgEntry2."Serial No.");
        TempItemLedgEntry.SetRange("Lot No.", TempItemLedgEntry2."Lot No.");
        TempItemLedgEntry.SetRange("Warranty Date", TempItemLedgEntry2."Warranty Date");
        TempItemLedgEntry.SetRange("Expiration Date", TempItemLedgEntry2."Expiration Date");
        if TempItemLedgEntry.FindFirst then begin
            TempItemLedgEntry.Quantity += TempItemLedgEntry2.Quantity;
            TempItemLedgEntry."Remaining Quantity" += TempItemLedgEntry2."Remaining Quantity";
            TempItemLedgEntry."Invoiced Quantity" += TempItemLedgEntry2."Invoiced Quantity";
            TempItemLedgEntry.Modify;
        end else begin
            TempItemLedgEntry.Insert;
        end;
        TempItemLedgEntry.Reset;
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnBeforeUpdateSalesLinesByFieldNo', '', false, false)]
    local procedure T36_OnUpdateField(var SalesHeader: Record "Sales Header"; ChangedFieldNo: Integer; var AskQuestion: Boolean; var IsHandled: Boolean)
    begin
        AskQuestion := false;
    end;

    [Scope('OnPrem')]
    procedure AddDefaultSalesLines(SalesLine: Record "Sales Line"): Boolean
    var
        lSalesLine: Record "Sales Line";
        Ins: Boolean;
        Items: Record Item;
        SalesH: Record "Sales Header";
        Cust: Record Customer;
        ShipAdr: Record "Ship-to Address";
        Flag_Contraload: Boolean;
    begin
        Ins := false;
        SalesH.Get(SalesLine."Document Type", SalesLine."Document No.");
        if SalesH."Ship-to Code" = '' then begin
            Cust.Get(SalesH."Sell-to Customer No.");
            Flag_Contraload := Cust."ID Contraload" <> '';
        end
        else begin
            ShipAdr.Get(SalesH."Sell-to Customer No.", SalesH."Ship-to Code");
            Flag_Contraload := ShipAdr."ID Contraload" <> '';
        end;


        if (SalesLine.Type = SalesLine.Type::Item) and (SalesLine."Document Type" = SalesLine."Document Type"::Order) then begin
            if StrPos(SalesLine."Description 2", 'EPS 24') > 0 then begin
                lSalesLine.Init;
                lSalesLine.Validate("Document Type", lSalesLine."Document Type"::Order);
                lSalesLine.Validate("Document No.", SalesLine."Document No.");
                lSalesLine."Line No." := 100;
                lSalesLine.Validate("Sell-to Customer No.", SalesLine."Sell-to Customer No.");
                lSalesLine.Type := lSalesLine.Type::Item;
                lSalesLine.Validate("No.", '9-VID-00002');
                lSalesLine.Validate(Quantity, 0);
                if lSalesLine.Insert(true) then;
                Ins := true;
            end;
            if ((StrPos(SalesLine."Description 2", 'Smart box') > 0) or (StrPos(SalesLine."Description 2", 'Smartbox') > 0) and Flag_Contraload) then begin
                lSalesLine.Init;
                lSalesLine.Validate("Document Type", lSalesLine."Document Type"::Order);
                lSalesLine.Validate("Document No.", SalesLine."Document No.");
                lSalesLine."Line No." := 300;
                lSalesLine.Validate("Sell-to Customer No.", SalesLine."Sell-to Customer No.");
                lSalesLine.Type := lSalesLine.Type::Item;
                if (StrPos(SalesLine."Description 2", 'Magnum') > 0) then
                    lSalesLine.Validate("No.", '9-VID-00023')
                else
                    lSalesLine.Validate("No.", '9-VID-00015');
                lSalesLine.Validate(Quantity, 0);
                if lSalesLine.Insert(true) then;
                Ins := true;
            end;
            if Items.Get(SalesLine."No.") then
                if ((StrPos(Items.TypePalette, 'CONTRALOAD') > 0) and (Flag_Contraload)) then begin
                    lSalesLine.Init;
                    lSalesLine.Validate("Document Type", lSalesLine."Document Type"::Order);
                    lSalesLine.Validate("Document No.", SalesLine."Document No.");
                    lSalesLine."Line No." := 200;
                    lSalesLine.Validate("Sell-to Customer No.", SalesLine."Sell-to Customer No.");
                    lSalesLine.Type := lSalesLine.Type::Item;
                    lSalesLine.Validate("No.", '9-VID-00021');
                    lSalesLine.Validate(Quantity, 0);
                    if lSalesLine.Insert(true) then;
                    Ins := true;
                end;
            if StrPos(UpperCase(SalesLine."Description 2"), 'BAC VERT136') > 0 then begin
                lSalesLine.Init;
                lSalesLine.Validate("Document Type", lSalesLine."Document Type"::Order);
                lSalesLine.Validate("Document No.", SalesLine."Document No.");
                lSalesLine."Line No." := 400;
                lSalesLine.Validate("Sell-to Customer No.", SalesLine."Sell-to Customer No.");
                lSalesLine.Type := lSalesLine.Type::Item;
                lSalesLine.Validate("No.", '9-VID-00022');
                lSalesLine.Validate(Quantity, 0);
                if lSalesLine.Insert(true) then;
                Ins := true;
            end;


            if StrPos(SalesLine."Description 2", 'BX pal indus Plast 55x10kg IND') > 0 then begin
                lSalesLine.Init;
                lSalesLine.Validate("Document Type", lSalesLine."Document Type"::Order);
                lSalesLine.Validate("Document No.", SalesLine."Document No.");
                lSalesLine."Line No." := 410;
                lSalesLine.Validate("Sell-to Customer No.", SalesLine."Sell-to Customer No.");
                lSalesLine.Type := lSalesLine.Type::Item;
                lSalesLine.Validate("No.", '9-VID-00019');
                lSalesLine.Validate(Quantity, 0);
                //    IF lSalesLine.INSERT(TRUE) THEN;
                //DG 130824 SalesBE
                Ins := true;
            end;
            if (StrPos(UpperCase(SalesLine."Description 2"), 'VERT246') > 0) or (StrPos(UpperCase(SalesLine."Description 2"), 'VERT 246') > 0) then begin
                lSalesLine.Init;
                lSalesLine.Validate("Document Type", lSalesLine."Document Type"::Order);
                lSalesLine.Validate("Document No.", SalesLine."Document No.");
                lSalesLine."Line No." := 415;
                lSalesLine.Validate("Sell-to Customer No.", SalesLine."Sell-to Customer No.");
                lSalesLine.Type := lSalesLine.Type::Item;
                lSalesLine.Validate("No.", '9-VID-00024');
                lSalesLine.Validate(Quantity, 0);
                if lSalesLine.Insert(true) then;
                Ins := true;
            end;

        end;

        exit(Ins);
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnBeforeOpenItemTrackingLines', '', false, false)]
    local procedure T37OnBeforeOpenTrackingLines(SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    var
        SalesH: Record "Sales Header";
    begin
        if SalesH.Get(SalesLine."Document Type", SalesLine."Document No.") then
            if SalesH."Blocage des lots" then
                Error(Text001);
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterValidateEvent', 'Blocage des lots', false, false)]
    local procedure T36OnChangeBlocageLots(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    begin
        if Rec."Blocage des lots" <> xRec."Blocage des lots" then
            if not cuUtils.IsInGroup('LOT-UNBLOCK') then
                Error(Text002);
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterCopyFromItem', '', false, false)]
    local procedure T37OnCopyFromItem(var SalesLine: Record "Sales Line"; Item: Record Item)
    var
        Translate: Record "Item Translation";
        SalesH: Record "Sales Header";
    begin
        /*
        IF Translate.GET(SalesLine."No.",'','FR') THEN
            SalesLine.Description := Translate.Description;
        IF SalesH.GET(SalesH."Document Type"::Order,SalesLine."Document No.") THEN
          IF SalesH."Language Code" <> '' THEN
            IF Translate.GET(SalesLine."No.",'',SalesH."Language Code") THEN
               SalesLine.Description := Translate.Description;
        */
        GetItemConditionnement(SalesLine);
        if Item.Get(SalesLine."No.") then
            if Item."Default Location Code" <> '' then
                if StrPos(Item."No.", 'IQF') > 0 then
                    SalesLine.Validate("Location Code", 'ECCONGEL')
                else
                    SalesLine.Validate("Location Code", Item."Default Location Code");

    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterValidateEvent', 'Lié avec commande n°', false, false)]
    local procedure T36_LienRD(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        lSalesLine: Record "Sales Line";
    begin
        if Rec."Lié avec commande n°" <> '' then begin
            lSalesLine.Init;
            lSalesLine.Validate("Document Type", lSalesLine."Document Type"::Order);
            lSalesLine.Validate("Document No.", Rec."No.");
            lSalesLine."Line No." := 51;
            lSalesLine.Validate("Sell-to Customer No.", Rec."Sell-to Customer No.");
            lSalesLine.Type := lSalesLine.Type::" ";
            lSalesLine.Validate(Description, 'A mettre sur la commande ' + Rec."Lié avec commande n°");
            if lSalesLine.Insert(true) then;

            lSalesLine.Init;
            lSalesLine.Validate("Document Type", lSalesLine."Document Type"::Order);
            lSalesLine.Validate("Document No.", Rec."Lié avec commande n°");
            lSalesLine."Line No." := 51;
            lSalesLine.Validate("Sell-to Customer No.", Rec."Sell-to Customer No.");
            lSalesLine.Type := lSalesLine.Type::" ";
            lSalesLine.Validate(Description, 'Joindre l''échantillon n° ' + Rec."No.");
            if lSalesLine.Insert(true) then;
        end
        else begin
            lSalesLine.Reset;
            lSalesLine.SetRange("Document Type", lSalesLine."Document Type"::Order);
            lSalesLine.SetRange("Document No.", Rec."No.");
            lSalesLine.SetRange("Line No.", 51);
            if lSalesLine.FindFirst then
                lSalesLine.Delete;
            lSalesLine.Reset;
            lSalesLine.SetRange("Document Type", lSalesLine."Document Type"::Order);
            lSalesLine.SetRange("Document No.", xRec."Lié avec commande n°");
            lSalesLine.SetRange("Line No.", 51);
            if lSalesLine.FindFirst then
                lSalesLine.Delete;
        end;
    end;

    [Scope('OnPrem')]
    procedure GetItemConditionnement(var SalesLine: Record "Sales Line")
    var
        recCodes: Record "Code";
        TranslationMgt: Codeunit "Translation Management";
        recItem: Record Item;
        SalesHeader: Record "Sales Header";
    begin
        if SalesLine.Type = SalesLine.Type::Item then begin
            if recItem.Get(SalesLine."No.") then
                if SalesHeader.Get(SalesHeader."Document Type"::Order, SalesLine."Document No.") then
                    if recCodes.Get(DATABASE::Item, recItem.FieldNo("Criteria 5"), recItem."Criteria 5") then
                        SalesLine."Description 2" := TranslationMgt.GetTranslation(8001400, 0, recItem."Criteria 5", SalesHeader."Language Code", recCodes.Description);
        end;
    end;



    [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'Promised Delivery Date', false, false)]
    local procedure T37_onChangeDtConfirme(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        CuStock: Codeunit "Stock EC";
        Utils: Codeunit Utils;
    begin
        //IF (NOT Utils.IsInGroup('DATEPROD')) AND (Rec."Location Code" IN ['EC TOURNAI','ECCONGEL'])THEN
        //  ERROR('Vous n''êtes pas autorisé à modifier la date de départ confirmée');
        if (Rec.Type = Rec.Type::Item) and (CopyStr(Rec."No.", 1, 5) = '1-IQF') and (Rec."Promised Delivery Date" <> 0D) then
            if CuStock.getStockAtDate(Rec."No.", Rec."Promised Delivery Date") < 0 then
                Error('La quantité en stock + production ne couvre pas la commande : %1', CuStock.getStockAtDate(Rec."No.", Rec."Promised Delivery Date"));
        if (Rec.Type = Rec.Type::Item) and (CopyStr(Rec."No.", 1, 3) = '1-F') and (Rec."Promised Delivery Date" <> 0D) and (Rec."Location Code" <> 'RD') and (CopyStr(Rec."No.", 1, 5) <> '1-FAP') and (CopyStr(Rec."No.", 1, 5) <> '1-FCB') and (Rec."Quantity (Base)" > 0) then
            if Rec."Date de production" = 0D then
                Error('Pas de date de production');
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterValidateEvent', 'Promised Delivery Date', false, false)]
    local procedure T36_OnChangeDtConfirme(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    begin
        if (xRec."Promised Delivery Date" <> 0D) and (Rec."Promised Delivery Date" <> xRec."Promised Delivery Date") then begin
            emailmsg.Create(
           'sales@europacuisson.com;g.dangremont@europacuisson.com', 'Date confirmé modifiée ' + Rec."No.",
           'Date confirmé modifiée ' + Rec."No." + '  ' + Format(xRec."Promised Delivery Date") + ' -> ' + Format(Rec."Promised Delivery Date"), true);
            emailsend.Send(emailmsg, enum::"Email Scenario"::Default);

        end;
    end;

    [Scope('OnPrem')]
    procedure IsEU27(ItemNo: Code[20]): Boolean
    var
        Item: Record Item;
    begin
        if Item.Get(ItemNo) then begin
            if Item."Criteria 4" = '02' then exit(true);
            if Item."Criteria 4" = '08' then exit(true);
            if Item."Criteria 4" = '09' then exit(true);
            if Item."Criteria 4" = '10' then exit(true);
            if Item."Criteria 4" = '11' then exit(true);
            if Item."Criteria 4" = '12' then exit(true);
            if Item."Criteria 4" = '13' then exit(true);
            if Item."Criteria 4" = '14' then exit(true);
            if Item."Criteria 4" = '16' then exit(true);
            if Item."Criteria 4" = '19' then exit(true);
            if Item."Criteria 4" = '20' then exit(true);
            if Item."Criteria 4" = '21' then exit(true);
            if Item."Criteria 4" = '22' then exit(true);
            if Item."Criteria 4" = '26' then exit(true);
            if Item."Criteria 4" = '27' then exit(true);
            if Item."Criteria 4" = '28' then exit(true);
            if Item."Criteria 4" = '29' then exit(true);
            if Item."Criteria 4" = '31' then exit(true);
            if Item."Criteria 4" = '32' then exit(true);

        end;
        exit(false);
    end;

    [Scope('OnPrem')]
    procedure IsGB(ItemNo: Code[20]): Boolean
    var
        Item: Record Item;
    begin
        if Item.Get(ItemNo) then begin
            if Item."Criteria 4" = '38' then exit(true);
            if Item."Criteria 4" = '39' then exit(true);
            if Item."Criteria 4" = '40' then exit(true);

        end;
        exit(false);
    end;




    [EventSubscriber(ObjectType::Table, 18, 'OnAfterValidateEvent', 'Salesperson Code', false, false)]
    local procedure T18_ChangeVendor(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    var
        T36: Record "Sales Header";
        T110: Record "Sales Shipment Header";
        T8001300: Record "Statistic aggregate";
        T5802: Record "Value Entry";
        T112: Record "Sales Invoice Header";
        T7002: Record "Sales PriceEC";
    begin
        T36.Reset;
        T36.SetRange("Sell-to Customer No.", Rec."No.");
        T36.ModifyAll("Salesperson Code", Rec."Salesperson Code");

        T110.Reset;
        T110.SetRange("Sell-to Customer No.", Rec."No.");
        T110.ModifyAll("Salesperson Code", Rec."Salesperson Code");

        T112.Reset;
        T112.SetRange("Sell-to Customer No.", Rec."No.");
        T112.ModifyAll("Salesperson Code", Rec."Salesperson Code");

        T8001300.Reset;
        T8001300.SetRange("Source Type", T8001300."Source Type"::Customer);
        T8001300.SetRange("Source No.", Rec."No.");
        T8001300.ModifyAll("Salespers./Purch. Code", Rec."Salesperson Code");
        T8001300.ModifyAll("Free field 4", Rec."Salesperson Code");

        T5802.Reset;
        T5802.SetRange("Source Type", T5802."Source Type"::Customer);
        T5802.SetRange("Source No.", Rec."No.");
        T5802.ModifyAll("Salespers./Purch. Code", Rec."Salesperson Code");

        T7002.Reset;
        T7002.SetRange(T7002."Sales Code", Rec."No.");
        T7002.ModifyAll("Salesperson Code", Rec."Salesperson Code");
    end;

    [Scope('OnPrem')]
    procedure CheckCreditClient(Cmd: Record "Sales Header"): Boolean
    var
        salesH: Record "Sales Header";
        TotalOnHold: Decimal;
        Cust: Record Customer;
        CreditOK: Boolean;
        CLE: Record "Cust. Ledger Entry";
    begin
        Cust.Get(Cmd."Sell-to Customer No.");


        TotalOnHold := GetEnCours(Cmd."Sell-to Customer No.");


        CreditOK := Cust."Credit Limit (LCY)" >= TotalOnHold;

        CLE.Reset;
        CLE.SetRange("Customer No.", Cmd."Sell-to Customer No.");
        CLE.SetRange(Open, true);
        CLE.SetFilter("Remaining Amount", '>0');
        if CLE.FindSet then
            repeat
                if CLE."Due Date" < CalcDate('<-23D>', Today) then
                    CreditOK := false;
            until CLE.Next = 0;

        exit(CreditOK);
    end;

    [Scope('OnPrem')]
    procedure GetEnCours(CustNo: Code[20]): Decimal
    var
        salesH: Record "Sales Header";
        TotalOnHold: Decimal;
        Cust: Record Customer;
    begin
        Cust.Get(CustNo);
        Cust.CalcFields("Balance (LCY)");
        TotalOnHold := Cust."Balance (LCY)";
        salesH.Reset;
        salesH.SetRange(Status, salesH.Status::Released);
        salesH.SetRange("Sell-to Customer No.", CustNo);
        salesH.SetRange("Commande bloquee", false);
        if salesH.FindSet then
            repeat
                salesH.CalcFields(Amount);
                TotalOnHold += salesH.Amount;
            until salesH.Next = 0;

        exit(TotalOnHold);
    end;


    [EventSubscriber(ObjectType::Table, 50008, 'OnBeforeValidateEvent', 'Sales Code', false, false)]
    local procedure T50008_OnValidateSalescode(var Rec: Record "Sales Line DiscountEC"; var xRec: Record "Sales Line DiscountEC"; CurrFieldNo: Integer)
    var
        Cust: Record Customer;
        grp: Record "Customer Price Group";
    begin
        if (Rec."Sales Type" = Rec."Sales Type"::Customer) and (Rec."Sales Code" <> '') then
            if Cust.Get(Rec."Sales Code") then
                Rec."Salesperson Code" := Cust."Salesperson Code";
        if (Rec."Sales Type" = Rec."Sales Type"::"Customer Disc. Group") and (Rec."Sales Code" <> '') then
            if grp.Get(Rec."Sales Code") then
                Rec."Salesperson Code" := grp."Salesperson Code";
    end;

    [Scope('OnPrem')]
    procedure CheckCreditClient2(ClientNo: Code[20]) msg: Text
    var
        SalesH: Record "Sales Header";
        Cust: Record Customer;
        NbJechu: Integer;
        Credit: Decimal;
        CLE: Record "Cust. Ledger Entry";
        echuOk: Boolean;
        Previousechu: Boolean;
    begin
        msg := '';
        Cust.Get(ClientNo);
        Cust.CalcFields("Balance (LCY)");
        if (Cust."Limite crédit non dénommée" + Cust."Limite crédit générale" + Cust."Limite crédit additionnelle") > 0 then
            NbJechu := 23
        else
            NbJechu := 0;
        Credit := Cust."Limite crédit interne" + Cust."Limite crédit générale" + Cust."Limite crédit additionnelle" + Cust."Limite crédit non dénommée";
        Credit := Credit - Cust."Balance (LCY)";
        echuOk := true;

        if GetOverdue(ClientNo, NbJechu) > 0 then echuOk := false;

        Previousechu := false;
        SalesH.Reset;
        SalesH.SetRange("Sell-to Customer No.", ClientNo);
        SalesH.SetFilter("Location Code", '<>RD');
        SalesH.SetRange("Document Type", SalesH."Document Type"::Order);
        SalesH.SetFilter("Status credit", '%1|%2', SalesH."Status credit"::"Bloqué - Montants échus", SalesH."Status credit"::"Bloqué - Montants échus précédents");
        if SalesH.FindFirst and (GetOverdue(ClientNo, 0) > 0) then
            Previousechu := true;


        SalesH.Reset;
        SalesH.SetRange("Sell-to Customer No.", ClientNo);
        SalesH.SetFilter("Location Code", '<>RD');
        SalesH.SetRange(Status, SalesH.Status::Released);
        SalesH.SetRange("Document Type", SalesH."Document Type"::Order);
        if SalesH.FindSet then
            repeat
                SalesH.CalcFields(Amount);
                Credit := Credit - SalesH.Amount;
                if (Cust."ByPass Credit chek") or (Cust."Payment Method Code" = '1-LCR') then begin
                    SalesH.Validate("Status credit", SalesH."Status credit"::Ok);
                    SalesH.Modify(false);
                end
                else
                    if (SalesH."Status credit" <> SalesH."Status credit"::"Libéré manuellement") then begin
                        if not echuOk then begin
                            if (SalesH."Status credit" <> SalesH."Status credit"::"Bloqué - Montants échus") then msg += SalesH."Sell-to Country/Region Code" + ' ' + SalesH."No." + ' ' + SalesH."Sell-to Customer Name" + ' : ' + Format(SalesH."Status credit") + ' -> ' + Format(SalesH."Status credit"::"Bloqué - Montants échus") + '</BR>';
                            SalesH.Validate("Status credit", SalesH."Status credit"::"Bloqué - Montants échus");
                            SalesH.Modify(false);
                        end
                        else begin
                            if Credit < 0 then begin
                                if (SalesH."Status credit" <> SalesH."Status credit"::"Bloqué - credit dépassé") then msg += SalesH."Sell-to Country/Region Code" + ' ' + SalesH."No." + ' ' + SalesH."Sell-to Customer Name" + ' : ' + Format(SalesH."Status credit") + ' -> ' + Format(SalesH."Status credit"::"Bloqué - credit dépassé") + '</BR>';
                                SalesH.Validate("Status credit", SalesH."Status credit"::"Bloqué - credit dépassé");
                                SalesH.Modify(false);
                            end
                            else begin
                                if Previousechu then begin
                                    if (SalesH."Status credit" <> SalesH."Status credit"::"Bloqué - Montants échus précédents") then msg += SalesH."Sell-to Country/Region Code" + ' ' + SalesH."No." + ' ' + SalesH."Sell-to Customer Name" + ' : ' + Format(SalesH."Status credit") + ' -> ' + Format(SalesH."Status credit"::"Bloqué - Montants échus précédents") + '</BR>';
                                    SalesH.Validate("Status credit", SalesH."Status credit"::"Bloqué - Montants échus précédents");
                                end
                                else begin
                                    if (SalesH."Status credit" <> SalesH."Status credit"::Ok) then msg += SalesH."Sell-to Country/Region Code" + ' ' + SalesH."No." + ' ' + SalesH."Sell-to Customer Name" + ' : ' + Format(SalesH."Status credit") + ' -> ' + Format(SalesH."Status credit"::Ok) + '</BR>';
                                    SalesH.Validate("Status credit", SalesH."Status credit"::Ok);
                                end;
                                SalesH.Modify(false);
                            end;
                        end;
                    end;
            until SalesH.Next = 0;
    end;

    [Scope('OnPrem')]
    procedure CheckCreditClientAll()
    var
        Cust: Record Customer;
    begin
        Cust.Reset;
        Cust.SetFilter("Outstanding Orders (LCY)", '>0');
        Cust.SetCurrentKey("Country/Region Code");
        if Cust.FindSet then
            repeat
                t := t + CheckCreditClient2(Cust."No.");
            until Cust.Next = 0;

        if t <> '' then begin
            emailmsg.Create('g.dangremont@europacuisson.com;sales-france@europacuisson.com;sales-export@europacuisson.com;sales-benelux@europacuisson.com', 'Blocage commandes', t, true);
            emailsend.Send(emailmsg, Enum::"Email Scenario"::Default);
        end;
    end;

    local procedure GetOverdue(ClientNo: Code[20]; NbDays: Integer): Decimal
    var
        CLE: Record "Cust. Ledger Entry";
        retour: Decimal;
    begin
        retour := 0;
        CLE.Reset;
        CLE.SetRange("Customer No.", ClientNo);
        CLE.SetRange(Open, true);
        CLE.SetFilter("Remaining Amount", '<>0');
        if CLE.FindSet then
            repeat
                CLE.CalcFields("Remaining Amount");
                if CLE."Due Date" < CalcDate('<-' + Format(NbDays) + 'D>', Today) then
                    retour := retour + CLE."Remaining Amount";
            until CLE.Next = 0;

        exit(retour);
    end;

    local procedure GetCreditMessageRelease(SalesH: Record "Sales Header"): Text
    var
        Cust: Record Customer;
        CRLF: Code[10];
        Msg: Text;
    begin
        CRLF[1] := 13;
        CRLF := '</BR>';
        Cust.Get(SalesH."Sell-to Customer No.");
        Cust.CalcFields("Balance (LCY)");
        Cust.CalcFields("Outstanding Orders (LCY)");

        if (SalesH."Document Type" <> SalesH."Document Type"::Order) then exit('');

        if (SalesH."Status credit" = SalesH."Status credit"::Ok) or (SalesH."Status credit" = SalesH."Status credit"::"Libéré manuellement") then begin
            case Cust."Language Code" of
                'FR':
                    begin
                        Msg := 'Cher client,' + CRLF + CRLF;
                        Msg += 'Nous vous remercions de votre commande avec ref. ' + SalesH."External Document No." + ' que nous avons enregistrée.' + CRLF;
                        Msg += 'Dès que possible, nous vous confirmerons la date de livraison.' + CRLF;
                    end;
                'NL':
                    begin
                        Msg := 'Beste klant,' + CRLF + CRLF;
                        Msg += 'Bedankt voor uw bestelling met ref. ' + SalesH."External Document No." + ' die we hebben geregistreerd.' + CRLF;
                        Msg += 'Zo snel mogelijk, kunnen wij de leveringsdatum bevestigen.' + CRLF;
                    end;
                else begin
                    Msg := 'Dear Customer,' + CRLF + CRLF;
                    Msg += 'Thank you for your order with ref. ' + SalesH."External Document No." + ' which we have registered.' + CRLF;
                    Msg += 'When possible, we will confirm the delivery date.' + CRLF;

                end;
            end;
        end
        else begin
            if (SalesH."Status credit" = SalesH."Status credit"::"Bloqué - credit dépassé") then
                Msg := GetCreditMessageOverdue(SalesH)
            else
                Msg := GetCreditMessage30J(SalesH);
        end;

        exit(Msg);
    end;

    local procedure GetCreditMessageOverdue(SalesH: Record "Sales Header"): Text
    var
        Cust: Record Customer;
        CRLF: Code[10];
        Msg: Text;
    begin
        CRLF[1] := 13;
        CRLF := '</BR>';
        Cust.Get(SalesH."Sell-to Customer No.");
        Cust.CalcFields("Balance (LCY)");
        Cust.CalcFields("Outstanding Orders (LCY)");

        if (SalesH."Document Type" <> SalesH."Document Type"::Order) then exit('');


        case Cust."Language Code" of
            'FR':
                begin
                    Msg := 'Cher client,' + CRLF + CRLF;
                    Msg += 'Nous vous remercions de votre commande avec ref. ' + SalesH."External Document No." + ' que nous avons enregistrée.' + CRLF;
                    Msg += 'Dès que le montant de l’encours le permettra, nous pourrons vous confirmer la date de livraison.' + CRLF;
                    Msg += 'Actuellement votre encours vaut ' + Format(Cust."Outstanding Orders (LCY)" + Cust."Balance (LCY)") + ' EUR contre une limite de crédit de ' + Format(Cust."Credit Limit (LCY)") + ' EUR.' + CRLF;
                    Msg += 'Nous vous prions gentiment d’effectuer le paiement des factures ouvertes afin de réduire votre encours en dessous de votre limite de crédit.' + CRLF;
                end;
            'NL':
                begin
                    Msg := 'Beste klant,' + CRLF + CRLF;
                    Msg += 'Bedankt voor uw bestelling met ref. ' + SalesH."External Document No." + ' die we hebben geregistreerd.' + CRLF;
                    Msg += 'Zodra het openstaande bedrag het toelaat, kunnen wij de leveringsdatum bevestigen.' + CRLF;
                    Msg += 'Momenteel is uw openstaande bedrag ' + Format(Cust."Outstanding Orders (LCY)" + Cust."Balance (LCY)") + ' EUR tegen een kredietlimiet van ' + Format(Cust."Credit Limit (LCY)") + ' EUR.' + CRLF;
                    Msg += 'Wij verzoeken u vriendelijk om openstaande facturen te betalen teneinde uw openstaande bedrag onder uw kredietlimiet te brengen.' + CRLF;
                end;
            else begin
                Msg := 'Dear Customer,' + CRLF + CRLF;
                Msg += 'Thank you for your order with ref. ' + SalesH."External Document No." + ' which we have registered.' + CRLF;
                Msg += 'As soon as the outstanding amount allows, we will confirm the delivery date.' + CRLF;
                Msg += 'Currently your outstanding amount is ' + Format(Cust."Outstanding Orders (LCY)" + Cust."Balance (LCY)") + ' EUR against a credit limit of ' + Format(Cust."Credit Limit (LCY)") + ' EUR.' + CRLF;
                Msg += 'We kindly ask you to pay open invoices in order to reduce your outstanding amount below your credit limit.' + CRLF;
            end;
        end;


        exit(Msg);
    end;

    local procedure GetCreditMessage30J(SalesH: Record "Sales Header"): Text
    var
        Cust: Record Customer;
        CRLF: Code[10];
        Msg: Text;
    begin
        Msg := '';
        CRLF[1] := 13;
        CRLF := '</BR>';
        Cust.Get(SalesH."Sell-to Customer No.");
        Cust.CalcFields("Balance (LCY)");
        Cust.CalcFields("Outstanding Orders (LCY)");
        SalesH.CalcFields(Amount);

        if (SalesH."Document Type" <> SalesH."Document Type"::Order) then exit('');

        case Cust."Language Code" of
            'FR':
                begin
                    Msg := 'Cher client,' + CRLF + CRLF;
                    Msg += 'Nous vous remercions de votre commande avec ref. ' + SalesH."External Document No." + CRLF;
                    if (Cust."Limite crédit non dénommée" + Cust."Limite crédit générale" + Cust."Limite crédit additionnelle") > 0 then
                        Msg += 'Nous constatons qu’il y a un retard de paiement d’au moins 23 jours pour certains montants ouverts.' + CRLF
                    else
                        Msg += 'Nous constatons qu’il y a un retard de paiement pour certains montants ouverts.' + CRLF;
                    Msg += 'Dès que vous avez payé les montants échus, nous pourrons vous confirmer la date de livraison.' + CRLF;
                    Msg += 'Veuillez trouver ci-joint les montants échus à payer avec leur échéance';
                end;
            'NL':
                begin
                    Msg := 'Beste klant,' + CRLF + CRLF;
                    Msg += 'Bedankt voor uw bestelling met ref. ' + SalesH."External Document No." + ' die we geregistreerd hebben.' + CRLF;
                    if (Cust."Limite crédit non dénommée" + Cust."Limite crédit générale" + Cust."Limite crédit additionnelle") > 0 then
                        Msg += 'We stellen vast dat er voor bepaalde openstaande bedragen een betalingsachterstand van minimaal 23 dagen is.' + CRLF
                    else
                        Msg += 'We stellen vast dat er voor bepaalde openstaande bedragen een betalingsachterstand is.' + CRLF;
                    Msg += 'Zodra u de verschuldigde bedragen betaald heeft, kunnen wij de leveringsdatum bevestigen.' + CRLF;
                    Msg += 'Hieronder vindt u de te betalen bedragen met hun vervaldatum »' + CRLF;
                end;
            else begin
                Msg := 'Dear customer,' + CRLF + CRLF;
                Msg += 'Thank you for your order with ref. ' + SalesH."External Document No." + ' that we have recorded.' + CRLF;
                if (Cust."Limite crédit non dénommée" + Cust."Limite crédit générale" + Cust."Limite crédit additionnelle") > 0 then
                    Msg += 'We see there is a payment delay of at least 23 days for certain open amounts.' + CRLF
                else
                    Msg += 'We see there is a payment delay for certain open amounts.' + CRLF;
                Msg += 'As soon as you have paid the amounts due, we can confirm the delivery date.' + CRLF;
                Msg += 'Please find attached the amounts due to be paid with their due date.' + CRLF;
            end;
        end;


        exit(Msg);
    end;

    local procedure GetCreditMessageUpdate(SalesH: Record "Sales Header"): Text
    var
        Cust: Record Customer;
        CRLF: Code[10];
        Msg: Text;
    begin
        Msg := '';
        CRLF[1] := 13;
        CRLF := '</BR>';
        Cust.Get(SalesH."Sell-to Customer No.");
        Cust.CalcFields("Balance (LCY)");
        Cust.CalcFields("Outstanding Orders (LCY)");
        SalesH.CalcFields(Amount);

        if (SalesH."Document Type" <> SalesH."Document Type"::Order) then exit('');

        if (SalesH."Status credit" = SalesH."Status credit"::Ok) or (SalesH."Status credit" = SalesH."Status credit"::"Libéré manuellement") then begin

        end
        else begin
            if (SalesH."Status credit" = SalesH."Status credit"::"Bloqué - credit dépassé") then
                Msg := GetCreditMessageOverdue(SalesH)
            else
                Msg := GetCreditMessage30J(SalesH);
        end;

        exit(Msg);
    end;

    [EventSubscriber(ObjectType::Codeunit, 414, 'OnAfterReleaseSalesDoc', '', false, false)]
    local procedure CU414_OnAfterReleaseSalesDoc(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; var LinesWereModified: Boolean)
    var
        salesH: Record "Sales Header";
    begin
        if (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) then begin
            CheckCreditClient2(SalesHeader."Sell-to Customer No.");
            if (SalesHeader."Release Date" = 0DT) and (StrPos(UpperCase(UserId), 'GEOFFREYD') = 0) and (StrPos(UpperCase(UserId), 'GDANGREMONT') = 0) then begin
                salesH.Get(SalesHeader."Document Type", SalesHeader."No.");
                if salesH."Location Code" <> 'RD' then
                    //    SendMessageCreditRelease(salesH);
                    salesH.Get(SalesHeader."Document Type", SalesHeader."No.");
                salesH."Release Date" := CurrentDateTime;
                salesH.Modify(false);
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnBeforeValidateEvent', 'Status credit', false, false)]
    local procedure T18_OnModifCreditStatus(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        CuUtils: Codeunit Utils;
    begin
        if GuiAllowed and (Rec."Status credit" <> xRec."Status credit") then begin
        end;

        if (not GuiAllowed) and (Rec."Status credit" <> xRec."Status credit") and ((xRec."Status credit" = xRec."Status credit"::"Libéré manuellement") or (xRec."Status credit" = xRec."Status credit"::Ok)) then
            SendMessageCreditUpdate(Rec);
    end;

    local procedure SendMessageCreditRelease(SalesH: Record "Sales Header")
    var
        Msg: Text;
        OrderConf: Label 'Order confirmation';
        Cust: Record Customer;
        FileMgt: Codeunit "File Management";
        f: Text;
        Vendor: Record "Salesperson/Purchaser";
        Salarie: Record Employee;
        CuMail: Codeunit Integration_EMail;
        CuUtils: Codeunit Utils;
        subject: Text;
        InS: InStream;
    begin
        Msg := GetCreditMessageRelease(SalesH);
        if Msg <> '' then begin
            Cust.Reset;
            Cust.SetFilter("No.", SalesH."Sell-to Customer No.");
            f := FileMgt.ServerTempFileName('.pdf');
            if Cust.FindFirst then
                Vendor.Get(Cust."Salesperson Code");
            Salarie.Reset;
            Salarie.SetRange("No.", GetReponsableFromSalesH(SalesH));
            if not Salarie.FindFirst then Error('Vendeur non trouvé');

            REPORT.SaveAsPdf(121, f, Cust);
            if Cust."No." = 'C03751' then
                emailmsg.Create(CuMail._GetEMailsRespForEntity(DATABASE::Customer, Cust."No.", 'S02'), GetSubject(Cust) + ' ' + SalesH."No.", '', true)
            else
                emailmsg.Create(CuMail._GetEMailsRespForEntity(DATABASE::Customer, Cust."No.", 'S03'), GetSubject(Cust) + ' ' + SalesH."No.", '', true);
            emailmsg.AppendToBody(Msg);
            emailmsg.AddRecipient(enum::"Email Recipient Type"::Bcc, Salarie."Company E-Mail");
            emailmsg.AppendToBody('</BR>' + CuMail.GetSignatureHTML(SalesH.User));
            if (FILE.Exists(f)) and (Cust."Payment Method Code" <> '1-LCR') then begin
                FileMgt.BLOBImportFromServerFile(TempBlob, f);
                TempBlob.CreateInStream(InS);
                emailmsg.AddAttachment('Credit status.pdf', 'application/pdf', InS);
            end;
            emailsend.Send(emailmsg, GetEMailScenarioForCustomer(SalesH));

        end;
    end;

    local procedure SendMessageCreditUpdate(SalesH: Record "Sales Header")
    var
        Msg: Text;
        Cust: Record Customer;
        FileMgt: Codeunit "File Management";
        f: Text;
        Vendor: Record "Salesperson/Purchaser";
        Salarie: Record Employee;
        CuMail: Codeunit Integration_EMail;
        CuUtils: Codeunit Utils;
        OrderConf: Label 'Order confirmation';
        InS: InStream;
    begin
        Msg := GetCreditMessageUpdate(SalesH);
        if Msg <> '' then begin
            Cust.Reset;
            Cust.SetFilter("No.", SalesH."Sell-to Customer No.");
            f := FileMgt.ServerTempFileName('.pdf');
            if Cust.FindFirst then
                Vendor.Get(Cust."Salesperson Code");
            Salarie.Reset;
            Salarie.SetRange("No.", GetReponsableFromSalesH(SalesH));
            if not Salarie.FindFirst then Error('Vendeur non trouvé');

            REPORT.SaveAsPdf(121, f, Cust);
            emailmsg.Create(CuMail._GetEMailsRespForEntity(DATABASE::Customer, Cust."No.", 'S03'), GetSubject(Cust) + ' ' + SalesH."No.", '', true);
            emailmsg.AppendToBody(Msg);
            emailmsg.AddRecipient(Enum::"Email Recipient Type"::Bcc, Salarie."Company E-Mail");
            //smtp.AddBCC('g.dangremont@europacuisson.com');
            emailmsg.AppendToBody('</BR>' + CuMail.GetSignatureHTML(Salarie.User));
            if (FILE.Exists(f)) and (Cust."Payment Method Code" <> '1-LCR') then begin
                FileMgt.BLOBImportFromServerFile(TempBlob, f);
                TempBlob.CreateInStream(InS);
                emailmsg.AddAttachment('Credit status.pdf', 'application/pdf', InS);
            end;
            emailsend.Send(emailmsg, GetEMailScenarioForCustomer(SalesH));

        end;
    end;

    local procedure GetSubject(Cust: Record Customer): Text
    var
        Msg: Text;
    begin
        case Cust."Language Code" of
            'FR':
                begin
                    Msg := 'Confirmation commande';
                end;
            'NL':
                begin
                    Msg := 'Orderbevestiging';
                end;
            else begin
                Msg := 'Order confirmation';
            end;
        end;
        exit(Msg);
    end;

    [Scope('OnPrem')]
    procedure GetResponsableFromCust(Cust: Record Customer): Code[20]
    var
        SalesP: Record "Salesperson/Purchaser";
        Sal: Record Employee;
    begin
        SalesP.Get(Cust."Salesperson Code");
        if (SalesP.Code = '72') or (SalesP.Code = '74') then begin
            if (Cust."Country/Region Code" = 'FR') then begin
                exit('00110');
            end
            else begin
                if (Cust."Country/Region Code" = 'BE') or (Cust."Country/Region Code" = 'NL') or (Cust."Country/Region Code" = 'LU') then
                    exit('00006')
                else
                    exit('00109');
            end;
        end
        else begin
            exit(SalesP.UserResp);
        end;
    end;

    [Scope('OnPrem')]
    procedure GetReponsableFromSalesH(SalesH: Record "Sales Header"): Code[20]
    var
        Cust: Record Customer;
    begin
        Cust.Get(SalesH."Sell-to Customer No.");
        exit(GetResponsableFromCust(Cust));
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterCheckSellToCust', '', false, false)]
    local procedure T36_OnAfterSellToCust(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header"; Customer: Record Customer)
    var
        lrec_CompanyInfo: Record "Company Information";
        lrec_SalesSetup: Record "Sales & Receivables Setup";
        lrec_AlertMgt: Record "Alert Management";
        lfrm_DisplayAlert: Page "Display Alert";
    begin
        if GuiAllowed then begin
            lrec_CompanyInfo.Get;
            if lrec_CompanyInfo."Use Alert Management" then begin
                lrec_SalesSetup.Get;
                if lrec_SalesSetup."Cust. Alert on Sales Order/Inv" then begin
                    lrec_AlertMgt.SetCurrentKey("Table Name", "No.", "Starting Date", "Ending Date", Active, "Event");
                    lrec_AlertMgt.SetFilter("Table Name", '%1', lrec_AlertMgt."Table Name"::Customer);
                    lrec_AlertMgt.SetFilter("No.", SalesHeader."Sell-to Customer No.");
                    lrec_AlertMgt.SetFilter("Starting Date", '<=%1', WorkDate);
                    lrec_AlertMgt.SetFilter("Ending Date", '>=%1|%2', WorkDate, 0D);
                    lrec_AlertMgt.SetRange(Active, true);
                    lrec_AlertMgt.SetRange("Event", lrec_AlertMgt."Event"::"Customer on Sales Order");
                    if lrec_AlertMgt.Find('-') then begin
                        lfrm_DisplayAlert.SetHeading(StrSubstNo(Text001, SalesHeader."Sell-to Customer No."));
                        lfrm_DisplayAlert.SetTableView(lrec_AlertMgt);
                        //IF lfrm_DisplayAlert.RUNMODAL = ACTION::OK THEN;
                        lfrm_DisplayAlert.Run;
                    end;
                end;
            end;
            if (Customer."VAT Bus. Posting Group" = 'BE') or (Customer."VAT Bus. Posting Group" = 'EU') then
                Customer.TestField("VAT Registration No.");
        end;
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnBeforeCopyShipToCustomerAddressFieldsFromShipToAddr', '', false, false)]
    local procedure T36_OnBeforeCopyShipToAddr(var SalesHeader: Record "Sales Header"; ShipToAddress: Record "Ship-to Address"; var IsHandled: Boolean)
    var
        EMailParam: Record "Email Parameter";
        Contacts: Record Contact;
    begin

        if ShipToAddress."Horaire livraison" <> '' then
            SalesHeader."Horaires de livraison" := ShipToAddress."Horaire livraison";
        SalesHeader."Délai de livraison" := ShipToAddress."Délai de livraison";
        SalesHeader."Commentaire CMR" := ShipToAddress."Commentaire CMR";
        EMailParam.Reset;
        EMailParam.SetRange("Document No", SalesHeader."No.");
        EMailParam.SetRange("Document Type", EMailParam."Document Type"::Order);
        EMailParam.DeleteAll;


        if ShipToAddress."Primary Contact No." <> '' then begin
            if Contacts.Get(ShipToAddress."Primary Contact No.") then begin
                EMailParam.Init;
                EMailParam."Document No" := SalesHeader."No.";
                EMailParam."Document Type" := EMailParam."Document Type"::Order;
                EMailParam."Parameter Type" := EMailParam."Parameter Type"::Address;
                EMailParam."Parameter Value" := Contacts."E-Mail";
                EMailParam.Insert;
            end;
        end;
    end;

    [Scope('OnPrem')]
    procedure ImportXlPrice()
    var
        Prices: Record "Sales PriceEC";
        stream: InStream;
        fromFile: Text;
        Sheet: Text;
        i: Integer;
        n: Integer;
        Sheets: Record "Name/Value Buffer";
    begin
        UploadIntoStream('Veuillez sélectionner le fichier à importer', '', '', fromFile, stream);
        if fromFile <> '' then begin
            //Sheet := Xl.SelectSheetsNameStream(stream);
            Xl.GetSheetsNameListFromStream(stream, Sheets);
            Sheets.FindFirst();
            Sheet := Sheets.Value;
            //'Prix vente';
        end
        else
            Error('Import stoppé');

        Xl.Reset;
        Xl.DeleteAll;
        Xl.OpenBookStream(stream, Sheet);
        Xl.ReadSheet();
        if Xl.FindLast then n := Xl."Row No.";

        for i := 2 to n do begin
            Prices.Reset;
            Prices.Init;
            Evaluate(Prices."Sales Type", GetValueAtCell(i, 10));
            Prices.Validate("Sales Code", GetValueAtCell(i, 11));
            Prices.Validate("Item No.", GetValueAtCell(i, 13));
            Prices.Validate("Unit of Measure Code", GetValueAtCell(i, 15));
            Prices.Validate("Minimum Quantity", GetValueAtCellDec(i, 16));
            Prices.Validate("Unit Price", GetValueAtCellDec(i, 17));
            Evaluate(Prices."Starting Date", GetValueAtCell(i, 18));
            Prices.Validate("Starting Date", Prices."Starting Date");
            Evaluate(Prices."Ending Date", GetValueAtCell(i, 19));
            Prices.Validate("Ending Date", Prices."Ending Date");
            Prices.Validate("Unit Start Price", GetValueAtCellDec(i, 20));
            Prices.Validate("Order Minimum Quantity", GetValueAtCellDec(i, 21));
            Prices.Validate("Order Minimum Palettes", GetValueAtCellDec(i, 22));
            Evaluate(Prices."Base RFA", GetValueAtCell(i, 24));
            Prices.Validate("Base RFA", Prices."Base RFA");
            Prices.Validate("RFA - %", GetValueAtCellDec(i, 25));
            Prices.Validate("RFA - Montant", GetValueAtCellDec(i, 26));
            Prices.Validate("Quantité annuelle base RFA", GetValueAtCellDec(i, 27));
            Evaluate(Prices."Base CC", GetValueAtCell(i, 29));
            Prices.Validate("Base CC", Prices."Base CC");
            Prices.Validate("CC - %", GetValueAtCellDec(i, 30));
            Prices.Validate("CC - Montant", GetValueAtCellDec(i, 31));
            Prices.Validate("Quantité annuelle base CC", GetValueAtCellDec(i, 32));
            Prices.Insert(true);
            Prices.Validate("Unit Price", Prices."Unit Price");
            Prices.Modify(true);
        end;
    end;

    local procedure GetValueAtCell(Row: Integer; Col: Integer): Text
    begin
        Xl.Reset;
        if Xl.Get(Row, Col) then
            exit(Xl."Cell Value as Text")
        else
            exit('');
    end;

    local procedure GetValueAtCellDec(Row: Integer; Col: Integer): Decimal
    var
        tmp: Decimal;
    begin
        tmp := 0;
        Xl.Reset;
        if Xl.Get(Row, Col) then
            Evaluate(tmp, Xl."Cell Value as Text");
        exit(tmp);
    end;

    [EventSubscriber(ObjectType::Table, 18, 'OnAfterValidateEvent', 'Search Name', false, false)]
    local procedure T18_OnValidateSearchName(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    var
        rDimVal: Record "Dimension Value";
        rSalesSetup: Record "Sales & Receivables Setup";
        rDefDim: Record "Default Dimension";
        rSalesHeader: Record "Sales Header";
    begin

        //ADM2.000 ABSYS BT 20061212
        rSalesSetup.Get;
        rDimVal.Reset;
        rDimVal.SetRange("Dimension Code", rSalesSetup."Cust Dimension Code");
        rDimVal.SetRange(Code, Rec."No.");
        if rDimVal.Find('-') then begin
            rDimVal.Name := Rec."Search Name";
            rDimVal.Modify;
        end;
        fct_CustDim(Rec);
        //
    end;

    [Scope('OnPrem')]
    procedure fct_CustDim(Rec: Record Customer)
    var
        rDimVal: Record "Dimension Value";
        rSalesSetup: Record "Sales & Receivables Setup";
        rDefDim: Record "Default Dimension";
        rSalesHeader: Record "Sales Header";
    begin
        //BT.AB6.001 : gestion de l'axe cliente  : par défaut à la création duc client
        rSalesSetup.Get;
        rSalesSetup.TestField("Cust Dimension Code");
        rDimVal.Reset;
        rDimVal.SetRange("Dimension Code", rSalesSetup."Cust Dimension Code");
        rDimVal.SetRange(Code, Rec."No.");
        if not rDimVal.Find('-') then begin
            rDimVal.Reset;
            rDimVal."Dimension Code" := rSalesSetup."Cust Dimension Code";
            rDimVal.Code := Rec."No.";
            rDimVal.Name := Rec."Search Name";
            rDimVal.Insert;
        end;

        rDefDim.Reset;
        rDefDim.SetRange("Table ID", 18);
        rDefDim.SetRange("Dimension Code", rSalesSetup."Cust Dimension Code");
        rDefDim.SetRange("No.", Rec."No.");
        if not rDefDim.Find('-') then begin
            rDefDim.Reset;
            rDefDim."Table ID" := 18;
            rDefDim."Dimension Code" := rSalesSetup."Cust Dimension Code";
            rDefDim."No." := Rec."No.";
            rDefDim."Dimension Value Code" := Rec."No.";
            rDefDim."Value Posting" := rDefDim."Value Posting"::"Code Mandatory";

            rDefDim.Insert;
        end else begin
            if rDefDim."Dimension Value Code" <> Rec."No."
              then begin
                rDefDim."Dimension Value Code" := Rec."No.";
                rDefDim.Modify;
            end;
        end;
        //
    end;

    [EventSubscriber(ObjectType::Table, 18, 'OnAfterValidateEvent', 'Blocked', false, false)]
    local procedure T18_Blocked(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    var
        rSalesHeader: Record "Sales Header";
    begin
        //AB6EB0408.C8
        rSalesHeader.Reset;
        rSalesHeader.SetCurrentKey("Document Type", "Sell-to Customer No.", "No.");
        rSalesHeader.SetRange("Document Type", rSalesHeader."Document Type"::Order);
        rSalesHeader.SetRange("Sell-to Customer No.", Rec."No.");
        if rSalesHeader.Find('-') then
            rSalesHeader.ModifyAll("Customer Shipment Blocked", (Rec.Blocked = Rec.Blocked::Ship));
        //AB6EB0408.C8
    end;

    [EventSubscriber(ObjectType::Table, 18, 'OnAfterInsertEvent', '', false, false)]
    local procedure T18_OnInsert(var Rec: Record Customer; RunTrigger: Boolean)
    var
        UserMgt: Codeunit "User Setup Management";
    begin
        if RunTrigger then begin
            Rec."Responsibility Center" := UserMgt.GetSalesFilter();
            Rec.Modify(false);
            fct_CustDim(Rec);
            ;

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnBeforePostSalesDoc', '', false, false)]
    local procedure CU80_OnBeforePost(var Sender: Codeunit "Sales-Post"; var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var HideProgressWindow: Boolean)
    var
        SalesL: Record "Sales Line";
    begin
        if (SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo") or (SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order") then begin
            SalesHeader.TestField("Reason Code");
            if not cuUtils.IsInGroup('COMPTA-USER') then begin
                SalesL.Reset;
                SalesL.SetRange("Document Type", SalesHeader."Document Type");
                SalesL.SetRange("Document No.", SalesHeader."No.");
                SalesL.SetRange(Type, SalesL.Type::"G/L Account");
                if SalesL.FindFirst then
                    Error('Validation impossible avec un compte comptable');
            end;


        end;
    end;

    [EventSubscriber(ObjectType::Table, 18, 'OnBeforeCheckBlockedCust', '', false, false)]
    local procedure T18_IsOnBeforeCheckBlockedCustHandled(Customer: Record Customer; Source: Option Journal,Document; DocType: Option; Shipment: Boolean; Transaction: Boolean; var IsHandled: Boolean)
    begin
        //IF Customer.Blocked = Customer.Blocked::Ship THEN
        //  IsHandled := TRUE;
        //DG200125  Pq??
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterValidateEvent', 'Sell-to Customer No.', false, false)]
    local procedure T36_SellToCustomer(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        Cust: Record Customer;
        ShptPurchOrder: Record "Shipment Purchase Orders";
        TranspPurchLine: Record "Purchase Line";
        recCountry: Record "Country/Region";
    begin
        if Cust.Get(Rec."Sell-to Customer No.") and (Cust."Default Ship-to Address" <> '') then
            Rec.Validate("Ship-to Code", Cust."Default Ship-to Address")
        else
            Rec.Validate("Ship-to Code", '');

        if ShptPurchOrder.Get(Rec."Shipping Agent Code", Rec."Location Code", Rec."Promised Delivery Date", Rec."No.") then begin
            ShptPurchOrder."Sell-to Customer No." := Rec."Sell-to Customer No.";
            ShptPurchOrder.Modify(true);
        end;
        if Rec."Transport Purchase Order" <> '' then begin
            TranspPurchLine.Reset;
            TranspPurchLine.SetRange("Document Type", TranspPurchLine."Document Type"::Order);
            TranspPurchLine.SetRange("Document No.", Rec."Transport Purchase Order");
            TranspPurchLine.SetRange("Transport Sales Order No", Rec."No.");
            if TranspPurchLine.FindFirst then begin
                TranspPurchLine."Transport Customer No" := Rec."Sell-to Customer No.";
                TranspPurchLine.Modify;
            end;
        end;
        if Cust.Get(Rec."Sell-to Customer No.") then begin
            Rec."Salesperson Code" := Cust."Salesperson Code";
            Rec."Territory Code" := Cust."Territory Code";
            Rec."Logistic unit" := Cust."Logistic unit";
            Rec."Production comment" := Cust."Production comment";
            Rec."Complete Pallet" := Cust."Complete Pallet";
            Rec."Horaires de livraison" := Cust."Schedule of delivery customer";
            if recCountry.Get(Rec."Sell-to Country/Region Code") then
                Rec."Employee BackOffice" := recCountry."Assistant commercial";
            Rec."Customer Shipment Blocked" := (Cust.Blocked = Cust.Blocked::Ship);
        end;
        Rec.Modify;
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterValidateEvent', 'Ship-to Code', false, false)]
    local procedure T36_OnShipTo(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        ShptPurchOrder: Record "Shipment Purchase Orders";
        TranspPurchLine: Record "Purchase Line";
    begin
        if ShptPurchOrder.Get(Rec."Shipping Agent Code", Rec."Location Code", Rec."Promised Delivery Date", Rec."No.") then begin
            ShptPurchOrder."Ship-to Code" := Rec."Ship-to Code";
            ShptPurchOrder.Modify(true);
        end;
        if Rec."Transport Purchase Order" <> '' then begin
            TranspPurchLine.Reset;
            TranspPurchLine.SetRange("Document Type", TranspPurchLine."Document Type"::Order);
            TranspPurchLine.SetRange("Document No.", Rec."Transport Purchase Order");
            TranspPurchLine.SetRange("Transport Sales Order No", Rec."No.");
            if TranspPurchLine.Find('-') then begin
                TranspPurchLine."Transport Ship-to Code" := Rec."Ship-to Code";
                TranspPurchLine.Modify;
            end;
        end;

        if Rec.Modify then;
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterValidateEvent', 'Location Code', false, false)]
    local procedure T36_LocationCode(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        Text50000: Label 'Please delete Purchase Order line %1 linked with Sales Order No %2.';
        ShptPurchOrder: Record "Shipment Purchase Orders";
    begin
        if Rec."Transport Purchase Order" <> '' then
            if not Confirm(StrSubstNo(Text50000, Rec."Transport Purchase Order", Rec."No.")) then
                Error('');
        if ShptPurchOrder.Get(Rec."Shipping Agent Code", xRec."Location Code", Rec."Promised Delivery Date", Rec."No.", '') then
            if ShptPurchOrder.Status < ShptPurchOrder.Status::"validé" then
                ShptPurchOrder.Rename(Rec."Shipping Agent Code", Rec."Location Code", Rec."Promised Delivery Date", Rec."No.", '');
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterValidateEvent', 'External Document No.', false, false)]
    local procedure T36_ExternalDoc(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        SalesHeader: Record "Sales Header";
        SalesShptHeader: Record "Sales Shipment Header";
    begin
        if Rec."External Document No." <> '' then begin
            SalesHeader.Reset;
            SalesHeader.SetRange("External Document No.", Rec."External Document No.");
            SalesHeader.SetRange("Sell-to Customer No.", Rec."Sell-to Customer No.");
            SalesHeader.SetFilter("No.", '<>%1', Rec."No.");
            if SalesHeader.FindFirst then
                Message('Reference déjà utilisée dans %1', SalesHeader."No.");

            SalesShptHeader.Reset;
            SalesShptHeader.SetRange("External Document No.", Rec."External Document No.");
            SalesShptHeader.SetRange("Sell-to Customer No.", Rec."Sell-to Customer No.");
            if SalesShptHeader.FindFirst then
                Message('Reference déjà utilisée dans %1', SalesShptHeader."No.");
        end;
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterValidateEvent', 'Shipping Agent Code', false, false)]
    local procedure T36_ShippingAgent(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        Text50000: Label 'Please delete Purchase Order line %1 linked with Sales Order No %2.';
        ShptPurchOrder: Record "Shipment Purchase Orders";
    begin
        if Rec."Transport Purchase Order" <> '' then
            if not Confirm(StrSubstNo(Text50000, Rec."Transport Purchase Order", Rec."No.")) then
                Error('');
        if ShptPurchOrder.Get(Rec."Shipping Agent Code", xRec."Location Code", Rec."Promised Delivery Date", Rec."No.", '') then
            if ShptPurchOrder.Status < ShptPurchOrder.Status::"validé" then
                ShptPurchOrder.Rename(Rec."Shipping Agent Code", Rec."Location Code", Rec."Promised Delivery Date", Rec."No.", '');
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterValidateEvent', 'Status', false, false)]
    local procedure T36_Status(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    begin
        if Rec."Status" = Rec.Status::Released then begin
            Rec."Validation départ demandé" := CurrentDateTime;
            Rec.Modify;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterValidateEvent', 'Requested Delivery Date', false, false)]
    local procedure T36_RequestedDeliveryDt(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    begin
        Rec."Validation départ demandé" := CurrentDateTime();
        Rec.Modify;
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnBeforeValidateEvent', 'Promised Delivery Date', false, false)]
    local procedure T36_BeforePromisedDt(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        Text50000: Label 'Please delete Purchase Order line %1 linked with Sales Order No %2.';
    begin
        if not ((Rec."Status credit" = Rec."Status credit"::Ok) or (Rec."Status credit" = Rec."Status credit"::"Libéré manuellement")) then
            Error('Pas de confirmation sur une commande bloquée');

        if (Rec.Status = Rec.Status::Released) then begin
            Rec.Reopen := true;
            Rec.Modify;
            ReleaseSalesDoc.Reopen(Rec);
        end;
        if Rec."Transport Purchase Order" <> '' then
            if not Confirm(StrSubstNo(Text50000, Rec."Transport Purchase Order", Rec."No.")) then
                Error('');
        Rec."Validation départ confirmée" := CurrentDateTime;
        if (Rec."Date confirmee initiale" = 0D) then Rec."Date confirmee initiale" := Rec."Promised Delivery Date";
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterValidateEvent', 'Promised Delivery Date', false, false)]
    local procedure T36_AfterPromisedDt(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        ShptPurchOrder: Record "Shipment Purchase Orders";
    begin
        if ShptPurchOrder.Get(Rec."Shipping Agent Code", Rec."Location Code", xRec."Promised Delivery Date", Rec."No.", '') then
            if ShptPurchOrder.Status < ShptPurchOrder.Status::"validé" then
                ShptPurchOrder.Rename(Rec."Shipping Agent Code", Rec."Location Code", Rec."Promised Delivery Date", Rec."No.", '');
        if Rec.Reopen then begin
            Clear(ReleaseSalesDoc);
            Rec.Reopen := false;
            Rec.Modify;
            ReleaseSalesDoc.Run(Rec);
        end;
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterDeleteEvent', '', false, false)]
    local procedure T36_OnDelete(var Rec: Record "Sales Header"; RunTrigger: Boolean)
    var
        ShptPurchOrder: Record "Shipment Purchase Orders";
        TranspPurchLine: Record "Purchase Line";
    begin
        if RunTrigger then begin
            if ShptPurchOrder.Get(Rec."Shipping Agent Code", Rec."Location Code", Rec."Promised Delivery Date", Rec."No.") then
                ShptPurchOrder.Delete;
            if Rec."Transport Purchase Order" <> '' then begin
                TranspPurchLine.Reset;
                TranspPurchLine.SetRange("Document Type", TranspPurchLine."Document Type"::Order);
                TranspPurchLine.SetRange("Document No.", Rec."Transport Purchase Order");
                TranspPurchLine.SetRange("Transport Sales Order No", Rec."No.");
                if TranspPurchLine.Find('-') then begin
                    TranspPurchLine.Delete;
                    emailmsg.Create(
                    'g.dangremont@europacuisson.com;sven@europacuisson.com'
                    , 'Suppression commande vente',
                    UserId + ' a supprimé  ' + Rec."No." + ' sur transport  ' + Rec."Transport Purchase Order", true);
                    //   emailsend.Send(emailmsg,enum::"Email Scenario"::Default);
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterInsertEvent', '', false, false)]
    local procedure T36_onInsert(var Rec: Record "Sales Header"; RunTrigger: Boolean)
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.Get;
        Rec.Validate("Transaction Type", SalesSetup."Transaction Type Default");
        Rec.Validate("Transport Method", SalesSetup."Transport Method Default");
        Rec.Validate("Transaction Specification", SalesSetup."Transaction Specifi. Default");
        Rec.Validate(Area, SalesSetup.Area);
        Rec.Validate(User, UserId);
        Rec.Modify;
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterCopyShipToCustomerAddressFieldsFromCustomer', '', false, false)]
    local procedure T36_OnAfterCopyShipToCustomerAddressFieldsFromCustomer(var SalesHeader: Record "Sales Header"; SellToCustomer: Record Customer)
    begin
        SalesHeader.Validate("Shipping Agent Code", SalesHeader."Shipping Agent Code");
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterCopyShipToCustomerAddressFieldsFromShipToAddr', '', false, false)]
    local procedure T36_OnAfterCopyShipToCustomerAddressFieldsFromShipToAddr(var SalesHeader: Record "Sales Header"; ShipToAddress: Record "Ship-to Address")
    begin
        if ShipToAddress."Territory Code" <> '' then
            SalesHeader."Territory Code" := ShipToAddress."Territory Code";
    end;

    [Scope('OnPrem')]
    procedure CalcTransport(var Rec: Record "Sales Header")
    var
        fTransport: Page "Sélection Transport";
        lRecTransport: Record Transport;
    begin
        Rec.TestField("Order type");
        Rec.TestField("Logistic unit");
        Rec.TestField("Territory Code");
        TestTransportLine(Rec);
        Clear(fTransport);
        lRecTransport.Reset;
        lRecTransport.SetRange(Type, lRecTransport.Type::Vente);
        lRecTransport.SetRange("Currency code", Rec."Currency Code");
        lRecTransport.SetRange("Type transport", Rec."Order type");
        lRecTransport.SetRange("Paletts type", Rec."Logistic unit");
        lRecTransport.SetRange("Territory code", Rec."Territory Code");

        //lRecTransport.SETFILTER("Starting date",,0D,"Order Date");
        //lRecTransport.SETFILTER(lRecTransport."End date",'<%1|''''',"Order Date");

        lRecTransport.SetFilter("Starting date", '%1..%2', 0D, Rec."Requested Delivery Date");
        lRecTransport.SetFilter(lRecTransport."End date", '%1|>=%2', 0D, Rec."Requested Delivery Date");

        fTransport.LookupMode := true;


        fTransport.SetTableView(lRecTransport);
        fTransport.SetNbPalette(CalcNbPaletteEntete(Rec));
        if fTransport.RunModal = ACTION::LookupOK then begin
            fTransport.GetRecord(lRecTransport);
            Rec."Nombre de palette confirmée" := fTransport.GetNbPalette;
            Rec."Unit price/Palette" := lRecTransport."Paletts / Price";
            Rec."Transport resource" := lRecTransport.Transport;
            if lRecTransport."Shipping Agent Code" <> '' then
                Rec.Validate("Shipping Agent Code", lRecTransport."Shipping Agent Code");

            Rec.Modify;
            CalcPrixLigneTransport(Rec);
            AddTransportLine(Rec);
        end;
    end;

    [Scope('OnPrem')]
    procedure AddTransportLine(var Rec: Record "Sales Header")
    var
        lSalesLine: Record "Sales Line";
        lLastLine: Record "Sales Line";
    begin
        lLastLine.Reset;
        lLastLine.SetRange("Document Type", Rec."Document Type");
        lLastLine.SetRange("Document No.", Rec."No.");
        if lLastLine.Find('+') then begin
            lSalesLine.Init;
            lSalesLine.Validate("Document Type", Rec."Document Type");
            lSalesLine.Validate("Document No.", Rec."No.");
            lSalesLine."Line No." := lLastLine."Line No." + 10000;
            lSalesLine.Validate("Sell-to Customer No.", Rec."Sell-to Customer No.");
            lSalesLine.Type := lSalesLine.Type::Resource;
            lSalesLine.Validate("No.", Rec."Transport resource");
            // bt test lSalesLine.VALIDATE(Quantity, CalcPdsTotal);
            lSalesLine.Validate(Quantity, CalcPdsTotalBT(Rec));

            lSalesLine.Validate("Qty. to Ship (Base)", CalcPdsALivrer(Rec));
            //bt test lSalesLine.VALIDATE("Unit Price", CalcPxALivrer/lSalesLine.Quantity);
            lSalesLine.Validate("Unit Price", Rec."Unit price/Palette" / 100);
            lSalesLine."Prix Tpt" := lSalesLine."Unit Price";

            //bt //
            lSalesLine."Transport line" := true;
            lSalesLine."Complete Pallet" := Rec."Complete Pallet";  //AB60408.V5
            lSalesLine.Insert(true);
        end;
        if Rec."Requested Delivery Date" > 20260415D then begin
            lSalesLine.Init;
            lSalesLine.Validate("Document Type", Rec."Document Type");
            lSalesLine.Validate("Document No.", Rec."No.");
            lSalesLine."Line No." := lLastLine."Line No." + 20000;
            lSalesLine.Validate("Sell-to Customer No.", Rec."Sell-to Customer No.");
            lSalesLine.Type := lSalesLine.Type::Resource;
            lSalesLine.Validate("No.", 'TRSURCHARGE');
            lSalesLine.Validate("Transport line", true);
            lSalesLine.Validate(Quantity, CalcPdsTotalBT(Rec));
            lSalesLine.Validate("Qty. to Ship (Base)", CalcPdsALivrer(Rec));
            lSalesLine.Validate("Unit Price", Rec."Unit price/Palette" / 100);
            lSalesLine."Attached to Line No." := lLastLine."Line No." + 10000;
            lSalesLine.Validate(Surcharge, 8.5);
            lSalesLine.Insert(true);

        end;
    end;

    [Scope('OnPrem')]
    procedure TestTransportLine(var Rec: Record "Sales Header")
    var
        lSalesLine: Record "Sales Line";
    begin
        lSalesLine.Reset;
        lSalesLine.SetRange("Document Type", Rec."Document Type");
        lSalesLine.SetRange("Document No.", Rec."No.");
        lSalesLine.SetRange("Transport line", true);
        lSalesLine.SetRange("Free Line", false);
        lSalesLine.SetRange(lSalesLine.Consign, false);

        if lSalesLine.Find('-') then
            Error('Il y a déjà une ligne de transport, merci de la supprimer');
    end;

    [Scope('OnPrem')]
    procedure CalcPdsALivrer(var Rec: Record "Sales Header"): Decimal
    var
        lSalesLine: Record "Sales Line";
        lItem: Record Item;
        lItemLog: Record "Unité logistique / article";
        lPds: Decimal;
    begin
        lPds := 0;
        lSalesLine.Reset;
        lSalesLine.SetRange(lSalesLine."Document Type", Rec."Document Type");
        lSalesLine.SetRange(lSalesLine."Document No.", Rec."No.");
        lSalesLine.SetRange(lSalesLine.Type, lSalesLine.Type::Item);
        lSalesLine.SetRange(lSalesLine."Free Line", false);
        lSalesLine.SetRange(lSalesLine.Consign, false);

        if lSalesLine.Find('-') then begin
            repeat
                lItem.Get(lSalesLine."No.");
                if lItemLog.Get(Rec."Logistic unit", lItem."No.") then

                    //bt test lPds := lPds+ lSalesLine."Qty. to Ship (Base)"*lItem."Gross Weight"
                    lPds := Round(lPds + lSalesLine."Qty. to Ship (Base)" * lItem."Gross Weight" / lItemLog."Palette weight"
              * 100, 0.00001);

            until lSalesLine.Next = 0;

            //AB60408.V5
            if Rec."Complete Pallet" then
                lPds := Round(lPds, 100, '>');
            //AB60408.V5

        end;
        exit(lPds);
    end;

    [Scope('OnPrem')]
    procedure CalcPxALivrer(var Rec: Record "Sales Header"): Decimal
    var
        lSalesLine: Record "Sales Line";
        lItem: Record Item;
        lItemLog: Record "Unité logistique / article";
        lMnt: Decimal;
    begin
        lMnt := 0;
        lSalesLine.Reset;
        lSalesLine.SetRange(lSalesLine."Document Type", Rec."Document Type");
        lSalesLine.SetRange(lSalesLine."Document No.", Rec."No.");
        lSalesLine.SetRange(lSalesLine.Type, lSalesLine.Type::Item);
        lSalesLine.SetRange(lSalesLine."Free Line", false);
        lSalesLine.SetRange(lSalesLine.Consign, false);

        if lSalesLine.Find('-') then begin
            repeat
                lItem.Get(lSalesLine."No.");
                lItemLog.Get(Rec."Logistic unit", lItem."No.");
                lMnt := lMnt + lSalesLine."Quantity (Base)" * lItem."Gross Weight" * lSalesLine."Transport Unit Price"
                * 100;
            until lSalesLine.Next = 0;
        end;
        exit(lMnt);
    end;

    [Scope('OnPrem')]
    procedure CalcPdsTotal(var Rec: Record "Sales Header"): Decimal
    var
        lSalesLine: Record "Sales Line";
        lItem: Record Item;
        lItemLog: Record "Unité logistique / article";
        lPds: Decimal;
    begin
        //bt : pour le calcul des quantités du transport

        lPds := 0;
        lSalesLine.Reset;
        lSalesLine.SetRange(lSalesLine."Document Type", Rec."Document Type");
        lSalesLine.SetRange(lSalesLine."Document No.", Rec."No.");
        lSalesLine.SetRange(lSalesLine.Type, lSalesLine.Type::Item);
        lSalesLine.SetRange(lSalesLine."Free Line", false);
        lSalesLine.SetRange(lSalesLine.Consign, false);
        if lSalesLine.Find('-') then begin
            repeat
                lItem.Get(lSalesLine."No.");
                lItemLog.Get(Rec."Logistic unit", lItem."No.");
                lPds := lPds + lSalesLine."Quantity (Base)" * lItem."Gross Weight";
            until lSalesLine.Next = 0;

            //AB60408.V5
            if Rec."Complete Pallet" then
                lPds := Round(lPds, 100, '>');
            //AB60408.V5

        end;
        exit(lPds);
    end;

    [Scope('OnPrem')]
    procedure CalcPdsTotalBT(var Rec: Record "Sales Header"): Decimal
    var
        lSalesLine: Record "Sales Line";
        lItem: Record Item;
        lItemLog: Record "Unité logistique / article";
        lPds: Decimal;
    begin
        //bt : pour le calcul des quantités du transport rapporté à la palette

        lPds := 0;
        lSalesLine.Reset;
        lSalesLine.SetRange(lSalesLine."Document Type", Rec."Document Type");
        lSalesLine.SetRange(lSalesLine."Document No.", Rec."No.");
        lSalesLine.SetRange(lSalesLine.Type, lSalesLine.Type::Item);
        lSalesLine.SetRange(lSalesLine."Free Line", false);
        lSalesLine.SetRange(lSalesLine.Consign, false);
        if lSalesLine.Find('-') then begin
            repeat
                lItem.Get(lSalesLine."No.");
                if lItemLog.Get(Rec."Logistic unit", lItem."No.") then
                    //lPds := lPds+ lSalesLine."Quantity (Base)"*lItem."Gross Weight";
                    lPds := Round(lPds + lSalesLine."Quantity (Base)" * lItem."Gross Weight" / lItemLog."Palette weight"
                   * 100, 0.00001);

            until lSalesLine.Next = 0;

            //AB60408.V5
            if Rec."Complete Pallet" then
                lPds := Round(lPds, 100, '>');
            //AB60408.V5

        end;
        exit(lPds);
    end;

    [Scope('OnPrem')]
    procedure CalcPrixLigneTransport(var Rec: Record "Sales Header")
    var
        lSalesLine: Record "Sales Line";
        lItem: Record Item;
        lItemLog: Record "Unité logistique / article";
    begin
        lSalesLine.Reset;
        lSalesLine.SetRange(lSalesLine."Document Type", Rec."Document Type");
        lSalesLine.SetRange(lSalesLine."Document No.", Rec."No.");
        lSalesLine.SetRange(lSalesLine.Type, lSalesLine.Type::Item);
        lSalesLine.SetRange(lSalesLine."Free Line", false);
        lSalesLine.SetRange(lSalesLine.Consign, false);
        if lSalesLine.Find('-') then begin
            repeat
                lItem.Get(lSalesLine."No.");
                lItemLog.Get(Rec."Logistic unit", lItem."No.");
                lSalesLine."Transport Unit Price" := Rec."Unit price/Palette" / lItemLog."Palette weight";
                lSalesLine.Modify;
            until lSalesLine.Next = 0;
        end;
    end;

    [Scope('OnPrem')]
    procedure CalcNbPaletteEntete(var Rec: Record "Sales Header"): Integer
    var
        lSalesLine: Record "Sales Line";
        lTotalPalette: Integer;
    begin
        lTotalPalette := 0;
        lSalesLine.Reset;
        lSalesLine.SetRange(lSalesLine."Document Type", Rec."Document Type");
        lSalesLine.SetRange(lSalesLine."Document No.", Rec."No.");
        lSalesLine.SetRange(lSalesLine.Type, lSalesLine.Type::Item);
        lSalesLine.SetRange(lSalesLine."Free Line", false);
        if lSalesLine.Find('-') then begin
            repeat
                lTotalPalette := lTotalPalette + CalcNbPaletteLigne(lSalesLine);
            until lSalesLine.Next = 0;
        end;
        exit(lTotalPalette);
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure T37_Qty(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        SalesHeader: Record "Sales Header";
        Item: Record Item;
        codes: Record "Code";
        SalesL: Record "Sales Line";
    begin
        if Rec.Quantity > 0 then begin
            if Rec.Quantity >= Rec."Qte commandée initiale" then begin
                Rec."Qte commandée initiale" := Rec.Quantity;
                Rec."Qte commandée initiale Base" := Rec."Quantity (Base)";
            end;
            if Rec.Quantity * 5 < Rec."Qte commandée initiale" then begin
                Rec."Qte commandée initiale" := Rec.Quantity;
                Rec."Qte commandée initiale Base" := Rec."Quantity (Base)";
            end;
            if not Rec."Complete Pallet" and not Rec."Transport line" then begin
                SalesHeader.Get(Rec."Document Type", Rec."Document No.");
                TestTransportLine(SalesHeader);
            end;
            if Rec.Type = Rec.Type::Item then begin
                Item.Get(Rec."No.");
                codes.Reset;
                codes.SetRange("Table No", 27);
                codes.SetRange("Field No", 8001305);
                codes.SetRange(Code, Item."Criteria 5");
                if (GuiAllowed) and (codes.FindFirst) then begin
                    if codes.Poids <> 0 then
                        if (Rec."Quantity (Base)" mod codes.Poids) > 0 then
                            if not Confirm('La quantité de base ne correspond pas à un multiple du conditionnement. Voulez-vous continuer ?') then
                                Error('Modification annulée');
                end;
            end;
            if Rec.Modify then;

            SalesL.Reset;
            SalesL.SetRange("Document Type", Rec."Document Type");
            SalesL.SetRange("Document No.", Rec."Document No.");
            SalesL.SetRange("Attached to Line No.", Rec."Line No.");
            if SalesL.FindFirst then begin
                SalesL.Validate(Surcharge, SalesL.Surcharge);
                SalesL.Modify;
            end;

        end;
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'Unit Price', false, false)]
    local procedure T37_UnitPrice(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        SalesL: Record "Sales Line";
    begin
        if (Rec."Line Discount unit amount" <> 0) and (Rec.Quantity <> 0) then
            Rec.Validate("Line Discount Amount", Rec.Quantity * Rec."Line Discount unit amount");
        if Rec.Modify then;
        SalesL.Reset;
        SalesL.SetRange("Document Type", Rec."Document Type");
        SalesL.SetRange("Document No.", Rec."Document No.");
        SalesL.SetRange("Attached to Line No.", Rec."Line No.");
        if SalesL.FindFirst then begin
            SalesL.Validate(Surcharge, SalesL.Surcharge);
            SalesL.Modify;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'Line Discount %', false, false)]
    local procedure T37_LineDiscount(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        SalesL: Record "Sales Line";
    begin

        if Rec.Modify then;
        SalesL.Reset;
        SalesL.SetRange("Document Type", Rec."Document Type");
        SalesL.SetRange("Document No.", Rec."Document No.");
        SalesL.SetRange("Attached to Line No.", Rec."Line No.");
        if SalesL.FindFirst then begin
            SalesL.Validate(Surcharge, SalesL.Surcharge);
            SalesL.Modify;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnBeforeValidateEvent', 'Purchasing Code', false, false)]
    local procedure T37_PurchasingCode(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        Evaluate(Rec."Outbound Whse. Handling Time", '<0D>');
        Evaluate(Rec."Shipping Time", '<0D>');
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnBeforeDeleteEvent', '', false, false)]
    local procedure T37_Delete(var Rec: Record "Sales Line"; RunTrigger: Boolean)
    var
        SalesHeader: Record "Sales Header";
        ShptPurchOrder: Record "Shipment Purchase Orders";
        callVP: Codeunit "Call WS";
    begin
        if RunTrigger then begin
            SalesHeader.Get(Rec."Document Type", Rec."Document No.");
            if not Rec."Transport line" then
                TestTransportLine(SalesHeader);
            //IF "Location Code" <> 'RD' THEN
            //TESTFIELD("Qty. Shipped Not Invoiced",0);

            //BT LOG-004 : cas de la suppression des lignes transports
            if Rec."Transport line" then SuppTransport(Rec);

            if ShptPurchOrder.Get(SalesHeader."Shipping Agent Code", SalesHeader."Location Code", SalesHeader."Promised Delivery Date", SalesHeader."No.") then begin
                ShptPurchOrder."Total Net Weight" -= Rec."Qty. to Ship" * Rec."Net Weight";
                ShptPurchOrder."Qty. to Ship" -= Rec."Qty. to Ship";
                ShptPurchOrder."Quantity Shipped" -= Rec."Quantity Shipped";
                ShptPurchOrder.Modify;
            end;
            if (Rec."Document Type" = Rec."Document Type"::Order) and (Rec.Type = Rec.Type::Item) then
                callVP.CmdVenteDel(Rec."Document No." + '_' + Format(Rec."Line No."));
        end;
    end;

    [Scope('OnPrem')]
    procedure SuppTransport(SalesLine: Record "Sales Line")
    var
        lSalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
        lSalesLine.Reset;
        lSalesLine.SetRange(lSalesLine."Document Type", SalesLine."Document Type");
        lSalesLine.SetRange(lSalesLine."Document No.", SalesLine."Document No.");
        lSalesLine.SetRange(lSalesLine."Transport line", false);
        if lSalesLine.Find('-') then begin
            repeat
                ;
                lSalesLine."Transport Unit Price" := 0;
                lSalesLine.Modify(false);
            until lSalesLine.Next = 0;
        end;
        SalesHeader."Nombre de palette confirmée" := 0;
        SalesHeader."Montant total palette" := 0;
        SalesHeader."Unit price/Palette" := 0;
        SalesHeader.Modify;
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnBeforeInsertEvent', '', false, false)]
    local procedure T37_OnInsert(var Rec: Record "Sales Line"; RunTrigger: Boolean)
    var
        SalesHeader: Record "Sales Header";
    begin
        if SalesHeader.Get(Rec."Document Type", Rec."Document No.") then
            Rec."Country Code" := SalesHeader."Bill-to Country/Region Code";
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnBeforeGetItemTranslation', '', false, false)]
    local procedure T37_OnBeforeItemTranslation(var SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    var
        SalesHeader: Record "Sales Header";
        ItemTranslation: Record "Item Translation";
    begin
        SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
        if ItemTranslation.Get(SalesLine."No.", SalesLine."Variant Code", SalesHeader."Language Code") then begin
            SalesLine.Description := ItemTranslation.Description;
            //"Description 2" := ItemTranslation."Description 2";
        end;
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'Item Reference No.', false, false)]
    local procedure T37_OnCrossRef(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        GetItemConditionnement(Rec);
        //Rec.MODIFY;
    end;



    [Scope('OnPrem')]
    procedure CalcNbPaletteLigne(SalesLine: Record "Sales Line") NbPalette: Integer
    var
        lItem: Record Item;
        lPoids: Decimal;
        lEnteteVente: Record "Sales Header";
        lUniteLogArt: Record "Unité logistique / article";
        Text50000: Label 'Le poids par type palette/article n''''a pas été renséigné';
    begin
        NbPalette := 0;
        if SalesLine."Free Line" then
            exit(0);
        if SalesLine.Consign then
            exit(0);


        lItem.Get(SalesLine."No.");
        lPoids := SalesLine."Quantity (Base)" * lItem."Gross Weight";
        lEnteteVente.Get(SalesLine."Document Type", SalesLine."Document No.");

        if not (lUniteLogArt.Get(lEnteteVente."Logistic unit", lItem."No.")) then
            Error(Text50000);

        if lUniteLogArt."Palette weight" = 0 then
            Error(Text50000);

        NbPalette := Round(lPoids / lUniteLogArt."Palette weight", 1, '>');
    end;

    local procedure CheckTarif(Rec: Record "Sales Line")
    var
        RecSalesPrice: Record "Sales PriceEC";
        SalesH: Record "Sales Header";
        recCust: Record Customer;
    begin
        if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') and (Rec."Location Code" <> 'RD') then begin
            SalesH.Get(Rec."Document Type", Rec."Document No.");
            recCust.Get(SalesH."Sell-to Customer No.");
            RecSalesPrice.Reset;
            RecSalesPrice.SetRange("Item No.", Rec."No.");
            RecSalesPrice.SetRange("Sales Type", RecSalesPrice."Sales Type"::Customer);
            RecSalesPrice.SetRange("Sales Code", SalesH."Sell-to Customer No.");
            RecSalesPrice.SetFilter("Starting Date", '<=%1', SalesH."Posting Date");
            RecSalesPrice.SetFilter("Ending Date", '>=%1', SalesH."Posting Date");
            RecSalesPrice.SetFilter("Unit Start Price", '<>%1', 0);
            RecSalesPrice.SetFilter("Prix 3x Net", '<>%1', 0);
            if not RecSalesPrice.Find('+') then begin
                RecSalesPrice.SetRange(RecSalesPrice."Sales Type", RecSalesPrice."Sales Type"::"Customer Price Group");
                RecSalesPrice.SetRange(RecSalesPrice."Sales Code", recCust."Customer Price Group"); //Groupe prix client
            end;

            if not RecSalesPrice.Find('+') then
                Error('Tarif non trouvé !   Veuillez contacter le service commercial');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 110, 'OnBeforePrintRecords', '', false, false)]
    local procedure T110_OnPrint(var SalesShipmentHeader: Record "Sales Shipment Header"; ShowDialog: Boolean; var IsHandled: Boolean)
    begin
        if SalesShipmentHeader."Location Code" = 'RD' then begin
            REPORT.RunModal(50008, ShowDialog, false, SalesShipmentHeader);
        end
        else begin
            REPORT.RunModal(50003, ShowDialog, false, SalesShipmentHeader);
            REPORT.RunModal(50008, ShowDialog, false, SalesShipmentHeader);
        end;
        IsHandled := true;
    end;

    [Scope('OnPrem')]
    procedure GetCommunicationForInvoice(SalesHeader: Record "Sales Invoice Header") Com: Text[30]
    var
        Utils: Codeunit Utils;
    begin
        Com := '+++';
        Com := Com + CopyStr(SalesHeader."Bill-to Customer No.", 4, 3);
        Com := Com + '/';
        Com := Com + CopyStr(SalesHeader."No.", 6, 2);
        Com := Com + CopyStr(SalesHeader."No.", 9, 2);
        Com := Com + '/';
        Com := Com + CopyStr(SalesHeader."No.", 11, 3);
        Com := Com + Utils.PadLeft(Format(Utils.Mod97(DelChr(Com, '=', DelChr(Com, '=', '0123456789')))), '0', 2);
        Com := Com + '+++';
        exit(Com);
    end;



    [EventSubscriber(ObjectType::Table, 5067, 'OnAfterModifyEvent', '', false, false)]
    local procedure T5067_OnModify(var Rec: Record "Contact Job Responsibility"; var xRec: Record "Contact Job Responsibility"; RunTrigger: Boolean)
    var
        Cont: Record Contact;
        CtResp: Record "Contact Job Responsibility";
    begin
        if Cont.Get(Rec."Contact No.") then begin
            Cont.LockTable;
            Cont.Get(Rec."Contact No.");
            Cont.Responsabilites := '';
            CtResp.Reset;
            CtResp.SetRange("Contact No.", Rec."Contact No.");
            if CtResp.FindSet then
                repeat
                    Cont.Responsabilites := Cont.Responsabilites + CtResp."Job Responsibility Code" + ';'
                until CtResp.Next = 0;
            Cont.SetLastDateTimeModified;
            Cont.Modify;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 5067, 'OnAfterInsertEvent', '', false, false)]
    local procedure T5067_OnInsert(var Rec: Record "Contact Job Responsibility"; RunTrigger: Boolean)
    var
        Cont: Record Contact;
        CtResp: Record "Contact Job Responsibility";
    begin
        if Cont.Get(Rec."Contact No.") then begin
            Cont.LockTable;
            Cont.Get(Rec."Contact No.");
            Cont.Responsabilites := '';
            CtResp.Reset;
            CtResp.SetRange("Contact No.", Rec."Contact No.");
            if CtResp.FindSet then
                repeat
                    Cont.Responsabilites := Cont.Responsabilites + CtResp."Job Responsibility Code" + ';'
                until CtResp.Next = 0;
            Cont.SetLastDateTimeModified;
            Cont.Modify;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 5067, 'OnAfterDeleteEvent', '', false, false)]
    local procedure T5067_OnDelete(var Rec: Record "Contact Job Responsibility"; RunTrigger: Boolean)
    var
        Cont: Record Contact;
        CtResp: Record "Contact Job Responsibility";
    begin
        if Cont.Get(Rec."Contact No.") then begin
            Cont.LockTable;
            Cont.Get(Rec."Contact No.");
            Cont.Responsabilites := '';
            CtResp.Reset;
            CtResp.SetRange("Contact No.", Rec."Contact No.");
            if CtResp.FindSet then
                repeat
                    Cont.Responsabilites := Cont.Responsabilites + CtResp."Job Responsibility Code" + ';'
                until CtResp.Next = 0;
            Cont.SetLastDateTimeModified;
            Cont.Modify;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterUpdateSellToCust', '', false, false)]
    local procedure T36_OnAfterUpdateSellToCust(var SalesHeader: Record "Sales Header"; Contact: Record Contact)
    begin
        SalesHeader."Sell-to E-Mail" := '';
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterCopySellToCustomerAddressFieldsFromCustomer', '', false, false)]
    local procedure T36_OnAfterCopySellToCustomerAddressFieldsFromCustomer(var SalesHeader: Record "Sales Header"; SellToCustomer: Record Customer; CurrentFieldNo: Integer)
    begin
        SalesHeader."Sell-to E-Mail" := '';
    end;

    [EventSubscriber(ObjectType::Table, 5050, 'OnBeforeValidateEvent', 'E-Mail', false, false)]
    local procedure T5050_OnEMailContact(var Rec: Record Contact; var xRec: Record Contact; CurrFieldNo: Integer)
    var
        ct: Record Contact;
    begin
        if (Rec."E-Mail" <> '') and (Rec.Password = '') then begin
            ct.Reset;
            ct.SetRange("E-Mail", Rec."E-Mail");
            ct.SetFilter(ct."No.", '<>%1', Rec."No.");
            ct.SetFilter(Password, '<>''''');
            if ct.FindFirst then begin
                Rec.Password := ct.Password;
                Rec.salt := ct.salt;
                Rec.PwdValidityUntil := ct.PwdValidityUntil;
                Rec.ChangePw := ct.ChangePw;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 50039, 'OnBeforeInsertEvent', '', false, false)]
    local procedure T50039_onInsert(var Rec: Record "Sales PriceEC"; RunTrigger: Boolean)
    begin
        T50039_Modif_CalcRFA(Rec, Rec, false);
    end;

    [EventSubscriber(ObjectType::Table, 50039, 'OnBeforeModifyEvent', '', false, false)]

    procedure T50039_Modif_CalcRFA(var Rec: Record "Sales PriceEC"; var xRec: Record "Sales PriceEC"; RunTrigger: Boolean)
    var
        Base: Decimal;
        IUoM: Record "Item Unit of Measure";
    begin
        Rec."RFA / Kg" := 0;
        if Rec."Base RFA" = Rec."Base RFA"::"Prix Départ" then
            Base := Rec."Unit Start Price";
        if Rec."Base RFA" = Rec."Base RFA"::"Prix rendu" then
            Base := Rec."Unit Price";
        if (Rec."RFA - %" > 0) then
            Rec."RFA / Kg" := Base / 100 * Rec."RFA - %";
        if ((Rec."RFA - Montant" > 0) and (Rec."Quantité annuelle base RFA" > 0)) then
            Rec."RFA / Kg" := Rec."RFA / Kg" + (Rec."RFA - Montant" / Rec."Quantité annuelle base RFA");
        if (Rec."RFA / Kg") < 0 then Rec."RFA / Kg" := 0;

        Rec."CC / Kg" := 0;
        if Rec."Base CC" = Rec."Base CC"::"Prix Départ" then
            Base := Rec."Unit Start Price";
        if Rec."Base CC" = Rec."Base CC"::"Prix rendu" then
            Base := Rec."Unit Price";
        if (Rec."CC - %" > 0) then
            Rec."CC / Kg" := Base / 100 * Rec."CC - %";
        if ((Rec."CC - Montant" > 0) and (Rec."Quantité annuelle base CC" > 0)) then
            Rec."CC / Kg" := Rec."CC / Kg" + (Rec."CC - Montant" / Rec."Quantité annuelle base CC");
        if (Rec."CC / Kg") < 0 then Rec."CC / Kg" := 0;


        Rec."Prix 3x Net" := Base - Rec."RFA / Kg" - Rec."CC / Kg";
        Rec."Prix 3x Net Unit" := Base - Rec."RFA / Kg" - Rec."CC / Kg";

        IUoM.Reset;
        IUoM.SetRange("Item No.", Rec."Item No.");
        IUoM.SetRange(Code, Rec."Unit of Measure Code");
        if (IUoM.FindFirst) then
            if (IUoM."Qty. per Unit of Measure" > 1) then begin
                Rec."CC / Kg" := Rec."CC / Kg" / IUoM."Qty. per Unit of Measure";
                Rec."RFA / Kg" := Rec."RFA / Kg" / IUoM."Qty. per Unit of Measure";
                Rec."Prix 3x Net" := Rec."Prix 3x Net" / IUoM."Qty. per Unit of Measure";
            end;
    end;

    [EventSubscriber(ObjectType::Table, 50039, 'OnBeforeInsertEvent', '', false, false)]
    procedure T50039_Insert_CalcRFA(var Rec: Record "Sales PriceEC"; RunTrigger: Boolean)
    var
        Base: Decimal;
    begin
        Rec."RFA / Kg" := 0;
        if Rec."Base RFA" = Rec."Base RFA"::"Prix Départ" then
            Base := Rec."Unit Start Price";
        if Rec."Base RFA" = Rec."Base RFA"::"Prix rendu" then
            Base := Rec."Unit Price";
        if (Rec."RFA - %" > 0) then
            Rec."RFA / Kg" := Base / 100 * Rec."RFA - %";
        if ((Rec."RFA - Montant" > 0) and (Rec."Quantité annuelle base RFA" > 0)) then
            Rec."RFA / Kg" := Rec."RFA / Kg" + (Rec."RFA - Montant" / Rec."Quantité annuelle base RFA");
        if (Rec."RFA / Kg") < 0 then Rec."RFA / Kg" := 0;

        Rec."CC / Kg" := 0;
        if Rec."Base CC" = Rec."Base CC"::"Prix Départ" then
            Base := Rec."Unit Start Price";
        if Rec."Base CC" = Rec."Base CC"::"Prix rendu" then
            Base := Rec."Unit Price";
        if (Rec."CC - %" > 0) then
            Rec."CC / Kg" := Base / 100 * Rec."CC - %";
        if ((Rec."CC - Montant" > 0) and (Rec."Quantité annuelle base CC" > 0)) then
            Rec."CC / Kg" := Rec."CC / Kg" + (Rec."CC - Montant" / Rec."Quantité annuelle base CC");
        if (Rec."CC / Kg") < 0 then Rec."CC / Kg" := 0;


        //IF (Rec."RFA / Kg") > 0 THEN
        Rec."Prix 3x Net" := Base - Rec."RFA / Kg" - Rec."CC / Kg";
    end;

    [EventSubscriber(ObjectType::Table, 50039, 'OnBeforeValidateEvent', 'Sales Code', false, false)]
    local procedure T50039_OnValidateSalescode(var Rec: Record "Sales PriceEC"; var xRec: Record "Sales PriceEC"; CurrFieldNo: Integer)
    var
        Cust: Record Customer;
        grp: Record "Customer Price Group";
    begin
        if (Rec."Sales Type" = Rec."Sales Type"::Customer) and (Rec."Sales Code" <> '') then
            if Cust.Get(Rec."Sales Code") then
                Rec."Salesperson Code" := Cust."Salesperson Code";
        if (Rec."Sales Type" = Rec."Sales Type"::"Customer Price Group") and (Rec."Sales Code" <> '') then
            if grp.Get(Rec."Sales Code") then
                Rec."Salesperson Code" := grp."Salesperson Code";
    end;

    local procedure WorkWithExv(ShptHeaderNo: Code[20])
    var
        Shpt: Record "Sales Shipment Header";
        GS1: Codeunit "GS1 Send";
        Cust: Record Customer;
        FileMgt: Codeunit "File Management";
        Path: Text;
        SFTP: Codeunit SFTP;
        InS: InStream;
    begin
        if Shpt.Get(ShptHeaderNo) then
            if Cust.Get(Shpt."Sell-to Customer No.") then
                if Cust.DESADV then begin
                    if Cust."SFTP Server" <> '' then begin
                        emailmsg.Create('g.dangremont@europacuisson.com', 'Debut Livraison n°' + ShptHeaderNo + 'pour client ' + Cust."No.", 'DESADV', true);
                        emailsend.Send(emailmsg, enum::"Email Scenario"::Default);
                        Path := FileMgt.ServerTempFileName('txt');
                        GS1.DESADV(Shpt, Path);
                        SFTP.TftFileToServer(Cust."SFTP Server", Cust."SFTP port", Cust."SFTP Login", Cust."SFTP Pwd", Path, Cust."SFTP Dir" + '/' + ShptHeaderNo + '.txt');
                        emailmsg.Create('g.dangremont@europacuisson.com', 'Livraison n°' + ShptHeaderNo + 'pour client ' + Cust."No.", 'DESADV', true);
                        emailsend.Send(emailmsg, enum::"Email Scenario"::Default);
                    end;
                    if Cust."Repertoire Send AS2" <> '' then begin
                        emailmsg.Create('g.dangremont@europacuisson.com', ' !!! Debut Livraison AS2 n°' + ShptHeaderNo + 'pour client ' + Cust."No.", 'DESADV', true);
                        emailsend.Send(emailmsg, enum::"Email Scenario"::Default);
                        Path := Cust."Repertoire Send AS2" + '.' + ShptHeaderNo + '.txt';

                        GS1.DESADV(Shpt, Path);

                        emailmsg.Create('g.dangremont@europacuisson.com', ' !!!   Livraison AS2 n°' + ShptHeaderNo + 'pour client ' + Cust."No.", 'DESADV', true);
                        emailsend.Send(emailmsg, enum::"Email Scenario"::Default);
                    end;
                    if Cust."E-Mail EDI" <> '' then begin

                        Shpt.SetFilter("No.", ShptHeaderNo);
                        emailmsg.Create('g.dangremont@europacuisson.com', Cust."E-Mail EDI" + 'Nous vous livrons votre commande sous la référence ' + ShptHeaderNo, 'Ci-joint détail de la livraison', true);
                        Path := FileMgt.ServerTempFileName('pdf');
                        REPORT.SaveAsPdf(REPORT::"Sales - Shipment EC", Path);
                        if FileMgt.ServerFileExists(Path) then begin
                            FileMgt.BLOBImportFromServerFile(TempBlob, Path);
                            TempBlob.CreateInStream(InS);
                            emailmsg.AddAttachment('Bonlivraison.pdf', 'application/pdf', InS);
                        end;

                        emailsend.Send(emailmsg, enum::"Email Scenario"::Default);

                    end;
                end;
    end;

    [EventSubscriber(ObjectType::Table, 18, 'OnBeforeValidateEvent', 'EInvoice EAS', false, false)]
    local procedure T18_EAS(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    begin
        if Rec."EInvoice EAS" = '0208' then
            Rec."EInvoice Endpoint" := Rec."Enterprise No.";
        if Rec."EInvoice EAS" = '9925' then
            Rec."EInvoice Endpoint" := Rec."VAT Registration No.";
        if Rec."EInvoice EAS" = '9957' then
            Rec."EInvoice Endpoint" := Rec."VAT Registration No.";
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnBeforeValidateEvent', 'Surcharge', false, false)]
    local procedure T37_Surcharge(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        SalesL: Record "Sales Line";
    begin
        SalesL.Reset;
        SalesL.SetRange("Document Type", Rec."Document Type");
        SalesL.SetRange("Document No.", Rec."Document No.");
        SalesL.SetRange("Line No.", Rec."Attached to Line No.");
        if SalesL.FindFirst then begin
            Rec.Validate("Quantity (Base)", Rec.Surcharge / 100);
            Rec.Validate("Unit Price", SalesL."Quantity (Base)" * SalesL."Unit Price");
            Rec.Validate("Line Discount %", SalesL."Line Discount %");
            SalesL.Validate(Surcharge, SalesL.Surcharge);
        end;
    end;
}

