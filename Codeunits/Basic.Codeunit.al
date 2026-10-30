codeunit 8001407 Basic
{
    // //+BGW+BASIC CW 04/09/03 Remplace une variable par un champ d'un RecordRef


    trigger OnRun()
    var
        lRec: Record "Purchase Header";
        lRecordRef: RecordRef;
        lText: Text[250];
        lID: Text[30];
    begin
        // Only for testing
        lRec.Find('-');
        lRecordRef.GetTable(lRec);
        lText := '3.5-3.1';
        Message('lText = %1', lText);
        SubstituteValues(lText, lRecordRef, '3.', GlobalLanguage);
        Message('%1 (%2)', lText, lRec);
        lText := '%1%3%2%';
        Message('lText = %1', lText);
        SubstituteValues(lText, lRecordRef, '%', GlobalLanguage);
        Message('%1 (%2)', lText, lRec);
        /*
        MESSAGE('%1, CaseSensitive=%2',StrReplace('Replace this by that in This sentence','this','that',FALSE,FALSE),FALSE);
        MESSAGE('%1, CaseSensitive=%2',StrReplace('Replace this by that in This sentence','this','that',TRUE,FALSE),TRUE);
        MESSAGE('%1, FullWord=%2',StrReplace('Replace this by that at this place','place','position',FALSE,FALSE),FALSE);
        MESSAGE('%1, FullWord=%2',StrReplace('Replace this by that at This place','place','position',FALSE,TRUE),TRUE);
        MESSAGE('%1',lText);
        //MESSAGE('%1',StrReplace('Replace %0 by Facture at This place','%0','Facture',FALSE,TRUE),TRUE);
        lText := '2:%2, 18.1:%18.1 (27.3:%27.3:10)';
        MESSAGE('%1=>\%2',lText,SubstituteCaptions(lText,18));
        */

    end;

    var
        tSyntaxError: Label 'Syntax error in "%1" at %2 position';
        RoundingPrecision: Decimal;
        PI: Decimal;
        EXP: Decimal;
        Sumcoef: Decimal;

    [Scope('OnPrem')]
    procedure SubstituteValues(var pText: Text[250]; pRecordRef: RecordRef; pID: Text[30]; pLanguage: Integer)
    var
        lField: Record "Field";
        lRecordRef: RecordRef;
        lFieldRef: FieldRef;
        lFieldNo: Integer;
        lFieldWidth: Integer;
        lFieldValue: Text[250];
        lPos: Integer;
        lFrom: Integer;
        lIdLen: Integer;
        lTranslationMgt: Codeunit "Translation Management";
        lLanguage: Record Language;
    begin
        lPos := StrPos(pText, pID);
        lIdLen := StrLen(pID);
        while (lPos <> 0) and (lPos + lFrom < MaxStrLen(pText)) do begin
            lPos += lFrom;
            lFrom := lPos;
            if not (pText[lPos + lIdLen] in ['0' .. '9']) then
                lFrom += lIdLen
            else begin
                pText := DelStr(pText, lPos, lIdLen);
                lFieldNo := lExtractInteger(pText, lPos);
                if pText[lPos] = ':' then begin
                    pText := DelStr(pText, lPos, 1);
                    lFieldWidth := lExtractInteger(pText, lPos);
                end else
                    lFieldWidth := 0;
                if lField.Get(pRecordRef.Number, lFieldNo) then begin
                    lFieldRef := pRecordRef.Field(lFieldNo);
                    Evaluate(lField.Class, Format(lFieldRef.Class));
                    if lField.Class = lField.Class::FlowField then
                        lFieldRef.CalcField;
                    lLanguage.SetRange("Windows Language ID", pLanguage);
                    if lLanguage.Find('-') then;
                    if pRecordRef.FieldExist(1) then
                        lFieldValue := lTranslationMgt.GetTranslation(pRecordRef.Number, lFieldNo, Format(pRecordRef.Field(1)),
                                      lLanguage.Code, lFormatField(lFieldRef, lFieldWidth))
                    else
                        lFieldValue := lFormatField(lFieldRef, lFieldWidth);
                    pText := CopyStr(CopyStr(pText, 1, lPos - 1) + lFieldValue + CopyStr(pText, lPos), 1, MaxStrLen(pText));
                    lFrom += StrLen(lFieldValue) - 1;
                end;
            end;
            lPos := StrPos(CopyStr(pText, lFrom + 1), pID);
        end;
    end;

    [Scope('OnPrem')]
    procedure SubstituteCaptions(pText: Text[250]; pTableID: Integer; pLanguage: Integer): Text[250]
    var
        lObject: Record "Object";
        lField: Record "Field";
        lRecordRef: RecordRef;
        lFieldRef: FieldRef;
        lPos: Integer;
        lFieldNo: Integer;
        lTableCaption: Text[30];
        lRight: Text[250];
        lTranslationMgt: Codeunit "Translation Management";
        lLanguage: Record Language;
    begin
        lPos := StrPos(pText, '%');
        while lPos > 0 do begin
            lTableCaption := '';
            pText := DelStr(pText, lPos, 1);
            lFieldNo := lExtractInteger(pText, lPos);
            if pText[lPos] = '.' then begin
                if lPos = StrLen(pText) then
                    lRecordRef.Open(pTableID)
                else
                    if not (pText[lPos + 1] in ['0' .. '9']) then
                        lRecordRef.Open(pTableID)
                    else
                        if not lObject.Get(lObject.Type::Table, '', lFieldNo) then
                            exit(CopyStr(pText, 1, lPos) + '??') //ERROR(tSyntaxError,pText,lPos)
                        else begin
                            pText := DelStr(pText, lPos, 1);
                            lRecordRef.Open(lFieldNo);
                            lFieldNo := lExtractInteger(pText, lPos);
                            lTableCaption := '"' + lRecordRef.Caption + '".';
                        end;
            end else
                if (pTableID <> 0) and (lObject.Get(lObject.Type::Table, '', pTableID)) then
                    lRecordRef.Open(pTableID)
                else
                    exit(CopyStr(pText, 1, lPos) + '??'); //ERROR(tSyntaxError,pText,lPos);
            if not lField.Get(pTableID, lFieldNo) then
                exit(CopyStr(pText, 1, lPos) + '??'); //ERROR(tSyntaxError,pText,lPos);
            lFieldRef := lRecordRef.Field(lFieldNo);
            lRight := CopyStr(pText, lPos);
            pText := CopyStr(CopyStr(pText, 1, lPos - 1) + lTableCaption + '"' + lFieldRef.Caption + '"', 1, MaxStrLen(pText));
            lPos := StrPos(lRight, '%'); // Avoid '%' in TableCaption or FieldCaption
            if lPos <> 0 then
                lPos += StrLen(pText);
            pText := CopyStr(pText + lRight, 1, MaxStrLen(pText));
            /*
              lLanguage.SETRANGE("Windows Language ID",pLanguage);
              IF lLanguage.FIND('-') THEN;
              pText := lTranslationMgt.GetTranslation(lRecordRef.NUMBER,lFieldNo,FORMAT(lRecordRef.FIELD(1)),
                                  lLanguage.Code,pText);
            */
        end;
        exit(pText);

    end;

    local procedure lExtractInteger(var pText: Text[250]; pPos: Integer) Return: Integer
    var
        lText: Text[30];
    begin
        while (pPos <= StrLen(pText)) and (pText[pPos] in ['0' .. '9']) do begin
            lText := lText + CopyStr(pText, pPos, 1);
            pText := DelStr(pText, pPos, 1);
        end;
        if lText = '' then
            lText := '0';
        Evaluate(Return, lText);
    end;

    local procedure lFormatField(pFieldRef: FieldRef; pWidth: Integer) Return: Text[250]
    var
        lFieldRec: Record "Field";
        lInteger: Integer;
        lDecimal: Decimal;
    begin
        Evaluate(lFieldRec.Type, Format(pFieldRef.Type));
        Return := Format(pFieldRef.Value);
        if lFieldRec.Type = lFieldRec.Type::Option then begin
            Evaluate(lInteger, Return);
            Return := SelectStr(lInteger + 1, pFieldRef.OptionCaption);
        end;
        if (RoundingPrecision <> 0) and
           (lFieldRec.Type = lFieldRec.Type::Decimal)
        then begin
            Evaluate(lDecimal, Return);
            lDecimal := Round(lDecimal, RoundingPrecision);
            Return := Format(lDecimal);
        end;
        if pWidth <> 0 then
            Return := PadStr(Return, pWidth);
    end;

    [Scope('OnPrem')]
    procedure StrReplace(pText: Text[250]; pFrom: Text[250]; pTo: Text[250]; pCaseSensitive: Boolean; pFullWord: Boolean) Return: Text[250]
    var
        lPos: Integer;
        i: Integer;
    begin
        Return := pText;
        lPos := 1;
        repeat
            if (lPos > 1) and pFullWord then
                while (lPos < StrLen(Return)) and not (Return[lPos] in [' ', '.', ';', ',', '(', ')']) do
                    lPos += 1;
            if pCaseSensitive then
                i := StrPos(CopyStr(Return, lPos), pFrom)
            else
                i := StrPos(UpperCase(CopyStr(Return, lPos)), UpperCase(pFrom));
            lPos += i - 1;
            if i <> 0 then begin
                if not pFullWord or lCheckFullWord(Return, lPos, StrLen(pFrom)) then begin
                    Return := CopyStr(Return, 1, lPos - 1) + pTo + CopyStr(Return, lPos + StrLen(pFrom));
                    lPos += StrLen(pTo);
                end;
            end;
        until (i = 0) or (lPos > StrLen(Return));
    end;

    local procedure lCheckFullWord(pText: Text[250]; pPos: Integer; pLen: Integer): Boolean
    begin
        if pPos > 1 then
            if not (pText[pPos - 1] in [' ', '.', ';', ',', '(', ')']) then
                exit(false);
        if StrLen(pText) = pPos + pLen - 1 then
            exit(true);
        exit(pText[pPos + pLen] in [' ', '.', ';', ',', '(', ')']);
    end;

    [Scope('OnPrem')]
    procedure InitRoundingPrecision(pRoundingPrecision: Decimal)
    begin
        RoundingPrecision := pRoundingPrecision;
    end;

    [Scope('OnPrem')]
    procedure LoiNormale(T: Integer; Ecart: Decimal; X: Integer): Decimal
    begin
        //T = Nombre de jours total de la rÔÇÜpartition
        //X = Nombre de jours depuis le  dÔÇÜbut
        //Ecart = permet de d'ÔÇÜcraser ou d'agrandir le sommet de la courbe
        EXP := 2.718281828;
        PI := 3.141592654;
        exit((1 / (Ecart * Power(2 * PI, 0.5))) * Power(EXP, -0.5 * Power(((X - (T / 2)) / Ecart), 2)));
    end;

    [Scope('OnPrem')]
    procedure SumLoiNormale(T: Integer; Ecart: Decimal)
    var
        I: Integer;
    begin
        Sumcoef := 0;
        for I := 0 to T do begin
            Sumcoef += LoiNormale(T, Ecart, I);
        end;
    end;

    [Scope('OnPrem')]
    procedure CoefLoiNormale(T: Integer; Ecart: Decimal; X: Integer): Decimal
    begin
        if Sumcoef <> 0 then
            exit(LoiNormale(T, Ecart, X) / Sumcoef)
        else
            exit(LoiNormale(T, Ecart, X));
    end;

    [Scope('OnPrem')]
    procedure CheckDataBaseLicense(pDataBaseNo: Integer): Boolean
    var
        LicensePermission: Record "License Permission";
    begin
        LicensePermission.SetRange("Object Type", LicensePermission."Object Type"::TableData);
        LicensePermission.SetRange("Object Number", pDataBaseNo);
        LicensePermission.SetFilter("Insert Permission", '<>%1', LicensePermission."Insert Permission"::" ");
        if LicensePermission.Find('-') then
            exit(true);
        exit(false);
    end;

    [Scope('OnPrem')]
    procedure AddRecordRef(var pRecordRef1: RecordRef; var pRecordRef2: RecordRef; pFactor: Decimal)
    var
        i: Integer;
        lFieldRef1: FieldRef;
        lFieldRef2: FieldRef;
        lField: Record "Field";
        lValue1: Decimal;
        lValue2: Decimal;
    begin
        for i := 1 to pRecordRef1.FieldCount do begin
            lFieldRef1 := pRecordRef1.FieldIndex(i);
            lFieldRef2 := pRecordRef2.FieldIndex(i);
            Evaluate(lField.Type, Format(lFieldRef1.Type));
            if lField.Type = lField.Type::Decimal then begin
                lValue1 := lFieldRef1.Value;
                lValue2 := lFieldRef2.Value;
                lValue1 += lValue2 * pFactor;
                lFieldRef1.Value := lValue1;
                //   lFieldRef1.VALUE := 0;
            end;
        end;
    end;
}

