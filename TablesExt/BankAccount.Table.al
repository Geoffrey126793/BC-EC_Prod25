tableextension 50002 BankAccountEC extends "Bank Account"
{
    fields
    {
        field(50000; "BankNo CODA"; Code[10])
        {
            Caption = 'Bank No for CODA Doc';
            Description = 'AB6 20120921';
        }
        field(50001; Logo; BLOB)
        {
            Caption = 'Logo';
            SubType = Bitmap;
        }

    }
}

