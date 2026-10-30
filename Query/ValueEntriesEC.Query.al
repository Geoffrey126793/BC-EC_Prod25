query 50004 "Value Entries EC"
{
    Caption = 'Value Entries';

    elements
    {
        dataitem(Value_Entry; "Value Entry")
        {
            DataItemTableFilter = "Posting Date" = FILTER (20190101D ..);
            column(Item_No; "Item No.")
            {
            }
            column(Posting_Date; "Posting Date")
            {
            }
            column(Location_Code; "Location Code")
            {
            }
            column(Cost_Amount_Actual; "Cost Amount (Actual)")
            {
            }
            column(Cost_Amount_Expected; "Cost Amount (Expected)")
            {
            }
        }
    }
}

