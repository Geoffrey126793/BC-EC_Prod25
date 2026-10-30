pageextension 70100 pageextension70100 extends "Item Ledger Entries"
{
    layout
    {
        modify("Document No.")
        {
            Width = 15;
        }
        modify("Lot No.")
        {
            Width = 30;
            Style = Unfavorable;
            StyleExpr = LotBloque;
            Visible = True;
        }
        modify("Sales Amount (Expected)")
        {
            Visible = CoutVisible;
        }
        modify("Sales Amount (Actual)")
        {
            Visible = CoutVisible;
        }
        modify("Cost Amount (Expected)")
        {
            Visible = CoutVisible;
        }
        modify("Cost Amount (Actual)")
        {
            Visible = CoutVisible;
        }
        modify("Cost Amount (Non-Invtbl.)")
        {
            Visible = CoutVisible;
        }
        modify("Cost Amount (Expected) (ACY)")
        {
            Visible = CoutVisible;
        }
        modify("Cost Amount (Actual) (ACY)")
        {
            Visible = CoutVisible;
        }
        modify("Cost Amount (Non-Invtbl.)(ACY)")
        {
            Visible = CoutVisible;
        }
        addafter("Sales Amount (Actual)")
        {
            field("Cost Amount (AtDate)"; "Cost Amount (AtDate)")
            {
                Visible = CoutVisible;
            }
        }
        addafter("Entry No.")
        {
            field("Warranty Date"; "Warranty Date")
            {
            }

            field("Lot bloque"; "Lot bloque")
            {
            }
            field("Cost Amount (Actual) Direct"; "Cost Amount (Actual) Direct")
            {
                Visible = CoutVisible;
            }
            field("Cost Amount (Actual) Frais"; "Cost Amount (Actual) Frais")
            {
                Visible = CoutVisible;
            }
        }
        addafter("Job Task No.")
        {
            field(CoutUnit; CoutUnit)
            {
                Caption = 'Cout unitaire réél';
                Visible = CoutVisible;
            }
            field(Halal; Halal)
            {
            }
            field("Blocage Raison"; "Blocage Raison")
            {
                Caption = 'Raison du blocage';
            }
            field("Blocage Commentaire"; "Blocage Commentaire")
            {
                Caption = 'Commentaire blocage';
            }
            field(Decision; Decision)
            {
            }
            field("Commentaire Decision"; "Commentaire Decision")
            {
            }
            field("Source desc"; "Source desc")
            {
            }
            field("Blocage Lot Statut"; "Blocage Lot Statut")
            {

            }
            field("Blocage Lot Destination"; "Blocage Lot Destination")
            {

            }
            field("Blocage Lot Recyclage"; "Blocage Lot Recyclage")
            {

            }
        }
    }

    var
        LotInfo: Record "Lot No. Information";
        LotBloque: Boolean;
        LotBloqueRaison: Text[250];

    var
        CoutVisible: Boolean;
        AB6Tool: Codeunit "Absys - tools PJ";
        CoutUnit: Decimal;


    trigger OnAfterGetRecord()
    begin
        LotInfo.Reset;
        LotBloque := false;
        LotBloqueRaison := '';
        if LotInfo.Get("Item No.", "Variant Code", "Lot No.") then begin
            LotBloque := LotInfo.Blocked;
            //IF (LotBloque) THEN
            LotBloqueRaison := LotInfo."Raison du blocage" + ' A ' + LotInfo."Commentaire blocage";
        end;
        if Quantity <> 0 then
            CoutUnit := "Cost Amount (Actual)" / Quantity;
    end;


    trigger OnOpenPage()
    begin
        CoutVisible := AB6Tool.GetRole('COUT');
    end;
}

