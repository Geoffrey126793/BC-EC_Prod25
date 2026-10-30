query 50093 ProductionLotPBI
{
    QueryType = Normal;

    elements
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            DataItemTableFilter =
                "Entry Type" = const (Output);

            column(Order_No; "Order No.")
            {
            }

            column(Order_Line_No; "Order Line No.")
            {
            }

            column(Lot_No; "Lot No.")
            {
            }
            column(Posting_Date; "Posting Date")
            {
            }
            column(Quantity; Quantity)
            {
                Method = Sum;
            }
        }
    }
}
