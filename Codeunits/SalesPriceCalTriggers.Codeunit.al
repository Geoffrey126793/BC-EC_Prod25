codeunit 50010 "Sales Price Cal Triggers"
{

    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, 7000, 'OnBeforeFindSalesLinePrice', '', false, false)]
    local procedure CU7000_OnBeforeFindSalesLinePrice(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; CalledByFieldNo: Integer; var IsHandled: Boolean)
    begin
    end;
}

