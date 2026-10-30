table 50032 "Historique Cout Ressources"
{

    fields
    {
        field(1; Ressource; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; StartDate; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3; Cost; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; Ressource, StartDate)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

