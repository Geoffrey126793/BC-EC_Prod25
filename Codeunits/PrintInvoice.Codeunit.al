codeunit 50042 "Print Invoice"
{
    TableNo = "Sales Invoice Header";

    trigger OnRun()
    var
        Modif: Codeunit ModifTables;
    begin
        Modif.InvoiceLogo(Rec."No.", Rec.StatusLogo::Sans);
        Rec.PrintRecords(false);
        Modif.InvoiceLogo(Rec."No.", Rec.StatusLogo::NonDefini);
    end;
}

