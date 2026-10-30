tableextension 50005 CompanyInformationEC extends "Company Information"
{

    fields
    {
        field(50000; "Code Génération EAN Company"; Code[7])
        {
            Caption = 'Code Génération EAN Company';
            DataClassification = ToBeClassified;
            Description = 'ART-001';
        }
        field(50001; "Nº Registre de Commerce"; Text[30])
        {
            Caption = 'Nº Registre de Commerce';
            DataClassification = ToBeClassified;
            Description = 'DOC';
        }
        field(50002; "Bank Account BE 2"; Text[30])
        {
            Caption = 'Bank Account BE 2';
            DataClassification = ToBeClassified;
        }
        field(50003; "Bank Account FR"; Text[30])
        {
            Caption = 'Bank Account FR';
            DataClassification = ToBeClassified;
        }
        field(50004; "Bank Account GB"; Text[30])
        {
            Caption = 'Bank Account GB';
            DataClassification = ToBeClassified;
        }
        field(50010; "Mail Subject ESP"; Text[50])
        {
            Caption = 'Mail Subject ESP';
            DataClassification = ToBeClassified;
        }
        field(50011; "Mail Subject FRB"; Text[50])
        {
            Caption = 'Mail Subject FR';
            DataClassification = ToBeClassified;
            Description = 'email';
        }
        field(50012; "Mail Subject ENU"; Text[50])
        {
            Caption = 'Mail Subject ENU';
            DataClassification = ToBeClassified;
            Description = 'email';
        }
        field(50013; "Mail Subject DEU"; Text[50])
        {
            Caption = 'Mail Subject DEU';
            DataClassification = ToBeClassified;
        }
        field(50014; "Mail Subject NLD"; Text[50])
        {
            Caption = 'Mail Subject NLD';
            DataClassification = ToBeClassified;
            Description = 'email';
        }
        field(50015; "Mail Body ESP"; Text[50])
        {
            Caption = 'Mail Body ESP';
            DataClassification = ToBeClassified;
        }
        field(50016; "Mail Body FRB"; Text[50])
        {
            Caption = 'Mail Body FR';
            DataClassification = ToBeClassified;
            Description = 'email';
        }
        field(50017; "Mail Body ENU"; Text[50])
        {
            Caption = 'Mail Body ENU';
            DataClassification = ToBeClassified;
            Description = 'email';
        }
        field(50018; "Mail Body DEU"; Text[50])
        {
            Caption = 'Mail Body DEU';
            DataClassification = ToBeClassified;
        }
        field(50019; "Mail Body NLD"; Text[50])
        {
            Caption = 'Mail Body NLD';
            DataClassification = ToBeClassified;
            Description = 'email';
        }
        field(50020; "Mail BCC"; Text[50])
        {
            Caption = 'Mail BCC';
            DataClassification = ToBeClassified;
            Description = 'email bcc/cci CTD';
        }
        field(50021; SeqIDPtachOEE; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(70100; "Use Alert Management"; Boolean)
        {
            Caption = 'Use Alert Management';
            DataClassification = ToBeClassified;
            Description = 'ABS2.00';
        }
    }
}

