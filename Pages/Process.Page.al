page 50072 Process
{
    PageType = List;
    SourceTable = ProcessOF;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Process; Process)
                {
                }
                field("Process Description"; "Process Description")
                {
                }
                field(Valeur; Valeur)
                {
                }
            }
        }
    }

    actions
    {
    }
}

