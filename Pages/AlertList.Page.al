page 50096 "Alert List"
{
    AutoSplitKey = true;
    Caption = 'Alert List';
    PageType = List;
    SourceTable = "Alert Management";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Comment; Comment)
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Ending Date"; "Ending Date")
                {
                }
                field(Active; Active)
                {
                }
                field("Event"; "Event")
                {
                }
            }
        }
    }

    actions
    {
    }
}

