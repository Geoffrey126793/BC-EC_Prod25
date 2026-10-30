query 50030 CustLedgEntry2
{

    elements
    {
        dataitem(Cust_Ledger_Entry; "Cust. Ledger Entry")
        {
            DataItemTableFilter = "Customer No." = CONST ('C00304');
            column(Entry_No; "Entry No.")
            {
            }
            column(Customer_No; "Customer No.")
            {
            }
            column(Posting_Date; "Posting Date")
            {
            }
            column(Document_Type; "Document Type")
            {
            }
            column(Document_No; "Document No.")
            {
            }
            column(Description; Description)
            {
            }
            column(Remaining_Amount; "Remaining Amount")
            {
            }
            column(Amount_LCY; "Amount (LCY)")
            {
            }
            column(Due_Date; "Due Date")
            {
            }
            column(Closed_at_Date; "Closed at Date")
            {
            }
        }
    }
}

