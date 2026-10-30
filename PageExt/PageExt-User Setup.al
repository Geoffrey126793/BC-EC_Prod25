pageextension 70016 pageextension70016 extends "User Setup"
{
    layout
    {
        addafter("Sales Resp. Ctr. Filter")
        {
            field("Resp. Centrer Filter"; "Resp. Centrer Filter")
            {
            }
        }
    }

    trigger OnOpenPage()
    begin
        HideExternalUsers;
        CurrPage.Editable(StrPos(UpperCase(UserId), 'COMPTABILITE') > 0);
    end;

}

