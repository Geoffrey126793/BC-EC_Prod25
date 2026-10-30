table 50014 "Shipment Invoiced"
{
    // //AB60408.V15 EBE 17/04/08
    //    création de la table expéditions facturées pour relier factures et expéditions

    Caption = 'Shipment Invoiced';
    DrillDownPageID = "Invoices bound by Shipment";
    LookupPageID = "Invoices bound by Shipment";

    fields
    {
        field(1; "Invoice No."; Code[20])
        {
            Caption = 'Invoice No.';
            TableRelation = "Sales Invoice Header";
        }
        field(2; "Invoice Line No."; Integer)
        {
            Caption = 'Invoice Line No.';
        }
        field(3; "Shipment No."; Code[20])
        {
            Caption = 'Sales Shipment No.';
            TableRelation = "Sales Shipment Header";
        }
        field(4; "Shipment Line No."; Integer)
        {
            Caption = 'Shipment Line No.';
        }
        field(5; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)';
            OptionMembers = " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)";
        }
        field(6; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type = CONST ("G/L Account")) "G/L Account"
            ELSE
            IF (Type = CONST (Item)) Item
            ELSE
            IF (Type = CONST (Resource)) Resource
            ELSE
            IF (Type = CONST ("Fixed Asset")) "Fixed Asset"
            ELSE
            IF (Type = CONST ("Charge (Item)")) "Item Charge";
        }
        field(7; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE ("Use As In-Transit" = CONST (false));
        }
        field(8; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(9; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            TableRelation = "Sales Header"."No." WHERE ("Document Type" = CONST (Order));
        }
        field(10; "Qty. to Invoice"; Decimal)
        {
            Caption = 'Qty. to Invoice';
            DecimalPlaces = 0 : 5;
        }
        field(11; "Qty. to Ship"; Decimal)
        {
            Caption = 'Qty. to Ship';
            DecimalPlaces = 0 : 5;
        }
        field(12; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(13; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            Editable = false;
            TableRelation = Customer;
        }
        field(14; "Sell-to Customer Name"; Text[30])
        {
            Caption = 'Sell-to Customer Name';
        }
        field(20; "User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = User;
        }
        field(30; "Customer Order No."; Code[20])
        {
            Caption = 'Customer Order No.';
        }
        field(31; "Qty. Shipped Not Invoiced"; Decimal)
        {
            Caption = 'Qty. Shipped Not Invoiced';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(32; "Quantity Invoiced"; Decimal)
        {
            Caption = 'Quantity Invoiced';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(33; "Shipment Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
    }

    keys
    {
        key(Key1; "Invoice No.", "Invoice Line No.", "Shipment No.", "Shipment Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Shipment No.", "Shipment Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}

