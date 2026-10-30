page 50019 "Shipment Purchase Orders"
{
    Caption = 'Shipment Purchase Orders';
    InsertAllowed = false;
    PageType = List;
    PromotedActionCategories = 'Catégorie1,Créer,Catégorie3,Commandes';
    SaveValues = true;
    SourceTable = "Shipment Purchase Orders";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater("Général")
            {
                field(Status; Status)
                {
                }
                field("Shipping Agent Code"; "Shipping Agent Code")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Promised Delivery Date"; "Promised Delivery Date")
                {
                }
                field("Date livraison prévue"; "Date livraison prévue")
                {
                }
                field("Purchase Order No."; "Purchase Order No.")
                {
                }
                field("Buy-from Vendor No."; "Buy-from Vendor No.")
                {
                }
                field("Territory Code"; "Territory Code")
                {
                }
                field("Unit Cost"; "Unit Cost")
                {
                }
                field("Sales Order No."; "Sales Order No.")
                {
                }
                field("Sales Invoice No"; "Sales Invoice No")
                {
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                }
                field("Ship-to Code"; "Ship-to Code")
                {
                }
                field("Qty. to Ship"; "Qty. to Ship")
                {
                }
                field("Total Net Weight"; "Total Net Weight")
                {
                }
                field("Pallet Quantity"; "Pallet Quantity")
                {
                }
                field("Cases Quantity per Pallet"; "Cases Quantity per Pallet")
                {
                }
                field("Quantity Shipped"; "Quantity Shipped")
                {
                }
                field("Order type"; "Order type")
                {
                }
                field("Logistic unit"; "Logistic unit")
                {
                }
                field("Complete Pallet"; "Complete Pallet")
                {
                }
                field("Customer Shipment Blocked"; "Customer Shipment Blocked")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Erreurs commandes de vente")
            {
                Caption = 'Erreurs commandes de vente';
                RunObject = Page "Shipment Purch. Orders Errors";
                RunPageLink = "Shipping Agent Code" = FIELD("Shipping Agent Code"),
                              "Location Code" = FIELD("Location Code"),
                              "Promised Delivery Date" = FIELD("Promised Delivery Date");
                RunPageView = SORTING("Error Source", "Entry No.")
                              WHERE("Error Source" = CONST('SALES ORDERS'));
            }
            action("Erreurs lignes à créer")
            {
                Caption = 'Erreurs lignes à créer';
                RunObject = Page "Shipment Purch. Orders Errors";
                RunPageLink = "Shipping Agent Code" = FIELD("Shipping Agent Code"),
                              "Location Code" = FIELD("Location Code"),
                              "Promised Delivery Date" = FIELD("Promised Delivery Date");
                RunPageView = SORTING("Error Source", "Entry No.")
                              WHERE("Error Source" = CONST('PURCH ORDERS'));
            }
            separator(Action1000000037)
            {
            }
            action("Extraire Commandes de vente")
            {
                Caption = 'Extraire Commandes de vente';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    _getFilters();
                    GetSalesOrders(LocationFilter, ShippingAgentFilter, DateFilter, '');
                end;
            }
            action("Vérifier Commandes de vente")
            {
                Caption = 'Vérifier Commandes de vente';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    _getFilters();
                    CheckSalesOrders(LocationFilter, ShippingAgentFilter, DateFilter, '');
                end;
            }
            action("Vérifier lignes à créer")
            {
                Caption = 'Vérifier lignes à créer';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    _getFilters();
                    CheckPurchOrders(LocationFilter, ShippingAgentFilter, DateFilter, '');
                end;
            }
            action("Extraire prix transport")
            {
                Caption = 'Extraire prix transport';

                trigger OnAction()
                begin
                    OpenTransport;
                end;
            }
            action("Créer Commande d'achat")
            {
                Caption = 'Créer Commande d''achat';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    _getFilters();
                    CheckSalesOrders(LocationFilter, ShippingAgentFilter, DateFilter, '');
                    CheckPurchOrders2(LocationFilter, ShippingAgentFilter, DateFilter, '');
                    //CurrForm.UPDATE;
                    CreatePurchOrders(LocationFilter, ShippingAgentFilter, DateFilter, '');

                    Reset;
                    SetFilter("Shipping Agent Code", ShippingAgentFilter);
                    SetFilter("Location Code", LocationFilter);
                    SetFilter("Promised Delivery Date", DateFilter);
                end;
            }
            action("Mettre à jour commande achat")
            {
                Caption = 'Mettre à jour commande achat';

                trigger OnAction()
                begin
                    UpdatePurchOrders(LocationFilter, ShippingAgentFilter, DateFilter, "Purchase Order No.");
                end;
            }
            action("Fiche commande vente")
            {
                Caption = 'Fiche commande vente';
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin

                    if RecSalesheader_l.Get(RecSalesheader_l."Document Type"::Order, "Sales Order No.") then
                        PAGE.Run(PAGE::"Sales Order", RecSalesheader_l);
                end;
            }
            action("Voir commande d'achat")
            {
                Caption = 'Voir commande d''achat';
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Cmd: Record "Purchase Header";
                begin
                    Cmd.Reset;
                    Cmd.SetRange("Document Type", Cmd."Document Type"::Order);
                    Cmd.SetRange("No.", "Purchase Order No.");
                    PAGE.Run(50, Cmd);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        //FILTERGROUP(4); ?
        //DateFilter := GETFILTER("Date Filter");
        //SETFILTER("Promised Delivery Date",DateFilter);
        //ShippingAgentFilter := GETFILTER("Shipping Agent Code");
        //LocationFilter := GETFILTER("Location Code");

        SetFilter(Status, '>%1', Status::"validé");
        DateFilter := Format(CalcDate('<+1D>', Today));
        ShippingAgentFilter := '*';
        LocationFilter := '*';

        _setfilters();
    end;

    var
        ShippingAgent: Record "Shipping Agent";
        Location: Record Location;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        ShptPurchOrder: Record "Shipment Purchase Orders";
        ShippingAgentList: Page "Shipping Agents";
        LocationList: Page "Location List";
        ShippingAgentFilter: Text[250];
        LocationFilter: Text[250];
        DateFilter: Text[30];
        RecSalesheader_l: Record "Sales Header";

    [Scope('OnPrem')]
    procedure _setfilters()
    begin
        SetFilter("Shipping Agent Code", ShippingAgentFilter);
        SetFilter("Location Code", LocationFilter);
        SetFilter("Promised Delivery Date", DateFilter);
    end;

    [Scope('OnPrem')]
    procedure _getFilters()
    begin
        ShippingAgentFilter := GetFilter("Shipping Agent Code");
        LocationFilter := GetFilter("Location Code");
        DateFilter := GetFilter("Promised Delivery Date");
    end;
}

