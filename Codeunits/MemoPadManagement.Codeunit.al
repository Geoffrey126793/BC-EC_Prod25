codeunit 8001411 "MemoPad Management"
{
    // //+REF+MEMOPAD CW 07/02/05 Thank's to WaldoPad (Cf. Mibuso)
    //    WaldoNavPad have to be installed and registred on each client
    // 
    // Can be extended to other comment line tables with a couple of lines :
    // 
    // 1) Add a "Separator" field (convention = 8001400) in the comment line table
    // 
    // 2) Add this source code to CommentSheet.OnOpenForm
    // 
    // LocalVar (convention ID = 800140x)
    //   lMemoPad   Codeunit   MemoPad Management
    //   lRecordRef RecordRef
    // 
    // //+REF+MEMOPAD
    // CurrentForm.saverecord;
    // lRecordRef.GETTABLE(Rec);
    // IF lMemoPad.Edit(lRecordRef,Caption) THEN
    //   CurrForm.CLOSE;
    // //+REF+MEMOPAD//
    // 
    // 3) If Comment field name is not "Comment" or
    //       Separator field name is not "Separator
    // 
    //      Add a case to Edit function with this template :
    //      SetCommentLine(pRecordRef,Caption,CheckLine,CommentField,Comment2Field,SeparatorField);


    trigger OnRun()
    begin
    end;

    var
        tCaption: Label '%1 - NotePad';
        tError: Label 'No memo for table %1.';
        gCheck: Boolean;
        gLineNoField: Integer;
        gCommentField: Integer;
        gComment2Field: Integer;
        gSeparatorField: Integer;
        tWarning: Label 'Warning : only %1 column will be kept.\Do you want to continue?';
        tCancel: Label 'Cancel';
        tOK: Label 'OK';

    [Scope('OnPrem')]
    procedure Edit(var pRecordRef: RecordRef; pCaption: Text[80]): Boolean
    var
        lKeyRef: KeyRef;
    begin
        /*
        IF NOT CREATE(WaldoNavPad) THEN
          EXIT(FALSE);
        
        CASE pRecordRef.NUMBER OF
        DATABASE::"Sales Line": // 37
          lSetCommentLine(pRecordRef,pCaption,FALSE,11,0,8001400); // Description
        DATABASE::"Purchase Line": // 39
          lSetCommentLine(pRecordRef,pCaption,FALSE,11,0,8001400); // Description
        DATABASE::"Extended Text Line": // 280
          lSetCommentLine(pRecordRef,pCaption,FALSE,6,0,8001400); // Text
        DATABASE::Table8004226: // 8004226
          lSetCommentLine(pRecordRef,pCaption,FALSE,6,0,8001400); // Comment
        ELSE IF NOT lSetDefaultCommentLine(pRecordRef,pCaption) THEN
          ERROR(tError,pRecordRef.NUMBER);
        END;
        
        IF NOT lGetMemo(pRecordRef,gCheck) THEN BEGIN
          CLEAR(WaldoNavPad);
          EXIT(FALSE);
        END;
        
        IF pCaption <> '' THEN
          pCaption := pCaption + ' ';
        lKeyRef := pRecordRef.KEYINDEX(1);
        WaldoNavPad.FormTitle := STRSUBSTNO(tCaption,pCaption+lCaptionFields(lKeyRef));
        WaldoNavPad.OKButtonText := tOK;
        WaldoNavPad.CancelButtonText := tCancel;
        WaldoNavPad.ShowDialog;
        IF WaldoNavPad.DialogResultOK THEN BEGIN
          lDeleteMemo(pRecordRef);
          lSaveMemo(pRecordRef);
        END;
        CLEAR(WaldoNavPad);
        EXIT(TRUE);
        */

    end;

    [Scope('OnPrem')]
    procedure Edit2(var pRecordRef: RecordRef; pCaption: Text[80]; pCheck: Boolean; pCommentField: Integer; pComment2Field: Integer; pSeparatorField: Integer): Boolean
    var
        lKeyRef: KeyRef;
    begin
        // This function can edit "Description" + "Description 2" on same MemoPad
        // Form and report need some modifications to append these 2 fields
        // See form 387 "Extended Text Lines" as an example
        /*
        IF NOT CREATE(WaldoNavPad) THEN
          EXIT(FALSE);
        
        lSetCommentLine(pRecordRef,pCaption,pCheck,pCommentField,pComment2Field,pSeparatorField);
        
        IF NOT lGetMemo(pRecordRef,gCheck) THEN BEGIN
          CLEAR(WaldoNavPad);
          EXIT(FALSE);
        END;
        
        IF pCaption <> '' THEN
          pCaption := pCaption + ' ';
        lKeyRef := pRecordRef.KEYINDEX(1);
        WaldoNavPad.FormTitle := STRSUBSTNO(tCaption,pCaption+lCaptionFields(lKeyRef));
        WaldoNavPad.OKButtonText := tOK;
        WaldoNavPad.CancelButtonText := tCancel;
        WaldoNavPad.ShowDialog;
        IF WaldoNavPad.DialogResultOK THEN BEGIN
          lDeleteMemo(pRecordRef);
          lSaveMemo(pRecordRef);
        END;
        CLEAR(WaldoNavPad);
        EXIT(TRUE);
         */

    end;

    local procedure lSetCommentLine(pRecordRef: RecordRef; pCaption: Text[80]; pCheck: Boolean; pCommentField: Integer; pComment2Field: Integer; pSeparatorField: Integer)
    var
        lFieldRef: FieldRef;
        lKeyRef: KeyRef;
    begin
        gCheck := pCheck;
        lKeyRef := pRecordRef.KeyIndex(1);
        lFieldRef := lKeyRef.FieldIndex(lKeyRef.FieldCount); // LastField of Primary Key
        gLineNoField := lFieldRef.Number;
        gCommentField := pCommentField;
        gComment2Field := pComment2Field;
        gSeparatorField := pSeparatorField;
    end;

    local procedure lSetDefaultCommentLine(var pRecordRef: RecordRef; pCaption: Text[250]): Boolean
    var
        lCommentField: Record "Field";
        lSeparatorField: Record "Field";
    begin
        lCommentField.SetRange(TableNo, pRecordRef.Number);
        lCommentField.SetRange(FieldName, 'Comment');
        if not lCommentField.Find('-') then
            exit(false);
        lSeparatorField.SetRange(TableNo, pRecordRef.Number);
        lSeparatorField.SetRange(FieldName, 'Separator');
        if not lSeparatorField.Find('-') then
            exit(false);
        lSetCommentLine(pRecordRef, pCaption, true, lCommentField."No.", 0, lSeparatorField."No.");
        exit(true);
    end;

    local procedure lGetMemo(var pRecordRef: RecordRef; pCheck: Boolean): Boolean
    var
        lFieldRef: FieldRef;
        lComment: Text[250];
        lComment2: Text[250];
        lSeparator: Integer;
        lWarning: Boolean;
    begin
        /*
        WITH pRecordRef DO BEGIN
          IF FIND('-') THEN BEGIN
            REPEAT
              IF pCheck THEN
                lWarning := lWarning OR lCheckLineWarning(pRecordRef);
              lFieldRef := FIELD(gCommentField);
              lComment := lFieldRef.VALUE;
              IF gComment2Field <> 0 THEN BEGIN
                lComment2 := '';
                lFieldRef := FIELD(gComment2Field);
                lComment2 := lFieldRef.VALUE;
                lComment := lComment + lComment2;
              END;
              lFieldRef := FIELD(gSeparatorField);
              lSeparator := lFieldRef.VALUE;
              lAppendMemo(lComment,lSeparator);
            UNTIL NEXT = 0;
          END ELSE BEGIN
            WaldoNavPad.Text := '';
          END;
          EXIT(NOT lWarning);
        END;
        */

    end;

    local procedure lDeleteMemo(var pRecordRef: RecordRef)
    begin
        if pRecordRef.Find('-') then
            pRecordRef.DeleteAll(true);
    end;

    local procedure lSaveMemo(var pRecordRef: RecordRef)
    var
        lFieldRef: FieldRef;
        lSeparator: Integer;
        lComment: Text[250];
        lLineNo: Integer;
        lFirst: Boolean;
    begin
        /*
        WITH pRecordRef DO BEGIN
          WaldoNavPad.AppendText(' ');
          lFirst := TRUE;
          WHILE NOT (WaldoNavPad.EOS) DO BEGIN
            lFieldRef := FIELD(gLineNoField);
            IF lFirst THEN BEGIN
              lLineNo := lFieldRef.VALUE;
              IF lLineNo = 0 THEN BEGIN
                lLineNo := 10000;
                lFieldRef.VALUE := lLineNo;
              END;
            END;
            IF NOT lFirst THEN BEGIN
              lLineNo += 10000;
              lFieldRef.VALUE := lLineNo;
            END;
        
        //Previous Code
        //    lLineNo := lFieldRef.VALUE;
        //    IF gCheck THEN
        //      lFieldRef.VALUE := lLineNo + 10000;
        //    ELSE
        //      lFieldRef.VALUE := lLineNo + 1;
        //Previous Code//
        
            lFieldRef := FIELD(gCommentField);
            WaldoNavPad.TextFieldLength := lFieldRef.LENGTH;
            WaldoNavPad.GetNextTextField(lComment,lSeparator);
            IF STRLEN(lComment) <> 0 THEN
              IF lComment[STRLEN(lComment)] = ' ' THEN
                lComment := DELSTR(lComment,STRLEN(lComment));
            IF (gComment2Field = 0) OR (lSeparator <> 1 {space}) THEN BEGIN
              lFieldRef.VALUE := lComment;
              IF (gComment2Field <> 0) THEN BEGIN
                lFieldRef := FIELD(gComment2Field);
                lFieldRef.VALUE := '';
              END;
            END ELSE IF STRLEN(lComment) = lFieldRef.LENGTH THEN BEGIN
              lFieldRef.VALUE := lComment;
              lFieldRef := FIELD(gComment2Field);
              WaldoNavPad.TextFieldLength := lFieldRef.LENGTH;
              WaldoNavPad.GetNextTextField(lComment,lSeparator);
              lFieldRef.VALUE := ' ' + lComment;
            END ELSE BEGIN
              lFieldRef.VALUE := lComment + ' ';
              lFieldRef := FIELD(gComment2Field);
              WaldoNavPad.TextFieldLength := lFieldRef.LENGTH;
              WaldoNavPad.GetNextTextField(lComment,lSeparator);
              lFieldRef.VALUE := lComment;
            END;
        
            lFieldRef := FIELD(gSeparatorField);
            lFieldRef.VALUE := lSeparator - 1;
            WHILE NOT INSERT(TRUE) DO BEGIN
              lFieldRef := FIELD(gLineNoField);
              lLineNo := lFieldRef.VALUE;
              lFieldRef.VALUE := lLineNo + 10000;
            END;
            lFirst := FALSE;
          END;
        END;
        */

    end;

    local procedure lAppendMemo(pComment: Text[250]; pSeparator: Integer)
    var
        lChar13: Char;
        lChar10: Char;
        lSeparator: Integer;
    begin
        /*
        lChar13 := 13;
        lChar10 := 10;
        WaldoNavPad.AppendText(pComment);
        CASE pSeparator + 1 OF
          1:WaldoNavPad.AppendText(' ');
          2:WaldoNavPad.AppendText(FORMAT(lChar13) + FORMAT(lChar10));
        END;
        */

    end;

    local procedure lCheckLineWarning(var pRecordRef: RecordRef): Boolean
    var
        i: Integer;
        k: Integer;
        lDate: Date;
        lDecimal: Decimal;
        lText: Text[250];
        lFieldRef: FieldRef;
        lField: Record "Field";
        lKeyRef: KeyRef;
    begin
        lKeyRef := pRecordRef.KeyIndex(1);
        with pRecordRef do begin
            i := 0;
            while i < FieldCount do begin
                i += 1;
                lFieldRef := FieldIndex(i);
                k := 1;
                while (k < lKeyRef.FieldCount) and (lKeyRef.FieldIndex(k).Number <> lFieldRef.Number) do
                    k += 1;
                if (lKeyRef.FieldIndex(k).Number <> lFieldRef.Number) and
                   (lFieldRef.Number <> gCommentField) and
                   (lFieldRef.Number <> gSeparatorField) then begin
                    Evaluate(lField.Type, Format(lFieldRef.Type));
                    case lField.Type of
                        lField.Type::Date, lField.Type::DateTime:
                            begin
                                lDate := lFieldRef.Value;
                                if lDate <> 0D then
                                    exit(true);
                            end;
                        lField.Type::OemText, lField.Type::OemCode:
                            begin
                                lText := lFieldRef.Value;
                                if lText <> '' then
                                    exit(true);
                            end else
                                    lDecimal := lFieldRef.Value;
                                    if lDecimal <> 0 then
                                        exit(true);
                    end;
                end;
            end;
        end;
    end;

    local procedure lCaptionFields(var pKeyRef: KeyRef) Return: Text[250]
    var
        lFieldRef: FieldRef;
        lField: Record "Field";
        i: Integer;
    begin
        for i := 1 to pKeyRef.FieldCount - 1 do begin // Last field = "Line No."
            lFieldRef := pKeyRef.FieldIndex(i);
            if Return <> '' then
                Return := Return + ' ';
            Evaluate(lField.Type, Format(lFieldRef.Type));
            if lField.Type <> lField.Type::Option then
                Return := Return + Format(lFieldRef.Value);
        end;
    end;

    [Scope('OnPrem')]
    procedure Split(var pLongText: Text[250]; var pText1: Text[250]; var pText2: Text[250])
    var
        i: Integer;
    begin
        if StrLen(pLongText) <= MaxStrLen(pText1) then begin
            pText1 := pLongText;
            pText2 := '';
        end else begin
            i := MaxStrLen(pText1) + 1;
            if (StrPos(pLongText, ' ') <> 0) or (StrPos(pLongText, '.') <> 0) or (StrPos(pLongText, ',') <> 0) or
               (StrPos(pLongText, ';') <> 0) or (StrPos(pLongText, ':') <> 0) then
                while (i > 0) and not (pLongText[i] in [' ', '.', ',', ';', ':']) do
                    i -= 1;
            if (i = 0) or (i = MaxStrLen(pText1) + 1) or (StrLen(pLongText) - i > MaxStrLen(pText2)) then
                i := MaxStrLen(pText1);
            pText1 := CopyStr(pLongText, 1, i);
            pText2 := CopyStr(pLongText, i + 1);
        end;
    end;
}

