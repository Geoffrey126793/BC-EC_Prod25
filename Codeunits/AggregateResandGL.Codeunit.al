codeunit 8001302 "Aggregate, Res. and G/L"
{
    // //STATSEXPLORER STATSEXPLORER 01/10/01 Statistic Aggregate, invoices and purchases resource and G/L
    // 
    // //AB60408.V1  EBE 10/04/2008 Flux de vente Montants en devise  : factures et avoirs enregistrÔÇÜs
    //    - champ libre 1 = code devise (repris sur EnT”åte document)
    //    - valeur libre 1 = montant en devise (facteur devise repris sur En t”åte document)


    trigger OnRun()
    begin
        if GuiAllowed then Window.Open('#1############################## #2##### -> #3#####');
        if GuiAllowed then Window.Update(1, Treatment);
        StatisticsSetup.Get;
        StatsExplorerTools.CreateTypeArray(TextType, WorkType, SearchDim, PeriodBasis, LastEntryNo);
        if StatisticAggregate1.Find('+') then
            NextEntry := StatisticAggregate1."Entry No." + 1
        else
            NextEntry := 1;

        if DocumentType = DocumentType::All then begin
            if WorkType[5] then begin
                SearchSalesInvoice;
                SearchSalesCredit;
            end;
            if WorkType[10] then begin
                SearchPurchaseInvoice;
                SearchPurchaseCredit;
            end;
        end else begin
            if StatisticsSetup."Period total basis" <> StatisticsSetup."Period total basis"::"According to every flow" then begin
                BasePeriod := StatisticsSetup."Period total basis";
                SearchEntry;
            end else begin
                repeat
                    i := i + 1;
                    if PeriodBasis[5, i] or PeriodBasis[10, i] or PeriodBasis[40, i] or PeriodBasis[45, i] or PeriodBasis[50, i] then begin
                        BasePeriod := i - 1;
                        SearchEntry;
                    end;
                until i = 5;
            end;
        end;
        if GuiAllowed then Window.Close;
    end;

    var
        "Object": Record "Object";
        StatisticAggregate1: Record "Statistic aggregate";
        StatisticAggregate2: Record "Statistic aggregate";
        StatisticsSetup: Record "Statistics setup";
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
        FieldEnabled: array[100, 250] of Boolean;
        SearchDim: array[100] of Boolean;
        Treatment: Label 'Resource and ledger account';
        NbRead: Integer;
        NbCreated: Integer;
        NextEntry: Integer;
        DocumentType: Option All,"Sales invoice","Sales Credit","Purchase Invoice","Purchase Credit";
        DocumentNo: Code[20];
        LineNo: Integer;
        EntryNo: Integer;
        LastEntryNo: array[100] of Integer;
        i: Integer;

    [Scope('OnPrem')]
    procedure InitRequest(wStartDate: Date; wEndDate: Date; wBasePeriod: Option Day,Week,Month,Quarter,Year,Period; wDocumentType: Option All,"Sales invoice","Sales Credit","Purchase Invoice","Purchase Credit"; wDocumentNo: Code[20]; wLineNo: Integer)
    begin
        StartDate := wStartDate;
        EndDate := wEndDate;
        BasePeriod := wBasePeriod;
        DocumentType := wDocumentType;
        DocumentNo := wDocumentNo;
        LineNo := wLineNo;
    end;

    [Scope('OnPrem')]
    procedure SearchEntry()
    begin
        case DocumentType of
            DocumentType::"Sales invoice":
                if WorkType[5] then
                    SearchSalesInvoice;
            DocumentType::"Sales Credit":
                if WorkType[5] then
                    SearchSalesCredit;
            DocumentType::"Purchase Invoice":
                if WorkType[10] then
                    SearchPurchaseInvoice;
            DocumentType::"Purchase Credit":
                if WorkType[10] then
                    SearchPurchaseCredit;
        end;
    end;

    [Scope('OnPrem')]
    procedure SearchSalesInvoice()
    var
        InvoiceHeader: Record "Sales Invoice Header";
        InvoiceLine: Record "Sales Invoice Line";
        ArretTraitement: Boolean;
        StartD: Date;
        EndD: Date;
        i: Integer;
        Resultat: array[20] of Decimal;
    begin
        with InvoiceLine do begin
            InvoiceHeader.SetRange("Posting Date", StartDate, EndDate);
            if DocumentType <> DocumentType::All then begin
                InvoiceHeader.SetRange("No.", DocumentNo);
                SetRange("Document No.", DocumentNo);
                SetRange("Line No.", LineNo);
            end;
            if InvoiceHeader.Find('-') then
                repeat
                    NbRead := NbRead + 1;
                    if GuiAllowed then Window.Update(2, NbRead);
                    SetRange("Document No.", InvoiceHeader."No.");
                    SetFilter(Type, '%1|%2', Type::"G/L Account", Type::Resource);
                    if Find('-') then
                        repeat
                            NbRead := NbRead + 1;
                            if GuiAllowed then Window.Update(2, NbRead);
                            if (Quantity <> 0) or (Amount <> 0) or ("Unit Cost (LCY)" <> 0) then begin
                                StartD := StatsExplorerTools.StartDateCalc(BasePeriod, InvoiceHeader."Posting Date");
                                EndD := StatsExplorerTools.EndDateCalc(BasePeriod, InvoiceHeader."Posting Date");
                                StatisticAggregate1.Init;
                                StatisticAggregate1."Entry No." := NextEntry;
                                StatisticAggregate1."Period Length" := BasePeriod;
                                StatisticAggregate1."Ending Date" := EndD;
                                StatisticAggregate1."Entry Type" := TextType[5];
                                StatisticAggregate1.Type := Type.AsInteger() - 1;
                                StatisticAggregate1."No." := "No.";
                                StatisticAggregate1."Source Type" := StatisticAggregate1."Source Type"::Customer;
                                StatisticAggregate1."Source No." := "Sell-to Customer No.";
                                StatisticAggregate1."Location Code" := "Location Code";

                                StatisticAggregate1."Source Posting Group" := InvoiceHeader."Customer Posting Group";
                                StatisticAggregate1."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
                                StatisticAggregate1."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
                                StatisticAggregate1."Salespers./Purch. Code" := InvoiceHeader."Salesperson Code";
                                StatisticAggregate1."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
                                StatisticAggregate1."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
                                StatisticAggregate1."Reason Code" := InvoiceHeader."Reason Code";
                                StatisticAggregate1."Variant Code" := "Variant Code";
                                StatisticAggregate1."Return Reason Code" := "Return Reason Code";
                                StatisticAggregate1."Campaign No." := InvoiceHeader."Campaign No.";
                                //             StatisticAggregate1."Job No." := "Job No.";
                                //             StatisticAggregate1."Phase Code" := "Phase Code";
                                //             StatisticAggregate1."Task Code" := "Task Code";
                                //             StatisticAggregate1."Step Code" := "Step Code";
                                //             StatisticAggregate1."Work Type Code" := "Work Type Code";
                                StatisticAggregate1.Quantity := Quantity;
                                if "Quantity (Base)" = 0 then
                                    "Quantity (Base)" := 1;
                                if InvoiceHeader."Currency Factor" = 0 then begin
                                    StatisticAggregate1.Amount := Round((Amount * StatisticAggregate1.Quantity) / "Quantity (Base)");
                                    //AB60408.V1
                                    StatisticAggregate1."Free field 1" := '';
                                    StatisticAggregate1."Free value 1" := 0;
                                    //AB60408.V1
                                end else begin
                                    StatisticAggregate1.Amount := Round((Amount * StatisticAggregate1.Quantity) / "Quantity (Base)" /
                                                                         InvoiceHeader."Currency Factor");
                                    //AB60408.V1
                                    StatisticAggregate1."Free field 1" := InvoiceHeader."Currency Code";
                                    StatisticAggregate1."Free value 1" := Round((Amount * StatisticAggregate1.Quantity) / "Quantity (Base)");
                                    //AB60408.V1
                                    //AB60408.V1
                                end;
                                StatisticAggregate1.Cost := Quantity * "Unit Cost (LCY)";
                                UpdateDefaultValues.Run(StatisticAggregate1);
                                if SearchDim[5] then
                                    StatsExplorerTools.SearchPostedDocumentDimension(StatisticAggregate1, 113, "Document No.", "Line No.");
                                if not StatsExplorerTools.SearchAndModifyAggregate(StatisticAggregate1, StatisticAggregate2, SearchDim[5], 5) then begin
                                    StatisticAggregate1.Insert;
                                    NextEntry := NextEntry + 1;
                                    NbCreated := NbCreated + 1;
                                end;
                                if GuiAllowed then Window.Update(3, NbCreated);
                            end;
                        until InvoiceLine.Next = 0;
                until InvoiceHeader.Next = 0;

        end;
    end;

    [Scope('OnPrem')]
    procedure SearchSalesCredit()
    var
        InvoiceHeader: Record "Sales Cr.Memo Header";
        InvoiceLine: Record "Sales Cr.Memo Line";
        ArretTraitement: Boolean;
        StartD: Date;
        EndD: Date;
        i: Integer;
        l_Prixvente: Record "Sales PriceEC";
    begin
        with InvoiceLine do begin
            InvoiceHeader.SetRange("Posting Date", StartDate, EndDate);
            if DocumentType <> DocumentType::All then begin
                InvoiceHeader.SetRange("No.", DocumentNo);
                SetRange("Document No.", DocumentNo);
                SetRange("Line No.", LineNo);
            end;
            if InvoiceHeader.Find('-') then
                repeat
                    NbRead := NbRead + 1;
                    if GuiAllowed then Window.Update(2, NbRead);
                    SetRange("Document No.", InvoiceHeader."No.");
                    SetFilter(Type, '%1|%2', Type::"G/L Account", Type::Resource);
                    if Find('-') then
                        repeat
                            if (Quantity <> 0) or (Amount <> 0) or ("Unit Cost (LCY)" <> 0) then begin
                                StartD := StatsExplorerTools.StartDateCalc(BasePeriod, InvoiceHeader."Posting Date");
                                EndD := StatsExplorerTools.EndDateCalc(BasePeriod, InvoiceHeader."Posting Date");
                                StatisticAggregate1.Init;
                                StatisticAggregate1."Entry No." := NextEntry;
                                StatisticAggregate1."Period Length" := BasePeriod;
                                StatisticAggregate1."Ending Date" := EndD;
                                StatisticAggregate1."Entry Type" := TextType[5];
                                StatisticAggregate1.Type := Type.AsInteger() - 1;
                                StatisticAggregate1."No." := "No.";
                                StatisticAggregate1."Source Type" := StatisticAggregate1."Source Type"::Customer;
                                StatisticAggregate1."Source No." := "Sell-to Customer No.";
                                StatisticAggregate1."Location Code" := "Location Code";

                                StatisticAggregate1."Source Posting Group" := InvoiceHeader."Customer Posting Group";
                                StatisticAggregate1."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
                                StatisticAggregate1."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
                                StatisticAggregate1."Salespers./Purch. Code" := InvoiceHeader."Salesperson Code";
                                StatisticAggregate1."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
                                StatisticAggregate1."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
                                StatisticAggregate1."Reason Code" := InvoiceHeader."Reason Code";
                                StatisticAggregate1."Variant Code" := "Variant Code";
                                StatisticAggregate1."Return Reason Code" := "Return Reason Code";
                                StatisticAggregate1."Campaign No." := InvoiceHeader."Campaign No.";
                                StatisticAggregate1.Quantity := -Quantity;
                                if "Quantity (Base)" = 0 then
                                    "Quantity (Base)" := 1;
                                if InvoiceHeader."Currency Factor" = 0 then begin
                                    StatisticAggregate1.Amount := Round((Amount * StatisticAggregate1.Quantity) / "Quantity (Base)");
                                    //AB60408.V1
                                    StatisticAggregate1."Free field 1" := '';
                                    StatisticAggregate1."Free value 1" := 0;  //AB60408.V1
                                                                              //AB60408.V1
                                end else begin
                                    StatisticAggregate1.Amount := Round((Amount * StatisticAggregate1.Quantity) / "Quantity (Base)" /
                                                                         InvoiceHeader."Currency Factor");
                                    //AB60408.V1
                                    StatisticAggregate1."Free field 1" := InvoiceHeader."Currency Code";
                                    StatisticAggregate1."Free value 1" := Round((Amount * StatisticAggregate1.Quantity) / "Quantity (Base)");
                                    //AB60408.V1
                                    //AB60408.V1
                                end;
                                StatisticAggregate1."Free value 2" := StatisticAggregate1.Amount;
                                StatisticAggregate1.Cost := -Quantity * "Unit Cost (LCY)";
                                UpdateDefaultValues.Run(StatisticAggregate1);
                                if SearchDim[5] then
                                    StatsExplorerTools.SearchPostedDocumentDimension(StatisticAggregate1, 115, "Document No.", "Line No.");
                                if not StatsExplorerTools.SearchAndModifyAggregate(StatisticAggregate1, StatisticAggregate2, SearchDim[5], 5) then begin
                                    StatisticAggregate1.Insert;
                                    NextEntry := NextEntry + 1;
                                    NbCreated := NbCreated + 1;
                                end;
                                if GuiAllowed then Window.Update(3, NbCreated);
                            end;
                        until InvoiceLine.Next = 0;
                until InvoiceHeader.Next = 0;

        end;
    end;

    [Scope('OnPrem')]
    procedure SearchPurchaseInvoice()
    var
        InvoiceHeader: Record "Purch. Inv. Header";
        InvoiceLine: Record "Purch. Inv. Line";
        ArretTraitement: Boolean;
        StartD: Date;
        EndD: Date;
        i: Integer;
        Resultat: array[20] of Decimal;
    begin
        with InvoiceLine do begin
            InvoiceHeader.SetRange("Posting Date", StartDate, EndDate);
            if DocumentType <> DocumentType::All then begin
                InvoiceHeader.SetRange("No.", DocumentNo);
                SetRange("Document No.", DocumentNo);
                SetRange("Line No.", LineNo);
            end;
            if InvoiceHeader.Find('-') then
                repeat
                    NbRead := NbRead + 1;
                    if GuiAllowed then Window.Update(2, NbRead);
                    SetRange("Document No.", InvoiceHeader."No.");
                    SetFilter(Type, '%1|%2', Type::"G/L Account", Type::"Fixed Asset");
                    if Find('-') then
                        repeat
                            if (Quantity <> 0) or (Amount <> 0) or ("Unit Cost (LCY)" <> 0) then begin
                                StartD := StatsExplorerTools.StartDateCalc(BasePeriod, InvoiceHeader."Posting Date");
                                EndD := StatsExplorerTools.EndDateCalc(BasePeriod, InvoiceHeader."Posting Date");
                                StatisticAggregate1.Init;
                                StatisticAggregate1."Entry No." := NextEntry;
                                StatisticAggregate1."Period Length" := BasePeriod;
                                StatisticAggregate1."Ending Date" := EndD;
                                StatisticAggregate1."Entry Type" := TextType[10];
                                StatisticAggregate1.Type := Type.AsInteger() - 1;
                                StatisticAggregate1."No." := "No.";
                                StatisticAggregate1."Source Type" := StatisticAggregate1."Source Type"::Vendor;
                                StatisticAggregate1."Source No." := "Buy-from Vendor No.";
                                StatisticAggregate1."Location Code" := "Location Code";

                                StatisticAggregate1."Source Posting Group" := InvoiceHeader."Vendor Posting Group";
                                StatisticAggregate1."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
                                StatisticAggregate1."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
                                StatisticAggregate1."Salespers./Purch. Code" := InvoiceHeader."Purchaser Code";
                                StatisticAggregate1."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
                                StatisticAggregate1."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
                                StatisticAggregate1."Reason Code" := InvoiceHeader."Reason Code";
                                StatisticAggregate1."Variant Code" := "Variant Code";
                                StatisticAggregate1."Return Reason Code" := "Return Reason Code";
                                //             StatisticAggregate1."Job No." := "Job No.";
                                //             StatisticAggregate1."Phase Code" := "Phase Code";
                                //             StatisticAggregate1."Task Code" := "Task Code";
                                //             StatisticAggregate1."Step Code" := "Step Code";
                                StatisticAggregate1.Quantity := Quantity;
                                if "Quantity (Base)" = 0 then
                                    "Quantity (Base)" := 1;
                                if InvoiceHeader."Currency Factor" = 0 then
                                    StatisticAggregate1.Amount := Round((Amount * StatisticAggregate1.Quantity) / "Quantity (Base)")
                                else
                                    StatisticAggregate1.Amount := Round((Amount * StatisticAggregate1.Quantity) / "Quantity (Base)" /
                                                                         InvoiceHeader."Currency Factor");
                                StatisticAggregate1.Cost := Quantity * "Unit Cost (LCY)";
                                UpdateDefaultValues.Run(StatisticAggregate1);
                                if SearchDim[10] then
                                    StatsExplorerTools.SearchPostedDocumentDimension(StatisticAggregate1, 123, "Document No.", "Line No.");
                                if not StatsExplorerTools.SearchAndModifyAggregate(StatisticAggregate1, StatisticAggregate2, SearchDim[10], 10) then begin
                                    StatisticAggregate1.Insert;
                                    NextEntry := NextEntry + 1;
                                    NbCreated := NbCreated + 1;
                                end;
                                if GuiAllowed then Window.Update(3, NbCreated);
                            end;
                        until InvoiceLine.Next = 0;
                until InvoiceHeader.Next = 0;

        end;
    end;

    [Scope('OnPrem')]
    procedure SearchPurchaseCredit()
    var
        InvoiceHeader: Record "Purch. Cr. Memo Hdr.";
        InvoiceLine: Record "Purch. Cr. Memo Line";
        ArretTraitement: Boolean;
        StartD: Date;
        EndD: Date;
        i: Integer;
    begin
        with InvoiceLine do begin
            if DocumentType <> DocumentType::All then begin
                InvoiceHeader.SetRange("No.", DocumentNo);
                SetRange("Document No.", DocumentNo);
                SetRange("Line No.", LineNo);
            end;
            InvoiceHeader.SetRange("Posting Date", StartDate, EndDate);
            if InvoiceHeader.Find('-') then
                repeat
                    SetRange("Document No.", InvoiceHeader."No.");
                    SetFilter(Type, '%1|%2', Type::"G/L Account", Type::"Fixed Asset");
                    if Find('-') then
                        repeat
                            NbRead := NbRead + 1;
                            if GuiAllowed then Window.Update(2, NbRead);
                            if (Quantity <> 0) or (Amount <> 0) or ("Unit Cost (LCY)" <> 0) then begin
                                StartD := StatsExplorerTools.StartDateCalc(BasePeriod, InvoiceHeader."Posting Date");
                                EndD := StatsExplorerTools.EndDateCalc(BasePeriod, InvoiceHeader."Posting Date");
                                StatisticAggregate1.Init;
                                StatisticAggregate1."Entry No." := NextEntry;
                                StatisticAggregate1."Period Length" := BasePeriod;
                                StatisticAggregate1."Ending Date" := EndD;
                                StatisticAggregate1."Entry Type" := TextType[10];
                                StatisticAggregate1.Type := Type.AsInteger() - 1;
                                StatisticAggregate1."No." := "No.";
                                StatisticAggregate1."Source Type" := StatisticAggregate1."Source Type"::Vendor;
                                StatisticAggregate1."Source No." := "Buy-from Vendor No.";
                                StatisticAggregate1."Location Code" := "Location Code";

                                StatisticAggregate1."Source Posting Group" := InvoiceHeader."Vendor Posting Group";
                                StatisticAggregate1."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
                                StatisticAggregate1."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
                                StatisticAggregate1."Salespers./Purch. Code" := InvoiceHeader."Purchaser Code";
                                StatisticAggregate1."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
                                StatisticAggregate1."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
                                StatisticAggregate1."Reason Code" := InvoiceHeader."Reason Code";
                                StatisticAggregate1."Variant Code" := "Variant Code";
                                StatisticAggregate1."Return Reason Code" := "Return Reason Code";
                                //             StatisticAggregate1."Job No." := "Job No.";
                                //             StatisticAggregate1."Phase Code" := "Phase Code";
                                //             StatisticAggregate1."Task Code" := "Task Code";
                                //             StatisticAggregate1."Step Code" := "Step Code";
                                StatisticAggregate1.Quantity := -Quantity;
                                if "Quantity (Base)" = 0 then
                                    "Quantity (Base)" := 1;
                                if InvoiceHeader."Currency Factor" = 0 then
                                    StatisticAggregate1.Amount := Round((Amount * StatisticAggregate1.Quantity) / "Quantity (Base)")
                                else
                                    StatisticAggregate1.Amount := Round((Amount * StatisticAggregate1.Quantity) / "Quantity (Base)" /
                                                                         InvoiceHeader."Currency Factor");
                                StatisticAggregate1.Cost := -Quantity * "Unit Cost (LCY)";
                                if SearchDim[10] then
                                    StatsExplorerTools.SearchPostedDocumentDimension(StatisticAggregate1, 125, "Document No.", "Line No.");
                                UpdateDefaultValues.Run(StatisticAggregate1);
                                if not StatsExplorerTools.SearchAndModifyAggregate(StatisticAggregate1, StatisticAggregate2, SearchDim[10], 10) then begin
                                    StatisticAggregate1.Insert;
                                    NextEntry := NextEntry + 1;
                                    NbCreated := NbCreated + 1;
                                end;
                                if GuiAllowed then Window.Update(3, NbCreated);
                            end;
                        until InvoiceLine.Next = 0;
                until InvoiceHeader.Next = 0;

        end;
    end;
}

