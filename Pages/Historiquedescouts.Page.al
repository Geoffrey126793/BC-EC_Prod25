page 50076 "Historique des couts"
{
    PageType = List;
    SourceTable = "Histo couts";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Item; Item)
                {
                }
                field(Date; Date)
                {
                }
                field(Cout; Cout)
                {
                }
                field(Type; Type)
                {
                }
            }
        }
    }

    actions
    {
    }
}

