pageextension 70247 pageextension70247 extends "Shop Supervisor Activities"
{
    layout
    {
        modify("Prod. Orders Routings-in Queue")
        {

            Visible = false;
        }
        modify("Prod. Orders Routings-in Prog.")
        {
            Visible = false;
        }
        modify("Planned Prod. Orders - All")
        {
            Visible = false;
        }
        modify("Firm Plan. Prod. Orders - All")
        {
            Visible = false;
        }
        modify("Warehouse Documents")
        {
            Visible = false;
        }
        modify("Invt. Picks to Production")
        {
            Visible = false;
        }
        modify("Invt. Put-aways from Prod.")
        {
            Visible = false;
        }
        addfirst("Production Orders")
        {
            field("OF Fait ajd"; "OF Fait ajd")
            {
                Caption = 'O.F. du jour terminés';
            }
            field("OF A Faire ajd"; "OF A Faire ajd")
            {
                Caption = 'O.F. du jour à faire';
            }
            field("OF demain"; "OF demain")
            {
                Caption = 'O.F. pour demain';
            }
        }
        addafter("Prod. Orders Routings-in Queue")
        {
            field("OTS ajd"; "OTS ajd")
            {
                Caption = 'OTS restants du jour';
            }
        }
    }

    var
        d: Date;


    trigger OnOpenPage()
    begin
        SetFilter("Date Filter", '>=%1', WorkDate);
        SetFilter("Date Filter Today", '%1', WorkDate);
        d := CalcDate('<+1D>', WorkDate);

        while (Date2DWY(d, 1) = 7) do
            d := CalcDate('<+1D>', d);
        SetFilter("DateFilter Demain ouvre", '%1', d);
    end;
}

