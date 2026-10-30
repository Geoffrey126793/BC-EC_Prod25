page 8001312 "Statistic sort card"
{
    // //STATSEXPLORER STATSEXPLORER 20/01/00 Statistic sort card

    Caption = 'Statistic sort card';
    PageType = Card;
    SourceTable = "Statistic sort criteria";
    SourceTableView = WHERE(Type = FILTER("Tri statistique"));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                group(Control1100287040)
                {
                    ShowCaption = false;
                    field("Code"; Code)
                    {
                    }
                    field(Description; Description)
                    {
                    }
                }
                group("Sort N°1")
                {
                    Caption = 'Sort N°1';
                    field(c1stsortlevel; wSortLevel1)
                    {
                        Caption = '1st sort level';

                        trigger OnDrillDown()
                        begin
                            if (fOnDrillDown(wSortLevel1, "1st sort level")) then begin
                                Validate("1st sort level", wSortLevel1);
                                CurrPage.Update(true);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            Validate("1st sort level", wSortLevel1);
                        end;
                    }
                    field("Sort 1 : start pos."; "Sort 1 : start pos.")
                    {
                        BlankZero = true;
                    }
                    field("Sort 1 : length"; "Sort 1 : length")
                    {
                        BlankZero = true;
                    }
                    field("Sort 1 : skip page"; "Sort 1 : skip page")
                    {
                    }
                    field("Sort 1 : line before total"; "Sort 1 : line before total")
                    {
                    }
                    field("Sort 1 : line after total"; "Sort 1 : line after total")
                    {
                    }
                }
                group("Sort N°2")
                {
                    Caption = 'Sort N°2';
                    field(c2ndsortlevel; wSortLevel2)
                    {
                        Caption = '2nd sort level';

                        trigger OnDrillDown()
                        begin
                            if (fOnDrillDown(wSortLevel2, "2nd sort level")) then begin
                                Validate("2nd sort level", wSortLevel2);
                                CurrPage.Update(true);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            Validate("2nd sort level", wSortLevel2);
                        end;
                    }
                    field("Sort 2 : start pos."; "Sort 2 : start pos.")
                    {
                        BlankZero = true;
                    }
                    field("Sort 2 : length"; "Sort 2 : length")
                    {
                        BlankZero = true;
                    }
                    field("Sort 2 : skip page"; "Sort 2 : skip page")
                    {
                    }
                    field("Sort 2 : line before total"; "Sort 2 : line before total")
                    {
                    }
                    field("Sort 2 : line after total"; "Sort 2 : line after total")
                    {
                    }
                }
                group("Sort N°3")
                {
                    Caption = 'Sort N°3';
                    field(c3rdsortlevel; wSortLevel3)
                    {
                        Caption = '3rd sort level';

                        trigger OnDrillDown()
                        begin
                            if (fOnDrillDown(wSortLevel3, "3rd sort level")) then begin
                                Validate("3rd sort level", wSortLevel3);
                                CurrPage.Update(true);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            Validate("3rd sort level", wSortLevel3);
                        end;
                    }
                    field("Sort 3 : start pos."; "Sort 3 : start pos.")
                    {
                        BlankZero = true;
                    }
                    field("Sort 3 : length"; "Sort 3 : length")
                    {
                        BlankZero = true;
                    }
                    field("Sort 3 : skip page"; "Sort 3 : skip page")
                    {
                    }
                    field("Sort 3 : line before total"; "Sort 3 : line before total")
                    {
                    }
                    field("Sort 3 : line after total"; "Sort 3 : line after total")
                    {
                    }
                }
                group("Sort N°4")
                {
                    Caption = 'Sort N°4';
                    field(c4thsortlevel; wSortLevel4)
                    {
                        Caption = '4th sort level';

                        trigger OnDrillDown()
                        begin
                            if (fOnDrillDown(wSortLevel4, "4th sort level")) then begin
                                Validate("4th sort level", wSortLevel4);
                                CurrPage.Update(true);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            Validate("4th sort level", wSortLevel4);
                        end;
                    }
                    field("Sort 4 : start pos."; "Sort 4 : start pos.")
                    {
                        BlankZero = true;
                    }
                    field("Sort 4 : length"; "Sort 4 : length")
                    {
                        BlankZero = true;
                    }
                    field("Sort 4 : skip page"; "Sort 4 : skip page")
                    {
                    }
                    field("Sort 4 : line before total"; "Sort 4 : line before total")
                    {
                    }
                    field("Sort 4 : line after total"; "Sort 4 : line after total")
                    {
                    }
                }
                group("Sort N°5")
                {
                    Caption = 'Sort N°5';
                    field(c5thsortlevel; wSortLevel5)
                    {
                        Caption = '5th sort level';

                        trigger OnDrillDown()
                        begin
                            if (fOnDrillDown(wSortLevel5, "5th sort level")) then begin
                                Validate("5th sort level", wSortLevel5);
                                CurrPage.Update(true);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            Validate("5th sort level", wSortLevel5);
                        end;
                    }
                    field("Sort 5 : start pos."; "Sort 5 : start pos.")
                    {
                        BlankZero = true;
                    }
                    field("Sort 5 : length"; "Sort 5 : length")
                    {
                        BlankZero = true;
                    }
                    field("Sort 5 : skip page"; "Sort 5 : skip page")
                    {
                    }
                    field("Sort 5 : line before total"; "Sort 5 : line before total")
                    {
                    }
                    field("Sort 5 : line after total"; "Sort 5 : line after total")
                    {
                    }
                }
                group("Sort N°6")
                {
                    Caption = 'Sort N°6';
                    field(c6thsortlevel; wSortLevel6)
                    {
                        Caption = '6th sort level';

                        trigger OnDrillDown()
                        begin
                            if (fOnDrillDown(wSortLevel6, "6th sort level")) then begin
                                Validate("6th sort level", wSortLevel6);
                                CurrPage.Update(true);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            Validate("6th sort level", wSortLevel6);
                        end;
                    }
                    field("Sort 6 : start pos."; "Sort 6 : start pos.")
                    {
                        BlankZero = true;
                    }
                    field("Sort 6 : length"; "Sort 6 : length")
                    {
                        BlankZero = true;
                    }
                    field("Sort 6 : skip page"; "Sort 6 : skip page")
                    {
                    }
                    field("Sort 6 : line before total"; "Sort 6 : line before total")
                    {
                    }
                    field("Sort 6 : line after total"; "Sort 6 : line after total")
                    {
                    }
                }
                group("Sort N°7")
                {
                    Caption = 'Sort N°7';
                    field(c7thsortlevel; wSortLevel7)
                    {
                        Caption = '7th sort level';

                        trigger OnDrillDown()
                        begin
                            if (fOnDrillDown(wSortLevel7, "7th sort level")) then begin
                                Validate("7th sort level", wSortLevel7);
                                CurrPage.Update(true);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            Validate("7th sort level", wSortLevel7);
                        end;
                    }
                    field("Sort 7 : start pos."; "Sort 7 : start pos.")
                    {
                        BlankZero = true;
                    }
                    field("Sort 7 : length"; "Sort 7 : length")
                    {
                        BlankZero = true;
                    }
                    field("Sort 7 : skip page"; "Sort 7 : skip page")
                    {
                    }
                    field("Sort 7 : line before total"; "Sort 7 : line before total")
                    {
                    }
                    field("Sort 7 : line after total"; "Sort 7 : line after total")
                    {
                    }
                }
                group("Sort N°8")
                {
                    Caption = 'Sort N°8';
                    field(c8thsortlevel; wSortLevel8)
                    {
                        Caption = '8th sort level';

                        trigger OnDrillDown()
                        begin
                            if (fOnDrillDown(wSortLevel8, "8th sort level")) then begin
                                Validate("8th sort level", wSortLevel8);
                                CurrPage.Update(true);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            Validate("8th sort level", wSortLevel8);
                        end;
                    }
                    field("Sort 8 : start pos."; "Sort 8 : start pos.")
                    {
                        BlankZero = true;
                    }
                    field("Sort 8 : length"; "Sort 8 : length")
                    {
                        BlankZero = true;
                    }
                    field("Sort 8 : skip page"; "Sort 8 : skip page")
                    {
                    }
                    field("Sort 8 : line before total"; "Sort 8 : line before total")
                    {
                    }
                    field("Sort 8 : line after total"; "Sort 8 : line after total")
                    {
                    }
                }
                group("Sort N°9")
                {
                    Caption = 'Sort N°9';
                    field(c9thsortlevel; wSortLevel9)
                    {
                        Caption = '9th sort level';

                        trigger OnDrillDown()
                        begin
                            if (fOnDrillDown(wSortLevel9, "9th sort level")) then begin
                                Validate("9th sort level", wSortLevel9);
                                CurrPage.Update(true);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            Validate("9th sort level", wSortLevel9);
                        end;
                    }
                    field("Sort 9 : start pos."; "Sort 9 : start pos.")
                    {
                        BlankZero = true;
                    }
                    field("Sort 9 : length"; "Sort 9 : length")
                    {
                        BlankZero = true;
                    }
                    field("Sort 9 : skip page"; "Sort 9 : skip page")
                    {
                    }
                    field("Sort 9 : line before total"; "Sort 9 : line before total")
                    {
                    }
                    field("Sort 9 : line after total"; "Sort 9 : line after total")
                    {
                    }
                }
                group("Sort N°10")
                {
                    Caption = 'Sort N°10';
                    field(c10thsortlevel; wSortLevel10)
                    {
                        Caption = '10th sort level';

                        trigger OnDrillDown()
                        begin
                            if (fOnDrillDown(wSortLevel10, "10th sort level")) then begin
                                Validate("10th sort level", wSortLevel10);
                                CurrPage.Update(true);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            Validate("10th sort level", wSortLevel10);
                        end;
                    }
                    field("Sort 10 : start pos."; "Sort 10 : start pos.")
                    {
                        BlankZero = true;
                    }
                    field("Sort 10 : length"; "Sort 10 : length")
                    {
                        BlankZero = true;
                    }
                    field("Sort 10 : skip page"; "Sort 10 : skip page")
                    {
                    }
                    field("Sort 10 : line before total"; "Sort 10 : line before total")
                    {
                    }
                    field("Sort 10 : line after total"; "Sort 10 : line after total")
                    {
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        fSetSortLevel();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetRange(Code);
        fSetSortLevel();
    end;

    trigger OnOpenPage()
    begin
        SetRange(Code);
    end;

    var
        wStatTools: Codeunit "StatsExplorer, Tools";
        wSortLevel1: Text[30];
        wSortLevel2: Text[30];
        wSortLevel3: Text[30];
        wSortLevel4: Text[30];
        wSortLevel5: Text[30];
        wSortLevel6: Text[30];
        wSortLevel7: Text[30];
        wSortLevel8: Text[30];
        wSortLevel9: Text[30];
        wSortLevel10: Text[30];

    [Scope('OnPrem')]
    procedure fSetSortLevel()
    begin
        //RTC - 2009
        /*
        wStatTools.GetTranslateCaption(wStatTools.GetStatCriterFieldNo(0,"1st sort level"),0, wSortLevel1);
        wStatTools.GetTranslateCaption(wStatTools.GetStatCriterFieldNo(0,"2nd sort level"),0, wSortLevel2);
        wStatTools.GetTranslateCaption(wStatTools.GetStatCriterFieldNo(0,"3rd sort level"),0, wSortLevel3);
        wStatTools.GetTranslateCaption(wStatTools.GetStatCriterFieldNo(0,"4th sort level"),0, wSortLevel4);
        wStatTools.GetTranslateCaption(wStatTools.GetStatCriterFieldNo(0,"5th sort level"),0, wSortLevel5);
        wStatTools.GetTranslateCaption(wStatTools.GetStatCriterFieldNo(0,"6th sort level"),0, wSortLevel6);
        wStatTools.GetTranslateCaption(wStatTools.GetStatCriterFieldNo(0,"7th sort level"),0, wSortLevel7);
        wStatTools.GetTranslateCaption(wStatTools.GetStatCriterFieldNo(0,"8th sort level"),0, wSortLevel8);
        wStatTools.GetTranslateCaption(wStatTools.GetStatCriterFieldNo(0,"9th sort level"),0, wSortLevel9);
        wStatTools.GetTranslateCaption(wStatTools.GetStatCriterFieldNo(0,"10th sort level"),0, wSortLevel10);
        */
        //RTC - 2009//
        fCheckCaption("1st sort level", wSortLevel1);
        fCheckCaption("2nd sort level", wSortLevel2);
        fCheckCaption("3rd sort level", wSortLevel3);
        fCheckCaption("4th sort level", wSortLevel4);
        fCheckCaption("5th sort level", wSortLevel5);
        fCheckCaption("6th sort level", wSortLevel6);
        fCheckCaption("7th sort level", wSortLevel7);
        fCheckCaption("8th sort level", wSortLevel8);
        fCheckCaption("9th sort level", wSortLevel9);
        fCheckCaption("10th sort level", wSortLevel10);

    end;

    [Scope('OnPrem')]
    procedure fOnDrillDown(var pSortLevel: Text[30]; pSortCriteria: Text[30]) Retour: Boolean
    var
        lStatCriteria: Record "Statistic criteria";
        lStatForm: Page "Statistic criteria";
    begin
        Retour := false;
        if (lStatCriteria.Get(lStatCriteria.Type::"Sort criteria", pSortCriteria)) then;
        lStatCriteria.SetRange(Type, lStatCriteria.Type::"Sort criteria");
        lStatForm.SetTableView(lStatCriteria);
        lStatForm.SetRecord(lStatCriteria);
        lStatForm.LookupMode(true);
        if (lStatForm.RunModal = ACTION::LookupOK) then begin
            lStatForm.GetRecord(lStatCriteria);
            pSortLevel := lStatCriteria."Field name";
            Retour := true;
        end;
    end;

    [Scope('OnPrem')]
    procedure fCheckCaption(pFieldValue: Text[30]; var pVariableValue: Text[30])
    begin
        //#7919\\
        pVariableValue := '';
        wStatTools.GetTranslateCaption(wStatTools.GetStatCriterFieldNo(0, pFieldValue), 0, pVariableValue);
        if (pVariableValue = '') and (pFieldValue <> '') then
            pVariableValue := pFieldValue
        else
            if (pFieldValue = '') then
                pVariableValue := '';
    end;


}

