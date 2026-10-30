query 50020 "Differences livraison"
{

    elements
    {
        dataitem(Sales_Shipment_Line; "Sales Shipment Line")
        {
            column(Sell_to_Customer_No; "Sell-to Customer No.")
            {
            }
            column(Document_No; "Document No.")
            {
            }
            column(Order_No; "Order No.")
            {
            }
            column(Posting_Date; "Posting Date")
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
            column(Quantity_Base; "Quantity (Base)")
            {
            }
            column(Location_Code; "Location Code")
            {
            }
            dataitem(Sales_Shipment_Header; "Sales Shipment Header")
            {
                DataItemLink = "No." = Sales_Shipment_Line."Document No.";
                column(Raison_retard; "Raison retard")
                {
                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin
        SetFilter(Posting_Date, '%1..', CalcDate('<-3M>', Today));
    end;
}

