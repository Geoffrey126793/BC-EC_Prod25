pageextension 70179 pageextension70179 extends "Value Entries"
{
    layout
    {
        modify("Sales Amount (Expected)")
        {
            Visible = ShowCost;
        }
        modify("Sales Amount (Actual)")
        {
            Visible = ShowCost;
        }
        modify("User ID")
        {
            Visible = true;
        }

    }
    var
        AB6Tool: Codeunit "Absys - tools PJ";
        ShowCost: Boolean;

    trigger OnOpenPage()
    begin
        ShowCost := AB6Tool.GetRole('COUT');
    end;
}

