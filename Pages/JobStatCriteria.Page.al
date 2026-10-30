page 8001324 "Job Stat Criteria"
{
    Caption = 'Job Statistic Criteria';
    PageType = Card;
    SourceTable = Job;

    layout
    {
        area(content)
        {
            group(Control800390000)
            {
                //The property 'Caption' cannot be empty.
                //Caption = '';
                ShowCaption = false;
                field("Criteria 1"; "Criteria 1")
                {
                    Visible = "Criteria 1Visible";
                }
                field("Criteria 2"; "Criteria 2")
                {
                    Visible = "Criteria 2Visible";
                }
                field("Criteria 3"; "Criteria 3")
                {
                    Visible = "Criteria 3Visible";
                }
                field("Criteria 4"; "Criteria 4")
                {
                    Visible = "Criteria 4Visible";
                }
                field("Criteria 5"; "Criteria 5")
                {
                    Visible = "Criteria 5Visible";
                }
                field("Criteria 6"; "Criteria 6")
                {
                    Visible = "Criteria 6Visible";
                }
                field("Criteria 7"; "Criteria 7")
                {
                    Visible = "Criteria 7Visible";
                }
                field("Criteria 8"; "Criteria 8")
                {
                    Visible = "Criteria 8Visible";
                }
                field("Criteria 9"; "Criteria 9")
                {
                    Visible = "Criteria 9Visible";
                }
                field("Criteria 10"; "Criteria 10")
                {
                    Visible = "Criteria 10Visible";
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        "Criteria 10Visible" := true;
        "Criteria 9Visible" := true;
        "Criteria 8Visible" := true;
        "Criteria 7Visible" := true;
        "Criteria 6Visible" := true;
        "Criteria 5Visible" := true;
        "Criteria 4Visible" := true;
        "Criteria 3Visible" := true;
        "Criteria 2Visible" := true;
        "Criteria 1Visible" := true;
    end;

    trigger OnOpenPage()
    begin
        //TRS-2009
        fVisible();
        //TRS-2009//
    end;

    var

        "Criteria 1Visible": Boolean;

        "Criteria 2Visible": Boolean;

        "Criteria 3Visible": Boolean;

        "Criteria 4Visible": Boolean;

        "Criteria 5Visible": Boolean;

        "Criteria 6Visible": Boolean;

        "Criteria 7Visible": Boolean;

        "Criteria 8Visible": Boolean;

        "Criteria 9Visible": Boolean;

        "Criteria 10Visible": Boolean;

    [Scope('OnPrem')]
    procedure fVisible()
    var
        lVisible: Boolean;
        lCaptionClassTrans: Record "Batch Treatment";
    begin
        //TRS-2009
        //TRS-2009//
    end;
}

