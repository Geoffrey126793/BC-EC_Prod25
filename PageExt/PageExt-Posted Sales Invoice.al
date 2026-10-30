pageextension 70022 pageextension70022 extends "Posted Sales Invoice"
{
    layout
    {


    }
    actions
    {
        modify(SendCustom)
        {
            Visible = false;
        }
        addafter(Email)
        {
            action("Fichier Peppol")
            {
                Caption = 'Fichier Peppol';

                trigger OnAction()
                var
                    cueinvoice: Codeunit Trigger_einvoice;
                begin
                    cueinvoice.GetInvoicePeppolFile(Rec);
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

