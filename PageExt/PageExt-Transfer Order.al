pageextension 70173 pageextension70173 extends "Transfer Order"
{
    layout
    {
        modify("Direct Transfer")
        {
            Visible = false;
        }
        addafter(Status)
        {
            field(Departement; Departement)
            {
            }
            field(Emplacement; Emplacement)
            {
            }
        }
        addafter("Receipt Date")
        {
            field("Blocage des lots"; "Blocage des lots")
            {
            }
        }
    }
    actions
    {

        Modify("&Print")
        {
            Visible = false;
        }
        addafter("&Print")
        {
            action("Imprimer")
            {
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Category8;

                trigger OnAction()
                var
                    RecTransHeader_l: Record "Transfer Header";
                    DocPrint: Codeunit "Document-Print";
                    ReportOTS: Report "Transfer Order EC";
                begin
                    ReportOTS.SetShowPallet(false);
                    RecTransHeader_l.SetRange("No.", "No.");
                    ReportOTS.SetTableView(RecTransHeader_l);
                    ReportOTS.Run();
                end;
            }
            action("Imprimer avec prépa palettes")
            {
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Category8;

                trigger OnAction()
                var
                    RecTransHeader_l: Record "Transfer Header";
                    DocPrint: Codeunit "Document-Print";
                    ReportOTS: Report "Transfer Order EC";
                begin
                    ReportOTS.SetShowPallet(true);
                    RecTransHeader_l.SetRange("No.", "No.");
                    ReportOTS.SetTableView(RecTransHeader_l);
                    ReportOTS.Run()
                end;
            }
        }
        addafter("Create Inventor&y Put-away/Pick")
        {
            action("Annuler le scan")
            {
                Caption = 'Annuler le scan';

                trigger OnAction()
                var
                    PalletJnl: Record "Pallet Journal";
                begin

                    if Confirm('Supprimer le scan ?') then begin
                        PalletJnl.Reset;
                        PalletJnl.SetRange("Journal Template Name", "No.");
                        PalletJnl.DeleteAll;
                    end;
                end;
            }
        }
        addafter(PostAndPrint)
        {
            action("Dédouanement")
            {
                Caption = 'Dédouanement';
                RunObject = Codeunit "Dedouanement Mgt";
            }

        }
    }
}

