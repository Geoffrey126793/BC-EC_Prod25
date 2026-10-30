table 8001323 "Statistic User"
{
    // //STATSEXPLORER STATSEXPLORER 01/10/10 Statistic User for sheduler line

    Caption = 'Statistic Compagny';

    fields
    {
        field(1; "Sheduler code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
            TableRelation = "Statistic Scheduler header";
        }
        field(2; "Statistic code"; Code[10])
        {
            Caption = 'Statistic code';
        }
        field(3; "User ID"; Code[50])
        {
            Caption = 'User ID';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;


        }
    }

    keys
    {
        key(Key1; "Sheduler code", "Statistic code", "User ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

