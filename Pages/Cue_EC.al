page 50195 AllCueEC
{
    PageType = CardPart;

    Caption = 'A approuver';
    layout
    {
        area(Content)
        {
            cuegroup(GroupNameEC)
            {

                Caption = 'Tâches à effectuer';
                field("Requests to Approve"; "CountRequest to approve")
                {
                    Caption = 'Factures achats à approuver';
                    Style = Unfavorable;
                    StyleExpr = ("CountRequest to approve") > 0;
                    Image = "None";
                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"Requests to Approve");
                    end;
                }
                field("CountPurchInvApproved"; "CountPurchInvApproved")
                {
                    Caption = 'Factures achats approuvées';
                    Visible = showFact;
                    trigger OnDrillDown()
                    begin
                        PurchH.RESET;
                        PurchH.SetRange("Document Type", PurchH."Document Type"::Invoice);
                        PurchH.SetRange(Status, PurchH.Status::Released);
                        if PurchH.FindFirst() then
                            Page.Run(Page::"Purchase Invoices", PurchH);

                    end;
                }
            }
        }
    }

    var
        "CountRequest to approve": Integer;
        ApprovalEntry: record "Approval Entry";
        CountPurchInvApproved: Integer;
        PurchH: record "Purchase Header";
        cuUtils: codeunit Utils;
        showFact: Boolean;

    trigger OnOpenPage()
    begin
        "CountRequest to approve" := 0;
        ApprovalEntry.RESET;
        ApprovalEntry.SetRange("Approver ID", USERID);
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
        "CountRequest to approve" := ApprovalEntry.COUNT();
        PurchH.RESET;
        Purchh.SetRange("Document Type", PurchH."Document Type"::Invoice);
        PurchH.SetRange(Status, PurchH.Status::Released);
        CountPurchInvApproved := PurchH.Count;
        showFact := cuUtils.IsInGroup('COMPTA-USER');
    end;

}