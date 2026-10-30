table 8001502 "Sales Line Discount Entry"
{
    // ------------------------------------------------------------------------------------------
    // ADV-002 ABSYS GN 20061020
    //   RFA : Gestion des offres promo
    //       Add Fields :
    //        - 50001 Quantity (base) Decimal
    //        - 50004 Special Offer Boolean
    // ------------------------------------------------------------------------------------------
    // ADV-001 ABSYS GN 20061018
    //   RFA : Gestion des gratuits
    //     Add Fields :
    //      - 50010 Reason Free Code (Code 20)
    //      - 50011 Free Line (Boolean)
    // ------------------------------------------------------------------------------------------
    // //+RFA+ GESWAY 11/07/02 Nouvelle table de stockage des remises des lignes vente.

    Caption = 'Sale Line Discount Entry';

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,,Posted Invoice,Posted Credit Memo,Posted Return Receipt';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",,"Posted Invoice","Posted Credit Memo","Posted Return Receipt";
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; Description; Text[100])
        {
            CalcFormula = Lookup("Sales Line".Description WHERE(
                                                                 "Document No." = FIELD("Document No."),
                                                                 "Line No." = FIELD("Line No.")));
            Caption = 'Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "Disc. Commission Type"; Option)
        {
            Caption = 'Discount And Comm. Type';
            OptionCaption = 'Line Discount,Footer Discount,Back Discount,Commission';
            OptionMembers = "Line Discount","Footer Discount","Back Discount",Commission;
        }
        field(6; "Rule No."; Code[20])
        {
            Caption = 'Rule No.';
            TableRelation = "Discount Rule"."No." WHERE("Discount and comm. type" = FIELD("Disc. Commission Type"),
                                                         "No." = FIELD("Rule No."));
        }
        field(10; "Continue Calculation"; Option)
        {
            Caption = 'Continue Calculation';
            OptionCaption = 'Yes,Line Discount,Footer Discount,End of Period Discount,No';
            OptionMembers = Yes,"Line Discount","Footer Discount","End of Period Discount",No;
        }
        field(11; Basis; Option)
        {
            Caption = 'Basis';
            OptionCaption = 'Gross,Net Line,Net Footer,Net End of Period Discount';
            OptionMembers = Gross,"Net Line","Net Footer","Net End of Period Discount";
        }
        field(12; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Sale,Order';
            OptionMembers = Sale,"Order";
        }
        field(13; "Base (LCY)"; Decimal)
        {
            Caption = 'Base (LCY)';
        }
        field(14; "Discount Amount (LCY)"; Decimal)
        {
            Caption = 'Discount Amount (LCY)';
        }
        field(15; "Coefficient (LCY)"; Decimal)
        {
            Caption = 'Coefficient (LCY)';
            DecimalPlaces = 0 : 5;
        }
        field(20; Base; Decimal)
        {
            Caption = 'Base';
        }
        field(21; "Discount Amount"; Decimal)
        {
            Caption = 'Discount Amount';
        }
        field(22; Coefficient; Decimal)
        {
            Caption = 'Coefficient';
            DecimalPlaces = 0 : 5;
        }
        field(50000; "Description Discount Rule"; Text[50])
        {
            Description = 'ADV-002';
            Editable = false;
        }
        field(50001; "Quantity (base)"; Decimal)
        {
            Description = 'ADV-002';
        }
        field(50004; "Special Offer"; Boolean)
        {
            Caption = 'Special Offer';
            Description = 'ADV-002';
        }
        field(50010; "Resaon Free Code"; Code[20])
        {
            Caption = 'Reason Free Code';
            Description = 'ADV-001';
            TableRelation = "Reason Free Code";
        }
        field(50011; "Free Line"; Boolean)
        {
            Caption = 'Free Line';
            Description = 'ADV-001';
        }
        field(50015; "Calc method"; Option)
        {
            Caption = 'Calc method';
            Editable = false;
            OptionCaption = 'QuantitÚ * Coefficient,QuantitÚ (base) * Coefficient,Montant * Coefficient,Base spÚcifique * Coefficient';
            OptionMembers = "QuantitÚ * Coefficient","QuantitÚ (base) * Coefficient","Montant * Coefficient","Base spÚcifique * Coefficient";
        }
        field(50016; "Unit of Volume"; Code[10])
        {
            Caption = 'Unit of Volume';
            Editable = false;
        }
        field(50017; "Sales Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            Editable = false;

            trigger OnValidate()
            var
                UnitOfMeasureTranslation: Record "Unit of Measure Translation";
                ResUnitofMeasure: Record "Resource Unit of Measure";
            begin
            end;
        }
        field(50018; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
        }
        field(50020; "Posting Date"; Date)
        {
            Description = 'ADV.21';
        }
        field(50055; Printable; Boolean)
        {
            Caption = 'Printable';
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.", "Disc. Commission Type", "Rule No.")
        {
            Clustered = true;
            SumIndexFields = "Discount Amount", "Discount Amount (LCY)";
        }
        key(Key2; "Document Type", "Document No.", "Disc. Commission Type", "Rule No.", "Line No.")
        {
        }
        key(Key3; "Document Type", "Disc. Commission Type", "Rule No.")
        {
            SumIndexFields = "Quantity (base)";
        }
        key(Key4; "Disc. Commission Type", "Posting Date")
        {
        }
    }

    fieldgroups
    {
    }
}

