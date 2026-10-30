page 50011 Transport
{
    Caption = 'Transport';
    PageType = List;
    SourceTable = Transport;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Type)
                {
                }
                field("Shipping Agent Code"; "Shipping Agent Code")
                {
                }
                field("Territory code"; "Territory code")
                {
                }
                field("Type transport"; "Type transport")
                {
                }
                field("Paletts type"; "Paletts type")
                {
                }
                field("Number of Pallets"; "Number of Pallets")
                {
                }
                field("Currency code"; "Currency code")
                {
                }
                field("Starting date"; "Starting date")
                {
                }
                field("End date"; "End date")
                {
                }
                field("Paletts / Price"; "Paletts / Price")
                {
                }
                field(Transport; Transport)
                {
                }
            }
        }
    }

    actions
    {
    }
}

