codeunit 8001501 "Aggregate, Back Disc. Comm."
{
    // //+RFA+ GESWAY 11/07/02 Calcul des cumuls statistiques, R.F.A et commissions.
    // 
    // ------------------------------------------------------------------------------------------
    // ADV-001 ABSYS BT 20061102
    //    Ajout filtre sur les gratuits
    // ------------------------------------------------------------------------------------------


    trigger OnRun()
    begin
        // On reprend la sélection dans la table des paramètres (au lieu de InitRequete)
        StatisticsSetup.Get;
        StartDate := StatisticsSetup."Last calculation start date";
        EndDate := StatisticsSetup."Last calculation end date";
        PeriodeBasis := StatisticsSetup."Period total basis";

        Window.Open(Text001);
        Stats.SetCurrentKey("Entry Type", "Ending Date");
        Stats.SetRange("Period Length", PeriodeBasis);
        Stats.SetRange("Ending Date", StartDate, EndDate);
        CreerTableauType;
        Stats.SetCurrentKey("Entry Type", "Ending Date");
        Stats.SetFilter("Entry Type", '%1', '###*');
        Stats.DeleteAll;
        Stats.SetFilter("Entry Type", '%1|%2', TexteType[30], TexteType[32]);
        Stats.DeleteAll;
        Window.Close;

        Stats.SetFilter("Entry Type", '%1|%2', TexteType[5], TexteType[10]);
        TotalNumber := Stats.Count;

        if TotalNumber = 0 then
            exit;

        Stats.Reset;
        if Stats.Find('+') then
            NextNbr := Stats."Entry No." + 1
        else
            NextNbr := 1;

        RuleExitLoop := false;
        Rule.SetRange("Discount and comm. type", Rule."Discount and comm. type"::"Back discount");
        Rule.SetFilter("Starting Date", '<=%1', EndDate);
        Rule.SetFilter("Ending Date", '>=%1', StartDate);
        if Rule.Find('-') then begin
            Window.Open(Text009);
            FirstLoop := true;
            repeat
                Window.Update(1, Rule."No.");
                StatAgg.Reset;
                SetFilters(Rule);
                RechercheEcrStatRFA(Rule);
                case Rule."Continue calculation" of
                    Rule."Continue calculation"::Yes:
                        ;
                    else
                        RuleExitLoop := true;
                end;
            until (Rule.Next = 0) or RuleExitLoop;
        end;

        RuleExitLoop := false;
        Rule.SetRange("Discount and comm. type", Rule."Discount and comm. type"::Commission);
        Rule.SetFilter("Starting Date", '<=%1', EndDate);
        Rule.SetFilter("Ending Date", '>=%1', StartDate);
        if Rule.Find('-') then begin
            Window.Open(Text009);
            FirstLoop := true;
            repeat
                Window.Update(1, Rule."No.");
                StatAgg.Reset;
                SetFilters(Rule);
                RechercheEcrStatCom(Rule);
                case Rule."Continue calculation" of
                    Rule."Continue calculation"::Yes:
                        ;
                    else
                        RuleExitLoop := true;
                end;
            until (Rule.Next = 0) or RuleExitLoop;
        end;

        FusionRFACom;
    end;

    var
        StatisticsSetup: Record "Statistics setup";
        Stats: Record "Statistic aggregate";
        Stat2: Record "Statistic aggregate";
        Rule: Record "Discount Rule";
        StatAgg: Record "Statistic aggregate";
        RepriseValeurs: Codeunit "Aggr., Update default values";
        Tool: Codeunit "StatsExplorer, Tools";
        Window: Dialog;
        PeriodeBasis: Option Jour,Semaine,Mois,Trimestre,"Année";
        TexteType: array[100] of Text[30];
        NombreCree: Integer;
        NextNbr: Integer;
        Enr: Integer;
        TotalNumber: Integer;
        Text001: Label 'Delete ...';
        Text003: Label 'Field number is a maximum of 100';
        Text004: Label 'RFA Treatement #1##### @2@@@@@@@@@@';
        Text005: Label '###Provisional RFA###';
        Text006: Label 'Commissions Treatement #1##### @2@@@@@@@@@@';
        Text007: Label '###Com Provisional###';
        Text008: Label 'Merge R.F.A and commissions ... @1@@@@@@@@@@';
        RuleExitLoop: Boolean;
        Text009: Label 'Treatement RFA Rule #1####### @2@@@@@@@@@@';
        Text010: Label 'Treatement Commissions Rule #1####### @2@@@@@@@@@@';
        FirstLoop: Boolean;
        StartDate: Date;
        EndDate: Date;

    [Scope('OnPrem')]
    procedure InitRequete(wDateD: Date; wDateF: Date; BaseP: Option Jour,Semaine,Mois,Trimestre,"Année")
    begin
        StartDate := wDateD;
        EndDate := wDateF;
        PeriodeBasis := BaseP;
    end;

    [Scope('OnPrem')]
    procedure CreerTableauType()
    var
        CritereStat: Record "Statistic criteria";
    begin
        CritereStat.SetRange(CritereStat.Type, CritereStat.Type::Flow);
        if CritereStat.Find('-') then
            repeat
                if CritereStat."Field No." <= 100 then
                    TexteType[CritereStat."Field No."] := CritereStat."Field name"
                else
                    Error(Text003);
            until CritereStat.Next = 0;
    end;

    [Scope('OnPrem')]
    procedure RechercheEcrStatRFA(DiscRule: Record "Discount Rule")
    var
        CumulStat: Record "Statistic aggregate";
        CalculRFA: Codeunit "Calculate Disc. and Commission";
        DateD: Date;
        DateF: Date;
        Base: Decimal;
        Com: Decimal;
    begin
        FirstLoop := false;
        with StatAgg do begin
            SetFilter(Amount, DiscRule."Amount filter");
            TotalNumber := Count;
            Enr := 0;
            if Find('-') then begin
                repeat
                    Enr := Enr + 1;
                    Base := CalculRFA.BasisCalculation(DiscRule, Quantity, Quantity, Amount, Amount);
                    Com := CalculRFA.CalcAmountComBase(Base, Base, DiscRule.Coefficient, DiscRule.Coefficient, DiscRule,
                           0, 0, "Back discount total", 0, 0, "Back discount total");
                    //Ecrire dans la table cumul statistique
                    Stats.Init;
                    Stats := StatAgg;
                    if DiscRule.Type = DiscRule.Type::Sale then
                        Stats."Source Type" := Stats."Source Type"::Customer
                    else
                        Stats."Source Type" := Stats."Source Type"::Vendor;
                    Stats."Entry No." := NextNbr;
                    NextNbr := NextNbr + 1;
                    Stats."Entry Type" := Text005;
                    Stats."Back disc./commission rule No." := DiscRule."No.";
                    Stats.Quantity := Round(Base, 0.01);
                    Stats.Amount := Com;
                    Stats.Cost := Com;
                    Stats."Lines discount total" := 0;
                    Stats."Document discount total" := 0;
                    Stats."Back discount total" := 0;
                    Stats."Commissions total" := 0;
                    Stats.Insert;
                    NombreCree := NombreCree + 1;
                    Window.Update(2, Round(Enr / TotalNumber * 10000, 1));
                    "Back discount total" := "Back discount total" + Com;
                    Modify;
                until Next = 0;
            end;
        end;
    end;

    [Scope('OnPrem')]
    procedure RechercheEcrStatCom(DiscRule: Record "Discount Rule")
    var
        CumulStat: Record "Statistic aggregate";
        CalculRFA: Codeunit "Calculate Disc. and Commission";
        DateD: Date;
        DateF: Date;
        i: Integer;
        Base: Decimal;
        Com: Decimal;
    begin
        FirstLoop := false;
        with StatAgg do begin
            SetFilter(Amount, DiscRule."Amount filter");
            TotalNumber := Count;
            Enr := 0;
            if Find('-') then begin
                repeat
                    Enr := Enr + 1;
                    Base := CalculRFA.BasisCalculation(Rule, Quantity, Quantity, Amount, Amount);
                    Com := CalculRFA.CalcAmountComBase(Base, Base, DiscRule.Coefficient, DiscRule.Coefficient, DiscRule,
                           0, 0, "Back discount total", 0, 0, "Back discount total");
                    //Ecrire dans la table cumul statistique
                    Stats.Init;
                    Stats := StatAgg;
                    if DiscRule.Type = DiscRule.Type::Sale then
                        Stats."Source Type" := Stats."Source Type"::Customer
                    else
                        Stats."Source Type" := Stats."Source Type"::Vendor;
                    Stats."Entry No." := NextNbr;
                    NextNbr := NextNbr + 1;
                    Stats."Entry Type" := Text007;
                    Stats."Back disc./commission rule No." := DiscRule."No.";
                    Stats.Quantity := Round(Base, 0.01);
                    Stats.Amount := Com;
                    Stats.Cost := Com;
                    Stats."Lines discount total" := 0;
                    Stats."Document discount total" := 0;
                    Stats."Back discount total" := 0;
                    Stats."Commissions total" := 0;
                    Stats.Insert;
                    NombreCree := NombreCree + 1;
                    Window.Update(2, Round(Enr / TotalNumber * 10000, 1));
                    "Commissions total" := "Commissions total" + Com;
                    Modify;
                until Next = 0;
            end;
        end;
    end;

    [Scope('OnPrem')]
    procedure InitStat()
    begin
        Stat2.Reset;
        Stat2.SetCurrentKey("Entry Type", Type, "No.", "Source Type", "Source No.", "Location Code",
                            "Inventory Posting Group", "Source Posting Group", "Gen. Bus. Posting Group",
                            "Gen. Prod. Posting Group", "Salespers./Purch. Code", "Global Dimension 1 Code",
                            "Global Dimension 2 Code", "Reason Code", "Ending Date");
        Stat2.SetFilter("Entry Type", '%1', '###*');
    end;

    [Scope('OnPrem')]
    procedure FusionRFACom()
    var
        ArretTraitement: Boolean;
        i: Integer;
        Resultat: array[20] of Decimal;
    begin
        ArretTraitement := false;
        with Stat2 do begin
            InitStat;
            TotalNumber := Count;
            Enr := 0;
            if Find('-') then begin
                Window.Open(Text008);
                repeat
                    Enr := Enr + 1;
                    Window.Update(1, Round(Enr / TotalNumber * 10000, 1));
                    CreateFilterAggregate;
                    i := 0;
                    repeat
                        i := i + 1;
                        Resultat[i] := 0;
                    until i = 20;
                    if Find('-') then
                        repeat
                            Resultat[1] := Resultat[1] + Quantity;
                            Resultat[2] := Resultat[2] + Amount;
                            Resultat[3] := Resultat[3] + Cost;
                            Delete;
                        until Next = 0;

                    if (Resultat[1] <> 0) or (Resultat[2] <> 0) or (Resultat[3] <> 0) then begin
                        Stats.Init;
                        Stats := Stat2;
                        Stats."Entry No." := NextNbr;
                        if Stat2."Entry Type" = Text005 then
                            Stats."Entry Type" := TexteType[30]
                        else
                            Stats."Entry Type" := TexteType[32];
                        NextNbr := NextNbr + 1;
                        Stats.Quantity := Resultat[1];
                        Stats.Amount := Resultat[2];
                        Stats.Cost := Resultat[3];
                        Stats.Insert;
                        RepriseValeurs.Run(Stats);
                    end;

                    //On passe à l'écriture suivante
                    InitStat;
                    if not Find('-') then
                        ArretTraitement := true;
                until ArretTraitement = true;
                Stat2.Reset;
                Stat2.SetFilter("Entry Type", '%1', '###*');
                Stat2.DeleteAll;
                Window.Close;
            end;
        end;
    end;

    [Scope('OnPrem')]
    procedure SetFilters(DiscRule2: Record "Discount Rule")
    var
        DateD: Date;
        DateF: Date;
    begin
        with StatAgg do begin
            SetCurrentKey("Entry Type");
            if DiscRule2.Type = DiscRule2.Type::Sale then
                SetRange("Entry Type", TexteType[5])
            else
                SetRange("Entry Type", TexteType[10]);
            SetRange("Period Length", PeriodeBasis);
            if StartDate > DiscRule2."Starting Date" then
                DateD := StartDate
            else
                DateD := DiscRule2."Starting Date";
            if EndDate < DiscRule2."Ending Date" then
                DateF := EndDate
            else
                DateF := DiscRule2."Ending Date";
            SetRange("Ending Date", DateD, DateF);
            SetFilter("Inventory Posting Group", DiscRule2."Inventory Posting Group filter");
            SetFilter("Source Posting Group", DiscRule2."Source Posting Group Filter");
            SetFilter("Gen. Bus. Posting Group", DiscRule2."Gen. Bus. Posting Group filter");
            SetFilter("Gen. Prod. Posting Group", DiscRule2."Gen.Prod. Posting Group filter");
            SetFilter("Salespers./Purch. Code", DiscRule2."Salespers./Purch. Filter");
            SetFilter("Source No.", DiscRule2."Source Filter");
            if DiscRule2."Type Filter" <> DiscRule2."Type Filter"::All then
                SetFilter(Type, '%1', DiscRule2."Type Filter" - 1);
            SetFilter("No.", DiscRule2."No. filter");
            if DiscRule2.Type = DiscRule2.Type::Sale then begin
                SetFilter("Customer criteria 1", DiscRule2."Customer criteria filter 1");
                SetFilter("Customer criteria 2", DiscRule2."Customer criteria filter 2");
                SetFilter("Customer criteria 3", DiscRule2."Customer criteria filter 3");
                SetFilter("Customer criteria 4", DiscRule2."Customer criteria filter 4");
                SetFilter("Customer criteria 5", DiscRule2."Customer criteria filter 5");
                SetFilter("Customer criteria 6", DiscRule2."Customer criteria filter 6");
                SetFilter("Customer criteria 7", DiscRule2."Customer criteria filter 7");
                SetFilter("Customer criteria 8", DiscRule2."Customer criteria filter 8");
                SetFilter("Customer criteria 9", DiscRule2."Customer criteria filter 9");
                SetFilter("Customer criteria 10", DiscRule2."Customer criteria filter 10");
            end;
            SetFilter("Item criteria 1", DiscRule2."Item criteria filter 1");
            SetFilter("Item criteria 2", DiscRule2."Item criteria filter 2");
            SetFilter("Item criteria 3", DiscRule2."Item criteria filter 3");
            SetFilter("Item criteria 4", DiscRule2."Item criteria filter 4");
            SetFilter("Item criteria 5", DiscRule2."Item criteria filter 5");
            SetFilter("Item criteria 6", DiscRule2."Item criteria filter 6");
            SetFilter("Item criteria 7", DiscRule2."Item criteria filter 7");
            SetFilter("Item criteria 8", DiscRule2."Item criteria filter 8");
            SetFilter("Item criteria 9", DiscRule2."Item criteria filter 9");
            SetFilter("Item criteria 10", DiscRule2."Item criteria filter 10");
            SetFilter(Quantity, DiscRule2."Quantity filter");
            SetFilter("Reason Code", DiscRule2."Reason Code filter");
            SetFilter("Global Dimension 1 Code", DiscRule2."Global Dimension 1 Filter");
            SetFilter("Global Dimension 2 Code", DiscRule2."Global Dimension 2 Filter");
            SetFilter("Job No.", DiscRule2."Job Filter");
            SetFilter(Amount, DiscRule2."Amount Filter (LCY)");
            SetFilter("Return Reason Code", DiscRule2."Return Reason Code Filter");
            SetFilter("Manufacturer Code", DiscRule2."Manufacturer Code Filter");
            SetFilter("Item Category Code", DiscRule2."Item Category Code Filter");
            SetFilter("Product Group Code", DiscRule2."Product Group Code Filter");
            SetFilter("Service Item Group", DiscRule2."Service Item Group Filter");
            SetFilter("Dimension 1 Value Code", DiscRule2."Dimension 1 Value Code");
            SetFilter("Dimension 2 Value Code", DiscRule2."Dimension 2 Value Code");
            SetFilter("Dimension 3 Value Code", DiscRule2."Dimension 3 Value Code");
            SetFilter("Dimension 4 Value Code", DiscRule2."Dimension 4 Value Code");
            SetFilter("Dimension 5 Value Code", DiscRule2."Dimension 5 Value Code");
            SetFilter("Dimension 6 Value Code", DiscRule2."Dimension 6 Value Code");
            SetFilter("Dimension 7 Value Code", DiscRule2."Dimension 7 Value Code");
            SetFilter("Dimension 8 Value Code", DiscRule2."Dimension 8 Value Code");
            SetFilter("Dimension 9 Value Code", DiscRule2."Dimension 9 Value Code");
            SetFilter("Dimension 10 Value Code", DiscRule2."Dimension 10 Value Code");
            SetFilter("Dimension 11 Value Code", DiscRule2."Dimension 11 Value Code");
            SetFilter("Dimension 12 Value Code", DiscRule2."Dimension 12 Value Code");
            SetFilter("Dimension 13 Value Code", DiscRule2."Dimension 13 Value Code");
            SetFilter("Dimension 14 Value Code", DiscRule2."Dimension 14 Value Code");
            SetFilter("Dimension 15 Value Code", DiscRule2."Dimension 15 Value Code");
            SetFilter("Dimension 16 Value Code", DiscRule2."Dimension 16 Value Code");
            SetFilter("Dimension 17 Value Code", DiscRule2."Dimension 17 Value Code");
            SetFilter("Dimension 18 Value Code", DiscRule2."Dimension 18 Value Code");
            SetFilter("Dimension 19 Value Code", DiscRule2."Dimension 19 Value Code");
            SetFilter("Dimension 20 Value Code", DiscRule2."Dimension 20 Value Code");
            //ADV-001 ABSYS BT 20061102 ajout du code gratuit dans les filtres
            SetFilter("Free field 2", DiscRule2."Free Code Filter");
            //

            if FirstLoop then begin
                case DiscRule2."Discount and comm. type" of
                    DiscRule2."Discount and comm. type"::"Back discount":
                        ModifyAll("Back discount total", 0);
                    DiscRule2."Discount and comm. type"::Commission:
                        ModifyAll("Commissions total", 0);
                end;
            end;
        end;
    end;

    [Scope('OnPrem')]
    procedure CreateFilterAggregate()
    var
        StatsExplorerFields: Record "StatsExplorer fields";
        FieldEnabled: array[250] of Boolean;
    begin
        with StatsExplorerFields do begin
            SetFilter("Entry name", '%1|%2', TexteType[30], TexteType[32]);
            if Find('-') then
                repeat
                    if not FieldEnabled["Field No"] then
                        FieldEnabled["Field No"] := StatsExplorerFields.Enabled;
                until Next = 0;
        end;

        with Stat2 do begin
            SetCurrentKey("Period Length", "Ending Date", "Entry Type", Type, "No.", "Source Type", "Source No.",
                          "Location Code", "Inventory Posting Group", "Source Posting Group", "Gen. Bus. Posting Group",
                          "Gen. Prod. Posting Group", "Salespers./Purch. Code", "Global Dimension 1 Code",
                          "Global Dimension 2 Code", "Country Code", "Business Unit Code");

            SetRange("Period Length", "Period Length");
            SetRange("Ending Date", "Ending Date");
            SetRange("Entry Type", "Entry Type");
            SetRange(Type, Type);
            SetRange("Source Type", "Source Type");
            SetRange("Back disc./commission rule No.", "Back disc./commission rule No.");

            if FieldEnabled[6] then
                SetRange("No.", "No.");

            if FieldEnabled[9] then
                SetRange("Source No.", "Source No.");

            if FieldEnabled[11] then
                SetRange("Location Code", "Location Code");

            if FieldEnabled[12] then
                SetRange("Inventory Posting Group", "Inventory Posting Group");

            if FieldEnabled[13] then
                SetRange("Source Posting Group", "Source Posting Group");

            if FieldEnabled[14] then
                SetRange("Gen. Bus. Posting Group", "Gen. Bus. Posting Group");

            if FieldEnabled[15] then
                SetRange("Gen. Prod. Posting Group", "Gen. Prod. Posting Group");

            if FieldEnabled[16] then
                SetRange("Salespers./Purch. Code", "Salespers./Purch. Code");

            if FieldEnabled[17] then
                SetRange("Global Dimension 1 Code", "Global Dimension 1 Code");

            if FieldEnabled[18] then
                SetRange("Global Dimension 2 Code", "Global Dimension 2 Code");

            if FieldEnabled[37] then
                SetRange("Business Unit Code", "Business Unit Code");

            if FieldEnabled[40] then
                SetRange("Job No.", "Job No.");

            if FieldEnabled[41] then
                SetRange("Phase Code", "Phase Code");

            if FieldEnabled[42] then
                SetRange("Task Code", "Task Code");

            if FieldEnabled[43] then
                SetRange("Step Code", "Step Code");

            if FieldEnabled[44] then
                SetRange("Work Type Code", "Work Type Code");

            if FieldEnabled[45] then
                SetRange("Reason Code", "Reason Code");

            if FieldEnabled[46] then
                SetRange("Job Posting Group", "Job Posting Group");

            if FieldEnabled[47] then
                SetRange("Resource Group No.", "Resource Group No.");

            if FieldEnabled[50] then
                SetRange("Item Charge No.", "Item Charge No.");

            if FieldEnabled[51] then
                SetRange("Variant Code", "Variant Code");

            if FieldEnabled[52] then
                SetRange("Return Reason Code", "Return Reason Code");

            if FieldEnabled[80] and
               (StatisticsSetup."Free field name 1" <> '') then
                SetRange("Free field 1", "Free field 1");

            if FieldEnabled[81] and
               (StatisticsSetup."Free field name 2" <> '') then
                SetRange("Free field 2", "Free field 2");

            if FieldEnabled[82] and
               (StatisticsSetup."Free field name 3" <> '') then
                SetRange("Free field 3", "Free field 3");

            if FieldEnabled[83] and
               (StatisticsSetup."Free field name 4" <> '') then
                SetRange("Free field 4", "Free field 4");

            if FieldEnabled[84] and
               (StatisticsSetup."Free field name 5" <> '') then
                SetRange("Free field 5", "Free field 5");

            if FieldEnabled[85] and
               (StatisticsSetup."Free field name 6" <> '') then
                SetRange("Free field 6", "Free field 6");

            if FieldEnabled[86] and
               (StatisticsSetup."Free field name 7" <> '') then
                SetRange("Free field 7", "Free field 7");

            if FieldEnabled[87] and
               (StatisticsSetup."Free field name 8" <> '') then
                SetRange("Free field 8", "Free field 8");

            if FieldEnabled[88] and
               (StatisticsSetup."Free field name 9" <> '') then
                SetRange("Free field 9", "Free field 9");

            if FieldEnabled[89] and
               (StatisticsSetup."Free field name 10" <> '') then
                SetRange("Free field 10", "Free field 10");

            if FieldEnabled[90] and
               (StatisticsSetup."Free date name 1" <> '') then
                SetRange("Free date 1", "Free date 1");

            if FieldEnabled[91] and
               (StatisticsSetup."Free date name 2" <> '') then
                SetRange("Free date 2", "Free date 2");

            if FieldEnabled[92] and
               (StatisticsSetup."Free date name 3" <> '') then
                SetRange("Free date 3", "Free date 3");

            if FieldEnabled[93] and
               (StatisticsSetup."Free date name 4" <> '') then
                SetRange("Free date 4", "Free date 4");

            if FieldEnabled[94] and
               (StatisticsSetup."Free date name 5" <> '') then
                SetRange("Free date 5", "Free date 5");

            if FieldEnabled[95] and
               (StatisticsSetup."Free check name 1" <> '') then
                SetRange("Free boolean 1", "Free boolean 1");

            if FieldEnabled[96] and
               (StatisticsSetup."Free check name 2" <> '') then
                SetRange("Free boolean 2", "Free boolean 2");

            if FieldEnabled[97] and
               (StatisticsSetup."Free check name 3" <> '') then
                SetRange("Free boolean 3", "Free boolean 3");

            if FieldEnabled[98] and
               (StatisticsSetup."Free check name 4" <> '') then
                SetRange("Free boolean 4", "Free boolean 4");

            if FieldEnabled[99] and
               (StatisticsSetup."Free check name 5" <> '') then
                SetRange("Free boolean 5", "Free boolean 5");

            if FieldEnabled[201] and
               (StatisticsSetup."Dimension 1 Code" <> '') then
                SetRange("Dimension 1 Value Code", "Dimension 1 Value Code");

            if FieldEnabled[202] and
               (StatisticsSetup."Dimension 2 Code" <> '') then
                SetRange("Dimension 2 Value Code", "Dimension 2 Value Code");

            if FieldEnabled[203] and
               (StatisticsSetup."Dimension 3 Code" <> '') then
                SetRange("Dimension 3 Value Code", "Dimension 3 Value Code");

            if FieldEnabled[204] and
               (StatisticsSetup."Dimension 4 Code" <> '') then
                SetRange("Dimension 4 Value Code", "Dimension 4 Value Code");

            if FieldEnabled[205] and
               (StatisticsSetup."Dimension 5 Code" <> '') then
                SetRange("Dimension 5 Value Code", "Dimension 5 Value Code");

            if FieldEnabled[206] and
               (StatisticsSetup."Dimension 6 Code" <> '') then
                SetRange("Dimension 6 Value Code", "Dimension 6 Value Code");

            if FieldEnabled[207] and
               (StatisticsSetup."Dimension 7 Code" <> '') then
                SetRange("Dimension 7 Value Code", "Dimension 7 Value Code");

            if FieldEnabled[208] and
               (StatisticsSetup."Dimension 8 Code" <> '') then
                SetRange("Dimension 8 Value Code", "Dimension 8 Value Code");

            if FieldEnabled[209] and
               (StatisticsSetup."Dimension 9 Code" <> '') then
                SetRange("Dimension 9 Value Code", "Dimension 9 Value Code");

            if FieldEnabled[210] and
               (StatisticsSetup."Dimension 10 Code" <> '') then
                SetRange("Dimension 10 Value Code", "Dimension 10 Value Code");

            if FieldEnabled[211] and
               (StatisticsSetup."Dimension 11 Code" <> '') then
                SetRange("Dimension 11 Value Code", "Dimension 11 Value Code");

            if FieldEnabled[212] and
               (StatisticsSetup."Dimension 12 Code" <> '') then
                SetRange("Dimension 12 Value Code", "Dimension 12 Value Code");

            if FieldEnabled[213] and
               (StatisticsSetup."Dimension 13 Code" <> '') then
                SetRange("Dimension 13 Value Code", "Dimension 13 Value Code");

            if FieldEnabled[214] and
               (StatisticsSetup."Dimension 14 Code" <> '') then
                SetRange("Dimension 14 Value Code", "Dimension 14 Value Code");

            if FieldEnabled[215] and
               (StatisticsSetup."Dimension 15 Code" <> '') then
                SetRange("Dimension 15 Value Code", "Dimension 15 Value Code");

            if FieldEnabled[216] and
               (StatisticsSetup."Dimension 16 Code" <> '') then
                SetRange("Dimension 16 Value Code", "Dimension 16 Value Code");

            if FieldEnabled[217] and
               (StatisticsSetup."Dimension 17 Code" <> '') then
                SetRange("Dimension 17 Value Code", "Dimension 17 Value Code");

            if FieldEnabled[218] and
               (StatisticsSetup."Dimension 18 Code" <> '') then
                SetRange("Dimension 18 Value Code", "Dimension 18 Value Code");

            if FieldEnabled[219] and
               (StatisticsSetup."Dimension 19 Code" <> '') then
                SetRange("Dimension 19 Value Code", "Dimension 19 Value Code");

            if FieldEnabled[220] and
               (StatisticsSetup."Dimension 20 Code" <> '') then
                SetRange("Dimension 20 Value Code", "Dimension 20 Value Code");
        end;
    end;
}

