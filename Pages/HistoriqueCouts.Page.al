page 50093 "Historique Couts"
{
    PageType = List;
    SourceTable = "Historique Cout Ressources";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(StartDate; StartDate)
                {
                }
                field(Cost; Cost)
                {
                }
            }
        }
    }

    actions
    {
    }
}

