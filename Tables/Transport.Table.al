table 50010 Transport
{
    // AB6.VIR.190509 : Ajout field 50000 : Code transporteur / "Netto Price" / "Diesel per"

    Caption = 'Transport';

    fields
    {
        field(1; "Territory code"; Code[20])
        {
            Caption = 'Territory code';
            TableRelation = Territory;
        }
        field(2; "Type transport"; Option)
        {
            Caption = 'Type transport';
            OptionCaption = ' ,Frais,Surgelé';
            OptionMembers = " ",Frais,"Surgelé";
        }
        field(3; "Paletts type"; Code[20])
        {
            Caption = 'Paletts type';
            TableRelation = "Unité logistique";
        }
        field(4; "Number of Pallets"; Integer)
        {
            Caption = 'Number of Pallets';
        }
        field(5; "Currency code"; Code[20])
        {
            Caption = 'Currency code';
            TableRelation = Currency;
        }
        field(6; "Starting date"; Date)
        {
            Caption = 'Starting date';
        }
        field(7; "End date"; Date)
        {
            Caption = 'End date';
        }
        field(8; "Paletts / Price"; Decimal)
        {
            Caption = 'Paletts / Price';
        }
        field(9; Transport; Code[20])
        {
            Caption = 'Transport';
            TableRelation = Resource;
        }
        field(50000; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";
        }
        field(50001; Type; Option)
        {
            Caption = 'Sales,Purchase';
            OptionCaption = 'Sales,Purchase';
            OptionMembers = Vente,Achats;
        }
        field(50002; "Netto Price"; Decimal)
        {
            Caption = 'Price HT';

            trigger OnValidate()
            begin

                if "Diesel Per" <> 0 then
                    "Paletts / Price" := "Netto Price" * (1 + "Diesel Per" / 100);
            end;
        }
        field(50003; "Diesel Per"; Decimal)
        {
            Caption = 'Diesel Tax';

            trigger OnValidate()
            begin

                if "Netto Price" <> 0 then
                    "Paletts / Price" := "Netto Price" * (1 + "Diesel Per" / 100);
            end;
        }
    }

    keys
    {
        key(Key1; Type, "Territory code", "Type transport", "Paletts type", "Number of Pallets", "Currency code", "Starting date", "Shipping Agent Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

