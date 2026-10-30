report 8001303 "Process standard statistic"
{
    // //STATSEXPLORER STATSEXPLORER 20/01/00 Calcul de stats prédéfinies

    Caption = 'Process standard statistic';
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(DateDebutSituation; DateDebutSituation)
                {
                    Caption = 'Date Début (facultatif)';
                }
                field(DateFinSituation; DateFinSituation)
                {
                    Caption = 'Date de fin';
                }
                field(CodeStatistique; CodeStatistique)
                {
                    Caption = 'Statistique';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ListeStatistiques: Page "Standard statistics list";
                    begin
                        if (CodeStatistique <> '') then
                            if not StatistiquePredefinie.Get(CodeStatistique) then
                                StatistiquePredefinie.Init;

                        ListeStatistiques.LookupMode := true;
                        if ListeStatistiques.RunModal = ACTION::LookupOK then begin
                            ListeStatistiques.GetRecord(StatistiquePredefinie);
                            CodeStatistique := StatistiquePredefinie.Code;
                        end;
                    end;

                    trigger OnValidate()
                    var
                        PermissionStatistique: Record "Statistic Permission";
                    begin
                        if not PermissionStatistique.Autorisation(PermissionStatistique.Type::Statistique, CodeStatistique, UserId) then
                            Error(Error1);
                    end;
                }
                field(bFilter; bFilter)
                {
                    Caption = 'Filtres';

                    trigger OnValidate()
                    begin
                        if CodeStatistique = '' then
                            Error(Error2);

                        if not StatistiquePredefinie.Get(CodeStatistique) then
                            Error(Error3, CodeStatistique);

                        if not FiltreTemporaire.Get(UserId, CodeStatistique) then begin
                            FiltreTemporaire.Init;
                            FiltreTemporaire.TransferFields(StatistiquePredefinie);
                            FiltreTemporaire."User ID" := UserId;
                            FiltreTemporaire.Insert;
                        end;

                        Commit;

                        PAGE.RunModal(PAGE::"Temp. statistic filter", FiltreTemporaire);
                    end;
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(Filtres)
                {
                    Caption = 'Filtres';
                }
            }
        }

        trigger OnOpenPage()
        var
            ConvertirFormuleDate: Codeunit "StatsExplorer, Tools";
        begin
            if (CodeStatistique <> '') and (FiltreTemporaire.Get(UserId, CodeStatistique)) then
                FiltreTemporaire.Delete(true);

            if DateFinSituation = 0D then
                DateFinSituation := CalcDate('<+' + ConvertirFormuleDate.ConvertDateFormula(3) + '>', WorkDate);
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        Statistiques.InitRequete(CodeStatistique, DateDebutSituation, DateFinSituation, UserId);
        Statistiques.UseRequestPage := false;
        Statistiques.Run;
    end;

    var
        StatistiquePredefinie: Record "Standard statistic";
        FiltreTemporaire: Record "Temp. statistic filter";
        Statistiques: Report "Process statistic array new";
        DateDebutSituation: Date;
        DateFinSituation: Date;
        CodeStatistique: Code[10];
        Error1: Label 'You are not authorized to process this statistic';
        Error2: Label 'Statistic code required';
        Error3: Label '%1 statistic code not defined';
        bFilter: Boolean;
}

