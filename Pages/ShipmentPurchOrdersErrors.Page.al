page 50021 "Shipment Purch. Orders Errors"
{
    Caption = 'Shipment Purch. Orders Errors';
    PageType = List;
    SourceTable = "Shipment Purch. Order Errors";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Type)
                {
                }
                field("Order No."; "Order No.")
                {
                }
                field("Shipping Agent Code"; "Shipping Agent Code")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Promised Delivery Date"; "Promised Delivery Date")
                {
                }
                field(Description; Description)
                {
                }
            }
        }
    }

    actions
    {
    }
}

