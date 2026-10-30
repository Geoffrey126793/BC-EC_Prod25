pageextension 70101 pageextension70101 extends "General Journal"
{
    layout
    {
        modify("Document No.")
        {
            Width = 15;
        }
        modify(Description)
        {
            Width = 50;
        }
    }
    actions
    {
        modify(ImportPayrollFile)
        {
            Visible = false;
        }
        addafter(PostAndPrint)
        {
            action("Importer Excel")
            {

                trigger OnAction()
                var
                    Cu50025: Codeunit Integration_Compta;
                begin
                    Cu50025.ImportXl("Journal Template Name", "Journal Batch Name");
                end;
            }
        }
    }
}

