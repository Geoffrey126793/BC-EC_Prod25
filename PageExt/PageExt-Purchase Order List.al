pageextension 70261 pageextension70261 extends "Purchase Order List"
{
    layout
    {
        modify("No.")
        {
            Width = 15;
        }
        addafter("Payment Terms Code")
        {
            field("Promised Receipt Date"; "Promised Receipt Date")
            {
            }
        }
        addafter("Shipment Method Code")
        {
            field(User; User)
            {
            }
        }
        addafter("Posting Description")
        {
            field("Status Visa"; "Status Visa")
            {
            }
            field("Completely Received"; "Completely Received")
            {
            }
        }
    }


    trigger OnOpenPage()
    begin
        Ascending(false);
        if FindFirst then;
    end;
}

