query 50028 PrevVente_WS
{

    elements
    {
        dataitem(Statistic_aggregate; "Statistic aggregate")
        {
            DataItemTableFilter = "Entry Type" = CONST ('Previsions'), "Ending Date" = FILTER (20260101D ..), "Period Length" = CONST (Month);
            column(Ending_Date; "Ending Date")
            {
            }
            column(No; "No.")
            {
            }
            column(Source_Type; "Source Type")
            {
            }
            column(Source_No; "Source No.")
            {
            }
            column(Quantity; Quantity)
            {
            }
            column(Encode; "Free boolean 1")
            {
            }
        }
    }
}

