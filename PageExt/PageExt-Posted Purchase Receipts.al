pageextension 70037 pageextension70037 extends "Posted Purchase Receipts"
{
    layout
    {
        modify("No.")
        {
            Width = 15;
        }

        modify("Document Date")
        {
            visible = true;
        }

        modify("Posting Date")
        {
            visible = true;
        }

        addafter("Document Date")
        {
            field("Vendor Shipment No."; "Vendor Shipment No.")
            {
            }
            field("User ID"; "User ID")
            {
            }
            field("Order No."; "Order No.")
            {
            }
        }
    }
}

