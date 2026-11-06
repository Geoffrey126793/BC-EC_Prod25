page 50028 "WS Shipments"
{
    PageType = List;
    SourceTable = "Sales Shipment Line";
    SourceTableView = WHERE("Posting Date" = FILTER(> 20230101D),
                            "Location Code" = FILTER(<> 'RD'));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Line No."; "Line No.")
                {
                }
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Qte commandée initiale"; "Qte commandée initiale")
                {
                }
                field("Order No."; "Order No.")
                {
                }
                field("Qte commandée initiale Base"; "Qte commandée initiale Base")
                {
                }
                field("Quantity (Base)"; "Quantity (Base)")
                {
                }
                field("Location Code"; "Location Code")
                {

                }
            }
        }
    }

    actions
    {
    }
}

