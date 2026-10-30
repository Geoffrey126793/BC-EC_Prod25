tableextension 50039 PurchaseLineEC extends "Purchase Line"
{
    fields
    {
        field(50001; "Vendor Item No Lkp"; Text[50])
        {
            CalcFormula = Lookup(Item."Vendor Item No." WHERE("No." = FIELD("No.")));
            Caption = 'Vendor Item No Lkp';
            Description = 'FON-001';
            FieldClass = FlowField;
        }
        field(50002; "Transport Sales Order No"; Code[20])
        {
            Caption = 'Transport Sales Order No';
            Description = 'AB60408.V14';
        }
        field(50003; "Transport Customer No"; Code[20])
        {
            Caption = 'Transport Customer No';
            Description = 'AB60408.V14';
            TableRelation = Customer;
        }
        field(50004; "Transport Ship-to Code"; Code[10])
        {
            Caption = 'Transport Ship-to Code';
            Description = 'AB60408.V14';
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Transport Customer No"));
        }
        field(50005; "Cases Quantity per Pallet"; Integer)
        {
            Caption = 'Cases Quantity per Pallet';
            Description = 'AB60408.V14';
        }
        field(50006; "Transport Sales Invoice No"; Code[20])
        {
            Caption = 'Transport Sales Invoice No';
            Description = 'AB60408.V14';
            TableRelation = "Sales Invoice Header"."No." WHERE("No." = FIELD("Transport Sales Invoice No"));
        }
        field(50007; "Transport Comment"; Text[80])
        {
            Caption = 'Transport Comment';
            Description = 'AB60408.V14';
        }
        field(50008; "Logistic unit"; Code[20])
        {
            Caption = 'Logistic unit';
            Description = 'AB60408.V14';
            TableRelation = "Unité logistique";
        }
        field(50009; "Transport Customer Name"; Text[100])
        {
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Transport Customer No")));
            Caption = 'Transport Customer Name';
            Description = 'AB60408.V14';
            FieldClass = FlowField;
        }
        field(50023; "Horaires de livraison"; Text[80])
        {
            CalcFormula = Lookup("Sales Header"."Horaires de livraison" WHERE("No." = FIELD("Transport Sales Order No"),
                                                                               "Document Type" = CONST(Order)));
            Caption = 'Horaires de livraison';
            FieldClass = FlowField;
        }
        field(50024; "Vendor Name"; Text[100])
        {
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("Buy-from Vendor No.")));
            Caption = 'Vendor Name';
            FieldClass = FlowField;
        }
        field(50025; "Nbre poulets"; Integer)
        {
            Caption = 'Nbre poulets';
        }
        field(50026; "Frais annexes estimatifs unit"; Decimal)
        {
            Caption = 'Frais annexes estimatifs unit';
        }
        field(50027; "DLC mini à réception"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50028; "Demandé"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50029; "Tarif Tpt"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50030; Note; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(8001500; "Rule Discount Line Amount"; Decimal)
        {
            Caption = 'Rule Discount Line Amount';
            Editable = false;

            trigger OnValidate()
            begin
                UpdateAmounts;
            end;
        }
        field(8001501; "Disc. Commission Type Filter"; Option)
        {
            Caption = 'Disc. and Commission Type Filter';
            FieldClass = FlowFilter;
            OptionCaption = 'Line Discount,Footer Discount,Back Discount,Commission';
            OptionMembers = "Line Discount","Footer Discount","Back Discount",Commission;
        }
        field(8001502; "Disc. Commission Rule Filter"; Code[20])
        {
            Caption = 'Disc. Commission Rule Filter';
            FieldClass = FlowFilter;
        }
        field(8001503; "Calculated Discount Amount"; Decimal)
        {
            CalcFormula = Sum("Purchase Line Disc. Entry"."Discount Amount" WHERE(
                                                                                   "Document No." = FIELD("Document No."),
                                                                                   "Line No." = FIELD("Line No."),
                                                                                   "Disc. Commission Type" = FIELD("Disc. Commission Type Filter"),
                                                                                   "Rule No." = FIELD("Disc. Commission Rule Filter")));
            Caption = 'Calculated Discount Amount';
            FieldClass = FlowField;
        }
    }

}

