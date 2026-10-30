tableextension 50063 ITemReferenceEC extends "Item Reference"
{

    fields
    {
        field(50000; "Intern Description"; Text[100])
        {
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD("Item No.")));
            Caption = 'Intern Description';
            FieldClass = FlowField;
        }
        field(50001; "Observation Description"; Text[40])
        {
            Caption = 'Observation Description';
        }
        field(50002; GTIN; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "DLC mini"; Integer)
        {
            Caption = 'DLC mini (jours)';
            DataClassification = ToBeClassified;
        }
    }

}

