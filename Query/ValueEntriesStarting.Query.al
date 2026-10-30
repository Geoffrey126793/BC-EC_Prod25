query 50005 "Value Entries Starting"
{
    Caption = 'Value Entries';

    elements
    {
        dataitem(Value_Entry; "Value Entry")
        {
            DataItemTableFilter = "Posting Date" = FILTER (< 20190101D);
            column(Item_No; "Item No.")
            {
            }
            column(Posting_Date; "Posting Date")
            {
                Method = Year;
            }
            column(Location_Code; "Location Code")
            {
            }
            column(Cost_Amount_Actual; "Cost Amount (Actual)")
            {
                Method = Sum;
            }
            column(Cost_Amount_Expected; "Cost Amount (Expected)")
            {
                Method = Sum;
            }
        }
    }
}

