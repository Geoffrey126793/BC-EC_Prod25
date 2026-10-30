tableextension 50013 GLAccountEC extends "G/L Account"
{
    fields
    {
        field(50000; "Purchase Order"; Boolean)
        {
            Caption = 'Purchase order';
            Description = 'AB60408.A2';
        }
        field(50001; "Remaining Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("G/L Entry"."Remaining Amount" WHERE("G/L Account No." = FIELD("No."),
                                                                    "G/L Account No." = FIELD(FILTER(Totaling)),
                                                                    "Business Unit Code" = FIELD("Business Unit Filter"),
                                                                    "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                    "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                    "Posting Date" = FIELD("Date Filter")));
            Caption = 'Remaining Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002; Regroupement; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Code.Code WHERE("Table No" = CONST(15),
                                             "Field No" = CONST(50002));
        }
        field(50399; tmpGL; Code[20])
        {
            Caption = 'tmpGL';
        }
    }

}

