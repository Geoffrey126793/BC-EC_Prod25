tableextension 50072 TUserSetupEC extends "User Setup"
{
    fields
    {
        field(50006; "Location Filter"; Text[200])
        {
            Caption = 'Location Filter';
            Description = 'AB6.SEC';
        }
        field(50007; "Purchase Filter"; Text[200])
        {
            Caption = 'Purchase Filter';
            Description = 'AB6.SEC';
        }
        field(50008; "Email Body"; BLOB)
        {
            Caption = 'Email Body';
            Description = 'Email';

            trigger OnLookup()
            var
                EmailTemplateExists: Boolean;
            begin
            end;
        }
        field(50010; "Resp. Centrer Filter"; Text[200])
        {
            Caption = 'Resp. Centrer Filter';
            Description = 'EC.SEC1.00';
        }
        field(50020; "Allow Forced Price and Disc."; Boolean)
        {
            Caption = 'Allow Forced Price and Disc.';
            Description = 'ABC OLL';
        }
    }
}

