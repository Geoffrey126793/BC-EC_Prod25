tableextension 50068 TransferHeaderEC extends "Transfer Header"
{
    fields
    {
        field(50000; Dedouanement; Boolean)
        {
            Caption = 'Dedouanement';
        }
        field(50001; Departement; Code[10])
        {
            Caption = 'Departement';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001309));
        }
        field(50002; Auto; Boolean)
        {
            Caption = 'Auto';
        }
        field(50035; "Blocage des lots"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50036; Emplacement; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Code.Code WHERE("Table No" = CONST(5405),
                                             "Field No" = CONST(50107));
        }
    }

}

