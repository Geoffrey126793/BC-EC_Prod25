codeunit 50024 Utils
{

    trigger OnRun()
    begin
        Message(DecimalString(15.12));
    end;

    var
        tab: array[10, 6] of Char;
        First_flag_sequence: array[10] of Integer;

    [Scope('OnPrem')]
    procedure Selectstr(pNo: Integer; pText: Text[1024]; pSeparator: Char): Text[1024]
    var
        ReturnString: Text[1024];
        FieldsFound: Integer;
        boo: Integer;
        CounterPos: Integer;
    begin
        ReturnString := '';
        FieldsFound := 1;
        boo := -1;
        repeat
            CounterPos += 1;
            if pText[CounterPos] = '"' then
                boo *= -1
            else begin
                if (pText[CounterPos] = pSeparator) and (boo = -1) then
                    FieldsFound += 1
                else
                    if FieldsFound = pNo then
                        ReturnString := ReturnString + CopyStr(pText, CounterPos, 1);
            end;
        until (CounterPos >= StrLen(pText)) or (FieldsFound > pNo);

        exit(ReturnString);
    end;

    [Scope('OnPrem')]
    procedure CompleteStr(num: Code[10]; type: Code[10]) rnew_num: Code[10]
    begin
        if StrLen(num) = 1 then
            rnew_num := type + '00000' + num;
        if StrLen(num) = 2 then
            rnew_num := type + '0000' + num;
        if StrLen(num) = 3 then
            rnew_num := type + '000' + num;
        if StrLen(num) = 4 then
            rnew_num := type + '00' + num;
        if StrLen(num) = 5 then
            rnew_num := type + '0' + num;
    end;



    [Scope('OnPrem')]
    procedure IsInGroup(Group: Code[20]) Retour: Boolean
    var
        WindowsAccess: Record "Access Control";
    begin
        WindowsAccess.Reset;
        WindowsAccess.SetRange("User Name", UserId);
        WindowsAccess.SetRange("Role ID", Group);
        if WindowsAccess.FindFirst then exit(true);

        exit(false);
    end;

    [Scope('OnPrem')]
    procedure HexadecimalToDecimal(StrHexa: Text[250]) StrDec: Text[250]
    var
        i: Integer;
        n: BigInteger;
        r: BigInteger;
        c: Text[1];
    begin
        i := StrLen(StrHexa);
        n := 1;
        r := 0;
        while (i > 0) do begin
            c := CopyStr(StrHexa, i, 1);
            r := r + n * CharHexaToDec(c);
            n := n * 16;
            i := i - 1;
        end;
        StrDec := Format(r);
    end;

    [Scope('OnPrem')]
    procedure DecimalToHexadecimal(StrDec: Text[250]) StrHexa: Text[250]
    var
        Q: Integer;
        R: Integer;
        X: BigInteger;
        s: Text[250];
    begin
        s := '';
        Evaluate(X, StrDec);
        repeat
            Q := X div 16;
            R := X mod 16;
            s := NumberDecToHexa(R) + s;
            X := Q;
        until Q = 0;
        StrHexa := s;
    end;

    [Scope('OnPrem')]
    procedure CharHexaToDec(Char: Text[1]) n: Integer
    begin
        case Char of
            '0':
                n := 0;
            '1':
                n := 1;
            '2':
                n := 2;
            '3':
                n := 3;
            '4':
                n := 4;
            '5':
                n := 5;
            '6':
                n := 6;
            '7':
                n := 7;
            '8':
                n := 8;
            '9':
                n := 9;
            'A':
                n := 10;
            'B':
                n := 11;
            'C':
                n := 12;
            'D':
                n := 13;
            'E':
                n := 14;
            'F':
                n := 15;
        end;
    end;

    [Scope('OnPrem')]
    procedure NumberDecToHexa(n: Integer) Char: Text[1]
    begin
        case n of
            0:
                Char := '0';
            1:
                Char := '1';
            2:
                Char := '2';
            3:
                Char := '3';
            4:
                Char := '4';
            5:
                Char := '5';
            6:
                Char := '6';
            7:
                Char := '7';
            8:
                Char := '8';
            9:
                Char := '9';
            10:
                Char := 'A';
            11:
                Char := 'B';
            12:
                Char := 'C';
            13:
                Char := 'D';
            14:
                Char := 'E';
            15:
                Char := 'F';
        end;
    end;

    [Scope('OnPrem')]
    procedure PadLeft(String: Text[200]; Filler: Text[1]; Length: Integer) Retour: Text[255]
    var
        s: Text[255];
    begin
        s := String;
        while StrLen(s) < Length do
            s := Filler + s;
        Retour := s;
    end;

    [Scope('OnPrem')]
    procedure Replace(String: Text[250]; FindWhat: Text[250]; ReplaceWith: Text[250]) NewString: Text[250]
    var
        donePos: Integer;
        currPos: Integer;
        Substr: Text[250];
    begin
        //WHILE STRPOS(String,FindWhat) > 0 DO
        //  String := DELSTR(String,STRPOS(String,FindWhat)) + ReplaceWith + COPYSTR(String,STRPOS(String,FindWhat) + STRLEN(FindWhat));
        //NewString := String;

        donePos := StrPos(String, FindWhat);
        currPos := donePos;
        while (currPos > 0) do begin
            String := CopyStr(String, 1, donePos - 1) + ReplaceWith + CopyStr(String, donePos + StrLen(FindWhat));
            Substr := CopyStr(String, donePos + StrLen(ReplaceWith));
            currPos := StrPos(Substr, FindWhat);
            donePos := donePos + currPos + StrLen(ReplaceWith) - 1;
        end;
        NewString := String;
    end;

    [Scope('OnPrem')]
    procedure ToHTML(Html: Text[250]) s: Text[250]
    begin
        s := Html;
        s := Replace(s, '&', 'AAAAZZZZZZ;');
        s := Replace(s, 'AAAAZZZZZZ;', '&amp;');
        s := Replace(s, '-', '&ndash;');
        s := Replace(s, '"', '&quot;');
        s := Replace(s, '  ', '&nbsp;&nbsp;');
        s := Replace(s, '>', '&gt;');
        s := Replace(s, '<', '&lt');
        s := Replace(s, '€', '&euro;');
        s := Replace(s, 'ÔÇª', '&agrave;');
        s := Replace(s, 'ãÆ', '&acirc; ');
        s := Replace(s, 'ÔÇí', '&ccedil;');
        s := Replace(s, 'ÔÇÜ', '&eacute;');
        s := Replace(s, 'á', '&egrave;');
        s := Replace(s, '”å', '&ecirc;');
        s := Replace(s, 'Æ', '&icirc;');
        s := Replace(s, 'ÔÇ£', '&ocirc;');
        s := Replace(s, 'ÔÇö', '&ugrave;');
        s := Replace(s, 'ÔÇô', '&ucirc;');
        s := Replace(s, 'Ž©', '&deg;');
    end;

    [Scope('OnPrem')]
    procedure GetFileFromPath(Path: Text[254]) File: Text[200]
    var
        i: Integer;
    begin
        File := '';
        i := StrLen(Path);
        while (i > 0) and (CopyStr(Path, i, 1) <> '\') do begin
            i := i - 1;
        end;
        if (i > 0) then File := CopyStr(Path, i + 1, StrLen(Path) - i + 1);
    end;

    [Scope('OnPrem')]
    procedure ToHTMLFile(Html: Text[250]) s: Text[250]
    begin
        s := ConvertStr(Html, 'ŽçŽ‰Ž®ŽóŽñŽáŽÑŽºŽ¬Ž½Ž¿Ž»Ž«Ž¼Ôé¼€', 'Ôé¼üÔÇÜãÆÔÇ×ÔÇªÔÇáÔÇí”åÔÇ€áÔÇ†Æì€Ž©');

        s := Replace(s, 'ÔÇª', 'a');
        s := Replace(s, 'ãÆ', 'a');
        s := Replace(s, 'ÔÇí', 'c');
        s := Replace(s, 'ÔÇÜ', 'e');
        s := Replace(s, 'á', 'e');
        s := Replace(s, '”å', 'e');
        s := Replace(s, 'Æ', 'i');
        s := Replace(s, 'ÔÇ£', 'o');
        s := Replace(s, 'ÔÇö', 'u');
        s := Replace(s, 'ÔÇô', 'u');
    end;

    [Scope('OnPrem')]
    procedure RGB(Red: Integer; Green: Integer; Blue: Integer): Integer
    begin

        if Red < 0 then Red := 0;
        if Red > 255 then Red := 255;

        if Green < 0 then Green := 0;
        if Green > 255 then Green := 255;

        if Blue < 0 then Blue := 0;
        if Blue > 255 then Blue := 255;

        exit(Red + (256 * Green) + (256 * 256 * Blue));
    end;

    [Scope('OnPrem')]
    procedure ConvertToUNC(Fichier: Text[250]) Retour: Text[250]
    begin
        Retour := Replace(Fichier, 'P:\', '\\srvfile\Public\');
        Retour := Replace(Fichier, 'p:\', '\\srvfile\Public\');
    end;

    [Scope('OnPrem')]
    procedure StartProcess(_Filename: Text[250]; _Arguments: Text[250])
    var
        Process: DotNet Process;
        ProcessInfo: DotNet ProcessStartInfo;
    begin
        Process := Process.Process();
        ProcessInfo := ProcessInfo.ProcessStartInfo(_Filename, _Arguments);
        Process.StartInfo := ProcessInfo;
        Process.Start();
        Process.WaitForExit(10000); // Wait max. 10 sec
    end;

    [Scope('OnPrem')]
    procedure EAN13GetCheck("Code": Code[50]) check: Text[30]
    var
        EAN_Sum_Pair: Integer;
        EAN_Sum_Impair: Integer;
        i: Integer;
        EAN_Check_Digit: Integer;
        r: Boolean;
    begin
        if StrLen(Code) <> 12 then begin
            check := '-1';
        end
        else begin
            r := true;
            for i := 1 to 12 do begin
                if (CopyStr(Code, i, 1) < '0') or (CopyStr(Code, i, 1) > '9') then
                    r := false;
            end;
            if r then begin
                EAN_Sum_Pair := 0;
                EAN_Sum_Impair := 0;

                i := 12;
                repeat
                    if i mod 2 = 0 then
                        EAN_Sum_Pair := EAN_Sum_Pair + strtoint(CopyStr(Code, i, 1))
                    else
                        EAN_Sum_Impair := EAN_Sum_Impair + strtoint(CopyStr(Code, i, 1));
                    i := i - 1;
                until i = 0;
                EAN_Check_Digit := 10 - (EAN_Sum_Pair * 3 + EAN_Sum_Impair) mod 10;
                if EAN_Check_Digit = 10 then
                    EAN_Check_Digit := 0;
                check := Format(EAN_Check_Digit);
            end
            else begin
                check := '-1';
            end;
        end;
    end;

    [Scope('OnPrem')]
    procedure EAN13GetDisplay("Code": Code[50]) EAN13: Text[30]
    var
        EAN_display: Text[30];
        first: Integer;
        actual: Integer;
        i: Integer;
    begin
        //IF NOT VerifCB(Code) THEN
        // ERROR('Code barre erronÔÇÜ : %1',Code);
        init_tab();

        EAN_display := '' + Format(tab[strtoint(CopyStr(Code, 1, 1)) + 1, 4]);
        EAN_display := EAN_display + Format(tab[strtoint(CopyStr(Code, 2, 1)) + 1, 5]);
        first := strtoint(CopyStr(Code, 1, 1));

        for i := 3 to 7 do begin
            actual := strtoint(CopyStr(Code, i, 1));
            if BinToInt(BitWiseAnd(IntToBin(First_flag_sequence[first + 1]), IntToBin(Power(2, 7 - i)))) <> 0
         then
                EAN_display := EAN_display + Format(tab[actual + 1, 2])
            else
                EAN_display := EAN_display + Format(tab[actual + 1, 1]);
        end;
        EAN_display := EAN_display + chr(124);
        for i := 8 to 12 do begin
            actual := strtoint(CopyStr(Code, i, 1));
            EAN_display := EAN_display + Format(tab[actual + 1, 3]);
        end;
        EAN_display := EAN_display + Format(tab[strtoint(CopyStr(Code, 13, 1)) + 1, 6]);
        // EAN_display := chr(5) + EAN_display + chr(5);

        EAN13 := EAN_display;
    end;

    [Scope('OnPrem')]
    procedure GS1GetCheck("Code": Code[50]) check: Text[30]
    var
        EAN_Sum_Pair: Integer;
        EAN_Sum_Impair: Integer;
        i: Integer;
        EAN_Check_Digit: Integer;
        r: Boolean;
        pair: Integer;
    begin

        r := true;
        for i := 1 to StrLen(Code) do begin
            if (CopyStr(Code, i, 1) < '0') or (CopyStr(Code, i, 1) > '9') then
                r := false;
        end;
        if r then begin
            EAN_Sum_Pair := 0;
            EAN_Sum_Impair := 0;
            pair := 0;
            i := StrLen(Code);
            repeat
                if pair mod 2 = 0 then
                    EAN_Sum_Pair := EAN_Sum_Pair + strtoint(CopyStr(Code, i, 1))
                else
                    EAN_Sum_Impair := EAN_Sum_Impair + strtoint(CopyStr(Code, i, 1));
                i := i - 1;
                pair := pair + 1;
            until i = 0;
            EAN_Check_Digit := 10 - (EAN_Sum_Pair * 3 + EAN_Sum_Impair) mod 10;
            if EAN_Check_Digit = 10 then
                EAN_Check_Digit := 0;
            check := Format(EAN_Check_Digit);
        end
        else begin
            check := '-1';
        end;
    end;

    [Scope('OnPrem')]
    procedure init_tab()
    var
        i: Integer;
        left_hand_A: Integer;
        left_hand_B: Integer;
        right_hand: Integer;
        first_flag: Integer;
        second_flag: Integer;
        check: Integer;
    begin
        First_flag_sequence[1] := 0;
        First_flag_sequence[2] := 11;
        First_flag_sequence[3] := 13;
        First_flag_sequence[4] := 14;
        First_flag_sequence[5] := 19;
        First_flag_sequence[6] := 25;
        First_flag_sequence[7] := 28;
        First_flag_sequence[8] := 21;
        First_flag_sequence[9] := 22;
        First_flag_sequence[10] := 26;
        left_hand_A := 48;
        left_hand_B := 64;
        right_hand := 80;
        first_flag := 33;
        second_flag := 96;
        check := 112;
        for i := 1 to 10 do begin
            tab[i, 1] := left_hand_A + i - 1;
            tab[i, 2] := left_hand_B + i - 1;
            tab[i, 3] := right_hand + i - 1;
            tab[i, 4] := first_flag + i - 1;
            tab[i, 5] := second_flag + i - 1;
            tab[i, 6] := check + i - 1;
        end;
    end;

    [Scope('OnPrem')]
    procedure strtoint(s: Text[30]) n: Integer
    begin
        Evaluate(n, s);
    end;

    [Scope('OnPrem')]
    procedure chr(n: Integer) s: Text[30]
    var
        c: Char;
    begin
        c := n;
        s := Format(c);
    end;

    [Scope('OnPrem')]
    procedure IntToBin(Int: Integer) BinaryValue: Text[200]
    var
        Stop: Boolean;
    begin

        repeat
            BinaryValue := InsStr(BinaryValue, Format(Int mod 2), 1);
            Stop := Round(Int / 2, 1, '<') = 0;
            Int := Int - (Round(Int / 2, 1, '<') + (Int mod 2));
        until Stop;
    end;

    [Scope('OnPrem')]
    procedure BinToInt(BinValue: Text[200]) Int: Integer
    var
        ByteTmp: Integer;
        Counter: Integer;
    begin
        for Counter := 0 to StrLen(BinValue) - 1 do begin
            Evaluate(ByteTmp, CopyStr(BinValue, Counter + 1, 1));
            Int := Int + ByteTmp * Power(2, (StrLen(BinValue) - Counter - 1));
        end;
    end;

    [Scope('OnPrem')]
    procedure BitWiseOr(BinValue1: Text[200]; BinValue2: Text[200]) BWO: Text[200]
    var
        Pad: Text[200];
        TheCount: Integer;
        Counter: Integer;
    begin
        Pad := PadStr(Pad, 200, '0');
        if StrLen(BinValue1) > StrLen(BinValue2) then
            BinValue2 := CopyStr(Pad, 1, StrLen(BinValue1) - StrLen(BinValue2)) + BinValue2
        else
            if StrLen(BinValue2) > StrLen(BinValue1) then
                BinValue1 := CopyStr(Pad, 1, StrLen(BinValue2) - StrLen(BinValue1)) + BinValue1;
        for Counter := 1 to StrLen(BinValue1) do
            if (BinValue1[Counter] = '1') or
              (BinValue2[Counter] = '1') then
                BWO[Counter] := '1'
            else
                BWO[Counter] := '0';
        if BWO = '' then
            BWO := '0'
        else
            BWO := DelChr(BWO, '<', '0');
    end;

    [Scope('OnPrem')]
    procedure BitWiseAnd(BinValue1: Text[200]; BinValue2: Text[200]) BWO: Text[200]
    var
        Pad: Text[200];
        TheCount: Integer;
        Counter: Integer;
    begin
        Pad := PadStr(Pad, 200, '0');
        if StrLen(BinValue1) > StrLen(BinValue2) then
            BinValue2 := CopyStr(Pad, 1, StrLen(BinValue1) - StrLen(BinValue2)) + BinValue2
        else
            if StrLen(BinValue2) > StrLen(BinValue1) then
                BinValue1 := CopyStr(Pad, 1, StrLen(BinValue2) - StrLen(BinValue1)) + BinValue1;
        for Counter := 1 to StrLen(BinValue1) do
            if (BinValue1[Counter] = '1') and
              (BinValue2[Counter] = '1') then
                BWO[Counter] := '1'
            else
                BWO[Counter] := '0';
        if BWO = '' then
            BWO := '0'
        else
            BWO := DelChr(BWO, '<', '0');
    end;

    [Scope('OnPrem')]
    procedure BitWiseXor(BinValue1: Text[200]; BinValue2: Text[200]) BWO: Text[200]
    var
        Pad: Text[200];
        TheCount: Integer;
        Counter: Integer;
    begin
        Pad := PadStr(Pad, 200, '0');
        if StrLen(BinValue1) > StrLen(BinValue2) then
            BinValue2 := CopyStr(Pad, 1, StrLen(BinValue1) - StrLen(BinValue2)) + BinValue2
        else
            if StrLen(BinValue2) > StrLen(BinValue1) then
                BinValue1 := CopyStr(Pad, 1, StrLen(BinValue2) - StrLen(BinValue1)) + BinValue1;
        for Counter := 1 to StrLen(BinValue1) do
            if BinValue1[Counter] <> BinValue2[Counter] then
                BWO[Counter] := '1'
            else
                BWO[Counter] := '0';
        if BWO = '' then
            BWO := '0'
        else
            BWO := DelChr(BWO, '<', '0');
    end;

    [Scope('OnPrem')]
    procedure Mod97(Txt: Text[250]): Integer
    var
        Decimal: Decimal;
    begin
        Evaluate(Decimal, DelChr(Txt, '=', DelChr(Txt, '=', '0123456789')));
        Decimal := Decimal mod 97;
        if Decimal = 0 then
            Decimal := 97;
        exit(Decimal);
    end;

    [Scope('OnPrem')]
    procedure Code128GetDisplay(pText: Text[250]) RetVal: Text[250]
    var
        StartChar: Char;
        StopChar: Char;
        currentchar: Char;
        checksum: Integer;
        i: Integer;
        ChecksumChar: Char;
        SpaceChar: Text[1];
    begin
        // How to encode a 128 barcode:
        //
        // Each character has a value ranging from 0 to 105. This value is used to calculate the check
        // character for each symbol.
        //
        // The check character is a Modulus 103 Checksum that is calculated by summing the start code
        // value plus the product of each character position (most significant character position equals 1)
        // and the character value of the character at that position. This sum is divided by 103. The
        // remainder of the answer is the value of the Check Character (which can be looked up from the
        // table). Every encoded character is included except the Stop and Check Character.
        //
        //
        // Example: BarCode 1
        // Message : Start B   B   a   r   C   o   d   e      1
        // Value      104      34  65  82  35  79  68  69  0  17
        // Position:   -       1   2   3   4   5   6   7   8  9
        // Calculate Total: 104 + (34x1) + (65x2) + (82x3) + (35x4) + (79x5) +
        //                  (68x6) + (69x7) + (0x8) + (17x9) = 2093
        // 2093/103 = 20 remainder 33
        // 33 = A
        // Final message: (Start B)BarCode 1(A)(STOP)

        //Code 128 Variant B Documented ASCII Equiv Actual ASCII Equiv
        //0 {SPACE} (128) Ç (176) €
        //95 DEL (145) æ (200) ‘
        //96 FNC 3 (146) Æ (201) ’
        //97 FNC 2 (147) ô (202) “
        //98 SHIFT (148) ö (203) ”
        //99 CODE C (149) ò (204) •
        //100 FNC 4 (150) û (205) –
        //101 CODE A (151) ù (206) —
        //102 FNC 1 (152) ÿ (213) ¤
        //103 START A (153) Ö (217) ™
        //104 START B (154) Ü (218) š
        //105 START C (155) ø (219) ›
        //106 STOP (156) £ (220) œ
        //http://www.fileformat.info/info/charset/UTF-8/list.htm


        pText := DelChr(pText, '=', '()');
        StartChar := 218;
        StartChar := 'š';
        StopChar := 220;
        StopChar := 'œ';

        checksum := 104;
        SpaceChar[1] := 176;

        for i := 1 to StrLen(pText) do begin
            currentchar := pText[i];
            checksum := checksum + (i * (currentchar - 32));
        end;
        ChecksumChar := checksum mod 103;
        ChecksumChar := ChecksumChar + 32;

        if (checksum mod 103) = 95 then ChecksumChar := '‘';
        if (checksum mod 103) = 96 then ChecksumChar := '’';
        if (checksum mod 103) = 97 then ChecksumChar := '“';
        if (checksum mod 103) = 98 then ChecksumChar := '”';
        if (checksum mod 103) = 99 then ChecksumChar := '•';
        if (checksum mod 103) = 100 then ChecksumChar := '–';
        if (checksum mod 103) = 101 then ChecksumChar := '—';
        if (checksum mod 103) = 102 then ChecksumChar := '˜';
        //IF (checksum MOD 103) = 103 THEN  ChecksumChar := '™';
        //IF (checksum MOD 103) = 104 THEN  ChecksumChar := 'š';
        //IF (checksum MOD 103) = 105 THEN  ChecksumChar := '›';
        //IF (checksum MOD 103) = 106 THEN  ChecksumChar := 'œ';  //??????
        if (checksum mod 103) = 0 then ChecksumChar := '€';

        //MESSAGE('%1',(checksum MOD 103));
        // convert SPACE to ALT+0128
        pText := ConvertStr(pText, ' ', SpaceChar);

        RetVal := StrSubstNo('%1%2%3%4', StartChar, pText, ChecksumChar, StopChar);

        exit(RetVal);
    end;

    [Scope('OnPrem')]
    procedure Dt2Hours(Dt: DateTime): Integer
    var
        ms: Integer;
    begin
        ms := DT2Time(Dt) - 000000T;
        exit(ms div 1000 div 60 div 60);
    end;

    [Scope('OnPrem')]
    procedure Dt2Minutes(Dt: DateTime): Integer
    var
        ms: Integer;
    begin
        ms := DT2Time(Dt) - 000000T;
        exit(((ms div 1000) mod 3600) div 60);
    end;

    [Scope('OnPrem')]
    procedure Dt2Seconds(Dt: DateTime): Integer
    var
        ms: Integer;
    begin
        ms := DT2Time(Dt) - 000000T;
        exit((ms div 1000) mod 100);
    end;

    [Scope('OnPrem')]
    procedure HMS2Time(H: Integer; M: Integer; S: Integer): Time
    begin
        exit(000000T + (H * 3600 + M * 60 + S) * 1000);
    end;

    [Scope('OnPrem')]
    procedure DelNonAN(Txt: Text): Text
    begin
        exit(DelChr(Txt, '=', DelChr(Txt, '=', '0123456789azertyuiopqsdfghjklmwxcvbnAZERTYUIOPQSDFGHJKLMWXCVBN,.-_+'' :;=/')));
    end;

    [Scope('OnPrem')]
    procedure DecimalString(Dec: Decimal): Text
    begin
        exit(Format(Dec, 0, '<Sign><Integer><Decimals><Comma,.>'));
    end;
}

