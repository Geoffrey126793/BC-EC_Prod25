tableextension 50011 EmployeeEC extends Employee
{

    fields
    {
        field(50001; User; Code[50])
        {
            Caption = 'User';
        }
        field(50002; Barcode; Code[20])
        {
            Caption = 'Barcode';
        }
        field(50003; InventoryScan; Boolean)
        {
            Caption = 'InventoryScan';
        }
        field(50004; Accueil; Boolean)
        {
            Caption = 'Accueil';
        }
        field(50005; PIN; Code[6])
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Responsable tactile"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50007; Atelier; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Work Center" WHERE("Work Center Group Code" = CONST('ATELIERS'));
        }
        field(50008; "Utilisateur pointeuse"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

}

