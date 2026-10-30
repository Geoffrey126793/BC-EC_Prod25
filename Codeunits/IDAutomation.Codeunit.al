codeunit 50052 IDAutomation
{

    trigger OnRun()
    begin
        ID_GS1 := ID_GS1.UniversalFontEncoder();
        t := ID_GS1.IDAutomation_Uni_C128('(15)121212', true);
        Message(t);
    end;

    var
        ID_GS1: DotNet UniversalFontEncoder;
        t: Text;

    [Scope('OnPrem')]
    procedure FCN(): Text
    var
        _fcn: Text[2];
    begin
        _fcn[1] := 202;
        exit(_fcn);
    end;

    [Scope('OnPrem')]
    procedure Get_GS1_128(BarCode: Text): Text
    begin
        ID_GS1 := ID_GS1.UniversalFontEncoder();
        exit(ID_GS1.IDAutomation_Uni_C128(BarCode, true));
    end;

    [Scope('OnPrem')]
    procedure Get_GS1_128_NoTilde(BarCode: Text): Text
    begin
        ID_GS1 := ID_GS1.UniversalFontEncoder();
        BarCode := DelChr(BarCode, '=', '(');
        BarCode := DelChr(BarCode, '=', ')');
        exit(ID_GS1.IDAutomation_Uni_C128(BarCode, false));
    end;
}

