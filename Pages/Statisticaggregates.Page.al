page 8001320 "Statistic aggregates"
{
    // //TRS-2009 XPE 02/10/09
    // //DELETE-RTC2009
    // //STATSEXPLORER STATSEXPLORER 20/01/00 Statistic Aggregates

    AdditionalSearchTerms = 'StatsExplorer';
    Caption = 'Statistic aggregates';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Statistic aggregate";
    SourceTableView = SORTING("Entry Type", "Ending Date");
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                group(Filters)
                {
                    Caption = 'Filters';
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
                            SetRange("Entry Type", FiltreType);
                            CurrPage.Update(false);
                        end;

                        trigger OnValidate()
                        begin
                            FiltreTypeOnAfterValidate;
                        end;
                    }
                    field("Filtre Date"; "Filtre Date")
                    {
                        Caption = 'Date Filter';

                        trigger OnValidate()
                        begin
                            FiltreDateOnAfterValidate;
                        end;
                    }
                }
                group(Option)
                {
                    Caption = 'Option';
                    field(TypePeriode; TypePeriode)
                    {
                        Caption = 'Period Type';
                        OptionCaption = 'Day,Week,Month,Quarter,Year,Accounting Period';

                        trigger OnValidate()
                        begin
                            TypePeriodeOnAfterValidate;
                        end;
                    }
                }
            }
            repeater(Liste)
            {
                Editable = false;
                field("Entry No."; "Entry No.")
                {
                }
                field("Period Length"; "Period Length")
                {
                }
                field("Ending Date"; "Ending Date")
                {
                }
                field("Entry Type"; "Entry Type")
                {
                }
                field(Type; Type)
                {
                }
                field("No."; "No.")
                {
                }
                field("Source Type"; "Source Type")
                {
                }
                field("Source No."; "Source No.")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Inventory Posting Group"; "Inventory Posting Group")
                {
                }
                field("Source Posting Group"; "Source Posting Group")
                {
                }
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                {
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                }
                field("Salespers./Purch. Code"; "Salespers./Purch. Code")
                {
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                }
                field("Country Code"; "Country Code")
                {
                }
                field("Item Charge No."; "Item Charge No.")
                {
                }
                field("Variant Code"; "Variant Code")
                {
                }
                field("Return Reason Code"; "Return Reason Code")
                {
                }
                field("Manufacturer Code"; "Manufacturer Code")
                {
                }
                field("Item Category Code"; "Item Category Code")
                {
                }
                field("Product Group Code"; "Product Group Code")
                {
                }
                field("Service Item Group"; "Service Item Group")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field(Volume; Volume)
                {
                }
                field(Amount; Amount)
                {
                }
                field(Cost; Cost)
                {
                }
                field(Year; Year)
                {
                }
                field("Half Year"; "Half Year")
                {
                }
                field(Quarter; Quarter)
                {
                }
                field(Month; Month)
                {
                }
                field(Week; Week)
                {
                }
                field("Week Day"; "Week Day")
                {
                }
                field("Fiscal year closing date"; "Fiscal year closing date")
                {
                }
                field("Business Unit Code"; "Business Unit Code")
                {
                }
                field("Consol. Debit Acc."; "Consol. Debit Acc.")
                {
                }
                field("Consol. Credit Acc."; "Consol. Credit Acc.")
                {
                }
                field("Job No."; "Job No.")
                {
                }
                field("Work Type Code"; "Work Type Code")
                {
                }
                field("Reason Code"; "Reason Code")
                {
                }
                field("Job Posting Group"; "Job Posting Group")
                {
                }
                field("Resource Group No."; "Resource Group No.")
                {
                }
                field("Person Responsible"; "Person Responsible")
                {
                }
                field("Campaign No."; "Campaign No.")
                {
                }
                field("Item criteria 1"; "Item criteria 1")
                {
                }
                field("Item criteria 2"; "Item criteria 2")
                {
                }
                field("Item criteria 3"; "Item criteria 3")
                {
                }
                field("Item criteria 4"; "Item criteria 4")
                {
                }
                field("Item criteria 5"; "Item criteria 5")
                {
                }
                field("Item criteria 6"; "Item criteria 6")
                {
                }
                field("Item criteria 7"; "Item criteria 7")
                {
                }
                field("Item criteria 8"; "Item criteria 8")
                {
                }
                field("Item criteria 9"; "Item criteria 9")
                {
                }
                field("Item criteria 10"; "Item criteria 10")
                {
                }
                field("Customer criteria 1"; "Customer criteria 1")
                {
                }
                field("Customer criteria 2"; "Customer criteria 2")
                {
                }
                field("Customer criteria 3"; "Customer criteria 3")
                {
                }
                field("Customer criteria 4"; "Customer criteria 4")
                {
                }
                field("Customer criteria 5"; "Customer criteria 5")
                {
                }
                field("Customer criteria 6"; "Customer criteria 6")
                {
                }
                field("Customer criteria 7"; "Customer criteria 7")
                {
                }
                field("Customer criteria 8"; "Customer criteria 8")
                {
                }
                field("Customer criteria 9"; "Customer criteria 9")
                {
                }
                field("Customer criteria 10"; "Customer criteria 10")
                {
                }
                field("Job criteria 1"; "Job criteria 1")
                {
                }
                field("Job criteria 2"; "Job criteria 2")
                {
                }
                field("Job criteria 3"; "Job criteria 3")
                {
                }
                field("Job criteria 4"; "Job criteria 4")
                {
                }
                field("Job criteria 5"; "Job criteria 5")
                {
                }
                field("Job criteria 6"; "Job criteria 6")
                {
                }
                field("Job criteria 7"; "Job criteria 7")
                {
                }
                field("Job criteria 8"; "Job criteria 8")
                {
                }
                field("Job criteria 9"; "Job criteria 9")
                {
                }
                field("Job criteria 10"; "Job criteria 10")
                {
                }
                field("Free value 1"; "Free value 1")
                {
                    Visible = true;
                }
                field("Free value 2"; "Free value 2")
                {
                    Visible = true;
                }
                field("Free value 3"; "Free value 3")
                {
                    Visible = true;
                }
                field("Free value 4"; "Free value 4")
                {
                    Visible = true;
                }
                field("Free value 5"; "Free value 5")
                {
                    Visible = true;
                }
                field("Free value 6"; "Free value 6")
                {
                    Visible = true;
                }
                field("Free value 7"; "Free value 7")
                {
                    Visible = true;
                }
                field("Free value 8"; "Free value 8")
                {
                    Visible = true;
                }
                field("Free value 9"; "Free value 9")
                {
                    Visible = true;
                }
                field("Free value 10"; "Free value 10")
                {
                    Visible = true;
                }
                field("Back disc./commission rule No."; "Back disc./commission rule No.")
                {
                    Visible = false;
                }
                field("Free field 1"; "Free field 1")
                {
                    Visible = false;
                }
                field("Free field 2"; "Free field 2")
                {
                    Visible = false;
                }
                field("Free field 3"; "Free field 3")
                {
                    Visible = false;
                }
                field("Free field 4"; "Free field 4")
                {
                    Visible = false;
                }
                field("Free field 5"; "Free field 5")
                {
                    Visible = false;
                }
                field("Free field 6"; "Free field 6")
                {
                    Visible = false;
                }
                field("Free field 7"; "Free field 7")
                {
                    Visible = false;
                }
                field("Free field 8"; "Free field 8")
                {
                    Visible = false;
                }
                field("Free field 9"; "Free field 9")
                {
                    Visible = false;
                }
                field("Free field 10"; "Free field 10")
                {
                    Visible = false;
                }
                field("Free date 1"; "Free date 1")
                {
                    Visible = false;
                }
                field("Free date 2"; "Free date 2")
                {
                    Visible = false;
                }
                field("Free date 3"; "Free date 3")
                {
                    Visible = false;
                }
                field("Free date 4"; "Free date 4")
                {
                    Visible = false;
                }
                field("Free date 5"; "Free date 5")
                {
                    Visible = false;
                }
                field("Free boolean 1"; "Free boolean 1")
                {
                    Visible = false;
                }
                field("Free boolean 2"; "Free boolean 2")
                {
                    Visible = false;
                }
                field("Free boolean 3"; "Free boolean 3")
                {
                    Visible = false;
                }
                field("Free boolean 4"; "Free boolean 4")
                {
                    Visible = false;
                }
                field("Free boolean 5"; "Free boolean 5")
                {
                    Visible = false;
                }
                field("Dimension 1 Value Code"; "Dimension 1 Value Code")
                {
                }
                field("Dimension 2 Value Code"; "Dimension 2 Value Code")
                {
                }
                field("Dimension 3 Value Code"; "Dimension 3 Value Code")
                {
                }
                field("Dimension 4 Value Code"; "Dimension 4 Value Code")
                {
                }
                field("Dimension 5 Value Code"; "Dimension 5 Value Code")
                {
                }
                field("Dimension 6 Value Code"; "Dimension 6 Value Code")
                {
                }
                field("Dimension 7 Value Code"; "Dimension 7 Value Code")
                {
                }
                field("Dimension 8 Value Code"; "Dimension 8 Value Code")
                {
                }
                field("Dimension 9 Value Code"; "Dimension 9 Value Code")
                {
                }
                field("Dimension 10 Value Code"; "Dimension 10 Value Code")
                {
                }
                field("Dimension 11 Value Code"; "Dimension 11 Value Code")
                {
                }
                field("Dimension 12 Value Code"; "Dimension 12 Value Code")
                {
                }
                field("Dimension 13 Value Code"; "Dimension 13 Value Code")
                {
                }
                field("Dimension 14 Value Code"; "Dimension 14 Value Code")
                {
                }
                field("Dimension 15 Value Code"; "Dimension 15 Value Code")
                {
                }
                field("Dimension 16 Value Code"; "Dimension 16 Value Code")
                {
                }
                field("Dimension 17 Value Code"; "Dimension 17 Value Code")
                {
                }
                field("Dimension 18 Value Code"; "Dimension 18 Value Code")
                {
                }
                field("Dimension 19 Value Code"; "Dimension 19 Value Code")
                {
                }
                field("Dimension 20 Value Code"; "Dimension 20 Value Code")
                {
                }
                field("Coop Comm"; "Coop Comm")
                {
                    Caption = 'Coopération commerciale';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Process aggregate")
                {
                    Caption = 'Process aggregate';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        REPORT.RunModal(REPORT::"Process aggregate");
                        CurrPage.Update(false);
                    end;
                }
                separator(Action207)
                {
                }
                action("Update default values")
                {
                    Caption = 'Update default values';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        if "Filtre Date" <> '' then begin
                            Compte.SetFilter("Date Filter", "Filtre Date");
                            PurgeCumuls.InitRequete(Compte.GetRangeMin("Date Filter"), Compte.GetRangeMax("Date Filter"), FiltreType, false);
                        end else
                            PurgeCumuls.InitRequete(0D, 0D, FiltreType, false);
                        PurgeCumuls.RunModal;
                        Clear(PurgeCumuls);
                    end;
                }
                action(Delete)
                {
                    Caption = 'Delete';
                    Image = DeleteQtyToHandle;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        if "Filtre Date" <> '' then begin
                            Compte.SetFilter("Date Filter", "Filtre Date");
                            PurgeCumuls.InitRequete(Compte.GetRangeMin("Date Filter"), Compte.GetRangeMax("Date Filter"), FiltreType, true);
                        end else
                            PurgeCumuls.InitRequete(0D, 0D, FiltreType, true);
                        PurgeCumuls.RunModal;
                        Clear(PurgeCumuls);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        VisibleFields;
    end;

    var
        StatisticsSetup: Record "Statistics setup";
        Critere: Record "Statistic criteria";
        Compte: Record "G/L Account";
        PurgeCumuls: Report "Modify aggregate";
        FiltreType: Text[30];
        "Filtre Date": Text[30];
        TypePeriode: Option Jour,Semaine,Mois,Trimestre,"Année","Période comptable";
        TypeMnt: Option "Solde période","Solde en date du";

    local procedure RechPeriode(RechTexte: Code[10])
    var
        Calendrier: Record Date;

    begin

        "Filtre Date" := StrSubstNo('%1..%2', Calendrier."Period Start", Calendrier."Period End");
        SetFilter("Ending Date", "Filtre Date");
        CurrPage.Update(true);
    end;

    [Scope('OnPrem')]
    procedure VisibleFields()
    var
        lClassicVisible: Boolean;
    begin
        StatisticsSetup.Get;
        //TRS-2009
        lClassicVisible := StatisticsSetup."Item criteria name 1" <> '';
        lClassicVisible := StatisticsSetup."Item criteria name 2" <> '';
        lClassicVisible := StatisticsSetup."Item criteria name 3" <> '';
        lClassicVisible := StatisticsSetup."Item criteria name 4" <> '';
        lClassicVisible := StatisticsSetup."Item criteria name 5" <> '';
        lClassicVisible := StatisticsSetup."Item criteria name 6" <> '';
        lClassicVisible := StatisticsSetup."Item criteria name 7" <> '';
        lClassicVisible := StatisticsSetup."Item criteria name 8" <> '';
        lClassicVisible := StatisticsSetup."Item criteria name 9" <> '';
        lClassicVisible := StatisticsSetup."Item criteria name 10" <> '';
        lClassicVisible := StatisticsSetup."Customer criteria name 1" <> '';
        lClassicVisible := StatisticsSetup."Customer criteria name 2" <> '';
        lClassicVisible := StatisticsSetup."Customer criteria name 3" <> '';
        lClassicVisible := StatisticsSetup."Customer criteria name 4" <> '';
        lClassicVisible := StatisticsSetup."Customer criteria name 5" <> '';
        lClassicVisible := StatisticsSetup."Customer criteria name 6" <> '';
        lClassicVisible := StatisticsSetup."Customer criteria name 7" <> '';
        lClassicVisible := StatisticsSetup."Customer criteria name 8" <> '';
        lClassicVisible := StatisticsSetup."Customer criteria name 9" <> '';
        lClassicVisible := StatisticsSetup."Customer criteria name 10" <> '';
        lClassicVisible := StatisticsSetup."Job criteria name 1" <> '';
        lClassicVisible := StatisticsSetup."Job criteria name 2" <> '';
        lClassicVisible := StatisticsSetup."Job criteria name 3" <> '';
        lClassicVisible := StatisticsSetup."Job criteria name 4" <> '';
        lClassicVisible := StatisticsSetup."Job criteria name 5" <> '';
        lClassicVisible := StatisticsSetup."Job criteria name 6" <> '';
        lClassicVisible := StatisticsSetup."Job criteria name 7" <> '';
        lClassicVisible := StatisticsSetup."Job criteria name 8" <> '';
        lClassicVisible := StatisticsSetup."Job criteria name 9" <> '';
        lClassicVisible := StatisticsSetup."Job criteria name 10" <> '';
        lClassicVisible := StatisticsSetup."Dimension 1 Code" <> '';
        lClassicVisible := StatisticsSetup."Dimension 2 Code" <> '';
        lClassicVisible := StatisticsSetup."Dimension 3 Code" <> '';
        lClassicVisible := StatisticsSetup."Dimension 4 Code" <> '';
        lClassicVisible := StatisticsSetup."Dimension 5 Code" <> '';
        lClassicVisible := StatisticsSetup."Dimension 6 Code" <> '';
        lClassicVisible := StatisticsSetup."Dimension 7 Code" <> '';
        lClassicVisible := StatisticsSetup."Dimension 8 Code" <> '';
        lClassicVisible := StatisticsSetup."Dimension 9 Code" <> '';
        lClassicVisible := StatisticsSetup."Dimension 10 Code" <> '';
        lClassicVisible := StatisticsSetup."Dimension 11 Code" <> '';
        lClassicVisible := StatisticsSetup."Dimension 12 Code" <> '';
        lClassicVisible := StatisticsSetup."Dimension 13 Code" <> '';
        lClassicVisible := StatisticsSetup."Dimension 14 Code" <> '';
        lClassicVisible := StatisticsSetup."Dimension 15 Code" <> '';
        lClassicVisible := StatisticsSetup."Dimension 16 Code" <> '';
        lClassicVisible := StatisticsSetup."Dimension 17 Code" <> '';
        lClassicVisible := StatisticsSetup."Dimension 18 Code" <> '';
        lClassicVisible := StatisticsSetup."Dimension 19 Code" <> '';
        lClassicVisible := StatisticsSetup."Dimension 20 Code" <> '';
        //TRS-2009//
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
            SetRange("Entry Type", FiltreType);
        end else
            SetRange("Entry Type");
        CurrPage.Update(false);
    end;

    local procedure FiltreDateOnAfterValidate()
    begin
        //"Filtre Date" := FaireFiltreDate.FaireDate("Filtre Date");
        SetFilter("Ending Date", "Filtre Date");
        CurrPage.Update(false);
    end;

    local procedure TypePeriodeOnAfterValidate()
    begin
        RechPeriode('');
    end;
}

