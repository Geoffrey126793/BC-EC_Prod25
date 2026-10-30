tableextension 50007 CountryRegionEC extends "Country/Region"
{
    fields
    {
        field(50000; "Bank Code 1"; Code[20])
        {
            Caption = 'Bank Code 1';
            Description = 'DOC';
            TableRelation = "Bank Account"."No.";
        }
        field(50001; "Bank Code 2"; Code[20])
        {
            Caption = 'Bank Code 2';
            Description = 'DOC';
            TableRelation = "Bank Account"."No.";
        }
        field(50002; "Bank Code 3"; Code[20])
        {
            Caption = 'Bank Code 3';
            Description = 'DOC';
            TableRelation = "Bank Account"."No.";
        }
        field(50003; "Bank Code 4"; Code[20])
        {
            Caption = 'Bank Code 4';
            Description = 'DOC';
            TableRelation = "Bank Account"."No.";
        }
        field(50004; "ISO Country/Region Code3"; Code[3])
        {
            Caption = 'ISO Country/Region Code3';
        }
        field(50005; "Bank Code 5"; Code[20])
        {
            Caption = 'Bank Code 5';
            Description = 'DOC';
            TableRelation = "Bank Account"."No.";
        }
        field(50006; "Assistant commercial"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;
        }
    }

}

