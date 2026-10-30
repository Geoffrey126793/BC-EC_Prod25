codeunit 50003 Trigger_einvoice
{
    Permissions = TableData "Sales Invoice Header" = rimd,
                  TableData "Sales Cr.Memo Header" = rimd;

    trigger OnRun()
    var
        SalesH: Record "Sales Cr.Memo Header";
    begin

        //CheckInbox();

        SalesH.Get('NCV-E26-0116');
        GetCRPeppolFile(SalesH);

        //CheckBabelwayStatus();
        Message('ok');
    end;

    var
        Goodns: Record "Code" temporary;
        Utils: Codeunit Utils;

    [Scope('OnPrem')]
    procedure GetAttachedInvoiceFromIncomingDocument(var IncomingDocument: Record "Incoming Document")
    var
        T133: Record "Incoming Document Attachment";
        T130: Record "Incoming Document";
        XPath: Text;
        ImportXMLFileToDataExch: Codeunit "Import XML File to Data Exch.";
        RecRef: RecordRef;
        FieldRef: FieldRef;
        XMLDOMManagement: Codeunit "XML DOM Management";
        XmlValue: Text;
        CuBlob: Codeunit "Temp Blob";
        InStream: InStream;
        OutStr: OutStream;
        FileName: Text;
        Mime: Text;
        FileMgt: Codeunit "File Management";
        i: Integer;
        hasfile: Boolean;
    begin

        GetAttachedInvoiceFromIncomingDocumentPath(IncomingDocument, '');
    end;

    [Scope('OnPrem')]
    procedure GetAttachedInvoiceFromIncomingDocumentPath(var IncomingDocument: Record "Incoming Document"; Path: Text)
    var
        T133: Record "Incoming Document Attachment";
        T130: Record "Incoming Document";
        XPath: Text;
        ImportXMLFileToDataExch: Codeunit "Import XML File to Data Exch.";
        RecRef: RecordRef;
        FieldRef: FieldRef;
        XMLDOMManagement: Codeunit "XML DOM Management";
        XmlNamespaceManager: XmlNamespaceManager;
        XMLRootNode: XmlNode;
        XmlValue: Text;
        CuBlob: Codeunit "Temp Blob";
        InStream: InStream;
        OutStr: OutStream;
        XMLNode: XmlNode;
        XMLAttr: XmlAttribute;
        XMLNodeList: XmlNodeList;
        FileName: Text;
        Mime: Text;
        FileMgt: Codeunit "File Management";
        i: Integer;
        hasfile: Boolean;
        XMLDoc: XmlDocument;
        XMLText: text;
        TempBlob: Codeunit "Temp Blob";
        Base64Convert: Codeunit "Base64 Convert";
        HttpClient: HttpClient;
        HttpResponse: HttpResponseMessage;
        HttpContent: HttpContent;
        OutStream: OutStream;
    begin
        hasfile := false;
        T133.Reset;
        T133.SetRange("Incoming Document Entry No.", IncomingDocument."Entry No.");
        T133.SetRange(Default, true);
        if not T133.FindFirst then exit;
        T133.CalcFields(Content);
        if IncomingDocument."Data Exchange Type" = 'PEPPOLCR' then
            XPath := '/CreditNote/cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject'
        else
            XPath := '/Invoice/cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject';
        XPath := ImportXMLFileToDataExch.EscapeMissingNamespacePrefix(XPath);

        T133.CalcFields(Content);
        T133.Content.CreateInStream(InStream);
        InStream.ReadText(XMLText);

        if not XmlDocument.ReadFrom(XMLText, XMLDoc) then
            exit;

        XMLRootNode := XMLDoc.AsXmlNode();

        XMLRootNode.SelectNodes(XPath, XMLNodeList);

        for i := 1 to XMLNodeList.Count do begin
            hasfile := true;
            XMLNodeList.Get(i, XMLNode);
            XmlValue := XMLNode.AsXmlElement().InnerText();
            FileName := CreateGuid();
            Mime := XMLDOMManagement.GetAttributeValue(XMLNode, 'mimeCode');
            case Mime of
                'application/pdf':
                    FileName := FileName + '.pdf';
                'r':
                    FileName := FileName + '.zzz';
                else
                    Error('Format non supporté : ' + Mime);
            end;
            Clear(TempBlob);
            TempBlob.CreateOutStream(OutStr);

            Base64Convert.FromBase64(XmlValue, OutStr);

            if Path <> '' then begin
                FileMgt.BLOBExportToServerFile(TempBlob, Path);
                i := XMLNodeList.Count();
            end else begin
                FileMgt.BLOBExport(TempBlob, FileName, true);

                if (XMLNodeList.Count() > 1) and
                (i < XMLNodeList.Count() - 1) then
                    if not Confirm('Voulez-vous voir le fichier suivant ?') then
                        i := XMLNodeList.Count();
            end;


        end;
        if (not hasfile) then  // un lien ?
        begin

            if IncomingDocument."Data Exchange Type" = 'PEPPOLCR' then
                XPath :=
                    '/*[local-name()="CreditNote"]' +
                    '/*[local-name()="AdditionalDocumentReference"]' +
                    '/*[local-name()="Attachment"]' +
                    '/*[local-name()="ExternalReference"]' +
                    '/*[local-name()="URI"]'
            else
                XPath :=
                    '/*[local-name()="Invoice"]' +
                    '/*[local-name()="AdditionalDocumentReference"]' +
                    '/*[local-name()="Attachment"]' +
                    '/*[local-name()="ExternalReference"]' +
                    '/*[local-name()="URI"]';

            T133.CalcFields(Content);
            T133.Content.CreateInStream(InStream);

            if not XmlDocument.ReadFrom(InStream, XMLDoc) then
                exit;

            XMLRootNode := XMLDoc.AsXmlNode();

            if not XMLRootNode.SelectNodes(XPath, XMLNodeList) then
                exit;

            FileName := Format(CreateGuid());

            for i := 1 to XMLNodeList.Count() do begin
                XMLNodeList.Get(i, XMLNode);

                if XMLNode.IsXmlElement() then begin
                    XmlValue := XMLNode.AsXmlElement().InnerText();

                    if XmlValue <> '' then begin
                        // Télécharger le fichier depuis son URL
                        if not HttpClient.Get(XmlValue, HttpResponse) then
                            Error('Impossible de télécharger le fichier : %1', XmlValue);

                        if not HttpResponse.IsSuccessStatusCode() then
                            Error(
                                'Erreur HTTP %1 pour %2',
                                HttpResponse.HttpStatusCode(),
                                XmlValue);

                        Clear(TempBlob);
                        TempBlob.CreateOutStream(OutStream);

                        HttpContent := HttpResponse.Content();
                        HttpContent.ReadAs(InStream);
                        CopyStream(OutStream, InStream);

                        // Exporter le fichier
                        if Path <> '' then
                            FileMgt.BLOBExportToServerFile(TempBlob, Path)
                        else
                            FileMgt.BLOBExport(TempBlob, FileName, true);

                        hasfile := true;
                    end;
                end;
            end;
        end;

        if (not hasfile) and (GuiAllowed) then
            if Confirm('Le fournisseur n''a pas joint de fichier, voulez-vous générer un PDF avec les infos de base venant de Peppol ?') then GetSimulatedPDF(IncomingDocument);

        if (not hasfile) and (GuiAllowed) then Message('Le fournisseur n''a pas joint de fichier pdf pour ce document entrant');
    end;

    [Scope('OnPrem')]
    procedure GetAttachedInvoiceFromPurchaseInvoice(Rec: Record "Purch. Inv. Header")
    var
        Doc: Record "Incoming Document";
    begin
        Doc.Reset;
        Doc.SetRange("Document Type", Doc."Document Type"::"Purchase Invoice");
        Doc.SetRange("Document No.", Rec."No.");
        if Doc.FindFirst then
            GetAttachedInvoiceFromIncomingDocument(Doc);
    end;

    [Scope('OnPrem')]
    procedure GetAttachedInvoiceFromPurchase(Rec: Record "Purchase Header")
    var
        Doc: Record "Incoming Document";
    begin
        Doc.Reset;
        Doc.SetRange("Document Type", Doc."Document Type"::"Purchase Invoice");
        Doc.SetRange("Document No.", Rec."No.");
        if Doc.FindFirst then
            GetAttachedInvoiceFromIncomingDocument(Doc);
    end;

    [Scope('OnPrem')]
    procedure GetInvoicePDF(No: Code[20]): Text
    var
        SalesH: Record "Sales Invoice Header";
        "Report": Report "Sales - Invoice EC";
        modif: Codeunit ModifTables;
        FileMgt: Codeunit "File Management";
        Path: Text;
        PathOK: Text;
    begin
        SalesH.Reset;
        SalesH.SetRange("No.", No);
        if SalesH.FindFirst then begin
            modif.InvoiceLogo(No, 1);
            Report.SetTableView(SalesH);
            Path := '\\srvnavision\NavisionTemp\Extranet\' + SalesH."No." + '.pdf';
            Report.SaveAsPdf(Path);
            PathOK := '\\srvnavision\NavisionTemp\Extranet\' + CompanyName + SalesH."No." + '.pdf';
            AddCGV('\Extranet\' + SalesH."No.", '\Extranet\' + CompanyName + SalesH."No.", SalesH."Language Code");
            FILE.Erase(Path);
        end;

        exit(PathOK);
    end;

    [Scope('OnPrem')]
    procedure GetSalesInvoiceBase64(No: Code[20]): Text
    var
        FileMgt: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";
        Base64Convert: Codeunit "Base64 Convert";
        InStr: InStream;
    begin
        FileMgt.BLOBImportFromServerFile(TempBlob, GetInvoicePDF(No));
        TempBlob.CreateInStream(InStr);

        exit(Base64Convert.ToBase64(InStr));
    end;

    [Scope('OnPrem')]
    procedure SaveInvoicePeppolFile(SalesH: Record "Sales Invoice Header"): Text
    var
        PeppolValidation: Codeunit "PEPPOL ValidationEC";
        PeppolGenXML: Codeunit "Exp. Sales Inv. PEPPOLBIS3.0EC";
        FileMgt: Codeunit "File Management";
    begin
        PeppolValidation.CheckSalesInvoice(SalesH);
        exit(PeppolGenXML.GenerateXMLFile(SalesH));
    end;

    [Scope('OnPrem')]
    procedure GetInvoicePeppolFile(SalesH: Record "Sales Invoice Header")
    var
        PeppolValidation: Codeunit "PEPPOL ValidationEC";
        PeppolGenXML: Codeunit "Exp. Sales Inv. PEPPOLBIS3.0EC";
        FileMgt: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";
    begin
        PeppolValidation.CheckSalesInvoice(SalesH);

        FileMgt.BLOBImportFromServerFile(
            TempBlob,
            PeppolGenXML.GenerateXMLFile(SalesH));

        FileMgt.BLOBExport(
            TempBlob,
            SalesH."No." + '.xml',
            true);
    end;

    [Scope('OnPrem')]
    procedure GetSalesCRPDF(CRNo: Code[20]): Text
    var
        id: Text;
        RepCredMem: Report "Nouveaux couts";
        SalesCRHeader: Record "Sales Cr.Memo Header";
        DocAttach: Record "Document Attachment";
        f: Text;
        "Report": Report "Sales - Credit Memo EC";
        modif: Codeunit ModifTables;
        FileMgt: Codeunit "File Management";
        Path: Text;
        PathOK: Text;
    begin
        SalesCRHeader.Reset;
        SalesCRHeader.SetFilter("No.", CRNo);
        if SalesCRHeader.FindFirst then begin
            Report.SetTableView(SalesCRHeader);
            Path := '\\srvnavision\NavisionTemp\Extranet\' + SalesCRHeader."No." + '.pdf';
            Report.SaveAsPdf(Path);
            PathOK := '\\srvnavision\NavisionTemp\Extranet\' + CompanyName + SalesCRHeader."No." + '.pdf';
            AddCGV('\Extranet\' + SalesCRHeader."No.", '\Extranet\' + CompanyName + SalesCRHeader."No.", SalesCRHeader."Language Code");
            FILE.Erase(Path);
        end;

        exit(PathOK);
    end;

    [Scope('OnPrem')]
    procedure GetSalesCRBase64(InvoiceNo: Code[20]): Text
    var
        TempBlob: Codeunit "Temp Blob";
        FileMgt: Codeunit "File Management";
        Base64Convert: Codeunit "Base64 Convert";
        InStr: InStream;
    begin
        FileMgt.BLOBImportFromServerFile(
            TempBlob,
            GetSalesCRPDF(InvoiceNo));

        TempBlob.CreateInStream(InStr);

        exit(Base64Convert.ToBase64(InStr));
    end;

    [Scope('OnPrem')]
    procedure SaveCRPeppolFile(CrH: Record "Sales Cr.Memo Header"): Text
    var
        PeppolValidation: Codeunit "PEPPOL ValidationEC";
        PeppolGenXML: Codeunit "Exp. Sales CrM. PEPPOLBIS3.0EC";
        FileMgt: Codeunit "File Management";
    begin
        if CrH."Your Reference" = '' then begin
            CrH."Your Reference" := CrH."No.";
            CrH.Modify;
        end;
        PeppolValidation.CheckSalesCreditMemo(CrH);
        exit(PeppolGenXML.GenerateXMLFile(CrH));
    end;

    [Scope('OnPrem')]
    procedure GetCRPeppolFile(CrH: Record "Sales Cr.Memo Header")
    var
        PeppolValidation: Codeunit "PEPPOL ValidationEC";
        PeppolGenXML: Codeunit "Exp. Sales CrM. PEPPOLBIS3.0EC";
        TempBlob: Codeunit "Temp Blob";
        FileMgt: Codeunit "File Management";
    begin
        if CrH."Your Reference" = '' then begin
            CrH."Your Reference" := CrH."No.";
            CrH.Modify();
        end;

        PeppolValidation.CheckSalesCreditMemo(CrH);

        FileMgt.BLOBImportFromServerFile(
            TempBlob,
            PeppolGenXML.GenerateXMLFile(CrH));

        FileMgt.BLOBExport(
            TempBlob,
            CrH."No." + '.xml',
            true);
    end;

    [EventSubscriber(ObjectType::Table, 700, 'OnBeforeInsertEvent', '', false, false)]
    local procedure LogTextNotFound(var Rec: Record "Error Message"; RunTrigger: Boolean)
    begin

        if StrPos(Rec.Message, 'Impossible de trouver un compte général approprié pour la ligne portant la description') > 0 then begin
            if StrPos(Rec.Message, 'Sélectionnez le bouton Mapper le texte avec le compte') > 0 then
                Rec."Additional Information" := CopyStr(Rec.Message, StrLen('Impossible de trouver un compte général approprié pour la ligne portant la description «') + 1, StrPos(Rec.Message, 'Sélectionnez le bouton Mapper le texte avec le compte') - StrLen('Impossible de trouver un compte général approprié pour la ligne portant la description «') - 1)
            else
                Rec."Additional Information" := CopyStr(Rec.Message, StrLen('Impossible de trouver un compte général approprié pour la ligne portant la description «') + 1, StrLen(Rec.Message) - StrLen('Impossible de trouver un compte général approprié pour la ligne portant la description «') - 1);
        end;
    end;

    procedure NormalizePeppolXML(FilePath: Text)
    var
        Xslt: DotNet XslCompiledTransform;
        XsltReader: DotNet DotNetXmlReader;
        SourceReader: DotNet DotNetXmlReader;
        ResultWriter: DotNet DotNetXmlWriter;
        StringReader: DotNet DotNetStringReader;
        FileMgt: Codeunit "File Management";
        XsltText: Text;
        TempPath: Text;
        MemoryStream: DotNet DotNetMemoryStream;

    begin
        Xslt := Xslt.XslCompiledTransform();
        Xslt.Load('\\srvnavision\NavisionTemp\NormalizePeppol.xslt');

        // Transformer le fichier XML
        SourceReader := SourceReader.Create(FilePath);
        ResultWriter := ResultWriter.Create(TempPath);

        Xslt.Transform(SourceReader, ResultWriter);

        ResultWriter.Close();
        SourceReader.Close();

        // Remplacer l'original uniquement après transformation
        FileMgt.CopyServerFile(TempPath, FilePath, true);
        FileMgt.DeleteServerFile(TempPath);
    end;


    procedure ImportEInvoice(FilePath: Text)
    var
        FileManagement: Codeunit "File Management";
        IncomingDoc: Record "Incoming Document Attachment";
        ImportDoc: Codeunit "Import Attachment - Inc. Doc.";
        InStream: InStream;
        outF: File;
        inF: File;
        tmpTxt: Text;
        NewFilePath: Text;
        inCust: Boolean;
        ForMe: Boolean;
        comp: Record "Company Information";
        DocType: Option Inconnu,Invoice,Response,CreditNote;
        XmlMmgt: Codeunit "XML DOM Management";
        i: Integer;
        Newns: Record "Code" temporary;
        InDoc: Record "Incoming Document";
        SessionId: Integer;
        TempBlob: Codeunit "Temp Blob";
        XmlFile: File;
        OutStr: OutStream;
        XmlDoc: XmlDocument;

    begin

        comp.Get;
        DocType := DocType::Inconnu;
        NewFilePath := FilePath.Replace('Received', 'Totreat');

        NormalizePeppolXML(FilePath);
        XmlFile.Create(FilePath);
        XmlFile.CreateOutStream(OutStr);

        XmlDoc.WriteTo(OutStr);

        XmlFile.Close();

        if inF.Open(FilePath) then begin
            outF.TextMode := true;
            outF.WriteMode := true;
            outF.Create(NewFilePath);
            inF.CreateInStream(InStream);
            inCust := false;
            ForMe := false;
            while not InStream.EOS() do begin
                InStream.ReadText(tmpTxt);
                outF.Write(tmpTxt);
                if StrPos(tmpTxt, '<Invoice') > 0 then DocType := DocType::Invoice;
                if StrPos(tmpTxt, '<ApplicationResponse') > 0 then DocType := DocType::Response;
                if StrPos(tmpTxt, '<CreditNote') > 0 then DocType := DocType::CreditNote;

                if StrPos(tmpTxt, '<cac:AccountingCustomerParty') > 0 then
                    inCust := true
                else
                    if StrPos(tmpTxt, '</cac:AccountingCustomerParty>') > 0 then inCust := false;
                if StrPos(tmpTxt, '<cac:ReceiverParty') > 0 then
                    inCust := true
                else
                    if StrPos(tmpTxt, '</cac:ReceiverPartyReceiverParty>') > 0 then inCust := false;
                if inCust and (StrPos(tmpTxt, DelChr(comp."VAT Registration No.", '=', DelChr(comp."VAT Registration No.", '=', '0123456789'))) > 0) then ForMe := true;
            end;
            inF.Close(); // Close the file
            outF.Close();

        end;
        //MESSAGE('%1  %2',DocType,ForMe);
        if ForMe and ((DocType = DocType::Invoice) or (DocType = DocType::CreditNote)) then begin
            Clear(TempBlob);
            FileManagement.BLOBImportFromServerFile(TempBlob, NewFilePath);

            IncomingDoc.Reset();
            IncomingDoc.Init();

            ImportDoc.ImportAttachment(
                IncomingDoc,
                FilePath,
                TempBlob);

            InDoc.Reset;
            if InDoc.Get(IncomingDoc."Incoming Document Entry No.") then
                //GetAttachedInvoiceFromIncomingDocumentPath(InDoc,'\\srvnavision\NavisionTemp\EINVOICE\Files\' + TextMgmt.Replace(InDoc."Vendor Name" + '-' + InDoc."Vendor Invoice No.",'\','_') + '____' + FORMAT(CREATEGUID) +  '.pdf');
                GetAttachedInvoiceFromIncomingDocumentPath(InDoc, '\\srvnavision\NavisionTemp\EINVOICE\Files\' + (InDoc."Vendor Name" + '-' + InDoc."Vendor Invoice No.").Replace('\', '_').Replace('/', '_') + '____' + Format(CreateGuid) + '.pdf');

            FILE.Erase(NewFilePath);
            FILE.Copy(FilePath, FilePath.Replace('Received', 'Treated'));
            FILE.Erase(FilePath);
            Commit;
            StartSession(SessionId, 50053, CompanyName);
        end;

        if ForMe and (DocType = DocType::Response) then begin
            TreatResponse(FilePath);
            FILE.Erase(NewFilePath);
            FILE.Copy(FilePath, FilePath.Replace('Received', 'Response'));
            FILE.Erase(FilePath);
        end;
    end;



    [Scope('OnPrem')]
    procedure CheckInbox()
    var
        WinSCPSesh: DotNet Session;
        WinSCPSessionOptions: DotNet SessionOptions;
        WinSCPTransferOptions: DotNet TransferOptions;
        WinSCPProtocol: DotNet Protocol;
        WinSCPTransferResumeSupport: DotNet TransferResumeSupport;
        WinSCPTransferResumeSupportState: DotNet TransferResumeSupportState;
        WinSCPTransferResult: DotNet TransferOperationResult;

        FileMgmt: Codeunit "File Management";
        buffer: Record "Name/Value Buffer" temporary;

    begin

        FileMgmt.GetServerDirectoryFilesList(buffer, '\\srvnavision\NavisionTemp\EINVOICE\EINVOICE_Received');
        if buffer.FindSet then
            repeat
                ImportEInvoice(buffer.Name);
            until buffer.Next = 0;


        WinSCPSessionOptions := WinSCPSessionOptions.SessionOptions();
        WinSCPSessionOptions.Protocol := WinSCPProtocol.Ftp;
        WinSCPSessionOptions.HostName := 'eu1.babelway.net';
        WinSCPSessionOptions.PortNumber := 21;
        WinSCPSessionOptions.UserName := 'EUROPACUISSON';
        WinSCPSessionOptions.Password := 'Europacuisson7522';
        //WinSCPSessionOptions.GiveUpSecurityAndAcceptAnySshHostKey := TRUE;

        WinSCPSesh := WinSCPSesh.Session();
        WinSCPSesh.Open(WinSCPSessionOptions);
        if WinSCPSesh.Opened then begin
            WinSCPTransferOptions := WinSCPTransferOptions.TransferOptions();
            WinSCPTransferOptions.TransferMode := 0;
            WinSCPTransferResumeSupport := WinSCPTransferOptions.ResumeSupport;
            WinSCPTransferResumeSupport.State(WinSCPTransferResumeSupportState.Off);
            WinSCPSesh.GetFiles('/PROD/PEPPOL_INVOICE_IN', '\\srvnavision\NavisionTemp\EINVOICE\EINVOICE_Received', true, WinSCPTransferOptions);
            WinSCPSesh.Dispose();
            FileMgmt.GetServerDirectoryFilesList(buffer, '\\srvnavision\NavisionTemp\EINVOICE\EINVOICE_Received');
            if buffer.FindSet then
                repeat
                    ImportEInvoice(buffer.Name);
                until buffer.Next = 0;
        end
        else begin

        end;
    end;

    [Scope('OnPrem')]
    procedure AddCGV(FileSrc: Text; FileDest: Text; Language: Code[20])
    var
        HttpWebRequestMgt: Codeunit "Http Web Request Mgt.";
        Instr: InStream;
        HttpResponse: HttpResponseMessage;
        HttpClient: HttpClient;
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        Url: Text;

    begin
        Url := 'http://intranet.europacuisson.local/PDF/Merge?src1=' + (FileSrc + '&src2=CGV' + CompanyName + '&dest=' + FileDest).Replace(' ', '%20');
        if not HttpClient.Get(Url, HttpResponse) then
            Error('Problème de connexion au service PDF');

        if not HttpResponse.IsSuccessStatusCode() then
            Error(
            'Problème génération PDF. Code HTTP : %1',
            HttpResponse.HttpStatusCode());

        Clear(TempBlob);
        TempBlob.CreateOutStream(OutStr);
    end;

    [Scope('OnPrem')]
    procedure GetPeppolList()
    var
        Txt: Text;
        tmp: Text;
        TmpJSon: Record "JSON Buffer" temporary;
        Instr: InStream;
        codes: Record "Code";
        Client: HttpClient;
        Response: HttpResponseMessage;
        Ic: Integer;
        iCount: Integer;
        dlg: Dialog;
    begin
        if not Client.Get(
        'https://directory.peppol.eu/export/participants-json',
        Response)
    then
            Error('Impossible de contacter le répertoire PEPPOL.');

        if not Response.IsSuccessStatusCode() then begin
            Error(
                'Erreur PEPPOL. Code HTTP : %1 - %2',
                Response.HttpStatusCode(),
                Response.ReasonPhrase());
        end
        else begin
            // Lecture du JSON directement dans un Text
            Response.Content().ReadAs(Tmp);

            Txt += Tmp;

            //MESSAGE(Txt);
            TmpJSon.ReadFromText(Txt);
            TmpJSon.Reset;
            TmpJSon.SetFilter(Path, 'Participants[*');
            Ic := 1;
            dlg.Open('@1@@@@@@@@@@@@@@@@@@@@@@');
            iCount := TmpJSon.Count;
            if TmpJSon.FindSet then
                repeat
                    codes.Reset;
                    codes.Init;
                    codes."Table No" := 18;
                    codes."Field No" := 60522;
                    codes.Code := TmpJSon.Value;
                    Txt := TmpJSon.Value.Replace(UpperCase('iso6523-actorid-upis::'), '');
                    codes.Description := CopyStr(Txt, 1, StrPos(Txt, ':') - 1);
                    codes.Description2 := CopyStr(Txt, StrLen(codes.Description) + 2, StrLen(Txt) - StrLen(codes.Description) - 1);
                    if codes.Insert then;
                    Ic += 1;
                    dlg.Update(1, Round(Ic / iCount * 10000, 1));

                until TmpJSon.Next = 0;
            dlg.Close;

            //MESSAGE(Txt);
        end;

    end;

    local procedure CheckCustomerOnPeppol(Cust: Record Customer)
    var
        Codes: Record "Code";
    begin

        if DelChr(Cust."Enterprise No.", '=', DelChr(Cust."Enterprise No.", '=', '0123456789')) <> '' then begin
            IsExistOnPeppol('0208', DelChr(Cust."Enterprise No.", '=', DelChr(Cust."Enterprise No.", '=', '0123456789')), Cust);
        end;
        if DelChr(Cust."VAT Registration No.", '=', DelChr(Cust."VAT Registration No.", '=', '0123456789')) <> '' then begin
            IsExistOnPeppol('9925', DelChr(Cust."VAT Registration No.", '=', DelChr(Cust."VAT Registration No.", '=', '0123456789')), Cust);
        end;
        if DelChr(Cust."VAT Registration No.", '=', DelChr(Cust."VAT Registration No.", '=', '0123456789')) <> '' then begin
            IsExistOnPeppol('9957', DelChr(Cust."VAT Registration No.", '=', DelChr(Cust."VAT Registration No.", '=', '0123456789')), Cust);
        end;
        if Cust.GLN <> '' then begin
            IsExistOnPeppol('0088', DelChr(Cust.GLN, '=', DelChr(Cust.GLN, '=', '0123456789')), Cust);
        end;
        //IF STRLEN(DELCHR(Cust.Siret,'=',DELCHR(Cust.Siret,'=','0123456789'))) >= 9  THEN
        //BEGIN
        //  IsExistOnPeppol('0002',COPYSTR(DELCHR(Cust.Siret,'=',DELCHR(Cust.Siret,'=','0123456789')),1,9),Cust);
        //END;
    end;

    local procedure IsExistOnPeppol(EAS: Code[10]; Id: Text[50]; Cust: Record Customer)
    var
        Codes: Record "Code";
    begin
        Codes.Reset;
        Codes.SetRange(Description, EAS);
        Codes.SetRange(Description2, Id);
        if Codes.FindFirst then begin
            Cust."EInvoice EAS" := Codes.Description;
            Cust.Validate("EInvoice Endpoint", Codes.Description2);
            Cust.Modify(false);
        end;
    end;

    [Scope('OnPrem')]
    procedure CheckAllCust()
    var
        Cust: Record Customer;
    begin
        Cust.Reset;
        if Cust.FindSet then
            repeat
                if Cust."EInvoice EAS" = '' then
                    CheckCustomerOnPeppol(Cust);
            until Cust.Next = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnAfterPostSalesDoc', '', false, false)]
    local procedure CU80_OnAfterPostSales(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean; InvtPickPutaway: Boolean)
    var
        JobQueueEntry: Record "Job Queue Entry";
        SalesInvH: Record "Sales Invoice Header";
        ParameterString: Text;
        SalesCrH: Record "Sales Cr.Memo Header";
        Cust: Record Customer;
    begin

        case SalesHeader."Document Type" of
            SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::Order:
                begin
                    SalesInvH.Reset;
                    if (SalesInvH.Get(SalesInvHdrNo)) then begin
                        Cust.Get(SalesInvH."Bill-to Customer No.");
                        if Cust."EInvoice EAS" <> '' then begin
                            JobQueueEntry.Init;
                            JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
                            JobQueueEntry."Object ID to Run" := CODEUNIT::"Einvoice Send";
                            JobQueueEntry."Job Queue Category Code" := 'SENDINV';
                            JobQueueEntry."Maximum No. of Attempts to Run" := 3;
                            JobQueueEntry."Rerun Delay (sec.)" := 180;
                            JobQueueEntry."Record ID to Process" := SalesInvH.RecordId;
                            JobQueueEntry."Earliest Start Date/Time" := CreateDateTime(Today, 230000T); //23h
                            JobQueueEntry."Parameter String" := SalesInvHdrNo;
                            JobQueueEntry.Description := 'EINVOICE ' + SalesInvHdrNo;
                            CODEUNIT.Run(CODEUNIT::"Job Queue - Enqueue", JobQueueEntry);
                        end;
                    end;
                end;
            SalesHeader."Document Type"::"Credit Memo":
                begin
                    SalesCrH.Reset;
                    if (SalesCrH.Get(SalesCrMemoHdrNo)) then begin
                        Cust.Get(SalesCrH."Bill-to Customer No.");
                        if Cust."EInvoice EAS" <> '' then begin
                            JobQueueEntry.Init;
                            JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
                            JobQueueEntry."Object ID to Run" := CODEUNIT::"Einvoice Send";
                            JobQueueEntry."Job Queue Category Code" := 'SENDINV';
                            JobQueueEntry."Maximum No. of Attempts to Run" := 3;
                            JobQueueEntry."Rerun Delay (sec.)" := 180;
                            JobQueueEntry."Record ID to Process" := SalesCrH.RecordId;
                            JobQueueEntry."Earliest Start Date/Time" := CreateDateTime(Today, 230000T); //23h
                            JobQueueEntry."Parameter String" := SalesCrMemoHdrNo;
                            JobQueueEntry.Description := 'EINVOICE ' + SalesCrMemoHdrNo;
                            CODEUNIT.Run(CODEUNIT::"Job Queue - Enqueue", JobQueueEntry);
                        end;
                    end;
                end;

        end;
    end;



    local procedure CheckBabelwayStatus()
    var
        Txt: Text;
        tmp: Text;
        TmpJSon: Record "JSON Buffer" temporary;
        HttpWebRequestMgt: Codeunit "Http Web Request Mgt.";
        Instr: InStream;
        codes: Record "Code";
        iCount: Integer;
        dlg: Dialog;
        JSon: Record "JSON Buffer";
        Client: HttpClient;
        Response: HttpResponseMessage;

    begin

        //String user = "Europacuisson";// the username you use to connect to Babelway
        //String pwd = "Eur.ccs!1"; // the password you use to connect to Babelway
        //String request = baseURL + "hub-" + myHub + "/messages.xml?status=ERROR";
        //String request = baseURL + "hub-" + myHub + "/messages.xml?status=DONE&type=REGULAR";
        if not Client.Get(
      'https://www.babelway.net/SelfService3/rest/v2/hub-42448/messages.json?start=0',
      Response)
          then
            Error('Impossible de contacter le répertoire PEPPOL.');

        if not Response.IsSuccessStatusCode() then begin
            Error(
                'Erreur PEPPOL. Code HTTP : %1 - %2',
                Response.HttpStatusCode(),
                Response.ReasonPhrase());
        end
        else begin
            // Lecture du JSON directement dans un Text
            Response.Content().ReadAs(Tmp);

            Txt += Tmp;


            TmpJSon.ReadFromText(Txt);
            TmpJSon.Reset;
            Txt := '';
            if TmpJSon.FindSet then
                repeat
                    JSon.Init;
                    JSon.TransferFields(TmpJSon, true);
                    JSon.Insert;
                    Txt += TmpJSon.Path + ';' + TmpJSon.Value + '%';
                until TmpJSon.Next = 0;
            Message(Txt);

        end;
    end;

    local procedure TreatResponse(FilePath: Text)
    var
        xml: Record "XML Buffer" temporary;
        comp: Record "Company Information";
        SalesH: Record "Sales Invoice Header";
        tmp: Text;
        Logs: Record "Peppol Logs";
    begin
        comp.Get;
        xml.Load(FilePath);

        xml.Reset;
        xml.SetFilter(Path, '/ApplicationResponse/*:ReceiverParty/*:EndpointID');
        if not xml.FindFirst then Error('No endpoint');
        if StrPos(xml.Value, DelChr(comp."VAT Registration No.", '=', DelChr(comp."VAT Registration No.", '=', '0123456789'))) > 0 then begin
            xml.SetFilter(Path, '/ApplicationResponse/*:DocumentResponse/*:DocumentReference/*:ID');
            if xml.FindFirst then begin
                if SalesH.Get(xml.Value) then begin
                    xml.SetFilter(Path, '/ApplicationResponse/*:IssueDate');
                    if xml.FindFirst then begin
                        tmp := xml.Value;
                        xml.SetFilter(Path, '/ApplicationResponse/*:IssueTime');
                        if xml.FindFirst then tmp := DelChr(tmp + ' ' + xml.Value, '=', 'Z');
                        ;
                        Evaluate(SalesH.Peppol_ResponseDt, tmp);
                    end;
                    xml.SetFilter(Path, '/ApplicationResponse/*:DocumentResponse/*:Response/*:ResponseCode');
                    if xml.FindFirst then SalesH.Peppol_ResponseCode := xml.Value;
                    xml.SetFilter(Path, '/ApplicationResponse/*:DocumentResponse/*:Response/*:Status/*:StatusReasonCode');
                    if xml.FindFirst then SalesH.Peppol_ResponseReasonCode := xml.Value;
                    xml.SetFilter(Path, '/ApplicationResponse/*:DocumentResponse/*:Response/*:Status/*:StatusReason');
                    if xml.FindFirst then SalesH.Peppol_ResponseReason := xml.Value;
                    SalesH.Modify;
                    Logs.Reset;
                    Logs.Init;
                    xml.SetFilter(Path, '/ApplicationResponse/*:ID');
                    if xml.FindFirst then Logs.ID := xml.Value;
                    Logs.Dt := SalesH.Peppol_ResponseDt;
                    Logs.Type := Logs.Type::Response;
                    Logs.Result_Code := SalesH.Peppol_ResponseCode;
                    Logs.ReasonCode := SalesH.Peppol_ResponseReasonCode;
                    Logs.Message := SalesH.Peppol_ResponseReason;
                    Logs.Company := CompanyName;
                    Logs.NoDoc := SalesH."No.";
                    if not Logs.Insert(true) then Logs.Modify;
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 50021, 'OnAfterInsertEvent', '', false, false)]
    local procedure OnLogsInserted(var Rec: Record "Peppol Logs"; RunTrigger: Boolean)
    var
        emailmsg: Codeunit "Email Message";
        emailsend: Codeunit Email;
    begin

        if not (Rec.Result_Code in ['AB', 'IP', 'OK', 'AP', 'NON']) then begin
            emailmsg.Create('g.dangremont@europacuisson.com', 'Statut recu ' + Rec.ReasonCode + '  ' + CompanyName, Rec.ID, true);
            emailsend.Send(emailmsg, Enum::"Email Scenario"::Default);
        end;
    end;

    procedure GetTotalsEC(SalesLine: Record "Sales Line"; var VATAmtLine: Record "VAT Amount Line")
    var
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        //Copy CU1605_GetOtalt
        if not VATPostingSetup.Get(SalesLine."VAT Bus. Posting Group", SalesLine."VAT Prod. Posting Group") then
            VATPostingSetup.Init;
        with VATAmtLine do begin
            Init;
            "VAT Identifier" := VATPostingSetup."VAT Identifier";
            "VAT Calculation Type" := SalesLine."VAT Calculation Type";
            "Tax Group Code" := SalesLine."Tax Group Code";
            "Tax Category" := VATPostingSetup."Tax Category";
            "VAT %" := SalesLine."VAT %";
            "VAT Base" := SalesLine.Amount;
            "Amount Including VAT" := SalesLine."Amount Including VAT";
            if SalesLine."Allow Invoice Disc." then
                "Inv. Disc. Base Amount" := SalesLine."Line Amount";
            "Invoice Discount Amount" := SalesLine."Inv. Discount Amount";

            //
            "VAT Identifier" := Format(VATAmtLine."VAT %");
            "VAT Clause Code" := SalesLine."VAT Clause Code";
            //

            //if InsertLineEC then begin
            "Line Amount" += SalesLine."Line Amount";
            Modify;
            //end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 23, 'OnAfterValidateEvent', 'Ignorer le mappage de texte', false, false)]
    local procedure VendorIgnoreMapping(var Rec: Record Vendor; var xRec: Record Vendor; CurrFieldNo: Integer)
    begin
        UpdIgnoreMapping(Rec);
    end;

    [EventSubscriber(ObjectType::Table, 130, 'OnAfterValidateEvent', 'Vendor No.', false, false)]
    local procedure T189_VendorNo(var Rec: Record "Incoming Document"; var xRec: Record "Incoming Document"; CurrFieldNo: Integer)
    var
        Vend: Record Vendor;
    begin
        if Vend.Get(Rec."Vendor No.") then
            UpdIgnoreMapping(Vend);

        if Rec."OCR Track ID" = 'TMPPDF' then
            if Vend.Get(Rec."Vendor No.") then begin
                Vend."Ignorer le mappage de texte" := true;
                UpdIgnoreMapping(Vend);
            end;
    end;

    local procedure UpdIgnoreMapping(Rec: Record Vendor)
    var
        Txt: Record "Text-to-Account Mapping";
        GLAcc: Record "G/L Account";
        NextL: Integer;
    begin
        if Rec."Ignorer le mappage de texte" then begin
            Txt.Reset;
            Txt.SetRange("Vendor No.", Rec."No.");
            Txt.SetRange("Mapping Text", '');
            if Txt.FindFirst then
                Txt.Delete;
            Txt.Reset;
            if Txt.FindLast then
                NextL := Txt."Line No." + 1
            else
                NextL := 1;

            GLAcc.Reset;
            GLAcc.SetFilter("No.", '7*');
            GLAcc.SetRange("Direct Posting", true);
            GLAcc.SetRange("Account Type", GLAcc."Account Type"::Posting);
            GLAcc.FindFirst;
            Txt.Reset;
            Txt.Init;
            Txt."Line No." := NextL;
            Txt."Mapping Text" := '';
            Txt."Debit Acc. No." := GLAcc."No.";
            Txt."Credit Acc. No." := GLAcc."No.";
            Txt."Vendor No." := Rec."No.";
            Txt.Insert();
        end
        else begin
            Txt.Reset;
            Txt.SetRange("Vendor No.", Rec."No.");
            Txt.SetRange("Mapping Text", '');
            if Txt.FindFirst then
                Txt.Delete;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 132, 'OnAfterCreateDocFromIncomingDocSuccess', '', false, false)]
    local procedure Cu132_OnAfterCreateDocFromIncomingDocSuccess(var IncomingDocument: Record "Incoming Document")
    var
        Vendor: Record Vendor;
        PurchL: Record "Purchase Line";
        PurchH: Record "Purchase Header";
        ReceiptL: Record "Purch. Rcpt. Line";
        GetReceipts: Codeunit "Purch.-Get Receipt";
        PurchLR: Record "Purchase Line";
    begin
        PurchH.Reset;
        PurchH.SetRange("No.", IncomingDocument."Document No.");
        if PurchH.FindFirst then begin
            Vendor.Get(PurchH."Buy-from Vendor No.");
            if Vendor."Ignorer le mappage de texte" then begin
                PurchL.Reset;
                PurchL.SetRange("Document Type", PurchH."Document Type");
                PurchL.SetRange("Document No.", PurchH."No.");
                PurchL.SetRange("Receipt Line No.", 0);
                if PurchL.FindSet then
                    repeat
                        ReceiptL.Reset; // 1 sur base du n° de cmd indiqué sur les lignes
                        ReceiptL.SetRange("Order No.", PurchL."Transport Comment");
                        ReceiptL.SetRange("Buy-from Vendor No.", PurchH."Buy-from Vendor No.");
                        ReceiptL.SetRange("Quantity (Base)", PurchL."Quantity (Base)");
                        ReceiptL.SetRange("Vendor Item No.", PurchL."Vendor Item No.");
                        if PurchL."Transport Comment" <> '' then begin   // Sur base de la ref fournisseur
                            if not ReceiptL.FindFirst then begin  // ou sur base de la description
                                ReceiptL.SetRange("Vendor Item No.");
                                ReceiptL.SetFilter(Description, '*' + Utils.Replace(Utils.Replace(PurchL.Description, '(', '*'), ')', '*') + '*');
                            end;
                        end;

                        if not ReceiptL.FindFirst then begin
                            ReceiptL.Reset;   // 2 sur base du n° de cmd indiqué dans le header
                            ReceiptL.SetRange("Order No.", PurchH."Vendor Order No.");
                            ReceiptL.SetRange("Buy-from Vendor No.", PurchH."Buy-from Vendor No.");
                            ReceiptL.SetRange("Quantity (Base)", PurchL."Quantity (Base)");
                            ReceiptL.SetRange("Vendor Item No.", PurchL."Vendor Item No.");
                            if not ReceiptL.FindFirst then  // Sur base de la ref fournisseur
                            begin    // ou sur base de la description
                                ReceiptL.SetRange("Vendor Item No.");
                                ReceiptL.SetFilter(Description, '*' + Utils.Replace(Utils.Replace(PurchL.Description, '(', '*'), ')', '*') + '*');
                            end;
                        end;

                        if ReceiptL.FindFirst then begin
                            GetReceipts.SetPurchHeader(PurchH);
                            GetReceipts.CreateInvLines(ReceiptL);
                            PurchLR.Reset;
                            PurchLR.SetRange("Document Type", PurchH."Document Type");
                            PurchLR.SetRange("Document No.", PurchH."No.");
                            PurchLR.SetRange("Receipt Line No.", ReceiptL."Line No.");
                            PurchLR.SetRange("Receipt No.", ReceiptL."Document No.");
                            if PurchLR.FindSet then begin
                                PurchLR."Unit Cost" := PurchL."Direct Unit Cost";
                                PurchLR.Modify;
                            end;
                        end;
                        PurchL.Delete;
                    until PurchL.Next = 0;
                //PurchL.RESET;
                //PurchL.SETRANGE("Document Type",PurchH."Document Type");
                //PurchL.SETRANGE("Document No.",PurchH."No.");
                //PurchL.DELETEALL();
            end;

            SavePeppolAttachedFilesToInvoice(IncomingDocument, PurchH);
        end;
    end;

    local procedure SavePeppolAttachedFilesToInvoice(IncomingDocument: Record "Incoming Document"; PuchH: Record "Purchase Header")
    var
        AttachDoc: Record "Document Attachment";
        T133: Record "Incoming Document Attachment";
        T130: Record "Incoming Document";
        XPath: Text;
        ImportXMLFileToDataExch: Codeunit "Import XML File to Data Exch.";
        RecRef: RecordRef;
        FieldRef: FieldRef;
        XMLDOMManagement: Codeunit "XML DOM Management";
        XMLRootNode: XmlNode;
        XmlValue: Text;
        InStream: InStream;
        OutStr: OutStream;
        XMLNode: XmlNode;
        XMLNodeList: XmlNodeList;
        FileName: Text;
        Mime: Text;
        FileMgt: Codeunit "File Management";
        i: Integer;
        XMLDoc: XmlDocument;
        XMLText: text;
        TempBlob: Codeunit "Temp Blob";
        Base64Convert: Codeunit "Base64 Convert";
        HttpClient: HttpClient;
        HttpResponse: HttpResponseMessage;
        HttpContent: HttpContent;
        OutStream: OutStream;
        InStr: InStream;
    begin
        T133.Reset;
        T133.SetRange("Incoming Document Entry No.", IncomingDocument."Entry No.");
        T133.SetRange(Default, true);
        if not T133.FindFirst then exit;
        T133.CalcFields(Content);
        if IncomingDocument."Data Exchange Type" = 'PEPPOLCR' then
            XPath := '/CreditNote/cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject'
        else
            XPath := '/Invoice/cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject';
        XPath := ImportXMLFileToDataExch.EscapeMissingNamespacePrefix(XPath);

        T133.CalcFields(Content);
        T133.Content.CreateInStream(InStream);
        InStream.ReadText(XMLText);

        if not XmlDocument.ReadFrom(XMLText, XMLDoc) then
            exit;

        XMLRootNode := XMLDoc.AsXmlNode();

        XMLRootNode.SelectNodes(XPath, XMLNodeList);
        for i := 1 to XMLNodeList.Count do begin
            XMLNodeList.Get(i, XMLNode);
            XmlValue := XMLNode.AsXmlElement().InnerText();
            FileName := 'Peppol' + Format(i + 1);
            Mime := XMLDOMManagement.GetAttributeValue(XMLNode, 'mimeCode');
            case Mime of
                'application/pdf':
                    FileName := FileName + '.pdf';
                else
                    Error('Format non supporté : ' + Mime);
            end;
            TempBlob.CreateOutStream(OutStr);
            Base64Convert.FromBase64(XmlValue, OutStr);

            AttachDoc.Reset();
            AttachDoc.Init();
            AttachDoc."Line No." := i + 1;

            RecRef.Open(Database::"Purchase Header");
            RecRef.GetTable(PuchH);

            // Enregistrer la pièce jointe
            TempBlob.CreateInStream(InStr);
            AttachDoc.SaveAttachmentFromStream(
                InStr,
                RecRef,
                FileName);
        end;
    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnBeforeUpdateLineDiscPct', '', false, false)]
    local procedure T39_OnBeforeUpdateLineDiscPct(var PurchaseLine: Record "Purchase Line"; Currency: Record Currency; var IsHandled: Boolean)
    begin
        if PurchaseLine."Line Discount Amount" = -0.01 then PurchaseLine."Line Discount Amount" := 0;
        if PurchaseLine."Line Discount Amount" < -0.01 then begin
            PurchaseLine."Direct Unit Cost" -= (PurchaseLine."Line Discount Amount" / PurchaseLine.Quantity);
            PurchaseLine."Line Discount Amount" := 0;
        end;
    end;

    [Scope('OnPrem')]
    procedure GetSimulatedPDF(IncomingDocument: Record "Incoming Document")
    var
        DataExch: Record "Data Exch.";
        DataExchDef: Record "Data Exch. Def";
        DataExchangeType: Record "Data Exchange Type";
        PurchH: Record "Purchase Header";
        FileMgmt: Codeunit "File Management";
        Path: Text;
    begin
        if (IncomingDocument."Document No." = '') then begin
            DataExch.Init;
            DataExchangeType.Get(IncomingDocument."Data Exchange Type");
            DataExchDef.Get(DataExchangeType."Data Exch. Def. Code");

            if not SetSourceForDataExch(IncomingDocument, DataExch, DataExchDef) then;


            DataExch."Related Record" := IncomingDocument.RecordId;
            IncomingDocument."OCR Track ID" := 'TMPPDF';
            IncomingDocument.Modify;


            if not DataExch.ImportToDataExch(DataExchDef) then;

            DataExchDef.ProcessDataExchange(DataExch);
            RollbackIfErrors(IncomingDocument);
        end;

        PurchH.Reset;
        PurchH.SetRange("Incoming Document Entry No.", IncomingDocument."Entry No.");
        if PurchH.FindFirst then begin
            //MESSAGE(PurchH."No.");
            Path := FileMgmt.ServerTempFileName('.pdf');
            REPORT.SaveAsPdf(50092, Path, PurchH);
            FileMgmt.DownloadTempFile(Path);
            Error('');
        end;
    end;

    [Scope('OnPrem')]
    procedure SetSourceForDataExch(IncomingDocument: Record "Incoming Document"; var DataExch: Record "Data Exch."; DataExchDef: Record "Data Exch. Def"): Boolean
    var
        IncomingDocumentAttachment: Record "Incoming Document Attachment";
        Stream: InStream;
    begin
        if DataExchDef."Ext. Data Handling Codeunit" <> 0 then begin
            DataExch."Related Record" := IncomingDocument.RecordId;
            exit(DataExch.ImportFileContent(DataExchDef))
        end;

        // if no external data handling, use the attachments
        IncomingDocumentAttachment.SetRange("Incoming Document Entry No.", IncomingDocument."Entry No.");
        IncomingDocumentAttachment.SetRange(Default, true);
        if not IncomingDocumentAttachment.FindFirst then;


        IncomingDocumentAttachment.CalcFields(Content);
        if not IncomingDocumentAttachment.Content.HasValue then;


        IncomingDocumentAttachment.Content.CreateInStream(Stream);
        DataExch.InsertRec(IncomingDocumentAttachment.Name, Stream, DataExchDef.Code);
        DataExch.Validate("Incoming Entry No.", IncomingDocument."Entry No.");
        DataExch.Modify(true);

        exit(true);
    end;

    local procedure RollbackIfErrors(var IncomingDocument: Record "Incoming Document")
    var
        ErrorMessage: Record "Error Message";
        TempErrorMessage: Record "Error Message" temporary;
    begin
        ErrorMessage.SetContext(IncomingDocument);
        if not ErrorMessage.HasErrors(false) then
            exit;

        // rollback if processing errors - preserve the errors
        ErrorMessage.SetRange("Context Record ID", IncomingDocument.RecordId);
        ErrorMessage.CopyToTemp(TempErrorMessage);
        IncomingDocument.SaveErrorMessages(TempErrorMessage);
    end;
}

