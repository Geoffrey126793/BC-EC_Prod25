report 50060 "Customer - Vendor Balance"
{
    // AC>
    // 
    //   LBO JUILLET 2002
    // 
    //   Basé sur le report 104, dans lequel on a rajouté la balance fournisseur pour les clients qui sont aussi fournisseurs
    // 
    // AC<
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/CustomerVendorBalance.rdlc';

    Caption = 'Customer - Vendor Balance';

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", "Customer Posting Group", "Date Filter", "Address Optional Invoice";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(STRSUBSTNO_Text000_CustDateFilter_; StrSubstNo(Text000, CustDateFilter))
            {
            }
            column(CurrReport_PAGENO; 1)
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(USERID; UserId)
            {
            }
            column(Customer_TABLECAPTION__________CustFilter; Customer.TableCaption + ': ' + CustFilter)
            {
            }
            column(AmountCaption; AmountCaption)
            {
            }
            column(RemainingAmtCaption; RemainingAmtCaption)
            {
            }
            column(RemainingAmtCaptionLCY; RemainingAmtCaptionLCY)
            {
            }
            column(AmountCaptionLCY; AmountCaptionLCY)
            {
            }
            column(Customer__No__; "No.")
            {
            }
            column(Customer_Name; Name)
            {
            }
            column(Customer___BalanceCaption; Customer___BalanceCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(All_amounts_are_in_LCYCaption; All_amounts_are_in_LCYCaptionLbl)
            {
            }
            column(This_report_also_includes_customers_that_only_have_balances_Caption; This_report_also_includes_customers_that_only_have_balances_CaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Posting_Date_Caption; "Cust. Ledger Entry".FieldCaption("Posting Date"))
            {
            }
            column(Cust__Ledger_Entry__Document_Type_Caption; Cust__Ledger_Entry__Document_Type_CaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Document_No__Caption; "Cust. Ledger Entry".FieldCaption("Document No."))
            {
            }
            column(Cust__Ledger_Entry_DescriptionCaption; "Cust. Ledger Entry".FieldCaption(Description))
            {
            }
            column(CustEntryDueDateCaption; CustEntryDueDateCaptionLbl)
            {
            }
            column(CustBalanceLCYCaption; CustBalanceLCYCaptionLbl)
            {
            }
            column(Customer_No_Caption; Customer_No_CaptionLbl)
            {
            }
            column(Customer_Date_Filter; "Date Filter")
            {
            }
            column(Customer_Global_Dimension_2_Filter; "Global Dimension 2 Filter")
            {
            }
            column(Customer_Global_Dimension_1_Filter; "Global Dimension 1 Filter")
            {
            }
            column(Customer_Vendor_No_; "Vendor No.")
            {
            }
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Date Filter" = FIELD("Date Filter");
                DataItemTableView = SORTING("Customer No.", "Posting Date");
                column(Cust__Ledger_Entry__Posting_Date_; "Posting Date")
                {
                }
                column(Cust__Ledger_Entry__Document_Type_; "Document Type")
                {
                }
                column(Cust__Ledger_Entry__Document_No__; "Document No.")
                {
                }
                column(Cust__Ledger_Entry_Description; Description)
                {
                }
                column(CustAmount; CustAmount)
                {
                    AutoFormatExpression = CustCurrencyCode;
                    AutoFormatType = 1;
                }
                column(CustRemainAmount; CustRemainAmount)
                {
                    AutoFormatExpression = CustCurrencyCode;
                    AutoFormatType = 1;
                }
                column(CustEntryDueDate; CustEntryDueDate)
                {
                }
                column(CustCurrencyCode; CustCurrencyCode)
                {
                }
                column(CustBalanceLCY; CustBalanceLCY)
                {
                    AutoFormatType = 1;
                }
                column(CustRemainAmountLCY; CustRemainAmountLCY)
                {
                    AutoFormatType = 1;
                }
                column(CustAmountLCY; CustAmountLCY)
                {
                    AutoFormatType = 1;
                }
                column(Cust__Ledger_Entry_Entry_No_; "Entry No.")
                {
                }
                column(Cust__Ledger_Entry_Customer_No_; "Customer No.")
                {
                }
                column(Cust__Ledger_Entry_Global_Dimension_2_Code; "Global Dimension 2 Code")
                {
                }
                column(Cust__Ledger_Entry_Global_Dimension_1_Code; "Global Dimension 1 Code")
                {
                }
                column(Cust__Ledger_Entry_Date_Filter; "Date Filter")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CalcFields(Amount, "Remaining Amount", "Amount (LCY)", "Remaining Amt. (LCY)");

                    CustLedgEntryExists := true;
                    if PrintAmountsInLCY then begin
                        CustAmount := "Amount (LCY)";
                        CustAmountLCY := "Amount (LCY)";
                        CustRemainAmountLCY := "Remaining Amt. (LCY)";
                        CustRemainAmount := "Remaining Amount";
                        CustCurrencyCode := '';
                    end else begin
                        CustAmount := Amount;
                        CustAmountLCY := "Amount (LCY)";
                        CustRemainAmountLCY := "Remaining Amt. (LCY)";
                        CustRemainAmount := "Remaining Amount";
                        CustCurrencyCode := "Currency Code";
                    end;
                    CustBalanceLCY := CustBalanceLCY + "Amount (LCY)";
                    if "Document Type" = "Document Type"::Payment then
                        CustEntryDueDate := 0D
                    else
                        CustEntryDueDate := "Due Date";
                end;

                trigger OnPreDataItem()
                begin
                    CustLedgEntryExists := false;

                end;
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(Customer_Name_Control48; Customer.Name)
                {
                }
                column(StartBalanceLCY____Cust__Ledger_Entry___Amount__LCY__; StartBalanceLCY + "Cust. Ledger Entry"."Amount (LCY)")
                {
                    AutoFormatType = 1;
                }
                column(CustRemainAmountLCY_Control1000000024; CustRemainAmountLCY)
                {
                    AutoFormatType = 1;
                }
                column(CustAmountLCY_Control1000000045; CustAmountLCY)
                {
                    AutoFormatType = 1;
                }
                column(Customer_Name_Control15; Customer.Name)
                {
                }
                column(StartBalanceLCY____Cust__Ledger_Entry___Amount__LCY___Control17; StartBalanceLCY + "Cust. Ledger Entry"."Amount (LCY)")
                {
                    AutoFormatType = 1;
                }
                column(CustAmount_Control49; CustAmount)
                {
                    AutoFormatExpression = CustCurrencyCode;
                    AutoFormatType = 1;
                }
                column(CustRemainAmountLCY_Control1000000023; CustRemainAmountLCY)
                {
                    AutoFormatType = 1;
                }
                column(CustRemainAmount_Control1000000042; CustRemainAmount)
                {
                    AutoFormatExpression = CustCurrencyCode;
                    AutoFormatType = 1;
                }
                column(CustAmountLCY_Control1000000044; CustAmountLCY)
                {
                    AutoFormatType = 1;
                }
                column(StartBalanceLCY____Cust__Ledger_Entry___Amount__LCY___Control1000000030; StartBalanceLCY + "Cust. Ledger Entry"."Amount (LCY)")
                {
                    AutoFormatType = 1;
                }
                column(CustRemainAmountLCY_Control1000000028; CustRemainAmountLCY)
                {
                    AutoFormatType = 1;
                }
                column(CustAmountLCY_Control1000000046; CustAmountLCY)
                {
                    AutoFormatType = 1;
                }
                column(Customer_Total__LCY_Caption; Customer_Total__LCY_CaptionLbl)
                {
                }
                column(Integer_Number; Number)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if not CustLedgEntryExists and ((StartBalanceLCY = 0) or not PrintAllHavingBal) then begin
                        StartBalanceLCY := 0;
                        CurrReport.Skip;
                    end;
                end;
            }
            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No." = FIELD("Vendor No.");
                DataItemTableView = SORTING("Vendor No.", "Posting Date", "Currency Code");
                column(Vendor_Ledger_Entry__Vendor_No__; "Vendor No.")
                {
                }
                column(txtVendorName; txtVendorName)
                {
                }
                column(Vendor_Ledger_Entry__Posting_Date_; "Posting Date")
                {
                }
                column(Vendor_Ledger_Entry__Document_Type_; "Document Type")
                {
                }
                column(Vendor_Ledger_Entry__Document_No__; "Document No.")
                {
                }
                column(Vendor_Ledger_Entry_Description; Description)
                {
                }
                column(VendAmount; VendAmount)
                {
                    AutoFormatExpression = VendCurrencyCode;
                    AutoFormatType = 1;
                }
                column(VendRemainAmount; VendRemainAmount)
                {
                    AutoFormatExpression = VendCurrencyCode;
                    AutoFormatType = 1;
                }
                column(VendCurrencyCode; VendCurrencyCode)
                {
                }
                column(VendBalanceLCY; VendBalanceLCY)
                {
                    AutoFormatType = 1;
                }
                column(VendEntryDueDate; VendEntryDueDate)
                {
                }
                column(VendRemainAmountLCY; VendRemainAmountLCY)
                {
                    AutoFormatType = 1;
                }
                column(VendAmountLCY; VendAmountLCY)
                {
                    AutoFormatType = 1;
                }
                column(Vendor_Ledger_Entry__Vendor_No__Caption; FieldCaption("Vendor No."))
                {
                }
                column(Vendor_Ledger_Entry_Entry_No_; "Entry No.")
                {
                }

                trigger OnAfterGetRecord()
                begin

                    CalcFields(Amount, "Remaining Amount", "Amount (LCY)", "Remaining Amt. (LCY)");

                    VendLedgEntryExists := true;
                    if PrintAmountsInLCY then begin
                        VendAmount := "Amount (LCY)";
                        VendAmountLCY := "Amount (LCY)";
                        VendRemainAmountLCY := "Remaining Amt. (LCY)";
                        VendRemainAmount := "Remaining Amount";
                        VendCurrencyCode := '';
                    end else begin
                        VendAmount := Amount;
                        VendAmountLCY := "Amount (LCY)";
                        VendRemainAmount := "Remaining Amount";
                        VendRemainAmountLCY := "Remaining Amt. (LCY)";
                        VendCurrencyCode := "Currency Code";
                    end;
                    VendBalanceLCY := VendBalanceLCY + "Amount (LCY)";
                    if "Document Type" = "Document Type"::Payment then
                        VendEntryDueDate := 0D
                    else
                        VendEntryDueDate := "Due Date";
                end;

                trigger OnPreDataItem()
                begin
                    VendLedgEntryExists := false;

                    if DateDebut <> 0D then
                        "Vendor Ledger Entry".SetFilter("Posting Date", '%1..%2', DateDebut, DateFin);
                end;
            }
            dataitem(Integer2; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(txtVendorName_Control1000000012; txtVendorName)
                {
                }
                column(StartBalanceLCY____Vendor_Ledger_Entry___Amount__LCY__; StartBalanceLCY + "Vendor Ledger Entry"."Amount (LCY)")
                {
                    AutoFormatType = 1;
                }
                column(VendRemainAmountLCY_Control1000000032; VendRemainAmountLCY)
                {
                    AutoFormatType = 1;
                }
                column(VendAmountLCY_Control1000000047; VendAmountLCY)
                {
                    AutoFormatType = 1;
                }
                column(VendAmount_Control1000000015; VendAmount)
                {
                    AutoFormatExpression = VendCurrencyCode;
                    AutoFormatType = 1;
                }
                column(StartBalanceLCY____Vendor_Ledger_Entry___Amount__LCY___Control1000000016; StartBalanceLCY + "Vendor Ledger Entry"."Amount (LCY)")
                {
                    AutoFormatType = 1;
                }
                column(txtVendorName_Control1000000017; txtVendorName)
                {
                }
                column(VendRemainAmount_Control1000000019; VendRemainAmount)
                {
                    AutoFormatExpression = VendCurrencyCode;
                    AutoFormatType = 1;
                }
                column(VendRemainAmountLCY_Control1000000029; VendRemainAmountLCY)
                {
                    AutoFormatType = 1;
                }
                column(VendAmountLCY_Control1000000026; VendAmountLCY)
                {
                    AutoFormatType = 1;
                }
                column(StartBalanceLCY____Vendor_Ledger_Entry___Amount__LCY___Control1000000025; StartBalanceLCY + "Vendor Ledger Entry"."Amount (LCY)")
                {
                    AutoFormatType = 1;
                }
                column(VendRemainAmountLCY_Control1000000039; VendRemainAmountLCY)
                {
                    AutoFormatType = 1;
                }
                column(VendAmountLCY_Control1000000031; VendAmountLCY)
                {
                    AutoFormatType = 1;
                }
                column(Vendor_Total__LCY_Caption; Vendor_Total__LCY_CaptionLbl)
                {
                }
                column(Integer2_Number; Number)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if not VendLedgEntryExists and ((StartBalanceLCY = 0) or not PrintAllHavingBal) then begin
                        StartBalanceLCY := 0;
                        CurrReport.Skip;
                    end;
                end;
            }
            dataitem(Integer3; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(CustRemainAmountLCY_VendRemainAmountLCY; CustRemainAmountLCY + VendRemainAmountLCY)
                {
                    AutoFormatType = 1;
                }
                column(Customer_Total__LCY____Vendor_Total__LCY_Caption; Customer_Total__LCY____Vendor_Total__LCY_CaptionLbl)
                {
                }
                column(Integer3_Number; Number)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if not CustLedgEntryExists and ((StartBalanceLCY = 0) or not PrintAllHavingBal) then begin
                        StartBalanceLCY := 0;
                        CurrReport.Skip;
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                StartBalanceLCY := 0;
                if CustDateFilter <> '' then
                    if GetRangeMin("Date Filter") <> 0D then begin
                        SetRange("Date Filter", 0D, GetRangeMin("Date Filter") - 1);
                        CalcFields("Net Change (LCY)");
                        StartBalanceLCY := "Net Change (LCY)";
                        SetFilter("Date Filter", CustDateFilter);
                    end;
                CurrReport.PrintOnlyIfDetail := not (PrintAllHavingBal and (StartBalanceLCY <> 0));
                CustBalanceLCY := StartBalanceLCY;

                //PJO IF Vendor.GET("Vendor No.") THEN
                //PJO    txtVendorName:=Vendor.Name;
            end;

            trigger OnPreDataItem()
            begin

                txtVendorName := '';
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CustFilter := Customer.GetFilters;
        CustDateFilter := Customer.GetFilter("Date Filter");

        with "Cust. Ledger Entry" do
            if PrintAmountsInLCY then begin
                AmountCaption := FieldCaption("Amount (LCY)");
                AmountCaptionLCY := FieldCaption("Amount (LCY)");
                RemainingAmtCaptionLCY := FieldCaption("Remaining Amt. (LCY)");
                RemainingAmtCaption := FieldCaption("Remaining Amount");
            end else begin
                AmountCaption := FieldCaption(Amount);
                AmountCaptionLCY := FieldCaption("Amount (LCY)");
                RemainingAmtCaption := FieldCaption("Remaining Amount");
                RemainingAmtCaptionLCY := FieldCaption("Remaining Amt. (LCY)");
            end;

        with "Vendor Ledger Entry" do
            if PrintAmountsInLCY then begin
                AmountCaption := FieldCaption("Amount (LCY)");
                AmountCaptionLCY := FieldCaption("Amount (LCY)");
                RemainingAmtCaptionLCY := FieldCaption("Remaining Amt. (LCY)");
                RemainingAmtCaption := FieldCaption("Remaining Amount");
            end else begin
                AmountCaption := FieldCaption(Amount);
                AmountCaptionLCY := FieldCaption("Amount (LCY)");
                RemainingAmtCaption := FieldCaption("Remaining Amount");
                RemainingAmtCaptionLCY := FieldCaption("Remaining Amt. (LCY)");
            end;

        DateDebuttxt := DelStr(CustDateFilter, 9);
        Evaluate(DateDebut, DateDebuttxt);
        DateFintxt := DelStr(CustDateFilter, 1, 10);
        Evaluate(DateFin, DateFintxt);

        PrintOnlyOnePerPage := true;
    end;

    var
        Text000: Label 'Period: %1';
        PrintAmountsInLCY: Boolean;
        PrintOnlyOnePerPage: Boolean;
        PrintAllHavingBal: Boolean;
        CustFilter: Text[250];
        CustDateFilter: Text[30];
        AmountCaption: Text[30];
        AmountCaptionLCY: Text[30];
        RemainingAmtCaption: Text[30];
        RemainingAmtCaptionLCY: Text[30];
        CustAmount: Decimal;
        CustAmountLCY: Decimal;
        CustRemainAmount: Decimal;
        CustRemainAmountLCY: Decimal;
        CustBalanceLCY: Decimal;
        CustCurrencyCode: Code[10];
        CustEntryDueDate: Date;
        StartBalanceLCY: Decimal;
        CustLedgEntryExists: Boolean;
        VendFilter: Text[250];
        VendDateFilter: Text[30];
        VendAmount: Decimal;
        VendAmountLCY: Decimal;
        VendRemainAmount: Decimal;
        VendRemainAmountLCY: Decimal;
        VendBalanceLCY: Decimal;
        VendEntryDueDate: Date;
        VendLedgEntryExists: Boolean;
        VendCurrencyCode: Code[10];
        Vendor: Record Vendor;
        txtVendorName: Text[30];
        DateDebuttxt: Text[30];
        DateDebut: Date;
        DateFintxt: Text[30];
        DateFin: Date;
        test2000: Text[30];
        Customer___BalanceCaptionLbl: Label 'Customer - Balance';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        All_amounts_are_in_LCYCaptionLbl: Label 'All amounts are in LCY';
        This_report_also_includes_customers_that_only_have_balances_CaptionLbl: Label 'This report also includes customers that only have balances.';
        Cust__Ledger_Entry__Document_Type_CaptionLbl: Label 'Document Type';
        CustEntryDueDateCaptionLbl: Label 'Due Date';
        CustBalanceLCYCaptionLbl: Label 'Balance (LCY)';
        Customer_No_CaptionLbl: Label 'Customer No.';
        Customer_Total__LCY_CaptionLbl: Label 'Customer Total (LCY)';
        Vendor_Total__LCY_CaptionLbl: Label 'Vendor Total (LCY)';
        Customer_Total__LCY____Vendor_Total__LCY_CaptionLbl: Label 'Customer Total (LCY) - Vendor Total (LCY)';
}

