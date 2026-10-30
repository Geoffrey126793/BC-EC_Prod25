table 50030 FAR
{

    fields
    {
        field(2; "Buy-from Vendor No."; Code[20])
        {
            Caption = 'Buy-from Vendor No.';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Vendor;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Purch. Rcpt. Header";
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; Type; Option)
        {
            Caption = 'Type';
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = ' ,G/L Account,Item,,Fixed Asset,Charge (Item)';
            OptionMembers = " ","G/L Account",Item,,"Fixed Asset","Charge (Item)";
        }
        field(6; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = IF (Type = CONST ("G/L Account")) "G/L Account"
            ELSE
            IF (Type = CONST (Item)) Item
            ELSE
            IF (Type = CONST ("Fixed Asset")) "Fixed Asset"
            ELSE
            IF (Type = CONST ("Charge (Item)")) "Item Charge";
        }
        field(7; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Location WHERE ("Use As In-Transit" = CONST (false));
        }
        field(10; "Expected Receipt Date"; Date)
        {
            Caption = 'Expected Receipt Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(11; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(13; "Unit of Measure"; Text[50])
        {
            Caption = 'Unit of Measure';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(15; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(23; "Unit Cost (LCY)"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost (LCY)';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(58; "Qty. Rcd. Not Invoiced"; Decimal)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            Caption = 'Qty. Rcd. Not Invoiced';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(61; "Quantity Invoiced"; Decimal)
        {
            Caption = 'Quantity Invoiced';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(65; "Order No."; Code[20])
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            Caption = 'Order No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(66; "Order Line No."; Integer)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            Caption = 'Order Line No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(74; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Gen. Business Posting Group";
        }
        field(75; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Gen. Product Posting Group";
        }
        field(131; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5700; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Responsibility Center";
        }
        field(5709; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = IF (Type = CONST (Item)) "Item Category";
        }
        field(50050; "Buy-from Vendor Name"; Text[100])
        {
            CalcFormula = Lookup (Vendor.Name WHERE ("No." = FIELD ("Buy-from Vendor No.")));
            Caption = 'Vendor name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50500; "Status facture"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "A recevoir","Reçue",Exclu;
        }
        field(50501; "Total FAR"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

