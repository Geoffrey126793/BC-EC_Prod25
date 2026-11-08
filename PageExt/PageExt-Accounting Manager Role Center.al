pageextension 70237 pageextension70237 extends "Accounting Manager Role Center"
{

    layout
    {
        addfirst(rolecenter)
        {
            part(AllEC; AllCueEC)
            {
                ApplicationArea = All;
            }
        }
        modify(Control100)
        {
            Visible = false;
        }
    }
    actions
    {
        modify("Cash Flow Date List")
        {
            Visible = false;
        }
        modify("Cost Accounting P/L Statement")
        {
            Visible = false;
        }
        modify("CA P/L Statement per Period")
        {
            Visible = false;
        }
        modify("CA P/L Statement with Budget")
        {
            Visible = false;
        }
        modify(Budgets)
        {
            Visible = false;
        }
        modify("Finance Charge Memos")
        {
            Visible = false;
        }
        modify("Cash Flow")
        {
            Visible = false;
        }
        modify("Cost Accounting")
        {
            Visible = false;
        }
        modify("P&ost Inventory Cost to G/L")
        {
            Visible = false;
        }
        modify("Cash Flow Setup")
        {
            Visible = false;
        }
        modify("Cost Accounting Setup")
        {
            Visible = false;
        }
        addafter("Purchase Orders")
        {
            action("<Page Purchase Invoice>")
            {
                ApplicationArea = Suite;
                Caption = 'Factures achats';
                RunObject = Page "Purchase Invoices";
            }
        }
        addafter(GeneralJournals)
        {
            action("Feuilles financières")
            {
                Caption = 'Feuilles financières';
                RunObject = Page "General Journal Batches";
                RunPageView = WHERE("Template Type" = CONST("General"),
                                    Recurring = CONST(false));
            }
        }
    }
}

