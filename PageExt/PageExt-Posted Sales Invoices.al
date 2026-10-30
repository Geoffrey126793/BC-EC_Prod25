pageextension 70035 pageextension70035 extends "Posted Sales Invoices"
{
    layout
    {
        modify("No.")
        {
            Width = 15;
        }

        modify("Sell-to Country/Region Code")
        {
            visible = true;
        }

        modify("Posting Date")
        {
            visible = true;
        }

        addafter("Posting Date")
        {
            field("Shipment No."; "Shipment No.")
            {
            }
        }
    }
    actions
    {
        modify(SendCustom)
        {
            Visible = false;
        }
        addafter(Email)
        {
            action("Envoyer par lot")
            {
                Caption = 'Envoyer par lot';
                Image = SendToMultiple;
                Promoted = true;
                PromotedCategory = Category7;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SalesInvHeader: Record "Sales Invoice Header";
                begin
                    CurrPage.SetSelectionFilter(SalesInvHeader);
                    REPORT.RunModal(50097, true, false, SalesInvHeader);
                end;
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

