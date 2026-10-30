page 50014 "Invoices bound by Receipt"
{
    Caption = 'Invoices bound by Receipt';
    PageType = List;
    SourceTable = "Receipt Invoiced";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Invoice No."; "Invoice No.")
                {
                }
                field("Receipt No."; "Receipt No.")
                {
                }
                field("Order No."; "Order No.")
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
                field("Qty. to Invoice"; "Qty. to Invoice")
                {
                }
                field("Qty. to Receive"; "Qty. to Receive")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Buy-from Vendor No."; "Buy-from Vendor No.")
                {
                }
                field("Buy-from Vendor Name"; "Buy-from Vendor Name")
                {
                }
                field("Receipt Posting Date"; "Receipt Posting Date")
                {
                }
                field("Vendor Order No."; "Vendor Order No.")
                {
                }
                field("Vendor Invoice No."; "Vendor Invoice No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

