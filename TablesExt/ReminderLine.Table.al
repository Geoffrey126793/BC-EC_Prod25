tableextension 50048 ReminderLineEC extends "Reminder Line"
{
    fields
    {
        field(50000; "Not Due"; Boolean)
        {
            Caption = 'Not Due';
            Description = 'ABSYS GN 20070409';
            Editable = false;
        }
    }

}

