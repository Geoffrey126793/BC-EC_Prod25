page 8001313 "Statistic Scheduler list"
{
    // //STATSEXPLORER STATSEXPLORER 01/08/00 Statistic Scheduler list

    Caption = 'Statistic Scheduler list';
    CardPageID = "Statistic Scheduler card";
    PageType = List;
    SourceTable = "Statistic Scheduler header";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                Editable = false;
                ShowCaption = false;
                field("Code"; Code)
                {
                }
                field(Description; Description)
                {
                }
            }
        }
    }

    actions
    {
    }
}

