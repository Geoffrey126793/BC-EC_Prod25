table 8001321 "Statistic Company"
{
    // //STATSEXPLORER STATSEXPLORER 01/10/10 Statistic Company for multiple-company statistics

    Caption = 'Statistic Compagny';

    fields
    {
        field(1; "Statistic code"; Code[10])
        {
            Caption = 'Statistic code';
        }
        field(2; Company; Text[30])
        {
            Caption = 'Company';
            NotBlank = true;
            TableRelation = Company;
        }
    }

    keys
    {
        key(Key1; "Statistic code", Company)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

