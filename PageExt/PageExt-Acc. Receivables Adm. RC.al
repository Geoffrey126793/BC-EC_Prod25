pageextension 70238 pageextension70238 extends "Acc. Receivables Adm. RC"
{
    layout
    {
        addfirst(rolecenter)
        {
            part(AllEC; AllCueEC)
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {

        modify("Sales &Credit Memo")
        {
            Visible = false;
        }

        addafter("Sales Orders")
        {
            action("Avoirs ventes")
            {
                RunObject = Page "Sales Credit Memos";
            }
            action(Retours)
            {
                Caption = 'Retours';
                RunObject = Page "Sales Return Order List";
            }
            action(Articles)
            {
                Caption = 'Articles';
                RunObject = Page "Item List";
            }
            action(Transport)
            {
                Caption = 'Transport';
                RunObject = Page Transport;
            }
            action("<Action1000000006>")
            {
                Caption = 'Lignes factures ventes';
                RunObject = Page "Posted Sales Invoice Lines";
            }
        }

        moveafter("&Sales"; "Sales &Invoice")
    }
}

