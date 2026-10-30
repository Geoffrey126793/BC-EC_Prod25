codeunit 50034 "WS EDI"
{

    trigger OnRun()
    begin
        ProcessFile('c:\tmp\noContentDispositionFilename-GENEDI-AS1AS2-21032022103516+0100-7337@3016065200000_EC_FranceFrais_OID');
    end;

    var
        GS1: Codeunit "GS1 Receive";

    procedure ProcessFile(FileName: Text[1024]) NoCommande: Text[1024]
    begin
        exit(GS1.ReadFile(FileName));
    end;

    procedure ProcessFilePoland(FileName: Text[1024])
    var
        cuEDIPL: Codeunit EDI;
    begin
        cuEDIPL.Import_ECPoland(FileName);
    end;
}

