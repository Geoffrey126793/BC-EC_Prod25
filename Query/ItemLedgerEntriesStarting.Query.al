query 50007 "Item Ledger Entries Starting"
{
    Caption = 'Item Ledger Entries';

    elements
    {
        dataitem(Item_Ledger_Entry; "Item Ledger Entry")
        {
            DataItemTableFilter = "Posting Date" = FILTER (< 20190101D);
            column(Item_No; "Item No.")
            {
            }
            column(Location_Code; "Location Code")
            {
            }
            column(Quantity; Quantity)
            {
                Method = Sum;
            }
            column(Invoiced_Quantity; "Invoiced Quantity")
            {
                Method = Sum;
            }
        }
    }
}

