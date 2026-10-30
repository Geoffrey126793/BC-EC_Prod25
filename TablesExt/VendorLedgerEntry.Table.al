tableextension 50075 VendorLedgerEntryEC extends "Vendor Ledger Entry"
{
    fields
    {
        field(50000; Name; Text[100])
        {
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("Vendor No.")));
            Caption = 'Name';
            FieldClass = FlowField;
        }
        field(50001; Commentaires; Boolean)
        {
            CalcFormula = Exist("Purch. Comment Line" WHERE("No." = FIELD("Document No."),
                                                             "Document Line No." = CONST(0)));
            Caption = 'Commentaires';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            var
                PurchComment: Record "Purch. Comment Line";
            begin
            end;
        }
    }

}

