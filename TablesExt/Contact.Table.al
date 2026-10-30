tableextension 50006 ContactC extends Contact
{
    fields
    {
        field(50001; Responsabilites; Text[150])
        {
            Caption = 'Responsabilites';
        }
        field(50301; Password; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50302; ChangePw; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50303; salt; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50304; PwdValidityUntil; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(50305; LastConnection; DateTime)
        {
            DataClassification = ToBeClassified;
        }
    }
}

