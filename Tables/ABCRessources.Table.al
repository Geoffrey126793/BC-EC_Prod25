table 50005 "ABC - Ressources"
{
    DrillDownPageID = "ABC - Ressources List";
    LookupPageID = "ABC - Ressources List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Rendement nominal"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(4; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Main d'oeuvre","Machine (planifiable)","Matériel","Main d'oeuvre production","Prestation externe";
        }
        field(5; "Description 2"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(6; Cout; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 3;
        }
        field(7; "Type Cout"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "€/kg","€/batch","€/h";
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

