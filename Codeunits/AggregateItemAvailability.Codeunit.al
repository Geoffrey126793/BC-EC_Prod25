codeunit 8001317 "Aggregate, Item Availability"
{
    // //STATSEXPLORER STATSEXPLORER 01/01/00 Calcul de la table de cumuls statistiques, situation du stock par article et magasin


    trigger OnRun()
    begin
        StatsExplorerTools.CreateTypeArray(TextType, WorkType, SearchDim, PeriodBasis, LastEntryNo);

        if GuiAllowed then Window.Open('#1###################### #2##### #3##### #4##### #5##### -> #6#####');
        if GuiAllowed then Window.Update(1, TextType[39]);

        StatisticAggregate1.Reset;
        if StatisticAggregate1.Find('+') then
            NextEntry := StatisticAggregate1."Entry No." + 1
        else
            NextEntry := 1;

        Ecart := 0;
        DateF1 := StartDate;
        //BasePeriod := 2;

        repeat
            if BasePeriod = 0 then
                FormuleCalc := StrSubstNo('+%1%2', Ecart, CopyStr(StatsExplorerTools.ConvertDateFormula(BasePeriod), 2, 1))
            else
                FormuleCalc := StrSubstNo('+%1%2', Ecart, CopyStr(StatsExplorerTools.ConvertDateFormula(BasePeriod + 1), 2, 1));
            if Ecart > 0 then
                DateF1 := CalcDate(FormuleCalc, StartDate);
            Ecart := Ecart + 1;
            DateD1 := StatsExplorerTools.StartDateCalc(BasePeriod, DateF1);
            DateF1 := StatsExplorerTools.EndDateCalc(BasePeriod, DateF1);
            if GuiAllowed then Window.Update(2, DateF1);
            if Magasin.Find('-') then
                repeat
                    if GuiAllowed then Window.Update(3, Magasin.Code);
                    RechercheEcr;
                until Magasin.Next = 0;
        until DateF1 = EndDate;

        if GuiAllowed then Window.Close;
    end;

    var
        StatisticAggregate1: Record "Statistic aggregate";
        StatisticAggregate2: Record "Statistic aggregate";
        "Object": Record "Object";
        Ecriture: Record Item;
        Magasin: Record Location;
        "Code": Record "Code";
        UpdateDefaultValues: Codeunit "Aggr., Update default values";
        Window: Dialog;
        StartDate: Date;
        EndDate: Date;
        PeriodBasis: array[100, 6] of Boolean;
        BasePeriod: Option Jour,Semaine,Mois,Trimestre,"AnnÔÇÜe";
        TextType: array[100] of Text[30];
        WorkType: array[100] of Boolean;
        SearchDim: array[100] of Boolean;
        FieldEnabled: array[100, 250] of Boolean;
        NextEntry: Integer;
        NbRead: Integer;
        NbCreated: Integer;
        FiltreType: Text[250];
        Ecart: Integer;
        DateF1: Date;
        DateD1: Date;
        StatsExplorerTools: Codeunit "StatsExplorer, Tools";
        FormuleCalc: Text[30];
        LastEntryNo: array[100] of Integer;

    [Scope('OnPrem')]
    procedure InitRequete(wStartDate: Date; wEndDate: Date; wBasePeriod: Option Day,Week,Month,Quarter,Year,Period)
    begin
        StartDate := wStartDate;
        EndDate := wEndDate;
        BasePeriod := wBasePeriod;
    end;

    [Scope('OnPrem')]
    procedure InitEcriture()
    begin
        Ecriture.Reset;
    end;

    [Scope('OnPrem')]
    procedure RechercheEcr()
    var
        ArretTraitement: Boolean;
        DateD: Date;
        DateF: Date;
        i: Integer;
    begin
        ArretTraitement := false;
        with Ecriture do begin
            InitEcriture;

            if Find('-') then begin
                repeat
                    if GuiAllowed then Window.Update(4, "No.");
                    NbRead := NbRead + 1;
                    if GuiAllowed then Window.Update(5, NbRead);
                    SetRange("Location Filter", Magasin.Code);
                    DateF := DateF1;
                    SetRange("Date Filter", DateD1, DateF1);
                    CalcFields("Net Change");

                    if "Net Change" <> 0 then begin
                        StatisticAggregate1.Init;
                        StatisticAggregate1."Entry No." := NextEntry;
                        StatisticAggregate1."Period Length" := BasePeriod;
                        StatisticAggregate1."Ending Date" := DateF;
                        StatisticAggregate1."Entry Type" := TextType[39];
                        StatisticAggregate1.Type := StatisticAggregate1.Type::Item;
                        StatisticAggregate1."No." := "No.";
                        StatisticAggregate1."Location Code" := Magasin.Code;
                        StatisticAggregate1.Quantity := "Net Change";
                        StatisticAggregate1.Amount := Round("Net Change" * "Unit Price");
                        StatisticAggregate1.Cost := Round("Net Change" * Ecriture."Unit Cost");
                        UpdateDefaultValues.Run(StatisticAggregate1);
                        if not StatsExplorerTools.SearchAndModifyAggregate(StatisticAggregate1, StatisticAggregate2, SearchDim[39], 39) then begin
                            StatisticAggregate1.Insert;
                            NextEntry := NextEntry + 1;
                            NbCreated := NbCreated + 1;
                        end;
                        if GuiAllowed then Window.Update(6, NbCreated);
                    end;

                    InitEcriture;
                    if not Find('>') then
                        ArretTraitement := true;
                until ArretTraitement = true;
            end;
        end;
    end;
}

