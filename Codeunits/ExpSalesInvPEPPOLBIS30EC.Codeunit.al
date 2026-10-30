codeunit 50055 "Exp. Sales Inv. PEPPOLBIS3.0EC"
{
    TableNo = "Record Export Buffer";

    trigger OnRun()
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        PEPPOLValidation: Codeunit "PEPPOL Validation";
        RecordRef: RecordRef;
        OutStr: OutStream;
    begin
        RecordRef.Get(Rec.RecordID);
        RecordRef.SetTable(SalesCrMemoHeader);

        PEPPOLValidation.CheckSalesCreditMemo(SalesCrMemoHeader);

        Rec."File Content".CreateOutStream(OutStr);
        GenerateXMLFile(SalesCrMemoHeader, OutStr);

        Rec.Modify();
    end;

    [Scope('OnPrem')]
    procedure GenerateXMLFile(VariantRec: Variant; var OutStr: OutStream)
    var
        SalesCrMemoPEPPOLBIS30: XMLport "Sales Invoice - PEPPOLBIS3.0EC";
    begin
        SalesCrMemoPEPPOLBIS30.Initialize(VariantRec);
        SalesCrMemoPEPPOLBIS30.SetDestination(OutStr);
        SalesCrMemoPEPPOLBIS30.Export();
    end;

    [Scope('OnPrem')]
    procedure GenerateXMLFile(VariantRec: Variant): Text[250]
    var
        PEPPOLManagement: Codeunit "PEPPOL Management";
        SalesInvoicePEPPOLBIS30: XMLport "Sales Invoice - PEPPOLBIS3.0EC";
        OutFile: File;
        OutStream: OutStream;
        XmlServerPath: Text;
    begin
        PEPPOLManagement.InitializeXMLExport(OutFile, XmlServerPath);

        OutFile.CreateOutStream(OutStream);
        SalesInvoicePEPPOLBIS30.Initialize(VariantRec);
        SalesInvoicePEPPOLBIS30.SetDestination(OutStream);
        SalesInvoicePEPPOLBIS30.Export;
        OutFile.Close;

        exit(CopyStr(XmlServerPath, 1, 250));
    end;
}

