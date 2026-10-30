pageextension 70265 pageextension70265 extends "Released Production Orders"
{
    layout
    {
        modify("No.")
        {
            Width = 15;
        }
        addafter(Quantity)
        {
            field("Quantité MP"; "Quantité MP")
            {
            }
            field("Quantité réalisée"; "Quantité réalisée")
            {
            }
            field("Quantité utilisée"; "Quantité utilisée")
            {
            }
            field(Rendement; Rendement)
            {
            }
            field(Machine; Machine)
            {
            }
        }
        addafter("Last Date Modified")
        {
            field(Ordre; Ordre)
            {
            }
            field(Ligne_proprete; Ligne_proprete)
            {
            }
            field("Ligne_integrité"; Ligne_integrité)
            {
            }
            field(Termine; Termine)
            {
            }
            field("Effectif Nomenclature"; "Effectif Nomenclature")
            {
            }
        }
    }

    var
        Rendement: Decimal;

    trigger OnAfterGetRecord()
    begin
        CalcFields("Quantité réalisée", "Quantité utilisée");
        if "Quantité utilisée" <> 0 then
            Rendement := "Quantité réalisée" / -"Quantité utilisée"
        else
            Rendement := 0;
    end;
}

