table 8001418 Import
{
    // //+REF+IMPORT CW 21/07/03 Import

    DataCaptionFields = "Code", Description;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(4; "File Name"; Text[250])
        {
            Caption = 'FileName';
        }
        field(5; "File Format"; Option)
        {
            Caption = 'File Format';
            OptionCaption = 'Excel,Tab,Comma,SemiColon,Fixed';
            OptionMembers = Excel,Tab,Comma,SemiColon,"Fixed";
        }
        field(6; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            TableRelation = Object.ID WHERE(Type = CONST(Table));

            trigger OnLookup()
            var
                lObject: Record "Object";
            begin
                lObject.SetRange(Type, lObject.Type::Table);
                if PAGE.RunModal(PAGE::Objects, lObject) = ACTION::LookupOK then begin
                    "Table ID" := lObject.ID;
                    ValidateTableID;
                end;
            end;

            trigger OnValidate()
            begin
                ValidateTableID;
            end;
        }
        field(7; "Import Group"; Code[10])
        {
            Caption = 'Groupe d''import';
            TableRelation = Code.Code WHERE("Table No" = CONST(8001418),
                                             "Field No" = CONST(7));
        }
        field(8; Mode; Option)
        {
            Caption = 'Mode';
            OptionCaption = 'Insert & Update,Insert,Update,Delete & Replace';
            OptionMembers = "Insert & Update",Insert,Update,"Delete & Replace";
        }
        field(9; "ASCII/ANSI"; Option)
        {
            Caption = 'ASCII/ANSI';
            OptionCaption = 'ASCII,ANSI';
            OptionMembers = ASCII,ANSI;
        }
        field(10; "Title Line No."; Integer)
        {
            BlankZero = true;
            Caption = 'Tilte Line';
        }
        field(11; "Field Delimiter"; Option)
        {
            Caption = 'Field Delimiter';
            OptionCaption = 'Aucun,",''';
            OptionMembers = "None",v,b;
        }
        field(12; "Codeunit ID"; Integer)
        {
            BlankZero = true;
            Caption = 'No codeunit';
            TableRelation = Object.ID WHERE(Type = CONST(Codeunit));

            trigger OnLookup()
            var
                lObject: Record "Object";
            begin
                lObject.SetRange(Type, lObject.Type::Codeunit);
                if PAGE.RunModal(PAGE::Objects, lObject) = ACTION::LookupOK then
                    "Codeunit ID" := lObject.ID;
                CalcFields("Codeunit Caption")
            end;

            trigger OnValidate()
            begin
                CalcFields("Codeunit Caption")
            end;
        }
        field(13; "Date Format"; Option)
        {
            Caption = 'Date Format';
            OptionCaption = 'European,American,Reverse';
            OptionMembers = European,American,Reverse;
        }
        field(14; "Trigger"; Option)
        {
            Caption = 'DÚclencheur';
            OptionCaption = 'Aucun,OnInsert,OnModify,Les deux';
            OptionMembers = "None",OnInsert,OnModify,Both;
        }
        field(15; Protected; Boolean)
        {
            Caption = 'Protected';

            trigger OnValidate()
            begin
                Modify;
            end;
        }
        field(16; "Alias File Name"; Code[20])
        {
            Caption = 'Alias File Name';
            TableRelation = Import;
        }
        field(107; "Table Caption"; Text[250])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object Type" = CONST(Table),
                                                                           "Object ID" = FIELD("Table ID")));
            Caption = 'Table Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(108; "Codeunit Caption"; Text[249])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object Type" = CONST(Codeunit),
                                                                           "Object ID" = FIELD("Codeunit ID")));
            Caption = 'Table Caption';
            Editable = false;
            FieldClass = FlowField;
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

    trigger OnDelete()
    var
        lImportLine: Record "Import Column";
        lCorres: Record "Import Correspondence";
    begin
        lImportLine.SetCurrentKey("Import Code");
        lImportLine.SetRange("Import Code", Code);
        lImportLine.DeleteAll(true);

        lCorres.SetCurrentKey("Import Code");
        lCorres.SetRange("Import Code", Code);
        lCorres.DeleteAll(true);
    end;

    trigger OnModify()
    begin
        TestField(Protected, false);
    end;

    var
        tConfirmDeleteLines: Label 'Do you want to delete all lines ?';
        lNoImport: Label 'No import define for table %1, Template %2, Bacth %3.';
        lNotUniqueImport: Label 'No import define for table %1, Template %2, Bacth %3.';
        tConfirmImport: Label 'Do you want to import file %1?';

    [Scope('OnPrem')]
    procedure ValidateTableID()
    var
        lLine: Record "Import Column";
    begin
        if (xRec."Table ID" <> 0) and ("Table ID" <> xRec."Table ID") then begin
            lLine.SetRange("Import Code", Code);
            if lLine.Find('-') then
                if Confirm(tConfirmDeleteLines, false) then
                    lLine.DeleteAll;
        end;
        CalcFields("Table Caption");
    end;

    [Scope('OnPrem')]
    procedure ImportJournal(pTableNo: Integer; pTemplateID: Integer; pTemplateName: Code[10]; pBatchID: Integer; pBatchName: Code[10])
    var
        lImport: Record Import;
        lTemplateName: Record "Import Column";
        lBatchName: Record "Import Column";
    begin
        lTemplateName.SetRange(TableNo, pTableNo);
        lTemplateName.SetRange(FieldNo, pTemplateID);
        lTemplateName.SetRange(Constant, pTemplateName);
        lBatchName.SetRange(TableNo, pTableNo);
        lBatchName.SetRange(FieldNo, pBatchID);
        lBatchName.SetRange(Constant, pBatchName);
        if lTemplateName.Find('-') then begin
            repeat
                lBatchName.SetRange("Import Code", lTemplateName."Import Code");
            until (lTemplateName.Next = 0) or lBatchName.Find('-');
            case lBatchName.Count of
                0:
                    Error(lNoImport, pTableNo, pTemplateName, pBatchName);
                1:
                    begin
                        lImport.Get(lBatchName."Import Code");
                        lImport.TestField("File Name");
                        lImport.SetRange(Code, lBatchName."Import Code");
                        if Confirm(tConfirmImport, false, lImport."File Name") then
                            REPORT.Run(REPORT::"Import Budget from Excel", false, true, lImport);
                    end;
                else
                    Error(lNotUniqueImport, pTableNo, pTemplateName, pBatchName);
            end;
        end;
    end;
}

