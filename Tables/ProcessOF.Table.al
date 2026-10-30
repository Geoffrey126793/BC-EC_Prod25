table 50036 ProcessOF
{

    fields
    {
        field(1; "Production BOM No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Production BOM Header";
        }
        field(2; "BOM Version"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Process; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Code.Code WHERE ("Table No" = CONST (50036),
                                             "Field No" = CONST (3));
        }
        field(4; Valeur; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Process Description"; Text[150])
        {
            CalcFormula = Lookup (Code.Description WHERE ("Table No" = CONST (50036),
                                                         "Field No" = CONST (3),
                                                         Code = FIELD (Process)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Production BOM No", "BOM Version", Process)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

