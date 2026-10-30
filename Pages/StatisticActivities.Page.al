page 8001327 "Statistic Activities"
{
    Caption = 'Statistic Activities';
    PageType = CardPart;
    SourceTable = "Finance Cue";

    layout
    {
        area(content)
        {
            cuegroup(Statistic)
            {
                Caption = 'Statistic';

                actions
                {
                    action("Statictic array display")
                    {
                        Caption = 'Statictic array display';
                        RunObject = Page "Statictic array display";
                    }
                }
            }
            cuegroup("Statistic aggregate")
            {
                Caption = 'Statistic aggregate';

                actions
                {
                    action(Aggregates)
                    {
                        Caption = 'Aggregates';
                        RunObject = Page "Statistic aggregates";
                    }
                }
            }
            cuegroup(Reports)
            {
                Caption = 'Reports';

                actions
                {
                    action("Statistic report")
                    {
                        Caption = 'Statistic report';
                        RunObject = Report "Statistic report";
                    }
                }
            }
        }
    }

    actions
    {
    }
}

