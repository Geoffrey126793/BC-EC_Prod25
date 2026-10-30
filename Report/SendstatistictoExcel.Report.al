report 8001307 "Send statistic to Excel"
{
    // //RTC RequestPage
    // //STATSEXPLORER STATSEXPLORER 20/01/00 Envoi des données dans excel

    Caption = 'Send statistic to Excel';
    ProcessingOnly = true;
    TransactionType = UpdateNoLocks;

    dataset
    {
        dataitem(Statistiques; "Statistic array line")
        {
            DataItemTableView = SORTING("User ID", "Statistic code", "Break 1", "Break 2", "Break 3", "Break 4", "Break 5", "Break 6", "Break 7", "Break 8", "Break 9", "Line No.");

            trigger OnAfterGetRecord()
            begin
                CptrLig := CptrLig + 1;

                //#6572
                if GuiAllowed then
                    //#6572//
                    Fenetre.Update(1, Round(CptrLig / NbreEnreg * 10000, 1));

                if "Section level" <> 1 then begin

                    //TODO
                    xlBuf.Init;
                    xlBuf.Validate("Row No.", CptrLig);
                    xlBuf.Validate("Column No.", 1);
                    xlBuf."Cell Value as Text" := CopyStr(TexteBlanc, 1, ("Section level" - 2) * 5) + Code;
                    xlBuf.Insert;
                    xlBuf.Init;
                    xlBuf.Validate("Row No.", CptrLig);
                    xlBuf.Validate("Column No.", 2);
                    xlBuf."Cell Value as Text" := CopyStr(TexteBlanc, 1, ("Section level" - 2) * 5) + Description;
                    xlBuf.Insert;

                    GestionCouleur;
                    CreerTableauResultats;
                end;

                if "Section level" < NiveauMaxi then begin
                    TexteImprime["Section level"] := CopyStr(TexteBlanc, 1, "Section level" * 5) + TexteTotal + ' ' + Code + ' ' + Description;
                end;
            end;

            trigger OnPostDataItem()
            begin
                // Total général
                Statistiques.SetRange("Section level", 1);
                if not Statistiques.IsEmpty then
                    if Statistiques.FindFirst then begin
                        CptrLig := CptrLig + 2;

                        xlBuf.Init;
                        xlBuf.Validate("Row No.", CptrLig);
                        xlBuf.Validate("Column No.", 2);
                        xlBuf."Cell Value as Text" := Description;
                        if xlBuf.Insert then;


                        CreerTableauResultats;
                        GestionDecimales;
                    end;
            end;

            trigger OnPreDataItem()
            begin

                //#6572
                if GuiAllowed then
                    //#6572//
                    Fenetre.Open(Fenetre2);

                SetRange("User ID", User);
                SetRange("Statistic code", CodeStatistique);
                SetRange("Section level", 1, NiveauMaxi);

                NbreEnreg := Count;

                TexteBlanc := '                                                                                                       ';
                TexteLettres := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
                CodeCellule := 'B';
                CptrLig := 3;
                CreerTableauColonnes;

                // Dates ou non dans le titre
                if SecondCodeCellule <> '' then
                    CptrLig := CptrLig + 3
                else
                    CptrLig := CptrLig + 1;
            end;
        }
    }

    requestpage
    {
        Caption = 'Send statistic to Excel';

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(CodeStatistique; CodeStatistique)
                    {
                        Caption = 'Statistic code';

                        trigger OnLookup(var Text: Text): Boolean
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

                        trigger OnValidate()
                        begin
                            if not DefinitionTemp.Get(User, CodeStatistique, 10000) then
                                Message(Error4);

                            DefinitionTemp.SetRange("User ID", User);
                            DefinitionTemp.SetRange("Statistic code", CodeStatistique);
                            DefinitionTemp.SetFilter("Line No.", '<=%1', 10);

                            if DefinitionTemp.Find('-') then begin
                                TexteNiveauEdition := DefinitionTemp.Description;
                                NiveauMaxi := DefinitionTemp."Line No." + 1;
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
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            ControlSheet2Enable := true;
            ControlSheet2Visible := true;
            ControlSheetEnable := true;
        end;

        trigger OnOpenPage()
        begin
            ParametresStatistiques.Get;
            DefinitionTemp.SetRange("User ID", User);
            DefinitionTemp.SetRange("Statistic code", CodeStatistique);
            DefinitionTemp.SetFilter("Line No.", '<%1', 10000);

            if DefinitionTemp.Find('-') then begin
                TexteNiveauEdition := DefinitionTemp.Description;
                NiveauMaxi := DefinitionTemp."Line No." + 1;
            end;

            if DefinitionTemp.Get(User, CodeStatistique, 9000) then begin
                NomModeleExcel := DefinitionTemp.Description;
                if DefinitionTemp.Get(User, CodeStatistique, 9010) then
                    NomFeuilleExcel := DefinitionTemp.Description;
                NouvelleFeuille := NouvelleFeuille::Append;
            end else begin
                NomModeleExcel := '';
                NouvelleFeuille := NouvelleFeuille::New;
            end;
            if NomFeuilleExcel = '' then
                if NouvelleFeuille = NouvelleFeuille::New then begin
                    NomFeuilleExcel := '1';
                    ControlSheetEnable := false;
                end else
                    NomFeuilleExcel := ParametresStatistiques."Default Excel sheet";

            ImprimerDefinition := false;
            ControlSheet2Visible := false;
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    var
        Ligne: Text[30];
    begin

        xlBuf.CreateBook(FileMgt.ServerTempFileName('xlsx'), 'test');
        //xlBuf.CreateBook('\\srvnavision\NavisionTemp\000.xlsx','test');
        xlBuf.WriteSheet('rr', '', '');
        xlBuf.CloseBook();
        xlBuf.DownloadAndOpenExcel();

        //  xlBuf.CreateCSV('test','',COMPANYNAME,USERID);
        //xlBuf.GiveUserControl();
    end;

    trigger OnPreReport()
    var
        TexteCode2: Text[30];
        TexteDesignation2: Text[30];
    begin
        //#6572

        if GuiAllowed then
            //#6572//
            Fenetre.Open(Fenetre1);
        ParametresStatistiques.Get;

        Statistiques.SetRange("User ID", User);
        Statistiques.SetRange("Statistic code", CodeStatistique);
        ColonnesStatistiquesTemp.SetRange("User ID", User);
        ColonnesStatistiquesTemp.SetRange("Statistic code", CodeStatistique);
        CellulesStatistiquesTemp.SetRange("User ID", User);
        CellulesStatistiquesTemp.SetRange("Statistic code", CodeStatistique);

        DefinitionTemp.Reset;
        DefinitionTemp.SetRange("User ID", User);
        DefinitionTemp.SetRange("Statistic code", CodeStatistique);
        DefinitionTemp.SetFilter("Line No.", '>=%1', 10000);
        DefinitionTemp.SetFilter(Description, '<>%1', '');

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
            Titre[1] := TexteStatistique;

        DefinitionTemp.Reset;
        DefinitionTemp.SetRange("User ID", User);
        DefinitionTemp.SetRange("Statistic code", CodeStatistique);
        DefinitionTemp.SetFilter("Line No.", '%1..%2', 100, 200);
        DefinitionTemp.SetFilter(Description, '<>%1', '');
        i := 0;
        if not DefinitionTemp.IsEmpty then begin
            DefinitionTemp.FindFirst;
            repeat
                i := i + 1;
                if not DefinitionTemp.Find('>') then begin
                    NiveauLePlusFin := i;
                    i := 10;
                end;
            until i = 10;
        end;
    end;

    var
        ParametresStatistiques: Record "Statistics setup";
        ColonnesStatistiquesTemp: Record "Statistic array column";
        CellulesStatistiquesTemp: Record "Statistic cell";
        ColonnesStatistiques: Record "Statistic column";
        DefinitionTemp: Record "Statistic definition";
        xStatistiques: Record "Statistic array line";
        User: Code[50];
        CodeStatistique: Code[10];
        FileName: Text[250];
        Cellule: array[260] of Text[30];
        LettresColonnes: Text[10];
        TexteLettres: Text[26];
        CodeCellule: Text[10];
        SecondCodeCellule: Text[10];
        NombreColonnesImprimees: Integer;
        Titre: array[10] of Text[250];
        Fenetre: Dialog;
        NbreEnreg: Integer;
        NiveauLePlusFin: Integer;
        NiveauMaxi: Integer;
        Niveau: Integer;
        NouvellePage: array[10] of Boolean;
        NiveauEdition: Integer;
        TexteNiveauEdition: Text[250];
        CptrLig: Integer;
        i: Integer;
        j: Integer;
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
        Col_CodeCelluleExcel: array[250] of Text[10];
        Col_NumeroColonneImprime: array[250] of Integer;
        TexteBlanc: Text[250];
        TexteImprime: array[10] of Text[250];
        Col_TotalCommeTexte: array[10, 250] of Text[30];
        ImprimerLigneBlanche: Boolean;
        ImprimerSuiteTotaux: Boolean;
        ImprimerDefinition: Boolean;
        NouvelleFeuille: Option New,Append;
        NomModeleExcel: Text[250];
        Error1: Label 'This array has more than 250 columns\You have to reduce this number';
        Error2: Label 'Disable New Line in some columns';
        Error3: Label 'Incorrect level. Select one of the list';
        Error4: Label 'Statistic %1 was not calculated';
        Fenetre1: Label 'Processing...';
        Fenetre2: Label 'Processing @1@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
        TexteCode: Label 'Code';
        TexteDesignation: Label 'Description';
        TexteStatistique: Label 'Statistic';
        NomFeuilleExcel: Text[30];
        TexteTotal: Label 'Total';
        FeuilleExcel: Label 'Excel sheet required';
        NomFeuilleExcel2: Text[30];
        Text000: Label 'Excel not found.';
        Text002: Label 'Excel Sheet %1 not found.';
        Text003: Label 'The file %1 does not exist.';
        XlSave: Boolean;
        XlClose: Boolean;
        ControlSheetEnable: Boolean;
        ControlSheet2Visible: Boolean;
        ControlSheet2Enable: Boolean;
        wXlArchive: Boolean;
        wArchivePath: Text[250];
        tErrArchivePathMissing: Label 'The Archive process, need a path for theses files';
        QuickExport: Boolean;
        xlBuf: Record "Excel Buffer" temporary;
        FileMgt: Codeunit "File Management";

    [Scope('OnPrem')]
    procedure InitRequete(InitCodeStatistique: Code[20]; InitNiveauMaxi: Integer; Utilisateur: Code[50])
    begin
        CodeStatistique := InitCodeStatistique;
        NiveauMaxi := InitNiveauMaxi;
        User := UserId;
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
                Col_Titre1[j] := "Column description";
                Col_UniteAffichage[j] := "Rounding Factor";
                CodeCellule := CalculerLettreSuivante(CptrLig);

                xlBuf.Init;
                xlBuf.Validate("Row No.", CptrLig);
                xlBuf.Validate("Column No.", j + 2);
                xlBuf."Cell Value as Text" := "Column description";
                if xlBuf.Insert then;


                if "Starting Date" <> 0D then begin
                    SecondCodeCellule := DelChr(StrSubstNo('%1 %2', LettresColonnes, CptrLig + 1), '=', ' ');
                    xlBuf.Init;
                    xlBuf.Validate("Row No.", CptrLig + 1);
                    xlBuf.Validate("Column No.", j + 2);
                    xlBuf."Cell Value as Text" := Format("Starting Date");
                    if xlBuf.Insert then;

                    Col_DateDebutTitre[j] := "Starting Date";
                end;

                if "Ending Date" <> 0D then begin
                    SecondCodeCellule := DelChr(StrSubstNo('%1 %2', LettresColonnes, CptrLig + 2), '=', ' ');
                    xlBuf.Init;
                    xlBuf.Validate("Row No.", CptrLig + 2);
                    xlBuf.Validate("Column No.", j + 2);
                    xlBuf."Cell Value as Text" := Format("Ending Date");
                    if xlBuf.Insert then;

                    Col_DateFinTitre[j] := "Ending Date";
                end;

                Col_CodeCelluleExcel[i] := LettresColonnes;

                Col_NumeroColonneImprime[i] := j;

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
            if not IsEmpty then begin
                FindFirst;
                Clear(Col_TotalCommeTexte[Statistiques."Section level"]);
                repeat
                    Col_ResultatCommeTexte[Col_NumeroColonneImprime["Column No."]] := "Printed result";
                    Col_TotalCommeTexte[Statistiques."Section level", Col_NumeroColonneImprime["Column No."]] := "Printed result";
                    xlBuf.Init;
                    xlBuf.Validate("Row No.", CptrLig);
                    xlBuf.Validate("Column No.", Col_NumeroColonneImprime["Column No."] + 2);
                    xlBuf.Validate(xlColID, Col_CodeCelluleExcel[Col_NumeroColonneImprime["Column No."]]);
                    xlBuf."Cell Value as Text" := "Printed result";
                    if xlBuf.Insert then;
                until Next = 0;
            end;
        end;
    end;

    [Scope('OnPrem')]
    procedure CalculerLettreSuivante(Valeur: Integer) ResultatCellule: Text[10]
    begin
        if (CopyStr(CodeCellule, 2, 1) < 'A') or (CopyStr(CodeCellule, 2, 1) > 'Z') then begin
            if CopyStr(CodeCellule, 1, 1) <> 'Z' then
                CodeCellule := CopyStr(TexteLettres, StrPos(TexteLettres, CopyStr(CodeCellule, 1, 1)) + 1, 1)
            else
                CodeCellule := 'AA';
        end else
            if CopyStr(CodeCellule, 2, 1) <> 'Z' then
                CodeCellule := CopyStr(CodeCellule, 1, 1) + CopyStr(TexteLettres, (StrPos(TexteLettres, CopyStr(CodeCellule, 2, 1))) + 1, 1)
            else
                CodeCellule := CopyStr(TexteLettres, StrPos(TexteLettres, CopyStr(CodeCellule, 1, 1)) + 1, 1) + 'A';
        LettresColonnes := CodeCellule;
        exit(DelChr(StrSubstNo('%1 %2', CodeCellule, Valeur), '=', ' '));
    end;

    [Scope('OnPrem')]
    procedure GestionCouleur()
    var
        LigneCouleur: Text[30];
        Couleur: Integer;
    begin
        Couleur := 0;
        case Statistiques."Section level" of
            2:
                Couleur := 5;
            3:
                Couleur := 10;
            4:
                Couleur := 7;
        end;
        if not QuickExport then begin
            if Couleur <> 0 then begin
                LigneCouleur := DelChr(StrSubstNo('A %1.. %2 %1', CptrLig, Col_CodeCelluleExcel[NombreColonnesImprimees]), '=', ' ');
                //   xlApp.Range(LigneCouleur).Font.ColorIndex := Couleur;
            end;
        end;
    end;

    [Scope('OnPrem')]
    procedure GestionDecimales()
    var
        ParamCompta: Record "General Ledger Setup";
        Plage: Text[30];
        FormatNombres: Text[30];
        Separator: Text[1];
    begin
        i := 0;

        ParamCompta.Get;


        if StrPos(Format(ParamCompta."Amount Rounding Precision"), ',') > 0 then
            Separator := ','
        else
            Separator := '.';
        case CopyStr(ParamCompta."Amount Decimal Places", 1, 1) of
            '0':
                FormatNombres := '# ##0';
            '1':
                FormatNombres := '# ##0' + Separator + '0';
            '2':
                FormatNombres := '# ##0' + Separator + '00';
            '3':
                FormatNombres := '# ##0' + Separator + '000';
            '4':
                FormatNombres := '# ##0' + Separator + '0000';
            '5':
                FormatNombres := '# ##0' + Separator + '00000';
        end;

        if not QuickExport then begin
            repeat
                i := i + 1;
                if SecondCodeCellule <> '' then
                    Plage := DelChr(StrSubstNo('%1 6 .. %1 %2', Col_CodeCelluleExcel[i], CptrLig), '=', ' ')
                else
                    Plage := DelChr(StrSubstNo('%1 4 .. %1 %2', Col_CodeCelluleExcel[i], CptrLig), '=', ' ');


            until i = NombreColonnesImprimees;
        end;
    end;

    [Scope('OnPrem')]
    procedure SelectSheetsName(FileName: Text[250]): Text[250]
    var
        i: Integer;
        SheetName: Text[250];
        EndOfLoop: Integer;
        SheetsList: Text[250];
        OptionNo: Integer;
    begin
    end;

    [Scope('OnPrem')]
    procedure ControlSheetName(SheetNameToBeVerified: Text[30]) SheetGood: Boolean
    var
        EndOfLoop: Integer;
        SheetName: Text[250];
    begin
    end;

    [Scope('OnPrem')]
    procedure fArchiveExcelFile()
    var
        lFilename: Text[250];
        lExtension: Text[50];
    begin
        //#8489
        /* lFileMgt = CU 80014..
        IF (wXlArchive) THEN BEGIN
          IF (wArchivePath <> '') THEN BEGIN
            // GO GO On peut archiver
            lFileMgt.fInitialise();
            lFileMgt.fSetFullFileName(NomModeleExcel);
            lExtension := lFileMgt.fGetExtension(NomModeleExcel);
            lFilename := lFileMgt.fGetFileName();
            IF (lExtension <> '') THEN BEGIN
              lFilename := COPYSTR(lFilename, 1, STRPOS(lFilename, lExtension) - 1);
            END;
            lFilename := lFilename + FORMAT(TODAY, 0,'<Year><Month><Day>') + FORMAT(TIME, 0, '<HOUR><MINUTE>')  + lExtension;
            lFileMgt.fCopyFile(wArchivePath + lFilename, TRUE);
            lFileMgt.fFinalize();
          END ELSE BEGIN
            ERROR(tErrArchivePathMissing);
          END;
        END;
        */
        //#8489//

    end;

    [Scope('OnPrem')]
    procedure fValidateArchiveExcelPath(var pPath: Text[1024])
    begin
        //#8489
        if pPath <> '' then begin
            if (pPath[StrLen(pPath)] <> '\') then begin
                pPath += '\';
            end;
        end;
        //#8489//
    end;
}

