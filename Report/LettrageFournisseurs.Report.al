report 50065 "Lettrage Fournisseurs"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/LettrageFournisseurs.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(USERID; UserId)
            {
            }
            column(CurrReport_PAGENO; 1)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(STRSUBSTNO_Text001__TxtFiltreDate_; StrSubstNo(Text001, TxtFiltreDate))
            {
            }
            column(Vendor__No__; "No.")
            {
            }
            column(Vendor_Name; Name)
            {
            }
            column(Vendor_Address; Address)
            {
            }
            column(Vendor_City; City)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Customer___Balance_to_DateCaption; Customer___Balance_to_DateCaptionLbl)
            {
            }
            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                CalcFields = "Remaining Amt. (LCY)";
                DataItemLink = "Vendor No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Vendor No.", "Posting Date", "Currency Code") ORDER(Ascending);
                RequestFilterFields = "Posting Date";
                column(Vendor_Ledger_Entry__Entry_No__; "Entry No.")
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
                column(Vendor_Ledger_Entry__Amount__LCY__; "Amount (LCY)")
                {
                }
                column(Vendor_Ledger_Entry__Remaining_Amt___LCY__; "Remaining Amt. (LCY)")
                {
                }
                column(Vendor_Ledger_Entry_Amount; Amount)
                {
                }
                column(Vendor_Ledger_Entry__Remaining_Amount_; "Remaining Amount")
                {
                }
                column(Vendor_Ledger_Entry___Remaining_Amt___LCY______Vendor_Ledger_Entry_II___Remaining_Amt___LCY__; "Vendor Ledger Entry"."Remaining Amt. (LCY)" + "Vendor Ledger Entry II"."Remaining Amt. (LCY)")
                {
                }
                column(Vendor_Ledger_Entry__Entry_No__Caption; FieldCaption("Entry No."))
                {
                }
                column(Date_ComptaCaption; Date_ComptaCaptionLbl)
                {
                }
                column(Vendor_Ledger_Entry__Document_Type_Caption; FieldCaption("Document Type"))
                {
                }
                column(Vendor_Ledger_Entry__Document_No__Caption; FieldCaption("Document No."))
                {
                }
                column(Vendor_Ledger_Entry__Amount__LCY__Caption; FieldCaption("Amount (LCY)"))
                {
                }
                column(Vendor_Ledger_Entry__Remaining_Amt___LCY__Caption; FieldCaption("Remaining Amt. (LCY)"))
                {
                }
                column(MontantCaption; MontantCaptionLbl)
                {
                }
                column(Montant_OuvertCaption; Montant_OuvertCaptionLbl)
                {
                }
                column(Montant_Ouvert_DSCaption; Montant_Ouvert_DSCaptionLbl)
                {
                }
                column(Vendor_Ledger_Entry_Vendor_No_; "Vendor No.")
                {
                }
                column(DocumentDate_VendorLedgerEntry; "Vendor Ledger Entry"."Document Date")
                {
                }
                dataitem("Vendor Ledger Entry II"; "Vendor Ledger Entry")
                {
                    CalcFields = "Remaining Amt. (LCY)";
                    DataItemTableView = SORTING("Entry No.") ORDER(Ascending);
                    column(Vendor_Ledger_Entry_II__Entry_No__; "Entry No.")
                    {
                    }
                    column(Vendor_Ledger_Entry_II__Posting_Date_; "Posting Date")
                    {
                    }
                    column(Vendor_Ledger_Entry_II__Document_Type_; "Document Type")
                    {
                    }
                    column(Vendor_Ledger_Entry_II__Document_No__; "Document No.")
                    {
                    }
                    column(Vendor_Ledger_Entry_II__Amount__LCY__; "Amount (LCY)")
                    {
                    }
                    column(Vendor_Ledger_Entry_II__Remaining_Amt___LCY__; "Remaining Amt. (LCY)")
                    {
                    }
                    column(Vendor_Ledger_Entry_II_Amount; Amount)
                    {
                    }
                    column(Vendor_Ledger_Entry_II__Remaining_Amount_; "Remaining Amount")
                    {
                    }
                    column(DocumentDate_VendorLedgerEntryII; "Vendor Ledger Entry II"."Document Date")
                    {
                    }

                    trigger OnPreDataItem()
                    begin
                        "Vendor Ledger Entry II".Reset;


                        if "Vendor Ledger Entry"."Entry No." <> 0 then begin
                            CreateVendorLedgEntry := "Vendor Ledger Entry";


                            FindApplnEntriesDtldtLedgEntry;
                            "Vendor Ledger Entry II".SetCurrentKey("Entry No.");
                            "Vendor Ledger Entry II".SetRange("Entry No.");

                            if CreateVendorLedgEntry."Closed by Entry No." <> 0 then begin
                                //IF ("Vendor Ledger Entry".Amount >= "Vendor Ledger Entry II".Amount) THEN BEGIN
                                "Vendor Ledger Entry II"."Entry No." := CreateVendorLedgEntry."Closed by Entry No.";
                                "Vendor Ledger Entry II".Mark(true);
                                "Vendor Ledger Entry III".Get("Vendor Ledger Entry II"."Entry No.");
                                "Vendor Ledger Entry III".Mark(true);
                                //END ELSE CurrReport.SKIP;
                            end;

                            "Vendor Ledger Entry II".SetCurrentKey("Closed by Entry No.");
                            "Vendor Ledger Entry II".SetRange("Closed by Entry No.", CreateVendorLedgEntry."Entry No.");
                            if "Vendor Ledger Entry II".Find('-') then
                                repeat
                                    //IF ("Vendor Ledger Entry".Amount >= "Vendor Ledger Entry II".Amount) THEN BEGIN
                                    "Vendor Ledger Entry II".Mark(true);
                                    "Vendor Ledger Entry III".Get("Vendor Ledger Entry II"."Entry No.");
                                    "Vendor Ledger Entry III".Mark(true);
                                //END ELSE CurrReport.SKIP;
                                until Next = 0;

                            "Vendor Ledger Entry II".SetCurrentKey("Entry No.");
                            "Vendor Ledger Entry II".SetRange("Closed by Entry No.");
                        end;

                        "Vendor Ledger Entry II".MarkedOnly(true);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if "Vendor Ledger Entry"."Entry No." <> 0 then
                        if "Vendor Ledger Entry III".Get("Vendor Ledger Entry"."Entry No.") and "Vendor Ledger Entry III".Mark then
                            CurrReport.Skip;
                    //IF ("Vendor Ledger Entry"."Amount (LCY)" < 0) THEN CurrReport.SKIP;
                end;

                trigger OnPreDataItem()
                begin

                end;
            }
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
        if "Vendor Ledger Entry".GetFilter("Posting Date") <> '' then
            TxtFiltreDate := "Vendor Ledger Entry".GetFilter("Posting Date")
        else
            TxtFiltreDate := Text002;
    end;

    var
        Heading: Text[50];
        CreateVendorLedgEntry: Record "Vendor Ledger Entry";
        Text000: Label 'Document';
        "Vendor Ledger Entry III": Record "Vendor Ledger Entry";
        TxtFiltreDate: Text[30];
        Text001: Label 'Filtre Date : %1';
        Text002: Label 'Aucun';
        "Vendor Ledger Entry IV": Record "Vendor Ledger Entry";
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Customer___Balance_to_DateCaptionLbl: Label 'Customer - Balance to Date';
        Date_ComptaCaptionLbl: Label 'Date Compta';
        MontantCaptionLbl: Label 'Montant';
        Montant_OuvertCaptionLbl: Label 'Montant Ouvert';
        Montant_Ouvert_DSCaptionLbl: Label 'Montant Ouvert DS';

    [Scope('OnPrem')]
    procedure FindApplnEntriesDtldtLedgEntry()
    var
        DtldVendorLedgEntry1: Record "Detailed Vendor Ledg. Entry";
        DtldVendorLedgEntry2: Record "Detailed Vendor Ledg. Entry";
        DtldVendorLedgEntry3: Record "Detailed Vendor Ledg. Entry";
    begin
        DtldVendorLedgEntry1.Reset;
        DtldVendorLedgEntry1.SetCurrentKey("Vendor Ledger Entry No.");
        DtldVendorLedgEntry1.SetRange("Vendor Ledger Entry No.", CreateVendorLedgEntry."Entry No.");
        DtldVendorLedgEntry1.SetRange(Unapplied, false);

        DtldVendorLedgEntry3.Reset;
        DtldVendorLedgEntry3.SetCurrentKey("Vendor Ledger Entry No.");
        DtldVendorLedgEntry3.SetRange("Vendor Ledger Entry No.", CreateVendorLedgEntry."Entry No.");
        DtldVendorLedgEntry3.SetRange(Unapplied, false);
        DtldVendorLedgEntry3.SetFilter(DtldVendorLedgEntry3."Entry Type", '%1', DtldVendorLedgEntry3."Entry Type"::Application);
        if DtldVendorLedgEntry3.Find('-') then begin
            "Vendor Ledger Entry".CalcFields("Amount (LCY)");
            if "Vendor Ledger Entry IV".Get(DtldVendorLedgEntry3."Applied Vend. Ledger Entry No.") then begin
                "Vendor Ledger Entry IV".CalcFields("Amount (LCY)");
                //   IF (ABS("Vendor Ledger Entry"."Amount (LCY)") < ABS("Vendor Ledger Entry IV"."Amount (LCY)")) THEN CurrReport.BREAK;
            end;
            //sinon, traitement normal
            repeat

                if DtldVendorLedgEntry1."Vendor Ledger Entry No." =
                                             DtldVendorLedgEntry1."Applied Vend. Ledger Entry No." then begin
                    DtldVendorLedgEntry2.Init;
                    DtldVendorLedgEntry2.SetCurrentKey("Applied Vend. Ledger Entry No.", "Entry Type");
                    DtldVendorLedgEntry2.SetRange(
                                   "Applied Vend. Ledger Entry No.", DtldVendorLedgEntry1."Applied Vend. Ledger Entry No.");
                    DtldVendorLedgEntry2.SetRange("Entry Type", DtldVendorLedgEntry2."Entry Type"::Application);
                    DtldVendorLedgEntry2.SetRange(Unapplied, false);
                    if DtldVendorLedgEntry2.Find('-') then begin
                        repeat
                            if DtldVendorLedgEntry2."Vendor Ledger Entry No." <>
                                           DtldVendorLedgEntry2."Applied Vend. Ledger Entry No." then begin
                                "Vendor Ledger Entry II".SetCurrentKey("Entry No.");
                                "Vendor Ledger Entry II".SetRange("Entry No.", DtldVendorLedgEntry2."Vendor Ledger Entry No.");
                                if "Vendor Ledger Entry II".Find('-') then begin
                                    //IF ("Vendor Ledger Entry".Amount >= "Vendor Ledger Entry II".Amount) THEN BEGIN
                                    "Vendor Ledger Entry II".Mark(true);
                                    "Vendor Ledger Entry III".Get("Vendor Ledger Entry II"."Entry No.");
                                    "Vendor Ledger Entry III".Mark(true);
                                    //END ELSE CurrReport.SKIP;
                                end;
                            end;
                        until DtldVendorLedgEntry2.Next = 0;
                    end;
                end else begin
                    "Vendor Ledger Entry II".SetCurrentKey("Entry No.");
                    "Vendor Ledger Entry II".SetRange("Entry No.", DtldVendorLedgEntry1."Applied Vend. Ledger Entry No.");
                    if "Vendor Ledger Entry II".Find('-') then begin

                        //IF ("Vendor Ledger Entry".Amount >= "Vendor Ledger Entry II".Amount) THEN BEGIN
                        "Vendor Ledger Entry II".Mark(true);
                        "Vendor Ledger Entry III".Get("Vendor Ledger Entry II"."Entry No.");
                        "Vendor Ledger Entry III".Mark(true);
                        //END ELSE
                        // CurrReport.SKIP;
                        //     FindApplnEntriesDtldtLedgEntry;

                    end;
                end;
            until DtldVendorLedgEntry1.Next = 0;

        end;

        "Vendor Ledger Entry II".MarkedOnly(true);
    end;
}

