table 50015 "Receipt Invoiced"
{
    // //AB60408.A1 EBE 17/04/08
    //    création de la table réceptions facturées pour relier factures et réceptions

    Caption = 'Receipt Invoiced';
    DrillDownPageID = "Invoices bound by Shipment";
    LookupPageID = "Invoices bound by Shipment";

    fields
    {
        field(1; "Invoice No."; Code[20])
        {
            Caption = 'Invoice No.';
            TableRelation = "Purch. Inv. Header"."No.";
        }
        field(2; "Invoice Line No."; Integer)
        {
            Caption = 'Invoice Line No.';
        }
        field(3; "Receipt No."; Code[20])
        {
            Caption = 'Sales Shipment No.';
            TableRelation = "Purch. Rcpt. Header"."No.";
        }
        field(4; "Receipt Line No."; Integer)
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
            TableRelation = IF (Type = CONST("G/L Account")) "G/L Account"
            ELSE
            IF (Type = CONST(Item)) Item
            ELSE
            IF (Type = CONST(Resource)) Resource
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF (Type = CONST("Charge (Item)")) "Item Charge";
        }
        field(7; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(8; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(9; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = CONST(Order));
        }
        field(10; "Qty. to Invoice"; Decimal)
        {
            Caption = 'Qty. to Invoice';
            DecimalPlaces = 0 : 5;
        }
        field(11; "Qty. to Receive"; Decimal)
        {
            Caption = 'Qty. to Ship';
            DecimalPlaces = 0 : 5;
        }
        field(12; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(13; "Buy-from Vendor No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            Editable = false;
            TableRelation = Customer;
        }
        field(14; "Buy-from Vendor Name"; Text[30])
        {
            Caption = 'Sell-to Customer Name';
        }
        field(20; "User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = System.Security.AccessControl.User;
        }
        field(30; "Vendor Order No."; Code[20])
        {
            Caption = 'Customer Order No.';
        }
        field(31; "Qty. Received Not Invoiced"; Decimal)
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
        field(33; "Receipt Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(34; "Vendor Invoice No."; Code[20])
        {
            Caption = 'Customer Order No.';
        }
    }

    keys
    {
        key(Key1; "Invoice No.", "Invoice Line No.", "Receipt No.", "Receipt Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Receipt No.", "Receipt Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}

