pageextension 70028 pageextension70028 extends "Posted Purchase Receipt"
{
    actions
    {
        addafter(Approvals)
        {
            action("Réception palettes")
            {
                Caption = 'Réception palettes';

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(PurchRcptHeader);
                    REPORT.Run(50032, true, true, PurchRcptHeader);
                end;
            }
        }
        addafter("&Print")
        {
            action(Action1000000001)
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Imprimer';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Category5;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(PurchRcptHeader);
                    REPORT.Run(50064, true, true, PurchRcptHeader);
                end;
            }
        }
    }
    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";

}

