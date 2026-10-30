codeunit 50002 "Dedouanement Mgt"
{
    TableNo = "Transfer Header";

    trigger OnRun()
    begin
        TransHeader.Copy(Rec);
        Code;
        Rec := TransHeader;
    end;

    var
        Text000: Label '&Ship,&Receive';
        TransHeader: Record "Transfer Header";
        TmpReservEntry: Record "Reservation Entry" temporary;
        TmpPalletJnl: Record "Pallet Journal" temporary;
        ReservEntry: Record "Reservation Entry";
        PalletJnl: Record "Pallet Journal";
        Location: Record Location;
        TmpPallet: Record Pallet temporary;
        Pallet: Record Pallet;

    local procedure "Code"()
    var
        TransLine: Record "Transfer Line";
        TransferPostShipment: Codeunit "TransferOrder-Post Shipment";
        TransferPostReceipt: Codeunit "TransferOrder-Post Receipt";
        ScanMgt: Codeunit "Scan Management";
        CptPallet: Integer;
        RecNewPallet_l: Record Pallet;
        OldPalletEntry: Record "Pallet Ledger Entry";
        RecNewPalletEntry: Record "Pallet Ledger Entry";
    begin
        //Vérifier si picking partiel
        ReservEntry.Reset;
        ReservEntry.SetRange("Source Type", 5741);
        ReservEntry.SetRange("Source ID", TransHeader."No.");
        if ReservEntry.Find('-') then begin
            repeat
                PalletJnl.Reset;
                PalletJnl.SetCurrentKey("Reservation Entry");
                PalletJnl.SetRange("Reservation Entry", ReservEntry."Entry No.");
                if PalletJnl.Find('-') then begin
                    repeat
                        if Pallet.Get(PalletJnl."SSCC No.") then begin
                            Pallet.CalcFields("Current Quantity");
                            if PalletJnl."Treated Quantity" < Pallet."Current Quantity" then begin
                                //Création nouvelle palette "picking"
                                CptPallet := 0;
                                RecNewPallet_l.Init;
                                RecNewPallet_l.Copy(Pallet);
                                repeat
                                    CptPallet += 1;
                                    RecNewPallet_l."SSCC No." := CopyStr(RecNewPallet_l."SSCC No.", 1, 12);
                                    RecNewPallet_l."SSCC No." := StrSubstNo('%1/%2', RecNewPallet_l."SSCC No.", CptPallet);
                                until RecNewPallet_l.Insert(false);

                                //Sortie Qté dédouanement sur ancienne palette
                                OldPalletEntry.Find('+');
                                RecNewPalletEntry.Init;
                                RecNewPalletEntry."Entry No." := OldPalletEntry."Entry No." + 1;
                                RecNewPalletEntry."SSCC No." := Pallet."SSCC No.";
                                RecNewPalletEntry."Posting Date" := WorkDate;
                                RecNewPalletEntry."Entry Type" := RecNewPalletEntry."Entry Type"::Transfer;
                                RecNewPalletEntry."Document No." := TransHeader."No.";
                                RecNewPalletEntry."Location Code" := Pallet."Location code";
                                RecNewPalletEntry."Item No." := Pallet."Item No.";
                                RecNewPalletEntry."Lot No." := Pallet."Lot No.";
                                RecNewPalletEntry.Quantity := -PalletJnl."Treated Quantity";
                                RecNewPalletEntry."Bin Code" := Pallet."Bin code";
                                RecNewPalletEntry.Insert(false);

                                //Entrée Qté dédouanement sur nouvelle palette
                                RecNewPalletEntry.Init;
                                RecNewPalletEntry."Entry No." := OldPalletEntry."Entry No." + 2;
                                RecNewPalletEntry."SSCC No." := RecNewPallet_l."SSCC No.";
                                RecNewPalletEntry."Posting Date" := WorkDate;
                                RecNewPalletEntry."Entry Type" := RecNewPalletEntry."Entry Type"::Transfer;
                                RecNewPalletEntry."Document No." := TransHeader."No.";
                                RecNewPalletEntry."Location Code" := Pallet."Location code";
                                RecNewPalletEntry."Item No." := Pallet."Item No.";
                                RecNewPalletEntry."Lot No." := Pallet."Lot No.";
                                RecNewPalletEntry.Quantity := PalletJnl."Treated Quantity";
                                RecNewPalletEntry."Bin Code" := Pallet."Bin code";
                                RecNewPalletEntry.Insert(false);

                                PalletJnl."SSCC No." := RecNewPallet_l."SSCC No.";
                                PalletJnl.Modify;
                            end;
                        end;
                    until PalletJnl.Next = 0;
                end;
            until ReservEntry.Next = 0;
        end;

        //Copier les écritures réservation et le journal Palette
        ReservEntry.Reset;
        ReservEntry.SetRange("Source Type", 5741);
        ReservEntry.SetRange("Source ID", TransHeader."No.");
        if ReservEntry.Find('-') then begin
            repeat
                TmpReservEntry.Init;
                TmpReservEntry.Copy(ReservEntry);
                TmpReservEntry.Insert;
                PalletJnl.Reset;
                PalletJnl.SetCurrentKey("Reservation Entry");
                PalletJnl.SetRange("Reservation Entry", ReservEntry."Entry No.");
                if PalletJnl.Find('-') then begin
                    repeat
                        TmpPalletJnl.Init;
                        TmpPalletJnl.Copy(PalletJnl);
                        TmpPalletJnl.Insert;
                        if Pallet.Get(PalletJnl."SSCC No.") then begin
                            TmpPallet.Init;
                            TmpPallet.Copy(Pallet);
                            TmpPallet.Insert;
                        end;
                    until PalletJnl.Next = 0;
                end;
            until ReservEntry.Next = 0;
        end;



        //Transfert de sortie
        ScanMgt.ValidateTransShip(TransHeader);
        TransferPostShipment.Run(TransHeader);

        //Recopier le journal palette sur l'autre écriture de réservation
        TmpReservEntry.Reset;
        TmpReservEntry.SetRange(Positive, false);
        if TmpReservEntry.Find('-') then begin
            repeat
                TmpPalletJnl.Reset;
                TmpPalletJnl.SetRange("Reservation Entry", TmpReservEntry."Entry No.");
                if TmpPalletJnl.Find('-') then begin
                    repeat
                        PalletJnl.Init;
                        PalletJnl.Copy(TmpPalletJnl);
                        PalletJnl."Reservation Entry" := TmpPalletJnl."Reservation Entry" + 1;
                        PalletJnl."Journal Template Name" := TmpReservEntry."Source ID";
                        PalletJnl."Journal Batch Name" := TmpReservEntry."Source Batch Name";
                        PalletJnl."Journal Line No." := TmpReservEntry."Source Ref. No." + 10000;
                        PalletJnl.Insert;
                    until TmpPalletJnl.Next = 0;
                end;
            until TmpReservEntry.Next = 0;
        end;

        //Modifier l'emplacement de réception par défaut
        TransLine.Reset;
        TransLine.SetRange("Document No.", TransHeader."No.");
        TransLine.SetFilter("Item No.", '<> %1', '');
        if TransLine.Find('-') then begin
            repeat
                Location.Get(TransLine."Transfer-to Code");
                TransLine."Transfer-To Bin Code" := Location."Default Recept. bin";
                TransLine.Modify;
            until TransLine.Next = 0;
        end;

        //Transfert de ré-entrée
        TransferPostReceipt.Run(TransHeader);

        //Déplacer dans les bons emplacements
        TmpPallet.Reset;
        if TmpPallet.Find('-') then begin
            repeat
                ScanMgt.PutAwayPalletWithUser(TmpPallet."SSCC No.", TmpPallet."Bin code", '');
            until TmpPallet.Next = 0;
        end;
    end;
}

