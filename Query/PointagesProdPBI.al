query 50090 "Pointages ProdPBI"
{
    QueryType = Normal;

    elements
    {
        dataitem(PointagesProd; "PointagesProd")
        {
            column(ID; ID) { }

            column(Machine; Machine) { }

            column(DtDebut; DtDebut) { }

            column(DtFin; DtFin) { }

            column(Salarie; Salarie) { }

            column("OF"; "OF") { }

            column(LigneOF; LigneOF) { }

            column(ActiviteRegroup; ActiviteRegroup) { }

            column(ActiviteRegroupDesc; ActiviteRegroupDesc) { }

            column(Comment; Comment) { }

            column(NomSalarie; NomSalarie) { }

            column(Minutes; Minutes) { }

            column(DtDebutEncodee; DtDebutEncodee) { }

            column(DtFinEncodee; DtFinEncodee) { }

            column(tmp_nbreOF; tmp_nbreOF) { }

            column(Traitement; Traitement) { }

            column(Traite; Traite) { }

            column(Temps_interruption; "Temps interruption") { }

            column(Interruption_machine; "Interruption machine") { }
            column(Emplacement; Emplacement) { }
        }
    }
}