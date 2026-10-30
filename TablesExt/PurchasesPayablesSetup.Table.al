tableextension 50041 PurchaseSetupEC extends "Purchases & Payables Setup"
{
    fields
    {
        field(50000; "Transaction Type Default"; Code[10])
        {
            Caption = 'Transaction Type Default';
            Description = 'ABS3.00p';
            TableRelation = "Transaction Type";
        }
        field(50001; "Transport Method Default"; Code[10])
        {
            Caption = 'Transport Method Default';
            Description = 'ABS3.00p';
            TableRelation = "Transport Method";
        }
        field(50002; "Transaction Specifi. Default"; Code[10])
        {
            Caption = 'Transaction Specification Default';
            Description = 'ABS3.00p';
            TableRelation = "Transaction Specification";
        }
        field(50003; "Area"; Code[10])
        {
            Caption = 'Area';
            Description = 'ABS3.00p';
            TableRelation = Area;
        }
        field(50004; "Transport G/L Account No."; Code[20])
        {
            Caption = 'Transport G/L Account No.';
            Description = 'AB60408.V14';
            TableRelation = "G/L Account"."No.";
        }
        field(50005; "Shipment Item No."; Code[20])
        {
            Caption = 'Transport Item No.';
            Description = 'AC BDU 110112D';
            TableRelation = Item;
        }
        field(50006; "Transport G/L Account No. RD"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";
        }
        field(70100; "Vendor Alert on Purch Ord/Inv"; Boolean)
        {
            Caption = 'Vendor Alert on Purch Ord/Inv';
            Description = 'ABS2.00';
        }
        field(70101; Contract; Code[20])
        {
            Caption = 'Contract';
            TableRelation = Dimension;
        }
    }

}

