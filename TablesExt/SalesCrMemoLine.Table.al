tableextension 50053 SalesCrMemoLineEC extends "Sales Cr.Memo Line"
{
    fields
    {
        field(50010; "Reason Free Code"; Code[20])
        {
            Caption = 'Reason Free Code';
            Description = 'ADV-001';
            Editable = false;
            TableRelation = "Customer Discount Group";
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
        field(50022; "Special Discount Code"; Code[10])
        {
            Caption = 'Special Discount Code';
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
            CalcFormula = Lookup("Sales Cr.Memo Header"."Document Date" WHERE("No." = FIELD("Document No.")));
            Caption = 'Document Date';
            Description = 'AB6.VR';
            FieldClass = FlowField;
        }
        field(50029; "Currency Code"; Code[10])
        {
            CalcFormula = Lookup("Sales Cr.Memo Header"."Currency Code" WHERE("No." = FIELD("Document No.")));
            Caption = 'Currency Code';
            Description = 'AB6.VR';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Currency;
        }
        field(8001500; "Rule Discount Line Amount"; Decimal)
        {
            Caption = 'Rule Discount Line Amount';
            Editable = false;
        }
    }
}

