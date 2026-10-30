codeunit 50053 SendMailIncomingDoc
{

    trigger OnRun()
    begin
        emailmsg.Create(
         'g.dangremont@europacuisson.com', 'Facture recue ' + CompanyName, 'Facture recue', true);
        emailsend.Send(emailmsg, Enum::"Email Scenario"::Default);
    end;

    var
        emailmsg: Codeunit "Email Message";
        emailsend: codeunit Email;
}

