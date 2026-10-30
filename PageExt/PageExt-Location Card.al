pageextension 70166 pageextension70166 extends "Location Card"
{
    layout
    {
        addafter("Branch No.")
        {
            field("No TVA"; "No TVA")
            {
            }
        }
        addafter("Cross-Dock Due Date Calc.")
        {
            field("Veterinian Comment Type"; "Veterinian Comment Type")
            {
            }
        }
        addafter("Bin Policies")
        {
            group(Palettes)
            {
                Caption = 'Palettes';
                field("Pallet Management"; "Pallet Management")
                {
                }
                field("Default Recept. bin"; "Default Recept. bin")
                {
                }
                field("Default Ship. bin"; "Default Ship. bin")
                {
                }
                field("Qty check"; "Qty check")
                {
                }
            }
        }
    }
}

