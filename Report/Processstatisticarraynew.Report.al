report 8001315 "Process statistic array new"
{
    // //STATSEXPLORER STATSEXPLORER 01/01/00 Moteur de calcul de tableaux statistiques multi-critères
    //                 CW     12/04/01 contrÔÇ£le clé revu

    Caption = 'Process statistic array';
    Permissions = TableData "Country/Region" = r,
                  TableData "Country/Region Translation" = r,
                  TableData "Salesperson/Purchaser" = r,
                  TableData Location = r,
                  TableData "G/L Account" = r,
                  TableData Customer = r,
                  TableData Vendor = r,
                  TableData Item = r,
                  TableData "Customer Posting Group" = r,
                  TableData "Vendor Posting Group" = r,
                  TableData "Inventory Posting Group" = r,
                  TableData "Resource Group" = r,
                  TableData Resource = r,
                  TableData Job = r,
                  TableData "Work Type" = r,
                  TableData "Job Posting Group" = r,
                  TableData "Reason Code" = r,
                  TableData "Gen. Business Posting Group" = r,
                  TableData "Gen. Product Posting Group" = r,
                  TableData Employee = r,
                  TableData "Cause of Absence" = r;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Stat; "Statistic aggregate")
        {
            DataItemTableView = SORTING("Entry No.");
            MaxIteration = 1;
            RequestFilterFields = "Period Length", "Salespers./Purch. Code", "Location Code", "Inventory Posting Group", Type, "No.", "Source Type", "Source No.";

            trigger OnPreDataItem()
            begin
                Statistiques.SetRange("User ID", User);
                Statistiques.SetRange("Statistic code", CodePredefini);
                Statistiques.DeleteAll;

                CreerTableauTypeDeColonne;

                //StatistiquesPredefinies.GET(CodePredefini)
                if DateFinSituationPredefini <> 0D then
                    CopierFiltresPredefinis;

                RechercherNumeroChamp;

                // Création de la table définition
                CreerTableDefinition;

                CreerTableauColonnes;
                // Mise à jour des clés
                // On recherche la date mini et maxi pour chaque type (achat, vente, etc...)
                // Puis on met à jour les clés par type de mouvement
                CritereTri.Reset;
                CritereTri.SetRange(Type, CritereTri.Type::Flow);
                SocieteStatistique.SetRange("Statistic code", CodePredefini);
                ParametresComptabilite.Get;
                repeat
                    CalculerDateMiniMaxi(CritereTri."Field name");
                    if (DateMini <> 0D) and (DateMaxi <> 0D) then begin
                        CompleterCles(CritereTri."Field name", CompanyName);
                        if SocieteStatistique.Find('-') then
                            repeat
                                if SocieteStatistique.Company <> CompanyName then
                                    CompleterCles(CritereTri."Field name", SocieteStatistique.Company);
                            until SocieteStatistique.Next = 0;
                    end;
                until CritereTri.Next = 0;
            end;
        }
        dataitem(Statistiques; "Temp. statistic")
        {
            DataItemTableView = SORTING("User ID", "Statistic code", "Key 1", "Key 2", "Key 3", "Key 4", "Key 5", "Key 6", "Key 7", "Key 8", "Entry No.");

            trigger OnAfterGetRecord()
            begin


                Clear(Col_Resultat);

                n := 1;
                repeat
                    //   MESSAGE('%1',CleTri[n]);
                    if (TotalTri[n] = 0) and (CleTri[n] <> '') then begin
                        CalcTotalLines(n);
                        //GrpHeader
                        NumeroSequence := NumeroSequence + 1;
                        NumeroLigne[n + 1] := NumeroSequence;
                        //MESSAGE('A  %1   %2',n+1,NumeroSequence);
                        NombreLignes[n + 2] := 0;
                    end;
                    if (TotalTri[n] = -1) and (CleTri[n] <> '') then begin
                        NumeroSequence := NumeroSequence + 1;
                        NumeroLigne[n + 1] := NumeroSequence;
                        //MESSAGE('A  %1   %2',n+1,NumeroSequence);
                        NombreLignes[n + 2] := 0;

                    end;

                    if (TotalTri[n] = -1) then begin
                        CalcTotalLines(n); // First init
                                           //    NumeroSequence := NumeroSequence + 1;
                                           //    NumeroLigne[n+1] := NumeroSequence;
                                           //    NombreLignes[n+2] := 0;
                    end;

                    n := n + 1;
                until n > 10;


                CptrLig := CptrLig + 1;
                if GuiAllowed then Fenetre.Update(2, Round(CptrLig / NbreEnreg * 10000, 1));

                Valeur[1] := "Key 1";
                Valeur[2] := "Key 2";
                Valeur[3] := "Key 3";
                Valeur[4] := "Key 4";
                Valeur[5] := "Key 5";
                Valeur[6] := "Key 6";
                Valeur[7] := "Key 7";
                Valeur[8] := "Key 8";
                Valeur[9] := "Key 9";
                Valeur[10] := "Key 10";

                CalculerTableauResultats;

                xStatistiques := Statistiques;


                i := 0;
                repeat
                    i := i + 1;
                    n := 1;
                    repeat
                        Col_Resultat_Sum[i, n] := Col_Resultat_Sum[i, n] + Col_Resultat[i];
                        n += 1;
                    until n > 10;
                    Col_Resultat_Tot[i] := Col_Resultat_Tot[i] + Col_Resultat[i];
                until i = NombreColonnes;

                n := 1;
                repeat
                    if CleTri[n] <> '' then TotalTri[n] += -1;

                    if (TotalTri[n] = 0) and (CleTri[n] <> '') then begin

                        //GrpFooter
                        TableauCles[1] := "Key 1";
                        TableauCles[2] := "Key 2";
                        TableauCles[3] := "Key 3";
                        TableauCles[4] := "Key 4";
                        TableauCles[5] := "Key 5";
                        TableauCles[6] := "Key 6";
                        TableauCles[7] := "Key 7";
                        TableauCles[8] := "Key 8";
                        TableauCles[9] := "Key 9";
                        TableauCles[10] := "Key 10";
                        GroupFooter(n);



                    end;
                    n += 1;
                until n > 10;

            end;

            trigger OnPostDataItem()
            begin


                i := 0;
                repeat
                    i := i + 1;
                    Col_Resultat[i] := Col_Resultat_Tot[i];
                until i = NombreColonnes;
                CalculerTotaux;
                ArrondirMontants;
                NumeroSequence := NumeroSequence + 1;
                NumeroLigne[1] := NumeroSequence;
                i := 0;
                repeat
                    i := i + 1;
                    TableauCles[i] := '';
                until i = 10;
                EcrireResultats(1, TexteTotalGeneral, TexteTotalGeneral, '');

            end;

            trigger OnPreDataItem()
            begin
                Statistiques.SetRange("User ID", User);
                Statistiques.SetRange("Statistic code", CodePredefini);

                if GuiAllowed then Fenetre.Open(FenetreCalcul, CodePredefini);

                NbreEnreg := Count;

                i := 0;
                repeat
                    i := i + 1;

                until i = NombreColonnes;


                TotalTri[1] := -1;
                TotalTri[2] := -1;
                TotalTri[3] := -1;
                TotalTri[4] := -1;
                TotalTri[5] := -1;
                TotalTri[6] := -1;
                TotalTri[7] := -1;
                TotalTri[8] := -1;
                TotalTri[9] := -1;
                TotalTri[10] := -1;

            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    var
        ConvertirFormuleDate: Codeunit "StatsExplorer, Tools";
    begin
        DateFinSituation := CalcDate('<+' + Format(ConvertirFormuleDate.ConvertDateFormula(3)) + '>', WorkDate);
    end;

    trigger OnPostReport()
    begin
        if GuiAllowed then Fenetre.Open(FenetreTotalisation, CodePredefini);
        // Si au moins une colonne de calcul de %, on lance le report de calcul
        if CalculerPourcentages then begin
            ReportCalculPourcentages.InitRequete(CodePredefini, 0, User);
            ReportCalculPourcentages.RunModal;
        end;

        Statistiques.FilterGroup(7);
        Statistiques.SetRange("User ID", User);
        Statistiques.FilterGroup(0);
        //Statistiques.DELETEALL;

        FiltreTemporaire.FilterGroup(7);
        FiltreTemporaire.SetRange("User ID", User);
        FiltreTemporaire.FilterGroup(0);
        FiltreTemporaire.DeleteAll;

        // Stockage date et heure de traitement
        DefinitionStatistiqueTemp.Init;
        DefinitionStatistiqueTemp."User ID" := User;
        DefinitionStatistiqueTemp."Statistic code" := CodePredefini;
        DefinitionStatistiqueTemp."Line No." := 2000000;
        DefinitionStatistiqueTemp.Insert;

        DefinitionStatistiqueTemp.Init;
        DefinitionStatistiqueTemp."User ID" := User;
        DefinitionStatistiqueTemp."Statistic code" := CodePredefini;
        DefinitionStatistiqueTemp."Line No." := 2010000;
        DefinitionStatistiqueTemp.Description := StrSubstNo(TexteDureeTraitement, Format(WorkDate, 0, 4), HeureDebut, Time);
        DefinitionStatistiqueTemp.Insert;
    end;

    trigger OnPreReport()
    var
        AddOnKey: Record "Add-On Licence";
        LicenceID: Code[30];
        GranuleID: Code[20];
        CodeID: Integer;
        lExpiration: Integer;
        lReturn: Integer;
    begin
        ParametresStatistiques.Get;
        LicenceID := SerialNumber;
        GranuleID := '8001310';
        /*
       IF (STRPOS(COMPANYNAME,'CRONUS') <> 1) THEN
          IF (AddOnKey.GET(GranuleID,LicenceID)) AND (AddOnKey."Granule Key" <> '') THEN BEGIN
             IF CheckGranuleKey(AddOnKey."Granule Key",SERIALNUMBER,GranuleID) < 0 THEN
                ERROR(Error13);
          END ELSE
             IF StatistiquesPredefinies.COUNT > 5 THEN
                ERROR(Error13);
       */
        HeureDebut := Time;

        if User = '' then
            User := UserId;

        // DateFinSituationPredefini <> 0D, le report a été appelé par l'option stats prédéfinies
        if DateFinSituationPredefini <> 0D then begin
            DateDebutSituation := DateDebutSituationPredefini;
            DateFinSituation := DateFinSituationPredefini;
            if StatistiquesPredefinies.Get(CodePredefini) then begin
                // On regarde si filtres temporaires
                if FiltreTemporaire.Get(User, CodePredefini) then begin
                    StatistiquesPredefinies.TransferFields(FiltreTemporaire);
                end;
                CodeColonne := StatistiquesPredefinies."Column Layout Name";
                if StatistiquesPredefinies."Sort criteria" <> '' then
                    RechercherTriStatistique(StatistiquesPredefinies."Sort criteria");
            end else
                Error(Error2);
        end;

        if CodePredefini = '' then
            CodePredefini := TexteCodePredefini;

        if not PermissionStatistique.Autorisation(PermissionStatistique.Type::Statistique, CodePredefini, User) then
            Error(Error1, User, CodePredefini);

        // Stockage dernière stat calculée
        if DefinitionStatistiqueTemp.Get(User, '', 0) then
            DefinitionStatistiqueTemp.Delete;
        DefinitionStatistiqueTemp.Init;
        DefinitionStatistiqueTemp."User ID" := User;
        DefinitionStatistiqueTemp."Statistic code" := '';
        DefinitionStatistiqueTemp."Line No." := 0;
        DefinitionStatistiqueTemp.Description := CodePredefini;
        DefinitionStatistiqueTemp.Insert;

        if CodeColonne = '' then
            Error(Error3);
        if (Stat.GetFilter("Ending Date") <> '') or
           (StrSubstNo('%1', Stats.GetFilter("Entry Type")) <> '') then
            Error(Error4);
        if DateFinSituation = 0D then
            Error(Error5);

        if Stat.GetFilter("Period Length") = '' then
            Stat.SetRange("Period Length", Stats."Period Length"::Month);

        if GuiAllowed then Fenetre.Open(FenetrePreparation, CodePredefini);
        NomColonneStatistique.Get(CodeColonne);

        ColonnesStatistiques.Reset;
        ColonnesStatistiques.SetRange(Code, CodeColonne);
        ColonnesStatistiques.SetFilter("Column No.", '<>%1', '');
        NombreColonnes := ColonnesStatistiques.Count;
        if NombreColonnes = 0 then
            Error(Error6, CodeColonne)
        else
            if NombreColonnes > 1000 then
                Error(Error7);

        ColonnesStatistiques.SetRange(ColonnesStatistiques."Print column", ColonnesStatistiques."Print column"::Never);
        NombreColonnesImprimees := NombreColonnes - ColonnesStatistiques.Count;
        ColonnesStatistiques.Reset;

        ColonnesStatistiquesTemp.FilterGroup(7);
        ColonnesStatistiquesTemp.SetRange("User ID", User);
        ColonnesStatistiquesTemp.SetRange("Statistic code", CodePredefini);
        ColonnesStatistiquesTemp.FilterGroup(0);
        ColonnesStatistiquesTemp.DeleteAll;

        LignesStatistiquesTemp.FilterGroup(7);
        LignesStatistiquesTemp.SetRange("User ID", User);
        LignesStatistiquesTemp.SetRange("Statistic code", CodePredefini);
        LignesStatistiquesTemp.FilterGroup(0);
        LignesStatistiquesTemp.DeleteAll;

        DefinitionStatistiqueTemp.FilterGroup(7);
        DefinitionStatistiqueTemp.SetRange("User ID", User);
        DefinitionStatistiqueTemp.SetRange("Statistic code", CodePredefini);
        DefinitionStatistiqueTemp.FilterGroup(0);
        DefinitionStatistiqueTemp.DeleteAll;

        ResultatsStatistiquesTemp.FilterGroup(7);
        ResultatsStatistiquesTemp.SetRange("User ID", User);
        ResultatsStatistiquesTemp.SetRange("Statistic code", CodePredefini);
        ResultatsStatistiquesTemp.FilterGroup(0);
        ResultatsStatistiquesTemp.DeleteAll;
        NumeroSequence := 0;

        if not ParametresStatistiques.Get then
            ParametresStatistiques.Init;

    end;

    var
        zStat: Record "Statistic aggregate";
        ParametresStatistiques: Record "Statistics setup";
        Stats: Record "Statistic aggregate";
        xStatistiques: Record "Temp. statistic";
        Article: Record Item;
        Ressource: Record Resource;
        Compte: Record "G/L Account";
        CritereTri: Record "Statistic criteria";
        CritereTri2: Record "Statistic criteria";
        SelectionStatistique: Record "Statistic sort criteria";
        ColonnesStatistiques: Record "Statistic column";
        FiltreColonneStatistique: Record "Statistic column filter";
        NomColonneStatistique: Record "Column style name";
        LignesStatistiquesTemp: Record "Statistic array line";
        LignesStatistiquesTemp2: Record "Statistic array line";
        ColonnesStatistiquesTemp: Record "Statistic array column";
        ResultatsStatistiquesTemp: Record "Statistic cell";
        DefinitionStatistiqueTemp: Record "Statistic definition";
        StatistiquesPredefinies: Record "Standard statistic";
        PermissionStatistique: Record "Statistic Permission";
        FiltreTemporaire: Record "Temp. statistic filter";
        SocieteStatistique: Record "Statistic Company";
        ParametresComptabilite: Record "General Ledger Setup";
        ParametresComptabilite2: Record "General Ledger Setup";
        DeviseTauxChange: Record "Currency Exchange Rate";
        "Object": Record "Object";
        ReportCalculPourcentages: Report "Statistics : % compute";
        User: Code[100];
        CodePredefini: Code[10];
        CritereSelection: Code[10];
        CodeColonne: Code[10];
        NombreColonnes: Integer;
        NombreColonnesImprimees: Integer;
        Titre: Text[250];
        TexteTri: Text[250];
        DateFinSituation: Date;
        DateFinSituationPredefini: Date;
        DateDebutSituation: Date;
        DateDebutSituationPredefini: Date;
        HeureDebut: Time;
        DateMini: Date;
        DateMaxi: Date;
        TypeEcriture: Text[30];
        TypeValeur: array[100] of Text[30];
        CleTri: array[10] of Text[30];
        SautDePage: array[10] of Boolean;
        SeparateurAvant: array[10] of Option Aucun,"Ligne blanche","Trait fin","Trait normal","Trait épais";
        SeparateurApres: array[10] of Option Aucun,"Ligne blanche","Trait fin","Trait normal","Trait épais";
        PositionDebut: array[10] of Integer;
        Longueur: array[10] of Integer;
        NumeroChamp: array[10] of Integer;
        Fenetre: Dialog;
        NbreEnreg: Integer;
        CptrLig: Integer;
        NbrLig: Integer;
        TexteDetail: Text[100];
        i: Integer;
        j: Integer;
        Valeur: array[10] of Text[30];
        NouvellePage: array[10] of Boolean;
        LibelleRupture: array[10] of Text[100];
        Col_NoColonne: array[1024] of Code[10];
        Col_NoLigne: array[1024] of Integer;
        Col_TypeDeColonne: array[1024] of Text[30];
        Col_NumTypeDeColonne: array[1024] of Integer;
        Col_TypeEcriture: array[1024] of Text[30];
        Col_InversionSigne: array[1024] of Boolean;
        Col_ImprimerColonne: array[1024] of Option Toujours,Jamais,"Si positif","Si négatif";
        Col_UniteAffichage: array[1024] of Option Standard,"1","1000","1000000";
        Col_CalculDateDebut: array[1024] of DateFormula;
        Col_CalculDateFin: array[1024] of DateFormula;
        Col_Formule: array[1024] of Text[250];
        Col_Filtre: array[1024] of Boolean;
        Col_DateDebut: array[1024] of Date;
        Col_DateFin: array[1024] of Date;
        Col_DateDebutTitre: array[1024] of Date;
        Col_DateFinTitre: array[1024] of Date;
        Col_Resultat: array[1024] of Decimal;
        Col_Resultat2: array[1024] of Decimal;
        Col_ResultatCommeTexte: array[1024] of Text[30];
        Col_Titre1: array[1024] of Text[30];
        Col_LineTitle: array[1024] of Text[30];
        FormatStringNormal: Text[80];
        NiveauAppel: Integer;
        ErreurDivision: Boolean;
        TexteErreurFormule: Text[250];
        TexteFiltreColonne: array[250] of Text[250];
        ImprimerLigneBlanche: Boolean;
        NumeroSequence: Integer;
        NumeroLigne: array[11] of Integer;
        NombreLignes: array[11] of Integer;
        NonNul: Boolean;
        TableauCles: array[10] of Text[30];
        CalculerPourcentages: Boolean;
        NumLigSuivDefinition: Integer;
        Error1: Label 'The user %1 do not have permission to calculate statistic %2';
        Error2: Label 'Statistic code is required';
        Error3: Label 'Column layout is required';
        Error4: Label 'Dates forbiden for "To date" and "Entry type" fields';
        Error5: Label 'To date required';
        Error6: Label 'No compute column had be defined for %1 code';
        Error7: Label 'Max number of columns is 250';
        Error8: Label '%1 code not defined';
        Error9: Label 'Start position an length required';
        Error10: Label 'for the sort criteria %1, %2';
        Error11: Label 'From and to dates are required for the statistic %1';
        Error12: Label 'There is an operand missing for the column %1, statistic %2';
        Error13: Label 'Your license is limited to 5 standard statistics.\Contact the system manager for more information.';
        Error15: Label 'Your licence has expired.\Contact the system manager for more information.';
        ErrorFormule1: Label 'Bad value or column number not defined : %1';
        ErrorFormule2: Label 'Circular reference, Navision Fiancial can''t compute this formula : %1';
        FenetrePreparation: Label 'Prepare in progress #1######## ...';
        FenetreTotalisation: Label 'Create totals #1######## ...';
        FenetreCles: Label 'Sort #1######## #2################ @3@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
        FenetreCalcul: Label 'Calc. in progress #1######## @2@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
        TexteTexteTri: Label 'Sort by';
        TexteDateSituation: Label 'Situation at %1';
        TexteFiltres1: Label 'Filters :';
        TexteFiltres2: Label 'No filter';
        TextePresentation: Label 'Column style :';
        TexteColonne1: Label 'Column %1 - %2, Type %3 %4, From %5 to %6';
        TexteColonne2: Label 'Column %1 - %2, Type %3 based on column %4';
        TexteColonne3: Label 'Column %1 - %2, %3 : %4';
        TexteFiltreComplementaire: Label 'Additional filter :';
        TexteDureeTraitement: Label 'Calc. done on %1 from %2 to %3';
        TexteCodePredefini: Label 'MANUAL';
        TexteTotalGeneral: Label 'GRAND TOTAL';
        PrimeConstant: Integer;
        Minimum: Integer;
        MaxiCode: Integer;
        TexteAnnee: Label 'Year';
        TexteSemestre: Label 'Half Year';
        TexteTrimestre: Label 'Quarter';
        TexteMois: Label 'Month';
        TexteSemaine: Label 'Week';
        TotalTri: array[10] of Integer;
        n: Integer;
        Stats2: Record "Temp. statistic";
        Col_Resultat_Sum: array[1024, 12] of Decimal;
        Col_Resultat_Tot: array[1024] of Decimal;

    [Scope('OnPrem')]
    procedure InitRequete(CodeStatistiquePredefini: Code[10]; DateDebut: Date; DateFin: Date; Utilisateur: Code[50])
    begin
        CodePredefini := CodeStatistiquePredefini;
        DateDebutSituationPredefini := DateDebut;
        DateFinSituationPredefini := DateFin;
        if Utilisateur = '' then
            User := UserId
        else
            User := Utilisateur;
    end;

    [Scope('OnPrem')]
    procedure AfficherCritereTri(Valeur: Integer)
    begin
        if Valeur <> 0 then begin
            SautDePage[Valeur] := false;
            if CritereTri.Get(CritereTri.Type::"Sort criteria", CleTri[Valeur]) then begin
                PositionDebut[Valeur] := 1;
                Longueur[Valeur] := CritereTri.Length;
            end else begin
                PositionDebut[Valeur] := 0;
                Longueur[Valeur] := 0;
            end;
        end;

        //     RequestOptionsForm.CleTri2.VISIBLE((CleTri[1] <> '')OR(CleTri[2] <> ''));
        //     RequestOptionsForm.CleTri3.VISIBLE((CleTri[2] <> '')OR(CleTri[3] <> ''));
        //     RequestOptionsForm.CleTri4.VISIBLE((CleTri[3] <> '')OR(CleTri[4] <> ''));
        //     RequestOptionsForm.CleTri5.VISIBLE((CleTri[4] <> '')OR(CleTri[5] <> ''));
        //     RequestOptionsForm.CleTri6.VISIBLE((CleTri[5] <> '')OR(CleTri[6] <> ''));
        //     RequestOptionsForm.CleTri7.VISIBLE((CleTri[6] <> '')OR(CleTri[7] <> ''));
        //     RequestOptionsForm.CleTri8.VISIBLE((CleTri[7] <> '')OR(CleTri[8] <> ''));
        //     RequestOptionsForm.CleTri9.VISIBLE((CleTri[8] <> '')OR(CleTri[9] <> ''));
        //     RequestOptionsForm.CleTri10.VISIBLE((CleTri[9] <> '')OR(CleTri[10] <> ''));
    end;

    [Scope('OnPrem')]
    procedure CopierFiltresPredefinis()
    begin
        with StatistiquesPredefinies do begin
            if "Period Length" <> "Period Length"::"By column" then
                Stat.SetRange("Period Length", "Period Length");
            if Type <> Type::" " then
                Stat.SetRange(Type, Type - 1);
            Stat.SetFilter("No.", "No.");
            if "Source Type" <> "Source Type"::" " then
                Stat.SetRange("Source Type", "Source Type");
            Stat.SetFilter("Source No.", "Source No.");
            Stat.SetFilter("Location Code", "Location Code");
            Stat.SetFilter("Inventory Posting Group", "Inventory Posting Group");
            Stat.SetFilter("Source Posting Group", "Source Posting Group");
            Stat.SetFilter("Gen. Bus. Posting Group", "Gen. Bus. Posting Group");
            Stat.SetFilter("Gen. Prod. Posting Group", "Gen. Prod. Posting Group");
            Stat.SetFilter("Salespers./Purch. Code", "Salespers./Purch. Code");
            Stat.SetFilter("Global Dimension 1 Code", "Global Dimension 1 Code");
            Stat.SetFilter("Global Dimension 2 Code", "Global Dimension 2 Code");
            Stat.SetFilter("Country Code", "Country Code");
            Stat.SetFilter("Business Unit Code", "Business Unit Code");
            Stat.SetFilter("Consol. Debit Acc.", "Consol. Debit Acc.");
            Stat.SetFilter("Consol. Credit Acc.", "Consol. Credit Acc.");
            Stat.SetFilter("Back disc./commission rule No.", "Back disc./commission rule No.");
            Stat.SetFilter(Year, Year);
            Stat.SetFilter("Half Year", "Half Year");
            Stat.SetFilter(Quarter, Quarter);
            Stat.SetFilter(Month, Month);
            Stat.SetFilter(Week, Week);
            Stat.SetFilter("Week Day", "Week Day");
            Stat.SetFilter("Fiscal year closing date", "Fiscal year closing date");
            Stat.SetFilter("Job No.", "Job No.");
            Stat.SetFilter("Phase Code", "Phase Code");
            Stat.SetFilter("Task Code", "Task Code");
            Stat.SetFilter("Step Code", "Step Code");
            Stat.SetFilter("Work Type Code", "Work Type Code");
            Stat.SetFilter("Job Posting Group", "Job Posting Group");
            Stat.SetFilter("Resource Group No.", "Resource Group No.");
            Stat.SetFilter("Person Responsible", "Person Responsible");
            Stat.SetFilter("Campaign No.", "Campaign No.");
            Stat.SetFilter("Reason Code", "Reason Code");
            Stat.SetFilter("Item Charge No.", "Item Charge No.");
            Stat.SetFilter("Variant Code", "Variant Code");
            Stat.SetFilter("Return Reason Code", "Return Reason Code");
            Stat.SetFilter("Manufacturer Code", "Manufacturer Code");
            Stat.SetFilter("Item Category Code", "Item Category Code");
            Stat.SetFilter("Product Group Code", "Product Group Code");
            Stat.SetFilter("Service Item Group", "Service Item Group");
            Stat.SetFilter("Item criteria 1", "Item criteria 1");
            Stat.SetFilter("Item criteria 2", "Item criteria 2");
            Stat.SetFilter("Item criteria 3", "Item criteria 3");
            Stat.SetFilter("Item criteria 4", "Item criteria 4");
            Stat.SetFilter("Item criteria 5", "Item criteria 5");
            Stat.SetFilter("Item criteria 6", "Item criteria 6");
            Stat.SetFilter("Item criteria 7", "Item criteria 7");
            Stat.SetFilter("Item criteria 8", "Item criteria 8");
            Stat.SetFilter("Item criteria 9", "Item criteria 9");
            Stat.SetFilter("Item criteria 10", "Item criteria 10");
            Stat.SetFilter("Customer criteria 1", "Customer criteria 1");
            Stat.SetFilter("Customer criteria 2", "Customer criteria 2");
            Stat.SetFilter("Customer criteria 3", "Customer criteria 3");
            Stat.SetFilter("Customer criteria 4", "Customer criteria 4");
            Stat.SetFilter("Customer criteria 5", "Customer criteria 5");
            Stat.SetFilter("Customer criteria 6", "Customer criteria 6");
            Stat.SetFilter("Customer criteria 7", "Customer criteria 7");
            Stat.SetFilter("Customer criteria 8", "Customer criteria 8");
            Stat.SetFilter("Customer criteria 9", "Customer criteria 9");
            Stat.SetFilter("Customer criteria 10", "Customer criteria 10");
            Stat.SetFilter("Job criteria 1", "Job criteria 1");
            Stat.SetFilter("Job criteria 2", "Job criteria 2");
            Stat.SetFilter("Job criteria 3", "Job criteria 3");
            Stat.SetFilter("Job criteria 4", "Job criteria 4");
            Stat.SetFilter("Job criteria 5", "Job criteria 5");
            Stat.SetFilter("Job criteria 6", "Job criteria 6");
            Stat.SetFilter("Job criteria 7", "Job criteria 7");
            Stat.SetFilter("Job criteria 8", "Job criteria 8");
            Stat.SetFilter("Job criteria 9", "Job criteria 9");
            Stat.SetFilter("Job criteria 10", "Job criteria 10");
            Stat.SetFilter("Free date 1", "Free date 1");
            Stat.SetFilter("Free date 2", "Free date 2");
            Stat.SetFilter("Free date 3", "Free date 3");
            Stat.SetFilter("Free date 4", "Free date 4");
            Stat.SetFilter("Free date 5", "Free date 5");
            Stat.SetFilter("Free field 1", "Free field 1");
            Stat.SetFilter("Free field 2", "Free field 2");
            Stat.SetFilter("Free field 3", "Free field 3");
            Stat.SetFilter("Free field 4", "Free field 4");
            Stat.SetFilter("Free field 5", "Free field 5");
            Stat.SetFilter("Free field 6", "Free field 6");
            Stat.SetFilter("Free field 7", "Free field 7");
            Stat.SetFilter("Free field 8", "Free field 8");
            Stat.SetFilter("Free field 9", "Free field 9");
            Stat.SetFilter("Free field 10", "Free field 10");
            Stat.SetFilter("Dimension 1 Value Code", "Dimension 1 Value Code");
            Stat.SetFilter("Dimension 2 Value Code", "Dimension 2 Value Code");
            Stat.SetFilter("Dimension 3 Value Code", "Dimension 3 Value Code");
            Stat.SetFilter("Dimension 4 Value Code", "Dimension 4 Value Code");
            Stat.SetFilter("Dimension 5 Value Code", "Dimension 5 Value Code");
            Stat.SetFilter("Dimension 6 Value Code", "Dimension 6 Value Code");
            Stat.SetFilter("Dimension 7 Value Code", "Dimension 7 Value Code");
            Stat.SetFilter("Dimension 8 Value Code", "Dimension 8 Value Code");
            Stat.SetFilter("Dimension 9 Value Code", "Dimension 9 Value Code");
            Stat.SetFilter("Dimension 10 Value Code", "Dimension 10 Value Code");
            Stat.SetFilter("Dimension 11 Value Code", "Dimension 11 Value Code");
            Stat.SetFilter("Dimension 12 Value Code", "Dimension 12 Value Code");
            Stat.SetFilter("Dimension 13 Value Code", "Dimension 13 Value Code");
            Stat.SetFilter("Dimension 14 Value Code", "Dimension 14 Value Code");
            Stat.SetFilter("Dimension 15 Value Code", "Dimension 15 Value Code");
            Stat.SetFilter("Dimension 16 Value Code", "Dimension 16 Value Code");
            Stat.SetFilter("Dimension 17 Value Code", "Dimension 17 Value Code");
            Stat.SetFilter("Dimension 18 Value Code", "Dimension 18 Value Code");
            Stat.SetFilter("Dimension 19 Value Code", "Dimension 19 Value Code");
            Stat.SetFilter("Dimension 20 Value Code", "Dimension 20 Value Code");
            case "Free boolean 1" of
                "Free boolean 1"::Yes:
                    Stat.SetRange("Free boolean 1", true);
                "Free boolean 1"::No:
                    Stat.SetRange("Free boolean 1", false);
            end;
            case "Free boolean 2" of
                "Free boolean 2"::Yes:
                    Stat.SetRange("Free boolean 2", true);
                "Free boolean 2"::No:
                    Stat.SetRange("Free boolean 2", false);
            end;
            case "Free boolean 3" of
                "Free boolean 3"::Yes:
                    Stat.SetRange("Free boolean 3", true);
                "Free boolean 3"::No:
                    Stat.SetRange("Free boolean 3", false);
            end;
            case "Free boolean 4" of
                "Free boolean 4"::Yes:
                    Stat.SetRange("Free boolean 4", true);
                "Free boolean 4"::No:
                    Stat.SetRange("Free boolean 4", false);
            end;
            case "Free boolean 5" of
                "Free boolean 5"::Yes:
                    Stat.SetRange("Free boolean 5", true);
                "Free boolean 5"::No:
                    Stat.SetRange("Free boolean 5", false);
            end;

            with StatistiquesPredefinies do begin
                CleTri[1] := "1st sort level";
                PositionDebut[1] := "Sort 1 : start pos.";
                Longueur[1] := "Sort 1 : length";
                SautDePage[1] := "Sort 1 : skip page";
                SeparateurAvant[1] := "Sort 1 : line before total";
                SeparateurApres[1] := "Sort 1 : line after total";

                CleTri[2] := "2nd sort level";
                PositionDebut[2] := "Sort 2 : start pos.";
                Longueur[2] := "Sort 2 : length";
                SautDePage[2] := "Sort 2 : skip page";
                SeparateurAvant[2] := "Sort 2 : line before total";
                SeparateurApres[2] := "Sort 2 : line after total";

                CleTri[3] := "3rd sort level";
                PositionDebut[3] := "Sort 3 : start pos.";
                Longueur[3] := "Sort 3 : length";
                SautDePage[3] := "Sort 3 : skip page";
                SeparateurAvant[3] := "Sort 3 : line before total";
                SeparateurApres[3] := "Sort 3 : line after total";

                CleTri[4] := "4th sort level";
                PositionDebut[4] := "Sort 4 : start pos.";
                Longueur[4] := "Sort 4 : length";
                SautDePage[4] := "Sort 4 : skip page";
                SeparateurAvant[4] := "Sort 4 : line before total";
                SeparateurApres[4] := "Sort 4 : line after total";

                CleTri[5] := "5th sort level";
                PositionDebut[5] := "Sort 5 : start pos.";
                Longueur[5] := "Sort 5 : length";
                SautDePage[5] := "Sort 5 : skip page";
                SeparateurAvant[5] := "Sort 5 : line before total";
                SeparateurApres[5] := "Sort 5 : line after total";

                CleTri[6] := "6th sort level";
                PositionDebut[6] := "Sort 6 : start pos.";
                Longueur[6] := "Sort 6 : length";
                SautDePage[6] := "Sort 6 : skip page";
                SeparateurAvant[6] := "Sort 6 : line before total";
                SeparateurApres[6] := "Sort 6 : line after total";

                CleTri[7] := "7th sort level";
                PositionDebut[7] := "Sort 7 : start pos.";
                Longueur[7] := "Sort 7 : length";
                SautDePage[7] := "Sort 7 : skip page";
                SeparateurAvant[7] := "Sort 7 : line before total";
                SeparateurApres[7] := "Sort 7 : line after total";

                CleTri[8] := "8th sort level";
                PositionDebut[8] := "Sort 8 : start pos.";
                Longueur[8] := "Sort 8 : length";
                SautDePage[8] := "Sort 8 : skip page";
                SeparateurAvant[8] := "Sort 8 : line before total";
                SeparateurApres[8] := "Sort 8 : line after total";

                CleTri[9] := "9th sort level";
                PositionDebut[9] := "Sort 9 : start pos.";
                Longueur[9] := "Sort 9 : length";
                SautDePage[9] := "Sort 9 : skip page";
                SeparateurAvant[9] := "Sort 9 : line before total";
                SeparateurApres[9] := "Sort 9 : line after total";

                CleTri[10] := "10th sort level";
                PositionDebut[10] := "Sort 10 : start pos.";
                Longueur[10] := "Sort 10 : length";
                SautDePage[10] := "Sort 10 : skip page";
                SeparateurAvant[10] := "Sort 10 : line before total";
                SeparateurApres[10] := "Sort 10 : line after total";
            end;
        end;
    end;

    [Scope('OnPrem')]
    procedure RechercherTriStatistique("code": Code[20])
    begin
        SelectionStatistique.Init;
        if (code = '') or (SelectionStatistique.Get(SelectionStatistique.Type::"Tri statistique", code)) then
            with SelectionStatistique do begin
                CleTri[1] := "1st sort level";
                PositionDebut[1] := SelectionStatistique."Sort 1 : start pos.";
                Longueur[1] := "Sort 1 : length";
                SautDePage[1] := "Sort 1 : skip page";
                SeparateurAvant[1] := "Sort 1 : line before total";
                SeparateurApres[1] := "Sort 1 : line after total";

                CleTri[2] := "2nd sort level";
                PositionDebut[2] := "Sort 2 : start pos.";
                Longueur[2] := "Sort 2 : length";
                SautDePage[2] := "Sort 2 : skip page";
                SeparateurAvant[2] := "Sort 2 : line before total";
                SeparateurApres[2] := "Sort 2 : line after total";

                CleTri[3] := "3rd sort level";
                PositionDebut[3] := "Sort 3 : start pos.";
                Longueur[3] := "Sort 3 : length";
                SautDePage[3] := "Sort 3 : skip page";
                SeparateurAvant[3] := "Sort 3 : line before total";
                SeparateurApres[3] := "Sort 3 : line after total";

                CleTri[4] := "4th sort level";
                PositionDebut[4] := "Sort 4 : start pos.";
                Longueur[4] := "Sort 4 : length";
                SautDePage[4] := "Sort 4 : skip page";
                SeparateurAvant[4] := "Sort 4 : line before total";
                SeparateurApres[4] := "Sort 4 : line after total";

                CleTri[5] := "5th sort level";
                PositionDebut[5] := "Sort 5 : start pos.";
                Longueur[5] := "Sort 5 : length";
                SautDePage[5] := "Sort 5 : skip page";
                SeparateurAvant[5] := "Sort 5 : line before total";
                SeparateurApres[5] := "Sort 5 : line after total";

                CleTri[6] := "6th sort level";
                PositionDebut[6] := "Sort 6 : start pos.";
                Longueur[6] := "Sort 6 : length";
                SautDePage[6] := "Sort 6 : skip page";
                SeparateurAvant[6] := "Sort 6 : line before total";
                SeparateurApres[6] := "Sort 6 : line after total";

                CleTri[7] := "7th sort level";
                PositionDebut[7] := "Sort 7 : start pos.";
                Longueur[7] := "Sort 7 : length";
                SautDePage[7] := "Sort 7 : skip page";
                SeparateurAvant[7] := "Sort 7 : line before total";
                SeparateurApres[7] := "Sort 7 : line after total";

                CleTri[8] := "8th sort level";
                PositionDebut[8] := "Sort 8 : start pos.";
                Longueur[8] := "Sort 8 : length";
                SautDePage[8] := "Sort 8 : skip page";
                SeparateurAvant[8] := "Sort 8 : line before total";
                SeparateurApres[8] := "Sort 8 : line after total";

                CleTri[9] := "9th sort level";
                PositionDebut[9] := "Sort 9 : start pos.";
                Longueur[9] := "Sort 9 : length";
                SautDePage[9] := "Sort 9 : skip page";
                SeparateurAvant[9] := "Sort 9 : line before total";
                SeparateurApres[9] := "Sort 9 : line after total";

                CleTri[10] := "10th sort level";
                PositionDebut[10] := "Sort 10 : start pos.";
                Longueur[10] := "Sort 10 : length";
                SautDePage[10] := "Sort 10 : skip page";
                SeparateurAvant[10] := "Sort 10 : line before total";
                SeparateurApres[10] := "Sort 10 : line after total";

                AfficherCritereTri(0);
            end else
            Error(Error8, code);
    end;

    [Scope('OnPrem')]
    procedure RechercherNumeroChamp()
    begin
        i := 0;
        repeat
            i := i + 1;
            if CleTri[i] <> '' then begin
                CritereTri.Get(CritereTri.Type::"Sort criteria", CleTri[i]);
                NumeroChamp[i] := CritereTri."Field No.";
                if (PositionDebut[i] = 0) or (Longueur[i] = 0) then
                    Error(Error9 + Error10, i, CleTri[i]);
            end else
                NumeroChamp[i] := 0;
        until i = 10;

        // Création du titre
        i := 0;
        TexteTri := TexteTexteTri;
        repeat
            i := i + 1;
            case NumeroChamp[i] of
                60:
                    CleTri[i] := ParametresStatistiques."Item criteria name 1";
                61:
                    CleTri[i] := ParametresStatistiques."Item criteria name 2";
                62:
                    CleTri[i] := ParametresStatistiques."Item criteria name 3";
                63:
                    CleTri[i] := ParametresStatistiques."Item criteria name 4";
                64:
                    CleTri[i] := ParametresStatistiques."Item criteria name 5";
                65:
                    CleTri[i] := ParametresStatistiques."Item criteria name 6";
                66:
                    CleTri[i] := ParametresStatistiques."Item criteria name 7";
                67:
                    CleTri[i] := ParametresStatistiques."Item criteria name 8";
                68:
                    CleTri[i] := ParametresStatistiques."Item criteria name 9";
                69:
                    CleTri[i] := ParametresStatistiques."Item criteria name 10";
                70:
                    CleTri[i] := ParametresStatistiques."Customer criteria name 1";
                71:
                    CleTri[i] := ParametresStatistiques."Customer criteria name 2";
                72:
                    CleTri[i] := ParametresStatistiques."Customer criteria name 3";
                73:
                    CleTri[i] := ParametresStatistiques."Customer criteria name 4";
                74:
                    CleTri[i] := ParametresStatistiques."Customer criteria name 5";
                75:
                    CleTri[i] := ParametresStatistiques."Customer criteria name 6";
                76:
                    CleTri[i] := ParametresStatistiques."Customer criteria name 7";
                77:
                    CleTri[i] := ParametresStatistiques."Customer criteria name 8";
                78:
                    CleTri[i] := ParametresStatistiques."Customer criteria name 9";
                79:
                    CleTri[i] := ParametresStatistiques."Customer criteria name 10";
                80:
                    CleTri[i] := ParametresStatistiques."Free field name 1";
                81:
                    CleTri[i] := ParametresStatistiques."Free field name 2";
                82:
                    CleTri[i] := ParametresStatistiques."Free field name 3";
                83:
                    CleTri[i] := ParametresStatistiques."Free field name 4";
                84:
                    CleTri[i] := ParametresStatistiques."Free field name 5";
                85:
                    CleTri[i] := ParametresStatistiques."Free field name 6";
                86:
                    CleTri[i] := ParametresStatistiques."Free field name 7";
                87:
                    CleTri[i] := ParametresStatistiques."Free field name 8";
                88:
                    CleTri[i] := ParametresStatistiques."Free field name 9";
                89:
                    CleTri[i] := ParametresStatistiques."Free field name 10";
                90:
                    CleTri[i] := ParametresStatistiques."Free date name 1";
                91:
                    CleTri[i] := ParametresStatistiques."Free date name 2";
                92:
                    CleTri[i] := ParametresStatistiques."Free date name 3";
                93:
                    CleTri[i] := ParametresStatistiques."Free date name 4";
                94:
                    CleTri[i] := ParametresStatistiques."Free date name 5";
                95:
                    CleTri[i] := ParametresStatistiques."Free check name 1";
                96:
                    CleTri[i] := ParametresStatistiques."Free check name 2";
                97:
                    CleTri[i] := ParametresStatistiques."Free check name 3";
                98:
                    CleTri[i] := ParametresStatistiques."Free check name 4";
                99:
                    CleTri[i] := ParametresStatistiques."Free check name 5";
                201:
                    if CopyStr(Stats.GetCaptionClass(1), 5, 1) <> ',' then
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(1), 5, 30)
                    else
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(1), 6, 30);
                202:
                    if CopyStr(Stats.GetCaptionClass(2), 5, 1) <> ',' then
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(2), 5, 30)
                    else
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(2), 6, 30);
                203:
                    if CopyStr(Stats.GetCaptionClass(3), 5, 1) <> ',' then
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(3), 5, 30)
                    else
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(3), 6, 30);
                204:
                    if CopyStr(Stats.GetCaptionClass(4), 5, 1) <> ',' then
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(4), 5, 30)
                    else
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(4), 6, 30);
                205:
                    if CopyStr(Stats.GetCaptionClass(5), 5, 1) <> ',' then
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(5), 5, 30)
                    else
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(5), 6, 30);
                206:
                    if CopyStr(Stats.GetCaptionClass(6), 5, 1) <> ',' then
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(6), 5, 30)
                    else
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(6), 6, 30);
                207:
                    if CopyStr(Stats.GetCaptionClass(7), 5, 1) <> ',' then
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(7), 5, 30)
                    else
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(7), 6, 30);
                208:
                    if CopyStr(Stats.GetCaptionClass(8), 5, 1) <> ',' then
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(8), 5, 30)
                    else
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(8), 6, 30);
                209:
                    if CopyStr(Stats.GetCaptionClass(9), 5, 1) <> ',' then
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(9), 5, 30)
                    else
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(9), 6, 30);
                210:
                    if CopyStr(Stats.GetCaptionClass(10), 5, 1) <> ',' then
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(10), 5, 30)
                    else
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(10), 6, 30);
                211:
                    if CopyStr(Stats.GetCaptionClass(11), 5, 1) <> ',' then
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(11), 5, 30)
                    else
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(11), 6, 30);
                212:
                    if CopyStr(Stats.GetCaptionClass(12), 5, 1) <> ',' then
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(12), 5, 30)
                    else
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(12), 6, 30);
                213:
                    if CopyStr(Stats.GetCaptionClass(13), 5, 1) <> ',' then
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(13), 5, 30)
                    else
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(13), 6, 30);
                214:
                    if CopyStr(Stats.GetCaptionClass(14), 5, 1) <> ',' then
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(14), 5, 30)
                    else
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(14), 6, 30);
                215:
                    if CopyStr(Stats.GetCaptionClass(15), 5, 1) <> ',' then
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(15), 5, 30)
                    else
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(15), 6, 30);
                216:
                    if CopyStr(Stats.GetCaptionClass(16), 5, 1) <> ',' then
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(16), 5, 30)
                    else
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(16), 6, 30);
                217:
                    if CopyStr(Stats.GetCaptionClass(17), 5, 1) <> ',' then
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(17), 5, 30)
                    else
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(17), 6, 30);
                218:
                    if CopyStr(Stats.GetCaptionClass(18), 5, 1) <> ',' then
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(18), 5, 30)
                    else
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(18), 6, 30);
                219:
                    if CopyStr(Stats.GetCaptionClass(19), 5, 1) <> ',' then
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(19), 5, 30)
                    else
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(19), 6, 30);
                220:
                    if CopyStr(Stats.GetCaptionClass(20), 5, 1) <> ',' then
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(20), 5, 30)
                    else
                        CleTri[i] := CopyStr(Stats.GetCaptionClass(20), 6, 30);
                300:
                    CleTri[i] := ParametresStatistiques."Job criteria name 1";
                301:
                    CleTri[i] := ParametresStatistiques."Job criteria name 2";
                302:
                    CleTri[i] := ParametresStatistiques."Job criteria name 3";
                303:
                    CleTri[i] := ParametresStatistiques."Job criteria name 4";
                304:
                    CleTri[i] := ParametresStatistiques."Job criteria name 5";
                305:
                    CleTri[i] := ParametresStatistiques."Job criteria name 6";
                306:
                    CleTri[i] := ParametresStatistiques."Job criteria name 7";
                307:
                    CleTri[i] := ParametresStatistiques."Job criteria name 8";
                308:
                    CleTri[i] := ParametresStatistiques."Job criteria name 9";
                309:
                    CleTri[i] := ParametresStatistiques."Job criteria name 10";
            end;
            if CleTri[i] <> '' then begin
                if PositionDebut[i] = 1 then
                    TexteTri := StrSubstNo('%1 %2 - ', TexteTri, CleTri[i])
                else
                    TexteTri := StrSubstNo('%1 %2 (%3,%4) - ', TexteTri, CleTri[i], PositionDebut[i], Longueur[i]);
                // Stockage dans la table définition
                DefinitionStatistiqueTemp.Init;
                DefinitionStatistiqueTemp."User ID" := User;
                DefinitionStatistiqueTemp."Statistic code" := CodePredefini;
                DefinitionStatistiqueTemp."Line No." := i;
                DefinitionStatistiqueTemp.Description := CopyStr(TexteTri, StrLen(TexteTexteTri) + 2, StrLen(TexteTri) - (StrLen(TexteTexteTri) + 4));
                DefinitionStatistiqueTemp.Insert;

                // Saut de page, séparateurs
                DefinitionStatistiqueTemp.Init;
                DefinitionStatistiqueTemp."User ID" := User;
                DefinitionStatistiqueTemp."Statistic code" := CodePredefini;
                DefinitionStatistiqueTemp."Line No." := i + 100;
                DefinitionStatistiqueTemp.Description := Format(SautDePage[i], 0, 2) + ',' + Format(SeparateurAvant[i], 1, 2) + ','
                                                         + Format(SeparateurApres[i], 1, 2);
                DefinitionStatistiqueTemp.Insert;
            end;
        until i = 10;

        if TexteTri <> TexteTexteTri then
            TexteTri := CopyStr(TexteTri, 1, StrLen(TexteTri) - 3)
        else
            TexteTri := '';
    end;

    [Scope('OnPrem')]
    procedure CalculerDateMiniMaxi(TypeMvt: Text[30])
    begin
        // Recherche de la fourchette de dates la plus large pour chaque type de mouvement
        DateMini := 0D;
        DateMaxi := 0D;
        i := 0;
        repeat
            i := i + 1;
            // Type 30 = formule, 35 = % sous total, 38 = % total, 70 à 79 = Moyenne,mini,maxi
            if (Col_TypeEcriture[i] = TypeMvt) and
              ((Col_TypeDeColonne[i] <> TypeValeur[30]) and (Col_TypeDeColonne[i] <> TypeValeur[35]) and
              (Col_TypeDeColonne[i] <> TypeValeur[38]) and
              ((Col_NumTypeDeColonne[i] < 70) or (Col_NumTypeDeColonne[i] > 79)))
               then begin
                if (Col_DateDebut[i] < DateMini) or (DateMini = 0D) then
                    DateMini := Col_DateDebut[i];
                if (Col_DateFin[i] > DateMaxi) or (DateMaxi = 0D) then
                    DateMaxi := Col_DateFin[i];
            end;
        until i = NombreColonnes;
    end;

    [Scope('OnPrem')]
    procedure CreerTableDefinition()
    begin
        // Titre stat
        // NumLigSuivDefinition vaut :
        // - de 1 à 10000 : réservé système (stockage tri, ...)
        // - de 10000 à 1000000 : titre
        // - > 1000000 : Définition des colonnes
        // Nom de modèle excel
        if StatistiquesPredefinies."Excel model name" <> '' then begin
            DefinitionStatistiqueTemp.Init;
            DefinitionStatistiqueTemp."User ID" := User;
            DefinitionStatistiqueTemp."Statistic code" := CodePredefini;
            DefinitionStatistiqueTemp."Line No." := 9000;
            DefinitionStatistiqueTemp.Description := StatistiquesPredefinies."Excel model name";
            DefinitionStatistiqueTemp.Insert;
        end;
        if StatistiquesPredefinies."Excel sheet" <> '' then begin
            DefinitionStatistiqueTemp.Init;
            DefinitionStatistiqueTemp."User ID" := User;
            DefinitionStatistiqueTemp."Statistic code" := CodePredefini;
            DefinitionStatistiqueTemp."Line No." := 9010;
            DefinitionStatistiqueTemp.Description := StatistiquesPredefinies."Excel sheet";
            DefinitionStatistiqueTemp.Insert;
        end;

        DefinitionStatistiqueTemp.Init;
        DefinitionStatistiqueTemp."User ID" := User;
        DefinitionStatistiqueTemp."Statistic code" := CodePredefini;
        DefinitionStatistiqueTemp."Line No." := 9050;
        DefinitionStatistiqueTemp.Description := Format(StatistiquesPredefinies."Sort header print mode", 0, 2);
        DefinitionStatistiqueTemp.Insert;

        DefinitionStatistiqueTemp.Init;
        DefinitionStatistiqueTemp."User ID" := User;
        DefinitionStatistiqueTemp."Statistic code" := CodePredefini;
        DefinitionStatistiqueTemp."Line No." := 9051;
        DefinitionStatistiqueTemp.Description := Format(StatistiquesPredefinies."Sort line print mode", 0, 2);
        DefinitionStatistiqueTemp.Insert;

        DefinitionStatistiqueTemp.Init;
        DefinitionStatistiqueTemp."User ID" := User;
        DefinitionStatistiqueTemp."Statistic code" := CodePredefini;
        DefinitionStatistiqueTemp."Line No." := 9052;
        DefinitionStatistiqueTemp.Description := Format(StatistiquesPredefinies."Sort total print mode", 0, 2);
        DefinitionStatistiqueTemp.Insert;

        DefinitionStatistiqueTemp.Init;
        DefinitionStatistiqueTemp."User ID" := User;
        DefinitionStatistiqueTemp."Statistic code" := CodePredefini;
        NumLigSuivDefinition := NumLigSuivDefinition + 10000;
        DefinitionStatistiqueTemp."Line No." := NumLigSuivDefinition;
        if StatistiquesPredefinies.Get(CodePredefini) then
            DefinitionStatistiqueTemp.Description := StatistiquesPredefinies.Name
        else
            DefinitionStatistiqueTemp.Description := Titre;
        DefinitionStatistiqueTemp.Insert;
        // Code + titre
        DefinitionStatistiqueTemp.Init;
        DefinitionStatistiqueTemp."User ID" := User;
        DefinitionStatistiqueTemp."Statistic code" := CodePredefini;
        DefinitionStatistiqueTemp."Line No." := 9999;
        if StatistiquesPredefinies.Get(CodePredefini) then
            DefinitionStatistiqueTemp.Description := CodePredefini + ' - ' + StatistiquesPredefinies.Name
        else
            DefinitionStatistiqueTemp.Description := CodePredefini + ' - ' + Titre;
        DefinitionStatistiqueTemp.Insert;

        // Ligne à blanc
        DefinitionStatistiqueTemp.Init;
        DefinitionStatistiqueTemp."User ID" := User;
        DefinitionStatistiqueTemp."Statistic code" := CodePredefini;
        NumLigSuivDefinition := NumLigSuivDefinition + 10000;
        DefinitionStatistiqueTemp."Line No." := NumLigSuivDefinition;
        DefinitionStatistiqueTemp.Insert;

        // Date de situation
        DefinitionStatistiqueTemp.Init;
        DefinitionStatistiqueTemp."User ID" := User;
        DefinitionStatistiqueTemp."Statistic code" := CodePredefini;
        NumLigSuivDefinition := NumLigSuivDefinition + 10000;
        DefinitionStatistiqueTemp."Line No." := NumLigSuivDefinition;
        DefinitionStatistiqueTemp.Description := StrSubstNo(TexteDateSituation, Format(DateFinSituation, 0, 4));
        DefinitionStatistiqueTemp.Insert;

        // Ligne à blanc
        DefinitionStatistiqueTemp.Init;
        DefinitionStatistiqueTemp."User ID" := User;
        DefinitionStatistiqueTemp."Statistic code" := CodePredefini;
        NumLigSuivDefinition := NumLigSuivDefinition + 10000;
        DefinitionStatistiqueTemp."Line No." := NumLigSuivDefinition;
        DefinitionStatistiqueTemp.Insert;

        // Tri
        DefinitionStatistiqueTemp.Init;
        DefinitionStatistiqueTemp."User ID" := User;
        DefinitionStatistiqueTemp."Statistic code" := CodePredefini;
        NumLigSuivDefinition := NumLigSuivDefinition + 10000;
        DefinitionStatistiqueTemp."Line No." := NumLigSuivDefinition;
        DefinitionStatistiqueTemp.Description := TexteTri;
        DefinitionStatistiqueTemp.Insert;

        // Ligne à blanc
        DefinitionStatistiqueTemp.Init;
        DefinitionStatistiqueTemp."User ID" := User;
        DefinitionStatistiqueTemp."Statistic code" := CodePredefini;
        NumLigSuivDefinition := NumLigSuivDefinition + 10000;
        DefinitionStatistiqueTemp."Line No." := NumLigSuivDefinition;
        DefinitionStatistiqueTemp.Insert;

        // Filtres
        DefinitionStatistiqueTemp.Init;
        DefinitionStatistiqueTemp."User ID" := User;
        DefinitionStatistiqueTemp."Statistic code" := CodePredefini;
        NumLigSuivDefinition := NumLigSuivDefinition + 10000;
        DefinitionStatistiqueTemp."Line No." := NumLigSuivDefinition;
        if Stat.GetFilters <> '' then
            DefinitionStatistiqueTemp.Description := CopyStr(TexteFiltres1 + Stat.GetFilters, 1, 250)
        else
            DefinitionStatistiqueTemp.Description := TexteFiltres2;
        DefinitionStatistiqueTemp.Insert;

        // Ligne à blanc
        DefinitionStatistiqueTemp.Init;
        DefinitionStatistiqueTemp."User ID" := User;
        DefinitionStatistiqueTemp."Statistic code" := CodePredefini;
        NumLigSuivDefinition := NumLigSuivDefinition + 10000;
        DefinitionStatistiqueTemp."Line No." := NumLigSuivDefinition;
        DefinitionStatistiqueTemp.Insert;

        // Nom présentation colonnes
        DefinitionStatistiqueTemp.Init;
        DefinitionStatistiqueTemp."User ID" := User;
        DefinitionStatistiqueTemp."Statistic code" := CodePredefini;
        NumLigSuivDefinition := NumLigSuivDefinition + 10000;
        DefinitionStatistiqueTemp."Line No." := NumLigSuivDefinition;
        DefinitionStatistiqueTemp.Description := StrSubstNo('%1 %2', TextePresentation,
                                                             NomColonneStatistique.Description);
        DefinitionStatistiqueTemp.Insert;

        // Ligne à blanc
        DefinitionStatistiqueTemp.Init;
        DefinitionStatistiqueTemp."User ID" := User;
        DefinitionStatistiqueTemp."Statistic code" := CodePredefini;
        NumLigSuivDefinition := NumLigSuivDefinition + 10000;
        DefinitionStatistiqueTemp."Line No." := NumLigSuivDefinition;
        DefinitionStatistiqueTemp.Insert;
    end;

    [Scope('OnPrem')]
    procedure CreerTableauTypeDeColonne()
    begin
        with CritereTri do begin
            Reset;
            SetRange(Type, Type::Value);
            if Find('-') then
                repeat
                    TypeValeur["Field No."] := "Field name";
                until Next = 0;
        end;
    end;

    [Scope('OnPrem')]
    procedure CreerTableauColonnes()
    begin
        // Création d'un tableau de 250 postes avec présentation des colonnes
        NumLigSuivDefinition := 1000000;
        with ColonnesStatistiques do begin

            ColonnesStatistiques.Reset;
            SetRange(Code, CodeColonne);
            SetFilter("Column No.", '<>%1', '');
            Find('-');

            i := 0;
            j := 0;
            repeat
                i := i + 1;
                Col_Titre1[i] := "Column Layout Name";
                Col_NoColonne[i] := "Column No.";
                Col_NoLigne[i] := "Line No.";
                Col_TypeDeColonne[i] := "Column type";
                Col_TypeEcriture[i] := "Entry Type";
                Col_InversionSigne[i] := "Reverse sign";
                Col_ImprimerColonne[i] := "Print column";
                Col_UniteAffichage[i] := "Rounding Factor";
                Col_CalculDateDebut[i] := "Process from date";
                Col_CalculDateFin[i] := "Process to date";
                Col_Formule[i] := Formula;
                Col_LineTitle[i] := "Line title";
                CalcFields("Additional filter");
                Col_Filtre[i] := "Additional filter";
                if "Column type" <> CritereTri2."Field name" then
                    CritereTri2.Get(CritereTri2.Type::Value, "Column type");
                Col_NumTypeDeColonne[i] := CritereTri2."Field No.";
                // Type 30 = formule, 35 = % sous total, 38 = % total, 70 à 79 = Moyenne,mini,maxi
                if (("Column type" <> TypeValeur[30]) and ("Column type" <> TypeValeur[35]) and ("Column type" <> TypeValeur[38])
             and
                   ((Col_NumTypeDeColonne[i] < 70) or (Col_NumTypeDeColonne[i] > 79)))
                   and ((Format("Process from date") = '') and (DateDebutSituation = 0D)) then
                    Error(Error11, CodePredefini);

                if (("Column type" <> TypeValeur[30]) and ("Column type" <> TypeValeur[35]) and ("Column type" <> TypeValeur[38])
             and
                   ((Col_NumTypeDeColonne[i] < 70) or (Col_NumTypeDeColonne[i] > 79)))
                   and ((Format("Process to date") = '') and (DateFinSituation = 0D)) then
                    Error(Error11, CodePredefini);

                if (("Column type" = TypeValeur[30]) or ("Column type" = TypeValeur[35]) or ("Column type" = TypeValeur[38]) or
                   ((Col_NumTypeDeColonne[i] >= 70) and (Col_NumTypeDeColonne[i] <= 79)))
                   and (Formula = '') then
                    Error(Error12, "Column No.", CodePredefini);

                // Type 30 = formule, 35 = % sous total, 38 = % total, 70 à 79 = Moyenne,mini,maxi
                if ((Col_TypeDeColonne[i] <> TypeValeur[30]) and
                   (Col_TypeDeColonne[i] <> TypeValeur[35]) and
                   (Col_TypeDeColonne[i] <> TypeValeur[38]) and
                   ((Col_NumTypeDeColonne[i] < 70) or (Col_NumTypeDeColonne[i] > 79))) then begin
                    if (Format(Col_CalculDateDebut[i]) <> '') then
                        Col_DateDebut[i] := CalcDate(Format(Col_CalculDateDebut[i]), DateFinSituation)
                    else
                        Col_DateDebut[i] := DateDebutSituation;
                    if (Format(Col_CalculDateFin[i]) <> '') then
                        Col_DateFin[i] := CalcDate(Format(Col_CalculDateFin[i]), DateFinSituation)
                    else
                        Col_DateFin[i] := DateFinSituation;
                end else begin
                    Col_DateDebut[i] := 0D;
                    Col_DateFin[i] := 0D;
                end;
                if i < NombreColonnes then
                    Find('>');
                // VISU
                if Col_ImprimerColonne[i] <> Col_ImprimerColonne[i] ::Jamais then begin
                    j := j + 1;
                    ColonnesStatistiquesTemp.Init;
                    ColonnesStatistiquesTemp."User ID" := User;
                    ColonnesStatistiquesTemp."Statistic code" := CodePredefini;
                    ColonnesStatistiquesTemp."Colonne No. pos." := j;
                    ColonnesStatistiquesTemp."Column Layout Name" := ColonnesStatistiques.Code;
                    ColonnesStatistiquesTemp."Line No." := ColonnesStatistiques."Line No.";
                    ColonnesStatistiquesTemp."Starting Date" := Col_DateDebut[i];
                    ColonnesStatistiquesTemp."Ending Date" := Col_DateFin[i];
                    ColonnesStatistiquesTemp."Column description" := Col_Titre1[i];
                    ColonnesStatistiquesTemp."Column No." := Col_NoColonne[i];
                    ColonnesStatistiquesTemp."Column type" := Col_TypeDeColonne[i];
                    ColonnesStatistiquesTemp.Formula := Col_Formule[i];
                    ColonnesStatistiquesTemp."Additional filter" := Col_Filtre[i];
                    ColonnesStatistiquesTemp."New line" := ColonnesStatistiques."New line";
                    if i = 1 then
                        ColonnesStatistiquesTemp."Line title" := Col_LineTitle[i]
                    else
                        ColonnesStatistiquesTemp."Line title" := ColonnesStatistiques."Line title";
                    ColonnesStatistiquesTemp."Rounding Factor" := Col_UniteAffichage[i];
                    // On prépare le calcul des %
                    if (Col_TypeDeColonne[i] = TypeValeur[35]) or (Col_TypeDeColonne[i] = TypeValeur[38]) then
                        CalculerPourcentages := true;
                    if (Col_DateDebut[i] <> 0D) and (Col_DateFin[i] <> 0D) then
                        ColonnesStatistiquesTemp."Column title" := StrSubstNo('%1 (%2 - %3)', Col_Titre1[i], Col_DateDebut[i], Col_DateFin[i])
                    else
                        ColonnesStatistiquesTemp."Column title" := Col_Titre1[i];
                    ColonnesStatistiquesTemp.Insert;

                    // Définition
                    DefinitionStatistiqueTemp.Init;
                    DefinitionStatistiqueTemp."User ID" := User;
                    DefinitionStatistiqueTemp."Statistic code" := CodePredefini;
                    DefinitionStatistiqueTemp."Line No." := 1000000 + (i * 100);
                    if ((Col_TypeDeColonne[i] <> TypeValeur[30]) and (Col_TypeDeColonne[i] <> TypeValeur[35]) and
                        (Col_TypeDeColonne[i] <> TypeValeur[38]) and
                        ((Col_NumTypeDeColonne[i] < 70) or (Col_NumTypeDeColonne[i] > 79))) then
                        DefinitionStatistiqueTemp.Description := StrSubstNo(TexteColonne1,
                            Col_NoColonne[i], Col_Titre1[i], Col_TypeDeColonne[i], Col_TypeEcriture[i], Col_DateDebut[i], Col_DateFin[i])
                    else
                        if ((Col_TypeDeColonne[i] = TypeValeur[35]) or (Col_TypeDeColonne[i] = TypeValeur[38]) or
                           ((Col_NumTypeDeColonne[i] >= 70) and (Col_NumTypeDeColonne[i] <= 79))) then
                            DefinitionStatistiqueTemp.Description := StrSubstNo(TexteColonne2,
                                Col_NoColonne[i], Col_Titre1[i], Col_TypeDeColonne[i], Col_Formule[i])
                        else
                            if (Col_TypeDeColonne[i] = TypeValeur[30]) then
                                DefinitionStatistiqueTemp.Description := StrSubstNo(TexteColonne3,
                                    Col_NoColonne[i], Col_Titre1[i], Col_TypeDeColonne[i], Col_Formule[i]);
                    DefinitionStatistiqueTemp.Insert;

                end;
            until i = NombreColonnes;
        end;
    end;

    [Scope('OnPrem')]
    procedure CompleterCles(TypeMvt: Text[30]; CodeSocieteStatistique: Text[30])
    var
        Convert: Boolean;
    begin
        CptrLig := 0;
        Convert := false;
        if CodeSocieteStatistique <> '' then begin
            Stats.ChangeCompany(CodeSocieteStatistique);
            ParametresComptabilite2.ChangeCompany(CodeSocieteStatistique);
            ParametresComptabilite2.Get;
            if ParametresComptabilite2."LCY Code" <> ParametresComptabilite."LCY Code" then
                Convert := true;
        end;
        if StatistiquesPredefinies."Period Length" <> StatistiquesPredefinies."Period Length"::"By column" then
            Stats.SetCurrentKey("Period Length", "Entry Type", "Ending Date")
        else
            Stats.SetCurrentKey("Entry Type", "Ending Date");

        Stats.CopyFilters(Stat);
        Stats.SetRange("Entry Type", TypeMvt);
        Stats.SetRange("Ending Date", DateMini, DateMaxi);
        if GuiAllowed then Fenetre.Open(FenetrePreparation, CodePredefini);
        NbreEnreg := Stats.Count;
        if GuiAllowed then Fenetre.Open(FenetreCles, CodePredefini);
        if GuiAllowed then Fenetre.Update(2, TypeMvt);

        if NbreEnreg <> 0 then
            with Stats do begin
                Find('-');
                repeat
                    Statistiques.Init;
                    i := 0;
                    repeat
                        if i < 10 then
                            i := i + 1;
                        //   MESSAGE('ll  %1    m   %2',i,NumeroChamp[i]);
                        if NumeroChamp[i] <> 0 then begin
                            case NumeroChamp[i] of
                                4:
                                    Valeur[i] := "Entry Type";
                                5:
                                    Valeur[i] := StrSubstNo('%1', Type);
                                6:
                                    if PositionDebut[i] > 0 then // Si < 0 on ne met pas la racine du type
                                        Valeur[i] := StrSubstNo('%1 %2', CopyStr(Format(Type), 1, 1), CopyStr("No.", PositionDebut[i], Longueur[i]))
                                    else
                                        Valeur[i] := CopyStr("No.", 1, Longueur[i]);
                                8:
                                    Valeur[i] := StrSubstNo('%1', "Source Type");
                                9:
                                    if PositionDebut[i] > 0 then // Si < 0 on ne met pas la racine du type
                                        Valeur[i] := StrSubstNo('%1 %2', CopyStr(Format("Source Type"), 1, 1), CopyStr("Source No.", PositionDebut[i], Longueur[i]))
                                    else
                                        Valeur[i] := CopyStr("Source No.", 1, Longueur[i]);
                                11:
                                    Valeur[i] := CopyStr("Location Code", PositionDebut[i], Longueur[i]);
                                12:
                                    Valeur[i] := CopyStr("Inventory Posting Group", PositionDebut[i], Longueur[i]);
                                13:
                                    Valeur[i] := CopyStr("Source Posting Group", PositionDebut[i], Longueur[i]);
                                14:
                                    Valeur[i] := CopyStr("Gen. Bus. Posting Group", PositionDebut[i], Longueur[i]);
                                15:
                                    Valeur[i] := CopyStr("Gen. Prod. Posting Group", PositionDebut[i], Longueur[i]);
                                16:
                                    Valeur[i] := CopyStr("Salespers./Purch. Code", PositionDebut[i], Longueur[i]);
                                17:
                                    Valeur[i] := CopyStr("Global Dimension 1 Code", PositionDebut[i], Longueur[i]);
                                18:
                                    Valeur[i] := CopyStr("Global Dimension 2 Code", PositionDebut[i], Longueur[i]);
                                19:
                                    Valeur[i] := CopyStr("Country Code", PositionDebut[i], Longueur[i]);
                                30:
                                    Valeur[i] := CopyStr(Format(Year), PositionDebut[i], Longueur[i]);
                                31:
                                    Valeur[i] := CopyStr(Format("Half Year"), PositionDebut[i], Longueur[i]);
                                32:
                                    Valeur[i] := CopyStr(Format(Quarter), PositionDebut[i], Longueur[i]);
                                33:
                                    begin
                                        Valeur[i] := CopyStr(Format(Month), PositionDebut[i], Longueur[i]);
                                        if Month < 10 then
                                            Valeur[i] := 'M0' + Valeur[i]
                                        else
                                            Valeur[i] := 'M' + Valeur[i];
                                    end;
                                34:
                                    Valeur[i] := CopyStr(Format(Week), PositionDebut[i], Longueur[i]);
                                35:
                                    Valeur[i] := CopyStr(Format("Fiscal year closing date", 0, '<Closing><Year4><Month,2><Day,2>'),
                                                                PositionDebut[i], Longueur[i]);
                                36:
                                    Valeur[i] := CopyStr(Format("Week Day"), PositionDebut[i], Longueur[i]);
                                37:
                                    Valeur[i] := CopyStr("Business Unit Code", PositionDebut[i], Longueur[i]);
                                38:
                                    Valeur[i] := CopyStr("Consol. Debit Acc.", PositionDebut[i], Longueur[i]);
                                39:
                                    Valeur[i] := CopyStr("Consol. Credit Acc.", PositionDebut[i], Longueur[i]);
                                40:
                                    Valeur[i] := CopyStr("Job No.", PositionDebut[i], Longueur[i]);
                                41:
                                    Valeur[i] := CopyStr("Phase Code", PositionDebut[i], Longueur[i]);
                                42:
                                    Valeur[i] := CopyStr("Task Code", PositionDebut[i], Longueur[i]);
                                43:
                                    Valeur[i] := CopyStr("Step Code", PositionDebut[i], Longueur[i]);
                                44:
                                    Valeur[i] := CopyStr("Work Type Code", PositionDebut[i], Longueur[i]);
                                45:
                                    Valeur[i] := CopyStr("Reason Code", PositionDebut[i], Longueur[i]);
                                46:
                                    Valeur[i] := CopyStr("Job Posting Group", PositionDebut[i], Longueur[i]);
                                47:
                                    Valeur[i] := CopyStr("Resource Group No.", PositionDebut[i], Longueur[i]);
                                48:
                                    Valeur[i] := CopyStr("Person Responsible", PositionDebut[i], Longueur[i]);
                                49:
                                    begin
                                        if CodeSocieteStatistique <> '' then
                                            Valeur[i] := CopyStr(CodeSocieteStatistique, PositionDebut[i], Longueur[i])
                                        else
                                            Valeur[i] := CopyStr(CompanyName, PositionDebut[i], Longueur[i])
                                    end;
                                50:
                                    Valeur[i] := CopyStr("Item Charge No.", PositionDebut[i], Longueur[i]);
                                51:
                                    Valeur[i] := CopyStr("Variant Code", PositionDebut[i], Longueur[i]);
                                52:
                                    Valeur[i] := CopyStr("Return Reason Code", PositionDebut[i], Longueur[i]);
                                53:
                                    Valeur[i] := CopyStr("Manufacturer Code", PositionDebut[i], Longueur[i]);
                                54:
                                    Valeur[i] := CopyStr("Item Category Code", PositionDebut[i], Longueur[i]);
                                55:
                                    Valeur[i] := CopyStr("Product Group Code", PositionDebut[i], Longueur[i]);
                                56:
                                    Valeur[i] := CopyStr("Service Item Group", PositionDebut[i], Longueur[i]);
                                57:
                                    Valeur[i] := CopyStr("Campaign No.", PositionDebut[i], Longueur[i]);
                                59:
                                    Valeur[i] := CopyStr("Back disc./commission rule No.", PositionDebut[i], Longueur[i]);
                                60:
                                    Valeur[i] := CopyStr("Item criteria 1", PositionDebut[i], Longueur[i]);
                                61:
                                    Valeur[i] := CopyStr("Item criteria 2", PositionDebut[i], Longueur[i]);
                                62:
                                    Valeur[i] := CopyStr("Item criteria 3", PositionDebut[i], Longueur[i]);
                                63:
                                    Valeur[i] := CopyStr("Item criteria 4", PositionDebut[i], Longueur[i]);
                                64:
                                    Valeur[i] := CopyStr("Item criteria 5", PositionDebut[i], Longueur[i]);
                                65:
                                    Valeur[i] := CopyStr("Item criteria 6", PositionDebut[i], Longueur[i]);
                                66:
                                    Valeur[i] := CopyStr("Item criteria 7", PositionDebut[i], Longueur[i]);
                                67:
                                    Valeur[i] := CopyStr("Item criteria 8", PositionDebut[i], Longueur[i]);
                                68:
                                    Valeur[i] := CopyStr("Item criteria 9", PositionDebut[i], Longueur[i]);
                                69:
                                    Valeur[i] := CopyStr("Item criteria 10", PositionDebut[i], Longueur[i]);
                                70:
                                    Valeur[i] := CopyStr("Customer criteria 1", PositionDebut[i], Longueur[i]);
                                71:
                                    Valeur[i] := CopyStr("Customer criteria 2", PositionDebut[i], Longueur[i]);
                                72:
                                    Valeur[i] := CopyStr("Customer criteria 3", PositionDebut[i], Longueur[i]);
                                73:
                                    Valeur[i] := CopyStr("Customer criteria 4", PositionDebut[i], Longueur[i]);
                                74:
                                    Valeur[i] := CopyStr("Customer criteria 5", PositionDebut[i], Longueur[i]);
                                75:
                                    Valeur[i] := CopyStr("Customer criteria 6", PositionDebut[i], Longueur[i]);
                                76:
                                    Valeur[i] := CopyStr("Customer criteria 7", PositionDebut[i], Longueur[i]);
                                77:
                                    Valeur[i] := CopyStr("Customer criteria 8", PositionDebut[i], Longueur[i]);
                                78:
                                    Valeur[i] := CopyStr("Customer criteria 9", PositionDebut[i], Longueur[i]);
                                79:
                                    Valeur[i] := CopyStr("Customer criteria 10", PositionDebut[i], Longueur[i]);
                                80:
                                    Valeur[i] := CopyStr("Free field 1", PositionDebut[i], Longueur[i]);
                                81:
                                    Valeur[i] := CopyStr("Free field 2", PositionDebut[i], Longueur[i]);
                                82:
                                    Valeur[i] := CopyStr("Free field 3", PositionDebut[i], Longueur[i]);
                                83:
                                    Valeur[i] := CopyStr("Free field 4", PositionDebut[i], Longueur[i]);
                                84:
                                    Valeur[i] := CopyStr("Free field 5", PositionDebut[i], Longueur[i]);
                                85:
                                    Valeur[i] := CopyStr("Free field 6", PositionDebut[i], Longueur[i]);
                                86:
                                    Valeur[i] := CopyStr("Free field 7", PositionDebut[i], Longueur[i]);
                                87:
                                    Valeur[i] := CopyStr("Free field 8", PositionDebut[i], Longueur[i]);
                                88:
                                    Valeur[i] := CopyStr("Free field 9", PositionDebut[i], Longueur[i]);
                                89:
                                    Valeur[i] := CopyStr("Free field 10", PositionDebut[i], Longueur[i]);
                                90:
                                    Valeur[i] := CopyStr(Format("Free date 1", 0, '<Closing><Year4><Month,2><Day,2>'), PositionDebut[i], Longueur[i]);
                                91:
                                    Valeur[i] := CopyStr(Format("Free date 2", 0, '<Closing><Year4><Month,2><Day,2>'), PositionDebut[i], Longueur[i]);
                                92:
                                    Valeur[i] := CopyStr(Format("Free date 3", 0, '<Closing><Year4><Month,2><Day,2>'), PositionDebut[i], Longueur[i]);
                                93:
                                    Valeur[i] := CopyStr(Format("Free date 4", 0, '<Closing><Year4><Month,2><Day,2>'), PositionDebut[i], Longueur[i]);
                                94:
                                    Valeur[i] := CopyStr(Format("Free date 5", 0, '<Closing><Year4><Month,2><Day,2>'), PositionDebut[i], Longueur[i]);
                                95:
                                    Valeur[i] := Format("Free boolean 1");
                                96:
                                    Valeur[i] := Format("Free boolean 2");
                                97:
                                    Valeur[i] := Format("Free boolean 3");
                                98:
                                    Valeur[i] := Format("Free boolean 4");
                                99:
                                    Valeur[i] := Format("Free boolean 5");
                                201:
                                    Valeur[i] := CopyStr("Dimension 1 Value Code", PositionDebut[i], Longueur[i]);
                                202:
                                    Valeur[i] := CopyStr("Dimension 2 Value Code", PositionDebut[i], Longueur[i]);
                                203:
                                    Valeur[i] := CopyStr("Dimension 3 Value Code", PositionDebut[i], Longueur[i]);
                                204:
                                    Valeur[i] := CopyStr("Dimension 4 Value Code", PositionDebut[i], Longueur[i]);
                                205:
                                    Valeur[i] := CopyStr("Dimension 5 Value Code", PositionDebut[i], Longueur[i]);
                                206:
                                    Valeur[i] := CopyStr("Dimension 6 Value Code", PositionDebut[i], Longueur[i]);
                                207:
                                    Valeur[i] := CopyStr("Dimension 7 Value Code", PositionDebut[i], Longueur[i]);
                                208:
                                    Valeur[i] := CopyStr("Dimension 8 Value Code", PositionDebut[i], Longueur[i]);
                                209:
                                    Valeur[i] := CopyStr("Dimension 9 Value Code", PositionDebut[i], Longueur[i]);
                                210:
                                    Valeur[i] := CopyStr("Dimension 10 Value Code", PositionDebut[i], Longueur[i]);
                                211:
                                    Valeur[i] := CopyStr("Dimension 11 Value Code", PositionDebut[i], Longueur[i]);
                                212:
                                    Valeur[i] := CopyStr("Dimension 12 Value Code", PositionDebut[i], Longueur[i]);
                                213:
                                    Valeur[i] := CopyStr("Dimension 13 Value Code", PositionDebut[i], Longueur[i]);
                                214:
                                    Valeur[i] := CopyStr("Dimension 14 Value Code", PositionDebut[i], Longueur[i]);
                                215:
                                    Valeur[i] := CopyStr("Dimension 15 Value Code", PositionDebut[i], Longueur[i]);
                                216:
                                    Valeur[i] := CopyStr("Dimension 16 Value Code", PositionDebut[i], Longueur[i]);
                                217:
                                    Valeur[i] := CopyStr("Dimension 17 Value Code", PositionDebut[i], Longueur[i]);
                                218:
                                    Valeur[i] := CopyStr("Dimension 18 Value Code", PositionDebut[i], Longueur[i]);
                                219:
                                    Valeur[i] := CopyStr("Dimension 19 Value Code", PositionDebut[i], Longueur[i]);
                                220:
                                    Valeur[i] := CopyStr("Dimension 20 Value Code", PositionDebut[i], Longueur[i]);
                                300:
                                    Valeur[i] := CopyStr("Job criteria 1", PositionDebut[i], Longueur[i]);
                                301:
                                    Valeur[i] := CopyStr("Job criteria 2", PositionDebut[i], Longueur[i]);
                                302:
                                    Valeur[i] := CopyStr("Job criteria 3", PositionDebut[i], Longueur[i]);
                                303:
                                    Valeur[i] := CopyStr("Job criteria 4", PositionDebut[i], Longueur[i]);
                                304:
                                    Valeur[i] := CopyStr("Job criteria 5", PositionDebut[i], Longueur[i]);
                                305:
                                    Valeur[i] := CopyStr("Job criteria 6", PositionDebut[i], Longueur[i]);
                                306:
                                    Valeur[i] := CopyStr("Job criteria 7", PositionDebut[i], Longueur[i]);
                                307:
                                    Valeur[i] := CopyStr("Job criteria 8", PositionDebut[i], Longueur[i]);
                                308:
                                    Valeur[i] := CopyStr("Job criteria 9", PositionDebut[i], Longueur[i]);
                                309:
                                    Valeur[i] := CopyStr("Job criteria 10", PositionDebut[i], Longueur[i]);
                            end;

                        end else
                            Valeur[i] := '';
                    until i = 10;

                    Statistiques.TransferFields(Stats);
                    Statistiques."Entry No." := NbrLig;
                    if CodeSocieteStatistique <> '' then
                        Statistiques.Company := CodeSocieteStatistique
                    else
                        Statistiques.Company := CompanyName;
                    Statistiques."User ID" := User;
                    Statistiques."Statistic code" := CodePredefini;
                    Statistiques."Key 1" := Valeur[1];
                    Statistiques."Key 2" := Valeur[2];
                    Statistiques."Key 3" := Valeur[3];
                    Statistiques."Key 4" := Valeur[4];
                    Statistiques."Key 5" := Valeur[5];
                    Statistiques."Key 6" := Valeur[6];
                    Statistiques."Key 7" := Valeur[7];
                    Statistiques."Key 8" := Valeur[8];
                    Statistiques."Key 9" := Valeur[9];
                    Statistiques."Key 10" := Valeur[10];
                    if Convert then begin
                        Statistiques.Amount := DeviseTauxChange.ExchangeAmtFCYToLCY(
                                               DateFinSituation, ParametresComptabilite2."LCY Code",
                                               Statistiques.Amount, 0);
                    end;
                    Statistiques.Insert;
                    NbrLig := NbrLig + 1;
                    CptrLig := CptrLig + 1;
                    if GuiAllowed then Fenetre.Update(3, Round(CptrLig / NbreEnreg * 10000, 1));
                until Stats.Next = 0;

                if GuiAllowed then Fenetre.Close;
                CptrLig := 0;
            end;
    end;

    [Scope('OnPrem')]
    procedure CalculerTableauResultats()
    var
        Calculer: Boolean;
    begin
        with Statistiques do begin

            i := 0;
            repeat
                i := i + 1;
                // Type 30 = formule, 35 = % sous total, 38 = % total, 70 à 79 = Moyenne,mini,maxi
                if ((Col_TypeDeColonne[i] <> TypeValeur[30]) and
                   (Col_TypeDeColonne[i] <> TypeValeur[35]) and
                   (Col_TypeDeColonne[i] <> TypeValeur[38]) and
                   ((Col_NumTypeDeColonne[i] < 70) or (Col_NumTypeDeColonne[i] > 79))) and
                   (Col_TypeEcriture[i] = "Entry Type") and
                   ("Ending Date" >= Col_DateDebut[i]) and
                   ("Ending Date" <= Col_DateFin[i]) then begin

                    if Col_Filtre[i] then
                        Calculer := AppliquerFiltreColonne("Entry No.", Col_NoLigne[i], i)
                    else
                        Calculer := true;

                    Col_Resultat[i] := 0;

                    if Calculer then
                        case Col_TypeDeColonne[i] of
                            TypeValeur[10]:
                                Col_Resultat[i] := Quantity;
                            TypeValeur[15]:
                                Col_Resultat[i] := Volume;
                            TypeValeur[20]:
                                Col_Resultat[i] := Amount;
                            TypeValeur[25]:
                                Col_Resultat[i] := "Adjusted Cost (Invoiced Qty.)";
                            TypeValeur[40]:
                                Col_Resultat[i] := "Lines discount total";
                            TypeValeur[42]:
                                Col_Resultat[i] := "Document discount total";
                            TypeValeur[44]:
                                Col_Resultat[i] := "Back discount total";
                            TypeValeur[46]:
                                Col_Resultat[i] := "Commissions total";
                            TypeValeur[51]:
                                Col_Resultat[i] := "Free value 1";
                            TypeValeur[52]:
                                Col_Resultat[i] := "Free value 2";
                            TypeValeur[53]:
                                Col_Resultat[i] := "Free value 3";
                            TypeValeur[54]:
                                Col_Resultat[i] := "Free value 4";
                            TypeValeur[55]:
                                Col_Resultat[i] := "Free value 5";
                            TypeValeur[56]:
                                Col_Resultat[i] := "Free value 6";
                            TypeValeur[57]:
                                Col_Resultat[i] := "Free value 7";
                            TypeValeur[58]:
                                Col_Resultat[i] := "Free value 8";
                            TypeValeur[59]:
                                Col_Resultat[i] := "Free value 9";
                            TypeValeur[60]:
                                Col_Resultat[i] := "Free value 10";
                        end;
                    if Col_InversionSigne[i] then
                        Col_Resultat[i] := Col_Resultat[i] * -1;
                end;

            until i = NombreColonnes;
        end;
    end;

    [Scope('OnPrem')]
    procedure AppliquerFiltreColonne(NumeroSequence: Integer; NumeroLigne: Integer; NumeroColonne: Integer) Trouve: Boolean
    var
        StatistiqueTemporaire2: Record "Temp. statistic";
    begin
        with FiltreColonneStatistique do begin
            if (Code <> CodeColonne) or ("Line No." <> NumeroLigne) then
                Get(CodeColonne, NumeroLigne);

            StatistiqueTemporaire2.Reset;
            StatistiqueTemporaire2.SetCurrentKey("User ID", "Statistic code", "Entry No.");
            if Type <> Type::" " then
                StatistiqueTemporaire2.SetRange(Type, Type - 1);
            StatistiqueTemporaire2.SetFilter("No.", "No.");
            if "Source Type" <> "Source Type"::" " then
                StatistiqueTemporaire2.SetRange("Source Type", "Source Type");
            if (StatistiquesPredefinies."Period Length" = StatistiquesPredefinies."Period Length"::"By column") then
                StatistiqueTemporaire2.SetRange("Period Length", "Period Length");
            StatistiqueTemporaire2.SetFilter("Source No.", "Source No.");
            StatistiqueTemporaire2.SetFilter("Location Code", "Location Code");
            StatistiqueTemporaire2.SetFilter("Inventory Posting Group", "Inventory Posting Group");
            StatistiqueTemporaire2.SetFilter("Source Posting Group", "Source Posting Group");
            StatistiqueTemporaire2.SetFilter("Gen. Bus. Posting Group", "Gen. Bus. Posting Group");
            StatistiqueTemporaire2.SetFilter("Gen. Prod. Posting Group", "Gen. Prod. Posting Group");
            StatistiqueTemporaire2.SetFilter("Salespers./Purch. Code", "Salespers./Purch. Code");
            StatistiqueTemporaire2.SetFilter("Global Dimension 1 Code", "Global Dimension 1 Code");
            StatistiqueTemporaire2.SetFilter("Global Dimension 2 Code", "Global Dimension 2 Code");
            StatistiqueTemporaire2.SetFilter("Country Code", "Country Code");
            StatistiqueTemporaire2.SetFilter("Business Unit Code", "Business Unit Code");
            StatistiqueTemporaire2.SetFilter("Consol. Debit Acc.", "Consol. Debit Acc.");
            StatistiqueTemporaire2.SetFilter("Consol. Credit Acc.", "Consol. Credit Acc.");
            StatistiqueTemporaire2.SetFilter("Back disc./commission rule No.", "Back disc./commission rule No.");
            StatistiqueTemporaire2.SetFilter(Year, Year);
            StatistiqueTemporaire2.SetFilter("Half Year", "Half Year");
            StatistiqueTemporaire2.SetFilter(Quarter, Quarter);
            StatistiqueTemporaire2.SetFilter(Month, Month);
            StatistiqueTemporaire2.SetFilter(Week, Week);
            StatistiqueTemporaire2.SetFilter("Week Day", "Week Day");
            StatistiqueTemporaire2.SetFilter("Fiscal year closing date", "Fiscal year closing date");
            StatistiqueTemporaire2.SetFilter("Job No.", "Job No.");
            StatistiqueTemporaire2.SetFilter("Phase Code", "Phase Code");
            StatistiqueTemporaire2.SetFilter("Task Code", "Task Code");
            StatistiqueTemporaire2.SetFilter("Step Code", "Step Code");
            StatistiqueTemporaire2.SetFilter("Work Type Code", "Work Type Code");
            StatistiqueTemporaire2.SetFilter("Job Posting Group", "Job Posting Group");
            StatistiqueTemporaire2.SetFilter("Resource Group No.", "Resource Group No.");
            StatistiqueTemporaire2.SetFilter("Person Responsible", "Person Responsible");
            StatistiqueTemporaire2.SetFilter("Campaign No.", "Campaign No.");
            StatistiqueTemporaire2.SetFilter("Reason Code", "Reason Code");
            StatistiqueTemporaire2.SetFilter("Item Charge No.", "Item Charge No.");
            StatistiqueTemporaire2.SetFilter("Variant Code", "Variant Code");
            StatistiqueTemporaire2.SetFilter("Return Reason Code", "Return Reason Code");
            StatistiqueTemporaire2.SetFilter("Manufacturer Code", "Manufacturer Code");
            StatistiqueTemporaire2.SetFilter("Item Category Code", "Item Category Code");
            StatistiqueTemporaire2.SetFilter("Product Group Code", "Product Group Code");
            StatistiqueTemporaire2.SetFilter("Service Item Group", "Service Item Group");
            StatistiqueTemporaire2.SetFilter("Item criteria 1", "Item criteria 1");
            StatistiqueTemporaire2.SetFilter("Item criteria 2", "Item criteria 2");
            StatistiqueTemporaire2.SetFilter("Item criteria 3", "Item criteria 3");
            StatistiqueTemporaire2.SetFilter("Item criteria 4", "Item criteria 4");
            StatistiqueTemporaire2.SetFilter("Item criteria 5", "Item criteria 5");
            StatistiqueTemporaire2.SetFilter("Item criteria 6", "Item criteria 6");
            StatistiqueTemporaire2.SetFilter("Item criteria 7", "Item criteria 7");
            StatistiqueTemporaire2.SetFilter("Item criteria 8", "Item criteria 8");
            StatistiqueTemporaire2.SetFilter("Item criteria 9", "Item criteria 9");
            StatistiqueTemporaire2.SetFilter("Item criteria 10", "Item criteria 10");
            StatistiqueTemporaire2.SetFilter("Customer criteria 1", "Customer criteria 1");
            StatistiqueTemporaire2.SetFilter("Customer criteria 2", "Customer criteria 2");
            StatistiqueTemporaire2.SetFilter("Customer criteria 3", "Customer criteria 3");
            StatistiqueTemporaire2.SetFilter("Customer criteria 4", "Customer criteria 4");
            StatistiqueTemporaire2.SetFilter("Customer criteria 5", "Customer criteria 5");
            StatistiqueTemporaire2.SetFilter("Customer criteria 6", "Customer criteria 6");
            StatistiqueTemporaire2.SetFilter("Customer criteria 7", "Customer criteria 7");
            StatistiqueTemporaire2.SetFilter("Customer criteria 8", "Customer criteria 8");
            StatistiqueTemporaire2.SetFilter("Customer criteria 9", "Customer criteria 9");
            StatistiqueTemporaire2.SetFilter("Customer criteria 10", "Customer criteria 10");
            StatistiqueTemporaire2.SetFilter("Job criteria 1", "Job criteria 1");
            StatistiqueTemporaire2.SetFilter("Job criteria 2", "Job criteria 2");
            StatistiqueTemporaire2.SetFilter("Job criteria 3", "Job criteria 3");
            StatistiqueTemporaire2.SetFilter("Job criteria 4", "Job criteria 4");
            StatistiqueTemporaire2.SetFilter("Job criteria 5", "Job criteria 5");
            StatistiqueTemporaire2.SetFilter("Job criteria 6", "Job criteria 6");
            StatistiqueTemporaire2.SetFilter("Job criteria 7", "Job criteria 7");
            StatistiqueTemporaire2.SetFilter("Job criteria 8", "Job criteria 8");
            StatistiqueTemporaire2.SetFilter("Job criteria 9", "Job criteria 9");
            StatistiqueTemporaire2.SetFilter("Job criteria 10", "Job criteria 10");
            StatistiqueTemporaire2.SetFilter("Free field 1", "Free field 1");
            StatistiqueTemporaire2.SetFilter("Free field 2", "Free field 2");
            StatistiqueTemporaire2.SetFilter("Free field 3", "Free field 3");
            StatistiqueTemporaire2.SetFilter("Free field 4", "Free field 4");
            StatistiqueTemporaire2.SetFilter("Free field 5", "Free field 5");
            StatistiqueTemporaire2.SetFilter("Free field 6", "Free field 6");
            StatistiqueTemporaire2.SetFilter("Free field 7", "Free field 7");
            StatistiqueTemporaire2.SetFilter("Free field 8", "Free field 8");
            StatistiqueTemporaire2.SetFilter("Free field 9", "Free field 9");
            StatistiqueTemporaire2.SetFilter("Free field 10", "Free field 10");
            StatistiqueTemporaire2.SetFilter("Free date 1", "Free date 1");
            StatistiqueTemporaire2.SetFilter("Free date 2", "Free date 2");
            StatistiqueTemporaire2.SetFilter("Free date 3", "Free date 3");
            StatistiqueTemporaire2.SetFilter("Free date 4", "Free date 4");
            StatistiqueTemporaire2.SetFilter("Free date 5", "Free date 5");
            StatistiqueTemporaire2.SetFilter("Dimension 1 Value Code", "Dimension 1 Value Code");
            StatistiqueTemporaire2.SetFilter("Dimension 2 Value Code", "Dimension 2 Value Code");
            StatistiqueTemporaire2.SetFilter("Dimension 3 Value Code", "Dimension 3 Value Code");
            StatistiqueTemporaire2.SetFilter("Dimension 4 Value Code", "Dimension 4 Value Code");
            StatistiqueTemporaire2.SetFilter("Dimension 5 Value Code", "Dimension 5 Value Code");
            StatistiqueTemporaire2.SetFilter("Dimension 6 Value Code", "Dimension 6 Value Code");
            StatistiqueTemporaire2.SetFilter("Dimension 7 Value Code", "Dimension 7 Value Code");
            StatistiqueTemporaire2.SetFilter("Dimension 8 Value Code", "Dimension 8 Value Code");
            StatistiqueTemporaire2.SetFilter("Dimension 9 Value Code", "Dimension 9 Value Code");
            StatistiqueTemporaire2.SetFilter("Dimension 10 Value Code", "Dimension 10 Value Code");
            StatistiqueTemporaire2.SetFilter("Dimension 11 Value Code", "Dimension 11 Value Code");
            StatistiqueTemporaire2.SetFilter("Dimension 12 Value Code", "Dimension 12 Value Code");
            StatistiqueTemporaire2.SetFilter("Dimension 13 Value Code", "Dimension 13 Value Code");
            StatistiqueTemporaire2.SetFilter("Dimension 14 Value Code", "Dimension 14 Value Code");
            StatistiqueTemporaire2.SetFilter("Dimension 15 Value Code", "Dimension 15 Value Code");
            StatistiqueTemporaire2.SetFilter("Dimension 16 Value Code", "Dimension 16 Value Code");
            StatistiqueTemporaire2.SetFilter("Dimension 17 Value Code", "Dimension 17 Value Code");
            StatistiqueTemporaire2.SetFilter("Dimension 18 Value Code", "Dimension 18 Value Code");
            StatistiqueTemporaire2.SetFilter("Dimension 19 Value Code", "Dimension 19 Value Code");
            StatistiqueTemporaire2.SetFilter("Dimension 20 Value Code", "Dimension 20 Value Code");
            StatistiqueTemporaire2.SetFilter(Company, FiltreColonneStatistique.Company);
            case "Free boolean 1" of
                "Free boolean 1"::Yes:
                    StatistiqueTemporaire2.SetRange("Free boolean 1", true);
                "Free boolean 1"::No:
                    StatistiqueTemporaire2.SetRange("Free boolean 1", false);
            end;
            case "Free boolean 2" of
                "Free boolean 2"::Yes:
                    StatistiqueTemporaire2.SetRange("Free boolean 2", true);
                "Free boolean 2"::No:
                    StatistiqueTemporaire2.SetRange("Free boolean 2", false);
            end;
            case "Free boolean 3" of
                "Free boolean 3"::Yes:
                    StatistiqueTemporaire2.SetRange("Free boolean 3", true);
                "Free boolean 3"::No:
                    StatistiqueTemporaire2.SetRange("Free boolean 3", false);
            end;
            case "Free boolean 4" of
                "Free boolean 4"::Yes:
                    StatistiqueTemporaire2.SetRange("Free boolean 4", true);
                "Free boolean 4"::No:
                    StatistiqueTemporaire2.SetRange("Free boolean 4", false);
            end;
            case "Free boolean 5" of
                "Free boolean 5"::Yes:
                    StatistiqueTemporaire2.SetRange("Free boolean 5", true);
                "Free boolean 5"::No:
                    StatistiqueTemporaire2.SetRange("Free boolean 5", false);
            end;

            if (TexteFiltreColonne[NumeroColonne] = '') and (StatistiqueTemporaire2.GetFilters <> '') and
               (Col_ImprimerColonne[NumeroColonne] <> Col_ImprimerColonne[NumeroColonne] ::Jamais) then begin
                TexteFiltreColonne[NumeroColonne] :=
                        CopyStr(TexteFiltreComplementaire + ' ' + StatistiqueTemporaire2.GetFilters, 1, 249 - StrLen(TexteFiltreComplementaire));
                DefinitionStatistiqueTemp.Init;
                DefinitionStatistiqueTemp."User ID" := User;
                DefinitionStatistiqueTemp."Statistic code" := CodePredefini;
                DefinitionStatistiqueTemp."Line No." := 1000010 + (NumeroColonne * 100);
                DefinitionStatistiqueTemp.Description := TexteFiltreColonne[NumeroColonne];
                DefinitionStatistiqueTemp.Insert;
            end;

            StatistiqueTemporaire2.SetRange("Entry No.", NumeroSequence);
            if StatistiqueTemporaire2.Find('-') then
                exit(true);
        end;
    end;

    [Scope('OnPrem')]
    procedure EvalExpression(Expression: Text[250]; Formule: Text[250]; NumeroLigne: Integer): Decimal
    var
        ResultatFormule: Decimal;
        Parentheses: Integer;
        Operateur: Char;
        OperateurGauche: Text[80];
        OperateurDroit: Text[80];
        ResultatGauche: Decimal;
        ResultatDroit: Decimal;
        i: Integer;
        EstExpression: Boolean;
        EstFiltre: Boolean;
        Operateurs: Text[8];
        NumeroOperateur: Integer;
        IDLigneTableauAna: Integer;
        Trouveformule: Boolean;
    begin
        ResultatFormule := 0;

        NiveauAppel := NiveauAppel + 1;
        if NiveauAppel > 25 then
            TexteErreurFormule := StrSubstNo(ErrorFormule2, Formule);

        while (StrLen(Expression) > 1) and (Expression[1] = ' ') do
            Expression := CopyStr(Expression, 2);
        if Expression <> '' then
            while (StrLen(Expression) > 1) and (Expression[StrLen(Expression)] = ' ') do
                Expression := CopyStr(Expression, 1, StrLen(Expression) - 1);
        if StrLen(Expression) > 0 then begin
            Parentheses := 0;
            EstExpression := false;
            Operateurs := '+-*/^';
            NumeroOperateur := 1;
            repeat
                i := StrLen(Expression);
                repeat
                    if Expression[i] = '(' then
                        Parentheses := Parentheses + 1
                    else
                        if Expression[i] = ')' then
                            Parentheses := Parentheses - 1;
                    if (Parentheses = 0) and (Expression[i] = Operateurs[NumeroOperateur]) then
                        EstExpression := true
                    else
                        i := i - 1;
                until EstExpression or (i <= 0);
                if not EstExpression then
                    NumeroOperateur := NumeroOperateur + 1;
            until (NumeroOperateur > StrLen(Operateurs)) or EstExpression;
            if EstExpression then begin
                if i > 1 then
                    OperateurGauche := CopyStr(Expression, 1, i - 1)
                else
                    OperateurGauche := '';
                if i < StrLen(Expression) then
                    OperateurDroit := CopyStr(Expression, i + 1)
                else
                    OperateurDroit := '';
                Operateur := Expression[i];
                ResultatGauche := EvalExpression(OperateurGauche, Formule, NumeroLigne);
                ResultatDroit := EvalExpression(OperateurDroit, Formule, NumeroLigne);
                case Operateur of
                    '^':
                        ResultatFormule := Power(ResultatGauche, ResultatDroit);
                    '*':
                        ResultatFormule := ResultatGauche * ResultatDroit;
                    '/':
                        if ResultatDroit = 0 then begin
                            ResultatFormule := 0;
                            ErreurDivision := true;
                        end else
                            ResultatFormule := ResultatGauche / ResultatDroit;
                    '+':
                        ResultatFormule := ResultatGauche + ResultatDroit;
                    '-':
                        ResultatFormule := ResultatGauche - ResultatDroit;
                end;
            end else
                if (Expression[1] = '(') and (Expression[StrLen(Expression)] = ')') then
                    ResultatFormule :=
                      EvalExpression(
                        CopyStr(Expression, 2, StrLen(Expression) - 2),
                        Formule, NumeroLigne)
                else begin
                    EstFiltre :=
                       (StrPos(Expression, '..') +
                        StrPos(Expression, '|') +
                        StrPos(Expression, '<') +
                        StrPos(Expression, '>') +
                        StrPos(Expression, '=') > 0);
                    if (StrLen(Expression) > 10) and (not EstFiltre) then
                        Evaluate(ResultatFormule, Expression)
                    else begin
                        j := 0;
                        Trouveformule := false;
                        repeat
                            j := j + 1;
                            IDLigneTableauAna := NumeroLigne;
                            if (Col_NoLigne[j] <> IDLigneTableauAna) and (Col_NoColonne[j] = Expression) then begin
                                ResultatFormule := ResultatFormule + Col_Resultat[j];
                                Trouveformule := true;
                            end;

                        until (j = NombreColonnes);
                        if not Trouveformule then
                            if EstFiltre or (not Evaluate(ResultatFormule, Expression)) then
                                TexteErreurFormule := StrSubstNo(ErrorFormule1, Expression);
                    end;
                end;
        end;
        NiveauAppel := NiveauAppel - 1;
        exit(ResultatFormule);
    end;

    [Scope('OnPrem')]
    procedure ArrondirMontants()
    var
        ParamCompta: Record "General Ledger Setup";
    begin
        NonNul := false;
        if FormatStringNormal = '' then begin
            ParamCompta.Get;
            FormatStringNormal := '<Precision,' + ParamCompta."Amount Decimal Places" + '><Standard Format,0>';
        end;

        i := 0;
        j := 0;
        repeat
            j := j + 1;
            if (Col_ImprimerColonne[j] <> Col_ImprimerColonne[j] ::Jamais) then begin
                i := i + 1;
                case Col_UniteAffichage[j] of
                    Col_UniteAffichage[j] ::Standard:
                        Col_ResultatCommeTexte[i] := Format(Col_Resultat[j], 0, FormatStringNormal);
                    Col_UniteAffichage[j] ::"1":
                        Col_ResultatCommeTexte[i] := Format(Round(Col_Resultat[j], 1));
                    Col_UniteAffichage[j] ::"1000":
                        Col_ResultatCommeTexte[i] := Format(Round(Col_Resultat[j] / 1000, 0.1), 0, '<Precision,1><Standard Format,0>');
                    Col_UniteAffichage[j] ::"1000000":
                        Col_ResultatCommeTexte[i] := Format(Round(Col_Resultat[j] / 1000000, 0.1), 0, '<Precision,1><Standard Format,0>');
                end;
                Col_Resultat2[i] := Col_Resultat[j];
                if Col_Resultat[j] = 0 then
                    Col_ResultatCommeTexte[i] := '';
                if ((Col_ImprimerColonne[j] = Col_ImprimerColonne[j] ::"Si positif") and (Col_Resultat[j] < 0)) or
                   ((Col_ImprimerColonne[j] = Col_ImprimerColonne[j] ::"Si négatif") and (Col_Resultat[j] > 0)) then
                    Col_ResultatCommeTexte[i] := '';
                if Col_ResultatCommeTexte[i] <> '' then
                    NonNul := true;
            end;
        until i = NombreColonnes;
    end;

    [Scope('OnPrem')]
    procedure CreerEntete()
    begin
        i := 0;
        j := 0;
        repeat
            j := j + 1;
            if (Col_ImprimerColonne[j] <> Col_ImprimerColonne[j] ::Jamais) then begin
                i := i + 1;
                Col_Titre1[i] := Col_Titre1[j];
                Col_DateDebutTitre[i] := Col_DateDebut[j];
                Col_DateFinTitre[i] := Col_DateFin[j];
            end;
        until i = NombreColonnes;
    end;

    [Scope('OnPrem')]
    procedure CalculerTotaux()
    begin
        i := 0;
        repeat
            i := i + 1;
            // Type 30 = formule
            if Col_TypeDeColonne[i] = TypeValeur[30] then begin
                Col_Resultat[i] := EvalExpression(Col_Formule[i], Col_Formule[i], Col_NoLigne[i]);
            end;
        until i = NombreColonnes;

        CreerLibelle;
    end;

    [Scope('OnPrem')]
    procedure CreerLibelle()
    var
        Client: Record Customer;
        Fournisseur: Record Vendor;
        Banque: Record "Bank Account";
        Immobilisation: Record "Fixed Asset";
        Vendeur: Record "Salesperson/Purchaser";
        GroupeComptaStock: Record "Inventory Posting Group";
        Magasin: Record Location;
        CentreProfit: Record "Business Unit";
        Pays: Record "Country/Region";
        Codes: Record "Code";
        Projet: Record Job;
        TypeTravail: Record "Work Type";
        Motif: Record "Reason Code";
        MotifAbsence: Record "Cause of Absence";
        GroupeComptaProjet: Record "Job Posting Group";
        GroupeRessource: Record "Resource Group";
        Ressource: Record Resource;
        Salarie: Record Employee;
        NomBudget: Record "G/L Budget Name";
        LoiRFA: Record "Discount Rule";
        JourTempo: Integer;
        MoisTempo: Integer;
        AnneeTempo: Integer;
        DateTempo: Date;
        ValeurTempo: Integer;
        Dimension: Record "Dimension Value";
        GroupeMarche: Record "Gen. Business Posting Group";
        GroupeProduit: Record "Gen. Product Posting Group";
        ItemCharge: Record "Item Charge";
        ItemVariant: Record "Item Variant";
        ReturnReason: Record "Return Reason";
        Manufacturer: Record Manufacturer;
        ItemCategory: Record "Item Category";

        ServiceItemGroup: Record "Service Item Group";
        DimensionValue: Record "Dimension Value";
        Campaign: Record Campaign;
    begin
        with Statistiques do begin

            case Type of
                Type::"Account (G/L)":
                    if Compte."No." <> "No." then
                        if not Compte.Get("No.") then
                            Compte.Init
                        else
                            TexteDetail := Compte."No." + ' ' + Compte.Name;
                Type::Item:
                    if Article."No." <> "No." then
                        if not Article.Get("No.") then
                            Article.Init
                        else
                            TexteDetail := Article."No." + ' ' + Article.Description;
                Type::Resource:
                    if Ressource."No." <> "No." then
                        if not Ressource.Get("No.") then
                            Ressource.Init
                        else
                            TexteDetail := Ressource."No." + ' ' + Ressource.Name;
                Type::Employee:
                    if Salarie."No." <> "No." then
                        if not Salarie.Get("No.") then
                            Salarie.Init
                        else
                            TexteDetail := Salarie."No." + ' ' + Salarie."Last Name";
                Type::"Resource Group":
                    if GroupeRessource."No." <> "No." then
                        if not GroupeRessource.Get("No.") then
                            GroupeRessource.Init
                        else
                            TexteDetail := GroupeRessource."No." + ' ' + GroupeRessource.Name;
            end;

            i := 0;
            repeat
                if i < 10 then
                    i := i + 1;
                LibelleRupture[i] := '';
                if (NumeroChamp[i] <> 0) and (Valeur[i] <> '') then begin
                    case NumeroChamp[i] of
                        4:
                            begin
                                LibelleRupture[i] := "Entry Type";
                            end;
                        5:
                            begin
                                LibelleRupture[i] := StrSubstNo('%1', Type);
                            end;
                        8:
                            begin
                                LibelleRupture[i] := StrSubstNo('%1', "Source Type");
                            end;
                        6:
                            begin
                                if PositionDebut[i] > 0 then
                                    ValeurTempo := 3
                                else
                                    ValeurTempo := 1;

                                case Type of
                                    Type::Item:
                                        begin
                                            if Article."No." <> CopyStr(Valeur[i], ValeurTempo, 20) then
                                                if not Article.Get(CopyStr(Valeur[i], ValeurTempo, 20)) then
                                                    Article.Init;
                                            LibelleRupture[i] := Article.Description;
                                            if (Article."Description 2" <> '') and (StrLen(Article.Description) < 50) then
                                                if StrLen(Article.Description + ' - ' + Article."Description 2") <= 50 then
                                                    LibelleRupture[i] := CopyStr(Article.Description + ' - ' + Article."Description 2", 1, 50)
                                                else
                                                    LibelleRupture[i] := CopyStr(Article.Description + ' - ' +
                                                    CopyStr(Article."Description 2", 1, (47 - StrLen(CopyStr(Article.Description, 1, 46)))), 1, 50);
                                        end;
                                    Type::Resource:
                                        begin
                                            if Ressource."No." <> CopyStr(Valeur[i], ValeurTempo, 20) then
                                                if not Ressource.Get(CopyStr(Valeur[i], ValeurTempo, 20)) then
                                                    Ressource.Init;
                                            LibelleRupture[i] := Ressource.Name;
                                        end;
                                    Type::"Account (G/L)":
                                        begin
                                            if Compte."No." <> CopyStr(Valeur[i], ValeurTempo, 20) then
                                                if not Compte.Get(CopyStr(Valeur[i], ValeurTempo, 20)) then begin
                                                    Compte.Reset;
                                                    Compte.SetRange("Account Type", Compte."Account Type"::"Begin-Total");
                                                    Compte.SetFilter("No.", '%1', CopyStr(Valeur[i], ValeurTempo, 20) + '*');
                                                    if not Compte.Find('+') then
                                                        Compte.Init;
                                                end;
                                            LibelleRupture[i] := Compte.Name;
                                        end;
                                    Type::Employee:
                                        begin
                                            if Salarie."No." <> CopyStr(Valeur[i], ValeurTempo, 20) then
                                                if not Salarie.Get(CopyStr(Valeur[i], ValeurTempo, 20)) then
                                                    Salarie.Init;
                                            LibelleRupture[i] := Salarie."Last Name";
                                        end;
                                    Type::"Resource Group":
                                        begin
                                            if GroupeRessource."No." <> CopyStr(Valeur[i], ValeurTempo, 20) then
                                                if not GroupeRessource.Get(CopyStr(Valeur[i], ValeurTempo, 20)) then
                                                    GroupeRessource.Init;
                                            LibelleRupture[i] := GroupeRessource.Name;
                                        end;
                                    else
                                        LibelleRupture[i] := '';
                                end;
                            end;
                        9:
                            begin
                                if PositionDebut[i] > 0 then
                                    ValeurTempo := 3
                                else
                                    ValeurTempo := 1;

                                case "Source Type" of
                                    "Source Type"::Customer:
                                        begin
                                            if Client."No." <> CopyStr(Valeur[i], ValeurTempo, 20) then
                                                if not Client.Get(CopyStr(Valeur[i], ValeurTempo, 20)) then
                                                    Client.Init;
                                            LibelleRupture[i] := Client.Name;
                                        end;
                                    "Source Type"::Vendor:
                                        begin
                                            if Fournisseur."No." <> CopyStr(Valeur[i], ValeurTempo, 20) then
                                                if not Fournisseur.Get(CopyStr(Valeur[i], ValeurTempo, 20)) then
                                                    Fournisseur.Init;
                                            LibelleRupture[i] := Fournisseur.Name;
                                        end;
                                    "Source Type"::Item:
                                        begin
                                            if Article."No." <> CopyStr(Valeur[i], ValeurTempo, 20) then
                                                if not Article.Get(CopyStr(Valeur[i], ValeurTempo, 20)) then
                                                    Article.Init;
                                            LibelleRupture[i] := Article.Description;
                                        end;
                                    "Source Type"::"Bank Account":
                                        begin
                                            if Banque."No." <> CopyStr(Valeur[i], ValeurTempo, 20) then
                                                if not Banque.Get(CopyStr(Valeur[i], ValeurTempo, 20)) then
                                                    Banque.Init;
                                            LibelleRupture[i] := Banque.Name;
                                        end;
                                    "Source Type"::"Fixed Asset":
                                        begin
                                            if Immobilisation."No." <> CopyStr(Valeur[i], ValeurTempo, 20) then
                                                if not Immobilisation.Get(CopyStr(Valeur[i], ValeurTempo, 20)) then
                                                    Immobilisation.Init;
                                            LibelleRupture[i] := Immobilisation.Description;
                                        end;
                                    "Source Type"::Budget:
                                        begin
                                            if NomBudget.Name <> CopyStr(Valeur[i], ValeurTempo, 20) then
                                                if not NomBudget.Get(CopyStr(Valeur[i], ValeurTempo, 20)) then
                                                    NomBudget.Init;
                                            LibelleRupture[i] := NomBudget.Name;
                                        end;
                                    else
                                        LibelleRupture[i] := '';
                                end;
                            end;
                        11:
                            begin
                                if Magasin.Code <> Valeur[i] then
                                    if not Magasin.Get(Valeur[i]) then
                                        Magasin.Init;
                                LibelleRupture[i] := Magasin.Name;
                            end;
                        12:
                            begin
                                if GroupeComptaStock.Code <> Valeur[i] then
                                    if not GroupeComptaStock.Get(Valeur[i]) then
                                        GroupeComptaStock.Init;
                                LibelleRupture[i] := GroupeComptaStock.Description;
                            end;
                        14:
                            begin
                                if GroupeMarche.Code <> Valeur[i] then
                                    if not GroupeMarche.Get(Valeur[i]) then
                                        GroupeMarche.Init;
                                LibelleRupture[i] := GroupeMarche.Description;
                            end;
                        15:
                            begin
                                if GroupeProduit.Code <> Valeur[i] then
                                    if not GroupeProduit.Get(Valeur[i]) then
                                        GroupeProduit.Init;
                                LibelleRupture[i] := GroupeProduit.Description;
                            end;
                        16:
                            begin
                                if Vendeur.Code <> Valeur[i] then
                                    if not Vendeur.Get(Valeur[i]) then
                                        Vendeur.Init;
                                LibelleRupture[i] := Vendeur.Name;
                            end;
                        17:
                            begin
                                if (Dimension."Dimension Code" <> ParametresComptabilite."Global Dimension 1 Code")
                                and (Dimension.Code <> Valeur[i]) then
                                    if not Dimension.Get(ParametresComptabilite."Global Dimension 1 Code", Valeur[i]) then
                                        Dimension.Init;
                                LibelleRupture[i] := Dimension.Name;
                            end;
                        18:
                            begin
                                if (Dimension."Dimension Code" <> ParametresComptabilite."Global Dimension 2 Code")
                                and (Dimension.Code <> Valeur[i]) then
                                    if not Dimension.Get(ParametresComptabilite."Global Dimension 2 Code", Valeur[i]) then
                                        Dimension.Init;
                                LibelleRupture[i] := Dimension.Name;
                            end;
                        19:
                            begin
                                if Pays.Code <> Valeur[i] then
                                    if not Pays.Get(Valeur[i]) then
                                        Pays.Init;
                                LibelleRupture[i] := Pays.Name;
                            end;
                        30:
                            LibelleRupture[i] := TexteAnnee + ' ' + Valeur[i];
                        31:
                            LibelleRupture[i] := TexteSemestre + ' ' + Valeur[i];
                        32:
                            LibelleRupture[i] := TexteTrimestre + ' ' + Valeur[i];
                        33:
                            begin
                                Evaluate(MoisTempo, CopyStr(Valeur[i], 2, 2));
                                LibelleRupture[i] := Format(DMY2Date(1, MoisTempo, 1900), 0, '<Month Text>');
                            end;
                        34:
                            LibelleRupture[i] := TexteSemaine + ' ' + Valeur[i];
                        35:
                            begin
                                Evaluate(JourTempo, CopyStr(Valeur[i], 7, 2));
                                Evaluate(MoisTempo, CopyStr(Valeur[i], 5, 2));
                                Evaluate(AnneeTempo, CopyStr(Valeur[i], 1, 4));
                                DateTempo := DMY2Date(JourTempo, MoisTempo, AnneeTempo);
                                LibelleRupture[i] := Format(DateTempo, 0, 4);
                            end;
                        36:
                            begin
                                Evaluate(MoisTempo, CopyStr(Valeur[i], 1, 1));
                                if MoisTempo <> 0 then
                                    LibelleRupture[i] := Format(DWY2Date(MoisTempo, 1, 1), 0, '<WeekDay Text>');
                            end;
                        37:
                            begin
                                if CentreProfit.Code <> Valeur[i] then
                                    if not CentreProfit.Get(Valeur[i]) then
                                        CentreProfit.Init;
                                LibelleRupture[i] := CentreProfit.Name;
                            end;
                        38, 39:
                            begin
                                if Compte.Get(Valeur[i]) then
                                    LibelleRupture[i] := Compte.Name
                                else
                                    LibelleRupture[i] := '';
                            end;
                        40:
                            begin
                                if Projet."No." <> Valeur[i] then
                                    if not Projet.Get(Valeur[i]) then
                                        Projet.Init;
                                LibelleRupture[i] := Projet.Description;
                            end;
                        /*           41:BEGIN
                                      IF Phase.Code <> Valeur[i] THEN
                                         IF NOT Phase.GET(Valeur[i]) THEN
                                            Phase.INIT;
                                      LibelleRupture[i] := Phase.Description;
                                      IF Object.GET(Object.Type::Codeunit,'',8003952) THEN BEGIN
                                         Statistiques."Phase Code" := Valeur[i];
                                         CODEUNIT.RUN(CODEUNIT::Codeunit8003952,Statistiques);
                                         LibelleRupture[i] := Statistiques.Description;
                                      END;
                                      END;
                                   42:BEGIN
                                      IF Tache.Code <> Valeur[i] THEN
                                         IF NOT Tache.GET(Valeur[i]) THEN
                                            Tache.INIT;
                                      LibelleRupture[i] := Tache.Description;
                                      END;
                                   43:BEGIN
                                      IF Etape.Code <> Valeur[i] THEN
                                         IF NOT Etape.GET(Valeur[i]) THEN
                                            Etape.INIT;
                                      LibelleRupture[i] := Etape.Description;
                                      END;
                         */
                        44:
                            begin
                                if TypeTravail.Code <> Valeur[i] then
                                    if not TypeTravail.Get(Valeur[i]) then
                                        TypeTravail.Init;
                                LibelleRupture[i] := TypeTravail.Description;
                            end;
                        45:
                            if Type = Type::Employee then begin
                                if MotifAbsence.Code <> Valeur[i] then
                                    if not MotifAbsence.Get(Valeur[i]) then
                                        MotifAbsence.Init;
                                LibelleRupture[i] := MotifAbsence.Description;
                            end else begin
                                if Motif.Code <> Valeur[i] then
                                    if not Motif.Get(Valeur[i]) then
                                        Motif.Init;
                                LibelleRupture[i] := Motif.Description;
                            end;
                        47:
                            begin
                                if GroupeRessource."No." <> Valeur[i] then
                                    if not GroupeRessource.Get(Valeur[i]) then
                                        GroupeRessource.Init;
                                LibelleRupture[i] := GroupeRessource.Name;
                            end;
                        48:
                            begin
                                if Ressource."No." <> Valeur[i] then
                                    if not Ressource.Get(Valeur[i]) then
                                        Ressource.Init;
                                LibelleRupture[i] := Ressource.Name;
                            end;
                        50:
                            begin
                                if ItemCharge."No." <> Valeur[i] then
                                    if not ItemCharge.Get(Valeur[i]) then
                                        ItemCharge.Init;
                                LibelleRupture[i] := ItemCharge.Description;
                            end;
                        51:
                            begin
                                if (ItemVariant."Item No." <> "No.") and (ItemVariant.Code <> Valeur[i]) then
                                    if not ItemVariant.Get("No.", Valeur[i]) then
                                        ItemVariant.Init;
                                LibelleRupture[i] := ItemVariant.Description;
                            end;
                        52:
                            begin
                                if ReturnReason.Code <> Valeur[i] then
                                    if not ReturnReason.Get(Valeur[i]) then
                                        ReturnReason.Init;
                                LibelleRupture[i] := ReturnReason.Description;
                            end;
                        53:
                            begin
                                if Manufacturer.Code <> Valeur[i] then
                                    if not Manufacturer.Get(Valeur[i]) then
                                        Manufacturer.Init;
                                LibelleRupture[i] := Manufacturer.Name;
                            end;
                        54:
                            begin
                                if ItemCategory.Code <> Valeur[i] then
                                    if not ItemCategory.Get(Valeur[i]) then
                                        ItemCategory.Init;
                                LibelleRupture[i] := ItemCategory.Description;
                            end;

                        56:
                            begin
                                if ServiceItemGroup.Code <> Valeur[i] then
                                    if not ServiceItemGroup.Get(Valeur[i]) then
                                        ServiceItemGroup.Init;
                                LibelleRupture[i] := ServiceItemGroup.Description;
                            end;
                        57:
                            begin
                                if Campaign."No." <> Valeur[i] then
                                    if not Campaign.Get(Valeur[i]) then
                                        Campaign.Init;
                                LibelleRupture[i] := Campaign.Description;
                            end;
                        59:
                            begin
                                if LoiRFA."No." <> Valeur[i] then
                                    if ((not LoiRFA.Get(LoiRFA."Discount and comm. type"::"Back discount", Valeur[i]))
                                      and (not LoiRFA.Get(LoiRFA."Discount and comm. type"::Commission, Valeur[i]))) then
                                        LoiRFA.Init;
                                LibelleRupture[i] := CopyStr(LoiRFA.Description, 1, 50);
                            end;
                        60:
                            begin
                                if (Codes."Table No" <> 27) or (Codes."Field No" <> 8001301) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(27, 8001301, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        61:
                            begin
                                if (Codes."Table No" <> 27) or (Codes."Field No" <> 8001302) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(27, 8001302, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        62:
                            begin
                                if (Codes."Table No" <> 27) or (Codes."Field No" <> 8001303) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(27, 8001303, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        63:
                            begin
                                if (Codes."Table No" <> 27) or (Codes."Field No" <> 8001304) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(27, 8001304, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        64:
                            begin
                                if (Codes."Table No" <> 27) or (Codes."Field No" <> 8001305) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(27, 8001305, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        65:
                            begin
                                if (Codes."Table No" <> 27) or (Codes."Field No" <> 8001306) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(27, 8001306, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        66:
                            begin
                                if (Codes."Table No" <> 27) or (Codes."Field No" <> 8001307) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(27, 8001307, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        67:
                            begin
                                if (Codes."Table No" <> 27) or (Codes."Field No" <> 8001308) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(27, 8001308, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        68:
                            begin
                                if (Codes."Table No" <> 27) or (Codes."Field No" <> 8001309) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(27, 8001309, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        69:
                            begin
                                if (Codes."Table No" <> 27) or (Codes."Field No" <> 8001310) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(27, 8001310, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        70:
                            begin
                                if (Codes."Table No" <> 18) or (Codes."Field No" <> 8001301) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(18, 8001301, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        71:
                            begin
                                if (Codes."Table No" <> 18) or (Codes."Field No" <> 8001302) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(18, 8001302, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        72:
                            begin
                                if (Codes."Table No" <> 18) or (Codes."Field No" <> 8001303) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(18, 8001303, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        73:
                            begin
                                if (Codes."Table No" <> 18) or (Codes."Field No" <> 8001304) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(18, 8001304, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        74:
                            begin
                                if (Codes."Table No" <> 18) or (Codes."Field No" <> 8001305) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(18, 8001305, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        75:
                            begin
                                if (Codes."Table No" <> 18) or (Codes."Field No" <> 8001306) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(18, 8001306, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        76:
                            begin
                                if (Codes."Table No" <> 18) or (Codes."Field No" <> 8001307) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(18, 8001307, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        77:
                            begin
                                if (Codes."Table No" <> 18) or (Codes."Field No" <> 8001308) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(18, 8001308, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        78:
                            begin
                                if (Codes."Table No" <> 18) or (Codes."Field No" <> 8001309) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(18, 8001309, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        79:
                            begin
                                if (Codes."Table No" <> 18) or (Codes."Field No" <> 8001310) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(18, 8001310, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        80:
                            begin
                                if (Codes."Table No" <> 8001300) or (Codes."Field No" <> 1001) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(8001300, 1001, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        81:
                            begin
                                if (Codes."Table No" <> 8001300) or (Codes."Field No" <> 1002) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(8001300, 1002, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        82:
                            begin
                                if (Codes."Table No" <> 8001300) or (Codes."Field No" <> 1003) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(8001300, 1003, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        83:
                            begin
                                if (Codes."Table No" <> 8001300) or (Codes."Field No" <> 1004) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(8001300, 1004, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        84:
                            begin
                                if (Codes."Table No" <> 8001300) or (Codes."Field No" <> 1005) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(8001300, 1005, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        85:
                            begin
                                if (Codes."Table No" <> 8001300) or (Codes."Field No" <> 1006) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(8001300, 1006, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        86:
                            begin
                                if (Codes."Table No" <> 8001300) or (Codes."Field No" <> 1007) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(8001300, 1007, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        87:
                            begin
                                if (Codes."Table No" <> 8001300) or (Codes."Field No" <> 1008) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(8001300, 1008, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        88:
                            begin
                                if (Codes."Table No" <> 8001300) or (Codes."Field No" <> 1009) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(8001300, 1009, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        89:
                            begin
                                if (Codes."Table No" <> 8001300) or (Codes."Field No" <> 1010) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(8001300, 1010, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        90, 91, 92, 93, 94:
                            begin
                                Evaluate(JourTempo, CopyStr(Valeur[i], 7, 2));
                                Evaluate(MoisTempo, CopyStr(Valeur[i], 5, 2));
                                Evaluate(AnneeTempo, CopyStr(Valeur[i], 1, 4));
                                DateTempo := DMY2Date(JourTempo, MoisTempo, AnneeTempo);
                                LibelleRupture[i] := Format(DateTempo, 0, 4);
                            end;
                        201:
                            begin
                                if DimensionValue.Get(ParametresStatistiques."Dimension 1 Code", Valeur[i]) then
                                    LibelleRupture[i] := DimensionValue.Name
                                else
                                    LibelleRupture[i] := Valeur[i];
                            end;
                        202:
                            begin
                                if DimensionValue.Get(ParametresStatistiques."Dimension 2 Code", Valeur[i]) then
                                    LibelleRupture[i] := DimensionValue.Name
                                else
                                    LibelleRupture[i] := Valeur[i];
                            end;
                        203:
                            begin
                                if DimensionValue.Get(ParametresStatistiques."Dimension 3 Code", Valeur[i]) then
                                    LibelleRupture[i] := DimensionValue.Name
                                else
                                    LibelleRupture[i] := Valeur[i];
                            end;
                        204:
                            begin
                                if DimensionValue.Get(ParametresStatistiques."Dimension 4 Code", Valeur[i]) then
                                    LibelleRupture[i] := DimensionValue.Name
                                else
                                    LibelleRupture[i] := Valeur[i];
                            end;
                        205:
                            begin
                                if DimensionValue.Get(ParametresStatistiques."Dimension 5 Code", Valeur[i]) then
                                    LibelleRupture[i] := DimensionValue.Name
                                else
                                    LibelleRupture[i] := Valeur[i];
                            end;
                        206:
                            begin
                                if DimensionValue.Get(ParametresStatistiques."Dimension 6 Code", Valeur[i]) then
                                    LibelleRupture[i] := DimensionValue.Name
                                else
                                    LibelleRupture[i] := Valeur[i];
                            end;
                        207:
                            begin
                                if DimensionValue.Get(ParametresStatistiques."Dimension 7 Code", Valeur[i]) then
                                    LibelleRupture[i] := DimensionValue.Name
                                else
                                    LibelleRupture[i] := Valeur[i];
                            end;
                        208:
                            begin
                                if DimensionValue.Get(ParametresStatistiques."Dimension 8 Code", Valeur[i]) then
                                    LibelleRupture[i] := DimensionValue.Name
                                else
                                    LibelleRupture[i] := Valeur[i];
                            end;
                        209:
                            begin
                                if DimensionValue.Get(ParametresStatistiques."Dimension 9 Code", Valeur[i]) then
                                    LibelleRupture[i] := DimensionValue.Name
                                else
                                    LibelleRupture[i] := Valeur[i];
                            end;
                        210:
                            begin
                                if DimensionValue.Get(ParametresStatistiques."Dimension 10 Code", Valeur[i]) then
                                    LibelleRupture[i] := DimensionValue.Name
                                else
                                    LibelleRupture[i] := Valeur[i];
                            end;
                        211:
                            begin
                                if DimensionValue.Get(ParametresStatistiques."Dimension 11 Code", Valeur[i]) then
                                    LibelleRupture[i] := DimensionValue.Name
                                else
                                    LibelleRupture[i] := Valeur[i];
                            end;
                        212:
                            begin
                                if DimensionValue.Get(ParametresStatistiques."Dimension 12 Code", Valeur[i]) then
                                    LibelleRupture[i] := DimensionValue.Name
                                else
                                    LibelleRupture[i] := Valeur[i];
                            end;
                        213:
                            begin
                                if DimensionValue.Get(ParametresStatistiques."Dimension 13 Code", Valeur[i]) then
                                    LibelleRupture[i] := DimensionValue.Name
                                else
                                    LibelleRupture[i] := Valeur[i];
                            end;
                        214:
                            begin
                                if DimensionValue.Get(ParametresStatistiques."Dimension 14 Code", Valeur[i]) then
                                    LibelleRupture[i] := DimensionValue.Name
                                else
                                    LibelleRupture[i] := Valeur[i];
                            end;
                        215:
                            begin
                                if DimensionValue.Get(ParametresStatistiques."Dimension 15 Code", Valeur[i]) then
                                    LibelleRupture[i] := DimensionValue.Name
                                else
                                    LibelleRupture[i] := Valeur[i];
                            end;
                        216:
                            begin
                                if DimensionValue.Get(ParametresStatistiques."Dimension 16 Code", Valeur[i]) then
                                    LibelleRupture[i] := DimensionValue.Name
                                else
                                    LibelleRupture[i] := Valeur[i];
                            end;
                        217:
                            begin
                                if DimensionValue.Get(ParametresStatistiques."Dimension 17 Code", Valeur[i]) then
                                    LibelleRupture[i] := DimensionValue.Name
                                else
                                    LibelleRupture[i] := Valeur[i];
                            end;
                        218:
                            begin
                                if DimensionValue.Get(ParametresStatistiques."Dimension 18 Code", Valeur[i]) then
                                    LibelleRupture[i] := DimensionValue.Name
                                else
                                    LibelleRupture[i] := Valeur[i];
                            end;
                        219:
                            begin
                                if DimensionValue.Get(ParametresStatistiques."Dimension 19 Code", Valeur[i]) then
                                    LibelleRupture[i] := DimensionValue.Name
                                else
                                    LibelleRupture[i] := Valeur[i];
                            end;
                        220:
                            begin
                                if DimensionValue.Get(ParametresStatistiques."Dimension 20 Code", Valeur[i]) then
                                    LibelleRupture[i] := DimensionValue.Name
                                else
                                    LibelleRupture[i] := Valeur[i];
                            end;
                        300:
                            begin
                                if (Codes."Table No" <> 167) or (Codes."Field No" <> 8001301) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(167, 8001301, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        301:
                            begin
                                if (Codes."Table No" <> 167) or (Codes."Field No" <> 8001302) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(167, 8001302, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        302:
                            begin
                                if (Codes."Table No" <> 167) or (Codes."Field No" <> 8001303) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(167, 8001303, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        303:
                            begin
                                if (Codes."Table No" <> 167) or (Codes."Field No" <> 8001304) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(167, 8001304, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        304:
                            begin
                                if (Codes."Table No" <> 167) or (Codes."Field No" <> 8001305) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(167, 8001305, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        305:
                            begin
                                if (Codes."Table No" <> 167) or (Codes."Field No" <> 8001306) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(167, 8001306, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        306:
                            begin
                                if (Codes."Table No" <> 167) or (Codes."Field No" <> 8001307) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(167, 8001307, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        307:
                            begin
                                if (Codes."Table No" <> 167) or (Codes."Field No" <> 8001308) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(167, 8001308, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        308:
                            begin
                                if (Codes."Table No" <> 167) or (Codes."Field No" <> 8001309) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(167, 8001309, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                        309:
                            begin
                                if (Codes."Table No" <> 167) or (Codes."Field No" <> 8001310) or (Codes.Code <> Valeur[i]) then
                                    if not Codes.Get(167, 8001310, Valeur[i]) then
                                        Codes.Init;
                                LibelleRupture[i] := Codes.Description;
                            end;
                    end;
                    if LibelleRupture[i] = '' then
                        LibelleRupture[i] := Valeur[i];
                end else
                    LibelleRupture[i] := '';
            until i = 10;

        end;

    end;

    [Scope('OnPrem')]
    procedure EcrireResultats(wNiveau: Integer; wCode: Text[30]; wDesignation: Text[100]; wDesignationRupture: Text[100])
    begin
        //      MESSAGE('%1  %2  %3   %4',wNiveau,wCode,wDesignation,wDesignationRupture);

        i := wNiveau;
        if i > 1 then
            repeat
                i := i - 1;
                NombreLignes[i] := NombreLignes[i] + 1;
            until i = 1;

        i := 0;
        with LignesStatistiquesTemp do begin
            Init;
            "User ID" := User;
            "Statistic code" := CodePredefini;
            "Line No." := NumeroLigne[wNiveau];
            if wNiveau <> 1 then
                "Attached to Line No." := NumeroLigne[wNiveau - 1]
            else begin
                LignesStatistiquesTemp2.SetCurrentKey("User ID", "Statistic code", "Section level", "Attached to Line No.",
                                                      "Sort value", "Line No.");
                LignesStatistiquesTemp2.SetRange("User ID", User);
                LignesStatistiquesTemp2.SetRange("Statistic code", CodePredefini);
                LignesStatistiquesTemp2.SetRange("Section level", 2);
                LignesStatistiquesTemp2.ModifyAll("Attached to Line No.", NumeroLigne[wNiveau]);
            end;
            Code := wCode;
            Description := wDesignation;
            "Break 1" := TableauCles[1];
            "Break 2" := TableauCles[2];
            "Break 3" := TableauCles[3];
            "Break 4" := TableauCles[4];
            "Break 5" := TableauCles[5];
            "Break 6" := TableauCles[6];
            "Break 7" := TableauCles[7];
            "Break 8" := TableauCles[8];
            "Break 9" := TableauCles[9];
            "Break 10" := TableauCles[10];
            "Section level" := wNiveau;
            "Section name" := wDesignationRupture;
            NombreLignes[wNiveau] := NombreLignes[wNiveau] + 1;
            "Lower lines count" := NombreLignes[wNiveau + 1];
            if Insert then;
        end;

        with ResultatsStatistiquesTemp do begin
            repeat
                i := i + 1;
                if Col_ResultatCommeTexte[i] <> '' then begin
                    Init;
                    "User ID" := User;
                    "Statistic code" := CodePredefini;
                    "Column No." := i;
                    "Line No." := NumeroLigne[wNiveau];
                    "Computed result" := Col_Resultat2[i];
                    "Printed result" := Col_ResultatCommeTexte[i];
                    if Insert then;
                end;
            until i = NombreColonnesImprimees;
        end;
    end;

    [Scope('OnPrem')]
    procedure CheckGranuleKey(pGranuleKeyCode: Code[20]; pLicenceID: Code[30]; pGranuleID: Code[20]) Return: Integer
    var
        n: Integer;
        d: Integer;
        lMaxiCode: Integer;
        lMinimum: Integer;
        lExpiration: Integer;
        lExpirationDate: Date;
        tInvalidKey: Label 'Invalid key for granule %1';
        lGranuleKey: Integer;
        tOutOfDate: Label 'Your licence StatsExplorer has expired.\Contact the system manager for more information.';
    begin
        lMaxiCode := 16;
        n := 32639;
        d := 23677;
        Evaluate(lGranuleKey, pGranuleKeyCode);

        lGranuleKey := lGranuleKey - lMinimum;
        lExpiration := lGranuleKey div (n * lMaxiCode);
        Return := -1; // en cas d'erreur
        if Decrypter(lGranuleKey mod n, d, n) <> f(pLicenceID, pGranuleID, n) then
            exit
        else
            if lExpiration <> 0 then begin
                lExpirationDate := 20010101D + (lExpiration + 1) * 7;
                if lExpirationDate < Today then
                    Error(tOutOfDate);
            end;

        Return := lGranuleKey div n mod lMaxiCode;
    end;

    [Scope('OnPrem')]
    procedure Decrypter(c: Integer; d: Integer; n: Integer) Return: Integer
    begin
        Return := PowerMod(c, d, n);
    end;

    local procedure f(pLicenceID: Code[30]; pGranuleID: Code[20]; pModulo: Integer) Return: Integer
    var
        i: Integer;
        wStr: Text[50];
    begin
        Return := 0;
        wStr := Reverse(pGranuleID) + Reverse(pLicenceID);

        for i := 1 to StrLen(wStr) do begin
            Return := Return mod pModulo;
            if i mod 2 = 0 then
                Return := Return + ((wStr[i] - 32) mod 64) * 2
            else
                Return := Return * 2 + ((wStr[i] - 32) mod 64);
        end;
        Return := (Return * 13) mod pModulo;
    end;

    [Scope('OnPrem')]
    procedure PowerMod(a: Integer; b: Integer; c: Integer) Return: Integer
    var
        i: Integer;
    begin
        //Return := a^b mod c
        if c = 0 then
            exit(0);
        Return := 1;
        for i := 1 to b do
            Return := (Return * a) mod c;
    end;

    [Scope('OnPrem')]
    procedure Reverse(Text: Text[30]) Return: Text[30]
    var
        i: Integer;
        l: Integer;
    begin
        Return := Text;
        l := StrLen(Text);
        for i := 1 to StrLen(Text) do
            Return[i] := Text[l - i + 1];
    end;

    [Scope('OnPrem')]
    procedure CalcTotalLines(Cle: Integer)
    begin
        Stats2.Reset;
        Stats2.SetRange("User ID", User);
        Stats2.SetRange("Statistic code", CodePredefini);
        Stats2.SetRange("Key 1", Statistiques."Key 1");
        if (Cle >= 2) and (CleTri[2] <> '') then
            Stats2.SetRange("Key 2", Statistiques."Key 2");
        if (Cle >= 3) and (CleTri[3] <> '') then
            Stats2.SetRange("Key 3", Statistiques."Key 3");
        if (Cle >= 4) and (CleTri[4] <> '') then
            Stats2.SetRange("Key 4", Statistiques."Key 4");
        if (Cle >= 5) and (CleTri[5] <> '') then
            Stats2.SetRange("Key 5", Statistiques."Key 5");
        if (Cle >= 6) and (CleTri[6] <> '') then
            Stats2.SetRange("Key 6", Statistiques."Key 6");
        if (Cle >= 7) and (CleTri[7] <> '') then
            Stats2.SetRange("Key 7", Statistiques."Key 7");
        if (Cle >= 8) and (CleTri[8] <> '') then
            Stats2.SetRange("Key 8", Statistiques."Key 8");
        if (Cle >= 9) and (CleTri[9] <> '') then
            Stats2.SetRange("Key 9", Statistiques."Key 9");
        if (Cle >= 10) and (CleTri[10] <> '') then
            Stats2.SetRange("Key 10", Statistiques."Key 10");

        if Stats2.FindFirst then;
        TotalTri[Cle] := Stats2.Count;
    end;

    [Scope('OnPrem')]
    procedure GroupFooter(Level: Integer)
    begin
        i := 0;
        repeat
            i := i + 1;
            Col_Resultat[i] := Col_Resultat_Sum[i, Level];
            Col_Resultat_Sum[i, Level] := 0;
        until i = NombreColonnes;

        CalculerTotaux;
        ArrondirMontants;
        if NonNul then begin
            i := n;
            repeat
                i := i + 1;
                TableauCles[i] := '';
            until i = 10;
            EcrireResultats(Level + 1, Valeur[Level], LibelleRupture[Level], CleTri[Level]);
        end;
    end;
}

