codeunit 50023 MakePDF
{

    trigger OnRun()
    begin
    end;

    var
        "Object": Record "Object";
        DefaultPrinter: Text[200];
        Window: Dialog;
        WindowisOpen: Boolean;
        RunOnceFile: Text[1000];
        TimeOut: Integer;
        PrinterSelection: Record "Printer Selection";
        PrinterSelectionBackup: Text[250];
        deletePrinterSelection: Boolean;
        resetPrinterSelection: Boolean;
        recS: Record "Sales Invoice Header";
        recS2: Record "Sales Invoice Header";
        iC: Integer;
        iCount: Integer;
        dlg: Dialog;
        Printers: Record Printer;
        recCredit: Record "Sales Cr.Memo Header";
        ReportSelection: Record "Report Selections";
        recRemindH: Record "Issued Reminder Header";
        recSales: Record "Sales Header";
        recPurch: Record "Purchase Header";

    [Scope('OnPrem')]
    procedure InvoiceValidated(No: Code[20]; ReportID: Integer; FileName: Text[250])
    begin

        recS2.Reset;
        recS2.SetFilter("No.", '%1', No);
        recS2.FindFirst;
        REPORT.SaveAsPdf(ReportID, FileName, recS2);
    end;

    [Scope('OnPrem')]
    procedure CreditMemoValidated(No: Code[20]; ReportID: Integer; FileName: Text[250])
    begin
    end;

    [Scope('OnPrem')]
    procedure ReminderIssued(No: Code[20]; ReportID: Integer; FileName: Text[250])
    begin

        recRemindH.Reset;
        recRemindH.SetFilter("No.", '%1', No);
        recRemindH.FindFirst;
        REPORT.SaveAsPdf(ReportID, FileName, recRemindH);
    end;

    [Scope('OnPrem')]
    procedure SalesOrderConfirm(No: Code[20]; ReportID: Integer; FileName: Text[250])
    begin

        recSales.Reset;
        recSales.SetFilter("No.", '%1', No);
        recSales.FindFirst;
        REPORT.SaveAsPdf(ReportID, FileName, recSales);
    end;

    [Scope('OnPrem')]
    procedure CheckCompany()
    begin
    end;

    [Scope('OnPrem')]
    procedure PurchOrderConfirm(No: Code[20]; ReportID: Integer; FileName: Text[250])
    begin

        recPurch.Reset;
        recPurch.SetFilter("No.", '%1', No);
        recPurch.FindFirst;
        REPORT.SaveAsPdf(ReportID, FileName, recPurch);

    end;
}

