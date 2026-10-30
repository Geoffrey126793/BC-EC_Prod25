codeunit 8001423 "Translation Management"
{
    // //+BGW+TRANSLATION CW 11/10/05 Translation management
    // 
    // Use a text editor to add this code at the place above.
    // Use suggested IDs (@80014xx) to avoid conflicts when merging.
    // 
    // ========================================================================================
    // 1) Table :
    // ----------
    // 
    //   PROPERTIES
    //   {
    //     ........................................................................................
    // 
    //     OnDelete=VAR
    //                lTranslationMgt@8001400 : Codeunit 8001423;
    //                lRecordRef@8001401 : RecordRef;
    //              BEGIN
    //                //TRANSLATION
    //                lRecordRef.GETTABLE(Rec);
    //                lTranslationMgt.DeleteTranslations(lRecordRef.NUMBER,0,Code);
    //                //TRANSLATION//
    //              END;
    // 
    //     OnRename=VAR
    //                lTranslationMgt@8001400 : Codeunit 8001423;
    //                lRecordRef@8001401 : RecordRef;
    //              BEGIN
    //                //TRANSLATION
    //                lRecordRef.GETTABLE(Rec);
    //                lTranslationMgt.RenameTranslations(lRecordRef.NUMBER,0,xRec.Code,Code);
    //                //TRANSLATION
    //              END;
    //     ........................................................................................
    // 
    // 
    //   Documentation :
    //     ........................................................................................
    //     {
    //       //TRANSLATION CW 11/10/05 OnDelete, OnRename
    //     }
    //     ........................................................................................
    // 
    // ========================================================================================
    // 2) Form List
    // ------------
    // 
    //   After Description TextBox and Label :
    //     ........................................................................................
    //     { 8001402;TextBox   ;6535 ;550  ;4400 ;440  ;HorzGlue=Both;
    //                                                  ParentControl=1;
    //                                                  InColumn=Yes;
    //                                                  CaptionML=[ENU=Caption;
    //                                                             FRA=Légende];
    //                                                  SourceExpr=Translation;
    //                                                  OnFormat=BEGIN
    //                                                             //TRANSLATION
    //                                                             RecRef.GETTABLE(Rec);
    //                                                             Text :=
    //                                                               TranslationMgt.GetTranslation(RecRef.NUMBER,0,Code,'',Description);
    //                                                             //TRANSLATION//
    //                                                           END;
    // 
    //                                                  OnValidate=BEGIN
    //                                                               //TRANSLATION
    //                                                               RecRef.GETTABLE(Rec);
    //                                                               TranslationMgt.SetTranslation(RecRef.NUMBER,0,Code,'',Translation)
    //                                                               //TRANSLATION//
    //                                                             END;
    // 
    //                                                  OnAssistEdit=BEGIN
    //                                                                 //TRANSLATION
    //                                                                 RecRef.GETTABLE(Rec);
    //                                                                 TranslationMgt.ShowTranslation(RecRef.NUMBER,0,Code);
    //                                                                 //TRANSLATION//
    //                                                               END;
    //                                                                }
    //     { 8001403;Label     ;0    ;0    ;0    ;0    ;ParentControl=8001402;
    //                                                  InColumnHeading=Yes }
    //     ........................................................................................
    // 
    // 
    //   CODE
    //   {
    //     ........................................................................................
    //     VAR
    //       TranslationMgt@8001400 : Codeunit 8001423;
    //       Translation@8001401 : Text[250];
    //       RecRef@8001402 : RecordRef;
    //     ........................................................................................
    //   }
    // 
    // 
    //   Documentation :
    //     ........................................................................................
    //     {
    //       //+REF+TRANSLATION CW 11/10/05 +Translation column with triggers
    //     }
    //     ........................................................................................


    trigger OnRun()
    begin
    end;

    var
        Translation: Record "Code Translation";
        Language: Record Language;

    [Scope('OnPrem')]
    procedure GetTranslation(pTableNo: Integer; pFieldNo: Integer; pCode: Code[30]; pLanguageCode: Code[10]; pDefault: Text[250]): Text[250]
    begin


        if Translation.Get(pTableNo, pFieldNo, pCode, pLanguageCode) then
            exit(Translation.Description)
        else
            exit(pDefault);
    end;

    [Scope('OnPrem')]
    procedure DeleteTranslations(pTableNo: Integer; pFieldNo: Integer; pCode: Code[20])
    begin
        Translation.SetRange(TableID, pTableNo);
        Translation.SetRange(FieldID, pFieldNo);
        Translation.DeleteAll;
    end;

    [Scope('OnPrem')]
    procedure RenameTranslations(pTableNo: Integer; pFieldNo: Integer; pOld: Code[20]; pNew: Code[20])
    var
        lNewTranslation: Record "Code Translation";
    begin
        Translation.SetRange(TableID, pTableNo);
        Translation.SetRange(FieldID, pFieldNo);
        repeat
            lNewTranslation := Translation;
            lNewTranslation.TableID := pTableNo;
            lNewTranslation.FieldID := pFieldNo;
            lNewTranslation.Insert(true);
        until Translation.Next = 0;
        Translation.DeleteAll(true);
    end;

    [Scope('OnPrem')]
    procedure ShowTranslation(pTableNo: Integer; pFieldNo: Integer; pCode: Code[20])
    begin
        Translation.FilterGroup(10);
        Translation.SetRange(TableID, pTableNo);
        Translation.SetRange(FieldID, pFieldNo);
        Translation.FilterGroup(0);
        Translation.SetRange(Code, pCode);
        PAGE.RunModal(0, Translation);
    end;

    [Scope('OnPrem')]
    procedure SetTranslation(pTableNo: Integer; pFieldNo: Integer; pCode: Code[20]; pLanguageCode: Code[10]; pTranslation: Text[250]): Text[250]
    begin

        if not Translation.Get(pTableNo, pFieldNo, pCode, pLanguageCode) then begin
            Translation.TableID := pTableNo;
            Translation.FieldID := pFieldNo;
            Translation.Code := pCode;
            Translation.Language := pLanguageCode;
            Translation.Description := pTranslation;
            Translation.Insert(true);
        end else
            if pTranslation = '' then
                Translation.Delete(true)
            else begin
                Translation.Description := pTranslation;
                Translation.Modify(true);
            end;
    end;
}

