page 50044 "Lignes RD"
{
    Caption = 'Lignes RD';
    Editable = false;
    PageType = List;
    SourceTable = "Sales Line";
    SourceTableView = WHERE ("Location Code" = CONST ('RD'),
                            "Outstanding Quantity" = FILTER (> 0));

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
                field(Description; Description)
                {
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Requested Delivery Date"; "Requested Delivery Date")
                {
                }
                field("Nom Client"; CustomerName)
                {
                }
                field(DeliveryName; DeliveryName)
                {
                    Caption = 'Livraison';
                }
                field(City; City)
                {
                    Caption = 'Ville';
                }
                field(Country; Country)
                {
                    Caption = 'Pays';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Afficher la commande")
            {
                Caption = 'Afficher la commande';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    SalesH.Reset;
                    SalesH.SetFilter("No.", "Document No.");

                    PAGE.Run(42, SalesH);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin

        SalesH.Get("Document Type", "Document No.");
        CustomerName := SalesH."Sell-to Customer Name";
        DeliveryName := SalesH."Ship-to Name";
        City := SalesH."Ship-to City";
        Country := SalesH."Ship-to Country/Region Code";
    end;

    var
        CustomerName: Text[50];
        recCust: Record Customer;
        SalesH: Record "Sales Header";
        DeliveryName: Text[50];
        City: Text[50];
        Country: Text[50];
}

