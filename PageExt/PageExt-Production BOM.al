pageextension 70285 pageextension70285 extends "Production BOM"
{
    layout
    {
        addafter(General)
        {
            group("Malaxage / Injection")
            {
                Caption = 'Malaxage / Injection';
                field("Quantite par malaxage"; "Quantite par malaxage")
                {
                }
            }
        }
        addafter(Status)
        {
            field("Calcul en cours"; "Calcul en cours")
            {

            }
        }
    }
    actions
    {
        addafter("Where-used")
        {
            action("ABC Paramètres")
            {
                Caption = 'ABC Paramètres';
                RunObject = Page "ABC - Parametres";
                RunPageLink = "Production BOM No" = FIELD ("No."),
                              "BOM Version" = CONST ('');
            }
            action(Process)
            {
                Caption = 'Process';
                RunObject = Page Process;
                RunPageLink = "Production BOM No" = FIELD ("No."),
                              "BOM Version" = CONST ('');
            }
        }
    }
}

