report 50066 "Lettrage clients"
{
    // Pos pour dire que c'est une facture ou un paiement positif donc montant de signe <0
    // neg pour dire que c'est un paiement ou un avoir donc montant de signe >0
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/Lettrageclients.rdlc';

    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Customer; Customer)
        {
            PrintOnlyIfDetail = false;
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
            column(Customer__No__; "No.")
            {
            }
            column(Customer_Name; Name)
            {
            }
            column(Customer_Address; Address)
            {
            }
            column(Customer_City; City)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Customer___Balance_to_DateCaption; Customer___Balance_to_DateCaptionLbl)
            {
            }
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                CalcFields = "Remaining Amt. (LCY)";
                DataItemLink = "Customer No." = FIELD("No.");
                DataItemTableView = SORTING("Entry No.") ORDER(Ascending);
                RequestFilterFields = "Posting Date";
                column(Cust__Ledger_Entry__Entry_No__; "Entry No.")
                {
                }
                column(Cust__Ledger_Entry__Posting_Date_; "Posting Date")
                {
                }
                column(Cust__Ledger_Entry__Document_Type_; "Document Type")
                {
                }
                column(Cust__Ledger_Entry__Document_No__; "Document No.")
                {
                }
                column(Cust__Ledger_Entry__Amount__LCY__; "Amount (LCY)")
                {
                }
                column(Cust__Ledger_Entry__Remaining_Amt___LCY__; "Remaining Amt. (LCY)")
                {
                }
                column(Cust__Ledger_Entry_Amount; Amount)
                {
                }
                column(Cust__Ledger_Entry__Remaining_Amount_; "Remaining Amount")
                {
                }
                column(Cust__Ledger_Entry___Remaining_Amt___LCY______Cust__Ledger_Entry_II___Remaining_Amt___LCY__; "Cust. Ledger Entry"."Remaining Amt. (LCY)" + "Cust. Ledger Entry II"."Remaining Amt. (LCY)")
                {
                }
                column(Cust__Ledger_Entry__Entry_No__Caption; FieldCaption("Entry No."))
                {
                }
                column(Date_ComptaCaption; Date_ComptaCaptionLbl)
                {
                }
                column(Cust__Ledger_Entry__Document_Type_Caption; FieldCaption("Document Type"))
                {
                }
                column(Cust__Ledger_Entry__Document_No__Caption; FieldCaption("Document No."))
                {
                }
                column(Cust__Ledger_Entry__Amount__LCY__Caption; FieldCaption("Amount (LCY)"))
                {
                }
                column(Cust__Ledger_Entry__Remaining_Amt___LCY__Caption; FieldCaption("Remaining Amt. (LCY)"))
                {
                }
                column(MontantCaption; MontantCaptionLbl)
                {
                }
                column(Montant_OuvertCaption; Montant_OuvertCaptionLbl)
                {
                }
                column(Solde_Ouvert_DSCaption; Solde_Ouvert_DSCaptionLbl)
                {
                }
                column(Cust__Ledger_Entry_Customer_No_; "Customer No.")
                {
                }
                dataitem("Cust. Ledger Entry II"; "Cust. Ledger Entry")
                {
                    CalcFields = "Remaining Amt. (LCY)";
                    DataItemTableView = SORTING("Entry No.") ORDER(Ascending);
                    column(Cust__Ledger_Entry_II__Entry_No__; "Entry No.")
                    {
                    }
                    column(Cust__Ledger_Entry_II__Posting_Date_; "Posting Date")
                    {
                    }
                    column(Cust__Ledger_Entry_II__Document_Type_; "Document Type")
                    {
                    }
                    column(Cust__Ledger_Entry_II__Document_No__; "Document No.")
                    {
                    }
                    column(Cust__Ledger_Entry_II__Amount__LCY__; "Amount (LCY)")
                    {
                    }
                    column(Cust__Ledger_Entry_II__Remaining_Amt___LCY__; "Remaining Amt. (LCY)")
                    {
                    }
                    column(Cust__Ledger_Entry_II_Amount; Amount)
                    {
                    }
                    column(Cust__Ledger_Entry_II__Remaining_Amount_; "Remaining Amount")
                    {
                    }

                    trigger OnPreDataItem()
                    begin
                        "Cust. Ledger Entry II".Reset;


                        if "Cust. Ledger Entry"."Entry No." <> 0 then begin
                            CreateCustLedgEntry := "Cust. Ledger Entry";


                            FindApplnEntriesDtldtLedgEntrp;
                            "Cust. Ledger Entry II".SetCurrentKey("Entry No.");
                            "Cust. Ledger Entry II".SetRange("Entry No.");

                            if CreateCustLedgEntry."Closed by Entry No." <> 0 then begin
                                //IF ("Cust. Ledger Entry".Amount >= "Cust. Ledger Entry II".Amount) THEN BEGIN
                                "Cust. Ledger Entry II"."Entry No." := CreateCustLedgEntry."Closed by Entry No.";
                                "Cust. Ledger Entry II".Mark(true);
                                "Cust. Ledger Entry III".Get("Cust. Ledger Entry II"."Entry No.");
                                "Cust. Ledger Entry III".Mark(true);
                                //END ELSE CurrReport.SKIP;
                            end;

                            "Cust. Ledger Entry II".SetCurrentKey("Closed by Entry No.");
                            "Cust. Ledger Entry II".SetRange("Closed by Entry No.", CreateCustLedgEntry."Entry No.");
                            if "Cust. Ledger Entry II".Find('-') then
                                repeat
                                    //IF ("Cust. Ledger Entry".Amount >= "Cust. Ledger Entry II".Amount) THEN BEGIN
                                    "Cust. Ledger Entry II".Mark(true);
                                    "Cust. Ledger Entry III".Get("Cust. Ledger Entry II"."Entry No.");
                                    "Cust. Ledger Entry III".Mark(true);
                                //END ELSE CurrReport.SKIP;
                                until Next = 0;

                            "Cust. Ledger Entry II".SetCurrentKey("Entry No.");
                            "Cust. Ledger Entry II".SetRange("Closed by Entry No.");
                        end;


                        "Cust. Ledger Entry II".MarkedOnly(true);


                        "Cust. Ledger Entry II".CalcFields("Cust. Ledger Entry II"."Remaining Amount");
                        MontantOuvert := "Cust. Ledger Entry II"."Remaining Amount";
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if "Cust. Ledger Entry"."Entry No." <> 0 then
                        if "Cust. Ledger Entry III".Get("Cust. Ledger Entry"."Entry No.") and "Cust. Ledger Entry III".Mark then
                            CurrReport.Skip;
                    //IF ("Cust. Ledger Entry".Amount < 0) THEN CurrReport.SKIP;
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
        if "Cust. Ledger Entry".GetFilter("Posting Date") <> '' then
            TxtFiltreDate := "Cust. Ledger Entry".GetFilter("Posting Date")
        else
            TxtFiltreDate := Text002;
    end;

    var
        Heading: Text[50];
        CreateCustLedgEntry: Record "Cust. Ledger Entry";
        Text000: Label 'Document';
        "Cust. Ledger Entry III": Record "Cust. Ledger Entry";
        TxtFiltreDate: Text[30];
        Text001: Label 'Filtre Date : %1';
        Text002: Label 'Aucun';
        "Cust. Ledger Entry IV": Record "Cust. Ledger Entry";
        MontantOuvert: Decimal;
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Customer___Balance_to_DateCaptionLbl: Label 'Customer - Balance to Date';
        Date_ComptaCaptionLbl: Label 'Date Compta';
        MontantCaptionLbl: Label 'Montant';
        Montant_OuvertCaptionLbl: Label 'Montant Ouvert';
        Solde_Ouvert_DSCaptionLbl: Label 'Solde Ouvert DS';

    [Scope('OnPrem')]
    procedure FindApplnEntriesDtldtLedgEntrp()
    var
        DtldCustLedgEntry1: Record "Detailed Cust. Ledg. Entry";
        DtldCustLedgEntry2: Record "Detailed Cust. Ledg. Entry";
        DtldCustLedgEntry3: Record "Detailed Cust. Ledg. Entry";
    begin
        DtldCustLedgEntry1.Reset;
        DtldCustLedgEntry1.SetCurrentKey("Cust. Ledger Entry No.");
        DtldCustLedgEntry1.SetRange("Cust. Ledger Entry No.", CreateCustLedgEntry."Entry No.");
        DtldCustLedgEntry1.SetRange(Unapplied, false);

        DtldCustLedgEntry3.Reset;
        DtldCustLedgEntry3.SetCurrentKey("Cust. Ledger Entry No.");
        DtldCustLedgEntry3.SetRange("Cust. Ledger Entry No.", CreateCustLedgEntry."Entry No.");
        DtldCustLedgEntry3.SetRange(Unapplied, false);
        DtldCustLedgEntry3.SetFilter(DtldCustLedgEntry3."Entry Type", '%1', DtldCustLedgEntry3."Entry Type"::Application);
        if DtldCustLedgEntry3.Find('-') then begin
            "Cust. Ledger Entry".CalcFields("Cust. Ledger Entry"."Amount (LCY)");
            if "Cust. Ledger Entry IV".Get(DtldCustLedgEntry3."Applied Cust. Ledger Entry No.") then begin
                "Cust. Ledger Entry IV".CalcFields("Amount (LCY)");
                if (Abs("Cust. Ledger Entry"."Amount (LCY)") < Abs("Cust. Ledger Entry IV"."Amount (LCY)")) then CurrReport.Break;
            end;
            //sinon, traitement normal
            repeat

                if DtldCustLedgEntry1."Cust. Ledger Entry No." =
                                             DtldCustLedgEntry1."Applied Cust. Ledger Entry No." then begin
                    DtldCustLedgEntry2.Init;
                    DtldCustLedgEntry2.SetCurrentKey("Applied Cust. Ledger Entry No.", "Entry Type");
                    DtldCustLedgEntry2.SetRange(
                                   "Applied Cust. Ledger Entry No.", DtldCustLedgEntry1."Applied Cust. Ledger Entry No.");
                    DtldCustLedgEntry2.SetRange("Entry Type", DtldCustLedgEntry2."Entry Type"::Application);
                    DtldCustLedgEntry2.SetRange(Unapplied, false);
                    if DtldCustLedgEntry2.Find('-') then begin
                        repeat
                            if DtldCustLedgEntry2."Cust. Ledger Entry No." <>
                                           DtldCustLedgEntry2."Applied Cust. Ledger Entry No." then begin
                                "Cust. Ledger Entry II".SetCurrentKey("Entry No.");
                                "Cust. Ledger Entry II".SetRange("Entry No.", DtldCustLedgEntry2."Cust. Ledger Entry No.");
                                if "Cust. Ledger Entry II".Find('-') then begin
                                    //IF ("Cust. Ledger Entry".Amount >= "Cust. Ledger Entry II".Amount) THEN BEGIN
                                    "Cust. Ledger Entry II".Mark(true);
                                    "Cust. Ledger Entry III".Get("Cust. Ledger Entry II"."Entry No.");
                                    "Cust. Ledger Entry III".Mark(true);
                                    //END ELSE CurrReport.SKIP;
                                end;
                            end;
                        until DtldCustLedgEntry2.Next = 0;
                    end;
                end else begin
                    "Cust. Ledger Entry II".SetCurrentKey("Entry No.");
                    "Cust. Ledger Entry II".SetRange("Entry No.", DtldCustLedgEntry1."Applied Cust. Ledger Entry No.");
                    if "Cust. Ledger Entry II".Find('-') then begin

                        //IF ("Cust. Ledger Entry".Amount >= "Cust. Ledger Entry II".Amount) THEN BEGIN
                        "Cust. Ledger Entry II".Mark(true);
                        "Cust. Ledger Entry III".Get("Cust. Ledger Entry II"."Entry No.");
                        "Cust. Ledger Entry III".Mark(true);
                        //END ELSE
                        // CurrReport.SKIP;
                        //     FindApplnEntriesDtldtLedgEntry;

                    end;
                end;
            until DtldCustLedgEntry1.Next = 0;

        end;

        "Cust. Ledger Entry II".MarkedOnly(true);
    end;
}

