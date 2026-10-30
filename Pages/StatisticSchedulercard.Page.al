page 8001316 "Statistic Scheduler card"
{
    // //STATSEXPLORER STATSEXPLORER 01/08/00 Statistic Scheduler card

    Caption = 'Statistic Scheduler card';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Statistic Scheduler header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code"; Code)
                {
                }
                field(Description; Description)
                {
                }
                field("Last calculation date"; "Last calculation date")
                {
                }
                field("Frequency of calculation"; "Frequency of calculation")
                {
                }
                field("Process agregate"; "Process agregate")
                {
                }
                field("Process from date"; "Process from date")
                {
                }
                field("Process to date"; "Process to date")
                {
                }
                field(TypeTreatment; "Type of treatment")
                {
                    Enabled = TypeTreatmentEnable;
                    Visible = TypeTreatmentVisible;
                }
                field(TextBasePeriode; "Period total basis")
                {
                    Enabled = TextBasePeriodeEnable;
                    Visible = TextBasePeriodeVisible;
                }
            }
            part(Lines; "Statistic Scheduler subform")
            {
                SubPageLink = "Code treatment" = FIELD(Code);
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Statistic")
            {
                Caption = '&Statistic';
                action("&Users")
                {
                    Caption = '&Users';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        //RTC-2009 -- VERSION 6.01
                        fShowUsers();
                        //RTC-2009 -- VERSION 6.01//
                    end;
                }
            }
            group(Schedule)
            {
                Caption = 'Schedule';
                action("&Start")
                {
                    Caption = '&Start';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ReportAutomate: Report "Launch Statistic Scheduler";
                    begin
                        ReportAutomate.InitRequete(Code);
                        ReportAutomate.RunModal;
                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        TypeTreatmentEnable := true;
        TextBasePeriodeEnable := true;
        TypeTreatmentVisible := true;
        TextBasePeriodeVisible := true;
    end;

    trigger OnOpenPage()
    var
        lOk: Boolean;
        lOK2: Boolean;
    begin
        ParametresStatistiques.Get;
        lOk := (ParametresStatistiques."Allow Changes in Period Length") and
               (ParametresStatistiques."Period total basis" <>
               ParametresStatistiques."Period total basis"::"According to every flow");
        lOK2 := ParametresStatistiques."Aggregate, real time update";

        TextBasePeriodeEnable := lOk;
        TypeTreatmentEnable := lOK2;

    end;

    var
        ParametresStatistiques: Record "Statistics setup";

        TextBasePeriodeVisible: Boolean;

        TypeTreatmentVisible: Boolean;

        TextBasePeriodeEnable: Boolean;

        TypeTreatmentEnable: Boolean;

    [Scope('OnPrem')]
    procedure fShowUsers()
    begin
        //RTC-2009 -- VERSION 6.01
        CurrPage.Lines.PAGE.Users;
        //RTC-2009 -- VERSION 6.01//
    end;
}

