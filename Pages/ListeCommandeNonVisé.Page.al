page 50008 "Liste Commande Non Visé"
{
    Caption = 'Liste Commande Non Visé';
    CardPageID = "Sales Order";
    PageType = List;
    SourceTable = "Sales Header";
    SourceTableView = SORTING("Document Type", "No.")
                      WHERE("Status Visa" = CONST("On standby visa "),
                            "Document Type" = CONST(Order),
                            Status = CONST(Released));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Status Visa"; "Status Visa")
                {
                }
                field("No."; "No.")
                {
                }
                field("Bill-to Customer No."; "Bill-to Customer No.")
                {
                }
                field("Customer Shipment Blocked"; "Customer Shipment Blocked")
                {
                }
                field("Order type"; "Order type")
                {
                }
                field("Requested Delivery Date"; "Requested Delivery Date")
                {
                }
                field("Promised Delivery Date"; "Promised Delivery Date")
                {
                }
                field("Bill-to Name"; "Bill-to Name")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field(ClientBloque; ClientBloque)
                {
                    Caption = 'Autorisation livraison';
                    Style = Unfavorable;
                    StyleExpr = ClientBloque <> 'OK';
                }
                field("Sell-to Country/Region Code"; "Sell-to Country/Region Code")
                {
                    Style = Unfavorable;
                    StyleExpr = "Sell-to Country/Region Code" = 'GB';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Viser)
            {
                Caption = 'Viser';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'F11';

                trigger OnAction()
                begin
                    if "Promised Delivery Date" = 0D then
                        Error('Pas de date conformée');

                    Validate("Status Visa", "Status Visa"::"Visa authorized");
                    Modify;
                    //recSales.GET(recSales."Document Type"::Order, "No.");
                    //recSales.VALIDATE(Status,Status::Released);
                    //recSales.MODIFY;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if "Customer Shipment Blocked" then
            ClientBloque := 'LIVRAISON BLOQUEE'
        else
            ClientBloque := 'OK';
        if ("Status credit" <> "Status credit"::Ok) and ("Status credit" <> "Status credit"::"Libéré manuellement") then
            ClientBloque := 'LIVRAISON BLOQUEE';
    end;

    var
        recSales: Record "Sales Header";
        ClientBloque: Text[30];
}

