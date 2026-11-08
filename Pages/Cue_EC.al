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
            }
        }
    }

    var
        "CountRequest to approve": Integer;
        ApprovalEntry: record "Approval Entry";
        CueStyle: Text;

    trigger OnOpenPage()
    begin
        "CountRequest to approve" := 0;
        ApprovalEntry.RESET;
        ApprovalEntry.SetRange("Approver ID", USERID);
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
        "CountRequest to approve" := ApprovalEntry.COUNT();

    end;

}