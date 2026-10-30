tableextension 50064 SalesShipmentLineEC extends "Sales Shipment Line"
{
    fields
    {
        field(50002; "Forced Unit Price"; Boolean)
        {
            Caption = 'Forced Unit Price';
            DataClassification = ToBeClassified;
            Description = 'ABC OLL';
        }
        field(50020; "Transport Unit Price"; Decimal)
        {
            Caption = 'Transport Unit Price';
            Description = 'LOG-004';
        }
        field(50028; "Qte commandée initiale"; Decimal)
        {
            Caption = 'Qte commandée initiale';
        }
        field(50030; "Qte commandée initiale Base"; Decimal)
        {
            Caption = 'Qte commandée initiale';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(50093; "Px Depart"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50094; "Px 3x Net"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50095; "Ship-to Country/Region Code"; Code[20])
        {
            CalcFormula = Lookup(Customer."Country/Region Code" WHERE("No." = FIELD("Sell-to Customer No.")));
            FieldClass = FlowField;
        }
    }

}

