table 50038 "Tarif transport"
{

    fields
    {
        field(1; Fournisseur; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }
        field(2; Indice; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; Debut; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Type transport"; Option)
        {
            Caption = 'Type transport';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Frais,Surgelé';
            OptionMembers = " ",Frais,"Surgelé";
        }
        field(5; "Nombre de palettes minimum"; Integer)
        {
            Caption = 'Number of Pallets';
            DataClassification = ToBeClassified;
        }
        field(6; "Currency code"; Code[20])
        {
            Caption = 'Currency code';
            DataClassification = ToBeClassified;
            TableRelation = Currency;
        }
        field(7; Fin; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Tarif / palette"; Decimal)
        {
            Caption = 'Paletts / Price';
            DataClassification = ToBeClassified;
        }
        field(9; "Tarif / Kg"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Poids Maximum"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(11; Pays; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(12; "Type Prix"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Tpt,Admin;
        }
        field(13; "Frais admin / palette"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Frais admin / livraison"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Frais admin (%)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Taxes (%)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Taxes + frais admin (%)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Accises (%)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Indice du transport (%)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Indice du transport +admin (%)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Indice du tpt non routier (%)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Frais de douane / commande"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Frais certificat veterinaire"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Remise (%)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; Fournisseur, "Type Prix", "Type transport", Debut, Pays, "Nombre de palettes minimum", "Poids Maximum")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

