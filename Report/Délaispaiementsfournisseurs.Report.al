report 50029 "Délais paiements fournisseurs"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/Délaispaiementsfournisseurs.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Country/Region Code";
            column(No_Customer; Vendor."No.")
            {
            }
            column(Name_Customer; Vendor.Name)
            {
            }
            column(City_Customer; Vendor.City)
            {
            }
            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No." = FIELD("No.");
                DataItemTableView = WHERE(Open = CONST(false), "Document Type" = CONST(Invoice));
                RequestFilterFields = "Posting Date";
                column(PostingDate_CustLedgerEntry; "Vendor Ledger Entry"."Posting Date")
                {
                }
                column(DocumentNo_CustLedgerEntry; "Vendor Ledger Entry"."Document No.")
                {
                }
                column(AmountLCY_CustLedgerEntry; "Vendor Ledger Entry"."Amount (LCY)")
                {
                }
                column(DueDate_CustLedgerEntry; "Vendor Ledger Entry"."Due Date")
                {
                }
                column(ClosedatDate_CustLedgerEntry; DtClosed)
                {
                }
                column(DelaiPaiement; "Vendor Ledger Entry"."Due Date" - "Vendor Ledger Entry"."Posting Date")
                {
                }
                column(DelaiReglement; delai)
                {
                }
                column(Retard; retard)
                {
                }
                column(ShowDetail; ShowDetail)
                {
                }

                trigger OnAfterGetRecord()
                var
                    vle: Record "Vendor Ledger Entry";
                begin
                    delai := 0;
                    retard := 0;
                    DtClosed := 0D;
                    if ("Vendor Ledger Entry"."Closed at Date" <> 0D) then begin
                        delai := "Vendor Ledger Entry"."Closed at Date" - "Vendor Ledger Entry"."Posting Date";
                        retard := "Vendor Ledger Entry"."Closed at Date" - "Vendor Ledger Entry"."Due Date";
                        DtClosed := "Vendor Ledger Entry"."Closed at Date";
                    end
                    else begin
                        vle.Reset;
                        vle.SetRange("Closed by Entry No.", "Vendor Ledger Entry"."Entry No.");
                        vle.SetFilter("Amount (LCY)", '<0');
                        if vle.FindFirst then begin
                            delai := vle."Posting Date" - "Vendor Ledger Entry"."Posting Date";
                            retard := vle."Posting Date" - "Vendor Ledger Entry"."Due Date";
                            DtClosed := vle."Posting Date";
                        end;
                    end;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Afficher le détail"; ShowDetail)
                {
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

    var
        delai: Decimal;
        retard: Decimal;
        DtClosed: Date;
        ShowDetail: Boolean;
}

