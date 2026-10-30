codeunit 50028 "Print palet Etiq2"
{
    TableNo = Pallet;

    trigger OnRun()
    var
        Pal: Record Pallet;
    begin
        Pal.Reset;
        Pal.SetFilter("SSCC No.", Rec."SSCC No.");
        Pal.FindFirst;
        REPORT.RunModal(50024, false, false, Pal);
    end;
}

