table 8001412 "Misc. Translation"
{
    // //+BGW+TRANSLATION CW 26/01/02 New table for miscaleneous translation


    fields
    {
        field(1; TableID; Integer)
        {
            Caption = 'ID Table';
        }
        field(2; "Code"; Code[30])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(3; Language; Code[10])
        {
            Caption = 'Language';
            NotBlank = true;
            TableRelation = Language;
        }
        field(4; Description; Text[50])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; TableID, "Code", Language)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

