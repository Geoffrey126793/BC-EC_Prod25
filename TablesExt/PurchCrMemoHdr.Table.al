tableextension 50076 PurchCrMemoHdrEC extends "Purch. Cr. Memo Hdr."
{
    fields
    {
        field(50005; "Nbre attachements"; Integer)
        {
            CalcFormula = Count("Document Attachment" WHERE("Table ID" = CONST(124),
                                                             "No." = FIELD("No.")));
            FieldClass = FlowField;
        }
    }

}

