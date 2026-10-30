page 50026 "Item TracingEC"
{
    AdditionalSearchTerms = 'serial number,lot number,expiration,fefo,item tracking,fda,defect';
    ApplicationArea = ItemTracking;
    Caption = 'Item Tracing EC';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    PromotedActionCategories = 'New,Process,Report,Line,Item';
    SourceTable = "Item Tracing Buffer";
    SourceTableTemporary = true;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            label(Control35)
            {
                ApplicationArea = ItemTracking;
                CaptionClass = Format(TraceText);
                Editable = false;
                ShowCaption = false;
                ToolTip = 'Specifies the text that is used to trace the item.';
            }
            repeater(Control1)
            {
                ShowCaption = false;
                field("Item No."; "Item No.")
                {
                    ApplicationArea = ItemTracking;
                    Editable = false;
                    Style = Strong;
                    ToolTip = 'Specifies the number of the traced item.';
                }
                field("Lot No."; "Lot No.")
                {
                    ApplicationArea = ItemTracking;
                    Editable = false;
                    Style = Strong;
                    ToolTip = 'Specifies the traced lot number.';

                    trigger OnDrillDown()
                    var
                        LotInfo: Record "Lot No. Information";
                    begin
                        LotInfo.Reset;
                        LotInfo.Get(Rec."Item No.", '', Rec."Lot No.");
                        PAGE.Run(6505, LotInfo);
                    end;
                }
                field("Item Description"; "Item Description")
                {
                    ApplicationArea = ItemTracking;
                    Editable = false;
                    ToolTip = 'Specifies a description of the item.';
                }
                field(Quantity; Quantity)
                {
                }
                field("Source Name"; "Source Name")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Line)
            {
                Caption = '&Line';
                Image = Line;
                action(ShowDocument)
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Show Document';
                    Image = View;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'Open the document that the selected line exists on.';

                    trigger OnAction()
                    begin
                        ItemTracingMgt.ShowDocument("Record Identifier");
                    end;
                }
            }
            group(Item)
            {
                Caption = '&Item';
                Image = Item;
                action(Card)
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Card';
                    Image = EditLines;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page "Item Card";
                    RunPageLink = "No." = FIELD("Item No.");
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or change detailed information about the record on the document or journal line.';
                }
                action(LedgerEntries)
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Ledger E&ntries';
                    Image = CustomerLedger;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page "Item Ledger Entries";
                    RunPageLink = "Item No." = FIELD("Item No.");
                    RunPageView = SORTING("Item No.");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of transactions that have been posted for the selected record.';
                }
            }
        }
        area(processing)
        {
            group(Functions)
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(TraceOppositeFromLine)
                {
                    ApplicationArea = ItemTracking;
                    Caption = '&Trace Opposite - from Line';
                    Enabled = FunctionsEnable;
                    Image = TraceOppositeLine;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Repeat the previous trace, but going the opposite direction.';

                    trigger OnAction()
                    begin
                        if TraceMethod = TraceMethod::"Origin->Usage" then
                            TraceMethod := TraceMethod::"Usage->Origin"
                        else
                            TraceMethod := TraceMethod::"Origin->Usage";
                        OppositeTraceFromLine;
                    end;
                }
                action(SetFiltersWithLineValues)
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Set &Filters with Line Values';
                    Enabled = FunctionsEnable;
                    Image = FilterLines;
                    ToolTip = 'Insert the values of the selected line in the respective filter fields on the header and executes a new trace. This function is useful, for example, when the origin of the defective item is found and that particular trace line must Page the basis of additional tracking with the same trace method.';

                    trigger OnAction()
                    var
                        pck: text;
                    begin
                        ItemTracingMgt.InitSearchParm(Rec, SerialNoFilter, LotNoFilter, pck, ItemNoFilter, VariantFilter);
                    end;
                }
                action("Go to Already-Traced History")
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Go to Already-Traced History';
                    Enabled = FunctionsEnable;
                    Image = MoveUp;
                    ToolTip = 'View the item tracing history.';

                    trigger OnAction()
                    begin
                        SetFocus("Item Ledger Entry No.");
                    end;
                }
                action(NextTraceResult)
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Next Trace Result';
                    Image = NextRecord;
                    ToolTip = 'View the next item transaction in the tracing direction. ';

                    trigger OnAction()
                    begin
                        RecallHistory(1);
                    end;
                }
                action(PreviousTraceResult)
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Previous Trace Result';
                    Image = PreviousRecord;
                    ToolTip = 'View the previous item transaction in the tracing direction.';

                    trigger OnAction()
                    begin
                        RecallHistory(-1);
                    end;
                }
            }
            action(Print)
            {
                ApplicationArea = ItemTracking;
                Caption = '&Print';
                Ellipsis = true;
                Enabled = PrintEnable;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    xItemTracingBuffer: Record "Item Tracing Buffer";
                    PrintTracking: Report "Item Tracing Specification";
                begin
                    Clear(PrintTracking);
                    xItemTracingBuffer.Copy(Rec);
                    PrintTracking.TransferEntries(Rec);
                    Copy(xItemTracingBuffer);
                    PrintTracking.Run;
                end;
            }
            action(Navigate)
            {
                ApplicationArea = ItemTracking;
                Caption = '&Navigate';
                Enabled = NavigateEnable;
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';

                trigger OnAction()
                var
                    Navigate: Page Navigate;
                    ItemTrk: record "Item Tracking Setup" temporary;
                begin
                    ItemTrk.INIT;
                    ItemTrk."Lot No." := "Lot No.";
                    ItemTrk.INIT;
                    Navigate.SetTracking(ItemTrk);
                    Navigate.Run;
                end;
            }
            action(Trace)
            {
                ApplicationArea = ItemTracking;
                Caption = '&Trace';
                Image = Trace;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Trace where a lot or serial number assigned to the item was used, for example, to find which lot a defective component came from or to find all the customers that have received items containing the defective component.';

                trigger OnAction()
                begin
                    FindRecords;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        DescriptionIndent := 0;
        ItemTracingMgt.SetExpansionStatus(Rec, TempTrackEntry, Rec, ActualExpansionStatus);
        DescriptionOnFormat;
    end;

    trigger OnInit()
    begin
        NavigateEnable := true;
        PrintEnable := true;
        FunctionsEnable := true;
    end;

    trigger OnOpenPage()
    begin
        InitButtons;
        TraceMethod := TraceMethod::"Usage->Origin";
        ShowComponents := ShowComponents::"Item-tracked Only";
        TempTrackEntry.Reset;

        ItemTracingMgt.ExpandAll(TempTrackEntry, Rec);
        //TrackEXV('EXV-E24-08115');
    end;

    var
        TempTrackEntry: Record "Item Tracing Buffer" temporary;
        ItemTracingMgt: Codeunit "Item Tracing Mgt.";
        TraceMethod: Option "Origin->Usage","Usage->Origin";
        ShowComponents: Option No,"Item-tracked Only",All;
        ActualExpansionStatus: Option "Has Children",Expanded,"No Children";
        SerialNoFilter: Text;
        LotNoFilter: Text;
        ItemNoFilter: Text;
        VariantFilter: Text;
        Text001: Label 'Item No. Filter is required.';
        TraceText: Text;
        Text002: Label 'Serial No.: %1, Lot No.: %2, Item: %3, Variant: %4, Trace Method: %5, Show Components: %6';
        PreviousExists: Boolean;
        NextExists: Boolean;
        Text003: Label 'Filters are too large to show.';
        Text004: Label 'Origin->Usage,Usage->Origin';
        Text005: Label 'No,Item-tracked Only,All';
        DescriptionIndent: Integer;
        FunctionsEnable: Boolean;
        PrintEnable: Boolean;
        NavigateEnable: Boolean;
        TempTrackEntry2: Record "Item Tracing Buffer" temporary;
        NbreL: Integer;

    procedure FindRecords()
    begin
        ItemTracingMgt.FindRecords(TempTrackEntry2, Rec,
          SerialNoFilter, LotNoFilter, '', ItemNoFilter, VariantFilter,
          TraceMethod, ShowComponents);
        InitButtons;

        ItemTracingMgt.GetHistoryStatus(PreviousExists, NextExists);

        UpdateTraceText;

        TempTrackEntry2.Reset;
        TempTrackEntry2.SetFilter("Item No.", '<>7-C*');
        TempTrackEntry2.DeleteAll;
        TempTrackEntry2.Reset;
        TempTrackEntry2.SetFilter("Lot No.", 'D-WB*');
        TempTrackEntry2.DeleteAll;

        TempTrackEntry2.Reset;
        if TempTrackEntry2.FindSet then
            repeat
                TempTrackEntry.Reset;
                TempTrackEntry.SetRange("Item No.", TempTrackEntry2."Item No.");
                TempTrackEntry.SetRange("Lot No.", TempTrackEntry2."Lot No.");
                if not TempTrackEntry.FindFirst then begin
                    TempTrackEntry.Reset;
                    TempTrackEntry.Init;
                    TempTrackEntry.TransferFields(TempTrackEntry2, true);
                    TempTrackEntry.Insert;
                end;
            until TempTrackEntry2.Next = 0;


        TempTrackEntry.Reset;

        ItemTracingMgt.ExpandAll(TempTrackEntry, Rec);
        CurrPage.Update(false)
    end;

    local procedure OppositeTraceFromLine()
    var
        pck: text;
    begin
        ItemTracingMgt.InitSearchParm(Rec, SerialNoFilter, LotNoFilter, pck, ItemNoFilter, VariantFilter);
        FindRecords;
    end;

    procedure InitButtons()
    begin
        if not TempTrackEntry.FindFirst then begin
            FunctionsEnable := false;
            PrintEnable := false;
            NavigateEnable := false;
        end else begin
            FunctionsEnable := true;
            PrintEnable := true;
            NavigateEnable := true;
        end;
    end;

    procedure InitFilters(var ItemTrackingEntry: Record "Item Tracing Buffer")
    begin
        SerialNoFilter := ItemTrackingEntry.GetFilter("Serial No.");
        LotNoFilter := ItemTrackingEntry.GetFilter("Lot No.");
        ItemNoFilter := ItemTrackingEntry.GetFilter("Item No.");
        VariantFilter := ItemTrackingEntry.GetFilter("Variant Code");
        TraceMethod := TraceMethod::"Usage->Origin";
        ShowComponents := ShowComponents::"Item-tracked Only";
    end;

    procedure GetItemFilters(var TraceMethod2: Option "Origin->Usage","Usage->Origin"; var ShowComponents2: Option No,"Item-tracked Only",All; var SerialNoFilter2: Text; var LotNoFilter2: Text; var ItemNoFilter2: Text; var VariantFilter2: Text)
    begin
        TraceMethod2 := TraceMethod;
        ShowComponents2 := ShowComponents;
        SerialNoFilter2 := SerialNoFilter;
        LotNoFilter2 := LotNoFilter;
        ItemNoFilter2 := ItemNoFilter;
        VariantFilter2 := VariantFilter;
    end;

    procedure SetItemFilters(TraceMethod2: Option "Origin->Usage","Usage->Origin"; ShowComponents2: Option No,"Item-tracked Only",All; SerialNoFilter2: Text; LotNoFilter2: Text; ItemNoFilter2: Text; VariantFilter2: Text)
    begin
        TraceMethod := TraceMethod2;
        ShowComponents := ShowComponents2;
        SerialNoFilter := SerialNoFilter2;
        LotNoFilter := LotNoFilter2;
        ItemNoFilter := ItemNoFilter2;
        VariantFilter := VariantFilter2;
    end;

    local procedure RecallHistory(Steps: Integer)
    var
        pck: text;
    begin

        ItemTracingMgt.RecallHistory(Steps, TempTrackEntry, Rec, SerialNoFilter,
          LotNoFilter, pck, ItemNoFilter, VariantFilter, TraceMethod, ShowComponents);
        UpdateTraceText;
        InitButtons;
        ItemTracingMgt.GetHistoryStatus(PreviousExists, NextExists);

        ItemTracingMgt.ExpandAll(TempTrackEntry, Rec);
        CurrPage.Update(false);
    end;

    local procedure UpdateTraceText()
    var
        LengthOfText: Integer;
        Overflow: Boolean;
    begin
        LengthOfText := (StrLen(Text002 + SerialNoFilter + LotNoFilter + ItemNoFilter + VariantFilter) +
                         StrLen(Format(TraceMethod)) + StrLen(Format(ShowComponents)) - 6); // 6 = number of positions in Text002

        Overflow := LengthOfText > 512;

        if Overflow then
            TraceText := Text003
        else
            TraceText := StrSubstNo(Text002, SerialNoFilter, LotNoFilter, ItemNoFilter, VariantFilter,
                SelectStr(TraceMethod + 1, Text004), SelectStr(ShowComponents + 1, Text005));
    end;

    local procedure DescriptionOnFormat()
    begin
        DescriptionIndent := Level;
    end;

    local procedure SetFocus(ItemLedgerEntryNo: Integer)
    begin
        if "Already Traced" then begin
            TempTrackEntry.SetCurrentKey("Item Ledger Entry No.");
            TempTrackEntry.SetRange("Item Ledger Entry No.", ItemLedgerEntryNo);
            TempTrackEntry.FindFirst;
            CurrPage.SetRecord(TempTrackEntry);
        end;
    end;

    procedure AddTracking(ItemNo: Code[20]; LotNo: Code[30]; Qty: Decimal; Dt: Date; Entry: Integer)
    var
        ile: Record "Item Ledger Entry";
        StatsOF: Record "Stats OF";
        QteKg: Decimal;
        Lot: Record "Lot No. Information";
    begin
        ItemTracingMgt.FindRecords(TempTrackEntry2, Rec, '', LotNo, '', ItemNo, '', TraceMethod::"Usage->Origin", ShowComponents::"Item-tracked Only");

        TempTrackEntry2.Reset;
        TempTrackEntry2.SetFilter("Item No.", '<>7-C*');
        TempTrackEntry2.DeleteAll;
        TempTrackEntry2.Reset;
        TempTrackEntry2.SetFilter("Lot No.", 'D-WB*');
        TempTrackEntry2.DeleteAll;

        TempTrackEntry2.Reset;
        if TempTrackEntry2.FindSet then
            repeat
                ile.Reset;
                ile.SetRange("Entry Type", ile."Entry Type"::Output);
                ile.SetRange("Item No.", ItemNo);
                ile.SetRange("Lot No.", LotNo);
                ile.SetFilter("Posting Date", '<=%1', CalcDate('<+2D>', Dt));
                QteKg := 0;
                if not ile.FindLast then begin
                    Message('Article %1, lot %2 non trouvé en prod', ItemNo, LotNo);
                end
                else begin
                    StatsOF.Reset;
                    StatsOF.SetRange("OF", ile."Order No." + '-' + Format(ile."Order Line No."));
                    StatsOF.SetRange(source, TempTrackEntry2."Item No.");
                    StatsOF.SetFilter(Lot, '*' + TempTrackEntry2."Lot No.");
                    if StatsOF.FindSet then
                        repeat
                            QteKg := QteKg + StatsOF."Quantité utilisee" / StatsOF."Quantite produite";
                        until StatsOF.Next = 0;
                end;

                TempTrackEntry.Reset;
                TempTrackEntry.SetRange("Item No.", TempTrackEntry2."Item No.");
                TempTrackEntry.SetRange("Lot No.", TempTrackEntry2."Lot No.");
                if not TempTrackEntry.FindFirst then begin
                    TempTrackEntry.Reset;
                    TempTrackEntry.Init;
                    TempTrackEntry."Line No." := NbreL;
                    NbreL := NbreL + 1;
                    TempTrackEntry.TransferFields(TempTrackEntry2, false);
                    TempTrackEntry.Quantity := Qty * QteKg;
                    TempTrackEntry."Item Ledger Entry No." := Entry;
                    TempTrackEntry.Insert;
                    Lot.Reset;
                    Lot.SetRange("Item No.", TempTrackEntry."Item No.");
                    Lot.SetRange("Lot No.", TempTrackEntry."Lot No.");
                    if Lot.FindFirst then
                        TempTrackEntry."Source Name" := Lot."Certificate Number";

                end
                else begin
                    if (TempTrackEntry."Item Ledger Entry No." <> Entry) then begin
                        TempTrackEntry.Quantity += Qty * QteKg;
                        TempTrackEntry."Item Ledger Entry No." := Entry;
                        TempTrackEntry.Modify;
                    end;
                end;
            until TempTrackEntry2.Next = 0;
    end;

    [Scope('OnPrem')]
    procedure TrackEXV(No: Code[20])
    var
        ile: Record "Item Ledger Entry";
    begin
        NbreL := 1;
        ile.Reset;
        ile.SetRange("Document No.", No);
        ile.SetFilter("Item No.", '1-*');
        if ile.FindSet then
            repeat
                AddTracking(ile."Item No.", ile."Lot No.", ile.Quantity, ile."Posting Date", ile."Entry No.");
            until ile.Next = 0;

        //UpdateTraceText;

        TempTrackEntry.Reset;
        ItemTracingMgt.ExpandAll(TempTrackEntry, Rec);
    end;

    [Scope('OnPrem')]
    procedure TrackCDV(No: Code[20])
    var
        Traca: Record "Reservation Entry";
    begin
        NbreL := 1;

        Traca.Reset;
        Traca.SetRange("Source ID", No);
        Traca.SetFilter("Item No.", '1-*');
        if Traca.FindSet then
            repeat
                AddTracking(Traca."Item No.", Traca."Lot No.", Traca.Quantity, Today, Traca."Item Ledger Entry No.");
            until Traca.Next = 0;

        //UpdateTraceText;

        TempTrackEntry.Reset;
        ItemTracingMgt.ExpandAll(TempTrackEntry, Rec);
    end;
}

