table 8001306 "Column style name"
{
    // //STATSEXPLORER STATSEXPLORER 01/10/01 Column style name

    Caption = 'Column style name';
    LookupPageID = "Statistic column's name";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[80])
        {
            Caption = 'Description';
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

    trigger OnDelete()
    begin
        Colonne.SetRange(Code, Code);
        Colonne.DeleteAll;

        FiltreColonne.SetRange(Code, Code);
        FiltreColonne.DeleteAll;
    end;

    var
        Colonne: Record "Statistic column";
        FiltreColonne: Record "Statistic column filter";
}

