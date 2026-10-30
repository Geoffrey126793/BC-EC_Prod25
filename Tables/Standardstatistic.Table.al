table 8001304 "Standard statistic"
{
    Caption = 'Standard statistic';
    DrillDownPageID = "Standard statistics list";
    LookupPageID = "Standard statistics list";

    fields
    {
        field(1; "Catégory"; Code[10])
        {
            Caption = 'Category';
            TableRelation = "Statistic category";
        }
        field(2; "Period Length"; Option)
        {
            Caption = 'Period Length';
            InitValue = Month;
            OptionCaption = 'Day,Week,Month,Quarter,Year,Period,By column';
            OptionMembers = Day,Week,Month,Quarter,Year,Period,"By column";
        }
        field(5; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Account (G/L),Item,Resource,Employee,Resource Group';
            OptionMembers = " ","Account (G/L)",Item,Resource,Employee,"Resource Group";
        }
        field(6; "No."; Text[30])
        {
            Caption = 'No.';
            TableRelation = IF (Type = FILTER("Account (G/L)")) "G/L Account"
            ELSE
            IF (Type = FILTER(Item)) Item
            ELSE
            IF (Type = FILTER(Resource)) Resource
            ELSE
            IF (Type = FILTER(Employee)) Employee
            ELSE
            IF (Type = FILTER("Resource Group")) "Resource Group";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(8; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionCaption = ' ,Customer,Vendor,Item,Bank Account,Fixed Asset,Budget';
            OptionMembers = " ",Customer,Vendor,Item,"Bank Account","Fixed Asset",Budget;
        }
        field(9; "Source No."; Text[30])
        {
            Caption = 'Source No.';
            TableRelation = IF ("Source Type" = CONST(Customer)) Customer
            ELSE
            IF ("Source Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Source Type" = CONST(Item)) Item
            ELSE
            IF ("Source Type" = FILTER("Bank Account")) "Bank Account"
            ELSE
            IF ("Source Type" = FILTER("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Source Type" = FILTER(Budget)) "G/L Budget Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(11; "Location Code"; Text[30])
        {
            Caption = 'Location Code';
            TableRelation = Location;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(12; "Inventory Posting Group"; Text[30])
        {
            Caption = 'Inventory Posting Group';
            TableRelation = "Inventory Posting Group";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(13; "Source Posting Group"; Text[30])
        {
            Caption = 'Source Posting Group';
            TableRelation = IF ("Source Type" = FILTER(Customer)) "Customer Posting Group"
            ELSE
            IF ("Source Type" = FILTER(Vendor)) "Vendor Posting Group"
            ELSE
            IF ("Source Type" = FILTER(Item)) "Inventory Posting Group"
            ELSE
            IF ("Source Type" = FILTER("Bank Account")) "Bank Account Posting Group"
            ELSE
            IF ("Source Type" = FILTER("Fixed Asset")) "FA Posting Group"
            ELSE
            IF ("Source Type" = FILTER(Budget)) "G/L Budget Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(14; "Gen. Bus. Posting Group"; Text[30])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(15; "Gen. Prod. Posting Group"; Text[30])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(16; "Salespers./Purch. Code"; Text[30])
        {
            Caption = 'Salespers./Purch. Code';
            TableRelation = "Salesperson/Purchaser";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(17; "Global Dimension 1 Code"; Text[30])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(18; "Global Dimension 2 Code"; Text[30])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(19; "Country Code"; Text[100])
        {
            Caption = 'Country Code';
            TableRelation = "Country/Region";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(30; Year; Text[10])
        {
            Caption = 'Year';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(31; "Half Year"; Text[10])
        {
            Caption = 'Half Year';
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(32; Quarter; Text[10])
        {
            Caption = 'Quarter';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(33; Month; Text[10])
        {
            Caption = 'Month';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(34; Week; Text[10])
        {
            Caption = 'Week';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(35; "Fiscal year closing date"; Text[22])
        {
            Caption = 'Fiscal year closing date';
        }
        field(36; "Week Day"; Text[10])
        {
            Caption = 'Week Day';
        }
        field(37; "Business Unit Code"; Text[30])
        {
            Caption = 'Business Unit Code';
            TableRelation = "Business Unit";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(38; "Consol. Debit Acc."; Text[30])
        {
            Caption = 'Consol. Debit Acc.';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(39; "Consol. Credit Acc."; Text[30])
        {
            Caption = 'Consol. Credit Acc.';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(40; "Job No."; Text[30])
        {
            Caption = 'Job No.';
            TableRelation = Job;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(41; "Phase Code"; Text[30])
        {
            Caption = 'Phase Code';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(42; "Task Code"; Text[30])
        {
            Caption = 'Task Code';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(43; "Step Code"; Text[30])
        {
            Caption = 'Step Code';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(44; "Work Type Code"; Text[30])
        {
            Caption = 'Work Type Code';
            TableRelation = "Work Type";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(45; "Reason Code"; Text[30])
        {
            Caption = 'Reason Code';
            TableRelation = IF (Type = FILTER(<> Employee)) "Reason Code"
            ELSE
            IF (Type = FILTER(Employee)) "Cause of Absence";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(46; "Job Posting Group"; Text[30])
        {
            Caption = 'Job Posting Group';
            TableRelation = "Job Posting Group";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(47; "Resource Group No."; Text[30])
        {
            Caption = 'Resource Group No.';
            TableRelation = "Resource Group";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(48; "Person Responsible"; Text[30])
        {
            Caption = 'Person Responsible';
            TableRelation = Resource;
            ValidateTableRelation = false;
        }
        field(57; "Campaign No."; Text[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;
        }
        field(60; "Item criteria 1"; Text[30])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(11);
            Caption = 'Item criteria 1';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001301));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(61; "Item criteria 2"; Text[30])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(12);
            Caption = 'Item criteria 2';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001302));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(62; "Item criteria 3"; Text[30])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(13);
            Caption = 'Item criteria 3';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001303));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(63; "Item criteria 4"; Text[30])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(14);
            Caption = 'Item criteria 4';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001304));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(64; "Item criteria 5"; Text[30])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(15);
            Caption = 'Item criteria 5';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001305));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(65; "Item criteria 6"; Text[30])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(16);
            Caption = 'Item criteria 6';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001306));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(66; "Item criteria 7"; Text[30])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(17);
            Caption = 'Item criteria 7';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001307));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(67; "Item criteria 8"; Text[30])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(18);
            Caption = 'Item criteria 8';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001308));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(68; "Item criteria 9"; Text[30])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(19);
            Caption = 'Item criteria 9';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001309));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(69; "Item criteria 10"; Text[30])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(20);
            Caption = 'Item criteria 10';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001310));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(70; "Customer criteria 1"; Text[20])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(1);
            Caption = 'Customer criteria 1';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001301));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(71; "Customer criteria 2"; Text[20])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(2);
            Caption = 'Customer criteria 2';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001302));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(72; "Customer criteria 3"; Text[20])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(3);
            Caption = 'Customer criteria 3';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001303));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(73; "Customer criteria 4"; Text[20])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(4);
            Caption = 'Customer criteria 4';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001304));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(74; "Customer criteria 5"; Text[20])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(5);
            Caption = 'Customer criteria 5';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001305));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(75; "Customer criteria 6"; Text[20])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(6);
            Caption = 'Customer criteria 6';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001306));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(76; "Customer criteria 7"; Text[20])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(7);
            Caption = 'Customer criteria 7';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001307));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(77; "Customer criteria 8"; Text[20])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(8);
            Caption = 'Customer criteria 8';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001308));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(78; "Customer criteria 9"; Text[20])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(9);
            Caption = 'Customer criteria 9';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001309));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(79; "Customer criteria 10"; Text[20])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(10);
            Caption = 'Customer criteria 10';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001310));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(89; "Job criteria 1"; Text[20])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(91);
            Caption = 'Job criteria 1';
            TableRelation = Code.Code WHERE("Table No" = CONST(167),
                                             "Field No" = CONST(8001301));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(90; "Back disc./commission rule No."; Text[30])
        {
            Caption = 'Back discount/commission rule No.';
            TableRelation = "Discount Rule"."No." WHERE("Discount and comm. type" = FILTER("Back discount" | Commission));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(91; "Job criteria 2"; Text[20])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(92);
            Caption = 'Job criteria 2';
            TableRelation = Code.Code WHERE("Table No" = CONST(167),
                                             "Field No" = CONST(8001302));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(92; "Job criteria 3"; Text[20])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(93);
            Caption = 'Job criteria 3';
            TableRelation = Code.Code WHERE("Table No" = CONST(167),
                                             "Field No" = CONST(8001303));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(93; "Job criteria 4"; Text[20])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(94);
            Caption = 'Job criteria 4';
            TableRelation = Code.Code WHERE("Table No" = CONST(167),
                                             "Field No" = CONST(8001304));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(94; "Job criteria 5"; Text[20])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(95);
            Caption = 'Job criteria 5';
            TableRelation = Code.Code WHERE("Table No" = CONST(167),
                                             "Field No" = CONST(8001305));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(95; "Job criteria 6"; Text[20])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(96);
            Caption = 'Job criteria 6';
            TableRelation = Code.Code WHERE("Table No" = CONST(167),
                                             "Field No" = CONST(8001306));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(96; "Job criteria 7"; Text[20])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(97);
            Caption = 'Job criteria 7';
            TableRelation = Code.Code WHERE("Table No" = CONST(167),
                                             "Field No" = CONST(8001307));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(97; "Job criteria 8"; Text[20])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(98);
            Caption = 'Job criteria 8';
            TableRelation = Code.Code WHERE("Table No" = CONST(167),
                                             "Field No" = CONST(8001308));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(98; "Job criteria 9"; Text[20])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(99);
            Caption = 'Job criteria 9';
            TableRelation = Code.Code WHERE("Table No" = CONST(167),
                                             "Field No" = CONST(8001309));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(99; "Job criteria 10"; Text[20])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(100);
            Caption = 'Job criteria 10';
            TableRelation = Code.Code WHERE("Table No" = CONST(167),
                                             "Field No" = CONST(8001310));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(100; "Sort criteria"; Code[10])
        {
            Caption = 'Sort criteria';
            TableRelation = "Statistic sort criteria".Code WHERE(Type = FILTER("Tri statistique"));
        }
        field(110; "1st sort level"; Text[30])
        {
            Caption = '1st sort level';
            TableRelation = "Statistic criteria"."Field name" WHERE(Type = FILTER("Sort criteria"));
        }
        field(111; "Sort 1 : start pos."; Integer)
        {
            Caption = 'Sort 1 : start pos.';
        }
        field(112; "Sort 1 : length"; Integer)
        {
            Caption = 'Sort 1 : length';
        }
        field(113; "Sort 1 : skip page"; Boolean)
        {
            Caption = 'Sort 1 : skip page';
        }
        field(114; "Sort 1 : line before total"; Option)
        {
            Caption = 'Sort 1 : line before total';
            OptionCaption = 'No,Hairline,1pt,2pt,3pt';
            OptionMembers = No,Hairline,"1pt","2pt","3pt";
        }
        field(115; "Sort 1 : line after total"; Option)
        {
            Caption = 'Sort 1 : line after total';
            OptionCaption = 'No,Hairline,1pt,2pt,3pt';
            OptionMembers = No,Hairline,"1pt","2pt","3pt";
        }
        field(120; "2nd sort level"; Text[30])
        {
            Caption = '2nd sort level';
            TableRelation = "Statistic criteria"."Field name" WHERE(Type = FILTER("Sort criteria"));
        }
        field(121; "Sort 2 : start pos."; Integer)
        {
            Caption = 'Sort 2 : start pos.';
        }
        field(122; "Sort 2 : length"; Integer)
        {
            Caption = 'Sort 2 : length';
        }
        field(123; "Sort 2 : skip page"; Boolean)
        {
            Caption = 'Sort 2 : skip page';
        }
        field(124; "Sort 2 : line before total"; Option)
        {
            Caption = 'Sort 2 : line before total';
            OptionCaption = 'No,Hairline,1pt,2pt,3pt';
            OptionMembers = No,Hairline,"1pt","2pt","3pt";
        }
        field(125; "Sort 2 : line after total"; Option)
        {
            Caption = 'Sort 2 : line after total';
            OptionCaption = 'No,Hairline,1pt,2pt,3pt';
            OptionMembers = No,Hairline,"1pt","2pt","3pt";
        }
        field(130; "3rd sort level"; Text[30])
        {
            Caption = '3rd sort level';
            TableRelation = "Statistic criteria"."Field name" WHERE(Type = FILTER("Sort criteria"));
        }
        field(131; "Sort 3 : start pos."; Integer)
        {
            Caption = 'Sort 3 : start pos.';
        }
        field(132; "Sort 3 : length"; Integer)
        {
            Caption = 'Sort 3 : length';
        }
        field(133; "Sort 3 : skip page"; Boolean)
        {
            Caption = 'Sort 3 : skip page';
        }
        field(134; "Sort 3 : line before total"; Option)
        {
            Caption = 'Sort 3 : line before total';
            OptionCaption = 'No,Hairline,1pt,2pt,3pt';
            OptionMembers = No,Hairline,"1pt","2pt","3pt";
        }
        field(135; "Sort 3 : line after total"; Option)
        {
            Caption = 'Sort 3 : line after total';
            OptionCaption = 'No,Hairline,1pt,2pt,3pt';
            OptionMembers = No,Hairline,"1pt","2pt","3pt";
        }
        field(140; "4th sort level"; Text[30])
        {
            Caption = '4th sort level';
            TableRelation = "Statistic criteria"."Field name" WHERE(Type = FILTER("Sort criteria"));
        }
        field(141; "Sort 4 : start pos."; Integer)
        {
            Caption = 'Sort 4 : start pos.';
        }
        field(142; "Sort 4 : length"; Integer)
        {
            Caption = 'Sort 4 : length';
        }
        field(143; "Sort 4 : skip page"; Boolean)
        {
            Caption = 'Sort 4 : skip page';
        }
        field(144; "Sort 4 : line before total"; Option)
        {
            Caption = 'Sort 4 :';
            OptionCaption = 'No,Hairline,1pt,2pt,3pt';
            OptionMembers = No,Hairline,"1pt","2pt","3pt";
        }
        field(145; "Sort 4 : line after total"; Option)
        {
            Caption = 'Sort 4 : line after total';
            OptionCaption = 'No,Hairline,1pt,2pt,3pt';
            OptionMembers = No,Hairline,"1pt","2pt","3pt";
        }
        field(150; "5th sort level"; Text[30])
        {
            Caption = '5th sort level';
            TableRelation = "Statistic criteria"."Field name" WHERE(Type = FILTER("Sort criteria"));
        }
        field(151; "Sort 5 : start pos."; Integer)
        {
            Caption = 'Sort 5 : start pos.';
        }
        field(152; "Sort 5 : length"; Integer)
        {
            Caption = 'Sort 5 : length';
        }
        field(153; "Sort 5 : skip page"; Boolean)
        {
            Caption = 'Sort 5 : skip page';
        }
        field(154; "Sort 5 : line before total"; Option)
        {
            Caption = 'Sort 5 : line before total';
            OptionCaption = 'No,Hairline,1pt,2pt,3pt';
            OptionMembers = No,Hairline,"1pt","2pt","3pt";
        }
        field(155; "Sort 5 : line after total"; Option)
        {
            Caption = 'Sort 5 : line after total';
            OptionCaption = 'No,Hairline,1pt,2pt,3pt';
            OptionMembers = No,Hairline,"1pt","2pt","3pt";
        }
        field(160; "6th sort level"; Text[30])
        {
            Caption = '6th sort level';
            TableRelation = "Statistic criteria"."Field name" WHERE(Type = FILTER("Sort criteria"));
        }
        field(161; "Sort 6 : start pos."; Integer)
        {
            Caption = 'Sort 6 : start pos.';
        }
        field(162; "Sort 6 : length"; Integer)
        {
            Caption = 'Sort 6 : length';
        }
        field(163; "Sort 6 : skip page"; Boolean)
        {
            Caption = 'Sort 6 : skip page';
        }
        field(164; "Sort 6 : line before total"; Option)
        {
            Caption = 'Sort 6 : line before total';
            OptionCaption = 'No,Hairline,1pt,2pt,3pt';
            OptionMembers = No,Hairline,"1pt","2pt","3pt";
        }
        field(165; "Sort 6 : line after total"; Option)
        {
            Caption = 'Sort 6 : line after total';
            OptionCaption = 'No,Hairline,1pt,2pt,3pt';
            OptionMembers = No,Hairline,"1pt","2pt","3pt";
        }
        field(170; "7th sort level"; Text[30])
        {
            Caption = '7th sort level';
            TableRelation = "Statistic criteria"."Field name" WHERE(Type = FILTER("Sort criteria"));
        }
        field(171; "Sort 7 : start pos."; Integer)
        {
            Caption = 'Sort 7 : start pos.';
        }
        field(172; "Sort 7 : length"; Integer)
        {
            Caption = 'Sort 7 : length';
        }
        field(173; "Sort 7 : skip page"; Boolean)
        {
            Caption = 'Sort 7 : skip page';
        }
        field(174; "Sort 7 : line before total"; Option)
        {
            Caption = 'Sort 7 : line before total';
            OptionCaption = 'No,Hairline,1pt,2pt,3pt';
            OptionMembers = No,Hairline,"1pt","2pt","3pt";
        }
        field(175; "Sort 7 : line after total"; Option)
        {
            Caption = 'Sort 7 : line after total';
            OptionCaption = 'No,Hairline,1pt,2pt,3pt';
            OptionMembers = No,Hairline,"1pt","2pt","3pt";
        }
        field(180; "8th sort level"; Text[30])
        {
            Caption = '8th sort level';
            TableRelation = "Statistic criteria"."Field name" WHERE(Type = FILTER("Sort criteria"));
        }
        field(181; "Sort 8 : start pos."; Integer)
        {
            Caption = 'Sort 8 : start pos.';
        }
        field(182; "Sort 8 : length"; Integer)
        {
            Caption = 'Sort 8 : length';
        }
        field(183; "Sort 8 : skip page"; Boolean)
        {
            Caption = 'Sort 8 : skip page';
        }
        field(184; "Sort 8 : line before total"; Option)
        {
            Caption = 'Sort 8 :';
            OptionCaption = 'No,Hairline,1pt,2pt,3pt';
            OptionMembers = No,Hairline,"1pt","2pt","3pt";
        }
        field(185; "Sort 8 : line after total"; Option)
        {
            Caption = 'Sort 8 : line before total';
            OptionCaption = 'No,Hairline,1pt,2pt,3pt';
            OptionMembers = No,Hairline,"1pt","2pt","3pt";
        }
        field(190; "9th sort level"; Text[30])
        {
            Caption = '9th sort level';
            TableRelation = "Statistic criteria"."Field name" WHERE(Type = FILTER("Sort criteria"));
        }
        field(191; "Sort 9 : start pos."; Integer)
        {
            Caption = 'Sort 9 : start pos.';
        }
        field(192; "Sort 9 : length"; Integer)
        {
            Caption = 'Sort 9 : length';
        }
        field(193; "Sort 9 : skip page"; Boolean)
        {
            Caption = 'Sort 9 : skip page';
        }
        field(194; "Sort 9 : line before total"; Option)
        {
            Caption = 'Sort 9 : line before total';
            OptionCaption = 'No,Hairline,1pt,2pt,3pt';
            OptionMembers = No,Hairline,"1pt","2pt","3pt";
        }
        field(195; "Sort 9 : line after total"; Option)
        {
            Caption = 'Sort 9 : line after total';
            OptionCaption = 'No,Hairline,1pt,2pt,3pt';
            OptionMembers = No,Hairline,"1pt","2pt","3pt";
        }
        field(200; "10th sort level"; Text[30])
        {
            Caption = '10th sort level';
            TableRelation = "Statistic criteria"."Field name" WHERE(Type = FILTER("Sort criteria"));
        }
        field(201; "Sort 10 : start pos."; Integer)
        {
            Caption = 'Sort 10 : start pos.';
        }
        field(202; "Sort 10 : length"; Integer)
        {
            Caption = 'Sort 10 : length';
        }
        field(203; "Sort 10 : skip page"; Boolean)
        {
            Caption = 'Sort 10 : skip page';
        }
        field(204; "Sort 10 : line before total"; Option)
        {
            Caption = 'Sort 10 : line before total';
            OptionCaption = 'No,Hairline,1pt,2pt,3pt';
            OptionMembers = No,Hairline,"1pt","2pt","3pt";
        }
        field(205; "Sort 10 : line after total"; Option)
        {
            Caption = 'Sort 10 : line after total';
            OptionCaption = 'No,Hairline,1pt,2pt,3pt';
            OptionMembers = No,Hairline,"1pt","2pt","3pt";
        }
        field(210; "Sort header print mode"; Option)
        {
            Caption = 'Sort header print mode';
            OptionCaption = 'Title+Code+Description,Title+Code,Title+Description,Code+Description,Code,Description,None';
            OptionMembers = "Title+Code+Description","Title+Code","Title+Description","Code+Description","Code",Description,"None";
        }
        field(211; "Sort line print mode"; Option)
        {
            Caption = 'Sort line print mode';
            OptionCaption = 'Code+Description,Code,Description';
            OptionMembers = "Code+Description","Code",Description;
        }
        field(212; "Sort total print mode"; Option)
        {
            Caption = 'Sort total print mode';
            OptionCaption = 'Title+Code+Description,Title+Code,Title+Description,Code+Description,Code,Description,None';
            OptionMembers = "Title+Code+Description","Title+Code","Title+Description","Code+Description","Code",Description,"None";
        }
        field(300; "Item Charge No."; Text[30])
        {
            Caption = 'Item Charge No.';
            TableRelation = "Item Charge";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(301; "Variant Code"; Text[30])
        {
            Caption = 'Variant Code';
            TableRelation = IF (Type = FILTER(Item)) "Item Variant".Code WHERE("Item No." = FIELD("No."));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(303; "Return Reason Code"; Text[30])
        {
            Caption = 'Return Reason Code';
            TableRelation = "Return Reason";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(310; "Manufacturer Code"; Text[30])
        {
            Caption = 'Manufacturer Code';
            TableRelation = Manufacturer;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(311; "Item Category Code"; Text[30])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(312; "Product Group Code"; Text[30])
        {
            Caption = 'Product Group Code';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(313; "Service Item Group"; Text[30])
        {
            Caption = 'Service Item Group';
            TableRelation = "Service Item Group".Code;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(500; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(501; Name; Text[80])
        {
            Caption = 'Name';
        }
        field(502; "Other Companies"; Boolean)
        {
            CalcFormula = Exist("Statistic Company" WHERE("Statistic code" = FIELD(Code),
                                                           Company = FILTER(<> '')));
            Caption = 'Other Compagnies';
            Editable = false;
            FieldClass = FlowField;
        }
        field(511; "Column Layout Name"; Code[10])
        {
            Caption = 'Column Layout Name';
            TableRelation = "Column style name";
        }
        field(600; "Excel model name"; Text[200])
        {
            Caption = 'Excel model name';
        }
        field(610; "Excel sheet"; Text[30])
        {
            Caption = 'Excel sheet';
        }
        field(1001; "Free field 1"; Text[30])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(1001);
            Caption = 'Free field 1';
            TableRelation = Code.Code WHERE("Table No" = CONST(8001300),
                                             "Field No" = CONST(1001));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(1002; "Free field 2"; Text[30])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(1002);
            Caption = 'Free field 2';
            TableRelation = Code.Code WHERE("Table No" = CONST(8001300),
                                             "Field No" = CONST(1002));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(1003; "Free field 3"; Text[30])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(1003);
            Caption = 'Free field 3';
            TableRelation = Code.Code WHERE("Table No" = CONST(8001300),
                                             "Field No" = CONST(1003));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(1004; "Free field 4"; Text[30])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(1004);
            Caption = 'Free field 4';
            TableRelation = Code.Code WHERE("Table No" = CONST(8001300),
                                             "Field No" = CONST(1004));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(1005; "Free field 5"; Text[30])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(1005);
            Caption = 'Free field 5';
            TableRelation = Code.Code WHERE("Table No" = CONST(8001300),
                                             "Field No" = CONST(1005));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(1006; "Free field 6"; Text[30])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(1006);
            Caption = 'Free field 6';
            TableRelation = Code.Code WHERE("Table No" = CONST(8001300),
                                             "Field No" = CONST(1006));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(1007; "Free field 7"; Text[30])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(1007);
            Caption = 'Free field 7';
            TableRelation = Code.Code WHERE("Table No" = CONST(8001300),
                                             "Field No" = CONST(1007));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(1008; "Free field 8"; Text[30])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(1008);
            Caption = 'Free field 8';
            TableRelation = Code.Code WHERE("Table No" = CONST(8001300),
                                             "Field No" = CONST(1008));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(1009; "Free field 9"; Text[30])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(1009);
            Caption = 'Free field 9';
            TableRelation = Code.Code WHERE("Table No" = CONST(8001300),
                                             "Field No" = CONST(1009));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(1010; "Free field 10"; Text[30])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(1010);
            Caption = 'Free field 10';
            TableRelation = Code.Code WHERE("Table No" = CONST(8001300),
                                             "Field No" = CONST(1010));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(1011; "Free date 1"; Text[22])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(1011);
            Caption = 'Free date 1';
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(1012; "Free date 2"; Text[22])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(1012);
            Caption = 'Free date 2';
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(1013; "Free date 3"; Text[22])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(1013);
            Caption = 'Free date 3';
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(1014; "Free date 4"; Text[22])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(1014);
            Caption = 'Free date 4';
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(1015; "Free date 5"; Text[22])
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(1015);
            Caption = 'Free date 5';
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(1021; "Free boolean 1"; Option)
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(1021);
            Caption = 'Free boolean 1';
            OptionCaption = ' ,Yes,No';
            OptionMembers = " ",Yes,No;
        }
        field(1022; "Free boolean 2"; Option)
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(1022);
            Caption = 'Free boolean 2';
            OptionCaption = ' ,Yes,No';
            OptionMembers = " ",Yes,No;
        }
        field(1023; "Free boolean 3"; Option)
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(1023);
            Caption = 'Free boolean 3';
            OptionCaption = ' ,Yes,No';
            OptionMembers = " ",Yes,No;
        }
        field(1024; "Free boolean 4"; Option)
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(1024);
            Caption = 'Free boolean 4';
            OptionCaption = ' ,Yes,No';
            OptionMembers = " ",Yes,No;
        }
        field(1025; "Free boolean 5"; Option)
        {
            CaptionClass = StatisticAggregate.GetCaptionsStatsExplorer(1025);
            Caption = 'Free boolean 5';
            OptionCaption = ' ,Yes,No';
            OptionMembers = " ",Yes,No;
        }
        field(30001; "Dimension 1 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(1);
            Caption = 'Dimension 1 Value Code';
        }
        field(30002; "Dimension 2 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(2);
            Caption = 'Dimension 2 Value Code';
        }
        field(30003; "Dimension 3 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(3);
            Caption = 'Dimension 3 Value Code';
        }
        field(30004; "Dimension 4 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(4);
            Caption = 'Dimension 4 Value Code';
        }
        field(30005; "Dimension 5 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(5);
            Caption = 'Dimension 5 Value Code';
        }
        field(30006; "Dimension 6 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(6);
            Caption = 'Dimension 6 Value Code';
        }
        field(30007; "Dimension 7 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(7);
            Caption = 'Dimension 7 Value Code';
        }
        field(30008; "Dimension 8 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(8);
            Caption = 'Dimension 8 Value Code';
        }
        field(30009; "Dimension 9 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(9);
            Caption = 'Dimension 9 Value Code';
        }
        field(30010; "Dimension 10 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(10);
            Caption = 'Dimension 10 Value Code';
        }
        field(30011; "Dimension 11 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(11);
            Caption = 'Dimension 11 Value Code';
        }
        field(30012; "Dimension 12 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(12);
            Caption = 'Dimension 12 Value Code';
        }
        field(30013; "Dimension 13 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(13);
            Caption = 'Dimension 13 Value Code';
        }
        field(30014; "Dimension 14 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(14);
            Caption = 'Dimension 14 Value Code';
        }
        field(30015; "Dimension 15 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(15);
            Caption = 'Dimension 15 Value Code';
        }
        field(30016; "Dimension 16 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(16);
            Caption = 'Dimension 16 Value Code';
        }
        field(30017; "Dimension 17 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(17);
            Caption = 'Dimension 17 Value Code';
        }
        field(30018; "Dimension 18 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(18);
            Caption = 'Dimension 18 Value Code';
        }
        field(30019; "Dimension 19 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(19);
            Caption = 'Dimension 19 Value Code';
        }
        field(30020; "Dimension 20 Value Code"; Text[30])
        {
            CaptionClass = GetCaptionClass(20);
            Caption = 'Dimension 20 Value Code';
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

    var
        ParametresStatistiques: Record "Statistics setup";
        Critere: Record "Statistic criteria";
        TriStatistique: Record "Statistic sort criteria";
        PermissionStatistique: Record "Statistic Permission";
        LigneAutomateStatistique: Record "Statistic Scheduler line";
        SocieteStatistique: Record "Statistic Company";
        StatisticsSetup: Record "Statistics setup";
        StatisticAggregate: Record "Statistic aggregate";
        DimValue: Record "Dimension Value";
        DimManagement: Codeunit DimensionManagement;
        Error1: Label 'Max length is %1 character for this field';
        Error2: Label '%1 code not defined';
        Text001: Label '1,6,,Dimension 1 Value Code';
        Text002: Label '1,6,,Dimension 2 Value Code';
        Text003: Label '1,6,,Dimension 3 Value Code';
        Text004: Label '1,6,,Dimension 4 Value Code';
        Text005: Label '1,6,,Dimension 5 Value Code';
        Text006: Label '1,6,,Dimension 6 Value Code';
        Text007: Label '1,6,,Dimension 7 Value Code';
        Text008: Label '1,6,,Dimension 8 Value Code';
        Text009: Label '1,6,,Dimension 9 Value Code';
        Text010: Label '1,6,,Dimension 10 Value Code';
        Text011: Label '1,6,,Dimension 11 Value Code';
        Text012: Label '1,6,,Dimension 12 Value Code';
        Text013: Label '1,6,,Dimension 13 Value Code';
        Text014: Label '1,6,,Dimension 14 Value Code';
        Text015: Label '1,6,,Dimension 15 Value Code';
        Text016: Label '1,6,,Dimension 16 Value Code';
        Text017: Label '1,6,,Dimension 17 Value Code';
        Text018: Label '1,6,,Dimension 18 Value Code';
        Text019: Label '1,6,,Dimension 19 Value Code';
        Text020: Label '1,6,,Dimension 20 Value Code';

    [Scope('OnPrem')]
    procedure RepriseTri()
    begin
    end;

    [Scope('OnPrem')]
    procedure GetCaptionClass(AnalysisViewDimType: Integer): Text[250]
    begin
    end;
}

