query 50006 "Item Ledger Entries EC"
{
    Caption = 'Item Ledger Entries';

    elements
    {
        dataitem(Item_Ledger_Entry; "Item Ledger Entry")
        {
            DataItemTableFilter = "Posting Date" = FILTER (20190101D ..);
            column(Item_No; "Item No.")
            {
            }
            column(Lot_No; "Lot No.")
            {
            }
            column(Posting_Date; "Posting Date")
            {
            }
            column(Document_No; "Document No.")
            {
            }
            column(Location_Code; "Location Code")
            {
            }
            column(Quantity; Quantity)
            {
            }
            column(Entry_Type; "Entry Type")
            {
            }
            column(Invoiced_Quantity; "Invoiced Quantity")
            {
            }
            column(Entry_No; "Entry No.")
            {
            }
        }
    }
}

