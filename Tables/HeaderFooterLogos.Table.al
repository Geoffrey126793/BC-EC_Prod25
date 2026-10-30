table 8001417 "Header/Footer Logos"
{
    // //+BGW+LOGO GESWAY 23/06/03 Table images documents

    Caption = 'Header/Footer Logos';


    fields
    {
        field(1; "No."; Code[10])
        {
            Caption = 'No.';
            NotBlank = true;
        }
        field(2; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(3; "Header Picture"; BLOB)
        {
            Caption = 'Header Picture';
        }
        field(4; "Footer Picture"; BLOB)
        {
            Caption = 'Footer Picture';
        }
        field(6; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(7; "Picture Type"; Code[10])
        {
            Caption = 'Picture Type';
            Editable = false;
        }
        field(8; "Next Header Picture"; BLOB)
        {
            Caption = 'Next Header Picture';
        }
        field(9; "Next Footer Picture"; BLOB)
        {
            Caption = 'Next Footer Picture';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    begin
        "Last Date Modified" := Today;
    end;

    var
        Text000: Label 'untitled';
        Text001: Label 'Do you want to replace the existing picture?';
        Text002: Label 'Do you want to delete the picture?';
}

