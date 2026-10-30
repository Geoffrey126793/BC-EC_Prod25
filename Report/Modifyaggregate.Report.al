report 8001313 "Modify aggregate"
{
    // //STATSEXPLORER STATSEXPLORER 01/10/00 Modification dans table des cumuls (période clôturée)

    Caption = 'Modify aggregate';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnPreDataItem()
            begin
                if DeleteCumuls then begin
                    if Confirm(Confirm1, false, FiltreType, DateDebut, DateFin) then
                        with CumulStatistique do begin
                            SetCurrentKey("Period Length", "Entry Type", "Ending Date");
                            if ParametresStatistiques."Allow Changes in Period Length" then
                                SetRange("Period Length", BasePeriode);
                            SetRange("Ending Date", DateDebut, DateFin);
                            if FiltreType <> '' then
                                SetRange("Entry Type", FiltreType);
                            NbreEnreg := Count;
                            Fenetre.Open(Fenetre1);
                            DeleteAll;
                            Message(Message1, NbreEnreg);
                        end;
                end else begin
                    if Confirm(Confirm2, false, FiltreType, DateDebut, DateFin) then
                        with CumulStatistique do begin
                            SetCurrentKey("Period Length", "Entry Type", "Ending Date");
                            if ParametresStatistiques."Allow Changes in Period Length" then
                                SetRange("Period Length", BasePeriode);
                            SetRange("Ending Date", DateDebut, DateFin);
                            if FiltreType <> '' then
                                SetRange("Entry Type", FiltreType);
                            NbreEnreg := Count;
                            if not IsEmpty then begin
                                FindFirst;
                                Fenetre.Open(Fenetre2);
                                repeat
                                    CptrLig := CptrLig + 1;
                                    Fenetre.Update(1, Round(CptrLig / NbreEnreg * 10000, 1));
                                    RepriseValeurs.Run(CumulStatistique);
                                    CumulStatistique.Modify;
                                until Next = 0;
                            end;
                            Message(Message2, CptrLig);
                        end;
                end;
            end;
        }
    }

    requestpage
    {
        Caption = 'Modify aggregate';

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(DateDebut; DateDebut)
                    {
                        Caption = 'Starting Date';
                    }
                    field(DateFin; DateFin)
                    {
                        Caption = 'Ending Date';
                    }
                    field(FiltreType; FiltreType)
                    {
                        Caption = 'Flow Filter';
                        Lookup = true;

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
                            FiltreTypeOnAfterValidate;
                        end;
                    }
                    field(TextBasePeriode; BasePeriode)
                    {
                        Caption = 'Period Length';
                        OptionCaption = 'Day,Week,Month,Quarter,Year,Period';
                        Visible = TextBasePeriodeVisible;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            TextBasePeriodeVisible := true;
        end;

        trigger OnOpenPage()
        begin
            TextBasePeriodeVisible := ParametresStatistiques."Allow Changes in Period Length";
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        ParametresStatistiques.Get;
        BasePeriode := ParametresStatistiques."Period total basis";
    end;

    trigger OnPreReport()
    begin
        if (DateDebut = 0D) or (DateFin = 0D) or (DateDebut > DateFin) then
            Error(Error1);
        if DateDebut <= ParametresStatistiques."Last close date" then
            Error(Date3, ParametresStatistiques."Last close date");
    end;

    var
        CumulStatistique: Record "Statistic aggregate";
        ParametresStatistiques: Record "Statistics setup";
        Critere: Record "Statistic criteria";
        RepriseValeurs: Codeunit "Aggr., Update default values";
        Fenetre: Dialog;
        DeleteCumuls: Boolean;
        BasePeriode: Option Jour,Semaine,Mois,Trimestre,"Année","Période";
        DateDebut: Date;
        DateFin: Date;
        FiltreType: Text[80];
        Confirm1: Label 'Do you want to delete aggregates %1 from %2 to %3 ?';
        Confirm2: Label 'Do you confirm the calculation of aggregates %1 from %2 to %3 ?';
        Error1: Label 'Incorrect dates';
        NbreEnreg: Integer;
        Message1: Label '%1 entries deleted';
        Message2: Label '%1 entries modified';
        Fenetre1: Label 'Delete in progress ...';
        Fenetre2: Label 'Create aggregate @1@@@@@@@@@@@@@@@@';
        CptrLig: Integer;
        Date3: Label 'You can''t processed before %1';
        TextBasePeriodeVisible: Boolean;

    [Scope('OnPrem')]
    procedure InitRequete(InitDateDebut: Date; InitDateFin: Date; TypeEcriture: Text[30]; Purge: Boolean)
    begin
        DateDebut := InitDateDebut;
        DateFin := InitDateFin;
        FiltreType := TypeEcriture;
        DeleteCumuls := Purge;
    end;

    local procedure FiltreTypeOnAfterValidate()
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

