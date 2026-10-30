page 50001 "Tarif transport admin"
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
                field(Pays; Pays)
                {
                }
                field("Frais admin / palette"; "Frais admin / palette")
                {
                }
                field("Frais admin / livraison"; "Frais admin / livraison")
                {
                }
                field("Frais admin (%)"; "Frais admin (%)")
                {
                }
                field("Taxes (%)"; "Taxes (%)")
                {
                }
                field("Taxes + frais admin (%)"; "Taxes + frais admin (%)")
                {
                }
                field("Accises (%)"; "Accises (%)")
                {
                }
                field("Indice du transport (%)"; "Indice du transport (%)")
                {
                }
                field("Indice du transport +admin (%)"; "Indice du transport +admin (%)")
                {
                }
                field("Indice du tpt non routier (%)"; "Indice du tpt non routier (%)")
                {
                }
                field("Frais de douane / commande"; "Frais de douane / commande")
                {
                }
                field("Frais certificat veterinaire"; "Frais certificat veterinaire")
                {
                }
                field("Remise (%)"; "Remise (%)")
                {
                }
            }
        }
    }

    actions
    {
    }
}

