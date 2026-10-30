pageextension 70174 pageextension70174 extends "Transfer Order Subform"
{
    actions
    {
        modify("Shipment")
        {
            Visible = false;
        }

        addafter("Shipment")
        {
            Action("Expédition")
            {
                trigger OnAction()
                var
                    TftH: Record "Transfer Header";
                    Text001: Label 'Les lots sont verrouillés';

                begin
                    if TftH.Get(Rec."Document No.") then
                        if TftH."Blocage des lots" then
                            Error(Text001);
                    OpenItemTrackingLines(enum::"Transfer Direction"::Inbound);
                end;
            }
        }

    }

}

