table 50013 "Gross Weight / container"
{
    // BT ABSYS 20070522 pour la gestion du poids brut pour EUROFRIFO
    // A mettre à jour sur les fiches info lots

    Caption = 'Gross Weight / container';
    DrillDownPageID = "Invoices bound by Receipt";
    LookupPageID = "Invoices bound by Receipt";

    fields
    {
        field(1; "Container type"; Code[20])
        {
            Caption = 'Container type';
        }
        field(2; Coeff; Decimal)
        {
            Caption = 'Coeff';
        }
    }

    keys
    {
        key(Key1; "Container type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

