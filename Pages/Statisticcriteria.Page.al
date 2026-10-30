page 8001301 "Statistic criteria"
{
    // //STAT 01/04/10
    // //STATSEXPLORER STATSEXPLORER 20/01/00 StatsExplorer setup

    Caption = 'Statistic criteria';
    PageType = List;
    SourceTable = "Statistic criteria";
    SourceTableView = SORTING (Type, "Field No.")
                      WHERE (Enabled = FILTER (true));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                Editable = false;
                ShowCaption = false;
                field("Field name"; "Field name")
                {
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

    local procedure FieldnameOnFormat(Text: Text[1024])
    var
        lStatTools: Codeunit "StatsExplorer, Tools";
    begin
        //STAT 01/04/10
        //IF Type <> Type::Flow THEN
        //STAT 01/04/10//
        //  lStatTools.GetTranslateCaption("Field No.",0,Text);
    end;
}

