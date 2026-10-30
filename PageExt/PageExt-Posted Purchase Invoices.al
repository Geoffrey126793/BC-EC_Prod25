pageextension 70038 pageextension70038 extends "Posted Purchase Invoices"
{
    layout
    {
        modify("No.")
        {
            Width = 15;
        }

        modify("Posting Date")
        {
            visible = true;
        }


        addafter("Payment Method Code")
        {
            field("Posting Description"; "Posting Description")
            {
            }
            field("Your Reference"; "Your Reference")
            {
            }
        }
        addafter(Corrective)
        {
            field("Nbre attachements"; "Nbre attachements")
            {

                trigger OnDrillDown()
                var
                    RecRef: RecordRef;
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                begin
                    RecRef.Open(DATABASE::"Purch. Inv. Header");
                    RecRef.GetTable(Rec);

                    DocumentAttachmentDetails.OpenForRecRef(RecRef);
                    DocumentAttachmentDetails.RunModal;
                end;
            }
        }
    }
}

