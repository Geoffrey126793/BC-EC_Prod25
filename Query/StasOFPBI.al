query 50098 StatsOFPBI
{
    QueryType = Normal;

    elements
    {
        dataitem(Stats_OF; "Stats OF")
        {

            column("OF"; "OF") { }
            column("Date"; "Date") { }
            column("Quantite_produite"; "Quantite produite") { }
            column("Article"; "Article") { }
            column("Type_source"; "Type source") { }
            column("source"; "source") { }
            column("Quantité_utilisee"; "Quantité utilisee") { }
            column("Cout_total"; "Cout total") { }
            column("Cout_unitaire"; "Cout unitaire") { }
            column("Lot"; "Lot") { }
            column("Niveau"; "Niveau") { }
            column("Direction"; "Direction") { }
            column("Cout_total_standard"; "Cout total standard") { }
            column("Cout_unitaire_standard"; "Cout unitaire standard") { }
            column("Cout_total_nomencl_std"; "Cout total nomencl std") { }
            column("Cout_unitaire_nomencl_std"; "Cout unitaire nomencl std") { }
            column("Quantité_nomenclature"; "Quantité nomenclature") { }
            column("Quantité_intermédiaire"; "Quantité intermédiaire") { }
            column("Ecriture"; "Ecriture") { }
            column("Cout_unitaire_direct_ateliers"; "Cout unitaire direct ateliers") { }
            column("Cout_total_direct_ateliers"; "Cout total direct ateliers") { }
            column("Quantité_intermédiaire_nomencl"; "Quantité intermédiaire nomencl") { }
            column("Quantité_nomenclature_OF"; "Quantité nomenclature OF") { }
            column("Cout_total_nomenclature_OF"; "Cout total nomenclature OF") { }
            column("Cout_unitaire_nomencl_OF"; "Cout unitaire nomencl OF") { }
            column("Quantité_intermédiaire_nom_OF"; "Quantité intermédiaire nom OF") { }
            column("source2"; "source2") { }
            column("Cru"; "Cru") { }
        }
    }

}