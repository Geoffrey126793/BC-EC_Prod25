pageextension 50111 pageextincomingdocuments extends "Incoming Documents"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field(Statut; Statut)
            { }
            field("Order No."; "Order No.")
            { }
            field("Amount Excl. VAT"; "Amount Excl. VAT")
            { }
            field("Vendor Resp Center"; "Vendor Resp Center")
            { }
        }
        modify("OCR Status")
        {
            Visible = false;
        }
        modify("OCR Track ID")
        {
            visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}