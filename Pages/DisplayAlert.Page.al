page 50095 "Display Alert"
{
    Caption = 'Display Alert';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ConfirmationDialog;
    ShowFilter = false;
    SourceTable = "Alert Management";

    layout
    {
        area(content)
        {
            field(Heading; Heading)
            {
                Editable = false;
                MultiLine = false;
                Style = Unfavorable;
                StyleExpr = TRUE;
            }
            repeater(Group)
            {
                field(Date; Date)
                {
                }
                field(Comment; Comment)
                {
                }
            }
        }
    }

    actions
    {
    }

    var
        Heading: Text[50];
        Text000: Label 'Alerts on %1';

    [Scope('OnPrem')]
    procedure SetHeading(ptxt_Heading: Text[30])
    begin
        Heading := StrSubstNo(Text000, ptxt_Heading);
    end;
}

