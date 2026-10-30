query 50025 SalesInvoiceLines
{

    elements
    {
        dataitem(Sales_Invoice_Line; "Sales Invoice Line")
        {
            DataItemTableFilter = "Posting Date" = FILTER (<> 0D);
            column(Sell_to_Customer_No; "Sell-to Customer No.")
            {
            }
            column(Document_No; "Document No.")
            {
            }
            column(Type; Type)
            {
            }
            column(No; "No.")
            {
            }
            column(Location_Code; "Location Code")
            {
            }
            column(Description; Description)
            {
            }
            column(Unit_of_Measure; "Unit of Measure")
            {
            }
            column(Amount; Amount)
            {
            }
            column(Order_No; "Order No.")
            {
            }
            column(Posting_Date; "Posting Date")
            {
            }
            column(Dimension_Set_ID; "Dimension Set ID")
            {
            }
            column(Quantity_Base; "Quantity (Base)")
            {
            }
        }
    }
}

