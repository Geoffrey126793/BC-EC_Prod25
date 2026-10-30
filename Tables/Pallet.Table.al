table 50018 Pallet
{
    Caption = 'Pallet';
    DrillDownPageID = "Liste palettes";
    LookupPageID = "Liste palettes";

    fields
    {
        field(1; "SSCC No."; Code[20])
        {
            Caption = 'SSCC No.';
            NotBlank = true;

            trigger OnValidate()
            begin
                if "SSCC No." <> xRec."SSCC No." then begin
                    InvtSetup.Get;

                    NoSeriesMgt.TestManual(InvtSetup."Pallet Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(25; "Location code"; Code[20])
        {
            Caption = 'Location Code';
            FieldClass = Normal;
            TableRelation = Location;
        }
        field(31; "Location Filter"; Code[10])
        {
            Caption = 'Location Filter';
            FieldClass = FlowFilter;
        }
        field(100; "Current Quantity"; Decimal)
        {
            CalcFormula = Sum("Pallet Ledger Entry".Quantity WHERE("SSCC No." = FIELD("SSCC No."),
                                                                    "Location Code" = FIELD("Location Filter")));
            Caption = 'Current Quantity';
            DecimalPlaces = 0 : 5;
            FieldClass = FlowField;
        }
        field(102; "Current Weight"; Decimal)
        {
            CalcFormula = Sum("Pallet Ledger Entry".Weight WHERE("SSCC No." = FIELD("SSCC No.")));
            Caption = 'Current Weight';
            DecimalPlaces = 0 : 5;
            FieldClass = FlowField;
        }
        field(110; "Inbound Document Type"; Option)
        {
            Caption = 'Inbound Document Type';
            OptionCaption = ' ,Production Order,Positive Adjustement,Purchase Order,Sales Return';
            OptionMembers = " ","Production Order","Positive Adjustement","Purchase Order","Sales Return",Transfer;
        }
        field(111; "Inbound Document No."; Code[20])
        {
            Caption = 'Inbound Document No.';
        }
        field(112; "Inbound Doc. Line No."; Integer)
        {
            Caption = 'Inbound Doc. Line No.';
        }
        field(120; "Outbound Document Type"; Option)
        {
            Caption = 'Outbound Document Type';
            OptionCaption = ' ,Consumption,Negative Adjustement,Sales Shipment,Purchase return';
            OptionMembers = " ",Consumption,"Negative Adjustement","Sales Shipment","Shipping Document","Consignation Document","Deconsignation Document",Transfer;
        }
        field(121; "Outbound Document No."; Code[20])
        {
            Caption = 'Outbound Document No.';
        }
        field(122; "Outbound Doc. Line No."; Integer)
        {
            Caption = 'Outbound Doc. Line No.';
        }
        field(124; "Last Entry No."; Integer)
        {
            CalcFormula = Max("Pallet Ledger Entry"."Entry No." WHERE("SSCC No." = FIELD("SSCC No."),
                                                                       Quantity = FILTER(> 0)));
            Caption = 'Last Entry No.';
            FieldClass = FlowField;
        }
        field(125; "Pallet Journal Line Exist"; Boolean)
        {
            CalcFormula = Exist("Pallet Journal" WHERE("SSCC No." = FIELD("SSCC No.")));
            Caption = 'Pallet Journal Line Exist';
            Editable = false;
            FieldClass = FlowField;
        }
        field(130; "Qty on pallet Jnl"; Decimal)
        {
            CalcFormula = Sum("Pallet Journal"."Treated Quantity" WHERE("SSCC No." = FIELD("SSCC No.")));
            Caption = 'Qty on pallet Jnl';
            DecimalPlaces = 0 : 5;
            FieldClass = FlowField;
        }
        field(50013; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
        }
        field(50014; "Creation Time"; Time)
        {
            Caption = 'Creation Time';
        }
        field(50034; "Current Quantity lot Prod"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("Item No."),
                                                                  "Lot No." = FIELD("Lot No."),
                                                                  "Location Code" = FILTER(<> 'EC STOCK' & <> '9-TFT' & <> 'RD')));
            Caption = 'Current Quantity lot';
            DecimalPlaces = 0 : 5;
            FieldClass = FlowField;
        }
        field(52003; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = Microsoft.Foundation.NoSeries."No. Series";
        }
        field(52004; "Bin code"; Code[20])
        {
            Caption = 'Bin code';
            Description = 'btt 201117';
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Location code"));
        }
        field(52005; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;

            trigger OnValidate()
            begin
                if (CopyStr("Item No.", 1, 5) = '1-CRU') then
                    Agrément := Agrément::KF102454;
            end;
        }
        field(52006; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
        }
        field(52007; DLC; Date)
        {
            Caption = 'DLC';
        }
        field(55001; "Display order"; Integer)
        {
            Caption = 'Display order';
        }
        field(55002; "Item Description"; Text[100])
        {
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD("Item No.")));
            Caption = 'Item Description';
            FieldClass = FlowField;
        }
        field(55003; "Nbre bacs reception"; Integer)
        {
            Caption = 'Nbre bacs reception';
        }
        field(55004; "Type bacs reception"; Code[20])
        {
            Caption = 'Type bacs reception';
        }
        field(55005; "Type palette reception"; Code[20])
        {
            Caption = 'Type palette reception';
        }
        field(55006; "Temperature reception"; Integer)
        {
            Caption = 'Temperature reception';
        }
        field(55007; "Poids brut reception"; Decimal)
        {
            Caption = 'Poids brut reception';
        }
        field(55008; "Quantite reception"; Decimal)
        {
            Caption = 'Quantite reception';
        }
        field(55009; "Quai reception"; Text[30])
        {
            Caption = 'Quai reception';
        }
        field(55010; "User reception"; Text[30])
        {
            Caption = 'User reception';
        }
        field(55011; "Unit of measure"; Text[10])
        {
            Caption = 'Unit of measure';
        }
        field(55012; "Quai reception Txt"; Text[150])
        {
            CalcFormula = Lookup(Code.Description WHERE("Table No" = CONST(50018),
                                                         "Field No" = CONST(55009),
                                                         Code = FIELD("Quai reception")));
            Caption = 'Quai reception Txt';
            FieldClass = FlowField;
        }
        field(55013; "User reception Txt"; Code[250])
        {
            CalcFormula = Lookup(Employee."Search Name" WHERE(User = FIELD("User reception")));
            Caption = 'User reception Txt';
            FieldClass = FlowField;
        }
        field(55014; "Type bacs Txt"; Text[150])
        {
            CalcFormula = Lookup(Code.Description WHERE("Table No" = CONST(50018),
                                                         "Field No" = CONST(55004),
                                                         Code = FIELD("Type bacs reception")));
            Caption = 'Type bacs Txt';
            FieldClass = FlowField;
        }
        field(55015; "Type palette Txt"; Text[150])
        {
            CalcFormula = Lookup(Code.Description WHERE("Table No" = CONST(50018),
                                                         "Field No" = CONST(55005),
                                                         Code = FIELD("Type palette reception")));
            Caption = 'Type palette Txt';
            FieldClass = FlowField;
        }
        field(55016; "Lot bloque"; Boolean)
        {
            CalcFormula = Lookup("Lot No. Information".Blocked WHERE("Item No." = FIELD("Item No."),
                                                                      "Lot No." = FIELD("Lot No.")));
            Caption = 'Lot bloque';
            FieldClass = FlowField;
        }
        field(55017; NumOF; Code[20])
        {
            Caption = 'NumOF';
        }
        field(55018; LigneOF; Integer)
        {
            Caption = 'LigneOF';
        }
        field(55020; "Ligne production"; Code[10])
        {
            Caption = 'Ligne production';
        }
        field(55021; ABloquer; Boolean)
        {
            Caption = 'ABloquer';
        }
        field(55022; Comment; Text[80])
        {
            Caption = 'Comment';
        }
        field(55023; Printed; Boolean)
        {
            Caption = 'Printed';
        }
        field(55024; "Palette liee"; Code[20])
        {
            Caption = 'Palette liee';
        }
        field(55025; "Dernier Inventaire"; DateTime)
        {
            Caption = 'Dernier Inventaire';
        }
        field(55026; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Stock,Expedition';
            OptionMembers = Stock,Expedition;
        }
        field(55027; "Quantite lot reserve"; Decimal)
        {
            CalcFormula = Sum("Reservation Entry"."Quantity (Base)" WHERE(Positive = CONST(false),
                                                                           "Item No." = FIELD("Item No."),
                                                                           "Lot No." = FIELD("Lot No."),
                                                                           "Location Code" = FIELD("Location code")));
            Caption = 'Quantite lot reserve';
            FieldClass = FlowField;
        }
        field(55028; "Current Quantity lot"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("Item No."),
                                                                  "Lot No." = FIELD("Lot No."),
                                                                  "Location Code" = FIELD("Location code")));
            Caption = 'Current Quantity lot';
            DecimalPlaces = 0 : 5;
            FieldClass = FlowField;
        }
        field(55029; "Agrément"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = B102454,KF102454,Aucun;
        }
        field(55030; "Temperature secondaire"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(55031; "Date Temperature secondaire"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(55032; "Current quantity Stock"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("Item No."),
                                                                  "Location Code" = FILTER(<> '9-TFT')));
            FieldClass = FlowField;
        }
        field(55033; "Current quantity ECStock"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("Item No."),
                                                                  "Location Code" = CONST('EC STOCK')));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "SSCC No.")
        {
            Clustered = true;
        }
        key(Key2; "Inbound Document Type", "Inbound Document No.")
        {
        }
        key(Key3; "Outbound Document Type", "Outbound Document No.")
        {
        }
        key(Key4; "Bin code")
        {
        }
        key(Key5; "Item No.", "Lot No.", "Bin code")
        {
        }
        key(Key6; "Display order")
        {
        }
        key(Key7; "Inbound Document No.", "Inbound Doc. Line No.", "Lot No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if GuiAllowed then
            if StrPos("Outbound Document No.", 'CDV') = 0 then
                Error('Impossible de supprimer');
    end;

    trigger OnInsert()
    begin
        if "SSCC No." = '' then begin
            InvtSetup.Get;
            InvtSetup.TestField("Pallet Nos.");
            "SSCC No." := NoSeriesMgt.GetNextNo(InvtSetup."Pallet Nos.", Today);
        end;
        if DLC < 19000101D then
            DLC := 0D;
    end;

    trigger OnModify()
    begin
        if DLC < 19000101D then
            DLC := 0D;

        if CopyStr("Lot No.", 1, 6) = '#PROD#' then getFromOF();
    end;

    var
        InvtSetup: Record "Inventory Setup";
        NoSeriesMgt: Codeunit Microsoft.Foundation.NoSeries."No. Series";

    [Scope('OnPrem')]
    procedure getFromOF()
    var
        recOFL: Record "Prod. Order Line";
        recItem: Record Item;
        LastPal: Record Pallet;
        Utils: Codeunit Utils;
        Dt: Date;
        y: Integer;
        m: Integer;
        d: Integer;
    begin
        "Creation Date" := Today;
        "Creation Time" := Time;
        recOFL.Reset;
        recOFL.SetRange("Prod. Order No.", NumOF);
        recOFL.SetRange("Line No.", LigneOF);
        recOFL.FindFirst;

        LastPal.Reset;
        LastPal.SetRange(NumOF, NumOF);
        LastPal.SetRange(LigneOF, LigneOF);
        if LastPal.FindLast then
            "Ligne production" := LastPal."Ligne production";

        "Item No." := recOFL."Item No.";
        Dt := Today;
        if StrLen("Lot No.") = 14 then begin
            Evaluate(d, CopyStr("Lot No.", 13, 2));
            Evaluate(m, CopyStr("Lot No.", 11, 2));
            Evaluate(y, CopyStr("Lot No.", 7, 4));
            Dt := DMY2Date(d, m, y);
        end;
        if ((StrPos("Item No.", 'IQF') > 0) or (StrPos("Item No.", '5-FAT') > 0)) then
            "Lot No." := CopyStr(CopyStr("SSCC No.", 7, 6) + '/' + Format((Date2DMY(Dt, 3) - 2000)) +
             Utils.PadLeft(Format((Dt - DMY2Date(1, 1, Date2DMY(Dt, 3))) + 1), '0', 3) + '-' + "Ligne production", 1, 20)
        else
            "Lot No." := Format((Date2DMY(Dt, 3) - 2000)) + Utils.PadLeft(Format((Dt - DMY2Date(1, 1, Date2DMY(Dt, 3))) + 1), '0', 3);

        recItem.Get("Item No.");
        DLC := CalcDate(recItem.FormuleDLC, Dt);
        "Nbre bacs reception" := recItem.BoitesPalette;
        "Quantite reception" := recItem.PoidsPalette;
        "Type palette reception" := recItem.TypePalette;

        if recItem."Comment blocage lots produits" <> '' then begin
            ABloquer := true;
            Comment := Comment + ' + ' + recItem."Comment blocage lots produits";
        end;
    end;
}

