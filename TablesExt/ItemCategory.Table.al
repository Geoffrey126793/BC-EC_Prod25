tableextension 50021 ItemCategoryEC extends "Item Category"
{

    fields
    {

        field(50000; "Code Generation  EAN"; Code[2])
        {
            Caption = 'Code Generation  EAN';
            Description = 'ART-001';
        }
        field(50001; "Last sequential EAN Code"; Code[3])
        {
            Caption = 'Last sequential EAN Code';
            Description = 'ART-001';
            InitValue = '0';
        }
        field(50002; "Inventory Value Zero"; Boolean)
        {
            Caption = 'Inventory Value Zero';
            Description = 'ART-002';
        }
    }

}

