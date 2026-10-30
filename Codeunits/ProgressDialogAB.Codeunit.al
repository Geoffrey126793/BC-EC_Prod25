codeunit 8001412 "Progress DialogAB"
{
    // //+BGW+ GESWAY 08/03/05 Barre de progression


    trigger OnRun()
    var
        Length: Integer;
    begin
    end;

    var
        Window: Dialog;
        "Count": BigInteger;
        OldTime: Time;
        tDefault: Label 'In progress...';
        "Max": BigInteger;
        OldProgress: BigInteger;
        tIsEmpty: Label 'Is empty';

    [Scope('OnPrem')]
    procedure Open(pDescription: Text[250]; pMax: BigInteger)
    begin
        Max := pMax;
        if pMax = 0 then
            Error(tIsEmpty);
        OldTime := Time;
        if pDescription = '' then
            pDescription := tDefault;
        Window.Open(pDescription + '\' + '@1@@@@@@@@@@@@@@@@@@');
    end;

    [Scope('OnPrem')]
    procedure Update()
    var
        lTime: Time;
        lProgress: Decimal;
    begin
        Count += 1;
        lTime := Time;
        if lTime < OldTime then
            OldTime := lTime
        else
            if Time - OldTime > 1000 then begin
                lProgress := Round(Count / Max * 100, 1);
                if lProgress <> OldProgress then begin
                    OldProgress := lProgress;
                    Window.Update(1, lProgress * 100);
                end;
                OldTime := Time;
            end;
    end;

    [Scope('OnPrem')]
    procedure Close()
    begin
        Window.Close;
    end;
}

