table 8001318 "Statistic category"
{
    // //STATSEXPLORER STATSEXPLORER 01/10/10 Statistic category

    Caption = 'Statistic category';
    LookupPageID = "Statistics categories";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(3; "Number of statistics"; Integer)
        {
            BlankZero = true;
            CalcFormula = Count ("Standard statistic" WHERE ("Catégory" = FIELD (Code)));
            Caption = 'Number of statistics';
            Editable = false;
            FieldClass = FlowField;
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

    var
        Colonne: Record "Statistic column";
        FiltreColonne: Record "Statistic column filter";
}

