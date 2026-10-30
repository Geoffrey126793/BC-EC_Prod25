page 50055 "ABC - Parametres"
{
    AutoSplitKey = true;
    PageType = List;
    SourceTable = "ABC - Parametres";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Activity; Activity)
                {
                }
                field(Ressource; Ressource)
                {
                }
                field("Rendement nominal"; "Rendement nominal")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("OEE (%)"; "OEE (%)")
                {
                }
                field("Rendement effectif"; "Rendement effectif")
                {
                }
                field("Unité"; Unité)
                {

                    trigger OnValidate()
                    begin
                        EditStdBatch := (Unité = Unité::"Heure/Batch");
                    end;
                }
                field("Nombre d'opérateurs"; "Nombre d'opérateurs")
                {
                }
                field("Batch standard"; "Batch standard")
                {
                    Editable = EditStdBatch;
                }
                field("Activity description"; "Activity description")
                {
                }
                field("Ressource description"; "Ressource description")
                {
                }
                field(Rendement; Rendement)
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
        EditStdBatch := (Unité = Unité::"Heure/Batch");
    end;

    var
        EditStdBatch: Boolean;
}

