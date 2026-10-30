table 50033 "ABC Cost OF"
{

    fields
    {
        field(1; ID; Guid)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "OF"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Line; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Unit Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5; Qty; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; Cost; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; ID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

