query 50009 Extranet_SalesCR
{

    elements
    {
        dataitem(Sales_Cr_Memo_Header; "Sales Cr.Memo Header")
        {
            column(Sell_to_Customer_No; "Sell-to Customer No.")
            {
            }
            column(No; "No.")
            {
            }
            column(Your_Reference; "Your Reference")
            {
            }
            column(Ship_to_City; "Ship-to City")
            {
            }
            column(Posting_Date; "Posting Date")
            {
            }
            column(Shipment_Date; "Shipment Date")
            {
            }
            column(Due_Date; "Due Date")
            {
            }
            column(Amount; Amount)
            {
                ReverseSign = true;
            }
            column(Amount_Including_VAT; "Amount Including VAT")
            {
                ReverseSign = true;
            }
            column(Remaining_Amount; "Remaining Amount")
            {
            }
        }
    }
}

