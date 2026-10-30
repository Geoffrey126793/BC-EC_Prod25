table 50020 "Pallet Journal"
{
    // Module      Point          Dev   Date           Commentaire
    // ----------------------------------------------------------------------------------------------------
    // VN1.00     LOG-100        GEN   14/09/09   :   Module de gestion des palettes
    // ----------------------------------------------------------------------------------------------------
    // 
    // 
    // 
    // 
    // 
    // ----------------------------------------------------------------------------------------------------
    // ABS5.01     STK-103        GEN   11/03/09   :   Module de préparation ABSYS CYBORG
    //   - Gestion des articles de consignes
    // ----------------------------------------------------------------------------------------------------
    // ABS5.01     STK-103        GEN   16/03/09   :   Module de préparation ABSYS CYBORG
    //   ABC GEN 20090316 maj des consignes Uniquement pour le scan
    //                    Ajout du champ fromform
    // 
    // ABS5.01     STK-103        AUT   17/03/09   :   Renommage du champ Lot No. en FF Lot No. (FlowField)
    //                                                 et ajout du champ suivant
    //                                                 EnabledField No.Field NameData TypeLengthDescription
    //                                                 Yes50004Lot No.Code20AUT
    // 
    // ABS5.01     STK-103        AUT   18/03/09   :   //>AT 0001 Test de la saisie du meme SSCC pour un meme lot

    Caption = 'Journal Pallets';
    DrillDownPageID = "Pallet Journal";

    fields
    {
        field(1; "Journal Template Name"; Code[20])
        {
            Caption = 'Journal Name';
        }
        field(2; "Journal Batch Name"; Code[20])
        {
            Caption = 'Journal Description';
        }
        field(3; "SSCC No."; Code[20])
        {
            Caption = 'SSCC No.';
            TableRelation = "Gross Weight / container";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                l_rPalletJournal: Record "Pallet Journal";
            begin
                if Pallet_g.Get("SSCC No.") then begin
                    Pallet_g.CalcFields("Current Quantity");
                    "Treated Quantity" := Pallet_g."Current Quantity";
                end;
                //ELSE MESSAGE('toto %1',"SSCC No.");

                //>AT 0001\
                l_rPalletJournal.Reset;
                l_rPalletJournal.SetRange("SSCC No.", "SSCC No.");
                if l_rPalletJournal.FindFirst then
                    if l_rPalletJournal.Count > 1 then
                        Error(TEXT1000000001, "SSCC No.")
                    else
                        if l_rPalletJournal.Count = 1 then begin
                            if (l_rPalletJournal."Journal Template Name" <> "Journal Template Name") or
                               (l_rPalletJournal."Journal Batch Name" <> "Journal Batch Name") or
                               (l_rPalletJournal."Journal Line No." <> "Journal Line No.") or
                               (l_rPalletJournal.ID <> ID) or
                               (l_rPalletJournal."Document No." <> "Document No.") or
                               (l_rPalletJournal."Document Line No." <> "Document Line No.") then
                                Error(TEXT1000000001, "SSCC No.");
                        end;
                //>AT 0001/
            end;
        }
        field(4; "Treated Quantity"; Decimal)
        {
            Caption = 'Treated Quantity';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                if xRec."Treated Quantity" < 0 then
                    "Treated Quantity" := Abs("Treated Quantity") * -1;
            end;
        }
        field(6; "Reservation Entry"; Integer)
        {
            Caption = 'Reservation Entry';
            TableRelation = "Reservation Entry";
        }
        field(7; ID; Integer)
        {
            Caption = 'ID';
        }
        field(8; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(10; "Journal Line No."; Integer)
        {
            Caption = 'Journal Line No.';
        }
        field(201; "New Bin code"; Code[10])
        {
            Caption = 'New Bin code';
            TableRelation = Bin.Code;
        }
        field(300; Weight; Decimal)
        {
            Caption = 'Weight';
        }
        field(500; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(501; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
        }
        field(502; "Transfert Treated"; Integer)
        {
            Caption = 'Transfert Treated';
            Description = 'Compteur interne sur transfert';
        }
        field(50000; "FF Lot No."; Code[50])
        {
            CalcFormula = Lookup ("Reservation Entry"."Lot No." WHERE ("Entry No." = FIELD ("Reservation Entry")));
            Caption = 'FF Lot No.';
            FieldClass = FlowField;
        }
        field(50001; "Item Tracking Spec Entry No."; Integer)
        {
            Caption = 'Item Tracking Spec Entry No.';
        }
        field(50002; FixRemains; Boolean)
        {
            Caption = 'FixRemains';
        }
        field(50003; FromForm; Boolean)
        {
            Caption = 'FromForm';
        }
        field(50004; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
            Description = 'AUT';
        }
        field(50005; "Source SSCC No."; Code[20])
        {
            Caption = 'Source SSCC No.';
        }
        field(50006; "Source EAN No."; Code[20])
        {
            Caption = 'Source EAN No.';
        }
        field(50007; "Source Lot No."; Code[50])
        {
            Caption = 'Source Lot No.';
        }
        field(50008; "Source Best Before Date"; Date)
        {
            Caption = 'Source Best Before Date';
        }
        field(50011; "Source Content EAN No."; Code[20])
        {
            Caption = 'Source Content EAN No.';
        }
        field(50012; "Content Quantity"; Decimal)
        {
            Caption = 'Content Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(50100; Printed; Boolean)
        {
            Caption = 'Printed';
        }
        field(50200; "Original Qty"; Decimal)
        {
            Caption = 'Original Qty';
        }
        field(50201; "Remaining Qty"; Decimal)
        {
            Caption = 'Remaining Qty';

            trigger OnValidate()
            begin
                "Treated Quantity" := "Remaining Qty" - "Original Qty";
            end;
        }
        field(50202; User; Code[20])
        {
            Caption = 'User';
        }
    }

    keys
    {
        key(Key1; "Journal Template Name", "Journal Batch Name", "Journal Line No.", ID, "Reservation Entry")
        {
            Clustered = true;
        }
        key(Key2; "Reservation Entry")
        {
            SumIndexFields = "Treated Quantity";
        }
        key(Key3; "Document No.", "Document Line No.")
        {
        }
        key(Key4; "Lot No.")
        {
        }
        key(Key5; "SSCC No.")
        {
            SumIndexFields = "Treated Quantity";
        }
        key(Key6; "Source Best Before Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        RecPallet_l: Record "Gross Weight / container";
        CUScanManage_l: Codeunit "Create Item Free Line";
    begin
        //--> ABC GEN 20090311
        //Uniquement pour les picking
        //IF NOT FromForm THEN BEGIN //--> ABC GEN 20090316 Uniquement pour le scan
        //  RecPickingLine_l.SETRANGE("Document No.","Journal Template Name");
        //  RecPickingLine_l.SETRANGE("Line No.","Journal Line No.");
        //  IF RecPickingLine_l.FIND('-') THEN BEGIN
        //    IF RecPallet_l.GET("SSCC No.") THEN BEGIN
        //      CUScanManage_l.GenConsignItem(RecPallet_l,RecPickingLine_l,FALSE);
        //    END;
        //  END;
        //END;
        //<-- ABC GEN 20090311
    end;

    trigger OnInsert()
    var
        RecPallet_l: Record "Gross Weight / container";
        CUScanManage_l: Codeunit "Create Item Free Line";
    begin
        //IF Pallet_g.GET("SSCC No.") THEN BEGIN
        //  Pallet_g.CALCFIELDS("Current Quantity");
        //  "Treated Quantity" := Pallet_g."Current Quantity";
        //END;

        //--> ABC GEN 20090311 Désactivé pour VN1
        //Uniquement pour les picking
        //IF NOT FromForm THEN BEGIN //--> ABC GEN 20090316 Uniquement pour le scan
        //  RecPickingLine_l.SETRANGE("Document No.","Journal Template Name");
        //  RecPickingLine_l.SETRANGE("Line No.","Journal Line No.");
        //  IF RecPickingLine_l.FIND('-') THEN BEGIN
        //    IF RecPallet_l.GET("SSCC No.") THEN BEGIN
        //      CUScanManage_l.GenConsignItem(RecPallet_l,RecPickingLine_l,TRUE);
        //    END;
        //  END;
        //END;
        //<-- ABC GEN 20090311
    end;

    trigger OnModify()
    var
        RecPallet_l: Record "Gross Weight / container";
        CUScanManage_l: Codeunit "Create Item Free Line";
    begin
        //--> ABC GEN 20090311
        //Uniquement pour les picking
        //IF NOT FromForm THEN BEGIN //--> ABC GEN 20090316 Uniquement pour le scan
        //  IF xRec."SSCC No." <> "SSCC No." THEN BEGIN
        //    RecPickingLine_l.SETRANGE("Document No.","Journal Template Name");
        //    RecPickingLine_l.SETRANGE("Line No.","Journal Line No.");
        //    IF RecPickingLine_l.FIND('-') THEN BEGIN
        //      IF RecPallet_l.GET(xRec."SSCC No.") THEN BEGIN
        //        //On enléve la pallete de l'ancien SSCC
        //        CUScanManage_l.GenConsignItem(RecPallet_l,RecPickingLine_l,FALSE);
        //      END;
        //      IF RecPallet_l.GET("SSCC No.") THEN BEGIN
        //        //On ajoute la pallete de l'ancien SSCC
        //        CUScanManage_l.GenConsignItem(RecPallet_l,RecPickingLine_l,TRUE);
        //      END;
        //    END;
        //  END;
        //END;

        //<-- ABC GEN 20090311
    end;

    var
        Pallet_g: Record Pallet;
        TEXT1000000001: Label 'SSCC %1 is already in used';
}

