report 8001306 "Copy standard statistic"
{
    // //STATSEXPLORER STATSEXPLORER 20/01/00 Copie de stat prédéfinie

    Caption = 'Copy standard statistic';
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {
        Caption = 'Copy standard statistic';
        SaveValues = false;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(SocieteOrigine; SocieteOrigine)
                    {
                        Caption = 'Source company';
                        LookupPageID = Companies;
                        NotBlank = true;
                        TableRelation = Company;

                        trigger OnValidate()
                        begin
                            CodeStatistique := '';
                        end;
                    }
                    field(CodeStatistique; CodeStatistique)
                    {
                        Caption = 'Statistic code';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            StatistiquePredefinie.ChangeCompany(SocieteOrigine);
                            StatistiquePredefinie.Reset;

                            if (CodeStatistique <> '') and (StatistiquePredefinie.Get(CodeStatistique)) then;
                            if PAGE.RunModal(PAGE::"Standard statistics list", StatistiquePredefinie) = ACTION::LookupOK then begin
                                CodeStatistique := StatistiquePredefinie.Code;
                                StatistiquePredefinie.ChangeCompany(SocieteDestination);
                            end;

                            if SocieteOrigine <> SocieteDestination then
                                NouveauCodeStatistique := CodeStatistique
                            else
                                NouveauCodeStatistique := '';
                        end;

                        trigger OnValidate()
                        begin
                            StatistiquePredefinie.ChangeCompany(SocieteOrigine);

                            if not StatistiquePredefinie.Get(CodeStatistique) then begin
                                StatistiquePredefinie.SetFilter(Code, '%1', CodeStatistique + '*');
                                if StatistiquePredefinie.Find('-') then
                                    CodeStatistique := StatistiquePredefinie.Code
                                else
                                    Error(Error4, CodeStatistique);
                            end;

                            if SocieteOrigine <> SocieteDestination then
                                NouveauCodeStatistique := CodeStatistique
                            else
                                NouveauCodeStatistique := '';
                        end;
                    }
                    field(SocieteDestination; SocieteDestination)
                    {
                        Caption = 'Target company';
                        LookupPageID = Companies;
                        NotBlank = true;
                        TableRelation = Company;

                        trigger OnValidate()
                        begin
                            if SocieteOrigine <> SocieteDestination then
                                NouveauCodeStatistique := CodeStatistique
                            else
                                NouveauCodeStatistique := '';
                        end;
                    }
                    field(NouveauCodeStatistique; NouveauCodeStatistique)
                    {
                        Caption = 'New statistic code';

                        trigger OnValidate()
                        begin
                            if (SocieteOrigine = SocieteDestination) and (CodeStatistique = NouveauCodeStatistique) then
                                Error(Error5);
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            SocieteDestination := CompanyName;
            SocieteOrigine := CompanyName;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if (SocieteOrigine = SocieteDestination) and (CodeStatistique = NouveauCodeStatistique) then
            Error(Error1);

        StatistiquePredefinie.ChangeCompany(SocieteOrigine);
        StatistiquePredefinie2.ChangeCompany(SocieteDestination);
        PermissionStatistique.ChangeCompany(SocieteOrigine);
        PermissionStatistique2.ChangeCompany(SocieteDestination);
        NomColonne.ChangeCompany(SocieteOrigine);
        NomColonne2.ChangeCompany(SocieteDestination);
        Colonne.ChangeCompany(SocieteOrigine);
        Colonne2.ChangeCompany(SocieteDestination);
        FiltreColonne.ChangeCompany(SocieteOrigine);
        FiltreColonne2.ChangeCompany(SocieteDestination);
        TriStatistique.ChangeCompany(SocieteOrigine);
        TriStatistique2.ChangeCompany(SocieteDestination);
        SocieteStatistique.ChangeCompany(SocieteOrigine);
        SocieteStatistique2.ChangeCompany(SocieteDestination);

        if StatistiquePredefinie2.Get(NouveauCodeStatistique) then
            if not Confirm(Confirm1, false, NouveauCodeStatistique) then
                CurrReport.Quit
            else begin
                PermissionStatistique2.SetRange(Code, NouveauCodeStatistique);
                if not PermissionStatistique2.IsEmpty then
                    if PermissionStatistique2.FindFirst then
                        PermissionStatistique2.DeleteAll;
                SocieteStatistique2.SetRange("Statistic code", NouveauCodeStatistique);
                if not SocieteStatistique2.IsEmpty then
                    if SocieteStatistique2.FindFirst then
                        SocieteStatistique2.DeleteAll;
                StatistiquePredefinie2.Delete(false);
            end;

        if not StatistiquePredefinie.Get(CodeStatistique) then
            Error(Error2, CodeStatistique, SocieteOrigine);

        StatistiquePredefinie2 := StatistiquePredefinie;
        StatistiquePredefinie2.Code := NouveauCodeStatistique;
        StatistiquePredefinie2.Insert;

        if StatistiquePredefinie2."Sort criteria" <> '' then
            if TriStatistique.Get(0, StatistiquePredefinie."Sort criteria") then begin
                if TriStatistique2.Get(0, StatistiquePredefinie."Sort criteria") then
                    TriStatistique2.Delete;
                TriStatistique2 := TriStatistique;
                TriStatistique2.Insert;
            end else
                Error(Error3, StatistiquePredefinie."Sort criteria", SocieteOrigine);


        PermissionStatistique.SetRange(Code, CodeStatistique);
        if not PermissionStatistique.IsEmpty then begin
            PermissionStatistique.FindFirst;
            repeat
                PermissionStatistique2 := PermissionStatistique;
                PermissionStatistique2.Code := NouveauCodeStatistique;
                PermissionStatistique2.Insert;
            until PermissionStatistique.Next = 0;
        end;

        SocieteStatistique.SetRange("Statistic code", CodeStatistique);
        if not SocieteStatistique.IsEmpty then begin
            SocieteStatistique.FindFirst;
            repeat
                SocieteStatistique2 := SocieteStatistique;
                SocieteStatistique2."Statistic code" := NouveauCodeStatistique;
                SocieteStatistique2.Insert;
            until SocieteStatistique.Next = 0;
        end;

        if (SocieteOrigine <> SocieteDestination) and (not NomColonne2.Get(StatistiquePredefinie2."Column Layout Name")) then begin
            if NomColonne.Get(StatistiquePredefinie2."Column Layout Name") then begin
                NomColonne2 := NomColonne;
                NomColonne2.Insert;
            end;
            Colonne.SetRange(Code, NomColonne2.Code);
            if not Colonne.IsEmpty then begin
                Colonne.FindFirst;
                repeat
                    Colonne2 := Colonne;
                    Colonne2.Code := NomColonne2.Code;
                    Colonne2.Insert;
                until Colonne.Next = 0;
            end;
            FiltreColonne.SetRange(Code, NomColonne2.Code);
            if not FiltreColonne.IsEmpty then begin
                FiltreColonne.FindFirst;
                repeat
                    FiltreColonne2 := FiltreColonne;
                    FiltreColonne2.Code := NomColonne2.Code;
                    FiltreColonne2.Insert;
                until FiltreColonne.Next = 0;
            end;
        end;
    end;

    var
        StatistiquePredefinie: Record "Standard statistic";
        StatistiquePredefinie2: Record "Standard statistic";
        PermissionStatistique: Record "Statistic Permission";
        PermissionStatistique2: Record "Statistic Permission";
        NomColonne: Record "Column style name";
        NomColonne2: Record "Column style name";
        Colonne: Record "Statistic column";
        Colonne2: Record "Statistic column";
        FiltreColonne: Record "Statistic column filter";
        FiltreColonne2: Record "Statistic column filter";
        TriStatistique: Record "Statistic sort criteria";
        TriStatistique2: Record "Statistic sort criteria";
        SocieteStatistique: Record "Statistic Company";
        SocieteStatistique2: Record "Statistic Company";
        Societe: Record Company;
        SocieteOrigine: Text[30];
        SocieteDestination: Text[30];
        CodeStatistique: Code[10];
        NouveauCodeStatistique: Code[10];
        Error1: Label 'Source and target code can''t be the same';
        Error2: Label '%1 statistic code not defined for %2 company';
        Error3: Label '%1 sort criteria not defined for %2 company';
        Error4: Label '%1 statistic code not defined';
        Error5: Label 'Source and target code can''t be the same';
        Confirm1: Label '%1 statistic is already defined. Do you want to replace it ?';
}

