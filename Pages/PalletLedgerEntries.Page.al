page 50031 "Pallet Ledger Entries"
{
    Caption = 'Pallet Ledger Entries';
    PageType = List;
    SourceTable = "Pallet Ledger Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Entry Type"; "Entry Type")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field(Description; Description)
                {
                }
                field("SSCC No."; "SSCC No.")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Bin Code"; "Bin Code")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Lot No."; "Lot No.")
                {
                }
                field("Item ledger entry No."; "Item ledger entry No.")
                {
                }
                field(Weight; Weight)
                {
                }
                field(User; User)
                {
                }
            }
        }
    }

    actions
    {
    }
}

