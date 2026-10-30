report 8001302 "Statistic report"
{
    // //STA.REPORT :Edition tableau statistique
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/Statisticreport.rdlc';

    Caption = 'Statistic report';
    UseSystemPrinter = true;

    dataset
    {
        dataitem(Statistiques; "Statistic array line")
        {
            DataItemTableView = SORTING("User ID", "Statistic code", "Break 1", "Break 2", "Break 3", "Break 4", "Break 5", "Break 6", "Break 7", "Break 8", "Break 9", "Line No.");
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(CurrReport_PAGENO; 1)
            {
            }
            column(User; UserId)
            {
            }
            column(Titre_1_; Titre[1])
            {
            }
            column(Titre_2_; Titre[2])
            {
            }
            column(Titre_3_; Titre[3])
            {
            }
            column(Titre_4_; Titre[4])
            {
            }
            column(Statistiques_Code; Code)
            {
            }
            column(Statistiques__Section_name_; "Section name")
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(StatsExplorer_Caption; StatsExplorer_CaptionLbl)
            {
            }
            column(Statistiques_CodeCaption; FieldCaption(Code))
            {
            }
            column(Statistiques__Section_name_Caption; FieldCaption("Section name"))
            {
            }
            column(Statistiques_User_Security_ID; "User ID")
            {
            }
            column(Statistiques_Statistic_code; "Statistic code")
            {
            }
            column(Statistiques_Line_No_; "Line No.")
            {
            }
            column(Statistiques_Break_1; "Break 1")
            {
            }
            column(Statistiques_Break_2; "Break 2")
            {
            }
            column(Statistiques_Break_3; "Break 3")
            {
            }
            column(Statistiques_Break_4; "Break 4")
            {
            }
            column(Statistiques_Break_5; "Break 5")
            {
            }
            column(Statistiques_Break_6; "Break 6")
            {
            }
            column(Statistiques_Break_7; "Break 7")
            {
            }
            column(Statistiques_Break_8; "Break 8")
            {
            }
            column(Statistiques_Break_9; "Break 9")
            {
            }
            column(Statistiques_Break_10; "Break 10")
            {
            }
            column(gSelectedLevel; gSelectedLevel)
            {
            }
            column(ReportNumber; CurrReport.ObjectId)
            {
            }
            column(ImprimerTotalGeneral; ImprimerTotalGeneral)
            {
            }
            column(ImprimerDefinition; ImprimerDefinition)
            {
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number);
                column(Cell_Value; gValue)
                {
                }
                column(Cell_LineNo; Statistiques."Line No.")
                {
                }
                column(Cell_ColNo; Number)
                {
                }
                column(Cell_ColTitle; gStatisticArrayColumn."Column description")
                {
                }
                column(Cell_TexteLigne; TexteLigne)
                {
                }
                column(Cell_LineEntity; gLineEntity)
                {
                }
                column(Cell_SectionLevel; Statistiques."Section level")
                {
                }
                column(Cell_NiveauMaxi; NiveauMaxi)
                {
                }
                column(gTabTextLine_1_; gTabTextLine[1])
                {
                }
                column(gTabTextLine_2_; gTabTextLine[2])
                {
                }
                column(gTabTextLine_3_; gTabTextLine[3])
                {
                }
                column(gTabTextLine_4_; gTabTextLine[4])
                {
                }
                column(gTabTextLine_5_; gTabTextLine[5])
                {
                }
                column(gTabTextLine_6_; gTabTextLine[6])
                {
                }
                column(gTabHidden_1_; gTabHidden[1])
                {
                }
                column(gTabHidden_2_; gTabHidden[2])
                {
                }
                column(gTabHidden_3_; gTabHidden[3])
                {
                }
                column(gTabHidden_4_; gTabHidden[4])
                {
                }
                column(gTabHidden_5_; gTabHidden[5])
                {
                }

                trigger OnAfterGetRecord()
                begin
                    //valeur de la cellule
                    gStatisticCell.SetRange("User ID", Statistiques."User ID");
                    gStatisticCell.SetRange("Statistic code", Statistiques."Statistic code");
                    gStatisticCell.SetRange("Line No.", Statistiques."Line No.");
                    gStatisticCell.SetRange("Column No.", Number);
                    if not gStatisticCell.FindSet() then
                        gStatisticCell.Init;
                    gValue := gStatisticCell."Computed result";

                    //titre de colonne
                    gStatisticArrayColumn.SetRange("Colonne No. pos.", Number);
                    if not gStatisticArrayColumn.FindSet() then
                        gStatisticArrayColumn.Init;

                    //gestion de nouvelle ligne
                    if gStatisticArrayColumn."New line" then
                        gLineEntity += 1;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, gColMax);
                    gLineEntity := 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                gTabTextLine["Section level"] := "Section name" + ' : ' + Code + ' ' + Description;
                if "Section level" < NiveauMaxi then begin
                    CurrReport.Skip;
                end;

                CptrLig := CptrLig + 1;
                CreerTableauResultats;

                if CptrLig <> 1 then
                    TestRupture;
                i := 0;
                repeat
                    i := i + 1;

                until i = 10;
                xStatistiques := Statistiques;

                if "Section level" < NiveauMaxi then begin
                    case ImpressionTotal of
                        1:
                            TexteImprime["Section level"] := TexteTotal + ' ' + Code;
                        2:
                            TexteImprime["Section level"] := TexteTotal + ' ' + Description;
                        3:
                            TexteImprime["Section level"] := Code + ' ' + Description;
                        4:
                            TexteImprime["Section level"] := Code;
                        5:
                            TexteImprime["Section level"] := Description;
                        6:
                            TexteImprime["Section level"] := '';
                        else
                            TexteImprime["Section level"] := TexteTotal + ' ' + Code + ' ' + Description;
                    end;

                end;

                TexteLigne := "Section name" + ' : ' + Code + ' ' + Description;
            end;

            trigger OnPreDataItem()
            var
                lStatisticArrayLineLevel: Record "Statistic array line";
            begin
                NbreEnreg := Count;

                SetRange("User ID", User);
                SetRange("Statistic code", CodeStatistique);
                for i := NiveauMaxi to ArrayLen(gTabHidden) do
                    gTabHidden[i] := true;

                lStatisticArrayLineLevel.SetCurrentKey("User ID", "Statistic code", "Section level", "Attached to Line No.", "Sort value", "Line No.");
                lStatisticArrayLineLevel.SetRange("User ID", User);
                lStatisticArrayLineLevel.SetRange("Statistic code", CodeStatistique);
                if lStatisticArrayLineLevel.Find('+') then
                    NiveauMaxi := lStatisticArrayLineLevel."Section level";
                SetRange("Section level", 1, NiveauMaxi);
                SetFilter(Code, '<>%1', '');
                TexteBlanc := '                                                                                                       ';
            end;
        }
        dataitem("Statistic definition"; "Statistic definition")
        {
            column(Statistic_Def_Description; "Statistic definition".Description)
            {
                IncludeCaption = true;
            }
            column(Statistic_Def_Description_Caption; FieldCaption("Statistic definition".Description))
            {
            }

            trigger OnPreDataItem()
            begin
                if not ImprimerDefinition then
                    CurrReport.Break;
                SetRange("User ID", User);
                SetRange("Statistic code", CodeStatistique);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(CodeStatistique; CodeStatistique)
                {
                    Caption = 'Statistic code';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        lTest: Page "Statistic definition";
                    begin
                        DefinitionTemp.Reset;
                        DefinitionTemp.FilterGroup(7);
                        DefinitionTemp.SetRange("User ID", User);
                        DefinitionTemp.SetRange("Statistic code");
                        DefinitionTemp.SetFilter("Line No.", '10000');
                        DefinitionTemp.FilterGroup(0);
                        if PAGE.RunModal(PAGE::"Statistic definition", DefinitionTemp) = ACTION::LookupOK then
                            CodeStatistique := DefinitionTemp."Statistic code";

                        DefinitionTemp.Reset;
                        DefinitionTemp.SetRange("User ID", User);
                        DefinitionTemp.SetRange("Statistic code", CodeStatistique);
                        DefinitionTemp.SetFilter("Line No.", '<=%1', 10);

                        if DefinitionTemp.Find('-') then begin
                            TexteNiveauEdition := DefinitionTemp.Description;
                            NiveauMaxi := DefinitionTemp."Line No." + 1;
                        end else begin
                            TexteNiveauEdition := '';
                            NiveauMaxi := 0;
                        end;
                    end;
                }
                field(TexteNiveauEdition; TexteNiveauEdition)
                {
                    Caption = 'Detail level';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        DefinitionTemp.Reset;
                        DefinitionTemp.FilterGroup(7);
                        DefinitionTemp.SetRange("User ID", User);
                        DefinitionTemp.SetRange("Statistic code", CodeStatistique);
                        DefinitionTemp.SetFilter("Line No.", '<=%1', 10);
                        DefinitionTemp.FilterGroup(0);
                        if PAGE.RunModal(PAGE::"Statistic definition", DefinitionTemp) = ACTION::LookupOK then begin
                            TexteNiveauEdition := DefinitionTemp.Description;
                            NiveauMaxi := DefinitionTemp."Line No." + 1;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        DefinitionTemp.Reset;
                        DefinitionTemp.FilterGroup(7);
                        DefinitionTemp.SetRange("User ID", User);
                        DefinitionTemp.SetRange("Statistic code", CodeStatistique);
                        DefinitionTemp.SetFilter("Line No.", '<=%1', 10);
                        DefinitionTemp.FilterGroup(0);

                        DefinitionTemp.SetRange(DefinitionTemp.Description, TexteNiveauEdition);
                        if DefinitionTemp.Find('-') then
                            NiveauMaxi := DefinitionTemp."Line No." + 1
                        else
                            Error(Error3);
                    end;
                }
                field(ImprimerDefinition; ImprimerDefinition)
                {
                    Caption = 'Print definition';
                }
                field(ImprimerTotalGeneral; ImprimerTotalGeneral)
                {
                    Caption = 'Print total';
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            //test
            //CodeStatistique := 'NAVIBAT010';
            //NiveauMaxi := 2;
            //test//
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin

        gSelectedLevel := NiveauMaxi;

        Statistiques.SetRange("User ID", User);
        Statistiques.SetRange("Statistic code", CodeStatistique);
        ColonnesStatistiquesTemp.SetRange("User ID", User);
        ColonnesStatistiquesTemp.SetRange("Statistic code", CodeStatistique);
        CellulesStatistiquesTemp.SetRange("User ID", User);
        CellulesStatistiquesTemp.SetRange("Statistic code", CodeStatistique);

        CreerTableauColonnes;

        RechercherSiDateDebutUnique;

        DefinitionTemp.Reset;
        DefinitionTemp.SetRange("User ID", User);
        DefinitionTemp.SetRange("Statistic code", CodeStatistique);
        DefinitionTemp.SetFilter("Line No.", '>=%1', 10000);
        DefinitionTemp.SetFilter(Description, '<>%1', '');

        if DefinitionTemp.Get(User, CodeStatistique, 9050) then
            Evaluate(ImpressionEntete, CopyStr(DefinitionTemp.Description, 1, 1));
        if DefinitionTemp.Get(User, CodeStatistique, 9051) then
            Evaluate(ImpressionLigne, CopyStr(DefinitionTemp.Description, 1, 1));
        if DefinitionTemp.Get(User, CodeStatistique, 9052) then
            Evaluate(ImpressionTotal, CopyStr(DefinitionTemp.Description, 1, 1));

        i := 0;
        if not DefinitionTemp.IsEmpty then begin

            DefinitionTemp.FindFirst;
            repeat
                i := i + 1;
                Titre[i] := DefinitionTemp.Description;
                if not DefinitionTemp.Find('>') then
                    i := 10;
            until i = 10;
        end;

        if Titre[1] = '' then
            Titre[1] := TexteTitre;

        DefinitionTemp.Reset;
        DefinitionTemp.SetRange("User ID", User);
        DefinitionTemp.SetRange("Statistic code", CodeStatistique);
        DefinitionTemp.SetFilter("Line No.", '%1..%2', 100, 200);

        i := 0;
        if not DefinitionTemp.IsEmpty then begin
            DefinitionTemp.FindFirst;
            repeat
                i := i + 1;
                if CopyStr(DefinitionTemp.Description, 1, 1) = '1' then
                    SautDePage[i] := true
                else
                    SautDePage[i] := false;
                Evaluate(SeparateurAvant[i], CopyStr(DefinitionTemp.Description, 3, 1));
                Evaluate(SeparateurApres[i], CopyStr(DefinitionTemp.Description, 5, 1));
                if not DefinitionTemp.Find('>') then begin
                    NiveauLePlusFin := i;
                    i := 10;
                end;
            until i = 10;
        end;

        gStatisticArrayColumn.SetRange("User ID", User);
        gStatisticArrayColumn.SetRange("Statistic code", CodeStatistique);
        gStatisticArrayColumn.FindLast;
        if gStatisticArrayColumn."Statistic code" <> '' then
            gColMax := gStatisticArrayColumn."Colonne No. pos."
        else
            gColMax := gStatisticArrayColumn.Count;
        Integer.SetRange(Number, 1, gColMax);
    end;

    var
        ColonnesStatistiquesTemp: Record "Statistic array column";
        CellulesStatistiquesTemp: Record "Statistic cell";
        ColonnesStatistiques: Record "Statistic column";
        DefinitionTemp: Record "Statistic definition";
        xStatistiques: Record "Statistic array line";
        User: Code[50];
        CodeColonne: Code[10];
        CodeStatistique: Code[10];
        NombreColonnesImprimees: Integer;
        Titre: array[10] of Text[250];
        SautDePage: array[10] of Boolean;
        SeparateurAvant: array[10] of Option Aucun,"Ligne blanche","Trait fin","Trait normal","Trait épais";
        SeparateurApres: array[10] of Option Aucun,"Ligne blanche","Trait fin","Trait normal","Trait épais";
        NiveauEdition: Integer;
        TexteNiveauEdition: Text[250];
        Fenetre: Dialog;
        NbreEnreg: Integer;
        CptrLig: Integer;
        i: Integer;
        j: Integer;
        NiveauLePlusFin: Integer;
        NiveauMaxi: Integer;
        Niveau: Integer;
        NouvellePage: array[10] of Boolean;
        LibelleRupture: array[5] of Text[50];
        Col_NoColonne: array[250] of Code[10];
        Col_NoLigne: array[250] of Integer;
        Col_TypeDeColonne: array[250] of Option "Quantité",Volume,Montant,"Coût","Remise ligne","Remise pied","R.F.A",Commission,Formule,"Cumul 1","Cumul 2","Cumul 3","Cumul 4","Cumul 5","Cumul 6","Cumul 7","Cumul 8","Cumul 9","Cumul 10";
        Col_TypeEcriture: array[250] of Text[30];
        Col_InversionSigne: array[250] of Boolean;
        Col_ImprimerColonne: array[250] of Option Toujours,Jamais,"Si positif","Si négatif";
        Col_UniteAffichage: array[250] of Option Standard,"1","1000","1000000";
        Col_CalculDateDebut: array[250] of Code[10];
        Col_CalculDateFin: array[250] of Code[10];
        Col_Formule: array[250] of Text[80];
        Col_DateDebut: array[250] of Date;
        Col_DateFin: array[250] of Date;
        Col_DateDebutTitre: array[250] of Date;
        Col_DateFinTitre: array[250] of Date;
        Col_Resultat: array[250] of Decimal;
        Col_ResultatCommeTexte: array[250] of Text[30];
        Col_Titre1: array[250] of Text[30];
        Col_TitreLigne: array[250] of Text[30];
        Col_NumeroColonneImprime: array[250] of Integer;
        TexteBlanc: Text[250];
        TexteImprime: array[10] of Text[250];
        Col_TotalCommeTexte: array[10, 250] of Text[30];
        ImprimerLigneBlanche: Boolean;
        ImprimerSuiteTotaux: Boolean;

        ImprimerDefinition: Boolean;
        ImprimerTotalGeneral: Boolean;
        DateUnique: Boolean;
        Error1: Label 'This array has more than 250 columns\You have to reduce this number';
        Error2: Label 'Disable New Line in some columns';
        Error3: Label 'Incorrect level. Select one of the list';
        Error4: Label 'Statistic %1 was not calculated';
        Fenetre1: Label 'Processing...';
        Fenetre2: Label 'Processing @1@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
        TexteDateSituation: Label 'Situation from %1 to %2';
        TexteTitre: Label 'Statistic';
        TexteTotal: Label 'Total';
        ImpressionEntete: Integer;
        ImpressionLigne: Integer;
        ImpressionTotal: Integer;
        TexteLigne: Text[250];
        gStatisticArrayColumn: Record "Statistic array column";
        gColMax: Integer;
        gStatisticCell: Record "Statistic cell";
        gValue: Decimal;
        gColTitle: Text[30];
        gLineEntity: Integer;
        gTabTextLine: array[10] of Text[250];
        gTabHidden: array[10] of Boolean;
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        StatsExplorer_CaptionLbl: Label 'StatsExplorer©';
        gSelectedLevel: Integer;

    [Scope('OnPrem')]
    procedure InitRequete(InitCodeStatistique: Code[10]; InitNiveauMaxi: Integer; InitImprimerDefinition: Boolean; InitImprimerTotal: Boolean; Utilisateur: Code[50])
    begin
        CodeStatistique := InitCodeStatistique;
        NiveauMaxi := InitNiveauMaxi;
        ImprimerDefinition := InitImprimerDefinition;
        ImprimerTotalGeneral := InitImprimerTotal;
        if Utilisateur = '' then
            User := UserId
        else
            User := Utilisateur;
    end;

    [Scope('OnPrem')]
    procedure CreerTableauColonnes()
    begin
        with ColonnesStatistiquesTemp do begin
            if not IsEmpty then
                FindFirst;
            i := 0;
            j := 0;
            repeat
                i := i + 1;
                j := j + 1;
                if "Line title" <> '' then
                    Col_TitreLigne[j] := "Line title"
                else
                    Col_TitreLigne[j] := "Column description";
                Col_Titre1[j] := "Column description";
                if "Starting Date" <> 0D then
                    Col_DateDebutTitre[j] := "Starting Date";
                if "Ending Date" <> 0D then
                    Col_DateFinTitre[j] := "Ending Date";
                Col_NumeroColonneImprime[i] := j;
                if "New line" then begin
                    j := (((j div 13) + 1) * 13);
                    Col_TitreLigne[j] := ColonnesStatistiquesTemp."Line title";
                end;
                if (j > 250) or (i > 250) then
                    Error(Error1 + Error2);
            until ColonnesStatistiquesTemp.Next = 0;
        end;

        NombreColonnesImprimees := Col_NumeroColonneImprime[i];
    end;

    [Scope('OnPrem')]
    procedure CreerTableauResultats()
    begin
        Clear(Col_ResultatCommeTexte);

        with CellulesStatistiquesTemp do begin
            SetRange("Line No.", Statistiques."Line No.");
            if not IsEmpty then
                if FindFirst then begin
                    Clear(Col_TotalCommeTexte[Statistiques."Section level"]);
                    repeat
                        Col_ResultatCommeTexte[Col_NumeroColonneImprime["Column No."]] := "Printed result";
                        Col_TotalCommeTexte[Statistiques."Section level", Col_NumeroColonneImprime["Column No."]] := "Printed result";
                    until Next = 0;
                end;
        end;
    end;

    [Scope('OnPrem')]
    procedure TestRupture()
    begin
        i := 0;
        repeat
            i := i + 1;
            NouvellePage[i] := false;
        until i = 10;

        if (Statistiques."Break 1" <> '') and (Statistiques."Break 1" <> xStatistiques."Break 1") and (SautDePage[1]) then
            NouvellePage[1] := true
        else
            if (Statistiques."Break 2" <> '') and (Statistiques."Break 2" <> xStatistiques."Break 2") and (SautDePage[2]) then
                NouvellePage[2] := true
            else
                if (Statistiques."Break 3" <> '') and (Statistiques."Break 3" <> xStatistiques."Break 3") and (SautDePage[3]) then
                    NouvellePage[3] := true
                else
                    if (Statistiques."Break 4" <> '') and (Statistiques."Break 4" <> xStatistiques."Break 4") and (SautDePage[4]) then
                        NouvellePage[4] := true
                    else
                        if (Statistiques."Break 5" <> '') and (Statistiques."Break 5" <> xStatistiques."Break 5") and (SautDePage[5]) then
                            NouvellePage[5] := true
                        else
                            if (Statistiques."Break 6" <> '') and (Statistiques."Break 6" <> xStatistiques."Break 6") and (SautDePage[6]) then
                                NouvellePage[6] := true
                            else
                                if (Statistiques."Break 7" <> '') and (Statistiques."Break 7" <> xStatistiques."Break 7") and (SautDePage[7]) then
                                    NouvellePage[7] := true
                                else
                                    if (Statistiques."Break 8" <> '') and (Statistiques."Break 8" <> xStatistiques."Break 8") and (SautDePage[8]) then
                                        NouvellePage[8] := true
                                    else
                                        if (Statistiques."Break 9" <> '') and (Statistiques."Break 9" <> xStatistiques."Break 9") and (SautDePage[9]) then
                                            NouvellePage[9] := true
                                        else
                                            if (Statistiques."Break 10" <> '') and (Statistiques."Break 10" <> xStatistiques."Break 10") and (SautDePage[10]) then
                                                NouvellePage[10] := true;
    end;

    [Scope('OnPrem')]
    procedure RechercherSiDateDebutUnique()
    var
        DateDebutUnique: Date;
        DateFinUnique: Date;
    begin
        // On regarde si il y a plusieurs dates début et fin
        // Si oui, on imprime les dates dans chaque colonne
        // Si non, on modifie le titre de la stat

        i := 0;
        DateUnique := true;
        repeat
            i := i + 1;
            if (Col_DateDebutTitre[i] <> 0D) then
                if (DateDebutUnique = 0D) then
                    DateDebutUnique := Col_DateDebutTitre[i]
                else
                    if (DateDebutUnique <> Col_DateDebutTitre[i]) then
                        DateUnique := false;

            if (Col_DateFinTitre[i] <> 0D) then
                if (DateFinUnique = 0D) then
                    DateFinUnique := Col_DateFinTitre[i]
                else
                    if (DateFinUnique <> Col_DateFinTitre[i]) then
                        DateUnique := false;
        until i = NombreColonnesImprimees;

        // Si une seule date, on remet les titres à blanc
        if DateUnique then begin
            i := 0;
            repeat
                i := i + 1;
                Col_DateFinTitre[i] := 0D;
                Col_DateDebutTitre[i] := 0D;
            until i = NombreColonnesImprimees;

            DefinitionTemp.Reset;
            if DefinitionTemp.Get(User, CodeStatistique, 30000) then begin
                DefinitionTemp.Description := StrSubstNo(TexteDateSituation, Format(DateDebutUnique, 0, 4), Format(DateFinUnique, 0, 4));
                DefinitionTemp.Modify;
            end;
        end;
    end;
}

