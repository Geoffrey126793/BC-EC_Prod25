report 50059 "Feuille de paiement"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/Feuilledepaiement.rdlc';

    dataset
    {
        dataitem("Payment Journal Line"; "Payment Journal Line")
        {
            column(Amount_PaymentJournalLine; "Payment Journal Line".Amount)
            {
            }
            column(PaymentMessage_PaymentJournalLine; "Payment Journal Line"."Payment Message")
            {
            }
            column(AppliestoDocNo_PaymentJournalLine; "Payment Journal Line"."Applies-to Doc. No.")
            {
            }
            column(DocumentDate_PaymentJournalLine; "Payment Journal Line"."Document Date")
            {
            }
            column(BeneficiaryIBAN_PaymentJournalLine; "Payment Journal Line"."Beneficiary IBAN")
            {
            }
            column(Name_PaymentJournalLine; "Payment Journal Line".Name)
            {
            }
            column(CurrencyCode_PaymentJournalLine; "Payment Journal Line"."Currency Code")
            {
            }
            column(PostingDate_PaymentJournalLine; "Payment Journal Line"."Posting Date")
            {
            }
            column(AccountNo_PaymentJournalLine; "Payment Journal Line"."Account No.")
            {
            }
            column(BankAccount_PaymentJournalLine; "Payment Journal Line"."Bank Account")
            {
            }
            column(Description; Description)
            {
            }
            column(JournalBatchName_PaymentJournalLine; "Payment Journal Line"."Journal Batch Name")
            {
            }
            column(JournalTemplateName_PaymentJournalLine; "Payment Journal Line"."Journal Template Name")
            {
            }

            trigger OnAfterGetRecord()
            begin

                if "Account No." <> '' then
                    case "Account Type" of
                        "Account Type"::Customer:
                            begin
                                // BE0002.begin
                                // CustLedgEntry.SETCURRENTKEY("Document No.","Document Type","Customer No.");
                                CustLedgEntry.SetCurrentKey("Document No.");
                                // BE0002.end
                                CustLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
                                CustLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
                                CustLedgEntry.SetRange("Customer No.", "Account No.");
                                if CustLedgEntry.Find('+') then begin
                                    Description := CustLedgEntry.Description;
                                end;
                            end;
                        "Account Type"::Vendor:
                            begin
                                // BE0002.begin
                                // VendLedgEntry.SETCURRENTKEY("Document No.","Document Type","Vendor No.");
                                VendLedgEntry.SetCurrentKey("Document No.");
                                // BE0002.end
                                VendLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
                                VendLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
                                VendLedgEntry.SetRange("Vendor No.", "Account No.");
                                if VendLedgEntry.Find('+') then begin
                                    Description := VendLedgEntry.Description;
                                end;
                            end;
                    end;
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

    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        Description: Text;
}

