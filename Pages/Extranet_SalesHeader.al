page 50083 "Extranet_SalesHeader"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Sales Header";

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Document Type"; "Document Type")
                { }
                field("No."; "No.")
                { }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                { }
                field("Requested Delivery Date"; "Requested Delivery Date")
                { }
                field("External Document No."; "External Document No.")
                { }
                field("Ship-to Code"; "Ship-to Code")
                { }
                field("Ship-to Address"; "Ship-to Address")
                { }
                field("Ship-to Name"; "Ship-to Name")
                { }
                field("Ship-to City"; "Ship-to City")
                { }
                field("Ship-to Post Code"; "Ship-to Post Code")
                { }
                field("Ship-to Country/Region Code"; "Ship-to Country/Region Code")
                { }
                field("Location Code"; "Location Code")
                { }
                field("Order type"; "Order type")
                { }
                field(ExtranetDt; ExtranetDt)
                { }
                field(ExtranetToConfirm; ExtranetToConfirm)
                { }
                field(ExtranetID; ExtranetID)
                { }

            }
        }
    }


}