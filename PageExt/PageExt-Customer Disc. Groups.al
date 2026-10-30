pageextension 70501 pageextension70501 extends "Customer Disc. Groups"
{


    actions
    {
        modify(DiscountLines)
        {
            Visible = false;
        }
        modify("SalesLineDiscounts")
        {
            Visible = false;
        }
        addafter("DiscountLines")
        {
            action("SalesLineDiscountsEC")
            {
                RunObject = Page "Sales Line Discounts EC";
                RunPageView = sorting("Sales Type", "Sales Code");
                RunPageLink = "Sales Type" = CONST("Customer Disc. Group"), "Sales Code" = FIELD(Code);
            }
        }
    }


}