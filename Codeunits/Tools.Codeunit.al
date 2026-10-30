codeunit 8001401 Tools
{
    // //BGW GESWAY 01/01/00 Convertisseur Ansi -> Ascii
    //       MB     05/04/06 Ajout des fonctions ControlBarCod qui verifie la validité d'un code barre EAN8, EAN13 et ITF14
    //                                           CalculateKey qui calcule la clef d'un code barre EAN8, EAN13 et ITF14
    //                                           EAN13ToITF14 qui convertit un EAN13 en ITF14
    //                                           ITF14ToEAN13 qui convertit un ITF14 en EAN13


    trigger OnRun()
    var
        Slimslam: Text[30];
        Slimslam2: Text[54];
    begin
    end;

    var
        AsciiStr: Text[250];
        AnsiStr: Text[250];
        CharVar: array[32] of Char;

    [Scope('OnPrem')]
    procedure Ansi2Ascii(_Text: Text[250]): Text[250]
    begin
        MakeVars;
        exit(ConvertStr(_Text, AnsiStr, AsciiStr));
    end;

    [Scope('OnPrem')]
    procedure Ascii2Ansi(_Text: Text[250]): Text[250]
    begin
        MakeVars;
        exit(ConvertStr(_Text, AsciiStr, AnsiStr));
    end;

    [Scope('OnPrem')]
    procedure MakeVars()
    begin
        AsciiStr := 'ÇüéâäàåçêëèïîìÄÅÉæÆôöòûùÿÖÜø£Ø×ƒáíóúñÑªº¿®¬½¼¡«»¦¦¦¦¦ÁÂÀ©¦¦++¢¥++--+-+ãÃ++--¦-+';
        AsciiStr := AsciiStr + '¤ðÐÊËÈiÍÎÏ++¦_¦Ì¯ÓßÔÒõÕµþÞÚÛÙýÝ¯´­±=¾¶§÷¸°¨·¹³²¦ ';
        CharVar[1] := 196;
        CharVar[2] := 197;
        CharVar[3] := 201;
        CharVar[4] := 242;
        CharVar[5] := 220;
        CharVar[6] := 186;
        CharVar[7] := 191;
        CharVar[8] := 188;
        CharVar[9] := 187;
        CharVar[10] := 193;
        CharVar[11] := 194;
        CharVar[12] := 192;
        CharVar[13] := 195;
        CharVar[14] := 202;
        CharVar[15] := 203;
        CharVar[16] := 200;
        CharVar[17] := 205;
        CharVar[18] := 206;
        CharVar[19] := 204;
        CharVar[20] := 175;
        CharVar[21] := 223;
        CharVar[22] := 213;
        CharVar[23] := 254;
        CharVar[24] := 218;
        CharVar[25] := 219;
        CharVar[26] := 217;
        CharVar[27] := 180;
        CharVar[28] := 177;
        CharVar[29] := 176;
        CharVar[30] := 185;
        CharVar[31] := 179;
        CharVar[32] := 178;
        AnsiStr := 'Ã³ÚÔõÓÕþÛÙÞ´¯ý' + Format(CharVar[1]) + Format(CharVar[2]) + Format(CharVar[3]) + 'µã¶÷' + Format(CharVar[4]);
        AnsiStr := AnsiStr + '¹¨ Í' + Format(CharVar[5]) + '°úÏÎâßÝ¾·±Ð¬' + Format(CharVar[6]) + Format(CharVar[7]);
        AnsiStr := AnsiStr + '«¼¢' + Format(CharVar[8]) + 'í½' + Format(CharVar[9]) + '___ªª' + Format(CharVar[10]) + Format(CharVar[11]);
        AnsiStr := AnsiStr + Format(CharVar[12]) + '®ªª++óÑ++--+-+Ò' + Format(CharVar[13]) + '++--ª-+ñ­ð';
        AnsiStr := AnsiStr + Format(CharVar[14]) + Format(CharVar[15]) + Format(CharVar[16]) + 'i' + Format(CharVar[17]) + Format(CharVar[18]);
        AnsiStr := AnsiStr + '¤++__ª' + Format(CharVar[19]) + Format(CharVar[20]) + 'Ë' + Format(CharVar[21]) + 'ÈÊ§';
        AnsiStr := AnsiStr + Format(CharVar[22]) + 'Á' + Format(CharVar[23]) + 'Ì' + Format(CharVar[24]) + Format(CharVar[25]);
        AnsiStr := AnsiStr + Format(CharVar[26]) + '²¦»' + Format(CharVar[27]) + '¡' + Format(CharVar[28]) + '=¥Âº¸©' + Format(CharVar[29]
        );
        AnsiStr := AnsiStr + '¿À' + Format(CharVar[30]) + Format(CharVar[31]) + Format(CharVar[32]) + '_ ';
    end;

    [Scope('OnPrem')]
    procedure ControlBarCod(pBarCod: Text[30]; var pMessage: Text[30]; pLenBarCod: Integer) Return: Boolean
    var
        tIncomplet: Label 'Incomplet Code';
        tErrorCode: Label 'Barcod Error';
    begin
        //pLenBarCod doit être égale à 13 pour un code EAN13, à 8 pour un code EAN8 ou à 14 pour un code ITF14

        pMessage := '';

        if pBarCod = '' then begin
        end
        else
            if StrLen(pBarCod) <> pLenBarCod then
                pMessage := tIncomplet
            else begin
                if ((pLenBarCod = 8) and (CalculateKey(pBarCod) <> pBarCod[8])) or
                   ((pLenBarCod = 13) and (CalculateKey(pBarCod) <> pBarCod[13])) or
                   ((pLenBarCod = 14) and (CalculateKey(pBarCod) <> pBarCod[14])) then
                    pMessage := tErrorCode;
            end;

        Return := pMessage = '';
    end;

    [Scope('OnPrem')]
    procedure EAN13ToITF14(pBarCod: Text[13]; pFirstNbr: Integer) Return: Text[14]
    begin
        if StrLen(pBarCod) = 13 then
            Return := Format(pFirstNbr) + CopyStr(pBarCod, 1, 12) + Format(CalculateKey(Format(pFirstNbr) + pBarCod))
        else
            Return := '';
    end;

    [Scope('OnPrem')]
    procedure CalculateKey(pBarCod: Text[30]) pKey: Integer
    begin
        //Renvoi 99 si la longueur du code barre est différent de 8,13 ou 14

        case StrLen(pBarCod) of
            8:
                pKey := StrCheckSum(CopyStr(pBarCod, 1, 7), '1313131', 10);
            13:
                pKey := StrCheckSum(CopyStr(pBarCod, 1, 12), '131313131313', 10);
            14:
                pKey := StrCheckSum(CopyStr(pBarCod, 1, 13), '1313131313131', 11);
            else
                pKey := 99;
        end;
    end;

    [Scope('OnPrem')]
    procedure ITF14ToEAN13(pBarCod: Text[14]) Return: Text[13]
    begin
        if StrLen(pBarCod) = 14 then
            Return := CopyStr(pBarCod, 2, 12) + Format(CalculateKey(CopyStr(pBarCod, 2, 13)))
        else
            Return := '';
    end;
}

