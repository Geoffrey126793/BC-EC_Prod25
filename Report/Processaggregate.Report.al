report 8001301 "Process aggregate"
{
    // //STATSEXPLORER STATSEXPLORER 01/01/00 Calcul de la table de cumuls statistiques
    // 
    // ------------------------------------------------------------------------------------------
    // ADV-001 ABSYS BT 20061102
    //   Calcul flux remise dans le stat : reprise Chimay
    // 
    // -----------------------------------------------------------------------------------------

    Caption = 'Process aggregate';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            var
                "Object": Record "Object";
                RechercheEcrArt: Codeunit "Aggr., Item Ledger Entries";
                RechercheDispoStock: Codeunit "Aggregate, Item Availability";
                RechercheEcrRess: Codeunit "Aggregate, Res. and G/L";
                RechercheEcrProjet: Codeunit "Aggregate, Job Ledger Entries";
                RechercheEcrBudgetProjet: Codeunit "Aggregate, Job Budget Entries";
                RechercheEcrCapacite: Codeunit "Aggregate, Res. Capacity Entry";
                RechercheEcrRessource: Codeunit "Aggregate, Res. Ledger Entries";
                RechercheAbsSalarie: Codeunit "Aggregate, Employee Absence";
                RechercheEcrClient: Codeunit "Aggregate, Cust. Ledger Entry";
                RechercheEcrFournisseur: Codeunit "Aggregate, Vendor Ledger Entry";
                RechercheEcrBudgetCompta: Codeunit "Aggregate, G/L budget";
                RechercheEcrCompteGeneral: Codeunit "Aggregate, G/L Entry";
                RechercheCommande: Codeunit "Aggregate, Sales/Purch. lines";
                TraitementSpecifique: Codeunit "Aggregate, Specific Entry";
                SearchForecastProdEntry: Codeunit "Aggr., Prod. Forecast Entries";
                "RepCalcSalesInv&CredMemDisc_l": Report "Calc. Sales Inv&CredMem Disc.";
                RechercheEcritureRemiseFact_l: Codeunit "Aggregate, Posted Disc. Entry";
            begin
                // Ecritures article


                if TraiterType[5] or TraiterType[10] or TraiterType[40] or TraiterType[45] or TraiterType[50] or TraiterType[80] or TraiterType[81
                ]
                   then begin
                    NumSuivEcr := Historique.CreerHistorique(0, '11' + CopyStr(StrSubstNo('%1, %2, %3, %4, %5, %6, %7 (%6 - %7)', TexteType[5],
                                  TexteType[10], TexteType[40], TexteType[45], TexteType[50], TexteType[80], TexteType[81], DateDebut, DateFin), 1, 250)
                                  , 3, 8001301);
                    if not AccordingToEveryFlow then begin
                        PurgeStats(TexteType[5], DateDebut, DateFin, BasePeriode, true);
                        PurgeStats(TexteType[10], DateDebut, DateFin, BasePeriode, true);
                        PurgeStats(TexteType[40], DateDebut, DateFin, BasePeriode, true);
                        PurgeStats(TexteType[45], DateDebut, DateFin, BasePeriode, true);
                        PurgeStats(TexteType[50], DateDebut, DateFin, BasePeriode, true);
                        PurgeStats(TexteType[80], DateDebut, DateFin, BasePeriode, true);
                        PurgeStats(TexteType[81], DateDebut, DateFin, BasePeriode, true);
                        RechercheEcrArt.InitRequest(DateDebut, DateFin, BasePeriode, 0);
                        RechercheEcrArt.Run;
                        RechercheEcrRess.InitRequest(DateDebut, DateFin, BasePeriode, 0, '', 0);
                        RechercheEcrRess.Run;
                    end else begin
                        i := 0;
                        repeat
                            if RecherchePeriodicite(i, 5) or RecherchePeriodicite(i, 10) or RecherchePeriodicite(i, 40)
                               or RecherchePeriodicite(i, 45) or RecherchePeriodicite(i, 50) or RecherchePeriodicite(i, 80)
                               or RecherchePeriodicite(i, 81) then begin
                                if i = 0 then begin
                                    DateDebutTmp := DateDebut;
                                    DateFinTmp := DateFin;
                                end
                                else begin
                                    DateDebutTmp := ConvertirFormuleDate.StartDateCalc(i, DateDebutTmp);
                                    DateFinTmp := ConvertirFormuleDate.EndDateCalc(i, DateFinTmp);
                                end;
                                PurgeStats(TexteType[5], DateDebutTmp, DateFinTmp, i, false);
                                PurgeStats(TexteType[10], DateDebutTmp, DateFinTmp, i, false);
                                PurgeStats(TexteType[40], DateDebutTmp, DateFinTmp, i, false);
                                PurgeStats(TexteType[45], DateDebutTmp, DateFinTmp, i, false);
                                PurgeStats(TexteType[50], DateDebutTmp, DateFinTmp, i, false);
                                RechercheEcrArt.InitRequest(DateDebutTmp, DateFinTmp, i, 0);
                                RechercheEcrArt.Run;
                                RechercheEcrRess.InitRequest(DateDebutTmp, DateFinTmp, i, 0, '', 0);
                                RechercheEcrRess.Run;
                            end;
                            i := i + 1;
                        until i = 5;
                    end;
                    Historique.CreerHistorique(NumSuivEcr, '', 3, 8001301);
                end;




                // Stock par magasin
                if TraiterType[39] then begin
                    NumSuivEcr := Historique.CreerHistorique(0, StrSubstNo('%1 (%2 - %3)', TexteType[39], DateDebut, DateFin), 3, 8001301);
                    if not AccordingToEveryFlow then begin
                        PurgeStats(TexteType[39], DateDebut, DateFin, BasePeriode, true);
                        RechercheDispoStock.InitRequete(DateDebut, DateFin, BasePeriode);
                        RechercheDispoStock.Run;
                    end else begin
                        i := 0;
                        repeat
                            if RecherchePeriodicite(i, 39) then begin
                                PurgeStats(TexteType[39], DateDebut, DateFin, i, true);
                                RechercheDispoStock.InitRequete(DateDebut, DateFin, i);
                                RechercheDispoStock.Run;
                            end;
                            i := i + 1;
                        until i = 5;
                    end;
                    Historique.CreerHistorique(NumSuivEcr, '', 3, 8001301);
                end;

                // Ecritures projet
                if TraiterType[15] or TraiterType[20] then begin
                    NumSuivEcr := Historique.CreerHistorique(0, StrSubstNo('%1, %2 (%3 - %4)',
                                  TexteType[15], TexteType[20], DateDebut, DateFin), 3, 8001301);
                    if not AccordingToEveryFlow then begin
                        PurgeStats(TexteType[15], DateDebut, DateFin, BasePeriode, true);
                        PurgeStats(TexteType[20], DateDebut, DateFin, BasePeriode, true);
                        RechercheEcrProjet.InitRequest(DateDebut, DateFin, BasePeriode, 0);
                        RechercheEcrProjet.Run;
                    end else begin
                        i := 0;
                        repeat
                            if RecherchePeriodicite(i, 15) or RecherchePeriodicite(i, 20) then begin
                                PurgeStats(TexteType[15], DateDebut, DateFin, i, true);
                                PurgeStats(TexteType[20], DateDebut, DateFin, i, true);
                                RechercheEcrProjet.InitRequest(DateDebut, DateFin, i, 0);
                                RechercheEcrProjet.Run;
                            end;
                            i := i + 1;
                        until i = 5;
                    end;
                    Historique.CreerHistorique(NumSuivEcr, '', 3, 8001301);
                end;


                // Ecritures budget projet
                if TraiterType[25] then begin
                    NumSuivEcr := Historique.CreerHistorique(0, StrSubstNo('%1 (%2 - %3)', TexteType[25], DateDebut, DateFin), 3, 8001301);
                    if not AccordingToEveryFlow then begin
                        PurgeStats(TexteType[25], DateDebut, DateFin, BasePeriode, true);
                        RechercheEcrBudgetProjet.InitRequest(DateDebut, DateFin, BasePeriode);
                        RechercheEcrBudgetProjet.Run;
                    end else begin
                        i := 0;
                        repeat
                            if RecherchePeriodicite(i, 25) then begin
                                PurgeStats(TexteType[25], DateDebut, DateFin, i, true);
                                RechercheEcrBudgetProjet.InitRequest(DateDebut, DateFin, i);
                                RechercheEcrBudgetProjet.Run;
                            end;
                            i := i + 1;
                        until i = 5;
                    end;
                    Historique.CreerHistorique(NumSuivEcr, '', 3, 8001301);
                end;

                // Ecritures capacité ressource
                if TraiterType[27] then begin
                    NumSuivEcr := Historique.CreerHistorique(0, StrSubstNo('%1 (%2 - %3)', TexteType[27], DateDebut, DateFin), 3, 8001301);
                    if not AccordingToEveryFlow then begin
                        PurgeStats(TexteType[27], DateDebut, DateFin, BasePeriode, true);
                        RechercheEcrCapacite.InitRequest(DateDebut, DateFin, BasePeriode);
                        RechercheEcrCapacite.Run;
                    end else begin
                        i := 0;
                        repeat
                            if RecherchePeriodicite(i, 27) then begin
                                PurgeStats(TexteType[27], DateDebut, DateFin, i, true);
                                RechercheEcrCapacite.InitRequest(DateDebut, DateFin, i);
                                RechercheEcrCapacite.Run;
                            end;
                            i := i + 1;
                        until i = 5;
                    end;
                    Historique.CreerHistorique(NumSuivEcr, '', 3, 8001301);
                end;

                // Ecritures ressource
                if TraiterType[28] or TraiterType[29] then begin
                    NumSuivEcr := Historique.CreerHistorique(0, '22' + StrSubstNo('%1, %2 (%3 - %4)',
                                                             TexteType[28], TexteType[29], DateDebut, DateFin), 3, 8001301);
                    if not AccordingToEveryFlow then begin
                        PurgeStats(TexteType[28], DateDebut, DateFin, BasePeriode, true);
                        PurgeStats(TexteType[29], DateDebut, DateFin, BasePeriode, true);
                        RechercheEcrRessource.InitRequest(DateDebut, DateFin, BasePeriode, 0);
                        RechercheEcrRessource.Run;
                    end else begin
                        i := 0;
                        repeat
                            if RecherchePeriodicite(i, 28) or RecherchePeriodicite(i, 29) then begin
                                PurgeStats(TexteType[28], DateDebut, DateFin, i, true);
                                PurgeStats(TexteType[29], DateDebut, DateFin, i, true);
                                RechercheEcrRessource.InitRequest(DateDebut, DateFin, i, 0);
                                RechercheEcrRessource.Run;
                            end;
                            i := i + 1;
                        until i = 5;
                    end;
                    Historique.CreerHistorique(NumSuivEcr, '', 3, 8001301);
                end;

                // Absences salarié
                if TraiterType[52] then begin
                    NumSuivEcr := Historique.CreerHistorique(0, StrSubstNo('%1 (%2 - %3)', TexteType[52], DateDebut, DateFin), 3, 8001301);
                    if not AccordingToEveryFlow then begin
                        PurgeStats(TexteType[52], DateDebut, DateFin, BasePeriode, true);
                        RechercheAbsSalarie.InitRequest(DateDebut, DateFin, BasePeriode);
                        RechercheAbsSalarie.Run;
                    end else begin
                        i := 0;
                        repeat
                            if RecherchePeriodicite(i, 52) then begin
                                PurgeStats(TexteType[52], DateDebut, DateFin, i, true);
                                RechercheAbsSalarie.InitRequest(DateDebut, DateFin, i);
                                RechercheAbsSalarie.Run;
                            end;
                            i := i + 1;
                        until i = 5;
                    end;
                    Historique.CreerHistorique(NumSuivEcr, '', 3, 8001301);
                end;

                // Ecritures client par échéance
                if TraiterType[60] then begin
                    NumSuivEcr := Historique.CreerHistorique(0, '33' + StrSubstNo('%1 (%2 - %3)', TexteType[60], DateDebut, DateFin), 3, 8001301);
                    if not AccordingToEveryFlow then begin
                        PurgeStats(TexteType[60], DateDebut, DateFin, BasePeriode, true);
                        RechercheEcrClient.InitRequest(DateDebut, DateFin, BasePeriode, true, 0);
                        RechercheEcrClient.Run;
                    end else begin
                        i := 0;
                        repeat
                            if RecherchePeriodicite(i, 60) then begin
                                PurgeStats(TexteType[60], DateDebut, DateFin, i, true);
                                RechercheEcrClient.InitRequest(DateDebut, DateFin, i, true, 0);
                                RechercheEcrClient.Run;
                            end;
                            i := i + 1;
                        until i = 5;
                    end;
                    Historique.CreerHistorique(NumSuivEcr, '', 3, 8001301);
                end;

                // Ecritures client par date compta.
                if TraiterType[61] then begin
                    NumSuivEcr := Historique.CreerHistorique(0, '44' + StrSubstNo('%1 (%2 - %3)', TexteType[61], DateDebut, DateFin), 3, 8001301);
                    if not AccordingToEveryFlow then begin
                        PurgeStats(TexteType[61], DateDebut, DateFin, BasePeriode, true);
                        RechercheEcrClient.InitRequest(DateDebut, DateFin, BasePeriode, false, 0);
                        RechercheEcrClient.Run;
                    end else begin
                        i := 0;
                        repeat
                            if RecherchePeriodicite(i, 61) then begin
                                PurgeStats(TexteType[61], DateDebut, DateFin, i, true);
                                RechercheEcrClient.InitRequest(DateDebut, DateFin, i, false, 0);
                                RechercheEcrClient.Run;
                            end;
                            i := i + 1;
                        until i = 5;
                    end;
                    Historique.CreerHistorique(NumSuivEcr, '', 3, 8001301);
                end;


                // Ecritures fournisseur par échéance
                if TraiterType[64] then begin
                    NumSuivEcr := Historique.CreerHistorique(0, '55' + StrSubstNo('%1 (%2 - %3)', TexteType[64], DateDebut, DateFin), 3, 8001301);
                    if not AccordingToEveryFlow then begin
                        PurgeStats(TexteType[64], DateDebut, DateFin, BasePeriode, true);
                        RechercheEcrFournisseur.InitRequest(DateDebut, DateFin, BasePeriode, true, 0);
                        RechercheEcrFournisseur.Run;
                    end else begin
                        i := 0;
                        repeat
                            if RecherchePeriodicite(i, 64) then begin
                                PurgeStats(TexteType[64], DateDebut, DateFin, i, true);
                                RechercheEcrFournisseur.InitRequest(DateDebut, DateFin, i, true, 0);
                                RechercheEcrFournisseur.Run;
                            end;
                            i := i + 1;
                        until i = 5;
                    end;
                    Historique.CreerHistorique(NumSuivEcr, '', 3, 8001301);
                end;

                // Ecritures fournisseur par date compta.
                if TraiterType[65] then begin
                    NumSuivEcr := Historique.CreerHistorique(0, '66' + StrSubstNo('%1 (%2 - %3)', TexteType[65], DateDebut, DateFin), 3, 8001301);
                    if not AccordingToEveryFlow then begin
                        PurgeStats(TexteType[65], DateDebut, DateFin, BasePeriode, true);
                        RechercheEcrFournisseur.InitRequest(DateDebut, DateFin, BasePeriode, false, 0);
                        RechercheEcrFournisseur.Run;
                    end else begin
                        i := 0;
                        repeat
                            if RecherchePeriodicite(i, 65) then begin
                                PurgeStats(TexteType[65], DateDebut, DateFin, i, true);
                                RechercheEcrFournisseur.InitRequest(DateDebut, DateFin, i, false, 0);
                                RechercheEcrFournisseur.Run;
                            end;
                            i := i + 1;
                        until i = 5;
                    end;
                    Historique.CreerHistorique(NumSuivEcr, '', 3, 8001301);
                end;

                // Ecritures budget comptable
                if TraiterType[66] then begin
                    NumSuivEcr := Historique.CreerHistorique(0, StrSubstNo('%1 (%2 - %3)', TexteType[66], DateDebut, DateFin), 3, 8001301);
                    if not AccordingToEveryFlow then begin
                        PurgeStats(TexteType[66], DateDebut, DateFin, BasePeriode, true);
                        RechercheEcrBudgetCompta.InitRequest(DateDebut, DateFin, BasePeriode);
                        RechercheEcrBudgetCompta.Run;
                    end else begin
                        i := 0;
                        repeat
                            if RecherchePeriodicite(i, 66) then begin
                                PurgeStats(TexteType[66], DateDebut, DateFin, i, true);
                                RechercheEcrBudgetCompta.InitRequest(DateDebut, DateFin, i);
                                RechercheEcrBudgetCompta.Run;
                            end;
                            i := i + 1;
                        until i = 5;
                    end;
                    Historique.CreerHistorique(NumSuivEcr, '', 3, 8001301);
                end;


                // Ecritures compte général
                if TraiterType[67] then begin
                    NumSuivEcr := Historique.CreerHistorique(0, StrSubstNo('%1 (%2 - %3)', TexteType[67], DateDebut, DateFin), 3, 8001301);
                    if not AccordingToEveryFlow then begin
                        PurgeStats(TexteType[67], DateDebut, DateFin, BasePeriode, true);
                        RechercheEcrCompteGeneral.InitRequest(DateDebut, DateFin, BasePeriode, 0);
                        RechercheEcrCompteGeneral.Run;
                    end else begin
                        i := 0;
                        repeat
                            if RecherchePeriodicite(i, 67) then begin
                                PurgeStats(TexteType[67], DateDebut, DateFin, i, true);
                                RechercheEcrCompteGeneral.InitRequest(DateDebut, DateFin, i, 0);
                                RechercheEcrCompteGeneral.Run;
                            end;
                            i := i + 1;
                        until i = 5;
                    end;
                    Historique.CreerHistorique(NumSuivEcr, '', 3, 8001301);
                end;

                // Ligne vente et achat (devis, commandes, ...)
                if TraiterType[68] or TraiterType[69] or TraiterType[70] or TraiterType[71] or
                   TraiterType[73] or TraiterType[74] or TraiterType[75] or TraiterType[76] then begin
                    NumSuivEcr := Historique.CreerHistorique(0, '66' + StrSubstNo('%1 (%2 - %3)', TexteType[68], DateDebut, DateFin), 3, 8001301);
                    if not AccordingToEveryFlow then begin
                        PurgeStats(TexteType[68], 0D, 20991231D, BasePeriode, false);
                        PurgeStats(TexteType[69], 0D, 20991231D, BasePeriode, false);
                        PurgeStats(TexteType[70], 0D, 20991231D, BasePeriode, false);
                        PurgeStats(TexteType[71], 0D, 20991231D, BasePeriode, false);
                        PurgeStats(TexteType[73], 0D, 20991231D, BasePeriode, false);
                        PurgeStats(TexteType[74], 0D, 20991231D, BasePeriode, false);
                        PurgeStats(TexteType[75], 0D, 20991231D, BasePeriode, false);
                        PurgeStats(TexteType[76], 0D, 20991231D, BasePeriode, false);
                        RechercheCommande.InitRequest(DateDebut, DateFin, BasePeriode);
                        RechercheCommande.Run;
                    end else begin
                        i := 0;
                        repeat
                            if RecherchePeriodicite(i, 68) or RecherchePeriodicite(i, 69) or RecherchePeriodicite(i, 70)
                               or RecherchePeriodicite(i, 71) or RecherchePeriodicite(i, 73) or RecherchePeriodicite(i, 74)
                               or RecherchePeriodicite(i, 75) or RecherchePeriodicite(i, 76) then begin
                                PurgeStats(TexteType[68], 0D, 20991231D, i, false);
                                PurgeStats(TexteType[69], 0D, 20991231D, i, false);
                                PurgeStats(TexteType[70], 0D, 20991231D, i, false);
                                PurgeStats(TexteType[71], 0D, 20991231D, i, false);
                                PurgeStats(TexteType[73], 0D, 20991231D, i, false);
                                PurgeStats(TexteType[74], 0D, 20991231D, i, false);
                                PurgeStats(TexteType[75], 0D, 20991231D, i, false);
                                PurgeStats(TexteType[76], 0D, 20991231D, i, false);
                                RechercheCommande.InitRequest(DateDebut, DateFin, i);
                                RechercheCommande.Run;
                            end;
                            i := i + 1;
                        until i = 5;
                    end;
                    Historique.CreerHistorique(NumSuivEcr, '', 3, 8001301);
                end;

                // Ecritures commissions et R.F.A
                if TraiterType[30] or TraiterType[32]
                  //ADV-001 ABSYS BT 20061102
                  or TraiterType[90] then begin

                    // Lancement du traitement de mise à jour des RFA sur la période sélectionné dans le calcul du cumul
                    Clear("RepCalcSalesInv&CredMemDisc_l");
                    "RepCalcSalesInv&CredMemDisc_l".UseRequestPage(false);
                    "RepCalcSalesInv&CredMemDisc_l".InitRequest(DateDebut, DateFin);
                    "RepCalcSalesInv&CredMemDisc_l".RunModal();

                    NumSuivEcr := Historique.CreerHistorique(0, '77' + StrSubstNo('%1, %2 (%3 - %4)',
                                                            TexteType[30], TexteType[32], DateDebut, DateFin), 3, 8001301);
                    PurgeStats(TexteType[30], DateDebut, DateFin, BasePeriode, true);
                    PurgeStats(TexteType[32], DateDebut, DateFin, BasePeriode, true);
                    if Object.Get(Object.Type::Codeunit, '', 8001501) then begin
                        //ADV-001 ABSYS BT 20061102>>
                        Clear(RechercheEcritureRemiseFact_l);
                        RechercheEcritureRemiseFact_l.InitRequest(DateDebut, DateFin, BasePeriode, 0);
                        RechercheEcritureRemiseFact_l.Run;
                        //
                    end;
                    Historique.CreerHistorique(NumSuivEcr, '', 3, 8001301);
                end;

                // Ecritures prévision de production
                if TraiterType[82] or TraiterType[83] then begin
                    NumSuivEcr := Historique.CreerHistorique(0, '88' + StrSubstNo('%1, %2 (%3 - %4)',
                                  TexteType[82], TexteType[83], DateDebut, DateFin), 3, 8001301);
                    if not AccordingToEveryFlow then begin
                        PurgeStats(TexteType[82], DateDebut, DateFin, BasePeriode, true);
                        PurgeStats(TexteType[83], DateDebut, DateFin, BasePeriode, true);
                        SearchForecastProdEntry.InitRequest(DateDebut, DateFin, BasePeriode, 0);
                        SearchForecastProdEntry.Run;
                    end else begin
                        i := 0;
                        repeat
                            if RecherchePeriodicite(i, 82) or RecherchePeriodicite(i, 83) then begin
                                PurgeStats(TexteType[82], DateDebut, DateFin, i, true);
                                PurgeStats(TexteType[83], DateDebut, DateFin, i, true);
                                SearchForecastProdEntry.InitRequest(DateDebut, DateFin, i, 0);
                                SearchForecastProdEntry.Run;
                            end;
                            i := i + 1;
                        until i = 5;
                    end;
                    Historique.CreerHistorique(NumSuivEcr, '', 3, 8001301);
                end;






                /*// Traitement spécifique
                   NumSuivEcr := Historique.CreerHistorique(0,STRSUBSTNO('%1 (%2 - %3)',TexteType[90],DateDebut,DateFin),3,8001301);
                   IF NOT AccordingToEveryFlow THEN BEGIN
                      PurgeStats(TexteType[90],DateDebut,DateFin,BasePeriode,TRUE);
                      PurgeStats(TexteType[91],DateDebut,DateFin,BasePeriode,TRUE);
                      PurgeStats(TexteType[92],DateDebut,DateFin,BasePeriode,TRUE);
                      PurgeStats(TexteType[93],DateDebut,DateFin,BasePeriode,TRUE);
                      PurgeStats(TexteType[94],DateDebut,DateFin,BasePeriode,TRUE);
                      PurgeStats(TexteType[95],DateDebut,DateFin,BasePeriode,TRUE);
                      PurgeStats(TexteType[96],DateDebut,DateFin,BasePeriode,TRUE);
                      PurgeStats(TexteType[97],DateDebut,DateFin,BasePeriode,TRUE);
                      PurgeStats(TexteType[98],DateDebut,DateFin,BasePeriode,TRUE);
                      PurgeStats(TexteType[99],DateDebut,DateFin,BasePeriode,TRUE);
                      TraitementSpecifique.InitRequest(DateDebut,DateFin,BasePeriode);
                      TraitementSpecifique.RUN;
                   END ELSE BEGIN
                      i := 0;
                      REPEAT
                       IF RecherchePeriodicite(i,90) OR RecherchePeriodicite(i,91) OR RecherchePeriodicite(i,92)
                          OR RecherchePeriodicite(i,93) OR RecherchePeriodicite(i,94) OR RecherchePeriodicite(i,95)
                          OR RecherchePeriodicite(i,96) OR RecherchePeriodicite(i,97) OR RecherchePeriodicite(i,98)
                          OR RecherchePeriodicite(i,99) THEN BEGIN
                          PurgeStats(TexteType[90],DateDebut,DateFin,i,TRUE);
                          PurgeStats(TexteType[91],DateDebut,DateFin,i,TRUE);
                          PurgeStats(TexteType[91],DateDebut,DateFin,i,TRUE);
                          PurgeStats(TexteType[93],DateDebut,DateFin,i,TRUE);
                          PurgeStats(TexteType[94],DateDebut,DateFin,i,TRUE);
                          PurgeStats(TexteType[95],DateDebut,DateFin,i,TRUE);
                          PurgeStats(TexteType[96],DateDebut,DateFin,i,TRUE);
                          PurgeStats(TexteType[97],DateDebut,DateFin,i,TRUE);
                          PurgeStats(TexteType[98],DateDebut,DateFin,i,TRUE);
                          PurgeStats(TexteType[99],DateDebut,DateFin,i,TRUE);
                          TraitementSpecifique.InitRequest(DateDebut,DateFin,i);
                          TraitementSpecifique.RUN;
                       END;
                       i := i + 1;
                      UNTIL i = 5;
                   END;
                   Historique.CreerHistorique(NumSuivEcr,'',3,8001301);
                 */
                if Stats.Find('+') then
                    NombreCree := Stats."Entry No." - NombreCree
                else
                    NombreCree := 0;

            end;

            trigger OnPostDataItem()
            begin

                if GuiAllowed then Fenetre.Open(Update);
                if Cloture then
                    ParametresStatistiques."Last close date" := DateFin;
                ParametresStatistiques."Last aggregate process date" := WorkDate;
                ParametresStatistiques."Last aggregate process time" := Time;
                ParametresStatistiques.Modify;
                if GuiAllowed and CurrReport.UseRequestPage then
                    Message(Fin, HeureD, Time, NombreCree, Round((Time - HeureD) / 60000));
            end;

            trigger OnPreDataItem()
            begin


                HeureD := Time;
                CreerTableauType;

                // Mise à jour de la table avec les types de mouvements, ...
                CODEUNIT.Run(CODEUNIT::"StatsExporer Init");

                if DeleteStatistics then begin
                    if GuiAllowed then Fenetre.Open(Purge1);
                    LignesStatistiquesTemp.LockTable;
                    LignesStatistiquesTemp.DeleteAll;
                    ColonnesStatistiquesTemp.LockTable;
                    ColonnesStatistiquesTemp.DeleteAll;
                    ResultatsStatistiquesTemp.LockTable;
                    ResultatsStatistiquesTemp.DeleteAll;
                    DefinitionStatistiquesTemp.LockTable;
                    DefinitionStatistiquesTemp.DeleteAll;
                    if GuiAllowed then Fenetre.Close;
                end;

                if GuiAllowed then Fenetre.Open(Purge2);
                if (FiltreType = '') and (TypeTreatment = TypeTreatment::All) then begin
                    Stats.Reset;
                    if ParametresStatistiques."Allow Changes in Period Length" then begin
                        Stats.SetRange("Period Length", BasePeriode);
                        Stats.SetCurrentKey("Period Length", "Ending Date");
                    end else
                        Stats.SetCurrentKey("Ending Date");
                    Stats.SetRange("Ending Date", DateDebut, DateFin);
                    Stats.SetFilter("Entry Type", '<>Previsions');
                    Stats.DeleteAll;
                    Stats.Reset;
                end else begin
                    if not AccordingToEveryFlow then begin
                        i := 1;
                        repeat
                            if TraiterType[i] then
                                PurgeStats(TexteType[i], DateDebut, DateFin, BasePeriode, true);
                            i := i + 1;
                        until i = 100;
                    end;
                end;
                if Format(ParametresStatistiques."Historic duration") <> '' then begin
                    Historique.SetRange(Date, 19000101D, CalcDate('-' + Format(ParametresStatistiques."Historic duration"), WorkDate));
                    Historique.SetRange("Type of Treatment", Historique."Type of Treatment"::Report);
                    Historique.SetRange("Treatment No.", 8001301);
                    Historique.DeleteAll;
                    Historique.Reset;
                end;
                if Stats.Find('+') then
                    NombreCree := Stats."Entry No."
                else
                    NombreCree := 0;


                if GuiAllowed then Fenetre.Close;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(BasePeriode; BasePeriode)
                {
                    Caption = 'Base période';
                }
                field(DateDebut; DateDebut)
                {
                    Caption = 'Date début';
                }
                field(DateFin; DateFin)
                {
                    Caption = 'Date fin';
                }
                field(DeleteStatistics; DeleteStatistics)
                {
                    Caption = 'Supprimer statistiques';

                    trigger OnValidate()
                    begin
                        if Cloture then
                            if not Confirm(Confirm1, false, DateFin) then
                                Cloture := false
                            else
                                DateDebut := ParametresStatistiques."Last close date";
                    end;
                }
                field(FiltreType; FiltreType)
                {
                    Caption = 'Filtre type écritures';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Categorie: Record "Statistic category";
                    begin
                        Critere.FilterGroup(7);
                        Critere.SetRange(Type, Critere.Type::Flow);
                        Critere.SetRange(Enabled, true);
                        Critere.FilterGroup(0);
                        if PAGE.RunModal(0, Critere) = ACTION::LookupOK then
                            FiltreType := Critere."Field name";
                        Critere.Reset;
                    end;

                    trigger OnValidate()
                    begin
                        if FiltreType <> '' then begin
                            Critere.FilterGroup(7);
                            Critere.SetRange(Type, Critere.Type::Flow);
                            Critere.SetFilter("Field name", '%1', '@' + FiltreType + '*');
                            Critere.SetRange(Enabled, true);
                            Critere.FilterGroup(0);
                            if Critere.Find('-') then
                                FiltreType := Critere."Field name"
                            else
                                FiltreType := '';
                            Critere.Reset;
                        end;
                    end;
                }
                field(TypeTreatment; TypeTreatment)
                {
                    Caption = 'Type de calcul';
                }
                field(Cloture; Cloture)
                {
                    Caption = 'Cloturer période';

                    trigger OnValidate()
                    begin
                        if Cloture then
                            if not Confirm(Confirm1, false, DateFin) then
                                Cloture := false
                            else
                                DateDebut := ParametresStatistiques."Last close date";
                    end;
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            //            DateDebut := 010118D;
            //            DateFin := CALCDATE('<+5M+CM>',WORKDATE);
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin

        with ParametresStatistiques do begin
            Get;
            BasePeriode := "Period total basis";
            if "Period total basis" = "Period total basis"::"According to every flow" then
                AccordingToEveryFlow := true
            else
                AccordingToEveryFlow := false;
            DeleteStatistics := true;
            Cloture := false;
            if "Last calculation start date" <> 0D then
                DateDebut := "Last calculation start date"
            else
                if "Last close date" <> 0D then
                    DateDebut := "Last close date" + 1
                else
                    DateDebut := CalcDate('-' + ConvertirFormuleDate.ConvertDateFormula(4), WorkDate);

            if ("Last calculation end date" <> 0D) then
                DateFin := "Last calculation end date"
            else
                DateFin := CalcDate('+' + ConvertirFormuleDate.ConvertDateFormula(4), WorkDate);

            if DateFin < DateDebut then
                DateFin := CalcDate('+' + ConvertirFormuleDate.ConvertDateFormula(4), WorkDate);
        end;
        DateDebut := CalcDate('<-90D>', Today);
        //DateDebut := 010125D;
        DateFin := CalcDate('<+1M>', Today);


        //DateDebut := 010122D;
        //DateDebut := 010120D;
        //DateFin := TODAY;
    end;

    trigger OnPreReport()
    begin

        if (DateDebut = 0D) or (DateFin = 0D) then
            Error(Date1);

        if DateDebut > DateFin then
            Error(Date2);

        if DateDebut <= ParametresStatistiques."Last close date" then
            Error(Date3, ParametresStatistiques."Last close date");

        with ParametresStatistiques do begin
            Get;
            "Last calculation start date" := DateDebut;
            "Last calculation end date" := DateFin;
            if "Allow Changes in Period Length" then
                "Period total basis" := BasePeriode
            else
                BasePeriode := "Period total basis";
            Modify;
        end;
    end;

    var
        Stats: Record "Statistic aggregate";
        ParametresStatistiques: Record "Statistics setup";
        LignesStatistiquesTemp: Record "Statistic array line";
        ColonnesStatistiquesTemp: Record "Statistic array column";
        ResultatsStatistiquesTemp: Record "Statistic cell";
        DefinitionStatistiquesTemp: Record "Statistic definition";
        Historique: Record "History treatment";
        ConvertirFormuleDate: Codeunit "StatsExplorer, Tools";
        AccordingToEveryFlow: Boolean;
        TexteType: array[100] of Text[30];
        TraiterType: array[100] of Boolean;
        BasePeriode: Option Jour,Semaine,Mois,Trimestre,"Année","Période";
        DateDebut: Date;
        DateDebutTmp: Date;
        DateFin: Date;
        DateFinTmp: Date;
        NombreCree: Integer;
        Fenetre: Dialog;
        HeureD: Time;
        Cloture: Boolean;
        Date1: Label 'From and to dates required';
        Date2: Label 'From date must be less than to date';
        Date3: Label 'You can''t processed before %1';
        Purge1: Label 'Deleting user statistic...';
        Purge2: Label 'Delete aggregate';
        Update: Label 'Updating database...';
        Fin: Label 'Job finished from %1 to %2, %3  entries processed (%4 mn)';
        Confirm1: Label 'Confirm aggregates closing on %1 ?';
        NumSuivEcr: Integer;
        BasePeriodeEcritureJour: array[100] of Boolean;
        BasePeriodeEcritureSemaine: array[100] of Boolean;
        BasePeriodeEcritureMois: array[100] of Boolean;
        BasePeriodeEcritureTrimestre: array[100] of Boolean;
        BasePeriodeEcritureAnnee: array[100] of Boolean;
        BasePeriodeEcriturePeriode: array[100] of Boolean;
        i: Integer;
        FiltreType: Text[80];
        Critere: Record "Statistic criteria";
        TypeTreatment: Option All,"Only new entries";
        DeleteStatistics: Boolean;

    [Scope('OnPrem')]
    procedure InitRequete(CalculDateDebut: Code[10]; CalculDateFin: Code[10]; BasePeriodeCalcul: Option Jour,Semaine,Mois,Trimestre,"Année","Période"; wTypeTreatment: Option All,"Only non-real time entries")
    begin
        DateDebut := CalcDate(CalculDateDebut, WorkDate);
        DateFin := CalcDate(CalculDateFin, WorkDate);
        BasePeriode := BasePeriodeCalcul;
        TypeTreatment := wTypeTreatment;
    end;

    [Scope('OnPrem')]
    procedure CreerTableauType()
    var
        CritereStat: Record "Statistic criteria";
    begin
        CritereStat.SetRange(Type, CritereStat.Type::Flow);

        if CritereStat.Find('-') then
            repeat
                TexteType[CritereStat."Field No."] := CritereStat."Field name";
                if (FiltreType <> '') and (FiltreType <> TexteType[CritereStat."Field No."]) then
                    TraiterType[CritereStat."Field No."] := false
                else
                    TraiterType[CritereStat."Field No."] := CritereStat.Enabled;
                if TypeTreatment <> TypeTreatment::All then
                    if (ParametresStatistiques."Aggregate, real time update") and (CritereStat."Real-Time Update") then
                        TraiterType[CritereStat."Field No."] := false;
                BasePeriodeEcritureJour[CritereStat."Field No."] := CritereStat."Process aggregate by day";
                BasePeriodeEcritureSemaine[CritereStat."Field No."] := CritereStat."Process aggregate by week";
                BasePeriodeEcritureMois[CritereStat."Field No."] := CritereStat."Process aggregate by month";
                BasePeriodeEcritureTrimestre[CritereStat."Field No."] := CritereStat."Process aggregate by quarter";
                BasePeriodeEcritureAnnee[CritereStat."Field No."] := CritereStat."Process aggregate by year";
                BasePeriodeEcriturePeriode[CritereStat."Field No."] := CritereStat."Process aggregate by period";
            until CritereStat.Next = 0;
    end;

    [Scope('OnPrem')]
    procedure RecherchePeriodicite(TypePeriode: Integer; NumeroEcriture: Integer) Return: Boolean
    begin
        case TypePeriode of
            0:
                if BasePeriodeEcritureJour[NumeroEcriture] then
                    exit(true);
            1:
                if BasePeriodeEcritureSemaine[NumeroEcriture] then
                    exit(true);
            2:
                if BasePeriodeEcritureMois[NumeroEcriture] then
                    exit(true);
            3:
                if BasePeriodeEcritureTrimestre[NumeroEcriture] then
                    exit(true);
            4:
                if BasePeriodeEcritureAnnee[NumeroEcriture] then
                    exit(true);
            5:
                if BasePeriodeEcriturePeriode[NumeroEcriture] then
                    exit(true);
        end;
        exit(false);
    end;

    [Scope('OnPrem')]
    procedure PurgeStats(wTypeEcriture: Text[30]; wDateD: Date; wDateF: Date; wBasePeriode: Option Jour,Semaine,Mois,Trimestre,"Année","Période"; wFiltreType: Boolean)
    begin
        if (FiltreType <> '') or (not wFiltreType) then begin
            Stats.Reset;
            Stats.SetCurrentKey("Period Length", "Entry Type", "Ending Date");
            Stats.SetRange("Period Length", wBasePeriode);
            Stats.SetRange("Entry Type", wTypeEcriture);
            Stats.SetRange("Ending Date", wDateD, wDateF);
            Stats.DeleteAll;
            Stats.Reset;
        end;
    end;
}

