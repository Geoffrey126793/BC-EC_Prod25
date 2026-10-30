page 50098 "Heures ABC"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Heures ABC";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Activite; Activite)
                {
                    Editable = false;
                }
                field("Description Activite"; "Description Activite")
                {
                    Editable = false;
                }
                field(Ressource; Ressource)
                {
                    Editable = false;
                }
                field("Description Ressource"; "Description Ressource")
                {
                    Editable = false;
                }
                field(Effectif; Effectif)
                {
                }
                field(Debut; Debut)
                {
                }
                field(Fin; Fin)
                {
                }
                field("h calcule"; "h calcule")
                {
                    Editable = false;
                }
                field("Operateurs prevu"; "Operateurs prevu")
                {
                    Editable = false;
                }
                field("Activite regroupement"; "Activite regroupement")
                {
                }
            }
        }
    }

    actions
    {
    }
}

