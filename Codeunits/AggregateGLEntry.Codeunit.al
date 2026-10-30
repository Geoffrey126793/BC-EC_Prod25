codeunit 8001310 "Aggregate, G/L Entry"
{
    // //STATSEXPLORER STATSEXPLORER 01/10/01 Aggregate, G/L Entry


    trigger OnRun()
    begin
        if GuiAllowed then Window.Open('#1############################## #2##### -> #3#####');
        if GuiAllowed then Window.Update(1, Entry.TableCaption);

        StatisticAggregate1.Reset;
        StatisticsSetup.Get;
        StatsExplorerTools.CreateTypeArray(TextType, WorkType, SearchDim, PeriodBasis, LastEntryNo);

        if StatisticAggregate1.Find('+') then
            NextEntry := StatisticAggregate1."Entry No." + 1
        else
            NextEntry := 1;

        if WorkType[67] then
            if EntryNo = 0 then
                SearchEntry
            else begin
                if StatisticsSetup."Period total basis" <> StatisticsSetup."Period total basis"::"According to every flow" then begin
                    BasePeriod := StatisticsSetup."Period total basis";
                    SearchEntry;
                end else begin
                    repeat
                        i := i + 1;
                        if PeriodBasis[67, i] then begin
                            BasePeriod := i - 1;
                            SearchEntry;
                        end;
                    until i = 5;
                end;
            end;

        if GuiAllowed then Window.Close;
    end;

    var
        StatisticAggregate1: Record "Statistic aggregate";
        StatisticAggregate2: Record "Statistic aggregate";
        Entry: Record "G/L Entry";
        "Code": Record "Code";
        StatisticsSetup: Record "Statistics setup";
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
            Entry.SetCurrentKey("G/L Account No.", "Business Unit Code", "Global Dimension 1 Code",
                                "Global Dimension 2 Code", "Close Income Statement Dim. ID", "Posting Date");
            Entry.SetRange("Posting Date", StartDate, EndDate);
        end else begin
            Entry.SetCurrentKey("Entry No.");
            Entry.SetRange("Entry No.", EntryNo);
        end;
    end;

    [Scope('OnPrem')]
    procedure SearchEntry()
    var
        StartD: Date;
        EndD: Date;
        Result: array[20] of Decimal;
    begin
        InitEntry;
        if Entry.Find('-') then
            with Entry do
                repeat
                    NbRead := NbRead + 1;
                    if GuiAllowed then Window.Update(2, NbRead);
                    StartD := StatsExplorerTools.StartDateCalc(BasePeriod, "Posting Date");
                    EndD := StatsExplorerTools.EndDateCalc(BasePeriod, "Posting Date");
                    if (Quantity <> 0) or (Amount <> 0) or ("Additional-Currency Amount" <> 0) then begin
                        StatisticAggregate1.Init;
                        StatisticAggregate1."Entry No." := NextEntry;
                        StatisticAggregate1."Period Length" := BasePeriod;
                        StatisticAggregate1."Ending Date" := EndD;
                        StatisticAggregate1."Entry Type" := TextType[67];
                        StatisticAggregate1.Type := StatisticAggregate1.Type::"Account (G/L)";
                        StatisticAggregate1."No." := Format("G/L Account No.");
                        StatisticAggregate1."Business Unit Code" := "Business Unit Code";
                        StatisticAggregate1."Global Dimension 1 Code" := "Global Dimension 1 Code";
                        StatisticAggregate1."Global Dimension 2 Code" := "Global Dimension 2 Code";
                        StatisticAggregate1.Quantity := Quantity;
                        StatisticAggregate1.Amount := Amount;
                        StatisticAggregate1."Free value 2" := Amount;
                        StatisticAggregate1.Cost := "Additional-Currency Amount";
                        if SearchDim[67] then
                            StatsExplorerTools.SearchLedgerEntryDimension(StatisticAggregate1, 17, "Entry No.");
                        UpdateDefaultValues.Run(StatisticAggregate1);
                        if not StatsExplorerTools.SearchAndModifyAggregate(StatisticAggregate1, StatisticAggregate2, SearchDim[67], 67) then begin
                            StatisticAggregate1.Insert;
                            NextEntry := NextEntry + 1;
                            NbCreated := NbCreated + 1;
                        end;
                        if GuiAllowed then Window.Update(3, NbCreated);
                    end;
                until Next = 0;
    end;
}

