table 50019 "Pallet Ledger Entry"
{
    // VN1.00 KWK 05/03/2010
    //   Added key Entry Type,Location Code,SSCC No.
    // 
    // Module      Point          Dev   Date           Commentaire
    // ----------------------------------------------------------------------------------------------------
    // VN1.00     LOG-100        GEN   14/09/09   :   Module de gestion des palettes
    // ----------------------------------------------------------------------------------------------------

    Caption = 'Pallet Ledger Entry';
    DrillDownPageID = "Pallet Ledger Entries";
    LookupPageID = "Pallet Ledger Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "SSCC No."; Code[20])
        {
            Caption = 'SSCC No.';
            TableRelation = Pallet;
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(4; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Output,Purchase,Sale,Positive Adjmt.,Negative Adjmt.,Transfer,Consumption';
            OptionMembers = Output,Purchase,Sale,"Positive Adjmt.","Negative Adjmt.",Transfer,Consumption;
        }
        field(6; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(7; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(8; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(9; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(10; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
        }
        field(12; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(50000; "Bin Code"; Code[20])
        {
            Caption = 'Bin code';
        }
        field(50010; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE ("Item No." = FIELD ("Item No."));
        }
        field(50100; "Item ledger entry No."; Integer)
        {
            Caption = 'Item ledger entry No.';
            TableRelation = "Item Ledger Entry";
        }
        field(50101; Weight; Decimal)
        {
            Caption = 'Weight';
        }
        field(50102; "Qty. By Pallet"; Decimal)
        {
            Caption = 'Qty. By Pallet';
            DecimalPlaces = 0 : 5;
        }
        field(50103; "Prod. Order No."; Code[20])
        {
            Caption = 'Prod. Order No.';
        }
        field(50104; "Prod. Operation No."; Integer)
        {
            Caption = 'Prod. Operation No.';
        }
        field(50105; User; Code[20])
        {
            Caption = 'User';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "SSCC No.", "Posting Date")
        {
        }
        key(Key3; "SSCC No.")
        {
            SumIndexFields = Quantity, Weight, "Qty. By Pallet";
        }
        key(Key4; "Document No.", "Posting Date")
        {
        }
        key(Key5; "Item ledger entry No.")
        {
        }
        key(Key6; "SSCC No.", "Location Code")
        {
            SumIndexFields = Quantity;
        }
        key(Key7; "Entry Type", "Document No.", "SSCC No.")
        {
            SumIndexFields = Quantity;
        }
        key(Key8; "Entry Type", "Prod. Order No.", "Prod. Operation No.")
        {
        }
        key(Key9; "Entry Type", "Location Code", "SSCC No.")
        {
            SumIndexFields = Quantity;
        }
    }

    fieldgroups
    {
    }
}

