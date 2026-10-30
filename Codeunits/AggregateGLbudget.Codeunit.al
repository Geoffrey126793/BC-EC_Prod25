codeunit 8001315 "Aggregate, G/L budget"
{
    // //STATSEXPLORER STATSEXPLORER 01/10/00 Aggregate, G/L budget


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
        Entry: Record "G/L Budget Entry";
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
        Entry.SetCurrentKey("Budget Name", "G/L Account No.", "Business Unit Code", "Global Dimension 1 Code", "Global Dimension 2 Code");
        Entry.SetRange(Date, StartDate, EndDate);
    end;

    [Scope('OnPrem')]
    procedure Treatment()
    var
        StartD: Date;
        EndD: Date;
        Result: array[20] of Decimal;
    begin
        InitEntry;

        if Entry.Find('-') then
            with Entry do
                repeat
                    StartD := StatsExplorerTools.StartDateCalc(BasePeriod, Date);
                    EndD := StatsExplorerTools.EndDateCalc(BasePeriod, Date);
                    NbRead := NbRead + 1;
                    if GuiAllowed then Window.Update(2, NbRead);
                    if Amount <> 0 then begin
                        StatisticAggregate1.Init;
                        StatisticAggregate1."Entry No." := NextEntry;
                        StatisticAggregate1."Period Length" := BasePeriod;
                        StatisticAggregate1."Ending Date" := EndD;
                        StatisticAggregate1."Entry Type" := TextType[66];
                        StatisticAggregate1.Type := StatisticAggregate1.Type::"Account (G/L)";
                        StatisticAggregate1."No." := Format("G/L Account No.");
                        StatisticAggregate1."Source Type" := StatisticAggregate1."Source Type"::Budget;
                        StatisticAggregate1."Source No." := "Budget Name";
                        StatisticAggregate1."Business Unit Code" := "Business Unit Code";
                        StatisticAggregate1."Global Dimension 1 Code" := "Global Dimension 1 Code";
                        StatisticAggregate1."Global Dimension 2 Code" := "Global Dimension 2 Code";
                        StatisticAggregate1.Amount := Amount;
                        if SearchDim[66] then
                            StatsExplorerTools.SearchGLBudgetDimension(StatisticAggregate1, "Entry No.");
                        UpdateDefaultValues.Run(StatisticAggregate1);
                        if not StatsExplorerTools.SearchAndModifyAggregate(StatisticAggregate1, StatisticAggregate2, SearchDim[66], 66) then begin
                            StatisticAggregate1.Insert;
                            NextEntry := NextEntry + 1;
                            NbCreated := NbCreated + 1;
                        end;
                        if GuiAllowed then Window.Update(3, NbCreated);
                    end;
                until Next = 0;
    end;
}

