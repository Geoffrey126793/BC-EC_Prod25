page 50196 MiscBatch2
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            field(txt1; txt1)
            { }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Desadv)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    shpt: record "Sales Shipment Header";

                begin
                    shpt.SETRANGE("No.", txt1);
                    shpt.FINDFIRST;

                end;
            }
        }
    }
    var
        txt1: text;


}