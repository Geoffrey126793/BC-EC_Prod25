pageextension 70122 pageextension70122 extends "Purchase Order"
{
    layout
    {
        modify("Buy-from Vendor No.")
        {
            trigger OnAfterValidate()
            var
                lrec_CompanyInfo: Record "Company Information";
                lrec_PurchSetup: Record "Purchases & Payables Setup";
                lrec_AlertMgt: Record "Alert Management";
                lfrm_DisplayAlert: Page "Display Alert";
                Text001: Label 'Alert on Vendor %1';
            begin
                lrec_CompanyInfo.Get;
                if lrec_CompanyInfo."Use Alert Management" then begin
                    lrec_PurchSetup.Get;
                    if lrec_PurchSetup."Vendor Alert on Purch Ord/Inv" then begin
                        lrec_AlertMgt.SetCurrentKey("Table Name", "No.", "Starting Date", "Ending Date", Active, "Event");
                        lrec_AlertMgt.SetFilter("Table Name", '%1', lrec_AlertMgt."Table Name"::Vendor);
                        lrec_AlertMgt.SetFilter("No.", "Buy-from Vendor No.");
                        lrec_AlertMgt.SetFilter("Starting Date", '<=%1', WorkDate);
                        lrec_AlertMgt.SetFilter("Ending Date", '>=%1', WorkDate);
                        lrec_AlertMgt.SetRange(Active, true);
                        lrec_AlertMgt.SetRange("Event", lrec_AlertMgt."Event"::"Vendor on Purchase Order");
                        if lrec_AlertMgt.Find('-') then begin
                            lfrm_DisplayAlert.SetHeading(StrSubstNo(Text001, "Buy-from Vendor No."));
                            lfrm_DisplayAlert.SetTableView(lrec_AlertMgt);
                            if lfrm_DisplayAlert.RunModal = ACTION::OK then;
                        end;
                    end;
                end;
            end;
        }

        addafter(Status)
        {
            field(Container; Container)
            {
            }
            field(User; User)
            {
                Editable = false;
            }
            field("Type commande"; "Type commande")
            {
                Visible = showType;
            }
        }
        addfirst(Control98)
        {
            field("Nombre de camions prévus"; "Nombre de camions prévus")
            {
            }
        }

    }
    actions
    {
        modify("Send Intercompany Purchase Order")
        {
            Visible = false;
        }
        modify(SendCustom)
        {
            Visible = false;
        }
        addafter("Send Intercompany Purchase Order")
        {
            separator(Action1000000002)
            {
            }
            action("Suivi transport vente")
            {
                Caption = 'Suivi transport vente';
                RunObject = Page "Shipment Purchase Orders";
                RunPageLink = "Shipping Agent Code" = FIELD("Shipping Agent Code"),
                              "Location Code" = FIELD("Location Code"),
                              "Date Filter" = FIELD("Posting Date");
                RunPageView = SORTING("Shipping Agent Code", "Location Code", "Promised Delivery Date", "Sales Order No.");
            }
            action("<Action1000000004>")
            {
                Caption = '<Action1000000004>';

                trigger OnAction()
                var
                    l_PurchHeader: Record "Purchase Header";
                    BonTransport: Report "Edition Bon de transport";
                    PurchL: Record "Purchase Line";
                    SalesH: Record "Sales Header";
                begin
                    l_PurchHeader.Reset;
                    l_PurchHeader.SetFilter("Document Type", '%1', l_PurchHeader."Document Type"::Order);
                    l_PurchHeader.SetFilter("No.", "No.");
                    BonTransport.SetTableView(l_PurchHeader);
                    if "Location Code" = 'ECCONGEL' then
                        BonTransport.SetInfos('-18°C', 'Chargement de 10h00 à 16h00', "Posting Date")
                    else
                        BonTransport.SetInfos('+2°C', 'Chargement àpd 13h00', "Posting Date");
                    if "Location Code" = 'RD' then begin
                        PurchL.Reset;
                        PurchL.SetRange("Document Type", Rec."Document Type");
                        PurchL.SetRange("Document No.", Rec."No.");
                        if PurchL.FindFirst then begin
                            if SalesH.Get(SalesH."Document Type"::Order, PurchL."Transport Sales Order No") then
                                if SalesH."Order type" = SalesH."Order type"::"Surgelé" then
                                    BonTransport.SetInfos('-18°C', 'Chargement de 10h00 à 16h00', "Posting Date");
                        end;
                    end;
                    BonTransport.RunModal;
                end;
            }
            action("Extraire BL")
            {
                Caption = 'Extraire BL';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    cuEDIPL: Codeunit EDI;
                begin
                    cuEDIPL.SetTraca(Rec."No.");
                end;
            }
        }
        addafter(SendCustom)
        {
            action(SendMail)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send';
                Ellipsis = true;
                Image = SendToMultiple;
                Promoted = true;
                PromotedCategory = Category10;
                PromotedIsBig = true;
                ToolTip = 'Prepare to send the document according to the vendor''s sending profile, such as attached to an email. The Send document to window opens first so you can confirm or select a sending profile.';

                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                    cuMail: Codeunit Integration_EMail;
                begin
                    cuMail.SendEMailPurchaseOrder(Rec."No.");
                end;
            }
            action("<Action1000000005>")
            {
                Caption = '<Action1000000005>';
                RunObject = Page "Posted Purchase Receipt Lines";
                RunPageLink = "Order No." = FIELD("No."),
                              Quantity = FILTER(<> 0);
            }
            separator(Action1000000006)
            {
            }
        }
    }
    var
        showType: Boolean;

    trigger OnOpenPage()
    begin
        showType := (Uppercase(UserId())) = 'EUROPACUISSON\YANNF';
    end;
}

