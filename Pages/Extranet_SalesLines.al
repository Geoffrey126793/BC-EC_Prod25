page 50040 "Extranet_SalesLines"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Sales line";

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Document Type"; "Document Type")
                { }
                field("Document No."; "Document No.")
                { }
                field("Line No."; "Line No.")
                { }
                field(Type; Type)
                { }
                field("No."; "No.")
                { }
                field(Quantity; Quantity)
                { }
                field("Unit of Measure Code"; "Unit of Measure Code")
                { }
                field("Unit Price"; "Unit Price")
                { }
                field(Amount; Amount)
                { }



            }
        }
    }


}