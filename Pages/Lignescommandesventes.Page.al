page 50078 "Lignes commandes ventes"
{
    PageType = List;
    SourceTable = "Sales Line";
    SourceTableView = WHERE (Type = CONST (Item));
    UsageCategory = Lists;

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
                field("No."; "No.")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field(Description; Description)
                {
                }
                field("Quantity (Base)"; "Quantity (Base)")
                {
                }
                field("Requested Delivery Date"; "Requested Delivery Date")
                {
                }
                field("Promised Delivery Date"; "Promised Delivery Date")
                {
                }
            }
        }
    }

    actions
    {
    }
}

