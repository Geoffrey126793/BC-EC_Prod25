report 50085 "Prob cmd"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/Probcmd.rdlc';

    dataset
    {
        dataitem("Sales Line"; "Sales Line")
        {
            DataItemTableView = WHERE("Location Code" = FILTER('ECCONGEL'), "No." = FILTER('1-IQF*'));
            column(QuantityBase_SalesLine; "Sales Line"."Quantity (Base)")
            {
            }
            column(SelltoCustomerNo_SalesLine; "Sales Line"."Sell-to Customer No.")
            {
            }
            column(DocumentNo_SalesLine; "Sales Line"."Document No.")
            {
            }
            column(No_SalesLine; "Sales Line"."No.")
            {
            }
            column(PromisedDeliveryDate_SalesLine; "Sales Line"."Promised Delivery Date")
            {
            }
            column(Dispo; Dispo)
            {
            }
            column(Stock; Dispo + "Sales Line"."Quantity (Base)")
            {
            }
            column(NbrePal; NbrePal)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if not Item.Get("No.") then CurrReport.Skip;

                StockEC := CalcStock.getInventoryCongel(Item);
                StockBlocked := CalcStock.getInventoryBlocked(Item);
                StockLibre := StockEC - StockBlocked;
                StockOnOF := CalcStock.getInventoryOnOFAtDate(Item, "Sales Line"."Promised Delivery Date");
                StockOnSalesConfirmed := CalcStock.getInventoryOnSalesConfirmedCongelAtDate(Item, "Sales Line"."Promised Delivery Date");
                Dispo := StockLibre - StockOnSalesConfirmed + StockOnOF;

                if Dispo >= 0 then CurrReport.Skip;
                NbrePal := 0;
                if Item.PoidsPalette > 0 then
                    NbrePal := (Dispo + "Sales Line"."Quantity (Base)") / Item.PoidsPalette;
            end;

            trigger OnPreDataItem()
            begin
                "Sales Line".SetFilter("Promised Delivery Date", '<>%1&<%2', 0D, CalcDate('<+10D>', Today));
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
        CalcStock: Codeunit "Stock EC";
        Item: Record Item;
        StockEC: Decimal;
        StockBlocked: Decimal;
        StockLibre: Decimal;
        StockOnOF: Decimal;
        StockOnSalesConfirmed: Decimal;
        Dispo: Decimal;
        NbrePal: Decimal;
}

