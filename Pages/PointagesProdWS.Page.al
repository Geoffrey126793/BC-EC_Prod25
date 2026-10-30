page 50074 "PointagesProd WS"
{
    PageType = List;
    SourceTable = PointagesProd;
    SourceTableView = SORTING (Salarie, DtDebut)
                      ORDER(Descending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ID; ID)
                {
                }
                field(Machine; Machine)
                {
                }
                field(DtDebut; DtDebut)
                {
                }
                field(DtFin; DtFin)
                {
                }
                field(Salarie; Salarie)
                {
                }
                field("OF"; "OF")
                {
                }
                field(LigneOF; LigneOF)
                {
                }
                field(ActiviteRegroup; ActiviteRegroup)
                {
                }
                field(ActiviteRegroupDesc; ActiviteRegroupDesc)
                {
                }
                field(Comment; Comment)
                {
                }
                field(NomSalarie; NomSalarie)
                {
                }
                field(ItemNo; ItemNo)
                {
                }
                field("Emplacement"; Emplacement)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        ItemNo := '';
        Ofs.Reset;
        Ofs.SetRange("No.", Rec."OF");
        if (Rec."OF" <> '') and Ofs.FindFirst then
            ItemNo := Ofs."Source No.";
    end;

    var
        Ofs: Record "Production Order";
        ItemNo: Code[20];
}

