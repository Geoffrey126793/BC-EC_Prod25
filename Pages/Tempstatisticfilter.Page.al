page 8001314 "Temp. statistic filter"
{
    // //STATSEXPLORER STATSEXPLORER 01/01/00 Temp. statistic filter

    Caption = 'Temp. statistic filter';
    DataCaptionExpression = Code;
    InsertAllowed = false;
    PageType = Card;
    Permissions = TableData "Country/Region" = r,
                  TableData "Country/Region Translation" = r,
                  TableData "Salesperson/Purchaser" = r,
                  TableData Location = r,
                  TableData "G/L Account" = r,
                  TableData Customer = r,
                  TableData Vendor = r,
                  TableData Item = r,
                  TableData "Customer Posting Group" = rimd,
                  TableData "Vendor Posting Group" = rimd,
                  TableData "Inventory Posting Group" = rimd,
                  TableData "Resource Group" = rimd,
                  TableData Resource = r,
                  TableData Job = r,
                  TableData "Work Type" = r,
                  TableData "Job Posting Group" = rimd,
                  TableData "Reason Code" = rimd,
                  TableData "Gen. Business Posting Group" = rimd,
                  TableData "Gen. Product Posting Group" = rimd;
    SourceTable = "Temp. statistic filter";

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
                    Caption = 'Consol. Debit Acc.';
                }
                field("Consol. Credit Acc."; "Consol. Credit Acc.")
                {
                    Caption = 'Consol. Credit Acc.';
                }
                field("Back disc./commission rule No."; "Back disc./commission rule No.")
                {
                    Visible = BackdisccommissionruleNoVisibl;
                }
                field("Campaign No."; "Campaign No.")
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
                    field("Job Task Code"; "Job Task Code")
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
                group("Free field ")
                {
                    Caption = 'Free field ';
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
            group(level)
            {
                Caption = 'level';
                group(Control1100287199)
                {
                    ShowCaption = false;
                    field("Sort criteria"; "Sort criteria")
                    {
                        Caption = 'Predefined sort criteria';
                    }
                }
                group("Sort 1")
                {
                    Caption = 'Sort 1';
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
                group("Sort 2")
                {
                    Caption = 'Sort 2';
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
                group("Sort 3")
                {
                    Caption = 'Sort 3';
                    field(c3thsortlevel; wSortLevel3)
                    {
                        Caption = '3rd sort level';

                        trigger OnDrillDown()
                        begin
                            if (fOnDrillDown(wSortLevel3, "3th sort level")) then begin
                                Validate("3th sort level", wSortLevel3);
                                CurrPage.Update(true);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            Validate("3th sort level", wSortLevel3);
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
                group("Sort 4")
                {
                    Caption = 'Sort 4';
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
                group("Sort 5")
                {
                    Caption = 'Sort 5';
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
                group("Sort 6")
                {
                    Caption = 'Sort 6';
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
                group("Sort 7")
                {
                    Caption = 'Sort 7';
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
                group("Sort 8")
                {
                    Caption = 'Sort 8';
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
                group("Sort 9")
                {
                    Caption = 'Sort 9';
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
                group("Sort 10")
                {
                    Caption = 'Sort 10';
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

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        fSetSortLevel();
    end;

    trigger OnOpenPage()
    var
        Magasin: Record Location;
    begin
        ParamStatistiques.Get;
        AfficherCriteres;
    end;

    var
        ParamStatistiques: Record "Statistics setup";
        StatistiquePredefinie: Record "Standard statistic";
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
    procedure fSetSortLevel()
    begin
        //RTC - 2009
        //wStatTools.GetTranslateCaption(wStatTools.GetStatCriterFieldNo(0,"1st sort level"),0, wSortLevel1);
        //wStatTools.GetTranslateCaption(wStatTools.GetStatCriterFieldNo(0,"2nd sort level"),0, wSortLevel2);
        //wStatTools.GetTranslateCaption(wStatTools.GetStatCriterFieldNo(0,"3th sort level"),0, wSortLevel3);
        //wStatTools.GetTranslateCaption(wStatTools.GetStatCriterFieldNo(0,"4th sort level"),0, wSortLevel4);
        //wStatTools.GetTranslateCaption(wStatTools.GetStatCriterFieldNo(0,"5th sort level"),0, wSortLevel5);
        //wStatTools.GetTranslateCaption(wStatTools.GetStatCriterFieldNo(0,"6th sort level"),0, wSortLevel6);
        //wStatTools.GetTranslateCaption(wStatTools.GetStatCriterFieldNo(0,"7th sort level"),0, wSortLevel7);
        //wStatTools.GetTranslateCaption(wStatTools.GetStatCriterFieldNo(0,"8th sort level"),0, wSortLevel8);
        //wStatTools.GetTranslateCaption(wStatTools.GetStatCriterFieldNo(0,"9th sort level"),0, wSortLevel9);
        //wStatTools.GetTranslateCaption(wStatTools.GetStatCriterFieldNo(0,"10th sort level"),0, wSortLevel10);
        //RTC - 2009//
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




}

