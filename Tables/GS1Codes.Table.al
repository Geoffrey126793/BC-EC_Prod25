table 50029 GS1Codes
{
    Caption = 'GS1Codes';

    fields
    {
        field(1; DE; Code[30])
        {
            Caption = 'DE';
        }
        field(2; "Code"; Text[30])
        {
            Caption = 'Code';
        }
        field(3; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(4; Traitement; Code[10])
        {
            Caption = 'Traitement';
        }
    }

    keys
    {
        key(Key1; DE, "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

