page 50046 "Prévisions ventes"
{
    Caption = 'Sales Forecast';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPlus;
    PromotedActionCategories = 'New,Process,Report,Function';
    SourceTable = "Statistic array line";
    SourceTableTemporary = true;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field(FilterCustomer; FilterCustomer)
            {
                Caption = 'Customer filter';
                TableRelation = Customer;
                ToolTip = 'Filtre client';

                trigger OnValidate()
                begin
                    if FilterCustomer <> '' then ShowByItem := false;
                    RefreshTemp();
                    //CurrPage.UPDATE;
                end;
            }
            field(FilterItem; FilterItem)
            {
                Caption = 'Item filter';
                TableRelation = Item;

                trigger OnValidate()
                begin
                    RefreshTemp();
                    //CurrPage.UPDATE;
                end;
            }
            field(FilterVendeur; FilterVendeur)
            {
                Caption = 'Sales filter';
                TableRelation = "Salesperson/Purchaser";
                Visible = ShowFilterVendeur;

                trigger OnValidate()
                begin
                    if FilterVendeur <> '' then ShowByItem := false;
                    RefreshTemp();
                    //CurrPage.UPDATE;
                end;
            }
            field(OnlyConfirmed; OnlyConfirmed)
            {
                Caption = 'Uniquement confirmé';

                trigger OnValidate()
                begin
                    RefreshTemp();
                end;
            }
            repeater(Control1100287002)
            {
                Enabled = true;
                FreezeColumn = "Désignation";
                IndentationColumn = Indentation;
                IndentationControls = Description;
                ShowCaption = false;
                Visible = true;
                field(Description; Description)
                {
                    Caption = 'Client';
                }
                field("Code"; Code)
                {
                }
                field("Désignation"; Désignation)
                {
                }
                field(Field1; MATRIX_CellData[1])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[1];
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnAssistEdit()
                    begin
                        //wAssistEdit(1);
                    end;

                    trigger OnValidate()
                    begin
                        MATRIX_ONVALIDATE(1);
                    end;
                }
                field(Field2; MATRIX_CellData[2])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[2];
                    DecimalPlaces = 0 : 5;
                    Style = Favorable;
                    StyleExpr = Field2Emphasize;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit(2);
                    end;

                    trigger OnValidate()
                    begin
                        MATRIX_ONVALIDATE(2);
                    end;
                }
                field(Field3; MATRIX_CellData[3])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[3];
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnAssistEdit()
                    begin
                        //wAssistEdit(3);
                    end;

                    trigger OnValidate()
                    begin
                        MATRIX_ONVALIDATE(3);
                    end;
                }
                field(Field4; MATRIX_CellData[4])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[4];
                    DecimalPlaces = 0 : 5;
                    Style = Favorable;
                    StyleExpr = Field4Emphasize;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit(4);
                    end;

                    trigger OnValidate()
                    begin
                        MATRIX_ONVALIDATE(4);
                    end;
                }
                field(Field5; MATRIX_CellData[5])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[5];
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnAssistEdit()
                    begin
                        //wAssistEdit(5);
                    end;

                    trigger OnValidate()
                    begin
                        MATRIX_ONVALIDATE(5);
                    end;
                }
                field(Field6; MATRIX_CellData[6])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[6];
                    DecimalPlaces = 0 : 5;
                    Style = Favorable;
                    StyleExpr = Field6Emphasize;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit(6);
                    end;

                    trigger OnValidate()
                    begin
                        MATRIX_ONVALIDATE(6);
                    end;
                }
                field(Field7; MATRIX_CellData[7])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[7];
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnAssistEdit()
                    begin
                        //wAssistEdit(7);
                    end;

                    trigger OnValidate()
                    begin
                        MATRIX_ONVALIDATE(7);
                    end;
                }
                field(Field8; MATRIX_CellData[8])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[8];
                    DecimalPlaces = 0 : 5;
                    Style = Favorable;
                    StyleExpr = Field8Emphasize;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit(8);
                    end;

                    trigger OnValidate()
                    begin
                        MATRIX_ONVALIDATE(8);
                    end;
                }
                field(Field9; MATRIX_CellData[9])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[9];
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnAssistEdit()
                    begin
                        //wAssistEdit(9);
                    end;

                    trigger OnValidate()
                    begin
                        MATRIX_ONVALIDATE(9);
                    end;
                }
                field(Field10; MATRIX_CellData[10])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[10];
                    DecimalPlaces = 0 : 5;
                    Style = Favorable;
                    StyleExpr = Field10Emphasize;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit(10);
                    end;

                    trigger OnValidate()
                    begin
                        MATRIX_ONVALIDATE(10);
                    end;
                }
                field(Field11; MATRIX_CellData[11])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[11];
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnAssistEdit()
                    begin
                        //wAssistEdit(11);
                    end;

                    trigger OnValidate()
                    begin
                        MATRIX_ONVALIDATE(11);
                    end;
                }
                field(Field12; MATRIX_CellData[12])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[12];
                    DecimalPlaces = 0 : 5;
                    Style = Favorable;
                    StyleExpr = Field12Emphasize;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit(12);
                    end;

                    trigger OnValidate()
                    begin
                        MATRIX_ONVALIDATE(12);
                    end;
                }
                field(Field13; MATRIX_CellData[13])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[13];
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnAssistEdit()
                    begin
                        //wAssistEdit(13);
                    end;

                    trigger OnValidate()
                    begin
                        MATRIX_ONVALIDATE(13);
                    end;
                }
                field(Field14; MATRIX_CellData[14])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[14];
                    DecimalPlaces = 0 : 5;
                    Style = Favorable;
                    StyleExpr = Field14Emphasize;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit(14);
                    end;

                    trigger OnValidate()
                    begin
                        MATRIX_ONVALIDATE(14);
                    end;
                }
                field(Field15; MATRIX_CellData[15])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[15];
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnAssistEdit()
                    begin
                        //wAssistEdit(15);
                    end;

                    trigger OnValidate()
                    begin
                        MATRIX_ONVALIDATE(15);
                    end;
                }
                field(Field16; MATRIX_CellData[16])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[16];
                    DecimalPlaces = 0 : 5;
                    Style = Favorable;
                    StyleExpr = Field16Emphasize;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit(16);
                    end;

                    trigger OnValidate()
                    begin
                        MATRIX_ONVALIDATE(16);
                    end;
                }
                field(Field17; MATRIX_CellData[17])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[17];
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnAssistEdit()
                    begin
                        //wAssistEdit(17);
                    end;

                    trigger OnValidate()
                    begin
                        MATRIX_ONVALIDATE(17);
                    end;
                }
                field(Field18; MATRIX_CellData[18])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[18];
                    DecimalPlaces = 0 : 5;
                    Style = Favorable;
                    StyleExpr = Field18Emphasize;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit(18);
                    end;

                    trigger OnValidate()
                    begin
                        MATRIX_ONVALIDATE(18);
                    end;
                }
                field(Field19; MATRIX_CellData[19])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[19];
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnAssistEdit()
                    begin
                        //wAssistEdit(19);
                    end;

                    trigger OnValidate()
                    begin
                        MATRIX_ONVALIDATE(19);
                    end;
                }
                field(Field20; MATRIX_CellData[20])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[20];
                    DecimalPlaces = 0 : 5;
                    Style = Favorable;
                    StyleExpr = Field20Emphasize;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit(20);
                    end;

                    trigger OnValidate()
                    begin
                        MATRIX_ONVALIDATE(20);
                    end;
                }
                field(Field21; MATRIX_CellData[21])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[21];
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnAssistEdit()
                    begin
                        //wAssistEdit(21);
                    end;

                    trigger OnValidate()
                    begin
                        MATRIX_ONVALIDATE(21);
                    end;
                }
                field(Field22; MATRIX_CellData[22])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[22];
                    DecimalPlaces = 0 : 5;
                    Style = Favorable;
                    StyleExpr = Field22Emphasize;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit(22);
                    end;

                    trigger OnValidate()
                    begin
                        MATRIX_ONVALIDATE(22);
                    end;
                }
                field(Field23; MATRIX_CellData[23])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[23];
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnAssistEdit()
                    begin
                        //wAssistEdit(23);
                    end;

                    trigger OnValidate()
                    begin
                        MATRIX_ONVALIDATE(23);
                    end;
                }
                field(Field24; MATRIX_CellData[24])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[24];
                    DecimalPlaces = 0 : 5;
                    Style = Favorable;
                    StyleExpr = Field24Emphasize;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit(24);
                    end;

                    trigger OnValidate()
                    begin
                        MATRIX_ONVALIDATE(24);
                    end;
                }
                field(Field25; MATRIX_CellData[25])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[25];
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnAssistEdit()
                    begin
                        //wAssistEdit(25);
                    end;

                    trigger OnValidate()
                    begin
                        MATRIX_ONVALIDATE(25);
                    end;
                }
                field(Field26; MATRIX_CellData[26])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[26];
                    DecimalPlaces = 0 : 5;
                    Style = Favorable;
                    StyleExpr = Field26Emphasize;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit(26);
                    end;

                    trigger OnValidate()
                    begin
                        MATRIX_ONVALIDATE(26);
                    end;
                }
                field(Field27; MATRIX_CellData[27])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[27];
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnAssistEdit()
                    begin
                        //wAssistEdit(27);
                    end;

                    trigger OnValidate()
                    begin
                        MATRIX_ONVALIDATE(27);
                    end;
                }
                field(Field28; MATRIX_CellData[28])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[28];
                    DecimalPlaces = 0 : 5;
                    Style = Favorable;
                    StyleExpr = Field28Emphasize;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit(28);
                    end;

                    trigger OnValidate()
                    begin
                        MATRIX_ONVALIDATE(28);
                    end;
                }
                field(Field29; MATRIX_CellData[29])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[29];
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnAssistEdit()
                    begin
                        //wAssistEdit(29);
                    end;

                    trigger OnValidate()
                    begin
                        MATRIX_ONVALIDATE(29);
                    end;
                }
                field(Field30; MATRIX_CellData[30])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[30];
                    DecimalPlaces = 0 : 5;
                    Style = Favorable;
                    StyleExpr = Field30Emphasize;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit(30);
                    end;

                    trigger OnValidate()
                    begin
                        MATRIX_ONVALIDATE(30);
                    end;
                }
                field(Field31; MATRIX_CellData[31])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[31];
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnAssistEdit()
                    begin
                        //wAssistEdit(31);
                    end;

                    trigger OnValidate()
                    begin
                        MATRIX_ONVALIDATE(31);
                    end;
                }
                field(Field32; MATRIX_CellData[32])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[32];
                    DecimalPlaces = 0 : 5;
                    Style = Favorable;
                    StyleExpr = Field32Emphasize;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit(32);
                    end;

                    trigger OnValidate()
                    begin
                        MATRIX_ONVALIDATE(32);
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Ajouter nouvelle opportunité")
                {
                    Caption = 'Ajouter nouvelle opportunité';
                    Image = PostedReceipts;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        P50047: Page "Add prevision";
                    begin

                        P50047.LookupMode(true);
                        if (P50047.RunModal() = ACTION::LookupOK) then begin
                            Dlg.Open('Merci de patienter');
                            CuPrev.Add(CalcDate('<+2M+CM>', Today), P50047.GetClient, P50047.GetArticle, 0);
                            RefreshTemp();
                            CurrPage.Update(false);
                            Dlg.Close();
                        end;
                    end;
                }
                action("Exporter Excel")
                {

                    trigger OnAction()
                    var
                        Items: Record Item;
                        Cust: Record Customer;
                        i: Integer;
                    begin
                        if ShowByItem then Error('Veuillez indiquer un filtre');
                        Xl.NewRow();
                        Xl.AddColumn('Client', false, '', false, false, false, '', Xl."Cell Type"::Text);
                        Xl.AddColumn('Article', false, '', false, false, false, '', Xl."Cell Type"::Text);
                        Xl.AddColumn('', false, '', false, false, false, '', Xl."Cell Type"::Text);
                        for i := 1 to 12 do begin
                            Xl.AddColumn(DtColumns[i * 2], false, '', false, false, false, '', Xl."Cell Type"::Date);
                        end;


                        if Rec.FindSet then
                            repeat
                                Xl.NewRow();
                                Xl.AddColumn(Rec."Break 1", false, '', false, false, false, '', Xl."Cell Type"::Text);
                                Xl.AddColumn(Rec.Code, false, '', false, false, false, '', Xl."Cell Type"::Text);
                                if Cust.Get("Break 1") and Items.Get(Code) then
                                    Xl.AddColumn(Cust.Name + ' / ' + Items.Description, false, '', false, false, false, '', Xl."Cell Type"::Text);
                                FORM_OnAfterGetRecord();
                                for i := 1 to 12 do begin
                                    Xl.AddColumn(MATRIX_CellData[i * 2], false, '', false, false, false, '', Xl."Cell Type"::Number);
                                end;
                            until Rec.Next = 0;
                        Xl.CreateNewBook('Previsions');
                        Xl.WriteSheet('Previsions', CompanyName, UserId);
                        Xl.CloseBook();
                        Xl.SetFriendlyFilename('Previsions');
                        Xl.OpenExcel();
                    end;
                }
                action("Importer Excel")
                {

                    trigger OnAction()
                    var
                        stream: InStream;
                        fromFile: Text;
                        Sheet: Text;
                        Sheets: Record "Name/Value Buffer";
                        i: Integer;
                        n: Integer;
                        Prev: Record "Statistic aggregate";
                        PrevTmp: Record "Statistic aggregate" temporary;
                        j: Integer;
                        CuPrev: Codeunit Previsions;
                        Cust: Record Customer;
                    begin
                        UploadIntoStream('Veuillez sélectionner le fichier à importer', '', '', fromFile, stream);
                        if fromFile <> '' then begin
                            Xl.GetSheetsNameListFromStream(stream, Sheets);
                            Sheets.FindFirst();
                            Sheet := Sheets.Value;
                        end
                        else
                            Error('Import stoppé');

                        Xl.Reset;
                        Xl.DeleteAll;
                        Xl.OpenBookStream(stream, Sheet);
                        Xl.ReadSheet();
                        if Xl.FindLast then n := Xl."Row No.";

                        Xl.Get(2, 4);
                        //IF Xl.FINDSET THEN REPEAT MESSAGE('%1   %2  %3',Xl."Row No.",Xl."Column No.",Xl."Cell Value as Text"); UNTIL Xl.NEXT=0;
                        for i := 2 to n do begin
                            for j := 4 to 15 do begin
                                PrevTmp.Reset;
                                PrevTmp.Init;
                                PrevTmp."Entry No." := i * 20 + j;
                                Evaluate(PrevTmp."Ending Date", GetValueAtCell(1, j));
                                PrevTmp."Source No." := GetValueAtCell(i, 1);
                                Cust.Get(PrevTmp."Source No.");
                                if UserMgt.GetRespCenter(0, '') <> '' then
                                    if Cust."Salesperson Code" <> UserMgt.GetRespCenter(0, '') then Error('Vous n''avez pas les droits sur ce client');

                                PrevTmp."No." := GetValueAtCell(i, 2);
                                Evaluate(PrevTmp.Quantity, GetValueAtCell(i, j));
                                PrevTmp.Insert;
                            end;
                        end;
                        PrevTmp.Reset;
                        if PrevTmp.FindSet then
                            repeat
                                Prev.Reset;
                                Prev.SetRange("Ending Date", PrevTmp."Ending Date");
                                Prev.SetRange("Source No.", PrevTmp."Source No.");
                                Prev.SetRange("Period Length", Prev."Period Length"::Month);
                                Prev.SetRange("No.", PrevTmp."No.");
                                Prev.SetRange("Entry Type", 'Previsions');
                                if Prev.FindFirst then begin
                                    if Prev.Quantity <> PrevTmp.Quantity then begin
                                        //MESSAGE('m  %1  %2',Prev.Quantity, PrevTmp.Quantity);
                                        CuPrev.Modify(PrevTmp."Ending Date", PrevTmp."Source No.", PrevTmp."No.", PrevTmp.Quantity);
                                    end;
                                end
                                else begin
                                    if PrevTmp.Quantity > 0 then begin
                                        CuPrev.Modify(PrevTmp."Ending Date", PrevTmp."Source No.", PrevTmp."No.", PrevTmp.Quantity);
                                    end;
                                end;
                            until PrevTmp.Next = 0;
                        RefreshTemp();
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CodeIndent := 0;
        FORM_OnAfterGetRecord;
        MATRIXCellData1OnFormat;
        MATRIXCellData2OnFormat;
        MATRIXCellData3OnFormat;
        MATRIXCellData4OnFormat;
        MATRIXCellData5OnFormat;
        MATRIXCellData6OnFormat;
        MATRIXCellData7OnFormat;
        MATRIXCellData8OnFormat;
        MATRIXCellData9OnFormat;
        MATRIXCellData10OnFormat;
        MATRIXCellData11OnFormat;
        MATRIXCellData12OnFormat;
        MATRIXCellData13OnFormat;
        MATRIXCellData14OnFormat;
        MATRIXCellData15OnFormat;
        MATRIXCellData16OnFormat;
        MATRIXCellData17OnFormat;
        MATRIXCellData18OnFormat;
        MATRIXCellData19OnFormat;
        MATRIXCellData20OnFormat;
        MATRIXCellData21OnFormat;
        MATRIXCellData22OnFormat;
        MATRIXCellData23OnFormat;
        MATRIXCellData24OnFormat;
        MATRIXCellData25OnFormat;
        MATRIXCellData26OnFormat;
        MATRIXCellData27OnFormat;
        MATRIXCellData28OnFormat;
        MATRIXCellData29OnFormat;
        MATRIXCellData30OnFormat;
        MATRIXCellData31OnFormat;
        MATRIXCellData32OnFormat;
    end;

    trigger OnInit()
    begin
        MATRIX_CurrSetLength := ArrayLen(MATRIX_CaptionSet);

        ShowByItem := not Utils.IsInGroup('COMMERCIAUX');
    end;

    trigger OnOpenPage()
    var
        last: Code[150];
        User: Record "User Setup";
    begin
        i := 1;



        SetColumns(MATRIX_SetWanted::Initial);


        if UserMgt.GetRespCenter(0, '') <> '' then begin
            ShowFilterVendeur := false;
            FilterVendeur := UserMgt.GetRespCenter(0, '');
        end
        else begin
            ShowFilterVendeur := true;
        end;

        RefreshTemp();
    end;

    var
        ParamCompta: Record "General Ledger Setup";
        LigneTableauStat2: Record "Statistic array line";
        Cellule: Record "Statistic cell";
        Definition: Record "Statistic definition";
        FormatStringNormal: Text[80];
        Ouverture: Boolean;
        Fenetre: Dialog;
        NumLig: Integer;
        Preparation: Label 'Prepare in progress...';
        Error1: Label 'Statistic %1 was not calculated';
        TexteCodePredefini: Label 'MANUAL';
        wLoginMgt: Codeunit "User Management";
        MatrixColumCaption: array[32] of Text[1024];
        ColumValue: array[32] of Text[1024];
        CurrSetLengh: Integer;
        "---------": Integer;
        MATRIX_SetWanted: Option Initial,Previous,Same,Next;
        MATRIX_CaptionSet: array[32] of Text[1024];
        MATRIX_CaptionRange: Text[100];
        MATRIX_PKFirstRecInCurrSet: Text[100];
        MATRIX_CurrSetLength: Integer;
        MATRIX_CellData: array[32] of Decimal;

        CodeEmphasize: Boolean;

        CodeIndent: Integer;

        DescriptionEmphasize: Boolean;

        DescriptionIndent: Integer;

        Field1Emphasize: Boolean;

        Field2Emphasize: Boolean;

        Field3Emphasize: Boolean;

        Field4Emphasize: Boolean;

        Field5Emphasize: Boolean;

        Field6Emphasize: Boolean;

        Field7Emphasize: Boolean;

        Field8Emphasize: Boolean;

        Field9Emphasize: Boolean;

        Field10Emphasize: Boolean;

        Field11Emphasize: Boolean;

        Field12Emphasize: Boolean;

        Field13Emphasize: Boolean;

        Field14Emphasize: Boolean;

        Field15Emphasize: Boolean;

        Field16Emphasize: Boolean;

        Field17Emphasize: Boolean;
        Field18Emphasize: Boolean;

        Field19Emphasize: Boolean;

        Field20Emphasize: Boolean;

        Field21Emphasize: Boolean;

        Field22Emphasize: Boolean;

        Field23Emphasize: Boolean;

        Field24Emphasize: Boolean;

        Field25Emphasize: Boolean;

        Field26Emphasize: Boolean;

        Field27Emphasize: Boolean;

        Field28Emphasize: Boolean;

        Field29Emphasize: Boolean;

        Field30Emphasize: Boolean;

        Field31Emphasize: Boolean;

        Field32Emphasize: Boolean;
        CodeNames: Code[60];
        DtColumns: array[32] of Date;
        i: Integer;
        Utils: Codeunit Utils;
        Indentation: Integer;
        Prev: Record "Statistic aggregate";
        Cust: Record Customer;
        NomClient: Text[80];

        Description: Text[150];
        CuPrev: Codeunit Previsions;
        Dlg: Dialog;
        ShowByItem: Boolean;
        FilterCustomer: Code[50];
        FilterItem: Code[50];
        FilterVendeur: Code[50];

        ShowFilterVendeur: Boolean;
        UserMgt: Codeunit "User Setup Management";
        Text50000: Label 'Forec';

        "Désignation": Text[200];
        Xl: Record "Excel Buffer" temporary;
        OnlyConfirmed: Boolean;

    [Scope('OnPrem')]
    procedure wAssistEdit(Column: Integer)
    var
        P50048: Page "Modif Prevision";
    begin
        if ShowByItem then begin
            Prev.Reset;
            Prev.SetRange("Ending Date", DtColumns[Column]);
            Prev.SetRange("No.", Code);
            Prev.SetRange("Entry Type", 'Previsions');
            if Prev.FindFirst then begin
                P50048.SetTableView(Prev);
                P50048.Run;
            end;
        end;
    end;

    [Scope('OnPrem')]
    procedure SetColumns(SetWanted: Option Initial,Previous,Same,Next)
    var
        MatrixMgt: Codeunit "Matrix Management";
        CaptionFieldNo: Integer;
        CurrentMatrixRecordOrdinal: Integer;
        Dt: Date;
    begin
        Dt := CalcDate('<-1M+CM+1D>', Today);
        for i := 1 to 16 do begin
            DtColumns[i * 2] := CalcDate('<+CM>', Dt);
            Dt := CalcDate('<+1M>', Dt);
            MATRIX_CaptionSet[i * 2] := Text50000 + ' ' + Format(DtColumns[i * 2], 0, '<Month Text> <Year4>');
            MATRIX_CaptionSet[i * 2 - 1] := 'N-1';
        end;
    end;

    [Scope('OnPrem')]
    procedure FORM_OnAfterGetRecord()
    var
        lIndex: Integer;
        Items: Record Item;
        Confirmed: Boolean;
    begin

        CodeNames := '';
        Indentation := 0;

        lIndex := 0;
        Clear(MATRIX_CellData);
        NomClient := '';

        if ShowByItem then begin
            CodeNames := '';
        end
        else begin
            if Cust.Get("Break 1") then NomClient := Cust.Name;
            if "Break 2" = xRec."Break 2" then begin
                if "Break 1" = xRec."Break 1" then begin
                    if "Break 2" = '' then
                        Indentation := 2
                    else
                        Indentation := 4;
                    CodeNames := ' ' + "Break 1"
                end
                else begin
                    if "Break 2" = '' then
                        Indentation := 0
                    else
                        Indentation := 2;
                    CodeNames := ' ' + "Break 1" + ' ' + NomClient
                end;
            end
            else
                CodeNames := "Break 2" + ' ' + "Break 1" + ' ' + NomClient;
        end;
        Description := CodeNames;
        Désignation := '';
        if Items.Get(Code) then
            Désignation := Items.Description;

        for i := 1 to 16 do begin
            Prev.Reset;
            Prev.SetRange("Ending Date", DtColumns[i * 2]);
            if not ShowByItem then
                Prev.SetRange("Source No.", "Break 1");
            Prev.SetRange("No.", Code);
            Prev.SetRange("Entry Type", 'Previsions');
            MATRIX_CellData[i * 2] := 0;
            Confirmed := true;
            if Prev.FindSet then
                repeat
                    if not Prev."Free boolean 1" then
                        Confirmed := false;
                    MATRIX_CellData[i * 2] := MATRIX_CellData[i * 2] + Prev.Quantity;
                until Prev.Next = 0;
            if OnlyConfirmed and not Confirmed then
                MATRIX_CellData[i * 2] := 0;

            Prev.Reset;
            Prev.SetRange("Ending Date", CalcDate('<-1Y+CM>', DtColumns[i * 2]));
            if not ShowByItem then
                Prev.SetRange("Source No.", "Break 1");
            Prev.SetRange("Period Length", Prev."Period Length"::Month);
            Prev.SetRange("No.", Code);
            Prev.SetRange("Entry Type", 'Vente');
            MATRIX_CellData[i * 2 - 1] := 0;
            if Prev.FindSet then
                repeat
                    MATRIX_CellData[i * 2 - 1] := MATRIX_CellData[i * 2 - 1] + Prev.Quantity;
                until Prev.Next = 0;

            MATRIX_OnFormat(i * 2, (MATRIX_CellData[i * 2 - 1] <> MATRIX_CellData[i * 2]));
        end;
    end;

    local procedure MATRIX_OnAfterGetRecord(ColumnID: Integer)
    var
        lStatArrayLine: Record "Statistic array line";
    begin
        MATRIX_CellData[ColumnID] := 0;
    end;

    [Scope('OnPrem')]
    procedure SetVisible()
    var
        lVisible: Boolean;
    begin
    end;

    [Scope('OnPrem')]
    procedure fSetFormatValue(pValue: Decimal; pColumnID: Integer) Retour: Text[80]
    begin
    end;

    [Scope('OnPrem')]
    procedure MATRIX_OnFormat(pColumnID: Integer; lFontBold: Boolean)
    begin

        case (pColumnID) of
            1:
                begin
                    Field1Emphasize := lFontBold;
                end;
            2:
                begin
                    Field2Emphasize := lFontBold;
                end;
            3:
                begin
                    Field3Emphasize := lFontBold;
                end;
            4:
                begin
                    Field4Emphasize := lFontBold;
                end;
            5:
                begin
                    Field5Emphasize := lFontBold;
                end;
            6:
                begin
                    Field6Emphasize := lFontBold;
                end;
            7:
                begin
                    Field7Emphasize := lFontBold;
                end;
            8:
                begin
                    Field8Emphasize := lFontBold;
                end;
            9:
                begin
                    Field9Emphasize := lFontBold;
                end;
            10:
                begin
                    Field10Emphasize := lFontBold;
                end;
            11:
                begin
                    Field11Emphasize := lFontBold;
                end;
            12:
                begin
                    Field12Emphasize := lFontBold;
                end;
            13:
                begin
                    Field13Emphasize := lFontBold;
                end;
            14:
                begin
                    Field14Emphasize := lFontBold;
                end;
            15:
                begin
                    Field15Emphasize := lFontBold;
                end;
            16:
                begin
                    Field16Emphasize := lFontBold;
                end;
            17:
                begin
                    Field17Emphasize := lFontBold;
                end;
            18:
                begin
                    Field18Emphasize := lFontBold;
                end;
            19:
                begin
                    Field19Emphasize := lFontBold;
                end;
            20:
                begin
                    Field20Emphasize := lFontBold;
                end;
            21:
                begin
                    Field21Emphasize := lFontBold;
                end;
            22:
                begin
                    Field22Emphasize := lFontBold;
                end;
            23:
                begin
                    Field23Emphasize := lFontBold;
                end;
            24:
                begin
                    Field24Emphasize := lFontBold;
                end;
            25:
                begin
                    Field25Emphasize := lFontBold;
                end;
            26:
                begin
                    Field26Emphasize := lFontBold;
                end;
            27:
                begin
                    Field27Emphasize := lFontBold;
                end;
            28:
                begin
                    Field28Emphasize := lFontBold;
                end;
            29:
                begin
                    Field29Emphasize := lFontBold;
                end;
            30:
                begin
                    Field30Emphasize := lFontBold;
                end;
            31:
                begin
                    Field31Emphasize := lFontBold;
                end;
            32:
                begin
                    Field32Emphasize := lFontBold;
                end;
        end;
    end;

    local procedure MATRIXCellData1OnFormat()
    begin
        //MATRIX_OnFormat(1);
    end;

    local procedure MATRIXCellData2OnFormat()
    begin
        //MATRIX_OnFormat(2);
    end;

    local procedure MATRIXCellData3OnFormat()
    begin
        //MATRIX_OnFormat(3);
    end;

    local procedure MATRIXCellData4OnFormat()
    begin
        //MATRIX_OnFormat(4);
    end;

    local procedure MATRIXCellData5OnFormat()
    begin
        //MATRIX_OnFormat(5);
    end;

    local procedure MATRIXCellData6OnFormat()
    begin
        //MATRIX_OnFormat(6);
    end;

    local procedure MATRIXCellData7OnFormat()
    begin
        //MATRIX_OnFormat(7);
    end;

    local procedure MATRIXCellData8OnFormat()
    begin
        //MATRIX_OnFormat(8);
    end;

    local procedure MATRIXCellData9OnFormat()
    begin
        //MATRIX_OnFormat(9);
    end;

    local procedure MATRIXCellData10OnFormat()
    begin
        //MATRIX_OnFormat(10);
    end;

    local procedure MATRIXCellData11OnFormat()
    begin
        //MATRIX_OnFormat(11);
    end;

    local procedure MATRIXCellData12OnFormat()
    begin
        //MATRIX_OnFormat(12);
    end;

    local procedure MATRIXCellData13OnFormat()
    begin
        //MATRIX_OnFormat(13);
    end;

    local procedure MATRIXCellData14OnFormat()
    begin
        //MATRIX_OnFormat(14);
    end;

    local procedure MATRIXCellData15OnFormat()
    begin
        //MATRIX_OnFormat(15);
    end;

    local procedure MATRIXCellData16OnFormat()
    begin
        //MATRIX_OnFormat(16);
    end;

    local procedure MATRIXCellData17OnFormat()
    begin
        //MATRIX_OnFormat(17);
    end;

    local procedure MATRIXCellData18OnFormat()
    begin
        //MATRIX_OnFormat(18);
    end;

    local procedure MATRIXCellData19OnFormat()
    begin
        //MATRIX_OnFormat(19);
    end;

    local procedure MATRIXCellData20OnFormat()
    begin
        //MATRIX_OnFormat(20);
    end;

    local procedure MATRIXCellData21OnFormat()
    begin
        //MATRIX_OnFormat(21);
    end;

    local procedure MATRIXCellData22OnFormat()
    begin
        //MATRIX_OnFormat(22);
    end;

    local procedure MATRIXCellData23OnFormat()
    begin
        //MATRIX_OnFormat(23);
    end;

    local procedure MATRIXCellData24OnFormat()
    begin
        //MATRIX_OnFormat(24);
    end;

    local procedure MATRIXCellData25OnFormat()
    begin
        //MATRIX_OnFormat(25);
    end;

    local procedure MATRIXCellData26OnFormat()
    begin
        //MATRIX_OnFormat(26);
    end;

    local procedure MATRIXCellData27OnFormat()
    begin
        //MATRIX_OnFormat(27);
    end;

    local procedure MATRIXCellData28OnFormat()
    begin
        //MATRIX_OnFormat(28);
    end;

    local procedure MATRIXCellData29OnFormat()
    begin
        //MATRIX_OnFormat(29);
    end;

    local procedure MATRIXCellData30OnFormat()
    begin
        //MATRIX_OnFormat(30);
    end;

    local procedure MATRIXCellData31OnFormat()
    begin
        //MATRIX_OnFormat(31);
    end;

    local procedure MATRIXCellData32OnFormat()
    begin
        //MATRIX_OnFormat(32);
    end;

    [Scope('OnPrem')]
    procedure MATRIX_ONVALIDATE(Column: Integer)
    begin
        CuPrev.Modify(DtColumns[Column], "Break 1", Code, MATRIX_CellData[Column]);
        MATRIX_OnFormat(Column, true);

        //CurrPage.UPDATE;
    end;

    [Scope('OnPrem')]
    procedure RefreshTemp()
    var
        last: Text[150];
        Act: Text[150];
    begin
        DeleteAll;

        Prev.Reset;

        Prev.SetRange("Period Length", Prev."Period Length"::Month);
        Prev.SetRange("Ending Date", CalcDate('<0M>', Today), CalcDate('<+18M>', Today));
        Prev.SetRange("Entry Type", 'Previsions');
        if FilterVendeur <> '' then begin
            Prev.SetFilter("Salespers./Purch. Code", FilterVendeur);

        end;

        if OnlyConfirmed then
            Prev.SetRange("Free boolean 1", true);

        Prev.SetFilter("No.", '1*|2*');
        if FilterCustomer <> '' then begin
            Prev.SetFilter("Source No.", FilterCustomer);
            ShowByItem := false;
        end;

        if FilterItem <> '' then
            Prev.SetFilter("No.", FilterItem);

        if ShowByItem then
            Prev.SetCurrentKey(
            "Entry Type", Type, "No.", "Source Type", "Source No.", "Location Code", "Inventory Posting Group", "Source Posting Group",
            "Gen. Bus. Posting Group", "Gen. Prod. Posting Group", "Salespers./Purch. Code", "Global Dimension 1 Code", "Global Dimension 2 Code",
            "Reason Code", "Ending Date")
        else
            //Prev.SETCURRENTKEY("Customer criteria 5","Source No.","No.");
            Prev.SetCurrentKey("Source No.", "No.");

        i := 1;

        if Prev.FindSet then
            repeat

                if ShowByItem then
                    Act := Prev."No."
                else
                    Act := Prev."Source No." + Prev."No.";
                if last <> Act then begin
                    last := Act;
                    Init;
                    "Line No." := i;
                    i := i + 1;
                    //"Break 2" := Prev."Customer criteria 5";
                    "Break 1" := Prev."Source No.";
                    Code := Prev."No.";
                    Insert;
                end;
            until Prev.Next = 0;
        FindFirst;
    end;

    local procedure GetValueAtCell(Row: Integer; Col: Integer): Text
    begin
        Xl.Reset;
        if Xl.Get(Row, Col) then
            exit(Xl."Cell Value as Text")
        else
            exit('');
    end;
}

