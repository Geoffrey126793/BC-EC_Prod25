pageextension 70248 pageextension70248 extends "Purchase Agent Activities"
{
    layout
    {
        modify("Purchase Orders - Authorize for Payment")
        {
            Visible = false;
        }
        addfirst("Pre-arrival Follow-up on Purchase Orders")
        {
            field("Depart ajd"; "Depart ajd")
            {
                Caption = 'Reste à envoyer aujourd''hui';
            }
            field("OTS ajd"; "OTS ajd")
            {
                Caption = 'OTS  restants aujourd''hui';
            }
            field("Préparations demain"; "Préparations demain")
            {
                Caption = 'Préparations à faire pour demain';
            }
            field("Préparations demain OK"; "Préparations demain OK")
            {
                Caption = 'Préparations déjà faites pour demain';
            }
        }
    }

    var
        d: Date;


    trigger OnOpenPage()
    begin
        SetFilter("Date Filter Today", '%1', WorkDate);
        d := CalcDate('<+1D>', WorkDate);
        while (Date2DWY(d, 1) = 6) or (Date2DWY(d, 1) = 7) do
            d := CalcDate('<+1D>', d);
        SetFilter("DateFilter Demain ouvre", '%1', d);
        SetFilter("User ID Filter", UserId);
    end;
}

