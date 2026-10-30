table 8001325 "Statistic Cue"
{

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(2; Statistic; Integer)
        {
            CalcFormula = Count ("Statistic definition" WHERE ("Line No." = CONST (10000)));
            Caption = 'Statistic';
            FieldClass = FlowField;
        }
        field(3; "Statistic for the user"; Integer)
        {
            CalcFormula = Count ("Statistic definition" WHERE ("Line No." = CONST (10000),
                                                              "User ID" = FIELD ("User ID Filter")));
            Caption = 'Statistic for the user';
            FieldClass = FlowField;
        }
        field(20; "User ID Filter"; Code[50])
        {
            Caption = 'User ID Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

