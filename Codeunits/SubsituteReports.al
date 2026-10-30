codeunit 50099 SubstituteReports
{
    trigger OnRun()
    begin

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::ReportManagement, 'OnAfterSubstituteReport', '', false, false)]
    local procedure OnSubstituteReport(ReportId: Integer; var NewReportId: Integer)
    begin
        if (ReportId = Report::"Refresh Production Order") then
            NewReportId := Report::"Refresh Production OrderEC";
        if (ReportId = Report::"Vendor - Balance to Date") then
            NewReportId := Report::"Vendor - Balance to DateEC";
        if (ReportId = Report::"Customer - Summary Aging Simp.") then
            NewReportId := Report::"Customer - Summary Aging SimEC";
        if (ReportId = Report::"Fixed Asset - Acquisition List") then
            NewReportId := Report::"Fixed Asset - Acq. ListEC";
        if (ReportId = Report::"Inventory - Reorders") then
            NewReportId := Report::"Inventory - ReordersEC";
        if (ReportId = Report::"Prod. Order - Job Card") then
            NewReportId := Report::"Prod. Order - Job CardEC";
        if (ReportId = Report::"Prod. Order - Mat. Requisition") then
            NewReportId := Report::"Prod. Order - Mat. ReqEC";
        if (ReportId = Report::"Purchase - Receipt") then
            NewReportId := Report::"Purchase - ReceiptEC";
        if (ReportId = Report::"Quantity Explosion of BOM") then
            NewReportId := Report::"Quantity Explosion of BOMEC";
        if (ReportId = Report::"Rolled-up Cost Shares") then
            NewReportId := Report::"Rolled-up Cost SharesEC";
        if (ReportId = Report::"Transfer Shipment") then
            NewReportId := Report::"Transfer ShipmentEC";
        if (ReportId = Report::"Customer - Balance to Date") then
            NewReportId := Report::"Customer - Balance to DateEC";

    end;

}