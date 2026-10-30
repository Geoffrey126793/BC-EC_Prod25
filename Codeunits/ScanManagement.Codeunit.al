codeunit 50001 "Scan Management"
{
    // ABC KWK 20130711
    //   Ajout divers init
    // 
    // //BNC 30/01/14 Prise compte du calcul de cohérence entre picking et les lignes
    // de la commandes (même lot sur plusieurs lignes de ventes), de même pour les OTS


    trigger OnRun()
    begin
        PutAwayPartialPallet('000000272811', 3, '', '', 'test1', 'PROD');
        Message('ok');
    end;

    var
        Pallet: Record Pallet;
        ReservEntry: Record "Reservation Entry";
        PalletEntry: Record "Pallet Ledger Entry";
        OldPalletEntry: Record "Pallet Ledger Entry";
        RecInventorySetup_g: Record "Inventory Setup";
        UserSetup: Record "Scan User Setup";
        NextEntry: Integer;
        Items: Record Item;

    [Scope('OnPrem')]
    procedure CreatePallet() SSCCNo: Code[20]
    begin
        Pallet.Init;
        Pallet."SSCC No." := '';
        Pallet."Creation Date" := WorkDate;
        Pallet."Creation Time" := Time;
        Pallet.Insert(true);

        exit(Pallet."SSCC No.");
    end;

    [Scope('OnPrem')]
    procedure CreatePalletJournal(ReservationEntry: Record "Reservation Entry")
    var
        PalletJournal_l: Record "Pallet Journal";
        NextEntry_l: Integer;
        ItemJournalLine_l: Record "Item Journal Line";
        i: Integer;
    begin

        if ReservationEntry."Pallet Qty" > 0 then begin
            for i := 1 to ReservationEntry."Pallet Qty" do begin
                //*** Création Ligne Journal Palette *****************************************************************
                PalletJournal_l.Reset;
                PalletJournal_l.SetRange("Journal Template Name", ReservationEntry."Source ID");
                PalletJournal_l.SetRange("Journal Batch Name", ReservationEntry."Source Batch Name");
                PalletJournal_l.SetRange("Journal Line No.", ReservationEntry."Source Ref. No.");
                if not PalletJournal_l.Find('+') then
                    NextEntry_l := 10000
                else
                    NextEntry_l := PalletJournal_l.ID + 10000;

                PalletJournal_l.Init;
                PalletJournal_l."Journal Template Name" := ReservationEntry."Source ID";
                PalletJournal_l."Journal Batch Name" := ReservationEntry."Source Batch Name";
                PalletJournal_l."Journal Line No." := ReservationEntry."Source Ref. No.";
                if (ReservationEntry."Source Type" = 39) or (ReservationEntry."Source Type" = 5741) or ((ReservationEntry."Source Type" = 37) and (ReservationEntry."Source Subtype" = 5)) then begin
                    PalletJournal_l."Document No." := ReservationEntry."Source ID";
                    // ABC KWK 20130711 >
                    if ReservationEntry."Source Type" = 5741 then
                        PalletJournal_l."Document Line No." := ReservationEntry."Source Prod. Order Line"
                    //ABC KWK 20130711 <
                    else
                        PalletJournal_l."Document Line No." := ReservationEntry."Source Ref. No.";
                end;
                PalletJournal_l.ID := NextEntry_l;
                PalletJournal_l."SSCC No." := CreatePallet;
                PalletJournal_l."Treated Quantity" := (ReservationEntry."Quantity (Base)" / ReservationEntry."Pallet Qty");
                PalletJournal_l."Reservation Entry" := ReservationEntry."Entry No.";
                //  PalletJournal_l."New Bin code" :=
                PalletJournal_l."Lot No." := ReservationEntry."Lot No.";
                PalletJournal_l.Insert;
            end;
        end;
    end;

    [Scope('OnPrem')]
    procedure CreatePalletJournalFromTrack(ReservationEntry: Record "Tracking Specification")
    var
        PalletJournal_l: Record "Pallet Journal";
        NextEntry_l: Integer;
        ItemJournalLine_l: Record "Item Journal Line";
        i: Integer;
    begin

        if ReservationEntry."Pallet Qty" > 0 then begin
            for i := 1 to ReservationEntry."Pallet Qty" do begin
                //*** Création Ligne Journal Palette *****************************************************************
                PalletJournal_l.Reset;
                PalletJournal_l.SetRange("Journal Template Name", ReservationEntry."Source ID");
                PalletJournal_l.SetRange("Journal Batch Name", ReservationEntry."Source Batch Name");
                if not PalletJournal_l.Find('+') then
                    NextEntry_l := 10000
                else
                    NextEntry_l := PalletJournal_l.ID + 10000;

                PalletJournal_l.Init;
                PalletJournal_l."Journal Template Name" := ReservationEntry."Source ID";
                PalletJournal_l."Journal Batch Name" := ReservationEntry."Source Batch Name";
                PalletJournal_l."Journal Line No." := ReservationEntry."Source Ref. No.";
                if ReservationEntry."Source Type" = 39 then begin
                    PalletJournal_l."Document No." := ReservationEntry."Source ID";
                    PalletJournal_l."Document Line No." := ReservationEntry."Source Ref. No.";
                end;
                PalletJournal_l.ID := NextEntry_l;
                PalletJournal_l."SSCC No." := CreatePallet;
                PalletJournal_l."Treated Quantity" := (ReservationEntry."Quantity (Base)" / ReservationEntry."Pallet Qty");
                PalletJournal_l."Reservation Entry" := ReservationEntry."Entry No.";
                //  PalletJournal_l."New Bin code" :=
                PalletJournal_l."Lot No." := ReservationEntry."Lot No.";
                PalletJournal_l.Insert;
            end;
        end;
    end;

    [Scope('OnPrem')]
    procedure PostPallet(var ItemJnlLine: Record "Item Journal Line"; var ItemLedgEntry: Record "Item Ledger Entry")
    var
        RecPalletJnl: Record "Pallet Journal";
        RecPalletEntry: Record "Pallet Ledger Entry";
        OldPalletEntry: Record "Pallet Ledger Entry";
        RecPallet: Record Pallet;
        RecItem: Record Item;
        ExistingItemJnlLine: Record "Item Journal Line";
        l_rReservationEntry: Record "Reservation Entry";
        RemainQty: Decimal;
        FirstStep: Boolean;
        l_rPallet: Record Pallet;
        Location_l: Record Location;
        LastILE: Record "Item Ledger Entry";
    begin
        //--> ABC VIE 20090204
        ExistingItemJnlLine.Reset;
        if ExistingItemJnlLine.Get(ItemJnlLine."Journal Template Name",
                                   ItemJnlLine."Journal Batch Name",
                                   ItemJnlLine."Line No.") then begin
            if ExistingItemJnlLine."Item No." <> ItemJnlLine."Item No." then exit;
        end;
        // <-- ABC VIE 20090204

        RecPalletJnl.Reset;
        if ItemJnlLine."Journal Template Name" <> '' then begin
            RecPalletJnl.SetRange("Journal Template Name", ItemJnlLine."Journal Template Name");
            RecPalletJnl.SetRange("Journal Batch Name", ItemJnlLine."Journal Batch Name");
            RecPalletJnl.SetRange("Journal Line No.", ItemJnlLine."Line No.");
        end else begin
            RecPalletJnl.SetRange("Document No.", ItemJnlLine."Document No. Pallet");
            //--> ABC GEN 20090210
            RecPalletJnl.SetRange("Document Line No.", ItemJnlLine."Document Line No. Pallet");
            //<-- ABC GEN 20090210

            //GD281019
            RecPalletJnl.SetRange("Lot No.", ItemLedgEntry."Lot No.");

        end;
        if RecPalletJnl.Find('-') then begin
            OldPalletEntry.Reset;
            if not OldPalletEntry.Find('+') then OldPalletEntry."Entry No." := 0;
            repeat
                RecItem.Get(ItemJnlLine."Item No.");

                if RecPalletJnl."Treated Quantity" <> 0 then begin
                    RecPalletJnl.Weight := RecPalletJnl."Treated Quantity" * RecItem."Net Weight";
                    if not RecPallet.Get(RecPalletJnl."SSCC No.") then begin
                        RecPallet.Init;
                        RecPallet."SSCC No." := RecPalletJnl."SSCC No.";
                        RecPallet."Creation Date" := WorkDate;
                        RecPallet."Creation Time" := Time;
                        RecPallet.Insert;
                    end;
                    RecPalletEntry.Init;
                    RecPalletEntry."Entry No." := OldPalletEntry."Entry No." + 1;
                    OldPalletEntry."Entry No." := OldPalletEntry."Entry No." + 1;
                    RecPalletEntry."SSCC No." := RecPalletJnl."SSCC No.";
                    RecPalletEntry."Item ledger entry No." := ItemLedgEntry."Entry No.";
                    RecPalletEntry."Location Code" := ItemLedgEntry."Location Code";
                    RecPalletEntry."Item No." := ItemJnlLine."Item No.";
                    RecPalletEntry."Lot No." := RecPalletJnl."Lot No.";
                    RecPalletEntry.User := RecPalletJnl.User;
                    case ItemLedgEntry."Entry Type" of
                        ItemLedgEntry."Entry Type"::Purchase:
                            begin
                                RecPalletEntry."Entry Type" := RecPalletEntry."Entry Type"::Purchase;
                                RecPalletEntry.Quantity := RecPalletJnl."Treated Quantity";
                                RecPalletEntry."Qty. By Pallet" := RecPalletJnl."Treated Quantity";
                                RecPalletEntry.Weight := RecPalletJnl.Weight;
                                RecPallet."Inbound Document Type" := RecPallet."Inbound Document Type"::"Purchase Order";
                                RecPallet."Inbound Document No." := ItemJnlLine."Document No. Pallet";
                                RecPallet."Inbound Doc. Line No." := ItemJnlLine."Document Line No. Pallet";
                            end;
                        ItemLedgEntry."Entry Type"::Sale:
                            begin
                                RecPalletEntry."Entry Type" := RecPalletEntry."Entry Type"::Sale;
                                if ItemLedgEntry."Document Type" = ItemLedgEntry."Document Type"::"Sales Return Receipt" then begin
                                    RecPalletEntry.Quantity := RecPalletJnl."Treated Quantity";
                                    RecPalletEntry."Qty. By Pallet" := RecPalletJnl."Treated Quantity";
                                    RecPalletEntry.Weight := RecPalletJnl.Weight;
                                end
                                else begin
                                    RecPalletEntry.Quantity := -RecPalletJnl."Treated Quantity";
                                    RecPalletEntry."Qty. By Pallet" := -RecPalletJnl."Treated Quantity";
                                    RecPalletEntry.Weight := -RecPalletJnl.Weight;
                                end;
                                RecPallet."Outbound Document Type" := RecPallet."Outbound Document Type"::"Sales Shipment";
                                RecPallet."Outbound Document No." := ItemJnlLine."Document No. Pallet";
                                RecPallet."Outbound Doc. Line No." := ItemJnlLine."Document Line No. Pallet";
                            end;
                        ItemLedgEntry."Entry Type"::"Positive Adjmt.":
                            begin
                                RecPalletEntry."Entry Type" := RecPalletEntry."Entry Type"::"Positive Adjmt.";
                                RecPalletEntry.Quantity := RecPalletJnl."Treated Quantity";
                                RecPalletEntry."Qty. By Pallet" := RecPalletJnl."Treated Quantity";
                                RecPalletEntry.Weight := RecPalletJnl.Weight;
                                RecPallet."Inbound Document Type" := RecPallet."Inbound Document Type"::"Positive Adjustement";
                                RecPallet."Inbound Document No." := ItemJnlLine."Document No. Pallet";
                                RecPallet."Inbound Doc. Line No." := ItemJnlLine."Document Line No. Pallet";
                            end;
                        ItemLedgEntry."Entry Type"::"Negative Adjmt.":
                            begin
                                RecPalletEntry."Entry Type" := RecPalletEntry."Entry Type"::"Negative Adjmt.";
                                RecPalletEntry.Quantity := RecPalletJnl."Treated Quantity";
                                RecPalletEntry.Weight := RecPalletJnl.Weight;
                                RecPalletEntry."Qty. By Pallet" := -RecPalletJnl."Treated Quantity";
                                RecPallet."Outbound Document Type" := RecPallet."Outbound Document Type"::"Negative Adjustement";
                                RecPallet."Outbound Document No." := ItemJnlLine."Document No. Pallet";
                                RecPallet."Outbound Doc. Line No." := ItemJnlLine."Document Line No. Pallet";
                            end;
                        ItemLedgEntry."Entry Type"::Transfer:
                            begin
                                RecPalletEntry."Entry Type" := RecPalletEntry."Entry Type"::Transfer;
                                RecPalletEntry.Quantity := -RecPalletJnl."Treated Quantity";
                                RecPalletEntry.Weight := -RecPalletJnl.Weight;
                                RecPalletEntry."Qty. By Pallet" := -RecPalletJnl."Treated Quantity";
                                RecPalletJnl."Transfert Treated" := RecPalletJnl."Transfert Treated" + 1;
                            end;
                        ItemLedgEntry."Entry Type"::Consumption:
                            begin
                                RecPalletEntry."Entry Type" := RecPalletEntry."Entry Type"::Consumption;
                                RecPalletEntry.Quantity := -RecPalletJnl."Treated Quantity";
                                RecPalletEntry."Qty. By Pallet" := -RecPalletJnl."Treated Quantity";
                                RecPalletEntry.Weight := -RecPalletJnl.Weight;
                                RecPallet."Outbound Document Type" := RecPallet."Outbound Document Type"::Consumption;
                                RecPallet."Outbound Document No." := ItemJnlLine."Document No. Pallet";
                                RecPallet."Outbound Doc. Line No." := ItemJnlLine."Document Line No. Pallet";
                            end;
                        ItemLedgEntry."Entry Type"::Output:
                            begin
                                RecPalletEntry."Entry Type" := RecPalletEntry."Entry Type"::Output;
                                RecPalletEntry.Quantity := RecPalletJnl."Treated Quantity";
                                RecPalletEntry."Qty. By Pallet" := RecPalletJnl."Treated Quantity";
                                RecPalletEntry.Weight := RecPalletJnl.Weight;
                                RecPallet."Inbound Document Type" := RecPallet."Inbound Document Type"::"Production Order";
                                RecPallet."Inbound Document No." := ItemLedgEntry."Document No.";
                                RecPallet."Inbound Doc. Line No." := ItemLedgEntry."Document Line No.";
                            end;
                    end;

                    RecPalletEntry."Location Code" := ItemLedgEntry."Location Code";
                    RecPalletEntry."Bin Code" := ItemJnlLine."Bin Code";

                    RecPalletEntry."Document No." := ItemLedgEntry."Document No.";
                    RecPalletEntry."Posting Date" := ItemLedgEntry."Posting Date";

                    if ItemLedgEntry."Entry Type" = ItemLedgEntry."Entry Type"::Transfer then begin
                        if RecPalletJnl."Transfert Treated" = 1 then begin
                            RecPalletEntry."Location Code" := ItemLedgEntry."Location Code";
                            RecPalletEntry."Bin Code" := ItemJnlLine."Bin Code";
                            RecPallet."Inbound Document Type" := RecPallet."Inbound Document Type"::Transfer;
                            RecPallet."Inbound Document No." := ItemJnlLine."Document No. Pallet";
                            RecPallet."Inbound Doc. Line No." := ItemJnlLine."Document Line No. Pallet";
                        end else begin
                            RecPalletEntry.Quantity := -RecPalletEntry.Quantity;
                            RecPalletEntry.Weight := -RecPalletEntry.Weight;
                            RecPalletEntry."Qty. By Pallet" := -RecPalletEntry."Qty. By Pallet";
                            RecPalletEntry."Location Code" := ItemJnlLine."New Location Code";
                            RecPalletEntry."Bin Code" := ItemJnlLine."New Bin Code";
                            RecPallet."Outbound Document Type" := RecPallet."Outbound Document Type"::Transfer;
                            RecPallet."Outbound Document No." := ItemJnlLine."Document No. Pallet";
                            RecPallet."Outbound Doc. Line No." := ItemJnlLine."Document Line No. Pallet";
                        end;
                    end;

                    if ItemLedgEntry."Entry Type" = ItemLedgEntry."Entry Type"::Transfer then begin
                        if RecPalletJnl."Transfert Treated" = 2 then begin
                            RecPalletJnl.Delete;
                        end else begin
                            RecPalletJnl.Modify;
                        end;
                    end else begin
                        RecPalletJnl.Delete;
                    end;
                    if ((Location_l.Get(RecPalletEntry."Location Code")) and (Location_l."Pallet Management"))
                      or (ItemLedgEntry."Entry Type" = ItemLedgEntry."Entry Type"::Output) then begin
                        //RecPalletEntry."Document No." :=  RecPalletEntry."Document No." +'P';
                        RecPalletEntry.Insert;

                        RecPallet.Validate("Location code", RecPalletEntry."Location Code");
                        RecPallet.Validate("Bin code", RecPalletEntry."Bin Code");
                        RecPallet.Validate("Item No.", RecPalletEntry."Item No.");
                        RecPallet.Validate("Lot No.", RecPalletEntry."Lot No.");
                        RecPallet.CalcFields("Current Quantity");
                        if RecPallet."Current Quantity" <= 0 then RecPallet."Bin code" := '';
                        RecPallet.DLC := ItemLedgEntry."Warranty Date";
                        RecPallet.Modify;
                    end;
                end;
            until RecPalletJnl.Next = 0;
        end;
    end;

    [Scope('OnPrem')]
    procedure PutAwayPalletWithUser(SSCCNo: Code[20]; NewBin: Code[20]; User: Code[20])
    var
        RecOldItemJnlLine_l: Record "Item Journal Line";
        RecItemJournalLine_l: Record "Item Journal Line";
        NewNumber_l: Integer;
        RecItem_l: Record Item;
        ReservationEntry_l: Record "Reservation Entry";
        ReservEntry_l: Integer;
        LotInfo_l: Record "Lot No. Information";
        PalletJournal_l: Record "Pallet Journal";
        NextEntry_l: Integer;
        FlagBlocked: Boolean;
    begin

        UserSetup.Get(UserId);
        Pallet.Get(SSCCNo);
        Pallet.CalcFields("Last Entry No.");
        Pallet.CalcFields("Current Quantity");
        if (Pallet."Current Quantity" > 0) then begin
            RecItem_l.Get(Pallet."Item No.");
            FlagBlocked := false;
            if RecItem_l.Blocked then begin
                FlagBlocked := true;
                RecItem_l.Blocked := false;
                RecItem_l.Modify(false);
            end;
            //Création de ligne journal
            RecOldItemJnlLine_l.Reset;
            RecOldItemJnlLine_l.SetRange("Journal Template Name", UserSetup."Jnl Template Name");
            RecOldItemJnlLine_l.SetRange("Journal Batch Name", UserSetup."Jnl Batch Name");
            if RecOldItemJnlLine_l.Find('+') then begin
                NewNumber_l := RecOldItemJnlLine_l."Line No." + 10000;
            end else begin
                NewNumber_l := 10000;
            end;

            RecItemJournalLine_l.Init;
            RecItemJournalLine_l.Validate("Journal Template Name", UserSetup."Jnl Template Name");
            RecItemJournalLine_l.Validate("Journal Batch Name", UserSetup."Jnl Batch Name");
            RecItemJournalLine_l.Validate("Line No.", NewNumber_l);
            RecItemJournalLine_l.Validate("Entry Type", RecItemJournalLine_l."Entry Type"::Transfer);
            RecItemJournalLine_l.Validate("Item No.", Pallet."Item No.");
            RecItemJournalLine_l.Validate("Location Code", Pallet."Location code");
            RecItemJournalLine_l.Validate(Quantity, Pallet."Current Quantity");
            RecItemJournalLine_l.Validate("Unit of Measure Code", RecItem_l."Base Unit of Measure");
            RecItemJournalLine_l.Validate("Document Date", WorkDate);
            RecItemJournalLine_l.Validate("Posting Date", WorkDate);
            RecItemJournalLine_l.Validate("Document No.", Pallet."Inbound Document No.");
            //ABC KWK 20130711 >
            if RecItemJournalLine_l."Document No." = '' then
                RecItemJournalLine_l.Validate("Document No.", UserSetup."Jnl Batch Name");
            //RecItemJournalLine_l.VALIDATE("New Lot No.",Pallet."Lot No.");
            //ABC KWK 20130711 <
            RecItemJournalLine_l."Bin Code" := Pallet."Bin code";
            RecItemJournalLine_l.Validate("New Bin Code", NewBin);
            //RecItemJournalLine_l."New Lot No." := Pallet."Lot No.";

            RecItemJournalLine_l.Insert(true);

            Items.Get(Pallet."Item No.");
            if Items."Item Tracking Code" <> '' then begin
                //Création de la Reservation Entry
                ReservationEntry_l.Reset;
                if ReservationEntry_l.Find('+') then
                    ReservEntry_l := ReservationEntry_l."Entry No." + 1
                else
                    ReservEntry_l := 1;

                if not LotInfo_l.Get(Pallet."Item No.", '', Pallet."Lot No.") then;
                LotInfo_l.CalcFields("Pick DLC");

                ReservationEntry_l.Init;
                ReservationEntry_l."Entry No." := ReservEntry_l;
                ReservationEntry_l.Positive := true;
                ReservationEntry_l.Insert;
                ReservationEntry_l."Item No." := RecItemJournalLine_l."Item No.";
                ReservationEntry_l."Location Code" := RecItemJournalLine_l."Location Code";
                ReservationEntry_l."Quantity (Base)" := -RecItemJournalLine_l."Quantity (Base)";
                ReservationEntry_l."Reservation Status" := ReservationEntry_l."Reservation Status"::Prospect;
                ReservationEntry_l."Creation Date" := WorkDate;
                ReservationEntry_l."Source Type" := 83;
                ReservationEntry_l."Source Subtype" := 4;
                ReservationEntry_l."Source ID" := RecItemJournalLine_l."Journal Template Name";
                ReservationEntry_l."Source Batch Name" := RecItemJournalLine_l."Journal Batch Name";
                ReservationEntry_l."Source Ref. No." := RecItemJournalLine_l."Line No.";
                ReservationEntry_l."Created By" := UserId;
                ReservationEntry_l."Qty. per Unit of Measure" := RecItemJournalLine_l."Qty. per Unit of Measure";
                ReservationEntry_l.Quantity := -RecItemJournalLine_l.Quantity;
                ReservationEntry_l."Qty. to Handle (Base)" := -RecItemJournalLine_l."Quantity (Base)";
                ReservationEntry_l."Qty. to Invoice (Base)" := -RecItemJournalLine_l."Quantity (Base)";
                ReservationEntry_l."Lot No." := Pallet."Lot No.";
                ReservationEntry_l."New Lot No." := Pallet."Lot No.";
                ReservationEntry_l."Expiration Date" := Pallet.DLC;
                ReservationEntry_l."Warranty Date" := Pallet.DLC;
                ReservationEntry_l.Modify;
            end;

            //Création du journal pallet
            PalletJournal_l.Reset;
            PalletJournal_l.SetRange("Journal Template Name", RecItemJournalLine_l."Journal Template Name");
            PalletJournal_l.SetRange("Journal Batch Name", RecItemJournalLine_l."Journal Batch Name");
            PalletJournal_l.SetRange("Journal Line No.", RecItemJournalLine_l."Line No.");
            if not PalletJournal_l.Find('+') then
                NextEntry_l := 10000
            else
                NextEntry_l := PalletJournal_l.ID + 10000;

            PalletJournal_l.Init;
            PalletJournal_l."Journal Template Name" := RecItemJournalLine_l."Journal Template Name";
            PalletJournal_l."Journal Batch Name" := RecItemJournalLine_l."Journal Batch Name";
            PalletJournal_l."Journal Line No." := RecItemJournalLine_l."Line No.";
            PalletJournal_l.ID := NextEntry_l;
            PalletJournal_l."SSCC No." := Pallet."SSCC No.";
            PalletJournal_l."Treated Quantity" := RecItemJournalLine_l."Quantity (Base)";
            PalletJournal_l.User := User;
            if Items."Item Tracking Code" <> '' then
                PalletJournal_l."Reservation Entry" := ReservEntry_l;

            //GEO 050218
            PalletJournal_l."Lot No." := Pallet."Lot No.";

            PalletJournal_l.Insert;


            //Validation de la feuille
            RecItemJournalLine_l.Reset;
            RecItemJournalLine_l.SetRange("Journal Template Name", UserSetup."Jnl Template Name");
            RecItemJournalLine_l.SetRange("Journal Batch Name", UserSetup."Jnl Batch Name");
            RecItemJournalLine_l.Find('-');
            CODEUNIT.Run(CODEUNIT::"Item Jnl.-Post Batch", RecItemJournalLine_l);

            RecItem_l.Get(Pallet."Item No.");
            if FlagBlocked then begin
                RecItem_l.Blocked := true;
                RecItem_l.Modify(false);
            end;

        end;
    end;

    [Scope('OnPrem')]
    procedure PutAwayPallet(SSCCNo: Code[20]; NewBin: Code[20])
    begin
        PutAwayPalletWithUser(SSCCNo, NewBin, '');
    end;

    [Scope('OnPrem')]
    procedure AddPickingPallet(PalletNo_p: Code[20]; OrderNo_p: Code[20]; LineNo_p: Integer; Qty_p: Decimal)
    var
        RecPallet_l: Record Pallet;
        RecPalletJournal_l: Record "Pallet Journal";
        RecReservationEntry_l: Record "Reservation Entry";
        OrderMgt: Boolean;
        TransMgt: Boolean;
        SalesHeader: Record "Sales Header";
        TransHeader: Record "Transfer Header";
        RecNewPallet_l: Record Pallet;
        RecNewPalletEntry: Record "Pallet Ledger Entry";
        CptPallet: Integer;
        FindEntry: Boolean;
    begin
        AddPickingPalletWithUserPrinter(PalletNo_p, OrderNo_p, LineNo_p, Qty_p, '', '');
    end;

    [Scope('OnPrem')]
    procedure AddPickingPalletWithUser(PalletNo_p: Code[20]; OrderNo_p: Code[20]; LineNo_p: Integer; Qty_p: Decimal; User: Code[20])
    var
        RecPallet_l: Record Pallet;
        RecPalletJournal_l: Record "Pallet Journal";
        RecReservationEntry_l: Record "Reservation Entry";
        OrderMgt: Boolean;
        TransMgt: Boolean;
        SalesHeader: Record "Sales Header";
        TransHeader: Record "Transfer Header";
        RecNewPallet_l: Record Pallet;
        RecNewPalletEntry: Record "Pallet Ledger Entry";
        CptPallet: Integer;
        FindEntry: Boolean;
    begin
        AddPickingPalletWithUserPrinter(PalletNo_p, OrderNo_p, LineNo_p, Qty_p, '', '');
    end;

    [Scope('OnPrem')]
    procedure AddPickingPalletWithUserPrinter(PalletNo_p: Code[20]; OrderNo_p: Code[20]; LineNo_p: Integer; Qty_p: Decimal; User: Code[20]; Printer: Code[20])
    var
        RecPallet_l: Record Pallet;
        RecPalletJournal_l: Record "Pallet Journal";
        RecReservationEntry_l: Record "Reservation Entry";
        OrderMgt: Boolean;
        TransMgt: Boolean;
        SalesHeader: Record "Sales Header";
        TransHeader: Record "Transfer Header";
        RecNewPallet_l: Record Pallet;
        RecNewPalletEntry: Record "Pallet Ledger Entry";
        CptPallet: Integer;
        FindEntry: Boolean;
        Cu50026: Codeunit "WS Scan";
    begin
        //Order or Picking ?
        OrderMgt := false;
        TransMgt := false;

        if SalesHeader.Get(SalesHeader."Document Type"::Order, OrderNo_p) then OrderMgt := true;
        if TransHeader.Get(OrderNo_p) then TransMgt := true;


        if RecPallet_l.Get(PalletNo_p) then begin
            RecPallet_l.CalcFields("Last Entry No.");
            RecPallet_l.CalcFields("Current Quantity");

            if RecPallet_l."Current Quantity" = 0 then begin
                Message('Cette Palette n''existe pas dans le stock');
                exit;
            end else begin
                //Vérifier si cette palette n'est pas déjà réservée
                RecPalletJournal_l.Reset;
                RecPalletJournal_l.SetRange("SSCC No.", PalletNo_p);
                if RecPalletJournal_l.Find('-') then begin
                    if RecPalletJournal_l."Reservation Entry" <> 0 then begin
                        Message('Cette palette a déjà été préparée');
                        exit;
                    end;
                end;

                //Vérifier si picking partiel
                if Qty_p < RecPallet_l."Current Quantity" then begin
                    //Création nouvelle palette "picking"
                    CptPallet := 0;
                    RecNewPallet_l.Init;
                    RecNewPallet_l.Copy(RecPallet_l);
                    RecNewPallet_l.NumOF := '';
                    RecNewPallet_l.LigneOF := 0;
                    repeat
                        CptPallet += 1;
                        //ABC VIE 20130906
                        //Bug traitement du '/'
                        //        RecNewPallet_l."SSCC No." := STRSUBSTNO('%1/%2',RecNewPallet_l."SSCC No.",CptPallet);
                        RecNewPallet_l."SSCC No." := CopyStr(RecNewPallet_l."SSCC No.", 1, 12);
                        RecNewPallet_l."SSCC No." := StrSubstNo('%1/%2', RecNewPallet_l."SSCC No.", CptPallet);

                    until RecNewPallet_l.Insert(false);

                    //Sortie Qté picking sur ancienne palette
                    OldPalletEntry.Find('+');
                    RecNewPalletEntry.Init;
                    RecNewPalletEntry."Entry No." := OldPalletEntry."Entry No." + 1;
                    RecNewPalletEntry."SSCC No." := RecPallet_l."SSCC No.";
                    RecNewPalletEntry."Posting Date" := WorkDate;
                    if OrderMgt then RecNewPalletEntry."Entry Type" := RecNewPalletEntry."Entry Type"::Sale;
                    if TransMgt then RecNewPalletEntry."Entry Type" := RecNewPalletEntry."Entry Type"::Transfer;
                    RecNewPalletEntry."Document No." := OrderNo_p;
                    RecNewPalletEntry."Location Code" := RecPallet_l."Location code";
                    RecNewPalletEntry."Item No." := RecPallet_l."Item No.";
                    RecNewPalletEntry."Lot No." := RecPallet_l."Lot No.";
                    RecNewPalletEntry.Quantity := -Qty_p;
                    RecNewPalletEntry."Bin Code" := RecPallet_l."Bin code";
                    RecNewPalletEntry.User := User;
                    RecNewPalletEntry.Insert(false);

                    //Entrée Qté picking sur nouvelle palette
                    RecNewPalletEntry.Init;
                    RecNewPalletEntry."Entry No." := OldPalletEntry."Entry No." + 2;
                    RecNewPalletEntry."SSCC No." := RecNewPallet_l."SSCC No.";
                    RecNewPalletEntry."Posting Date" := WorkDate;
                    if OrderMgt then RecNewPalletEntry."Entry Type" := RecNewPalletEntry."Entry Type"::Sale;
                    if TransMgt then RecNewPalletEntry."Entry Type" := RecNewPalletEntry."Entry Type"::Transfer;
                    RecNewPalletEntry."Document No." := OrderNo_p;
                    RecNewPalletEntry."Location Code" := RecPallet_l."Location code";
                    RecNewPalletEntry."Item No." := RecPallet_l."Item No.";
                    RecNewPalletEntry."Lot No." := RecPallet_l."Lot No.";
                    RecNewPalletEntry.Quantity := Qty_p;
                    RecNewPalletEntry."Bin Code" := RecPallet_l."Bin code";
                    RecNewPalletEntry.User := User;
                    RecNewPalletEntry.Insert(false);

                    if Printer <> '' then Cu50026.PrintLabelCongel(RecPallet_l."SSCC No.", Printer);
                    RecPallet_l.Get(RecNewPallet_l."SSCC No.");
                    if Printer <> '' then Cu50026.PrintLabelCongel(RecPallet_l."SSCC No.", Printer);
                    PalletNo_p := RecNewPallet_l."SSCC No.";



                end;

                //*** CREER LES LIGNES JOURNAL PALETTE ***
                Items.Get(RecPallet_l."Item No.");
                if Items."Item Tracking Code" <> '' then begin
                    RecReservationEntry_l.Reset;
                    RecReservationEntry_l.SetRange("Reservation Status", RecReservationEntry_l."Reservation Status"::Surplus);
                    if OrderMgt then RecReservationEntry_l.SetRange("Source Type", 37);
                    if OrderMgt then RecReservationEntry_l.SetRange("Source Subtype", 1);
                    if TransMgt then RecReservationEntry_l.SetRange("Source Type", 5741);
                    if TransMgt then RecReservationEntry_l.SetRange("Source Subtype", 0);
                    RecReservationEntry_l.SetRange("Source ID", OrderNo_p);
                    RecReservationEntry_l.SetRange("Source Ref. No.", LineNo_p);
                    RecReservationEntry_l.SetRange("Item No.", RecPallet_l."Item No.");
                    RecReservationEntry_l.SetRange("Lot No.", RecPallet_l."Lot No.");

                    if RecReservationEntry_l.Find('-') then begin
                        RecPalletJournal_l.Reset;
                        RecPalletJournal_l.SetRange("Journal Template Name", OrderNo_p);
                        RecPalletJournal_l.SetRange("Journal Line No.", RecReservationEntry_l."Source Ref. No.");
                        if not RecPalletJournal_l.Find('+') then
                            NextEntry := 10000
                        else
                            NextEntry := RecPalletJournal_l.ID + 10000;

                        RecPalletJournal_l.Init;
                        RecPalletJournal_l."Journal Template Name" := OrderNo_p;
                        RecPalletJournal_l."Journal Line No." := RecReservationEntry_l."Source Ref. No.";
                        RecPalletJournal_l.ID := NextEntry;
                        RecPalletJournal_l."SSCC No." := PalletNo_p;
                        RecPalletJournal_l."Treated Quantity" := Qty_p;
                        RecPalletJournal_l."Reservation Entry" := RecReservationEntry_l."Entry No.";
                        RecPalletJournal_l."Document No." := OrderNo_p;
                        RecPalletJournal_l."Document Line No." := RecReservationEntry_l."Source Ref. No.";
                        RecPalletJournal_l."Lot No." := RecPallet_l."Lot No.";
                        RecPalletJournal_l.User := User;
                        RecPalletJournal_l.Insert;

                        RecReservationEntry_l.CalcFields("Pallet Qty to Treat", "Qty To Treat");
                        if RecReservationEntry_l."Qty To Treat" > Abs(RecReservationEntry_l."Quantity (Base)") then begin
                            //        ERROR('Quantité Max=%2\Pour lot %1',RecReservationEntry_l."Lot No."
                            //                                                                        ,ABS(RecReservationEntry_l."Quantity (Base)"));
                        end else begin
                            RecReservationEntry_l."Pallet Qty" := RecReservationEntry_l."Pallet Qty to Treat";
                            RecReservationEntry_l.Modify;
                        end;
                    end else begin
                        Error('La palette ne peut être réservée sur le document %1', OrderNo_p);
                        exit;
                    end;
                end
                else begin  // No tracking
                    RecPalletJournal_l.Reset;
                    RecPalletJournal_l.SetRange("Journal Template Name", OrderNo_p);
                    RecPalletJournal_l.SetRange("Journal Line No.", LineNo_p);
                    if not RecPalletJournal_l.Find('+') then
                        NextEntry := 10000
                    else
                        NextEntry := RecPalletJournal_l.ID + 10000;

                    RecPalletJournal_l.Init;
                    RecPalletJournal_l."Journal Template Name" := OrderNo_p;
                    RecPalletJournal_l."Journal Line No." := LineNo_p;
                    RecPalletJournal_l.ID := NextEntry;
                    RecPalletJournal_l."SSCC No." := PalletNo_p;
                    RecPalletJournal_l."Treated Quantity" := Qty_p;
                    RecPalletJournal_l."Reservation Entry" := 0;
                    RecPalletJournal_l."Document No." := OrderNo_p;
                    RecPalletJournal_l."Document Line No." := LineNo_p;
                    RecPalletJournal_l."Lot No." := RecPallet_l."Lot No.";
                    RecPalletJournal_l.User := User;
                    RecPalletJournal_l.Insert;

                end;
            end;
        end else begin
            Error('Cette Palette n''existe pas dans le stock');
            exit;
        end;
    end;

    [Scope('OnPrem')]
    procedure ValidateSalesShip(var SalesOrder: Record "Sales Header")
    var
        RecPallet_l: Record Pallet;
        RecPalletJournal_l: Record "Pallet Journal";
        RecReservationEntry_l: Record "Reservation Entry";
        SalesLine: Record "Sales Line";
        Location: Record Location;
        DefinedQty: Decimal;
        ReservedQty: Decimal;
        RecReservationEntry_l2: Record "Reservation Entry";
    begin
        ValidateSalesShipWithUser(SalesOrder, '');
    end;

    [Scope('OnPrem')]
    procedure ValidateSalesShipWithUser(var SalesOrder: Record "Sales Header"; User: Code[20])
    var
        RecPallet_l: Record Pallet;
        RecPalletJournal_l: Record "Pallet Journal";
        RecReservationEntry_l: Record "Reservation Entry";
        SalesLine: Record "Sales Line";
        Location: Record Location;
        DefinedQty: Decimal;
        ReservedQty: Decimal;
        RecReservationEntry_l2: Record "Reservation Entry";
    begin
        //Controle des quantités palettes cohérentes avec les écritures de réservation     //ABC VIE 20131017
        SalesLine.Reset;
        SalesLine.SetRange("Document Type", SalesOrder."Document Type");
        SalesLine.SetRange("Document No.", SalesOrder."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        if SalesLine.Find('-') then begin
            Location.Get(SalesLine."Location Code");
            if Location."Qty check" then
                repeat
                    if SalesLine.Type = SalesLine.Type::Item then begin
                        RecReservationEntry_l.Reset;
                        RecReservationEntry_l.SetRange("Reservation Status", RecReservationEntry_l."Reservation Status"::Surplus);
                        RecReservationEntry_l.SetRange("Source Type", 37);
                        RecReservationEntry_l.SetRange("Source Subtype", 1);
                        RecReservationEntry_l.SetRange("Source ID", SalesOrder."No.");
                        if RecReservationEntry_l.Find('-') then begin
                            repeat
                                DefinedQty := 0;

                                //BNC 30/01/14
                                ReservedQty := 0;
                                //BNC 30/01/14 //

                                RecPalletJournal_l.Reset;
                                RecPalletJournal_l.SetRange("Document No.", SalesLine."Document No.");

                                //BNC 30/01/14
                                //RecPalletJournal_l.SETRANGE("Document Line No.",SalesLine."Line No.");
                                //BNC 30/01/14 //

                                RecPalletJournal_l.SetRange("Lot No.", RecReservationEntry_l."Lot No.");
                                if RecPalletJournal_l.Find('-') then begin
                                    repeat
                                        DefinedQty += RecPalletJournal_l."Treated Quantity";
                                    until RecPalletJournal_l.Next = 0;

                                    //BNC 30/01/14
                                    Clear(RecReservationEntry_l2);
                                    RecReservationEntry_l2.Copy(RecReservationEntry_l);
                                    RecReservationEntry_l2.SetRange("Lot No.", RecReservationEntry_l."Lot No.");
                                    if RecReservationEntry_l2.Find('-') then begin
                                        repeat
                                            ReservedQty += Abs(RecReservationEntry_l2."Quantity (Base)")
                                        until RecReservationEntry_l2.Next = 0;
                                    end;

                                    //IF DefinedQty <> ABS(RecReservationEntry_l."Quantity (Base)") THEN
                                    if DefinedQty <> ReservedQty then
                                        /*ERROR('Erreur Qté palette. \Article %1 \Lot %2 \Qté à livrer %3 \Qté palette %4',
                                         SalesLine."No.",RecReservationEntry_l."Lot No.", ABS(RecReservationEntry_l."Quantity (Base)"),
                                         DefinedQty);  */

                     Error('Erreur Qté palette. \Article %1 \Lot %2 \Qté à livrer %3 \Qté palette %4',
                     SalesLine."No.", RecReservationEntry_l."Lot No.", ReservedQty,
                     DefinedQty);

                                end;
                            //BNC 30/01/14

                            until RecReservationEntry_l.Next = 0;
                        end;
                    end;
                until SalesLine.Next = 0;
        end;

        //Etape 1 - transférer toutes les pallettes à quai DEPART
        RecReservationEntry_l.Reset;
        RecReservationEntry_l.SetRange("Reservation Status", RecReservationEntry_l."Reservation Status"::Surplus);
        RecReservationEntry_l.SetRange("Source Type", 37);
        RecReservationEntry_l.SetRange("Source Subtype", 1);
        RecReservationEntry_l.SetRange("Source ID", SalesOrder."No.");
        if RecReservationEntry_l.Find('-') then begin
            repeat
                Location.Get(RecReservationEntry_l."Location Code");
                RecPalletJournal_l.Reset;
                RecPalletJournal_l.SetRange("Journal Template Name", SalesOrder."No.");
                RecPalletJournal_l.SetRange("Reservation Entry", RecReservationEntry_l."Entry No.");
                if RecPalletJournal_l.Find('-') then begin
                    repeat
                        PutAwayPalletWithUser(RecPalletJournal_l."SSCC No.", Location."Default Ship. bin", User);
                    until RecPalletJournal_l.Next = 0;
                end;
            until RecReservationEntry_l.Next = 0;
        end;

        //Etape 2 - mettre à jour la commande avec l'emplacement DEPART
        SalesLine.Reset;
        SalesLine.SetRange("Document Type", SalesOrder."Document Type");
        SalesLine.SetRange("Document No.", SalesOrder."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        if SalesLine.Find('-') then begin
            repeat
                Location.Get(SalesLine."Location Code");
                SalesLine."Bin Code" := Location."Default Ship. bin";
                SalesLine.Modify;
            until SalesLine.Next = 0;
        end;

        //Etape 3 - Valider l'expédition

    end;

    [Scope('OnPrem')]
    procedure ValidateTransShip(var TransOrder: Record "Transfer Header")
    var
        RecPallet_l: Record Pallet;
        RecPalletJournal_l: Record "Pallet Journal";
        RecReservationEntry_l: Record "Reservation Entry";
        TransLine: Record "Transfer Line";
        Location: Record Location;
        DefinedQty: Decimal;
        ReservedQty: Decimal;
        RecReservationEntry_l2: Record "Reservation Entry";
    begin
        ValidateTransShipWithUser(TransOrder, '');
    end;

    [Scope('OnPrem')]
    procedure ValidateTransShipWithUser(var TransOrder: Record "Transfer Header"; User: Code[20])
    var
        RecPallet_l: Record Pallet;
        RecPalletJournal_l: Record "Pallet Journal";
        RecReservationEntry_l: Record "Reservation Entry";
        TransLine: Record "Transfer Line";
        Location: Record Location;
        DefinedQty: Decimal;
        ReservedQty: Decimal;
        RecReservationEntry_l2: Record "Reservation Entry";
    begin
        //Controle des quantités palettes cohérentes avec les écritures de réservation     //ABC VIE 20131017
        TransLine.Reset;
        TransLine.SetRange("Document No.", TransOrder."No.");
        TransLine.SetFilter("Item No.", '<> %1', '');
        if TransLine.Find('-') then begin
            Location.Get(TransLine."Transfer-from Code");
            if Location."Qty check" then
                repeat
                    if Items."Item Tracking Code" = '' then begin
                        RecPalletJournal_l.Reset;
                        RecPalletJournal_l.SetRange("Journal Template Name", TransOrder."No.");
                        RecPalletJournal_l.SetRange("Journal Line No.", TransLine."Line No.");
                        DefinedQty := 0;
                        ReservedQty := TransLine.Quantity;
                        if RecPalletJournal_l.Find('-') then
                            repeat
                                DefinedQty += RecPalletJournal_l."Treated Quantity"
                            until RecPalletJournal_l.Next = 0;
                        if DefinedQty <> ReservedQty then
                            Error('Erreur Qté palette. \Article %1 \Qté à livrer %3 \Qté palette %4',
                                 TransLine."Item No.", ReservedQty,
                                   DefinedQty);

                    end
                    else begin
                        RecReservationEntry_l.Reset;
                        RecReservationEntry_l.SetRange("Reservation Status", RecReservationEntry_l."Reservation Status"::Surplus);
                        RecReservationEntry_l.SetRange("Source Type", 5741);
                        RecReservationEntry_l.SetRange("Source Subtype", 0);
                        RecReservationEntry_l.SetRange("Source ID", TransOrder."No.");
                        if RecReservationEntry_l.Find('-') then begin
                            repeat
                                DefinedQty := 0;
                                ReservedQty := 0;
                                RecPalletJournal_l.Reset;
                                RecPalletJournal_l.SetRange("Document No.", TransLine."Document No.");
                                //BNC 30/01/14
                                //RecPalletJournal_l.SETRANGE("Document Line No.",TransLine."Line No.");
                                //BNC 30/01/14 //
                                RecPalletJournal_l.SetRange("Lot No.", RecReservationEntry_l."Lot No.");
                                if RecPalletJournal_l.Find('-') then begin
                                    repeat
                                        DefinedQty += RecPalletJournal_l."Treated Quantity";
                                    until RecPalletJournal_l.Next = 0;
                                    //BNC 30/01/14
                                    Clear(RecReservationEntry_l2);
                                    RecReservationEntry_l2.Copy(RecReservationEntry_l);
                                    RecReservationEntry_l2.SetRange("Lot No.", RecReservationEntry_l."Lot No.");
                                    if RecReservationEntry_l2.Find('-') then begin
                                        repeat
                                            ReservedQty += Abs(RecReservationEntry_l2."Quantity (Base)")
                                        until RecReservationEntry_l2.Next = 0;
                                    end;
                                    //IF DefinedQty <> ABS(RecReservationEntry_l."Quantity (Base)") THEN
                                    if DefinedQty <> ReservedQty then
                                        Error('Erreur Qté palette. \Article %1 \Lot %2 \Qté à livrer %3 \Qté palette %4',
                                              TransLine."Item No.", RecReservationEntry_l."Lot No.", ReservedQty,
                                              DefinedQty);
                                end;
                            until RecReservationEntry_l.Next = 0;
                        end;
                    end;
                until TransLine.Next = 0;
        end;

        //Etape 1 - transférer toutes les pallettes à quai DEPART
        RecReservationEntry_l.Reset;
        RecReservationEntry_l.SetRange("Reservation Status", RecReservationEntry_l."Reservation Status"::Surplus);
        RecReservationEntry_l.SetRange("Source Type", 5741);
        RecReservationEntry_l.SetRange("Source Subtype", 0);
        RecReservationEntry_l.SetRange("Source ID", TransOrder."No.");
        if RecReservationEntry_l.Find('-') then begin
            repeat
                Location.Get(RecReservationEntry_l."Location Code");
                RecPalletJournal_l.Reset;
                RecPalletJournal_l.SetRange("Journal Template Name", TransOrder."No.");
                RecPalletJournal_l.SetRange("Reservation Entry", RecReservationEntry_l."Entry No.");
                if RecPalletJournal_l.Find('-') then begin
                    repeat
                        PutAwayPalletWithUser(RecPalletJournal_l."SSCC No.", Location."Default Ship. bin", User);
                    until RecPalletJournal_l.Next = 0;
                end;
            until RecReservationEntry_l.Next = 0;
        end;

        //Transférer les palettes sans tracking
        TransLine.Reset;
        TransLine.SetRange("Document No.", TransOrder."No.");
        TransLine.SetFilter("Item No.", '<>%1', '');
        if TransLine.Find('-') then begin
            repeat
                Location.Get(TransLine."Transfer-from Code");
                Items.Get(TransLine."Item No.");
                if Items."Item Tracking Code" = '' then begin
                    RecPalletJournal_l.Reset;
                    RecPalletJournal_l.SetRange("Journal Template Name", TransOrder."No.");
                    RecPalletJournal_l.SetRange("Journal Line No.", TransLine."Line No.");
                    if RecPalletJournal_l.Find('-') then
                        repeat
                            PutAwayPallet(RecPalletJournal_l."SSCC No.", Location."Default Ship. bin");
                        until RecPalletJournal_l.Next = 0;
                end;

            until TransLine.Next = 0;
        end;


        //Etape 2 - mettre à jour le transfert avec l'emplacement DEPART
        TransLine.Reset;
        TransLine.SetRange("Document No.", TransOrder."No.");
        TransLine.SetFilter("Item No.", '<> %1', '');
        if TransLine.Find('-') then begin
            repeat

                Location.Get(TransLine."Transfer-from Code");
                TransLine."Transfer-from Bin Code" := Location."Default Ship. bin";
                TransLine.Modify;
            until TransLine.Next = 0;
        end;

        //Etape 3 - Valider l'expédition
    end;

    local procedure SplitPalet(SSCC: Code[20]; Qty: Decimal; Printer: Text; User: Code[50]; DocNo: Code[20]): Code[20]
    var
        RecPallet_l: Record Pallet;
        RecNewPallet_l: Record Pallet;
        RecNewPalletEntry: Record "Pallet Ledger Entry";
        OldPalletEntry: Record "Pallet Ledger Entry";
        Cu50026: Codeunit "WS Scan";
        CptPallet: Integer;
    begin
        RecPallet_l.Get(SSCC);
        RecPallet_l.CalcFields("Current Quantity");

        if Qty < RecPallet_l."Current Quantity" then begin
            //Création nouvelle palette "picking"
            CptPallet := 0;
            RecNewPallet_l.Init;
            RecNewPallet_l.Copy(RecPallet_l);
            RecNewPallet_l.NumOF := '';
            RecNewPallet_l.LigneOF := 0;
            repeat
                CptPallet += 1;
                RecNewPallet_l."SSCC No." := CopyStr(RecNewPallet_l."SSCC No.", 1, 12);
                RecNewPallet_l."SSCC No." := StrSubstNo('%1/%2', RecNewPallet_l."SSCC No.", CptPallet);
            until RecNewPallet_l.Insert(false);

            //Sortie Qté picking sur ancienne palette
            OldPalletEntry.Find('+');
            RecNewPalletEntry.Init;
            RecNewPalletEntry."Entry No." := OldPalletEntry."Entry No." + 1;
            RecNewPalletEntry."SSCC No." := RecPallet_l."SSCC No.";
            RecNewPalletEntry."Posting Date" := WorkDate;
            RecNewPalletEntry."Document No." := DocNo;
            RecNewPalletEntry."Location Code" := RecPallet_l."Location code";
            RecNewPalletEntry."Item No." := RecPallet_l."Item No.";
            RecNewPalletEntry."Lot No." := RecPallet_l."Lot No.";
            RecNewPalletEntry.Quantity := -Qty;
            RecNewPalletEntry."Bin Code" := RecPallet_l."Bin code";
            RecNewPalletEntry.User := User;
            RecNewPalletEntry.Insert(false);

            //Entrée Qté picking sur nouvelle palette
            RecNewPalletEntry.Init;
            RecNewPalletEntry."Entry No." := OldPalletEntry."Entry No." + 2;
            RecNewPalletEntry."SSCC No." := RecNewPallet_l."SSCC No.";
            RecNewPalletEntry."Posting Date" := WorkDate;
            RecNewPalletEntry."Document No." := DocNo;
            RecNewPalletEntry."Location Code" := RecPallet_l."Location code";
            RecNewPalletEntry."Item No." := RecPallet_l."Item No.";
            RecNewPalletEntry."Lot No." := RecPallet_l."Lot No.";
            RecNewPalletEntry.Quantity := Qty;
            RecNewPalletEntry."Bin Code" := RecPallet_l."Bin code";
            RecNewPalletEntry.User := User;
            RecNewPalletEntry.Insert(false);

            if Printer <> '' then Cu50026.PrintLabelCongel(RecPallet_l."SSCC No.", Printer);
            RecPallet_l.Get(RecNewPallet_l."SSCC No.");
            if Printer <> '' then Cu50026.PrintLabelCongel(RecPallet_l."SSCC No.", Printer);
            exit(RecNewPallet_l."SSCC No.");
        end
        else begin
            exit(SSCC);
        end;

    end;

    [Scope('OnPrem')]
    procedure PutAwayPartialPallet(SSCC: Code[20]; Qty: Decimal; Printer: Text; User: Code[50]; DocNo: Code[20]; NewBin: Code[20]): Code[20]
    var
        RecPallet_l: Record Pallet;
        RecNewPallet_l: Record Pallet;
        RecNewPalletEntry: Record "Pallet Ledger Entry";
        OldPalletEntry: Record "Pallet Ledger Entry";
        Cu50026: Codeunit "WS Scan";
        CptPallet: Integer;
    begin
        SSCC := SplitPalet(SSCC, Qty, Printer, User, DocNo);
        PutAwayPalletWithUser(SSCC, NewBin, User);
    end;
}

