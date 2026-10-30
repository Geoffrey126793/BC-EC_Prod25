codeunit 50044 "Print EXV"
{
    TableNo = "Sales Shipment Header";

    trigger OnRun()
    var
        SalesShp: Record "Sales Shipment Header";
    begin
        SalesShp.Reset;
        SalesShp.SetFilter("No.", Rec."No.");
        SalesShp.FindFirst;
        REPORT.RunModal(50003, false, false, SalesShp);
        REPORT.RunModal(50008, false, false, SalesShp);
    end;
}

