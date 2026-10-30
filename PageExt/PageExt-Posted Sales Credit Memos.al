pageextension 70036 pageextension70036 extends "Posted Sales Credit Memos"
{
    layout
    {
        modify(Paid)
        {
            Visible = false;
        }
        modify(Amount)
        {
            Visible = false;
        }
        modify("Sell-to Country/Region Code")
        {
            visible = true;
        }

        modify("Document Date")
        {
            visible = true;
        }

        addafter("Shortcut Dimension 2 Code")
        {
            field("Reason Code"; "Reason Code")
            {
            }
        }
    }

    var
        UserSetup: Record "User Setup";


    trigger OnOpenPage()
    begin
        if (UserSetup.Get(UserId)) and (UserSetup."Resp. Centrer Filter" <> '') then begin
            FilterGroup(2);
            SetFilter("Salesperson Code", UserSetup."Resp. Centrer Filter");
            FilterGroup(0);
        end;
    end;
}

