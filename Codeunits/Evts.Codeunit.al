codeunit 50049 Evts
{

    trigger OnRun()
    begin
    end;

    var
        Utils: Codeunit Utils;

    [EventSubscriber(ObjectType::Codeunit, 44, 'OnAfterGetPrinterName', '', false, false)]
    local procedure SelectPrinter(ReportID: Integer; var PrinterName: Text[250])
    begin
        //EC a supprimer dès qu'on utilise exclusiement le client Web
        //IF NOT GUIALLOWED THEN
        PrinterName := Utils.Replace(Utils.Replace(PrinterName, '\\srvdc1\', ''), '\\SRVDC1\', '');
        //  PrinterName := Utils.Replace('\\SRVDC1\Ricoh Accueil00000'+PrinterName,'\\SRVDC1\','');
    end;
}

