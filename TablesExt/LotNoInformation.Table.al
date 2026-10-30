tableextension 50030 LotNoInformationEC extends "Lot No. Information"
{
    fields
    {
        field(50000; "Item Description"; Text[100])
        {
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD("Item No.")));
            Caption = 'Description';
            Description = 'LOG.5';
            FieldClass = FlowField;
        }
        field(50001; "Entry Type Filter"; Option)
        {
            Caption = 'Entry Type Filter';
            Description = 'PRO.1';
            FieldClass = FlowFilter;
            OptionCaption = 'Purchase,Sale,Positive Adjmt.,Negative Adjmt.,Transfer,Consumption,Output';
            OptionMembers = Purchase,Sale,"Positive Adjmt.","Negative Adjmt.",Transfer,Consumption,Output;
        }
        field(50002; "Inventory Period"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("Item No."),
                                                                  "Variant Code" = FIELD("Variant Code"),
                                                                  "Lot No." = FIELD("Lot No."),
                                                                  "Location Code" = FIELD("Location Filter"),
                                                                  "Posting Date" = FIELD("Inventory Date Filter")));
            Caption = 'Inventory Period';
            DecimalPlaces = 0 : 5;
            Description = 'PRO.1';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50003; "Inventory Date Filter"; Date)
        {
            Caption = 'Inventory Date Filter';
            FieldClass = FlowFilter;
        }
        field(50060; "Pick Qty."; Decimal)
        {
            CalcFormula = Sum("Warehouse Activity Line"."Qty. Outstanding" WHERE("Location Code" = FIELD("Location Filter"),
                                                                                  "Bin Code" = FIELD("Bin Filter"),
                                                                                  "Item No." = FIELD("Item No."),
                                                                                  "Variant Code" = FIELD("Variant Code"),
                                                                                  "Action Type" = CONST(Take),
                                                                                  "Lot No." = FIELD("Lot No.")));
            Caption = 'Pick Qty.';
            Description = 'ART-004';
            FieldClass = FlowField;
        }
        field(50061; "Pick DLC"; Date)
        {
            CalcFormula = Lookup("Item Ledger Entry"."Warranty Date" WHERE("Item No." = FIELD("Item No."),
                                                                            "Variant Code" = FIELD("Variant Code")));
            Caption = 'Pick DLC';
            Description = 'ART-004';
            FieldClass = FlowField;
        }
        field(50090; "Poids moyen"; Decimal)
        {
            Caption = 'Poids moyen';
        }
        field(50100; "Inventory Warehouse Entry"; Decimal)
        {
            CalcFormula = Sum("Warehouse Entry"."Qty. (Base)" WHERE("Item No." = FIELD("Item No."),
                                                                     "Bin Code" = FIELD("Bin Filter"),
                                                                     "Lot No." = FIELD("Lot No.")));
            Caption = 'Inventory Warehouse Entry';
            FieldClass = FlowField;
        }
        field(50101; "Gross Weight / container"; Code[20])
        {
            Caption = 'Gross Weight / container';
            Description = 'pour le calcul poids brut d''un lot';
            TableRelation = "Gross Weight / container";
        }
        field(50102; "Commentaire coupe/calibre"; Text[250])
        {
            Caption = 'Commentaire coupe/calibre';
        }
        field(50103; "Commentaire couleur/odeur"; Text[250])
        {
            Caption = 'Commentaire couleur/odeur';
        }
        field(50104; "Date controle"; Date)
        {
            Caption = 'Date controle';
        }
        field(50105; "Commentaire packaging/livraiso"; Text[250])
        {
            Caption = 'Commentaire packaging/livraiso';
        }
        field(50106; "Commentaire blocage"; Text[250])
        {
            Caption = 'Commentaire blocage blocage';
        }
        field(50107; "En vente"; Decimal)
        {
            CalcFormula = Sum("Reservation Entry"."Quantity (Base)" WHERE("Item No." = FIELD("Item No."),
                                                                           "Lot No." = FIELD("Lot No."),
                                                                           "Source Type" = CONST(37),
                                                                           "Source Subtype" = CONST("1")));
            FieldClass = FlowField;
        }
        field(50108; "Previously blocked"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50200; ElevagePays; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(50201; ElevageVille; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50202; AbattagePays; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(50203; AbattageVille; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50204; AbattageCP; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50205; AbattageDu; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50206; AbattageAu; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50207; DecoupePays; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(50208; DecoupeVille; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50209; DecoupeCP; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50210; DecoupeDu; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50211; DecoupeAu; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50212; Decision; Text[200])
        {
            DataClassification = ToBeClassified;
            TableRelation = Code.Code WHERE("Table No" = CONST(6505),
                                             "Field No" = CONST(50212));
        }
        field(50213; AttachedFile; BLOB)
        {
            DataClassification = ToBeClassified;
        }
        field(50214; "Raison du blocage"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Code.Code WHERE("Table No" = CONST(6505),
                                             "Field No" = CONST(50214));
        }
        field(50215; "Commentaire decision"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50216; "Statut du blocage"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Code.Code WHERE("Table No" = CONST(6505),
                                             "Field No" = CONST(50216));
        }
        field(50217; Destination; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Code.Code WHERE("Table No" = CONST(6505),
                                             "Field No" = CONST(50217));
        }
        field(50218; Recyclage; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Code.Code WHERE("Table No" = CONST(6505),
                                             "Field No" = CONST(50218));
        }
    }

}

