codeunit 8001413 "Sort Management"
{
    // //+BGW+SORT CW 31/07/04 Sort Management


    trigger OnRun()
    begin
    end;

    var
        Sort: Record Sort;
        tSortMax1: Label 'Only first level of %1 is used for this report.';
        tSortMaxN: Label 'Olny %1 levels of %2 are used for this report.';
        tProgress: Label 'Procesing...';
        tOrderBy: Label 'Order by :';
        SortKey: Record "Sort Key";
        SortField: array[5] of Record "Sort Field";
        SortMax: Integer;
        SortLevel: Integer;
        SortNewPage: Boolean;
        InputCount: array[5] of Integer;
        OutputCount: array[5] of Integer;
        DistinctCount: array[5] of Integer;
        TotalInput: Integer;
        TotalOutput: Integer;
        Progress: array[2] of BigInteger;
        ProgressDialog: Dialog;
        ProgressCount: Integer;
        ProgressEnabled: Boolean;
        tGroupTitle: Label '%1 %2 ';
        tGroupTotal: Label 'Total %1 %2 ';
        AccountingStartPeriod: array[20] of Date;
        gRecordRef: RecordRef;
        RepCurrFactor: Decimal;
        tRepCurr: Label 'All amounts are in %1.';
        tPeriod: Label '%1 from %2 to %3';
        tAtDate: Label '%1 at %2';

    [Scope('OnPrem')]
    procedure InitReport(var pRecordRef: RecordRef; var pSortKey: Record "Sort Key"; pSortMax: Integer)
    begin
        pSortKey.SetRange(TableNo, pRecordRef.Number);
        pSortKey.TableNo := pRecordRef.Number;
        SortMax := pSortMax;
    end;

    [Scope('OnPrem')]
    procedure OpenForm(var pSortKey: Record "Sort Key")
    begin
        if pSortKey.Get(pSortKey.GetRangeMin(TableNo), pSortKey.SortKey) then;
    end;

    [Scope('OnPrem')]
    procedure AssistEdit(var pSortKey: Record "Sort Key")
    var
        lSortField: Record "Sort Field";
        lCount: Integer;
    begin

    end;

    [Scope('OnPrem')]
    procedure PreReport(var pSortKey: Record "Sort Key")
    var
        lSortField: Record "Sort Field";
        lAccountingPeriod: Record "Accounting Period";
        i: Integer;
    begin
        Sort.DateTime := CurrentDateTime;
        lSortField.SetRange(TableNo, pSortKey.TableNo);
        lSortField.SetRange(SortKey, pSortKey.SortKey);
        if lSortField.Find('-') then
            repeat
                i += 1;
                lSortField.CalcFields("Field Caption");
                SortField[i] := lSortField;
            until (lSortField.Next = 0) or (i = 5);

        i := 0;

        lAccountingPeriod.SetRange("New Fiscal Year", true);
        if lAccountingPeriod.Find('-') then
            repeat
                i += 1;
                AccountingStartPeriod[i] := lAccountingPeriod."Starting Date";
            until (i = 20) or (lAccountingPeriod.Next = 0);
    end;

    [Scope('OnPrem')]
    procedure SortInsert(var pRecordRef: RecordRef)
    var
        lSortField: Record "Sort Field";
    begin
        with Sort do begin
            lInitKey(pRecordRef, SortField[1], "Key 1");
            lInitKey(pRecordRef, SortField[2], "Key 2");
            lInitKey(pRecordRef, SortField[3], "Key 3");
            lInitKey(pRecordRef, SortField[4], "Key 4");
            lInitKey(pRecordRef, SortField[5], "Key 5");
            "Entry No." += 1;
            RecID := pRecordRef.RecordId;
            Insert;
        end;

        Progress[1] += 1;
        if ProgressEnabled then
            ProgressDialog.Update(1, Progress[1] * 10000 div ProgressCount);
    end;

    [Scope('OnPrem')]
    procedure lInitKey(var pRecordRef: RecordRef; var pSortField: Record "Sort Field"; var pKey: Text[30])
    begin
        if pSortField."Sort Direction" = pSortField."Sort Direction"::Descending then
            pKey := lGetFieldValue(pRecordRef, pSortField.FieldNo, 30, true, 1)
        else
            pKey := lGetFieldValue(pRecordRef, pSortField.FieldNo, 30, false, 1);

        if pSortField."Start Position" <> 0 then
            pKey := CopyStr(pKey, pSortField."Start Position", pSortField.Length);
    end;

    [Scope('OnPrem')]
    procedure ProgressInit(pProgressCount: Integer)
    begin
        ProgressDialog.Open(tProgress + '\' + '@1@@@@@@@@@@@@@@@@@@' + '\' + '@2@@@@@@@@@@@@@@@@@@');
        ProgressCount := pProgressCount;
        ProgressEnabled := true;
    end;

    [Scope('OnPrem')]
    procedure PreDataItem()
    begin
    end;

    [Scope('OnPrem')]
    procedure GroupHeader(pLevel: Integer; pCausedBy: Integer) Return: Boolean
    begin
        SortLevel := pLevel;
        Return := SortField[pLevel].Header and (pCausedBy = 10 + pLevel); // "Key 1" : FieldNo = 11, "Key 2" : FieldNo = 12...
        if pCausedBy = 10 + pLevel then begin // "Key 1" : FieldNo = 11, "Key 2" : FieldNo = 12...
            InputCount[pLevel] := 1;
            OutputCount[pLevel] := 0;
            DistinctCount[pLevel + 1] := 0;
            exit(SortField[pLevel].Header)
        end;
    end;

    [Scope('OnPrem')]
    procedure AfterGetRecord(var pSort: Record Sort; var pRecordRef: RecordRef)
    var
        i: Integer;
    begin
        Sort.Copy(pSort);
        Progress[2] += 1;
        if ProgressEnabled then
            ProgressDialog.Update(2, Progress[2] * 10000 div Progress[1]);
        for i := 1 to 5 do
            InputCount[i] += 1;
        TotalInput += 1;

        gRecordRef := pRecordRef.Duplicate;
    end;

    [Scope('OnPrem')]
    procedure Body(lShowOutput: Boolean): Boolean
    var
        i: Integer;
    begin
        case SortKey.Print of
            SortKey.Print::Always:
                lShowOutput := true;
            SortKey.Print::Never:
                lShowOutput := false;
            else
        end;

        if lShowOutput then begin
            for i := 1 to 5 do
                OutputCount[i] += 1;
            TotalOutput += 1;
        end;
        exit(lShowOutput);
    end;

    [Scope('OnPrem')]
    procedure GroupFooter(pLevel: Integer; pCausedBy: Integer): Boolean
    begin
        SortLevel := pLevel;
        if pCausedBy = 10 + pLevel then begin
            SortNewPage := SortNewPage or SortField[pLevel].NewPage;
            if OutputCount[pLevel] <> 0 then
                DistinctCount[pLevel] += 1;
            exit(SortField[pLevel].Footer);
        end;
    end;

    [Scope('OnPrem')]
    procedure Footer()
    begin
        SortLevel := 0;
    end;

    [Scope('OnPrem')]
    procedure PostDataItem()
    begin
    end;

    [Scope('OnPrem')]
    procedure Caption(pSortLevel: Integer): Text[250]
    var
        lSortLevel: Integer;
    begin
        if pSortLevel = 0 then
            lSortLevel := SortLevel
        else
            lSortLevel := pSortLevel;
        with SortField[lSortLevel] do
            if Header or Footer then
                exit(GetHeaderFieldCaption("Field Caption", lSortLevel));
    end;

    [Scope('OnPrem')]
    procedure Value(var pRecordRef: RecordRef; pSortLevel: Integer): Text[250]
    var
        lSortLevel: Integer;
    begin
        if pSortLevel = 0 then
            lSortLevel := SortLevel
        else
            lSortLevel := pSortLevel;

        if SortField[lSortLevel].Header or SortField[lSortLevel].Footer then
            if SortField[lSortLevel]."Sort Direction" = SortField[lSortLevel]."Sort Direction"::Descending then
                exit(lGetFieldValue(pRecordRef, SortField[lSortLevel].FieldNo, 0, true, lSortLevel))
            else
                exit(lGetFieldValue(pRecordRef, SortField[lSortLevel].FieldNo, 0, false, lSortLevel));
    end;

    local procedure lGroupText(pText: Text[250]; pSortLevel: Integer): Text[250]
    var
        lField: Record "Field";
        lAccountingPeriod: Record "Accounting Period";
        lFieldRef: FieldRef;
        lSortLevel: Integer;
        lDescription: Text[250];
        lValue: Text[250];
        lDate: Date;
        tWeek: Label 'On Week';
        tMonth: Label 'On Month';
        tQuarter: Label 'On Quarter';
        tYear: Label 'On Year';
        taccountingPeriod: Label 'On Accounting Period';
        i: Integer;
        lRelation: Integer;
    begin
        if pSortLevel = 0 then
            lSortLevel := SortLevel
        else
            lSortLevel := pSortLevel;
        if SortField[lSortLevel].Header or SortField[lSortLevel].Footer then begin
            case lSortLevel of
                1:
                    lValue := Sort."Key 1";
                2:
                    lValue := Sort."Key 2";
                3:
                    lValue := Sort."Key 3";
                4:
                    lValue := Sort."Key 4";
                5:
                    lValue := Sort."Key 5";
            end;
            //EXIT(STRSUBSTNO(pText,lSortLevel,SortField[lSortLevel])); //??
            lFieldRef := gRecordRef.Field(SortField[lSortLevel].FieldNo);
            lField.Get(gRecordRef.Number, lFieldRef.Number);
            Evaluate(lField.Type, Format(lFieldRef.Type));
            case lField.Type of
                lField.Type::OemText, lField.Type::OemCode:
                    if lFieldRef.Relation = 0 then
                        exit(StrSubstNo(pText, Caption(lSortLevel), lValue, ''))
                    else begin
                        lDescription := GroupDescription(SortField[lSortLevel], lField, lValue, lFieldRef);
                        exit(StrSubstNo(pText, Caption(lSortLevel), lValue, lDescription));
                    end;
                lField.Type::Date:
                    case SortField[lSortLevel].Periodicity of
                        SortField[lSortLevel].Periodicity::Week:
                            exit(StrSubstNo(pText, Caption(lSortLevel), tWeek, Format(lFieldRef.Value, 0, ' <Week>-<Year4>')));
                        SortField[lSortLevel].Periodicity::Month:
                            exit(StrSubstNo(pText, Caption(lSortLevel), tMonth, Format(lFieldRef.Value, 0, ' <Month>-<Year4>')));
                        SortField[lSortLevel].Periodicity::Quarter:
                            exit(StrSubstNo(pText, Caption(lSortLevel), tQuarter, Format(lFieldRef.Value, 0, ' <Quarter>-<Year4>')));
                        SortField[lSortLevel].Periodicity::Year:
                            exit(StrSubstNo(pText, Caption(lSortLevel), tYear, Format(lFieldRef.Value, 0, ' <Year4>')));
                        SortField[lSortLevel].Periodicity::"Accounting Period":
                            begin
                                lDate := lFieldRef.Value;
                                lAccountingPeriod.SetRange("New Fiscal Year", true);
                                lAccountingPeriod.SetRange("Starting Date", 0D, lDate);
                                lAccountingPeriod.Find('+');
                                exit(StrSubstNo(pText, Caption(lSortLevel), taccountingPeriod, Format(lAccountingPeriod."Starting Date", 0,
                                  Format(lAccountingPeriod."Starting Date", 0, '<Day,2><Month,2><Year4>')) + ' ' + lAccountingPeriod.Name));
                            end;
                    end;
                lField.Type::Option:
                    begin
                        i := lFieldRef.Value; // Option rank
                        exit(StrSubstNo(pText, Caption(lSortLevel), SelectStr(i + 1, lFieldRef.OptionCaption), ''));
                    end;
                else
                    exit(StrSubstNo(pText, Caption(lSortLevel), lValue, ''));
            end;
        end;
    end;

    [Scope('OnPrem')]
    procedure GroupDescription(var pSortField: Record "Sort Field"; var pField: Record "Field"; pValue: Text[30]; var pFieldRef: FieldRef): Text[250]
    var
        lRecordRef: RecordRef;
        lFieldRef: array[3] of FieldRef;
        i: Integer;
    begin
        case pFieldRef.Relation of
            0:
                exit('');
            DATABASE::Code:
                begin
                    lRecordRef.Open(pField.RelationTableNo);
                    lFieldRef[1] := lRecordRef.FieldIndex(1);
                    lFieldRef[1].SetRange(pSortField.TableNo);
                    lFieldRef[2] := lRecordRef.FieldIndex(2);
                    lFieldRef[2].SetRange(pSortField.FieldNo);
                    lFieldRef[3] := lRecordRef.FieldIndex(3);
                    lFieldRef[3].SetRange(pValue);
                    if not lRecordRef.Find('-') then
                        exit('');
                end;
            else begin
                lRecordRef.Open(pFieldRef.Relation);
                lFieldRef[1] := lRecordRef.FieldIndex(1);
                lFieldRef[1].SetRange(pValue);
                if not lRecordRef.Find('-') then
                    exit('');
            end;
        end;

        i := 1;
        while (i <= lRecordRef.FieldCount) do begin
            lFieldRef[1] := lRecordRef.FieldIndex(i);
            if lFieldRef[1].Name in ['Description', 'Name', 'City'] then
                exit(lFieldRef[1].Value);
            i += 1;
        end;
    end;

    [Scope('OnPrem')]
    procedure GroupTitle(pSortLevel: Integer): Text[250]
    begin
        exit(lGroupText(tGroupTitle, pSortLevel));
    end;

    [Scope('OnPrem')]
    procedure GroupTotal(pSortLevel: Integer): Text[250]
    begin
        exit(lGroupText(tGroupTotal, pSortLevel));
    end;

    [Scope('OnPrem')]
    procedure "Count"(pSortLevel: Integer): Integer
    begin
        if SortLevel = 0 then
            exit(TotalInput)
        else
            if pSortLevel = 0 then
                exit(InputCount[SortLevel])
            else
                exit(InputCount[pSortLevel]);
    end;

    [Scope('OnPrem')]
    procedure CountOutput(pSortLevel: Integer): Integer
    begin
        if SortLevel = 0 then
            exit(TotalOutput)
        else
            if pSortLevel = 0 then
                exit(OutputCount[SortLevel])
            else
                exit(OutputCount[pSortLevel]);
    end;

    [Scope('OnPrem')]
    procedure Distinct(pLevel: Integer): Integer
    begin
        exit(DistinctCount[pLevel]);
    end;

    [Scope('OnPrem')]
    procedure NewPage() Return: Boolean
    begin
        Return := SortNewPage;
        SortNewPage := false;
    end;

    [Scope('OnPrem')]
    procedure PostReport()
    begin
        Sort.SetRange(DateTime, Sort.DateTime);
        Sort.DeleteAll;

        if ProgressEnabled then
            ProgressDialog.Close;
    end;

    local procedure lGetFieldValue(var pRecordRef: RecordRef; pFieldNo: Integer; pLen: Integer; pDescending: Boolean; pSortlevel: Integer): Text[250]
    var
        lField: Record "Field";
        lFieldRef: FieldRef;
        lOptionNum: Integer;
        lDecimal: Decimal;
        lDate: Date;
        i: Integer;
    begin
        if pFieldNo = 0 then
            exit;
        lFieldRef := pRecordRef.Field(pFieldNo);
        Evaluate(lField.Class, Format(lFieldRef.Class));
        if lField.Class = lField.Class::FlowField then
            lFieldRef.CalcField;

        Evaluate(lField.Type, Format(lFieldRef.Type));
        case lField.Type of

            lField.Type::Decimal:
                begin
                    lDecimal := lFieldRef.Value;
                    if pDescending then
                        exit(Format((lDecimal * -1 + Power(10, 10)) * 100000, pLen, '<Integer>')) // Reverse negative & décimal
                    else
                        exit(Format((lDecimal * 100000) + Power(10, 10), pLen, '<Integer>')); // Right alignment
                end;

            lField.Type::Integer:
                begin
                    lDecimal := lFieldRef.Value;
                    if pDescending then
                        exit(Format((lDecimal + Power(10, 10)) * -1, pLen, '<Integer>'))
                    else
                        exit(Format(lDecimal + Power(10, 10), pLen, '<Integer>'));
                end;

            lField.Type::Date:
                begin
                    lDate := lFieldRef.Value;
                    case SortField[pSortlevel].Periodicity of
                        SortField[pSortlevel].Periodicity::Week:
                            begin
                                lDecimal := Date2DWY(lDate, 2) + Date2DWY(lDate, 3) * 100;
                                if pDescending then begin
                                    lDecimal := -lDecimal;
                                    exit(Format((lDecimal + Power(10, 10)) * 100000, pLen, '<Integer>'));
                                end else
                                    exit(Format(lDecimal, pLen, '<Integer>'));
                            end;
                        SortField[pSortlevel].Periodicity::Month:
                            begin
                                lDecimal := Date2DMY(lDate, 2) + Date2DMY(lDate, 3) * 100;
                                if pDescending then begin
                                    lDecimal := 1000000 - lDecimal;
                                    exit(Format(lDecimal, pLen, '<Integer>'));
                                end else
                                    exit(Format(lDecimal, pLen, '<Integer>'));
                            end;
                        SortField[pSortlevel].Periodicity::Quarter:
                            begin
                                if pDescending then begin
                                    lDate := CalcDate('<-CQ>', lDate);
                                    lDecimal := ((19000101D - lDate) + 8001450000.0) * -1;
                                    exit(Format(lDecimal, pLen, '<Integer>'));
                                end else
                                    exit(Format(lDate, pLen, '<Year4><Quarter>'));
                            end;
                        SortField[pSortlevel].Periodicity::Year:
                            begin
                                lDecimal := Date2DMY(lDate, 3);
                                if pDescending then begin
                                    lDecimal := 10000 - lDecimal;
                                    exit(Format(lDecimal, pLen, '<Integer>'));
                                end else
                                    exit(Format(lDecimal, pLen, '<Integer>'));
                            end;
                        SortField[pSortlevel].Periodicity::"Accounting Period":
                            begin
                                if pDescending then begin
                                    repeat
                                        i += 1
                                    until (lDate < AccountingStartPeriod[i]) or (i = 20) or (AccountingStartPeriod[i] = 0D);
                                    exit(Format(21 - i, pLen, '<Integer>'));
                                end else begin
                                    repeat
                                        i += 1
                                    until (lDate < AccountingStartPeriod[i]) or (i = 20) or (AccountingStartPeriod[i] = 0D);
                                    exit(Format(i - 1, pLen, '<Integer>'));
                                end;
                            end;
                        else begin
                            if pDescending then begin
                                lDecimal := 99991231D - lDate;
                                exit(Format(lDecimal, pLen, '<Integer>'));
                            end else
                                exit(Format(lDate, pLen, '<Year4><Month,2><Day,2>'));
                        end;
                    end;

                end;
            else begin
                if (pLen = 0) and (lField.Type = lField.Type::Option) then begin
                    lOptionNum := lFieldRef.Value;
                    exit(SelectStr(lOptionNum + 1, lFieldRef.OptionCaption))
                end else
                    exit(CopyStr(Format(lFieldRef.Value), 1, pLen));
            end;
        end;
    end;

    [Scope('OnPrem')]
    procedure SortFields(var pSortKey: Record "Sort Key") Return: Text[250]
    var
        lSortField: Record "Sort Field";
        lRecordRef: RecordRef;
        lText: Text[30];
        lTableNo: Integer;
        lTableFieldNo: Integer;
        lFieldRef: FieldRef;
        lSetupFieldNo: Integer;
        lCaption: Text[250];
    begin
        //CLEAR(SortKey);
        if pSortKey.TableNo = 0 then
            exit;
        SortKey.Copy(pSortKey);
        if SortKey.Find then; // Get "Print"
        lRecordRef.Open(pSortKey.TableNo);
        lSortField.SetRange(TableNo, pSortKey.TableNo);
        lSortField.SetRange(SortKey, pSortKey.SortKey);

        if lSortField.Find('-') then
            repeat
                lSortField.CalcFields("Field Caption");
                if Return <> '' then
                    Return := Return + ', ';

                //      lText := FORMAT(lSortField.TableNo) + '.' + FORMAT(lSortField.FieldNo);
                //      CLEAR(FieldSelection);
                //      FieldSelection.InitRequest(lText);
                //      lCaption := COPYSTR(FieldSelection.GetFieldCaption,1,MAXSTRLEN(lCaption));
                with lSortField do
                    //        lCaption := COPYSTR(lFieldList.GetFieldCaption(TableNo,FieldNo,"Field Caption"),1,MAXSTRLEN(lCaption));

                    with lSortField do begin
                        if "Start Position" <> 0 then begin
                            if "Sort Direction" = "Sort Direction"::Descending then
                                Return := Return + lCaption + '[' + Format("Start Position") + ':' + Format(Length) + ',' + Format("Sort Direction", 4) + ']'
                            else
                                Return := Return + lCaption + '[' + Format("Start Position") + ':' + Format(Length) + ']';
                        end;
                        if Periodicity <> 0 then begin
                            if "Sort Direction" = "Sort Direction"::Descending then
                                Return := Return + lCaption + '[' + Format(Periodicity) + ',' + Format("Sort Direction", 4) + ']'
                            else
                                Return := Return + lCaption + '[' + Format(Periodicity) + ']';
                        end
                        else begin
                            if "Sort Direction" = "Sort Direction"::Descending then
                                Return := Return + lCaption + '[' + Format("Sort Direction", 4) + ']'
                            else
                                Return := Return + lCaption;
                        end;
                    end;
            until lSortField.Next = 0;
    end;

    [Scope('OnPrem')]
    procedure OrderBy(var pSortKey: Record "Sort Key") Return: Text[250]
    var
        lSortField: Record "Sort Field";
        lRecordRef: RecordRef;
    begin
        exit(tOrderBy + SortFields(pSortKey));
    end;

    [Scope('OnPrem')]
    procedure Rate(pNumerator: Decimal; pDenominator: Decimal): Decimal
    begin
        if pDenominator <> 0 then
            exit(pNumerator / pDenominator);
    end;

    [Scope('OnPrem')]
    procedure Percentage(pNumerator: Decimal; pDenominator: Decimal): Decimal
    begin
        if pDenominator <> 0 then
            exit(pNumerator / pDenominator * 100);
    end;

    [Scope('OnPrem')]
    procedure GetHeaderFieldCaption(var pCaption: Text[30]; pLevel: Integer): Text[250]
    var
        lText: Text[30];
        lTableNo: Integer;
        lTableFieldNo: Integer;
        lRecordRef: RecordRef;
        lFieldRef: FieldRef;
        lSetupFieldNo: Integer;
    begin
        with SortField[pLevel] do begin
            lText := Format(TableNo) + '.' + Format(FieldNo);
            //FieldSelection.InitRequest(lText);
            //  lText := COPYSTR(FieldSelection.GetFieldCaption,1,MAXSTRLEN(pCaption));
            if "Start Position" <> 0 then
                exit(lText + '[' + Format("Start Position") + ':' + Format(Length) + ']')
            else
                exit(lText);
        end;
    end;

    [Scope('OnPrem')]
    procedure ReportCaption(pObjectID: Text[250]): Text[250]
    begin
        exit(CopyStr(pObjectID, 8)); // Avoid 'Report '
    end;

    [Scope('OnPrem')]
    procedure ReportCaptionPeriod(pObjectID: Text[250]; pDateFilter: Text[250]) Return: Text[250]
    var
        lDate: Record Date;
    begin
        Return := CopyStr(pObjectID, 8); // Avoid 'Report '
        if pDateFilter <> '' then begin
            lDate.SetRange("Period Type", lDate."Period Type"::Date);
            lDate.SetFilter("Period Start", pDateFilter);
            if lDate.GetRangeMin("Period Start") = 0D then
                Return := StrSubstNo(tAtDate, Return, lDate.GetRangeMax("Period Start"))
            else
                Return := StrSubstNo(tPeriod, Return, lDate.GetRangeMin("Period Start"), lDate.GetRangeMax("Period Start"));
        end;
    end;

    [Scope('OnPrem')]
    procedure SetRepCurr(pUseReportingCurrency: Boolean; pDate: Date): Text[80]
    var
        lGLSetup: Record "General Ledger Setup";
        lCurrExchRate: Record "Currency Exchange Rate";
        lCurrencyText: Text[80];
    begin
        lGLSetup.Get;
        RepCurrFactor := 1;
        if pUseReportingCurrency then begin
            lCurrencyText := StrSubstNo(tRepCurr, lGLSetup."Additional Reporting Currency");
            if pDate = 0D then
                RepCurrFactor := lCurrExchRate.ExchangeRate(WorkDate, lGLSetup."Additional Reporting Currency")
            else
                RepCurrFactor := lCurrExchRate.ExchangeRate(pDate, lGLSetup."Additional Reporting Currency");
        end else
            if lGLSetup."LCY Code" <> '' then
                lCurrencyText := StrSubstNo(tRepCurr, lGLSetup."LCY Code")
            else
                lCurrencyText := '';
        exit(lCurrencyText);
    end;

    [Scope('OnPrem')]
    procedure ToRepCurr(pAmount: Decimal): Decimal
    begin
        if RepCurrFactor = 0 then
            exit(pAmount)
        else
            exit(pAmount * RepCurrFactor);
    end;
}

