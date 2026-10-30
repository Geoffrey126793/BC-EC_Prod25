tableextension 50040 PurchasePriceEC extends "Purchase Price"
{
    fields
    {
        field(50001; Nom; Text[100])
        {
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("Vendor No.")));
            Caption = 'Nom';
            FieldClass = FlowField;
        }
        field(50002; "Bloqué"; Boolean)
        {
            CalcFormula = Lookup(Item.Blocked WHERE("No." = FIELD("Item No.")));
            Caption = 'Bloqué';
            FieldClass = FlowField;
        }
    }

}

