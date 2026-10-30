tableextension 50032 PaymentJournalLineEC extends "Payment Journal Line"
{
    fields
    {
        field(50000; "Document Date"; Date)
        {
            CalcFormula = Lookup("Purch. Inv. Header"."Document Date" WHERE("No." = FIELD("Applies-to Doc. No.")));
            Caption = 'Document Date';
            Description = 'AB6.VR';
            FieldClass = FlowField;
        }
        field(50001; Name; Text[100])
        {
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("Account No.")));
            Caption = 'Name';
            Description = 'AB6.VR';
            FieldClass = FlowField;
        }
        field(50002; "Transférer vers feuille"; Code[10])
        {
        }
    }

}

