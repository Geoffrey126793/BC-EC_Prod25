query 50021 "Cmd non livrees"
{

    elements
    {
        dataitem(Sales_Line; "Sales Line")
        {
            column(Sell_to_Customer_No; "Sell-to Customer No.")
            {
            }
            column(Document_No; "Document No.")
            {
            }
            column(Order_No; "Document No.")
            {
            }
            column(Posting_Date; "Requested Delivery Date")
            {
            }
            column(No; "No.")
            {
            }
            column(Description; Description)
            {
            }
            column("Qte_commandée_initiale_Base"; "Qte commandée initiale Base")
            {
            }
            column(Quantity_Base; "Quantity Shipped")
            {
            }
            column(Location_Code; "Location Code")
            {
            }
            dataitem(Sales_Header; "Sales Header")
            {
                DataItemLink = "No." = Sales_Line."Document No.";
                column(Raison_retard; "Raison retard")
                {
                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin
        SetFilter(Posting_Date, '..%1', Today);
    end;
}

