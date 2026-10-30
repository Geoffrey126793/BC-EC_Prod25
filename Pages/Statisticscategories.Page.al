page 8001315 "Statistics categories"
{
    // //STATSEXPLORER STATSEXPLORER 20/01/00 Statistics categories

    Caption = 'Statistics categories';
    PageType = List;
    SourceTable = "Statistic category";

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
                field("Number of statistics"; "Number of statistics")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Categories")
            {
                Caption = '&Categories';
                action("A&utorisations")
                {
                    Caption = 'A&utorisations';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Statistics Permissions";
                    RunPageLink = Type = FILTER ("Catégorie"),
                                  Code = FIELD (Code);
                }
            }
        }
    }
}

