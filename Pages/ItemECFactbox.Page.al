page 50030 "Item EC Factbox"
{
    Caption = 'Item EC Factbox';
    PageType = CardPart;
    SourceTable = Item;

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
                    CalcStock.showInventory(Rec);
                end;
            }
            field(StockEC; StockEC)
            {
                Caption = 'Stock magasins EC';

                trigger OnDrillDown()
                begin
                    CalcStock.showInventoryEC(Rec);
                end;
            }
            field(StockBlocked; StockBlocked)
            {
                Caption = 'Stock bloqué';

                trigger OnDrillDown()
                begin
                    CalcStock.showInventoryBlocked(Rec);
                end;
            }
            field(StockOnPurch; StockOnPurch)
            {
                Caption = 'Quantité sur achats';

                trigger OnDrillDown()
                begin
                    CalcStock.showInventoryOnPurchase(Rec);
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
                    CalcStock.showInventoryOnOF(Rec);
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
                    CalcStock.showInventoryOnComponent(Rec);
                end;
            }
            field(StockOnSalesConfirmed; StockOnSalesConfirmed)
            {
                Caption = 'Ventes confirmées';

                trigger OnDrillDown()
                begin
                    CalcStock.showInventoryOnSalesConfirmed(Rec);
                end;
            }
            field(DispoConfirmed; DispoConfirmed)
            {
                Caption = 'Stock confirmé';
                Style = Strong;
                StyleExpr = true;
            }
            field(StockOnSales; StockOnSales)
            {
                Caption = 'Quantité sur vente';

                trigger OnDrillDown()
                begin
                    CalcStock.showInventoryOnSales(Rec);
                end;
            }
            field(Dispo; Dispo)
            {
                Caption = 'Disponibilité';
            }
            field(Interm5; Interm5)
            {
                Caption = '5 Intermédiaire';
            }
            field(Interm5Stock; Interm5Stock)
            {
                Caption = '5 Intermédiaire stock';

                trigger OnDrillDown()
                begin
                    CalcStock.ShowIntermediaireStock(Rec);
                end;
            }
            field("Reserved Qty. on Inventory"; "Reserved Qty. on Inventory")
            {
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Stock := CalcStock.getInventory(Rec);
        StockEC := CalcStock.getInventoryEC(Rec);
        StockBlocked := CalcStock.getInventoryBlocked(Rec);
        StockOnSales := CalcStock.getInventoryOnSales(Rec);
        StockOnPurch := CalcStock.getInventoryOnPurchase(Rec);
        StockOnOF := CalcStock.getInventoryOnOF(Rec);
        StockOnComponents := CalcStock.getInventoryOnComponent(Rec);
        Dispo := StockEC - StockBlocked - StockOnSales + StockOnPurch + StockOnOF - StockOnComponents;

        StockOnSalesConfirmed := CalcStock.getInventoryOnSalesConfirmed(Rec);
        DispoConfirmed := StockEC - StockBlocked - StockOnSalesConfirmed + StockOnPurch + StockOnOF - StockOnComponents;

        Interm5 := CalcStock.getIntermediaireNo(Rec);
        Interm5Stock := CalcStock.getIntermediaireStock(Rec, Today);
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
}

