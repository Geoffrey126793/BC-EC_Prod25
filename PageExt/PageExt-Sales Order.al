pageextension 70106 pageextension70106 extends "Sales Order"
{
    layout
    {
        modify("VAT Reporting Date")
        {
            Visible = false;
        }
        modify("Control1900201301")  //Prepaiement
        {
            Visible = false;
        }
        modify(control4)
        {
            Visible = true;
        }
        modify("No.")
        {
            StyleExpr = TxtStyle;
            Visible = true;
        }
        modify("Sell-to Customer No.")
        {
            Importance = Standard;
            StyleExpr = TxtStyle;
        }
        modify("Sell-to Customer Name")
        {
            StyleExpr = TxtStyle;
        }

        modify("Ship-to City")
        {
            Importance = Promoted;
        }

        modify("Ship-to Country/Region Code")
        {
            Importance = Standard;
        }
        modify("Shipping Agent Code")
        {
            Importance = Standard;
        }
        modify("Location Code")
        {
            Importance = Promoted;
        }
        modify("Promised Delivery Date")
        {
            Importance = Standard;
        }

        modify("Salesperson Code")
        {
            Importance = Standard;
        }

        modify("Ship-to Code")
        {
            Importance = Standard;
        }

        addafter("No. of Archived Versions")
        {
            field(User; User)
            {
                Caption = 'Créé par';
            }
        }
        addafter("Requested Delivery Date")
        {
            field("Validation départ demandé"; "Validation départ demandé")
            {
            }
        }
        addafter("Promised Delivery Date")
        {
            field("Validation départ confirmée"; "Validation départ confirmée")
            {
            }
            field("Date livraison prévue"; "Date livraison prévue")
            {
            }
        }
        addafter("Assigned User ID")
        {
            field("Stade Relance client"; "Stade Relance client")
            {
                Style = Attention;
                StyleExpr = StadeAttention;
            }
        }
        addafter(Status)
        {
            field("Status credit"; "Status credit")
            {
                StyleExpr = TxtStyle;

                trigger OnValidate()
                var
                    CuUtils: Codeunit Utils;
                    mail: Codeunit "Email Message";
                    send: codeunit Email;
                begin
                    if not CuUtils.IsInGroup('CUST-CREDIT') then
                        Error('Vous ne pouvez pas modifer le statut crédit');
                    mail.Create('comptabilite@europacuisson.com;g.dangremont@europacuisson.com', 'CDV n°' + Rec."No." + ' pour client ' + Rec."Sell-to Customer Name", 'Statut credit modifié par ' + UserId, TRUE);

                    send.Send(mail, enum::"Email Scenario"::Default);

                end;
            }
            field("Raison retard"; "Raison retard")
            {

            }
        }
        addafter(SalesLines)
        {
            group(Transport)
            {
                Caption = 'Transport';
                field("Order type"; "Order type")
                {
                    Importance = Promoted;
                }
                field("Logistic unit"; "Logistic unit")
                {
                }
                field("Unit price/Palette"; "Unit price/Palette")
                {
                }
                field("Territory Code"; "Territory Code")
                {
                }
                field("Transport resource"; "Transport resource")
                {
                }
                field("Montant total palette"; "Montant total palette")
                {
                }
                field("Nombre de palette confirmée"; "Nombre de palette confirmée")
                {
                }
                field("Cases Quantity per Pallet"; "Cases Quantity per Pallet")
                {
                }
                field("Complete Pallet"; "Complete Pallet")
                {
                }
                field("Transport Purchase Order"; "Transport Purchase Order")
                {
                }
                field("Transport Purchase Invoice"; "Transport Purchase Invoice")
                {
                }
                field("Camion parti"; "Camion parti")
                {
                }
                field("Lié avec commande n°"; "Lié avec commande n°")
                {
                }
            }
        }

        addafter("Ship-to Contact")
        {
            field("Horaires de livraison"; "Horaires de livraison")
            {
            }
            field("Production comment"; "Production comment")
            {
            }
        }
        addafter("Shipping Agent Service Code")
        {
            field("Délai de livraison"; "Délai de livraison")
            {
            }
        }
        addafter("Shipping Advice")
        {
            field("Commentaire CMR"; "Commentaire CMR")
            {
            }
        }
        addafter("Shipping Time")
        {
            field("Blocage des lots"; "Blocage des lots")
            {
            }
        }

        addafter("Invoice Details")
        {
            field("Cout echantillon - Transport"; "Cout echantillon - Transport")
            {
            }
            field("Cout echantillon - Produits"; "Cout echantillon - Produits")
            {
            }
            group(Visa)
            {
                Caption = 'Visa';
                field("Status Visa"; "Status Visa")
                {
                }
                field("Person in charge Visa"; "Person in charge Visa")
                {
                }
                field("Bon Pour Expédition"; "Bon Pour Expédition")
                {
                }
                field("Date Visa"; "Date Visa")
                {
                }
                field("Shipment Person in charge Visa"; "Shipment Person in charge Visa")
                {
                }
                field("Shipment Date Visa"; "Shipment Date Visa")
                {
                }
            }
        }
        addafter(SalesDocCheckFactbox)
        {
            part("Détail article"; "Item EC Factbox Sales")
            {
                Provider = SalesLines;
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Document No."),
                              "Line No." = FIELD("Line No.");
            }
        }
        moveafter(SalesLines; "Shipping and Billing")
    }
    actions
    {

        addafter(Reopen)
        {
            action("Actualiser crédit")
            {

                trigger OnAction()
                var
                    CuSales: Codeunit Integration_Sales;
                begin
                    CuSales.CheckCreditClient2(Rec."Sell-to Customer No.");
                end;
            }
        }
        addafter(ProformaInvoice)
        {
            action("Annuler le scan")
            {
                Caption = 'Annuler le scan';

                trigger OnAction()
                var
                    PalletJnl: Record "Pallet Journal";
                begin

                    if Confirm('Supprimer le scan ?') then begin
                        PalletJnl.Reset;
                        PalletJnl.SetRange("Journal Template Name", "No.");
                        PalletJnl.DeleteAll;
                    end;
                end;
            }
        }
        addafter("Work Order")
        {

            action("Traca viandes")
            {

                trigger OnAction()
                var
                    PTraca: Page "Item TracingEC";
                begin
                    PTraca.TrackCDV("No.");
                    PTraca.Run;
                end;
            }
            action("Fiches palettes expédition")
            {
                Caption = 'Fiches palettes expédition';


                trigger OnAction()
                var
                    PFicheExpe: Page "Palettes expedition";
                    Pal: Record Pallet;
                begin
                    if "Last Shipping No." <> '' then
                        Error('Commande déjà expédie => A modifier sur la livraison');
                    PFicheExpe.setCommande("No.");
                    Pal.Reset;
                    Pal.SetRange("Outbound Document No.", "No.");
                    Pal.SetRange(Type, Pal.Type::Expedition);
                    PFicheExpe.SetTableView(Pal);
                    PFicheExpe.Run;
                end;
            }
            action("Pro Format")
            {
                Caption = 'Pro Format';

                trigger OnAction()
                var
                    ReportProFormat_l: Report "Sales - Invoice PRO FORMA";
                    RecSalesHeader_l: Record "Sales Header";
                begin
                    //--> ABSYS GN 20061220
                    RecSalesHeader_l.SetRange("Document Type", "Document Type");
                    RecSalesHeader_l.SetRange("No.", "No.");
                    ReportProFormat_l.SetTableView(RecSalesHeader_l);
                    ReportProFormat_l.Run;
                    //<-- ABSYS GN 20061220
                end;
            }
            action("Echantillon")
            {
                Caption = 'Echantillon';

                trigger OnAction()
                var
                    ReportEch: Report "Sales - Shipment EC - Ech";
                    RecSalesHeader_l: Record "Sales Header";
                begin
                    RecSalesHeader_l.SetRange("Document Type", "Document Type");
                    RecSalesHeader_l.SetRange("No.", "No.");
                    ReportEch.SetTableView(RecSalesHeader_l);
                    ReportEch.Run;
                end;
            }
            action("Préparation de commande")
            {
                Caption = 'Préparation de commande';


                trigger OnAction()
                var
                    ReportPick_l: Report "Preparation Commande";
                    RecSalesHeader_l: Record "Sales Header";
                begin
                    RecSalesHeader_l.SetRange("Document Type", "Document Type");
                    RecSalesHeader_l.SetRange("No.", "No.");
                    ReportPick_l.SetTableView(RecSalesHeader_l);
                    ReportPick_l.Run;
                end;
            }
        }
        addafter(Action96)
        {
            separator(Action100000027)
            {
            }
            action("Calcul transport")
            {
                Caption = 'Calcul transport';


                trigger OnAction()
                var
                    lSalesLine: Record "Sales Line";
                    CuSales: Codeunit Integration_Sales;
                begin
                    if "Shipping Agent Code" = 'ENL' then begin
                        lSalesLine.Reset;
                        lSalesLine.SetRange("Document Type", Rec."Document Type");
                        lSalesLine.SetRange("Document No.", Rec."No.");
                        lSalesLine.SetRange("Transport line", true);
                        lSalesLine.SetRange("Free Line", false);
                        lSalesLine.SetRange(lSalesLine.Consign, false);
                        if not lSalesLine.FindFirst then begin
                            if Rec."Transport resource" = '' then
                                Rec."Transport resource" := 'TRFRAIS';
                            CuSales.AddTransportLine(Rec);
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
                    end
                    else begin
                        CuSales.CalcTransport(Rec);
                    end;
                end;
            }
            action("Créer/mettre à jour ligne transport")
            {
                Caption = 'Créer/mettre à jour ligne transport';

                trigger OnAction()
                begin
                    ShptPurchOrder.GetSalesOrders('', '', '', "No.");  //AB60408.V14
                end;
            }
            action("Départ du camion")
            {
                Caption = 'Départ du camion';

                trigger OnAction()
                begin
                    "Camion parti" := true;
                    Modify;
                end;
            }
        }
        modify(PostAndSend_Promoted)
        {
            visible = false;
        }
        modify(PreviewPosting_Promoted)
        {
            visible = false;
        }
        modify(PostAndNew_Promoted)
        {
            visible = false;
        }
        modify("Create &Warehouse Shipment_Promoted")
        {
            visible = false;
        }
        modify("Create Inventor&y Put-away/Pick_Promoted")
        {
            visible = false;
        }
        modify("Archive Document_Promoted")
        {
            visible = false;
        }
        addafter("Archive Document_Promoted")
        {
            actionref("Fiches palettes expédition_promotedEC"; "Fiches palettes expédition")
            {

            }
        }
    }

    var
        lrec_CompanyInfo: Record "Company Information";
        lrec_SalesSetup: Record "Sales & Receivables Setup";
        lrec_AlertMgt: Record "Alert Management";
        lfrm_DisplayAlert: Page "Display Alert";
        Text001: Label 'Alert on Customer %1';

    var
        ShptPurchOrder: Record "Shipment Purchase Orders";
        ShptPurchForm: Page "Shipment Purchase Orders";
        PurchInvLine: Record "Purch. Inv. Line";
        PostedPurchInv: Page "Posted Purchase Invoices";
        AB6Tools: Codeunit "Absys - tools PJ";

        SalesUser: Boolean;

        StadeAttention: Boolean;

        StadeProb: Boolean;
        TxtStyle: Text;

    trigger OnAfterGetRecord()
    begin
        CalcFields("Stade Relance client");
        StadeProb := "Stade Relance client" = 3;
        StadeAttention := ("Stade Relance client" = 2);
        TxtStyle := 'Standard';
        if ("Stade Relance client" = 3) then TxtStyle := 'Unfavorable';
        if ("Stade Relance client" = 2) then TxtStyle := 'Attention';
        if ("Stade Relance client" = 1) then TxtStyle := 'Ambiguous';
    end;


    trigger OnOpenPage()
    begin
        if not (AB6Tools.GetRole('SALES-CUST2') or AB6Tools.GetRole('SALES-CUST4')) then begin
            CurrPage.Editable := false;
        end;
        SalesUser := AB6Tools.GetRole('SALES-CUST2');
    end;
}

