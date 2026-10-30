query 50011 Extranet_cmd
{

    elements
    {
        dataitem(Sales_Header; "Sales Header")
        {
            DataItemTableFilter = "Document Type" = CONST (Order), "Last Shipping No." = FILTER (''), Status = CONST (Released);
            column(Requested_Delivery_Date; "Requested Delivery Date")
            {
            }
            column(Promised_Delivery_Date; "Promised Delivery Date")
            {
            }
            column("Date_livraison_prévue"; "Date livraison prévue")
            {
            }
            column(Commande_bloquee; "Commande bloquee")
            {
            }
            column(Status_credit; "Status credit")
            {
            }
            column(Ship_to_Name; "Ship-to Name")
            {
            }
            column(Ship_to_Address; "Ship-to Address")
            {
            }
            column(Ship_to_City; "Ship-to City")
            {
            }
            column(Order_Date; "Order Date")
            {
            }
            column(No; "No.")
            {
            }
            column(Sell_to_Customer_No; "Sell-to Customer No.")
            {
            }
            column(Your_Reference; "External Document No.")
            {
            }
            column(Ship_to_Code; "Ship-to Code")
            {
            }
            column(Ship_to_Post_Code; "Ship-to Post Code")
            {
            }
            column(Ship_to_Country_Region_Code; "Ship-to Country/Region Code")
            {
            }
        }
    }
}

