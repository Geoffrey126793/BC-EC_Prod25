codeunit 50047 Integration_Purchase
{
    Permissions = TableData "Sales Header" = rimd,
                  TableData "Sales Line" = rimd,
                  TableData "Sales Shipment Header" = rimd,
                  TableData "Sales Shipment Line" = rimd,
                  TableData "Sales Invoice Header" = rimd,
                  TableData "Sales Invoice Line" = rimd;

    trigger OnRun()
    begin
        UpdateCmdTpt('CDA-E24-1528', 10000);
    end;

    var
        AB6Tool: Codeunit "Absys - tools PJ";


    [EventSubscriber(ObjectType::Table, 38, 'OnCheckPurchasePostRestrictions', '', false, false)]
    local procedure T39_OnCheckPurchasePostRestrictions(var Sender: Record "Purchase Header")
    var
        Text50000: Label 'Validation impossible pour la commande No %1, Cette commande n''a pas reçue de Visa';
    begin
        if (Sender."Document Type" = Sender."Document Type"::Order) and
          (Sender."Status Visa" = Sender."Status Visa"::"On standby visa ")

           then begin
            Error(Text50000, Sender."No.");
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforePostLines', '', false, false)]
    local procedure CU90_OnBeforePostLines(var PurchLine: Record "Purchase Line"; PurchHeader: Record "Purchase Header"; PreviewMode: Boolean; CommitIsSupressed: Boolean)
    var
        PurchLine2: Record "Purchase Line";
        Text50001: Label 'Unit cost is required for %1 = %2, %3 = %4, %5 = %6.';
    begin
        if (PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice) or (PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo") then begin

            PurchHeader.CalcFields("Amount Including VAT");
            if PurchHeader."Vérification Montant TTC" <> PurchHeader."Amount Including VAT" then
                Error('Le montant TTC ne correspond pas');
        end;

        PurchLine2.Reset;
        PurchLine2.SetRange("Document No.", PurchHeader."No.");
        PurchLine2.SetRange(Type, PurchLine2.Type::Item);
        PurchLine2.SetRange("Unit Cost", 0);
        if PurchLine2.Find('-') then
            repeat
                Error(
                 Text50001,
                 PurchLine2.FieldCaption("Document Type"),
                 PurchLine2."Document Type",
                 PurchLine2.FieldCaption("Document No."),
                 PurchLine2."Document No.",
                 PurchLine2.FieldCaption("Line No."),
                 PurchLine2."Line No.");
            until PurchLine2.Next = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforePostPurchaseDoc', '', false, false)]
    local procedure CU90_ONBeforePost(var Sender: Codeunit "Purch.-Post"; var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; CommitIsSupressed: Boolean; var HideProgressWindow: Boolean)
    var
        RecptH: Record "Purch. Rcpt. Header";
    begin
        if (PurchaseHeader."Vendor Shipment No." <> '') and (GuiAllowed) then begin
            RecptH.Reset;
            RecptH.SetRange("Buy-from Vendor No.", PurchaseHeader."Buy-from Vendor No.");
            RecptH.SetRange("Vendor Shipment No.", PurchaseHeader."Vendor Shipment No.");
            if RecptH.FindFirst then
                if not Confirm('Il existe déjà une réception validée avec ce BL validé pour ce fournisseur. Continuer la validation ?') then
                    Error('');
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnAfterPurchRcptLineInsert', '', false, false)]
    local procedure CU90_OnInvoiceReceipt(PurchaseLine: Record "Purchase Line"; var PurchRcptLine: Record "Purch. Rcpt. Line"; ItemLedgShptEntryNo: Integer; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSupressed: Boolean; PurchInvHeader: Record "Purch. Inv. Header")
    var
        ReceiptInvoiced: Record "Receipt Invoiced";
        ShptPurchOrder: Record "Shipment Purchase Orders";
    begin

        //AB60408.A1 Insert Receipt Invoiced
        ReceiptInvoiced.Init;
        ReceiptInvoiced."Invoice No." := PurchInvHeader."No.";
        ReceiptInvoiced."Receipt No." := PurchRcptLine."Document No.";
        ReceiptInvoiced."Receipt Line No." := PurchRcptLine."Line No.";
        ReceiptInvoiced."Invoice Line No." := PurchaseLine."Line No.";
        ReceiptInvoiced."Qty. to Invoice" := PurchRcptLine."Quantity Invoiced";
        ReceiptInvoiced."Qty. to Receive" := PurchRcptLine.Quantity;
        ReceiptInvoiced."Posting Date" := PurchInvHeader."Posting Date";
        ReceiptInvoiced."User ID" := UserId;

        ReceiptInvoiced.Type := PurchRcptLine.Type.AsInteger();
        ReceiptInvoiced."No." := PurchRcptLine."No.";
        ReceiptInvoiced."Location Code" := PurchRcptLine."Location Code";
        ReceiptInvoiced.Description := PurchRcptLine.Description;
        ReceiptInvoiced."Order No." := PurchRcptLine."Order No.";
        ReceiptInvoiced."Buy-from Vendor No." := PurchRcptLine."Buy-from Vendor No.";
        //ReceiptInvoiced."Buy-from Vendor Name" := PurchRcptLine."Buy-from Vendor Name";
        //ReceiptInvoiced."Vendor Order No." := PurchRcptLine."Vendor Order No.";
        ReceiptInvoiced."Vendor Invoice No." := PurchInvHeader."Vendor Invoice No.";
        ReceiptInvoiced."Qty. Received Not Invoiced" := PurchRcptLine."Qty. Rcd. Not Invoiced";
        ReceiptInvoiced."Quantity Invoiced" := PurchRcptLine."Quantity Invoiced";
        ReceiptInvoiced."Receipt Posting Date" := PurchRcptLine."Posting Date";

        if ReceiptInvoiced.Insert then;
        //AB60408.A1
        //AB60408.V14
        if (PurchaseLine."Transport Customer No" <> '') then
            if (PurchRcptLine.Quantity = PurchaseLine."Outstanding Quantity") then
                ShptPurchOrder.UpdatePurchPost(PurchaseLine);
        //AB60408.V14
    end;

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnAfterPostPurchaseDoc', '', false, false)]
    local procedure CU90_OnAfterPostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PurchRcpHdrNo: Code[20]; RetShptHdrNo: Code[20]; PurchInvHdrNo: Code[20]; PurchCrMemoHdrNo: Code[20]; CommitIsSupressed: Boolean)
    var
        ShptPurchOrder: Record "Shipment Purchase Orders";
        SalesHeader: Record "Sales Header";
        SalesInvHeader: Record "Sales Invoice Header";
        RecPalletEntry_l: Record "Pallet Ledger Entry";
        RecPurchRcptHeader_l: Record "Purch. Rcpt. Header";
        RepPrintPalletLabel_l: Report "Print Pallet Label";
        RecPallet_l: Record Pallet;
        recBL: Record "Sales Line DiscountEC";
        sessionId: Integer;
    begin
        //AB60408.V14
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order then begin
            ShptPurchOrder.Reset;
            ShptPurchOrder.SetRange("Purchase Order No.", PurchaseHeader."No.");
            ShptPurchOrder.DeleteAll;
            SalesHeader.Reset;
            SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
            SalesHeader.SetRange("Transport Purchase Order", PurchaseHeader."No.");
            if SalesHeader.Find('-') then
                repeat begin
                    SalesHeader."Transport Purchase Order" := '';
                    SalesHeader."Transport Purchase Invoice" := PurchInvHdrNo;
                    SalesHeader.Modify;
                end until SalesHeader.Next = 0;
            SalesInvHeader.Reset;
            SalesInvHeader.SetRange("Transport Purchase Order", PurchaseHeader."No.");
            if SalesInvHeader.Find('-') then
                repeat begin
                    SalesInvHeader."Transport Purchase Order" := '';
                    SalesInvHeader."Transport Purchase Invoice" := PurchInvHdrNo;
                    SalesInvHeader.Modify;
                end until SalesInvHeader.Next = 0;
        end;
        //AB60408.V14

        ////--> ABC GEN 20130702
        if PurchaseHeader.Receive then begin
            if RecPurchRcptHeader_l.Get(PurchRcpHdrNo) then begin
                RecPalletEntry_l.SetCurrentKey("Document No.", "Posting Date");
                RecPalletEntry_l.SetFilter("Document No.", RecPurchRcptHeader_l."No." + '*');
                RecPalletEntry_l.SetRange("Posting Date", RecPurchRcptHeader_l."Posting Date");
                //   smtp.CreateMessage('Navision','xerox@europacuisson.com','g.dangremont@europacuisson.com',FORMAT(RecPalletEntry_l.COUNT),FORMAT(RecPalletEntry_l.COUNT),TRUE);
                //           smtp.Send();
                if RecPalletEntry_l.FindSet then
                    //Print Label
                    repeat
                        RecPallet_l.Reset;
                        RecPallet_l.SetRange("SSCC No.", RecPalletEntry_l."SSCC No.");
                        // RecPallet_l.SETFILTER("Quai reception",'''''');

                        if RecPallet_l.FindSet then begin
                            //          smtp.CreateMessage('Navision','xerox@europacuisson.com','g.dangremont@europacuisson.com',PurchRcpHdrNo,RecPallet_l."SSCC No.",TRUE);
                            //          smtp.Send();

                            StartSession(sessionId, CODEUNIT::"Print palet Etiq", CompanyName, RecPallet_l);
                        end;
                    until RecPalletEntry_l.Next = 0;

            end;


        end;
        ////<-- ABC GEN 20130702
    end;

    [EventSubscriber(ObjectType::Codeunit, 91, 'OnBeforeConfirmPost', '', false, false)]
    local procedure CU91_OnBeforeConfirmPost(var PurchaseHeader: Record "Purchase Header"; var HideDialog: Boolean; var IsHandled: Boolean; var DefaultOption: Integer)
    begin
        if (PurchaseHeader."Posting Date" <> Today) then begin
            if AB6Tool.GetRole('DATECOMPTA') then begin
                PurchaseHeader.SetHideValidationDialog(true);
                PurchaseHeader.Validate("Posting Date", Today);
                PurchaseHeader.Modify;
            end else begin
                if Confirm('Mettre la date du jour ?') then begin
                    PurchaseHeader.SetHideValidationDialog(true);
                    PurchaseHeader.Validate("Posting Date", Today);
                    PurchaseHeader.Modify;
                end;
            end;
        end;
        DefaultOption := 1;
    end;

    [EventSubscriber(ObjectType::Codeunit, 92, 'OnBeforeConfirmPost', '', false, false)]
    local procedure CU92_OnBeforeConfirmPost(var PurchaseHeader: Record "Purchase Header"; var HideDialog: Boolean; var IsHandled: Boolean; var DefaultOption: Integer)
    begin
        if (PurchaseHeader."Posting Date" <> Today) then begin
            if AB6Tool.GetRole('DATECOMPTA') then begin
                PurchaseHeader.SetHideValidationDialog(true);
                PurchaseHeader.Validate("Posting Date", Today);
                PurchaseHeader.Modify;
            end else begin
                if Confirm('Mettre la date du jour ?') then begin
                    PurchaseHeader.SetHideValidationDialog(true);
                    PurchaseHeader.Validate("Posting Date", Today);
                    PurchaseHeader.Modify;
                end;
            end;
        end;
        DefaultOption := 1;
    end;

    [EventSubscriber(ObjectType::Table, 225, 'OnBeforeCheckClearPostCodeCityCounty', '', false, false)]
    local procedure T225_OnModifCP(var CityTxt: Text; var PostCode: Code[20]; var CountyTxt: Text; var CountryCode: Code[10]; xCountryCode: Code[10]; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, 7010, 'OnCalcBestDirectUnitCostOnAfterSetUnitCost', '', false, false)]
    local procedure CU7010_OnCalcBestDirectUnitCostOnAfterSetUnitCost(var PurchasePrice: Record "Purchase Price")
    begin
        //BT ABSYS 20070201 : demande de MR MATE : pas de dernier prix en saisie des achats,
        // pour garder confidentiel le prix des mat 1Šre...

        PurchasePrice."Direct Unit Cost" := 0;

    end;

    [EventSubscriber(ObjectType::Table, 38, 'OnAfterCopyBuyFromVendorFieldsFromVendor', '', false, false)]
    local procedure T38_OnAfterCopyBuyFromVendorFieldsFromVendor(var PurchaseHeader: Record "Purchase Header"; Vendor: Record Vendor; xPurchaseHeader: Record "Purchase Header")
    begin
        PurchaseHeader."Responsibility Center" := Vendor."Responsibility Center";
    end;

    [EventSubscriber(ObjectType::Table, 38, 'OnAfterInitRecord', '', false, false)]
    local procedure T38_OnAfterInitRecord(var PurchHeader: Record "Purchase Header")
    var
        Vend: Record Vendor;
    begin
        if Vend.Get(PurchHeader."Buy-from Vendor No.") then
            PurchHeader."Responsibility Center" := Vend."Responsibility Center";
        PurchHeader."Posting Description" := Format(PurchHeader."Document Type") + ' ... '; //Ab6 + "No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, 74, 'OnBeforeTransferLineToPurchaseDoc', '', false, false)]
    local procedure CU74_OnBeforeTransferLineToPurchaseDoc(var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchRcptLine: Record "Purch. Rcpt. Line"; var PurchaseHeader: Record "Purchase Header"; var TransferLine: Boolean)
    begin
        if (PurchRcptHeader."Posting Date" > PurchaseHeader."Posting Date") then
            if not Confirm('La date de facture est antérieure à la date de réception. Continuer ???') then
                Error('Annulé');
    end;

    [Scope('OnPrem')]
    procedure UpdateCmdTpt(CmdNo: Code[20]; LineNo: Integer)
    var
        SalesH: Record "Sales Header";
        Tarif: Record "Tarif transport";
        PurchL: Record "Purchase Line";
        Prix: Decimal;
        PurchH: Record "Purchase Header";
        NbrePal: Decimal;
        Pourcent: Decimal;
        lRecTransport: Record Transport;
        Agent: Record "Shipping Agent";
    begin

        Prix := 0;
        PurchL.Get(PurchL."Document Type"::Order, CmdNo, LineNo);
        PurchH.Get(PurchH."Document Type"::Order, CmdNo);
        SalesH.Get(SalesH."Document Type"::Order, PurchL."Transport Sales Order No");
        NbrePal := SalesH."Nombre de palette confirmée";

        Tarif.Reset;
        Tarif.SetRange(Fournisseur, PurchH."Buy-from Vendor No.");
        Tarif.SetRange("Type Prix", Tarif."Type Prix"::Tpt);
        Tarif.SetFilter("Type transport", '%1|%2', SalesH."Order type", Tarif."Type transport"::" ");
        Tarif.SetFilter(Debut, '<=%1', SalesH."Promised Delivery Date");
        Tarif.SetFilter(Fin, '>=%1', SalesH."Promised Delivery Date");
        Tarif.SetFilter(Pays, '''''|%1', SalesH."Ship-to Country/Region Code");
        Tarif.SetFilter("Poids Maximum", '..%1', PurchL."Net Weight");

        if Tarif.FindLast then begin
            Prix := PurchL."Net Weight" * Tarif."Tarif / Kg";
        end
        else begin
            Agent.Reset;
            Agent.SetRange("Buy-from Vendor No.", PurchH."Buy-from Vendor No.");
            Agent.FindFirst;
            lRecTransport.Reset;
            lRecTransport.SetRange(Type, lRecTransport.Type::Achats);
            lRecTransport.SetRange("Shipping Agent Code", Agent.Code);
            lRecTransport.SetRange("Type transport", SalesH."Order type");
            lRecTransport.SetRange("Paletts type", SalesH."Logistic unit");
            lRecTransport.SetRange("Territory code", SalesH."Territory Code");
            lRecTransport.SetFilter("Starting date", '%1..%2', 0D, SalesH."Promised Delivery Date");
            lRecTransport.SetFilter(lRecTransport."End date", '%1|>=%2', 0D, SalesH."Promised Delivery Date");
            lRecTransport.SetFilter("Number of Pallets", '<=%1', NbrePal);
            if lRecTransport.FindLast then
                Prix := lRecTransport."Paletts / Price" * NbrePal;

        end;


        // Ajouter les frais fixes
        Tarif.Reset;
        Tarif.SetRange(Fournisseur, PurchH."Buy-from Vendor No.");
        Tarif.SetRange("Type Prix", Tarif."Type Prix"::Admin);
        Tarif.SetFilter("Type transport", '%1|%2', SalesH."Order type", Tarif."Type transport"::" ");
        Tarif.SetFilter(Debut, '<=%1', SalesH."Promised Delivery Date");
        Tarif.SetFilter(Fin, '>=%1', SalesH."Promised Delivery Date");
        Tarif.SetFilter(Pays, '''''|%1', SalesH."Ship-to Country/Region Code");
        if Tarif.FindLast then begin
            Prix := Prix + Tarif."Frais admin / palette" * NbrePal;
            Prix := Prix + Tarif."Frais admin / livraison";
            Prix := Prix + Tarif."Frais de douane / commande";
            Prix := Prix + Tarif."Frais certificat veterinaire";
            Pourcent := Tarif."Frais admin (%)" + Tarif."Taxes (%)" + Tarif."Taxes + frais admin (%)" + Tarif."Accises (%)" + Tarif."Indice du transport (%)" + Tarif."Indice du transport +admin (%)" + Tarif."Indice du tpt non routier (%)";
            Prix := Prix * (1 + Pourcent / 100);
        end;

        PurchL.Validate("Unit Cost (LCY)", Prix / PurchL."Quantity (Base)");
        PurchL.Validate("Direct Unit Cost", Prix / PurchL."Quantity (Base)");
        //PurchL.VALIDATE("Quantity (Base)",1);
        PurchL.Modify;
    end;

    [EventSubscriber(ObjectType::Table, 38, 'OnAfterDeleteEvent', '', false, false)]
    local procedure T38_Delete(var Rec: Record "Purchase Header"; RunTrigger: Boolean)
    var
        ShptPurchOrder: Record "Shipment Purchase Orders";
        SalesHeader: Record "Sales Header";
    begin
        if RunTrigger then begin
            ShptPurchOrder.Reset;
            ShptPurchOrder.SetRange("Purchase Order No.", Rec."No.");
            if ShptPurchOrder.FindFirst then
                ShptPurchOrder.ModifyAll("Purchase Order No.", '');
            SalesHeader.Reset;
            SalesHeader.SetRange("Transport Purchase Order", Rec."No.");
            if SalesHeader.Find('-') then
                SalesHeader.ModifyAll("Transport Purchase Order", '');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 38, 'OnBeforeInsertEvent', '', false, false)]
    local procedure T38_BeforeInsert(var Rec: Record "Purchase Header"; RunTrigger: Boolean)
    var
        PurchSetup: Record "Purchases & Payables Setup";
        isAutorised: Boolean;
    begin
        if RunTrigger then begin
            PurchSetup.Get;
            Rec.Validate("Transaction Type", PurchSetup."Transaction Type Default");
            Rec.Validate("Transport Method", PurchSetup."Transport Method Default");
            Rec.Validate("Transaction Specification", PurchSetup."Transaction Specifi. Default");
            Rec.Validate(Area, PurchSetup.Area);
            Rec.Validate(User, UserId);
        end;
        if (Rec."Document Type" = Rec."Document Type"::Order) then begin
            isAutorised := false;
            if ((UpperCase(UserId) = 'EUROPACUISSON\SVEND') or (UpperCase(UserId) = 'EUROPACUISSON\ANTONELLAZ')) then begin
                Rec."Type commande" := Rec."Type commande"::Transport;
                isAutorised := true;
            end;

            if ((UpperCase(UserId) = 'EUROPACUISSON\JULIEND') or (UpperCase(UserId) = 'EUROPACUISSON\GIUSEPPEN')) then begin
                Rec."Type commande" := Rec."Type commande"::Technique;
                isAutorised := true;
            end;

            if ((UpperCase(UserId) = 'EUROPACUISSON\YANNF')) then begin
                isAutorised := true;
            end;

            if ((UpperCase(UserId) = 'EUROPACUISSON\COMPTABILITE')) then begin
                isAutorised := true;
            end;
            if ((UpperCase(UserId) = 'EUROPACUISSON\GEOFFREYD')) then begin
                isAutorised := true;
            end;
            if not isAutorised then
                Error('Vous n''êtes pas autorisé à passer une commande d''achat');
        end;
    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterDeleteEvent', '', false, false)]
    local procedure T39_Delete(var Rec: Record "Purchase Line"; RunTrigger: Boolean)
    var
        SalesHeader: Record "Sales Header";
        ShptPurchOrder: Record "Shipment Purchase Orders";
        SalesInvHeader: Record "Sales Invoice Header";
    begin
        //AB60408.V14 suppression lien commande vente
        if Rec."Transport Customer No" <> '' then begin
            if SalesHeader.Get(SalesHeader."Document Type"::Order, Rec."Transport Sales Order No") then begin
                SalesHeader."Transport Purchase Order" := '';
                //     SalesHeader.MODIFY;
            end;
            if SalesInvHeader.Get(Rec."Transport Sales Invoice No") then begin
                SalesInvHeader."Transport Purchase Order" := '';
                //     SalesInvHeader.MODIFY;
            end;
            ShptPurchOrder.Reset;
            ShptPurchOrder.SetRange("Sales Order No.", Rec."Transport Sales Order No");
            ShptPurchOrder.SetRange("Purchase Order No.", Rec."Document No.");
            if ShptPurchOrder.Find('-') then begin
                ShptPurchOrder."Purchase Order No." := '';
                ShptPurchOrder.Status := ShptPurchOrder.Status::"prévalidé";
                ShptPurchOrder.Modify;
            end;
        end;
        //AB60408.V14
    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnBeforeGetDefaultBin', '', false, false)]
    local procedure T39_GetDefaultBin(var PurchaseLine: Record "Purchase Line"; var IsHandled: Boolean)
    var
        Location: Record Location;
    begin
        if (PurchaseLine."Location Code" <> '') and (PurchaseLine."No." <> '') then begin
            Location.Get(PurchaseLine."Location Code");
            if Location."Bin Mandatory" and Location."Pallet Management" then begin
                PurchaseLine."Bin Code" := Location."Default Recept. bin";
                IsHandled := true;
            end;
        end;
    end;
}

