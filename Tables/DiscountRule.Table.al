table 8001303 "Discount Rule"
{
    Caption = 'Discount Rule';

    fields
    {
        field(1; "Discount and comm. type"; Option)
        {
            Caption = 'Discount and comm. type';
            OptionCaption = 'Line discount,Footer discount,Back discount,Commission,,,,,Item Free';
            OptionMembers = "Line discount","Footer discount","Back discount",Commission,,,,,"Item Free";
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            NotBlank = true;
        }
        field(10; Description; Text[80])
        {
            Caption = 'Description';
        }
        field(20; "Continue calculation"; Option)
        {
            Caption = 'Continue calculation';
            OptionCaption = 'Yes,Line discount,Footer discount,End of period discount,No';
            OptionMembers = Yes,"Line discount","Footer discount","End of period discount",No;
        }
        field(30; Basis; Option)
        {
            Caption = 'Basis';
            OptionCaption = 'Gross,Net line,Net footer,Net back discount';
            OptionMembers = Gross,"Net line","Net footer","Net back discount";
        }
        field(31; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Sale,Purchase';
            OptionMembers = Sale,Purchase;
        }
        field(100; "Salespers./Purch. Filter"; Text[40])
        {
            Caption = 'Salespers./Purch. Filter';
            TableRelation = "Salesperson/Purchaser";
            ValidateTableRelation = false;
        }
        field(101; "Source Filter"; Text[60])
        {
            Caption = 'Source Filter';
            TableRelation = IF (Type = FILTER(Sale)) Customer
            ELSE
            IF (Type = FILTER(Purchase)) Vendor;
            ValidateTableRelation = false;
        }
        field(102; "Price code filter"; Text[40])
        {
            Caption = 'Price code filter';
            TableRelation = "Customer Price Group";
            ValidateTableRelation = false;
        }
        field(103; "Source Posting Group Filter"; Text[40])
        {
            Caption = 'Source Posting Group Filter';
            TableRelation = IF (Type = CONST(Sale)) "Customer Posting Group"
            ELSE
            IF (Type = CONST(Purchase)) "Vendor Posting Group";
            ValidateTableRelation = false;
        }
        field(104; "Gen. Bus. Posting Group filter"; Text[40])
        {
            Caption = 'Gen. Bus. Posting Group filter';
            TableRelation = "Gen. Business Posting Group";
            ValidateTableRelation = false;
        }
        field(105; "Cust./Item Disc. Gr. filter"; Text[40])
        {
            Caption = 'Cust./Item Disc. Gr. filter';
            TableRelation = "Customer Discount Group";
            ValidateTableRelation = false;
        }
        field(106; "Inventory Posting Group filter"; Text[40])
        {
            Caption = 'Inventory Posting Group filter';
            TableRelation = "Inventory Posting Group";
            ValidateTableRelation = false;
        }
        field(107; "Gen.Prod. Posting Group filter"; Text[40])
        {
            Caption = 'Gen. Prod. Posting Group filter';
            TableRelation = "Gen. Product Posting Group";
            ValidateTableRelation = false;
        }
        field(108; "Item/Cust. Disc. Gr. filter"; Text[40])
        {
            Caption = 'Item/Cust. Disc. Gr. filter';
            TableRelation = "Item Discount Group";
            ValidateTableRelation = false;
        }
        field(109; "Type Filter"; Option)
        {
            Caption = 'Type Filter';
            OptionCaption = 'All,Account (G/L),Item,Resource,Fixed Asset,Charge (Item)';
            OptionMembers = All,"Account (G/L)",Item,Resource,"Fixed Asset","Charge (Item)";
        }
        field(110; "No. filter"; Text[60])
        {
            Caption = 'No. filter';
            TableRelation = IF ("Type Filter" = CONST("Account (G/L)")) "G/L Account"
            ELSE
            IF ("Type Filter" = CONST(Item)) Item
            ELSE
            IF ("Type Filter" = CONST(Resource)) Resource
            ELSE
            IF ("Type Filter" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Type Filter" = CONST("Charge (Item)")) "Item Charge";
            ValidateTableRelation = false;
        }
        field(112; "Quantity filter"; Text[20])
        {
            Caption = 'Quantity filter';
        }
        field(113; "Amount filter"; Text[40])
        {
            Caption = 'Amount filter';
        }
        field(115; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            NotBlank = true;
        }
        field(117; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
            NotBlank = true;

            trigger OnValidate()
            var
                lFinApresDebut: Label '%1 is less than %2.';
            begin
            end;
        }
        field(120; "Reason Code filter"; Text[40])
        {
            Caption = 'Reason Code filter';
            TableRelation = "Reason Code";
            ValidateTableRelation = false;
        }
        field(121; "Global Dimension 1 Filter"; Text[40])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(122; "Global Dimension 2 Filter"; Text[40])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(123; "Currency Filter"; Text[20])
        {
            Caption = 'Currency Filter';
            TableRelation = Currency;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(124; "Amount Filter (LCY)"; Text[40])
        {
            Caption = 'Amount Filter( LCY)';
        }
        field(125; "Job Filter"; Text[40])
        {
            Caption = 'Job Filter';
            TableRelation = Job;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(130; "Return Reason Code Filter"; Text[30])
        {
            Caption = 'Return Reason Code Filter';
            TableRelation = "Return Reason";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(131; "Manufacturer Code Filter"; Text[30])
        {
            Caption = 'Manufacturer Code Filter';
            TableRelation = Manufacturer;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(132; "Item Category Code Filter"; Text[30])
        {
            Caption = 'Item Category Code Filter';
            TableRelation = "Item Category";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(133; "Product Group Code Filter"; Text[30])
        {
            Caption = 'Product Group Code Filter';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(134; "Service Item Group Filter"; Text[30])
        {
            Caption = 'Service Item Group Filter';
            TableRelation = "Service Item Group".Code;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(200; "Calc method"; Option)
        {
            Caption = 'Calc method';
            OptionCaption = 'Quantity * Rate,Quantity (Base) * Rate,Amount * Rate,Specific amount * Rate';
            OptionMembers = "Quantité * Coefficient","Quantité (base) * Coefficient","Montant * Coefficient","Base spécifique * Coefficient";
        }
        field(201; Coefficient; Decimal)
        {
            BlankZero = true;
            Caption = 'Coefficient';
            DecimalPlaces = 0 : 5;
        }
        field(301; "Customer criteria filter 1"; Text[40])
        {
            Caption = 'Customer criteria filter 1';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001301));
            ValidateTableRelation = false;
        }
        field(302; "Customer criteria filter 2"; Text[40])
        {
            Caption = 'Customer criteria filter 2';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001302));
            ValidateTableRelation = false;
        }
        field(303; "Customer criteria filter 3"; Text[40])
        {
            Caption = 'Customer criteria filter 3';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001303));
            ValidateTableRelation = false;
        }
        field(304; "Customer criteria filter 4"; Text[40])
        {
            Caption = 'Customer criteria filter 4';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001304));
            ValidateTableRelation = false;
        }
        field(305; "Customer criteria filter 5"; Text[40])
        {
            Caption = 'Customer criteria filter 5';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001305));
            ValidateTableRelation = false;
        }
        field(306; "Customer criteria filter 6"; Text[40])
        {
            Caption = 'Customer criteria filter 6';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001306));
            ValidateTableRelation = false;
        }
        field(307; "Customer criteria filter 7"; Text[40])
        {
            Caption = 'Customer criteria filter 7';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001307));
            ValidateTableRelation = false;
        }
        field(308; "Customer criteria filter 8"; Text[40])
        {
            Caption = 'Customer criteria filter 8';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001308));
            ValidateTableRelation = false;
        }
        field(309; "Customer criteria filter 9"; Text[40])
        {
            Caption = 'Customer criteria filter 9';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001309));
            ValidateTableRelation = false;
        }
        field(310; "Customer criteria filter 10"; Text[40])
        {
            Caption = 'Customer criteria filter 10';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001310));
            ValidateTableRelation = false;
        }
        field(311; "Item criteria filter 1"; Text[40])
        {
            Caption = 'Item criteria filter 1';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001301));
            ValidateTableRelation = false;
        }
        field(312; "Item criteria filter 2"; Text[40])
        {
            Caption = 'Item criteria filter 2';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001302));
            ValidateTableRelation = false;
        }
        field(313; "Item criteria filter 3"; Text[40])
        {
            Caption = 'Item criteria filter 3';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001303));
            ValidateTableRelation = false;
        }
        field(314; "Item criteria filter 4"; Text[40])
        {
            Caption = 'Item criteria filter 4';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001304));
            ValidateTableRelation = false;
        }
        field(315; "Item criteria filter 5"; Text[40])
        {
            Caption = 'Item criteria filter 5';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001305));
            ValidateTableRelation = false;
        }
        field(316; "Item criteria filter 6"; Text[40])
        {
            Caption = 'Item criteria filter 6';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001306));
            ValidateTableRelation = false;
        }
        field(317; "Item criteria filter 7"; Text[40])
        {
            Caption = 'Item criteria filter 7';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001307));
            ValidateTableRelation = false;
        }
        field(318; "Item criteria filter 8"; Text[40])
        {
            Caption = 'Item criteria filter 8';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001308));
            ValidateTableRelation = false;
        }
        field(319; "Item criteria filter 9"; Text[40])
        {
            Caption = 'Item criteria filter 9';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001309));
            ValidateTableRelation = false;
        }
        field(320; "Item criteria filter 10"; Text[40])
        {
            Caption = 'Item criteria filter 10';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001310));
            ValidateTableRelation = false;
        }
        field(30001; "Dimension 1 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(1);
            Caption = 'Dimension 1 Value Code';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FIELD("Dimension 1 Value Code"));
        }
        field(30002; "Dimension 2 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(2);
            Caption = 'Dimension 2 Value Code';
        }
        field(30003; "Dimension 3 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(3);
            Caption = 'Dimension 3 Value Code';
        }
        field(30004; "Dimension 4 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(4);
            Caption = 'Dimension 4 Value Code';
        }
        field(30005; "Dimension 5 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(5);
            Caption = 'Dimension 5 Value Code';
        }
        field(30006; "Dimension 6 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(6);
            Caption = 'Dimension 6 Value Code';
        }
        field(30007; "Dimension 7 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(7);
            Caption = 'Dimension 7 Value Code';
        }
        field(30008; "Dimension 8 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(8);
            Caption = 'Dimension 8 Value Code';
        }
        field(30009; "Dimension 9 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(9);
            Caption = 'Dimension 9 Value Code';
        }
        field(30010; "Dimension 10 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(10);
            Caption = 'Dimension 10 Value Code';
        }
        field(30011; "Dimension 11 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(11);
            Caption = 'Dimension 11 Value Code';
        }
        field(30012; "Dimension 12 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(12);
            Caption = 'Dimension 12 Value Code';
        }
        field(30013; "Dimension 13 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(13);
            Caption = 'Dimension 13 Value Code';
        }
        field(30014; "Dimension 14 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(14);
            Caption = 'Dimension 14 Value Code';
        }
        field(30015; "Dimension 15 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(15);
            Caption = 'Dimension 15 Value Code';
        }
        field(30016; "Dimension 16 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(16);
            Caption = 'Dimension 16 Value Code';
        }
        field(30017; "Dimension 17 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(17);
            Caption = 'Dimension 17 Value Code';
        }
        field(30018; "Dimension 18 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(18);
            Caption = 'Dimension 18 Value Code';
        }
        field(30019; "Dimension 19 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(19);
            Caption = 'Dimension 19 Value Code';
        }
        field(30020; "Dimension 20 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(20);
            Caption = 'Dimension 20 Value Code';
        }
        field(50000; "Free Code Filter"; Text[120])
        {
            Caption = 'Free Code Filter';
            Description = 'ADV-001';
            TableRelation = "Reason Free Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(50001; "Expected Quantity (base)"; Decimal)
        {
            Caption = 'Expected Quantity (base)';
            Description = 'ADV-002';
        }
        field(50002; "Actual Qty (base) on Invoice"; Decimal)
        {
            CalcFormula = Sum("Posted Sales Discount Entry"."Quantity (base)" WHERE("Document Type" = CONST("Posted Invoice"),
                                                                                     "Disc. Commission Type" = CONST("Line Discount"),
                                                                                     "Rule No." = FIELD("No.")));
            Description = 'ADV-002';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50003; "Actual Qty (base) on Cr. Memo"; Decimal)
        {
            CalcFormula = Sum("Posted Sales Discount Entry"."Quantity (base)" WHERE("Document Type" = CONST("Posted Credit Memo"),
                                                                                     "Disc. Commission Type" = CONST("Line Discount"),
                                                                                     "Rule No." = FIELD("No.")));
            Description = 'ADV-002';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50004; "Special Offer"; Boolean)
        {
            Caption = 'Special Offer';
            Description = 'ADV-002';
        }
        field(50018; "Quantity (base) filter"; Text[20])
        {
            Caption = 'Quantity (base) Filter';
            Description = 'ADV-001';
        }
        field(50020; "Item Free Type"; Option)
        {
            Caption = 'Item Free Type';
            Description = 'ADV-001';
            OptionCaption = 'Same Item,Another Item';
            OptionMembers = "Same Item","Another Item";
        }
        field(50021; "Item Free No."; Code[20])
        {
            Caption = 'Item Free No.';
            Description = 'ADV-001';
            TableRelation = Item;
        }
        field(50022; "Measure Unit of Item Free"; Code[10])
        {
            Caption = 'Measure Unit of Item Free';
            Description = 'ADV-001';
            TableRelation = "Unit of Measure";
        }
        field(50024; "Calc method of Item Free"; Option)
        {
            Caption = 'Calc Method of Item Free';
            Description = 'ADV-001';
            OptionCaption = 'Qty. * Coefficient,Qty. (base) * Coefficient, Specific Base * Coefficient,Qty. Fixed';
            OptionMembers = "Qty. * Coefficient","Qty. (base) * Coefficient","Specific Base * Coefficient","Qty. Fixed";
        }
        field(50025; "Cofficient of Item Free"; Decimal)
        {
            Caption = 'Cofficient of Item Free';
            Description = 'ADV-001';
        }
        field(50026; "Qty of Item Free"; Decimal)
        {
            Caption = 'Qty of Item Free';
            Description = 'ADV-001';
        }
        field(50027; "Rounding Precis. of Item Free"; Decimal)
        {
            Caption = 'Rounding Precis. of Item Free';
            DecimalPlaces = 0 : 5;
            Description = 'ADV-001';
            InitValue = 1;
        }
        field(50028; "Rounding Meth. of Item Free"; Option)
        {
            Caption = 'Rounding Meth. of Item Free';
            Description = 'ADV-001';
            OptionMembers = Nearest,Up,Down;
        }
        field(50030; "Reason Free Code"; Code[20])
        {
            Caption = 'Reason Free Code';
            Description = 'ADV-001';
            TableRelation = "Reason Free Code";
        }
        field(50033; "Application Number Maximum"; Integer)
        {
            Caption = 'Application Number Maximum';
            Description = 'ADV-001';
        }
        field(50040; "Special Discount Filter"; Text[120])
        {
            Caption = 'Special Discount Filter';
            Description = 'ADV-001';
            TableRelation = Transport;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(50041; "Quantity (Base) Maximum"; Decimal)
        {
            Caption = 'Quantity (Base) Maximum';
            DecimalPlaces = 0 : 2;
            Description = 'ADV-001';
        }
        field(50050; Status; Option)
        {
            Caption = 'Status';
            Description = 'ADV-001';
            OptionCaption = 'Under Modification,Certified';
            OptionMembers = "Under Modification",Certified;
        }
        field(50055; Printable; Boolean)
        {
            Caption = 'Printable';
            Description = 'ADV-001';
            InitValue = true;
        }
        field(50060; "Qty Shipped of Src Item Free"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry"."Qty Item Source of Item Free" WHERE("Discount Rule of Item Free" = FIELD("No.")));
            Caption = 'Qté livrée d''article source offert';
            Description = 'ADV-001';
            FieldClass = FlowField;
        }
        field(50061; "Qty Order of Src Item Free"; Decimal)
        {
            CalcFormula = Sum("Sales Line"."Qty Item Source of Item Free" WHERE("Document Type" = FILTER(Order | Invoice),
                                                                                 "Discount Rule of Item Free" = FIELD("No."),
                                                                                 "Quantity Shipped" = CONST(0)));
            Caption = 'Qté sur commande d''article source offert';
            Description = 'ADV-001';
            FieldClass = FlowField;
        }
        field(50062; "Qty Return of Src Item Free"; Decimal)
        {
            CalcFormula = - Sum("Sales Line"."Qty Item Source of Item Free" WHERE("Document Type" = FILTER("Return Order" | "Credit Memo"),
                                                                                  "Discount Rule of Item Free" = FIELD("No."),
                                                                                  "Quantity Shipped" = CONST(0)));
            Caption = 'Qté sur retour d''article source offert';
            Description = 'ADV-001';
            FieldClass = FlowField;
        }
        field(50065; "Number of Bins Filter"; Text[30])
        {
            Caption = 'Filtre nombre emplacements';
            Description = 'ADV-001';
        }
    }

    keys
    {
        key(Key1; "Discount and comm. type", "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        StatisticsSetup: Record "Statistics setup";
        "Code": Record "Code";
        DimValue: Record "Dimension Value";
        tError1: Label 'The rule must be a discount.';
        Text50000: Label 'Etes vous certain de valider la loi %1.\(Assurez vous que tous les filtres sont positionnés avant de valider)';
        RecSalesLine_l: Record "Sales Line";
        RecSalesInvLine_l: Record "Sales Invoice Line";
        RecSalesCrMemoLine_l: Record "Sales Cr.Memo Line";

    [Scope('OnPrem')]
    procedure GetCaptionClass(AnalysisViewDimType: Integer): Text[250]
    var
        lStatisticsSetup: Record "Statistics setup";
        lText001: Label '1,6,,Dimension 1 Value Code';
        lText002: Label '1,6,,Dimension 2 Value Code';
        lText003: Label '1,6,,Dimension 3 Value Code';
        lText004: Label '1,6,,Dimension 4 Value Code';
        lText005: Label '1,6,,Dimension 5 Value Code';
        lText006: Label '1,6,,Dimension 6 Value Code';
        lText007: Label '1,6,,Dimension 7 Value Code';
        lText008: Label '1,6,,Dimension 8 Value Code';
        lText009: Label '1,6,,Dimension 9 Value Code';
        lText010: Label '1,6,,Dimension 10 Value Code';
        lText011: Label '1,6,,Dimension 11 Value Code';
        lText012: Label '1,6,,Dimension 12 Value Code';
        lText013: Label '1,6,,Dimension 13 Value Code';
        lText014: Label '1,6,,Dimension 14 Value Code';
        lText015: Label '1,6,,Dimension 15 Value Code';
        lText016: Label '1,6,,Dimension 16 Value Code';
        lText017: Label '1,6,,Dimension 17 Value Code';
        lText018: Label '1,6,,Dimension 18 Value Code';
        lText019: Label '1,6,,Dimension 19 Value Code';
        lText020: Label '1,6,,Dimension 20 Value Code';
    begin
    end;

    [Scope('OnPrem')]
    procedure TestRFA()
    begin
    end;

    [Scope('OnPrem')]
    procedure GetQtyInvoiced(): Decimal
    begin
    end;

    [Scope('OnPrem')]
    procedure GetApplicationNumber() NbApplication: Integer
    var
        RecSalesInvDiscountEntry_l: Record "Sales Line Discount Entry";
        RecPostSalesInvDiscountEntry_l: Record "Posted Sales Discount Entry";
        RecDiscountRule_l: Record "Discount Rule";
    begin
    end;

    [Scope('OnPrem')]
    procedure GetQtyBaseOnRuleEntry() QtyBase: Integer
    var
        RecSalesInvDiscountEntry_l: Record "Sales Line Discount Entry";
        RecPostSalesInvDiscountEntry_l: Record "Posted Sales Discount Entry";
        RecDiscountRule_l: Record "Discount Rule";
    begin
    end;

    [Scope('OnPrem')]
    procedure TestStatus()
    begin
    end;
}

