page 8001423 "Codes translations"
{
    Caption = 'Codes translations';
    PageType = List;
    SourceTable = "Code Translation";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Code)
                {
                }
                field(Language; Language)
                {
                }
                field(Description; Description)
                {
                }
                field("Description 2"; "Description 2")
                {
                }
            }
        }
    }

    actions
    {
    }
}

