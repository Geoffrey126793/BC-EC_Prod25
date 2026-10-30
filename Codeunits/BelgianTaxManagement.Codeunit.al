codeunit 50006 "Belgian Tax Management"
{

    trigger OnRun()
    begin
    end;

    [Scope('OnPrem')]
    procedure GenerateItemTaxes(var SalesLine: Record "Sales Line"): Boolean
    begin
    end;

    [Scope('OnPrem')]
    procedure CreateSalesTaxLines(SalesLine: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
        TaxSalesLine: Record "Sales Line";
    begin
    end;

    [Scope('OnPrem')]
    procedure CreateGroupingSalesTaxLines(SalesLine: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
        TaxSalesLine: Record "Sales Line";
    begin
    end;

    [Scope('OnPrem')]
    procedure DeleteAttachLine(SalesLine: Record "Sales Line")
    var
        SalesLine2: Record "Sales Line";
    begin
    end;

    [Scope('OnPrem')]
    procedure PostInvItemTaxes(var InvoiceLine: Record "Sales Invoice Line"): Boolean
    begin
    end;

    [Scope('OnPrem')]
    procedure PostInvTaxLines(InvoiceLine: Record "Sales Invoice Line")
    begin
    end;

    [Scope('OnPrem')]
    procedure PostCrMemoItemTaxes(var CrMemoLine: Record "Sales Cr.Memo Line"): Boolean
    begin
    end;

    [Scope('OnPrem')]
    procedure PostCrMemoTaxLines(CrMemoLine: Record "Sales Cr.Memo Line")
    begin
    end;

    [Scope('OnPrem')]
    procedure UpdateItemTaxFromBOM(BOMLine: Record "BOM Component")
    begin
    end;
}

