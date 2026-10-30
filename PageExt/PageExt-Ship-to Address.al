pageextension 70089 pageextension70089 extends "Ship-to Address"
{
    layout
    {


        addafter("Phone No.")
        {
            field("Horaire livraison"; "Horaire livraison")
            {
            }
        }
        addafter("Service Zone Code")
        {
            field("Territory Code"; "Territory Code")
            {
            }
            field("Commentaire CMR"; "Commentaire CMR")
            {
            }
            field("ID Contraload"; "ID Contraload")
            {
            }
        }
        addafter("Last Date Modified")
        {
            field("Primary Contact No."; "Primary Contact No.")
            {
            }
        }
    }
}

