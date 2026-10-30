page 50075 ProcessWS
{
    PageType = List;
    SourceTable = ProcessOF;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Production BOM No"; "Production BOM No")
                {
                }
                field("BOM Version"; "BOM Version")
                {
                }
                field(Process; Process)
                {
                }
                field(Valeur; Valeur)
                {
                }
                field("Process Description"; "Process Description")
                {
                }
            }
        }
    }

    actions
    {
    }
}

