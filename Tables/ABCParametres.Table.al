table 50006 "ABC - Parametres"
{

    fields
    {
        field(1; "Production BOM No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Production BOM Header";
        }
        field(2; "BOM Version"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Activity; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "ABC - Activites";
        }
        field(4; Ressource; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "ABC - Ressources";

            trigger OnValidate()
            begin
                CalcFields("Rendement nominal");
            end;
        }
        field(5; "Rendement nominal"; Decimal)
        {
            CalcFormula = Lookup ("ABC - Ressources"."Rendement nominal" WHERE (Code = FIELD (Ressource)));
            Caption = 'Nominal Output';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "OEE (%)"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "OEE (%)" <> 0 then begin
                    CalcFields("Rendement nominal");
                    "Rendement effectif" := "Rendement nominal" * "OEE (%)" / 100;
                end;
            end;
        }
        field(7; "Rendement effectif"; Decimal)
        {
            Caption = 'Net Output';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CalcFields("Rendement nominal");
                "OEE (%)" := 0;
                if ("Rendement nominal" <> 0) and (Unité = Unité::"Kg/Heure") then "OEE (%)" := Round(("Rendement effectif" * 100) / "Rendement nominal", 0.01, '>');
            end;
        }
        field(9; "Unité"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Kg/Heure","Heure/Batch";
        }
        field(10; "Nombre d'opérateurs"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Batch standard"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; LineNo; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Cout Kg"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Ressource description"; Text[80])
        {
            CalcFormula = Lookup ("ABC - Ressources".Description WHERE (Code = FIELD (Ressource)));
            FieldClass = FlowField;
        }
        field(15; "Activity description"; Text[80])
        {
            CalcFormula = Lookup ("ABC - Activites".Description WHERE (Code = FIELD (Activity)));
            FieldClass = FlowField;
        }
        field(16; "Hr Prod Kg"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(17; Type; Option)
        {
            CalcFormula = Lookup ("ABC - Ressources".Type WHERE (Code = FIELD (Ressource)));
            FieldClass = FlowField;
            OptionMembers = "Main d'oeuvre","Machine (planifiable)","Matériel","Main d'oeuvre production","Prestation externe";
        }
        field(18; "Imputation Ressource"; Option)
        {
            CalcFormula = Lookup ("ABC - Activites".Imputation WHERE (Code = FIELD (Activity)));
            FieldClass = FlowField;
            OptionMembers = Direct,Indirect,Regroupement;
        }
        field(19; Rendement; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Tenir en compte dans le calcul de rendement';
        }
    }

    keys
    {
        key(Key1; "Production BOM No", "BOM Version", LineNo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

