pageextension 70269 pageextension70269 extends "Sales Cr. Memo Subform"
{
    layout
    {
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }

        addafter("Appl.-to Item Entry")
        {
            field("Forced Unit Price"; "Forced Unit Price")
            {
            }
        }
    }
}

