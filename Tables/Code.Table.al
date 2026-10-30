table 8001400 "Code"
{
    // //+BGW+CODE             GESWAY 01/01/00 Codes table
    // //+BGW+TRANSLATION GESWAY 26/01/02 Translation function
    // //+BGW+TRANSLATION CW 11/10/05 OnDelete, OnRename

    Caption = 'Code';
    LookupPageID = Codes;

    fields
    {
        field(1; "Table No"; Integer)
        {
            Caption = 'Table';
            TableRelation = Object.ID WHERE(Type = CONST(Table));
        }
        field(2; "Field No"; Integer)
        {
            Caption = 'Field';
            TableRelation = Field."No." WHERE(TableNo = FIELD("Table No"));
            ValidateTableRelation = false;
        }
        field(3; "Code"; Code[150])
        {
            Caption = 'Code';
        }
        field(4; Description; Text[150])
        {
            Caption = 'Description';
        }
        field(50001; Poids; Decimal)
        {
        }
        field(50002; Description2; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Poids primaire"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 3;
        }
        field(50004; "Plastique non recyclable"; Decimal)
        {
            Caption = 'Plastique non recyclable par Kg de produit';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Table No", "Field No", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Description)
        {
        }
    }

    trigger OnDelete()
    var
        lRecordRef: RecordRef;
    begin
        //TRANSLATION
        lRecordRef.GetTable(Rec);
        //lTranslationMgt.DeleteTranslations(lRecordRef.NUMBER,0,Code);
        //TRANSLATION//
    end;

    trigger OnRename()
    var
        lRecordRef: RecordRef;
    begin
        //TRANSLATION
        //lRecordRef.GETTABLE(Rec);
        //lTranslationMgt.RenameTranslations(lRecordRef.NUMBER,0,xRec.Code,Code);
        //TRANSLATION
    end;

    [Scope('OnPrem')]
    procedure Translation(pLanguage: Code[10]): Text[50]
    begin
        /*
        IF lTranslation.GET("Table No","Field No",Code,pLanguage) THEN
          Return := lTranslation.Description
        ELSE
          Return := Description;
        */
        //EXIT(lTranslationMgt.GetTranslation("Table No","Field No",Code,pLanguage,Description));

    end;
}

