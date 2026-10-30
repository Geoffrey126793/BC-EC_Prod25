tableextension 50052 SalesCrMemoHeaderEC extends "Sales Cr.Memo Header"
{
    fields
    {
        field(50003; "Order type"; Option)
        {
            Caption = 'Order type';
            Description = 'LOG-004';
            OptionCaption = ' ,Frais,Surgelé';
            OptionMembers = " ",Frais,"Surgelé";
        }
        field(50004; "Logistic unit"; Code[20])
        {
            Caption = 'Logistic unit';
            Description = 'LOG-004';
        }
        field(50005; "Unit price/Palette"; Decimal)
        {
            Caption = 'Unit price/Palette';
            Description = 'LOG-004';
        }
        field(50006; "Territory Code"; Code[10])
        {
            Caption = 'Territory Code';
            Description = 'LOG-004';
            TableRelation = Territory;
        }
    }
}

