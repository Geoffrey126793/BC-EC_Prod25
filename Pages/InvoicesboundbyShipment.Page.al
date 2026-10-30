page 50016 "Invoices bound by Shipment"
{
    Caption = 'Invoices bound by Shipment';
    PageType = List;
    SourceTable = "Shipment Invoiced";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Invoice No."; "Invoice No.")
                {
                }
                field("Invoice Line No."; "Invoice Line No.")
                {
                }
                field("Shipment No."; "Shipment No.")
                {
                }
                field("Shipment Line No."; "Shipment Line No.")
                {
                }
                field(Type; Type)
                {
                }
                field("No."; "No.")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field(Description; Description)
                {
                }
                field("Order No."; "Order No.")
                {
                }
                field("Qty. to Invoice"; "Qty. to Invoice")
                {
                }
                field("Qty. to Ship"; "Qty. to Ship")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                }
                field("Sell-to Customer Name"; "Sell-to Customer Name")
                {
                }
                field("User ID"; "User ID")
                {
                }
                field("Customer Order No."; "Customer Order No.")
                {
                }
                field("Qty. Shipped Not Invoiced"; "Qty. Shipped Not Invoiced")
                {
                }
                field("Quantity Invoiced"; "Quantity Invoiced")
                {
                }
                field("Shipment Posting Date"; "Shipment Posting Date")
                {
                }
            }
        }
    }

    actions
    {
    }
}

