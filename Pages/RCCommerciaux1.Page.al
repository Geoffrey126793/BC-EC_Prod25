page 50086 "RC Commerciaux 1"
{
    Caption = 'Commerciaux';
    PageType = CardPart;

    layout
    {
        area(content)
        {
            cuegroup("Pre-arrival Follow-up on Purchase Orders")
            {
                Caption = 'Pre-arrival Follow-up on Purchase Orders';

                actions
                {
                    action("Prévisions de vente")
                    {


                        RunObject = Page "Prévisions ventes";
                    }
                }
            }
            cuegroup(Control1000000000)
            {
                Caption = 'Devis';

                actions
                {
                    action(Devis)
                    {
                        RunObject = Page "Sales Quotes";
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        n := 5;
        "Depart ajd" := 18;
    end;

    var
        n: Integer;
        "Depart ajd": Decimal;
}

