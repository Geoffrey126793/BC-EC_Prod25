table 50021 "Peppol Logs"
{

    fields
    {
        field(1; ID; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Dt; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(3; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = BC,Response,Gateway;
        }
        field(4; Result_Code; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; ReasonCode; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(6; Message; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
        field(7; Company; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(8; NoDoc; Code[20])
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

