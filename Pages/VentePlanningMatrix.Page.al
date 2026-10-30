page 50080 "Vente Planning Matrix"
{
    Caption = 'Production Forecast Matrix';
    DataCaptionExpression = "Production Forecast Name";
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; "No.")
                {
                    Style = Unfavorable;
                    StyleExpr = PrevisionOKItem;
                }
                field(Description; Description)
                {
                }
                field(Field1; MATRIX_CellData[1])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[1];

                    Style = Unfavorable;
                    StyleExpr = PrevisionOK1;
                    Visible = Field1Visible;
                    Width = 15;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(1);
                    end;
                }
                field(Field2; MATRIX_CellData[2])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[2];

                    Style = Unfavorable;
                    StyleExpr = PrevisionOK2;
                    Visible = Field2Visible;
                    Width = 15;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(2);
                    end;
                }
                field(Field3; MATRIX_CellData[3])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[3];

                    Style = Unfavorable;
                    StyleExpr = PrevisionOK3;
                    Visible = Field3Visible;
                    Width = 15;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(3);
                    end;
                }
                field(Field4; MATRIX_CellData[4])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[4];

                    Style = Unfavorable;
                    StyleExpr = PrevisionOK4;
                    Visible = Field4Visible;
                    Width = 15;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(4);
                    end;
                }
                field(Field5; MATRIX_CellData[5])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[5];

                    Style = Unfavorable;
                    StyleExpr = PrevisionOK5;
                    Visible = Field5Visible;
                    Width = 15;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(5);
                    end;
                }
                field(Field6; MATRIX_CellData[6])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[6];

                    Style = Unfavorable;
                    StyleExpr = PrevisionOK6;
                    Visible = Field6Visible;
                    Width = 15;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(6);
                    end;
                }
                field(Field7; MATRIX_CellData[7])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[7];

                    Style = Unfavorable;
                    StyleExpr = PrevisionOK7;
                    Visible = Field7Visible;
                    Width = 15;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(7);
                    end;
                }
                field(Field8; MATRIX_CellData[8])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[8];

                    Style = Unfavorable;
                    StyleExpr = PrevisionOK8;
                    Visible = Field8Visible;
                    Width = 15;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(8);
                    end;
                }
                field(Field9; MATRIX_CellData[9])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[9];

                    Style = Unfavorable;
                    StyleExpr = PrevisionOK9;
                    Visible = Field9Visible;
                    Width = 15;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(9);
                    end;
                }
                field(Field10; MATRIX_CellData[10])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[10];

                    Style = Unfavorable;
                    StyleExpr = PrevisionOK10;
                    Visible = Field10Visible;
                    Width = 15;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(10);
                    end;
                }
                field(Field11; MATRIX_CellData[11])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[11];

                    Style = Unfavorable;
                    StyleExpr = PrevisionOK11;
                    Visible = Field11Visible;
                    Width = 15;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(11);
                    end;
                }
                field(Field12; MATRIX_CellData[12])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[12];

                    Style = Unfavorable;
                    StyleExpr = PrevisionOK12;
                    Visible = Field12Visible;
                    Width = 15;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(12);
                    end;
                }
                field(Field13; MATRIX_CellData[13])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[13];

                    Style = Unfavorable;
                    StyleExpr = PrevisionOK13;
                    Visible = Field13Visible;
                    Width = 15;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(13);
                    end;
                }
                field(Field14; MATRIX_CellData[14])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[14];

                    Style = Unfavorable;
                    StyleExpr = PrevisionOK14;
                    Visible = Field14Visible;
                    Width = 15;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(14);
                    end;
                }
                field(Field15; MATRIX_CellData[15])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[15];

                    Style = Unfavorable;
                    StyleExpr = PrevisionOK15;
                    Visible = Field15Visible;
                    Width = 15;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(15);
                    end;
                }
                field(Field16; MATRIX_CellData[16])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[16];

                    Style = Unfavorable;
                    StyleExpr = PrevisionOK16;
                    Visible = Field16Visible;
                    Width = 15;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(16);
                    end;
                }
                field(Field17; MATRIX_CellData[17])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[17];

                    Style = Unfavorable;
                    StyleExpr = PrevisionOK17;
                    Visible = Field17Visible;
                    Width = 15;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(17);
                    end;
                }
                field(Field18; MATRIX_CellData[18])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[18];

                    Style = Unfavorable;
                    StyleExpr = PrevisionOK18;
                    Visible = Field18Visible;
                    Width = 15;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(18);
                    end;
                }
                field(Field19; MATRIX_CellData[19])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[19];

                    Style = Unfavorable;
                    StyleExpr = PrevisionOK19;
                    Visible = Field19Visible;
                    Width = 15;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(19);
                    end;
                }
                field(Field20; MATRIX_CellData[20])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[20];

                    Style = Unfavorable;
                    StyleExpr = PrevisionOK20;
                    Visible = Field20Visible;
                    Width = 15;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(20);
                    end;
                }
                field(Field21; MATRIX_CellData[21])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[21];

                    Style = Unfavorable;
                    StyleExpr = PrevisionOK21;
                    Visible = Field21Visible;
                    Width = 15;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(21);
                    end;
                }
                field(Field22; MATRIX_CellData[22])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[22];

                    Style = Unfavorable;
                    StyleExpr = PrevisionOK22;
                    Visible = Field22Visible;
                    Width = 15;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(22);
                    end;
                }
                field(Field23; MATRIX_CellData[23])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[23];

                    Style = Unfavorable;
                    StyleExpr = PrevisionOK23;
                    Visible = Field23Visible;
                    Width = 15;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(23);
                    end;
                }
                field(Field24; MATRIX_CellData[24])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[24];

                    Style = Unfavorable;
                    StyleExpr = PrevisionOK24;
                    Visible = Field24Visible;
                    Width = 15;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(24);
                    end;
                }
                field(Field25; MATRIX_CellData[25])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[25];

                    Style = Unfavorable;
                    StyleExpr = PrevisionOK25;
                    Visible = Field25Visible;
                    Width = 15;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(25);
                    end;
                }
                field(Field26; MATRIX_CellData[26])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[26];

                    Style = Unfavorable;
                    StyleExpr = PrevisionOK26;
                    Visible = Field26Visible;
                    Width = 15;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(26);
                    end;
                }
                field(Field27; MATRIX_CellData[27])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[27];

                    Style = Unfavorable;
                    StyleExpr = PrevisionOK27;
                    Visible = Field27Visible;
                    Width = 15;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(27);
                    end;
                }
                field(Field28; MATRIX_CellData[28])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[28];

                    Style = Unfavorable;
                    StyleExpr = PrevisionOK28;
                    Visible = Field28Visible;
                    Width = 15;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(28);
                    end;
                }
                field(Field29; MATRIX_CellData[29])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[29];

                    Style = Unfavorable;
                    StyleExpr = PrevisionOK29;
                    Visible = Field29Visible;
                    Width = 15;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(29);
                    end;
                }
                field(Field30; MATRIX_CellData[30])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[30];

                    Style = Unfavorable;
                    StyleExpr = PrevisionOK30;
                    Visible = Field30Visible;
                    Width = 15;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(30);
                    end;
                }
                field(Field31; MATRIX_CellData[31])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[31];

                    Style = Unfavorable;
                    StyleExpr = PrevisionOK31;
                    Visible = Field31Visible;
                    Width = 15;

                    trigger OnDrillDown()
                    begin
                        MatrixOnDrillDown(31);
                    end;
                }
                field(Field32; MATRIX_CellData[32])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[32];

                    Style = Unfavorable;
                    StyleExpr = PrevisionOK32;
                    Visible = Field32Visible;
                    Width = 15;

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
        i: Integer;
    begin

        MATRIX_CurrentColumnOrdinal := 0;
        while MATRIX_CurrentColumnOrdinal < MATRIX_NoOfMatrixColumns do begin
            MATRIX_CurrentColumnOrdinal := MATRIX_CurrentColumnOrdinal + 1;
            MATRIX_OnAfterGetRecord(MATRIX_CurrentColumnOrdinal);
        end;

        PrevisionOK1 := PrevisionsOK[1];
        PrevisionOK2 := PrevisionsOK[2];
        PrevisionOK3 := PrevisionsOK[3];
        PrevisionOK4 := PrevisionsOK[4];
        PrevisionOK5 := PrevisionsOK[5];
        PrevisionOK6 := PrevisionsOK[6];
        PrevisionOK7 := PrevisionsOK[7];
        PrevisionOK8 := PrevisionsOK[8];
        PrevisionOK9 := PrevisionsOK[9];
        PrevisionOK10 := PrevisionsOK[10];
        PrevisionOK11 := PrevisionsOK[11];
        PrevisionOK12 := PrevisionsOK[12];
        PrevisionOK13 := PrevisionsOK[13];
        PrevisionOK14 := PrevisionsOK[14];
        PrevisionOK15 := PrevisionsOK[15];
        PrevisionOK16 := PrevisionsOK[16];
        PrevisionOK17 := PrevisionsOK[17];
        PrevisionOK18 := PrevisionsOK[18];
        PrevisionOK19 := PrevisionsOK[19];
        PrevisionOK20 := PrevisionsOK[20];
        PrevisionOK21 := PrevisionsOK[21];
        PrevisionOK22 := PrevisionsOK[22];
        PrevisionOK23 := PrevisionsOK[23];
        PrevisionOK24 := PrevisionsOK[24];
        PrevisionOK25 := PrevisionsOK[25];
        PrevisionOK26 := PrevisionsOK[26];
        PrevisionOK27 := PrevisionsOK[27];
        PrevisionOK28 := PrevisionsOK[28];
        PrevisionOK29 := PrevisionsOK[29];
        PrevisionOK30 := PrevisionsOK[30];
        PrevisionOK31 := PrevisionsOK[31];
        PrevisionOK32 := PrevisionsOK[32];

        PrevisionOKItem := false;
        for i := 1 to ArrayLen(MatrixRecords) do begin
            if PrevisionsOK[i] then PrevisionOKItem := true;
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

        Rec.SetFilter("Qty. on Sales Order", '>0');
        Rec.SetRange("Item Category Code", CategoryFilter);
    end;

    var
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        QtyType: Option "Net Change","Balance at Date";
        ForecastType: Option "Sales Item",Component,Both;
        MatrixRecords: array[32] of Record Date;
        MATRIX_NoOfMatrixColumns: Integer;
        MATRIX_CellData: array[32] of Text[150];
        MATRIX_CaptionSet: array[32] of Text[1024];
        ProductionForecastName: Code[10];
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
        Besoin: Decimal;
        VentesConsommees: Decimal;
        Stock: Decimal;
        Commande: Decimal;
        Produit: Decimal;
        Minimum: Decimal;
        Total: Decimal;

        PrevisionOK: Boolean;
        Msg: Text[250];
        PrevisionsOK: array[33] of Boolean;

        PrevisionOK1: Boolean;

        PrevisionOK2: Boolean;

        PrevisionOK3: Boolean;

        PrevisionOK4: Boolean;

        PrevisionOK5: Boolean;

        PrevisionOK6: Boolean;

        PrevisionOK7: Boolean;

        PrevisionOK8: Boolean;

        PrevisionOK9: Boolean;

        PrevisionOK10: Boolean;

        PrevisionOK11: Boolean;

        PrevisionOK12: Boolean;

        PrevisionOK13: Boolean;

        PrevisionOK14: Boolean;

        PrevisionOK15: Boolean;

        PrevisionOK16: Boolean;

        PrevisionOK17: Boolean;

        PrevisionOK18: Boolean;

        PrevisionOK19: Boolean;

        PrevisionOK20: Boolean;

        PrevisionOK21: Boolean;

        PrevisionOK22: Boolean;

        PrevisionOK23: Boolean;

        PrevisionOK24: Boolean;

        PrevisionOK25: Boolean;

        PrevisionOK26: Boolean;

        PrevisionOK27: Boolean;

        PrevisionOK28: Boolean;

        PrevisionOK29: Boolean;

        PrevisionOK30: Boolean;

        PrevisionOK31: Boolean;

        PrevisionOK32: Boolean;

        PrevisionOKItem: Boolean;
        CategoryFilter: Code[20];

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
    procedure SetCategory(Category: Code[20])
    begin
        CategoryFilter := Category;
    end;

    [Scope('OnPrem')]
    procedure Load(var MatrixColumns1: array[32] of Text[1024]; var MatrixRecords1: array[32] of Record Date; ProductionForecastName1: Code[10]; DateFilter1: Text[30]; LocationFilter1: Code[10]; ForecastType1: Option "Sales Item",Component,Both; QtyType1: Option "Net Change","Balance at Date"; NoOfMatrixColumns1: Integer)
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



        DateFilter := DateFilter1;
        MATRIX_NoOfMatrixColumns := NoOfMatrixColumns1;

        SetVisible;

        Rec.SetRange("Date Filter", MatrixRecords[1]."Period Start", MatrixRecords[32]."Period End");
        Rec.SetRange("Item Category Code", CategoryFilter);
    end;

    local procedure MatrixOnDrillDown(ColumnID: Integer)
    var
        ProductionForecastEntry: Record "Production Forecast Entry";
        PDetail: Page "Vente Planning Detail";
    begin
        PDetail.setDate(MatrixRecords[ColumnID]."Period Start", MatrixRecords[ColumnID]."Period End");
        PDetail.SetRecord(Rec);
        PDetail.RunModal();
    end;

    local procedure MATRIX_OnAfterGetRecord(ColumnOrdinal: Integer)
    begin

        //CRLF[1] := 13;


        Besoin := 0;
        VentesConsommees := 0;
        Stock := 0;
        Commande := 0;
        Produit := 0;
        Minimum := 0;
        Total := 0;
        GetPrevision("No.", MatrixRecords[ColumnOrdinal]."Period Start", MatrixRecords[ColumnOrdinal]."Period End", ColumnOrdinal);

        MATRIX_CellData[ColumnOrdinal] := '' + Format(Besoin) + ' (' + Format(Total) + ')';
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
    procedure GetPrevision(ItemNo: Code[20]; PeriodStart: Date; PeriodEnd: Date; Colonne: Integer)
    var
        recProdLine: Record "Prod. Order Component";
        recItem: Record Item;
        recOrderLine: Record "Purchase Line";
        calcPlanning: Codeunit "Stock EC";
    begin

        recItem.Get(ItemNo);

        Stock := calcPlanning.getPlanningStock(recItem, PeriodStart, PeriodEnd, false);
        Besoin := calcPlanning.getPlanningVentes(recItem, PeriodStart, PeriodEnd, false);
        VentesConsommees := calcPlanning.getPlanningVentesConsommees(recItem, PeriodStart, PeriodEnd, false);
        Commande := calcPlanning.getPlanningCommandesAchats(recItem, PeriodStart, PeriodEnd, false);
        Produit := calcPlanning.getPlanningProduction(recItem, PeriodStart, PeriodEnd, false);
        //Minimum := calcPlanning.getPlanningPrev(recItem);
        Total := Stock + Commande + Produit - VentesConsommees - Minimum;
        //PrevisionOK := (Besoin > Total);
        PrevisionOK := Total <= 0;
        PrevisionsOK[Colonne] := PrevisionOK;
    end;

    [Scope('OnPrem')]
    procedure Refresh()
    begin
        CurrPage.Update;
    end;
}

