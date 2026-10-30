page 50025 "Tracking specif viewer subPage"
{
    Caption = 'Tracking specif viewer subPage';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Tracking Specif. Viewer";
    SourceTableView = SORTING("Journal Name", "Line No.")
                      WHERE(Visible = CONST(true),
                            Indentation = FILTER(> 0));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                IndentationColumn = Indentation;
                IndentationControls = Description;
                field("Interractiv bitmap"; "Interractiv bitmap")
                {
                    Caption = '''''';

                    trigger OnAssistEdit()
                    var
                        OldTrackViewer: Record "Tracking Specif. Viewer";
                        SearchTrackViewer: Record "Tracking Specif. Viewer";
                    begin
                        OldTrackViewer := Rec;

                        if not OldTrackViewer.Open then begin
                            Expand(OldTrackViewer);
                        end else begin
                            Collapse(OldTrackViewer, true);
                        end;

                        Commit;
                        CurrPage.Update(true);
                        Get(OldTrackViewer."Journal Name", OldTrackViewer."Line No.");
                    end;
                }
                field("Code"; Code)
                {
                }
                field(Description; Description)
                {
                }
                field("Prod. Order No."; "Prod. Order No.")
                {
                }
                field("Consumption Quantity"; "Consumption Quantity")
                {
                }
                field("Base Unit of Measure"; "Base Unit of Measure")
                {
                }
                field(DisplayStatus; DisplayStatus)
                {
                }
                field("Quality Status"; "Quality Status")
                {
                }
                field("Lot no."; "Lot no.")
                {
                }
                field("Item Legder Entry Qty"; "Item Legder Entry Qty")
                {
                }
                field("Entry Type"; "Entry Type")
                {
                }
                field("Source No."; "Source No.")
                {
                }
                field("Item Legder Entry No."; "Item Legder Entry No.")
                {
                }
                field("Item Ledger Entry No Filter"; "Item Ledger Entry No Filter")
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
        CalcFields("Last Level");
        if "Last Level" then
            "Interractiv bitmap" := '';
    end;

    var
        CU_SpecificationTrackingViewer: Codeunit "Tracking Specification Viewer";
        Direction_g: Option Up,Down;
        DisplayStatus: Text[1];

    [Scope('OnPrem')]
    procedure Expand(OldTrackViewer_p: Record "Tracking Specif. Viewer")
    var
        SearchTrackViewer_l: Record "Tracking Specif. Viewer";
    begin
        //-------------------------------
        // Eclater d'un dossier
        //-------------------------------

        OldTrackViewer_p.Open := true;
        OldTrackViewer_p."Interractiv bitmap" := '1';
        OldTrackViewer_p.Modify;

        SearchTrackViewer_l.Reset;
        SearchTrackViewer_l.SetRange("Parent Line No.", OldTrackViewer_p."Line No.");
        if SearchTrackViewer_l.Find('-') then
            repeat
                SearchTrackViewer_l.Visible := true;
                SearchTrackViewer_l.Modify;
            until SearchTrackViewer_l.Next = 0;
    end;

    [Scope('OnPrem')]
    procedure Collapse(OldTrackViewer_p: Record "Tracking Specif. Viewer"; Visible_p: Boolean)
    var
        SearchTrackViewer_l: Record "Tracking Specif. Viewer";
    begin
        //--------------------------------------------
        // Fermeture d'un dossier et de tous ces
        // sous dossqier
        // (Fonction récursive)
        //--------------------------------------------

        OldTrackViewer_p.Open := false;
        OldTrackViewer_p.Visible := Visible_p;
        OldTrackViewer_p."Interractiv bitmap" := '0';
        OldTrackViewer_p.Modify;


        // on ferme les sous dossier
        SearchTrackViewer_l.Reset;
        SearchTrackViewer_l.SetRange("Parent Line No.", OldTrackViewer_p."Line No.");
        SearchTrackViewer_l.SetRange(Visible, true);
        if SearchTrackViewer_l.Find('-') then
            repeat
                Collapse(SearchTrackViewer_l, false);
            until SearchTrackViewer_l.Next = 0;
    end;

    [Scope('OnPrem')]
    procedure ExpandAll()
    var
        RecTrackViewer_l: Record "Tracking Specif. Viewer";
    begin
        RecTrackViewer_l.CopyFilters(Rec);
        RecTrackViewer_l.SetRange(Open, false);

        while (RecTrackViewer_l.Find('-')) do
            Expand(RecTrackViewer_l);

        CurrPage.Update();
    end;

    [Scope('OnPrem')]
    procedure ShowInformationLot()
    var
        RecInfoLot_l: Record "Lot No. Information";
        frmInfoLot_l: Page "Lot No. Information Card";
    begin
        RecInfoLot_l.SetRange(RecInfoLot_l."Item No.", Code);
        RecInfoLot_l.SetRange(RecInfoLot_l."Lot No.", "Lot no.");
        //FORM.RUNMODAL(0,RecInfoLot_l);

        frmInfoLot_l.SetTableView(RecInfoLot_l);
        frmInfoLot_l.RunModal;
    end;

    [Scope('OnPrem')]
    procedure ShowItemLedgerEntry()
    var
        RecItemLedgerEntry_l: Record "Item Ledger Entry";
    begin
        // Absys

        RecItemLedgerEntry_l.Reset;
        RecItemLedgerEntry_l.SetFilter("Entry No.", "Item Ledger Entry No Filter");
        if RecItemLedgerEntry_l.Find('-') then
            PAGE.RunModal(50060, RecItemLedgerEntry_l);
    end;
}

