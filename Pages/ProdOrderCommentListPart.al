page 50102 ProdOrderCommentListPart
{
    PageType = ListPart;
    SourceTable = "Prod. Order Comment Line";

    layout
    {
        area(Content)
        {
            repeater(repeat1)
            {
                field("Prod. Order No."; "Prod. Order No.")
                { }
                field("Date"; "Date")
                { }
                field(Comment; Comment)
                { }
            }

        }
    }


}