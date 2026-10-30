table 50026 "Ateliers Couts"
{
    Caption = 'Ateliers Couts';

    fields
    {
        field(1; "Centre de charges"; Code[20])
        {
            Caption = 'Centre de charges';
            TableRelation = "Work Center";
        }
        field(2; Cout; Decimal)
        {
            Caption = 'Cout';
            DecimalPlaces = 0 : 5;
        }
        field(3; Debut; Date)
        {
            Caption = 'Debut';
        }
        field(4; Fin; Date)
        {
            Caption = 'Fin';
        }
    }

    keys
    {
        key(Key1; "Centre de charges", Debut)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

