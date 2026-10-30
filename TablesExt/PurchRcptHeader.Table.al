tableextension 50045 PurchRcptHeaderEC extends "Purch. Rcpt. Header"
{
    fields
    {
        field(50004; Container; Text[30])
        {
            Caption = 'Container';
            Description = 'FON-001';
        }
        field(50011; "Status Visa2"; Option)
        {
            Caption = 'Status Visa';
            DataClassification = ToBeClassified;
            Description = 'ACH-003';
            OptionCaption = 'On standby visa, Visa authorized';
            OptionMembers = "On standby visa ","Visa authorized";
        }
        field(50012; "Person in charge Visa2"; Code[50])
        {
            Caption = 'Person in charge Visa';
            DataClassification = ToBeClassified;
            Description = 'ACH-003';
        }
        field(50013; "Date Visa2"; Date)
        {
            Caption = 'Date Visa';
            DataClassification = ToBeClassified;
            Description = 'ACH-003';
        }
        field(55004; "Type commande"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Qualite,Production,HR,RD,Finance,Logistique,Transport,Technique,Securite;
        }
    }

}

