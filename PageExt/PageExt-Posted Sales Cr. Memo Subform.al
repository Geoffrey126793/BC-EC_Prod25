pageextension 70027 pageextension70027 extends "Posted Sales Cr. Memo Subform"
{
    layout
    {
        addafter("Allow Invoice Disc.")
        {
            field("Location Code"; "Location Code")
            {
            }
        }
        addafter("Shortcut Dimension 1 Code")
        {
            field("Document Date"; "Document Date")
            {
            }
            field("Sell-to Customer No."; "Sell-to Customer No.")
            {
            }
        }
    }
}

