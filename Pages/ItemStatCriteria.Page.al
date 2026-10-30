page 8001325 "Item Stat Criteria"
{
    Caption = 'Item Statistics Criteria';
    PageType = Card;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            group("Statistics Criteria")
            {
                Caption = 'Statistics Criteria';
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
        fVisible();
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
        /*
        lVisible := lCaptionClassTrans.Exists(8001302,99030,GLOBALLANGUAGE);
        "Criteria 1Visible" := lVisible;
        lVisible := lCaptionClassTrans.Exists(8001302,99031,GLOBALLANGUAGE);
        "Criteria 2Visible" := lVisible;
        lVisible := lCaptionClassTrans.Exists(8001302,99032,GLOBALLANGUAGE);
        "Criteria 3Visible" := lVisible;
        lVisible := lCaptionClassTrans.Exists(8001302,99033,GLOBALLANGUAGE);
        "Criteria 4Visible" := lVisible;
        lVisible := lCaptionClassTrans.Exists(8001302,99034,GLOBALLANGUAGE);
        "Criteria 5Visible" := lVisible;
        lVisible := lCaptionClassTrans.Exists(8001302,99035,GLOBALLANGUAGE);
        "Criteria 6Visible" := lVisible;
        lVisible := lCaptionClassTrans.Exists(8001302,99036,GLOBALLANGUAGE);
        "Criteria 7Visible" := lVisible;
        lVisible := lCaptionClassTrans.Exists(8001302,99037,GLOBALLANGUAGE);
        "Criteria 8Visible" := lVisible;
        lVisible := lCaptionClassTrans.Exists(8001302,99038,GLOBALLANGUAGE);
        "Criteria 9Visible" := lVisible;
        lVisible := lCaptionClassTrans.Exists(8001302,99039,GLOBALLANGUAGE);
        "Criteria 10Visible" := lVisible;
        *///TRS-2009//

    end;
}

