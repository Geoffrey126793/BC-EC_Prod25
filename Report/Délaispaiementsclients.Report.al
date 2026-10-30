report 50022 "Délais paiements clients"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/Délaispaiementsclients.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Customer; Customer)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Salesperson Code", "Country/Region Code";
            column(No_Customer; Customer."No.")
            {
            }
            column(Name_Customer; Customer.Name)
            {
            }
            column(City_Customer; Customer.City)
            {
            }
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = FIELD("No.");
                DataItemTableView = WHERE(Open = CONST(false), "Document Type" = CONST(Invoice));
                RequestFilterFields = "Posting Date";
                column(PostingDate_CustLedgerEntry; "Cust. Ledger Entry"."Posting Date")
                {
                }
                column(DocumentNo_CustLedgerEntry; "Cust. Ledger Entry"."Document No.")
                {
                }
                column(AmountLCY_CustLedgerEntry; "Cust. Ledger Entry"."Amount (LCY)")
                {
                }
                column(DueDate_CustLedgerEntry; "Cust. Ledger Entry"."Due Date")
                {
                }
                column(ClosedatDate_CustLedgerEntry; DtClosed)
                {
                }
                column(DelaiPaiement; "Cust. Ledger Entry"."Due Date" - "Cust. Ledger Entry"."Posting Date")
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
                    cle: Record "Cust. Ledger Entry";
                begin
                    delai := 0;
                    retard := 0;
                    DtClosed := 0D;
                    if ("Cust. Ledger Entry"."Closed at Date" <> 0D) then begin
                        delai := "Cust. Ledger Entry"."Closed at Date" - "Cust. Ledger Entry"."Posting Date";
                        retard := "Cust. Ledger Entry"."Closed at Date" - "Cust. Ledger Entry"."Due Date";
                        DtClosed := "Cust. Ledger Entry"."Closed at Date";
                    end
                    else begin
                        cle.Reset;
                        cle.SetRange("Closed by Entry No.", "Cust. Ledger Entry"."Entry No.");
                        cle.SetFilter("Amount (LCY)", '<0');
                        if cle.FindFirst then begin
                            delai := cle."Posting Date" - "Cust. Ledger Entry"."Posting Date";
                            retard := cle."Posting Date" - "Cust. Ledger Entry"."Due Date";
                            DtClosed := cle."Posting Date";
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

