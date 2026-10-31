pageextension 70315 pageextension70315 extends "Customer Card"
{
    layout
    {
        modify("Search Name")
        {
            Importance = Standard;
            Visible = true;
        }
        modify("VAT Registration No.")
        {
            Visible = false;
        }
        modify("Shipping Agent Code")
        {
            Importance = Standard;
        }
        modify(Control10)
        {
            Visible = false;
        }
        modify("GLN")
        {
            Visible = false;
        }

        addafter(Blocked)
        {
            field("Criteria 6"; "Criteria 6")
            {
            }
        }
        addafter(General)
        {
            group(Control1000000001)
            {
                Caption = 'Crédit';
                group("Crédit")
                {
                    field("Limite crédit non dénommée"; "Limite crédit non dénommée")
                    {
                    }
                    field("Limite crédit générale"; "Limite crédit générale")
                    {
                    }
                    field("Limite crédit additionnelle"; "Limite crédit additionnelle")
                    {
                    }
                    field("Limite crédit interne"; "Limite crédit interne")
                    {
                    }
                }
                group(Coface)
                {
                    field("Coface No."; "Coface No.")
                    {
                    }
                    field("Ouverture Dossier COFACE"; "Ouverture Dossier COFACE")
                    {
                    }
                    field("Covered date"; "Covered date")
                    {
                    }
                    field("End covered date"; "End covered date")
                    {
                    }
                    field("Rating COFACE"; "Rating COFACE")
                    {
                        Importance = Promoted;
                    }
                }
                field("Groupe crédit autorisé"; "Groupe crédit autorisé")
                {
                }
            }
        }
        addafter(AdjProfitPct)
        {
            field("N° EORI"; "N° EORI")
            {
            }
        }
        addafter("VAT Registration No.")
        {
            field(tmpTVA; tmpTVA)
            {
            }
        }
        addafter("Block Payment Tolerance")
        {
            field("Stade manuel"; "Stade manuel")
            {
            }
            field("Stade rappel calculé"; "Stade rappel calculé")
            {
            }
        }
        addafter("Shipping Advice")
        {
            field("Intervalle de commande"; "Intervalle de commande")
            {
                ToolTip = 'Intervalle habituel de commande (en semaines)';
            }
        }
        addafter(Shipping)
        {
            field("Number Copy CMR"; "Number Copy CMR")
            {
            }
            field("Number copy BL"; "Number copy BL")
            {
            }
            field("Logistic unit"; "Logistic unit")
            {
            }
            field("Territory Code"; "Territory Code")
            {
            }
            field("Schedule of delivery customer"; "Schedule of delivery customer")
            {
            }
            field("Default Ship-to Address"; "Default Ship-to Address")
            {
            }
            field("Production comment"; "Production comment")
            {
            }
            group(EDI)
            {
                field("EInvoice EAS"; "EInvoice EAS")
                {

                }
                field("EInvoice Endpoint"; "EInvoice Endpoint")
                {

                }
                field("GLN Destinataire"; "GLN Destinataire")
                {
                }
                field(GLNec; GLN)
                {
                }
                field("E-Mail EDI"; "E-Mail EDI")
                {
                }
                field("Repertoire Send AS2"; "Repertoire Send AS2")
                {
                }
                field(DESADV; DESADV)
                {
                }
                field("ID Contraload"; "ID Contraload")
                {
                }
            }
        }
        addafter(Statistics)
        {
            group(Critères)
            {
                field("Criteria 1"; "Criteria 1")
                {
                }
                field("Criteria 2"; "Criteria 2")
                {
                }
                field("Criteria 3"; "Criteria 3")
                {
                }
                field("Criteria 5"; "Criteria 5")
                {
                }
                field("Criteria 10"; "Criteria 10")
                {
                }

            }
        }
        moveafter("Balance Due (LCY)"; Blocked)
        moveafter(AdjProfitPct; "Last Date Modified")
        moveafter("Address 2"; City)
        moveafter("Post Code"; "Country/Region Code")
        moveafter("Country/Region Code"; ShowMap)
    }
    actions
    {

        modify(ApplyTemplate_Promoted)
        {
            Visible = false;
        }
        modify(MergeDuplicate_Promoted)
        {
            Visible = false;
        }
        modify(EMail_Promoted)
        {
            Visible = false;
        }

        addafter("Co&mments")
        {
            action(Alertes)
            {
                ApplicationArea = Comments;
                Caption = 'Alerts';
                Image = ViewComments;
                RunObject = Page "Alert List";
                RunPageLink = "Table Name" = CONST(Customer),
                              "No." = FIELD("No.");
                ToolTip = 'Affichez ou ajoutez des alertes pour l''enregistrement.';
            }
        }
        modify(Prices)
        {
            Visible = false;
        }
        modify("Line Discounts")
        {
            Visible = false;
        }
        modify(PriceLists)
        {
            Visible = false;
        }
        modify(PriceLines)
        {
            Visible = false;
        }
        modify(DiscountLines)
        {
            Visible = false;
        }
        modify(PriceListsDiscounts)
        {
            Visible = false;
        }
        modify("Prices and Discounts Overview")
        {
            Visible = false;
        }
        addafter(PriceLists)
        {

            action("Page Sales PricesEC")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Prices';
                Image = Price;
                RunObject = Page "Sales PricesEC";
                RunPageLink = "Sales Type" = CONST(Customer),
                              "Sales Code" = FIELD("No.");
                RunPageView = SORTING("Sales Type", "Sales Code");
                ToolTip = 'View or set up different prices for items that you sell to the customer. An item price is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.';
            }

            action("Page Sales Line DiscountsEC")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Line Discounts';
                Image = LineDiscount;
                RunObject = Page "Sales Line Discounts EC";
                RunPageLink = "Sales Type" = CONST(Customer),
                              "Sales Code" = FIELD("No.");
                RunPageView = SORTING("Sales Type", "Sales Code");
                ToolTip = 'View or set up different discounts for items that you sell to the customer. An item discount is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.';
            }
        }
        addafter(Email_Promoted)
        {
            actionref("Page Sales PricesEC_PromotedEC"; "Page Sales PricesEC")
            {

            }
            actionref("Item References_promotedEC"; "Item References")
            {

            }

            actionref("NewSalesOrder_promotedEC"; "NewSalesOrder")
            {

            }

        }
    }





    trigger OnAfterGetRecord()
    begin

    end;


    trigger OnOpenPage()
    begin
        SetFilter("Date Filter", '..%1', Today);
    end;
}

