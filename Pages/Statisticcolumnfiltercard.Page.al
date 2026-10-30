page 8001308 "Statistic column filter card"
{
    // TRS-2009 XPE 02/10/09
    // //STATSEXPLORER STATSEXPLORER 01/01/00 Statistic column filter card

    Caption = 'Statistic column filter card';
    DataCaptionExpression = StrSubstNo('%1 - %2', Code, Colonne."Column No.");
    DelayedInsert = true;
    PageType = Card;
    SourceTable = "Statistic column filter";

    layout
    {
        area(content)
        {
            group("Inventoty filters")
            {
                Caption = 'Inventoty filters';
                field(Type; Type)
                {
                }
                field("No."; "No.")
                {
                }
                field("Source Type"; "Source Type")
                {
                }
                field("Source No."; "Source No.")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Salespers./Purch. Code"; "Salespers./Purch. Code")
                {
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                }
                field("Item Charge No."; "Item Charge No.")
                {
                }
                field("Variant Code"; "Variant Code")
                {
                }
                field("Manufacturer Code"; "Manufacturer Code")
                {
                }
                field("Item Category Code"; "Item Category Code")
                {
                }
                field("Product Group Code"; "Product Group Code")
                {
                }
                field(Company; Company)
                {
                }
                field("Inventory Posting Group"; "Inventory Posting Group")
                {
                }
                field("Source Posting Group"; "Source Posting Group")
                {
                }
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                {
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                }
                field("Service Item Group"; "Service Item Group")
                {
                }
                field("Reason Code"; "Reason Code")
                {
                }
                field("Return Reason Code"; "Return Reason Code")
                {
                }
                field("Country Code"; "Country Code")
                {
                }
                field("Business Unit Code"; "Business Unit Code")
                {
                }
                field("Consol. Debit Acc."; "Consol. Debit Acc.")
                {
                }
                field("Consol. Credit Acc."; "Consol. Credit Acc.")
                {
                }
                field("Back disc./commission rule No."; "Back disc./commission rule No.")
                {
                    Visible = BackdisccommissionruleNoVisibl;
                }
                field("Campaign No."; "Campaign No.")
                {
                }
            }
            group("Date filters")
            {
                Caption = 'Date filters';
                field("Period Length"; "Period Length")
                {
                }
                field(Year; Year)
                {
                }
                field("Half Year"; "Half Year")
                {
                }
                field(Quarter; Quarter)
                {
                }
                field(Month; Month)
                {
                }
                field(Week; Week)
                {
                }
                field("Week Day"; "Week Day")
                {
                }
                field("Fiscal year closing date"; "Fiscal year closing date")
                {
                }
            }
            group("Job filters")
            {
                Caption = 'Job filters';
                group(General)
                {
                    Caption = 'General';
                    field("Job No."; "Job No.")
                    {
                    }
                    field("Phase Code"; "Phase Code")
                    {
                    }
                    field("Work Type Code"; "Work Type Code")
                    {
                    }
                    field("Job Posting Group"; "Job Posting Group")
                    {
                    }
                    field("Resource Group No."; "Resource Group No.")
                    {
                    }
                    field("Person Responsible"; "Person Responsible")
                    {
                    }
                }
                group("Job criteria")
                {
                    Caption = 'Job criteria';
                    field("Job criteria 1"; "Job criteria 1")
                    {
                        Visible = "Job criteria 1Visible";
                    }
                    field("Job criteria 2"; "Job criteria 2")
                    {
                        Visible = "Job criteria 2Visible";
                    }
                    field("Job criteria 3"; "Job criteria 3")
                    {
                        Visible = "Job criteria 3Visible";
                    }
                    field("Job criteria 4"; "Job criteria 4")
                    {
                        Visible = "Job criteria 4Visible";
                    }
                    field("Job criteria 5"; "Job criteria 5")
                    {
                        Visible = "Job criteria 5Visible";
                    }
                    field("Job criteria 6"; "Job criteria 6")
                    {
                        Visible = "Job criteria 6Visible";
                    }
                    field("Job criteria 7"; "Job criteria 7")
                    {
                        Visible = "Job criteria 7Visible";
                    }
                    field("Job criteria 8"; "Job criteria 8")
                    {
                        Visible = "Job criteria 8Visible";
                    }
                    field("Job criteria 9"; "Job criteria 9")
                    {
                        Visible = "Job criteria 9Visible";
                    }
                    field("Job criteria 10"; "Job criteria 10")
                    {
                        Visible = "Job criteria 10Visible";
                    }
                }
            }
            group("Item filters")
            {
                Caption = 'Item filters';
                field("Item criteria 1"; "Item criteria 1")
                {
                    Visible = "Item criteria 1Visible";
                }
                field("Item criteria 2"; "Item criteria 2")
                {
                    Visible = "Item criteria 2Visible";
                }
                field("Item criteria 3"; "Item criteria 3")
                {
                    Visible = "Item criteria 3Visible";
                }
                field("Item criteria 4"; "Item criteria 4")
                {
                    Visible = "Item criteria 4Visible";
                }
                field("Item criteria 5"; "Item criteria 5")
                {
                    Visible = "Item criteria 5Visible";
                }
                field("Item criteria 6"; "Item criteria 6")
                {
                    Visible = "Item criteria 6Visible";
                }
                field("Item criteria 7"; "Item criteria 7")
                {
                    Visible = "Item criteria 7Visible";
                }
                field("Item criteria 8"; "Item criteria 8")
                {
                    Visible = "Item criteria 8Visible";
                }
                field("Item criteria 9"; "Item criteria 9")
                {
                    Visible = "Item criteria 9Visible";
                }
                field("Item criteria 10"; "Item criteria 10")
                {
                    Visible = "Item criteria 10Visible";
                }
            }
            group("Customer filters")
            {
                Caption = 'Customer filters';
                field("Customer criteria 1"; "Customer criteria 1")
                {
                    Visible = "Customer criteria 1Visible";
                }
                field("Customer criteria 2"; "Customer criteria 2")
                {
                    Visible = "Customer criteria 2Visible";
                }
                field("Customer criteria 3"; "Customer criteria 3")
                {
                    Visible = "Customer criteria 3Visible";
                }
                field("Customer criteria 4"; "Customer criteria 4")
                {
                    Visible = "Customer criteria 4Visible";
                }
                field("Customer criteria 5"; "Customer criteria 5")
                {
                    Visible = "Customer criteria 5Visible";
                }
                field("Customer criteria 6"; "Customer criteria 6")
                {
                    Visible = "Customer criteria 6Visible";
                }
                field("Customer criteria 7"; "Customer criteria 7")
                {
                    Visible = "Customer criteria 7Visible";
                }
                field("Customer criteria 8"; "Customer criteria 8")
                {
                    Visible = "Customer criteria 8Visible";
                }
                field("Customer criteria 9"; "Customer criteria 9")
                {
                    Visible = "Customer criteria 9Visible";
                }
                field("Customer criteria 10"; "Customer criteria 10")
                {
                    Visible = "Customer criteria 10Visible";
                }
            }
            group(Dimensions)
            {
                Caption = 'Dimensions';
                field("Dimension 1 Value Code"; "Dimension 1 Value Code")
                {
                    Visible = "Dimension 1 Value CodeVisible";
                }
                field("Dimension 2 Value Code"; "Dimension 2 Value Code")
                {
                    Visible = "Dimension 2 Value CodeVisible";
                }
                field("Dimension 3 Value Code"; "Dimension 3 Value Code")
                {
                    Visible = "Dimension 3 Value CodeVisible";
                }
                field("Dimension 4 Value Code"; "Dimension 4 Value Code")
                {
                    Visible = "Dimension 4 Value CodeVisible";
                }
                field("Dimension 5 Value Code"; "Dimension 5 Value Code")
                {
                    Visible = "Dimension 5 Value CodeVisible";
                }
                field("Dimension 6 Value Code"; "Dimension 6 Value Code")
                {
                    Visible = "Dimension 6 Value CodeVisible";
                }
                field("Dimension 7 Value Code"; "Dimension 7 Value Code")
                {
                    Visible = "Dimension 7 Value CodeVisible";
                }
                field("Dimension 8 Value Code"; "Dimension 8 Value Code")
                {
                    Visible = "Dimension 8 Value CodeVisible";
                }
                field("Dimension 9 Value Code"; "Dimension 9 Value Code")
                {
                    Visible = "Dimension 9 Value CodeVisible";
                }
                field("Dimension 10 Value Code"; "Dimension 10 Value Code")
                {
                    Visible = "Dimension 10 Value CodeVisible";
                }
                field("Dimension 11 Value Code"; "Dimension 11 Value Code")
                {
                    Visible = "Dimension 11 Value CodeVisible";
                }
                field("Dimension 12 Value Code"; "Dimension 12 Value Code")
                {
                    Visible = "Dimension 12 Value CodeVisible";
                }
                field("Dimension 13 Value Code"; "Dimension 13 Value Code")
                {
                    Visible = "Dimension 13 Value CodeVisible";
                }
                field("Dimension 14 Value Code"; "Dimension 14 Value Code")
                {
                    Visible = "Dimension 14 Value CodeVisible";
                }
                field("Dimension 15 Value Code"; "Dimension 15 Value Code")
                {
                    Visible = "Dimension 15 Value CodeVisible";
                }
                field("Dimension 16 Value Code"; "Dimension 16 Value Code")
                {
                    Visible = "Dimension 16 Value CodeVisible";
                }
                field("Dimension 17 Value Code"; "Dimension 17 Value Code")
                {
                    Visible = "Dimension 17 Value CodeVisible";
                }
                field("Dimension 18 Value Code"; "Dimension 18 Value Code")
                {
                    Visible = "Dimension 18 Value CodeVisible";
                }
                field("Dimension 19 Value Code"; "Dimension 19 Value Code")
                {
                    Visible = "Dimension 19 Value CodeVisible";
                }
                field("Dimension 20 Value Code"; "Dimension 20 Value Code")
                {
                    Visible = "Dimension 20 Value CodeVisible";
                }
            }
            group("Additional filters")
            {
                Caption = 'Additional filters';
                group("Free field")
                {
                    Caption = 'Free field';
                    field("Free field 1"; "Free field 1")
                    {
                        Visible = "Free field 1Visible";
                    }
                    field("Free field 2"; "Free field 2")
                    {
                        Visible = "Free field 2Visible";
                    }
                    field("Free field 3"; "Free field 3")
                    {
                        Visible = "Free field 3Visible";
                    }
                    field("Free field 4"; "Free field 4")
                    {
                        Visible = "Free field 4Visible";
                    }
                    field("Free field 5"; "Free field 5")
                    {
                        Visible = "Free field 5Visible";
                    }
                    field("Free field 6"; "Free field 6")
                    {
                        Visible = "Free field 6Visible";
                    }
                    field("Free field 7"; "Free field 7")
                    {
                        Visible = "Free field 7Visible";
                    }
                    field("Free field 8"; "Free field 8")
                    {
                        Visible = "Free field 8Visible";
                    }
                    field("Free field 9"; "Free field 9")
                    {
                        Visible = "Free field 9Visible";
                    }
                    field("Free field 10"; "Free field 10")
                    {
                        Visible = "Free field 10Visible";
                    }
                }
                group("Free Date / Free Boolean")
                {
                    Caption = 'Free Date / Free Boolean';
                    field("Free date 1"; "Free date 1")
                    {
                        Visible = "Free date 1Visible";
                    }
                    field("Free date 2"; "Free date 2")
                    {
                        Visible = "Free date 2Visible";
                    }
                    field("Free date 3"; "Free date 3")
                    {
                        Visible = "Free date 3Visible";
                    }
                    field("Free date 4"; "Free date 4")
                    {
                        Visible = "Free date 4Visible";
                    }
                    field("Free date 5"; "Free date 5")
                    {
                        Visible = "Free date 5Visible";
                    }
                    field("Free boolean 1"; "Free boolean 1")
                    {
                        Visible = "Free boolean 1Visible";
                    }
                    field("Free boolean 2"; "Free boolean 2")
                    {
                        Visible = "Free boolean 2Visible";
                    }
                    field("Free boolean 3"; "Free boolean 3")
                    {
                        Visible = "Free boolean 3Visible";
                    }
                    field("Free boolean 4"; "Free boolean 4")
                    {
                        Visible = "Free boolean 4Visible";
                    }
                    field("Free boolean 5"; "Free boolean 5")
                    {
                        Visible = "Free boolean 5Visible";
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
        AfficherCriteres;
    end;

    trigger OnClosePage()
    var
        lRecordRef: RecordRef;
        i: Integer;
        lFieldType: Option TableFilter,RecordID,Text,Date,Time,DateFormula,Decimal,Binary,BLOB,Boolean,"Integer","Code",Option,BigInteger,Duration,GUID,DateTime;
        lFieldRef: FieldRef;
        lFieldFill: Boolean;
        lValue: Text[30];
    begin
        //#7509
        lFieldFill := false;
        lRecordRef.GetTable(Rec);
        for i := 4 to lRecordRef.FieldCount do begin
            lFieldRef := lRecordRef.FieldIndex(i);
            GetFieldType(lRecordRef.Number, lFieldRef.Number, lFieldType);
            case lFieldType of
                lFieldType::Text:
                    begin
                        Evaluate(lValue, Format(lFieldRef.Value));
                        if lValue <> '' then
                            lFieldFill := true;
                    end;
                lFieldType::Option:
                    begin
                        Evaluate(lValue, Format(lFieldRef.Value));
                        if lValue <> '0' then
                            lFieldFill := true;
                    end;
            end;
        end;
        if not lFieldFill then
            if not lRecordRef.IsEmpty then
                Delete;
    end;

    trigger OnInit()
    begin
        BackdisccommissionruleNoVisibl := true;
        "Dimension 20 Value CodeVisible" := true;
        "Dimension 19 Value CodeVisible" := true;
        "Dimension 18 Value CodeVisible" := true;
        "Dimension 17 Value CodeVisible" := true;
        "Dimension 16 Value CodeVisible" := true;
        "Dimension 15 Value CodeVisible" := true;
        "Dimension 14 Value CodeVisible" := true;
        "Dimension 13 Value CodeVisible" := true;
        "Dimension 12 Value CodeVisible" := true;
        "Dimension 11 Value CodeVisible" := true;
        "Dimension 10 Value CodeVisible" := true;
        "Dimension 9 Value CodeVisible" := true;
        "Dimension 8 Value CodeVisible" := true;
        "Dimension 7 Value CodeVisible" := true;
        "Dimension 6 Value CodeVisible" := true;
        "Dimension 5 Value CodeVisible" := true;
        "Dimension 4 Value CodeVisible" := true;
        "Dimension 3 Value CodeVisible" := true;
        "Dimension 2 Value CodeVisible" := true;
        "Dimension 1 Value CodeVisible" := true;
        "Free boolean 5Visible" := true;
        "Free boolean 4Visible" := true;
        "Free boolean 3Visible" := true;
        "Free boolean 2Visible" := true;
        "Free boolean 1Visible" := true;
        "Free date 5Visible" := true;
        "Free date 4Visible" := true;
        "Free date 3Visible" := true;
        "Free date 2Visible" := true;
        "Free date 1Visible" := true;
        "Free field 10Visible" := true;
        "Free field 9Visible" := true;
        "Free field 8Visible" := true;
        "Free field 7Visible" := true;
        "Free field 6Visible" := true;
        "Free field 5Visible" := true;
        "Free field 4Visible" := true;
        "Free field 3Visible" := true;
        "Free field 2Visible" := true;
        "Free field 1Visible" := true;
        "Job criteria 10Visible" := true;
        "Job criteria 9Visible" := true;
        "Job criteria 8Visible" := true;
        "Job criteria 7Visible" := true;
        "Job criteria 6Visible" := true;
        "Job criteria 5Visible" := true;
        "Job criteria 4Visible" := true;
        "Job criteria 3Visible" := true;
        "Job criteria 2Visible" := true;
        "Job criteria 1Visible" := true;
        "Customer criteria 10Visible" := true;
        "Customer criteria 9Visible" := true;
        "Customer criteria 8Visible" := true;
        "Customer criteria 7Visible" := true;
        "Customer criteria 6Visible" := true;
        "Customer criteria 5Visible" := true;
        "Customer criteria 4Visible" := true;
        "Customer criteria 3Visible" := true;
        "Customer criteria 2Visible" := true;
        "Customer criteria 1Visible" := true;
        "Item criteria 10Visible" := true;
        "Item criteria 9Visible" := true;
        "Item criteria 8Visible" := true;
        "Item criteria 7Visible" := true;
        "Item criteria 6Visible" := true;
        "Item criteria 5Visible" := true;
        "Item criteria 4Visible" := true;
        "Item criteria 3Visible" := true;
        "Item criteria 2Visible" := true;
        "Item criteria 1Visible" := true;
    end;

    trigger OnOpenPage()
    begin
        Colonne.Get(Code, "Line No.");
        ParamStatistiques.Get;
        AfficherCriteres;
    end;

    var
        Colonne: Record "Statistic column";
        ParamStatistiques: Record "Statistics setup";

        "Item criteria 1Visible": Boolean;

        "Item criteria 2Visible": Boolean;

        "Item criteria 3Visible": Boolean;

        "Item criteria 4Visible": Boolean;

        "Item criteria 5Visible": Boolean;

        "Item criteria 6Visible": Boolean;

        "Item criteria 7Visible": Boolean;

        "Item criteria 8Visible": Boolean;

        "Item criteria 9Visible": Boolean;

        "Item criteria 10Visible": Boolean;

        "Customer criteria 1Visible": Boolean;

        "Customer criteria 2Visible": Boolean;

        "Customer criteria 3Visible": Boolean;

        "Customer criteria 4Visible": Boolean;

        "Customer criteria 5Visible": Boolean;

        "Customer criteria 6Visible": Boolean;

        "Customer criteria 7Visible": Boolean;

        "Customer criteria 8Visible": Boolean;

        "Customer criteria 9Visible": Boolean;

        "Customer criteria 10Visible": Boolean;

        "Job criteria 1Visible": Boolean;

        "Job criteria 2Visible": Boolean;

        "Job criteria 3Visible": Boolean;

        "Job criteria 4Visible": Boolean;

        "Job criteria 5Visible": Boolean;

        "Job criteria 6Visible": Boolean;

        "Job criteria 7Visible": Boolean;

        "Job criteria 8Visible": Boolean;

        "Job criteria 9Visible": Boolean;

        "Job criteria 10Visible": Boolean;

        "Free field 1Visible": Boolean;

        "Free field 2Visible": Boolean;

        "Free field 3Visible": Boolean;

        "Free field 4Visible": Boolean;

        "Free field 5Visible": Boolean;

        "Free field 6Visible": Boolean;

        "Free field 7Visible": Boolean;

        "Free field 8Visible": Boolean;

        "Free field 9Visible": Boolean;

        "Free field 10Visible": Boolean;

        "Free date 1Visible": Boolean;

        "Free date 2Visible": Boolean;

        "Free date 3Visible": Boolean;

        "Free date 4Visible": Boolean;

        "Free date 5Visible": Boolean;

        "Free boolean 1Visible": Boolean;

        "Free boolean 2Visible": Boolean;

        "Free boolean 3Visible": Boolean;

        "Free boolean 4Visible": Boolean;

        "Free boolean 5Visible": Boolean;

        "Dimension 1 Value CodeVisible": Boolean;

        "Dimension 2 Value CodeVisible": Boolean;

        "Dimension 3 Value CodeVisible": Boolean;

        "Dimension 4 Value CodeVisible": Boolean;

        "Dimension 5 Value CodeVisible": Boolean;

        "Dimension 6 Value CodeVisible": Boolean;

        "Dimension 7 Value CodeVisible": Boolean;

        "Dimension 8 Value CodeVisible": Boolean;

        "Dimension 9 Value CodeVisible": Boolean;

        "Dimension 10 Value CodeVisible": Boolean;

        "Dimension 11 Value CodeVisible": Boolean;

        "Dimension 12 Value CodeVisible": Boolean;

        "Dimension 13 Value CodeVisible": Boolean;

        "Dimension 14 Value CodeVisible": Boolean;

        "Dimension 15 Value CodeVisible": Boolean;

        "Dimension 16 Value CodeVisible": Boolean;

        "Dimension 17 Value CodeVisible": Boolean;

        "Dimension 18 Value CodeVisible": Boolean;

        "Dimension 19 Value CodeVisible": Boolean;

        "Dimension 20 Value CodeVisible": Boolean;

        BackdisccommissionruleNoVisibl: Boolean;

    [Scope('OnPrem')]
    procedure AfficherCriteres()
    var
        "Object": Record "Object";
        lVisible: Boolean;
    begin
        //TRS-2009
        lVisible := ParamStatistiques."Item criteria name 1" <> '';
        "Item criteria 1Visible" := lVisible;
        lVisible := ParamStatistiques."Item criteria name 2" <> '';
        "Item criteria 2Visible" := lVisible;
        lVisible := ParamStatistiques."Item criteria name 3" <> '';
        "Item criteria 3Visible" := lVisible;
        lVisible := ParamStatistiques."Item criteria name 4" <> '';
        "Item criteria 4Visible" := lVisible;
        lVisible := ParamStatistiques."Item criteria name 5" <> '';
        "Item criteria 5Visible" := lVisible;
        lVisible := ParamStatistiques."Item criteria name 6" <> '';
        "Item criteria 6Visible" := lVisible;
        lVisible := ParamStatistiques."Item criteria name 7" <> '';
        "Item criteria 7Visible" := lVisible;
        lVisible := ParamStatistiques."Item criteria name 8" <> '';
        "Item criteria 8Visible" := lVisible;
        lVisible := ParamStatistiques."Item criteria name 9" <> '';
        "Item criteria 9Visible" := lVisible;
        lVisible := ParamStatistiques."Item criteria name 10" <> '';
        "Item criteria 10Visible" := lVisible;
        lVisible := ParamStatistiques."Customer criteria name 1" <> '';
        "Customer criteria 1Visible" := lVisible;
        lVisible := ParamStatistiques."Customer criteria name 2" <> '';
        "Customer criteria 2Visible" := lVisible;
        lVisible := ParamStatistiques."Customer criteria name 3" <> '';
        "Customer criteria 3Visible" := lVisible;
        lVisible := ParamStatistiques."Customer criteria name 4" <> '';
        "Customer criteria 4Visible" := lVisible;
        lVisible := ParamStatistiques."Customer criteria name 5" <> '';
        "Customer criteria 5Visible" := lVisible;
        lVisible := ParamStatistiques."Customer criteria name 6" <> '';
        "Customer criteria 6Visible" := lVisible;
        lVisible := ParamStatistiques."Customer criteria name 7" <> '';
        "Customer criteria 7Visible" := lVisible;
        lVisible := ParamStatistiques."Customer criteria name 8" <> '';
        "Customer criteria 8Visible" := lVisible;
        lVisible := ParamStatistiques."Customer criteria name 9" <> '';
        "Customer criteria 9Visible" := lVisible;
        lVisible := ParamStatistiques."Customer criteria name 10" <> '';
        "Customer criteria 10Visible" := lVisible;
        lVisible := ParamStatistiques."Job criteria name 1" <> '';
        "Job criteria 1Visible" := lVisible;
        lVisible := ParamStatistiques."Job criteria name 2" <> '';
        "Job criteria 2Visible" := lVisible;
        lVisible := ParamStatistiques."Job criteria name 3" <> '';
        "Job criteria 3Visible" := lVisible;
        lVisible := ParamStatistiques."Job criteria name 4" <> '';
        "Job criteria 4Visible" := lVisible;
        lVisible := ParamStatistiques."Job criteria name 5" <> '';
        "Job criteria 5Visible" := lVisible;
        lVisible := ParamStatistiques."Job criteria name 6" <> '';
        "Job criteria 6Visible" := lVisible;
        lVisible := ParamStatistiques."Job criteria name 7" <> '';
        "Job criteria 7Visible" := lVisible;
        lVisible := ParamStatistiques."Job criteria name 8" <> '';
        "Job criteria 8Visible" := lVisible;
        lVisible := ParamStatistiques."Job criteria name 9" <> '';
        "Job criteria 9Visible" := lVisible;
        lVisible := ParamStatistiques."Job criteria name 10" <> '';
        "Job criteria 10Visible" := lVisible;
        lVisible := ParamStatistiques."Free field name 1" <> '';
        "Free field 1Visible" := lVisible;
        lVisible := ParamStatistiques."Free field name 2" <> '';
        "Free field 2Visible" := lVisible;
        lVisible := ParamStatistiques."Free field name 3" <> '';
        "Free field 3Visible" := lVisible;
        lVisible := ParamStatistiques."Free field name 4" <> '';
        "Free field 4Visible" := lVisible;
        lVisible := ParamStatistiques."Free field name 5" <> '';
        "Free field 5Visible" := lVisible;
        lVisible := ParamStatistiques."Free field name 6" <> '';
        "Free field 6Visible" := lVisible;
        lVisible := ParamStatistiques."Free field name 7" <> '';
        "Free field 7Visible" := lVisible;
        lVisible := ParamStatistiques."Free field name 8" <> '';
        "Free field 8Visible" := lVisible;
        lVisible := ParamStatistiques."Free field name 9" <> '';
        "Free field 9Visible" := lVisible;
        lVisible := ParamStatistiques."Free field name 10" <> '';
        "Free field 10Visible" := lVisible;
        lVisible := ParamStatistiques."Free date name 1" <> '';
        "Free date 1Visible" := lVisible;
        lVisible := ParamStatistiques."Free date name 2" <> '';
        "Free date 2Visible" := lVisible;
        lVisible := ParamStatistiques."Free date name 3" <> '';
        "Free date 3Visible" := lVisible;
        lVisible := ParamStatistiques."Free date name 4" <> '';
        "Free date 4Visible" := lVisible;
        lVisible := ParamStatistiques."Free date name 5" <> '';
        "Free date 5Visible" := lVisible;
        lVisible := ParamStatistiques."Free check name 1" <> '';
        "Free boolean 1Visible" := lVisible;
        lVisible := ParamStatistiques."Free check name 2" <> '';
        "Free boolean 2Visible" := lVisible;
        lVisible := ParamStatistiques."Free check name 3" <> '';
        "Free boolean 3Visible" := lVisible;
        lVisible := ParamStatistiques."Free check name 4" <> '';
        "Free boolean 4Visible" := lVisible;
        lVisible := ParamStatistiques."Free check name 5" <> '';
        "Free boolean 5Visible" := lVisible;
        lVisible := ParamStatistiques."Dimension 1 Code" <> '';
        "Dimension 1 Value CodeVisible" := lVisible;
        lVisible := ParamStatistiques."Dimension 2 Code" <> '';
        "Dimension 2 Value CodeVisible" := lVisible;
        lVisible := ParamStatistiques."Dimension 3 Code" <> '';
        "Dimension 3 Value CodeVisible" := lVisible;
        lVisible := ParamStatistiques."Dimension 4 Code" <> '';
        "Dimension 4 Value CodeVisible" := lVisible;
        lVisible := ParamStatistiques."Dimension 5 Code" <> '';
        "Dimension 5 Value CodeVisible" := lVisible;
        lVisible := ParamStatistiques."Dimension 6 Code" <> '';
        "Dimension 6 Value CodeVisible" := lVisible;
        lVisible := ParamStatistiques."Dimension 7 Code" <> '';
        "Dimension 7 Value CodeVisible" := lVisible;
        lVisible := ParamStatistiques."Dimension 8 Code" <> '';
        "Dimension 8 Value CodeVisible" := lVisible;
        lVisible := ParamStatistiques."Dimension 9 Code" <> '';
        "Dimension 9 Value CodeVisible" := lVisible;
        lVisible := ParamStatistiques."Dimension 10 Code" <> '';
        "Dimension 10 Value CodeVisible" := lVisible;
        lVisible := ParamStatistiques."Dimension 11 Code" <> '';
        "Dimension 11 Value CodeVisible" := lVisible;
        lVisible := ParamStatistiques."Dimension 12 Code" <> '';
        "Dimension 12 Value CodeVisible" := lVisible;
        lVisible := ParamStatistiques."Dimension 13 Code" <> '';
        "Dimension 13 Value CodeVisible" := lVisible;
        lVisible := ParamStatistiques."Dimension 14 Code" <> '';
        "Dimension 14 Value CodeVisible" := lVisible;
        lVisible := ParamStatistiques."Dimension 15 Code" <> '';
        "Dimension 15 Value CodeVisible" := lVisible;
        lVisible := ParamStatistiques."Dimension 16 Code" <> '';
        "Dimension 16 Value CodeVisible" := lVisible;
        lVisible := ParamStatistiques."Dimension 17 Code" <> '';
        "Dimension 17 Value CodeVisible" := lVisible;
        lVisible := ParamStatistiques."Dimension 18 Code" <> '';
        "Dimension 18 Value CodeVisible" := lVisible;
        lVisible := ParamStatistiques."Dimension 19 Code" <> '';
        "Dimension 19 Value CodeVisible" := lVisible;
        lVisible := ParamStatistiques."Dimension 20 Code" <> '';
        "Dimension 20 Value CodeVisible" := lVisible;
        //TRS-2009//
        if not Object.Get(Object.Type::Codeunit, '', 8001501) then
            BackdisccommissionruleNoVisibl := false;
    end;

    [Scope('OnPrem')]
    procedure GetFieldType(TableNo: Integer; FieldNo: Integer; var FieldType: Option TableFilter,RecordID,Text,Date,Time,DateFormula,Decimal,Binary,BLOB,Boolean,"Integer","Code",Option,BigInteger,Duration,GUID,DateTime)
    var
        "Fields": Record "Field";
    begin
        Fields.Get(TableNo, FieldNo);

        case Fields.Type of
            Fields.Type::TableFilter:
                begin
                    FieldType := FieldType::TableFilter;
                end;
            Fields.Type::RecordID:
                begin
                    FieldType := FieldType::RecordID;
                end;
            Fields.Type::Text:
                begin
                    FieldType := FieldType::Text;
                end;
            Fields.Type::Date:
                begin
                    FieldType := FieldType::Date;
                end;
            Fields.Type::Time:
                begin
                    FieldType := FieldType::Time;
                end;
            Fields.Type::DateFormula:
                begin
                    FieldType := FieldType::DateFormula;
                end;
            Fields.Type::Decimal:
                begin
                    FieldType := FieldType::Decimal;
                end;
            Fields.Type::Binary:
                begin
                    FieldType := FieldType::Binary;
                end;
            Fields.Type::BLOB:
                begin
                    FieldType := FieldType::BLOB;
                end;
            Fields.Type::Boolean:
                begin
                    FieldType := FieldType::Boolean;
                end;
            Fields.Type::Integer:
                begin
                    FieldType := FieldType::Integer;
                end;
            Fields.Type::Code:
                begin
                    FieldType := FieldType::Code;
                end;
            Fields.Type::Option:
                begin
                    FieldType := FieldType::Option;
                end;
            Fields.Type::BigInteger:
                begin
                    FieldType := FieldType::BigInteger;
                end;
            Fields.Type::Duration:
                begin
                    FieldType := FieldType::Duration;
                end;
            Fields.Type::GUID:
                begin
                    FieldType := FieldType::GUID;
                end;
            Fields.Type::DateTime:
                begin
                    FieldType := FieldType::DateTime;
                end;
        end;
    end;
}

