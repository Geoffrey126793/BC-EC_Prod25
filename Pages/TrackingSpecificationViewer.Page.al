page 50024 "Tracking Specification Viewer"
{
    Caption = 'Tracking Specification Viewer';
    SourceTable = "Journal Track. Specif Viewer";

    layout
    {
        area(content)
        {
            field("Journal Name"; "Journal Name")
            {
            }
            field("Journal Description"; "Journal Description")
            {
            }
            field("Item Filter"; "Item Filter")
            {
            }
            field("Lot No. Filter"; "Lot No. Filter")
            {
            }
            field(Direction; Direction)
            {
            }
            field("Item Filter Finish"; "Item Filter Finish")
            {
            }
            field("Only Distinct of Last Level"; "Only Distinct of Last Level")
            {
            }
            part(Control1000000001; "Tracking specif viewer subPage")
            {
                SubPageLink = "Journal Name" = FIELD ("Journal Name");
            }
        }
    }

    actions
    {
    }
}

