report 50097 "Envoi factures"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "No.", "Posting Date";

            trigger OnAfterGetRecord()
            var
                Modif: Codeunit ModifTables;
                TypeLogo: Option NonDefini,Avec,Sans;
                SessionId: Integer;
                cu419: Codeunit "File Management";
            begin

                SalesH.Reset;
                SalesH.SetFilter("No.", "No.");
                SalesH.FindFirst;


                t := CuMail._GetEMailsRespForEntity(DATABASE::Customer, "Bill-to Customer No.", 'S01');
                recCust.Get("Bill-to Customer No.");
                //IF (t = '') OR (recCust."Sending Invoice Address") THEN
                if (t = '') then begin
                    StartSession(SessionId, 50042, CompanyName, SalesH);
                end
                else begin
                    Modif.InvoiceLogo("No.", TypeLogo::Avec);
                    SalesH.EmailRecords(false);
                    Modif.InvoiceLogo("No.", TypeLogo::NonDefini);
                end;
            end;

            trigger OnPreDataItem()
            begin
                if ("Sales Invoice Header".GetFilter("Posting Date") = '') or ("Sales Invoice Header".GetFilter("No.") = '') then
                    Error('Vous devez mettre un filtre sur le N° ET sur la date comptabilisation');
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
        SalesH: Record "Sales Invoice Header";
        CuMail: Codeunit Integration_EMail;
        t: Text[1000];
        recCust: Record Customer;
}

