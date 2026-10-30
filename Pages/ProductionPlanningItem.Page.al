page 50091 "Production Planning Item"
{
    Caption = 'Production Forecast';
    DataCaptionExpression = ProductionForecastName;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPlus;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(PeriodType; PeriodType)
                {
                    Caption = 'View by';

                    trigger OnValidate()
                    begin
                        SetColumns(SetWanted::First);
                    end;
                }
                field(DateFilter; DateFilter)
                {
                    Caption = 'Date Filter';

                    trigger OnValidate()
                    begin
                        SetColumns(SetWanted::First);
                    end;
                }
            }
            part(Matrix; "Production Planning Matrix")
            {
            }
        }
        area(factboxes)
        {
            part(Control1000000001; "Item EC Factbox")
            {
                Provider = Matrix;
                SubPageLink = "No." = FIELD("No.");
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
                action("Copy Production Forecast")
                {
                    Caption = 'Copy Production Forecast';
                    Ellipsis = true;
                    RunObject = Report "Copy Production Forecast";
                }
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
                    SetColumns(SetWanted::Previous);
                end;
            }
            action("Previous Column")
            {
                Caption = 'Previous Column';
                Image = PreviousRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    SetColumns(SetWanted::PreviousColumn);
                end;
            }
            action("Next Column")
            {
                Caption = 'Next Column';
                Image = NextRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    SetColumns(SetWanted::NextColumn);
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
                    SetColumns(SetWanted::Next);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetColumns(SetWanted::First);
    end;

    var
        MatrixRecords: array[32] of Record Date;
        PeriodType: Enum "Analysis Period Type";
        QtyType: Option "Net Change","Balance at Date";
        ForecastType: Option "Sales Item",Component,Both;
        ProductionForecastName: Text[30];
        NewProductionForecastName: Text[30];
        LocationFilter: Text[30];
        DateFilter: Text[30];
        MatrixColumnCaptions: array[32] of Text[1024];
        ColumnSet: Text[1024];
        SetWanted: Option First,Previous,Same,Next,PreviousColumn,NextColumn;
        PKFirstRecInCurrSet: Text[100];
        CurrSetLength: Integer;
        ItemNoFilter: Code[20];

    [Scope('OnPrem')]
    procedure SetColumns(SetWanted: Option Initial,Previous,Same,Next,PreviousSet,NextSet)
    var
        MatrixMgt: Codeunit "Matrix Management";
    begin
        MatrixMgt.GeneratePeriodMatrixData(SetWanted, ArrayLen(MatrixRecords), false, PeriodType, DateFilter, PKFirstRecInCurrSet,
          MatrixColumnCaptions, ColumnSet, CurrSetLength, MatrixRecords);
        SetMatrix;
    end;

    [Scope('OnPrem')]
    procedure SetMatrix()
    begin
        CurrPage.Matrix.PAGE.
        Load(MatrixColumnCaptions, MatrixRecords, ItemNoFilter, DateFilter, LocationFilter, ForecastType, QtyType
          , CurrSetLength);
    end;

    [Scope('OnPrem')]
    procedure SetItemNo(No: Code[20])
    begin
        ItemNoFilter := No;
    end;
}

