query 50017 "Stock by Lot"
{

    elements
    {
        dataitem(Item_Ledger_Entry; "Item Ledger Entry")
        {
            column(Item_No; "Item No.")
            {
            }
            column(Location_Code; "Location Code")
            {
            }
            column(Lot_No; "Lot No.")
            {
            }
            column(Sum_Quantity; Quantity)
            {
                ColumnFilter = Sum_Quantity = FILTER (<> 0);
                Method = Sum;
            }
        }
    }
}

