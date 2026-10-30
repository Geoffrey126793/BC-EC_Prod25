table 8001422 "Direct Mailing Line"
{
    // //PUBLIPOSTAGE GESWAY 18/12/03 Nouvelle table ligne Publipostage
    //                AC     06/01/05 Ajout de la table des Ecritures Caution et des comptes bancaires dans InitTableList;

    Caption = 'Direct Mailing Line';

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Table No."; Integer)
        {
            Caption = 'Table No.';

            trigger OnLookup()
            begin
                InitTableList;
                if PAGE.RunModal(PAGE::Objects, Table) = ACTION::LookupOK then begin
                    Validate("Table No.", Table.ID);
                end;
            end;

            trigger OnValidate()
            begin
                InitTableList;
                if not isTableInFilter("Table No.") then
                    Error(Text001);
                Table.CalcFields(Caption);
                "Table Caption" := Table.Caption;
                "Table Name" := Table.Name;
            end;
        }
        field(4; "Table Caption"; Text[30])
        {
            Caption = 'Table Caption';
            Editable = false;
        }
        field(5; "Table Name"; Text[30])
        {
            Caption = 'Table Name';
            Editable = false;
        }
        field(6; "Field No."; Integer)
        {
            Caption = 'Field No.';

            trigger OnLookup()
            begin
                TestField("Table No.");
                InitFieldList;

            end;

            trigger OnValidate()
            begin
                TestField("Table No.");
                Validate("Table No.");
                InitFieldList;
                if "Field No." > 0 then begin
                    if not FieldTable.Get("Table No.", "Field No.") then
                        Error(Text001);
                    "Field Caption" := FieldTable."Field Caption";
                    "Field Name" := FieldTable.FieldName;
                end else begin
                    "Field Caption" := '';
                    "Field Name" := '';
                end;
            end;
        }
        field(7; "Field Caption"; Text[30])
        {
            Caption = 'Field Caption';
            Editable = false;
        }
        field(8; "Field Name"; Text[30])
        {
            Caption = 'Field Name';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Code", "Table No.", "Field No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        isFieldAlreadySelected;

        DirectMailingLine.Reset;
        DirectMailingLine.SetRange(Code, Code);
        if DirectMailingLine.Find('+') then
            "Line No." := DirectMailingLine."Line No." + 10000
        else
            "Line No." := 10000;
    end;

    trigger OnModify()
    begin
        isFieldAlreadySelected;
    end;

    var
        "Table": Record "Object";
        FieldTable: Record "Field";
        TableFilter: Text[250];
        Text001: Label 'You have entered an illegal value.';
        DirectMailingLine: Record "Direct Mailing Line";
        Text002: Label 'Field has already been selected.';

    [Scope('OnPrem')]
    procedure InitTableList()
    begin
        TableFilter := '3|4|10|13|18|36|79|167|289|5050|5714';
        //CAUTION
        TableFilter := TableFilter + '|8003993';
        //CAUTION//
        Table.SetRange(Type, Table.Type::Table);
        Table.SetFilter(ID, TableFilter);
        Table.Find('-');
    end;

    [Scope('OnPrem')]
    procedure InitFieldList()
    var
        lFilter: Text[250];
    begin
        FieldTable.Reset;
        FieldTable.SetRange(TableNo, "Table No.");
    end;

    [Scope('OnPrem')]
    procedure isTableInFilter(pTableNo: Integer): Boolean
    begin
        if Table.Find('-') then
            repeat
                if Table.ID = pTableNo then
                    exit(true);
            until Table.Next = 0;
        exit(false);
    end;

    [Scope('OnPrem')]
    procedure isFieldAlreadySelected()
    begin
        TestField("Field No.");
        DirectMailingLine.SetRange(Code, Code);
        DirectMailingLine.SetRange("Table No.", "Table No.");
        DirectMailingLine.SetRange("Field No.", "Field No.");
        if DirectMailingLine.Find('-') then
            Error(Text002);
    end;
}

