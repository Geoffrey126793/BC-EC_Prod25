codeunit 50050 "Modif EC Stock"
{

    trigger OnRun()
    begin

        TftFromLocationToLocation();
        Message('ok');
    end;

    var
        scanMgmt: Codeunit "Scan Management";
        recPalletIn: Record Pallet;
        Params: Record "Code";


    procedure TftFromLocationToLocation()
    var
        TftH: Record "Transfer Header";
        TftL: Record "Transfer Line";
        recReservOTS: Record "Reservation Entry";
        NextSeq: Integer;
        T32: Record "Item Ledger Entry";
        i: Integer;
    begin

        recReservOTS.Reset;
        if recReservOTS.FindLast then NextSeq := recReservOTS."Entry No." + 1;

        i := 10000;
        TftH.Reset;
        TftH.Init;
        TftH.Insert(true);
        TftH.Validate("Transfer-from Code", 'EC TOURNAI');
        TftH.Validate("Transfer-to Code", 'EC STOCK');
        TftH.Validate("In-Transit Code", '9-TFT');

        TftH.Modify(true);

        T32.Reset;
        T32.SetFilter("Item No.", '8-BRQ-*');
        T32.SetFilter("Remaining Quantity", '>0');
        T32.SetRange("Location Code", 'EC TOURNAI');
        if T32.FindSet then
            repeat

                TftL.Reset;
                TftL.Init;
                TftL."Document No." := TftH."No.";
                TftL."Line No." := i;
                TftL.Validate("Item No.", T32."Item No.");
                TftL.Validate(Quantity, T32."Remaining Quantity");
                TftL.Insert(true);


                if (T32."Lot No." <> '') then begin
                    recReservOTS.Reset;
                    recReservOTS.Init;
                    recReservOTS."Entry No." := NextSeq;
                    recReservOTS.Positive := false;
                    recReservOTS."Item No." := T32."Item No.";
                    recReservOTS."Location Code" := TftH."Transfer-from Code";
                    recReservOTS."Quantity (Base)" := -T32."Remaining Quantity";
                    recReservOTS."Qty. to Handle (Base)" := -T32."Remaining Quantity";
                    recReservOTS."Qty. to Invoice (Base)" := -T32."Remaining Quantity";
                    recReservOTS."Source Type" := 5741;
                    recReservOTS."Source Subtype" := 0;
                    recReservOTS."Source ID" := TftH."No.";
                    recReservOTS."Source Ref. No." := TftL."Line No.";
                    recReservOTS."Shipment Date" := Today;
                    recReservOTS."Warranty Date" := T32."Warranty Date";
                    recReservOTS."Lot No." := T32."Lot No.";
                    recReservOTS."Item Tracking" := recReservOTS."Item Tracking"::"Lot No.";
                    recReservOTS."Reservation Status" := recReservOTS."Reservation Status"::Surplus;
                    recReservOTS."Creation Date" := WorkDate;
                    recReservOTS."Created By" := UserId;
                    recReservOTS.Insert;
                    NextSeq += 1;

                    recReservOTS.Reset;
                    recReservOTS.Init;
                    recReservOTS."Entry No." := NextSeq;
                    recReservOTS.Positive := true;
                    recReservOTS."Item No." := T32."Item No.";
                    recReservOTS."Location Code" := TftH."Transfer-to Code";
                    recReservOTS."Quantity (Base)" := T32."Remaining Quantity";
                    recReservOTS."Qty. to Handle (Base)" := T32."Remaining Quantity";
                    recReservOTS."Qty. to Invoice (Base)" := T32."Remaining Quantity";
                    recReservOTS."Source Type" := 5741;
                    recReservOTS."Source Subtype" := 1;
                    recReservOTS."Source ID" := TftH."No.";
                    recReservOTS."Source Ref. No." := i;
                    //recReservOTS."Source Prod. Order Line" := i;
                    recReservOTS."Expected Receipt Date" := Today;
                    recReservOTS."Warranty Date" := T32."Warranty Date";
                    recReservOTS."Lot No." := T32."Lot No.";
                    recReservOTS."Item Tracking" := recReservOTS."Item Tracking"::"Lot No.";
                    recReservOTS."Reservation Status" := recReservOTS."Reservation Status"::Surplus;
                    recReservOTS."Creation Date" := WorkDate;
                    recReservOTS."Created By" := UserId;
                    recReservOTS.Insert;
                end;
                NextSeq += 1;

                i += 10000;
            until T32.Next = 0;
    end;
}

