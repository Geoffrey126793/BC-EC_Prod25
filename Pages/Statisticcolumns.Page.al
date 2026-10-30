page 8001307 "Statistic columns"
{
    // //STATSEXPLORER STATSEXPLORER 01/01/00 Statistic columns

    AutoSplitKey = true;
    Caption = 'Statistic columns';
    DelayedInsert = true;
    PageType = Worksheet;
    SourceTable = "Statistic column";

    layout
    {
        area(content)
        {
            group(Control1100287000)
            {
                ShowCaption = false;
                fixed(Control1906247201)
                {
                    ShowCaption = false;
                    group("Code")
                    {
                        Caption = 'Code';
                        field(CodeCourant; CodeCourant)
                        {
                            Caption = 'Slyle name';
                            Editable = false;
                            TableRelation = "Column style name".Code;

                            trigger OnValidate()
                            begin
                                CodeCourantOnAfterValidate;
                            end;
                        }
                    }
                    group(Description)
                    {
                        Caption = 'Description';
                        field(NomCodeCourant; NomCodeCourant)
                        {
                            Editable = false;
                        }
                    }
                }
                field(Text001; Text001)
                {
                    Visible = false;
                }
            }
            repeater(Control1)
            {
                ShowCaption = false;
                field("Column No."; "Column No.")
                {
                }
                field("Entry Type"; "Entry Type")
                {
                }
                field("Reverse sign"; "Reverse sign")
                {
                }
                field("Print column"; "Print column")
                {
                }
                field("Rounding Factor"; "Rounding Factor")
                {
                }
                field("Process from date"; "Process from date")
                {
                }
                field("Process to date"; "Process to date")
                {
                }
                field(Formula; Formula)
                {
                }
                field(Control26; "Additional filter")
                {
                }
                field("New line"; "New line")
                {
                    Visible = false;
                }
                field("Line title"; "Line title")
                {
                    Visible = false;
                }
                field("Column Layout Name"; "Column Layout Name")
                {
                }
                field("Column type"; "Column type")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Column")
            {
                Caption = '&Column';
                action("Additional filter")
                {
                    Caption = 'Additional filter';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Statistic column filter card";
                    RunPageLink = Code = FIELD(Code),
                                  "Line No." = FIELD("Line No.");
                    ShortCutKey = 'Shift+F5';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if (CodeCourant = '') and FindFirst then
            CodeCourant := Code;
        SetRange(Code, CodeCourant);
        RechercherNom;
        CurrPage.Update(false);
    end;

    var
        NomPresentation: Record "Column style name";
        CodeCourant: Code[10];
        NomCodeCourant: Text[80];
        Text001: Label ' ';

    [Scope('OnPrem')]
    procedure SelCode()
    begin
    end;

    [Scope('OnPrem')]
    procedure RechercherNom()
    begin
        if NomPresentation.Get(CodeCourant) then
            NomCodeCourant := NomPresentation.Description
        else
            NomCodeCourant := '';
    end;

    local procedure CodeCourantOnAfterValidate()
    begin
        SetRange(Code, CodeCourant);
        RechercherNom;
        CurrPage.Update(false);
    end;
}

