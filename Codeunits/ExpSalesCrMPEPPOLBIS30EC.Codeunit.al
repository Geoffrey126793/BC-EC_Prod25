codeunit 50056 "Exp. Sales CrM. PEPPOLBIS3.0EC"
{
    TableNo = "Record Export Buffer";

    trigger OnRun()
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        PEPPOLValidation: Codeunit "PEPPOL Validation";
        RecordRef: RecordRef;
        OutStr: OutStream;
    begin
        RecordRef.Get(Rec.RecordID);
        RecordRef.SetTable(SalesInvoiceHeader);

        PEPPOLValidation.CheckSalesInvoice(SalesInvoiceHeader);

        Rec."File Content".CreateOutStream(OutStr);
        GenerateXMLFile(SalesInvoiceHeader, OutStr);

        Rec.Modify();
    end;

    [Scope('OnPrem')]
    procedure GenerateXMLFile(VariantRec: Variant; var OutStr: OutStream)
    var
        SalesInvoicePEPPOLBIS30: XMLport "Sales Cr.Memo - PEPPOLBIS3.0EC";
    begin
        SalesInvoicePEPPOLBIS30.Initialize(VariantRec);
        SalesInvoicePEPPOLBIS30.SetDestination(OutStr);
        SalesInvoicePEPPOLBIS30.Export();
    end;

    [Scope('OnPrem')]
    procedure GenerateXMLFile(VariantRec: Variant): Text[250]
    var
        PEPPOLManagement: Codeunit "PEPPOL Management";
        SalesCrMemoPEPPOLBIS30: XMLport "Sales Cr.Memo - PEPPOLBIS3.0EC";
        OutFile: File;
        OutStream: OutStream;
        XmlServerPath: Text;
    begin
        PEPPOLManagement.InitializeXMLExport(OutFile, XmlServerPath);

        OutFile.CreateOutStream(OutStream);
        SalesCrMemoPEPPOLBIS30.Initialize(VariantRec);
        SalesCrMemoPEPPOLBIS30.SetDestination(OutStream);
        SalesCrMemoPEPPOLBIS30.Export;
        OutFile.Close;

        exit(CopyStr(XmlServerPath, 1, 250));
    end;
}

