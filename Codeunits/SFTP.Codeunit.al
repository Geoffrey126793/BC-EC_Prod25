codeunit 50008 SFTP
{

    trigger OnRun()
    begin
        TftFile();
    end;

    var
        WinSCPSesh: DotNet Session;
        WinSCPSessionOptions: DotNet SessionOptions;
        WinSCPTransferOptions: DotNet TransferOptions;
        WinSCPProtocol: DotNet Protocol;
        WinSCPTransferResumeSupport: DotNet TransferResumeSupport;
        WinSCPTransferResumeSupportState: DotNet TransferResumeSupportState;
        WinSCPTransferResult: DotNet TransferOperationResult;

    local procedure TftFile()
    begin
        WinSCPSessionOptions := WinSCPSessionOptions.SessionOptions();
        WinSCPSessionOptions.Protocol := WinSCPProtocol.Sftp;
        WinSCPSessionOptions.HostName := '192.168.5.130';
        WinSCPSessionOptions.PortNumber := 22;
        WinSCPSessionOptions.UserName := 'test';
        WinSCPSessionOptions.Password := 'test';
        WinSCPSessionOptions.GiveUpSecurityAndAcceptAnySshHostKey := true;

        WinSCPSesh := WinSCPSesh.Session();
        WinSCPSesh.Open(WinSCPSessionOptions);
        if WinSCPSesh.Opened then begin
            WinSCPTransferOptions := WinSCPTransferOptions.TransferOptions();
            WinSCPTransferOptions.TransferMode := 0;
            WinSCPTransferResumeSupport := WinSCPTransferOptions.ResumeSupport;
            WinSCPTransferResumeSupport.State(WinSCPTransferResumeSupportState.Off);
            if WinSCPSesh.FileExists('test.txt') then
                WinSCPSesh.RemoveFiles('test.txt');
            //WinSCPSesh.PutFiles('C:\tmp\test.txt','test'+FORMAT(CURRENTDATETIME)+'.txt',FALSE,WinSCPTransferOptions);
            WinSCPTransferResult := WinSCPSesh.PutFiles('\\srvnavision\NavisionTemp\test.txt', './test.txt', false, WinSCPTransferOptions);
            WinSCPTransferResult.Check();

        end
        else begin
            Error('Connection failed');
        end;

        if WinSCPSesh.Opened then WinSCPSesh.Dispose();
    end;

    [Scope('OnPrem')]
    procedure TftFileToServer(Server: Text; Port: Integer; Login: Text; Pwd: Text; SrcFile: Text; DstFile: Text)
    var
        emailmsg: Codeunit "Email Message";
        emailsend: Codeunit Email;

    begin
        WinSCPSessionOptions := WinSCPSessionOptions.SessionOptions();
        WinSCPSessionOptions.Protocol := WinSCPProtocol.Sftp;
        WinSCPSessionOptions.HostName := Server;
        WinSCPSessionOptions.PortNumber := Port;
        WinSCPSessionOptions.UserName := Login;
        WinSCPSessionOptions.Password := Pwd;
        WinSCPSessionOptions.GiveUpSecurityAndAcceptAnySshHostKey := true;

        WinSCPSesh := WinSCPSesh.Session();
        WinSCPSesh.Open(WinSCPSessionOptions);
        if WinSCPSesh.Opened then begin
            WinSCPTransferOptions := WinSCPTransferOptions.TransferOptions();
            WinSCPTransferOptions.TransferMode := 0;
            WinSCPTransferResumeSupport := WinSCPTransferOptions.ResumeSupport;
            WinSCPTransferResumeSupport.State(WinSCPTransferResumeSupportState.Off);
            if WinSCPSesh.FileExists(DstFile) then
                WinSCPSesh.RemoveFiles(DstFile);

            WinSCPTransferResult := WinSCPSesh.PutFiles(SrcFile, DstFile, false, WinSCPTransferOptions);
            WinSCPTransferResult.Check();

        end
        else begin
            emailmsg.Create('g.dangremont@europacuisson.com', 'SFTP Erreur', 'DESADV');
            emailsend.Send(emailmsg);
        end;

        if WinSCPSesh.Opened then WinSCPSesh.Dispose();
    end;


}

