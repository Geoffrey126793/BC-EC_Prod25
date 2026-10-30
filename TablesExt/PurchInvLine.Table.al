tableextension 50044 PurchInvLineEC extends "Purch. Inv. Line"
{

    fields
    {
        field(50002; "Transport Sales Order No"; Code[20])
        {
            Caption = 'Transport Sales Order No';
            Description = 'AB60408.V14';
            TableRelation = "Sales Header"."No." WHERE("Document Type" = CONST(Order));
        }
        field(50003; "Transport Customer No"; Code[20])
        {
            Caption = 'Transport Customer No';
            Description = 'AB60408.V14';
            TableRelation = Customer;
        }
        field(50004; "Transport Ship-to Code"; Code[10])
        {
            Caption = 'Transport Ship-to Code';
            Description = 'AB60408.V14';
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Transport Customer No"));
        }
        field(50005; "Cases Quantity per Pallet"; Integer)
        {
            Caption = 'Cases Quantity per Pallet';
            Description = 'AB60408.V14';
        }
        field(50006; "Transport Sales Invoice No"; Code[20])
        {
            Caption = 'Transport Sales Invoice No';
            Description = 'AB60408.V14';
            TableRelation = "Sales Invoice Header"."No." WHERE("No." = FIELD("Transport Sales Invoice No"));
        }
        field(50007; "Transport Comment"; Text[80])
        {
            Caption = 'Transport Comment';
            DataClassification = ToBeClassified;
            Description = 'AB60408.V14';
        }
        field(50030; Note; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(8001500; "Rule Discount Line Amount"; Decimal)
        {
            Caption = 'Rule Discount Line Amount';
            Editable = false;
        }
    }

}

