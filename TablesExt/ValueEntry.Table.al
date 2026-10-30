tableextension 50073 ValueEntryEC extends "Value Entry"
{
    fields
    {
        field(50010; "Resaon Free Code"; Code[20])
        {
            Caption = 'Reason Free Code';
            Description = 'ADV-001';
            Editable = false;
            TableRelation = "Return Reason";
        }
        field(50011; "Free Line"; Boolean)
        {
            Caption = 'Free Line';
            Description = 'ADV-001';
            Editable = false;
        }
    }
}

