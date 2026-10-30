table 8001300 "Statistic aggregate"
{
    // -------------------------------------------------------------------------------------------
    //   STA-000 ABSYS GN 20061005 (Ajout de critères StatsExplorer sur Vendor)
    //     Display Fields :
    //       50000 - 50009 : Vendor criteria 1 ... Vendor criteria 10 (Text 30)
    //     Add Code :
    //       GetCaptionsStatsExplorer
    // -------------------------------------------------------------------------------------------
    //   STA-000 ABSYS BT 20061102
    //     type : ajout de 2 options :
    //     - Loi de remise,
    //     - Loi de remise RFA
    //    No : lien vers la table des ressources
    // ----------------------------------------------------------------------------------------------
    // 
    // 
    // //STATSEXPLORER STATSEXPLORER 01/10/01 Statistic aggregate

    Caption = 'Statistic aggregate';
    LookupPageID = "Statistic aggregates";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Period Length"; Option)
        {
            Caption = 'Period Length';
            OptionCaption = 'Day,Week,Month,Quarter,Year,Period';
            OptionMembers = Day,Week,Month,Quarter,Year,Period;
        }
        field(3; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(4; "Entry Type"; Text[30])
        {
            Caption = 'Entry Type';
            TableRelation = "Statistic criteria"."Field name" WHERE(Type = FILTER(Flow));

            trigger OnLookup()
            var
                Critere: Record "Statistic criteria";
            begin
                Critere.FilterGroup(7);
                Critere.SetRange(Type, Critere.Type::Flow);
                Critere.SetRange(Enabled, true);
                Critere.FilterGroup(0);
                if PAGE.RunModal(0, Critere) = ACTION::LookupOK then
                    "Entry Type" := Critere."Field name";
            end;
        }
        field(5; Type; Option)
        {
            Caption = 'Type';
            Description = 'BT AB6 : ajout de 2 types';
            OptionCaption = 'Account (G/L),Item,Resource,Employee,Resource Group,Discount Rule';
            OptionMembers = "Account (G/L)",Item,Resource,Employee,"Resource Group","Discount Rule","Back Disc. Rule";
        }
        field(6; "No."; Text[20])
        {
            Caption = 'No.';
            Description = 'Lien vers discount';
            TableRelation = IF (Type = FILTER("Account (G/L)")) "G/L Account"
            ELSE
            IF (Type = FILTER(Item)) Item
            ELSE
            IF (Type = FILTER(Resource)) Resource
            ELSE
            IF (Type = FILTER(Employee)) Employee
            ELSE
            IF (Type = FILTER("Resource Group")) "Resource Group"
            ELSE
            IF (Type = FILTER("Discount Rule")) "Discount Rule";
            ValidateTableRelation = false;
        }
        field(8; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionCaption = ' ,Customer,Vendor,Item,Bank Account,Fixed Asset,Budget';
            OptionMembers = " ",Customer,Vendor,Item,"Bank Account","Fixed Asset",Budget;
        }
        field(9; "Source No."; Code[20])
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

            trigger OnLookup()
            var
                lCust: Record Customer;
                lVendor: Record Vendor;
                lItem: Record Item;
                lBankAccount: Record "Bank Account";
                lFixedAsset: Record "Fixed Asset";
                lGLBudgetName: Record "G/L Budget Name";
                lForecastName: Record "Production Forecast Name";
            begin
                case "Source Type" of
                    "Source Type"::Customer:
                        PAGE.RunModal(0, lCust);
                    "Source Type"::Vendor:
                        PAGE.RunModal(0, lVendor);
                    "Source Type"::Item:
                        PAGE.RunModal(0, lItem);
                    "Source Type"::"Bank Account":
                        PAGE.RunModal(0, lBankAccount);
                    "Source Type"::"Fixed Asset":
                        PAGE.RunModal(0, lFixedAsset);
                    "Source Type"::Budget:
                        if Type = Type::"Account (G/L)" then
                            PAGE.RunModal(0, lGLBudgetName)
                        else
                            if Type = Type::Item then
                                PAGE.RunModal(0, lForecastName)
                end;
            end;
        }
        field(11; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(12; "Inventory Posting Group"; Code[20])
        {
            Caption = 'Inventory Posting Group';
            TableRelation = "Inventory Posting Group";
        }
        field(13; "Source Posting Group"; Code[20])
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
        }
        field(14; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(15; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(16; "Salespers./Purch. Code"; Code[10])
        {
            Caption = 'Salespers./Purch. Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(17; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';

            trigger OnLookup()
            begin
                DimManagement.LookupDimValueCode(1, "Global Dimension 1 Code");
            end;
        }
        field(18; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';

            trigger OnLookup()
            begin
                DimManagement.LookupDimValueCode(2, "Global Dimension 2 Code");
            end;
        }
        field(19; "Country Code"; Code[10])
        {
            Caption = 'Country Code';
            TableRelation = "Country/Region";
        }
        field(20; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(21; Volume; Decimal)
        {
            Caption = 'Volume';
        }
        field(23; Amount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';
        }
        field(24; Cost; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Cost';
        }
        field(30; Year; Integer)
        {
            Caption = 'Year';
        }
        field(31; "Half Year"; Integer)
        {
            Caption = 'Half Year';
        }
        field(32; Quarter; Integer)
        {
            Caption = 'Quarter';
        }
        field(33; Month; Integer)
        {
            Caption = 'Month';
        }
        field(34; Week; Integer)
        {
            Caption = 'Week';
        }
        field(35; "Fiscal year closing date"; Date)
        {
            Caption = 'Fiscal year closing date';
        }
        field(36; "Week Day"; Integer)
        {
            Caption = 'Week Day';
        }
        field(37; "Business Unit Code"; Code[10])
        {
            Caption = 'Business Unit Code';
            TableRelation = "Business Unit";
        }
        field(38; "Consol. Debit Acc."; Code[20])
        {
            Caption = 'Consol. Debit Acc.';
        }
        field(39; "Consol. Credit Acc."; Code[20])
        {
            Caption = 'Consol. Credit Acc.';
        }
        field(40; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
        }
        field(41; "Phase Code"; Code[10])
        {
            Caption = 'Phase Code';
        }
        field(42; "Task Code"; Code[10])
        {
            Caption = 'Task Code';
        }
        field(43; "Step Code"; Code[10])
        {
            Caption = 'Step Code';
        }
        field(44; "Work Type Code"; Code[10])
        {
            Caption = 'Work Type Code';
            TableRelation = "Work Type";
        }
        field(45; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = IF (Type = FILTER(<> Employee)) "Reason Code"
            ELSE
            IF (Type = FILTER(Employee)) "Cause of Absence";
        }
        field(46; "Job Posting Group"; Code[20])
        {
            Caption = 'Job Posting Group';
            TableRelation = "Job Posting Group";
        }
        field(47; "Resource Group No."; Code[20])
        {
            Caption = 'Resource Group No.';
            TableRelation = "Resource Group";
        }
        field(48; "Person Responsible"; Code[20])
        {
            Caption = 'Person Responsible';
            TableRelation = Resource;
        }
        field(57; "Campaign No."; Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;
        }
        field(60; "Item criteria 1"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(11);
            Caption = 'Item criteria 1';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001301));
        }
        field(61; "Item criteria 2"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(12);
            Caption = 'Item criteria 2';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001302));
        }
        field(62; "Item criteria 3"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(13);
            Caption = 'Item criteria 3';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001303));
        }
        field(63; "Item criteria 4"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(14);
            Caption = 'Item criteria 4';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001304));
        }
        field(64; "Item criteria 5"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(15);
            Caption = 'Item criteria 5';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001305));
        }
        field(65; "Item criteria 6"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(16);
            Caption = 'Item criteria 6';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001306));
        }
        field(66; "Item criteria 7"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(17);
            Caption = 'Item criteria 7';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001307));
        }
        field(67; "Item criteria 8"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(18);
            Caption = 'Item criteria 8';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001308));
        }
        field(68; "Item criteria 9"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(19);
            Caption = 'Item criteria 9';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001309));
        }
        field(69; "Item criteria 10"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(20);
            Caption = 'Item criteria 10';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001310));
        }
        field(70; "Customer criteria 1"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(1);
            Caption = 'Customer criteria 1';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001301));
        }
        field(71; "Customer criteria 2"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(2);
            Caption = 'Customer criteria 2';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001302));
        }
        field(72; "Customer criteria 3"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(3);
            Caption = 'Customer criteria 3';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001303));
        }
        field(73; "Customer criteria 4"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(4);
            Caption = 'Customer criteria 4';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001304));
        }
        field(74; "Customer criteria 5"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(5);
            Caption = 'Customer criteria 5';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001305));
        }
        field(75; "Customer criteria 6"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(6);
            Caption = 'Customer criteria 6';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001306));
        }
        field(76; "Customer criteria 7"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(7);
            Caption = 'Customer criteria 7';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001307));
        }
        field(77; "Customer criteria 8"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(8);
            Caption = 'Customer criteria 8';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001308));
        }
        field(78; "Customer criteria 9"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(9);
            Caption = 'Customer criteria 9';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001309));
        }
        field(79; "Customer criteria 10"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(10);
            Caption = 'Customer criteria 10';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001310));
        }
        field(80; "Free value 1"; Decimal)
        {
            AutoFormatType = 1;
            CaptionClass = GetCaptionsStatsExplorer(81);
            Caption = 'Free value 1';
        }
        field(81; "Free value 2"; Decimal)
        {
            AutoFormatType = 1;
            CaptionClass = GetCaptionsStatsExplorer(82);
            Caption = 'Free value 2';
        }
        field(82; "Free value 3"; Decimal)
        {
            AutoFormatType = 1;
            CaptionClass = GetCaptionsStatsExplorer(83);
            Caption = 'Free value 3';
        }
        field(83; "Free value 4"; Decimal)
        {
            AutoFormatType = 1;
            CaptionClass = GetCaptionsStatsExplorer(84);
            Caption = 'Free value 4';
        }
        field(84; "Free value 5"; Decimal)
        {
            AutoFormatType = 1;
            CaptionClass = GetCaptionsStatsExplorer(85);
            Caption = 'Free value 5';
        }
        field(85; "Free value 6"; Decimal)
        {
            AutoFormatType = 1;
            CaptionClass = GetCaptionsStatsExplorer(86);
            Caption = 'Free value 6';
        }
        field(86; "Free value 7"; Decimal)
        {
            AutoFormatType = 1;
            CaptionClass = GetCaptionsStatsExplorer(87);
            Caption = 'Free value 7';
        }
        field(87; "Free value 8"; Decimal)
        {
            AutoFormatType = 1;
            CaptionClass = GetCaptionsStatsExplorer(88);
            Caption = 'Free value 8';
        }
        field(88; "Free value 9"; Decimal)
        {
            AutoFormatType = 1;
            CaptionClass = GetCaptionsStatsExplorer(89);
            Caption = 'Free value 9';
        }
        field(89; "Free value 10"; Decimal)
        {
            AutoFormatType = 1;
            CaptionClass = GetCaptionsStatsExplorer(90);
            Caption = 'Free value 10';
        }
        field(90; "Job criteria 1"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(91);
            Caption = 'Job criteria 1';
            TableRelation = Code.Code WHERE("Table No" = CONST(167),
                                             "Field No" = CONST(8001301));
        }
        field(91; "Job criteria 2"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(92);
            Caption = 'Job criteria 2';
            TableRelation = Code.Code WHERE("Table No" = CONST(167),
                                             "Field No" = CONST(8001302));
        }
        field(92; "Job criteria 3"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(93);
            Caption = 'Job criteria 3';
            TableRelation = Code.Code WHERE("Table No" = CONST(167),
                                             "Field No" = CONST(8001303));
        }
        field(93; "Job criteria 4"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(94);
            Caption = 'Job criteria 4';
            TableRelation = Code.Code WHERE("Table No" = CONST(167),
                                             "Field No" = CONST(8001304));
        }
        field(94; "Job criteria 5"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(95);
            Caption = 'Job criteria 5';
            TableRelation = Code.Code WHERE("Table No" = CONST(167),
                                             "Field No" = CONST(8001305));
        }
        field(95; "Job criteria 6"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(96);
            Caption = 'Job criteria 6';
            TableRelation = Code.Code WHERE("Table No" = CONST(167),
                                             "Field No" = CONST(8001306));
        }
        field(96; "Job criteria 7"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(97);
            Caption = 'Job criteria 7';
            TableRelation = Code.Code WHERE("Table No" = CONST(167),
                                             "Field No" = CONST(8001307));
        }
        field(97; "Job criteria 8"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(98);
            Caption = 'Job criteria 8';
            TableRelation = Code.Code WHERE("Table No" = CONST(167),
                                             "Field No" = CONST(8001308));
        }
        field(98; "Job criteria 9"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(99);
            Caption = 'Job criteria 9';
            TableRelation = Code.Code WHERE("Table No" = CONST(167),
                                             "Field No" = CONST(8001309));
        }
        field(99; "Job criteria 10"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(100);
            Caption = 'Job criteria 10';
            TableRelation = Code.Code WHERE("Table No" = CONST(167),
                                             "Field No" = CONST(8001310));
        }
        field(100; "Lines discount total"; Decimal)
        {
            Caption = 'Lines discount total';
        }
        field(101; "Document discount total"; Decimal)
        {
            Caption = 'Document discount total';
        }
        field(102; "Back discount total"; Decimal)
        {
            Caption = 'Back discount total';
        }
        field(103; "Commissions total"; Decimal)
        {
            Caption = 'Commissions total';
        }
        field(110; "Back disc./commission rule No."; Code[20])
        {
            Caption = 'Back discount/commission rule No.';
            TableRelation = "Discount Rule"."No." WHERE("Discount and comm. type" = FILTER("Back discount" | Commission));
        }
        field(300; "Item Charge No."; Code[20])
        {
            Caption = 'Item Charge No.';
            TableRelation = "Item Charge";
        }
        field(301; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = IF (Type = FILTER(Item)) "Item Variant".Code WHERE("Item No." = FIELD("No."));
        }
        field(303; "Return Reason Code"; Code[10])
        {
            Caption = 'Return Reason Code';
            TableRelation = "Return Reason";
        }
        field(310; "Manufacturer Code"; Code[10])
        {
            Caption = 'Manufacturer Code';
            TableRelation = Manufacturer;
        }
        field(311; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(312; "Product Group Code"; Code[20])
        {
            Caption = 'Product Group Code';
        }
        field(313; "Service Item Group"; Code[20])
        {
            Caption = 'Service Item Group';
            TableRelation = "Service Item Group".Code;
        }
        field(1001; "Free field 1"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(1001);
            Caption = 'Free field 1';
            TableRelation = Code.Code WHERE("Table No" = CONST(8001300),
                                             "Field No" = CONST(1001));
        }
        field(1002; "Free field 2"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(1002);
            Caption = 'Free field 2';
            TableRelation = Code.Code WHERE("Table No" = CONST(8001300),
                                             "Field No" = CONST(1002));
        }
        field(1003; "Free field 3"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(1003);
            Caption = 'Free field 3';
            TableRelation = Code.Code WHERE("Table No" = CONST(8001300),
                                             "Field No" = CONST(1003));
        }
        field(1004; "Free field 4"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(1004);
            Caption = 'Free field 4';
            TableRelation = Code.Code WHERE("Table No" = CONST(8001300),
                                             "Field No" = CONST(1004));
        }
        field(1005; "Free field 5"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(1005);
            Caption = 'Free field 5';
            TableRelation = Code.Code WHERE("Table No" = CONST(8001300),
                                             "Field No" = CONST(1005));
        }
        field(1006; "Free field 6"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(1006);
            Caption = 'Free field 6';
            TableRelation = Code.Code WHERE("Table No" = CONST(8001300),
                                             "Field No" = CONST(1006));
        }
        field(1007; "Free field 7"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(1007);
            Caption = 'Free field 7';
            TableRelation = Code.Code WHERE("Table No" = CONST(8001300),
                                             "Field No" = CONST(1007));
        }
        field(1008; "Free field 8"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(1008);
            Caption = 'Free field 8';
            TableRelation = Code.Code WHERE("Table No" = CONST(8001300),
                                             "Field No" = CONST(1008));
        }
        field(1009; "Free field 9"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(1009);
            Caption = 'Free field 9';
            TableRelation = Code.Code WHERE("Table No" = CONST(8001300),
                                             "Field No" = CONST(1009));
        }
        field(1010; "Free field 10"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(1010);
            Caption = 'Free field 10';
            TableRelation = Code.Code WHERE("Table No" = CONST(8001300),
                                             "Field No" = CONST(1010));
        }
        field(1011; "Free date 1"; Date)
        {
            CaptionClass = GetCaptionsStatsExplorer(1011);
            Caption = 'Free date 1';
        }
        field(1012; "Free date 2"; Date)
        {
            CaptionClass = GetCaptionsStatsExplorer(1012);
            Caption = 'Free date 2';
        }
        field(1013; "Free date 3"; Date)
        {
            CaptionClass = GetCaptionsStatsExplorer(1013);
            Caption = 'Free date 3';
        }
        field(1014; "Free date 4"; Date)
        {
            CaptionClass = GetCaptionsStatsExplorer(1014);
            Caption = 'Free date 4';
        }
        field(1015; "Free date 5"; Date)
        {
            CaptionClass = GetCaptionsStatsExplorer(1015);
            Caption = 'Free date 5';
        }
        field(1021; "Free boolean 1"; Boolean)
        {
            CaptionClass = GetCaptionsStatsExplorer(1021);
            Caption = 'Free boolean 1';
        }
        field(1022; "Free boolean 2"; Boolean)
        {
            CaptionClass = GetCaptionsStatsExplorer(1022);
            Caption = 'Free boolean 2';
        }
        field(1023; "Free boolean 3"; Boolean)
        {
            CaptionClass = GetCaptionsStatsExplorer(1023);
            Caption = 'Free boolean 3';
        }
        field(1024; "Free boolean 4"; Boolean)
        {
            CaptionClass = GetCaptionsStatsExplorer(1024);
            Caption = 'Free boolean 4';
        }
        field(1025; "Free boolean 5"; Boolean)
        {
            CaptionClass = GetCaptionsStatsExplorer(1025);
            Caption = 'Free boolean 5';
        }
        field(30001; "Dimension 1 Value Code"; Code[20])
        {
            CaptionClass = GetCaptionClass(1);
            Caption = 'Dimension 1 Value Code';

            trigger OnLookup()
            begin
                DimValue.SetRange("Dimension Code", StatisticsSetup."Dimension 1 Code");
                DimValue.SetRange("Dimension Value Type", DimValue."Dimension Value Type"::Standard);
                if PAGE.RunModal(0, DimValue) = ACTION::LookupOK then begin
                    "Dimension 1 Value Code" := DimValue.Code;
                end;
            end;
        }
        field(30002; "Dimension 2 Value Code"; Code[20])
        {
            CaptionClass = GetCaptionClass(2);
            Caption = 'Dimension 2 Value Code';

            trigger OnLookup()
            begin
                DimValue.SetRange("Dimension Code", StatisticsSetup."Dimension 2 Code");
                DimValue.SetRange("Dimension Value Type", DimValue."Dimension Value Type"::Standard);
                if PAGE.RunModal(0, DimValue) = ACTION::LookupOK then begin
                    "Dimension 2 Value Code" := DimValue.Code;
                end;
            end;
        }
        field(30003; "Dimension 3 Value Code"; Code[20])
        {
            CaptionClass = GetCaptionClass(3);
            Caption = 'Dimension 3 Value Code';

            trigger OnLookup()
            begin
                DimValue.SetRange("Dimension Code", StatisticsSetup."Dimension 3 Code");
                DimValue.SetRange("Dimension Value Type", DimValue."Dimension Value Type"::Standard);
                if PAGE.RunModal(0, DimValue) = ACTION::LookupOK then begin
                    "Dimension 3 Value Code" := DimValue.Code;
                end;
            end;
        }
        field(30004; "Dimension 4 Value Code"; Code[20])
        {
            CaptionClass = GetCaptionClass(4);
            Caption = 'Dimension 4 Value Code';

            trigger OnLookup()
            begin
                DimValue.SetRange("Dimension Code", StatisticsSetup."Dimension 4 Code");
                DimValue.SetRange("Dimension Value Type", DimValue."Dimension Value Type"::Standard);
                if PAGE.RunModal(0, DimValue) = ACTION::LookupOK then begin
                    "Dimension 4 Value Code" := DimValue.Code;
                end;
            end;
        }
        field(30005; "Dimension 5 Value Code"; Code[20])
        {
            CaptionClass = GetCaptionClass(5);
            Caption = 'Dimension 5 Value Code';

            trigger OnLookup()
            begin
                DimValue.SetRange("Dimension Code", StatisticsSetup."Dimension 5 Code");
                DimValue.SetRange("Dimension Value Type", DimValue."Dimension Value Type"::Standard);
                if PAGE.RunModal(0, DimValue) = ACTION::LookupOK then begin
                    "Dimension 5 Value Code" := DimValue.Code;
                end;
            end;
        }
        field(30006; "Dimension 6 Value Code"; Code[20])
        {
            CaptionClass = GetCaptionClass(6);
            Caption = 'Dimension 6 Value Code';

            trigger OnLookup()
            begin
                DimValue.SetRange("Dimension Code", StatisticsSetup."Dimension 6 Code");
                DimValue.SetRange("Dimension Value Type", DimValue."Dimension Value Type"::Standard);
                if PAGE.RunModal(0, DimValue) = ACTION::LookupOK then begin
                    "Dimension 6 Value Code" := DimValue.Code;
                end;
            end;
        }
        field(30007; "Dimension 7 Value Code"; Code[20])
        {
            CaptionClass = GetCaptionClass(7);
            Caption = 'Dimension 7 Value Code';

            trigger OnLookup()
            begin
                DimValue.SetRange("Dimension Code", StatisticsSetup."Dimension 7 Code");
                DimValue.SetRange("Dimension Value Type", DimValue."Dimension Value Type"::Standard);
                if PAGE.RunModal(0, DimValue) = ACTION::LookupOK then begin
                    "Dimension 7 Value Code" := DimValue.Code;
                end;
            end;
        }
        field(30008; "Dimension 8 Value Code"; Code[20])
        {
            CaptionClass = GetCaptionClass(8);
            Caption = 'Dimension 8 Value Code';

            trigger OnLookup()
            begin
                DimValue.SetRange("Dimension Code", StatisticsSetup."Dimension 8 Code");
                DimValue.SetRange("Dimension Value Type", DimValue."Dimension Value Type"::Standard);
                if PAGE.RunModal(0, DimValue) = ACTION::LookupOK then begin
                    "Dimension 8 Value Code" := DimValue.Code;
                end;
            end;
        }
        field(30009; "Dimension 9 Value Code"; Code[20])
        {
            CaptionClass = GetCaptionClass(9);
            Caption = 'Dimension 9 Value Code';

            trigger OnLookup()
            begin
                DimValue.SetRange("Dimension Code", StatisticsSetup."Dimension 9 Code");
                DimValue.SetRange("Dimension Value Type", DimValue."Dimension Value Type"::Standard);
                if PAGE.RunModal(0, DimValue) = ACTION::LookupOK then begin
                    "Dimension 9 Value Code" := DimValue.Code;
                end;
            end;
        }
        field(30010; "Dimension 10 Value Code"; Code[20])
        {
            CaptionClass = GetCaptionClass(10);
            Caption = 'Dimension 10 Value Code';

            trigger OnLookup()
            begin
                DimValue.SetRange("Dimension Code", StatisticsSetup."Dimension 10 Code");
                DimValue.SetRange("Dimension Value Type", DimValue."Dimension Value Type"::Standard);
                if PAGE.RunModal(0, DimValue) = ACTION::LookupOK then begin
                    "Dimension 10 Value Code" := DimValue.Code;
                end;
            end;
        }
        field(30011; "Dimension 11 Value Code"; Code[20])
        {
            CaptionClass = GetCaptionClass(11);
            Caption = 'Dimension 11 Value Code';

            trigger OnLookup()
            begin
                DimValue.SetRange("Dimension Code", StatisticsSetup."Dimension 11 Code");
                DimValue.SetRange("Dimension Value Type", DimValue."Dimension Value Type"::Standard);
                if PAGE.RunModal(0, DimValue) = ACTION::LookupOK then begin
                    "Dimension 11 Value Code" := DimValue.Code;
                end;
            end;
        }
        field(30012; "Dimension 12 Value Code"; Code[20])
        {
            CaptionClass = GetCaptionClass(12);
            Caption = 'Dimension 12 Value Code';

            trigger OnLookup()
            begin
                DimValue.SetRange("Dimension Code", StatisticsSetup."Dimension 12 Code");
                DimValue.SetRange("Dimension Value Type", DimValue."Dimension Value Type"::Standard);
                if PAGE.RunModal(0, DimValue) = ACTION::LookupOK then begin
                    "Dimension 12 Value Code" := DimValue.Code;
                end;
            end;
        }
        field(30013; "Dimension 13 Value Code"; Code[20])
        {
            CaptionClass = GetCaptionClass(13);
            Caption = 'Dimension 13 Value Code';

            trigger OnLookup()
            begin
                DimValue.SetRange("Dimension Code", StatisticsSetup."Dimension 13 Code");
                DimValue.SetRange("Dimension Value Type", DimValue."Dimension Value Type"::Standard);
                if PAGE.RunModal(0, DimValue) = ACTION::LookupOK then begin
                    "Dimension 13 Value Code" := DimValue.Code;
                end;
            end;
        }
        field(30014; "Dimension 14 Value Code"; Code[20])
        {
            CaptionClass = GetCaptionClass(14);
            Caption = 'Dimension 14 Value Code';

            trigger OnLookup()
            begin
                DimValue.SetRange("Dimension Code", StatisticsSetup."Dimension 14 Code");
                DimValue.SetRange("Dimension Value Type", DimValue."Dimension Value Type"::Standard);
                if PAGE.RunModal(0, DimValue) = ACTION::LookupOK then begin
                    "Dimension 14 Value Code" := DimValue.Code;
                end;
            end;
        }
        field(30015; "Dimension 15 Value Code"; Code[20])
        {
            CaptionClass = GetCaptionClass(15);
            Caption = 'Dimension 15 Value Code';

            trigger OnLookup()
            begin
                DimValue.SetRange("Dimension Code", StatisticsSetup."Dimension 15 Code");
                DimValue.SetRange("Dimension Value Type", DimValue."Dimension Value Type"::Standard);
                if PAGE.RunModal(0, DimValue) = ACTION::LookupOK then begin
                    "Dimension 15 Value Code" := DimValue.Code;
                end;
            end;
        }
        field(30016; "Dimension 16 Value Code"; Code[20])
        {
            CaptionClass = GetCaptionClass(16);
            Caption = 'Dimension 16 Value Code';

            trigger OnLookup()
            begin
                DimValue.SetRange("Dimension Code", StatisticsSetup."Dimension 16 Code");
                DimValue.SetRange("Dimension Value Type", DimValue."Dimension Value Type"::Standard);
                if PAGE.RunModal(0, DimValue) = ACTION::LookupOK then begin
                    "Dimension 16 Value Code" := DimValue.Code;
                end;
            end;
        }
        field(30017; "Dimension 17 Value Code"; Code[20])
        {
            CaptionClass = GetCaptionClass(17);
            Caption = 'Dimension 17 Value Code';

            trigger OnLookup()
            begin
                DimValue.SetRange("Dimension Code", StatisticsSetup."Dimension 17 Code");
                DimValue.SetRange("Dimension Value Type", DimValue."Dimension Value Type"::Standard);
                if PAGE.RunModal(0, DimValue) = ACTION::LookupOK then begin
                    "Dimension 17 Value Code" := DimValue.Code;
                end;
            end;
        }
        field(30018; "Dimension 18 Value Code"; Code[20])
        {
            CaptionClass = GetCaptionClass(18);
            Caption = 'Dimension 18 Value Code';

            trigger OnLookup()
            begin
                DimValue.SetRange("Dimension Code", StatisticsSetup."Dimension 18 Code");
                DimValue.SetRange("Dimension Value Type", DimValue."Dimension Value Type"::Standard);
                if PAGE.RunModal(0, DimValue) = ACTION::LookupOK then begin
                    "Dimension 18 Value Code" := DimValue.Code;
                end;
            end;
        }
        field(30019; "Dimension 19 Value Code"; Code[20])
        {
            CaptionClass = GetCaptionClass(19);
            Caption = 'Dimension 19 Value Code';

            trigger OnLookup()
            begin
                DimValue.SetRange("Dimension Code", StatisticsSetup."Dimension 19 Code");
                DimValue.SetRange("Dimension Value Type", DimValue."Dimension Value Type"::Standard);
                if PAGE.RunModal(0, DimValue) = ACTION::LookupOK then begin
                    "Dimension 19 Value Code" := DimValue.Code;
                end;
            end;
        }
        field(30020; "Dimension 20 Value Code"; Code[20])
        {
            CaptionClass = GetCaptionClass(20);
            Caption = 'Dimension 20 Value Code';

            trigger OnLookup()
            begin
                DimValue.SetRange("Dimension Code", StatisticsSetup."Dimension 20 Code");
                DimValue.SetRange("Dimension Value Type", DimValue."Dimension Value Type"::Standard);
                if PAGE.RunModal(0, DimValue) = ACTION::LookupOK then begin
                    "Dimension 20 Value Code" := DimValue.Code;
                end;
            end;
        }
        field(50000; "Vendor criteria 1"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(1);
            Caption = 'Customer criteria 1';
            Description = 'STA-000';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001301));
        }
        field(50001; "Vendor criteria 2"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(2);
            Caption = 'Customer criteria 2';
            Description = 'STA-000';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001302));
        }
        field(50002; "Vendor criteria 3"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(3);
            Caption = 'Customer criteria 3';
            Description = 'STA-000';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001303));
        }
        field(50003; "Vendor criteria 4"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(4);
            Caption = 'Customer criteria 4';
            Description = 'STA-000';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001304));
        }
        field(50004; "Vendor criteria 5"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(5);
            Caption = 'Customer criteria 5';
            Description = 'STA-000';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001305));
        }
        field(50005; "Vendor criteria 6"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(6);
            Caption = 'Customer criteria 6';
            Description = 'STA-000';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001306));
        }
        field(50006; "Vendor criteria 7"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(7);
            Caption = 'Customer criteria 7';
            Description = 'STA-000';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001307));
        }
        field(50007; "Vendor criteria 8"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(8);
            Caption = 'Customer criteria 8';
            Description = 'STA-000';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001308));
        }
        field(50008; "Vendor criteria 9"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(9);
            Caption = 'Customer criteria 9';
            Description = 'STA-000';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001309));
        }
        field(50009; "Vendor criteria 10"; Code[20])
        {
            CaptionClass = GetCaptionsStatsExplorer(10);
            Caption = 'Customer criteria 10';
            Description = 'STA-000';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001310));
        }
        field(50010; RFA; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50011; "Coop Comm"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Period Length", "Entry Type", "Ending Date")
        {
        }
        key(Key3; "Entry Type", "Ending Date")
        {
        }
        key(Key4; "Entry Type", Type, "No.", "Source Type", "Source No.", "Location Code", "Inventory Posting Group", "Source Posting Group", "Gen. Bus. Posting Group", "Gen. Prod. Posting Group", "Salespers./Purch. Code", "Global Dimension 1 Code", "Global Dimension 2 Code", "Reason Code", "Ending Date")
        {
        }
        key(Key5; "Ending Date")
        {
        }
        key(Key6; "Period Length", "Ending Date", "Entry Type", Type, "No.", "Source Type", "Source No.", "Location Code", "Inventory Posting Group", "Source Posting Group", "Gen. Bus. Posting Group", "Gen. Prod. Posting Group", "Salespers./Purch. Code", "Global Dimension 1 Code", "Global Dimension 2 Code", "Country Code", "Business Unit Code")
        {
        }
        key(Key7; "Source Type", "Source No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        DimValue: Record "Dimension Value";
        StatisticsSetup: Record "Statistics setup";
        DimManagement: Codeunit DimensionManagement;
        Text001: Label '1,5,,Dimension 1 Value Code';
        Text002: Label '1,5,,Dimension 2 Value Code';
        Text003: Label '1,5,,Dimension 3 Value Code';
        Text004: Label '1,5,,Dimension 4 Value Code';
        Text005: Label '1,5,,Dimension 5 Value Code';
        Text006: Label '1,5,,Dimension 6 Value Code';
        Text007: Label '1,5,,Dimension 7 Value Code';
        Text008: Label '1,5,,Dimension 8 Value Code';
        Text009: Label '1,5,,Dimension 9 Value Code';
        Text010: Label '1,5,,Dimension 10 Value Code';
        Text011: Label '1,5,,Dimension 11 Value Code';
        Text012: Label '1,5,,Dimension 12 Value Code';
        Text013: Label '1,5,,Dimension 13 Value Code';
        Text014: Label '1,5,,Dimension 14 Value Code';
        Text015: Label '1,5,,Dimension 15 Value Code';
        Text016: Label '1,5,,Dimension 16 Value Code';
        Text017: Label '1,5,,Dimension 17 Value Code';
        Text018: Label '1,5,,Dimension 18 Value Code';
        Text019: Label '1,5,,Dimension 19 Value Code';
        Text020: Label '1,5,,Dimension 20 Value Code';

    [Scope('OnPrem')]
    procedure GetCaptionClass(AnalysisViewDimType: Integer): Text[250]
    begin
        StatisticsSetup.Get;
        case AnalysisViewDimType of
            1:
                begin
                    if StatisticsSetup."Dimension 1 Code" <> '' then
                        exit('1,5,' + StatisticsSetup."Dimension 1 Code")
                    else
                        exit(Text001);
                end;
            2:
                begin
                    if StatisticsSetup."Dimension 2 Code" <> '' then
                        exit('1,5,' + StatisticsSetup."Dimension 2 Code")
                    else
                        exit(Text002);
                end;
            3:
                begin
                    if StatisticsSetup."Dimension 3 Code" <> '' then
                        exit('1,5,' + StatisticsSetup."Dimension 3 Code")
                    else
                        exit(Text003);
                end;
            4:
                begin
                    if StatisticsSetup."Dimension 4 Code" <> '' then
                        exit('1,5,' + StatisticsSetup."Dimension 4 Code")
                    else
                        exit(Text004);
                end;
            5:
                begin
                    if StatisticsSetup."Dimension 5 Code" <> '' then
                        exit('1,5,' + StatisticsSetup."Dimension 5 Code")
                    else
                        exit(Text005);
                end;
            6:
                begin
                    if StatisticsSetup."Dimension 6 Code" <> '' then
                        exit('1,5,' + StatisticsSetup."Dimension 6 Code")
                    else
                        exit(Text006);
                end;
            7:
                begin
                    if StatisticsSetup."Dimension 7 Code" <> '' then
                        exit('1,5,' + StatisticsSetup."Dimension 7 Code")
                    else
                        exit(Text007);
                end;
            8:
                begin
                    if StatisticsSetup."Dimension 8 Code" <> '' then
                        exit('1,5,' + StatisticsSetup."Dimension 8 Code")
                    else
                        exit(Text008);
                end;
            9:
                begin
                    if StatisticsSetup."Dimension 9 Code" <> '' then
                        exit('1,5,' + StatisticsSetup."Dimension 9 Code")
                    else
                        exit(Text009);
                end;
            10:
                begin
                    if StatisticsSetup."Dimension 10 Code" <> '' then
                        exit('1,5,' + StatisticsSetup."Dimension 10 Code")
                    else
                        exit(Text010);
                end;
            11:
                begin
                    if StatisticsSetup."Dimension 11 Code" <> '' then
                        exit('1,5,' + StatisticsSetup."Dimension 11 Code")
                    else
                        exit(Text011);
                end;
            12:
                begin
                    if StatisticsSetup."Dimension 12 Code" <> '' then
                        exit('1,5,' + StatisticsSetup."Dimension 12 Code")
                    else
                        exit(Text012);
                end;
            13:
                begin
                    if StatisticsSetup."Dimension 13 Code" <> '' then
                        exit('1,5,' + StatisticsSetup."Dimension 13 Code")
                    else
                        exit(Text013);
                end;
            14:
                begin
                    if StatisticsSetup."Dimension 14 Code" <> '' then
                        exit('1,5,' + StatisticsSetup."Dimension 14 Code")
                    else
                        exit(Text014);
                end;
            15:
                begin
                    if StatisticsSetup."Dimension 15 Code" <> '' then
                        exit('1,5,' + StatisticsSetup."Dimension 15 Code")
                    else
                        exit(Text015);
                end;
            16:
                begin
                    if StatisticsSetup."Dimension 16 Code" <> '' then
                        exit('1,5,' + StatisticsSetup."Dimension 16 Code")
                    else
                        exit(Text016);
                end;
            17:
                begin
                    if StatisticsSetup."Dimension 17 Code" <> '' then
                        exit('1,5,' + StatisticsSetup."Dimension 17 Code")
                    else
                        exit(Text017);
                end;
            18:
                begin
                    if StatisticsSetup."Dimension 18 Code" <> '' then
                        exit('1,5,' + StatisticsSetup."Dimension 18 Code")
                    else
                        exit(Text018);
                end;
            19:
                begin
                    if StatisticsSetup."Dimension 19 Code" <> '' then
                        exit('1,5,' + StatisticsSetup."Dimension 19 Code")
                    else
                        exit(Text019);
                end;
            20:
                begin
                    if StatisticsSetup."Dimension 20 Code" <> '' then
                        exit('1,5,' + StatisticsSetup."Dimension 20 Code")
                    else
                        exit(Text020);
                end;
        end;
    end;

    [Scope('OnPrem')]
    procedure GetCaptionsStatsExplorer(CriteriaNumber: Integer) ReturnValue: Text[250]
    var
        ReturnText: Text[250];
    begin
        with StatisticsSetup do begin
            Get;
            case CriteriaNumber of
                1:
                    if "Customer criteria name 1" <> '' then
                        ReturnText := '1,5,,' + "Customer criteria name 1"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Customer criteria 1");
                2:
                    if "Customer criteria name 2" <> '' then
                        ReturnText := '1,5,,' + "Customer criteria name 2"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Customer criteria 2");
                3:
                    if "Customer criteria name 3" <> '' then
                        ReturnText := '1,5,,' + "Customer criteria name 3"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Customer criteria 3");
                4:
                    if "Customer criteria name 4" <> '' then
                        ReturnText := '1,5,,' + "Customer criteria name 4"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Customer criteria 4");
                5:
                    if "Customer criteria name 5" <> '' then
                        ReturnText := '1,5,,' + "Customer criteria name 5"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Customer criteria 5");
                6:
                    if "Customer criteria name 6" <> '' then
                        ReturnText := '1,5,,' + "Customer criteria name 6"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Customer criteria 6");
                7:
                    if "Customer criteria name 7" <> '' then
                        ReturnText := '1,5,,' + "Customer criteria name 7"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Customer criteria 7");
                8:
                    if "Customer criteria name 8" <> '' then
                        ReturnText := '1,5,,' + "Customer criteria name 8"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Customer criteria 8");
                9:
                    if "Customer criteria name 9" <> '' then
                        ReturnText := '1,5,,' + "Customer criteria name 9"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Customer criteria 9");
                10:
                    if "Customer criteria name 10" <> '' then
                        ReturnText := '1,5,,' + "Customer criteria name 10"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Customer criteria 10");
                11:
                    if "Item criteria name 1" <> '' then
                        ReturnText := '1,5,,' + "Item criteria name 1"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Item criteria 1");
                12:
                    if "Item criteria name 2" <> '' then
                        ReturnText := '1,5,,' + "Item criteria name 2"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Item criteria 2");
                13:
                    if "Item criteria name 3" <> '' then
                        ReturnText := '1,5,,' + "Item criteria name 3"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Item criteria 3");
                14:
                    if "Item criteria name 4" <> '' then
                        ReturnText := '1,5,,' + "Item criteria name 4"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Item criteria 4");
                15:
                    if "Item criteria name 5" <> '' then
                        ReturnText := '1,5,,' + "Item criteria name 5"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Item criteria 5");
                16:
                    if "Item criteria name 6" <> '' then
                        ReturnText := '1,5,,' + "Item criteria name 6"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Item criteria 6");
                17:
                    if "Item criteria name 7" <> '' then
                        ReturnText := '1,5,,' + "Item criteria name 7"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Item criteria 7");
                18:
                    if "Item criteria name 8" <> '' then
                        ReturnText := '1,5,,' + "Item criteria name 8"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Item criteria 8");
                19:
                    if "Item criteria name 9" <> '' then
                        ReturnText := '1,5,,' + "Item criteria name 9"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Item criteria 9");
                20:
                    if "Item criteria name 10" <> '' then
                        ReturnText := '1,5,,' + "Item criteria name 10"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Item criteria 10");
                21:
                    ReturnText := '1,5,,' + 'Matière première';
                22:
                    ReturnText := '1,5,,' + 'Type de film';

                81:
                    if "Free value name 1" <> '' then
                        ReturnText := '1,5,,' + "Free value name 1"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Free value 1");
                82:
                    if "Free value name 2" <> '' then
                        ReturnText := '1,5,,' + "Free value name 2"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Free value 2");
                83:
                    if "Free value name 3" <> '' then
                        ReturnText := '1,5,,' + "Free value name 3"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Free value 3");
                84:
                    if "Free value name 4" <> '' then
                        ReturnText := '1,5,,' + "Free value name 4"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Free value 4");
                85:
                    if "Free value name 5" <> '' then
                        ReturnText := '1,5,,' + "Free value name 5"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Free value 5");
                86:
                    if "Free value name 6" <> '' then
                        ReturnText := '1,5,,' + "Free value name 6"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Free value 6");
                87:
                    if "Free value name 7" <> '' then
                        ReturnText := '1,5,,' + "Free value name 7"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Free value 7");
                88:
                    if "Free value name 8" <> '' then
                        ReturnText := '1,5,,' + "Free value name 8"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Free value 8");
                89:
                    if "Free value name 9" <> '' then
                        ReturnText := '1,5,,' + "Free value name 9"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Free value 9");
                90:
                    if "Free value name 10" <> '' then
                        ReturnText := '1,5,,' + "Free value name 10"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Free value 10");
                91:
                    if "Job criteria name 1" <> '' then
                        ReturnText := '1,5,,' + "Job criteria name 1"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Job criteria 1");
                92:
                    if "Job criteria name 2" <> '' then
                        ReturnText := '1,5,,' + "Job criteria name 2"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Job criteria 2");
                93:
                    if "Job criteria name 3" <> '' then
                        ReturnText := '1,5,,' + "Job criteria name 3"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Job criteria 3");
                94:
                    if "Job criteria name 4" <> '' then
                        ReturnText := '1,5,,' + "Job criteria name 4"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Job criteria 4");
                95:
                    if "Job criteria name 5" <> '' then
                        ReturnText := '1,5,,' + "Job criteria name 5"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Job criteria 5");
                96:
                    if "Job criteria name 6" <> '' then
                        ReturnText := '1,5,,' + "Job criteria name 6"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Job criteria 6");
                97:
                    if "Job criteria name 7" <> '' then
                        ReturnText := '1,5,,' + "Job criteria name 7"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Job criteria 7");
                98:
                    if "Job criteria name 8" <> '' then
                        ReturnText := '1,5,,' + "Job criteria name 8"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Job criteria 8");
                99:
                    if "Job criteria name 9" <> '' then
                        ReturnText := '1,5,,' + "Job criteria name 9"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Job criteria 9");
                100:
                    if "Job criteria name 10" <> '' then
                        ReturnText := '1,5,,' + "Job criteria name 10"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Job criteria 10");
                1001:
                    if "Free field name 1" <> '' then
                        ReturnText := '1,5,,' + "Free field name 1"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Free field 1");
                1002:
                    if "Free field name 2" <> '' then
                        ReturnText := '1,5,,' + "Free field name 2"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Free field 2");
                1003:
                    if "Free field name 3" <> '' then
                        ReturnText := '1,5,,' + "Free field name 3"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Free field 3");
                1004:
                    if "Free field name 4" <> '' then
                        ReturnText := '1,5,,' + "Free field name 4"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Free field 4");
                1005:
                    if "Free field name 5" <> '' then
                        ReturnText := '1,5,,' + "Free field name 5"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Free field 5");
                1006:
                    if "Free field name 6" <> '' then
                        ReturnText := '1,5,,' + "Free field name 6"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Free field 6");
                1007:
                    if "Free field name 7" <> '' then
                        ReturnText := '1,5,,' + "Free field name 7"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Free field 7");
                1008:
                    if "Free field name 8" <> '' then
                        ReturnText := '1,5,,' + "Free field name 8"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Free field 8");
                1009:
                    if "Free field name 9" <> '' then
                        ReturnText := '1,5,,' + "Free field name 9"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Free field 9");
                1010:
                    if "Free field name 10" <> '' then
                        ReturnText := '1,5,,' + "Free field name 10"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Free field 10");
                1011:
                    if "Free date name 1" <> '' then
                        ReturnText := '1,5,,' + "Free date name 1"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Free date 1");
                1012:
                    if "Free date name 2" <> '' then
                        ReturnText := '1,5,,' + "Free date name 2"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Free date 2");
                1013:
                    if "Free date name 3" <> '' then
                        ReturnText := '1,5,,' + "Free date name 3"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Free date 3");
                1014:
                    if "Free date name 4" <> '' then
                        ReturnText := '1,5,,' + "Free date name 4"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Free date 4");
                1015:
                    if "Free date name 5" <> '' then
                        ReturnText := '1,5,,' + "Free date name 5"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Free date 5");
                1021:
                    if "Free check name 1" <> '' then
                        ReturnText := '1,5,,' + "Free check name 1"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Free boolean 1");
                1022:
                    if "Free check name 2" <> '' then
                        ReturnText := '1,5,,' + "Free check name 2"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Free boolean 2");
                1023:
                    if "Free check name 3" <> '' then
                        ReturnText := '1,5,,' + "Free check name 3"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Free boolean 3");
                1024:
                    if "Free check name 4" <> '' then
                        ReturnText := '1,5,,' + "Free check name 4"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Free boolean 4");
                1025:
                    if "Free check name 5" <> '' then
                        ReturnText := '1,5,,' + "Free check name 5"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Free boolean 5");

                //--> STA-000 ABSYS GN 20061005 ----------------------------------------------
                50000:
                    if "Vendor criteria name 1" <> '' then
                        ReturnText := '1,5,,' + "Vendor criteria name 1"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Vendor criteria 1");
                50001:
                    if "Vendor criteria name 2" <> '' then
                        ReturnText := '1,5,,' + "Vendor criteria name 2"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Vendor criteria 2");
                50002:
                    if "Vendor criteria name 3" <> '' then
                        ReturnText := '1,5,,' + "Vendor criteria name 3"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Vendor criteria 3");
                50003:
                    if "Vendor criteria name 4" <> '' then
                        ReturnText := '1,5,,' + "Vendor criteria name 4"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Vendor criteria 4");
                50004:
                    if "Vendor criteria name 5" <> '' then
                        ReturnText := '1,5,,' + "Vendor criteria name 5"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Vendor criteria 5");
                50005:
                    if "Vendor criteria name 6" <> '' then
                        ReturnText := '1,5,,' + "Vendor criteria name 6"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Vendor criteria 6");
                50006:
                    if "Vendor criteria name 7" <> '' then
                        ReturnText := '1,5,,' + "Vendor criteria name 7"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Vendor criteria 7");
                50007:
                    if "Vendor criteria name 8" <> '' then
                        ReturnText := '1,5,,' + "Vendor criteria name 8"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Vendor criteria 8");
                50008:
                    if "Vendor criteria name 9" <> '' then
                        ReturnText := '1,5,,' + "Vendor criteria name 9"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Vendor criteria 9");
                50009:
                    if "Vendor criteria name 10" <> '' then
                        ReturnText := '1,5,,' + "Vendor criteria name 10"
                    else
                        ReturnText := '1,5,,' + Rec.FieldCaption("Vendor criteria 10");

            //<-- STA-000 ABSYS GN 20061005 ----------------------------------------------

            end;
            exit(ReturnText);
        end;
    end;
}

