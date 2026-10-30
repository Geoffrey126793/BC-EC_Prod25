table 50011 "Unité logistique"
{
    Caption = 'Unité logistique';
    DrillDownPageID = "Logistic Unit";
    LookupPageID = "Logistic Unit";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; "Désignation"; Text[50])
        {
            Caption = 'Name';
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

