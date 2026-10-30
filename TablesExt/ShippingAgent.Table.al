tableextension 50065 ShippingAgentEC extends "Shipping Agent"
{
    fields
    {
        field(50000; Address; Text[30])
        {
            Caption = 'Address';
        }
        field(50001; "Address 2"; Text[30])
        {
            Caption = 'Address 2';
        }
        field(50002; City; Text[30])
        {
            Caption = 'City';

            trigger OnLookup()
            begin
                //Postcode.LookUpCity(City,"Post Code",TRUE);
            end;

            trigger OnValidate()
            begin
                //Postcode.ValidateCity(City,"Post Code",County,"Country Code",TRUE);
            end;
        }
        field(50003; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = "Post Code".Code;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                //Postcode.LookupPostCode(City,"Post Code",County,"Country Code");
            end;

            trigger OnValidate()
            begin
                //Postcode.ValidatePostCode(City,"Post Code",County,"Country Code",TRUE);
            end;
        }
        field(50004; County; Text[30])
        {
            Caption = 'County';
        }
        field(50005; "Country Code"; Code[10])
        {
            Caption = 'Country Code';
            TableRelation = "Country/Region";
        }
        field(50006; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
        }
        field(50007; "Buy-from Vendor No."; Code[20])
        {
            Caption = 'Buy-from Vendor No.';
            TableRelation = Vendor;
        }
    }

}

