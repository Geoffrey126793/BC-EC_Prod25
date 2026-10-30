tableextension 50061 SalesReceivablesSetupEC extends "Sales & Receivables Setup"
{
    fields
    {
        field(50000; "Transaction Type Default"; Code[10])
        {
            Caption = 'Transaction Type Default';
            Description = 'ABS3.00s';
            TableRelation = "Transaction Type";
        }
        field(50001; "Transport Method Default"; Code[10])
        {
            Caption = 'Transport Method Default';
            Description = 'ABS3.00s';
            TableRelation = "Transport Method";
        }
        field(50002; "Transaction Specifi. Default"; Code[10])
        {
            Caption = 'Transaction Specification Default';
            Description = 'ABS3.00s';
            TableRelation = "Transaction Specification";
        }
        field(50003; "Area"; Code[10])
        {
            Caption = 'Area';
            Description = 'ABS3.00s';
            TableRelation = Area;
        }
        field(50010; "Transaction Type to Free Sales"; Code[10])
        {
            Caption = 'Transaction Type to Free Sales';
            Description = 'ADV-001';
            TableRelation = "Transaction Type";
        }
        field(50011; "Logo Contrôle 1"; BLOB)
        {
            Caption = 'Picture';
            Description = 'ADV-009';
            SubType = Bitmap;
        }
        field(50012; "Logo Contrôle 2"; BLOB)
        {
            Caption = 'Logo Contrôle 2';
            Description = 'ADV-009';
        }
        field(50013; "Logo Contrôle 3"; BLOB)
        {
            Caption = 'Logo Contrôle 3';
            Description = 'ADV-009';
        }
        field(50014; "Logo Contrôle 4"; BLOB)
        {
            Caption = 'Logo Contrôle 4';
            Description = 'ADV-009';
        }
        field(50020; "Cust Dimension Code"; Code[20])
        {
            Caption = 'Cust Dimension Code';
            Description = 'AB6.BT.001';
            TableRelation = Dimension;
        }
        field(50021; "Organizational Level Code"; Code[10])
        {
            Caption = 'Organizational Level Code';
            Description = 'AB6.VIR';
            TableRelation = "Organizational Level";
        }
        field(50022; "Mail PDF File Path Name"; Text[50])
        {
            Caption = 'Mail PDF File Path Name';
            Description = 'Email';
        }
        field(50023; "Mail CGV PDF File Path Name"; Text[100])
        {
            Caption = 'Mail CGV PDF File Path Name';
            Description = 'Email';
        }
        field(70100; "Cust. Alert on Sales Order/Inv"; Boolean)
        {
            Caption = 'Cust. Alert on Sales Order/Inv';
            Description = 'ABS2.00';
        }
    }

}

