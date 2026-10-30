tableextension 50016 IntrastatJnlLineEC extends "Intrastat Jnl. Line"
{
    Caption = 'Intrastat Jnl. Line';

    fields
    {
        field(50001; "No donneur / preneur ordre"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Nom donneur / preneur ordre"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "No TVA"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Document No.2"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Location Code EC"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Partner ID EC"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
    }

}

