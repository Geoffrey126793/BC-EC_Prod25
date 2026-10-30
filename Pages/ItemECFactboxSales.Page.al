page 50036 "Item EC Factbox Sales"
{
    Caption = 'Item EC Factbox';
    PageType = CardPart;
    SourceTable = "Sales Line";

    layout
    {
        area(content)
        {
            field("No."; "No.")
            {
            }
            field(Stock; Stock)
            {
                Caption = 'Stock';

                trigger OnDrillDown()
                begin
                    CalcStock.showInventory(Item);
                end;
            }
            field(StockEC; StockEC)
            {
                Caption = '<Stock  EC>';

                trigger OnDrillDown()
                begin
                    CalcStock.showInventoryEC(Item);
                end;
            }
            field(StockBlocked; StockBlocked)
            {
                Caption = 'Stock bloqué';

                trigger OnDrillDown()
                begin
                    CalcStock.showInventoryBlocked(Item);
                end;
            }
            field(StockLibre; StockLibre)
            {
                Caption = 'Stock libre';
                Style = Favorable;
                StyleExpr = TRUE;
            }
            field(StockOnPurch; StockOnPurch)
            {
                Caption = 'Quantité sur achats';

                trigger OnDrillDown()
                begin
                    CalcStock.showInventoryOnPurchase(Item);
                end;

                trigger OnLookup(var Text: Text): Boolean
                var
                    PurchL: Record "Purchase Line";
                begin
                end;
            }
            field(StockOnOF; StockOnOF)
            {
                Caption = 'Quantité prévue en production';

                trigger OnDrillDown()
                begin
                    CalcStock.showInventoryOnOF(Item);
                end;

                trigger OnLookup(var Text: Text): Boolean
                var
                    ProdL: Record "Prod. Order Line";
                begin
                end;
            }
            field(StockOnComponents; StockOnComponents)
            {
                Caption = 'Quantité prévue en consommation';

                trigger OnDrillDown()
                begin
                    CalcStock.showInventoryOnComponent(Item);
                end;
            }
            field(StockOnSalesConfirmed; StockOnSalesConfirmed)
            {
                Caption = 'Ventes confirmées';

                trigger OnDrillDown()
                begin
                    CalcStock.showInventoryOnSalesConfirmed(Item);
                end;
            }
            field(DispoConfirmed; DispoConfirmed)
            {
                Caption = 'Disponibilités après confirmation';
                Style = StrongAccent;
                StyleExpr = TRUE;
            }
            field(StockOnSales; StockOnSales)
            {
                Caption = 'Ventes non onfirmées';

                trigger OnDrillDown()
                begin
                    CalcStock.showInventoryOnSales(Item);
                end;
            }
            field(Dispo; Dispo)
            {
                Caption = 'Disponibilité';
                Style = Unfavorable;
                StyleExpr = TRUE;
            }
            field(Interm5; Interm5)
            {
                Caption = 'Intermédiaire';
            }
            field(Interm5Stock; Interm5Stock)
            {
                Caption = 'Intermédiaire stock';

                trigger OnDrillDown()
                begin
                    CalcStock.ShowIntermediaireStock(Item);
                end;
            }
            field(Interm5Delivery; Interm5Delivery)
            {
                Caption = 'inter stock à date exp.';
            }
            field(Interm5Prod; Interm5Prod)
            {
                Caption = 'inter stock à date prod.';
            }
            field("Qté réappro"; QtyReappro)
            {
            }
            field("Conso 5 (15J)"; "Conso5-15D")
            {
            }
            field("Delai production"; Item."Delai production")
            {
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        if Item.Get("No.") then begin
            if CopyStr(Item."No.", 1, 5) = '1-IQF' then begin
                Stock := CalcStock.getInventory(Item);
                StockEC := CalcStock.getInventoryCongel(Item);
                StockBlocked := CalcStock.getInventoryBlockedCongel(Item);
                StockLibre := StockEC - StockBlocked;
                if Rec."Promised Delivery Date" <> 0D then
                    StockOnOF := CalcStock.getInventoryOnOFAtDate(Item, Rec."Promised Delivery Date")
                else
                    StockOnOF := CalcStock.getInventoryOnOFAtDate(Item, Rec."Requested Delivery Date");

                StockOnSales := CalcStock.getInventoryOnSalesCongel(Item);
                StockOnSalesConfirmed := CalcStock.getInventoryOnSalesConfirmedCongel(Item);

                Dispo := StockEC - StockOnSalesConfirmed + StockOnOF - StockBlocked;

                QtyReappro := Item."Reorder Quantity";
            end
            else begin
                Stock := CalcStock.getInventory(Item);
                StockEC := CalcStock.getInventoryEC(Item);
                StockBlocked := CalcStock.getInventoryBlocked(Item);
                StockOnSales := CalcStock.getInventoryOnSales(Item);
                StockOnPurch := CalcStock.getInventoryOnPurchase(Item);
                if Rec."Promised Delivery Date" <> 0D then
                    StockOnOF := CalcStock.getInventoryOnOFAtDate(Item, Rec."Promised Delivery Date")
                else
                    StockOnOF := CalcStock.getInventoryOnOFAtDate(Item, Rec."Requested Delivery Date");

                StockOnComponents := CalcStock.getInventoryOnComponent(Item);
                Dispo := StockEC - StockBlocked - StockOnSales + StockOnPurch + StockOnOF - StockOnComponents;

                StockOnSalesConfirmed := CalcStock.getInventoryOnSalesConfirmed(Item);
                DispoConfirmed := StockEC - StockBlocked - StockOnSalesConfirmed + StockOnPurch + StockOnOF - StockOnComponents;

                Interm5 := CalcStock.getIntermediaireNo(Item);
                Interm5Stock := CalcStock.getIntermediaireStock(Item, Today);

                Interm5Delivery := CalcStock.getIntermediaireStock(Item, Rec."Promised Delivery Date");
                Interm5Prod := CalcStock.getIntermediaireStock(Item, Rec."Date de production");

                QtyReappro := Item."Reorder Quantity";
                "Conso5-15D" := CalcStock.getConsoMoy15D(Item);

            end;
        end;
    end;

    var
        CalcStock: Codeunit "Stock EC";
        Dispo: Decimal;
        Stock: Decimal;
        StockEC: Decimal;
        StockBlocked: Decimal;
        StockOnSales: Decimal;
        StockOnPurch: Decimal;
        StockOnOF: Decimal;
        StockOnComponents: Decimal;
        ItemLedg: Record "Item Ledger Entry";
        StockOnSalesConfirmed: Decimal;
        DispoConfirmed: Decimal;
        Interm5Stock: Decimal;
        Interm5: Code[20];
        Interm5Delivery: Decimal;
        Interm5Prod: Decimal;
        Item: Record Item;
        QtyReappro: Decimal;
        "Conso5-15D": Decimal;
        StockLibre: Decimal;
}

