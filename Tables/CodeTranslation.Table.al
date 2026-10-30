table 8001411 "Code Translation"
{
    // ----------------------------------------------------------------------------------
    //   STA-000 ABSYS GN TEMPORAIRE
    //     - Code +REF+REPLIC Mis en commentaire car ne compile pas
    //     - Suppression Temporaire de la variable Globale
    //       wReplicationTrigger    Codeunit    Codeunit8001406
    // 
    // ----------------------------------------------------------------------------------
    // 
    // //+BGW+TRANSLATION GESWAY 26/01/02 New table for Code translation
    // //+REF+REPLIC AC 28/06/05 OnInsert, OnModify, OnDelete, OnRename
    //                           + field "Replication" (ID = 73754 ), boolean, editable=No

    LookupPageID = "Codes translations";

    fields
    {
        field(1; TableID; Integer)
        {
            Caption = 'ID Table';
        }
        field(2; FieldID; Integer)
        {
        }
        field(3; "Code"; Code[30])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(4; Language; Code[10])
        {
            Caption = 'Language';
            NotBlank = true;
            TableRelation = Language;
        }
        field(5; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(6; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(73754; Replication; Boolean)
        {
            Caption = 'Replication';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; TableID, FieldID, "Code", Language)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //--> STA-000 ABSYS GN
        /*
        //+REF+REPLIC
        wReplicationRef.GETTABLE(Rec);
        wReplicationTrigger.OnDelete(wReplicationRef);
        //+REF+REPLIC//
        */
        //<-- STA-000 ABSYS GN

    end;

    trigger OnInsert()
    begin
        //--> STA-000 ABSYS GN
        /*
        //+REF+REPLIC
        wReplicationRef.GETTABLE(Rec);
        wReplicationTrigger.OnInsert(wReplicationRef);
        //+REF+REPLIC//
        */
        //<-- STA-000 ABSYS GN

    end;

    trigger OnModify()
    var
        lReplicationRef: RecordRef;
    begin
        //--> STA-000 ABSYS GN
        /*
        //+REF+REPLIC
        lReplicationRef.GETTABLE(xRec);
        wReplicationRef.GETTABLE(Rec);
        wReplicationTrigger.OnModify(wReplicationRef,lReplicationRef);
        //+REF+REPLIC//
        */
        //<-- STA-000 ABSYS GN

    end;

    trigger OnRename()
    var
        lReplicationRef: RecordRef;
    begin
        //--> STA-000 ABSYS GN
        /*
        //+REF+REPLIC
        lReplicationRef.GETTABLE(xRec);
        wReplicationRef.GETTABLE(Rec);
        wReplicationTrigger.OnRename(lReplicationRef,wReplicationRef);
        //+REF+REPLIC//
        */
        //<-- STA-000 ABSYS GN

    end;

    var
        wReplicationRef: RecordRef;
}

