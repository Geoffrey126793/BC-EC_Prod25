report 8001309 "Copy column style"
{
    // //STATSEXPLORER STATSEXPLORER 20/01/00 Copie de stat prédéfinie

    Caption = 'Copy column style';
    Permissions =;
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {
        Caption = 'Copy column style';
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
                            AncienCode := '';
                        end;
                    }
                    field(AncienCode; AncienCode)
                    {
                        Caption = 'Old code';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            NomColonne.ChangeCompany(SocieteOrigine);
                            NomColonne.Reset;

                            if (AncienCode <> '') and (NomColonne.Get(AncienCode)) then;
                            if PAGE.RunModal(PAGE::"Statistic column's name", NomColonne) = ACTION::LookupOK then begin
                                AncienCode := NomColonne.Code;
                                NomColonne.ChangeCompany(SocieteDestination);
                            end;

                            if SocieteOrigine <> SocieteDestination then
                                NouveauCode := AncienCode
                            else
                                NouveauCode := '';
                        end;

                        trigger OnValidate()
                        begin
                            NomColonne.ChangeCompany(SocieteOrigine);

                            if not NomColonne.Get(AncienCode) then begin
                                NomColonne.SetFilter(Code, '%1', AncienCode + '*');
                                if NomColonne.Find('-') then
                                    AncienCode := NomColonne.Code
                                else
                                    Error(Error4, AncienCode);
                            end;

                            if SocieteOrigine <> SocieteDestination then
                                NouveauCode := AncienCode
                            else
                                NouveauCode := '';
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
                                NouveauCode := AncienCode
                            else
                                NouveauCode := '';
                        end;
                    }
                    field(NouveauCode; NouveauCode)
                    {
                        Caption = 'New code';

                        trigger OnValidate()
                        begin
                            if (SocieteOrigine = SocieteDestination) and (AncienCode = NouveauCode) then
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
        if (SocieteOrigine = SocieteDestination) and (AncienCode = NouveauCode) then
            Error(Error1);

        NomColonne.ChangeCompany(SocieteOrigine);
        NomColonne2.ChangeCompany(SocieteDestination);
        Colonne.ChangeCompany(SocieteOrigine);
        Colonne2.ChangeCompany(SocieteDestination);
        FiltreColonne.ChangeCompany(SocieteOrigine);
        FiltreColonne2.ChangeCompany(SocieteDestination);

        if NomColonne2.Get(NouveauCode) then
            if not Confirm(Confirm1, false, NouveauCode) then
                CurrReport.Quit
            else begin
                Colonne2.SetRange(Code, NomColonne2.Code);
                if not Colonne2.IsEmpty then
                    if Colonne2.FindFirst then
                        Colonne2.DeleteAll;
                FiltreColonne2.SetRange(Code, NomColonne2.Code);
                if not FiltreColonne2.IsEmpty then
                    if FiltreColonne2.FindFirst then
                        FiltreColonne2.DeleteAll;
                NomColonne2.Delete(false);
            end;

        if not NomColonne.Get(AncienCode) then
            Error(Error2, AncienCode, SocieteOrigine);

        NomColonne2 := NomColonne;
        NomColonne2.Code := NouveauCode;
        NomColonne2.Insert;

        Colonne.SetRange(Code, AncienCode);
        if not Colonne.IsEmpty then begin
            Colonne.FindFirst;
            repeat
                Colonne2 := Colonne;
                Colonne2.Code := NouveauCode;
                Colonne2.Insert;
            until Colonne.Next = 0;
        end;

        FiltreColonne.SetRange(Code, AncienCode);
        if not FiltreColonne.IsEmpty then begin
            FiltreColonne.FindFirst;
            repeat
                FiltreColonne2 := FiltreColonne;
                FiltreColonne2.Code := NouveauCode;
                FiltreColonne2.Insert;
            until FiltreColonne.Next = 0;
        end;
    end;

    var
        NomColonne: Record "Column style name";
        NomColonne2: Record "Column style name";
        Colonne: Record "Statistic column";
        Colonne2: Record "Statistic column";
        FiltreColonne: Record "Statistic column filter";
        FiltreColonne2: Record "Statistic column filter";
        Societe: Record Company;
        SocieteOrigine: Text[30];
        SocieteDestination: Text[30];
        AncienCode: Code[10];
        NouveauCode: Code[10];
        Error1: Label 'Source and target code can''t be the same';
        Error2: Label '%1 code not defined for %2 company';
        Error4: Label '%1 code not defined';
        Error5: Label 'Source and target code can''t be the same';
        Confirm1: Label '%1 code is already defined. Do you want to replace it ?';
}

