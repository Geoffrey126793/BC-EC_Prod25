page 8001304 "Statistics Permissions"
{
    // //STATSEXPLORER STATSEXPLORER 01/01/00 Statistics Permissions

    Caption = 'Statistics Permissions';
    PageType = List;
    SourceTable = "Statistic Permission";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Code"; Code)
                {
                    Editable = false;
                    Visible = false;
                }
                field("Authorized group"; "Authorized group")
                {
                }
            }
        }
    }

    actions
    {
    }
}

