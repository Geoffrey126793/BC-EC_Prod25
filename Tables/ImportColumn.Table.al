table 8001419 "Import Column"
{
    // //+REF+IMPORT CW 21/07/03 Import

    Caption = 'Import Column';

    fields
    {
        field(1; "Import Code"; Code[20])
        {
            Caption = 'Import Code';
            TableRelation = Import;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; TableNo; Integer)
        {
            Caption = 'TableNo';
            TableRelation = Object.ID WHERE(Type = CONST(Table));

            trigger OnLookup()
            var
                lObject: Record "Object";
            begin
            end;

            trigger OnValidate()
            var
                Objtransl: Record "Object Translation";
            begin
            end;
        }
        field(4; FieldNo; Integer)
        {
            BlankZero = true;
            Caption = 'FieldNo';
            TableRelation = Field."No." WHERE(TableNo = FIELD(TableNo));

            trigger OnLookup()
            var
                FieldLoc: Record "Field";
            begin
                FieldLoc.SetRange(TableNo, TableNo);

                CalcFields("Field Caption", "Field Type Name");
            end;

            trigger OnValidate()
            begin
                CalcFields("Field Caption", "Field Type Name");
            end;
        }
        field(5; "Column No."; Integer)
        {
            BlankZero = true;
            Caption = 'No colonne';
        }
        field(6; "Start Position"; Integer)
        {
            BlankZero = true;
            Caption = 'Start Position';

            trigger OnValidate()
            begin
                Validate(Length);
            end;
        }
        field(7; "End Position"; Integer)
        {
            BlankZero = true;
            Caption = 'End Position';

            trigger OnValidate()
            begin
                if "End Position" = 0 then
                    Length := 0
                else
                    Length := "End Position" - "Start Position" + 1;
            end;
        }
        field(8; Length; Integer)
        {
            BlankZero = true;
            Caption = 'Field Length';

            trigger OnValidate()
            begin
                "End Position" := "Start Position" + Length - 1;
                if "End Position" < 0 then
                    "End Position" := 0;
            end;
        }
        field(9; Divisor; Decimal)
        {
            BlankZero = true;
            Caption = 'Diviseur';
            DecimalPlaces = 0 : 5;
        }
        field(12; Constant; Text[30])
        {
            Caption = 'Constante';

            trigger OnLookup()
            var
                lCode: Code[20];
            begin
            end;
        }
        field(13; "Convertion Table"; Boolean)
        {
            BlankZero = true;
            CalcFormula = Exist("Import Correspondence" WHERE("Import Code" = FIELD("Import Code"),
                                                               "Field No." = FIELD(FieldNo)));
            Caption = 'Convertion Table';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; "Codeunit ID"; Integer)
        {
            BlankZero = true;
            Caption = 'No codeunit';
        }
        field(15; CallFieldValidate; Boolean)
        {
            Caption = 'CallFieldValidate';
        }
        field(16; Comment; Text[250])
        {
            Caption = 'Commentaire';
        }
        field(17; Title; Text[30])
        {
            Caption = 'Titre';
        }
        field(18; Mandatory; Boolean)
        {
            Caption = 'Obligatoire';
        }
        field(19; "Text Filter"; Text[250])
        {
            Caption = 'Filter';
        }
        field(100; "Field Caption"; Text[80])
        {
            CalcFormula = Lookup(Field."Field Caption" WHERE(TableNo = FIELD(TableNo),
                                                              "No." = FIELD(FieldNo)));
            Caption = 'Field Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(101; "Field Type Name"; Text[30])
        {
            CalcFormula = Lookup(Field."Type Name" WHERE(TableNo = FIELD(TableNo),
                                                          "No." = FIELD(FieldNo)));
            Caption = 'Type';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Import Code", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        lCorres: Record "Import Correspondence";
    begin
        if Import.Get("Import Code") and Import.Protected then
            Import.TestField(Protected, false);
        CalcFields("Convertion Table");
        if "Convertion Table" then
            if Confirm(TextCorres, false, FieldNo) then begin
                lCorres.SetCurrentKey("Import Code");
                lCorres.SetRange("Import Code", "Import Code");
                lCorres.SetRange("Field No.", FieldNo);
                lCorres.DeleteAll(true);
            end;
    end;

    trigger OnInsert()
    begin
        if Import.Get("Import Code") and Import.Protected then
            Import.TestField(Protected, false);
    end;

    trigger OnModify()
    begin
        if Import.Get("Import Code") and Import.Protected then
            Import.TestField(Protected, false);
    end;

    var
        Import: Record Import;
        TextCorres: Label 'Correspondences exist for field No. %1. Do you want to delete them ?';
}

