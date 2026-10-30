report 50098 "Envoi relances"
{
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Issued Reminder Header"; "Issued Reminder Header")
        {
            RequestFilterFields = "No.", "Posting Date", "Reminder Level";

            trigger OnAfterGetRecord()
            var
                Cu50038: Codeunit Integration_EMail;
            begin
                Txt := '';
                RemindH.Reset;
                RemindH.SetRange("No.", "No.");
                RemindH.FindFirst;

                if Cust.Get("Issued Reminder Header"."Customer No.") then
                    if (Cust."Payment Method Code" = '1-LCR') or (Cust."Payment Method Code" = '1-LCR') then
                        CurrReport.Skip;

                // Prevent miss click ...
                if ("Issued Reminder Header"."Posting Date" < CalcDate('<-7D>', Today)) then CurrReport.Skip;


                EMails := Cu50038._GetEMailsRespForEntity(DATABASE::Customer, "Issued Reminder Header"."Customer No.", 'S02');
                if EMails <> '' then begin
                    RemindH.PrintRecords(false, true, true);
                    Change.ReminderSend("Issued Reminder Header"."No.");
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        Message('Envoi terminé');
    end;

    var
        Mail: Codeunit Mail;
        RemindH: Record "Issued Reminder Header";
        Txt: Text[50];
        EMails: Text;
        Change: Codeunit ModifTables;
        Cust: Record Customer;
}

