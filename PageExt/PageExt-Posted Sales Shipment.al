pageextension 70020 pageextension70020 extends "Posted Sales Shipment"
{
    layout
    {

        addafter("No. Printed")
        {
            field("Nombre de palette"; "Nombre de palette")
            {
            }
            field("Nombre de colis"; "Nombre de colis")
            {
            }
        }
        addafter("Promised Delivery Date")
        {
            field("Order Date"; "Order Date")
            {
            }
            field("Raison retard"; "Raison retard")
            {

            }
        }
    }
    actions
    {
        modify("&Track Package")
        {
            Visible = false;
        }
        addafter(CertificateOfSupplyDetails)
        {
            action("Confirmer les palettes")
            {
                Caption = 'Confirmer les palettes';
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                RunPageMode = View;

                trigger OnAction()
                var
                    dlg: Dialog;
                    NbrPal: Integer;
                    NbrColis: Integer;
                    P50082: Page AskPal;
                begin

                    P50082.setExp("No.");
                    P50082.RunModal;
                end;
            }
        }
        addafter("&Track Package")
        {
            action("Traca viandes")
            {

                trigger OnAction()
                var
                    PTraca: Page "Item TracingEC";
                begin
                    PTraca.TrackEXV("No.");
                    PTraca.Run;
                end;
            }
            action("Tracabilité ATC")
            {

                trigger OnAction()
                var
                    edi: Codeunit EDI;
                begin
                    edi.ATC(Rec."No.");
                end;
            }
        }
        addafter("&Print")
        {
            action("Envoyer à l'impression")
            {
                Caption = 'Envoyer à l''impression';
                Image = PrintForm;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                var
                    sessionId: Integer;
                begin
                    StartSession(sessionId, CODEUNIT::"Print EXV", CompanyName, Rec);
                end;
            }
            action("<Action1000000003>")
            {
                Caption = '<Action1000000003>';
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                var
                    PFicheExpe: Page "Palettes expedition";
                    Pal: Record Pallet;
                begin
                    PFicheExpe.setExpedition("No.");
                    Pal.Reset;
                    Pal.SetRange("Outbound Document No.", "No.");
                    Pal.SetRange(Type, Pal.Type::Expedition);
                    PFicheExpe.SetTableView(Pal);
                    PFicheExpe.Run;
                end;
            }
        }
    }

    var
        UserSetup: Record "User Setup";

    trigger OnOpenPage()
    begin
        //AB6.SEC
        if (UserSetup.Get(UserId)) and (UserSetup."Location Filter" <> '') then begin
            FilterGroup(2);
            SetFilter("Location Code", UserSetup."Location Filter");
            FilterGroup(0);
        end;

        //CTD FND 17/05/2013: Ajout d'un filtre sur le centre de gestion.
        if (UserSetup.Get(UserId)) and (UserSetup."Resp. Centrer Filter" <> '') then begin
            FilterGroup(2);
            SetFilter("Salesperson Code", UserSetup."Resp. Centrer Filter");
            FilterGroup(0);
        end;
        //CTD//

        //SetSecurityFilterOnRespCenter;

    end;
}

