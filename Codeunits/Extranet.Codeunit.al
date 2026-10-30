codeunit 50005 Extranet
{

    trigger OnRun()
    begin
        CreatePDFInvoice('NCV-E24-0251', '');
    end;

    var
        HttpWebRequestMgt: Codeunit "Http Web Request Mgt.";
        Instr: InStream;


    procedure CreatePDFInvoice(No: Code[20]; CustNo: Code[20])
    var
        SalesH: Record "Sales Invoice Header";
        SalesCr: Record "Sales Cr.Memo Header";
        RepInvoice: Report "Sales - Invoice EC";
        RepCR: Report "Sales - Credit Memo EC";
        id: Text;
        SalesCrRef: RecordRef;
        SalesHRef: RecordRef;
        TempBlob: Codeunit "Temp Blob";
        FileMgt: Codeunit "File Management";
        HttpClient: HttpClient;
        HttpResponse: HttpResponseMessage;
        InStr: InStream;
        OutStr: OutStream;
        PDFPath: Text;
        MergeURL: Text;
        ResponseText: Text;
    begin
        PDFPath := '\\192.168.5.42\NavisionTemp\Extranet\' + CompanyName + id + '.pdf';
        if not FILE.Exists(PDFPath) then begin
            id := CreateGuid();
            SalesCr.Reset;
            SalesCr.SetFilter("No.", '%1', No);
            SalesCr.SetFilter("Sell-to Customer No.", CustNo);
            if SalesCr.FindFirst then begin
                SalesCrRef.GetTable(SalesCr);
                if not Report.SaveAs(50009, '', ReportFormat::Pdf, OutStr, SalesCrRef) then
                    Error('Erreur génération PDF');
                TempBlob.CreateInStream(InStr);
                FileMgt.BLOBExportToServerFile(TempBlob, PDFPath);

                MergeURL := 'http://intranet.europacuisson.local/PDF/Merge' + '?src1=' + 'Extranet\' + CompanyName + id + '&src2=CGV' + '&dest=' + 'Extranet\' + CompanyName + No;
                if not HttpClient.Get(MergeURL, HttpResponse) then
                    Error('Impossible de contacter le service PDF : %1', No);

                if not HttpResponse.IsSuccessStatusCode() then
                    Error('Erreur fusion PDF %1 : HTTP %2', No, HttpResponse.HttpStatusCode());

                if FileMgt.ServerFileExists(PDFPath) then
                    FileMgt.DeleteServerFile(PDFPath);
            end;
            SalesH.Reset;
            SalesH.SetFilter("No.", '%1', No);
            SalesH.SetFilter("Sell-to Customer No.", CustNo);
            if SalesH.FindFirst then begin
                SalesHRef.GetTable(SalesCr);
                if not Report.SaveAs(50000, '', ReportFormat::Pdf, OutStr, SalesHRef) then
                    Error('Erreur génération PDF');
                TempBlob.CreateInStream(InStr);
                FileMgt.BLOBExportToServerFile(TempBlob, PDFPath);

                MergeURL := 'http://intranet.europacuisson.local/PDF/Merge' + '?src1=' + 'Extranet\' + CompanyName + id + '&src2=CGV' + '&dest=' + 'Extranet\' + CompanyName + No;
                if not HttpClient.Get(MergeURL, HttpResponse) then
                    Error('Impossible de contacter le service PDF : %1', No);

                if not HttpResponse.IsSuccessStatusCode() then
                    Error('Erreur fusion PDF %1 : HTTP %2', No, HttpResponse.HttpStatusCode());

                if FileMgt.ServerFileExists(PDFPath) then
                    FileMgt.DeleteServerFile(PDFPath);
            end;
        end;
    end;

    procedure ChangePwd(EMail: Text; HashedPwd: Text; salt: Text)
    var
        Contacts: Record Contact;
    begin
        Contacts.Reset;
        Contacts.SetRange("E-Mail", EMail);
        if Contacts.FindFirst then
            repeat
                Contacts.salt := salt;
                Contacts.Password := HashedPwd;
                Contacts.Modify;
            until Contacts.Next = 0;
    end;

    procedure CreatePDFExv(No: Code[20]; CustNo: Code[20])
    var
        SalesExv: Record "Sales Shipment Header";
        CrExv: Report "Sales - Shipment EC";
    begin
        if not FILE.Exists('\\192.168.5.42\NavisionTemp\Extranet\' + CompanyName + No + '.pdf') then begin
            SalesExv.Reset;
            SalesExv.SetFilter("No.", '%1', No);
            SalesExv.SetFilter("Sell-to Customer No.", CustNo);
            if SalesExv.FindFirst then begin
                REPORT.SaveAsPdf(50003, '\\192.168.5.42\NavisionTemp\Extranet\' + CompanyName + No + '.pdf', SalesExv);
            end;

        end;
    end;
}

