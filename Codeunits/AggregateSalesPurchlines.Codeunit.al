codeunit 8001308 "Aggregate, Sales/Purch. lines"
{
    // //STATSEXPLORER STATSEXPLORER 01/10/01 Aggregate, Sales and Purchase lines
    // //STATSEXPLORER STATSEXPLORER 01/07/02 "Line Amount" and not "Amount" is now used for this aggregate
    // 
    // 
    // -------------------------------------------------------------------------------------------
    //   STA-000 ABSYS BT 20061102
    //    Gestion des gratuits
    // 
    // -------------------------------------------------------------------------------------------


    trigger OnRun()
    begin
        if GuiAllowed then Window.Open('#1############################## #2##### -> #3#####');

        StatsExplorerTools.CreateTypeArray(TextType, WorkType, SearchDim, PeriodBasis, LastEntryNo);
        StatisticAggregate1.Reset;

        if StatisticAggregate1.Find('+') then
            NextEntry := StatisticAggregate1."Entry No." + 1
        else
            NextEntry := 1;

        if WorkType[68] then
            SearchSales(68);
        if WorkType[69] then
            SearchSales(69);
        if WorkType[70] then
            SearchSales(70);
        if WorkType[71] then
            SearchSales(71);

        if WorkType[73] then
            SearchPurch(73);
        if WorkType[74] then
            SearchPurch(74);
        if WorkType[75] then
            SearchPurch(75);
        if WorkType[76] then
            SearchPurch(76);
        if GuiAllowed then Window.Close;
    end;

    var
        StatisticAggregate1: Record "Statistic aggregate";
        StatisticAggregate2: Record "Statistic aggregate";
        "Code": Record "Code";
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
        LastEntryNo: array[100] of Integer;

    [Scope('OnPrem')]
    procedure InitRequest(wStartDate: Date; wEndDate: Date; wBasePeriod: Option Day,Week,Month,Quarter,Year,Period)
    begin
        //StartDate := wStartDate;
        StartDate := 20180101D;  //GEO a modifier plus tard
        EndDate := wEndDate;
        BasePeriod := wBasePeriod;
    end;

    [Scope('OnPrem')]
    procedure SearchSales(NoType: Integer)
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        StartD: Date;
        EndD: Date;
        i: Integer;
        Result: array[20] of Decimal;
        QtyStat: Decimal;
    begin
        if GuiAllowed then Window.Update(1, SalesLine.TableCaption + ', ' + TextType[NoType]);
        NbCreated := 0;
        with SalesLine do begin
            SetFilter(Type, '<>%1', Type::" ");
            SalesHeader.SetRange("Posting Date", 0D);
            if SalesHeader.Find('-') then
                repeat
                    if SalesHeader."Document Date" <> 0D then
                        SalesHeader."Posting Date" := SalesHeader."Document Date"
                    else
                        if SalesHeader."Order Date" <> 0D then
                            SalesHeader."Posting Date" := SalesHeader."Order Date"
                        else
                            SalesHeader."Posting Date" := WorkDate;
                    SalesHeader.Modify;
                until SalesHeader.Next = 0;

            SalesHeader.SetRange("Posting Date", StartDate, EndDate);
            case NoType of
                68:
                    SalesHeader.SetFilter("Document Type", '%1', "Document Type"::Quote);
                69:
                    SalesHeader.SetFilter("Document Type", '%1', "Document Type"::"Blanket Order");
                70, 71:
                    SalesHeader.SetFilter("Document Type", '%1|%2|%3', "Document Type"::Order, "Document Type"::Invoice,
                                          "Document Type"::"Credit Memo");
            end;

            if SalesHeader.Find('-') then
                repeat
                    SetRange("Document Type", SalesHeader."Document Type");
                    SetRange("Document No.", SalesHeader."No.");
                    if Find('-') then
                        repeat
                            NbRead := NbRead + 1;
                            if GuiAllowed then Window.Update(2, NbRead);
                            QtyStat := 0;
                            case NoType of
                                68, 69:
                                    if ("Quantity (Base)" <> 0) and ("Shipment No." = '') then
                                        QtyStat := "Quantity (Base)";
                                70:
                                    if ("Outstanding Qty. (Base)" <> 0) and ("Shipment No." = '') then
                                        QtyStat := "Outstanding Qty. (Base)";
                                71:
                                    if ("Qty. Shipped Not Invd. (Base)" <> 0) and ("Shipment No." = '') then
                                        QtyStat := "Qty. Shipped Not Invd. (Base)";
                            end;

                            if (QtyStat <> 0) then begin
                                StartD := StatsExplorerTools.StartDateCalc(BasePeriod, SalesHeader."Posting Date");
                                EndD := StatsExplorerTools.EndDateCalc(BasePeriod, SalesHeader."Posting Date");
                                StatisticAggregate1.Init;
                                StatisticAggregate1."Entry No." := NextEntry;
                                StatisticAggregate1."Period Length" := BasePeriod;
                                StatisticAggregate1."Ending Date" := EndD;
                                StatisticAggregate1."Entry Type" := TextType[NoType];
                                StatisticAggregate1.Type := Type.AsInteger() - 1;
                                StatisticAggregate1."No." := "No.";
                                StatisticAggregate1."Source Type" := StatisticAggregate1."Source Type"::Customer;
                                StatisticAggregate1."Source No." := "Sell-to Customer No.";
                                StatisticAggregate1."Location Code" := "Location Code";
                                StatisticAggregate1."Source Posting Group" := SalesHeader."Customer Posting Group";
                                StatisticAggregate1."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
                                StatisticAggregate1."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
                                StatisticAggregate1."Salespers./Purch. Code" := SalesHeader."Salesperson Code";
                                StatisticAggregate1."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
                                StatisticAggregate1."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
                                StatisticAggregate1."Reason Code" := SalesHeader."Reason Code";
                                StatisticAggregate1."Job No." := "Job No.";
                                StatisticAggregate1."Free date 1" := SalesHeader."Order Date";
                                //             StatisticAggregate1."Phase Code" := RowID1;
                                //             StatisticAggregate1."Task Code" := GetItemCrossRef;
                                //             StatisticAggregate1."Step Code" := GetResource;
                                StatisticAggregate1."Work Type Code" := "Work Type Code";
                                StatisticAggregate1."Campaign No." := SalesHeader."Campaign No.";
                                if "Document Type" <> "Document Type"::"Credit Memo" then
                                    StatisticAggregate1.Quantity := QtyStat
                                else
                                    StatisticAggregate1.Quantity := -QtyStat;
                                if "Quantity (Base)" = 0 then
                                    "Quantity (Base)" := 1;
                                if SalesHeader."Currency Factor" = 0 then
                                    StatisticAggregate1.Amount := Round(("Line Amount" * StatisticAggregate1.Quantity) / "Quantity (Base)")
                                else
                                    StatisticAggregate1.Amount := Round(("Line Amount" * StatisticAggregate1.Quantity) /
                                                                         "Quantity (Base)" / SalesHeader."Currency Factor");
                                StatisticAggregate1.Cost := StatisticAggregate1.Quantity * "Unit Cost (LCY)";

                                // STA-000 ABSYS BT 20061102
                                StatisticAggregate2."Free boolean 1" := "Free Line";
                                StatisticAggregate1."Free field 2" := "Reason Free Code";
                                //<<

                                UpdateDefaultValues.Run(StatisticAggregate1);
                                if SearchDim[NoType] then
                                    StatsExplorerTools.SearchDocumentDimension(StatisticAggregate1, 37, "Document Type".AsInteger(), "Document No.", "Line No.");
                                if not StatsExplorerTools.SearchAndModifyAggregate(StatisticAggregate1, StatisticAggregate2, SearchDim[NoType], NoType)
                                   then begin
                                    StatisticAggregate1.Insert;
                                    NextEntry := NextEntry + 1;
                                    NbCreated := NbCreated + 1;
                                end;
                                if GuiAllowed then Window.Update(3, NbCreated);
                            end;
                        until SalesLine.Next = 0;
                until SalesHeader.Next = 0;

        end;
    end;

    [Scope('OnPrem')]
    procedure SearchPurch(NoType: Integer)
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        StartD: Date;
        EndD: Date;
        i: Integer;
        Result: array[20] of Decimal;
        QtyStat: Decimal;
    begin
        if GuiAllowed then Window.Update(1, PurchaseLine.TableCaption + ', ' + TextType[NoType]);
        NbCreated := 0;
        with PurchaseLine do begin
            SetFilter(Type, '<>%1', Type::" ");
            PurchaseHeader.SetRange("Posting Date", 0D);
            if PurchaseHeader.Find('-') then
                repeat
                    if PurchaseHeader."Document Date" <> 0D then
                        PurchaseHeader."Posting Date" := PurchaseHeader."Document Date"
                    else
                        if PurchaseHeader."Order Date" <> 0D then
                            PurchaseHeader."Posting Date" := PurchaseHeader."Order Date"
                        else
                            PurchaseHeader."Posting Date" := WorkDate;
                    PurchaseHeader.Modify;
                until PurchaseHeader.Next = 0;
            PurchaseHeader.SetRange("Posting Date", StartDate, EndDate);

            case NoType of
                73:
                    PurchaseHeader.SetFilter("Document Type", '%1', "Document Type"::Quote);
                74:
                    PurchaseHeader.SetFilter("Document Type", '%1', "Document Type"::"Blanket Order");
                75, 76:
                    PurchaseHeader.SetFilter("Document Type", '%1|%2|%3', "Document Type"::Order, "Document Type"::Invoice,
                    "Document Type"::"Credit Memo");
            end;
            if PurchaseHeader.Find('-') then
                repeat
                    SetRange("Document Type", PurchaseHeader."Document Type");
                    SetRange("Document No.", PurchaseHeader."No.");
                    if Find('-') then
                        repeat
                            NbRead := NbRead + 1;
                            if GuiAllowed then Window.Update(2, NbRead);
                            QtyStat := 0;
                            case NoType of
                                73, 74:
                                    if ("Quantity (Base)" <> 0) and ("Receipt No." = '') then
                                        QtyStat := "Quantity (Base)";
                                75:
                                    if ("Outstanding Qty. (Base)" <> 0) and ("Receipt No." = '') then
                                        QtyStat := "Outstanding Qty. (Base)";
                                76:
                                    if ("Qty. Rcd. Not Invoiced (Base)" <> 0) and ("Receipt No." = '') then
                                        QtyStat := "Qty. Rcd. Not Invoiced (Base)";
                            end;

                            if (QtyStat <> 0) then begin
                                StartD := StatsExplorerTools.StartDateCalc(BasePeriod, PurchaseHeader."Posting Date");
                                EndD := StatsExplorerTools.EndDateCalc(BasePeriod, PurchaseHeader."Posting Date");
                                StatisticAggregate1.Init;
                                StatisticAggregate1."Entry No." := NextEntry;
                                StatisticAggregate1."Period Length" := BasePeriod;
                                StatisticAggregate1."Ending Date" := EndD;
                                StatisticAggregate1."Entry Type" := TextType[NoType];
                                StatisticAggregate1.Type := Type.AsInteger() - 1;
                                StatisticAggregate1."No." := "No.";
                                StatisticAggregate1."Source Type" := StatisticAggregate1."Source Type"::Vendor;
                                StatisticAggregate1."Source No." := "Buy-from Vendor No.";
                                StatisticAggregate1."Location Code" := "Location Code";

                                StatisticAggregate1."Source Posting Group" := PurchaseHeader."Vendor Posting Group";
                                StatisticAggregate1."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
                                StatisticAggregate1."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
                                StatisticAggregate1."Salespers./Purch. Code" := PurchaseHeader."Purchaser Code";
                                StatisticAggregate1."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
                                StatisticAggregate1."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
                                StatisticAggregate1."Reason Code" := PurchaseHeader."Reason Code";
                                StatisticAggregate1."Job No." := "Job No.";
                                //             StatisticAggregate1."Phase Code" := "Phase Code";
                                //             StatisticAggregate1."Task Code" := AdjustDateFormula;
                                //             StatisticAggregate1."Step Code" := RowID1;
                                StatisticAggregate1."Campaign No." := PurchaseHeader."Campaign No.";
                                if "Document Type" <> "Document Type"::"Credit Memo" then
                                    StatisticAggregate1.Quantity := QtyStat
                                else
                                    StatisticAggregate1.Quantity := -QtyStat;
                                if "Quantity (Base)" = 0 then
                                    "Quantity (Base)" := 1;
                                if PurchaseHeader."Currency Factor" = 0 then
                                    StatisticAggregate1.Amount := Round(("Line Amount" * StatisticAggregate1.Quantity) / "Quantity (Base)")
                                else
                                    StatisticAggregate1.Amount := Round(("Line Amount" * StatisticAggregate1.Quantity) /
                                                                         "Quantity (Base)" / PurchaseHeader."Currency Factor");
                                StatisticAggregate1.Cost := StatisticAggregate1.Quantity * "Unit Cost (LCY)";
                                UpdateDefaultValues.Run(StatisticAggregate1);
                                if SearchDim[NoType] then
                                    StatsExplorerTools.SearchDocumentDimension(StatisticAggregate1, 39, "Document Type".AsInteger(), "Document No.", "Line No.");
                                if not StatsExplorerTools.SearchAndModifyAggregate(StatisticAggregate1, StatisticAggregate2, SearchDim[NoType], NoType)
                                   then begin
                                    StatisticAggregate1.Insert;
                                    NextEntry := NextEntry + 1;
                                    NbCreated := NbCreated + 1;
                                end;
                                if GuiAllowed then Window.Update(3, NbCreated);
                            end;
                        until PurchaseLine.Next = 0;
                until PurchaseHeader.Next = 0;

        end;
    end;
}

