codeunit 50027 "Einvoice Send"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        Einv: Codeunit Trigger_einvoice;
        SalesInvH: Record "Sales Invoice Header";
        RecRef: RecordRef;
        Cust: Record Customer;
        Comp: Record "Company Information";
        WinSCPSesh: DotNet Session;
        WinSCPSessionOptions: DotNet SessionOptions;
        WinSCPTransferOptions: DotNet TransferOptions;
        WinSCPProtocol: DotNet Protocol;
        WinSCPTransferResumeSupport: DotNet TransferResumeSupport;
        WinSCPTransferResumeSupportState: DotNet TransferResumeSupportState;
        WinSCPTransferResult: DotNet TransferOperationResult;
        emailmsg: Codeunit "Email Message";
        emailsend: Codeunit Email;
        FileMgmt: Codeunit "File Management";
        Path: Text;
        filename: Text;
        Logs: Record "Peppol Logs";
        SalesCrH: Record "Sales Cr.Memo Header";
    begin
        Comp.Get;
        RecRef.Get("Record ID to Process");
        RecRef.Find;
        RecRef.SetRecFilter;

        if SalesInvH.Get(Rec."Parameter String") then begin
            Cust.Get(SalesInvH."Bill-to Customer No.");
            filename := DelChr(Comp."Enterprise No.", '=', DelChr(Comp."Enterprise No.", '=', '0123456789')) + '_' + SalesInvH."No." + '.xml';
            Path := '\\srvnavision\NavisionTemp\EINVOICE\EINVOICE_ToSend\' + filename;
            FILE.Copy(Einv.SaveInvoicePeppolFile(SalesInvH), Path);
        end;

        if SalesCrH.Get(Rec."Parameter String") then begin
            Cust.Get(SalesCrH."Bill-to Customer No.");
            filename := DelChr(Comp."VAT Registration No.", '=', DelChr(Comp."VAT Registration No.", '=', '0123456789')) + '_' + SalesCrH."No." + '.xml';
            Path := '\\srvnavision\NavisionTemp\EInvoice\EINVOICE_ToSend\' + filename;
            FILE.Copy(Einv.SaveCRPeppolFile(SalesCrH), Path);
        end;



        if Cust."EInvoice EAS" <> '' then begin

            WinSCPSessionOptions := WinSCPSessionOptions.SessionOptions();
            WinSCPSessionOptions.Protocol := WinSCPProtocol.Ftp;
            WinSCPSessionOptions.HostName := 'eu1.babelway.net';
            WinSCPSessionOptions.PortNumber := 21;
            WinSCPSessionOptions.UserName := 'EUROPACUISSON';
            WinSCPSessionOptions.Password := 'Europacuisson7522';
            //WinSCPSessionOptions.GiveUpSecurityAndAcceptAnySshHostKey := TRUE;

            WinSCPSesh := WinSCPSesh.Session();
            WinSCPSesh.Open(WinSCPSessionOptions);
            if WinSCPSesh.Opened then begin
                WinSCPTransferOptions := WinSCPTransferOptions.TransferOptions();
                WinSCPTransferOptions.TransferMode := 0;
                WinSCPTransferResumeSupport := WinSCPTransferOptions.ResumeSupport;
                WinSCPTransferResumeSupport.State(WinSCPTransferResumeSupportState.Off);
                WinSCPSesh.PutFiles(Path, '/PROD/PEPPOL_INVOICE_OUT/' + filename, false, WinSCPTransferOptions);
                WinSCPSesh.Dispose();
                FILE.Copy(Path, Path.Replace('ToSend', 'Send'));
                FILE.Erase(Path);
                Logs.Reset;
                Logs.Init;
                Logs.ID := CreateGuid;
                Logs.Dt := CurrentDateTime;
                Logs.Type := Logs.Type::BC;
                Logs.Result_Code := 'OK';
                Logs.Message := 'FTP Send';
                Logs.Company := CompanyName;
                Logs.NoDoc := Rec."Parameter String";
                if not Logs.Insert(true) then Logs.Modify;
            end;
        end;
    end;
}

