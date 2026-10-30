report 50041 "Customer - Credit Blocked"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/CustomerCreditBlocked.rdlc';
    ApplicationArea = Basic, Suite;
    Caption = 'Customer statement';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Sales HeaderCust"; "Sales Header")
        {
            dataitem(Customer; Customer)
            {
                DataItemLink = "No." = FIELD("Sell-to Customer No.");
                DataItemTableView = SORTING("No.");
                PrintOnlyIfDetail = true;
                RequestFilterFields = "No.", "Date Filter", Blocked;
                column(TodayFormatted; Format(Today, 0, 4))
                {
                }
                column(TxtCustGeTranmaxDtFilter; StrSubstNo(Text000, Format(GetRangeMax("Date Filter"))))
                {
                }
                column(CompanyName; COMPANYPROPERTY.DisplayName)
                {
                }
                column(PrintOnePrPage; PrintOnePrPage)
                {
                }
                column(CustFilter; CustFilter)
                {
                }
                column(PrintAmountInLCY; PrintAmountInLCY)
                {
                }
                column(CustTableCaptCustFilter; TableCaption + ': ' + CustFilter)
                {
                }
                column(No_Customer; "No.")
                {
                }
                column(Name_Customer; Name)
                {
                }
                column(PhoneNo_Customer; "Phone No.")
                {
                    IncludeCaption = true;
                }
                column(CustBalancetoDateCaption; CustBalancetoDateCaptionLbl)
                {
                }
                column(CustLedgEntryDueDtCaption; CustLedgEntryDueDtCaptionLbl)
                {
                }
                column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
                {
                }
                column(AllamtsareinLCYCaption; AllamtsareinLCYCaptionLbl)
                {
                }
                column(CustLedgEntryPostingDtCaption; CustLedgEntryPostingDtCaptionLbl)
                {
                }
                column(OriginalAmtCaption; OriginalAmtCaptionLbl)
                {
                }
                column(CreditLimitLCY_Customer; Customer."Credit Limit (LCY)")
                {
                }
                column(Ligne1; Ligne1)
                {
                }
                column(Ligne2; Ligne2)
                {
                }
                column(Ligne3; Ligne3)
                {
                }
                column(Ligne4; Ligne4)
                {
                }
                column(Ligne5; Ligne5)
                {
                }
                column(Ligne6; Ligne6)
                {
                }
                column(Ligne7; Ligne7)
                {
                }
                dataitem(CustLedgEntry3; "Cust. Ledger Entry")
                {
                    DataItemTableView = SORTING("Entry No.");
                    column(PostingDt_CustLedgEntry; Format("Posting Date"))
                    {
                        IncludeCaption = false;
                    }
                    column(DueDate; "Due Date")
                    {
                    }
                    column(DocType_CustLedgEntry; "Document Type")
                    {
                        IncludeCaption = true;
                    }
                    column(DocNo_CustLedgEntry; "Document No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Desc_CustLedgEntry; Description)
                    {
                        IncludeCaption = true;
                    }
                    column(OriginalAmt; OriginalAmt)
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(EntryNo_CustLedgEntry; "Entry No.")
                    {
                        IncludeCaption = true;
                    }
                    column(CumulAmt; CumulAmt)
                    {
                    }
                    column(CurrencyCode; CurrencyCode)
                    {
                    }
                    dataitem("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
                    {
                        DataItemLink = "Cust. Ledger Entry No." = FIELD("Entry No."), "Posting Date" = FIELD("Date Filter");
                        DataItemTableView = SORTING("Cust. Ledger Entry No.", "Posting Date") WHERE("Entry Type" = FILTER(<> "Initial Entry"));
                        column(EntType_DtldCustLedgEnt; "Entry Type")
                        {
                        }
                        column(postDt_DtldCustLedgEntry; Format("Posting Date"))
                        {
                        }
                        column(DocType_DtldCustLedgEntry; "Document Type")
                        {
                        }
                        column(DocNo_DtldCustLedgEntry; "Document No.")
                        {
                        }
                        column(Amt; Amt)
                        {
                            AutoFormatExpression = CurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(CurrencyCodeDtldCustLedgEntry; CurrencyCode)
                        {
                        }
                        column(EntNo_DtldCustLedgEntry; DtldCustLedgEntryNum)
                        {
                        }
                        column(RemainingAmt; RemainingAmt)
                        {
                            AutoFormatExpression = CurrencyCode;
                            AutoFormatType = 1;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if not PrintUnappliedEntries then
                                if Unapplied then
                                    CurrReport.Skip;

                            if PrintAmountInLCY then begin
                                Amt := "Amount (LCY)";
                                CurrencyCode := '';
                            end else begin
                                Amt := Amount;
                                CurrencyCode := "Currency Code";
                            end;
                            if Amt = 0 then
                                CurrReport.Skip;

                            DtldCustLedgEntryNum := DtldCustLedgEntryNum + 1;
                        end;

                        trigger OnPreDataItem()
                        begin
                            DtldCustLedgEntryNum := 0;
                            CustLedgEntry3.CopyFilter("Posting Date", "Posting Date");
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if PrintAmountInLCY then begin
                            CalcFields("Original Amt. (LCY)", "Remaining Amt. (LCY)");
                            OriginalAmt := "Original Amt. (LCY)";
                            RemainingAmt := "Remaining Amt. (LCY)";
                            CurrencyCode := '';
                        end else begin
                            CalcFields("Original Amount", "Remaining Amount");
                            OriginalAmt := "Original Amount";
                            RemainingAmt := "Remaining Amount";
                            CurrencyCode := "Currency Code";
                        end;
                        CumulAmt += OriginalAmt;
                    end;

                    trigger OnPreDataItem()
                    var
                        TempCustLedgerEntry: Record "Cust. Ledger Entry" temporary;
                        ClosedEntryIncluded: Boolean;
                    begin
                        Reset;
                        SetRange("Date Filter", 0D, MaxDate);
                        FilterCustLedgerEntry(CustLedgEntry3);
                        if FindSet then
                            repeat
                                if not Open then
                                    ClosedEntryIncluded := CheckCustEntryIncluded("Entry No.");
                                if Open or ClosedEntryIncluded then begin
                                    Mark(true);
                                    TempCustLedgerEntry := CustLedgEntry3;
                                    TempCustLedgerEntry.Insert;
                                end;
                            until Next = 0;

                        SetCurrentKey("Entry No.");
                        MarkedOnly(true);

                        AddCustomerDimensionFilter(CustLedgEntry3);

                        CalcCustomerTotalAmount(TempCustLedgerEntry);
                    end;
                }
                dataitem("Sales Header"; "Sales Header")
                {
                    DataItemLink = "Sell-to Customer No." = FIELD("No.");
                    column(Cmd; 'Commande')
                    {
                    }
                    column(No_SalesHeader; "Sales Header"."No.")
                    {
                    }
                    column(YourReference_SalesHeader; "Sales Header"."Your Reference")
                    {
                    }
                    column(OrderDate_SalesHeader; "Sales Header"."Order Date")
                    {
                    }
                    column(Amount_SalesHeader; "Sales Header".Amount)
                    {
                    }
                    column(Commandebloquee_SalesHeader; "Sales Header"."Commande bloquee")
                    {
                    }
                    column(CumulAmtCmd; CumulAmt)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        "Sales Header".CalcFields(Amount);
                        CumulAmt += "Sales Header".Amount;
                    end;
                }
                dataitem(Integer2; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                    column(CustName; Customer.Name)
                    {
                    }
                    column(TtlAmtCurrencyTtlBuff; CurrencyTotalBuffer."Total Amount")
                    {
                        AutoFormatExpression = CurrencyTotalBuffer."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(CurryCode_CurrencyTtBuff; CurrencyTotalBuffer."Currency Code")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if Number = 1 then
                            OK := CurrencyTotalBuffer.Find('-')
                        else
                            OK := CurrencyTotalBuffer.Next <> 0;
                        if not OK then
                            CurrReport.Break;

                        CurrencyTotalBuffer2.UpdateTotal(
                          CurrencyTotalBuffer."Currency Code",
                          CurrencyTotalBuffer."Total Amount",
                          0,
                          Counter1);
                    end;

                    trigger OnPostDataItem()
                    begin
                        CurrencyTotalBuffer.DeleteAll;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if not ShowEntriesWithZeroBalance then
                            CurrencyTotalBuffer.SetFilter("Total Amount", '<>0');
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if MaxDate = 0D then
                        Error(BlankMaxDateErr);

                    SetRange("Date Filter", 0D, MaxDate);
                    CalcFields("Net Change (LCY)", "Net Change");

                    if (PrintAmountInLCY and ("Net Change (LCY)" = 0) or
                        (not PrintAmountInLCY) and ("Net Change" = 0)) and
                       (not ShowEntriesWithZeroBalance)
                    then
                        CurrReport.Skip;
                    CumulAmt := 0;
                end;


            }

            trigger OnAfterGetRecord()
            var
                Cust: Record Customer;
            begin
                Cust.Get("Sales HeaderCust"."Sell-to Customer No.");

                Ligne1 := TxtLigne1;
                if ("Sales HeaderCust"."Confirmation envoyée") then begin
                    if "Sales HeaderCust"."Your Reference" <> '' then
                        Ligne2 := StrSubstNo(TxtLigne2B, "Sales HeaderCust"."Your Reference")
                    else
                        Ligne2 := StrSubstNo(TxtLigne2B, "Sales HeaderCust"."No.");
                    Ligne3 := TxtLigne3;
                    Ligne4 := TxtLigne4;
                    Ligne5 := StrSubstNo(TxtLigne5, CuSales.GetEnCours("Sales HeaderCust"."Sell-to Customer No."), Cust."Credit Limit (LCY)");//en cours / limite
                    Ligne6 := TxtLigne6;
                    Ligne7 := TxtLigne7;
                end
                else begin
                    if "Sales HeaderCust"."Your Reference" <> '' then
                        Ligne2 := StrSubstNo(TxtLigne2A, "Sales HeaderCust"."Your Reference")
                    else
                        Ligne2 := StrSubstNo(TxtLigne2A, "Sales HeaderCust"."No.");
                    Ligne3 := TxtLigne4;
                    Ligne4 := StrSubstNo(TxtLigne5, CuSales.GetEnCours("Sales HeaderCust"."Sell-to Customer No."), Cust."Credit Limit (LCY)");//en cours / limite
                    Ligne5 := TxtLigne6;
                    Ligne6 := TxtLigne7;
                end;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field("Ending Date"; MaxDate)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Ending Date';
                        ToolTip = 'Specifies the last date until which information in the report is shown. If left blank, the report shows information until the present time.';
                    }
                    field(PrintAmountInLCY; PrintAmountInLCY)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Show Amounts in LCY';
                        ToolTip = 'Specifies if amounts in the report are displayed in LCY. If you leave the check box blank, amounts are shown in foreign currencies.';
                    }
                    field(PrintOnePrPage; PrintOnePrPage)
                    {
                        ApplicationArea = Suite;
                        Caption = 'New Page per Customer';
                        ToolTip = 'Specifies if each customer balance is printed on a separate page, in case two or more customers are included in the report.';
                    }
                    field(PrintUnappliedEntries; PrintUnappliedEntries)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Include Unapplied Entries';
                        ToolTip = 'Specifies if unapplied entries are included in the report.';
                    }
                    field(ShowEntriesWithZeroBalance; ShowEntriesWithZeroBalance)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Show Entries with Zero Balance';
                        ToolTip = 'Specifies if the report must include entries with a balance of 0. By default, the report only includes entries with a positive or negative balance.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        FormatDocument: Codeunit "Format Document";
    begin
        CustFilter := FormatDocument.GetRecordFiltersWithCaptions(Customer);
    end;

    var
        Text000: Label 'Balance on %1';
        CurrencyTotalBuffer: Record "Currency Total Buffer" temporary;
        CurrencyTotalBuffer2: Record "Currency Total Buffer" temporary;
        PrintAmountInLCY: Boolean;
        PrintOnePrPage: Boolean;
        ShowEntriesWithZeroBalance: Boolean;
        CustFilter: Text;
        MaxDate: Date;
        OriginalAmt: Decimal;
        Amt: Decimal;
        RemainingAmt: Decimal;
        Counter1: Integer;
        DtldCustLedgEntryNum: Integer;
        OK: Boolean;
        CurrencyCode: Code[10];
        PrintUnappliedEntries: Boolean;
        CustBalancetoDateCaptionLbl: Label 'Customer : Statment';
        CurrReportPageNoCaptionLbl: Label 'Page';
        AllamtsareinLCYCaptionLbl: Label 'All amounts are in LCY.';
        CustLedgEntryPostingDtCaptionLbl: Label 'Posting Date';
        CustLedgEntryDueDtCaptionLbl: Label 'Due Date';
        OriginalAmtCaptionLbl: Label 'Amount';
        TotalCaptionLbl: Label 'Total';
        BlankMaxDateErr: Label 'Ending Date must have a value.';
        CumulAmt: Decimal;
        TxtLigne1: Label 'Cher client,';
        TxtLigne2A: Label 'Nous vous remercions de votre commande avec ref. %1 que nous avons enregistrée.';
        TxtLigne4: Label 'Dès que le montant de l’encours le permettra, nous pourrons vous confirmer la date de livraison.';
        TxtLigne5: Label 'Actuellement votre encours vaut %1 EUR contre une limite de crédit de %2 EUR.';
        TxtLigne6: Label 'Nous vous prions gentiment d’effectuer le paiement des factures ouvertes afin de réduire votre encours en dessous de votre limite de crédit';
        TxtLigne7: Label 'Veuillez trouver ci-joint le détail de votre situation';
        TxtLigne2B: Label 'Nous sommes désolés de devoir bloquer la livraison de la commande avec ref. %1 déjà confirmée.';
        TxtLigne3: Label 'La raison concerne le dépassement de votre encours en comparaison avec votre limite de crédit.';
        Ligne1: Text;
        Ligne2: Text;
        Ligne3: Text;
        Ligne4: Text;
        Ligne5: Text;
        Ligne6: Text;
        Ligne7: Text;
        CuSales: Codeunit Integration_Sales;

    procedure InitializeRequest(NewPrintAmountInLCY: Boolean; NewPrintOnePrPage: Boolean; NewPrintUnappliedEntries: Boolean; NewEndingDate: Date)
    begin
        PrintAmountInLCY := NewPrintAmountInLCY;
        PrintOnePrPage := NewPrintOnePrPage;
        PrintUnappliedEntries := NewPrintUnappliedEntries;
        MaxDate := NewEndingDate;
    end;

    local procedure FilterCustLedgerEntry(var CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        with CustLedgerEntry do begin
            SetCurrentKey("Customer No.", "Posting Date");
            SetRange("Customer No.", Customer."No.");
            SetRange("Posting Date", 0D, MaxDate);
        end;
    end;

    local procedure AddCustomerDimensionFilter(var CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        with CustLedgerEntry do begin
            if Customer.GetFilter("Global Dimension 1 Filter") <> '' then
                SetFilter("Global Dimension 1 Code", Customer.GetFilter("Global Dimension 1 Filter"));
            if Customer.GetFilter("Global Dimension 2 Filter") <> '' then
                SetFilter("Global Dimension 2 Code", Customer.GetFilter("Global Dimension 2 Filter"));
            if Customer.GetFilter("Currency Filter") <> '' then
                SetFilter("Currency Code", Customer.GetFilter("Currency Filter"));
        end;
    end;

    local procedure CalcCustomerTotalAmount(var TempCustLedgerEntry: Record "Cust. Ledger Entry" temporary)
    begin
        with TempCustLedgerEntry do begin
            SetCurrentKey("Entry No.");
            SetRange("Date Filter", 0D, MaxDate);
            AddCustomerDimensionFilter(TempCustLedgerEntry);
            if FindSet then
                repeat
                    if PrintAmountInLCY then begin
                        CalcFields("Remaining Amt. (LCY)");
                        RemainingAmt := "Remaining Amt. (LCY)";
                        CurrencyCode := '';
                    end else begin
                        CalcFields("Remaining Amount");
                        RemainingAmt := "Remaining Amount";
                        CurrencyCode := "Currency Code";
                    end;
                    if RemainingAmt <> 0 then
                        CurrencyTotalBuffer.UpdateTotal(
                          CurrencyCode,
                          RemainingAmt,
                          0,
                          Counter1);
                until Next = 0;
        end;
    end;

    local procedure CheckCustEntryIncluded(EntryNo: Integer): Boolean
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        if CustLedgerEntry.Get(EntryNo) and (CustLedgerEntry."Posting Date" <= MaxDate) then begin
            CustLedgerEntry.SetRange("Date Filter", 0D, MaxDate);
            CustLedgerEntry.CalcFields("Remaining Amount");
            if CustLedgerEntry."Remaining Amount" <> 0 then
                exit(true);
            if PrintUnappliedEntries then
                exit(CheckUnappliedEntryExists(EntryNo));
        end;
        exit(false);
    end;

    local procedure CheckUnappliedEntryExists(EntryNo: Integer): Boolean
    var
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        with DetailedCustLedgEntry do begin
            SetCurrentKey("Cust. Ledger Entry No.", "Entry Type", "Posting Date");
            SetRange("Cust. Ledger Entry No.", EntryNo);
            SetRange("Entry Type", "Entry Type"::Application);
            SetFilter("Posting Date", '>%1', MaxDate);
            SetRange(Unapplied, true);
            exit(not IsEmpty);
        end;
    end;
}

