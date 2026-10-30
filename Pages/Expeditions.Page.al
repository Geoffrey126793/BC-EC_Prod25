page 50070 Expeditions
{
    Caption = 'Expeditions';
    PageType = List;
    SourceTable = "Sales Shipment Header";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                }
                field("Bill-to Name"; "Bill-to Name")
                {
                }
                field("Ship-to City"; "Ship-to City")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Order No."; "Order No.")
                {
                }
                field("Promised Delivery Date"; "Promised Delivery Date")
                {
                }
                field("Requested Delivery Date"; "Requested Delivery Date")
                {
                }
                field("Transport Purchase Order"; "Transport Purchase Order")
                {
                }
                field("Camion parti"; "Camion parti")
                {
                }
            }
        }
    }

    actions
    {
    }
}

