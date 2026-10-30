tableextension 50035 ProductionBOMHeaderEC extends "Production BOM Header"
{
    fields
    {
        field(50001; "Programme injection"; Code[40])
        {
            Caption = 'Programme injection';
        }
        field(50002; "Programme malaxage"; Code[40])
        {
            Caption = 'Programme malaxage';
        }
        field(50003; "Programme malaxage extra"; Code[40])
        {
            Caption = 'Programme malaxage extra';
        }
        field(50004; Melangeur; Code[40])
        {
            Caption = 'Melangeur';
        }
        field(50005; "Melangeur phase 2"; Code[40])
        {
            Caption = 'Melangeur phase 2';
        }
        field(50006; "T° finale malaxage"; Code[40])
        {
            Caption = 'T° finale malaxage';
        }
        field(50007; Broyeur; Code[40])
        {
            Caption = 'Broyeur';
        }
        field(50008; "Message malaxage"; Text[250])
        {
            Caption = 'Message malaxage';
        }
        field(50009; "Quantite par malaxage"; Decimal)
        {
            Caption = 'Quantite par malaxage';
        }
        field(50010; "Calcul en cours"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
}

