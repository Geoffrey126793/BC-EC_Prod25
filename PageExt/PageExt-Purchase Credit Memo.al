pageextension 70142 pageextension70142 extends "Purchase Credit Memo"
{
    layout
    {
        modify("Posting Description")
        {
            Visible = true;
        }

        addafter("Assigned User ID")
        {
            field("Vérification Montant TTC"; "Vérification Montant TTC")
            {
            }
        }
    }
}

