codeunit 50011 "Aggregate, Posted Disc. Entry"
{
    // //STATSEXPLORER STATSEXPLORER 01/10/01 Aggregate, G/L Entry
    // 
    // ------------------------------------------------------------------------------------------
    // ADV-001 ABSYS BT 20061102
    //   Calcul flux remise dans le stat : reprise Chimay
    // 
    // -----------------------------------------------------------------------------------------


    trigger OnRun()
    begin
        Window.Open('#1############################## #2##### -> #3#####');
        Window.Update(1, Entry.TableCaption);

        StatisticAggregate1.Reset;
        StatisticsSetup.Get;
        StatsExplorerTools.CreateTypeArray(TextType, WorkType, SearchDim, PeriodBasis, LastEntryNo);

        if StatisticAggregate1.Find('+') then
            NextEntry := StatisticAggregate1."Entry No." + 1
        else
            NextEntry := 1;

        //Absys GJ 15/06/05 ->
        if WorkType[90] or WorkType[30] or WorkType[32] then
            if EntryNo = 0 then
                SearchEntry
            else begin
                if StatisticsSetup."Period total basis" <> StatisticsSetup."Period total basis"::"According to every flow" then begin
                    BasePeriod := StatisticsSetup."Period total basis";
                    SearchEntry;
                end else begin
                    repeat
                        i := i + 1;
                        if PeriodBasis[90, i] or PeriodBasis[30, i] or PeriodBasis[32, i] then begin
                            BasePeriod := i - 1;
                            SearchEntry;
                        end;
                    until i = 5;
                end;
            end;
        //Absys GJ 15/06/05 <-

        Window.Close;
    end;

    var
        StatisticAggregate1: Record "Statistic aggregate";
        StatisticAggregate2: Record "Statistic aggregate";
        Entry: Record "Posted Sales Discount Entry";
        "Code": Record "Code";
        StatisticsSetup: Record "Statistics setup";
        StatsExplorerTools: Codeunit "StatsExplorer, Tools";
        UpdateDefaultValues: Codeunit "Aggr., Update default values";
        Window: Dialog;
        TextType: array[100] of Text[30];
        WorkType: array[100] of Boolean;
        PeriodBasis: array[100, 6] of Boolean;
        StartDate: Date;
        EndDate: Date;
        BasePeriod: Option Day,Week,Month,Quarter,Year,Period;
        SearchDim: array[100] of Boolean;
        FieldEnabled: array[100, 250] of Boolean;
        NbRead: Integer;
        NbCreated: Integer;
        NextEntry: Integer;
        EntryNo: Integer;
        LastEntryNo: array[100] of Integer;
        i: Integer;
        RecCust_l: Record Customer;

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
    var
        TypeFilter: Text[250];
    begin
        Entry.Reset;

        if EntryNo <> 0 then
            Error('Paramètre de la méthode incorrecte');

        if EntryNo = 0 then begin
            Entry.SetCurrentKey("Document Type", Entry."Disc. Commission Type", "Posting Date");
            Entry.SetRange("Posting Date", StartDate, EndDate);

            //Absys FH 12/07/2005 ->
            TypeFilter := '';
            if WorkType[90] then
                TypeFilter := StrSubstNo('%1|%2', Entry."Disc. Commission Type"::"Line Discount",
                  Entry."Disc. Commission Type"::"Footer Discount");

            if WorkType[30] then
                if TypeFilter <> '' then
                    TypeFilter := TypeFilter + StrSubstNo('|%1', Entry."Disc. Commission Type"::"Back Discount")
                else
                    TypeFilter := StrSubstNo('%1', Entry."Disc. Commission Type"::"Back Discount");
            ;

            if WorkType[32] then
                if TypeFilter <> '' then
                    TypeFilter := TypeFilter + StrSubstNo('|%1', Entry."Disc. Commission Type"::Commission)
                else
                    TypeFilter := StrSubstNo('%1', Entry."Disc. Commission Type"::Commission);
            ;

            Entry.SetFilter("Disc. Commission Type", TypeFilter);
            //Absys GJ 15/06/05 <-

            Entry.SetFilter("Document Type", '%1|%2', Entry."Document Type"::"Posted Invoice",
              Entry."Document Type"::"Posted Credit Memo");
        end;

        //END ELSE BEGIN
        //   Entry.SETCURRENTKEY("Entry No.");
        //   Entry.SETRANGE("Entry No.",EntryNo);
        //END;
    end;

    [Scope('OnPrem')]
    procedure SearchEntry()
    var
        StartD: Date;
        EndD: Date;
        Result: array[20] of Decimal;
        RecSalesInvLine_l: Record "Sales Invoice Line";
        RecSalesInvHeader_l: Record "Sales Invoice Header";
        RecSalesCrMemoLine_l: Record "Sales Cr.Memo Line";
        RecSalesCrMemoHeader_l: Record "Sales Cr.Memo Header";
        NoType: Integer;
    begin
        InitEntry;
        if Entry.Find('-') then
            with Entry do
                repeat
                    NbRead := NbRead + 1;
                    Window.Update(2, NbRead);
                    StartD := StatsExplorerTools.StartDateCalc(BasePeriod, "Posting Date");
                    EndD := StatsExplorerTools.EndDateCalc(BasePeriod, "Posting Date");

                    if Entry."Discount Amount" <> 0 then begin
                        StatisticAggregate1.Init;
                        StatisticAggregate1."Entry No." := NextEntry;
                        StatisticAggregate1."Period Length" := BasePeriod;
                        StatisticAggregate1."Ending Date" := EndD;

                        case "Disc. Commission Type" of
                            "Disc. Commission Type"::"Line Discount":
                                NoType := 90;
                            "Disc. Commission Type"::"Footer Discount":
                                NoType := 90;
                            "Disc. Commission Type"::"Back Discount":
                                NoType := 30;
                            "Disc. Commission Type"::Commission:
                                NoType := 32;
                        end;

                        StatisticAggregate1."Entry Type" := TextType[NoType];
                        StatisticAggregate1."Back disc./commission rule No." := Entry."Rule No.";

                        if Entry."Document Type" in [Entry."Document Type"::"Posted Invoice"] then begin
                            RecSalesInvLine_l.Get(Entry."Document No.", Entry."Line No.");
                            RecSalesInvHeader_l.Get(Entry."Document No.");
                            StatisticAggregate1.Type := RecSalesInvLine_l.Type.AsInteger() - 1;
                            StatisticAggregate1."No." := RecSalesInvLine_l."No.";
                            //StatisticAggregate1.Quantity :=             Entry."Quantity (base)";
                            //BT 060929 : demande de fdv : Je souhaite que pour tous les flux remise
                            //le champ Žé« quantité Žé» de StatsExplorer soit garni de lŽâÔÇ€information qui provient du champ
                            //Žé« base Žé» des écritures remises.
                            //
                            StatisticAggregate1.Quantity := Entry."Base (LCY)";
                            //
                            StatisticAggregate1.Amount := -Entry."Discount Amount (LCY)";
                            StatisticAggregate1."Source Type" := StatisticAggregate1."Source Type"::Customer;
                            StatisticAggregate1."Source No." := RecSalesInvLine_l."Sell-to Customer No.";
                            StatisticAggregate1."Location Code" := RecSalesInvLine_l."Location Code";
                            StatisticAggregate1."Source Posting Group" := RecSalesInvHeader_l."Customer Posting Group";
                            StatisticAggregate1."Gen. Bus. Posting Group" := RecSalesInvLine_l."Gen. Bus. Posting Group";
                            StatisticAggregate1."Gen. Prod. Posting Group" := RecSalesInvLine_l."Gen. Prod. Posting Group";
                            StatisticAggregate1."Salespers./Purch. Code" := RecSalesInvHeader_l."Salesperson Code";
                            StatisticAggregate1."Reason Code" := RecSalesInvHeader_l."Reason Code";
                            StatisticAggregate1."Job No." := RecSalesInvLine_l."Job No.";
                            //         StatisticAggregate1."Phase Code" :=         RecSalesInvLine_l."Phase Code";
                            //         StatisticAggregate1."Task Code" :=          RecSalesInvLine_l."Task Code";
                            //         StatisticAggregate1."Step Code" :=          RecSalesInvLine_l."Step Code";
                            StatisticAggregate1."Work Type Code" := RecSalesInvLine_l."Work Type Code";
                            StatisticAggregate1."Reason Code" := RecSalesInvHeader_l."Reason Code";
                        end else begin
                            RecSalesCrMemoLine_l.Get(Entry."Document No.", Entry."Line No.");
                            RecSalesCrMemoHeader_l.Get(Entry."Document No.");
                            StatisticAggregate1.Type := RecSalesCrMemoLine_l.Type.AsInteger() - 1;
                            StatisticAggregate1."No." := RecSalesCrMemoLine_l."No.";
                            //StatisticAggregate1.Quantity :=             -Entry."Quantity (base)";
                            //BT 060929 : demande de fdv : Je souhaite que pour tous les flux remise
                            //le champ Žé« quantité Žé» de StatsExplorer soit garni de lŽâÔÇ€information qui provient du champ
                            //Žé« base Žé» des écritures remises.
                            //
                            StatisticAggregate1.Quantity := -Entry."Base (LCY)";
                            //




                            StatisticAggregate1.Amount := Entry."Discount Amount (LCY)";
                            StatisticAggregate1."Source Type" := StatisticAggregate1."Source Type"::Customer;
                            StatisticAggregate1."Source No." := RecSalesCrMemoLine_l."Sell-to Customer No.";
                            StatisticAggregate1."Location Code" := RecSalesCrMemoLine_l."Location Code";
                            StatisticAggregate1."Source Posting Group" := RecSalesCrMemoHeader_l."Customer Posting Group";
                            StatisticAggregate1."Gen. Bus. Posting Group" := RecSalesCrMemoLine_l."Gen. Bus. Posting Group";
                            StatisticAggregate1."Gen. Prod. Posting Group" := RecSalesCrMemoLine_l."Gen. Prod. Posting Group";
                            StatisticAggregate1."Salespers./Purch. Code" := RecSalesCrMemoHeader_l."Salesperson Code";
                            StatisticAggregate1."Reason Code" := RecSalesCrMemoHeader_l."Reason Code";
                            StatisticAggregate1."Job No." := RecSalesCrMemoLine_l."Job No.";
                            //         StatisticAggregate1."Phase Code" :=         RecSalesCrMemoLine_l."Phase Code";
                            //         StatisticAggregate1."Task Code" :=          RecSalesCrMemoLine_l."Task Code";
                            //         StatisticAggregate1."Step Code" :=          RecSalesCrMemoLine_l."Step Code";
                            StatisticAggregate1."Work Type Code" := RecSalesCrMemoLine_l."Work Type Code";
                            StatisticAggregate1."Reason Code" := RecSalesCrMemoHeader_l."Reason Code";
                        end;

                        StatisticAggregate1.Cost := 0;

                        // Absys
                        //BT CHIMAY 060327 :Stats point 92 - Bascule de gratuit et promo en booléen
                        //StatisticAggregate1."Free field 1" := FORMAT(Entry."Free Line");
                        StatisticAggregate1."Free boolean 1" := Entry."Free Line";
                        StatisticAggregate1."Free boolean 2" := Entry."Special Offer";
                        StatisticAggregate1."Free field 2" := Entry."Reason Free Code";
                        //StatisticAggregate1."Free field 5" := FORMAT(Entry."Special Offer");
                        // Absys

                        // Absys
                        // IF Entry."Source Type" = Entry."Source Type"::Customer THEN BEGIN
                        if RecCust_l.Get(StatisticAggregate1."Source No.") then begin
                            //-- Groupe prix client du client --
                            StatisticAggregate1."Free field 3" := RecCust_l."Customer Price Group";
                            //-- Si flux vente on reprend le code vendeur de la fiche client --
                            StatisticAggregate1."Salespers./Purch. Code" := RecCust_l."Salesperson Code";
                        end;
                        // END;
                        // Absys

                        if SearchDim[NoType] then
                            if Entry."Document Type" in [Entry."Document Type"::"Posted Invoice"] then
                                StatsExplorerTools.SearchPostedDocumentDimension(StatisticAggregate1, 113,
                                RecSalesInvLine_l."Document No.", RecSalesInvLine_l."Line No.")
                            else
                                StatsExplorerTools.SearchPostedDocumentDimension(StatisticAggregate1, 115,
                                RecSalesCrMemoLine_l."Document No.", RecSalesCrMemoLine_l."Line No.");

                        UpdateDefaultValues.Run(StatisticAggregate1);
                        if not StatsExplorerTools.SearchAndModifyAggregate(StatisticAggregate1, StatisticAggregate2, SearchDim[67], 67) then begin
                            StatisticAggregate1.Insert;
                            NextEntry := NextEntry + 1;
                            NbCreated := NbCreated + 1;
                        end;
                        Window.Update(3, NbCreated);
                    end;
                until Next = 0;
    end;
}

