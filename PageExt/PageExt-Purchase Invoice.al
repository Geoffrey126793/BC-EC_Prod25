pageextension 70128 pageextension70128 extends "Purchase Invoice"
{
    layout
    {
        modify("Buy-from Contact")
        {
            QuickEntry = false;
        }

        modify("Posting Description")
        {
            Visible = true;
        }

        addafter("Assigned User ID")
        {
            field("Vérification Montant TTC"; "Vérification Montant TTC")
            {
                Importance = Promoted;
            }

            field(Note; Note)
            {

            }
        }
        moveafter("Buy-from Contact"; "Posting Date")
    }
    actions
    {
        addbefore(IncomingDocCard)
        {
            action(ShowAttachedDoc)
            {
                Caption = 'Afficher le fichier attaché';
                trigger OnAction();
                var
                    CuEInvoice: Codeunit Trigger_einvoice;
                begin
                    CuEInvoice.GetAttachedInvoiceFromPurchase(rec);
                end;
            }
        }
        // Add changes to page actions here
    }
}

