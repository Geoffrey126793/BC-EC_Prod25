query 50016 Nomenclatures
{

    elements
    {
        dataitem(Item; Item)
        {
            DataItemTableFilter = Blocked = CONST (false);
            column(No; "No.")
            {
            }
            dataitem(Production_BOM_Version; "Production BOM Version")
            {
                DataItemLink = "Production BOM No." = Item."Production BOM No.";
                column(Version_Code; "Version Code")
                {
                }
                column(Status; Status)
                {
                }
            }
        }
    }
}

