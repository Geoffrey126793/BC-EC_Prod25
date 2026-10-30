pageextension 70308 pageextension70308 extends "Finished Production Order"
{
    layout
    {




        addafter(Control1905767507)
        {
            part(Control1000000001; "Logs OF Part")
            {
                Caption = 'Logs';
                SubPageLink = OF = FIELD("No.");
            }
        }
    }
    actions
    {
        addafter("&Warehouse Entries")
        {
            action(Logs)
            {
                RunObject = Page "LogsOF";
                RunPageLink = OF = FIELD("No.");
            }
        }
        addfirst(processing)
        {
            action(Reopen)
            {
                Caption = 'Reopen';
                Visible = false;

                trigger OnAction()
                var
                    Cu50045: Codeunit "Integration Tft and Prod";
                begin
                    Cu50045.Reopenof(Rec."No.");
                    Message('Ok');
                end;
            }
        }
    }


}

