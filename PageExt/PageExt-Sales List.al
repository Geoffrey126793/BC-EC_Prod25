pageextension 70112 pageextension70112 extends "Sales List"
{
    layout
    {
        addafter("Salesperson Code")
        {
            field(User; User)
            {
            }
            field("Order type"; "Order type")
            {
            }
            field("Shipping Agent Code"; "Shipping Agent Code")
            {
            }
            field("Status Visa"; "Status Visa")
            {
            }
        }
    }
}

