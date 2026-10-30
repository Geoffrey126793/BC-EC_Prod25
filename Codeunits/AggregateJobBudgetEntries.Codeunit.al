codeunit 8001304 "Aggregate, Job Budget Entries"
{
    // //STATSEXPLORER STATSEXPLORER 01/10/01 Statistic Aggregates Job Budget Entries
    // //NAVIBAT_STATS NAVIBAT 07/12/02 1 new field : "Gen. Expenses Amount"


    trigger OnRun()
    begin
    end;

    var
        StatisticAggregate1: Record "Statistic aggregate";
        StatisticAggregate2: Record "Statistic aggregate";
        "Code": Record "Code";
        StatsExplorerTools: Codeunit "StatsExplorer, Tools";
        UpdateDefaultValues: Codeunit "Aggr., Update default values";
        Window: Dialog;
        TextType: array[100] of Text[30];
        WorkType: array[100] of Boolean;
        PeriodBasis: array[100, 6] of Boolean;
        StartDate: Date;
        EndDate: Date;
        BasePeriod: Option Day,Week,Month,Quarter,Year,Period;
        SearchDim: array[100] of Boolean;
        FieldEnabled: array[100, 250] of Boolean;
        NbRead: Integer;
        NbCreated: Integer;
        NextEntry: Integer;
        LastEntryNo: array[100] of Integer;

    [Scope('OnPrem')]
    procedure InitRequest(wStartDate: Date; wEndDate: Date; wBasePeriod: Option Day,Week,Month,Quarter,Year,Period)
    begin
        StartDate := wStartDate;
        EndDate := wEndDate;
        BasePeriod := wBasePeriod;
    end;

    [Scope('OnPrem')]
    procedure InitEntry()
    begin
    end;

    [Scope('OnPrem')]
    procedure Treatment()
    var
        StartD: Date;
        EndD: Date;
        i: Integer;
        Result: array[20] of Decimal;
    begin
    end;
}

