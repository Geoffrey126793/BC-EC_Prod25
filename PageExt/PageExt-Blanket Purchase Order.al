pageextension 70126 pageextension70126 extends "Blanket Purchase Order"
{
    actions
    {
        addafter(Print)
        {
            action(Send)
            {
                Caption = 'Envoyer E-Mail';
                Promoted = true;

                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                    ReportSelections: Record "Report Selections";
                begin
                    PurchaseHeader := Rec;
                    CurrPage.SetSelectionFilter(PurchaseHeader);
                    //PurchaseHeader.SendRecords;
                    ReportSelections.SendEmailToVendor(ReportSelections.Usage::"P.Blanket".AsInteger(), PurchaseHeader, PurchaseHeader."No.", 'Commande', true, PurchaseHeader."Buy-from Vendor No.");
                end;
            }
        }
    }
}

