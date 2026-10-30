table 50012 "Unité logistique / article"
{
    Caption = 'Unité logistique / article';
    DrillDownPageID = "Logistic Unit / Item";
    LookupPageID = "Logistic Unit / Item";

    fields
    {
        field(1; "Logistic unit"; Code[20])
        {
            Caption = 'Logistic unit';
            TableRelation = "Unité logistique";
        }
        field(2; "Item no"; Code[20])
        {
            Caption = 'Item no';
            TableRelation = Item;
        }
        field(3; "Palette weight"; Decimal)
        {
            Caption = 'Palette weight';
        }
    }

    keys
    {
        key(Key1; "Logistic unit", "Item no")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

