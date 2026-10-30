table 8001322 "Statistics translations"
{
    // //STATSEXPLORER STATSEXPLORER 01/10/10 Statistics translations

    Caption = 'Statistics translations';
    DataPerCompany = false;
    LookupPageID = "Statistics categories";

    fields
    {
        field(1; Description; Text[100])
        {
        }
        field(5; "Language ID"; Integer)
        {
            Caption = 'Language Code';
            TableRelation = "Windows Language";
        }
        field(10; Translation; Text[100])
        {
            Caption = 'Translation';
        }
    }

    keys
    {
        key(Key1; Description, "Language ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Colonne: Record "Statistic column";
        FiltreColonne: Record "Statistic column filter";
}

