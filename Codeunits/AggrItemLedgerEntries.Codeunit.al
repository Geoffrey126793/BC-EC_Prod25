codeunit 8001301 "Aggr., Item Ledger Entries"
{
    // //STATSEXPLORER STATSEXPLORER 01/10/01 Process Aggregates, Item Ledger Entry
    // 
    // This codeunit was changed for 3.60 version, amounts are very different from other versions
    // 
    // -------------------------------------------------------------------------------------------
    //   STA-000 ABSYS BT 20061102
    //    Gestion des gratuits
    // 
    // -------------------------------------------------------------------------------------------
    // 
    // //AB60408.V1  EBE 10/04/2008 Flux de vente Montants en devise  : factures et avoirs enregistrés
    //    - champ libre 1 = code devise (repris sur EnTête document)
    //    - valeur libre 1 = montant en devise (facteur devise repris sur En tête document)
    // 
    // //AB6.VIR.190509
    //    - champ libre 2 = Code vendeur de la fiche client
    // 
    // //AB6.VIR 040609
    //    - Free Value 2 = Montant départ = Quantité * Prix départ (selon champ spécifique sur Sales Price)
    //    - Free Value 3 = Fraix Fixes    = Quantité * Cout Fixe (selon table spécifique par période/article)
    //    - Free Value 4 = RFA            = Quantité * RFA (selon champ spécifique sur Sales Price)
    // //CTD ALX 210116
    //    - Free Value 5 = Montant 3x Net = Quantité * Prix 3x Net (selon champ spécifique sur Sales Price)
    // 
    // //ABC(OLL) - 04/12/2017 :
    //    - Ajout Free Field 6 = Groupe prix client (facture ou avoir)
    //    - Ajout filtre des prix sur groupe prix client si nécessaire
    // 
    // //GEO 030118
    //    - Free Value 4 = RFA            = Montant Départ * RFA (en % repris sur Sales Price)
    // 
    // 
    // //GEO020818
    //     IF NOT StatsExplorerTools.SearchAndModifyAggregate(StatisticAggregate1,StatisticAggregate2,SearchDimensions,NoType) THEN BEGIN
    //     prend du temps a caus des setrange, impossible a améliorer
    // 
    // //GEO0419
    //    On ignore le magasin RD
    // 
    // //GEO 210120
    //    - Free Value 8 = Cout réél écriture vente
    //    - Free Value 9 = Cout réél MP
    // 
    // //GEO 180520
    //   - Free Value 10 = ABCCosting
    // 
    // //GEO 220126
    //   - Free Value 3  ABC standard


    trigger OnRun()
    begin

        //StartDate := 010619D;
        //EndDate := 300619D;
        //EntryNo := 0;
        //BasePeriod := BasePeriod::Day;

        if GuiAllowed then Window.Open('#1############################## #2##### -> #3#####');
        if GuiAllowed then Window.Update(1, Entry.TableCaption);

        StatisticsSetup.Get;

        StatisticAggregate1.SetCurrentKey("Entry Type", "Ending Date");
        StatisticAggregate1.SetRange("Period Length", BasePeriod);
        StatisticAggregate1.SetRange("Ending Date", StartDate, EndDate);

        StatsExplorerTools.CreateTypeArray(TextType, WorkType, SearchDim, PeriodBasis, LastEntryNo);

        StatisticAggregate2.SetCurrentKey("Period Length", "Ending Date", "Entry Type", Type, "No.", "Source Type", "Source No."
        , "Location Code", "Inventory Posting Group", "Source Posting Group", "Gen. Bus. Posting Group", "Gen. Prod. Posting Group",
        "Salespers./Purch. Code", "Global Dimension 1 Code", "Global Dimension 2 Code", "Country Code", "Business Unit Code");

        StatisticAggregate1.SetCurrentKey("Entry No.");
        StatisticAggregate1.Reset;
        if StatisticAggregate1.Find('+') then
            NextEntry := StatisticAggregate1."Entry No." + 1
        else
            NextEntry := 1;

        TypeFilter := '';
        if WorkType[5] then
            TypeFilter := '1';

        if WorkType[10] then
            if TypeFilter <> '' then
                TypeFilter := TypeFilter + '|0'
            else
                TypeFilter := '0';

        if WorkType[40] then
            if TypeFilter <> '' then
                TypeFilter := TypeFilter + '|2'
            else
                TypeFilter := '2';

        if WorkType[45] then
            if TypeFilter <> '' then
                TypeFilter := TypeFilter + '|3'
            else
                TypeFilter := '3';

        if WorkType[50] then
            if TypeFilter <> '' then
                TypeFilter := TypeFilter + '|4'
            else
                TypeFilter := '4';

        if WorkType[80] then
            if TypeFilter <> '' then
                TypeFilter := TypeFilter + '|5'
            else
                TypeFilter := '5';

        if WorkType[81] then
            if TypeFilter <> '' then
                TypeFilter := TypeFilter + '|6'
            else
                TypeFilter := '6';

        if TypeFilter <> '' then
            if BasePeriod = BasePeriod::Day then
                SearchEntry
            else
                CreatePeriod;

        if GuiAllowed then Window.Close;
    end;

    var
        "Object": Record "Object";
        StatisticAggregate1: Record "Statistic aggregate";
        StatisticAggregate2: Record "Statistic aggregate";
        StatisticAggregate3: Record "Statistic aggregate";
        Entry: Record "Value Entry";
        "Code": Record "Code";
        LedgerEntryDimension: Record "Dimension Set ID Filter Line";
        StatisticsSetup: Record "Statistics setup";
        lSalesInv: Record "Sales Invoice Header";
        lSalesCr: Record "Sales Cr.Memo Header";
        UpdateDefaultValues: Codeunit "Aggr., Update default values";
        StatsExplorerTools: Codeunit "StatsExplorer, Tools";
        Window: Dialog;
        StartDate: Date;
        EndDate: Date;
        BasePeriod: Option Day,Week,Month,Quarter,Year,Period;
        TextType: array[100] of Text[30];
        FieldEnabled: array[100, 250] of Boolean;
        WorkType: array[100] of Boolean;
        PeriodBasis: array[100, 6] of Boolean;
        SearchDim: array[100] of Boolean;
        NbRead: Integer;
        NbCreated: Integer;
        NextEntry: Integer;
        TypeFilter: Text[250];
        SearchDimensions: Boolean;
        EntryNo: Integer;
        LastEntryNo: array[100] of Integer;
        i: Integer;
        RecCustomer: Record Customer;
        rCurrExchRate: Record "Currency Exchange Rate";
        dPostingDate: Date;
        UnitItem: Record "Item Unit of Measure";
        Item: Record Item;
        HistoCouts: Record "Histo couts";
        ActCost: Decimal;
        CUProd: Codeunit "Integration Tft and Prod";

    [Scope('OnPrem')]
    procedure InitRequest(wStartDate: Date; wEndDate: Date; wBasePeriod: Option Day,Week,Month,Quarter,Year,Period; wEntryNo: Integer)
    begin
        StartDate := wStartDate;
        EndDate := wEndDate;
        BasePeriod := wBasePeriod;
        EntryNo := wEntryNo;
    end;

    [Scope('OnPrem')]
    procedure InitEntry()
    begin
        Entry.Reset;
        if EntryNo = 0 then begin
            Entry.SetCurrentKey("Item Ledger Entry Type", "Item No.", "Source Type", "Source No.", "Location Code", "Inventory Posting Group",
                 "Source Posting Group", "Gen. Bus. Posting Group", "Gen. Prod. Posting Group", "Salespers./Purch. Code",
                 "Global Dimension 1 Code", "Global Dimension 2 Code", "Reason Code", "Posting Date");
            Entry.SetRange("Posting Date", StartDate, EndDate);
        end else begin
            Entry.SetCurrentKey("Entry No.");
            Entry.SetRange("Entry No.", EntryNo);
        end;
        Entry.SetFilter("Item Ledger Entry Type", TypeFilter);
        Entry.SetRange(Inventoriable, true);

        Entry.SetFilter("Location Code", '<>%1', 'RD');

        //Entry.SETRANGE("Posting Date",200525D);
        //Entry.SETRANGE("Source No.",'C02001');
        //Entry.SETRANGE("Item No.",'1-IQF-00980');


        //Entry.SETRANGE(Entry."Expected Cost",FALSE);
    end;

    [Scope('OnPrem')]
    procedure SearchEntry()
    var
        SDate: Date;
        EDate: Date;
        i: Integer;
        Result: array[20] of Decimal;
        NoType: Integer;
        RecSalesPrice: Record "Sales PriceEC";
        UnitStartPrice: Decimal;
        CustGrpPrice: Boolean;
        UnitPrice: Decimal;
    begin
        with Entry do begin
            InitEntry;

            if Find('-') then
                repeat
                    NbRead := NbRead + 1;
                    if GuiAllowed then Window.Update(2, NbRead);
                    if NbRead > 465 then
                        dPostingDate := 0D;
                    //AC.CTD.ADA 130712
                    dPostingDate := 0D;
                    dPostingDate := "Posting Date";
                    //AC.CTD.ADA 130712//
                    SDate := StatsExplorerTools.StartDateCalc(BasePeriod, "Posting Date");
                    EDate := StatsExplorerTools.EndDateCalc(BasePeriod, "Posting Date");
                    StatisticAggregate1.Init;
                    StatisticAggregate1."Entry No." := NextEntry;
                    StatisticAggregate1."Period Length" := BasePeriod;
                    StatisticAggregate1."Ending Date" := EDate;
                    case "Item Ledger Entry Type" of
                        "Item Ledger Entry Type"::Purchase:
                            NoType := 10;
                        "Item Ledger Entry Type"::Sale:
                            NoType := 5;
                        "Item Ledger Entry Type"::"Positive Adjmt.":
                            NoType := 40;
                        "Item Ledger Entry Type"::"Negative Adjmt.":
                            NoType := 45;
                        "Item Ledger Entry Type"::Transfer:
                            NoType := 50;
                        "Item Ledger Entry Type"::Consumption:
                            NoType := 80;
                        "Item Ledger Entry Type"::Output:
                            NoType := 81;
                    end;
                    StatisticAggregate1."Entry Type" := TextType[NoType];
                    StatisticAggregate1.Type := StatisticAggregate1.Type::Item;
                    StatisticAggregate1."No." := "Item No.";
                    StatisticAggregate1."Source Type" := "Source Type".AsInteger();
                    StatisticAggregate1."Source No." := "Source No.";
                    StatisticAggregate1."Location Code" := "Location Code";
                    StatisticAggregate1."Inventory Posting Group" := "Inventory Posting Group";
                    StatisticAggregate1."Source Posting Group" := "Source Posting Group";
                    StatisticAggregate1."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
                    StatisticAggregate1."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
                    StatisticAggregate1."Salespers./Purch. Code" := "Salespers./Purch. Code";
                    StatisticAggregate1."Global Dimension 1 Code" := "Global Dimension 1 Code";
                    StatisticAggregate1."Global Dimension 2 Code" := "Global Dimension 2 Code";
                    StatisticAggregate1."Reason Code" := "Reason Code";
                    StatisticAggregate1."Item Charge No." := "Item Charge No.";
                    StatisticAggregate1."Variant Code" := "Variant Code";
                    StatisticAggregate1."Return Reason Code" := "Return Reason Code";

                    //  STA-000 ABSYS BT 20061102
                    StatisticAggregate1."Free boolean 1" := "Free Line";
                    StatisticAggregate1."Free field 2" := "Resaon Free Code";
                    // <-

                    Item.Get("Item No.");
                    //AB6.VIR.190509 -->
                    if RecCustomer.Get("Source No.") then
                        StatisticAggregate1."Free field 3" := RecCustomer."Salesperson Code";
                    //AB6.VIR.190509 <--

                    ActCost := 0;
                    HistoCouts.Reset;
                    HistoCouts.SetRange(Item, Item."No.");
                    HistoCouts.SetFilter(Date, '<=%1', EDate);
                    if EDate < 20210901D then
                        HistoCouts.SetRange(Type, HistoCouts.Type::"Cout standard")
                    else
                        HistoCouts.SetRange(Type, HistoCouts.Type::"Prix de revient matiére");
                    if HistoCouts.FindLast then
                        ActCost := HistoCouts.Cout;

                    case "Item Ledger Entry Type" of
                        "Item Ledger Entry Type"::"Positive Adjmt.", "Item Ledger Entry Type"::Purchase, "Item Ledger Entry Type"::Transfer,
                        "Item Ledger Entry Type"::"Negative Adjmt.":
                            begin
                                StatisticAggregate1.Quantity := "Invoiced Quantity";
                                StatisticAggregate1.Amount := "Cost Amount (Actual)";
                                StatisticAggregate1.Cost := "Invoiced Quantity" * ActCost;
                            end;
                        "Item Ledger Entry Type"::Sale:
                            begin
                                StatisticAggregate1.Quantity := -"Invoiced Quantity";
                                StatisticAggregate1.Amount := +"Sales Amount (Actual)";
                                StatisticAggregate1.Cost := -"Invoiced Quantity" * ActCost;
                                StatisticAggregate1."Campaign No." := FindCampaign(Entry);
                                StatisticAggregate1."Free value 8" := -Entry."Cost Amount (Actual)";
                                GetCosts(Entry);
                                if (EDate >= 20211201D) then
                                    StatisticAggregate1."Free value 9" := -Entry."Cost Amount (Actual)";

                                //MESSAGE('%1  %2     ',"Entry No.", StatisticAggregate1."Free value 9");
                                //AB60408.V1
                                if ("Document No." <> '') then begin
                                    if lSalesInv.Get("Document No.") then begin
                                        if lSalesInv."Currency Factor" <> 0 then begin
                                            StatisticAggregate1."Free field 1" := lSalesInv."Currency Code";
                                            //GEO 090318  le "nouveau" taux de la table
                                            rCurrExchRate.Reset;
                                            rCurrExchRate.SetFilter("Currency Code", lSalesInv."Currency Code");
                                            rCurrExchRate.SetFilter("Starting Date", '<=%1', dPostingDate);
                                            if rCurrExchRate.Find('+') then
                                                StatisticAggregate1."Free value 1" += Round("Sales Amount (Actual)"
                                                                                        * rCurrExchRate."Exchange Rate Amount")
                                            else
                                                StatisticAggregate1."Free value 1" += Round("Sales Amount (Actual)"
                                                                                         * lSalesInv."Currency Factor");

                                        end;
                                        StatisticAggregate1."Free date 1" := lSalesInv."Order Date";
                                        StatisticAggregate1."Free field 6" := lSalesInv."Customer Price Group"; //ABC(OLL) - 04/12/2017
                                    end;
                                    if lSalesCr.Get("Document No.") then begin
                                        if lSalesCr."Currency Factor" <> 0 then begin
                                            StatisticAggregate1."Free field 1" := lSalesCr."Currency Code";
                                            //GEO 090318  le "nouveau" taux de la table
                                            rCurrExchRate.Reset;
                                            rCurrExchRate.SetFilter("Currency Code", lSalesCr."Currency Code");
                                            rCurrExchRate.SetFilter("Starting Date", '<=%1', dPostingDate);
                                            if rCurrExchRate.Find('+') then
                                                StatisticAggregate1."Free value 1" += Round("Sales Amount (Actual)"
                                                                                        * rCurrExchRate."Exchange Rate Amount")
                                            else
                                                StatisticAggregate1."Free value 1" += Round("Sales Amount (Actual)"
                                                                                         * lSalesCr."Currency Factor");
                                        end;
                                        StatisticAggregate1."Free field 6" := lSalesCr."Customer Price Group"; //ABC(OLL) - 04/12/2017
                                    end;
                                end;
                                //AB60408.V1

                            end;

                        "Item Ledger Entry Type"::Consumption:
                            begin
                                StatisticAggregate1.Quantity := -"Valued Quantity";
                                StatisticAggregate1.Amount := -"Cost Amount (Actual)";
                                StatisticAggregate1.Cost := -"Invoiced Quantity" * ActCost;
                                //BT : reprise correction chimay
                                StatisticAggregate1.Quantity := -"Invoiced Quantity";
                                //
                            end;
                        "Item Ledger Entry Type"::Output:
                            begin
                                StatisticAggregate1.Quantity := "Valued Quantity";
                                StatisticAggregate1.Amount := "Cost Amount (Actual)";
                                StatisticAggregate1.Cost := -"Invoiced Quantity" * ActCost;
                                //BT : reprise correction chimay
                                StatisticAggregate1.Quantity := -"Invoiced Quantity";
                                //

                            end;
                    end;

                    //AB6.VIR 040609 -->
                    //GEO 090118 par défaut=0
                    //StatisticAggregate1."Free value 2":= StatisticAggregate1.Amount;
                    RecSalesPrice.Reset;
                    RecSalesPrice.SetRange(RecSalesPrice."Item No.", "Item No.");
                    RecSalesPrice.SetRange(RecSalesPrice."Sales Type", RecSalesPrice."Sales Type"::Customer);
                    RecSalesPrice.SetRange(RecSalesPrice."Sales Code", "Source No.");
                    RecSalesPrice.SetFilter(RecSalesPrice."Starting Date", '<=%1', "Posting Date");
                    RecSalesPrice.SetFilter(RecSalesPrice."Ending Date", '>=%1', "Posting Date");
                    RecSalesPrice.SetFilter(RecSalesPrice."Unit Start Price", '<>%1', 0);
                    //>> ABC(OLL) - 04/12/2017
                    CustGrpPrice := false;
                    if RecSalesPrice.Find('+') then begin
                        UnitStartPrice := RecSalesPrice."Unit Start Price";
                        UnitPrice := RecSalesPrice."Unit Price";
                        RecSalesPrice.SetRange(RecSalesPrice."Sales Type", RecSalesPrice."Sales Type"::"Customer Price Group");
                        RecSalesPrice.SetRange(RecSalesPrice."Sales Code", StatisticAggregate1."Free field 6"); //Groupe prix client
                        if RecSalesPrice.Find('+') then begin
                            CustGrpPrice := true;
                            //        IF (UnitStartPrice < RecSalesPrice."Unit Start Price") THEN BEGIN   //DG 281217  test inutile, tjs le meme ?
                            if (UnitPrice < RecSalesPrice."Unit Price") then begin
                                //** Reprise du tarif client **
                                RecSalesPrice.SetRange(RecSalesPrice."Sales Type", RecSalesPrice."Sales Type"::Customer);
                                RecSalesPrice.SetRange(RecSalesPrice."Sales Code", "Source No.");
                                CustGrpPrice := false;
                            end;
                        end
                        else begin
                            //** Reprise du tarif client **
                            RecSalesPrice.SetRange(RecSalesPrice."Sales Type", RecSalesPrice."Sales Type"::Customer);
                            RecSalesPrice.SetRange(RecSalesPrice."Sales Code", "Source No.");
                            CustGrpPrice := false;
                        end;
                    end
                    else begin
                        RecSalesPrice.SetRange(RecSalesPrice."Sales Type", RecSalesPrice."Sales Type"::"Customer Price Group");
                        RecSalesPrice.SetRange(RecSalesPrice."Sales Code", StatisticAggregate1."Free field 6"); //Groupe prix client
                        if RecSalesPrice.Find('+') then begin
                            CustGrpPrice := true;
                        end;
                    end;

                    //<<
                    if RecSalesPrice.Find('+') then begin
                        //CTD ALX 210116

                        //CTD ALX 210116//
                        if UnitItem.Get(RecSalesPrice."Item No.", RecSalesPrice."Unit of Measure Code") then begin
                            RecSalesPrice."Unit Start Price" := RecSalesPrice."Unit Start Price" / UnitItem."Qty. per Unit of Measure";
                            RecSalesPrice."Prix 3x Net" := RecSalesPrice."Prix 3x Net";
                            RecSalesPrice."Unit Price" := RecSalesPrice."Unit Price" / UnitItem."Qty. per Unit of Measure";
                        end;
                        //AC.CTD.ADA 130712
                        if RecSalesPrice."Currency Code" <> '' then begin
                            rCurrExchRate.Reset;
                            rCurrExchRate.SetFilter("Currency Code", RecSalesPrice."Currency Code");
                            rCurrExchRate.SetFilter("Starting Date", '<=%1', dPostingDate);
                            if rCurrExchRate.Find('+') then begin
                                StatisticAggregate1."Free value 2" := Round((RecSalesPrice."Unit Start Price" - (Entry."Discount Amount" / Entry."Valued Quantity")) * StatisticAggregate1.Quantity / rCurrExchRate."Exchange Rate Amount");
                                StatisticAggregate1."Free value 5" := Round((RecSalesPrice."Prix 3x Net" - (Entry."Discount Amount" / Entry."Valued Quantity")) * StatisticAggregate1.Quantity / rCurrExchRate."Exchange Rate Amount");
                                StatisticAggregate1."Free value 6" := Round((RecSalesPrice."Unit Price" - (Entry."Discount Amount" / Entry."Valued Quantity")) * StatisticAggregate1.Quantity / rCurrExchRate."Exchange Rate Amount");
                                StatisticAggregate1."Free value 7" := Entry."Discount Amount";

                            end
                            else begin
                                //ERROR('Il n y a pas de taux de change pour la devise %1',RecSalesPrice."Currency Code");
                                StatisticAggregate1."Free value 2" := Round((RecSalesPrice."Unit Start Price" - (Entry."Discount Amount" / Entry."Valued Quantity")) * StatisticAggregate1.Quantity);
                                StatisticAggregate1."Free value 5" := Round((RecSalesPrice."Prix 3x Net" - (Entry."Discount Amount" / Entry."Valued Quantity")) * StatisticAggregate1.Quantity);
                                StatisticAggregate1."Free value 6" := Round((RecSalesPrice."Unit Price" - (Entry."Discount Amount" / Entry."Valued Quantity")) * StatisticAggregate1.Quantity);
                                StatisticAggregate1."Free value 7" := Entry."Discount Amount";
                            end;
                        end else begin
                            StatisticAggregate1."Free value 2" := Round((RecSalesPrice."Unit Start Price" - (Entry."Discount Amount" / Entry."Valued Quantity")) * StatisticAggregate1.Quantity);
                            StatisticAggregate1."Free value 5" := Round((RecSalesPrice."Prix 3x Net" - (Entry."Discount Amount" / Entry."Valued Quantity")) * StatisticAggregate1.Quantity);
                            StatisticAggregate1."Free value 6" := Round((RecSalesPrice."Unit Price" - (Entry."Discount Amount" / Entry."Valued Quantity")) * StatisticAggregate1.Quantity);
                            StatisticAggregate1."Free value 7" := Entry."Discount Amount";
                        end;
                        // GEO 120318 Prix 3x net diminué de la ristourne
                        // GEO 120819 Depart également


                        //StatisticAggregate1."Free value 2":= StatisticAggregate1.Quantity * RecSalesPrice."Unit Start Price";
                        //GEO 030118
                        if StatisticAggregate1."Ending Date" < 20220101D then begin
                            StatisticAggregate1."Free value 4" := StatisticAggregate1."Free value 2" * (RecSalesPrice.RFA / 100);
                        end
                        else begin
                            StatisticAggregate1."Free value 4" := RecSalesPrice."RFA / Kg" * StatisticAggregate1.Quantity;
                            StatisticAggregate1.RFA := RecSalesPrice."RFA / Kg" * StatisticAggregate1.Quantity;
                            StatisticAggregate1."Coop Comm" := RecSalesPrice."CC / Kg" * StatisticAggregate1.Quantity;
                        end;
                    end;
                    //AC.CTD.ADA 130712//

                    //RecFixedCost.RESET;
                    //RecFixedCost.SETRANGE("Item No.","Item No.");
                    //RecFixedCost.SETFILTER("Start Periode",'<=%1',"Posting Date");
                    //RecFixedCost.SETFILTER("End Periode",'>=%1',"Posting Date");
                    //IF RecFixedCost.FIND('+') THEN
                    //   StatisticAggregate1."Free value 3":= StatisticAggregate1.Quantity * RecFixedCost."Fixed Cost";

                    /*  //GEO 030118  On avait déjà la ligne prix. Voir plus haut
                    RecSalesPrice.RESET;
                    RecSalesPrice.SETRANGE(RecSalesPrice."Item No.","Item No.");
                    //>> ABC(OLL) - 04/12/2017
                    IF CustGrpPrice THEN BEGIN
                      RecSalesPrice.SETRANGE(RecSalesPrice."Sales Type",RecSalesPrice."Sales Type"::"Customer Price Group");
                      RecSalesPrice.SETRANGE(RecSalesPrice."Sales Code",StatisticAggregate1."Free field 6"); //Groupe prix client
                    END ELSE BEGIN
                    //<<
                      RecSalesPrice.SETRANGE(RecSalesPrice."Sales Type",RecSalesPrice."Sales Type"::Customer);
                      RecSalesPrice.SETRANGE(RecSalesPrice."Sales Code","Source No.");
                    END; //ABC(OLL) - 04/12/2017
                    RecSalesPrice.SETFILTER(RecSalesPrice."Starting Date",'<=%1',"Posting Date");
                    RecSalesPrice.SETFILTER(RecSalesPrice."Ending Date",'>=%1',"Posting Date");
                    RecSalesPrice.SETFILTER(RecSalesPrice.RFA,'<>%1',0);
                    IF RecSalesPrice.FIND('+') THEN
                       StatisticAggregate1."Free value 4":= StatisticAggregate1."Free value 2" * (RecSalesPrice.RFA / 100);

                   */
                    //AB6.VIR 040609 <--



                    if (SearchDim[NoType]) then begin
                        StatsExplorerTools.SearchLedgerEntryDimension(StatisticAggregate1, 5802, "Entry No.");
                        SearchDimensions := true;
                    end;
                    UpdateDefaultValues.Run(StatisticAggregate1);

                    if not StatsExplorerTools.SearchAndModifyAggregate(StatisticAggregate1, StatisticAggregate2, SearchDimensions, NoType) then begin
                        StatisticAggregate1.Insert;
                        NextEntry := NextEntry + 1;
                        NbCreated := NbCreated + 1;
                    end;
                    if GuiAllowed then Window.Update(3, NbCreated);
                until Next = 0;
        end;

    end;

    [Scope('OnPrem')]
    procedure FindCampaign(pEntry: Record "Value Entry"): Code[20]
    var
        lSalesInv: Record "Sales Invoice Header";
        lSalesCr: Record "Sales Cr.Memo Header";
        lSalesSh: Record "Sales Shipment Header";
    begin
        if pEntry."Document No." <> '' then begin
            if lSalesSh.Get(pEntry."Document No.") then
                exit(lSalesSh."Campaign No.")
            else
                if lSalesInv.Get(pEntry."Document No.") then
                    exit(lSalesInv."Campaign No.")
                else
                    if lSalesCr.Get(pEntry."Document No.") then
                        exit(lSalesCr."Campaign No.")
                    else
                        exit('');
        end
        else
            exit('');
    end;

    [Scope('OnPrem')]
    procedure CreatePeriod()
    var
        dlg: Dialog;
        iC: Integer;
        iCount: Integer;
        TextType: array[100] of Text[30];
        WorkType: array[100] of Boolean;
        PeriodBasis: array[100, 6] of Boolean;
        SearchDim: array[100] of Boolean;
        LastEntryNo: array[100] of Integer;
    begin
        StatsExplorerTools.CreateTypeArray(TextType, WorkType, SearchDim, PeriodBasis, LastEntryNo);

        if GuiAllowed then dlg.Open('@1@@@@@@@@@@@@@@@@@@@@@@');

        StatisticAggregate1.Reset;
        if StatisticAggregate1.FindLast then
            NextEntry := StatisticAggregate1."Entry No." + 1
        else
            NextEntry := 1;

        StatisticAggregate1.Reset;
        StatisticAggregate1.SetRange("Period Length", StatisticAggregate1."Period Length"::Day);
        StatisticAggregate1.SetRange("Ending Date", StartDate, EndDate);
        StatisticAggregate1.SetRange(Type, StatisticAggregate1.Type::Item);
        iCount := StatisticAggregate1.Count;
        iC := 1;
        if StatisticAggregate1.FindSet then
            repeat
                StatisticAggregate2.TransferFields(StatisticAggregate1, true);
                StatisticAggregate2."Entry No." := NextEntry;
                StatisticAggregate2."Period Length" := BasePeriod;
                StatisticAggregate2."Ending Date" := StatsExplorerTools.EndDateCalc(BasePeriod, StatisticAggregate1."Ending Date");
                SearchDimensions := true;
                if not StatsExplorerTools.SearchAndModifyAggregate(StatisticAggregate2, StatisticAggregate3, SearchDimensions, 5) then begin
                    StatisticAggregate2.Insert;
                    NextEntry := NextEntry + 1;
                    NbCreated := NbCreated + 1;
                end;
                iC := iC + 1;
                if GuiAllowed then dlg.Update(1, Round(iC / iCount * 10000, 1));

            until StatisticAggregate1.Next = 0;
        if GuiAllowed then dlg.Close;
    end;

    local procedure GetCosts(ValueEntry: Record "Value Entry")
    var
        ILE1: Record "Item Ledger Entry";
        ILE2: Record "Item Ledger Entry";
        Stats: Record "Stats OF";
        TotalCout: Decimal;
        TotalQty: Decimal;
        TotalCoutABC: Decimal;
        TotalQtyABC: Decimal;
        rItem: Record Item;
        TotalCoutABCstd: Decimal;
        TotalQtyABCstd: Decimal;
    begin
        if ILE1.Get(ValueEntry."Item Ledger Entry No.") then begin
            TotalCout := 0;
            TotalQty := 0;
            ILE2.Reset;
            ILE2.SetRange("Item No.", ILE1."Item No.");
            ILE2.SetRange("Lot No.", ILE1."Lot No.");
            ILE2.SetRange("Entry Type", ILE2."Entry Type"::Output);
            ILE2.SetFilter("Posting Date", '%1..%2', CalcDate('<-2Y>', ILE1."Posting Date"), ILE1."Posting Date");
            if ILE2.FindSet then begin
                repeat
                    Stats.Reset;
                    Stats.SetRange("OF", ILE2."Order No." + '-' + Format(ILE2."Order Line No."));
                    Stats.SetRange(Direction, 'PRODUCTION');
                    if Stats.FindFirst then begin
                        TotalCout += Stats."Cout total";
                        TotalQty += Stats."Quantite produite";
                    end;
                    Stats.Reset;
                    Stats.SetRange("OF", ILE2."Order No." + '-' + Format(ILE2."Order Line No."));
                    Stats.SetRange(Direction, 'CONSOMMATION');
                    Stats.SetRange("Type source", 'ABC');
                    if Stats.FindSet then
                        repeat
                            TotalCoutABC += Stats."Cout total standard";
                            TotalCoutABCstd += Stats."Cout total nomencl std"
                        until Stats.Next = 0;
                until ILE2.Next = 0;

                if TotalQty <> 0 then begin
                    StatisticAggregate1."Free value 9" := -ValueEntry."Invoiced Quantity" * (TotalCout / TotalQty);
                    StatisticAggregate1."Free value 10" := -ValueEntry."Invoiced Quantity" * (TotalCoutABC / TotalQty);
                    StatisticAggregate1."Free value 3" := -ValueEntry."Invoiced Quantity" * (TotalCoutABCstd / TotalQty);

                    //MESSAGE('%1     %2',TotalCoutABC,TotalQty)
                end
                else begin
                    StatisticAggregate1."Free value 9" := 0;
                    StatisticAggregate1."Free value 10" := 0;
                end;



            end
            else begin
                //    IF rItem.GET(ILE1."Item No.") THEN
                //      StatisticAggregate1."Free value 9" := -ValueEntry."Invoiced Quantity" * rItem."Rolled-up Material Cost";
            end;
        end;
    end;
}

