report 50096 "Clients ne commandant plus"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/Clientsnecommandantplus.rdlc';
    Caption = 'Customers without orders';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = WHERE("Intervalle de commande" = FILTER(> 0));
            column(No_Customer; Customer."No.")
            {
            }
            column(Name_Customer; Customer.Name)
            {
            }
            column(Intervalledecommande_Customer; Customer."Intervalle de commande")
            {
            }
            column(LastDt; LastDt)
            {
            }
            column(CountryRegionCode_Customer; Customer."Country/Region Code")
            {
            }

            trigger OnAfterGetRecord()
            begin
                LastDt := 20190101D;
                Cmd.Reset;
                Cmd.SetRange("Sell-to Customer No.", "No.");
                Cmd.SetRange("Document Type", Cmd."Document Type"::Order);
                if Cmd.FindLast then begin
                    LastDt := Cmd."Order Date";
                end;
                Exp.Reset;
                Exp.SetRange("Sell-to Customer No.", "No.");
                if Exp.FindLast then
                    if LastDt < Exp."Posting Date" then
                        LastDt := Exp."Posting Date";

                //Nbre J depuis derniere commande > intervalle (en jours) * 2
                if (Today - LastDt) < Customer."Intervalle de commande" * 7 * 2 then
                    CurrReport.Skip;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        LastDt: Date;
        Cmd: Record "Sales Header";
        Exp: Record "Sales Shipment Header";
}

