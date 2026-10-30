table 50027 "Histo couts"
{
    Caption = 'Histo couts';

    fields
    {
        field(1; Item; Code[20])
        {
            Caption = 'Item';
            TableRelation = Item;
        }
        field(2; Date; Date)
        {
            Caption = 'Date';
        }
        field(3; Cout; Decimal)
        {
            Caption = 'Cout';
        }
        field(4; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Cout standard,Prix de revient matiére,Prix de revient total,Prix de revient total sans 22A,ABC';
            OptionMembers = "Cout standard","Prix de revient matiére","Prix de revient total","Prix de revient total sans 22A",ABC;
        }
    }

    keys
    {
        key(Key1; Item, Date, Type)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

