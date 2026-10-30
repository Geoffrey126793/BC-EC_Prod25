pageextension 70218 pageextension70218 extends "Customer Price Groups"
{
    layout
    {
        addafter("VAT Bus. Posting Gr. (Price)")
        {
            field("Salesperson Code"; "Salesperson Code")
            {
            }
        }
    }
    actions
    {
        modify(SalesPrices)
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
        addafter(PriceLists)
        {
            action(SalesPricesEC)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sales &Prices';
                Image = SalesPrices;
                RunObject = Page "Sales PricesEC";
                RunPageLink = "Sales Type" = CONST("Customer Price Group"),
                              "Sales Code" = FIELD(Code);
                RunPageView = SORTING("Sales Type", "Sales Code");
                ToolTip = 'Define how to set up sales price agreements. These sales prices can be for individual customers, for a group of customers, for all customers, or for a campaign.';
            }
        }
    }
}

