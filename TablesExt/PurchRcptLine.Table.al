tableextension 50046 PurchRcptLineEC extends "Purch. Rcpt. Line"
{
    fields
    {
        field(50002; "Transport Sales Order No"; Code[20])
        {
            CalcFormula = Lookup("Purchase Line"."Transport Sales Order No" WHERE("Document No." = FIELD("Order No."),
                                                                                   "Line No." = FIELD("Order Line No.")));
            Caption = 'Transport Sales Order No';
            Description = 'AB60408.V14';
            FieldClass = FlowField;
        }
        field(50003; "Transport Customer No"; Code[20])
        {
            CalcFormula = Lookup("Purchase Line"."Transport Customer No" WHERE("Document No." = FIELD("Order No."),
                                                                                "Line No." = FIELD("Order Line No.")));
            Caption = 'Transport Customer No';
            Description = 'AB60408.V14';
            FieldClass = FlowField;
            TableRelation = Customer;
        }
        field(50004; Name; Text[100])
        {
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Transport Customer No")));
            Caption = 'Name';
            Description = 'AB60408.V14';
            FieldClass = FlowField;
        }
        field(50007; "Transport Comment"; Text[80])
        {
            Caption = 'Transport Comment';
            DataClassification = ToBeClassified;
            Description = 'AB60408.V14';
        }
        field(50009; "Facture vente"; Code[20])
        {
            CalcFormula = Lookup("Purchase Line"."Transport Sales Invoice No" WHERE("Document No." = FIELD("Order No."),
                                                                                     "Line No." = FIELD("Order Line No.")));
            Caption = 'Facture vente';
            Description = 'AB60408.V14';
            FieldClass = FlowField;
            TableRelation = Customer;
        }
        field(50010; "Ville livraison"; Text[50])
        {
            CalcFormula = Lookup("Sales Invoice Header"."Ship-to City" WHERE("No." = FIELD("Facture vente")));
            Caption = 'Ville livraison';
            FieldClass = FlowField;
        }
        field(50025; "Nbre poulets"; Integer)
        {
            Caption = 'Nbre poulets';
        }
        field(50050; "Buy-from Vendor Name"; Text[100])
        {
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("Buy-from Vendor No.")));
            Caption = 'Vendor name';
            FieldClass = FlowField;
        }
        field(50051; "Pay-To Vendor Name"; Text[100])
        {
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("Pay-to Vendor No.")));
            Caption = 'Vendor name';
            FieldClass = FlowField;
        }
        field(50126; UserID; Code[50])
        {
            CalcFormula = Lookup("Purch. Rcpt. Header"."User ID" WHERE("No." = FIELD("Document No.")));
            Caption = 'UserID';
            FieldClass = FlowField;
        }
        field(50200; Container; Text[30])
        {
            CalcFormula = Lookup("Purch. Rcpt. Header".Container WHERE("No." = FIELD("Document No.")));
            Caption = 'Container';
            FieldClass = FlowField;
        }
    }

}

