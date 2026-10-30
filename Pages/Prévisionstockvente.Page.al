page 50079 "Prévision stock vente"
{
    Caption = 'Production Forecast';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPlus;
    UsageCategory = ReportsAndAnalysis;

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
                        CurrPage.Matrix.PAGE.Refresh();
                    end;
                }
                field(DateFilter; DateFilter)
                {
                    Caption = 'Date Filter';
                    Visible = false;

                    trigger OnValidate()
                    begin

                        SetColumns(SetWanted::First);
                    end;
                }
                field(ItemCategory; ItemCategory)
                {
                    Caption = 'Catégorie article';
                    TableRelation = "Item Category";

                    trigger OnValidate()
                    begin
                        CurrPage.Matrix.PAGE.SetCategory(ItemCategory);
                        SetColumns(SetWanted::First);
                        CurrPage.Matrix.PAGE.Refresh();
                    end;
                }
            }
            part(Matrix; "Vente Planning Matrix")
            {
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
        ItemCategory := '1-PFI-IQF';
        CurrPage.Matrix.PAGE.SetCategory(ItemCategory);

        SetColumns(SetWanted::First);
    end;

    var
        MatrixRecords: array[32] of Record Date;
        PeriodType: Enum "Analysis Period Type";
        DateFilter: Text[30];
        MatrixColumnCaptions: array[32] of Text[1024];
        ColumnSet: Text[1024];
        SetWanted: Option First,Previous,Same,Next,PreviousColumn,NextColumn;
        PKFirstRecInCurrSet: Text[100];
        CurrSetLength: Integer;
        ItemCategory: Code[20];

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
        Load(MatrixColumnCaptions, MatrixRecords, '', DateFilter, '', 0, 0
          , CurrSetLength);
    end;
}

