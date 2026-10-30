query 50019 Versions2
{

    elements
    {
        dataitem(Item; Item)
        {
            DataItemTableFilter = Blocked = CONST (false), "No." = CONST ('5-MLX-00328');
            column(No; "No.")
            {
            }
            dataitem(Production_BOM_Version; "Production BOM Version")
            {
                DataItemLink = "Production BOM No." = Item."Production BOM No.";
                column(Version_Code; "Version Code")
                {
                }
                column(Starting_Date; "Starting Date")
                {
                }
                column(Status; Status)
                {
                }
            }
        }
    }
}

