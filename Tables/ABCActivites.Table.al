table 50004 "ABC - Activites"
{
    DrillDownPageID = "ABC - Activites";
    LookupPageID = "ABC - Activites";

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Atelier; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Work Center"."No.";
        }
        field(4; Imputation; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Direct,Indirect,Regroupement;
        }
        field(5; "On OF"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(6; Capte; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(7; Regroupement; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "ABC - Activites".Code WHERE (Imputation = CONST (Regroupement));

            trigger OnValidate()
            var
                Act: Record "ABC - Activites";
            begin
                if Act.Get(Regroupement) then
                    "Regroupement Description" := Act.Description;
            end;
        }
        field(8; "Regroupement Description"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

