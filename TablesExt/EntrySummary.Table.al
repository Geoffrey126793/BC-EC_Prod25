tableextension 50012 EntrySummaryEC extends "Entry Summary"
{

    fields
    {
        field(50000; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(50060; "Pick Qty."; Decimal)
        {
            CalcFormula = Sum("Warehouse Activity Line"."Qty. Outstanding" WHERE("Item No." = FIELD("Item No."),
                                                                                  "Action Type" = CONST(Take),
                                                                                  "Lot No." = FIELD("Lot No.")));
            Caption = 'Pick Qty.';
            DecimalPlaces = 0 : 2;
            FieldClass = FlowField;
        }
        field(50100; "Inventory Warehouse Entry"; Decimal)
        {
            CalcFormula = Sum("Warehouse Entry"."Qty. (Base)" WHERE("Item No." = FIELD("Item No."),
                                                                     "Lot No." = FIELD("Lot No.")));
            Caption = 'Inventory Warehouse Entry';
            DecimalPlaces = 0 : 2;
            FieldClass = FlowField;
        }
    }

}

