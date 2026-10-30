page 8001322 "Statistic Users List"
{
    // //STATSEXPLORER STATSEXPLORER 01/01/01 Statistic Users List

    Caption = 'Statistic users';
    PageType = List;
    SourceTable = "Statistic User";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("User ID"; "User ID")
                {
                    LookupPageID = Users;
                }
            }
        }
    }

    actions
    {
    }
}

