page 50023 "Stock par lot"
{
    Caption = 'Stock par lot';
    PageType = Worksheet;
    SourceTable = "Lot No. Information";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            field("Location Filter"; "Location Filter")
            {
                Caption = 'Filtre magasin';

                trigger OnValidate()
                begin
                    AppliquerFiltre
                end;
            }
            field(InventoryOnly_g; InventoryOnly_g)
            {
                Caption = 'Uniquement en stock';

                trigger OnValidate()
                begin
                    AppliquerFiltre
                end;
            }
            field(DtPeriod; DtPeriod)
            {
                Caption = 'Date fin période';

                trigger OnValidate()
                begin

                    SetFilter("Inventory Date Filter", '..%1', DtPeriod);
                end;
            }
            field(InventoryPeriodOnly_g; InventoryPeriodOnly_g)
            {
                Caption = 'Uniquement en Stock Période';

                trigger OnValidate()
                begin
                    SetFilter("Inventory Date Filter", '..%1', DtPeriod);
                    AppliquerFiltre
                end;
            }
            repeater("repeat")
            {
                field("Item No."; "Item No.")
                {
                }
                field("rItem.Description"; rItem.Description)
                {
                    Caption = 'Désignation articles';
                }
                field("Lot No."; "Lot No.")
                {
                }
                field(CodeMag; CodeMag)
                {
                    Caption = 'Code magasin';
                }
                field(Inventory; Inventory)
                {
                }
                field("Inventory Period"; "Inventory Period")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        if rItem.Get("Item No.") then;
        dGrossW := 0;
        if rGWContainer.Get("Gross Weight / container") then begin
            dGrossW := "Inventory Period" * rGWContainer.Coeff;
        end;

        //CTD HUO 12/08/13
        DateExp := 0D;
        DateWar := 0D;
        CodeMag := '';
        ItemLedgerEntry.SetCurrentKey("Item No.", "Lot No.");      //DG170518
        ItemLedgerEntry.SetRange(ItemLedgerEntry."Item No.", "Item No.");
        ItemLedgerEntry.SetRange(ItemLedgerEntry."Lot No.", "Lot No.");
        //IF ItemLedgerEntry.FINDFIRST THEN BEGIN
        if ItemLedgerEntry.FindLast then begin    //DG170518
            DateWar := ItemLedgerEntry."Warranty Date";
            DateExp := ItemLedgerEntry."Expiration Date";
            CodeMag := ItemLedgerEntry."Location Code";
        end;
    end;

    trigger OnOpenPage()
    var
        UserSetUp: Record "User Setup";
    begin
        SetFilter("Date Filter", '%1..', 00000101D);

        AppliquerFiltre;

        //AB6.SEC
        //AB6.VIR.120310 --->
        if (UserSetUp.Get(UserId)) and (UserSetUp."Location Filter" <> '') then begin
            FilterGroup(2);
            SetFilter("Location Filter", UserSetUp."Location Filter");
            FilterGroup(0);
        end;
        //AB6.VIR.120310 <---
    end;

    var
        InventoryOnly_g: Boolean;
        DisplayStatus: Text[1];
        rItem: Record Item;
        dGrossW: Decimal;
        rGWContainer: Record "Gross Weight / container";
        UserMgt: Codeunit "User Setup Management";
        DateExp: Date;
        DateWar: Date;
        ItemLedgerEntry: Record "Item Ledger Entry";
        CodeMag: Text[30];
        InventoryPeriodOnly_g: Boolean;
        DtPeriod: Date;

    [Scope('OnPrem')]
    procedure AppliquerFiltre()
    begin
        if InventoryOnly_g then
            SetFilter(Inventory, '>%1', 0)
        else
            SetRange(Inventory);

        //CCS001.03 BEGIN
        if InventoryPeriodOnly_g then
            SetFilter("Inventory Period", '>%1', 0)
        else
            SetRange("Inventory Period");
        //CCS001.03 EINDE

        CurrPage.Update(false);
    end;

    [Scope('OnPrem')]
    procedure SetLocationFilter(LocationFilter_p: Text[80])
    begin
        // Absys LOG.5.B
        SetFilter("Location Filter", LocationFilter_p);
    end;

    [Scope('OnPrem')]
    procedure setDateFilter(DateFilter_p: Text[30])
    begin
        // Absys LOG.5.B
        SetFilter("Inventory Date Filter", DateFilter_p);
    end;
}

