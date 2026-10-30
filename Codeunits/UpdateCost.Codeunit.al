codeunit 50036 "Update Cost"
{

    trigger OnRun()
    var
        R50040: Report "Nouveaux couts";
        f: Text[250];
        FTxt: File;
        convert_ansi: Codeunit Utils;
        emailmsg: Codeunit "Email Message";
        emailsend: Codeunit Email;
        s: Text[250];
        FileMgt: Codeunit "File Management";
        TempBlob: codeunit "Temp Blob";
        InS: InStream;
    begin
        Items.Reset;
        Items.SetRange(Blocked, false);
        Items.SetRange("Replenishment System", Items."Replenishment System"::Purchase);
        if Items.FindSet then
            repeat
                Items."Unit Cost" := Items."Standard Cost";
                Items.Modify(false);
            until Items.Next = 0;

        Items.Reset;
        Items.SetRange(Blocked, false);
        if Items.FindSet then
            repeat
                Clear(CalcStdCost);
                CalcStdCost.CalcItem(Items."No.", false);
            until Items.Next = 0;

        f := '\\srvnavision\NavisionTemp\HistoCouts\Modif_Couts_'
         + Format(Date2DMY(Today, 3)) + Format(Date2DMY(Today, 2)) + Format(Date2DMY(Today, 1)) + '.pdf';


        R50040.SaveAsPdf(f);



        if (R50040.getCount() > 0) then begin
            emailmsg.Create('g.dangremont@europacuisson.com;manon.mate@europacuisson.com;dagobert.blase@europacuisson.com;julio.mate@europacuisson.com',
            'Couts standards', '', true);
            if FileMgt.ServerFileExists(f) then begin
                FileMgt.BLOBImportFromServerFile(TempBlob, f);
                TempBlob.CreateInStream(InS);
                emailmsg.AddAttachment('Couts standards.pdf', 'application/pdf', InS);
            end;

            emailsend.Send(emailmsg, Enum::"Email Scenario"::Default);


        end;
    end;

    var
        Items: Record Item;
        CalcStdCost: Codeunit "Calculate Standard Cost";
}

