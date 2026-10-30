page 8001300 "Statictic array display"
{
    // //STATSEXPLORER STATSEXPLORER 20/01/00 Statistic display
    // //STATSEXPLORER STATSEXPLORER 19/07/04 Bug with 3.70A : option was bad in OnFormat

    AdditionalSearchTerms = 'StatsExplorer';
    Caption = 'Statictic array display';
    DataCaptionExpression = Definition.Description;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPlus;
    PromotedActionCategories = 'New,Process,Report,Function';
    QueryCategory = 'StatsExplorer';
    SaveValues = true;
    SourceTable = "Statistic array line";
    UsageCategory = ReportsAndAnalysis;

    layout
    {
        area(content)
        {
            group(Options)
            {
                Caption = 'Options';
                group(Option)
                {
                    Caption = 'Option';
                    field(CodeStatistique; CodeStatistique)
                    {
                        Caption = 'Statistic code';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            Definition.FilterGroup(7);
                            Definition.SetRange("Statistic code");
                            Definition.SetRange("Line No.", 9999);
                            Definition.FilterGroup(0);

                            if PAGE.RunModal(PAGE::"Statistic definition", Definition) = ACTION::LookupOK then begin
                                CodeStatistique := Definition."Statistic code";
                                SetRange("Statistic code", CodeStatistique);
                                fSetFilter();
                                CurrPage.Update(false);
                            end;

                            fSetFilter();
                        end;

                        trigger OnValidate()
                        begin
                            CodeStatistiqueOnAfterValidate;
                        end;
                    }
                }
                group("Matrix Options")
                {
                    Caption = 'Matrix Options';
                    field(MATRIX_CaptionRange; MATRIX_CaptionRange)
                    {
                        Caption = 'Column Set';
                        Editable = false;
                    }
                }
            }
            repeater(Control1100287002)
            {
                Editable = false;
                Enabled = true;
                FreezeColumn = Description;
                IndentationColumn = DescriptionIndent;
                IndentationControls = "Code";
                ShowCaption = false;
                Visible = true;
                field("Code"; Code)
                {
                    Width = 22;
                }
                field(Description; Description)
                {

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit();
                    end;
                }
                field(Field1; MATRIX_CellData[1])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[1];

                    Visible = Field1Visible;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit();
                    end;
                }
                field(Field2; MATRIX_CellData[2])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[2];

                    Visible = Field2Visible;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit();
                    end;
                }
                field(Field3; MATRIX_CellData[3])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[3];

                    Visible = Field3Visible;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit();
                    end;
                }
                field(Field4; MATRIX_CellData[4])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[4];

                    Visible = Field4Visible;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit();
                    end;
                }
                field(Field5; MATRIX_CellData[5])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[5];

                    Visible = Field5Visible;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit();
                    end;
                }
                field(Field6; MATRIX_CellData[6])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[6];

                    Visible = Field6Visible;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit();
                    end;
                }
                field(Field7; MATRIX_CellData[7])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[7];

                    Visible = Field7Visible;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit();
                    end;
                }
                field(Field8; MATRIX_CellData[8])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[8];

                    Visible = Field8Visible;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit();
                    end;
                }
                field(Field9; MATRIX_CellData[9])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[9];

                    Visible = Field9Visible;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit();
                    end;
                }
                field(Field10; MATRIX_CellData[10])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[10];

                    Visible = Field10Visible;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit();
                    end;
                }
                field(Field11; MATRIX_CellData[11])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[11];

                    Visible = Field11Visible;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit();
                    end;
                }
                field(Field12; MATRIX_CellData[12])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[12];

                    Visible = Field12Visible;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit();
                    end;
                }
                field(Field13; MATRIX_CellData[13])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[13];

                    Visible = Field13Visible;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit();
                    end;
                }
                field(Field14; MATRIX_CellData[14])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[14];

                    Visible = Field14Visible;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit();
                    end;
                }
                field(Field15; MATRIX_CellData[15])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[15];

                    Visible = Field15Visible;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit();
                    end;
                }
                field(Field16; MATRIX_CellData[16])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[16];

                    Visible = Field16Visible;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit();
                    end;
                }
                field(Field17; MATRIX_CellData[17])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[17];

                    Visible = Field17Visible;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit();
                    end;
                }
                field(Field18; MATRIX_CellData[18])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[18];

                    Visible = Field18Visible;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit();
                    end;
                }
                field(Field19; MATRIX_CellData[19])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[19];

                    Visible = Field19Visible;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit();
                    end;
                }
                field(Field20; MATRIX_CellData[20])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[20];

                    Visible = Field20Visible;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit();
                    end;
                }
                field(Field21; MATRIX_CellData[21])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[21];

                    Visible = Field21Visible;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit();
                    end;
                }
                field(Field22; MATRIX_CellData[22])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[22];

                    Visible = Field22Visible;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit();
                    end;
                }
                field(Field23; MATRIX_CellData[23])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[23];

                    Visible = Field23Visible;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit();
                    end;
                }
                field(Field24; MATRIX_CellData[24])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[24];

                    Visible = Field24Visible;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit();
                    end;
                }
                field(Field25; MATRIX_CellData[25])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[25];

                    Visible = Field25Visible;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit();
                    end;
                }
                field(Field26; MATRIX_CellData[26])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[26];

                    Visible = Field26Visible;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit();
                    end;
                }
                field(Field27; MATRIX_CellData[27])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[27];

                    Visible = Field27Visible;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit();
                    end;
                }
                field(Field28; MATRIX_CellData[28])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[28];

                    Visible = Field28Visible;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit();
                    end;
                }
                field(Field29; MATRIX_CellData[29])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[29];

                    Visible = Field29Visible;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit();
                    end;
                }
                field(Field30; MATRIX_CellData[30])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[30];

                    Visible = Field30Visible;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit();
                    end;
                }
                field(Field31; MATRIX_CellData[31])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[31];

                    Visible = Field31Visible;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit();
                    end;
                }
                field(Field32; MATRIX_CellData[32])
                {

                    CaptionClass = '3,' + MATRIX_CaptionSet[32];

                    Visible = Field32Visible;

                    trigger OnAssistEdit()
                    begin
                        wAssistEdit();
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
                action("Process statistic")
                {
                    Caption = 'Process statistic';
                    Visible = false;

                    trigger OnAction()
                    begin
                        REPORT.RunModal(REPORT::"Process aggregate");
                        if Definition.Get(UserId, '', 0) then
                            CodeStatistique := Definition.Description;
                        wOuverture;
                    end;
                }
                action("Process standard statistic")
                {
                    Caption = 'Process standard statistic';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        REPORT.RunModal(REPORT::"Process standard statistic");
                        if Definition.Get(UserId, '', 0) then
                            CodeStatistique := Definition.Description;
                        wOuverture;
                    end;
                }
                action("&Definition")
                {
                    Caption = '&Definition';

                    trigger OnAction()
                    begin
                        PAGE.RunModal(PAGE::"Statistic definition", Definition);
                    end;
                }
                action(Forward)
                {
                    Caption = 'Forward';
                }
                separator(Action16)
                {
                }
                action("Send to Excel")
                {
                    Caption = 'Send to Excel';
                    Image = Excel;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        ReportExcelold: Report "Send statistic to Excel";
                        TempFile: File;
                        Name: Text[250];
                        NewStream: InStream;
                        Tofile: Text;
                        ReturnValue: Boolean;
                        ReportExcel: Report "Statistic report";
                        Excel2007FileType: Label 'Fichiers Excel (*.xls*)|*.xls*';
                    begin
                        //ReportExcel.InitRequete(CodeStatistique,1,FALSE,'','',USERID,FALSE,FALSE,FALSE, '');
                        //ReportExcel.RUNMODAL;
                        ReportExcel.InitRequete(CodeStatistique, 1, false, true, UserId);
                        // Specify that TempFile is opened as a binary file.
                        TempFile.TextMode(false);
                        // Specify that you can write to TempFile.
                        TempFile.WriteMode(true);
                        Name := '\\srvnavision\NavisionTemp\TempReport.xls';
                        // Create and open TempFile.
                        TempFile.Create(Name);
                        // Close TempFile so that the SAVEASEXCEL function can write to it.
                        TempFile.Close;
                        ReportExcel.SaveAsExcel(Name);
                        TempFile.Open(Name);
                        TempFile.CreateInStream(NewStream);
                        Tofile := 'Report.xls';
                        // Transfer the content from the temporary file on Microsoft Dynamics NAV
                        // Server to a file on the client.
                        ReturnValue := DownloadFromStream(
                            NewStream,
                            'Save file to client',
                            '',
                            'Excel File *.xls| *.xls',
                            Tofile);
                        // Close the temporary file.
                        TempFile.Close();
                    end;
                }
                action("Send To Excel simple")
                {
                    Caption = 'Send To Excel simple';

                    trigger OnAction()
                    var
                        "Report": Report "Send statistic to Excel";
                    begin
                        Report.InitRequete(CodeStatistique, 10, '');
                        Report.Run;
                    end;
                }
                separator(Action8)
                {
                }
                action("Delete statistics")
                {
                    Caption = 'Delete statistics';
                    Image = DeleteQtyToHandle;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        Definition2: Record "Statistic definition";
                        ReportPurge: Report "Deleting user statistic";
                    begin
                        ReportPurge.InitRequete(CodeStatistique);
                        ReportPurge.RunModal;
                        Definition.FilterGroup(7);
                        Definition.SetRange("Statistic code");
                        Definition.SetRange("Line No.", 10000);
                        Definition.FilterGroup(0);

                        if not Definition.Get(UserId, CodeStatistique, 10000) then
                            if Definition.Find('-') then begin
                                if Definition2.Get(UserId, '', 0) then begin
                                    Definition2.Description := Definition."Statistic code";
                                    Definition2.Modify;
                                    CodeStatistique := Definition2.Description;
                                end;
                            end else begin
                                if Definition2.Get(UserId, '', 0) then
                                    Definition2.Delete;
                                CodeStatistique := '';
                            end;

                        fSetFilter;
                        wOuverture;
                        CurrPage.Update(false);
                    end;
                }
            }
            action("&Print")
            {
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ReportEdition: Report "Statistic report";
                begin
                    ReportEdition.InitRequete(CodeStatistique, 1, false, true, UserId);
                    ReportEdition.RunModal;
                end;
            }
            action("Previous Set")
            {
                Caption = 'Previous Set';
                Image = PreviousSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Previous Set';

                trigger OnAction()
                begin
                    SetColumns(MATRIX_SetWanted::Previous);
                end;
            }
            action("Next Set")
            {
                Caption = 'Next Set';
                Image = NextSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Next Set';

                trigger OnAction()
                begin
                    SetColumns(MATRIX_SetWanted::Next);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CodeIndent := 0;
        FORM_OnAfterGetRecord;
        CodeOnFormat;
        DescriptionOnFormat;
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
        MATRIX_CurrSetLength := ArrayLen(MATRIX_CaptionSet);
    end;

    trigger OnOpenPage()
    begin
        fInitialize();
        SetColumns(MATRIX_SetWanted::Initial);
    end;

    var
        ParamCompta: Record "General Ledger Setup";
        LigneTableauStat2: Record "Statistic array line";
        Cellule: Record "Statistic cell";
        Definition: Record "Statistic definition";
        CodeStatistique: Code[10];
        xCodeStatistique: Code[10];
        FormatStringNormal: Text[80];
        Ouverture: Boolean;
        Fenetre: Dialog;
        NumLig: Integer;
        Preparation: Label 'Prepare in progress...';
        Error1: Label 'Statistic %1 was not calculated';
        TexteCodePredefini: Label 'MANUAL';
        wLoginMgt: Codeunit "User Management";
        MatrixColumCaption: array[32] of Text;
        ColumValue: array[32] of Text;
        CurrSetLengh: Integer;
        "---------": Integer;
        MatrixRecord: Record "Statistic array column";
        MatrixRecords: array[32] of Record "Statistic array column";
        MatrixRecordRef: RecordRef;
        MATRIX_SetWanted: Option Initial,Previous,Same,Next;
        MATRIX_CaptionSet: array[32] of Text;
        MATRIX_CaptionRange: Text;
        MATRIX_PKFirstRecInCurrSet: Text;
        MATRIX_CurrSetLength: Integer;
        MATRIX_CellData: array[32] of Text[80];

        CodeEmphasize: Boolean;

        CodeIndent: Integer;

        DescriptionEmphasize: Boolean;

        DescriptionIndent: Integer;

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

    [Scope('OnPrem')]
    procedure fInitialize()
    begin
        if FormatStringNormal = '' then begin
            ParamCompta.Get;
            FormatStringNormal := '<Precision,' + ParamCompta."Amount Decimal Places" + '><Standard Format,0>';
        end;

        if (CodeStatistique = '') and (Definition.Get(UserId, '', 0)) then
            CodeStatistique := Definition.Description;

        fSetFilter();

        if Definition.Get(UserId, CodeStatistique, 10000) then
            wMark(true);

        //#5075
        //wLoginMgt.fPopulateLogin(Users);
        //#5075//
    end;

    [Scope('OnPrem')]
    procedure fSetFilter()
    begin
        FilterGroup(7);
        SetRange("User ID", UserId);
        SetRange("Statistic code", CodeStatistique);
        FilterGroup(0);

        Definition.FilterGroup(7);
        Definition.SetRange("User ID", UserId);
        Definition.SetRange("Statistic code", CodeStatistique);
        Definition.SetFilter("Line No.", '>=%1', 10000);
        Definition.FilterGroup(0);
    end;

    [Scope('OnPrem')]
    procedure wOuverture()
    begin
        Definition.FilterGroup(7);
        Definition.SetRange("User ID", UserId);
        Definition.SetRange("Statistic code", CodeStatistique);
        Definition.FilterGroup(0);
        if Definition.Get(UserId, CodeStatistique, 10000) then
            wMark(true)
        else begin
            Definition.Init;
            ClearMarks;
        end;
    end;

    [Scope('OnPrem')]
    procedure wMark(Open: Boolean)
    begin


        Fenetre.Open(Preparation);

        Reset;

        FilterGroup(7);
        SetRange("User ID", UserId);
        FilterGroup(0);

        if Open then begin
            SetCurrentKey("User ID", "Section level", Open);
            SetRange("Section level", 2, 100);
            SetRange(Open, true);
            ModifyAll(Open, false);
            SetRange(Open);
        end;

        SetRange("Section level", 1);
        ModifyAll(Open, true);

        SetRange("Section level", 1, 2);
        if not IsEmpty then begin
            FindFirst;
            repeat
                Mark(true);
            until Next = 0;
            FindFirst;
        end;
        SetRange("Section level");
        MarkedOnly(true);
        SetCurrentKey("User ID", "Statistic code", "Line No.");
        SetRange("Statistic code", CodeStatistique);
        if not IsEmpty then
            if FindFirst then;
        CurrPage.Update(false);

        Fenetre.Close;

    end;

    [Scope('OnPrem')]
    procedure wAssistEdit()
    begin


        if ("Section level" = 1) and (Open) then begin
            wMark(true);
            CurrPage.Update(false);
        end else
            if "Lower lines count" > 0 then begin
                MarkedOnly(false);
                if not Open then begin
                    SetRange("Section level", "Section level" + 1);
                    Open := true;
                    Ouverture := true;
                end else begin
                    Open := false;
                    SetRange("Section level", "Section level" + 1, "Section level" + 100);
                    Ouverture := false;
                end;
                Modify;

                case "Section level" of
                    2:
                        begin
                            SetRange("Break 1", "Break 1");
                        end;
                    3:
                        begin
                            SetRange("Break 1", "Break 1");
                            SetRange("Break 2", "Break 2");
                        end;
                    4:
                        begin
                            SetRange("Break 1", "Break 1");
                            SetRange("Break 2", "Break 2");
                            SetRange("Break 3", "Break 3");
                        end;
                    5:
                        begin
                            SetRange("Break 1", "Break 1");
                            SetRange("Break 2", "Break 2");
                            SetRange("Break 3", "Break 3");
                            SetRange("Break 4", "Break 4");
                        end;
                    6:
                        begin
                            SetRange("Break 1", "Break 1");
                            SetRange("Break 2", "Break 2");
                            SetRange("Break 3", "Break 3");
                            SetRange("Break 4", "Break 4");
                            SetRange("Break 5", "Break 5");
                        end;
                    7:
                        begin
                            SetRange("Break 1", "Break 1");
                            SetRange("Break 2", "Break 2");
                            SetRange("Break 3", "Break 3");
                            SetRange("Break 4", "Break 4");
                            SetRange("Break 5", "Break 5");
                            SetRange("Break 6", "Break 6");
                        end;
                    8:
                        begin
                            SetRange("Break 1", "Break 1");
                            SetRange("Break 2", "Break 2");
                            SetRange("Break 3", "Break 3");
                            SetRange("Break 4", "Break 4");
                            SetRange("Break 5", "Break 5");
                            SetRange("Break 6", "Break 6");
                            SetRange("Break 7", "Break 7");
                        end;
                    9:
                        begin
                            SetRange("Break 1", "Break 1");
                            SetRange("Break 2", "Break 2");
                            SetRange("Break 3", "Break 3");
                            SetRange("Break 4", "Break 4");
                            SetRange("Break 5", "Break 5");
                            SetRange("Break 6", "Break 6");
                            SetRange("Break 7", "Break 7");
                            SetRange("Break 8", "Break 8");
                        end;
                    10:
                        begin
                            SetRange("Break 1", "Break 1");
                            SetRange("Break 2", "Break 2");
                            SetRange("Break 3", "Break 3");
                            SetRange("Break 4", "Break 4");
                            SetRange("Break 5", "Break 5");
                            SetRange("Break 6", "Break 6");
                            SetRange("Break 7", "Break 7");
                            SetRange("Break 8", "Break 8");
                            SetRange("Break 9", "Break 9");
                        end;
                    11:
                        begin
                            SetRange("Break 1", "Break 1");
                            SetRange("Break 2", "Break 2");
                            SetRange("Break 3", "Break 3");
                            SetRange("Break 4", "Break 4");
                            SetRange("Break 5", "Break 5");
                            SetRange("Break 6", "Break 6");
                            SetRange("Break 7", "Break 7");
                            SetRange("Break 8", "Break 8");
                            SetRange("Break 9", "Break 9");
                            SetRange("Break 10", "Break 10");
                        end;
                end;
                if not IsEmpty then begin
                    FindFirst;
                    repeat
                        if not Ouverture then begin
                            Open := false;
                            Modify;
                            Mark(false);
                        end else
                            Mark(true);
                    until Next = 0;
                    FindFirst;
                end;
                Commit;
                SetRange("Break 1");
                SetRange("Break 2");
                SetRange("Break 3");
                SetRange("Break 4");
                SetRange("Break 5");
                SetRange("Break 6");
                SetRange("Break 7");
                SetRange("Break 8");
                SetRange("Break 9");
                SetRange("Break 10");
                SetRange("Section level");
                MarkedOnly(true);
                if (Ouverture) and Find('<') then;
                CurrPage.Update(false);
            end;
    end;

    [Scope('OnPrem')]
    procedure wColor() Col: Integer
    begin
        case "Section level" of
            2:
                Col := 1;
            3:
                Col := 8388608;
            4:
                Col := 500000000;
            5:
                Col := 82000000;
            6:
                Col := 16000000;
            7:
                Col := 8410000;
        end;
    end;

    [Scope('OnPrem')]
    procedure wForward()
    var
        LignesStatistiquesTemp: Record "Statistic array line";
        ColonnesStatistiquesTemp: Record "Statistic array column";
        ResultatsStatistiquesTemp: Record "Statistic cell";
        DefinitionStatistiquesTemp: Record "Statistic definition";
        LignesStatistiquesTemp2: Record "Statistic array line";
        ColonnesStatistiquesTemp2: Record "Statistic array column";
        ResultatsStatistiquesTemp2: Record "Statistic cell";
        DefinitionStatistiquesTemp2: Record "Statistic definition";
    begin
        // Other users
        /*
        IF Users."User ID" <> USERID THEN BEGIN
        
               LignesStatistiquesTemp.SETRANGE("Statistic code",CodeStatistique);
               LignesStatistiquesTemp.SETRANGE("User ID",USERID);
        
               IF NOT LignesStatistiquesTemp.ISEMPTY THEN BEGIN
                  LignesStatistiquesTemp.FINDFIRST;
                  LignesStatistiquesTemp2.SETRANGE("Statistic code",CodeStatistique);
                  LignesStatistiquesTemp2.SETRANGE("User ID",Users."User ID");
                  LignesStatistiquesTemp2.DELETEALL;
                  REPEAT
                   LignesStatistiquesTemp2.RESET;
                   LignesStatistiquesTemp2.INIT;
                   LignesStatistiquesTemp2 := LignesStatistiquesTemp;
                   LignesStatistiquesTemp2."User ID" := Users."User ID";
                   LignesStatistiquesTemp2.INSERT;
                  UNTIL LignesStatistiquesTemp.NEXT = 0;
               END;
        
               ColonnesStatistiquesTemp.SETRANGE("Statistic code",CodeStatistique);
               ColonnesStatistiquesTemp.SETRANGE("User ID",USERID);
               IF NOT ColonnesStatistiquesTemp.ISEMPTY THEN BEGIN
                  ColonnesStatistiquesTemp.FINDFIRST;
                  ColonnesStatistiquesTemp2.SETRANGE("Statistic code",CodeStatistique);
                  ColonnesStatistiquesTemp2.SETRANGE("User ID",Users."User ID");
                  ColonnesStatistiquesTemp2.DELETEALL;
                  REPEAT
                   ColonnesStatistiquesTemp2.RESET;
                   ColonnesStatistiquesTemp2.INIT;
                   ColonnesStatistiquesTemp2 := ColonnesStatistiquesTemp;
                   ColonnesStatistiquesTemp2."User ID" := Users."User ID";
                   ColonnesStatistiquesTemp2.INSERT;
                  UNTIL ColonnesStatistiquesTemp.NEXT = 0;
               END;
        
               ResultatsStatistiquesTemp.SETRANGE("Statistic code",CodeStatistique);
               ResultatsStatistiquesTemp.SETRANGE("User ID",USERID);
               IF NOT ResultatsStatistiquesTemp.ISEMPTY THEN BEGIN
                  ResultatsStatistiquesTemp.FINDFIRST;
                  ResultatsStatistiquesTemp2.SETRANGE("Statistic code",CodeStatistique);
                  ResultatsStatistiquesTemp2.SETRANGE("User ID",Users."User ID");
                  ResultatsStatistiquesTemp2.DELETEALL;
                  REPEAT
                   ResultatsStatistiquesTemp2.RESET;
                   ResultatsStatistiquesTemp2.INIT;
                   ResultatsStatistiquesTemp2 := ResultatsStatistiquesTemp;
                   ResultatsStatistiquesTemp2."User ID" := Users."User ID";
                   ResultatsStatistiquesTemp2.INSERT;
                  UNTIL ResultatsStatistiquesTemp.NEXT = 0;
               END;
        
               DefinitionStatistiquesTemp.SETRANGE("Statistic code",CodeStatistique);
               DefinitionStatistiquesTemp.SETRANGE("User ID",USERID);
               IF NOT DefinitionStatistiquesTemp.ISEMPTY THEN BEGIN
                  DefinitionStatistiquesTemp.FINDFIRST;
                  DefinitionStatistiquesTemp2.SETRANGE("Statistic code",CodeStatistique);
                  DefinitionStatistiquesTemp2.SETRANGE("User ID",Users."User ID");
                  DefinitionStatistiquesTemp2.DELETEALL;
                  REPEAT
                   DefinitionStatistiquesTemp2.RESET;
                   DefinitionStatistiquesTemp2.INIT;
                   DefinitionStatistiquesTemp2 := DefinitionStatistiquesTemp;
                   DefinitionStatistiquesTemp2."User ID" := Users."User ID";
                   DefinitionStatistiquesTemp2.INSERT;
                  UNTIL DefinitionStatistiquesTemp.NEXT = 0;
               END;
        END;
        */

    end;

    [Scope('OnPrem')]
    procedure "-----"()
    begin
    end;

    [Scope('OnPrem')]
    procedure SetColumns(SetWanted: Option Initial,Previous,Same,Next)
    var
        MatrixMgt: Codeunit "Matrix Management";
        CaptionFieldNo: Integer;
        CurrentMatrixRecordOrdinal: Integer;
    begin
        Clear(MATRIX_CaptionSet);
        Clear(MatrixRecords);
        CurrentMatrixRecordOrdinal := 1;

        MatrixRecord.SetRange("Statistic code", CodeStatistique);
        MatrixRecord.SetRange("User ID", UserId);
        if MatrixRecord.FindFirst then;

        MatrixRecordRef.GetTable(MatrixRecord);
        MatrixRecordRef.SetTable(MatrixRecord);

        CaptionFieldNo := MatrixRecord.FieldNo("Column title");


        MatrixMgt.GenerateMatrixData(MatrixRecordRef, SetWanted, ArrayLen(MatrixRecords), CaptionFieldNo, MATRIX_PKFirstRecInCurrSet,
          MATRIX_CaptionSet, MATRIX_CaptionRange, MATRIX_CurrSetLength);

        if MATRIX_CurrSetLength > 0 then begin
            MatrixRecord.SetPosition(MATRIX_PKFirstRecInCurrSet);
            MatrixRecord.Find;
            repeat
                MatrixRecords[CurrentMatrixRecordOrdinal].Copy(MatrixRecord);
                CurrentMatrixRecordOrdinal := CurrentMatrixRecordOrdinal + 1;
            until (CurrentMatrixRecordOrdinal > MATRIX_CurrSetLength) or (MatrixRecord.Next <> 1);
        end;
    end;

    [Scope('OnPrem')]
    procedure FORM_OnAfterGetRecord()
    var
        lIndex: Integer;
    begin
        fSetFilter();
        lIndex := 0;
        Clear(MATRIX_CellData);
        MatrixRecord.SetPosition(MATRIX_PKFirstRecInCurrSet);
        if MatrixRecord.Find then
            repeat
                lIndex += 1;
                MATRIX_OnAfterGetRecord(lIndex);
            until (MatrixRecord.Next() = 0) or (lIndex = MATRIX_CurrSetLength);
    end;

    local procedure MATRIX_OnAfterGetRecord(ColumnID: Integer)
    var
        lStatArrayLine: Record "Statistic array line";
    begin
        lStatArrayLine.Copy(Rec);
        lStatArrayLine.SetRange("Column no. filter", MatrixRecord."Colonne No. pos.");
        lStatArrayLine.CalcFields(Result);
        MATRIX_CellData[ColumnID] := fSetFormatValue(lStatArrayLine.Result, ColumnID);
        SetVisible;
    end;

    [Scope('OnPrem')]
    procedure SetVisible()
    var
        lVisible: Boolean;
    begin

        lVisible := MATRIX_CaptionSet[1] <> '';
        Field1Visible := lVisible;
        lVisible := MATRIX_CaptionSet[2] <> '';
        Field2Visible := lVisible;
        lVisible := MATRIX_CaptionSet[3] <> '';
        Field3Visible := lVisible;
        lVisible := MATRIX_CaptionSet[4] <> '';
        Field4Visible := lVisible;
        lVisible := MATRIX_CaptionSet[5] <> '';
        Field5Visible := lVisible;
        lVisible := MATRIX_CaptionSet[6] <> '';
        Field6Visible := lVisible;
        lVisible := MATRIX_CaptionSet[7] <> '';
        Field7Visible := lVisible;
        lVisible := MATRIX_CaptionSet[8] <> '';
        Field8Visible := lVisible;
        lVisible := MATRIX_CaptionSet[9] <> '';
        Field9Visible := lVisible;
        lVisible := MATRIX_CaptionSet[10] <> '';
        Field10Visible := lVisible;
        lVisible := MATRIX_CaptionSet[11] <> '';
        Field11Visible := lVisible;
        lVisible := MATRIX_CaptionSet[12] <> '';
        Field12Visible := lVisible;
        lVisible := MATRIX_CaptionSet[13] <> '';
        Field13Visible := lVisible;
        lVisible := MATRIX_CaptionSet[14] <> '';
        Field14Visible := lVisible;
        lVisible := MATRIX_CaptionSet[15] <> '';
        Field15Visible := lVisible;
        lVisible := MATRIX_CaptionSet[16] <> '';
        Field16Visible := lVisible;
        lVisible := MATRIX_CaptionSet[17] <> '';
        Field17Visible := lVisible;
        lVisible := MATRIX_CaptionSet[18] <> '';
        Field18Visible := lVisible;
        lVisible := MATRIX_CaptionSet[19] <> '';
        Field19Visible := lVisible;
        lVisible := MATRIX_CaptionSet[20] <> '';
        Field20Visible := lVisible;
        lVisible := MATRIX_CaptionSet[21] <> '';
        Field21Visible := lVisible;
        lVisible := MATRIX_CaptionSet[22] <> '';
        Field22Visible := lVisible;
        lVisible := MATRIX_CaptionSet[23] <> '';
        Field23Visible := lVisible;
        lVisible := MATRIX_CaptionSet[24] <> '';
        Field24Visible := lVisible;
        lVisible := MATRIX_CaptionSet[25] <> '';
        Field25Visible := lVisible;
        lVisible := MATRIX_CaptionSet[26] <> '';
        Field26Visible := lVisible;
        lVisible := MATRIX_CaptionSet[27] <> '';
        Field27Visible := lVisible;
        lVisible := MATRIX_CaptionSet[28] <> '';
        Field28Visible := lVisible;
        lVisible := MATRIX_CaptionSet[29] <> '';
        Field29Visible := lVisible;
        lVisible := MATRIX_CaptionSet[30] <> '';
        Field30Visible := lVisible;
        lVisible := MATRIX_CaptionSet[31] <> '';
        Field31Visible := lVisible;
        lVisible := MATRIX_CaptionSet[32] <> '';
        Field32Visible := lVisible;
    end;

    [Scope('OnPrem')]
    procedure fSetFormatValue(pValue: Decimal; pColumnID: Integer) Retour: Text[80]
    begin
        Retour := '';
        if pValue <> 0 then begin
            case MatrixRecords[pColumnID]."Rounding Factor" of
                0:
                    Retour := CopyStr(Format(pValue, 0, FormatStringNormal), 1, MaxStrLen(Retour));
                1:
                    Retour := CopyStr(Format(Round(pValue, 1)), 1, MaxStrLen(Retour));
                2:
                    Retour := CopyStr(Format(Round(pValue / 1000, 0.1), 0, '<Precision,1><Standard Format,0>'), 1, MaxStrLen(Retour));
                3:
                    Retour := CopyStr(Format(Round(pValue / 1000000, 0.1), 0, '<Precision,1><Standard Format,0>'), 1, MaxStrLen(Retour));
                else
                    ;
            end;
        end;
    end;

    [Scope('OnPrem')]
    procedure MATRIX_OnFormat(pColumnID: Integer)
    var
        lFontBold: Boolean;
    begin
        lFontBold := ("Section level" <= 2);
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

    local procedure CodeStatistiqueOnAfterValidate()
    begin
        if not Definition.Get(UserId, CodeStatistique, 10000) then begin
            Message(Error1, CodeStatistique);
            CodeStatistique := xCodeStatistique;
        end else begin
            SetRange("Statistic code", CodeStatistique);
            fSetFilter();
            CurrPage.Update(false);
        end;
    end;

    local procedure CodeStatistiqueOnBeforeInput()
    begin
        xCodeStatistique := CodeStatistique;
    end;

    local procedure CodeOnFormat()
    var
        lLevel: Integer;
        lFontBold: Boolean;
    begin

        lLevel := "Section level";
        lFontBold := ("Section level" <= 2);
        CodeIndent := lLevel;
        CodeEmphasize := lFontBold;
    end;

    local procedure DescriptionOnFormat()
    var
        lLevel: Integer;
        lFontBold: Boolean;
    begin

        lLevel := "Section level";
        lFontBold := ("Section level" <= 2);
        DescriptionIndent := lLevel;
        DescriptionEmphasize := lFontBold;
    end;

    local procedure MATRIXCellData1OnFormat()
    begin
        MATRIX_OnFormat(1);
    end;

    local procedure MATRIXCellData2OnFormat()
    begin
        MATRIX_OnFormat(2);
    end;

    local procedure MATRIXCellData3OnFormat()
    begin
        MATRIX_OnFormat(3);
    end;

    local procedure MATRIXCellData4OnFormat()
    begin
        MATRIX_OnFormat(4);
    end;

    local procedure MATRIXCellData5OnFormat()
    begin
        MATRIX_OnFormat(5);
    end;

    local procedure MATRIXCellData6OnFormat()
    begin
        MATRIX_OnFormat(6);
    end;

    local procedure MATRIXCellData7OnFormat()
    begin
        MATRIX_OnFormat(7);
    end;

    local procedure MATRIXCellData8OnFormat()
    begin
        MATRIX_OnFormat(8);
    end;

    local procedure MATRIXCellData9OnFormat()
    begin
        MATRIX_OnFormat(9);
    end;

    local procedure MATRIXCellData10OnFormat()
    begin
        MATRIX_OnFormat(10);
    end;

    local procedure MATRIXCellData11OnFormat()
    begin
        MATRIX_OnFormat(11);
    end;

    local procedure MATRIXCellData12OnFormat()
    begin
        MATRIX_OnFormat(12);
    end;

    local procedure MATRIXCellData13OnFormat()
    begin
        MATRIX_OnFormat(13);
    end;

    local procedure MATRIXCellData14OnFormat()
    begin
        MATRIX_OnFormat(14);
    end;

    local procedure MATRIXCellData15OnFormat()
    begin
        MATRIX_OnFormat(15);
    end;

    local procedure MATRIXCellData16OnFormat()
    begin
        MATRIX_OnFormat(16);
    end;

    local procedure MATRIXCellData17OnFormat()
    begin
        MATRIX_OnFormat(17);
    end;

    local procedure MATRIXCellData18OnFormat()
    begin
        MATRIX_OnFormat(18);
    end;

    local procedure MATRIXCellData19OnFormat()
    begin
        MATRIX_OnFormat(19);
    end;

    local procedure MATRIXCellData20OnFormat()
    begin
        MATRIX_OnFormat(20);
    end;

    local procedure MATRIXCellData21OnFormat()
    begin
        MATRIX_OnFormat(21);
    end;

    local procedure MATRIXCellData22OnFormat()
    begin
        MATRIX_OnFormat(22);
    end;

    local procedure MATRIXCellData23OnFormat()
    begin
        MATRIX_OnFormat(23);
    end;

    local procedure MATRIXCellData24OnFormat()
    begin
        MATRIX_OnFormat(24);
    end;

    local procedure MATRIXCellData25OnFormat()
    begin
        MATRIX_OnFormat(25);
    end;

    local procedure MATRIXCellData26OnFormat()
    begin
        MATRIX_OnFormat(26);
    end;

    local procedure MATRIXCellData27OnFormat()
    begin
        MATRIX_OnFormat(27);
    end;

    local procedure MATRIXCellData28OnFormat()
    begin
        MATRIX_OnFormat(28);
    end;

    local procedure MATRIXCellData29OnFormat()
    begin
        MATRIX_OnFormat(29);
    end;

    local procedure MATRIXCellData30OnFormat()
    begin
        MATRIX_OnFormat(30);
    end;

    local procedure MATRIXCellData31OnFormat()
    begin
        MATRIX_OnFormat(31);
    end;

    local procedure MATRIXCellData32OnFormat()
    begin
        MATRIX_OnFormat(32);
    end;
}

