tableextension 50014 GLEntryEC extends "G/L Entry"
{
    fields
    {
        field(50002; Regroupement; Code[30])
        {
            CalcFormula = Lookup("G/L Account".Regroupement WHERE("No." = FIELD("G/L Account No.")));
            FieldClass = FlowField;
            TableRelation = Code.Code WHERE("Table No" = CONST(15),
                                             "Field No" = CONST(50002));
        }
        field(50399; tmpGL; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

}

