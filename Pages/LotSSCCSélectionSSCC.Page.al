page 50066 "Lot - SSCC : Sélection SSCC"
{
    // ABSYS-CYBORG
    // ------------
    // VN1.00 KWK 20/10/2009 Ajout bouton Create SSCC
    // 
    // BSO1.00     LOG-101        GEN   12/03/09   : //--> ABC GEN 20090312 : Gestion des N° SSCC directement depuis l'écriture réservation

    Caption = 'Lot - SSCC : Sélection SSCC';
    PageType = List;
    SourceTable = "Reservation Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; "Item No.")
                {
                }
                field("Lot No."; "Lot No.")
                {
                }
                field("Quantité"; Abs("Quantity (Base)"))
                {
                    Style = Unfavorable;
                    StyleExpr = CtrlQty;
                }
                field("Pallet Qty"; "Pallet Qty")
                {
                }
                field("Add on existing pallet"; "Add on existing pallet")
                {
                }
                field(CtrlQty; CtrlQty)
                {
                    Visible = false;
                }
            }
            part(JournalPallet; "Pallet Journal")
            {
                SubPageLink = "Reservation Entry" = FIELD("Entry No."),
                              "Journal Template Name" = FIELD("Source ID"),
                              "Journal Batch Name" = FIELD("Source Batch Name"),
                              "Journal Line No." = FIELD("Source Ref. No.");
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        RecPalletJournal_l: Record "Pallet Journal";
        TotalPalette_l: Decimal;
    begin
        //--> ABC GEN 20090312
        CurrPage.JournalPallet.PAGE.SetFilter("Lot No.", "Item No.");

        if "Add on existing pallet" then begin
            CalcFields("Item Jnl Bin Code");
            CurrPage.JournalPallet.PAGE.SetAddOnExistingPal("Item Jnl Bin Code", "Location Code");
        end;
        //MESSAGE('Lot No : %1 - Item No : %2',"Lot No.","Item No.");
        //<-- ABC GEN 20090312

        CtrlQty := false;
        RecPalletJournal_l.SetRange("Reservation Entry", "Entry No.");
        if RecPalletJournal_l.FindSet then begin
            repeat
                TotalPalette_l += RecPalletJournal_l."Treated Quantity";
            until RecPalletJournal_l.Next = 0;
            if (Abs("Quantity (Base)") - TotalPalette_l) <> 0 then
                CtrlQty := true;
        end else begin
            CtrlQty := true;
        end;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        RecPalletJournal_l: Record "Pallet Journal";
        TotalPalette_l: Decimal;
    begin
        //--> ABC GEN 20090312
        //  Contrôle si la qté palette correspond à la ligne de réservation
        RecPalletJournal_l.SetRange("Reservation Entry", "Entry No.");
        if RecPalletJournal_l.FindSet then begin
            repeat
                TotalPalette_l += RecPalletJournal_l."Treated Quantity";
            until RecPalletJournal_l.Next = 0;
            if (Abs("Quantity (Base)") - TotalPalette_l) <> 0 then
                if Confirm('La qté SSCC ne correspond pas à la Qté réservée\Voulez-vous continuer ?') then
                    exit(true)
                else
                    exit(false);

        end else begin
            if Confirm('Voulez-vous continuer sans sélectionner de N° SSCC ?') then
                exit(true)
            else
                exit(false);
        end;
        //--> ABC GEN 20090312
    end;

    var
        CtrlQty: Boolean;
}

