pageextension 70302 pageextension70302 extends "Released Production Order"
{
    layout
    {

        modify("Location Code")
        {
            Importance = Promoted;
        }
        modify("Blocked")
        {
            Visible = false;
        }
        addafter(Quantity)
        {
            field("Quantité MP"; "Quantité MP")
            {
            }
        }

        addafter("Last Date Modified")
        {
            field("Production BOM Version"; "Production BOM Version")
            {
                Caption = 'Version';
            }
            field(Machine; Machine)
            {
            }
            field("No Ordre"; "No Ordre")
            {
            }
            field(Ordre; Ordre)
            {
            }
            field("Nbre malaxage"; "Nbre malaxage")
            {
            }
            field("No malaxage"; "No malaxage")
            {
            }
            field(Emplacement; Emplacement)
            {
            }
            field(Confirmed; Confirmed)
            {
            }
            field(Recyclage; Recyclage)
            {
            }
        }
        moveafter("Production BOM Version"; "Location Code")

        addafter(Posting)
        {
            group(Control1000000007)
            {
                Caption = 'Heures';
                part(Control1000000015; "Heures ABC")
                {
                    SubPageLink = "Production No" = FIELD("No.");
                    SubPageView = WHERE("Operateurs prevu" = FILTER(> 0),
                                        Imputation = CONST(Direct));
                }
            }
        }
        addafter(Control1905767507)
        {
            part(Control1000000002; "Logs OF Part")
            {
                Caption = 'Logs';
                SubPageLink = OF = FIELD("No.");
            }
            part(Control1000000012; "ProdOrderCommentListPart")
            {
                SubPageLink = Status = FIELD(Status),
                              "Prod. Order No." = FIELD("No.");
            }
        }
    }
    actions
    {
        addafter("Change &Status_Promoted")
        {
            actionref("Actualiser O.F.Promoted"; "Actualiser O.F.")
            {

            }
            actionref("Item Ledger E&ntries_Promoted"; "Item Ledger E&ntries")
            {
            }
        }
        modify("Create Inventor&y Put-away/Pick/Movement_Promoted")
        {
            visible = false;
        }
        modify("Create Warehouse Pick_Promoted")
        {
            visible = false;
        }
        modify("&Update Unit Cost_Promoted")
        {
            Visible = false;
        }
        modify("Re&plan_Promoted")
        {
            Visible = false;
        }


        modify(RefreshProductionOrder)
        {
            Visible = false;
        }
        addafter(RefreshProductionOrder)
        {
            action("Actualiser O.F.")
            {

                Image = Refresh;

                trigger OnAction()
                var
                    ProdOrder: Record "Production Order";
                begin
                    ProdOrder.SETRANGE(Status, Status);
                    ProdOrder.SETRANGE("No.", "No.");
                    REPORT.RUNMODAL(REPORT::"Refresh Production OrderEC", false, TRUE, ProdOrder);
                end;
            }
        }

        addafter("&Warehouse Entries")
        {
            action(Logs)
            {
                RunObject = Page "LogsOF";
                RunPageLink = OF = FIELD("No.");
            }
        }
        addafter(OrderTracking)
        {
            action("Forcer cloture")
            {
                trigger OnAction()
                var
                    CuProd: Codeunit "Integration Tft and Prod";
                begin
                    IF Confirm('Confirmer la cloture ?') THEN
                        CuProd.CloseOF(Rec."No.");
                end;
            }
            action("Remettre à l'écran")
            {
                trigger OnAction()
                var
                    Lines: Record "Prod. Order Line";
                begin
                    Rec.Termine := false;
                    Rec.Modify();
                    lines.Reset();
                    lines.SETRANGE("Prod. Order No.", Rec."No.");
                    if lines.FindSet() then
                        repeat
                            lines.Termine := false;
                            lines.Modify();
                        until lines.NEXT = 0;

                end;
            }
        }
        addafter(Planning)
        {
            action(Heures)
            {
                RunObject = Page "Heures ABC";
                RunPageLink = "Production No" = FIELD("No.");
                RunPageView = WHERE("Operateurs prevu" = FILTER(> 0),
                                    Imputation = CONST(Direct));
            }
        }
    }

}

