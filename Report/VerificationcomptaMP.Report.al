report 50084 "Verification compta MP"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/VerificationcomptaMP.rdlc';
    Caption = 'Verification compta MP';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            DataItemTableView = WHERE("G/L Account No." = FILTER('600*' | '6010*' | '6012*' | '603*' | '604' | '607*' & <> '607100'));
            PrintOnlyIfDetail = false;
            RequestFilterFields = "Posting Date", "Document No.";
            column(GLAccountNo_GLEntry; "G/L Entry"."G/L Account No.")
            {
            }
            column(PostingDate_GLEntry; "G/L Entry"."Posting Date")
            {
            }
            column(DocumentType_GLEntry; "G/L Entry"."Document Type")
            {
            }
            column(DocumentNo_GLEntry; "G/L Entry"."Document No.")
            {
            }
            column(Description_GLEntry; "G/L Entry".Description)
            {
            }
            column(Amount_GLEntry; "G/L Entry".Amount)
            {
            }
            column(Quantity_GLEntry; "G/L Entry".Quantity)
            {
            }
            column(Fourn; fourn.Name)
            {
            }
            column(SourceNo_GLEntry; "G/L Entry"."Source No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                VE.Reset;
                VE.SetRange("Posting Date", "Posting Date");
                VE.SetRange("Document No.", "Document No.");
                VE.SetFilter("Item No.", '%1|%2|%3', '7*', '8*', '9*');
                if VE.FindFirst then CurrReport.Skip;
                if fourn.Get("G/L Entry"."Source No.") then;
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
        VE: Record "Value Entry";
        fourn: Record Vendor;
}

