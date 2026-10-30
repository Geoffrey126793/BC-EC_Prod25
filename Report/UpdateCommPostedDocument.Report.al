report 8001504 "Update Comm. Posted Document"
{
    // //+RFA+ GESWAY 11/07/02 Calcul des commissions sur les documents enregistrés

    Caption = 'Update Posted Commission Document';
    ProcessingOnly = true;

    dataset
    {
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
        SalesInvLine: Record "Sales Invoice Line";
        PurchInvLine: Record "Purch. Inv. Line";
        CalcPostDocCom: Codeunit "Calculate Posted Document Com.";

    [Scope('OnPrem')]
    procedure CalcSalesInvoiceDiscount(SalesInvHeader: Record "Sales Invoice Header")
    var
        SalesInvLine2: Record "Sales Invoice Line";
        PostSalesDiscEntry: Record "Posted Sales Discount Entry";
        Discount: Decimal;
    begin
        SalesInvLine2.Reset;
        SalesInvLine2.SetRange("Document No.", SalesInvHeader."No.");
        SalesInvLine2.SetFilter(Quantity, '<>0');
        if SalesInvLine2.Find('-') then begin
            repeat
                CalcPostDocCom.RemiseLigneVente(SalesInvLine2);
            until SalesInvLine2.Next = 0;
        end;
    end;

    [Scope('OnPrem')]
    procedure CalPurchInvoiceDiscount(PurchInvHeader: Record "Purch. Inv. Header")
    var
        PurchInvLine: Record "Purch. Inv. Line";
        Discount: Decimal;
    begin
        PurchInvLine.Reset;
        PurchInvLine.SetRange("Document No.", PurchInvHeader."No.");
        PurchInvLine.SetFilter(Quantity, '<>0');
        if PurchInvLine.Find('-') then begin
            repeat
                CalcPostDocCom.RemiseLigneAchat(PurchInvLine);
            until PurchInvLine.Next = 0;
        end;
    end;
}

