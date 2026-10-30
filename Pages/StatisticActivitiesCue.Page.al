page 8001328 "Statistic Activities Cue"
{
    Caption = 'Statistic Activities Cue';
    PageType = CardPart;
    SourceTable = "Statistic Cue";

    layout
    {
        area(content)
        {
            cuegroup(Statistic)
            {
                Caption = 'Staistic';
                field(Statistic1; Statistic)
                {
                    DrillDownPageID = "Statistic definition";
                }
                field("Statistic for the user"; "Statistic for the user")
                {
                    DrillDownPageID = "Statistic definition";
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Reset;
        if not Get then begin
            Init;
            Insert;
        end;

        SetFilter("User ID Filter", '%1', UserId);
    end;
}

