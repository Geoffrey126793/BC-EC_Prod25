page 50051 "Stats Année client"
{
    PageType = ListPlus;
    SourceTable = Customer;
    UsageCategory = ReportsAndAnalysis;

    layout
    {
        area(content)
        {
            field("Mois en cours (M)"; DtFin)
            {

                trigger OnValidate()
                begin
                    CurrPage.Update();
                end;
            }
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field(Name; Name)
                {
                }
                field("Limite crédit interne"; "Limite crédit interne")
                {
                }
                field("Limite crédit générale"; "Limite crédit générale")
                {
                }
                field("Limite crédit additionnelle"; "Limite crédit additionnelle")
                {
                }
                field("Limite crédit non dénommée"; "Limite crédit non dénommée")
                {
                }
                field("Credit Limit (LCY)"; "Credit Limit (LCY)")
                {
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                }
                field("Payment Terms Code"; "Payment Terms Code")
                {
                }
                field("Délai régl. moyen (jours) N"; "Délai régl. moyen (jours) N")
                {
                }
                field(Total; Total)
                {
                    Caption = 'CA Total';
                }
                field("Totals[1]"; Totals[1])
                {
                    Caption = 'CA M-1';
                }
                field("Totals[2]"; Totals[2])
                {
                    Caption = 'CA M-2';
                }
                field("Totals[3]"; Totals[3])
                {
                    Caption = 'CA M-3';
                }
                field("Totals[4]"; Totals[4])
                {
                    Caption = 'CA M-4';
                }
                field("Totals[5]"; Totals[5])
                {
                    Caption = 'CA M-5';
                }
                field("Totals[6]"; Totals[6])
                {
                    Caption = 'CA M-6';
                }
                field("Totals[7]"; Totals[7])
                {
                    Caption = 'CA M-7';
                }
                field("Totals[8]"; Totals[8])
                {
                    Caption = 'CA M-8';
                }
                field("Totals[9]"; Totals[9])
                {
                    Caption = 'CA M-9';
                }
                field("Totals[10]"; Totals[10])
                {
                    Caption = 'CA M-10';
                }
                field("Totals[11]"; Totals[11])
                {
                    Caption = 'CA M-11';
                }
                field("Totals[12]"; Totals[12])
                {
                    Caption = 'CA M-12';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        i: Integer;
        DtStart: Date;
    begin
        DtStart := DtFin;
        Clear(Totals);
        Clear(Total);
        for i := 1 to 12 do begin
            Rec.SetRange("Date Filter", DtStart, CalcDate('<CM>', DtStart));
            DtStart := CalcDate('<-1M>', DtStart);
            Rec.CalcFields("Sales (LCY)");
            Totals[i] := Rec."Sales (LCY)";
            Total += Totals[i];
        end;
    end;

    trigger OnInit()
    begin
        DtFin := DMY2Date(1, Date2DMY(Today, 2), Date2DMY(Today, 3));
        DtFin := CalcDate('<-1M>', DtFin);
    end;

    var
        Totals: array[12] of Decimal;
        Total: Decimal;
        DtFin: Date;
}

