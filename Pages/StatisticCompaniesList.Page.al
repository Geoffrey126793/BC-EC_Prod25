page 8001321 "Statistic Companies List"
{
    // //STATSEXPLORER STATSEXPLORER 01/01/01 Statistic Companies List

    Caption = 'Statistic Companies';
    PageType = List;
    SourceTable = "Statistic Company";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Company; Company)
                {
                }
            }
        }
    }

    actions
    {
    }
}

