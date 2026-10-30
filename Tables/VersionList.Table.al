table 8001410 "Version List"
{
    // //VERSION GESWAY 01/12/01 Gestion de la Version List

    DataPerCompany = false;

    fields
    {
        field(1; "Entry ID"; Integer)
        {
        }
        field(2; "Version List"; Text[80])
        {
        }
        field(3; UserID; Code[50])
        {
        }
        field(4; Date; Date)
        {
        }
        field(5; Time; Time)
        {
        }
    }

    keys
    {
        key(Key1; "Entry ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        ModeleFeuille: Record "Gen. Journal Template";
        NomFeuille: Record "Gen. Journal Batch";
}

