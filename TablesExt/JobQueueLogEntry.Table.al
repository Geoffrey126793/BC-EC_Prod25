tableextension 50028 JobQueueLogEntryEC extends "Job Queue Log Entry"
{

    fields
    {
        field(50001; Parametre; Text[250])
        {
            CalcFormula = Lookup("Job Queue Entry"."Parameter String" WHERE(ID = FIELD(ID)));
            Caption = 'Parametre';
            FieldClass = FlowField;
        }
    }

}

