tableextension 50059 SalesPersonPurchaserEC extends "Salesperson/Purchaser"
{
    fields
    {
        field(50000; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';
        }
        field(51000; Address; Text[30])
        {
            Caption = 'Address';
            Description = 'AB6.VR.01';
        }
        field(51001; Address2; Text[30])
        {
            Caption = 'Address2';
            Description = 'AB6.VR.01';
        }
        field(51002; City; Text[30])
        {
            Caption = 'City';
            Description = 'AB6.VR.01';
        }
        field(51003; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            Description = 'AB6.VR.01';
        }
        field(51004; "GSM number"; Text[30])
        {
            Caption = 'GSM number';
        }
        field(51005; User; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = User."Authentication Email";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(51006; Signature; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(51007; UserResp; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;
        }
    }

}

