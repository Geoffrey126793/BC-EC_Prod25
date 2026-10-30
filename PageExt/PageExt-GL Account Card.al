pageextension 70048 pageextension70048 extends "G/L Account Card"
{
    layout
    {
        addafter(Totaling)
        {
            field(Regroupement; Regroupement)
            { }
        }
    }
    actions
    {
        addafter("Co&mments")
        {
            action("Commentaires sur vente")
            {
                Caption = 'Commentaires sur vente';
                RunObject = Page "Alert List";
                RunPageLink = "Table Name" = CONST (Customer),
                              "No." = FIELD ("No.");
            }
        }
    }
}

