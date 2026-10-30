page 50099 "Pointages production"
{
    PageType = List;
    SourceTable = PointagesProd;
    SourceTableView = WHERE (Traitement = CONST (Pointage));
    UsageCategory = ReportsAndAnalysis;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Machine; Machine)
                {
                }
                field(DtDebut; DtDebut)
                {
                }
                field(DtFin; DtFin)
                {
                }
                field(Duree; Duree)
                {
                }
                field(Salarie; Salarie)
                {
                }
                field("NomSalarie"; NomSalarie)
                {
                }
                field("OF"; "OF")
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
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Duree := 0;
        if DtFin > 0DT then
            Duree := (DtFin - DtDebut) / (60 * 60000);
    end;

    var
        Duree: Decimal;
}

