pageextension 70195 pageextension70195 extends "Item Tracking Summary"
{
    layout
    {
        modify("Lot No.")
        {
            Width = 25;
            Style = Unfavorable;
            StyleExpr = LotBlocked;

        }

        modify("Warranty Date")
        {
            Visible = true;
        }

        addafter("Bin Content")
        {
            field("Pick Qty."; "Pick Qty.")
            {
            }
            field("Inventory Warehouse Entry"; "Inventory Warehouse Entry")
            {
            }
        }
    }

    var
        EmplacementCode: Text[30];
        PalletList: Record Pallet;
        InfoLot: Record "Lot No. Information";
        LotBlocked: Boolean;
        StyleBloque: Text;


    trigger OnAfterGetRecord()
    begin

        //CTD HUO 190914 Récupération du code emplacement par rapport à la table pallet
        PalletList.Reset;
        PalletList.SetRange("Lot No.", "Lot No.");
        StyleBloque := 'standard';

        if PalletList.FindFirst then
            EmplacementCode := PalletList."Bin code";
        //CTD//
        LotBlocked := false;

        if InfoLot.Get(Rec."Item No.", '', Rec."Lot No.") then
            if InfoLot.Blocked then begin
                LotBlocked := true;
                StyleBloque := 'unfavorable';
                if StrPos(InfoLot."Commentaire blocage", 'résultats d''analyse') > 0 then
                    StyleBloque := 'strongaccent';
            end;
    end;


    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Warranty Date");
    end;
}

