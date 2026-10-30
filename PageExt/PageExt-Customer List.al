pageextension 70073 pageextension70073 extends "Customer List"
{
    layout
    {
        modify(Name)
        {
            StyleExpr = TxtStyle;
        }
        modify("Post Code")
        {
            Visible = true;
        }
        modify("Country/Region Code")
        {
            Visible = true;
        }

        modify("Salesperson Code")
        {
            Visible = true;
        }

        modify("Customer Posting Group")
        {
            Visible = true;
        }

        modify("Customer Price Group")
        {
            Visible = true;
        }

        modify("Customer Disc. Group")
        {
            Visible = true;
        }

        modify("Payment Terms Code")
        {
            Visible = true;
        }

        modify("Currency Code")
        {
            Visible = true;
        }

        modify("Language Code")
        {
            Visible = true;
        }

        modify("Search Name")
        {
            Visible = true;
        }

        modify("Credit Limit (LCY)")
        {
            Visible = true;
        }


        addafter("No.")
        {
            field("Stade rappel calculé"; "Stade rappel calculé")
            {
                Style = Attention;
                StyleExpr = StadeAttention;
            }
        }
        addafter("Post Code")
        {
            field(City; City)
            {
            }
        }
        addafter(Blocked)
        {
            field("Criteria 2"; "Criteria 2")
            {
            }
            field("Délai régl. moyen (jours) N -1"; "Délai régl. moyen (jours) N -1")
            {
            }
            field("Délai régl. moyen (jours) N"; "Délai régl. moyen (jours) N")
            {
            }
            field("VAT Registration No."; "VAT Registration No.")
            {
            }
            field("Criteria 5"; "Criteria 5")
            {
            }
            field("Invoice Amounts"; "Invoice Amounts")
            {
            }
            field("Payment Method Code"; "Payment Method Code")
            {
            }
            field("E-Mail"; "E-Mail")
            {
            }
            field("Criteria 1"; "Criteria 1")
            {
            }
        }
        addafter("Ship-to Code")
        {
            field("Criteria 10"; "Criteria 10")
            {
            }
        }
        addafter("Base Calendar Code")
        {
            field("Net Change"; "Net Change")
            {
            }
            field("Net Change (LCY)"; "Net Change (LCY)")
            {
            }
            field("Outstanding Orders"; "Outstanding Orders")
            {
            }
        }
        addafter("Payments (LCY)")
        {
            field("Covered date"; "Covered date")
            {
            }
            field("Ouverture Dossier COFACE"; "Ouverture Dossier COFACE")
            {
            }
            field("Coface No."; "Coface No.")
            {
            }
            field("Limite crédit interne"; "Limite crédit interne")
            {
            }
            field("Limite crédit générale"; "Limite crédit générale")
            {
            }
            field("Limite crédit additionnelle"; "Limite crédit additionnelle")
            {
            }
            field("Limite crédit non dénommée"; "Limite crédit non dénommée")
            {
            }
        }
    }
    actions
    {
        modify("Sales_Prices")
        {
            Visible = false;
        }
        modify("Prices_Prices")
        {
            Visible = false;
        }
        modify("Prices_LineDiscounts")
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

        addafter("PriceLists")
        {
            action(Sales_PricesEC)
            {
                ApplicationArea = Advanced;
                Caption = 'Prices';
                Image = Price;
                RunObject = Page "Sales PricesEC";
                RunPageLink = "Sales Type" = CONST(Customer),
                              "Sales Code" = FIELD("No.");
                RunPageView = SORTING("Sales Type", "Sales Code");
                ToolTip = 'View or set up different prices for items that you sell to the customer. An item price is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.';
            }
        }
        addafter("DiscountLines")
        {
            action(Sales_LineDiscountsEC)
            {
                ApplicationArea = Advanced;
                Caption = 'Line Discounts';
                Image = LineDiscount;
                RunObject = Page "Sales Line Discounts EC";
                RunPageLink = "Sales Type" = CONST(Customer),
                              "Sales Code" = FIELD("No.");
                RunPageView = SORTING("Sales Type", "Sales Code");
                ToolTip = 'View or set up different discounts for items that you sell to the customer. An item discount is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.';
                Visible = false;
            }
        }
        addafter("DiscountLines")
        {
            action(Prices_PricesEC)
            {
                ApplicationArea = Advanced;
                Caption = 'Prices';
                Image = Price;
                RunObject = Page "Sales PricesEC";
                RunPageLink = "Sales Type" = CONST(Customer),
                              "Sales Code" = FIELD("No.");
                RunPageView = SORTING("Sales Type", "Sales Code");
                Scope = Repeater;
                ToolTip = 'View or set up different prices for items that you sell to the selected customer. An item price is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.';
            }
            action(Prices_LineDiscountsEC)
            {
                ApplicationArea = Advanced;
                Caption = 'Line Discounts';
                Image = LineDiscount;
                RunObject = Page "Sales Line Discounts EC";
                RunPageLink = "Sales Type" = CONST(Customer),
                              "Sales Code" = FIELD("No.");
                RunPageView = SORTING("Sales Type", "Sales Code");
                Scope = Repeater;
                ToolTip = 'View or set up different discounts for items that you sell to the customer. An item discount is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.';
            }
        }
    }

    var
        StadeAttention: Boolean;
        StadeProb: Boolean;
        AB6Tools: Codeunit "Absys - tools PJ";
        UserMgt: Codeunit "User Setup Management";

    var
        TxtStyle: Text;

    trigger OnAfterGetRecord()
    begin
        TxtStyle := 'Standard';
        if ("Stade rappel calculé" = 3) then TxtStyle := 'Unfavorable';
        if ("Stade rappel calculé" = 2) then TxtStyle := 'Attention';
        if ("Stade rappel calculé" = 1) then TxtStyle := 'Ambiguous';
    end;


    trigger OnOpenPage()
    begin
        if not (AB6Tools.GetRole('SALES-CUST2') or (AB6Tools.GetRole('COMMERCIAUX'))) then
            Error('Désactivé');
        if UserMgt.GetRespCenter(0, '') <> '' then begin
            FilterGroup(9);
            SetFilter("Salesperson Code", UserMgt.GetRespCenter(0, ''));
            FilterGroup(0);
        end;
    end;
}

