tableextension 50025 ItemTrackingCodeEC extends "Item Tracking Code"
{

    fields
    {
        field(50000; "Information Lot Automaticaly"; Boolean)
        {
            Caption = 'Information Lot Automaticaly';
            Description = 'LOG-002';
            InitValue = true;
        }
        field(50100; "Pallet Management"; Boolean)
        {
            Caption = 'Pallet Management';
            Description = 'LOG-100';
        }
    }

}

