tableextension 50017 InventorySetupEC extends "Inventory Setup"
{
    fields
    {
        field(50010; "Picking of Lot based on FIFO"; Boolean)
        {
            Caption = 'Picking of Lot based on FIFO';
            Description = 'ART-004';
        }
        field(50100; "Journal Template Name Consign"; Code[10])
        {
            Caption = 'Journal Template Name Consign';
            Description = 'ART-003';
            TableRelation = "Item Journal Template" WHERE(Type = CONST(Item),
                                                           Recurring = CONST(false));
        }
        field(50101; "Journal Batch Name Consign"; Code[10])
        {
            Caption = 'Journal Batch Name Consign';
            Description = 'ART-003';
            TableRelation = "Item Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Template Name Consign"));
        }
        field(50200; "Pallet Nos."; Code[20])
        {
            Caption = 'Pallet Nos.';
            TableRelation = Microsoft.Foundation.NoSeries."No. Series";
        }
        field(70100; "Item Alert on Sales Order/Inv"; Boolean)
        {
            Caption = 'Item Alert on Sales Order/Inv';
            Description = 'ABS2.00';
        }
        field(70101; "Item Alert on Purch Order/Inv"; Boolean)
        {
            Caption = 'Item Alert on Purch Order/Inv';
            Description = 'ABS2.00';
        }
    }

}

