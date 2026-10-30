codeunit 50030 "Stock EC"
{

    trigger OnRun()
    var
        recItem: Record Item;
    begin
        //recItem.GET('1-FSV-00001');

        //getConsoMoy15D(recItem);
        Message('%1', getStockAtDate('8-FLM-00061', 20250130D));
    end;

    [Scope('OnPrem')]
    procedure getInventory(Item: Record Item) Retour: Decimal
    begin
        Item.SetFilter("Location Filter", '');
        Item.CalcFields(Inventory);
        Retour := Item.Inventory;
    end;

    [Scope('OnPrem')]
    procedure getInventoryEC(Item: Record Item) Retour: Decimal
    begin
        Item.SetFilter("Location Filter", 'ECCONGEL|EC DORMA|EC TOURNAI|EC MP|MP|EC STOCK');
        Item.CalcFields(Inventory);
        Retour := Item.Inventory;
    end;

    [Scope('OnPrem')]
    procedure getInventoryTft(Item: Record Item) Retour: Decimal
    begin
        Item.SetFilter("Location Filter", '9-TFT');
        Item.CalcFields(Inventory);
        Retour := Item.Inventory;
    end;

    [Scope('OnPrem')]
    procedure getInventoryBlocked(Item: Record Item) Retour: Decimal
    var
        LotInfo: Record "Lot No. Information";
    begin
        LotInfo.Reset;
        LotInfo.SetRange("Item No.", Item."No.");
        LotInfo.SetRange(Blocked, true);
        LotInfo.SetFilter(Inventory, '>0');

        Retour := 0;
        if LotInfo.FindSet then
            repeat
                LotInfo.CalcFields(Inventory);
                Retour := Retour + LotInfo.Inventory;
            until LotInfo.Next = 0;

        LotInfo.Reset;
        LotInfo.SetRange("Item No.", Item."No.");
        LotInfo.SetFilter("Lot No.", 'DECLAS*');
        LotInfo.SetFilter(Inventory, '>0');

        if LotInfo.FindSet then
            repeat
                LotInfo.CalcFields(Inventory);
                Retour := Retour + LotInfo.Inventory;
            until LotInfo.Next = 0;
    end;

    [Scope('OnPrem')]
    procedure getInventoryBlockedCongel(Item: Record Item) Retour: Decimal
    var
        LotInfo: Record "Lot No. Information";
    begin
        LotInfo.Reset;
        LotInfo.SetRange("Item No.", Item."No.");
        LotInfo.SetRange(Blocked, true);
        LotInfo.SetFilter(Inventory, '>0');
        LotInfo.SetRange("Location Filter", 'ECCONGEL');
        Retour := 0;
        if LotInfo.FindSet then
            repeat
                LotInfo.CalcFields(Inventory);
                Retour := Retour + LotInfo.Inventory;
            until LotInfo.Next = 0;

        LotInfo.Reset;
        LotInfo.SetRange("Item No.", Item."No.");
        LotInfo.SetFilter("Lot No.", 'DECLAS*');
        LotInfo.SetFilter(Inventory, '>0');
        LotInfo.SetRange("Location Filter", 'ECCONGEL');

        if LotInfo.FindSet then
            repeat
                LotInfo.CalcFields(Inventory);
                Retour := Retour + LotInfo.Inventory;
            until LotInfo.Next = 0;
    end;

    [Scope('OnPrem')]
    procedure getInventoryOnSales(Item: Record Item) Retour: Decimal
    var
        SalesL: Record "Sales Line";
        Qty: Decimal;
    begin
        Qty := 0;
        SalesL.Reset;
        SalesL.SetRange("No.", Item."No.");
        SalesL.SetFilter("Promised Delivery Date", '%1', 0D);
        SalesL.SetFilter("Qty. to Ship (Base)", '>0');
        if SalesL.FindSet then
            repeat
                Qty += SalesL."Qty. to Ship (Base)";
            until SalesL.Next = 0;
        exit(Qty);
    end;

    [Scope('OnPrem')]
    procedure getInventoryOnSalesConfirmed(Item: Record Item): Decimal
    var
        SalesL: Record "Sales Line";
        Qty: Decimal;
    begin
        Qty := 0;
        SalesL.Reset;
        SalesL.SetRange("No.", Item."No.");
        SalesL.SetFilter("Promised Delivery Date", '<>%1', 0D);
        SalesL.SetFilter("Qty. to Ship (Base)", '>0');
        if SalesL.FindSet then
            repeat
                Qty += SalesL."Qty. to Ship (Base)";
            until SalesL.Next = 0;
        exit(Qty);
    end;

    [Scope('OnPrem')]
    procedure getInventoryOnPurchase(Item: Record Item) Retour: Decimal
    begin
        Item.SetFilter("Location Filter", '');
        Item.CalcFields("Qty. on Purch. Order");
        Retour := Item."Qty. on Purch. Order";
    end;

    [Scope('OnPrem')]
    procedure getInventoryOnOF(Item: Record Item) Retour: Decimal
    begin
        Item.SetFilter("Location Filter", '');
        Item.CalcFields("Qty. on Prod. Order");
        Item.SetFilter("Date Filter", '%1..', Today);
        Retour := Item."Qty. on Prod. Order";
    end;

    [Scope('OnPrem')]
    procedure getInventoryOnComponent(Item: Record Item) Retour: Decimal
    begin
        Item.SetFilter("Location Filter", '');
        Item.SetFilter("Date Filter", '%1..', CalcDate('<-15D>', Today));
        Item.CalcFields("Qty. on Component Lines");
        Retour := Item."Qty. on Component Lines";
    end;

    [Scope('OnPrem')]
    procedure showInventory(Item: Record Item) Retour: Decimal
    var
        ItemLedg: Record "Item Ledger Entry";
    begin
        ItemLedg.Reset;
        ItemLedg.SetRange("Item No.", Item."No.");
        ItemLedg.SetFilter(ItemLedg."Remaining Quantity", '<>0');
        PAGE.Run(38, ItemLedg);
    end;

    [Scope('OnPrem')]
    procedure showInventoryEC(Item: Record Item) Retour: Decimal
    var
        ItemLedg: Record "Item Ledger Entry";
    begin
        ItemLedg.Reset;
        ItemLedg.SetRange("Item No.", Item."No.");
        ItemLedg.SetFilter("Location Code", 'ECCONGEL|EC DORMA|EC TOURNAI|EC MP|MP');
        ItemLedg.SetFilter(ItemLedg."Remaining Quantity", '<>0');
        PAGE.Run(38, ItemLedg);
    end;

    [Scope('OnPrem')]
    procedure showInventoryBlocked(Item: Record Item) Retour: Decimal
    var
        LotInfo: Record "Lot No. Information";
    begin
        LotInfo.Reset;
        LotInfo.SetRange("Item No.", Item."No.");
        LotInfo.SetRange(Blocked, true);
        LotInfo.SetFilter(Inventory, '>0');
        PAGE.Run(6508, LotInfo);
    end;

    [Scope('OnPrem')]
    procedure showInventoryOnSales(Item: Record Item) Retour: Decimal
    var
        SalesL: Record "Sales Line";
    begin
        SalesL.Reset;
        SalesL.SetRange(Type, SalesL.Type::Item);
        SalesL.SetRange("No.", Item."No.");
        SalesL.SetFilter("Outstanding Quantity", '>0');
        PAGE.Run(516, SalesL);
    end;

    [Scope('OnPrem')]
    procedure showInventoryOnPurchase(Item: Record Item) Retour: Decimal
    var
        PurchL: Record "Purchase Line";
    begin
        PurchL.Reset;
        PurchL.SetRange(Type, PurchL.Type::Item);
        PurchL.SetRange("No.", Item."No.");
        PurchL.SetFilter("Qty. to Receive", '>0');
        PAGE.Run(50084, PurchL)
    end;

    [Scope('OnPrem')]
    procedure showInventoryOnOF(Item: Record Item) Retour: Decimal
    var
        ProdL: Record "Prod. Order Line";
    begin
        ProdL.Reset;
        ProdL.SetRange("Item No.", Item."No.");
        ProdL.SetFilter("Remaining Quantity", '>0');
        ProdL.SetFilter("Due Date", '%1..', Today);
        PAGE.Run(5406, ProdL);
    end;

    [Scope('OnPrem')]
    procedure showInventoryOnComponent(Item: Record Item) Retour: Decimal
    var
        CompL: Record "Prod. Order Component";
    begin
        CompL.Reset;
        CompL.SetRange("Item No.", Item."No.");
        CompL.SetFilter("Remaining Quantity", '>0');
        CompL.SetFilter("Due Date", '%1..', CalcDate('<-3D>', Today));
        PAGE.Run(5407, CompL);
    end;

    [Scope('OnPrem')]
    procedure showInventoryOnSalesConfirmed(Item: Record Item) Retour: Decimal
    var
        SalesL: Record "Sales Line";
    begin
        SalesL.Reset;
        SalesL.SetRange(Type, SalesL.Type::Item);
        SalesL.SetRange("No.", Item."No.");
        SalesL.SetFilter("Outstanding Quantity", '>0');
        SalesL.SetFilter("Promised Delivery Date", '<>%1', 0D);
        SalesL.SetFilter("Location Code", '<>RD');
        PAGE.Run(516, SalesL);
    end;

    [Scope('OnPrem')]
    procedure getPlanningStock(recItem: Record Item; PeriodStart: Date; PeriodEnd: Date; Show: Boolean): Decimal
    var
        T32: Record "Item Ledger Entry";
    begin
        if Show then begin
            T32.Reset;
            T32.SetRange("Item No.", recItem."No.");
            T32.SetRange(Open, true);
            if T32.FindFirst then
                PAGE.Run(0, T32);
        end
        else begin
            recItem.SetRange("Date Filter", 20010101D, 20491231D);
            recItem.CalcFields(Inventory);
            exit(recItem.Inventory);
        end;
    end;

    [Scope('OnPrem')]
    procedure getPlanningVentes(recItem: Record Item; PeriodStart: Date; PeriodEnd: Date; Show: Boolean): Decimal
    var
        T37: Record "Sales Line";
    begin
        if Show then begin
            T37.Reset;
            T37.SetRange("Document Type", T37."Document Type"::Order);
            T37.SetRange(Type, T37.Type::Item);
            T37.SetRange("No.", recItem."No.");
            T37.SetRange("Shipment Date", PeriodStart, PeriodEnd);
            if T37.FindFirst then
                PAGE.Run(0, T37);
        end
        else begin
            recItem.SetRange("Date Filter", PeriodStart, PeriodEnd);
            recItem.CalcFields("Qty. on Sales Order");
            exit(recItem."Qty. on Sales Order");
        end;
    end;

    [Scope('OnPrem')]
    procedure getPlanningVentesConsommees(recItem: Record Item; PeriodStart: Date; PeriodEnd: Date; Show: Boolean): Decimal
    var
        T37: Record "Sales Line";
    begin
        if Show then begin
            T37.Reset;
            T37.SetRange("Document Type", T37."Document Type"::Order);
            T37.SetRange(Type, T37.Type::Item);
            T37.SetRange("No.", recItem."No.");
            T37.SetRange("Shipment Date", CalcDate('<-3D>', Today), CalcDate('<-1D>', PeriodEnd));
            if T37.FindFirst then
                PAGE.Run(0, T37);
        end
        else begin
            recItem.SetRange("Date Filter", CalcDate('<-3D>', Today), CalcDate('<-1D>', PeriodEnd));
            recItem.CalcFields("Qty. on Sales Order");
            exit(recItem."Qty. on Sales Order");
        end;
    end;

    [Scope('OnPrem')]
    procedure getPlanningCommandesAchats(recItem: Record Item; PeriodStart: Date; PeriodEnd: Date; Show: Boolean): Decimal
    var
        T39: Record "Purchase Line";
    begin
        if Show then begin
            T39.Reset;
            T39.SetRange("Document Type", T39."Document Type"::Order);
            T39.SetRange(Type, T39.Type::Item);
            T39.SetRange("No.", recItem."No.");
            T39.SetRange("Expected Receipt Date", CalcDate('<-3D>', Today), PeriodEnd);
            if T39.FindFirst then
                PAGE.Run(0, T39);
        end
        else begin
            recItem.SetRange("Date Filter", CalcDate('<-3D>', Today), PeriodEnd);
            recItem.CalcFields("Qty. on Purch. Order");
            exit(recItem."Qty. on Purch. Order");
        end;
    end;

    [Scope('OnPrem')]
    procedure getPlanningProduction(recItem: Record Item; PeriodStart: Date; PeriodEnd: Date; Show: Boolean): Decimal
    var
        T5406: Record "Prod. Order Line";
    begin
        if Show then begin
            T5406.Reset;
            T5406.SetFilter(Status, '%1..%2', T5406.Status::Planned, T5406.Status::Released);
            T5406.SetRange("Item No.", recItem."No.");
            T5406.SetRange("Due Date", Today, PeriodEnd);
            if T5406.FindFirst then
                PAGE.Run(0, T5406);
        end
        else begin
            recItem.SetRange("Date Filter", Today, PeriodEnd);
            recItem.CalcFields("Qty. on Prod. Order");
            exit(recItem."Qty. on Prod. Order");
        end;
    end;

    [Scope('OnPrem')]
    procedure getPlanningMinimum(recItem: Record Item): Decimal
    begin
        exit(recItem."Reorder Point");
    end;

    [Scope('OnPrem')]
    procedure getPlanningMoy3(recItem: Record Item; Show: Boolean): Decimal
    var
        T111: Record "Sales Shipment Line";
    begin
        if Show then begin
            T111.Reset;
            T111.SetRange(Type, T111.Type::Item);
            T111.SetRange("No.", recItem."No.");
            T111.SetRange("Shipment Date", CalcDate('<-3M>', Today), Today);
            if T111.FindFirst then
                PAGE.Run(0, T111);
        end
        else begin
            recItem.SetRange("Date Filter", CalcDate('<-3M>', Today), Today);
            recItem.CalcFields("Sales (Qty.)");
            exit(Round(recItem."Sales (Qty.)" / 3, 1, '='));
        end;
    end;

    [Scope('OnPrem')]
    procedure getPlanningMoy12(recItem: Record Item; Show: Boolean): Decimal
    var
        T111: Record "Sales Shipment Line";
    begin
        if Show then begin
            T111.Reset;
            T111.SetRange(Type, T111.Type::Item);
            T111.SetRange("No.", recItem."No.");
            T111.SetRange("Shipment Date", CalcDate('<-12M>', Today), Today);
            if T111.FindFirst then
                PAGE.Run(0, T111);
        end
        else begin
            recItem.SetRange("Date Filter", CalcDate('<-12M>', Today), Today);
            recItem.CalcFields("Sales (Qty.)");
            exit(Round(recItem."Sales (Qty.)" / 12, 1, '='));
        end;
    end;

    [Scope('OnPrem')]
    procedure getPlanningPrev(recItem: Record Item): Decimal
    begin
        exit(recItem.PrevisionVenteMensuelle);
    end;

    [Scope('OnPrem')]
    procedure getIntermediaireNo(recItem: Record Item): Code[20]
    var
        "5_no": Code[40];
        BomL: Record "Production BOM Line";
        VersionMgt: Codeunit VersionManagement;
    begin
        "5_no" := '';

        BomL.Reset;
        BomL.SetRange("Production BOM No.", recItem."Production BOM No.");
        BomL.SetRange("Version Code", VersionMgt.GetBOMVersion(recItem."Production BOM No.", Today, true));
        BomL.SetFilter("No.", '5-F*|4-*');
        //IF BomL.FINDSET THEN
        //REPEAT
        if BomL.FindFirst then
            "5_no" := "5_no" + BomL."No.";
        // UNTIL BomL.NEXT=0;
        exit(CopyStr("5_no", 1, 20));
    end;

    [Scope('OnPrem')]
    procedure getIntermediaireStock(recItem: Record Item; DateStock: Date): Decimal
    var
        recInterm: Record Item;
        Stock: Decimal;
        LotInfo: Record "Lot No. Information";
        WhereUsed: Codeunit "Where-Used Management";
        WhereUsedLine: Record "Where-Used Line";
        SalesL: Record "Sales Line";
    begin
        if (DateStock <> 0D) and recInterm.Get(getIntermediaireNo(recItem)) then begin
            recInterm.CalcFields(Inventory);
            Stock := recInterm.Inventory;

            LotInfo.Reset;
            LotInfo.SetRange("Item No.", recInterm."No.");
            LotInfo.SetRange(Blocked, true);
            if LotInfo.FindSet then
                repeat
                    LotInfo.CalcFields(Inventory);
                    Stock -= LotInfo.Inventory;
                until LotInfo.Next = 0;

            LotInfo.Reset;
            LotInfo.SetRange("Item No.", recInterm."No.");
            LotInfo.SetFilter("Lot No.", 'DECLAS*');
            LotInfo.SetFilter(Inventory, '>0');

            if LotInfo.FindSet then
                repeat
                    LotInfo.CalcFields(Inventory);
                    Stock -= LotInfo.Inventory;
                until LotInfo.Next = 0;


            recItem.SetRange("Date Filter", CalcDate('<-15D>', Today), DateStock);
            recItem.CalcFields("Qty. on Component Lines");
            Stock -= recItem."Qty. on Component Lines";

            if StrPos(recInterm."No.", '5-FSV') > 0 then
                recItem.SetRange("Date Filter", CalcDate('<-15D>', Today), CalcDate('<-1D>', DateStock))
            else
                recItem.SetRange("Date Filter", CalcDate('<-15D>', Today), DateStock);
            recItem.CalcFields("Qty. on Prod. Order");
            Stock += recItem."Qty. on Prod. Order";
        end;

        if StrPos(recInterm."No.", '5-FSV') > 0 then begin
            WhereUsed.WhereUsedFromItem(recItem, Today, false);
            while (WhereUsed.NextRecord(1, WhereUsedLine) <> 0) do begin
                if (CopyStr(WhereUsedLine."Item No.", 1, 1) = '1') then begin
                    SalesL.Reset;
                    SalesL.SetRange("No.", WhereUsedLine."Item No.");
                    SalesL.SetFilter("Promised Delivery Date", '<>''''');
                    if SalesL.FindSet then
                        repeat
                            Stock -= SalesL."Qty. to Ship (Base)";
                        until SalesL.Next = 0;
                end;
            end;
        end;

        exit(Stock);
    end;

    [Scope('OnPrem')]
    procedure ShowIntermediaireStock(RecItem: Record Item)
    var
        p: Page "Production Planning Item";
    begin
        p.SetItemNo(getIntermediaireNo(RecItem));
        p.Run();
    end;

    [Scope('OnPrem')]
    procedure getStockAtDate(ItemNo: Code[20]; Dt: Date): Decimal
    var
        SalesL: Record "Sales Line";
        PurchL: Record "Purchase Line";
        Qty: Decimal;
        recItem: Record Item;
        T5406: Record "Prod. Order Line";
        ILE: Record "Item Ledger Entry";
        Lot: Record "Lot No. Information";
        bloque: Decimal;
    begin
        recItem.Get(ItemNo);
        ILE.Reset;
        ILE.SetRange("Item No.", ItemNo);
        ILE.SetFilter("Remaining Quantity", '>0');
        ILE.SetFilter("Location Code", 'ECCONGEL|EC TOURNAI|EC STOCK');
        if ILE.FindSet then
            repeat
                ILE.CalcFields("Lot bloque");
                if ILE."Lot bloque" then begin
                    Lot.Reset;
                    Lot.SetRange(Blocked, true);
                    Lot.SetRange("Item No.", ItemNo);
                    Lot.SetRange("Lot No.", ILE."Lot No.");
                    Lot.SetFilter("Commentaire blocage", 'Viande pas assez congel*');
                    if Lot.FindFirst then
                        if ILE."Posting Date" <= CalcDate('<-4D>', Dt) then
                            Qty += ILE."Remaining Quantity";
                    Lot.SetFilter("Commentaire blocage", '*résultats d''analyse*');
                    if Lot.FindFirst then
                        if ILE."Posting Date" <= CalcDate('<-7D>', Dt) then
                            Qty += ILE."Remaining Quantity";
                end
                else begin
                    Qty += ILE."Remaining Quantity";
                end;
                bloque += ILE."Remaining Quantity";
            until ILE.Next = 0;

        bloque := bloque - Qty;

        SalesL.Reset;
        SalesL.SetRange("No.", ItemNo);
        SalesL.SetFilter("Promised Delivery Date", '<>%1&<=%2', 0D, Dt);
        SalesL.SetFilter("Qty. to Ship (Base)", '>0');
        SalesL.SetRange("Location Code", 'ECONCGEL|EC TOURNAI');
        if SalesL.FindSet then
            repeat
                Qty += -SalesL."Qty. to Ship (Base)";
            until SalesL.Next = 0;

        recItem.SetRange("Date Filter", CalcDate('<-3D>', Today), CalcDate('<-1D>', Dt));
        recItem.CalcFields("Qty. on Purch. Order");
        Qty += recItem."Qty. on Purch. Order";

        T5406.Reset;
        T5406.SetFilter(Status, '%1..%2', T5406.Status::Planned, T5406.Status::Released);
        T5406.SetRange("Item No.", recItem."No.");
        if recItem."Comment blocage lots produits" <> '' then
            T5406.SetRange("Due Date", CalcDate('<-1D>', Today), CalcDate('<-10D>', Dt))
        else
            T5406.SetRange("Due Date", CalcDate('<-1D>', Today), CalcDate('<-1D>', Dt));
        if T5406.FindSet then
            repeat
                Qty += T5406."Quantity (Base)";
            until T5406.Next = 0;
        //DG1807
        recItem.SetRange("Date Filter", CalcDate('<-15D>', Today), Dt);
        recItem.CalcFields("Qty. on Component Lines");

        if (bloque < recItem."Qty. on Component Lines") then
            Qty -= (recItem."Qty. on Component Lines" - bloque);
        //Decompte bloqué
        exit(Qty);
    end;

    [Scope('OnPrem')]
    procedure getConsoMoy15D(recItem: Record Item): Decimal
    var
        recInterm: Record Item;
    begin
        if recInterm.Get(getIntermediaireNo(recItem)) then begin

            recInterm.SetFilter("Date Filter", '%1..%2', CalcDate('<-21D+CW>', Today), CalcDate('<-21D+CW+14D>', Today));
            recInterm.CalcFields("Conso Moy Period");
            //   MESSAGE('%1    %2',recInterm."No.");
            exit(recInterm."Conso Moy Period");
        end;
    end;

    [Scope('OnPrem')]
    procedure getInventoryCongel(Item: Record Item) Retour: Decimal
    begin
        Item.SetFilter("Location Filter", 'ECCONGEL');
        Item.CalcFields(Inventory);
        Retour := Item.Inventory;
    end;

    [Scope('OnPrem')]
    procedure getInventoryOnOFAtDate(Item: Record Item; Dt: Date) Retour: Decimal
    var
        ProdL: Record "Prod. Order Line";
    begin
        //Item.SETFILTER("Date Filter",'%1..%2',CALCDATE('<-15D>',TODAY),CALCDATE('<-1D>',Dt));
        //Item.CALCFIELDS("Qty. on Prod. Order");
        Retour := Item."Qty. on Prod. Order";
        Retour := 0;
        ProdL.Reset;
        ProdL.SetRange("Item No.", Item."No.");
        if Item."Raison blocage" <> '' then
            ProdL.SetRange("Due Date", Today, CalcDate('<-' + Format(Item."Delai mise à dispo") + 'D>', Dt))
        else
            ProdL.SetRange("Due Date", Today, CalcDate('<-1D>', Dt));

        if ProdL.FindSet then
            repeat
                Retour := Retour + ProdL."Remaining Qty. (Base)";
            until ProdL.Next = 0;
    end;

    [Scope('OnPrem')]
    procedure getInventoryOnSalesConfirmedCongel(Item: Record Item): Decimal
    var
        SalesL: Record "Sales Line";
        Qty: Decimal;
    begin
        Qty := 0;
        SalesL.Reset;
        SalesL.SetRange("No.", Item."No.");
        SalesL.SetFilter("Promised Delivery Date", '<>%1', 0D);
        SalesL.SetFilter("Qty. to Ship (Base)", '>0');
        SalesL.SetRange("Location Code", 'ECCONGEL');
        if SalesL.FindSet then
            repeat
                Qty += SalesL."Qty. to Ship (Base)";
            until SalesL.Next = 0;
        exit(Qty);
    end;

    [Scope('OnPrem')]
    procedure getInventoryOnSalesCongel(Item: Record Item) Retour: Decimal
    var
        SalesL: Record "Sales Line";
        Qty: Decimal;
    begin
        Qty := 0;
        SalesL.Reset;
        SalesL.SetRange("No.", Item."No.");
        SalesL.SetFilter("Promised Delivery Date", '%1', 0D);
        SalesL.SetFilter("Qty. to Ship (Base)", '>0');
        SalesL.SetRange("Location Code", 'ECCONGEL');
        if SalesL.FindSet then
            repeat
                Qty += SalesL."Qty. to Ship (Base)";
            until SalesL.Next = 0;
        exit(Qty);
    end;

    [Scope('OnPrem')]
    procedure getInventoryOnSalesConfirmedCongelAtDate(Item: Record Item; Dt: Date): Decimal
    var
        SalesL: Record "Sales Line";
        Qty: Decimal;
    begin
        Qty := 0;
        SalesL.Reset;
        SalesL.SetRange("No.", Item."No.");
        SalesL.SetFilter("Promised Delivery Date", '<>%1&<=%2', 0D, Dt);
        SalesL.SetFilter("Qty. to Ship (Base)", '>0');
        SalesL.SetRange("Location Code", 'ECCONGEL');
        if SalesL.FindSet then
            repeat
                Qty += SalesL."Qty. to Ship (Base)";
            until SalesL.Next = 0;
        exit(Qty);
    end;
}

