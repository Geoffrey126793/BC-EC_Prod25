report 50081 "Rupture StockMP1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/RuptureStockMP1.rdlc';

    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            DataItemTableView = SORTING("Starting Date") WHERE(Status = FILTER(Released));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Due Date";
            column(SourceNo_ProductionOrder; "Production Order"."Source No.")
            {
            }
            column(No_ProductionOrder; "Production Order"."No.")
            {
            }
            column(StartingDate_ProductionOrder; "Production Order"."Starting Date")
            {
            }
            dataitem("Prod. Order Component"; "Prod. Order Component")
            {
                DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("No.");
                column(ItemNo_ProdOrderComponent; "Prod. Order Component"."Item No.")
                {
                }
                column(ExpectedQuantity_ProdOrderComponent; "Prod. Order Component"."Expected Quantity")
                {
                }
                column(Stock; Stock)
                {
                }

                trigger OnAfterGetRecord()
                var
                    recItem: Record Item;
                begin
                    if StrPos("Prod. Order Component"."Item No.", '8-GAZ') > 0 then
                        CurrReport.Skip;
                    if StrPos("Prod. Order Component"."Item No.", '9-DIV') > 0 then
                        CurrReport.Skip;
                    if StrPos("Prod. Order Component"."Item No.", '7-C') > 0 then
                        CurrReport.Skip;
                    Stock := 0;
                    recItem.Get("Prod. Order Component"."Item No.");
                    if recItem.IsMfgItem then
                        CurrReport.Skip;

                    Stock := CUStock.getStockAtDate("Prod. Order Component"."Item No.", "Production Order"."Starting Date");
                    //MESSAGE('%1  %2  %3',"Prod. Order Component"."Item No.",Stock, "Production Order"."Starting Date");
                    if (Stock >= 0) then
                        CurrReport.Skip
                    else
                        CuWS.SetAlerte("Production Order"."No.", "Prod. Order Component"."Item No.");
                end;
            }

            trigger OnPreDataItem()
            begin
                "Production Order".SetFilter("Starting Date", '%1..', CalcDate('<+1D>', Today));
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
        CUStock: Codeunit "Stock EC";
        Stock: Decimal;
        CuWS: Codeunit "Call WS";
}

