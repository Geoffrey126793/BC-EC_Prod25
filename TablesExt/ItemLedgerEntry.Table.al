tableextension 50024 ItemLedgerEntryEC extends "Item Ledger Entry"
{
    fields
    {
        field(50010; "Resaon Free Code"; Code[20])
        {
            Caption = 'Reason Free Code';
            Description = 'ADV-001';
            Editable = false;
            TableRelation = "Return Reason";
        }
        field(50011; "Free Line"; Boolean)
        {
            Caption = 'Free Line';
            Description = 'ADV-001';
            Editable = false;
        }
        field(50012; "Intrastat Value on Free Line"; Decimal)
        {
            Caption = 'Intrastat Value on Free Line';
            Description = 'ADV-001';
            Editable = false;
        }
        field(50025; "Discount Rule of Item Free"; Code[20])
        {
            Caption = 'Discount Rule of Item Free';
            Description = 'ADV-001';
        }
        field(50026; "Item Source of Item Free"; Code[20])
        {
            Caption = 'Item Source of Item Free';
            Description = 'ADV-001';
        }
        field(50027; "Qty Item Source of Item Free"; Decimal)
        {
            Caption = 'Qty Item Source of Item Free';
            Description = 'ADV-001';
            Editable = false;
        }
        field(50028; "Lot bloque"; Boolean)
        {
            CalcFormula = Lookup("Lot No. Information".Blocked WHERE("Item No." = FIELD("Item No."),
                                                                      "Variant Code" = FIELD("Variant Code"),
                                                                      "Lot No." = FIELD("Lot No.")));
            FieldClass = FlowField;
        }
        field(50029; "Cost Amount (Actual) Direct"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Value Entry"."Cost Amount (Actual)" WHERE("Item Ledger Entry No." = FIELD("Entry No."),
                                                                          "Item Charge No." = FILTER('')));
            Caption = 'Cost Amount (Actual) Direct';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50030; "Cost Amount (Actual) Frais"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Value Entry"."Cost Amount (Actual)" WHERE("Item Ledger Entry No." = FIELD("Entry No."),
                                                                          "Item Charge No." = FILTER(<> '')));
            Caption = 'Cost Amount (Actual) Charge';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50031; "Cost Amount (AtDate)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Value Entry"."Cost Amount (Actual)" WHERE("Item Ledger Entry No." = FIELD("Entry No."),
                                                                          "Posting Date" = FIELD("Date Filter")));
            Caption = 'Cost Amount (At date)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50032; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(50033; Halal; Code[20])
        {
            CalcFormula = Lookup(Item."Criteria 10" WHERE("No." = FIELD("Item No.")));
            FieldClass = FlowField;
        }
        field(50100; Consign; Boolean)
        {
            Caption = 'Consign';
            Description = 'ART-003';
        }
        field(55000; "On Boat"; Boolean)
        {
            Caption = 'On Boat';
            Description = 'LOG-005';
        }
        field(55001; "Sales Available Date"; Date)
        {
            Caption = 'Sales Available Date';
            Description = 'LOG-005';
        }
        field(55002; "Blocage Commentaire"; Text[250])
        {
            CalcFormula = Lookup("Lot No. Information"."Commentaire blocage" WHERE("Item No." = FIELD("Item No."),
                                                                                    "Variant Code" = FIELD("Variant Code"),
                                                                                    "Lot No." = FIELD("Lot No.")));
            FieldClass = FlowField;
        }
        field(55003; "Blocage Destination"; Text[200])
        {
            CalcFormula = Lookup("Lot No. Information".Decision WHERE("Item No." = FIELD("Item No."),
                                                                       "Variant Code" = FIELD("Variant Code"),
                                                                       "Lot No." = FIELD("Lot No.")));
            FieldClass = FlowField;
        }
        field(55004; "Source desc"; Text[100])
        {
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("Source No.")));
            Caption = 'Source description';
            FieldClass = FlowField;
        }
        field(55005; "Blocage Raison"; Text[50])
        {
            CalcFormula = Lookup("Lot No. Information"."Raison du blocage" WHERE("Item No." = FIELD("Item No."),
                                                                                  "Variant Code" = FIELD("Variant Code"),
                                                                                  "Lot No." = FIELD("Lot No.")));
            FieldClass = FlowField;
        }
        field(55006; Decision; Text[250])
        {
            CalcFormula = Lookup("Lot No. Information".Decision WHERE("Item No." = FIELD("Item No."),
                                                                       "Variant Code" = FIELD("Variant Code"),
                                                                       "Lot No." = FIELD("Lot No.")));
            FieldClass = FlowField;
        }
        field(55007; "Commentaire Decision"; Text[250])
        {
            CalcFormula = Lookup("Lot No. Information"."Commentaire decision" WHERE("Item No." = FIELD("Item No."),
                                                                                     "Variant Code" = FIELD("Variant Code"),
                                                                                     "Lot No." = FIELD("Lot No.")));
            FieldClass = FlowField;
        }
        field(55008; "Blocage Lot Statut"; Text[50])
        {
            CalcFormula = Lookup("Lot No. Information"."Statut du blocage" WHERE("Item No." = FIELD("Item No."),
                                                                                  "Variant Code" = FIELD("Variant Code"),
                                                                                  "Lot No." = FIELD("Lot No.")));
            FieldClass = FlowField;
        }
        field(55009; "Blocage Lot Destination"; Text[50])
        {
            CalcFormula = Lookup("Lot No. Information".Destination WHERE("Item No." = FIELD("Item No."),
                                                                          "Variant Code" = FIELD("Variant Code"),
                                                                          "Lot No." = FIELD("Lot No.")));
            FieldClass = FlowField;
        }
        field(55010; "Blocage Lot Recyclage"; Text[50])
        {
            CalcFormula = Lookup("Lot No. Information".Recyclage WHERE("Item No." = FIELD("Item No."),
                                                                        "Variant Code" = FIELD("Variant Code"),
                                                                        "Lot No." = FIELD("Lot No.")));
            FieldClass = FlowField;
        }
    }

}

