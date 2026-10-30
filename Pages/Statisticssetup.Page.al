page 8001302 "Statistics setup"
{
    // //STATSEXPLORER STATSEXPLORER 01/01/00 StatsExplorer Setup

    Caption = 'Statistics setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Statistics setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Last calculation start date"; "Last calculation start date")
                {
                }
                field("Last calculation end date"; "Last calculation end date")
                {
                }
                field("Period total basis"; "Period total basis")
                {

                    trigger OnValidate()
                    begin
                        PeriodtotalbasisOnAfterValidat;
                    end;
                }
                field("Allow Changes in Period Length"; "Allow Changes in Period Length")
                {
                    Editable = AllowChangesinPeriodLengthEdit;
                }
                field("Default Excel sheet"; "Default Excel sheet")
                {
                }
                field("Last close date"; "Last close date")
                {
                    Editable = false;
                }
                field("Last aggregate process date"; "Last aggregate process date")
                {
                    Caption = 'Last aggregate computation';
                    Editable = false;
                }
                field("Scheduler process from date"; "Scheduler process from date")
                {
                }
                field("Scheduler process to date"; "Scheduler process to date")
                {
                }
                field("Historic duration"; "Historic duration")
                {
                }
            }
            group("Ledger type")
            {
                Caption = 'Ledger type';
                part(StatisticCriteriaSubform; "Statistic criteria subform")
                {
                    SubPageView = SORTING(Type, "Field No.")
                                  WHERE(Type = FILTER(Flow));
                }
            }
            group("Sort field")
            {
                Caption = 'Sort field';
                part(Control3; "Statistic criteria subform")
                {
                    SubPageView = SORTING(Type, "Field No.")
                                  WHERE(Type = FILTER("Sort criteria"));
                }
            }
            group(Values)
            {
                Caption = 'Values';
                part(Control4; "Statistic criteria subform")
                {
                    SubPageView = SORTING(Type, "Field No.")
                                  WHERE(Type = FILTER(Value));
                }
            }
            group("Customer criterias")
            {
                Caption = 'Customer criterias';
                field("Customer criteria name 1"; "Customer criteria name 1")
                {
                    Caption = 'Criteria 1 name';

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Customer criteria name 1"));
                        CurrPage.Update(false);
                    end;
                }
                field("Customer criteria 1 required"; "Customer criteria 1 required")
                {
                }
                field("Customer criteria name 2"; "Customer criteria name 2")
                {
                    Caption = 'Criteria 2 name';

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Customer criteria name 2"));
                    end;
                }
                field("Customer criteria 2 required"; "Customer criteria 2 required")
                {
                }
                field("Customer criteria name 3"; "Customer criteria name 3")
                {
                    Caption = 'Criteria 3 name';

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Customer criteria name 3"));
                        CurrPage.Update(false);
                    end;
                }
                field("Customer criteria 3 required"; "Customer criteria 3 required")
                {
                }
                field("Customer criteria name 4"; "Customer criteria name 4")
                {
                    Caption = 'Criteria 4 name';

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Customer criteria name 4"));
                    end;
                }
                field("Customer criteria 4 required"; "Customer criteria 4 required")
                {
                }
                field("Customer criteria name 5"; "Customer criteria name 5")
                {
                    Caption = 'Criteria 5 name';

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Customer criteria name 5"));
                    end;
                }
                field("Customer criteria 5 required"; "Customer criteria 5 required")
                {
                }
                field("Customer criteria name 6"; "Customer criteria name 6")
                {
                    Caption = 'Criteria 6 name';

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Customer criteria name 6"));
                    end;
                }
                field("Customer criteria 6 required"; "Customer criteria 6 required")
                {
                }
                field("Customer criteria name 7"; "Customer criteria name 7")
                {
                    Caption = 'Criteria 7 name';

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Customer criteria name 7"));
                    end;
                }
                field("Customer criteria 7 required"; "Customer criteria 7 required")
                {
                }
                field("Customer criteria name 8"; "Customer criteria name 8")
                {
                    Caption = 'Criteria 8 name';

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Customer criteria name 8"));
                    end;
                }
                field("Customer criteria 8 required"; "Customer criteria 8 required")
                {
                }
                field("Customer criteria name 9"; "Customer criteria name 9")
                {
                    Caption = 'Criteria 9 name';

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Customer criteria name 9"));
                    end;
                }
                field("Customer criteria 9 required"; "Customer criteria 9 required")
                {
                }
                field("Customer criteria name 10"; "Customer criteria name 10")
                {
                    Caption = 'Criteria 10 name';

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Customer criteria name 10"));
                    end;
                }
                field("Customer criteria 10 required"; "Customer criteria 10 required")
                {
                }
            }
            group("Item criterias")
            {
                Caption = 'Item criterias';
                field("Item criteria name 1"; "Item criteria name 1")
                {
                    Caption = 'Criteria 1 name';

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Item criteria name 1"));
                    end;
                }
                field("Item criteria 1 required"; "Item criteria 1 required")
                {
                }
                field("Item criteria name 2"; "Item criteria name 2")
                {
                    Caption = 'Criteria 2 name';

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Item criteria name 2"));
                    end;
                }
                field("Item criteria 2 required"; "Item criteria 2 required")
                {
                }
                field("Item criteria name 3"; "Item criteria name 3")
                {
                    Caption = 'Criteria 3 name';

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Item criteria name 3"));
                    end;
                }
                field("Item criteria 3 required"; "Item criteria 3 required")
                {
                }
                field("Item criteria name 4"; "Item criteria name 4")
                {
                    Caption = 'Criteria 4 name';

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Item criteria name 4"));
                    end;
                }
                field("Item criteria 4 required"; "Item criteria 4 required")
                {
                }
                field("Item criteria name 5"; "Item criteria name 5")
                {
                    Caption = 'Criteria 5 name';

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Item criteria name 5"));
                    end;
                }
                field("Item criteria 5 required"; "Item criteria 5 required")
                {
                }
                field("Item criteria name 6"; "Item criteria name 6")
                {
                    Caption = 'Criteria 6 name';

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Item criteria name 6"));
                    end;
                }
                field("Item criteria 6 required"; "Item criteria 6 required")
                {
                }
                field("Item criteria name 7"; "Item criteria name 7")
                {
                    Caption = 'Criteria 7 name';

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Item criteria name 7"));
                    end;
                }
                field("Item criteria 7 required"; "Item criteria 7 required")
                {
                }
                field("Item criteria name 8"; "Item criteria name 8")
                {
                    Caption = 'Criteria 8 name';

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Item criteria name 8"));
                    end;
                }
                field("Item criteria 8 required"; "Item criteria 8 required")
                {
                }
                field("Item criteria name 9"; "Item criteria name 9")
                {
                    Caption = 'Criteria 9 name';

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Item criteria name 9"));
                    end;
                }
                field("Item criteria 9 required"; "Item criteria 9 required")
                {
                }
                field("Item criteria name 10"; "Item criteria name 10")
                {
                    Caption = 'Criteria 10 name';

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Item criteria name 10"));
                    end;
                }
                field("Item criteria 10 required"; "Item criteria 10 required")
                {
                }
            }
            group("Job criterias")
            {
                Caption = 'Job criterias';
                field("Job criteria name 1"; "Job criteria name 1")
                {
                    Caption = 'Criteria 1 name';

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Job criteria name 1"));
                    end;
                }
                field("Job criteria 1 required"; "Job criteria 1 required")
                {
                }
                field("Job criteria name 2"; "Job criteria name 2")
                {
                    Caption = 'Criteria 2 name';

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Job criteria name 2"));
                    end;
                }
                field("Job criteria 2 required"; "Job criteria 2 required")
                {
                }
                field("Job criteria name 3"; "Job criteria name 3")
                {
                    Caption = 'Criteria 3 name';

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Job criteria name 3"));
                    end;
                }
                field("Job criteria 3 required"; "Job criteria 3 required")
                {
                }
                field("Job criteria name 4"; "Job criteria name 4")
                {
                    Caption = 'Criteria 4 name';

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Job criteria name 4"));
                    end;
                }
                field("Job criteria 4 required"; "Job criteria 4 required")
                {
                }
                field("Job criteria name 5"; "Job criteria name 5")
                {
                    Caption = 'Criteria 5 name';

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Job criteria name 5"));
                    end;
                }
                field("Job criteria 5 required"; "Job criteria 5 required")
                {
                }
                field("Job criteria name 6"; "Job criteria name 6")
                {
                    Caption = 'Criteria 6 name';

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Job criteria name 6"));
                    end;
                }
                field("Job criteria 6 required"; "Job criteria 6 required")
                {
                }
                field("Job criteria name 7"; "Job criteria name 7")
                {
                    Caption = 'Criteria 7 name';

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Job criteria name 7"));
                    end;
                }
                field("Job criteria 7 required"; "Job criteria 7 required")
                {
                }
                field("Job criteria name 8"; "Job criteria name 8")
                {
                    Caption = 'Criteria 8 name';

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Job criteria name 8"));
                    end;
                }
                field("Job criteria 8 required"; "Job criteria 8 required")
                {
                }
                field("Job criteria name 9"; "Job criteria name 9")
                {
                    Caption = 'Criteria 9 name';

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Job criteria name 9"));
                    end;
                }
                field("Job criteria 9 required"; "Job criteria 9 required")
                {
                }
                field("Job criteria name 10"; "Job criteria name 10")
                {
                    Caption = 'Criteria 10 name';

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Job criteria name 10"));
                    end;
                }
                field("Job criteria 10 required"; "Job criteria 10 required")
                {
                }
            }
            group("Free fields")
            {
                Caption = 'Free fields';
                field("Free field no 1"; "Free field no 1")
                {

                    trigger OnValidate()
                    begin
                        //Freefieldno1OnAfterValidate;
                    end;
                }
                field("Free field name 1"; "Free field name 1")
                {

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Free field name 1"));
                    end;
                }
                field("Free field no 2"; "Free field no 2")
                {

                    trigger OnValidate()
                    begin
                        Freefieldno2OnAfterValidate;
                    end;
                }
                field("Free field name 2"; "Free field name 2")
                {

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Free field name 2"));
                    end;
                }
                field("Free field no 3"; "Free field no 3")
                {

                    trigger OnValidate()
                    begin
                        Freefieldno3OnAfterValidate;
                    end;
                }
                field("Free field name 3"; "Free field name 3")
                {

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Free field name 3"));
                    end;
                }
                field("Free field no 4"; "Free field no 4")
                {

                    trigger OnValidate()
                    begin
                        Freefieldno4OnAfterValidate;
                    end;
                }
                field("Free field name 4"; "Free field name 4")
                {

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Free field name 4"));
                    end;
                }
                field("Free field no 5"; "Free field no 5")
                {

                    trigger OnValidate()
                    begin
                        Freefieldno5OnAfterValidate;
                    end;
                }
                field("Free field name 5"; "Free field name 5")
                {

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Free field name 5"));
                    end;
                }
                field("Free field no 6"; "Free field no 6")
                {

                    trigger OnValidate()
                    begin
                        Freefieldno6OnAfterValidate;
                    end;
                }
                field("Free field name 6"; "Free field name 6")
                {

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Free field name 6"));
                    end;
                }
                field("Free field no 7"; "Free field no 7")
                {

                    trigger OnValidate()
                    begin
                        Freefieldno7OnAfterValidate;
                    end;
                }
                field("Free field name 7"; "Free field name 7")
                {

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Free field name 7"));
                    end;
                }
                field("Free field no 8"; "Free field no 8")
                {

                    trigger OnValidate()
                    begin
                        Freefieldno8OnAfterValidate;
                    end;
                }
                field("Free field name 8"; "Free field name 8")
                {

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Free field name 8"));
                    end;
                }
                field("Free field no 9"; "Free field no 9")
                {

                    trigger OnValidate()
                    begin
                        Freefieldno9OnAfterValidate;
                    end;
                }
                field("Free field name 9"; "Free field name 9")
                {

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Free field name 9"));
                    end;
                }
                field("Free field no 10"; "Free field no 10")
                {

                    trigger OnValidate()
                    begin
                        Freefieldno10OnAfterValidate;
                    end;
                }
                field("Free field name 10"; "Free field name 10")
                {

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Free field name 10"));
                    end;
                }
                field("Free date no 1"; "Free date no 1")
                {

                    trigger OnValidate()
                    begin
                        Freedateno1OnAfterValidate;
                    end;
                }
                field("Free date name 1"; "Free date name 1")
                {

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Free date name 1"));
                    end;
                }
                field("Free date no 2"; "Free date no 2")
                {

                    trigger OnValidate()
                    begin
                        Freedateno2OnAfterValidate;
                    end;
                }
                field("Free date name 2"; "Free date name 2")
                {

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Free date name 2"));
                    end;
                }
                field("Free date no 3"; "Free date no 3")
                {

                    trigger OnValidate()
                    begin
                        Freedateno3OnAfterValidate;
                    end;
                }
                field("Free date name 3"; "Free date name 3")
                {

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Free date name 3"));
                    end;
                }
                field("Free date no 4"; "Free date no 4")
                {

                    trigger OnValidate()
                    begin
                        Freedateno4OnAfterValidate;
                    end;
                }
                field("Free date name 4"; "Free date name 4")
                {

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Free date name 4"));
                    end;
                }
                field("Free date no 5"; "Free date no 5")
                {

                    trigger OnValidate()
                    begin
                        Freedateno5OnAfterValidate;
                    end;
                }
                field("Free date name 5"; "Free date name 5")
                {

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Free date name 5"));
                    end;
                }
                field("Free check no 1"; "Free check no 1")
                {

                    trigger OnValidate()
                    begin
                        Freecheckno1OnAfterValidate;
                    end;
                }
                field("Free check name 1"; "Free check name 1")
                {

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Free check name 1"));
                    end;
                }
                field("Free check no 2"; "Free check no 2")
                {

                    trigger OnValidate()
                    begin
                        Freecheckno2OnAfterValidate;
                    end;
                }
                field("Free check name 2"; "Free check name 2")
                {

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Free check name 2"));
                    end;
                }
                field("Free check no 3"; "Free check no 3")
                {

                    trigger OnValidate()
                    begin
                        Freecheckno3OnAfterValidate;
                    end;
                }
                field("Free check name 3"; "Free check name 3")
                {

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Free check name 3"));
                    end;
                }
                field("Free check no 4"; "Free check no 4")
                {

                    trigger OnValidate()
                    begin
                        Freecheckno4OnAfterValidate;
                    end;
                }
                field("Free check name 4"; "Free check name 4")
                {

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Free check name 4"));
                    end;
                }
                field("Free check no 5"; "Free check no 5")
                {

                    trigger OnValidate()
                    begin
                        Freecheckno5OnAfterValidate;
                    end;
                }
                field("Free check name 5"; "Free check name 5")
                {

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Free check name 5"));
                    end;
                }
            }
            group("Free values")
            {
                Caption = 'Free values';
                field("Free value name 1"; "Free value name 1")
                {

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Free value name 1"));
                    end;
                }
                field("Free value name 2"; "Free value name 2")
                {

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Free value name 2"));
                    end;
                }
                field("Free value name 3"; "Free value name 3")
                {

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Free value name 3"));
                    end;
                }
                field("Free value name 4"; "Free value name 4")
                {

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Free value name 4"));
                    end;
                }
                field("Free value name 5"; "Free value name 5")
                {

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Free value name 5"));
                    end;
                }
                field("Free value name 6"; "Free value name 6")
                {

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Free value name 6"));
                    end;
                }
                field("Free value name 7"; "Free value name 7")
                {

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Free value name 7"));
                    end;
                }
                field("Free value name 8"; "Free value name 8")
                {

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Free value name 8"));
                    end;
                }
                field("Free value name 9"; "Free value name 9")
                {

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Free value name 9"));
                    end;
                }
                field("Free value name 10"; "Free value name 10")
                {

                    trigger OnAssistEdit()
                    begin
                        //wCaptionClassTrans.SetAssistEdit(DATABASE::"Statistics setup",FIELDNO("Free value name 10"));
                    end;
                }
            }
            group(Dimensions)
            {
                Caption = 'Dimensions';
                field("Dimension 1 Code"; "Dimension 1 Code")
                {
                }
                field("Dimension 2 Code"; "Dimension 2 Code")
                {
                }
                field("Dimension 3 Code"; "Dimension 3 Code")
                {
                }
                field("Dimension 4 Code"; "Dimension 4 Code")
                {
                }
                field("Dimension 5 Code"; "Dimension 5 Code")
                {
                }
                field("Dimension 6 Code"; "Dimension 6 Code")
                {
                }
                field("Dimension 7 Code"; "Dimension 7 Code")
                {
                }
                field("Dimension 8 Code"; "Dimension 8 Code")
                {
                }
                field("Dimension 9 Code"; "Dimension 9 Code")
                {
                }
                field("Dimension 10 Code"; "Dimension 10 Code")
                {
                }
                field("Dimension 11 Code"; "Dimension 11 Code")
                {
                }
                field("Dimension 12 Code"; "Dimension 12 Code")
                {
                }
                field("Dimension 13 Code"; "Dimension 13 Code")
                {
                }
                field("Dimension 14 Code"; "Dimension 14 Code")
                {
                }
                field("Dimension 15 Code"; "Dimension 15 Code")
                {
                }
                field("Dimension 16 Code"; "Dimension 16 Code")
                {
                }
                field("Dimension 17 Code"; "Dimension 17 Code")
                {
                }
                field("Dimension 18 Code"; "Dimension 18 Code")
                {
                }
                field("Dimension 19 Code"; "Dimension 19 Code")
                {
                }
                field("Dimension 20 Code"; "Dimension 20 Code")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = 'F&unctions';
                Visible = FunctionsVisible;
                action(Levels)
                {
                    Caption = 'Levels';
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        //RTC-2009 -- VERSION 6.01
                        fShowLevels();
                        //RTC-2009 -- VERSION 6.01//
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        /*
        Customercriterianame1OnFormat(FORMAT("Customer criteria name 1"));
        Customercriterianame2OnFormat(FORMAT("Customer criteria name 2"));
        Customercriterianame3OnFormat(FORMAT("Customer criteria name 3"));
        Customercriterianame4OnFormat(FORMAT("Customer criteria name 4"));
        Customercriterianame5OnFormat(FORMAT("Customer criteria name 5"));
        Customercriterianame6OnFormat(FORMAT("Customer criteria name 6"));
        Customercriterianame7OnFormat(FORMAT("Customer criteria name 7"));
        Customercriterianame8OnFormat(FORMAT("Customer criteria name 8"));
        Customercriterianame9OnFormat(FORMAT("Customer criteria name 9"));
        Customercriterianame10OnFormat(FORMAT("Customer criteria name 10"));
        Itemcriterianame10OnFormat(FORMAT("Item criteria name 10"));
        Itemcriterianame9OnFormat(FORMAT("Item criteria name 9"));
        Itemcriterianame8OnFormat(FORMAT("Item criteria name 8"));
        Itemcriterianame7OnFormat(FORMAT("Item criteria name 7"));
        Itemcriterianame6OnFormat(FORMAT("Item criteria name 6"));
        Itemcriterianame5OnFormat(FORMAT("Item criteria name 5"));
        Itemcriterianame4OnFormat(FORMAT("Item criteria name 4"));
        Itemcriterianame3OnFormat(FORMAT("Item criteria name 3"));
        Itemcriterianame2OnFormat(FORMAT("Item criteria name 2"));
        Itemcriterianame1OnFormat(FORMAT("Item criteria name 1"));
        Jobcriterianame10OnFormat(FORMAT("Job criteria name 10"));
        Jobcriterianame9OnFormat(FORMAT("Job criteria name 9"));
        Jobcriterianame8OnFormat(FORMAT("Job criteria name 8"));
        Jobcriterianame7OnFormat(FORMAT("Job criteria name 7"));
        Jobcriterianame6OnFormat(FORMAT("Job criteria name 6"));
        Jobcriterianame5OnFormat(FORMAT("Job criteria name 5"));
        Jobcriterianame4OnFormat(FORMAT("Job criteria name 4"));
        Jobcriterianame3OnFormat(FORMAT("Job criteria name 3"));
        Jobcriterianame2OnFormat(FORMAT("Job criteria name 2"));
        Jobcriterianame1OnFormat(FORMAT("Job criteria name 1"));
        Freefieldname1OnFormat(FORMAT("Free field name 1"));
        Freedatename1OnFormat(FORMAT("Free date name 1"));
        Freefieldname2OnFormat(FORMAT("Free field name 2"));
        Freedatename2OnFormat(FORMAT("Free date name 2"));
        Freefieldname3OnFormat(FORMAT("Free field name 3"));
        Freedatename3OnFormat(FORMAT("Free date name 3"));
        Freefieldname4OnFormat(FORMAT("Free field name 4"));
        Freedatename4OnFormat(FORMAT("Free date name 4"));
        Freefieldname5OnFormat(FORMAT("Free field name 5"));
        Freedatename5OnFormat(FORMAT("Free date name 5"));
        Freefieldname6OnFormat(FORMAT("Free field name 6"));
        Freecheckname1OnFormat(FORMAT("Free check name 1"));
        Freefieldname7OnFormat(FORMAT("Free field name 7"));
        Freecheckname2OnFormat(FORMAT("Free check name 2"));
        Freefieldname8OnFormat(FORMAT("Free field name 8"));
        Freecheckname3OnFormat(FORMAT("Free check name 3"));
        Freefieldname9OnFormat(FORMAT("Free field name 9"));
        Freecheckname4OnFormat(FORMAT("Free check name 4"));
        Freefieldname10OnFormat(FORMAT("Free field name 10"));
        Freecheckname5OnFormat(FORMAT("Free check name 5"));
        Freevaluename10OnFormat(FORMAT("Free value name 10"));
        Freevaluename9OnFormat(FORMAT("Free value name 9"));
        Freevaluename8OnFormat(FORMAT("Free value name 8"));
        Freevaluename7OnFormat(FORMAT("Free value name 7"));
        Freevaluename6OnFormat(FORMAT("Free value name 6"));
        Freevaluename5OnFormat(FORMAT("Free value name 5"));
        Freevaluename4OnFormat(FORMAT("Free value name 4"));
        Freevaluename3OnFormat(FORMAT("Free value name 3"));
        Freevaluename2OnFormat(FORMAT("Free value name 2"));
        Freevaluename1OnFormat(FORMAT("Free value name 1"));
        */

    end;

    trigger OnInit()
    begin
        FunctionsVisible := true;
        AllowChangesinPeriodLengthEdit := true;
    end;

    trigger OnOpenPage()
    begin
        Reset;
        if not Get then begin
            Init;
            Insert;
        end;

        //CODEUNIT.RUN(CODEUNIT::"StatsExporer Init");

        FunctionsVisible := false;
    end;

    var
        wCaptionClassTrans: Record "Batch Treatment";

        AllowChangesinPeriodLengthEdit: Boolean;

        FunctionsVisible: Boolean;

    [Scope('OnPrem')]
    procedure fShowLevels()
    begin
        //RTC-2009 -- VERSION 6.01
        CurrPage.StatisticCriteriaSubform.PAGE.ShowStatsExplorerFields;
        //RTC-2009 -- VERSION 6.01//
    end;

    local procedure PeriodtotalbasisOnAfterValidat()
    begin
        if "Period total basis" = "Period total basis"::"According to every flow" then begin
            "Allow Changes in Period Length" := false;
            AllowChangesinPeriodLengthEdit := false;
        end else
            AllowChangesinPeriodLengthEdit := true;
    end;

    local procedure Freefieldno1OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure Freedateno1OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure Freefieldno2OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure Freedateno2OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure Freefieldno3OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure Freedateno3OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure Freefieldno4OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure Freedateno4OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure Freefieldno5OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure Freedateno5OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure Freefieldno6OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure Freecheckno1OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure Freefieldno7OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure Freecheckno2OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure Freefieldno8OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure Freecheckno3OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure Freefieldno9OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure Freecheckno4OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure Freefieldno10OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure Freecheckno5OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure StatisticCriteriaSubformOnDeac()
    begin
        FunctionsVisible := false;
    end;

    local procedure StatisticCriteriaSubformOnActi()
    begin
        FunctionsVisible := true;
    end;

    local procedure Customercriterianame1OnFormat(Text: Text[1024])
    begin
        //IF "Customer criteria name 1" <> '' THEN
        //Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Customer criteria name 1"),GLOBALLANGUAGE,Text);
    end;

    local procedure Customercriterianame2OnFormat(Text: Text[1024])
    begin
        //IF "Customer criteria name 2" <> '' THEN
        //Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Customer criteria name 2"),
        //            GLOBALLANGUAGE,"Customer criteria name 2");
    end;

    local procedure Customercriterianame3OnFormat(Text: Text[1024])
    begin
        //IF "Customer criteria name 3" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Customer criteria name 3"),GLOBALLANGUAGE,Text)
        //;
    end;

    local procedure Customercriterianame4OnFormat(Text: Text[1024])
    begin
        //IF "Customer criteria name 4" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Customer criteria name 4"),GLOBALLANGUAGE,Text)
        //;
    end;

    local procedure Customercriterianame5OnFormat(Text: Text[1024])
    begin
        //IF "Customer criteria name 5" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Customer criteria name 5"),GLOBALLANGUAGE,Text)
        //;
    end;

    local procedure Customercriterianame6OnFormat(Text: Text[1024])
    begin
        //IF "Customer criteria name 6" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Customer criteria name 6"),GLOBALLANGUAGE,Text)
        //;
    end;

    local procedure Customercriterianame7OnFormat(Text: Text[1024])
    begin
        //IF "Customer criteria name 7" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Customer criteria name 7"),GLOBALLANGUAGE,Text)
        //;
    end;

    local procedure Customercriterianame8OnFormat(Text: Text[1024])
    begin
        //IF "Customer criteria name 8" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Customer criteria name 8"),GLOBALLANGUAGE,Text)
        //;
    end;

    local procedure Customercriterianame9OnFormat(Text: Text[1024])
    begin
        //IF "Customer criteria name 9" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Customer criteria name 9"),GLOBALLANGUAGE,Text)
        //;
    end;

    local procedure Customercriterianame10OnFormat(Text: Text[1024])
    begin
        //IF "Customer criteria name 10" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Customer criteria name 10"),GLOBALLANGUAGE,Text
        //);
    end;

    local procedure Itemcriterianame10OnFormat(Text: Text[1024])
    begin
        //IF "Item criteria name 10" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Item criteria name 10"),GLOBALLANGUAGE,Text);
    end;

    local procedure Itemcriterianame9OnFormat(Text: Text[1024])
    begin
        //IF "Item criteria name 9" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Item criteria name 9"),GLOBALLANGUAGE,Text);
    end;

    local procedure Itemcriterianame8OnFormat(Text: Text[1024])
    begin
        //IF "Item criteria name 8" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Item criteria name 8"),GLOBALLANGUAGE,Text);
    end;

    local procedure Itemcriterianame7OnFormat(Text: Text[1024])
    begin
        //IF "Item criteria name 7" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Item criteria name 7"),GLOBALLANGUAGE,Text);
    end;

    local procedure Itemcriterianame6OnFormat(Text: Text[1024])
    begin
        //IF "Item criteria name 6" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Item criteria name 6"),GLOBALLANGUAGE,Text);
    end;

    local procedure Itemcriterianame5OnFormat(Text: Text[1024])
    begin
        //IF "Item criteria name 5" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Item criteria name 5"),GLOBALLANGUAGE,Text);
    end;

    local procedure Itemcriterianame4OnFormat(Text: Text[1024])
    begin
        //IF "Item criteria name 4" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Item criteria name 4"),GLOBALLANGUAGE,Text);
    end;

    local procedure Itemcriterianame3OnFormat(Text: Text[1024])
    begin
        //IF "Item criteria name 3" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Item criteria name 3"),GLOBALLANGUAGE,Text);
    end;

    local procedure Itemcriterianame2OnFormat(Text: Text[1024])
    begin
        //IF "Item criteria name 2" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Item criteria name 2"),GLOBALLANGUAGE,Text);
    end;

    local procedure Itemcriterianame1OnFormat(Text: Text[1024])
    begin
        //IF "Item criteria name 1" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Item criteria name 1"),GLOBALLANGUAGE,Text);
    end;

    local procedure Jobcriterianame10OnFormat(Text: Text[1024])
    begin
        //IF "Job criteria name 10" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Job criteria name 10"),GLOBALLANGUAGE,Text);
    end;

    local procedure Jobcriterianame9OnFormat(Text: Text[1024])
    begin
        //IF "Job criteria name 9" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Job criteria name 9"),GLOBALLANGUAGE,Text);
    end;

    local procedure Jobcriterianame8OnFormat(Text: Text[1024])
    begin
        //IF "Job criteria name 8" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Job criteria name 8"),GLOBALLANGUAGE,Text);
    end;

    local procedure Jobcriterianame7OnFormat(Text: Text[1024])
    begin
        //IF "Job criteria name 7" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Job criteria name 7"),GLOBALLANGUAGE,Text);
    end;

    local procedure Jobcriterianame6OnFormat(Text: Text[1024])
    begin
        //IF "Job criteria name 6" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Job criteria name 6"),GLOBALLANGUAGE,Text);
    end;

    local procedure Jobcriterianame5OnFormat(Text: Text[1024])
    begin
        //IF "Job criteria name 5" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Job criteria name 5"),GLOBALLANGUAGE,Text);
    end;

    local procedure Jobcriterianame4OnFormat(Text: Text[1024])
    begin
        //IF "Job criteria name 4" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Job criteria name 4"),GLOBALLANGUAGE,Text);
    end;

    local procedure Jobcriterianame3OnFormat(Text: Text[1024])
    begin
        //IF "Job criteria name 3" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Job criteria name 3"),GLOBALLANGUAGE,Text);
    end;

    local procedure Jobcriterianame2OnFormat(Text: Text[1024])
    begin
        //IF "Job criteria name 2" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Job criteria name 2"),GLOBALLANGUAGE,Text);
    end;

    local procedure Jobcriterianame1OnFormat(Text: Text[1024])
    begin
        //IF "Job criteria name 1" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Job criteria name 1"),GLOBALLANGUAGE,Text);
    end;

    local procedure Freefieldname1OnFormat(Text: Text[1024])
    begin
        //IF "Free field name 1" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Free field name 1"),GLOBALLANGUAGE,Text);
    end;

    local procedure Freedatename1OnFormat(Text: Text[1024])
    begin
        //IF "Free date name 1" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Free date name 1"),GLOBALLANGUAGE,Text);
    end;

    local procedure Freefieldname2OnFormat(Text: Text[1024])
    begin
        //IF "Free field name 2" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Free field name 2"),GLOBALLANGUAGE,Text);
    end;

    local procedure Freedatename2OnFormat(Text: Text[1024])
    begin
        //IF "Free date name 2" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Free date name 2"),GLOBALLANGUAGE,Text);
    end;

    local procedure Freefieldname3OnFormat(Text: Text[1024])
    begin
        //IF "Free field name 3" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Free field name 3"),GLOBALLANGUAGE,Text);
    end;

    local procedure Freedatename3OnFormat(Text: Text[1024])
    begin
        //IF "Free date name 3" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Free date name 3"),GLOBALLANGUAGE,Text);
    end;

    local procedure Freefieldname4OnFormat(Text: Text[1024])
    begin
        //IF "Free field name 4" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Free field name 4"),GLOBALLANGUAGE,Text);
    end;

    local procedure Freedatename4OnFormat(Text: Text[1024])
    begin
        //IF "Free date name 4" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Free date name 4"),GLOBALLANGUAGE,Text);
    end;

    local procedure Freefieldname5OnFormat(Text: Text[1024])
    begin
        //IF "Free field name 5" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Free field name 5"),GLOBALLANGUAGE,Text);
    end;

    local procedure Freedatename5OnFormat(Text: Text[1024])
    begin
        //IF "Free date name 5" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Free date name 5"),GLOBALLANGUAGE,Text);
    end;

    local procedure Freefieldname6OnFormat(Text: Text[1024])
    begin
        //IF "Free field name 6" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Free field name 6"),GLOBALLANGUAGE,Text);
    end;

    local procedure Freecheckname1OnFormat(Text: Text[1024])
    begin
        //IF "Free check name 1" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Free check name 1"),GLOBALLANGUAGE,Text);
    end;

    local procedure Freefieldname7OnFormat(Text: Text[1024])
    begin
        //IF "Free field name 7" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Free field name 7"),GLOBALLANGUAGE,Text);
    end;

    local procedure Freecheckname2OnFormat(Text: Text[1024])
    begin
        //IF "Free check name 2" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Free check name 2"),GLOBALLANGUAGE,Text);
    end;

    local procedure Freefieldname8OnFormat(Text: Text[1024])
    begin
        //IF "Free field name 8" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Free field name 8"),GLOBALLANGUAGE,Text);
    end;

    local procedure Freecheckname3OnFormat(Text: Text[1024])
    begin
        //IF "Free check name 3" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Free check name 3"),GLOBALLANGUAGE,Text);
    end;

    local procedure Freefieldname9OnFormat(Text: Text[1024])
    begin
        //IF "Free field name 9" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Free field name 9"),GLOBALLANGUAGE,Text);
    end;

    local procedure Freecheckname4OnFormat(Text: Text[1024])
    begin
        //IF "Free check name 4" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Free check name 4"),GLOBALLANGUAGE,Text);
    end;

    local procedure Freefieldname10OnFormat(Text: Text[1024])
    begin
        //IF "Free field name 10" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Free field name 10"),GLOBALLANGUAGE,Text);
    end;

    local procedure Freecheckname5OnFormat(Text: Text[1024])
    begin
        //IF "Free check name 5" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Free check name 5"),GLOBALLANGUAGE,Text);
    end;

    local procedure Freevaluename10OnFormat(Text: Text[1024])
    begin
        //IF "Free value name 10" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Free value name 10"),GLOBALLANGUAGE,Text);
    end;

    local procedure Freevaluename9OnFormat(Text: Text[1024])
    begin
        //IF "Free value name 9" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Free value name 9"),GLOBALLANGUAGE,Text);
    end;

    local procedure Freevaluename8OnFormat(Text: Text[1024])
    begin
        //IF "Free value name 8" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Free value name 8"),GLOBALLANGUAGE,Text);
    end;

    local procedure Freevaluename7OnFormat(Text: Text[1024])
    begin
        //IF "Free value name 7" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Free value name 7"),GLOBALLANGUAGE,Text);
    end;

    local procedure Freevaluename6OnFormat(Text: Text[1024])
    begin
        //IF "Free value name 6" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Free value name 6"),GLOBALLANGUAGE,Text);
    end;

    local procedure Freevaluename5OnFormat(Text: Text[1024])
    begin
        //IF "Free value name 5" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Free value name 5"),GLOBALLANGUAGE,Text);
    end;

    local procedure Freevaluename4OnFormat(Text: Text[1024])
    begin
        //IF "Free value name 4" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Free value name 4"),GLOBALLANGUAGE,Text);
    end;

    local procedure Freevaluename3OnFormat(Text: Text[1024])
    begin
        //IF "Free value name 3" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Free value name 3"),GLOBALLANGUAGE,Text);
    end;

    local procedure Freevaluename2OnFormat(Text: Text[1024])
    begin
        //IF "Free value name 2" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Free value name 2"),GLOBALLANGUAGE,Text);
    end;

    local procedure Freevaluename1OnFormat(Text: Text[1024])
    begin
        //IF "Free value name 1" <> '' THEN
        //  Text := wCaptionClassTrans.GetCaptionValue(DATABASE::"Statistics setup",FIELDNO("Free value name 1"),GLOBALLANGUAGE,Text);
    end;
}

