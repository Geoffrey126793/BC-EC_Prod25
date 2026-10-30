tableextension 50033 ProdOrderComponentEC extends "Prod. Order Component"
{
    fields
    {
        field(50001; "Item Category"; Code[20])
        {
            CalcFormula = Lookup(Item."Item Category Code" WHERE("No." = FIELD("Item No.")));
            Caption = 'Item Category';
            FieldClass = FlowField;
        }
        field(50002; "Item to produce"; Code[20])
        {
            CalcFormula = Lookup("Prod. Order Line"."Item No." WHERE(Status = FIELD(Status),
                                                                      "Prod. Order No." = FIELD("Prod. Order No."),
                                                                      "Line No." = FIELD("Prod. Order Line No.")));
            Caption = 'Item to produce';
            FieldClass = FlowField;
        }
        field(50003; Stock; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("Item No."),
                                                                  "Location Code" = FILTER('EC DORMA' | 'EC TOURNAI')));
            FieldClass = FlowField;
        }
    }

}