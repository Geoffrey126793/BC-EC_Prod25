query 50095 ActivitesABCPBI
{
    QueryType = Normal;

    elements
    {
        dataitem(ActivitesABC; "ABC - Activites")
        {
            column("Code"; "Code") { }

            column("Description"; "Description") { }

            column("Atelier"; "Atelier") { }

            column("Imputation"; "Imputation") { }

            column("On_OF"; "On OF") { }

            column("Capte"; "Capte") { }

            column("Regroupement"; "Regroupement") { }

            column("Regroupement_Description"; "Regroupement Description") { }
        }
    }
}