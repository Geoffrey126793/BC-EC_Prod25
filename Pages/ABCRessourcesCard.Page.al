page 50054 "ABC - Ressources Card"
{
    SourceTable = "ABC - Ressources";

    layout
    {
        area(content)
        {
            field("Code"; Code)
            {
            }
            field(Description; Description)
            {
            }
            field("Description 2"; "Description 2")
            {
            }
            field("Rendement nominal"; "Rendement nominal")
            {
            }
            field(Type; Type)
            {
            }
            field("Type Cout"; "Type Cout")
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Couts)
            {
                RunObject = Page "Historique Couts";
                RunPageLink = Ressource = FIELD (Code);
            }
        }
    }
}

