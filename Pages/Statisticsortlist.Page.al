page 8001309 "Statistic sort list"
{
    // //STATSEXPLORER STATSEXPLORER 20/01/00 Statistic sort list

    Caption = 'Statistic sort list';
    CardPageID = "Statistic sort card";
    PageType = List;
    SourceTable = "Statistic sort criteria";
    SourceTableView = WHERE (Type = FILTER ("Tri statistique"));

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
                field("1st sort level"; "1st sort level")
                {
                }
                field("2nd sort level"; "2nd sort level")
                {
                }
                field("3rd sort level"; "3rd sort level")
                {
                }
                field("4th sort level"; "4th sort level")
                {
                }
                field("5th sort level"; "5th sort level")
                {
                }
                field("6th sort level"; "6th sort level")
                {
                }
                field("7th sort level"; "7th sort level")
                {
                }
                field("8th sort level"; "8th sort level")
                {
                }
                field("9th sort level"; "9th sort level")
                {
                }
                field("10th sort level"; "10th sort level")
                {
                }
            }
        }
    }

    actions
    {
    }
}

