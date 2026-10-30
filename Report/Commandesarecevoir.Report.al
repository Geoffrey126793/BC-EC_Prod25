report 50031 "Commandes a recevoir"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/Commandesarecevoir.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Purchase Line"; "Purchase Line")
        {
            DataItemTableView = SORTING("Document Type", "Expected Receipt Date", "Buy-from Vendor No.") WHERE("Qty. to Receive" = FILTER(> 0), Type = CONST(Item));
            RequestFilterFields = "Expected Receipt Date", "Buy-from Vendor No.";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(CurrReport_PAGENO; 1)
            {
            }
            column(USERID; UserId)
            {
            }
            column(Purchase_Line__Document_No__; "Document No.")
            {
            }
            column(Purchase_Line__No__; "No.")
            {
            }
            column(Purchase_Line_Description; Description)
            {
            }
            column(Purchase_Line__Vendor_Name_; "Vendor Name")
            {
            }
            column(Purchase_Line__Expected_Receipt_Date_; "Expected Receipt Date")
            {
            }
            column(Purchase_Line_Quantity; Quantity)
            {
            }
            column(Purchase_Line__Qty__to_Receive_; "Qty. to Receive")
            {
            }
            column(Purchase_LineCaption; Purchase_LineCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Purchase_Line_Document_Type; "Document Type")
            {
            }
            column(Purchase_Line_Line_No_; "Line No.")
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Document Type");
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
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        Purchase_LineCaptionLbl: Label 'Purchase Line';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
}

