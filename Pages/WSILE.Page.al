page 50057 "WS ILE"
{
    PageType = List;
    SourceTable = "Item Ledger Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Entry Type"; "Entry Type")
                {
                }
                field("Source No."; "Source No.")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Remaining Quantity"; "Remaining Quantity")
                {
                }
                field("Order No."; "Order No.")
                {
                }
                field("Order Line No."; "Order Line No.")
                {
                }
                field("Lot No."; "Lot No.")
                {
                }
                field("Warranty Date"; dt)
                {
                }
                field("Shipped Qty. Not Returned"; "Shipped Qty. Not Returned")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        if "Warranty Date" = 0D then
            dt := 20991231D
        else
            dt := "Warranty Date"
    end;

    var
        dt: Date;
}

