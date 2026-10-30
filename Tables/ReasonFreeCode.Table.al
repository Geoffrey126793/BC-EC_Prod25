table 50001 "Reason Free Code"
{
    // ------------------------------------------------------------------------------------------
    // ADV-001 ABSYS GN 20061018
    //   RFA : Gestion des gratuits
    // ------------------------------------------------------------------------------------------

    Caption = 'Free';
    DrillDownPageID = "Get Sales PriceEC";
    LookupPageID = "Get Sales PriceEC";

    fields
    {
        field(1; "Free Code"; Code[20])
        {
            Caption = 'Free Code';
            Description = 'ADV-001';
            NotBlank = true;
        }
        field(2; "Free Description"; Text[30])
        {
            Caption = 'Free Descritpion';
            Description = 'ADV-001';
        }
    }

    keys
    {
        key(Key1; "Free Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

