page 8001323 "StatsExplorer Fields"
{
    // //STATSEXPLORER STATSEXPLORER 01/01/01 StatsExplorer fields for totals in aggregates

    Caption = 'Section levels';
    DataCaptionFields = "Entry name";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "StatsExplorer fields";
    SourceTableView = WHERE(Available = FILTER(true));

    layout
    {
        area(content)
        {
            repeater(Control1180040000)
            {
                ShowCaption = false;
                field("Entry No"; "Entry No")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Entry name"; "Entry name")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Field No"; "Field No")
                {
                    Editable = false;
                }
                field(FieldCaptionText; FieldCaptionText)
                {
                    CaptionClass = FieldCaption("Field Caption");
                    Editable = false;
                }
                field(Enabled; Enabled)
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
        FieldCaptionText := Format("Field Caption");
        FieldCaptionTextOnFormat(FieldCaptionText);
    end;

    var
        FieldCaptionText: Text[1024];

    local procedure FieldCaptionTextOnFormat(var Text: Text[1024])
    var
        lStatTools: Codeunit "StatsExplorer, Tools";
    begin
        lStatTools.GetTranslateCaption("Field No", 0, Text);
    end;
}

