tableextension 50003 BinEC extends "Bin"
{
    fields
    {
        field(50090; "Lot Filter"; Code[20])
        {
            Caption = 'Lot Filter';
            FieldClass = FlowFilter;
        }
        field(50100; "Inventory Warehouse Entry"; Decimal)
        {
            CalcFormula = Sum("Warehouse Entry"."Qty. (Base)" WHERE("Location Code" = FIELD("Location Code"),
                                                                     "Bin Code" = FIELD(Code),
                                                                     "Item No." = FIELD("Item Filter"),
                                                                     "Lot No." = FIELD("Lot Filter")));
            Caption = 'Inventory Warehouse Entry';
            DecimalPlaces = 0 : 2;
            FieldClass = FlowField;
        }
    }

}

