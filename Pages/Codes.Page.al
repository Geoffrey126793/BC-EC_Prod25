page 8001400 Codes
{
    Caption = 'Codes';
    PageType = List;
    SourceTable = "Code";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Code)
                {
                }
                field(Description; Description)
                {
                }
                field(Poids; Poids)
                {
                }
                field(Caption; Caption)
                {
                    Caption = 'Légende';

                    trigger OnAssistEdit()
                    begin
                        //TRANSLATION
                        RecRef.GetTable(Rec);
                        TranslationMgt.ShowTranslation(RecRef.Number, 0, Code);
                        //TRANSLATION//
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        //TRANSLATION
                        RecRef.GetTable(Rec);
                        TranslationMgt.ShowTranslation(RecRef.Number, 0, Code);
                        //TRANSLATION//
                    end;

                    trigger OnValidate()
                    begin
                        //TRANSLATION
                        RecRef.GetTable(Rec);
                        TranslationMgt.SetTranslation(RecRef.Number, 0, Code, '', Caption)
                        //TRANSLATION//
                    end;
                }
                field("Field No"; "Field No")
                {
                    Visible = false;
                }
                field("Table No"; "Table No")
                {
                    Visible = false;
                }
                field(Description2; Description2)
                {
                }
                field("Plastique non recyclable"; "Plastique non recyclable")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        RecRef.GetTable(Rec);
        //Caption := TranslationMgt.GetTranslation(RecRef.NUMBER,0,Code,'',Description);
        Caption := Description;
    end;

    var
        TranslationMgt: Codeunit "Translation Management";
        Caption: Text[250];
        RecRef: RecordRef;
}

