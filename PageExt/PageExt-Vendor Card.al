pageextension 70085 pageextension70085 extends "Vendor Card"
{
    layout
    {
        modify("VAT Registration No.")
        {
            Visible = false;
        }
        addafter("VAT Registration No.")
        {
            field(tmpTVA; tmpTVA)
            {
            }
        }
        addafter(Invoicing)
        {
            group(EDI)
            {
                Caption = 'EDI';
                field(GLN2; GLN)
                {
                }
                field("GLN Destinataire"; "GLN Destinataire")
                {
                }
                field("E-Mail EDI"; "E-Mail EDI")
                {
                }
                field("Repertoire Send AS2"; "Repertoire Send AS2")
                {
                }
                field("Traitement EDI"; "Traitement EDI")
                {
                }
                field(IFCSUM; IFCSUM)
                {
                }
                field("Ignorer le mappage de texte"; "Ignorer le mappage de texte")
                {
                }
            }
            group("Critères")
            {
                Caption = 'Critères';
                field("Criteria 1"; "Criteria 1")
                {
                }
            }
        }
    }
    actions
    {
        addafter("Co&mments")
        {
            action("Commentaires sur achats")
            {
                Caption = 'Commentaires sur achats';
                RunObject = Page "Alert List";
                RunPageLink = "Table Name" = CONST (Customer),
                              "No." = FIELD ("No.");
            }
        }
        addafter("Return Orders")
        {
            action("Tarif transport / unité")
            {
                RunObject = Page "Tarif transport / unité";
                RunPageLink = Fournisseur = FIELD ("No."),
                              "Type Prix" = CONST (Tpt);
            }
            action("Tarif transport admin")
            {
                RunObject = Page "Tarif transport admin";
                RunPageLink = Fournisseur = FIELD ("No."),
                              "Type Prix" = CONST (Admin);
            }
        }
    }
}

