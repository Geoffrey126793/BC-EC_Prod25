report 50006 "Déclaration Coface"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/DéclarationCoface.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = WHERE("Salesperson Code" = FILTER(<> '' & <> '1'));
            RequestFilterFields = "No.";
            column(SalesLCY_Customer; Customer."Sales (LCY)")
            {
            }
            column(CreditLimitLCY_Customer; Customer."Limite crédit générale")
            {
            }
            column(EncoursMax; EncoursMax)
            {
            }
            column(DtEnCoursMax; DtEnCoursMax)
            {
            }
            column(DtDebut; DtDebut)
            {
            }
            column(Dtfin; Dtfin)
            {
            }
            column(Name_Customer; Customer.Name)
            {
            }
            column(No_Customer; Customer."No.")
            {
            }
            column(CountryRegionCode_Customer; Customer."Country/Region Code")
            {
            }
            column(Groupe; Customer."Criteria 5")
            {
            }

            trigger OnAfterGetRecord()
            begin
                Customer.SetFilter("Date Filter", '%1..%2', DtDebut, Dtfin);
                Customer.CalcFields("Sales (LCY)");
                if Customer."Sales (LCY)" = 0 then CurrReport.Skip;

                EncoursMax := 0;
                DtEnCoursMax := 0D;
                recCust.Get("No.");
                recDt.Reset;
                recDt.SetRange("Period Type", recDt."Period Type"::Date);
                recDt.SetRange("Period Start", DtDebut, Dtfin);
                if recDt.FindSet then
                    repeat
                        recCust.SetFilter("Date Filter", '..%1', recDt."Period Start");
                        recCust.CalcFields("Net Change (LCY)");
                        if recCust."Net Change (LCY)" > EncoursMax then begin
                            EncoursMax := recCust."Net Change (LCY)";
                            DtEnCoursMax := recDt."Period Start";
                        end;
                    //  MESSAGE('%1   %2    %3   %4',recDt."Period Start",recCust."Net Change (LCY)",EncoursMax,recCust.GETFILTER("Date Filter"));
                    until recDt.Next = 0;
            end;

            trigger OnPreDataItem()
            begin
                if (DtDebut = 0D) or (Dtfin = 0D) then
                    Error('Veuillez indiquer les dates');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Date début"; DtDebut)
                {
                }
                field("Date fin"; Dtfin)
                {
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        DtDebut: Date;
        Dtfin: Date;
        EncoursMax: Decimal;
        DtEnCoursMax: Date;
        recDt: Record Date;
        recCust: Record Customer;
}

