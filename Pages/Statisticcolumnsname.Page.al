page 8001306 "Statistic column's name"
{
    // //STATSEXPLORER STATSEXPLORER 20/01/00 Statistic column's name

    Caption = 'Statistic column''s name';
    CardPageID = "Statistic columns";
    PageType = List;
    SourceTable = "Column style name";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
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
        area(navigation)
        {
            group("&Column")
            {
                Caption = '&Column';
                action("&Copy")
                {
                    Caption = '&Copy';
                    Image = Copy;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Report "Copy column style";
                }
                action("Statistics Columns")
                {
                    Caption = 'Statistics Columns';
                    Image = Worksheet;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Statistic columns";
                    RunPageLink = Code = FIELD (Code);
                    RunPageView = SORTING (Code, "Line No.")
                                  ORDER(Ascending);
                }
            }
        }
    }
}

