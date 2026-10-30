tableextension 50069 TransferLineEC extends "Transfer Line"
{
    fields
    {

        field(50000; "Vendor Item No."; Text[50])
        {
            CalcFormula = Lookup(Item."Vendor Item No." WHERE("No." = FIELD("Item No.")));
            Caption = 'Vendor Item No.';
            Description = 'FON-001';
            FieldClass = FlowField;
        }
    }
}

