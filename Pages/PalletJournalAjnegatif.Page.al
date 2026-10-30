page 50068 "Pallet Journal Aj. negatif"
{
    // Module      Point          Dev   Date           Commentaire
    // ----------------------------------------------------------------------------------------------------
    // BSO1.00     LOG-101        GEN   14/01/09   :   Module de gestion du Scan
    // ----------------------------------------------------------------------------------------------------
    // 
    // BSO1.00     LOG-101        AUT   04/02/09   :   AutoSpliKey
    // 
    // BSO1.00     LOG-101        AUT   05/03/09   :   //>AT 0002 : à la selection du SSCC, Filtre du SSCC sur l'article et sur le lot.
    // 
    // BSO1.00     LOG-101        AUT   05/03/09   :   //>AT 0001 : Remplissage du "Item Tracking Spec Entry No." pour l'affectation du
    //                                                 N° de reservation.
    // 
    // BSO1.00     LOG-101        AUT   05/03/09   :   //>AT 0002 : Filtre des Journaux Pallet sur le Lot.
    // 
    // BSO1.00     LOG-101        GEN   12/03/09   :   ABC GEN 01 20090312 : Empêche la création de ligne sans N° SSCC
    //                                                 ABC GEN 02 20090312 : Modification du lookup SSCC
    //                                                 ABC GEN 03 20090312 : Ajout de la fonction SetFilter Utilisée par le Page 50066
    //                                                 + Modification du Page pour être utilisé comme Subform

    Caption = 'Pallet Journal Aj. negatif';
    PageType = ListPart;
    SourceTable = "Pallet Journal";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("SSCC No."; "SSCC No.")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        l_rPallet: Record Pallet;
                        FrmPalletList_l: Page "Liste palettes";
                        RecPallet_l: Record Pallet;
                    begin

                        //--> ABC GEN 02 20090312
                        Clear(FrmPalletList_l);
                        RecPallet_l.Reset;
                        if ItemFilter <> '' then
                            RecPallet_l.SetRange("Item No.", ItemFilter);
                        if LotFilter <> '' then
                            RecPallet_l.SetRange("Lot No.", LotFilter);
                        RecPallet_l.SetFilter("Current Quantity", '>0');
                        RecPallet_l.SetRange("Pallet Journal Line Exist", false);
                        FrmPalletList_l.SetTableView(RecPallet_l);
                        FrmPalletList_l.Editable(false);
                        FrmPalletList_l.LookupMode(true);
                        if FrmPalletList_l.RunModal() = ACTION::LookupOK then begin
                            FrmPalletList_l.GetRecord(RecPallet_l);
                            "SSCC No." := RecPallet_l."SSCC No.";
                            RecPallet_l.CalcFields("Current Quantity");
                            "Original Qty" := RecPallet_l."Current Quantity";
                            "Remaining Qty" := RecPallet_l."Current Quantity";
                        end;
                        //<-- ABC GEN 02 20090312
                    end;
                }
                field("Original Qty"; "Original Qty")
                {
                }
                field("Remaining Qty"; "Remaining Qty")
                {
                }
                field("Treated Quantity"; "Treated Quantity")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnDeleteRecord(): Boolean
    begin
        //--> ABC GEN 20090317
        FromForm := true;
        //<-- ABC GEN 20090317
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        RecPalletJournal_l: Record "Pallet Journal";
    begin
        //--> ABC GEN 01 20090312
        if "SSCC No." = '' then
            Error('');
        //<-- ABC GEN 01 20090312
        FilterGroup(4);
        if GetFilter("Reservation Entry") <> '' then begin
            Evaluate("Reservation Entry", GetFilter("Reservation Entry"));
        end;

        //>AT 0001\
        "Item Tracking Spec Entry No." := iItemTrackingSpecEntry;
        //>AT 0001/

        "Lot No." := LotFilter;

        //--> ABC GEN 20090317
        FromForm := true;
        //<-- ABC GEN 20090317

        //--> ABC GEN 20090317
        RecPalletJournal_l.Reset;
        RecPalletJournal_l.SetRange("Journal Template Name", "Journal Template Name");
        RecPalletJournal_l.SetRange("Journal Batch Name", "Journal Batch Name");
        RecPalletJournal_l.SetRange("Journal Line No.", "Journal Line No.");
        if RecPalletJournal_l.Find('+') then
            ID := RecPalletJournal_l.ID + 10000
        else
            ID := 10000;

        //<-- ABC GEN 20090317
    end;

    trigger OnModifyRecord(): Boolean
    begin
        //>AT 0001\
        "Item Tracking Spec Entry No." := iItemTrackingSpecEntry;
        //>AT 0001/
        //--> ABC GEN 20090317
        FromForm := true;
        //<-- ABC GEN 20090317
    end;

    var
        ItemFilter: Code[20];
        LotFilter: Code[20];
        iItemTrackingSpecEntry: Integer;
        rTrackingSpecification: Record "Tracking Specification";
        Pallet_g: Record "Gross Weight / container";

    [Scope('OnPrem')]
    procedure SetItemLotFilter(Itemf: Code[20]; Lotf: Code[20]; p_iItemTrackingSpecEntry: Integer; var p_rTrackingSpecification: Record "Tracking Specification")
    begin
        ItemFilter := Itemf;
        LotFilter := Lotf;

        //>AT 0001\
        iItemTrackingSpecEntry := p_iItemTrackingSpecEntry;
        //>AT 0001/

        //>AT 0002\



        //>AT 0002/
    end;

    [Scope('OnPrem')]
    procedure SetFilter(LotFilter_p: Code[20]; Item_p: Code[20])
    begin
        //--> ABC GEN 03 20090312
        ItemFilter := Item_p;
        LotFilter := LotFilter_p;
        //<-- ABC GEN 03 20090312
    end;
}

