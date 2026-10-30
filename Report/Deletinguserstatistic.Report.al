report 8001312 "Deleting user statistic"
{
    // //RTC RequestPage
    // //STATSEXPLORER STATSEXPLORER 01/08/00 Purge des statistiques pour tout ou partie des utilisateurs

    Caption = 'Deleting user statistic';
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {
        Caption = 'Deleting user statistic';

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(Choix1; TypePurge)
                    {
                        Caption = 'Delete ...';

                        trigger OnValidate()
                        begin

                            TypePurgeOnValidate;

                        end;
                    }
                    field(Texte1; Texte1)
                    {
                        Editable = false;
                        ShowCaption = false;
                    }
                    field(Texte2; Texte2)
                    {
                        Editable = false;
                        ShowCaption = false;
                    }
                    field(Texte3; Texte3)
                    {
                        Editable = false;
                        ShowCaption = false;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            Choix3Visible := true;
            Choix2Visible := true;
        end;

        trigger OnOpenPage()
        begin
            TypePurge := 2;
            Texte1 := StrSubstNo(MLTexte1, UserId);
            Texte2 := StrSubstNo(MLTexte2, CodeStatistique);
            Texte3 := MLTexte3;

            if CodeStatistique = '' then begin
                Choix2Visible := false;
                Texte2 := '';
                TypePurge := 1;
            end;

            // IF (NOT MembreSecurite.WRITEPERMISSION) AND (STRPOS(COMPANYNAME,'CRONUS') <> 1)  THEN BEGIN
            //    Choix3Visible := FALSE;
            //    Texte3 := '';
            // END;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        case TypePurge of
            1:
                PurgeStat(UserId, '');
            2:
                PurgeStat(UserId, CodeStatistique);
            3:
                PurgeStat('', '');
        end;
    end;

    var
        TypePurge: Integer;
        Texte1: Text[80];
        Texte2: Text[80];
        Texte3: Text[80];
        MLTexte1: Label 'The statistics of the user %1';
        MLTexte2: Label '%1 statistic';
        MLTexte3: Label 'All Statistics';
        CodeStatistique: Code[10];

        Choix2Visible: Boolean;

        Choix3Visible: Boolean;
        Text666: Label '%1 is not a valid selection.';

    [Scope('OnPrem')]
    procedure InitRequete(InitCodeStatistique: Code[10])
    begin
        CodeStatistique := InitCodeStatistique;
    end;

    [Scope('OnPrem')]
    procedure PurgeStat(FiltreUserid: Code[20]; FiltreCodeStatistique: Code[10])
    var
        LignesStatistiquesTemp: Record "Statistic array line";
        ColonnesStatistiquesTemp: Record "Statistic array column";
        ResultatsStatistiquesTemp: Record "Statistic cell";
        DefinitionStatistiquesTemp: Record "Statistic definition";
        Fenetre: Dialog;
        Purge1: Label 'Delete statistics user ...';
    begin
        Fenetre.Open(Purge1);
        with LignesStatistiquesTemp do begin
            LockTable;
            if FiltreUserid <> '' then
                SetRange("User ID", FiltreUserid)
            else
                SetRange("User ID");
            if FiltreCodeStatistique <> '' then
                SetRange("Statistic code", FiltreCodeStatistique)
            else
                SetRange("Statistic code");
            DeleteAll;
        end;

        with ColonnesStatistiquesTemp do begin
            LockTable;
            if FiltreUserid <> '' then
                SetRange("User ID", FiltreUserid)
            else
                SetRange("User ID");
            if FiltreCodeStatistique <> '' then
                SetRange("Statistic code", FiltreCodeStatistique)
            else
                SetRange("Statistic code");
            DeleteAll;
        end;

        with ResultatsStatistiquesTemp do begin
            LockTable;
            if FiltreUserid <> '' then
                SetRange("User ID", FiltreUserid)
            else
                SetRange("User ID");
            if FiltreCodeStatistique <> '' then
                SetRange("Statistic code", FiltreCodeStatistique)
            else
                SetRange("Statistic code");
            DeleteAll;
        end;

        with DefinitionStatistiquesTemp do begin
            LockTable;
            if FiltreUserid <> '' then
                SetRange("User ID", FiltreUserid)
            else
                SetRange("User ID");
            if FiltreCodeStatistique <> '' then
                SetRange("Statistic code", FiltreCodeStatistique)
            else
                SetRange("Statistic code");
            DeleteAll;
        end;
        Fenetre.Close;
    end;

    local procedure TypePurgeOnValidate()
    begin
        if not (Choix2Visible) and (TypePurge = 2) then
            Error(Text666, TypePurge);
        if not (Choix3Visible) and (TypePurge = 3) then
            Error(Text666, TypePurge);
    end;
}

