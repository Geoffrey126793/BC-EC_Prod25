codeunit 50032 "Stats OF"
{

    trigger OnRun()
    begin
        Get();
        //UpdateCost();
    end;

    var
        Stats: Record "Stats OF";
        OFl: Record "Prod. Order Line";
        dlg: Dialog;
        iC: Integer;
        iCount: Integer;
        Items: Record Item;
        CuProd: Codeunit "Integration Tft and Prod";
        Items2: Record Item;
        Log: Text;
        CRLF: Text[2];

    [Scope('OnPrem')]
    procedure Get()
    var
        Loop: Integer;
    begin
        CRLF[1] := 10;
        if GuiAllowed then dlg.Open('@1@@@@@@@@@@@@@@@@@@\#2##############\@3@@@@@@@@@@@@@@@@@@');
        OFl.Reset;
        OFl.SetCurrentKey("Starting Date", "Finished Qty. (Base)");
        OFl.SetRange("Starting Date", CalcDate('<-2M>', Today), CalcDate('<-1D>', Today));
        //OFl.SETRANGE("Starting Date",010125D,240126D);
        //OFl.SETRANGE("Starting Date",010125D,311225D);
        //OFl.SETRANGE("Item No.",'5-FRS-10051');
        //OFl.SETRANGE("Prod. Order No.",'WB-00714162');
        //OFl.SETFILTER("Prod. Order No.",'%1|%2','WB-00577383','WB-00577961');
        //OFl.SETFILTER("Prod. Order No.",'%1|%2|%3|%4','WB-00576169','WB-00576281','WB-00576272','WB-00575766');
        //OFl.SETRANGE("Line No.",60000);
        if OFl.FindSet then
            repeat
                Stats.Reset;
                Stats.SetRange("OF", OFl."Prod. Order No." + '-' + Format(OFl."Line No."));
                Stats.DeleteAll;
            until OFl.Next = 0;

        OFl.SetFilter("Finished Qty. (Base)", '>0');


        //OFl.SETCURRENTKEY(Status,"Prod. Order No.","Line No.");
        //OFl.ASCENDING(FALSE);

        for Loop := 1 to 5 do begin
            if Loop = 1 then OFl.SetFilter("Item No.", '5-CRU*');
            if Loop = 2 then OFl.SetFilter("Item No.", '5-MLX*');
            if Loop = 3 then OFl.SetFilter("Item No.", '5-FRS*');
            if Loop = 4 then OFl.SetFilter("Item No.", '5-*&<>5-CRU*&<>5-MLX*&<>5-FRS*');
            if Loop = 5 then OFl.SetFilter("Item No.", '<>5*');
            iCount := OFl.Count;
            iC := 1;
            if OFl.FindSet then
                repeat
                    //MESSAGE(OFl."Prod. Order No.");
                    if GuiAllowed then begin
                        dlg.Update(1, Round(iC / iCount * 10000, 1));
                        dlg.Update(2, OFl."Prod. Order No.");
                        dlg.Update(3, Loop);
                    end;
                    GetReel();
                    GetStandard();
                    //  GetAteliers();
                    GetNomenclStd();
                    GetNomenclOF();
                    iC := iC + 1;
                until OFl.Next = 0;
        end;

        if GuiAllowed then dlg.Close;
        Message(Log);
    end;

    [Scope('OnPrem')]
    procedure GetReel()
    var
        Level: Integer;
        StatsOF: Record "Stats OF";
    begin
        Level := 1;

        StatsOF.Init;
        StatsOF."OF" := OFl."Prod. Order No." + '-' + Format(OFl."Line No.");
        StatsOF.Date := OFl."Ending Date";
        StatsOF."Quantite produite" := OFl."Finished Qty. (Base)";
        StatsOF.Article := OFl."Item No.";
        StatsOF."Type source" := 'ARTICLE';
        StatsOF.source := OFl."Item No.";
        StatsOF.Niveau := Level;
        StatsOF."Quantité utilisee" := 0;
        StatsOF.Direction := 'PRODUCTION';
        StatsOF.Insert;

        StatsOF."Cout total" := getFromOF(OFl."Prod. Order No.", OFl."Line No.", Level, OFl."Finished Qty. (Base)", false);
        if StatsOF."Quantite produite" > 0 then
            StatsOF."Cout unitaire" := StatsOF."Cout total" / StatsOF."Quantite produite";
        StatsOF.Modify;
    end;

    [Scope('OnPrem')]
    procedure Update(ProdOrder: Code[20]; ProdLine: Integer)
    begin
        Stats.Reset;
        Stats.SetRange("OF", ProdOrder + '-' + Format(ProdLine));
        Stats.DeleteAll;

        OFl.Reset;
        OFl.SetRange("Prod. Order No.", ProdOrder);
        OFl.SetRange("Line No.", ProdLine);
        if OFl.FindFirst then begin
            getFromOF(OFl."Prod. Order No.", OFl."Line No.", 1, OFl."Finished Qty. (Base)", false);
        end;
    end;

    [Scope('OnPrem')]
    procedure getFromOF(ProdOrder: Code[20]; ProdLine: Integer; Level: Integer; Quantite: Decimal; CruTrouve: Boolean): Decimal
    var
        CoutTotal: Decimal;
        ItemLedg: Record "Item Ledger Entry";
        ProdTotal: Decimal;
        StatsOFSrc: Record "Stats OF";
        StatsOF: Record "Stats OF";
        LastDt: Date;
        ItemLedg3: Record "Item Ledger Entry";
        ApplEntry: Record "Item Application Entry";
        Annule: Boolean;
        ItemLedg2: Record "Item Ledger Entry";
    begin
        //Log += ProdOrder + '  ' + FORMAT(Quantite) + CRLF;

        StatsOFSrc.Reset;
        StatsOFSrc.SetRange("OF", ProdOrder + '-' + Format(ProdLine));
        //StatsOFSrc.SETRANGE(Direction,'PRODUCTION');
        if StatsOFSrc.FindFirst and (Level > 1) then begin  //OF déjà traité
                                                            //MESSAGE('-- %1   %2',ProdOrder,Quantite);
            ProdTotal := StatsOFSrc."Quantite produite";
            StatsOFSrc.SetFilter(Direction, '<>PRODUCTION');
            //StatsOFSrc.SETFILTER("Quantité utilisee",'>0.01|<-0.01');
            if ProdTotal > 0 then
                if StatsOFSrc.FindSet then
                    repeat
                        if (Abs(StatsOFSrc."Quantité utilisee") > 0.01) or (Abs(StatsOFSrc."Quantité intermédiaire") > 0.01) or (Abs(StatsOFSrc."Quantité intermédiaire nom OF") > 0.01) then begin
                            //IF STRPOS(StatsOFSrc.source,'5-CRU') >0 THEN
                            //      MESSAGE(StatsOFSrc."OF"+'   '+StatsOFSrc.source+ '   '+FORMAT(StatsOFSrc."Quantité intermédiaire")+'   '+FORMAT(ABS(Quantite/ProdTotal)));
                            StatsOF.Reset;
                            StatsOF.SetRange("OF", OFl."Prod. Order No." + '-' + Format(OFl."Line No."));
                            StatsOF.SetRange(Date, OFl."Ending Date");
                            StatsOF.SetRange("Type source", StatsOFSrc."Type source");
                            StatsOF.SetRange(source, StatsOFSrc.source);
                            StatsOF.SetRange(source2, StatsOFSrc.source2);
                            StatsOF.SetRange(Niveau, StatsOFSrc.Niveau + Level - 1);
                            StatsOF.SetRange(Ecriture, StatsOFSrc.Ecriture);
                            if StatsOF.FindFirst then begin
                                StatsOF."Quantité utilisee" := StatsOF."Quantité utilisee" + StatsOFSrc."Quantité utilisee" * Abs(Quantite / ProdTotal);
                                StatsOF."Cout total" := StatsOF."Cout total" + StatsOFSrc."Cout total" * Abs(Quantite / ProdTotal);
                                StatsOF."Cout total standard" := StatsOF."Cout total standard" + StatsOFSrc."Cout total standard" * Abs(Quantite / ProdTotal);
                                CoutTotal := CoutTotal + StatsOFSrc."Cout total" * Abs(Quantite / ProdTotal);
                                StatsOF."Cout total nomenclature OF" := StatsOF."Cout total nomenclature OF" + StatsOFSrc."Cout total nomenclature OF" * Abs(Quantite / ProdTotal);
                                //StatsOF."Quantité nomenclature OF" :=  StatsOF."Quantité nomenclature OF"+ StatsOFSrc."Quantité nomenclature OF" * ABS(Quantite/ProdTotal);
                                StatsOF."Quantité nomenclature OF" := 0;
                                StatsOF."Quantité intermédiaire" := StatsOF."Quantité intermédiaire" + StatsOFSrc."Quantité intermédiaire" * Abs(Quantite / ProdTotal);

                                //     StatsOF."Quantité intermédiaire nom OF" := StatsOF."Quantité intermédiaire nom OF" + StatsOFSrc."Quantité intermédiaire nom OF" * ABS(Quantite/ProdTotal);
                                StatsOF.Modify;
                            end
                            else begin
                                StatsOF.Init;
                                StatsOF.TransferFields(StatsOFSrc, true);
                                StatsOF."OF" := OFl."Prod. Order No." + '-' + Format(OFl."Line No.");
                                StatsOF.Date := OFl."Ending Date";
                                StatsOF.Niveau := StatsOFSrc.Niveau + Level - 1;
                                StatsOF."Quantite produite" := OFl."Finished Qty. (Base)";
                                StatsOF.Article := OFl."Item No.";
                                StatsOF."Quantité utilisee" := StatsOFSrc."Quantité utilisee" * Abs(Quantite / ProdTotal);
                                StatsOF."Cout total" := StatsOFSrc."Cout total" * Abs(Quantite / ProdTotal);
                                StatsOF."Cout total standard" := StatsOFSrc."Cout total standard" * Abs(Quantite / ProdTotal);
                                StatsOF."Cout total nomenclature OF" := StatsOFSrc."Cout total nomenclature OF" * Abs(Quantite / ProdTotal);
                                StatsOF."Quantité nomenclature OF" := StatsOFSrc."Quantité nomenclature OF" * Abs(Quantite / ProdTotal);
                                StatsOF."Cout total nomencl std" := 0;
                                StatsOF."Quantité nomenclature" := 0;
                                StatsOF."Quantité nomenclature OF" := 0;
                                StatsOF."Quantité intermédiaire nomencl" := 0;
                                StatsOF."Quantité intermédiaire" := StatsOFSrc."Quantité intermédiaire" * Abs(Quantite / ProdTotal);
                                StatsOF."Quantité intermédiaire nom OF" := 0;
                                //StatsOF."Quantité intermédiaire nom OF" := StatsOFSrc."Quantité intermédiaire nom OF" * ABS(Quantite/ProdTotal);
                                CoutTotal := CoutTotal + StatsOF."Cout total";
                                if CruTrouve then
                                    StatsOF.Cru := false
                                else
                                    StatsOF.Cru := StatsOFSrc.Cru;
                                if (ProdOrder + '-' + Format(ProdLine)) <> StatsOF."OF" then  //Pour éviter le bouclage
                                    if StatsOF.Insert then;
                            end;
                        end;
                    until StatsOFSrc.Next = 0;

        end
        else begin

            if Level > 8 then exit(0);

            ProdTotal := 0;
            ItemLedg.Reset;
            ItemLedg.SetRange("Order Type", ItemLedg."Order Type"::Production);
            ItemLedg.SetRange("Order No.", ProdOrder);
            ItemLedg.SetRange("Order Line No.", ProdLine);
            ItemLedg.SetRange("Entry Type", ItemLedg."Entry Type"::Output);
            repeat
                ProdTotal := ProdTotal + ItemLedg.Quantity;
            //MESSAGE('%1   %2',ProdTotal,ItemLedg.Quantity);
            //ProdTotal := ProdTotal + ABS(ItemLedg.Quantity);
            until ItemLedg.Next = 0;


            if ProdTotal > 0 then begin
                GetABC(ProdOrder, ProdLine, Level, Abs(Quantite));

                ItemLedg.Reset;
                ItemLedg.SetRange("Order Type", ItemLedg."Order Type"::Production);
                ItemLedg.SetRange("Order No.", ProdOrder);
                ItemLedg.SetRange("Order Line No.", ProdLine);
                ItemLedg.SetRange("Entry Type", ItemLedg."Entry Type"::Consumption);
                // ItemLedg.SETFILTER(Quantity,'<0');  //Conso non corrigée

                if ItemLedg.FindSet then
                    repeat
                        //  MESSAGE('%1',ItemLedg."Lot No.");
                        //  MESSAGE('--%1',ItemLedg."Entry No.");
                        Annule := false;
                        ItemLedg2.Reset;
                        ItemLedg2.SetRange("Order Type", ItemLedg."Order Type"::Production);
                        ItemLedg2.SetRange("Order No.", ProdOrder);
                        ItemLedg2.SetRange("Order Line No.", ProdLine);
                        ItemLedg2.SetRange("Entry Type", ItemLedg."Entry Type"::Consumption);
                        ItemLedg2.SetRange(Quantity, -ItemLedg.Quantity);
                        ItemLedg2.SetRange("Lot No.", ItemLedg."Lot No.");
                        if ItemLedg2.FindFirst then begin
                            //  Annule := TRUE;
                            //MESSAGE('%1',ItemLedg."Entry No.");
                        end;
                        ApplEntry.Reset;
                        ApplEntry.SetRange("Outbound Item Entry No.", ItemLedg."Entry No.");
                        ApplEntry.SetRange(Quantity, -ItemLedg.Quantity);
                        if ApplEntry.FindFirst then
                            Annule := true;

                        if not Annule then begin // Annule
                                                 //  MESSAGE('%1',ItemLedg."Entry No.");
                            Items.Get(ItemLedg."Item No.");
                            ApplEntry.Reset;
                            ApplEntry.SetRange("Outbound Item Entry No.", ItemLedg."Entry No.");

                            if ApplEntry.FindSet then begin
                                repeat

                                    if ItemLedg2.Get(ApplEntry."Inbound Item Entry No.") then begin
                                        //MESSAGE('%1  -   %2    %3',ItemLedg."Entry No.",ApplEntry."Inbound Item Entry No.",ItemLedg2."Entry Type");
                                        if ((ItemLedg2."Entry Type" = ItemLedg2."Entry Type"::Output) or ((ItemLedg2."Entry Type" = ItemLedg2."Entry Type"::Consumption) and (ItemLedg2.Quantity > 0.01))) then begin

                                            if ItemLedg2."Entry Type" = ItemLedg2."Entry Type"::Consumption then begin
                                                //            ItemLedg2.Quantity := -ItemLedg2.Quantity;
                                            end;
                                            //MESSAGE('inter   %1  %2    %3',ItemLedg2."Entry No.", ItemLedg.Quantity,ApplEntry.Quantity/ItemLedg2.Quantity * Quantite/ProdTotal);
                                            //          Log += '00   - ' + FORMAT(ItemLedg2."Entry No.") + '  -  '+ FORMAT(ItemLedg.Quantity) + '  ' + FORMAT(-ApplEntry.Quantity)+' '+FORMAT(ItemLedg2.Quantity) +' ' + FORMAT(ProdTotal) + '     '+ FORMAT(Quantite)+CRLF;

                                            AddIntermediaire(ItemLedg2, Level, Abs(ApplEntry.Quantity / ItemLedg2.Quantity * Quantite / ProdTotal), CruTrouve);
                                            if ItemLedg2."Entry Type" = ItemLedg2."Entry Type"::Output then begin
                                                //   MESSAGE('%1',ItemLedg."Entry No.");
                                                //MESSAGE('11111');
                                                CoutTotal := CoutTotal + getFromOF(ItemLedg2."Order No.", ItemLedg2."Order Line No.", Level + 1, -ApplEntry.Quantity * Quantite / ProdTotal, IsCru(ItemLedg2."Item No."));
                                                //MESSAGE('%1',CoutTotal);
                                            end
                                            else begin
                                                ItemLedg3.Reset;
                                                ItemLedg3.SetRange("Entry Type", ItemLedg3."Entry Type"::Output);
                                                ItemLedg3.SetRange("Item No.", ItemLedg2."Item No.");
                                                ItemLedg3.SetRange("Lot No.", ItemLedg2."Lot No.");
                                                if ItemLedg3.FindFirst then
                                                    CoutTotal := CoutTotal + getFromOF(ItemLedg3."Order No.", ItemLedg3."Order Line No.", Level + 1, -ApplEntry.Quantity * Quantite / ProdTotal, IsCru(ItemLedg3."Item Category Code"));
                                            end;

                                        end
                                        else begin
                                            Items2.Get(ItemLedg2."Item No.");
                                            if ((ItemLedg2."Entry Type" = ItemLedg2."Entry Type"::Transfer) and (Items2.IsMfgItem)) then
                                                if not ItemLedg2.Get(GetOrigineEntry(ItemLedg2, 1)) then exit(0);
                                            if (ItemLedg2."Entry Type" = ItemLedg2."Entry Type"::Output) then begin
                                                //Log += '11   - ' + FORMAT(ItemLedg2."Entry No.") + '  -  '+ FORMAT(ItemLedg.Quantity) + '  ' + FORMAT(ApplEntry.Quantity)+' '+FORMAT(ItemLedg2.Quantity) +' ' + FORMAT(ProdTotal) + '     '+ FORMAT(Quantite)+CRLF;

                                                AddIntermediaire(ItemLedg2, Level, -ApplEntry.Quantity / ItemLedg2.Quantity * Quantite / ProdTotal, CruTrouve);
                                                CoutTotal := CoutTotal + getFromOF(ItemLedg2."Order No.", ItemLedg2."Order Line No.", Level + 1, -ApplEntry.Quantity * Quantite / ProdTotal, IsCru(ItemLedg2."Item No."));
                                            end
                                            else begin

                                                CoutTotal := CoutTotal + AddConsommation(ItemLedg2, Level, ApplEntry.Quantity / ItemLedg2.Quantity * Quantite / ProdTotal, CruTrouve);
                                                //MESSAGE('222 %1  %2   %3   %4',ApplEntry.Quantity,ItemLedg2.Quantity, Quantite,ProdTotal);
                                            end;
                                        end;
                                    end;
                                until ApplEntry.Next = 0;
                            end
                            else begin
                                //MESSAGE('conso   %1  %2',ItemLedg."Entry No.", ItemLedg.Quantity);
                                IF (ItemLedg.Quantity < 0) THEN BEGIN //DG031126 on ne prend pas les conso annul‚e, donc pas non plus l'annulation
                                    CoutTotal := CoutTotal + AddConsommation(ItemLedg, Level, ItemLedg.Quantity / ItemLedg.Quantity * Quantite / ProdTotal, CruTrouve);
                                END;
                            end;
                        end;//Annule
                    until ItemLedg.Next = 0;
            end;

        end;


        exit(CoutTotal);
    end;

    [Scope('OnPrem')]
    procedure AddConsommation(ItemLedg: Record "Item Ledger Entry"; Level: Integer; "Part": Decimal; CruTrouve: Boolean): Decimal
    var
        cout: Decimal;
    begin
        Part := -Part;
        ItemLedg.CalcFields("Cost Amount (Actual)");
        ItemLedg.CalcFields("Cost Amount (Expected)");
        if ItemLedg."Cost Amount (Actual)" <> 0 then
            cout := ItemLedg."Cost Amount (Actual)"
        else
            cout := ItemLedg."Cost Amount (Expected)";
        Stats.Reset;
        Stats.SetRange("OF", OFl."Prod. Order No." + '-' + Format(OFl."Line No."));
        Stats.SetRange(Date, OFl."Ending Date");
        Stats.SetRange("Type source", 'ARTICLE');
        Stats.SetRange(source, ItemLedg."Item No.");
        Stats.SetRange(Niveau, Level);
        Stats.SetRange(Ecriture, ItemLedg."Entry No.");
        if Stats.FindFirst then begin
            Stats."Quantité utilisee" := Stats."Quantité utilisee" + ItemLedg.Quantity * Part;
            Stats."Cout total" := Stats."Cout total" + cout * Part;
            if Stats."Quantité utilisee" <> 0 then
                Stats."Cout unitaire" := Stats."Cout total" / Stats."Quantité utilisee";
            Stats.Modify;
        end
        else begin
            Stats.Init;
            Stats."OF" := OFl."Prod. Order No." + '-' + Format(OFl."Line No.");
            Stats.Date := OFl."Ending Date";
            Stats."Quantite produite" := OFl."Finished Qty. (Base)";
            Stats.Article := OFl."Item No.";
            Stats.Cru := (IsCru(ItemLedg."Item No.") and not CruTrouve);
            Stats."Type source" := 'ARTICLE';
            Stats.source := ItemLedg."Item No.";
            Stats.Niveau := Level;
            Stats."Quantité utilisee" := ItemLedg.Quantity * Part;
            Stats."Cout total" := cout * Part;
            if Stats."Quantité utilisee" <> 0 then
                Stats."Cout unitaire" := Abs(Stats."Cout total" / Stats."Quantité utilisee");
            Stats.Lot := ItemLedg."Lot No.";
            Stats.Direction := 'CONSOMMATION';
            Stats.Ecriture := ItemLedg."Entry No.";
            if (Stats."Quantité utilisee" > 0.0001) or (Stats."Quantité utilisee" < -0.0001) then
                Stats.Insert;
        end;

        exit(cout * Part);
    end;

    [Scope('OnPrem')]
    procedure GetStandard()
    var
        TotalCost: Decimal;
    begin
        TotalCost := 0;
        Stats.Reset;
        Stats.SetRange("OF", OFl."Prod. Order No." + '-' + Format(OFl."Line No."));
        Stats.SetRange(Direction, 'CONSOMMATION');
        Stats.SetRange("Type source", 'ARTICLE');
        if Stats.FindSet then
            repeat
                Stats."Cout unitaire standard" := GetStandardCost(Stats.source, Stats.Date);
                Stats."Cout total standard" := Stats."Quantité utilisee" * Stats."Cout unitaire standard";
                TotalCost := TotalCost + Stats."Cout total standard";
                Stats.Modify(true);
            until Stats.Next = 0;

        Stats.Reset;
        Stats.SetRange("OF", OFl."Prod. Order No." + '-' + Format(OFl."Line No."));
        Stats.SetRange(Direction, 'PRODUCTION');
        if Stats.FindFirst then begin
            Stats."Cout total standard" := TotalCost;
            if Stats."Quantite produite" <> 0 then
                Stats."Cout unitaire standard" := TotalCost / Stats."Quantite produite";
            Stats.Modify;
        end;

        TotalCost := 0;
        Stats.Reset;
        Stats.SetRange("OF", OFl."Prod. Order No." + '-' + Format(OFl."Line No."));
        Stats.SetRange(Direction, 'CONSOMMATION');
        Stats.SetRange("Type source", 'ABC');
        if Stats.FindFirst then begin
            Stats."Cout unitaire nomencl std" := GetStandardABCCost(Stats.Article, Stats.Date);
            Stats."Cout total nomencl std" := Stats."Quantite produite" * Stats."Cout unitaire nomencl std";
            TotalCost := TotalCost + Stats."Cout total standard";
            Stats.Modify(true);
        end;
    end;

    [Scope('OnPrem')]
    procedure GetStandardCost(ItemNo: Code[20]; Date: Date): Decimal
    var
        Histo: Record "Histo couts";
    begin
        Histo.Reset;
        Histo.SetRange(Item, ItemNo);
        Histo.SetFilter(Date, '..%1', Date);
        Histo.SetFilter(Type, '<>%1', Histo.Type::ABC);
        if Histo.FindLast then
            exit(Histo.Cout);
    end;

    [Scope('OnPrem')]
    procedure GetStandardABCCost(ItemNo: Code[20]; Date: Date): Decimal
    var
        Histo: Record "Histo couts";
    begin
        Histo.Reset;
        Histo.SetRange(Item, ItemNo);
        Histo.SetRange(Type, Histo.Type::ABC);
        Histo.SetFilter(Date, '..%1', Date);
        if Histo.FindLast then begin
            exit(Histo.Cout)
        end
        else begin
            Histo.SetFilter(Date, '%1..', Date);
            if Histo.FindFirst then
                exit(Histo.Cout)
        end;
    end;

    [Scope('OnPrem')]
    procedure GetNomenclStd()
    var
        TotalCost: Decimal;
    begin
        TotalCost := GetNomenclature(OFl."Item No.", OFl."Finished Qty. (Base)", 1, 1, false);
        Stats.Reset;
        Stats.SetRange("OF", OFl."Prod. Order No." + '-' + Format(OFl."Line No."));
        Stats.SetRange(Direction, 'PRODUCTION');
        if Stats.FindFirst then begin
            Stats."Cout total nomencl std" := TotalCost;
            if Stats."Quantite produite" <> 0 then
                Stats."Cout unitaire nomencl std" := Stats."Cout total nomencl std" / Stats."Quantite produite";
            Stats.Modify;
        end;
    end;

    [Scope('OnPrem')]
    procedure GetNomenclature(Item: Code[20]; Quantite: Decimal; QtyPreviousLevel: Decimal; Level: Integer; CruTrouve: Boolean): Decimal
    var
        VersionMgt: Codeunit VersionManagement;
        CostCalcMgt: Codeunit "Cost Calculation Management";
        ProdBOMHeader: Record "Production BOM Header";
        ProdBOMVersion: Record "Production BOM Version";
        ProdBOMLine: Record "Production BOM Line";
        CompItemQtyBase: Decimal;
        Qty: Decimal;
        CoutTotal: Decimal;
    begin
        CoutTotal := 0;
        Items.Get(Item);
        if Items.IsMfgItem and (Items."Production BOM No." <> '') then begin
            ProdBOMLine.SetRange("Production BOM No.", Items."Production BOM No.");
            ProdBOMLine.SetRange("Version Code", VersionMgt.GetBOMVersion(Items."Production BOM No.", OFl."Ending Date", false));

            ProdBOMLine.SetFilter("Starting Date", '%1|..%2', 0D, OFl."Ending Date");
            ProdBOMLine.SetFilter("Ending Date", '%1|%2..', 0D, OFl."Ending Date");
            if ProdBOMLine.FindSet then
                repeat
                    CompItemQtyBase := CostCalcMgt.CalcCompItemQtyBase(
                      ProdBOMLine, OFl."Ending Date", CostCalcMgt.CalcQtyAdjdForBOMScrap(QtyPreviousLevel, Items."Scrap %"), Items."Routing No.", true);
                    if Items.Get(ProdBOMLine."No.") then
                        if Items.IsMfgItem then begin
                            AddIntermediaireNomenclature(Items."No.", CompItemQtyBase * Quantite, Level, CruTrouve);
                            CoutTotal := CoutTotal + GetNomenclature(Items."No.", Quantite, CompItemQtyBase, Level + 1, IsCru(Items."No."));
                        end
                        else begin
                            Qty := CostCalcMgt.CalcQtyAdjdForBOMScrap(Items."Lot Size", Items."Scrap %");
                            CoutTotal := CoutTotal + AddNomenclature(Items."No.", CompItemQtyBase * Quantite, Level, CruTrouve);
                            //    MESSAGE('%1   %2   %3   %4',Items."No.",CompItemQtyBase,Quantite,QtyPreviousLevel);
                        end;
                until ProdBOMLine.Next = 0;
        end;

        exit(CoutTotal);
    end;

    [Scope('OnPrem')]
    procedure AddNomenclature(Item: Code[20]; Qty: Decimal; Level: Integer; CruTrouve: Boolean): Decimal
    begin

        Stats.Reset;
        Stats.SetRange("OF", OFl."Prod. Order No." + '-' + Format(OFl."Line No."));
        Stats.SetRange(Date, OFl."Ending Date");
        Stats.SetRange("Type source", 'ARTICLE');
        Stats.SetRange(source, Item);
        Stats.SetRange(Niveau, Level);
        if Stats.FindFirst then begin
            Stats."Quantité nomenclature" := Stats."Quantité nomenclature" + Qty;
            Stats."Cout total nomencl std" := Stats."Cout total nomencl std" +
              Stats."Quantité nomenclature" * GetStandardCost(Item, OFl."Ending Date");
            if Stats."Quantité nomenclature" <> 0 then
                Stats."Cout unitaire nomencl std" := Stats."Cout total nomencl std" / Stats."Quantité nomenclature";
            Stats.Modify;
        end
        else begin
            Stats.Init;
            Stats."OF" := OFl."Prod. Order No." + '-' + Format(OFl."Line No.");
            Stats.Date := OFl."Ending Date";
            Stats."Quantite produite" := OFl."Finished Qty. (Base)";
            Stats.Article := OFl."Item No.";
            Stats."Type source" := 'ARTICLE';
            Stats.source := Item;
            Stats.Niveau := Level;
            Stats."Quantité nomenclature" := Qty;
            Stats."Cout total nomencl std" := Stats."Quantité nomenclature" * GetStandardCost(Item, OFl."Ending Date");
            if Stats."Quantité nomenclature" <> 0 then
                Stats."Cout unitaire nomencl std" := Stats."Cout total nomencl std" / Stats."Quantité nomenclature";
            Stats.Cru := (IsCru(Item) and not CruTrouve);

            Stats.Direction := 'CONSOMMATION';
            Stats.Insert;
        end;
        exit(Stats."Quantité nomenclature" * GetStandardCost(Item, OFl."Ending Date"));
    end;

    [Scope('OnPrem')]
    procedure GetOrigineEntry(ItemLedg: Record "Item Ledger Entry"; LevelTft: Integer): Integer
    var
        Appl: Record "Item Application Entry";
        EntryNo: Integer;
        Ledg: Record "Item Ledger Entry";
    begin
        if LevelTft > 100 then exit(0);

        Appl.Reset;
        Appl.SetRange("Inbound Item Entry No.", ItemLedg."Entry No.");
        if Appl.FindFirst then begin
            EntryNo := Appl."Outbound Item Entry No.";
            Appl.Reset;
            Appl.SetRange("Outbound Item Entry No.", EntryNo);
            if Appl.FindFirst then begin
                EntryNo := Appl."Inbound Item Entry No.";
                if Ledg.Get(EntryNo) then begin
                    if Ledg."Entry Type" = Ledg."Entry Type"::Transfer then
                        exit(GetOrigineEntry(Ledg, LevelTft + 1))
                    else
                        exit(Ledg."Entry No.");
                end;
            end;

        end;
    end;

    [Scope('OnPrem')]
    procedure AddIntermediaire(ItemLedg: Record "Item Ledger Entry"; Level: Integer; "Part": Decimal; CruTrouve: Boolean)
    var
        cout: Decimal;
    begin
        //MESSAGE('%1  %2  %3',ItemLedg."Item No.",ItemLedg.Quantity*ABS(Part),ItemLedg."Lot No.");
        Log += ItemLedg."Item No." + '   ' + Format(Part) + '      ' + Format(ItemLedg.Quantity) + '    ' + ItemLedg."Lot No." + CRLF;
        //Part := -Part;
        Stats.Reset;
        Stats.SetRange("OF", OFl."Prod. Order No." + '-' + Format(OFl."Line No."));
        Stats.SetRange(Date, OFl."Ending Date");
        Stats.SetRange("Type source", 'ARTICLE');
        Stats.SetRange(Direction, 'CONSOMMATION');
        Stats.SetRange(source, ItemLedg."Item No.");
        Stats.SetRange(Niveau, Level);

        if Stats.FindFirst then begin
            Log += Format(Stats."Quantité intermédiaire");
            Stats."Quantité intermédiaire" += ItemLedg.Quantity * Part;
            Log += '  ->  ' + Format(Stats."Quantité intermédiaire") + CRLF;
            Stats.Modify;
        end
        else begin
            Stats.Init;
            Stats."OF" := OFl."Prod. Order No." + '-' + Format(OFl."Line No.");
            Stats.Date := OFl."Ending Date";
            Stats."Quantite produite" := OFl."Finished Qty. (Base)";
            Stats.Article := OFl."Item No.";
            Stats.Cru := (IsCru(ItemLedg."Item No.") and not CruTrouve);
            Stats."Type source" := 'ARTICLE';
            Stats.source := ItemLedg."Item No.";
            Stats.Niveau := Level;
            Stats."Quantité intermédiaire" := ItemLedg.Quantity * Part;
            Stats.Direction := 'CONSOMMATION';
            Stats.Ecriture := ItemLedg."Entry No.";
            Stats.Insert;
        end;
    end;

    [Scope('OnPrem')]
    procedure AddIntermediaireNomenclature(Item: Code[20]; Qty: Decimal; Level: Integer; CruTrouve: Boolean)
    var
        cout: Decimal;
    begin


        Stats.Reset;
        Stats.SetRange("OF", OFl."Prod. Order No." + '-' + Format(OFl."Line No."));
        Stats.SetRange(Date, OFl."Ending Date");
        Stats.SetRange("Type source", 'ARTICLE');
        Stats.SetRange(source, Item);
        Stats.SetRange(Niveau, Level);
        if Stats.FindFirst then begin
            Stats."Quantité intermédiaire nomencl" += Qty;
            Stats.Modify;
        end
        else begin
            Stats.Init;
            Stats."OF" := OFl."Prod. Order No." + '-' + Format(OFl."Line No.");
            Stats.Date := OFl."Ending Date";
            Stats."Quantite produite" := OFl."Finished Qty. (Base)";
            Stats.Article := OFl."Item No.";
            Stats."Type source" := 'ARTICLE';
            Stats.source := Item;
            Stats.Cru := (IsCru(Item) and not CruTrouve);
            Stats.Niveau := Level;
            Stats."Quantité intermédiaire nomencl" := Qty;
            Stats.Direction := 'CONSOMMATION';
            Stats.Insert;
        end;
    end;

    [Scope('OnPrem')]
    procedure UpdateCost()
    var
        StatsProd: Record "Stats OF";
        StatsConso: Record "Stats OF";
        Cout: Decimal;
        ItemLedg: Record "Item Ledger Entry";
        CoutTotal: Decimal;
    begin
        if GuiAllowed then dlg.Open('@1@@@@@@@@@@@@@@@@@@\#2##############');
        StatsProd.Reset;
        StatsProd.SetRange(Date, CalcDate('-3M', Today), Today);
        //StatsProd.SETRANGE(Date,301018D,280219D);
        //StatsProd.SETRANGE(Date,010519D,310519D);
        //StatsProd.SETRANGE("OF",'WB-00576169-10000');
        StatsProd.SetRange(Direction, 'PRODUCTION');
        iCount := StatsProd.Count;
        iC := 1;

        if StatsProd.FindSet then
            repeat
                if GuiAllowed then
                    dlg.Update(1, Round(iC / iCount * 10000, 1));
                if GuiAllowed then
                    dlg.Update(2, StatsProd."OF");
                iC := iC + 1;

                CoutTotal := 0;
                StatsConso.Reset;
                StatsConso.SetRange(Direction, 'CONSOMMATION');
                StatsConso.SetRange("Type source", 'ARTICLE');
                StatsConso.SetRange("OF", StatsProd."OF");
                StatsConso.SetFilter("Quantité utilisee", '>0');
                if StatsConso.FindSet then
                    repeat
                        if ItemLedg.Get(StatsConso.Ecriture) then begin
                            ItemLedg.CalcFields("Cost Amount (Actual)");
                            ItemLedg.CalcFields("Cost Amount (Expected)");
                            if ItemLedg."Cost Amount (Actual)" <> 0 then
                                Cout := ItemLedg."Cost Amount (Actual)"
                            else
                                Cout := ItemLedg."Cost Amount (Expected)";
                            StatsConso."Cout unitaire" := Cout / ItemLedg.Quantity;
                            StatsConso."Cout total" := StatsConso."Quantité utilisee" * StatsConso."Cout unitaire";
                            StatsConso.Modify;
                        end;
                        CoutTotal += StatsConso."Cout total";
                    until StatsConso.Next = 0;
                StatsProd."Cout total" := CoutTotal;
                StatsProd."Cout unitaire" := StatsProd."Cout total" / StatsProd."Quantite produite";
                StatsProd.Modify;
            until StatsProd.Next = 0;
        if GuiAllowed then dlg.Close;
    end;

    [Scope('OnPrem')]
    procedure GetAteliers()
    var
        Matrice: Record "Ateliers Liens";
        Centres: Record "Work Center";
    begin
        Stats.Reset;
        Stats.SetRange("OF", OFl."Prod. Order No." + '-' + Format(OFl."Line No."));
        Stats.SetRange(Date, OFl."Ending Date");
        Stats.SetRange("Type source", 'ATELIERS');
        Stats.SetRange(Niveau, 1);
        Stats.DeleteAll;

        Centres.Reset;
        Centres.SetRange("Work Center Group Code", 'ATELIERS');
        if Centres.FindSet then
            repeat
                //IF (Centres."No." = '26_PI') THEN
                //      MESSAGE(OFl."Prod. Order No."+'-'+FORMAT(OFl."Line No.") + '  '+FORMAT(Matrice.Début));
                Matrice.Reset;
                Matrice.SetRange(Article, OFl."Item No.");
                Matrice.SetRange("Centre de charges", Centres."No.");
                Matrice.SetFilter(Début, '<=%1', OFl."Ending Date");
                Matrice.SetFilter(Fin, '%1|>=%2', 0D, OFl."Ending Date");
                if Matrice.FindLast then begin
                    if Matrice.Pondération <> 0 then begin
                        Stats.Reset;
                        Stats.Init;
                        Stats."OF" := OFl."Prod. Order No." + '-' + Format(OFl."Line No.");
                        Stats.Date := OFl."Ending Date";
                        Stats."Quantite produite" := OFl."Finished Qty. (Base)";
                        Stats.Article := OFl."Item No.";
                        Stats."Type source" := 'ATELIERS';
                        Stats.Niveau := 1;
                        Stats.Direction := 'CONSOMMATION';

                        Stats.source := Centres."No.";

                        Stats."Quantité nomenclature" := Matrice.Pondération * Stats."Quantite produite";
                        Stats."Cout unitaire nomencl std" := CuProd.WorkCenter_getMatriceCost(OFl."Ending Date", Centres);
                        Stats."Cout total nomencl std" := Stats."Quantité nomenclature" * Stats."Cout unitaire nomencl std";
                        //      MESSAGE(Stats."OF"+'  '+Stats.source+'  '+FORMAT( Stats.Date));

                        Stats.Insert;
                    end;
                end;
            until Centres.Next = 0;
    end;

    [Scope('OnPrem')]
    procedure GetABC(OrderNo: Code[20]; OrderLine: Integer; Level: Integer; Qty: Decimal)
    var
        ParamsABC: Record "ABC - Parametres" temporary;
        ProdL: Record "Prod. Order Line";
        ProdH: Record "Production Order";
    begin
        Stats.Reset;
        Stats.SetRange("OF", OFl."Prod. Order No." + '-' + Format(OFl."Line No."));
        Stats.SetRange(Date, OFl."Ending Date");
        Stats.SetRange("Type source", 'ABC');
        Stats.SetRange(Niveau, Level);
        Stats.DeleteAll;

        ProdL.Reset;
        ProdL.SetRange("Prod. Order No.", OrderNo);
        ProdL.SetRange("Line No.", OrderLine);
        if not ProdL.FindFirst then exit;


        CuProd.ABC_GetParameters(ParamsABC, ProdL."Production BOM No.", ProdL."Production BOM Version Code", ProdL."Starting Date");

        ParamsABC.Reset;

        if ParamsABC.FindSet then
            repeat
                Stats.Reset;
                Stats.SetRange("OF", OFl."Prod. Order No." + '-' + Format(OFl."Line No."));
                Stats.SetRange(Date, OFl."Ending Date");
                Stats.SetRange(Article, OFl."Item No.");
                Stats.SetRange("Type source", 'ABC');
                Stats.SetRange(Niveau, Level);
                Stats.SetRange(Direction, 'CONSOMMATION');
                Stats.SetRange(source, ParamsABC.Activity);
                Stats.SetRange(source2, ParamsABC.Ressource);
                if Stats.FindFirst then begin
                    Stats."Cout unitaire standard" += ParamsABC."Cout Kg";
                    Stats."Quantité nomenclature" += Qty;
                    Stats."Cout total standard" := Stats."Quantité nomenclature" * Stats."Cout unitaire standard";
                    //Stats."Quantité utilisee" += Stats."Cout total standard" / 30;
                    Stats."Quantité utilisee" += ParamsABC."Hr Prod Kg" * Qty;
                    if (ParamsABC.Unité <> ParamsABC.Unité::"Heure/Batch") then
                        Stats."Quantité nomenclature OF" += ParamsABC."Hr Prod Kg" * Qty;  //Heures sans setup
                    Stats.Modify;
                end
                else begin
                    Stats.Init;
                    Stats."OF" := OFl."Prod. Order No." + '-' + Format(OFl."Line No.");
                    Stats.Date := OFl."Ending Date";
                    Stats."Quantite produite" := OFl."Finished Qty. (Base)";
                    Stats.Article := OFl."Item No.";
                    Stats."Type source" := 'ABC';
                    Stats.Niveau := Level;
                    Stats.Direction := 'CONSOMMATION';
                    Stats.source := ParamsABC.Activity;
                    Stats.source2 := ParamsABC.Ressource;
                    Stats."Cout unitaire standard" := ParamsABC."Cout Kg";
                    Stats."Quantité nomenclature" := Qty;
                    Stats."Cout total standard" := Stats."Quantité nomenclature" * Stats."Cout unitaire standard";
                    //Stats."Quantité utilisee" := Stats."Cout total standard" / 30;
                    Stats."Quantité utilisee" := ParamsABC."Hr Prod Kg" * Qty;
                    if (ParamsABC.Unité <> ParamsABC.Unité::"Heure/Batch") then
                        Stats."Quantité nomenclature OF" := ParamsABC."Hr Prod Kg" * Qty;  //Heures sans setup
                    Stats.Insert;
                end;
            until ParamsABC.Next = 0;


        Stats.Reset;
        Stats.SetRange("OF", OFl."Prod. Order No." + '-' + Format(OFl."Line No."));
        Stats.SetRange(Date, OFl."Ending Date");
        Stats.SetRange("Type source", 'HR');
        Stats.SetRange(Niveau, Level);
        Stats.DeleteAll;

        ProdH.Reset;
        ProdH.SetRange("No.", OrderNo);
        if not ProdH.FindFirst then exit;
        Stats.Init;
        Stats."OF" := OFl."Prod. Order No." + '-' + Format(OFl."Line No.");
        Stats.Date := OFl."Ending Date";
        //Stats."Quantite produite" := OFl."Finished Qty. (Base)";
        Stats.Article := OFl."Item No.";
        Stats."Type source" := 'HR';
        Stats.Niveau := Level;
        Stats.Direction := 'CONSOMMATION';
        Stats.source := 'HR';
        Stats."Cout total direct ateliers" := ProdH."Temps total";
        Stats.Insert;
    end;

    [Scope('OnPrem')]
    procedure GetNomenclOF()
    var
        TotalCost: Decimal;
    begin
        TotalCost := GetNomenclatureOF(OFl."Item No.", OFl."Finished Qty. (Base)", 1, 1, OFl."Production BOM Version Code");
        Stats.Reset;
        Stats.SetRange("OF", OFl."Prod. Order No." + '-' + Format(OFl."Line No."));
        Stats.SetRange(Direction, 'PRODUCTION');
        if Stats.FindFirst then begin
            Stats."Cout total nomenclature OF" := TotalCost;
            if Stats."Quantite produite" <> 0 then
                Stats."Cout unitaire nomencl OF" := Stats."Cout total nomenclature OF" / Stats."Quantite produite";
            Stats.Modify;
        end;
    end;

    [Scope('OnPrem')]
    procedure GetNomenclatureOF(Item: Code[20]; Quantite: Decimal; QtyPreviousLevel: Decimal; Level: Integer; Version: Code[20]): Decimal
    var
        VersionMgt: Codeunit VersionManagement;
        CostCalcMgt: Codeunit "Cost Calculation Management";
        ProdBOMHeader: Record "Production BOM Header";
        ProdBOMVersion: Record "Production BOM Version";
        ProdBOMLine: Record "Production BOM Line";
        CompItemQtyBase: Decimal;
        Qty: Decimal;
        CoutTotal: Decimal;
    begin
        //MESSAGE('%1  %2',Item,Version);

        CoutTotal := 0;
        Items.Get(Item);
        if Items.IsMfgItem and (Items."Production BOM No." <> '') then begin
            ProdBOMLine.SetRange("Production BOM No.", Items."Production BOM No.");
            if Version = '' then
                Version := VersionMgt.GetBOMVersion(Items."Production BOM No.", OFl."Ending Date", false);
            ProdBOMLine.SetRange("Version Code", Version);

            ProdBOMLine.SetFilter("Starting Date", '%1|..%2', 0D, OFl."Ending Date");
            ProdBOMLine.SetFilter("Ending Date", '%1|%2..', 0D, OFl."Ending Date");
            if ProdBOMLine.FindSet then
                repeat
                    CompItemQtyBase := CostCalcMgt.CalcCompItemQtyBase(
                      ProdBOMLine, OFl."Ending Date", CostCalcMgt.CalcQtyAdjdForBOMScrap(QtyPreviousLevel, Items."Scrap %"), Items."Routing No.", true);
                    if Items.Get(ProdBOMLine."No.") then
                        if Items.IsMfgItem then begin
                            AddIntermediaireNomenclatureOF(Items."No.", CompItemQtyBase * Quantite, Level);
                            CoutTotal := CoutTotal + GetNomenclatureOF(Items."No.", Quantite, CompItemQtyBase, Level + 1, '');
                        end
                        else begin
                            Qty := CostCalcMgt.CalcQtyAdjdForBOMScrap(Items."Lot Size", Items."Scrap %");
                            CoutTotal := CoutTotal;//
                            AddNomenclatureOF(Items."No.", CompItemQtyBase * Quantite, Level);
                            //    MESSAGE('%1   %2   %3   %4',Items."No.",CompItemQtyBase,Quantite,QtyPreviousLevel);
                        end;
                until ProdBOMLine.Next = 0;
        end;

        exit(CoutTotal);
    end;

    [Scope('OnPrem')]
    procedure AddNomenclatureOF(Item: Code[20]; Qty: Decimal; Level: Integer): Decimal
    begin

        Stats.Reset;
        Stats.SetRange("OF", OFl."Prod. Order No." + '-' + Format(OFl."Line No."));
        Stats.SetRange(Date, OFl."Ending Date");
        Stats.SetRange("Type source", 'ARTICLE');
        Stats.SetRange(source, Item);
        Stats.SetRange(Niveau, Level);
        if Stats.FindFirst then begin
            //MESSAGE('%1  %2',Stats.source,Stats."Quantité nomenclature OF");
            Stats."Quantité nomenclature OF" := Stats."Quantité nomenclature OF" + Qty;
            Stats."Cout total nomenclature OF" := Stats."Cout total nomenclature OF" +
              Stats."Quantité nomenclature OF" * GetStandardCost(Item, OFl."Ending Date");
            if Stats."Quantité nomenclature OF" <> 0 then
                Stats."Cout unitaire nomencl OF" := Stats."Cout total nomenclature OF" / Stats."Quantité nomenclature OF";
            // MESSAGE('%1  %2',Stats.source,Stats."Quantité nomenclature OF");
            Stats.Modify;
        end
        else begin
            Stats.Init;
            Stats."OF" := OFl."Prod. Order No." + '-' + Format(OFl."Line No.");
            Stats.Date := OFl."Ending Date";
            Stats."Quantite produite" := OFl."Finished Qty. (Base)";
            Stats.Article := OFl."Item No.";
            Stats."Type source" := 'ARTICLE';
            Stats.source := Item;
            Stats.Niveau := Level;
            Stats."Quantité nomenclature OF" := Qty;
            Stats."Cout total nomenclature OF" := Stats."Quantité nomenclature OF" * GetStandardCost(Item, OFl."Ending Date");
            if Stats."Quantité nomenclature OF" <> 0 then
                Stats."Cout unitaire nomencl OF" := Stats."Cout total nomenclature OF" / Stats."Quantité nomenclature OF";
            Stats.Direction := 'CONSOMMATION';
            Stats.Insert;

        end;

        exit(Stats."Quantité nomenclature OF" * GetStandardCost(Item, OFl."Ending Date"));
    end;

    [Scope('OnPrem')]
    procedure AddIntermediaireNomenclatureOF(Item: Code[20]; Qty: Decimal; Level: Integer)
    var
        cout: Decimal;
    begin
        //MESSAGE('++  %1    %2   %3    %4',Item,Qty,Level,OFl."Prod. Order No.");

        Stats.Reset;
        Stats.SetRange("OF", OFl."Prod. Order No." + '-' + Format(OFl."Line No."));
        Stats.SetRange(Date, OFl."Ending Date");
        Stats.SetRange("Type source", 'ARTICLE');
        Stats.SetRange(source, Item);
        Stats.SetRange(Niveau, Level);
        if Stats.FindFirst then begin
            Stats."Quantité intermédiaire nom OF" += Qty;
            Stats.Modify;
        end
        else begin
            Stats.Init;
            Stats."OF" := OFl."Prod. Order No." + '-' + Format(OFl."Line No.");
            Stats.Date := OFl."Ending Date";
            Stats."Quantite produite" := OFl."Finished Qty. (Base)";
            Stats.Article := OFl."Item No.";
            Stats."Type source" := 'ARTICLE';
            Stats.source := Item;
            Stats.Niveau := Level;
            Stats."Quantité intermédiaire nom OF" := Qty;
            Stats.Direction := 'CONSOMMATION';
            Stats.Insert;
        end;
    end;

    local procedure IsCru(ItemNo: Code[20]): Boolean
    begin
        if StrPos(ItemNo, '5-FRS-80400') > 0 then exit(true);
        if StrPos(ItemNo, '5-CRU') > 0 then exit(true);
        if StrPos(ItemNo, '7-C') > 0 then exit(true);
        if StrPos(ItemNo, '1-') > 0 then exit(true);
        exit(false);
    end;
}

