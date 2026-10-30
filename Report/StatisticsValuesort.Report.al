report 8001304 "Statistics : Value sort"
{
    // //STATSEXPLORER STATSEXPLORER 20/01/00 Tri des résultats de tableaux statistiques par valeur

    Caption = 'Statistics : Value sort';
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem(Ligne2; "Statistic array line")
        {
            DataItemTableView = SORTING("User ID", "Statistic code", "Section level", "Attached to Line No.", "Sort value", "Line No.") ORDER(Descending) WHERE("Section level" = FILTER(2));

            trigger OnAfterGetRecord()
            begin
                Boucle("Statistic code", NbLignesEnregPrecedent, "Attached to Line No.", "Section level");
                "Sort key by value" := NumLig;
                Modify;
                NbLignesEnregPrecedent := "Lower lines count";
            end;

            trigger OnPreDataItem()
            begin
                SetRange("User ID", User);
                SetRange("Statistic code", CodeStatistique);
            end;
        }
        dataitem(Ligne3; "Statistic array line")
        {
            DataItemTableView = SORTING("User ID", "Statistic code", "Section level", "Attached to Line No.", "Sort value", "Line No.") ORDER(Descending) WHERE("Section level" = FILTER(3));

            trigger OnAfterGetRecord()
            begin
                Boucle("Statistic code", NbLignesEnregPrecedent, "Attached to Line No.", "Section level");
                "Sort key by value" := NumLig;
                Modify;
                NbLignesEnregPrecedent := "Lower lines count";
            end;

            trigger OnPreDataItem()
            begin
                SetRange("User ID", User);
                SetRange("Statistic code", CodeStatistique);
            end;
        }
        dataitem(Ligne4; "Statistic array line")
        {
            DataItemTableView = SORTING("User ID", "Statistic code", "Section level", "Attached to Line No.", "Sort value", "Line No.") ORDER(Descending) WHERE("Section level" = FILTER(4));

            trigger OnAfterGetRecord()
            begin
                Boucle("Statistic code", NbLignesEnregPrecedent, "Attached to Line No.", "Section level");
                "Sort key by value" := NumLig;
                Modify;
                NbLignesEnregPrecedent := "Lower lines count";
            end;

            trigger OnPreDataItem()
            begin
                SetRange("User ID", User);
                SetRange("Statistic code", CodeStatistique);
            end;
        }
        dataitem(Ligne5; "Statistic array line")
        {
            DataItemTableView = SORTING("User ID", "Statistic code", "Section level", "Attached to Line No.", "Sort value", "Line No.") ORDER(Descending) WHERE("Section level" = FILTER(5));

            trigger OnAfterGetRecord()
            begin
                Boucle("Statistic code", NbLignesEnregPrecedent, "Attached to Line No.", "Section level");
                "Sort key by value" := NumLig;
                Modify;
                NbLignesEnregPrecedent := "Lower lines count";
            end;

            trigger OnPreDataItem()
            begin
                SetRange("User ID", User);
                SetRange("Statistic code", CodeStatistique);
            end;
        }
        dataitem(Ligne6; "Statistic array line")
        {
            DataItemTableView = SORTING("User ID", "Statistic code", "Section level", "Attached to Line No.", "Sort value", "Line No.") ORDER(Descending) WHERE("Section level" = FILTER(6));

            trigger OnAfterGetRecord()
            begin
                Boucle("Statistic code", NbLignesEnregPrecedent, "Attached to Line No.", "Section level");
                "Sort key by value" := NumLig;
                Modify;
                NbLignesEnregPrecedent := "Lower lines count";
            end;

            trigger OnPreDataItem()
            begin
                SetRange("User ID", User);
                SetRange("Statistic code", CodeStatistique);
            end;
        }
        dataitem(Ligne7; "Statistic array line")
        {
            DataItemTableView = SORTING("User ID", "Statistic code", "Section level", "Attached to Line No.", "Sort value", "Line No.") ORDER(Descending) WHERE("Section level" = FILTER(7));

            trigger OnAfterGetRecord()
            begin
                Boucle("Statistic code", NbLignesEnregPrecedent, "Attached to Line No.", "Section level");
                "Sort key by value" := NumLig;
                Modify;
                NbLignesEnregPrecedent := "Lower lines count";
            end;

            trigger OnPreDataItem()
            begin
                SetRange("User ID", User);
                SetRange("Statistic code", CodeStatistique);
            end;
        }
        dataitem(Ligne8; "Statistic array line")
        {
            DataItemTableView = SORTING("User ID", "Statistic code", "Section level", "Attached to Line No.", "Sort value", "Line No.") ORDER(Descending) WHERE("Section level" = FILTER(8));

            trigger OnAfterGetRecord()
            begin
                Boucle("Statistic code", NbLignesEnregPrecedent, "Attached to Line No.", "Section level");
                "Sort key by value" := NumLig;
                Modify;
                NbLignesEnregPrecedent := "Lower lines count";
            end;

            trigger OnPreDataItem()
            begin
                SetRange("User ID", User);
                SetRange("Statistic code", CodeStatistique);
            end;
        }
        dataitem(Ligne9; "Statistic array line")
        {
            DataItemTableView = SORTING("User ID", "Statistic code", "Section level", "Attached to Line No.", "Sort value", "Line No.") ORDER(Descending) WHERE("Section level" = FILTER(9));

            trigger OnAfterGetRecord()
            begin
                Boucle("Statistic code", NbLignesEnregPrecedent, "Attached to Line No.", "Section level");
                "Sort key by value" := NumLig;
                Modify;
                NbLignesEnregPrecedent := "Lower lines count";
            end;

            trigger OnPreDataItem()
            begin
                SetRange("User ID", User);
                SetRange("Statistic code", CodeStatistique);
            end;
        }
        dataitem(Ligne10; "Statistic array line")
        {
            DataItemTableView = SORTING("User ID", "Statistic code", "Section level", "Attached to Line No.", "Sort value", "Line No.") ORDER(Descending) WHERE("Section level" = FILTER(10));

            trigger OnAfterGetRecord()
            begin
                Boucle("Statistic code", NbLignesEnregPrecedent, "Attached to Line No.", "Section level");
                "Sort key by value" := NumLig;
                Modify;
                NbLignesEnregPrecedent := "Lower lines count";
            end;

            trigger OnPreDataItem()
            begin
                SetRange("User ID", User);
                SetRange("Statistic code", CodeStatistique);
            end;
        }
        dataitem(Ligne11; "Statistic array line")
        {
            DataItemTableView = SORTING("User ID", "Statistic code", "Section level", "Attached to Line No.", "Sort value", "Line No.") ORDER(Descending) WHERE("Section level" = FILTER(11));

            trigger OnAfterGetRecord()
            begin
                Boucle("Statistic code", NbLignesEnregPrecedent, "Attached to Line No.", "Section level");
                "Sort key by value" := NumLig;
                Modify;
                NbLignesEnregPrecedent := "Lower lines count";
            end;

            trigger OnPreDataItem()
            begin
                SetRange("User ID", User);
                SetRange("Statistic code", CodeStatistique);
            end;
        }
        dataitem(Ligne1; "Statistic array line")
        {
            DataItemTableView = SORTING("User ID", "Statistic code", "Section level", "Attached to Line No.", "Sort value", "Line No.") ORDER(Descending) WHERE("Section level" = FILTER(1));

            trigger OnAfterGetRecord()
            begin
                "Sort key by value" := "Lower lines count" + 1;
                Modify;
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
        Caption = 'Statistics : Value sort';

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
        Fenetre.Open(TriEnCours1, CodeStatistique);
        with LigneTempTableauStat do begin
            FilterGroup(7);
            SetRange("User ID", User);
            SetRange("Statistic code", CodeStatistique);
            FilterGroup(0);
            NbreEnreg := Count * 2;
            Fenetre.Open(TriEnCours2, CodeStatistique);
            Fenetre.Update(2, 1);
            if not IsEmpty then begin
                FindFirst;
                repeat
                    SetRange("Column no. filter", NumColonne);
                    CalcFields(Result);
                    "Sort value" := Result;
                    "Sort key by value" := 0;
                    Modify;
                    CptrLig := CptrLig + 1;
                    Fenetre.Update(3, Round(CptrLig / NbreEnreg * 10000, 1));
                until Next = 0;
            end;
        end;
    end;

    var
        LigneTempTableauStat: Record "Statistic array line";
        User: Code[20];
        CodeStatistique: Code[10];
        Fenetre: Dialog;
        NbreEnreg: Integer;
        CptrLig: Integer;
        NumLig: Integer;
        NumColonne: Integer;
        NbLignesEnregPrecedent: Integer;
        AttachePrecedent: Integer;
        TriEnCours1: Label 'Sort in progress #1######## ...';
        TriEnCours2: Label 'Sort in progress #1######## level #2##### @3@@@@@@@@@@@@@@@@';

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
    procedure Boucle(CodePredefini: Code[10]; NbLignes: Integer; NumLigneParente: Integer; Niveau: Integer)
    begin
        if AttachePrecedent <> NumLigneParente then begin
            if LigneTempTableauStat.Get(User, CodePredefini, NumLigneParente) then
                NumLig := LigneTempTableauStat."Sort key by value" + 1
            else
                NumLig := 0;
        end else
            NumLig := NumLig + NbLignes + 1;

        CptrLig := CptrLig + 1;
        Fenetre.Update(2, Niveau);
        Fenetre.Update(3, Round(CptrLig / NbreEnreg * 10000, 1));
        AttachePrecedent := NumLigneParente;
    end;
}

