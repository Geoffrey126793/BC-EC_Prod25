tableextension 50029 LocationEC extends Location
{

    fields
    {
        field(50000; "Zero Qty To Receive"; Boolean)
        {
            Caption = 'Zero Qty To Receive';
            Description = 'ACH-001';
        }
        field(50001; "Veterinian Comment Type"; Option)
        {
            Caption = 'Veterinian Comment Type';
            OptionCaption = ' ,Type 1 (TEMSE),Type 2 (WB)';
            OptionMembers = " ","Type 1 (TEMSE)","Type 2 (WB)";
        }
        field(50100; "Pallet Management"; Boolean)
        {
            Caption = 'Pallet Management';
        }
        field(50101; "Default Recept. bin"; Code[20])
        {
            Caption = 'Default Recept. bin';
            TableRelation = Bin.Code WHERE("Location Code" = FIELD(Code));
        }
        field(50102; "Default Ship. bin"; Code[20])
        {
            Caption = 'Default Ship. bin';
            TableRelation = Bin.Code WHERE("Location Code" = FIELD(Code));
        }
        field(50103; "Qty check"; Boolean)
        {
            Caption = 'Qty check';
        }
        field(50104; Disabled; Boolean)
        {
            Caption = 'Disabled';
        }
        field(50105; "No TVA"; Code[30])
        {
            Caption = 'No TVA';
        }
    }

}

