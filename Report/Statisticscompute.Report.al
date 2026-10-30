report 8001305 "Statistics : % compute"
{
    // //STATSEXPLORER STATSEXPLORER 20/01/00 Calcul des tableaux statistiques  : % sous-total et total

    Caption = 'Statistics : % compute';
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem(ColonneTemp; "Statistic array column")
        {
            DataItemTableView = WHERE(Formula = FILTER(<> ''));

            trigger OnAfterGetRecord()
            begin
                if CritereStatistique."Field name" <> "Column type" then
                    CritereStatistique.Get(CritereStatistique.Type::Value, "Column type");
                if (CritereStatistique."Field No." <> 35) and (CritereStatistique."Field No." <> 38) and
                   ((CritereStatistique."Field No." < 70) or (CritereStatistique."Field No." > 79)) then
                    CurrReport.Skip;

                ColonneTemp2.SetRange("User ID", User);
                ColonneTemp2.SetRange("Statistic code", ColonneTemp."Statistic code");
                ColonneTemp2.SetRange("Column No.", ColonneTemp.Formula);
                if not ColonneTemp2.IsEmpty then
                    if ColonneTemp2.FindFirst then begin
                        j := j + 1;
                        Col_Type[j] := CritereStatistique."Field No.";
                        Col_NumeroColonne[j] := "Colonne No. pos.";
                        Col_NumeroColonneBase[j] := ColonneTemp2."Colonne No. pos.";
                        Col_UniteAffichage[j] := "Rounding Factor";
                    end;
            end;

            trigger OnPostDataItem()
            begin
                NombreColonnes := j;
                if NombreColonnes = 0 then
                    CurrReport.Quit;

                j := 0;
                with LigneTempTableauStat do begin
                    SetRange("Section level", 1);
                    if not IsEmpty then begin
                        FindFirst;
                        repeat
                            j := j + 1;
                            if CelluleTemp.Get(User, "Statistic code", "Line No.", Col_NumeroColonneBase[j]) then
                                TotalGeneral[Col_NumeroColonneBase[j]] := CelluleTemp."Computed result";
                        until j = NombreColonnes;
                    end;
                    Reset;
                end;
            end;

            trigger OnPreDataItem()
            begin
                SetRange("User ID", User);
                SetRange("Statistic code", CodeStatistique);
                CritereStatistique.SetRange(Type, CritereStatistique.Type::Value);
            end;
        }
        dataitem("Statistic array line"; "Statistic array line")
        {
            DataItemTableView = SORTING("User ID", "Statistic code", "Section level", "Attached to Line No.", "Sort value", "Line No.");

            trigger OnAfterGetRecord()
            begin
                j := 0;
                NombreBoucles := 0;
                repeat
                    j := j + 1;
                    wResultat := 0;
                    case Col_Type[j] of
                        38:
                            begin
                                if TotalGeneral[Col_NumeroColonneBase[j]] <> 0 then
                                    if CelluleTemp.Get(User, "Statistic code", "Line No.", Col_NumeroColonneBase[j]) then begin
                                        wResultat := Round(CelluleTemp."Computed result" / (TotalGeneral[Col_NumeroColonneBase[j]]) * 100, 0.01);
                                    end;
                            end;
                        35:
                            begin
                                if ("Attached to Line No." <> 0) then begin
                                    if CelluleTemp.Get(User, "Statistic code", "Line No.", Col_NumeroColonneBase[j]) then
                                        wResultat := CelluleTemp."Computed result";
                                    if CelluleTemp2.Get(User, "Statistic code", "Attached to Line No.", Col_NumeroColonneBase[j]) then
                                        if CelluleTemp2."Computed result" <> 0 then
                                            wResultat := Round(wResultat / CelluleTemp2."Computed result" * 100, 0.01)
                                        else
                                            wResultat := 0;
                                end;
                            end;
                        70:
                            if "Lower lines count" <> 0 then
                                with LigneTempTableauStat do begin
                                    SetRange("User ID", User);
                                    SetRange("Statistic code", CodeStatistique);
                                    SetRange("Attached to Line No.", "Statistic array line"."Line No.");
                                    if not IsEmpty then begin
                                        FindFirst;
                                        repeat
                                            SetRange("Column no. filter", Col_NumeroColonneBase[j]);
                                            CalcFields(Result);
                                            wResultat := wResultat + Result;
                                            NombreBoucles := NombreBoucles + 1;
                                        until Next = 0;
                                        wResultat := wResultat / NombreBoucles;
                                    end;
                                end;
                        71:
                            if "Lower lines count" <> 0 then
                                with LigneTempTableauStat do begin
                                    SetRange("User ID", User);
                                    SetRange("Statistic code", CodeStatistique);
                                    SetRange("Attached to Line No.", "Statistic array line"."Line No.");
                                    if not IsEmpty then begin
                                        FindFirst;
                                        repeat
                                            SetRange("Column no. filter", Col_NumeroColonneBase[j]);
                                            CalcFields(Result);
                                            if (wResultat = 0) or (wResultat > Result) then
                                                wResultat := Result;
                                        until Next = 0;
                                    end;
                                end;
                        72:
                            if "Lower lines count" <> 0 then
                                with LigneTempTableauStat do begin
                                    SetRange("User ID", User);
                                    SetRange("Statistic code", CodeStatistique);
                                    SetRange("Attached to Line No.", "Statistic array line"."Line No.");
                                    if not IsEmpty then begin
                                        FindFirst;
                                        repeat
                                            SetRange("Column no. filter", Col_NumeroColonneBase[j]);
                                            CalcFields(Result);
                                            if (wResultat = 0) or (wResultat < Result) then
                                                wResultat := Result;
                                        until Next = 0;
                                    end;
                                end;
                        73:
                            if "Lower lines count" <> 0 then
                                with LigneTempTableauStat do begin
                                    SetRange("User ID", User);
                                    SetRange("Statistic code", CodeStatistique);
                                    SetRange("Attached to Line No.", "Statistic array line"."Line No.");
                                    wResultat := Count;
                                end;
                    end;
                    if wResultat <> 0 then
                        if CelluleTemp.Get(User, "Statistic code", "Line No.", Col_NumeroColonne[j]) then begin
                            CelluleTemp."Computed result" := wResultat;
                            CelluleTemp."Printed result" := FormatterResultatCommeTexte(CelluleTemp."Computed result", Col_UniteAffichage[j]);
                            CelluleTemp.Modify;
                        end else begin
                            CelluleTemp.Init;
                            CelluleTemp."User ID" := User;
                            CelluleTemp."Statistic code" := "Statistic code";
                            CelluleTemp."Line No." := "Line No.";
                            CelluleTemp."Column No." := Col_NumeroColonne[j];
                            CelluleTemp."Computed result" := wResultat;
                            CelluleTemp."Printed result" := FormatterResultatCommeTexte(CelluleTemp."Computed result", Col_UniteAffichage[j]);
                            CelluleTemp.Insert;
                        end;

                until j = NombreColonnes;

                CptrLig := CptrLig + 1;
                Fenetre.Update(2, "Section level");
                if NbreEnreg = 0 then
                    NbreEnreg := 1;
                Fenetre.Update(3, Round(CptrLig / NbreEnreg * 10000, 1));
            end;

            trigger OnPreDataItem()
            begin
                SetRange("User ID", User);
                SetRange("Statistic code", CodeStatistique);
            end;
        }
    }

    requestpage
    {
        Caption = 'Statistics : % compute';

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

    trigger OnPostReport()
    begin
        Fenetre.Close;
    end;

    trigger OnPreReport()
    begin
        with LigneTempTableauStat do begin
            FilterGroup(7);
            SetRange("User ID", User);
            SetRange("Statistic code", CodeStatistique);
            FilterGroup(0);
            NbreEnreg := Count;
            Fenetre.Open(CalculEnCours, CodeStatistique);
            Fenetre.Update(2, 1);
        end;

        if FormatStringNormal = '' then begin
            ParamCompta.Get;
            FormatStringNormal := '<Precision,' + ParamCompta."Amount Decimal Places" + '><Standard Format,0>';
        end;
    end;

    var
        CritereStatistique: Record "Statistic criteria";
        CritereStatistique2: Record "Statistic criteria";
        ColonneTemp2: Record "Statistic array column";
        LigneTempTableauStat: Record "Statistic array line";
        CelluleTemp: Record "Statistic cell";
        CelluleTemp2: Record "Statistic cell";
        ParamCompta: Record "General Ledger Setup";
        User: Code[20];
        CodeStatistique: Code[10];
        Col_NumeroColonne: array[250] of Integer;
        Col_NumeroColonneBase: array[250] of Integer;
        Col_Type: array[250] of Integer;
        Col_UniteAffichage: array[250] of Option Standard,"1","1000","1000000";
        i: Integer;
        j: Integer;
        Fenetre: Dialog;
        NbreEnreg: Integer;
        CptrLig: Integer;
        NumLig: Integer;
        NumColonne: Integer;
        NombreColonnes: Integer;
        NombreBoucles: Integer;
        TotalGeneral: array[250] of Decimal;
        wResultat: Decimal;
        FormatStringNormal: Text[80];
        CalculEnCours: Label 'Calc. % #1######## level #2 @3@@@@@@@@@@@@@@@@';

    [Scope('OnPrem')]
    procedure InitRequete(InitCodeStatistique: Code[10]; NumeroColonne: Integer; Utilisateur: Code[20])
    begin
        CodeStatistique := InitCodeStatistique;
        NumColonne := NumeroColonne;
        if Utilisateur = '' then
            User := UserId
        else
            User := Utilisateur;
    end;

    [Scope('OnPrem')]
    procedure FormatterResultatCommeTexte(Valeur: Decimal; UniteAffichage: Option Standard,"1","1000","1000000") Res: Text[30]
    begin
        if Valeur = 0 then
            Res := ''
        else
            case UniteAffichage of
                UniteAffichage::Standard:
                    Res := Format(Valeur, 0, FormatStringNormal);
                UniteAffichage::"1":
                    Res := Format(Round(Valeur, 1));
                UniteAffichage::"1000":
                    Res := Format(Round(Valeur / 1000, 0.1), 0, '<Precision,1><Standard Format,0>');
                UniteAffichage::"1000000":
                    Res := Format(Round(Valeur / 1000000, 0.1), 0, '<Precision,1><Standard Format,0>');
            end;
    end;
}

