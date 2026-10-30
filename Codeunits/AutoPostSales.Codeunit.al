codeunit 50015 "AutoPost Sales"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        Cust: Record Customer;
    begin
        //SendInvoiceFrom('VEN-E26-09250');
        //EXIT;

        //RD Expédiés
        SalesH.Reset;
        SalesH.SetRange("Location Code", 'RD');
        SalesH.SetFilter("Last Shipping No.", '<>''''');
        SalesH.SetFilter("Amt. Ship. Not Inv. (LCY)", '=0');
        SalesH.DeleteAll;

        SalesH.Reset;
        SalesH.SetCurrentKey("Posting Date");
        SalesH.SetRange("Document Type", SalesH."Document Type"::Order);
        SalesH.SetRange("Shipped Not Invoiced", true);
        //SalesH.SETFILTER("No.",'<>CDV-E24-09304');
        //SalesH.SETRANGE("Completely Shipped",TRUE);
        SalesH.SetFilter("Location Code", '<>RD');
        if Rec."Parameter String" = 'GB' then
            SalesH.SetRange("Ship-to Country/Region Code", 'GB');
        if Rec."Parameter String" = 'CLIENTS' then
            SalesH.SetFilter("Sell-to Customer No.", 'C02682');

        //SalesH.SETRANGE("Posting Date",130825D,180825D);

        //SalesH.SETFILTER("No.",'<>%1','CDV-E26-00358');

        SalesHP.Reset;
        SalesHP.FindLast;
        LastNo := SalesHP."No.";

        if SalesH.FindSet then
            repeat
                SalesL.Reset;
                SalesL.SetRange("Document Type", SalesH."Document Type");
                SalesL.SetRange("Document No.", SalesH."No.");
                SalesL.SetRange(Type, SalesL.Type::"G/L Account");
                if not SalesL.FindFirst then begin
                    SalesH.Invoice := true;
                    SalesH.Ship := false;
                    CUPost.Run(SalesH);
                end;
            until SalesH.Next = 0;

        SalesHP.Reset;
        SalesHP.FindLast;
        if (LastNo <> SalesHP."No.") then Msg := 'Facture generees de ' + IncStr(LastNo) + ' a ' + SalesHP."No." + '</BR>';

        SalesHP.Reset;
        SalesHP.SetFilter("No.", '%1..', IncStr(LastNo));
        if SalesHP.FindSet then
            repeat
                Cust.Get(SalesHP."Bill-to Customer No.");
                if Cust."EInvoice EAS" <> '' then begin
                    Msg := Msg + 'Peppol ' + SalesHP."No." + '</BR>';
                end
                else begin
                    if (CuMail._GetEMailsRespForEntity(DATABASE::Customer, SalesHP."Bill-to Customer No.", 'S01') = '') then begin
                        //STARTSESSION(SessionId,50042,COMPANYNAME,SalesH);
                        Msg := Msg + 'Print ' + SalesHP."No." + '</BR>';
                    end
                    else begin
                        Msg := Msg + 'Envoi ' + SalesHP."No." + '  -> ' + CuMail._GetEMailsRespForEntity(DATABASE::Customer, SalesHP."Bill-to Customer No.", 'S01') + '</BR>';

                        SalesHPSend.Reset;
                        SalesHPSend.SetFilter("No.", '%1', SalesHP."No.");
                        if SalesHPSend.FindFirst then
                            if SalesHPSend.Count < 10 then begin
                                modif.InvoiceLogo(SalesHPSend."No.", TypeLogo::Avec);
                                SalesHPSend.EmailRecords(false);
                                modif.InvoiceLogo(SalesHPSend."No.", TypeLogo::NonDefini);
                            end;
                    end;
                end;
                SalesHP.CalcFields("Shipment No.");
                Msg2 += SalesHP."No." + ' <- ' + SalesHP."Order No." + ' <- ' + SalesHP."Shipment No." + '</BR>';
            until SalesHP.Next = 0;

        f := FileMgt.ServerTempFileName('.pdf');

        InvoiceA4.SetPrintOnly();
        InvoiceA4.SetTableView(SalesHP);
        InvoiceA4.SaveAsPdf(f);

        if StrLen(Rec."Parameter String") < 2 then begin
            SalesH.Reset;
            SalesH.SetRange("Document Type", SalesH."Document Type"::Order);
            SalesH.SetRange("Shipped Not Invoiced", true);
            SalesH.SetRange("Completely Shipped", true);
            SalesH.SetFilter("Location Code", 'RD');

            if SalesH.FindSet then begin
                Msg := Msg + 'Commandes RD a facturer : ';
                repeat
                    Msg := Msg + SalesH."No." + '</BR>';
                until SalesH.Next = 0;
                Msg := Msg + '</BR>';
            end;
        end;
        if StrLen(Rec."Parameter String") >= 2 then begin
            if Msg <> '' then begin
                emailmsg.Create('sales-export@europacuisson.com;g.dangremont@europacuisson.com;billing@europacuisson.com', 'Facturation', '', true);
                emailmsg.AppendToBody(Msg);
                emailmsg.AppendToBody(Msg2);
                if FileMgt.ServerFileExists(f) then begin
                    FileMgt.BLOBImportFromServerFile(TempBlob, f);
                    TempBlob.CreateInStream(InS);
                    emailmsg.AddAttachment('Factures a imprimer.pdf', 'application/pdf', InS);
                end;
                emailsend.Send(emailmsg);
            end;
        end
        else begin
            emailmsg.Create('billing@europacuisson.com;g.dangremont@europacuisson.com;sales-export@europacuisson.com', 'Facturation', '', true);
            //  smtp.CreateMessage('Europacuisson','Xerox@europacuisson.com','g.dangremont@europacuisson.com','Fact','' ,TRUE);
            emailmsg.AppendToBody(Msg + Rec."Parameter String");
            emailmsg.AppendToBody(Msg2);
            if FileMgt.ServerFileExists(f) then begin
                FileMgt.BLOBImportFromServerFile(TempBlob, f);
                TempBlob.CreateInStream(InS);
                emailmsg.AddAttachment('Factures a imprimer.pdf', 'application/pdf', InS);
            end;
            emailsend.Send(emailmsg);
        end;
    end;

    var
        SalesH: Record "Sales Header";
        SalesHP: Record "Sales Invoice Header";
        SalesHPSend: Record "Sales Invoice Header";
        CUPost: Codeunit "Sales-Post";
        SalesL: Record "Sales Line";
        LastNo: Code[20];
        Msg: Text;
        emailmsg: codeunit "Email Message";
        emailsend: Codeunit Email;
        CuMail: Codeunit Integration_EMail;
        modif: Codeunit ModifTables;
        TypeLogo: Option NonDefini,Avec,Sans;
        InvoiceA4: Report "Sales - Invoice EC";
        f: Text;
        Msg2: Text;
        FileMgt: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";
        InS: InStream;

    local procedure SendInvoiceFrom(FirstNo: Code[20])
    var
        Cust: Record Customer;
    begin
        SalesHP.Reset;
        SalesHP.SetFilter("No.", '%1..', FirstNo);
        if SalesHP.FindSet then
            repeat
                Cust.Get(SalesHP."Bill-to Customer No.");
                if Cust."EInvoice EAS" <> '' then begin
                    Msg := Msg + 'Peppol ' + SalesHP."No." + '</BR>';
                end
                else begin
                    if (CuMail._GetEMailsRespForEntity(DATABASE::Customer, SalesHP."Bill-to Customer No.", 'S01') = '') then begin
                        //STARTSESSION(SessionId,50042,COMPANYNAME,SalesH);
                        Msg := Msg + 'Print ' + SalesHP."No." + '</BR>';
                    end
                    else begin
                        Msg := Msg + 'Envoi ' + SalesHP."No." + '  -> ' + CuMail._GetEMailsRespForEntity(DATABASE::Customer, SalesHP."Bill-to Customer No.", 'S01') + '</BR>';

                        SalesHPSend.Reset;
                        SalesHPSend.SetFilter("No.", '%1', SalesHP."No.");
                        if SalesHPSend.FindFirst then
                            if SalesHPSend.Count < 10 then begin
                                modif.InvoiceLogo(SalesHPSend."No.", TypeLogo::Avec);
                                SalesHPSend.EmailRecords(false);
                                modif.InvoiceLogo(SalesHPSend."No.", TypeLogo::NonDefini);
                            end;
                    end;
                end;
                SalesHP.CalcFields("Shipment No.");
                Msg2 += SalesHP."No." + ' <- ' + SalesHP."Order No." + ' <- ' + SalesHP."Shipment No." + '</BR>';
            until SalesHP.Next = 0;

        f := FileMgt.ServerTempFileName('.pdf');

        InvoiceA4.SetPrintOnly();
        InvoiceA4.SetTableView(SalesHP);
        InvoiceA4.SaveAsPdf(f);

        SalesH.Reset;
        SalesH.SetRange("Document Type", SalesH."Document Type"::Order);
        SalesH.SetRange("Shipped Not Invoiced", true);
        SalesH.SetRange("Completely Shipped", true);
        SalesH.SetFilter("Location Code", 'RD');

        if SalesH.FindSet then begin
            Msg := Msg + 'Commandes RD a facturer : ';
            repeat
                Msg := Msg + SalesH."No." + '</BR>';
            until SalesH.Next = 0;
            Msg := Msg + '</BR>';
        end;


        emailmsg.Create('billing@europacuisson.com;g.dangremont@europacuisson.com;sales-export@europacuisson.com', 'Facturation', '', true);
        //  smtp.CreateMessage('Europacuisson','Xerox@europacuisson.com','g.dangremont@europacuisson.com','Fact','' ,TRUE);
        emailmsg.AppendToBody(Msg);
        emailmsg.AppendToBody(Msg2);
        if FileMgt.ServerFileExists(f) then begin
            FileMgt.BLOBImportFromServerFile(TempBlob, f);
            TempBlob.CreateInStream(InS);
            emailmsg.AddAttachment('Factures a imprimer.pdf', 'application/pdf', InS);
        end;
        emailsend.Send(emailmsg);
    end;
}

