codeunit 8001319 "Aggr., Prod. Forecast Entries"
{
    // //STATSEXPLORER STATSEXPLORER 01/06/03 Process Aggregates, Production Forecast Entry


    trigger OnRun()
    begin
        if GuiAllowed then Window.Open('#1############################## #2##### -> #3#####');
        if GuiAllowed then Window.Update(1, Entry.TableCaption);

        StatisticsSetup.Get;

        StatisticAggregate1.SetCurrentKey("Entry Type", "Ending Date");
        StatisticAggregate1.SetRange("Period Length", BasePeriod);
        StatisticAggregate1.SetRange("Ending Date", StartDate, EndDate);

        StatsExplorerTools.CreateTypeArray(TextType, WorkType, SearchDim, PeriodBasis, LastEntryNo);

        StatisticAggregate2.SetCurrentKey("Period Length", "Ending Date", "Entry Type", Type, "No.", "Source Type", "Source No."
        , "Location Code", "Inventory Posting Group", "Source Posting Group", "Gen. Bus. Posting Group", "Gen. Prod. Posting Group",
        "Salespers./Purch. Code", "Global Dimension 1 Code", "Global Dimension 2 Code", "Country Code", "Business Unit Code");

        StatisticAggregate1.SetCurrentKey("Entry No.");
        StatisticAggregate1.Reset;
        if StatisticAggregate1.Find('+') then
            NextEntry := StatisticAggregate1."Entry No." + 1
        else
            NextEntry := 1;

        TypeFilter := '';
        if WorkType[82] then
            TypeFilter := '0';

        if WorkType[83] then
            if TypeFilter <> '' then
                TypeFilter := TypeFilter + '|1'
            else
                TypeFilter := '1';

        if TypeFilter <> '' then
            if EntryNo = 0 then
                SearchEntry
            else begin
                if StatisticsSetup."Period total basis" <> StatisticsSetup."Period total basis"::"According to every flow" then begin
                    BasePeriod := StatisticsSetup."Period total basis";
                    SearchEntry;
                end else begin
                    repeat
                        i := i + 1;
                        if PeriodBasis[82, i] or PeriodBasis[83, i] then begin
                            BasePeriod := i - 1;
                            SearchEntry;
                        end;
                    until i = 5;
                end;
            end;

        if GuiAllowed then Window.Close;
    end;

    var
        "Object": Record "Object";
        StatisticAggregate1: Record "Statistic aggregate";
        StatisticAggregate2: Record "Statistic aggregate";
        Entry: Record "Production Forecast Entry";
        "Code": Record "Code";
        StatisticsSetup: Record "Statistics setup";
        UpdateDefaultValues: Codeunit "Aggr., Update default values";
        StatsExplorerTools: Codeunit "StatsExplorer, Tools";
        Window: Dialog;
        StartDate: Date;
        EndDate: Date;
        BasePeriod: Option Day,Week,Month,Quarter,Year,Period;
        TextType: array[100] of Text[30];
        FieldEnabled: array[100, 250] of Boolean;
        WorkType: array[100] of Boolean;
        PeriodBasis: array[100, 6] of Boolean;
        SearchDim: array[100] of Boolean;
        NbRead: Integer;
        NbCreated: Integer;
        NextEntry: Integer;
        TypeFilter: Text[250];
        SearchDimensions: Boolean;
        EntryNo: Integer;
        LastEntryNo: array[100] of Integer;
        i: Integer;

    [Scope('OnPrem')]
    procedure InitRequest(wStartDate: Date; wEndDate: Date; wBasePeriod: Option Day,Week,Month,Quarter,Year,Period; wEntryNo: Integer)
    begin
        StartDate := wStartDate;
        EndDate := wEndDate;
        BasePeriod := wBasePeriod;
        EntryNo := wEntryNo;
    end;

    [Scope('OnPrem')]
    procedure InitEntry()
    begin
        Entry.Reset;
        if EntryNo = 0 then begin
            Entry.SetCurrentKey("Production Forecast Name", "Item No.", "Component Forecast", "Forecast Date", "Location Code");
            Entry.SetRange("Forecast Date", StartDate, EndDate);
        end else begin
            Entry.SetCurrentKey("Entry No.");
            Entry.SetRange("Entry No.", EntryNo);
        end;
        Entry.SetFilter("Component Forecast", TypeFilter);
    end;

    [Scope('OnPrem')]
    procedure SearchEntry()
    var
        SDate: Date;
        EDate: Date;
        i: Integer;
        Result: array[20] of Decimal;
        NoType: Integer;
    begin
        with Entry do begin
            InitEntry;

            if Find('-') then
                repeat
                    NbRead := NbRead + 1;
                    if GuiAllowed then Window.Update(2, NbRead);
                    SDate := StatsExplorerTools.StartDateCalc(BasePeriod, "Forecast Date");
                    EDate := StatsExplorerTools.EndDateCalc(BasePeriod, "Forecast Date");
                    StatisticAggregate1.Init;
                    StatisticAggregate1."Entry No." := NextEntry;
                    StatisticAggregate1."Period Length" := BasePeriod;
                    StatisticAggregate1."Ending Date" := EDate;
                    case "Component Forecast" of
                        false:
                            NoType := 82;
                        true:
                            NoType := 83;
                    end;
                    StatisticAggregate1."Entry Type" := TextType[NoType];
                    StatisticAggregate1.Type := StatisticAggregate1.Type::Item;
                    StatisticAggregate1."No." := "Item No.";
                    StatisticAggregate1."Source Type" := StatisticAggregate1."Source Type"::Budget;
                    StatisticAggregate1."Source No." := "Production Forecast Name";
                    StatisticAggregate1."Location Code" := "Location Code";
                    StatisticAggregate1.Quantity := "Forecast Quantity (Base)";
                    if (SearchDim[NoType]) then begin
                        StatsExplorerTools.SearchDefaultDimension(StatisticAggregate1, 27, "Item No.");
                        SearchDimensions := true;
                    end;
                    UpdateDefaultValues.Run(StatisticAggregate1);
                    if not StatsExplorerTools.SearchAndModifyAggregate(StatisticAggregate1, StatisticAggregate2, SearchDimensions, NoType) then begin
                        StatisticAggregate1.Insert;
                        NextEntry := NextEntry + 1;
                        NbCreated := NbCreated + 1;
                    end;
                    if GuiAllowed then Window.Update(3, NbCreated);
                until Next = 0;
        end;
    end;
}

