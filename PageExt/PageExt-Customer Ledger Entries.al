pageextension 70078 pageextension70078 extends "Customer Ledger Entries"
{
    layout
    {
        modify("Document No.")
        {
            Width = 15;
        }

        addafter("Reversed Entry No.")
        {
            field("BL No."; "BL No.")
            {
            }
        }
    }


    trigger OnOpenPage()
    begin
        if FindFirst then;
    end;
}

