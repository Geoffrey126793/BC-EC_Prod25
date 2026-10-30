page 50039 "WS Prod Line"
{
    Caption = 'WS Prod Line';
    PageType = List;
    SourceTable = "Prod. Order Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Status; Status)
                {
                }
                field("Prod. Order No."; "Prod. Order No.")
                {
                }
                field("Line No."; "Line No.")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field("Ending Date-Time"; "Ending Date-Time")
                {
                }
                field("Starting Date-Time"; "Starting Date-Time")
                {
                }
                field(IDVP; IDVP)
                {
                }
                field(Quantity; Quantity)
                {
                }
            }
        }
    }

    actions
    {
    }
}

