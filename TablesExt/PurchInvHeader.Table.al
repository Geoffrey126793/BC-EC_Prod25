tableextension 50043 PurchInvHeaderEC extends "Purch. Inv. Header"
{
    fields
    {
        field(50004; Container; Text[30])
        {
            Caption = 'Container';
            Description = 'FON-001';
        }
        field(50005; "Nbre attachements"; Integer)
        {
            CalcFormula = Count("Document Attachment" WHERE("Table ID" = CONST(122),
                                                             "No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(55003; Note; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

}

