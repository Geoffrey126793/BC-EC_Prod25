tableextension 50057 SalesInvoiceLineEC extends "Sales Invoice Line"
{
    fields
    {
        field(50010; "Reason Free Code"; Code[20])
        {
            Caption = 'Reason Free Code';
            Description = 'ADV-001';
            Editable = false;
            TableRelation = "Reason Free Code";
        }
        field(50011; "Free Line"; Boolean)
        {
            Caption = 'Free Line';
            Description = 'ADV-001';
            Editable = false;
        }
        field(50015; "Source Line No. Item Free"; Integer)
        {
            Caption = 'Source Line No. Item Free';
            Description = 'ADV-007';
        }
        field(50020; "Transport Unit Price"; Decimal)
        {
            Caption = 'Transport Unit Price';
            Description = 'LOG-004';
        }
        field(50021; "Transport line"; Boolean)
        {
            Caption = 'Transport line';
            Description = 'LOG-004';
        }
        field(50022; "Special Discount Code"; Code[10])
        {
            Caption = 'Special Discount Code';
            Editable = false;
        }
        field(50025; "Discount Rule of Item Free"; Code[20])
        {
            Caption = 'Discount Rule of Item Free';
        }
        field(50026; "Item Source of Item Free"; Code[20])
        {
            Caption = 'Item Source of Item Free';
        }
        field(50027; "Qty Item Source of Item Free"; Decimal)
        {
            Caption = 'Qty Item Source of Item Free';
            Editable = false;
        }
        field(50028; "Document Date"; Date)
        {
            CalcFormula = Lookup("Sales Invoice Header"."Document Date" WHERE("No." = FIELD("Document No.")));
            Caption = 'Document Date';
            Description = 'AB6.VR';
            FieldClass = FlowField;
        }
        field(50029; "Currency Code"; Code[10])
        {
            CalcFormula = Lookup("Sales Invoice Header"."Currency Code" WHERE("No." = FIELD("Document No.")));
            Caption = 'Currency Code';
            Description = 'AB6.VR';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Currency;
        }
        field(50030; "Nom Client"; Text[100])
        {
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Sell-to Customer No.")));
            FieldClass = FlowField;
        }
        field(50031; Vendeur; Code[20])
        {
            CalcFormula = Lookup(Customer."Salesperson Code" WHERE("No." = FIELD("Sell-to Customer No.")));
            FieldClass = FlowField;
        }
        field(50050; "Ship-to Country/Region Code"; Code[10])
        {
            CalcFormula = Lookup("Sales Invoice Header"."Ship-to Country/Region Code" WHERE("No." = FIELD("Document No.")));
            Caption = 'Ship-to Country/Region Code';
            FieldClass = FlowField;
            TableRelation = "Country/Region";
        }
        field(50093; "Px Depart"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50094; "Px 3x Net"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50095; "External Document No"; Text[50])
        {
            CalcFormula = Lookup("Sales Invoice Header"."External Document No." WHERE("No." = FIELD("Document No.")));
            FieldClass = FlowField;
        }
        field(50206; "Prix Tpt"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50207; "Shipment No"; Code[20])
        {
            CalcFormula = Lookup("Shipment Invoiced"."Shipment No." WHERE("Invoice No." = FIELD("Document No.")));
            Caption = 'No BL';
            FieldClass = FlowField;
        }
        field(8001500; "Rule Discount Line Amount"; Decimal)
        {
            Caption = 'Rule Discount Line Amount';
            Editable = false;
        }
    }
}

