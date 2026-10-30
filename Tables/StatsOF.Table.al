table 50028 "Stats OF"
{
    Caption = 'Stats OF';

    fields
    {
        field(1; "OF"; Code[30])
        {
            Caption = 'OF';
        }
        field(2; Date; Date)
        {
            Caption = 'Date';
        }
        field(3; "Quantite produite"; Decimal)
        {
            Caption = 'Quantite produite';
        }
        field(4; Article; Code[20])
        {
            Caption = 'Article';
        }
        field(6; "Type source"; Code[20])
        {
            Caption = 'Type source';
        }
        field(7; source; Code[20])
        {
            Caption = 'source';
        }
        field(8; "Quantité utilisee"; Decimal)
        {
            Caption = 'Quantité utilisee';
        }
        field(9; "Cout total"; Decimal)
        {
            Caption = 'Cout total';
        }
        field(10; "Cout unitaire"; Decimal)
        {
            Caption = 'Cout unitaire';
        }
        field(11; Lot; Text[50])
        {
            Caption = 'Lot';
        }
        field(12; Niveau; Integer)
        {
            Caption = 'Niveau';
        }
        field(13; Direction; Code[20])
        {
            Caption = 'Direction';
        }
        field(14; "Cout total standard"; Decimal)
        {
            Caption = 'Cout total standard';
        }
        field(15; "Cout unitaire standard"; Decimal)
        {
            Caption = 'Cout unitaire standard';
        }
        field(16; "Cout total nomencl std"; Decimal)
        {
            Caption = 'Cout total nomencl std';
        }
        field(17; "Cout unitaire nomencl std"; Decimal)
        {
            Caption = 'Cout unitaire nomencl std';
        }
        field(18; "Quantité nomenclature"; Decimal)
        {
            Caption = 'Quantité nomenclature';
        }
        field(19; "Quantité intermédiaire"; Decimal)
        {
            Caption = 'Quantité intermédiaire';
        }
        field(20; Ecriture; Integer)
        {
            Caption = 'Ecriture';
        }
        field(21; "Cout unitaire direct ateliers"; Decimal)
        {
            Caption = 'Cout unitaire direct ateliers';
            DecimalPlaces = 0 : 5;
        }
        field(22; "Cout total direct ateliers"; Decimal)
        {
            Caption = 'Cout total direct ateliers';
        }
        field(23; "Quantité intermédiaire nomencl"; Decimal)
        {
            Caption = 'Quantité intermédiaire nomencl';
        }
        field(24; "Quantité nomenclature OF"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Cout total nomenclature OF"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Cout unitaire nomencl OF"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(27; "Quantité intermédiaire nom OF"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(28; source2; Code[20])
        {
            Caption = 'source';
            DataClassification = ToBeClassified;
        }
        field(29; Cru; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "OF", Date, "Type source", source, Niveau, Direction, Ecriture, source2)
        {
            Clustered = true;
        }
        key(Key2; "OF", source, Lot)
        {
        }
    }

    fieldgroups
    {
    }
}

