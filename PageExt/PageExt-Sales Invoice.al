pageextension 70108 pageextension70108 extends "Sales Invoice"
{
    layout
    {

        modify("Sell-to Customer Name")
        {
            trigger OnAfterValidate()
            var
                lrec_CompanyInfo: Record "Company Information";
                lrec_SalesSetup: Record "Sales & Receivables Setup";
                lrec_AlertMgt: Record "Alert Management";
                lfrm_DisplayAlert: Page "Display Alert";
                Text001: Label 'Alert on Customer %1';

            begin
                lrec_CompanyInfo.GET;
                IF lrec_CompanyInfo."Use Alert Management" THEN BEGIN
                    lrec_SalesSetup.GET;
                    IF lrec_SalesSetup."Cust. Alert on Sales Order/Inv" THEN BEGIN
                        lrec_AlertMgt.SETCURRENTKEY("Table Name", "No.", "Starting Date", "Ending Date", Active, "Event");
                        lrec_AlertMgt.SETFILTER("Table Name", '%1', lrec_AlertMgt."Table Name"::Customer);
                        lrec_AlertMgt.SETFILTER("No.", "Sell-to Customer No.");
                        lrec_AlertMgt.SETFILTER("Starting Date", '<=%1', WORKDATE);
                        lrec_AlertMgt.SETFILTER("Ending Date", '>=%1', WORKDATE);
                        lrec_AlertMgt.SETRANGE(Active, TRUE);
                        lrec_AlertMgt.SETRANGE("Event", lrec_AlertMgt."Event"::"Customer on Sales Order");
                        IF lrec_AlertMgt.FIND('-') THEN BEGIN
                            lfrm_DisplayAlert.SetHeading(STRSUBSTNO(Text001, "Sell-to Customer No."));
                            lfrm_DisplayAlert.SETTABLEVIEW(lrec_AlertMgt);
                            IF lfrm_DisplayAlert.RUNMODAL = ACTION::OK THEN;
                        END;
                    END;
                END;

            end;
        }
    }
    actions
    {
        modify(DraftInvoice)
        {
            Visible = false;
        }
    }



}

