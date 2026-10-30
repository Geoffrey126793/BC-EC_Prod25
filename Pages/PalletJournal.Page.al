page 50027 "Pallet Journal"
{
    AutoSplitKey = true;
    Caption = 'Pallet Journal';
    DelayedInsert = true;
    PageType = ListPart;
    PopulateAllFields = true;
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
                        if AddOnExistingPal then begin
                            Clear(FrmPalletList_l);
                            RecPallet_l.Reset;
                            if ItemFilter <> '' then
                                RecPallet_l.SetRange("Item No.", ItemFilter);
                            if LotFilter <> '' then
                                RecPallet_l.SetRange("Lot No.", LotFilter);
                            RecPallet_l.SetRange("Location code", LocationFilter);
                            RecPallet_l.SetRange("Bin code", CurrentBin);
                            RecPallet_l.SetFilter("Current Quantity", '>0');
                            RecPallet_l.SetRange("Pallet Journal Line Exist", false);
                            FrmPalletList_l.SetTableView(RecPallet_l);
                            FrmPalletList_l.Editable(false);
                            FrmPalletList_l.LookupMode(true);
                            if FrmPalletList_l.RunModal() = ACTION::LookupOK then begin
                                FrmPalletList_l.GetRecord(RecPallet_l);
                                "SSCC No." := RecPallet_l."SSCC No.";
                                "Lot No." := RecPallet_l."Lot No.";
                                //    RecPallet_l.CALCFIELDS("Current Quantity");
                                //    "Treated Quantity" := RecPallet_l."Current Quantity";
                            end;
                        end;
                    end;
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

    var
        ItemFilter: Code[50];
        LotFilter: Code[50];
        iItemTrackingSpecEntry: Integer;
        rTrackingSpecification: Record "Tracking Specification";
        Pallet_g: Record "Gross Weight / container";
        AddOnExistingPal: Boolean;
        CurrentBin: Code[20];
        LocationFilter: Code[20];

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
    procedure SetFilter(LotFilter_p: Code[50]; Item_p: Code[50])
    begin
        //--> ABC GEN 03 20090312
        ItemFilter := Item_p;
        LotFilter := LotFilter_p;
        //<-- ABC GEN 03 20090312
    end;

    [Scope('OnPrem')]
    procedure SetAddOnExistingPal(CurrBin: Code[20]; CurrLoc: Code[20])
    begin
        AddOnExistingPal := true;
        CurrentBin := CurrBin;
        LocationFilter := CurrLoc;
    end;
}

