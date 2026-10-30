codeunit 50014 PatchOEE
{

    trigger OnRun()
    var
        ItemsRendements: Report "MaJ Rendement";
    begin
        ItemsRendements.SaveAsPdf('\\srvnavision.europacuisson.local\NavisionTemp\UpdRendements.pdf');
        Work();
    end;

    var
        xFile: File;
        Txt: Text;
        ProdH: Record "Production Order";

    local procedure PlannedOF()
    begin
        Clear(xFile);
        xFile.TextMode := true;
        xFile.WriteMode := true;
        xFile.Create('\\srvnavision.europacuisson.local\NavisionTemp\PatchOEE\Planned.csv');

        Txt := '';
        ProdH.Reset;
        ProdH.SetRange(Status, ProdH.Status::Released);
        ProdH.SetRange("Starting Date", Today, CalcDate('<+5D>', Today));
        ProdH.SetFilter(Machine, GetMachineFilter);
        xFile.Write(Txt);
        if ProdH.FindSet then
            repeat
                Txt := ProdH."No." + ';';
                Txt += ProdH."Source No." + ';';
                Txt += DelChr(Format(ProdH.Quantity, 0, '<Integer>'), '=', '.') + ';';
                Txt += ProdH.Machine + ';';
                Txt += ';';
                Txt += Format(ProdH."Starting Date-Time", 0, '<Year4>-<Month,2>-<Day,2> <Hours24,2>:<Minutes,2>') + ';';

                xFile.Write(Txt);
            until ProdH.Next = 0;
        xFile.Close();
    end;

    local procedure FinishedOF()
    var
        Comp: Record "Company Information";
    begin
        Clear(xFile);
        Comp.Get;
        Comp.SeqIDPtachOEE += 1;
        Comp.Modify;
        xFile.TextMode := true;
        xFile.WriteMode := true;
        xFile.Create('\\srvnavision.europacuisson.local\NavisionTemp\PatchOEE\OEE_ProductionData_' + Format(CurrentDateTime, 0, '<Year4><Month,2><Day,2>_<Hours24,2><Minutes,2><Seconds,2>') + '_' + Format(Comp.SeqIDPtachOEE) + '.xml');

        Txt := '';
        xFile.Write('<ProductionData>');
        xFile.Write('<Header>');
        xFile.Write('<SequenceID>' + Format(Comp.SeqIDPtachOEE) + '</SequenceID>');
        xFile.Write('</Header>');
        xFile.Write('<Data>');
        ProdH.Reset;
        ProdH.SetRange(Status, ProdH.Status::Finished);
        ProdH.SetRange("Due Date", CalcDate('<-15D>', Today), Today);
        ProdH.SetFilter(Machine, GetMachineFilter);
        xFile.Write(Txt);
        if ProdH.FindSet then
            repeat
                ProdH.CalcFields("Quantité réalisée");
                xFile.Write('<NettDeclaration>');
                xFile.Write('<Timestamp>' + Format(CurrentDateTime, 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>.000') + '</Timestamp>');
                xFile.Write('<ScheduleCode>' + ProdH."No." + '</ScheduleCode>');
                xFile.Write('<NettQuantity>' + DelChr(Format(ProdH."Quantité réalisée", 0, '<Integer>'), '=', '.') + '</NettQuantity>');
                xFile.Write('</NettDeclaration>');
            until ProdH.Next = 0;
        xFile.Write('</Data>');
        xFile.Write('</ProductionData>');

        xFile.Close();
    end;

    local procedure Work()
    begin
        PlannedOF();
        FinishedOF();
    end;

    local procedure GetMachineFilter(): Text
    begin
        exit('LIGNE IQF 1|LIGNE IQF 2|LIGNE IQF 3');
    end;
}

