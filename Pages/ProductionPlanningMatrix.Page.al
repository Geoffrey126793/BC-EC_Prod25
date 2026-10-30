page 50092 "Production Planning Matrix"
{
    Caption = 'Production Forecast Matrix';
    DataCaptionExpression = "Production Forecast Name";
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = Item;
    SourceTableView = WHERE(Blocked = CONST(false));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field(Field1; MATRIX_CellData[1])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[1];
                    Style = Unfavorable;
                    StyleExpr = PrevisionOK;
                    Visible = Field1Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(1);
                    end;
                }
                field(Field2; MATRIX_CellData[2])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[2];
                    Style = Unfavorable;
                    StyleExpr = PrevisionOK;
                    Visible = Field2Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(2);
                    end;
                }
                field(Field3; MATRIX_CellData[3])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[3];
                    Style = Unfavorable;
                    StyleExpr = PrevisionOK;
                    Visible = Field3Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(3);
                    end;
                }
                field(Field4; MATRIX_CellData[4])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[4];
                    Style = Unfavorable;
                    StyleExpr = PrevisionOK;
                    Visible = Field4Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(4);
                    end;
                }
                field(Field5; MATRIX_CellData[5])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[5];
                    Style = Unfavorable;
                    StyleExpr = PrevisionOK;
                    Visible = Field5Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(5);
                    end;
                }
                field(Field6; MATRIX_CellData[6])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[6];
                    Style = Unfavorable;
                    StyleExpr = PrevisionOK;
                    Visible = Field6Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(6);
                    end;
                }
                field(Field7; MATRIX_CellData[7])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[7];
                    Style = Unfavorable;
                    StyleExpr = PrevisionOK;
                    Visible = Field7Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(7);
                    end;
                }
                field(Field8; MATRIX_CellData[8])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[8];
                    Style = Unfavorable;
                    StyleExpr = PrevisionOK;
                    Visible = Field8Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(8);
                    end;
                }
                field(Field9; MATRIX_CellData[9])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[9];
                    Style = Unfavorable;
                    StyleExpr = PrevisionOK;
                    Visible = Field9Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(9);
                    end;
                }
                field(Field10; MATRIX_CellData[10])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[10];
                    Style = Unfavorable;
                    StyleExpr = PrevisionOK;
                    Visible = Field10Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(10);
                    end;
                }
                field(Field11; MATRIX_CellData[11])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[11];
                    Style = Unfavorable;
                    StyleExpr = PrevisionOK;
                    Visible = Field11Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(11);
                    end;
                }
                field(Field12; MATRIX_CellData[12])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[12];
                    Style = Unfavorable;
                    StyleExpr = PrevisionOK;
                    Visible = Field12Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(12);
                    end;
                }
                field(Field13; MATRIX_CellData[13])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[13];
                    Style = Unfavorable;
                    StyleExpr = PrevisionOK;
                    Visible = Field13Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(13);
                    end;
                }
                field(Field14; MATRIX_CellData[14])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[14];
                    Style = Unfavorable;
                    StyleExpr = PrevisionOK;
                    Visible = Field14Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(14);
                    end;
                }
                field(Field15; MATRIX_CellData[15])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[15];
                    Style = Unfavorable;
                    StyleExpr = PrevisionOK;
                    Visible = Field15Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(15);
                    end;
                }
                field(Field16; MATRIX_CellData[16])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[16];
                    Style = Unfavorable;
                    StyleExpr = PrevisionOK;
                    Visible = Field16Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(16);
                    end;
                }
                field(Field17; MATRIX_CellData[17])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[17];
                    Style = Unfavorable;
                    StyleExpr = PrevisionOK;
                    Visible = Field17Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(17);
                    end;
                }
                field(Field18; MATRIX_CellData[18])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[18];
                    Style = Unfavorable;
                    StyleExpr = PrevisionOK;
                    Visible = Field18Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(18);
                    end;
                }
                field(Field19; MATRIX_CellData[19])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[19];
                    Style = Unfavorable;
                    StyleExpr = PrevisionOK;
                    Visible = Field19Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(19);
                    end;
                }
                field(Field20; MATRIX_CellData[20])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[20];
                    Style = Unfavorable;
                    StyleExpr = PrevisionOK;
                    Visible = Field20Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(20);
                    end;
                }
                field(Field21; MATRIX_CellData[21])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[21];
                    Style = Unfavorable;
                    StyleExpr = PrevisionOK;
                    Visible = Field21Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(21);
                    end;
                }
                field(Field22; MATRIX_CellData[22])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[22];
                    Style = Unfavorable;
                    StyleExpr = PrevisionOK;
                    Visible = Field22Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(22);
                    end;
                }
                field(Field23; MATRIX_CellData[23])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[23];
                    Style = Unfavorable;
                    StyleExpr = PrevisionOK;
                    Visible = Field23Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(23);
                    end;
                }
                field(Field24; MATRIX_CellData[24])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[24];
                    Style = Unfavorable;
                    StyleExpr = PrevisionOK;
                    Visible = Field24Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(24);
                    end;
                }
                field(Field25; MATRIX_CellData[25])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[25];
                    Style = Unfavorable;
                    StyleExpr = PrevisionOK;
                    Visible = Field25Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(25);
                    end;
                }
                field(Field26; MATRIX_CellData[26])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[26];
                    Style = Unfavorable;
                    StyleExpr = PrevisionOK;
                    Visible = Field26Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(26);
                    end;
                }
                field(Field27; MATRIX_CellData[27])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[27];
                    Style = Unfavorable;
                    StyleExpr = PrevisionOK;
                    Visible = Field27Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(27);
                    end;
                }
                field(Field28; MATRIX_CellData[28])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[28];
                    Style = Unfavorable;
                    StyleExpr = PrevisionOK;
                    Visible = Field28Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(28);
                    end;
                }
                field(Field29; MATRIX_CellData[29])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[29];
                    Style = Unfavorable;
                    StyleExpr = PrevisionOK;
                    Visible = Field29Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(29);
                    end;
                }
                field(Field30; MATRIX_CellData[30])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[30];
                    Style = Unfavorable;
                    StyleExpr = PrevisionOK;
                    Visible = Field30Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(30);
                    end;
                }
                field(Field31; MATRIX_CellData[31])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[31];
                    Style = Unfavorable;
                    StyleExpr = PrevisionOK;
                    Visible = Field31Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(31);
                    end;
                }
                field(Field32; MATRIX_CellData[32])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[32];
                    Style = Unfavorable;
                    StyleExpr = PrevisionOK;
                    Visible = Field32Visible;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(32);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        MATRIX_CurrentColumnOrdinal: Integer;
        MATRIX_Steps: Integer;
    begin
        MATRIX_CurrentColumnOrdinal := 0;
        while MATRIX_CurrentColumnOrdinal < MATRIX_NoOfMatrixColumns do begin
            MATRIX_CurrentColumnOrdinal := MATRIX_CurrentColumnOrdinal + 1;
            MATRIX_OnAfterGetRecord(MATRIX_CurrentColumnOrdinal);
        end;
    end;

    trigger OnInit()
    begin
        Field32Visible := true;
        Field31Visible := true;
        Field30Visible := true;
        Field29Visible := true;
        Field28Visible := true;
        Field27Visible := true;
        Field26Visible := true;
        Field25Visible := true;
        Field24Visible := true;
        Field23Visible := true;
        Field22Visible := true;
        Field21Visible := true;
        Field20Visible := true;
        Field19Visible := true;
        Field18Visible := true;
        Field17Visible := true;
        Field16Visible := true;
        Field15Visible := true;
        Field14Visible := true;
        Field13Visible := true;
        Field12Visible := true;
        Field11Visible := true;
        Field10Visible := true;
        Field9Visible := true;
        Field8Visible := true;
        Field7Visible := true;
        Field6Visible := true;
        Field5Visible := true;
        Field4Visible := true;
        Field3Visible := true;
        Field2Visible := true;
        Field1Visible := true;
    end;

    trigger OnOpenPage()
    var
        recProdLine: Record "Prod. Order Component";
    begin


        Rec.SetFilter("No.", ItemNoFilter);
        //MARKEDONLY(TRUE);
    end;

    var

        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        QtyType: Option "Net Change","Balance at Date";
        ForecastType: Option "Sales Item",Component,Both;
        MatrixRecords: array[32] of Record Date;
        MATRIX_NoOfMatrixColumns: Integer;
        MATRIX_CellData: array[32] of Text[150];
        MATRIX_CaptionSet: array[32] of Text[1024];
        ProductionForecastName: Code[20];
        LocationFilter: Code[10];
        DateFilter: Text[30];
        Text000: Label 'The Forecast On field must be Sales Items or Component.';
        Text001: Label 'A forecast was previously made on the %1. Do you want all forecasts of the period %2-%3 moved to the start of the period?';
        Text003: Label 'You must set a location filter.';
        Text004: Label 'You must change view to Sales Items or Component.';

        Field1Visible: Boolean;

        Field2Visible: Boolean;

        Field3Visible: Boolean;

        Field4Visible: Boolean;

        Field5Visible: Boolean;

        Field6Visible: Boolean;

        Field7Visible: Boolean;

        Field8Visible: Boolean;

        Field9Visible: Boolean;

        Field10Visible: Boolean;

        Field11Visible: Boolean;

        Field12Visible: Boolean;

        Field13Visible: Boolean;

        Field14Visible: Boolean;

        Field15Visible: Boolean;

        Field16Visible: Boolean;

        Field17Visible: Boolean;

        Field18Visible: Boolean;

        Field19Visible: Boolean;

        Field20Visible: Boolean;

        Field21Visible: Boolean;

        Field22Visible: Boolean;

        Field23Visible: Boolean;

        Field24Visible: Boolean;

        Field25Visible: Boolean;

        Field26Visible: Boolean;

        Field27Visible: Boolean;

        Field28Visible: Boolean;

        Field29Visible: Boolean;

        Field30Visible: Boolean;

        Field31Visible: Boolean;

        Field32Visible: Boolean;
        CRLF: Text[2];
        Besoin: Decimal;
        Stock: Decimal;
        StockConsomme: Decimal;
        Produit: Decimal;
        Bloque: Decimal;
        Total: Decimal;

        PrevisionOK: Boolean;
        Msg: Text[250];
        LotInfo: Record "Lot No. Information";
        ItemNoFilter: Code[20];

    local procedure SetDateFilter(ColumnID: Integer)
    begin
        if DateFilter <> '' then
            MatrixRecords[ColumnID].SetFilter("Period Start", DateFilter)
        else
            MatrixRecords[ColumnID].SetRange("Period Start");

        if QtyType = QtyType::"Net Change" then
            if MatrixRecords[ColumnID]."Period Start" = MatrixRecords[ColumnID]."Period End" then
                SetRange("Date Filter", MatrixRecords[ColumnID]."Period Start")
            else
                SetRange("Date Filter", MatrixRecords[ColumnID]."Period Start", MatrixRecords[ColumnID]."Period End")
        else
            SetRange("Date Filter", 0D, MatrixRecords[ColumnID]."Period End");
    end;

    [Scope('OnPrem')]
    procedure Load(var MatrixColumns1: array[32] of Text[1024]; var MatrixRecords1: array[32] of Record Date; ItemNo: Code[20]; DateFilter1: Text[30]; LocationFilter1: Code[10]; ForecastType1: Option "Sales Item",Component,Both; QtyType1: Option "Net Change","Balance at Date"; NoOfMatrixColumns1: Integer)
    var
        recProdLine: Record "Prod. Order Component";
        i: Integer;
        recItem: Record Item;
    begin
        CopyArray(MATRIX_CaptionSet, MatrixColumns1, 1);
        for i := 1 to ArrayLen(MatrixRecords) do begin
            if MatrixColumns1[i] = '' then
                MATRIX_CaptionSet[i] := ' '
            else
                MATRIX_CaptionSet[i] := MatrixColumns1[i];
            MatrixRecords[i] := MatrixRecords1[i];
        end;

        ProductionForecastName := ItemNo;
        DateFilter := DateFilter1;
        LocationFilter := LocationFilter1;
        ForecastType := ForecastType1;
        QtyType := QtyType1;
        MATRIX_NoOfMatrixColumns := NoOfMatrixColumns1;

        SetVisible;
        if ItemNo = '' then
            //ItemNoFilter := '5-FAT*|5-FSV*|5-FRS*'
            ItemNoFilter := '7*'
        else
            ItemNoFilter := ItemNo;

        Rec.SetFilter("No.", ItemNoFilter);

        if Rec.FindSet then
            repeat
                recItem.Get("No.");
                recItem.SetRange("Date Filter", MatrixRecords[1]."Period Start", MatrixRecords[32]."Period End");
                recItem.CalcFields("Qty. on Component Lines");
                Rec.Mark := (recItem."Qty. on Component Lines" > 0);
            /*
              recProdLine.RESET;
              recProdLine.SETFILTER(Status,'<>%1',recProdLine.Status::Finished);
              recProdLine.SETRANGE("Item No.",Rec."No.");
              recProdLine.SETRANGE("Due Date",MatrixRecords[1]."Period Start",MatrixRecords[32]."Period End");
              Rec.MARK := recProdLine.FINDFIRST;
              */
            until Rec.Next = 0;

    end;

    local procedure MatrixOnDrillDown(ColumnID: Integer)
    var
        ProductionForecastEntry: Record "Production Forecast Entry";
    begin
        GetPrevision("No.", MatrixRecords[ColumnID]."Period Start", MatrixRecords[ColumnID]."Period End");

        Msg := 'Besoin : ' + Format(Besoin) + '\' + '\';
        Msg += 'Stock Initial : ' + Format(Stock) + '\';
        Msg += 'Bloque : ' + Format(Bloque) + '\';
        Msg += 'Stock consommé : ' + Format(StockConsomme) + '\';
        Msg += 'Production : ' + Format(Produit) + '\';
        Msg += 'TOTAL stock théorique: ' + Format(Total);
        Message(Msg);
    end;

    local procedure MATRIX_OnAfterGetRecord(ColumnOrdinal: Integer)
    begin

        CRLF[1] := 13;


        Besoin := 0;
        Stock := 0;
        StockConsomme := 0;
        Bloque := 0;
        Produit := 0;
        Total := 0;
        GetPrevision("No.", MatrixRecords[ColumnOrdinal]."Period Start", MatrixRecords[ColumnOrdinal]."Period End");

        MATRIX_CellData[ColumnOrdinal] := '' + Format(Besoin) + ' / ' + Format(Produit) + ' (' + Format(Total) + ')';
    end;

    [Scope('OnPrem')]
    procedure SetVisible()
    begin
        Field1Visible := MATRIX_CaptionSet[1] <> '';
        Field2Visible := MATRIX_CaptionSet[2] <> '';
        Field3Visible := MATRIX_CaptionSet[3] <> '';
        Field4Visible := MATRIX_CaptionSet[4] <> '';
        Field5Visible := MATRIX_CaptionSet[5] <> '';
        Field6Visible := MATRIX_CaptionSet[6] <> '';
        Field7Visible := MATRIX_CaptionSet[7] <> '';
        Field8Visible := MATRIX_CaptionSet[8] <> '';
        Field9Visible := MATRIX_CaptionSet[9] <> '';
        Field10Visible := MATRIX_CaptionSet[10] <> '';
        Field11Visible := MATRIX_CaptionSet[11] <> '';
        Field12Visible := MATRIX_CaptionSet[12] <> '';
        Field13Visible := MATRIX_CaptionSet[13] <> '';
        Field14Visible := MATRIX_CaptionSet[14] <> '';
        Field15Visible := MATRIX_CaptionSet[15] <> '';
        Field16Visible := MATRIX_CaptionSet[16] <> '';
        Field17Visible := MATRIX_CaptionSet[17] <> '';
        Field18Visible := MATRIX_CaptionSet[18] <> '';
        Field19Visible := MATRIX_CaptionSet[19] <> '';
        Field20Visible := MATRIX_CaptionSet[20] <> '';
        Field21Visible := MATRIX_CaptionSet[21] <> '';
        Field22Visible := MATRIX_CaptionSet[22] <> '';
        Field23Visible := MATRIX_CaptionSet[23] <> '';
        Field24Visible := MATRIX_CaptionSet[24] <> '';
        Field25Visible := MATRIX_CaptionSet[25] <> '';
        Field26Visible := MATRIX_CaptionSet[26] <> '';
        Field27Visible := MATRIX_CaptionSet[27] <> '';
        Field28Visible := MATRIX_CaptionSet[28] <> '';
        Field29Visible := MATRIX_CaptionSet[29] <> '';
        Field30Visible := MATRIX_CaptionSet[30] <> '';
        Field31Visible := MATRIX_CaptionSet[31] <> '';
        Field32Visible := MATRIX_CaptionSet[32] <> '';
    end;

    [Scope('OnPrem')]
    procedure GetPrevision(ItemNo: Code[20]; PeriodStart: Date; PeriodEnd: Date)
    var
        recProdLine: Record "Prod. Order Component";
        recItem: Record Item;
        recOrderLine: Record "Purchase Line";
        SalesL: Record "Sales Line";
    begin
        PrevisionOK := true;

        recItem.Get(ItemNo);
        recItem.CalcFields(Inventory);
        Stock := recItem.Inventory;

        LotInfo.Reset;
        LotInfo.SetRange("Item No.", ItemNo);
        LotInfo.SetRange(Blocked, true);
        if LotInfo.FindSet then
            repeat
                LotInfo.CalcFields(Inventory);
                Bloque += LotInfo.Inventory;
            until LotInfo.Next = 0;

        recItem.SetRange("Date Filter", PeriodStart, PeriodEnd);
        recItem.CalcFields("Qty. on Component Lines");
        Besoin := recItem."Qty. on Component Lines";
        if (StrPos(ItemNo, '5-F') > 0) and (StrPos(ItemNo, '5-FRS') <= 0) then begin
            Besoin := 0;
            SalesL.Reset;
            SalesL.SetRange(Intermediaire5, ItemNo);
            SalesL.SetRange("Requested Delivery Date", PeriodStart, PeriodEnd);
            SalesL.SetRange("Promised Delivery Date", 0D);
            if SalesL.FindSet then
                repeat
                    Besoin := Besoin + SalesL."Qty. to Ship (Base)";
                until SalesL.Next = 0;
            SalesL.Reset;
            SalesL.SetRange(Intermediaire5, ItemNo);
            SalesL.SetRange("Promised Delivery Date", PeriodStart, PeriodEnd);
            if SalesL.FindSet then
                repeat
                    Besoin := Besoin + SalesL."Qty. to Ship (Base)";
                until SalesL.Next = 0;

        end;

        recItem.SetRange("Date Filter", Today, CalcDate('<-1D>', PeriodStart));
        recItem.CalcFields("Qty. on Component Lines");
        StockConsomme := recItem."Qty. on Component Lines";
        if (StrPos(ItemNo, '5-F') > 0) and (StrPos(ItemNo, '5-FRS') <= 0) then begin
            StockConsomme := 0;
            SalesL.Reset;
            SalesL.SetRange(Intermediaire5, ItemNo);
            SalesL.SetRange("Requested Delivery Date", Today, CalcDate('<-1D>', PeriodStart));
            SalesL.SetRange("Promised Delivery Date", 0D);
            if SalesL.FindSet then
                repeat
                    StockConsomme := StockConsomme + SalesL."Qty. to Ship (Base)";
                until SalesL.Next = 0;
            SalesL.Reset;
            SalesL.SetRange(Intermediaire5, ItemNo);
            SalesL.SetRange("Promised Delivery Date", Today, CalcDate('<-1D>', PeriodStart));
            if SalesL.FindSet then
                repeat
                    StockConsomme := StockConsomme + SalesL."Qty. to Ship (Base)";
                until SalesL.Next = 0;

        end;

        if StrPos(ItemNo, '5-FSV') > 0 then
            recItem.SetRange("Date Filter", CalcDate('<-32D>', PeriodStart), CalcDate('<-1D>', PeriodEnd))
        else
            recItem.SetRange("Date Filter", CalcDate('<-32D>', PeriodStart), PeriodEnd);
        recItem.CalcFields("Qty. on Prod. Order");
        Produit := recItem."Qty. on Prod. Order";


        Total := Stock - Bloque + Produit - StockConsomme;
        PrevisionOK := (Besoin > Total);
    end;
}

