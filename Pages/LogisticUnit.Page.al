page 50009 "Logistic Unit"
{
    Caption = 'Logistic Unit';
    PageType = List;
    SourceTable = "Unité logistique";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Code)
                {
                }
                field("Désignation"; Désignation)
                {
                }
            }
        }
    }

    actions
    {
    }
}

