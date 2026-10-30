report 8001310 "Launch Statistic Scheduler"
{
    // //STATSEXPLORER STATSEXPLORER 01/08/00 Lancement automatique de stats prédéfinies

    Caption = 'Launch Statistic Scheduler';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(AutomateStatistique; "Statistic Scheduler header")
        {
            DataItemTableView = SORTING(Code);

            trigger OnAfterGetRecord()
            begin
                // Calcul des cumuls
                if (CodeAutomate <> '') and ("Process agregate") then begin
                    TestField("Process from date");
                    TestField("Process to date");
                    CalculCumuls.InitRequete(Format("Process from date"), Format("Process to date"), "Period total basis", "Type of treatment");
                    CalculCumuls.UseRequestPage := false;
                    CalculCumuls.RunModal;
                    Clear(CalculCumuls);
                end;

                if CodeAutomate = '' then begin
                    if (Format("Frequency of calculation") = '') then
                        CurrReport.Skip;
                    if (("Last calculation date" <> 0D) and
                       (CalcDate('+' + Format(AutomateStatistique."Frequency of calculation"), "Last calculation date") > WorkDate)) then
                        CurrReport.Skip;
                end;

                LigneAutomateStatistique.SetRange("Code treatment", Code);
                LigneAutomateStatistique.SetFilter("Statistic code", '<>%1', '');
                if not LigneAutomateStatistique.Find('-') then
                    Error(Error2, Code)
                else
                    with LigneAutomateStatistique do repeat
                                                         StatistiquePredefinie.Get("Statistic code");
                                                         Calculer;
                                                         if "Type of Treatment" = "Type of Treatment"::Imprimer then
                                                             Imprimer;
                                                         if "Type of Treatment" = "Type of Treatment"::"Fichier HTML" then
                                                             SaveHTML;
                                                         if "Type of Treatment" = "Type of Treatment"::"Envoi dans Excel" then
                                                             SaveExcel;

                        until LigneAutomateStatistique.Next = 0;

                "Last calculation date" := WorkDate;
                Modify;

                // Historique des traitements
                NumSuivEcr := Historique.CreerHistorique(0, StrSubstNo(Texte1, Code), 3, 8001310);
                Historique.CreerHistorique(NumSuivEcr, '', 0, 0);
            end;

            trigger OnPreDataItem()
            begin
                ParametresStatistiques.Get;
                ParametresStatistiques.TestField("Scheduler process from date");
                ParametresStatistiques.TestField("Scheduler process to date");

                // Calcul des cumuls
                if CodeAutomate <> '' then begin
                    if not Get(CodeAutomate) then
                        Error(Error1, CodeAutomate)
                    else
                        SetRange(Code, CodeAutomate);
                end else
                    with AutomateStatistique2 do begin
                        DateDebutSituation := CalcDate(ParametresStatistiques."Scheduler process from date", WorkDate);
                        DateFinSituation := CalcDate(ParametresStatistiques."Scheduler process to date", WorkDate);
                        //      AutomateStatistique2.SETFILTER("Frequency of calculation",'<>%1','');
                        if Find('-') then
                            repeat
                                if Format("Frequency of calculation") <> '' then
                                    if ((("Last calculation date" = 0D) or
                                       (CalcDate('+' + Format("Frequency of calculation"), "Last calculation date") <= WorkDate)) and
                                       ("Process agregate")) then begin
                                        CalculCumuls.InitRequete(Format("Process from date"), Format("Process to date"), "Period total basis",
                                                                 "Type of treatment");
                                        CalculCumuls.UseRequestPage := false;
                                        CalculCumuls.RunModal;
                                        Clear(CalculCumuls);
                                    end;
                            until Next = 0;
                    end;

                Find('-');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Date début"; DateDebutSituation)
                {
                }
                field("Date fin"; DateFinSituation)
                {
                }
                field("Code automate"; CodeAutomate)
                {

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ListeAutomate: Page "Statistic Scheduler list";
                    begin
                        if (CodeAutomate <> '') then
                            if not AutomateStatistique.Get(CodeAutomate) then
                                AutomateStatistique.Init;

                        ListeAutomate.LookupMode := true;
                        if ListeAutomate.RunModal = ACTION::LookupOK then begin
                            ListeAutomate.GetRecord(AutomateStatistique);
                            CodeAutomate := AutomateStatistique.Code;
                        end;
                    end;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        ParametresStatistiques.Get;
        DateDebutSituation := CalcDate(ParametresStatistiques."Scheduler process from date", WorkDate);
        DateFinSituation := CalcDate(ParametresStatistiques."Scheduler process to date", WorkDate);
    end;

    var
        AutomateStatistique2: Record "Statistic Scheduler header";
        ParametresStatistiques: Record "Statistics setup";
        LigneAutomateStatistique: Record "Statistic Scheduler line";
        CalculCumuls: Report "Process aggregate";
        CalculStatistique: Report "Process statistic array new";
        ImprimerStatistique: Report "Statistic report";
        EnvoiExcelStatistique: Report "Statistic report";
        StatistiquePredefinie: Record "Standard statistic";
        Historique: Record "History treatment";
        ConvertirFormuleDate: Codeunit "StatsExplorer, Tools";
        DateDebutSituation: Date;
        DateDebutSituation2: Date;
        DateFinSituation: Date;
        DateFinSituation2: Date;
        CodeAutomate: Code[10];
        Error1: Label 'The treatment %1 is not correct';
        Error2: Label 'The treatment %1 does not contain statistics';
        Error3: Label 'You must enter file name for statistic %1';
        Error4: Label 'You must enter Excel worksheet name for statistic %1';
        CodeAutomate2: Code[10];
        NumSuivEcr: Integer;
        Texte1: Label 'Process %1';

    [Scope('OnPrem')]
    procedure InitRequete(InitCodeAutomate: Code[10])
    begin
        CodeAutomate2 := InitCodeAutomate;
    end;

    [Scope('OnPrem')]
    procedure Calculer()
    var
        StatisticUser: Record "Statistic User";
        LignesStatistiquesTemp: Record "Statistic array line";
        ColonnesStatistiquesTemp: Record "Statistic array column";
        ResultatsStatistiquesTemp: Record "Statistic cell";
        DefinitionStatistiquesTemp: Record "Statistic definition";
        LignesStatistiquesTemp2: Record "Statistic array line";
        ColonnesStatistiquesTemp2: Record "Statistic array column";
        ResultatsStatistiquesTemp2: Record "Statistic cell";
        DefinitionStatistiquesTemp2: Record "Statistic definition";
    begin
        with LigneAutomateStatistique do begin

            if Format("Process from date") <> '' then
                DateDebutSituation2 := CalcDate(Format("Process from date"), WorkDate)
            else
                DateDebutSituation2 := DateDebutSituation;

            if Format("Process to date") <> '' then
                DateFinSituation2 := CalcDate(Format("Process to date"), WorkDate)
            else
                DateFinSituation2 := DateFinSituation;

            Clear(CalculStatistique);
            CalculStatistique.InitRequete(LigneAutomateStatistique."Statistic code", DateDebutSituation2, DateFinSituation2,
                                          "User ID");
            CalculStatistique.UseRequestPage := false;
            CalculStatistique.RunModal;
            Clear(CalculStatistique);
            // Other users
            StatisticUser.SetRange("Sheduler code", "Code treatment");
            StatisticUser.SetRange("Statistic code", "Statistic code");
            if "User ID" = '' then
                "User ID" := UserId;
            StatisticUser.SetFilter("User ID", '<>%1&<>%2', '', "User ID");

            if StatisticUser.Find('-') then begin

                repeat

                    LignesStatistiquesTemp.SetRange("Statistic code", "Statistic code");
                    LignesStatistiquesTemp.SetRange("User ID", "User ID");
                    if LignesStatistiquesTemp.Find('-') then begin
                        LignesStatistiquesTemp2.SetRange("Statistic code", "Statistic code");
                        LignesStatistiquesTemp2.SetRange("User ID", StatisticUser."User ID");
                        LignesStatistiquesTemp2.DeleteAll;
                        repeat
                            LignesStatistiquesTemp2.Reset;
                            LignesStatistiquesTemp2.Init;
                            LignesStatistiquesTemp2 := LignesStatistiquesTemp;
                            LignesStatistiquesTemp2."User ID" := StatisticUser."User ID";
                            LignesStatistiquesTemp2.Insert;
                        until LignesStatistiquesTemp.Next = 0;
                    end;

                    ColonnesStatistiquesTemp.SetRange("Statistic code", "Statistic code");
                    ColonnesStatistiquesTemp.SetRange("User ID", "User ID");
                    if ColonnesStatistiquesTemp.Find('-') then begin
                        ColonnesStatistiquesTemp2.SetRange("Statistic code", "Statistic code");
                        ColonnesStatistiquesTemp2.SetRange("User ID", StatisticUser."User ID");
                        ColonnesStatistiquesTemp2.DeleteAll;
                        repeat
                            ColonnesStatistiquesTemp2.Reset;
                            ColonnesStatistiquesTemp2.Init;
                            ColonnesStatistiquesTemp2 := ColonnesStatistiquesTemp;
                            ColonnesStatistiquesTemp2."User ID" := StatisticUser."User ID";
                            ColonnesStatistiquesTemp2.Insert;
                        until ColonnesStatistiquesTemp.Next = 0;
                    end;

                    ResultatsStatistiquesTemp.SetRange("Statistic code", "Statistic code");
                    ResultatsStatistiquesTemp.SetRange("User ID", "User ID");
                    if ResultatsStatistiquesTemp.Find('-') then begin
                        ResultatsStatistiquesTemp2.SetRange("Statistic code", "Statistic code");
                        ResultatsStatistiquesTemp2.SetRange("User ID", StatisticUser."User ID");
                        ResultatsStatistiquesTemp2.DeleteAll;
                        repeat
                            ResultatsStatistiquesTemp2.Reset;
                            ResultatsStatistiquesTemp2.Init;
                            ResultatsStatistiquesTemp2 := ResultatsStatistiquesTemp;
                            ResultatsStatistiquesTemp2."User ID" := StatisticUser."User ID";
                            ResultatsStatistiquesTemp2.Insert;
                        until ResultatsStatistiquesTemp.Next = 0;
                    end;

                    DefinitionStatistiquesTemp.SetRange("Statistic code", "Statistic code");
                    DefinitionStatistiquesTemp.SetRange("User ID", "User ID");
                    if DefinitionStatistiquesTemp.Find('-') then begin
                        DefinitionStatistiquesTemp2.SetRange("Statistic code", "Statistic code");
                        DefinitionStatistiquesTemp2.SetRange("User ID", StatisticUser."User ID");
                        DefinitionStatistiquesTemp2.DeleteAll;
                        repeat
                            DefinitionStatistiquesTemp2.Reset;
                            DefinitionStatistiquesTemp2.Init;
                            DefinitionStatistiquesTemp2 := DefinitionStatistiquesTemp;
                            DefinitionStatistiquesTemp2."User ID" := StatisticUser."User ID";
                            DefinitionStatistiquesTemp2.Insert;
                        until DefinitionStatistiquesTemp.Next = 0;
                    end;

                until StatisticUser.Next = 0;
            end;
        end;
    end;

    [Scope('OnPrem')]
    procedure Imprimer()
    begin
        Clear(ImprimerStatistique);
        with LigneAutomateStatistique do begin
            ImprimerStatistique.InitRequete("Statistic code", "Detail level" + 1, "Print definition", "Print total", "User ID");
            ImprimerStatistique.UseRequestPage := false;
            ImprimerStatistique.RunModal;
            Clear(ImprimerStatistique);
        end;
    end;

    [Scope('OnPrem')]
    procedure SaveHTML()
    begin
        Clear(ImprimerStatistique);
        with LigneAutomateStatistique do begin
            if "File Name" = '' then
                Error(Error3, "Statistic code");
            Clear(ImprimerStatistique);
            ImprimerStatistique.InitRequete("Statistic code", "Detail level" + 1, "Print definition", "Print total", "User ID");
            ImprimerStatistique.UseRequestPage := false;
            ImprimerStatistique.SaveAsHtml("File Name");
            Clear(ImprimerStatistique);
        end;
    end;

    [Scope('OnPrem')]
    procedure SaveExcel()
    var
        FichierExcel: Text[250];
        ExcelSheet: Text[30];
        Utils: Codeunit Utils;
    begin
        Clear(EnvoiExcelStatistique);
        with LigneAutomateStatistique do begin
            FichierExcel := "File Name";
            if FichierExcel = '' then
                if StatistiquePredefinie."Excel model name" <> '' then
                    FichierExcel := StatistiquePredefinie."Excel model name";
            FichierExcel := Utils.ConvertToUNC(FichierExcel);
            EnvoiExcelStatistique.InitRequete("Statistic code", "Detail level" + 1, "Print definition", "Print total", "User ID");
            EnvoiExcelStatistique.UseRequestPage := false;
            EnvoiExcelStatistique.SaveAsExcel(FichierExcel);
        end;
    end;

    [Scope('OnPrem')]
    procedure SetCode(pCodeAutomate: Code[10])
    begin
        CodeAutomate := pCodeAutomate;
    end;
}

