pageextension 50101 IncomingDocumentEC extends "Incoming Document"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field(Statut; Statut)
            { }
        }
        modify("Order No.")
        {
            Editable = true;
        }
    }

    actions
    {
        // Add changes to page actions here
        addbefore(OpenDocument)
        {
            action(ShowAttachedDoc)
            {
                Caption = 'Afficher le fichier attaché';
                trigger OnAction();
                var
                    CuEInvoice: Codeunit Trigger_einvoice;
                begin
                    CuEInvoice.GetAttachedInvoiceFromIncomingDocument(rec);
                end;
            }
        }
    }


    var
        myInt: Integer;
}