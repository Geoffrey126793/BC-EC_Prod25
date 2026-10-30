page 50002 "Tarif transport / unité"
{
    PageType = List;
    SourceTable = "Tarif transport";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Debut; Debut)
                {
                }
                field(Fin; Fin)
                {
                }
                field("Type transport"; "Type transport")
                {
                }
                field("Currency code"; "Currency code")
                {
                }
                field("Tarif / Kg"; "Tarif / Kg")
                {
                }
                field("Poids Maximum"; "Poids Maximum")
                {
                }
                field(Pays; Pays)
                {
                }
            }
        }
    }

    actions
    {
    }
}

