codeunit 8001314 "Aggregate, Employee Absence"
{
    // //STATSEXPLORER STATSEXPLORER 01/10/01 Aggregate, Employee Absence


    trigger OnRun()
    begin
        if GuiAllowed then Window.Open('#1############################## #2##### -> #3#####');
        if GuiAllowed then Window.Update(1, Entry.TableCaption);

        StatsExplorerTools.CreateTypeArray(TextType, WorkType, SearchDim, PeriodBasis, LastEntryNo);

        StatisticAggregate1.Reset;

        if StatisticAggregate1.Find('+') then
            NextEntry := StatisticAggregate1."Entry No." + 1
        else
            NextEntry := 1;

        Treatment;
        if GuiAllowed then Window.Close;
    end;

    var
        StatisticAggregate1: Record "Statistic aggregate";
        StatisticAggregate2: Record "Statistic aggregate";
        "Object": Record "Object";
        Entry: Record "Employee Absence";
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
        Entry.Reset;
        Entry.SetCurrentKey("Employee No.", "Cause of Absence Code", "From Date");
        Entry.SetRange("From Date", StartDate, EndDate);
    end;

    [Scope('OnPrem')]
    procedure Treatment()
    var
        StartD: Date;
        EndD: Date;
        i: Integer;
        Result: array[20] of Decimal;
    begin

        InitEntry;
        if Entry.Find('-') then
            with Entry do
                repeat
                    NbRead := NbRead + 1;
                    if GuiAllowed then Window.Update(2, NbRead);
                    StartD := StatsExplorerTools.StartDateCalc(BasePeriod, "From Date");
                    EndD := StatsExplorerTools.EndDateCalc(BasePeriod, "From Date");
                    if (Quantity <> 0) then begin
                        StatisticAggregate1.Init;
                        StatisticAggregate1."Entry No." := NextEntry;
                        StatisticAggregate1."Period Length" := BasePeriod;
                        StatisticAggregate1."Ending Date" := EndD;
                        StatisticAggregate1."Entry Type" := TextType[52];
                        StatisticAggregate1.Type := StatisticAggregate1.Type::Employee;
                        StatisticAggregate1."No." := "Employee No.";
                        StatisticAggregate1."Reason Code" := "Cause of Absence Code";
                        StatisticAggregate1.Quantity := Quantity;
                        //      IF SearchDim[52] THEN
                        //         StatsExplorerTools.SearchLedgerEntryDimension(StatisticAggregate1,xxx,"Entry No.");
                        UpdateDefaultValues.Run(StatisticAggregate1);
                        if not StatsExplorerTools.SearchAndModifyAggregate(StatisticAggregate1, StatisticAggregate2, SearchDim[52], 52) then begin
                            StatisticAggregate1.Insert;
                            NextEntry := NextEntry + 1;
                            NbCreated := NbCreated + 1;
                        end;
                        if GuiAllowed then Window.Update(3, NbCreated);
                    end;
                until Next = 0;
    end;
}

