tableextension 50058 SalesLineEC extends "Sales Line"
{
    fields
    {
        field(50000; "Country Code"; Code[10])
        {
            Caption = 'Country Code';
            Description = 'ADV-006';
            TableRelation = "Country/Region";
        }
        field(50001; "Line Discount unit amount"; Decimal)
        {
            BlankZero = true;
            Caption = 'Line Discount unit amount';
            Description = 'ABC OLL';
            Editable = false;
        }
        field(50002; "Forced Unit Price"; Boolean)
        {
            Caption = 'Forced Unit Price';
            Description = 'ABC OLL';

            trigger OnValidate()
            var
                Utils: Codeunit Utils;
            begin
                //>> ABC(OLL) - 01/08/2017
                TestStatusOpen;
                //<<
                if (not Utils.IsInGroup('SALES_FORCEPX')) and ("Location Code" <> 'RD') then Error('Vous ne pouvez pas forcer un prix');
            end;
        }
        field(50003; "Forced Line Discount %"; Boolean)
        {
            Caption = 'Forced Line Discount %';
            Description = 'ABC OLL';

            trigger OnValidate()
            var
                Utils: Codeunit Utils;
            begin
                //>> ABC(OLL) - 01/08/2017 - Pour remise en montant unitaire
                TestStatusOpen;

                Validate("Line Discount unit amount", 0);
                //<<
                if not Utils.IsInGroup('SALES_FORCEPX') then Error('Vous ne pouvez pas forcer un prix');
            end;
        }
        field(50009; "Complete Pallet"; Boolean)
        {
            Caption = 'Complete Pallet';
            Description = 'AB60408.V5';
        }
        field(50010; "Reason Free Code"; Code[20])
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
        field(50012; "Transport Purchase Order"; Code[20])
        {
            CalcFormula = Lookup("Sales Header"."Transport Purchase Order" WHERE("Document Type" = FIELD("Document Type"),
                                                                                  "No." = FIELD("Document No.")));
            Caption = 'Transport Purchase Order';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = CONST(Order),
                                                           "No." = FIELD("Transport Purchase Order"));
        }
        field(50015; "Source Line No. Item Free"; Integer)
        {
            Caption = 'Source Line No. Item Free';
            Description = 'ADV-007';
        }
        field(50020; "Transport Unit Price"; Decimal)
        {
            Caption = 'Transport Unit Price';
            Description = 'LOG-004';
        }
        field(50021; "Transport line"; Boolean)
        {
            Caption = 'Transport line';
            Description = 'LOG-004';
        }
        field(50022; "Special Discount Code"; Code[10])
        {
            Caption = 'Special Discount Code';
            Description = 'ADV-007';
            Editable = false;
        }
        field(50025; "Discount Rule of Item Free"; Code[20])
        {
            Caption = 'Discount Rule of Item Free';
            Description = 'ADV-007';
            Editable = false;
        }
        field(50026; "Item Source of Item Free"; Code[20])
        {
            Caption = 'Item Source of Item Free';
            Description = 'ADV-007';
            Editable = false;
        }
        field(50027; "Qty Item Source of Item Free"; Decimal)
        {
            Caption = 'Qty Item Source of Item Free';
            Description = 'ADV-007';
        }
        field(50028; "Qte commandée initiale"; Decimal)
        {
            Caption = 'Qte commandée initiale';
            DecimalPlaces = 0 : 5;
        }
        field(50029; "Base Unit"; Code[10])
        {
            CalcFormula = Lookup(Item."Base Unit of Measure" WHERE("No." = FIELD("No.")));
            Caption = 'Base Unit';
            FieldClass = FlowField;
        }
        field(50030; "Qte commandée initiale Base"; Decimal)
        {
            Caption = 'Qte commandée initiale';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(50080; "Order Type"; Option)
        {
            CalcFormula = Lookup("Sales Header"."Order type" WHERE("Document Type" = FIELD("Document Type"),
                                                                    "No." = FIELD("Document No.")));
            Caption = 'Order type';
            Description = 'LOG-004';
            FieldClass = FlowField;
            OptionCaption = ' ,Frais,Surgelé';
            OptionMembers = " ",Frais,"Surgelé";
        }
        field(50090; "Tax line"; Boolean)
        {
            Caption = 'Tax line';
            Description = 'ADV-005';
        }
        field(50091; "Tax Type"; Code[10])
        {
            Caption = 'Tax Type';
            Description = 'ADV-005';
            Editable = false;
        }
        field(50092; "Tax SubType"; Code[10])
        {
            Caption = 'Tax SubType';
            Description = 'ADV-005';
            Editable = false;
        }
        field(50093; "Px Depart"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50094; "Px 3x Net"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50099; "Description FR"; Text[100])
        {
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD("No.")));
            Caption = 'Description FR';
            Description = 'ADV-999';
            FieldClass = FlowField;
        }
        field(50100; Consign; Boolean)
        {
            Caption = 'Consign';
            Description = 'ART-003';
        }
        field(50201; "Minimum de commande"; Decimal)
        {
            Caption = 'Minimum order';
            DataClassification = ToBeClassified;
        }
        field(50202; "Prix unitaire départ"; Decimal)
        {
            Caption = 'Ex-works unit price';
            DataClassification = ToBeClassified;
        }
        field(50203; "Poids par palette"; Decimal)
        {
            Caption = 'Weight by palet';
            DataClassification = ToBeClassified;
        }
        field(50204; "Date de production"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                CU50045: Codeunit "Integration Tft and Prod";
            begin
                //IF (Type = Type::Item) AND ("No." <> '')THEN
                //  CU50045.AddSalesToOF(Rec,xRec);
            end;
        }
        field(50205; "Nom client"; Text[100])
        {
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Sell-to Customer No.")));
            FieldClass = FlowField;
        }
        field(50206; "Prix Tpt"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50207; Intermediaire5; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50208; Surcharge; Decimal)
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
            CalcFormula = Sum("Sales Line Discount Entry"."Discount Amount" WHERE(
                                                                                   "Document No." = FIELD("Document No."),
                                                                                   "Line No." = FIELD("Line No."),
                                                                                   "Disc. Commission Type" = FIELD("Disc. Commission Type Filter"),
                                                                                   "Rule No." = FIELD("Disc. Commission Rule Filter")));
            Caption = 'Calculated Discount Amount';
            FieldClass = FlowField;
        }
    }

}

