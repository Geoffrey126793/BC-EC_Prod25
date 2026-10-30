pageextension 70200 pageextension70200 extends "Item Tracking Lines"
{
    layout
    {
        modify("Lot No.")
        {
            StyleExpr = StyleBloque;
        }
        modify("New Expiration Date")
        {
            Visible = false;
        }
        modify("Warranty Date")
        {
            Visible = true;
        }
        modify("Appl.-to Item Entry")
        {
            Visible = true;
        }
        modify("Appl.-from Item Entry")
        {
            Visible = true;
        }

    }
    var
        RecItem_l: Record Item;
        RecReservationEntry_l: Record "Reservation Entry";
        RecItemTrackingCode_l: Record "Item Tracking Code";
        FrmReservationSSCC_l: Page "Lot - SSCC : Sélection SSCC";
        RecLocation_l: Record Location;
        //FrmReservationSSCCNeg_l: Page "Lot - SSCC : SSCC aj. négatif";
        TransHeader: Record "Transfer Header";


    var
        xTempItemTrackingLine2: Record "Tracking Specification";

    var
        InfoLot: Record "Lot No. Information";
        LotBlocked: Boolean;
        StyleBloque: Text;

    trigger OnAfterGetRecord()
    begin

        LotBlocked := false;
        StyleBloque := 'standard';
        if InfoLot.Get("Item No.", '', "Lot No.") then
            if InfoLot.Blocked then begin
                LotBlocked := true;
                StyleBloque := 'unfavorable';
                if StrPos(InfoLot."Commentaire blocage", 'résultats d''analyse') > 0 then
                    StyleBloque := 'strongaccent';
            end;
    end;

    trigger OnClosePage()
    var
        CUProd: Codeunit "Integration Tft and Prod";
    begin

        CUProd.MergeTraca("Source ID", "Source Ref. No.");
        COMMIT;

        if (RecItem_l.Get("Item No.") and RecLocation_l.Get("Location Code")) then begin
            if (RecItemTrackingCode_l.Get(RecItem_l."Item Tracking Code")) and (RecLocation_l."Pallet Management") then begin
                if RecItemTrackingCode_l."Pallet Management" then begin
                    if "Source Type" = 39 then begin
                        RecReservationEntry_l.Reset;
                        RecReservationEntry_l.SetRange("Item No.", "Item No.");
                        RecReservationEntry_l.SetRange("Source Type", "Source Type");
                        RecReservationEntry_l.SetRange("Source Subtype", "Source Subtype");
                        RecReservationEntry_l.SetRange("Source ID", "Source ID");
                        RecReservationEntry_l.SetRange("Source Batch Name", "Source Batch Name");
                        RecReservationEntry_l.SetRange("Source Prod. Order Line", "Source Prod. Order Line");
                        RecReservationEntry_l.SetRange("Source Ref. No.", "Source Ref. No.");
                        if RecReservationEntry_l.Count <> 0 then begin
                            FrmReservationSSCC_l.SetTableView(RecReservationEntry_l);
                            FrmReservationSSCC_l.RunModal;
                        end;
                    end;


                    if ("Source Type" = 37) and ("Source Subtype" = 5) then begin   //Retour vente
                        RecReservationEntry_l.Reset;
                        RecReservationEntry_l.SetRange("Item No.", "Item No.");
                        RecReservationEntry_l.SetRange("Source Type", "Source Type");
                        RecReservationEntry_l.SetRange("Source Subtype", "Source Subtype");
                        RecReservationEntry_l.SetRange("Source ID", "Source ID");
                        RecReservationEntry_l.SetRange("Source Batch Name", "Source Batch Name");
                        RecReservationEntry_l.SetRange("Source Prod. Order Line", "Source Prod. Order Line");
                        RecReservationEntry_l.SetRange("Source Ref. No.", "Source Ref. No.");
                        if RecReservationEntry_l.Count <> 0 then begin
                            FrmReservationSSCC_l.SetTableView(RecReservationEntry_l);
                            FrmReservationSSCC_l.RunModal;
                        end;
                    end;
                    if ("Source Type" = 5741) and ("Source Subtype" = 1) then begin
                        RecReservationEntry_l.Reset;
                        RecReservationEntry_l.SetRange("Item No.", "Item No.");
                        RecReservationEntry_l.SetRange("Source Type", "Source Type");
                        RecReservationEntry_l.SetRange("Source Subtype", "Source Subtype");
                        RecReservationEntry_l.SetRange("Source ID", "Source ID");
                        RecReservationEntry_l.SetRange("Source Batch Name", "Source Batch Name");
                        RecReservationEntry_l.SetRange("Source Prod. Order Line", "Source Prod. Order Line");
                        RecReservationEntry_l.SetRange("Source Ref. No.", "Source Ref. No.");
                        if RecReservationEntry_l.Count <> 0 then begin
                            FrmReservationSSCC_l.SetTableView(RecReservationEntry_l);
                            FrmReservationSSCC_l.RunModal;
                        end;
                    end;
                    if ("Source Type" = 83) and ("Source Subtype" = 2) then begin    // Ajustement positif sur feuille article
                        RecReservationEntry_l.Reset;
                        RecReservationEntry_l.SetRange("Item No.", "Item No.");
                        RecReservationEntry_l.SetRange("Source Type", "Source Type");
                        RecReservationEntry_l.SetRange("Source Subtype", "Source Subtype");
                        RecReservationEntry_l.SetRange("Source ID", "Source ID");
                        RecReservationEntry_l.SetRange("Source Batch Name", "Source Batch Name");
                        RecReservationEntry_l.SetRange("Source Prod. Order Line", "Source Prod. Order Line");
                        RecReservationEntry_l.SetRange("Source Ref. No.", "Source Ref. No.");
                        if RecReservationEntry_l.Count <> 0 then begin
                            FrmReservationSSCC_l.SetTableView(RecReservationEntry_l);
                            FrmReservationSSCC_l.RunModal;
                        end;
                    end;
                    /*if ("Source Type" = 83) and ("Source Subtype" = 3) then begin    // Ajustement négatif sur feuille article
                        RecReservationEntry_l.Reset;
                        RecReservationEntry_l.SetRange("Item No.", "Item No.");
                        RecReservationEntry_l.SetRange("Source Type", "Source Type");
                        RecReservationEntry_l.SetRange("Source Subtype", "Source Subtype");
                        RecReservationEntry_l.SetRange("Source ID", "Source ID");
                        RecReservationEntry_l.SetRange("Source Batch Name", "Source Batch Name");
                        RecReservationEntry_l.SetRange("Source Prod. Order Line", "Source Prod. Order Line");
                        RecReservationEntry_l.SetRange("Source Ref. No.", "Source Ref. No.");
                        if RecReservationEntry_l.Count <> 0 then begin
                            FrmReservationSSCCNeg_l.SetTableView(RecReservationEntry_l);
                            FrmReservationSSCCNeg_l.RunModal;
                        end;
                    end;*/
                end;
            end;
        end;

    end;



}

