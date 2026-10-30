pageextension 70289 pageextension70289 extends "Production BOM Version"
{
    actions
    {
        addafter("Where-Used")
        {
            action("ABC Parametres")
            {
                Caption = 'ABC Parametres';
                RunObject = Page "ABC - Parametres";
                RunPageLink = "Production BOM No" = FIELD ("Production BOM No."),
                              "BOM Version" = FIELD ("Version Code");
            }
            action(Process)
            {
                Caption = 'Process';
                RunObject = Page Process;
                RunPageLink = "Production BOM No" = FIELD ("Production BOM No."),
                              "BOM Version" = FIELD ("Version Code");
            }
        }
    }
}

