tableextension 50060 SalesPriceAndLineDiscBufferEC extends "Sales Price and Line Disc Buff"
{
    fields
    {
        field(50010; "Order Minimum Quantity"; Decimal)
        {
            Caption = 'Order Minimum Quantity';
            DataClassification = ToBeClassified;
            Description = 'ABC OLL';
            MinValue = 0;
        }
        field(50011; "Order Minimum Palettes"; Integer)
        {
            Caption = 'Order Minimum Palettes';
            DataClassification = ToBeClassified;
        }
    }

}

