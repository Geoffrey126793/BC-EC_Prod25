table 8001315 "Statistic definition"
{
    // //STATSEXPLORER STATSEXPLORER 01/10/01 Statistic definitions by user

    Caption = 'Statistic definition';

    fields
    {
        field(1; "User ID"; Code[50])
        {
            Caption = 'User ID';
        }
        field(3; "Statistic code"; Code[10])
        {
            Caption = 'Statistic code';
        }
        field(5; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(10; Description; Text[250])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "User ID", "Statistic code", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

