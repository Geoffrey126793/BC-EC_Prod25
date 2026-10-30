page 8001310 "Statistic definition"
{
    // //STATSEXPLORER STATSEXPLORER 20/01/00 Statistic definition

    Caption = 'Statistic definition';
    PageType = List;
    SourceTable = "Statistic definition";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                Editable = false;
                ShowCaption = false;
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

