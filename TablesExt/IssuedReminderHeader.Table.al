tableextension 50018 IssuedReminderHeaderEC extends "Issued Reminder Header"
{
    fields
    {
        field(50000; "Salesperson Code"; Code[10])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(50001; "Envoi automatique"; Boolean)
        {
            Caption = 'Envoi automatique';
        }
        field(50002; "E-Mail envoyé"; Boolean)
        {
            Caption = 'E-Mail envoyé';
        }
    }

}

