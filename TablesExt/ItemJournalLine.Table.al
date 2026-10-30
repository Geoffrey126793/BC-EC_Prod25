tableextension 50023 ItemJournalLineEC extends "Item Journal Line"
{
    fields
    {
        field(50000; "Phys Inventory Lot No."; Code[20])
        {
            Caption = 'Physical Inventory Lot No.';
            Description = 'LOG-001';
        }
        field(50010; "Reason Free Code"; Code[20])
        {
            Caption = 'Reason Free Code';
            Description = 'ADV-001';
            Editable = false;
        }
        field(50011; "Free Line"; Boolean)
        {
            Caption = 'Free Line';
            Description = 'ADV-001';
            Editable = false;
        }
        field(50012; "Intrastat Value on Free Line"; Decimal)
        {
            Caption = 'Intrastat Value on Free Line';
            Description = 'ADV-001';
        }
        field(50015; "Discount Rule of Item Free"; Code[20])
        {
            Caption = 'Discount Rule of Item Free';
            Description = 'ADV-001TEMP';
        }
        field(50016; "Item Source of Item Free"; Code[20])
        {
            Caption = 'Item Source of Item Free';
            Description = 'ADV-001TEMP';
        }
        field(50017; "Qty Item Source of Item Free"; Decimal)
        {
            Caption = 'Qty Item Source of Item Free';
            Description = 'ADV-001TEMP';
            Editable = false;
        }
        field(50100; Consign; Boolean)
        {
            Caption = 'Consign';
            Description = 'ART-003';
        }
        field(50199; "Document No. Pallet"; Code[20])
        {
            Caption = 'Document No.';
            Description = 'ABC GEN 20130628';
        }
        field(50200; "Document Line No. Pallet"; Integer)
        {
            Caption = 'Document Line No.';
            Description = 'ABC GEN 20130628';
        }
        field(55000; "On Boat"; Boolean)
        {
            Caption = 'On Boat';
            Description = 'LOG-005';
        }
        field(55001; "Available For Sale Date"; Date)
        {
            Caption = 'Available For Sale Date';
            Description = 'LOG-005';
        }
    }
}

