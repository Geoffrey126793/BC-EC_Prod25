pageextension 70199 pageextension70199 extends "Lot No. Information List"
{
    layout
    {
        modify("Item No.")
        {
            Visible = true;
        }
        modify(Inventory)
        {
            Visible = true;
        }
        addafter(Inventory)
        {
            field("Raison du blocage"; "Raison du blocage")
            {
            }
            field("Commentaire blocage"; "Commentaire blocage")
            {
            }
            field(Decision; Decision)
            {
            }
            field("Commentaire decision"; "Commentaire decision")
            {
            }
            field("Statut du blocage"; "Statut du blocage")
            {

            }
            field(Destination; Destination)
            {

            }
            field(Recyclage; Recyclage)
            {

            }


        }
    }
}

