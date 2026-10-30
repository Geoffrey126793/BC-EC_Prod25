table 50002 "Track. Specif. Viewer Item Ldg"
{
    // ----------------------------------------------------------------------------------------------
    // LOG-003 ABSYS GN 20061030
    //   Arborescence Traçabilité
    // ------------------------------------------------------------------------------------------

    Caption = 'Track. Specif. Viewer Item Ldg';

    fields
    {
        field(1; User; Code[20])
        {
            Caption = 'User';
        }
        field(2; "Track Specif. Viewer Line No."; Integer)
        {
            Caption = 'Track Specif. Viewer Line No.';
        }
        field(3; "Item Ledger Entry Linked"; Integer)
        {
            Caption = 'Item Ledger Entry Linked';
        }
    }

    keys
    {
        key(Key1; User)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

