codeunit 50018 "Tracking Specification Viewer"
{
    // ABSYS QM1.00 VE
    //   Affichage des informations Qualité

    TableNo = "Journal Track. Specif Viewer";

    trigger OnRun()
    begin
        JnlName_g := "Journal Name";

        ClearViewer();

        FilterLotNo_g := "Lot No. Filter";
        FilterItemCode_g := "Item Filter";

        if (FilterLotNo_g = '') or (FilterItemCode_g = '') then
            exit;

        case Direction of
            Direction::Up:
                CalculViewerExploreUp;
            Direction::Down:
                CalculViewerExploreDown;
        end;
    end;

    var
        FilterLotNo_g: Code[20];
        FilterItemCode_g: Code[30];
        HideOutputEntry_g: Boolean;
        Window_g: Dialog;
        JnlName_g: Code[20];

    [Scope('OnPrem')]
    procedure ClearViewer()
    var
        RecTrackSpecViewer_l: Record "Tracking Specif. Viewer";
        RecTrackSpecViewerItemLedger_l: Record "Track. Specif. Viewer Item Ldg";
    begin
        with RecTrackSpecViewer_l do begin
            Reset;
            SetRange("Journal Name", JnlName_g);
            DeleteAll;
        end;

        with RecTrackSpecViewerItemLedger_l do begin
            Reset;
            SetRange(User, JnlName_g);
            DeleteAll;
        end;
    end;

    [Scope('OnPrem')]
    procedure CalculViewerExploreUp()
    var
        RecTrackSpecViewer_l: Record "Tracking Specif. Viewer";
        RecItemLedgerEntry_l: Record "Item Ledger Entry";
    begin

        // on commence par le 1er niveau : les écritures de prod sur l'art et le lot.
        Window_g.Open('Item ledger Entry : #1#########################');

        RecItemLedgerEntry_l.Reset;
        RecItemLedgerEntry_l.SetCurrentKey("Entry Type", "Item No.", "Variant Code", "Lot No.", "Location Code", "Posting Date");
        RecItemLedgerEntry_l.SetFilter("Item No.", FilterItemCode_g);
        RecItemLedgerEntry_l.SetFilter("Lot No.", FilterLotNo_g);
        RecItemLedgerEntry_l.SetRange("Entry Type", RecItemLedgerEntry_l."Entry Type"::Output);

        if RecItemLedgerEntry_l.Find('-') then
            repeat
                ExploreUp(RecItemLedgerEntry_l, 1, 0, true, 0);

            until RecItemLedgerEntry_l.Next = 0;

        Window_g.Close;
    end;

    [Scope('OnPrem')]
    procedure ExploreUp(RecItemLedgerEntry_p: Record "Item Ledger Entry"; Level_p: Integer; Qty_p: Decimal; Affichable_p: Boolean; ParentLineNo_p: Integer)
    var
        RecTrackSpecViewer_l: Record "Tracking Specif. Viewer";
        RecTrackSpecViewer2_l: Record "Tracking Specif. Viewer";
        LineNo_l: Integer;
        RecItemApplies_l: Record "Item Application Entry";
        RecItemLedgerEntry_l: Record "Item Ledger Entry";
        RecItem_l: Record Item;
        RecLotInfo_l: Record "Lot No. Information";
    begin
        //----------------------------------------------------
        // Eploration de la traçabilité dans le sens
        // Production finale -> entrée en stock marchandise
        //----------------------------------------------------
        Window_g.Update(1, Format(RecItemLedgerEntry_p));

        if Level_p > 30 then
            exit;

        //-----------------------------------------------------------------------------------------------------
        // On regroupe les écritures de prod d'un même of... et on ne descend qu'une seule fois dans les conso
        // Vu que l'on fait fait une exploration en profondeur d'abord, si une ligne de production existe déjà
        // dans la table, on déjà explorer une fois les composants.
        // Mais ceci, uniquement si on est au même niveau
        //-----------------------------------------------------------------------------------------------------
        if RecItemLedgerEntry_p."Entry Type" = RecItemLedgerEntry_p."Entry Type"::Output then begin
            RecTrackSpecViewer_l.Reset;
            RecTrackSpecViewer_l.SetCurrentKey("Entry Type", "Prod. Order No.", "Prod. Order Line No.", Indentation);
            RecTrackSpecViewer_l.SetRange("Journal Name", JnlName_g);
            RecTrackSpecViewer_l.SetRange("Entry Type", RecTrackSpecViewer_l."Entry Type"::Output);
            RecTrackSpecViewer_l.SetRange("Prod. Order No.", RecItemLedgerEntry_p."Order No.");
            RecTrackSpecViewer_l.SetRange("Prod. Order Line No.", RecItemLedgerEntry_p."Order Line No.");
            RecTrackSpecViewer_l.SetRange(Indentation, Level_p);
            if RecTrackSpecViewer_l.Find('-') then begin
                // on test si on a pas déjà écrit le lot sur la ligne
                if not (StrPos(RecTrackSpecViewer_l."Lot no.", RecItemLedgerEntry_p."Lot No.") > 0) then
                    RecTrackSpecViewer_l."Lot no." := RecTrackSpecViewer_l."Lot no." + '|' + RecItemLedgerEntry_p."Lot No.";
                // on ajoute la qté consommée
                RecTrackSpecViewer_l."Consumption Quantity" += -Qty_p;
                RecTrackSpecViewer_l."Item Ledger Entry No Filter" :=
                    RecTrackSpecViewer_l."Item Ledger Entry No Filter" + '|' + Format(RecItemLedgerEntry_p."Entry No.");
                RecTrackSpecViewer_l.Modify;
                exit;
            end;
        end;

        RecTrackSpecViewer_l.Reset;
        RecTrackSpecViewer_l.SetRange("Journal Name", JnlName_g);
        if RecTrackSpecViewer_l.Find('+') then
            LineNo_l := RecTrackSpecViewer_l."Line No." + 1
        else
            LineNo_l := 1;

        //-------------------------------------------------------------------------
        // Enregistrement de la ligne
        // (les écritures de consommation ne servent qu'a passé au niveau suivant)
        //-------------------------------------------------------------------------

        if (RecItemLedgerEntry_p."Entry Type" <> RecItemLedgerEntry_p."Entry Type"::Consumption)
        or (RecItemLedgerEntry_p.Quantity > 0) then begin
            RecTrackSpecViewer_l.Init;
            RecTrackSpecViewer_l."Journal Name" := JnlName_g;
            RecTrackSpecViewer_l."Line No." := LineNo_l;
            RecTrackSpecViewer_l."Parent Line No." := ParentLineNo_p;
            RecTrackSpecViewer_l."Item Legder Entry No." := RecItemLedgerEntry_p."Entry No.";
            RecTrackSpecViewer_l."Item Ledger Entry No Filter" := Format(RecItemLedgerEntry_p."Entry No.");
            RecTrackSpecViewer_l."Entry Type" := RecItemLedgerEntry_p."Entry Type".AsInteger();
            RecTrackSpecViewer_l.Code := RecItemLedgerEntry_p."Item No.";
            RecItem_l.Get(RecItemLedgerEntry_p."Item No.");
            RecTrackSpecViewer_l.Description := RecItem_l.Description;
            RecTrackSpecViewer_l."Base Unit of Measure" := RecItem_l."Base Unit of Measure";
            //RecTrackSpecViewer_l.Indentation := RecTrackSpecViewer2_l.Indentation + 1;
            RecTrackSpecViewer_l.Indentation := Level_p;
            RecTrackSpecViewer_l.Open := false;
            RecTrackSpecViewer_l.Visible := Affichable_p;
            RecTrackSpecViewer_l."Interractiv bitmap" := '0';
            if RecItemLedgerEntry_p."Entry Type" = RecItemLedgerEntry_p."Entry Type"::Consumption then
                RecTrackSpecViewer_l."Consumption Quantity" := Qty_p // cas des conso négatives
            else
                RecTrackSpecViewer_l."Consumption Quantity" := -Qty_p;
            RecTrackSpecViewer_l."Item Legder Entry Qty" := RecItemLedgerEntry_p.Quantity;
            RecTrackSpecViewer_l."Lot no." := RecItemLedgerEntry_p."Lot No.";
            RecTrackSpecViewer_l."Prod. Order No." := RecItemLedgerEntry_p."Order No.";
            RecTrackSpecViewer_l."Prod. Order Line No." := RecItemLedgerEntry_p."Order Line No.";
            RecTrackSpecViewer_l."Source No." := RecItemLedgerEntry_p."Source No.";
            //QM
            /*
                      IF RecLotInfo_l.GET(RecItemLedgerEntry_p."Item No.",RecItemLedgerEntry_p."Variant Code",RecItemLedgerEntry_p."Lot No.") TH
            EN
            B
            EG
            IN
                RecLotInfo_l.CALCFIELDS("Quality Status");
                RecTrackSpecViewer_l."Quality Status":= RecLotInfo_l."Quality Status";
              END;
            */
            RecTrackSpecViewer_l.Insert;
        end;

        //------------------------------
        // Exploration des lignes liées
        // 2 cas :
        //------------------------------

        //-----------------------------------
        // Cas de l'écriture de consommation
        //-----------------------------------
        if RecItemLedgerEntry_p."Entry Type" = RecItemLedgerEntry_p."Entry Type"::Consumption then begin
            if RecItemLedgerEntry_p.Quantity < 0 then begin
                RecItemApplies_l.Reset;
                // !! Mettre la clé
                RecItemApplies_l.SetRange("Outbound Item Entry No.", RecItemLedgerEntry_p."Entry No.");
                RecItemApplies_l.SetFilter("Inbound Item Entry No.", '<>0');
                if RecItemApplies_l.Find('-') then
                    repeat
                        RecItemLedgerEntry_l.Get(RecItemApplies_l."Inbound Item Entry No.");
                        ExploreUp(RecItemLedgerEntry_l, Level_p, RecItemApplies_l.Quantity, false, ParentLineNo_p);
                    until RecItemApplies_l.Next = 0;
            end else begin
                // !! Rien pour l'instant !!
            end;
        end;

        //-----------------------------------
        // Cas de l'écriture de production
        //-----------------------------------
        if RecItemLedgerEntry_p."Entry Type" = RecItemLedgerEntry_p."Entry Type"::Output then begin

            RecItemLedgerEntry_l.Reset;
            RecItemLedgerEntry_l.SetCurrentKey(
              "Order No.", "Order Line No.", "Prod. Order Comp. Line No.", "Entry Type");
            RecItemLedgerEntry_l.SetRange("Entry Type", RecItemLedgerEntry_p."Entry Type"::Consumption);
            RecItemLedgerEntry_l.SetRange("Order Type", RecItemLedgerEntry_l."Order Type"::Production);
            RecItemLedgerEntry_l.SetRange("Order No.", RecItemLedgerEntry_p."Order No.");
            RecItemLedgerEntry_l.SetRange("Order Line No.", RecItemLedgerEntry_p."Order Line No.");

            if RecItemLedgerEntry_l.Find('-') then
                repeat
                    ExploreUp(RecItemLedgerEntry_l, Level_p + 1, RecItemLedgerEntry_p.Quantity, false, RecTrackSpecViewer_l."Line No.");
                until RecItemLedgerEntry_l.Next = 0;
        end;

    end;

    [Scope('OnPrem')]
    procedure CalculViewerExploreDown()
    var
        RecTrackSpecViewer_l: Record "Tracking Specif. Viewer";
        RecItemLedgerEntry_l: Record "Item Ledger Entry";
    begin
        Window_g.Open('Item ledger Entry : #1#####################');

        RecItemLedgerEntry_l.Reset;
        //PJ RecItemLedgerEntry_l.SETCURRENTKEY("Sales Available Date","Item No.","Lot No.",Positive);
        RecItemLedgerEntry_l.SetFilter("Item No.", FilterItemCode_g);
        RecItemLedgerEntry_l.SetFilter("Lot No.", FilterLotNo_g);
        RecItemLedgerEntry_l.SetRange(Positive, true);

        if RecItemLedgerEntry_l.Find('-') then
            repeat
                ExploreDown(RecItemLedgerEntry_l, 1, 0, true, 0);

            until RecItemLedgerEntry_l.Next = 0;

        Window_g.Close;
    end;

    [Scope('OnPrem')]
    procedure ExploreDown(RecItemLedgerEntry_p: Record "Item Ledger Entry"; Level_p: Integer; Qty_p: Decimal; Affichable_p: Boolean; ParentLineNo_p: Integer)
    var
        RecTrackSpecViewer_l: Record "Tracking Specif. Viewer";
        RecTrackSpecViewer2_l: Record "Tracking Specif. Viewer";
        LineNo_l: Integer;
        RecItemApplies_l: Record "Item Application Entry";
        RecItemLedgerEntry_l: Record "Item Ledger Entry";
        RecItem_l: Record Item;
        RecLotInfo_l: Record "Lot No. Information";
    begin
        //----------------------------------------------------
        // Eploration de la traçabilité dans le sens
        // entrée en stock marchandise -> vente client
        //----------------------------------------------------
        Window_g.Update(1, Format(RecItemLedgerEntry_p));

        if Level_p > 30 then
            exit;

        RecTrackSpecViewer_l.Reset;
        RecTrackSpecViewer_l.SetRange("Journal Name", JnlName_g);
        if RecTrackSpecViewer_l.Find('+') then
            LineNo_l := RecTrackSpecViewer_l."Line No." + 1
        else
            LineNo_l := 1;

        //----------------------------------------------------------------------
        // Enregistrement de la ligne
        // (les écritures de production ne servent qu'a passer au niveau suivant)
        // sauf pour le niveau 1
        //----------------------------------------------------------------------

        if not (RecItemLedgerEntry_p."Entry Type" = RecItemLedgerEntry_p."Entry Type"::Output) or (Level_p = 1) then begin
            RecTrackSpecViewer_l.Init;
            RecTrackSpecViewer_l."Journal Name" := JnlName_g;
            RecTrackSpecViewer_l."Line No." := LineNo_l;
            RecTrackSpecViewer_l."Parent Line No." := ParentLineNo_p;
            RecTrackSpecViewer_l."Item Legder Entry No." := RecItemLedgerEntry_p."Entry No.";
            RecTrackSpecViewer_l."Item Ledger Entry No Filter" := Format(RecItemLedgerEntry_p."Entry No.");
            RecTrackSpecViewer_l."Entry Type" := RecItemLedgerEntry_p."Entry Type".AsInteger();
            RecTrackSpecViewer_l.Code := RecItemLedgerEntry_p."Item No.";
            RecItem_l.Get(RecItemLedgerEntry_p."Item No.");
            RecTrackSpecViewer_l.Description := RecItem_l.Description;
            RecTrackSpecViewer_l."Base Unit of Measure" := RecItem_l."Base Unit of Measure";
            RecTrackSpecViewer_l.Indentation := Level_p;
            RecTrackSpecViewer_l.Open := false;
            RecTrackSpecViewer_l.Visible := Affichable_p;
            RecTrackSpecViewer_l."Interractiv bitmap" := '0';
            if RecItemLedgerEntry_p."Entry Type" = RecItemLedgerEntry_p."Entry Type"::Consumption then
                RecTrackSpecViewer_l."Consumption Quantity" := Qty_p // cas des conso négatives
            else
                RecTrackSpecViewer_l."Consumption Quantity" := -Qty_p;
            RecTrackSpecViewer_l."Item Legder Entry Qty" := RecItemLedgerEntry_p.Quantity;
            RecTrackSpecViewer_l."Lot no." := RecItemLedgerEntry_p."Lot No.";
            RecTrackSpecViewer_l."Prod. Order No." := RecItemLedgerEntry_p."Order No.";
            RecTrackSpecViewer_l."Prod. Order Line No." := RecItemLedgerEntry_p."Order Line No.";
            RecTrackSpecViewer_l."Source No." := RecItemLedgerEntry_p."Source No.";

            //QM
            /*
                      IF RecLotInfo_l.GET(RecItemLedgerEntry_p."Item No.",RecItemLedgerEntry_p."Variant Code",RecItemLedgerEntry_p."Lot No.") TH
            EN
            B
            EG
            IN
                RecLotInfo_l.CALCFIELDS("Quality Status");
                RecTrackSpecViewer_l."Quality Status":= RecLotInfo_l."Quality Status";
              END;
            */
            RecTrackSpecViewer_l.Insert;
        end;

        //----------------------------------------------------
        // Cas d'une sortie de stock : on s'arrête d'explorer
        //----------------------------------------------------
        if not (RecItemLedgerEntry_p."Entry Type" in [RecItemLedgerEntry_p."Entry Type"::Consumption,
          RecItemLedgerEntry_p."Entry Type"::Output]) and (RecItemLedgerEntry_p.Quantity < 0) then
            exit;

        //---------------------------------------------------------
        // Cas d'une consommation négative :
        // on descend dans l'OF -> A la recherche des productions
        //---------------------------------------------------------
        if (RecItemLedgerEntry_p."Entry Type" = RecItemLedgerEntry_p."Entry Type"::Consumption)
        and (RecItemLedgerEntry_p.Quantity < 0) then begin
            RecItemLedgerEntry_l.Reset;
            RecItemLedgerEntry_l.SetCurrentKey(
              "Order No.", "Order Line No.", "Prod. Order Comp. Line No.", "Entry Type"
            );
            RecItemLedgerEntry_l.SetRange("Entry Type", RecItemLedgerEntry_p."Entry Type"::Output);
            RecItemLedgerEntry_l.SetRange("Order No.", RecItemLedgerEntry_p."Order No.");
            RecItemLedgerEntry_l.SetRange("Order Line No.", RecItemLedgerEntry_p."Order Line No.");
            if RecItemLedgerEntry_l.Find('-') then
                repeat
                    ExploreDown(RecItemLedgerEntry_l, Level_p, RecItemLedgerEntry_p.Quantity, false, ParentLineNo_p);
                until RecItemLedgerEntry_l.Next = 0;
        end;

        //------------------------------------------------------------------
        // Cas d'une entrée en stock : on descend dans les sorties de stock
        //------------------------------------------------------------------
        if RecItemLedgerEntry_p.Quantity > 0 then begin
            RecItemApplies_l.Reset;
            RecItemApplies_l.SetCurrentKey(
              "Item Ledger Entry No.", "Inbound Item Entry No.", "Outbound Item Entry No."
            );
            RecItemApplies_l.SetRange("Inbound Item Entry No.", RecItemLedgerEntry_p."Entry No.");
            RecItemApplies_l.SetFilter("Outbound Item Entry No.", '<>0');
            if RecItemApplies_l.Find('-') then
                repeat
                    RecItemLedgerEntry_l.Get(RecItemApplies_l."Outbound Item Entry No.");
                    //ExploreDown(RecItemLedgerEntry_l,Level_p+1,RecItemApplies_l.Quantity,FALSE,ParentLineNo_p);
                    ExploreDown(RecItemLedgerEntry_l, Level_p + 1, RecItemApplies_l.Quantity, false, RecTrackSpecViewer_l."Line No.");
                until RecItemApplies_l.Next = 0;
        end;

    end;
}

