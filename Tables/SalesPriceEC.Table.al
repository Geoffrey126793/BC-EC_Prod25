table 50039 "Sales PriceEC"
{
    // T7002 + 2 champs clefs primaire

    Caption = 'Sales Price';

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            NotBlank = true;
            TableRelation = Item;

            trigger OnValidate()
            begin
                if "Item No." <> xRec."Item No." then begin
                    Item.Get("Item No.");
                    "Unit of Measure Code" := Item."Sales Unit of Measure";
                    "Variant Code" := '';
                end;

                if "Sales Type" = "Sales Type"::"Customer Price Group" then
                    if CustPriceGr.Get("Sales Code") and
                       (CustPriceGr."Allow Invoice Disc." = "Allow Invoice Disc.")
                    then
                        exit;

                UpdateValuesFromItem;
            end;
        }
        field(2; "Sales Code"; Code[20])
        {
            Caption = 'Sales Code';
            TableRelation = IF ("Sales Type" = CONST("Customer Price Group")) "Customer Price Group"
            ELSE
            IF ("Sales Type" = CONST(Customer)) Customer
            ELSE
            IF ("Sales Type" = CONST(Campaign)) Campaign;

            trigger OnValidate()
            begin
                if "Sales Code" <> '' then
                    case "Sales Type" of
                        "Sales Type"::"All Customers":
                            Error(Text001, FieldCaption("Sales Code"));
                        "Sales Type"::"Customer Price Group":
                            begin
                                CustPriceGr.Get("Sales Code");
                                "Price Includes VAT" := CustPriceGr."Price Includes VAT";
                                "VAT Bus. Posting Gr. (Price)" := CustPriceGr."VAT Bus. Posting Gr. (Price)";
                                "Allow Line Disc." := CustPriceGr."Allow Line Disc.";
                                "Allow Invoice Disc." := CustPriceGr."Allow Invoice Disc.";
                            end;
                        "Sales Type"::Customer:
                            begin
                                Cust.Get("Sales Code");
                                "Currency Code" := Cust."Currency Code";
                                "Price Includes VAT" := Cust."Prices Including VAT";
                                "VAT Bus. Posting Gr. (Price)" := Cust."VAT Bus. Posting Group";
                                "Allow Line Disc." := Cust."Allow Line Disc.";
                            end;
                        "Sales Type"::Campaign:
                            begin
                                Campaign.Get("Sales Code");
                                "Starting Date" := Campaign."Starting Date";
                                "Ending Date" := Campaign."Ending Date";
                            end;
                    end;
            end;
        }
        field(3; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(4; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                if ("Starting Date" > "Ending Date") and ("Ending Date" <> 0D) then
                    Error(Text000, FieldCaption("Starting Date"), FieldCaption("Ending Date"));

                if CurrFieldNo = 0 then
                    exit;

                if "Starting Date" <> 0D then
                    if "Sales Type" = "Sales Type"::Campaign then
                        Error(Text002, "Sales Type");
            end;
        }
        field(5; "Unit Price"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Unit Price';
            MinValue = 0;
        }
        field(7; "Price Includes VAT"; Boolean)
        {
            Caption = 'Price Includes VAT';
        }
        field(10; "Allow Invoice Disc."; Boolean)
        {
            Caption = 'Allow Invoice Disc.';
            InitValue = true;
        }
        field(11; "VAT Bus. Posting Gr. (Price)"; Code[20])
        {
            Caption = 'VAT Bus. Posting Gr. (Price)';
            TableRelation = "VAT Business Posting Group";
        }
        field(13; "Sales Type"; Option)
        {
            Caption = 'Sales Type';
            OptionCaption = 'Customer,Customer Price Group,All Customers,Campaign';
            OptionMembers = Customer,"Customer Price Group","All Customers",Campaign;

            trigger OnValidate()
            begin
                if "Sales Type" <> xRec."Sales Type" then begin
                    Validate("Sales Code", '');
                    UpdateValuesFromItem;
                end;
            end;
        }
        field(14; "Minimum Quantity"; Decimal)
        {
            Caption = 'Minimum Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(15; "Ending Date"; Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate()
            begin
                if CurrFieldNo = 0 then
                    exit;

                Validate("Starting Date");

                if "Ending Date" <> 0D then
                    if "Sales Type" = "Sales Type"::Campaign then
                        Error(Text002, "Sales Type");
            end;
        }
        field(5400; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(5700; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(7001; "Allow Line Disc."; Boolean)
        {
            Caption = 'Allow Line Disc.';
            InitValue = true;
        }
        field(50000; "Item Description"; Text[100])
        {
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD("Item No.")));
            Caption = 'Item Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50001; RFA; Decimal)
        {
            Caption = 'RFA';
            DecimalPlaces = 3 : 3;
            Description = 'AB6.RFA';
        }
        field(50003; "Unit Start Price"; Decimal)
        {
            Caption = 'Unit Start Price';
            DecimalPlaces = 3 : 3;
            Description = 'AB6.VIR';
        }
        field(50004; "Prix 3x Net"; Decimal)
        {
            Caption = 'Prix 3x Net';
            DecimalPlaces = 3 : 3;
        }
        field(50010; "Order Minimum Quantity"; Decimal)
        {
            Caption = 'Order Minimum Quantity';
            Description = 'ABC OLL';
            MinValue = 0;
        }
        field(50011; "Order Minimum Palettes"; Integer)
        {
            Caption = 'Order Minimum Palettes';
        }
        field(50012; "RFA - %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "RFA - Montant"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50014; "Quantité annuelle base RFA"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50015; "RFA / Kg"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50016; "Description client"; Text[100])
        {
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Sales Code")));
            FieldClass = FlowField;
        }
        field(50017; "Description article"; Text[100])
        {
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD("Item No.")));
            FieldClass = FlowField;
        }
        field(50018; Flag; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50019; "Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
        field(50020; "CC - %"; Decimal)
        {
            Caption = 'Coopération commerciale- %';
            DataClassification = ToBeClassified;
        }
        field(50021; "CC - Montant"; Decimal)
        {
            Caption = 'Coopération commerciale- Montant';
            DataClassification = ToBeClassified;
        }
        field(50022; "Quantité annuelle base CC"; Decimal)
        {
            Caption = 'Coopération commerciale- Quantité annuelle prévue';
            DataClassification = ToBeClassified;
        }
        field(50023; "CC / Kg"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50024; "Base RFA"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Prix Départ","Prix rendu";
        }
        field(50025; "Base CC"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Prix Départ","Prix rendu";
        }
        field(50026; "Prix 3x Net Unit"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Item No.", "Sales Type", "Sales Code", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Order Minimum Quantity", "Order Minimum Palettes")
        {
            Clustered = true;
        }
        key(Key2; "Sales Type", "Sales Code", "Item No.", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(Brick; "Sales Type", "Sales Code", "Item No.", "Starting Date", "Unit Price", "Ending Date")
        {
        }
    }

    trigger OnInsert()
    begin
        if "Sales Type" = "Sales Type"::"All Customers" then
            "Sales Code" := ''
        else
            TestField("Sales Code");
        TestField("Item No.");
    end;

    trigger OnRename()
    begin
        if "Sales Type" <> "Sales Type"::"All Customers" then
            TestField("Sales Code");
        TestField("Item No.");
    end;

    var
        CustPriceGr: Record "Customer Price Group";
        Text000: Label '%1 cannot be after %2';
        Cust: Record Customer;
        Text001: Label '%1 must be blank.';
        Campaign: Record Campaign;
        Item: Record Item;
        Text002: Label 'If Sales Type = %1, then you can only change Starting Date and Ending Date from the Campaign Card.';

    local procedure UpdateValuesFromItem()
    begin
        if Item.Get("Item No.") then begin
            "Allow Invoice Disc." := Item."Allow Invoice Disc.";
            if "Sales Type" = "Sales Type"::"All Customers" then begin
                "Price Includes VAT" := Item."Price Includes VAT";
                "VAT Bus. Posting Gr. (Price)" := Item."VAT Bus. Posting Gr. (Price)";
            end;
        end;
    end;

    procedure CopySalesPriceToCustomersSalesPrice(var SalesPrice: Record "Sales PriceEC"; CustNo: Code[20])
    var
        NewSalesPrice: Record "Sales PriceEC";
    begin
        if SalesPrice.FindSet then
            repeat
                NewSalesPrice := SalesPrice;
                NewSalesPrice."Sales Type" := NewSalesPrice."Sales Type"::Customer;
                NewSalesPrice."Sales Code" := CustNo;
                if NewSalesPrice.Insert then;
            until SalesPrice.Next = 0;
    end;


}

