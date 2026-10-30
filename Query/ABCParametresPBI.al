query 50091 "ABC Parametres Details"
{
    QueryType = Normal;

    elements
    {
        dataitem(ABC_Parametres; "ABC - Parametres")
        {
            column(Production_BOM_No; "Production BOM No") { }
            column(BOM_Version; "BOM Version") { }
            column(Activity; Activity) { }
            column(Ressource; Ressource) { }
            column(Rendement_nominal; "Rendement nominal") { }
            column(OEE; "OEE (%)") { }
            column(Rendement_effectif; "Rendement effectif") { }
            column(Unite; "Unité") { }
            column(Nombre_operateurs; "Nombre d'opérateurs") { }
            column(Batch_standard; "Batch standard") { }
            column(LineNo; LineNo) { }
            column(Cout_Kg; "Cout Kg") { }
            column(Ressource_description; "Ressource description") { }
            column(Activity_description; "Activity description") { }
            column(Hr_Prod_Kg; "Hr Prod Kg") { }
            column(Type; Type) { }
            column(Imputation_Ressource; "Imputation Ressource") { }
            column(Rendement; Rendement) { }

            dataitem(ABC_Activites; "ABC - Activites")
            {
                SqlJoinType = InnerJoin;

                DataItemLink =
                    Code = ABC_Parametres.Activity;

                column(ActiviteDesc; Description) { }

                dataitem(ABC_Ressources; "ABC - Ressources")
                {
                    SqlJoinType = InnerJoin;

                    DataItemLink =
                        Code = ABC_Parametres.Ressource;

                    column(RessourceDesc; Description) { }
                }
            }
        }
    }
}