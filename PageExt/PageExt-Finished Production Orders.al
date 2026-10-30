pageextension 70266 pageextension70266 extends "Finished Production Orders"
{
    layout
    {

        addafter("Last Date Modified")
        {
            field(Ligne_proprete; Ligne_proprete)
            {
            }
            field("Ligne_integrité"; Ligne_integrité)
            {
            }
            field("Quantité réalisée"; "Quantité réalisée")
            {
            }
        }
        addafter("Bin Code")
        {
            field("Quantité utilisée"; "Quantité utilisée")
            {
            }
        }
    }
}

