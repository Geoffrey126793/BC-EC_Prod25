table 8001404 "Batch Treatment"
{
    // //+STA+BATCH GESWAY 01/01/00 Table des reports Ó lancer en batch (multi sociÚtÚ)

    Caption = 'Batch treatment';
    DataPerCompany = false;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            NotBlank = true;
        }
        field(3; Company; Text[30])
        {
            Caption = 'Company';
            NotBlank = true;
            TableRelation = Company;
        }
        field(10; "Report No."; Integer)
        {
            Caption = 'Report No.';
            NotBlank = true;
            TableRelation = Object.ID WHERE (Type = FILTER (Report));
        }
        field(11; Name; Text[80])
        {
            CalcFormula = Lookup (Object.Name WHERE (Type = FILTER (Report),
                                                    ID = FIELD ("Report No.")));
            Caption = 'Name';
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                CalcFields(Name);
            end;
        }
        field(20; "Date of last launch"; Date)
        {
            Caption = 'Date of last launch';
        }
        field(22; Frequency; Code[10])
        {
            Caption = 'Frequency';
            DateFormula = true;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Report No.", Company)
        {
        }
        key(Key3; Company, "Report No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Batch: Record "Batch Treatment";
}

