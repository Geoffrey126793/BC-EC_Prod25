pageextension 70143 pageextension70143 extends "Employee Card"
{
    layout
    {
        addafter("Last Date Modified")
        {
            field(PIN; PIN)
            {
            }
        }
        addafter("Privacy Blocked")
        {
            field("Responsable tactile"; "Responsable tactile")
            {
            }
        }
        addafter(Pager)
        {
            field("Fax No."; "Fax No.")
            {
            }
        }
        addafter("Salespers./Purch. Code")
        {
            field(User; User)
            {
            }
        }
    }
    actions
    {
        addafter(Action23)
        {
            action("Code barre")
            {
                Caption = 'Code barre';

                trigger OnAction()
                var
                    recEmp: Record Employee;
                begin
                    recEmp.Reset;
                    recEmp.SetFilter("No.", '%1', "No.");
                    REPORT.Run(50079, true, false, recEmp);
                end;
            }
        }
    }
}

