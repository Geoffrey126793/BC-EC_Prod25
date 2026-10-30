pageextension 70260 pageextension70260 extends "Sales Order List"
{
    layout
    {
        modify("No.")
        {
            Width = 14;
        }
        modify("Sell-to Country/Region Code")
        {
            Style = Unfavorable;
            StyleExpr = "Sell-to Country/Region Code" = 'GB';
        }
        modify("Ship-to Country/Region Code")
        {
            Visible = true;
            Style = Unfavorable;
            StyleExpr = "Ship-to Country/Region Code" = 'GB';
        }
        modify(Control1902018507)
        {
            Visible = ShowPrice;
        }
        modify("Requested Delivery Date")
        {
            Visible = true;
        }
        modify("Shipping Agent Code")
        {
            Visible = true;
        }
        addafter("Sell-to Customer Name")
        {
            field("Nom recherche client"; "Nom recherche client")
            {
            }
            field(ClientBloque; ClientBloque)
            {
                Caption = 'Autorisation livraison';
                Style = Unfavorable;
                StyleExpr = ClientBloque <> 'OK';
            }
        }
        addafter("Requested Delivery Date")
        {
            field("Promised Delivery Date"; "Promised Delivery Date")
            {
                Style = StrongAccent;
                StyleExpr = AvertDtConfirme;
            }
            field("Date livraison prévue"; "Date livraison prévue")
            {
            }
            field("Order Date"; "Order Date")
            {
            }
        }
        addafter("Ship-to Contact")
        {
            field("Confirmation envoyée"; "Confirmation envoyée")
            {
            }
        }
        addafter("Document Date")
        {
            field("Nombre de palette confirmée"; "Nombre de palette confirmée")
            {
            }
            field("Territory Code"; "Territory Code")
            {
            }
        }
        addafter(Status)
        {
            field("Order type"; "Order type")
            {
            }
            field(User; User)
            {
            }
        }
        addafter("Shipment Date")
        {
            field("Last Shipping No."; "Last Shipping No.")
            {
            }
            field("Cases Quantity per Pallet"; "Cases Quantity per Pallet")
            {
            }
            field(Control1000000016; "Camion parti")
            {
            }
            field("Ligne transport existante"; "Ligne transport existante")
            {
            }
            field(Ship; Ship)
            {
            }
            field("<Customer Shipment Blocked>"; "Customer Shipment Blocked")
            {
            }
        }
        addafter("Posting Description")
        {
            field("Quantité totale"; "Quantité totale")
            {
            }
            field("Status credit"; "Status credit")
            {
            }
        }
        moveafter("Bill-to Post Code"; "Requested Delivery Date")
        moveafter("Salesperson Code"; "Currency Code")
        moveafter("Document Date"; "Campaign No.")
    }
    actions
    {
        addafter("Post &Batch")
        {
            action("Camion parti")
            {
                Caption = 'Camion parti';
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin
                    Rec."Camion parti" := true;
                    Rec.Modify;
                end;
            }
        }
    }

    var
        ClientBloque: Text[20];
        TotalNetWeight: Decimal;
        rSalesLine: Record "Sales Line";
        AvertDtConfirme: Boolean;
        ShowPrice: Boolean;
        CuUtils: Codeunit "Absys - tools PJ";
        UserMgtEc: codeunit "User Setup Management";

    trigger OnAfterGetRecord()
    var
        Cust: Record Customer;
    begin
        if "Customer Shipment Blocked" then
            ClientBloque := 'LIVRAISON BLOQUEE'
        else
            ClientBloque := 'OK';

        if ("Status credit" <> "Status credit"::Ok) and ("Status credit" <> "Status credit"::"Libéré manuellement") then
            ClientBloque := 'LIVRAISON BLOQUEE';

        AvertDtConfirme := (("Promised Delivery Date" <> "Requested Delivery Date") and ("Promised Delivery Date" <> 0D))
    end;

    trigger OnOpenPage()
    begin
        if UserMgtEc.GetRespCenter(0, '') <> '' then begin
            FilterGroup(2);
            SetFilter("Salesperson Code", UserMgtEC.GetRespCenter(0, ''));
            FilterGroup(0);
        end;
        ShowPrice := CuUtils.GetRole('SALES-CUST2');
        Ascending(false);
        rec.FindFirst();
    end;
}

