table 50035 Pointages
{

    fields
    {
        field(1; ID; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; Badge; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Dt; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(4; Emplacement; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(5; User; Text[80])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Emp: Record Employee;
            begin
                Emp.Reset;
                Emp.SetRange("Utilisateur pointeuse", User);
                if Emp.FindFirst then begin
                    Atelier := Emp.Atelier;
                end;
            end;
        }
        field(6; Atelier; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Work Center" WHERE ("Work Center Group Code" = CONST ('ATELIERS'));
        }
    }

    keys
    {
        key(Key1; ID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

