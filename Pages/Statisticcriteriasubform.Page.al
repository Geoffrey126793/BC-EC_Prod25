page 8001311 "Statistic criteria subform"
{
    // //STAT 01/04/10
    // //STATSEXPLORER STATSEXPLORER 20/01/00 Statistic criteria subform

    Caption = 'Lines';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Statistic criteria";
    SourceTableView = SORTING(Type, "Field No.");

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Field No."; "Field No.")
                {
                    Editable = false;
                }
                field("Field name"; "Field name")
                {
                }
                field(Enabled; Enabled)
                {
                }
                field("Process aggregate by dimension"; "Process aggregate by dimension")
                {
                    Visible = false;
                }
                field("Process aggregate by day"; "Process aggregate by day")
                {
                    Visible = false;
                }
                field("Process aggregate by week"; "Process aggregate by week")
                {
                    Visible = false;
                }
                field("Process aggregate by month"; "Process aggregate by month")
                {
                    Visible = false;
                }
                field("Process aggregate by quarter"; "Process aggregate by quarter")
                {
                    Visible = false;
                }
                field("Process aggregate by year"; "Process aggregate by year")
                {
                    Visible = false;
                }
                field("Process aggregate by period"; "Process aggregate by period")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        FieldnameOnFormat(Format("Field name"));
    end;

    [Scope('OnPrem')]
    procedure ShowStatsExplorerFields()
    var
        StatsExplorerFields: Record "StatsExplorer fields";
    begin
        StatsExplorerFields.SetRange("Entry name", "Field name");
        PAGE.RunModal(PAGE::"StatsExplorer Fields", StatsExplorerFields);
    end;

    local procedure FieldnameOnFormat(Text: Text[1024])
    var
        lStatTools: Codeunit "StatsExplorer, Tools";
    begin
        //STAT 01/04/10
        if Type <> Type::Flow then
            //STAT 01/04/10//
            lStatTools.GetTranslateCaption("Field No.", 0, Text);
    end;
}

