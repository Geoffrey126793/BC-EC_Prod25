pageextension 70109 pageextension70109 extends "Issued Reminder"
{
    layout
    {
        addafter("Reminder Level")
        {
            field("Language Code"; "Language Code")
            {
            }
            field("Salesperson Code"; "Salesperson Code")
            {
            }
            field("Envoi automatique"; "Envoi automatique")
            {
            }
            field("E-Mail envoyé"; "E-Mail envoyé")
            {
            }
        }
    }
    actions
    {

        Modify("Send by &Email")
        {
            trigger OnAfterAction()
            var
                ChangeT: Codeunit ModifTables;
            begin
                ChangeT.ReminderSend("No.");
            end;
        }

        addafter("&Navigate")
        {
            action("Envoyer par lot")
            {
                Caption = 'Envoyer par lot';

                trigger OnAction()
                var
                    remind: Record "Issued Reminder Header";
                begin
                    remind.Reset;
                    remind.SetFilter("Posting Date", '%1', "Posting Date");
                    REPORT.Run(50098, true, true, remind);
                end;
            }
        }
    }


}

