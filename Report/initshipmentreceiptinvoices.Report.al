report 50018 "init shipment/receipt invoices"
{
    // //AB60408.V15 EBE 16/04/08
    //   - initialisation de la table invoice shipment
    // 
    // //AB60408.A1 EBE 17/04/08
    //   - initialisation de la table invoice receipt

    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.");
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.");

                trigger OnAfterGetRecord()
                begin

                    SalesShipLine.Reset;
                    SalesShipLine.SetRange("Document No.", SalesShipHeader."No.");
                    SalesShipLine.SetRange(Type, Type);
                    SalesShipLine.SetRange("No.", "No.");
                    if not SalesShipLine.Find('-') then
                        CurrReport.Skip;

                    ShipmentInvoiced.Reset;
                    ShipmentInvoiced.SetRange("Invoice No.", "Document No.");
                    ShipmentInvoiced.SetRange("Invoice Line No.", "Line No.");
                    if not ShipmentInvoiced.Find('-') then;


                    //AB60408.V15 Insert Shipment Invoiced
                    ShipmentInvoiced.Init;
                    ShipmentInvoiced."Invoice No." := "Document No.";
                    ShipmentInvoiced."Shipment No." := SalesShipLine."Document No.";
                    ShipmentInvoiced."Shipment Line No." := SalesShipLine."Line No.";
                    ShipmentInvoiced."Invoice Line No." := "Line No.";
                    ShipmentInvoiced."Qty. to Invoice" := SalesShipLine."Quantity Invoiced";
                    ShipmentInvoiced."Qty. to Ship" := SalesShipLine.Quantity;
                    ShipmentInvoiced."Posting Date" := "Sales Invoice Header"."Posting Date";
                    ShipmentInvoiced."User ID" := UserId;

                    ShipmentInvoiced.Type := SalesShipLine.Type.AsInteger();
                    ShipmentInvoiced."No." := SalesShipLine."No.";
                    ShipmentInvoiced."Location Code" := SalesShipLine."Location Code";
                    ShipmentInvoiced.Description := SalesShipLine.Description;
                    ShipmentInvoiced."Order No." := SalesShipHeader."Order No.";
                    ShipmentInvoiced."Sell-to Customer No." := SalesShipHeader."Sell-to Customer No.";
                    ShipmentInvoiced."Sell-to Customer Name" := SalesShipHeader."Sell-to Customer Name";
                    ShipmentInvoiced."Customer Order No." := SalesShipHeader."Order No.";
                    ShipmentInvoiced."Qty. Shipped Not Invoiced" := SalesShipLine."Qty. Shipped Not Invoiced";
                    ShipmentInvoiced."Quantity Invoiced" := SalesShipLine."Quantity Invoiced";
                    ShipmentInvoiced."Shipment Posting Date" := SalesShipHeader."Posting Date";

                    if not ShipmentInvoiced.Insert then
                        ShipmentInvoiced.Modify;
                end;
            }

            trigger OnAfterGetRecord()
            begin

                if "Order No." = '' then
                    CurrReport.Skip;

                SalesShipHeader.Reset;
                SalesShipHeader.SetRange("Order No.", "Order No.");
                if not SalesShipHeader.Find('-') then
                    CurrReport.Skip;

                //Init receipt only  :
                CurrReport.Skip;
            end;
        }
        dataitem("Purch. Inv. Header"; "Purch. Inv. Header")
        {
            DataItemTableView = SORTING("No.");
            dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.");

                trigger OnAfterGetRecord()
                begin

                    PurchRcptLine.Reset;
                    PurchRcptLine.SetRange("Document No.", PurchRcptHeader."No.");
                    PurchRcptLine.SetRange(Type, Type);
                    PurchRcptLine.SetRange("No.", "No.");
                    if not PurchRcptLine.Find('-') then
                        CurrReport.Skip;

                    ReceiptInvoiced.Reset;
                    ReceiptInvoiced.SetRange("Invoice No.", "Document No.");
                    ReceiptInvoiced.SetRange("Invoice Line No.", "Line No.");
                    if not ReceiptInvoiced.Find('-') then;


                    //AB60408.A1 Insert Receipt Invoiced
                    ReceiptInvoiced.Init;
                    ReceiptInvoiced."Invoice No." := "Document No.";
                    ReceiptInvoiced."Receipt No." := PurchRcptLine."Document No.";
                    ReceiptInvoiced."Receipt Line No." := PurchRcptLine."Line No.";
                    ReceiptInvoiced."Invoice Line No." := "Line No.";
                    ReceiptInvoiced."Qty. to Invoice" := Quantity;
                    ReceiptInvoiced."Qty. to Receive" := PurchRcptLine.Quantity;
                    ReceiptInvoiced."Posting Date" := "Purch. Inv. Header"."Posting Date";
                    ReceiptInvoiced."User ID" := UserId;

                    ReceiptInvoiced.Type := PurchRcptLine.Type.AsInteger();
                    ReceiptInvoiced."No." := PurchRcptLine."No.";
                    ReceiptInvoiced."Location Code" := PurchRcptLine."Location Code";
                    ReceiptInvoiced.Description := PurchRcptLine.Description;
                    ReceiptInvoiced."Order No." := PurchRcptHeader."Order No.";
                    ReceiptInvoiced."Buy-from Vendor No." := PurchRcptHeader."Buy-from Vendor No.";
                    ReceiptInvoiced."Buy-from Vendor Name" := PurchRcptHeader."Buy-from Vendor Name";
                    ReceiptInvoiced."Vendor Order No." := PurchRcptHeader."Vendor Order No.";
                    ReceiptInvoiced."Vendor Invoice No." := "Purch. Inv. Header"."Vendor Invoice No.";
                    ReceiptInvoiced."Qty. Received Not Invoiced" := PurchRcptLine."Qty. Rcd. Not Invoiced";
                    ReceiptInvoiced."Quantity Invoiced" := PurchRcptLine."Quantity Invoiced";
                    ReceiptInvoiced."Receipt Posting Date" := PurchRcptHeader."Posting Date";

                    if not ReceiptInvoiced.Insert then
                        ReceiptInvoiced.Modify;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if "Order No." = '' then
                    CurrReport.Skip;

                PurchRcptHeader.Reset;
                PurchRcptHeader.SetRange("Order No.", "Order No.");
                if not PurchRcptHeader.Find('-') then
                    CurrReport.Skip;

                //Init receipt only  : with //
                //CurrReport.SKIP;
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
        SalesShipHeader: Record "Sales Shipment Header";
        SalesShipLine: Record "Sales Shipment Line";
        ShipmentInvoiced: Record "Shipment Invoiced";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        ReceiptInvoiced: Record "Receipt Invoiced";
}

