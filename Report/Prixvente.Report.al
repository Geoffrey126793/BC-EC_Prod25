report 50026 "Prix vente"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/Prixvente.rdlc';
    AdditionalSearchTerms = 'Prix de vente';
    Caption = 'Sales prices';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Customer; Customer)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Country/Region Code";
            column(No_Customer; Customer."No.")
            {
            }
            column(Name_Customer; Customer.Name)
            {
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 .. 2));
                dataitem("Sales Price"; "Sales PriceEC")
                {
                    RequestFilterFields = "Ending Date";
                    column(MinimumQuantity_SalesPrice; "Sales Price"."Minimum Quantity")
                    {
                    }
                    column(CurrencyCode_SalesPrice; "Sales Price"."Currency Code")
                    {
                    }
                    column(EndingDate_SalesPrice; "Sales Price"."Ending Date")
                    {
                    }
                    column(StartingDate_SalesPrice; "Sales Price"."Starting Date")
                    {
                    }
                    column(UnitPrice_SalesPrice; "Sales Price"."Unit Price")
                    {
                    }
                    column(ItemNo_SalesPrice; "Sales Price"."Item No.")
                    {
                    }
                    column(UnitStartPrice_SalesPrice; "Sales Price"."Unit Start Price")
                    {
                    }
                    column(Prix3xNet_SalesPrice; "Sales Price"."Prix 3x Net")
                    {
                    }
                    column(OrderMinimumQuantity_SalesPrice; "Sales Price"."Order Minimum Quantity")
                    {
                    }

                    trigger OnPreDataItem()
                    begin
                        if Integer.Number = 1 then begin
                            "Sales Price".SetRange("Sales Type", "Sales Type"::Customer);
                            "Sales Price".SetRange("Sales Price"."Sales Code", Customer."No.");
                        end;
                        if Integer.Number = 2 then begin
                            "Sales Price".SetRange("Sales Type", "Sales Type"::"Customer Price Group");
                            "Sales Price".SetRange("Sales Price"."Sales Code", Customer."Customer Price Group");
                        end;
                    end;
                }
            }
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
}

