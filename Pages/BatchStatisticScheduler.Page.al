page 8001319 "Batch Statistic Scheduler"
{
    // //STATSEXPLORER STATSEXPLORER 01/10/00 Batch Statistic Scheduler

    Caption = 'Batch Statistic Scheduler';
    PageType = Card;

    layout
    {
        area(content)
        {
            label(Control1)
            {
                CaptionClass = Text19078634;
                MultiLine = true;
                ShowCaption = false;
                Style = Strong;
                StyleExpr = TRUE;
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        ParametresStatistiques.Get;
        ParametresStatistiques.TestField("Scheduler process from date");
        ParametresStatistiques.TestField("Scheduler process to date");
        Automate.UseRequestPage(false);
        Automate.RunModal;
        CurrPage.Close;
    end;

    var
        Automate: Report "Launch Statistic Scheduler";
        ParametresStatistiques: Record "Statistics setup";
        Text19078634: Label 'This Page allows to launch calculations in batch, and should be associated to a "BATCH" user.';
}

