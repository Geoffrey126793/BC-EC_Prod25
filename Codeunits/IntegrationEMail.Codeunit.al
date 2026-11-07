codeunit 50038 Integration_EMail
{

    trigger OnRun()
    begin
        Message(_GetEMailsRespForEntity(DATABASE::Customer, 'C02764', 'S01'));
    end;

    var
        FileMgt: Codeunit "File Management";


    [EventSubscriber(ObjectType::Codeunit, 260, 'OnBeforeSendEmail', '', false, false)]
    local procedure CU260_OnBeforeSendMail(var TempEmailItem: Record "Email Item" temporary; var IsFromPostedDoc: Boolean; var PostedDocNo: Code[20]; var HideDialog: Boolean; var ReportUsage: Integer; var EmailSentSuccesfully: Boolean; var IsHandled: Boolean; EmailDocName: Text[250]; SenderUserID: Code[50]; EmailScenario: Enum "Email Scenario")
    var
        ReportSelection: Record "Report Selections";
        TempFile: Text;
        cuEDI: Codeunit EDI;
        PurchH: Record "Purchase Header";
        Vend: Record Vendor;
        emailmsg: codeunit "Email Message";
        emailsend: codeunit Email;
        SalesH: Record "Sales Header";
        SalesHP: Record "Sales Invoice Header";
        TempFile2: Text;
        FileMgt: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";
        InStr: InStream;
    begin




        if (ReportUsage = ReportSelection.Usage::"S.Quote".AsInteger()) then begin
            FileMgt.BLOBImportFromServerFile(TempBlob, '\\srvnavision\NavisionTemp\CGV.pdf');
            TempBlob.CreateInStream(InStr);
            TempEmailItem.AddAttachment(InStr, 'Terms_and_Conditions.pdf');
        end;

        if (ReportUsage = ReportSelection.Usage::"S.Order".AsInteger()) then begin
            FileMgt.BLOBImportFromServerFile(TempBlob, '\\srvnavision\NavisionTemp\CGV.pdf');
            TempBlob.CreateInStream(InStr);
            TempEmailItem.AddAttachment(InStr, 'Terms_and_Conditions.pdf');
            if SalesH.Get(SalesH."Document Type"::Order, PostedDocNo) then
                if SalesH."External Document No." <> '' then
                    TempEmailItem.Subject := TempEmailItem.Subject + ' - ' + SalesH."External Document No.";
        end;

        if (ReportUsage = ReportSelection.Usage::"S.Invoice".AsInteger()) then begin
            FileMgt.BLOBImportFromServerFile(TempBlob, '\\srvnavision\NavisionTemp\CGV.pdf');
            TempBlob.CreateInStream(InStr);
            TempEmailItem.AddAttachment(InStr, 'CGV.pdf');
            TempEmailItem."Send BCC" := 'billing@europacuisson.com';

            if SalesHP.Get(PostedDocNo) then begin
                if SalesHP."Currency Code" = 'GBP' then begin
                    FileMgt.BLOBImportFromServerFile(TempBlob, '\\srvnavision\NavisionTemp\CourrierGB.pdf');
                    TempBlob.CreateInStream(InStr);
                    TempEmailItem.AddAttachment(InStr, 'Bank.pdf');

                end;
            end;
        end;

        if (ReportUsage = ReportSelection.Usage::"P.Arch.Blanket".AsInteger()) then   // Commande achat transport
        begin
            if PurchH.Get(PurchH."Document Type"::Order, PostedDocNo) then
                if Vend.Get(PurchH."Buy-from Vendor No.") then
                    if Vend."Traitement EDI" = Vend."Traitement EDI"::csv1 then begin
                        emailmsg.Create(Vend."E-Mail EDI", '', '', false);
                        emailmsg.AddRecipient(Enum::"Email Recipient Type"::Bcc, 'g.dangremont@europacuisson.com');
                        TempFile := FileMgt.ServerTempFileName('csv');
                        cuEDI.FichierTFE(TempFile, PostedDocNo);
                        FileMgt.BLOBImportFromServerFile(TempBlob, TempFile);
                        TempBlob.CreateInStream(InStr);
                        emailmsg.AddAttachment('CDA.csv', 'text/csv', InStr);
                        emailsend.Send(emailmsg, Enum::"Email Scenario"::Transport);
                    end;
        end;
    end;




    [EventSubscriber(ObjectType::Table, 77, 'OnBeforeGetCustEmailAddress', '', false, false)]
    local procedure T77_OnBeforeGetCustEMail(BillToCustomerNo: Code[20]; var ToAddress: Text; ReportUsage: Option; var IsHandled: Boolean)
    var
        TempBodyReportSelections: Record "Report Selections";
        recCust: Record Customer;
    begin

        if (ReportUsage = TempBodyReportSelections.Usage::"S.Quote".AsInteger()) then begin
            ToAddress := '';  // => Sell-to EMail du devis (venant du contact T36_OnChangeContact)
            IsHandled := true;
        end;

        if (ReportUsage = TempBodyReportSelections.Usage::"S.Order".AsInteger()) then begin
            if (StrPos(UpperCase(UserId), 'GEOFFREY') > 0) then
                ToAddress := 'g.dangremont@europacuisson.com'
            else
                ToAddress := _GetEMailsRespForEntity(DATABASE::Customer, BillToCustomerNo, 'S03');
            if ToAddress = '' then Error('Pas d''adresse mail pour recevoir le fichier');
            if ToAddress <> '' then IsHandled := true;

            if recCust.Get(BillToCustomerNo) then
                if recCust."Salesperson Code" = '39' then
                    ToAddress := ToAddress + ';Pierre-Yves.Beckman@europacuisson.com';
            if recCust.Get(BillToCustomerNo) then
                if recCust."Salesperson Code" = '74' then
                    ToAddress := ToAddress + ';Fiona.Herlihy@europacuisson.com';
            if recCust.Get(BillToCustomerNo) then
                if recCust."Salesperson Code" = '71' then
                    ToAddress := ToAddress + ';Lidio.Flor@europacuisson.com';
        end;
        if (ReportUsage = TempBodyReportSelections.Usage::"S.Invoice".AsInteger()) then begin
            //     IF (STRPOS(UPPERCASE(USERID),'GEOFFREY') > 0) THEN
            //      ToAddress := 'g.dangremont@europacuisson.com'
            //    ELSE
            ToAddress := _GetEMailsRespForEntity(DATABASE::Customer, BillToCustomerNo, 'S01');
            if not GuiAllowed then
                ToAddress := 'BILLING@EUROPACUISSON.COM;' + ToAddress;

            if ToAddress = '' then Error('Pas d''adresse mail pour recevoir le fichier');
            if ToAddress <> '' then IsHandled := true;
        end;
        if (ReportUsage = TempBodyReportSelections.Usage::"S.Cr.Memo".AsInteger()) then begin
            if (StrPos(UpperCase(UserId), 'GEOFFREY1') > 0) then
                ToAddress := 'g.dangremont@europacuisson.com'
            else
                ToAddress := _GetEMailsRespForEntity(DATABASE::Customer, BillToCustomerNo, 'S01');
            if ToAddress = '' then Error('Pas d''adresse mail pour recevoir le fichier');
            if ToAddress <> '' then IsHandled := true;
        end;
        if (ReportUsage = TempBodyReportSelections.Usage::Reminder.AsInteger()) then begin
            //  IF (STRPOS(UPPERCASE(USERID),'GEOFFREY') > 0) THEN
            //   ToAddress := 'g.dangremont@europacuisson.com'
            // ELSE
            ToAddress := _GetEMailsRespForEntity(DATABASE::Customer, BillToCustomerNo, 'S02');
            if ToAddress = '' then Error('Pas d''adresse mail pour recevoir le fichier');
            if ToAddress <> '' then IsHandled := true;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 77, 'OnBeforeGetVendorEmailAddress', '', false, false)]
    local procedure T77_OnBeforeGetVendorEMail(BuyFromVendorNo: Code[20]; var ToAddress: Text; ReportUsage: Option; var IsHandled: Boolean)
    var
        TempBodyReportSelections: Record "Report Selections";
    begin
        if ((ReportUsage = TempBodyReportSelections.Usage::"P.Order".AsInteger()) or (ReportUsage = TempBodyReportSelections.Usage::"P.Blanket".AsInteger()) or (ReportUsage = TempBodyReportSelections.Usage::"P.Arch.Blanket".AsInteger())) then begin
            if (StrPos(UpperCase(UserId), 'GEOFFREY') > 0) then
                ToAddress := 'g.dangremont@europacuisson.com'
            else
                ToAddress := _GetEMailsRespForEntity(DATABASE::Vendor, BuyFromVendorNo, 'S03');
            if ToAddress = '' then Error('Pas d''adresse mail pour recevoir le fichier');
            if ToAddress <> '' then IsHandled := true;
        end;
    end;

    [Scope('OnPrem')]
    procedure _GetEMailRespForEntity(TableNo: Integer; No: Code[20]; Responsability: Code[10]; var ContactsTrough: Record "Communication Method")
    var
        ContBusRel: Record "Contact Business Relation";
        Ct: Record Contact;
        Resp: Record "Contact Job Responsibility";
        KeyNo: Integer;
    begin
        ContBusRel.Reset;
        case TableNo of
            DATABASE::Customer:
                ContBusRel.SetRange("Link to Table", ContBusRel."Link to Table"::Customer);
            DATABASE::Vendor:
                ContBusRel.SetRange("Link to Table", ContBusRel."Link to Table"::Vendor);
            DATABASE::"Bank Account":
                ContBusRel.SetRange("Link to Table", ContBusRel."Link to Table"::"Bank Account");
        end;
        ContBusRel.SetRange("No.", No);
        if ContBusRel.FindFirst then begin
            Ct.Reset;
            Ct.SetRange("Company No.", ContBusRel."Contact No.");
            if Ct.FindSet then
                repeat
                    Resp.Reset;
                    Resp.SetRange("Contact No.", Ct."No.");
                    Resp.SetRange("Job Responsibility Code", Responsability);
                    if Resp.FindFirst then begin
                        ContactsTrough.Reset;
                        ContactsTrough.SetRange("E-Mail", Ct."E-Mail");
                        if not ContactsTrough.FindFirst then begin
                            ContactsTrough.Reset;
                            if ContactsTrough.FindLast then
                                KeyNo := ContactsTrough.Key + 1
                            else
                                KeyNo := 1;
                            ContactsTrough.Reset;
                            ContactsTrough.Init;
                            ContactsTrough.Key := KeyNo;
                            ContactsTrough."E-Mail" := Ct."E-Mail";
                            ContactsTrough.Insert;
                        end;

                    end;
                until Ct.Next = 0;
        end;
    end;

    [Scope('OnPrem')]
    procedure _GetEMailsRespForEntity(TableNo: Integer; No: Code[20]; Responsability: Code[10]) EMails: Text
    var
        Ct: Record "Communication Method" temporary;
    begin
        Ct.Reset;
        Ct.DeleteAll;
        _GetEMailRespForEntity(TableNo, No, Responsability, Ct);
        EMails := '';

        Ct.Reset;
        if Ct.FindSet then
            repeat
                if EMails = '' then
                    EMails := Ct."E-Mail"
                else
                    EMails := EMails + ';' + Ct."E-Mail";
            until Ct.Next = 0;
    end;

    [EventSubscriber(ObjectType::Table, 77, 'OnAfterSendEmailDirectly', '', false, false)]
    local procedure T77_OnAfterSendEMail(ReportUsage: Integer; RecordVariant: Variant; var AllEmailsWereSuccessful: Boolean)
    var
        T77: Record "Report Selections";
        RecRef: RecordRef;
        FieldRef: FieldRef;
        SalesH: Record "Sales Header";
    begin
        if (ReportUsage = T77.Usage::"S.Order".AsInteger()) then begin
            RecRef.GetTable(RecordVariant);
            FieldRef := RecRef.Field(3);
            if SalesH.Get(SalesH."Document Type"::Order, Format(FieldRef.Value)) then begin
                SalesH."Confirmation envoyée" := true;
                SalesH.Modify;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterValidateEvent', 'Sell-to Contact No.', false, false)]
    local procedure T36_OnChangeContact(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        Contact: Record Contact;
    begin
        Contact.Get(Rec."Sell-to Contact No.");
        Rec."Sell-to E-Mail" := Contact."E-Mail";
    end;

    [Scope('OnPrem')]
    procedure SendEMailPurchaseOrder(PurchaseNo: Code[20])
    var
        PurchH: Record "Purchase Header";
        ReportSelections: Record "Report Selections";
        PurchL: Record "Purchase Line";
        PurchSetup: Record "Purchases & Payables Setup";
    begin
        PurchSetup.Get();
        PurchH.Get(PurchH."Document Type"::Order, PurchaseNo);
        PurchH.Reset;
        PurchH.SetFilter("Document Type", '%1', PurchH."Document Type"::Order);
        PurchH.SetFilter("No.", PurchaseNo);
        if PurchH.FindFirst then begin
            PurchL.Reset;
            PurchL.SetRange("Document Type", PurchH."Document Type");
            PurchL.SetRange("Document No.", PurchaseNo);
            PurchL.SetRange(Type, PurchL.Type::"G/L Account");
            PurchL.SetFilter("No.", '%1|%2', PurchSetup."Transport G/L Account No.", PurchSetup."Transport G/L Account No. RD");
            if PurchL.FindFirst then
                ReportSelections.SendEmailToVendor(ReportSelections.Usage::"P.Arch.Blanket".AsInteger(), PurchH, PurchH."No.", 'Commande', true, PurchH."Buy-from Vendor No.")
            else
                ReportSelections.SendEmailToVendor(ReportSelections.Usage::"P.Order".AsInteger(), PurchH, PurchH."No.", 'Commande', true, PurchH."Buy-from Vendor No.");
        end;
    end;

    [Scope('OnPrem')]
    procedure GetSignature(User: Code[50]) Sign: Text[1024]
    var
        CRLF: Text[4];
        Emp: Record Employee;
        cuUtils: Codeunit Utils;
    begin
        CRLF[1] := 13;
        Emp.Reset;
        Emp.SetRange(User, User);
        if not Emp.FindFirst then begin
            Emp.SetRange(User, cuUtils.Replace(User, 'EUROPACUISSON\', ''));
            // IF NOT Emp.FINDFIRST THEN
            //   ERROR('User %1 non trouvé pour signature',User);
        end;

        if Emp.FindFirst then begin
            Sign := CRLF + CRLF;
            Sign := Sign + Emp."First Name" + ' ' + Emp."Last Name" + CRLF;
            Sign := Sign + Emp."Job Title" + CRLF;
            Sign := Sign + 'Tel : ' + Emp."Phone No." + CRLF;
            //  Sign := Sign + 'Fax : ' + Emp."Fax No." + CRLF;
            Sign := Sign + Emp."Company E-Mail" + CRLF;
            Sign := Sign + 'www.europacuisson.com' + CRLF;
        end;
    end;

    [Scope('OnPrem')]
    procedure GetSignatureHTML(User: Code[50]) Sign: Text[1024]
    var
        CRLF: Text[10];
        Emp: Record Employee;
        cuUtils: Codeunit Utils;
    begin
        CRLF := '</BR>';
        Emp.Reset;
        Emp.SetRange(User, User);
        if not Emp.FindFirst then begin
            Emp.SetRange(User, cuUtils.Replace(User, 'EUROPACUISSON\', ''));
            // IF NOT Emp.FINDFIRST THEN
            //   ERROR('User %1 non trouvé pour signature',User);
        end;

        if Emp.FindFirst then begin
            Sign := CRLF + CRLF;
            Sign := Sign + Emp."First Name" + ' ' + Emp."Last Name" + CRLF;
            Sign := Sign + Emp."Job Title" + CRLF;
            Sign := Sign + 'Tel : ' + Emp."Phone No." + CRLF;
            //  Sign := Sign + 'Fax : ' + Emp."Fax No." + CRLF;
            Sign := Sign + Emp."Company E-Mail" + CRLF;
            Sign := Sign + 'www.europacuisson.com' + CRLF;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 365, 'OnBeforeSalesHeaderSellTo', '', false, false)]
    local procedure CU365_OnBeforeSalesHeaderSellTo(var AddrArray: array[8] of Text[100]; var SalesHeader: Record "Sales Header"; var Handled: Boolean)
    begin
        SalesHeader."Sell-to Contact" := '';
    end;

    [EventSubscriber(ObjectType::Codeunit, 365, 'OnBeforeSalesHeaderBillTo', '', false, false)]
    local procedure CU365_OnBeforeSalesHeaderBillTo(var AddrArray: array[8] of Text[100]; var SalesHeader: Record "Sales Header"; var Handled: Boolean)
    begin
        SalesHeader."Bill-to Contact" := '';
    end;

    [EventSubscriber(ObjectType::Codeunit, 365, 'OnBeforeSalesHeaderShipTo', '', false, false)]
    local procedure CU365_OnBeforeSalesHeaderShipTo(var AddrArray: array[8] of Text[100]; CustAddr: array[8] of Text[100]; var SalesHeader: Record "Sales Header"; var Handled: Boolean; var Result: Boolean)
    begin
        SalesHeader."Ship-to Contact" := '';
    end;

    [EventSubscriber(ObjectType::Codeunit, 365, 'OnBeforeSalesShptShipTo', '', false, false)]
    local procedure CU365_OnBeforeSalesShptShipTo(var AddrArray: array[8] of Text[100]; var SalesShipmentHeader: Record "Sales Shipment Header"; var Handled: Boolean)
    begin
        SalesShipmentHeader."Ship-to Contact" := '';
    end;

    [EventSubscriber(ObjectType::Codeunit, 365, 'OnBeforeSalesInvBillTo', '', false, false)]
    local procedure CU365_OnBeforeSalesInvBillTo(var AddrArray: array[8] of Text[100]; var SalesInvHeader: Record "Sales Invoice Header"; var Handled: Boolean)
    begin
        SalesInvHeader."Bill-to Contact" := '';
    end;

    [EventSubscriber(ObjectType::Codeunit, 365, 'OnBeforeSalesCrMemoBillTo', '', false, false)]
    local procedure CU365_OnBeforeSalesCrMemoBillTo(var AddrArray: array[8] of Text[100]; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var Handled: Boolean)
    begin
        SalesCrMemoHeader."Bill-to Contact" := '';
    end;

    [EventSubscriber(ObjectType::Codeunit, 9520, 'OnBeforeQualifyFromAddress', '', false, false)]
    local procedure CU9520_OnBeforeQualifyFrom(var TempEmailItem: Record "Email Item" temporary)
    var
        TempPossibleEmailNameValueBuffer: Record "Name/Value Buffer" temporary;
        MailForEmails: Codeunit Mail;
        CuUtils: Codeunit Utils;
    begin

        MailForEmails.CollectCurrentUserEmailAddresses(TempPossibleEmailNameValueBuffer);

        TempPossibleEmailNameValueBuffer.SetFilter(Name, 'AuthEmail');
        if not TempPossibleEmailNameValueBuffer.IsEmpty then begin
            TempPossibleEmailNameValueBuffer.FindFirst;
            if TempPossibleEmailNameValueBuffer.Value <> '' then begin
                TempEmailItem."From Address" := TempPossibleEmailNameValueBuffer.Value;
                TempEmailItem."Send BCC" := TempEmailItem."From Address";
            end;
        end;

        if (StrPos(TempEmailItem.Subject, 'REL-E') > 0) then begin
            TempEmailItem."From Address" := 'BILLING@EUROPACUISSON.COM';
            TempEmailItem."Send BCC" := 'BILLING@EUROPACUISSON.COM';
        end;

        if not GuiAllowed then // E-Invoice auto
            if StrPos(TempEmailItem."Send to", 'BILLING@EUROPACUISSON.COM') > 0 then begin
                TempEmailItem."Send to" := CuUtils.Replace(TempEmailItem."Send to", 'BILLING@EUROPACUISSON.COM;', '');
                TempEmailItem."From Address" := 'BILLING@EUROPACUISSON.COM';
                TempEmailItem."Send BCC" := '';
            end;
        TempPossibleEmailNameValueBuffer.Reset;
    end;

    [EventSubscriber(ObjectType::Table, 474, 'OnAfterInsertEvent', '', false, false)]
    local procedure T474_OnInsert(var Rec: Record "Job Queue Log Entry"; RunTrigger: Boolean)
    var
        emailmsg: codeunit "Email Message";
        emailsend: codeunit Email;
    begin
        if Rec.Status = Rec.Status::Error then begin
            emailmsg.Create('g.dangremont@europacuisson.com', 'Erreur job', Rec."Error Message", true);
            emailsend.Send(emailmsg, Enum::"Email Scenario"::Default);
        end;
    end;

    [EventSubscriber(ObjectType::Table, 474, 'OnAfterModifyEvent', '', false, false)]
    local procedure T474_OnModify(var Rec: Record "Job Queue Log Entry"; var xRec: Record "Job Queue Log Entry"; RunTrigger: Boolean)
    var
        emailmsg: codeunit "Email Message";
        emailsend: codeunit Email;
    begin
        if Rec.Status = Rec.Status::Error then begin
            emailmsg.Create('g.dangremont@europacuisson.com', 'Erreur job', Rec."Error Message", true);
            emailsend.Send(emailmsg, Enum::"Email Scenario"::Default);
        end;
    end;
}

