tableextension 50008 CustLedgerEntryEC extends "Cust. Ledger Entry"
{

    fields
    {
        field(50000; "BL No."; Code[20])
        {
            CalcFormula = Lookup("Shipment Invoiced"."Shipment No." WHERE("Invoice No." = FIELD("Document No.")));
            Caption = 'Document No.';
            Description = 'AB6.VIR';
            FieldClass = FlowField;
        }
    }
}

