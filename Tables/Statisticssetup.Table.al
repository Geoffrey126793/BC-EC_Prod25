table 8001302 "Statistics setup"
{
    // -------------------------------------------------------------------------------------------
    //   STA-000 ABSYS GN 20061005 (Ajout de critères StatsExplorer sur Vendor)
    //     Add Fields :
    //       50000 - 50009 : Vendor criteria name 1...Vendor criteria name 10 (Text 30) + ADD CODE
    //       50010 - 50019 : Vendor criteria 10 required ... Vendor criteria 10 required (Boolean)
    // -------------------------------------------------------------------------------------------
    // 
    // //STATSEXPLORER STATSEXPLORER 01/10/01 Statistics setup

    Caption = 'Statistics setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(10; "Last close date"; Date)
        {
            Caption = 'Last close date';
        }
        field(20; "Last aggregate process date"; Date)
        {
            Caption = 'Last aggregate process date';
        }
        field(21; "Last aggregate process time"; Time)
        {
            Caption = 'Last aggregate process time';
        }
        field(30; "Scheduler process from date"; DateFormula)
        {
            Caption = 'Scheduler process from date';

            trigger OnValidate()
            begin
                if (CopyStr(Format("Scheduler process from date"), 1, 1) <> '-') and (CopyStr(Format("Scheduler process from date"), 1, 1) <> '+') then
                    Message(Message1);
            end;
        }
        field(31; "Scheduler process to date"; DateFormula)
        {
            Caption = 'Scheduler process to date';

            trigger OnValidate()
            begin
                if (CopyStr(Format("Scheduler process to date"), 1, 1) <> '-') and (CopyStr(Format("Scheduler process to date"), 1, 1) <> '+') then
                    Message(Message1);
            end;
        }
        field(100; "Last calculation start date"; Date)
        {
            Caption = 'Last calculation start date';

            trigger OnValidate()
            begin
                if "Last calculation start date" < "Last close date" then
                    Error(Error1, "Last close date");
            end;
        }
        field(101; "Last calculation end date"; Date)
        {
            Caption = 'Last calculation end date';
        }
        field(102; "Period total basis"; Option)
        {
            Caption = 'Period total basis';
            OptionCaption = 'Day,Week,Month,Quarter,Year,Period,According to every flow';
            OptionMembers = Day,Week,Month,Quarter,Year,Period,"According to every flow";

            trigger OnValidate()
            begin
                if ("Period total basis" <> xRec."Period total basis") and
                   ("Period total basis" = "Period total basis"::"According to every flow") then
                    Message(Message2);
                Commit;
                UpdateStatisticCriteria;
            end;
        }
        field(103; "Allow Changes in Period Length"; Boolean)
        {
            Caption = 'Allow Changes in Period Length';
        }
        field(104; "Aggregate, real time update"; Boolean)
        {
            Caption = 'Aggregate, real time update';
            InitValue = true;

            trigger OnValidate()
            begin
                UpdateStatisticCriteria;
            end;
        }
        field(105; "Historic duration"; DateFormula)
        {
            Caption = 'Historic duration';
        }
        field(1000; "Default Excel sheet"; Text[30])
        {
            Caption = 'Default Excel sheet';
        }
        field(30001; "Dimension 1 Code"; Code[20])
        {
            Caption = 'Dimension 1 Code';
            TableRelation = Dimension;

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Dimension 1 Code", "Dimension 1 Code", 201, 1);
            end;
        }
        field(30002; "Dimension 2 Code"; Code[20])
        {
            Caption = 'Dimension 2 Code';
            TableRelation = Dimension;

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Dimension 2 Code", "Dimension 2 Code", 202, 1);
            end;
        }
        field(30003; "Dimension 3 Code"; Code[20])
        {
            Caption = 'Dimension 3 Code';
            TableRelation = Dimension;

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Dimension 3 Code", "Dimension 3 Code", 203, 1);
            end;
        }
        field(30004; "Dimension 4 Code"; Code[20])
        {
            Caption = 'Dimension 4 Code';
            TableRelation = Dimension;

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Dimension 4 Code", "Dimension 4 Code", 204, 1);
            end;
        }
        field(30005; "Dimension 5 Code"; Code[20])
        {
            Caption = 'Dimension 5 Code';
            TableRelation = Dimension;

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Dimension 5 Code", "Dimension 5 Code", 205, 1);
            end;
        }
        field(30006; "Dimension 6 Code"; Code[20])
        {
            Caption = 'Dimension 6 Code';
            TableRelation = Dimension;

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Dimension 6 Code", "Dimension 6 Code", 206, 1);
            end;
        }
        field(30007; "Dimension 7 Code"; Code[20])
        {
            Caption = 'Dimension 7 Code';
            TableRelation = Dimension;

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Dimension 7 Code", "Dimension 7 Code", 207, 1);
            end;
        }
        field(30008; "Dimension 8 Code"; Code[20])
        {
            Caption = 'Dimension 8 Code';
            TableRelation = Dimension;

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Dimension 8 Code", "Dimension 8 Code", 208, 1);
            end;
        }
        field(30009; "Dimension 9 Code"; Code[20])
        {
            Caption = 'Dimension 9 Code';
            TableRelation = Dimension;

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Dimension 9 Code", "Dimension 9 Code", 209, 1);
            end;
        }
        field(30010; "Dimension 10 Code"; Code[20])
        {
            Caption = 'Dimension 10 Code';
            TableRelation = Dimension;

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Dimension 10 Code", "Dimension 10 Code", 210, 1);
            end;
        }
        field(30011; "Dimension 11 Code"; Code[20])
        {
            Caption = 'Dimension 11 Code';
            TableRelation = Dimension;

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Dimension 11 Code", "Dimension 11 Code", 211, 1);
            end;
        }
        field(30012; "Dimension 12 Code"; Code[20])
        {
            Caption = 'Dimension 12 Code';
            TableRelation = Dimension;

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Dimension 12 Code", "Dimension 12 Code", 212, 1);
            end;
        }
        field(30013; "Dimension 13 Code"; Code[20])
        {
            Caption = 'Dimension 13 Code';
            TableRelation = Dimension;

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Dimension 13 Code", "Dimension 13 Code", 213, 1);
            end;
        }
        field(30014; "Dimension 14 Code"; Code[20])
        {
            Caption = 'Dimension 14 Code';
            TableRelation = Dimension;

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Dimension 14 Code", "Dimension 14 Code", 214, 1);
            end;
        }
        field(30015; "Dimension 15 Code"; Code[20])
        {
            Caption = 'Dimension 15 Code';
            TableRelation = Dimension;

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Dimension 15 Code", "Dimension 15 Code", 215, 1);
            end;
        }
        field(30016; "Dimension 16 Code"; Code[20])
        {
            Caption = 'Dimension 16 Code';
            TableRelation = Dimension;

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Dimension 16 Code", "Dimension 16 Code", 216, 1);
            end;
        }
        field(30017; "Dimension 17 Code"; Code[20])
        {
            Caption = 'Dimension 17 Code';
            TableRelation = Dimension;

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Dimension 17 Code", "Dimension 17 Code", 217, 1);
            end;
        }
        field(30018; "Dimension 18 Code"; Code[20])
        {
            Caption = 'Dimension 18 Code';
            TableRelation = Dimension;

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Dimension 18 Code", "Dimension 18 Code", 218, 1);
            end;
        }
        field(30019; "Dimension 19 Code"; Code[20])
        {
            Caption = 'Dimension 19 Code';
            TableRelation = Dimension;

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Dimension 19 Code", "Dimension 19 Code", 219, 1);
            end;
        }
        field(30020; "Dimension 20 Code"; Code[20])
        {
            Caption = 'Dimension 20 Code';
            TableRelation = Dimension;

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Dimension 20 Code", "Dimension 20 Code", 220, 1);
            end;
        }
        field(50000; "Vendor criteria name 1"; Text[30])
        {
            Caption = 'Vendor criteria name 1';
            Description = 'STA-000';

            trigger OnValidate()
            begin
                //--> STA-000 ABSYS GN 20061005
                UpdateStatisticSetup(xRec."Vendor criteria name 1", "Vendor criteria name 1", 50000, 1);

                if "Vendor criteria name 1" = '' then
                    "Vendor criteria 1 required" := false
                else
                    "Vendor criteria 1 required" := true;
                //<-- STA-000 ABSYS GN 20061005
            end;
        }
        field(50001; "Vendor criteria name 2"; Text[30])
        {
            Caption = 'Vendor criteria name 2';
            Description = 'STA-000';

            trigger OnValidate()
            begin
                //--> STA-000 ABSYS GN 20061005
                UpdateStatisticSetup(xRec."Vendor criteria name 2", "Vendor criteria name 2", 50001, 1);

                if "Vendor criteria name 2" = '' then
                    "Vendor criteria 2 required" := false
                else
                    "Vendor criteria 2 required" := true;
                //<-- STA-000 ABSYS GN 20061005
            end;
        }
        field(50002; "Vendor criteria name 3"; Text[30])
        {
            Caption = 'Vendor criteria name 3';
            Description = 'STA-000';

            trigger OnValidate()
            begin
                //--> STA-000 ABSYS GN 20061005
                UpdateStatisticSetup(xRec."Vendor criteria name 3", "Vendor criteria name 3", 50002, 1);

                if "Vendor criteria name 3" = '' then
                    "Vendor criteria 3 required" := false
                else
                    "Vendor criteria 3 required" := true;
                //<-- STA-000 ABSYS GN 20061005
            end;
        }
        field(50003; "Vendor criteria name 4"; Text[30])
        {
            Caption = 'Vendor criteria name 4';
            Description = 'STA-000';

            trigger OnValidate()
            begin
                //--> STA-000 ABSYS GN 20061005
                UpdateStatisticSetup(xRec."Vendor criteria name 4", "Vendor criteria name 4", 50003, 1);

                if "Vendor criteria name 4" = '' then
                    "Vendor criteria 4 required" := false
                else
                    "Vendor criteria 4 required" := true;
                //<-- STA-000 ABSYS GN 20061005
            end;
        }
        field(50004; "Vendor criteria name 5"; Text[30])
        {
            Caption = 'Vendor criteria name 5';
            Description = 'STA-000';

            trigger OnValidate()
            begin
                //--> STA-000 ABSYS GN 20061005
                UpdateStatisticSetup(xRec."Vendor criteria name 5", "Vendor criteria name 5", 50004, 1);

                if "Vendor criteria name 5" = '' then
                    "Vendor criteria 5 required" := false
                else
                    "Vendor criteria 5 required" := true;
                //<-- STA-000 ABSYS GN 20061005
            end;
        }
        field(50005; "Vendor criteria name 6"; Text[30])
        {
            Caption = 'Vendor criteria name 6';
            Description = 'STA-000';

            trigger OnValidate()
            begin
                //--> STA-000 ABSYS GN 20061005
                UpdateStatisticSetup(xRec."Vendor criteria name 6", "Vendor criteria name 6", 50005, 1);

                if "Vendor criteria name 6" = '' then
                    "Vendor criteria 6 required" := false
                else
                    "Vendor criteria 6 required" := true;
                //<-- STA-000 ABSYS GN 20061005
            end;
        }
        field(50006; "Vendor criteria name 7"; Text[30])
        {
            Caption = 'Vendor criteria name 7';
            Description = 'STA-000';

            trigger OnValidate()
            begin
                //--> STA-000 ABSYS GN 20061005
                UpdateStatisticSetup(xRec."Vendor criteria name 7", "Vendor criteria name 7", 50006, 1);

                if "Vendor criteria name 7" = '' then
                    "Vendor criteria 7 required" := false
                else
                    "Vendor criteria 7 required" := true;
                //<-- STA-000 ABSYS GN 20061005
            end;
        }
        field(50007; "Vendor criteria name 8"; Text[30])
        {
            Caption = 'Vendor criteria name 8';
            Description = 'STA-000';

            trigger OnValidate()
            begin
                //--> STA-000 ABSYS GN 20061005
                UpdateStatisticSetup(xRec."Vendor criteria name 8", "Vendor criteria name 8", 50007, 1);

                if "Vendor criteria name 8" = '' then
                    "Vendor criteria 8 required" := false
                else
                    "Vendor criteria 8 required" := true;
                //<-- STA-000 ABSYS GN 20061005
            end;
        }
        field(50008; "Vendor criteria name 9"; Text[30])
        {
            Caption = 'Vendor criteria name 9';
            Description = 'STA-000';

            trigger OnValidate()
            begin
                //--> STA-000 ABSYS GN 20061005
                UpdateStatisticSetup(xRec."Vendor criteria name 9", "Vendor criteria name 9", 50008, 1);

                if "Vendor criteria name 9" = '' then
                    "Vendor criteria 9 required" := false
                else
                    "Vendor criteria 9 required" := true;
                //<-- STA-000 ABSYS GN 20061005
            end;
        }
        field(50009; "Vendor criteria name 10"; Text[30])
        {
            Caption = 'Vendor criteria name 10';
            Description = 'STA-000';

            trigger OnValidate()
            begin
                //--> STA-000 ABSYS GN 20061005
                UpdateStatisticSetup(xRec."Vendor criteria name 10", "Vendor criteria name 10", 50009, 1);

                if "Vendor criteria name 10" = '' then
                    "Vendor criteria 10 required" := false
                else
                    "Vendor criteria 10 required" := true;
                //<-- STA-000 ABSYS GN 20061005
            end;
        }
        field(50010; "Vendor criteria 1 required"; Boolean)
        {
            Caption = 'Vendor criteria 1 required';
            Description = 'STA-000';
        }
        field(50011; "Vendor criteria 2 required"; Boolean)
        {
            Caption = 'Vendor criteria 2 required';
            Description = 'STA-000';
        }
        field(50012; "Vendor criteria 3 required"; Boolean)
        {
            Caption = 'Vendor criteria 3 required';
            Description = 'STA-000';
        }
        field(50013; "Vendor criteria 4 required"; Boolean)
        {
            Caption = 'Vendor criteria 4 required';
            Description = 'STA-000';
        }
        field(50014; "Vendor criteria 5 required"; Boolean)
        {
            Caption = 'Vendor criteria 5 required';
            Description = 'STA-000';
        }
        field(50015; "Vendor criteria 6 required"; Boolean)
        {
            Caption = 'Vendor criteria 6 required';
            Description = 'STA-000';
        }
        field(50016; "Vendor criteria 7 required"; Boolean)
        {
            Caption = 'Vendor criteria 7 required';
            Description = 'STA-000';
        }
        field(50017; "Vendor criteria 8 required"; Boolean)
        {
            Caption = 'Vendor criteria 8 required';
            Description = 'STA-000';
        }
        field(50018; "Vendor criteria 9 required"; Boolean)
        {
            Caption = 'Vendor criteria 9 required';
            Description = 'STA-000';
        }
        field(50019; "Vendor criteria 10 required"; Boolean)
        {
            Caption = 'Vendor criteria 10 required';
            Description = 'STA-000';
        }
        field(99003; "Customer criteria name 1"; Text[30])
        {
            Caption = 'Customer criteria name 1';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Customer criteria name 1", "Customer criteria name 1", 70, 1);

                if "Customer criteria name 1" = '' then
                    "Customer criteria 1 required" := false
                else
                    "Customer criteria 1 required" := true;
            end;
        }
        field(99004; "Customer criteria name 2"; Text[30])
        {
            Caption = 'Customer criteria name 2';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Customer criteria name 2", "Customer criteria name 2", 71, 1);

                if "Customer criteria name 2" = '' then
                    "Customer criteria 2 required" := false
                else
                    "Customer criteria 2 required" := true;
            end;
        }
        field(99005; "Customer criteria name 3"; Text[30])
        {
            Caption = 'Customer criteria name 3';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Customer criteria name 3", "Customer criteria name 3", 72, 1);

                if "Customer criteria name 3" = '' then
                    "Customer criteria 3 required" := false
                else
                    "Customer criteria 3 required" := true;
            end;
        }
        field(99006; "Customer criteria name 4"; Text[30])
        {
            Caption = 'Customer criteria name 4';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Customer criteria name 4", "Customer criteria name 4", 73, 1);

                if "Customer criteria name 4" = '' then
                    "Customer criteria 4 required" := false
                else
                    "Customer criteria 4 required" := true;
            end;
        }
        field(99007; "Customer criteria name 5"; Text[30])
        {
            Caption = 'Customer criteria name 5';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Customer criteria name 5", "Customer criteria name 5", 74, 1);

                if "Customer criteria name 5" = '' then
                    "Customer criteria 5 required" := false
                else
                    "Customer criteria 5 required" := true;
            end;
        }
        field(99008; "Customer criteria name 6"; Text[30])
        {
            Caption = 'Customer criteria name 6';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Customer criteria name 6", "Customer criteria name 6", 75, 1);

                if "Customer criteria name 6" = '' then
                    "Customer criteria 6 required" := false
                else
                    "Customer criteria 6 required" := true;
            end;
        }
        field(99009; "Customer criteria name 7"; Text[30])
        {
            Caption = 'Customer criteria name 7';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Customer criteria name 7", "Customer criteria name 7", 76, 1);

                if "Customer criteria name 7" = '' then
                    "Customer criteria 7 required" := false
                else
                    "Customer criteria 7 required" := true;
            end;
        }
        field(99010; "Customer criteria name 8"; Text[30])
        {
            Caption = 'Customer criteria name 8';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Customer criteria name 8", "Customer criteria name 8", 77, 1);

                if "Customer criteria name 8" = '' then
                    "Customer criteria 8 required" := false
                else
                    "Customer criteria 8 required" := true;
            end;
        }
        field(99011; "Customer criteria name 9"; Text[30])
        {
            Caption = 'Customer criteria name 9';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Customer criteria name 9", "Customer criteria name 9", 78, 1);

                if "Customer criteria name 9" = '' then
                    "Customer criteria 9 required" := false
                else
                    "Customer criteria 9 required" := true;
            end;
        }
        field(99012; "Customer criteria name 10"; Text[30])
        {
            Caption = 'Customer criteria name 10';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Customer criteria name 10", "Customer criteria name 10", 79, 1);

                if "Customer criteria name 10" = '' then
                    "Customer criteria 10 required" := false
                else
                    "Customer criteria 10 required" := true;
            end;
        }
        field(99030; "Item criteria name 1"; Text[30])
        {
            Caption = 'Item criteria name 1';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Item criteria name 1", "Item criteria name 1", 60, 1);

                if "Item criteria name 1" = '' then
                    "Item criteria 1 required" := false
                else
                    "Item criteria 1 required" := true;
            end;
        }
        field(99031; "Item criteria name 2"; Text[30])
        {
            Caption = 'Item criteria name 2';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Item criteria name 2", "Item criteria name 2", 61, 1);

                if "Item criteria name 2" = '' then
                    "Item criteria 2 required" := false
                else
                    "Item criteria 2 required" := true;
            end;
        }
        field(99032; "Item criteria name 3"; Text[30])
        {
            Caption = 'Item criteria name 3';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Item criteria name 3", "Item criteria name 3", 62, 1);

                if "Item criteria name 3" = '' then
                    "Item criteria 3 required" := false
                else
                    "Item criteria 3 required" := true;
            end;
        }
        field(99033; "Item criteria name 4"; Text[30])
        {
            Caption = 'Item criteria name 4';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Item criteria name 4", "Item criteria name 4", 63, 1);

                if "Item criteria name 4" = '' then
                    "Item criteria 4 required" := false
                else
                    "Item criteria 4 required" := true;
            end;
        }
        field(99034; "Item criteria name 5"; Text[30])
        {
            Caption = 'Item criteria name 5';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Item criteria name 5", "Item criteria name 5", 64, 1);

                if "Item criteria name 5" = '' then
                    "Item criteria 5 required" := false
                else
                    "Item criteria 5 required" := true;
            end;
        }
        field(99035; "Item criteria name 6"; Text[30])
        {
            Caption = 'Item criteria name 6';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Item criteria name 6", "Item criteria name 6", 65, 1);

                if "Item criteria name 6" = '' then
                    "Item criteria 6 required" := false
                else
                    "Item criteria 6 required" := true;
            end;
        }
        field(99036; "Item criteria name 7"; Text[30])
        {
            Caption = 'Item criteria name 7';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Item criteria name 7", "Item criteria name 7", 66, 1);

                if "Item criteria name 7" = '' then
                    "Item criteria 7 required" := false
                else
                    "Item criteria 7 required" := true;
            end;
        }
        field(99037; "Item criteria name 8"; Text[30])
        {
            Caption = 'Item criteria name 8';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Item criteria name 8", "Item criteria name 8", 67, 1);

                if "Item criteria name 8" = '' then
                    "Item criteria 8 required" := false
                else
                    "Item criteria 8 required" := true;
            end;
        }
        field(99038; "Item criteria name 9"; Text[30])
        {
            Caption = 'Item criteria name 9';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Item criteria name 9", "Item criteria name 9", 68, 1);

                if "Item criteria name 9" = '' then
                    "Item criteria 9 required" := false
                else
                    "Item criteria 9 required" := true;
            end;
        }
        field(99039; "Item criteria name 10"; Text[30])
        {
            Caption = 'Item criteria name 10';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Item criteria name 10", "Item criteria name 10", 69, 1);

                if "Item criteria name 10" = '' then
                    "Item criteria 10 required" := false
                else
                    "Item criteria 10 required" := true;
            end;
        }
        field(99041; "Free field name 1"; Text[30])
        {
            Caption = 'Free field name 1';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Free field name 1", "Free field name 1", 80, 1);
            end;
        }
        field(99042; "Free field name 2"; Text[30])
        {
            Caption = 'Free field name 2';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Free field name 2", "Free field name 2", 81, 1);
            end;
        }
        field(99043; "Free field name 3"; Text[30])
        {
            Caption = 'Free field name 3';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Free field name 3", "Free field name 3", 82, 1);
            end;
        }
        field(99044; "Free field name 4"; Text[30])
        {
            Caption = 'Free field name 4';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Free field name 4", "Free field name 4", 83, 1);
            end;
        }
        field(99045; "Free field name 5"; Text[30])
        {
            Caption = 'Free field name 5';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Free field name 5", "Free field name 5", 84, 1);
            end;
        }
        field(99046; "Free field name 6"; Text[30])
        {
            Caption = 'Free field name 6';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Free field name 6", "Free field name 6", 85, 1);
            end;
        }
        field(99047; "Free field name 7"; Text[30])
        {
            Caption = 'Free field name 7';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Free field name 7", "Free field name 7", 86, 1);
            end;
        }
        field(99048; "Free field name 8"; Text[30])
        {
            Caption = 'Free field name 8';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Free field name 8", "Free field name 8", 87, 1);
            end;
        }
        field(99049; "Free field name 9"; Text[30])
        {
            Caption = 'Free field name 9';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Free field name 9", "Free field name 9", 88, 1);
            end;
        }
        field(99050; "Free field name 10"; Text[30])
        {
            Caption = 'Free field name 10';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Free field name 10", "Free field name 10", 89, 1);
            end;
        }
        field(99051; "Free value name 1"; Text[30])
        {
            Caption = 'Free value name 1';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Free value name 1", "Free value name 1", 51, 3);
            end;
        }
        field(99052; "Free value name 2"; Text[30])
        {
            Caption = 'Free value name 2';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Free value name 2", "Free value name 2", 52, 3);
            end;
        }
        field(99053; "Free value name 3"; Text[30])
        {
            Caption = 'Free value name 3';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Free value name 3", "Free value name 3", 53, 3);
            end;
        }
        field(99054; "Free value name 4"; Text[30])
        {
            Caption = 'Free value name 4';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Free value name 4", "Free value name 4", 54, 3);
            end;
        }
        field(99055; "Free value name 5"; Text[30])
        {
            Caption = 'Free value name 5';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Free value name 5", "Free value name 5", 55, 3);
            end;
        }
        field(99056; "Free value name 6"; Text[30])
        {
            Caption = 'Free value name 6';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Free value name 6", "Free value name 6", 56, 3);
            end;
        }
        field(99057; "Free value name 7"; Text[30])
        {
            Caption = 'Free value name 7';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Free value name 7", "Free value name 7", 57, 3);
            end;
        }
        field(99058; "Free value name 8"; Text[30])
        {
            Caption = 'Free value name 8';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Free value name 8", "Free value name 8", 58, 3);
            end;
        }
        field(99059; "Free value name 9"; Text[30])
        {
            Caption = 'Free value name 9';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Free value name 9", "Free value name 9", 59, 3);
            end;
        }
        field(99060; "Free value name 10"; Text[30])
        {
            Caption = 'Free value name 10';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Free value name 10", "Free value name 10", 60, 3);
            end;
        }
        field(99061; "Free date name 1"; Text[30])
        {
            Caption = 'Free date name 1';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Free date name 1", "Free date name 1", 90, 1);
            end;
        }
        field(99062; "Free date name 2"; Text[30])
        {
            Caption = 'Free date name 2';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Free date name 2", "Free date name 2", 91, 1);
            end;
        }
        field(99063; "Free date name 3"; Text[30])
        {
            Caption = 'Free date name 3';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Free date name 3", "Free date name 3", 92, 1);
            end;
        }
        field(99064; "Free date name 4"; Text[30])
        {
            Caption = 'Free date name 4';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Free date name 4", "Free date name 4", 93, 1);
            end;
        }
        field(99065; "Free date name 5"; Text[30])
        {
            Caption = 'Free date name 5';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Free date name 5", "Free date name 5", 94, 1);
            end;
        }
        field(99071; "Free check name 1"; Text[25])
        {
            Caption = 'Free check name 1';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Free check name 1", "Free check name 1", 95, 1);
            end;
        }
        field(99072; "Free check name 2"; Text[25])
        {
            Caption = 'Free check name 2';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Free check name 2", "Free check name 2", 96, 1);
            end;
        }
        field(99073; "Free check name 3"; Text[25])
        {
            Caption = 'Free check name  3';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Free check name 3", "Free check name 3", 97, 1);
            end;
        }
        field(99074; "Free check name 4"; Text[25])
        {
            Caption = 'Free check name  4';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Free check name 4", "Free check name 4", 98, 1);
            end;
        }
        field(99075; "Free check name 5"; Text[25])
        {
            Caption = 'Free check name  5';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Free check name 5", "Free check name 5", 99, 1);
            end;
        }
        field(99090; "Job criteria name 1"; Text[30])
        {
            Caption = 'Job criteria name 1';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Job criteria name 1", "Job criteria name 1", 300, 1);

                if "Job criteria name 1" = '' then
                    "Job criteria 1 required" := false
                else
                    "Job criteria 1 required" := true;
            end;
        }
        field(99091; "Job criteria name 2"; Text[30])
        {
            Caption = 'Job criteria name 2';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Job criteria name 2", "Job criteria name 2", 301, 1);

                if "Job criteria name 2" = '' then
                    "Job criteria 2 required" := false
                else
                    "Job criteria 2 required" := true;
            end;
        }
        field(99092; "Job criteria name 3"; Text[30])
        {
            Caption = 'Job criteria name 3';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Job criteria name 3", "Job criteria name 3", 302, 1);

                if "Job criteria name 3" = '' then
                    "Job criteria 3 required" := false
                else
                    "Job criteria 3 required" := true;
            end;
        }
        field(99093; "Job criteria name 4"; Text[30])
        {
            Caption = 'Job criteria name 4';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Job criteria name 4", "Job criteria name 4", 303, 1);

                if "Job criteria name 4" = '' then
                    "Job criteria 4 required" := false
                else
                    "Job criteria 4 required" := true;
            end;
        }
        field(99094; "Job criteria name 5"; Text[30])
        {
            Caption = 'Job criteria name 5';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Job criteria name 5", "Job criteria name 5", 304, 1);

                if "Job criteria name 5" = '' then
                    "Job criteria 5 required" := false
                else
                    "Job criteria 5 required" := true;
            end;
        }
        field(99095; "Job criteria name 6"; Text[30])
        {
            Caption = 'Job criteria name 6';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Job criteria name 6", "Job criteria name 6", 305, 1);

                if "Job criteria name 6" = '' then
                    "Job criteria 6 required" := false
                else
                    "Job criteria 6 required" := true;
            end;
        }
        field(99096; "Job criteria name 7"; Text[30])
        {
            Caption = 'Job criteria name 7';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Job criteria name 7", "Job criteria name 7", 306, 1);

                if "Job criteria name 7" = '' then
                    "Job criteria 7 required" := false
                else
                    "Job criteria 7 required" := true;
            end;
        }
        field(99097; "Job criteria name 8"; Text[30])
        {
            Caption = 'Job criteria name 8';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Job criteria name 8", "Job criteria name 8", 307, 1);

                if "Job criteria name 8" = '' then
                    "Job criteria 8 required" := false
                else
                    "Job criteria 8 required" := true;
            end;
        }
        field(99098; "Job criteria name 9"; Text[30])
        {
            Caption = 'Job criteria name 9';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Job criteria name 9", "Job criteria name 9", 308, 1);

                if "Job criteria name 9" = '' then
                    "Job criteria 9 required" := false
                else
                    "Job criteria 9 required" := true;
            end;
        }
        field(99099; "Job criteria name 10"; Text[30])
        {
            Caption = 'Job criteria name 10';

            trigger OnValidate()
            begin
                UpdateStatisticSetup(xRec."Job criteria name 10", "Job criteria name 10", 309, 1);

                if "Job criteria name 10" = '' then
                    "Job criteria 10 required" := false
                else
                    "Job criteria 10 required" := true;
            end;
        }
        field(100001; "Customer criteria 1 required"; Boolean)
        {
            Caption = 'Customer criteria 1 required';
        }
        field(100002; "Customer criteria 2 required"; Boolean)
        {
            Caption = 'Customer criteria 2 required';
        }
        field(100003; "Customer criteria 3 required"; Boolean)
        {
            Caption = 'Customer criteria 3 required';
        }
        field(100004; "Customer criteria 4 required"; Boolean)
        {
            Caption = 'Customer criteria 4 required';
        }
        field(100005; "Customer criteria 5 required"; Boolean)
        {
            Caption = 'Customer criteria 5 required';
        }
        field(100006; "Customer criteria 6 required"; Boolean)
        {
            Caption = 'Customer criteria 6 required';
        }
        field(100007; "Customer criteria 7 required"; Boolean)
        {
            Caption = 'Customer criteria 7 required';
        }
        field(100008; "Customer criteria 8 required"; Boolean)
        {
            Caption = 'Customer criteria 8 required';
        }
        field(100009; "Customer criteria 9 required"; Boolean)
        {
            Caption = 'Customer criteria 9 required';
        }
        field(100010; "Customer criteria 10 required"; Boolean)
        {
            Caption = 'Customer criteria 10 required';
        }
        field(100011; "Item criteria 1 required"; Boolean)
        {
            Caption = 'Item criteria 1 required';
        }
        field(100012; "Item criteria 2 required"; Boolean)
        {
            Caption = 'Item criteria 2 required';
        }
        field(100013; "Item criteria 3 required"; Boolean)
        {
            Caption = 'Item criteria 3 required';
        }
        field(100014; "Item criteria 4 required"; Boolean)
        {
            Caption = 'Item criteria 4 required';
        }
        field(100015; "Item criteria 5 required"; Boolean)
        {
            Caption = 'Item criteria 5 required';
        }
        field(100016; "Item criteria 6 required"; Boolean)
        {
            Caption = 'Item criteria 6 required';
        }
        field(100017; "Item criteria 7 required"; Boolean)
        {
            Caption = 'Item criteria 7 required';
        }
        field(100018; "Item criteria 8 required"; Boolean)
        {
            Caption = 'Item criteria 8 required';
        }
        field(100019; "Item criteria 9 required"; Boolean)
        {
            Caption = 'Item criteria 9 required';
        }
        field(100020; "Item criteria 10 required"; Boolean)
        {
            Caption = 'Item criteria 10 required';
        }
        field(100021; "Job criteria 1 required"; Boolean)
        {
            Caption = 'Job criteria 1 required';
        }
        field(100022; "Job criteria 2 required"; Boolean)
        {
            Caption = 'Job criteria 2 required';
        }
        field(100023; "Job criteria 3 required"; Boolean)
        {
            Caption = 'Job criteria 3 required';
        }
        field(100024; "Job criteria 4 required"; Boolean)
        {
            Caption = 'Job criteria 4 required';
        }
        field(100025; "Job criteria 5 required"; Boolean)
        {
            Caption = 'Job criteria 5 required';
        }
        field(100026; "Job criteria 6 required"; Boolean)
        {
            Caption = 'Job criteria 6 required';
        }
        field(100027; "Job criteria 7 required"; Boolean)
        {
            Caption = 'Job criteria 7 required';
        }
        field(100028; "Job criteria 8 required"; Boolean)
        {
            Caption = 'Job criteria 8 required';
        }
        field(100029; "Job criteria 9 required"; Boolean)
        {
            Caption = 'Job criteria 9 required';
        }
        field(100030; "Job criteria 10 required"; Boolean)
        {
            Caption = 'Job criteria 10 required';
        }
        field(100041; "Free field no 1"; Text[30])
        {
            CaptionClass = '1,5,,' + ShowTableName("Free field no 1", FieldCaption("Free field no 1"));
            Caption = 'Free field name 1';

            trigger OnLookup()
            begin
                "Free field no 1" := LookupFieldNo("Free field name 1", wField.Type::OemText, "Free field no 1");
                Validate("Free field name 1");
                if (xRec."Free field no 1" <> "Free field no 1") and (xRec."Free field no 1" <> '') then begin
                    wStat.Reset;
                    wStat.SetFilter("Free field 1", '<>%1', '');
                    wStat.ModifyAll("Free field 1", '');
                end;
            end;

            trigger OnValidate()
            begin
                UpdateStatisticNameSetup("Free field name 1", "Free field no 1");
                Validate("Free field name 1");
                if (xRec."Free field no 1" <> "Free field no 1") and (xRec."Free field no 1" <> '') then begin
                    wStat.Reset;
                    wStat.SetFilter("Free field 1", '<>%1', '');
                    wStat.ModifyAll("Free field 1", '');
                end;
            end;
        }
        field(100042; "Free field no 2"; Text[30])
        {
            CaptionClass = '1,5,,' + ShowTableName("Free field no 2", FieldCaption("Free field no 2"));
            Caption = 'Free field name 2';

            trigger OnLookup()
            begin
                "Free field no 2" := LookupFieldNo("Free field name 2", wField.Type::OemText, "Free field no 2");
                Validate("Free field name 2");
                if (xRec."Free field no 2" <> "Free field no 2") and (xRec."Free field no 2" <> '') then begin
                    wStat.Reset;
                    wStat.SetFilter("Free field 2", '<>%1', '');
                    wStat.ModifyAll("Free field 2", '');
                end;
            end;

            trigger OnValidate()
            begin
                UpdateStatisticNameSetup("Free field name 2", "Free field no 2");
                Validate("Free field name 2");
                if (xRec."Free field no 2" <> "Free field no 2") and (xRec."Free field no 2" <> '') then begin
                    wStat.Reset;
                    wStat.SetFilter("Free field 2", '<>%1', '');
                    wStat.ModifyAll("Free field 2", '');
                end;
            end;
        }
        field(100043; "Free field no 3"; Text[30])
        {
            CaptionClass = '1,5,,' + ShowTableName("Free field no 3", FieldCaption("Free field no 3"));
            Caption = 'Free field name 3';

            trigger OnLookup()
            begin
                "Free field no 3" := LookupFieldNo("Free field name 3", wField.Type::OemText, "Free field no 3");
                Validate("Free field name 3");
                if (xRec."Free field no 3" <> "Free field no 3") and (xRec."Free field no 3" <> '') then begin
                    wStat.Reset;
                    wStat.SetFilter("Free field 3", '<>%1', '');
                    wStat.ModifyAll("Free field 3", '');
                end;
            end;

            trigger OnValidate()
            begin
                UpdateStatisticNameSetup("Free field name 3", "Free field no 3");
                Validate("Free field name 3");
                if (xRec."Free field no 3" <> "Free field no 3") and (xRec."Free field no 3" <> '') then begin
                    wStat.Reset;
                    wStat.SetFilter("Free field 3", '<>%1', '');
                    wStat.ModifyAll("Free field 3", '');
                end;
            end;
        }
        field(100044; "Free field no 4"; Text[30])
        {
            CaptionClass = '1,5,,' + ShowTableName("Free field no 4", FieldCaption("Free field no 4"));
            Caption = 'Free field name 4';

            trigger OnLookup()
            begin
                "Free field no 4" := LookupFieldNo("Free field name 4", wField.Type::OemText, "Free field no 4");
                Validate("Free field name 4");
                if (xRec."Free field no 4" <> "Free field no 4") and (xRec."Free field no 4" <> '') then begin
                    wStat.Reset;
                    wStat.SetFilter("Free field 4", '<>%1', '');
                    wStat.ModifyAll("Free field 4", '');
                end;
            end;

            trigger OnValidate()
            begin
                UpdateStatisticNameSetup("Free field name 4", "Free field no 4");
                Validate("Free field name 4");
                if (xRec."Free field no 4" <> "Free field no 4") and (xRec."Free field no 4" <> '') then begin
                    wStat.Reset;
                    wStat.SetFilter("Free field 4", '<>%1', '');
                    wStat.ModifyAll("Free field 4", '');
                end;
            end;
        }
        field(100045; "Free field no 5"; Text[30])
        {
            CaptionClass = '1,5,,' + ShowTableName("Free field no 5", FieldCaption("Free field no 5"));
            Caption = 'Free field name 5';

            trigger OnLookup()
            begin
                "Free field no 5" := LookupFieldNo("Free field name 5", wField.Type::OemText, "Free field no 5");
                Validate("Free field name 5");
                if (xRec."Free field no 5" <> "Free field no 5") and (xRec."Free field no 5" <> '') then begin
                    wStat.Reset;
                    wStat.SetFilter("Free field 5", '<>%1', '');
                    wStat.ModifyAll("Free field 5", '');
                end;
            end;

            trigger OnValidate()
            begin
                UpdateStatisticNameSetup("Free field name 5", "Free field no 5");
                Validate("Free field name 5");
                if (xRec."Free field no 5" <> "Free field no 5") and (xRec."Free field no 5" <> '') then begin
                    wStat.Reset;
                    wStat.SetFilter("Free field 5", '<>%1', '');
                    wStat.ModifyAll("Free field 5", '');
                end;
            end;
        }
        field(100046; "Free field no 6"; Text[30])
        {
            CaptionClass = '1,5,,' + ShowTableName("Free field no 6", FieldCaption("Free field no 6"));
            Caption = 'Free field name 6';

            trigger OnLookup()
            begin
                "Free field no 6" := LookupFieldNo("Free field name 6", wField.Type::OemText, "Free field no 6");
                Validate("Free field name 6");
                if (xRec."Free field no 6" <> "Free field no 6") and (xRec."Free field no 6" <> '') then begin
                    wStat.Reset;
                    wStat.SetFilter("Free field 6", '<>%1', '');
                    wStat.ModifyAll("Free field 6", '');
                end;
            end;

            trigger OnValidate()
            begin
                UpdateStatisticNameSetup("Free field name 6", "Free field no 6");
                Validate("Free field name 6");
                if (xRec."Free field no 6" <> "Free field no 6") and (xRec."Free field no 6" <> '') then begin
                    wStat.Reset;
                    wStat.SetFilter("Free field 6", '<>%1', '');
                    wStat.ModifyAll("Free field 6", '');
                end;
            end;
        }
        field(100047; "Free field no 7"; Text[30])
        {
            CaptionClass = '1,5,,' + ShowTableName("Free field no 7", FieldCaption("Free field no 7"));
            Caption = 'Free field name 7';

            trigger OnLookup()
            begin
                "Free field no 7" := LookupFieldNo("Free field name 7", wField.Type::OemText, "Free field no 7");
                Validate("Free field name 7");
                if (xRec."Free field no 7" <> "Free field no 7") and (xRec."Free field no 7" <> '') then begin
                    wStat.Reset;
                    wStat.SetFilter("Free field 7", '<>%1', '');
                    wStat.ModifyAll("Free field 7", '');
                end;
            end;

            trigger OnValidate()
            begin
                UpdateStatisticNameSetup("Free field name 7", "Free field no 7");
                Validate("Free field name 7");
                if (xRec."Free field no 7" <> "Free field no 7") and (xRec."Free field no 7" <> '') then begin
                    wStat.Reset;
                    wStat.SetFilter("Free field 7", '<>%1', '');
                    wStat.ModifyAll("Free field 7", '');
                end;
            end;
        }
        field(100048; "Free field no 8"; Text[30])
        {
            CaptionClass = '1,5,,' + ShowTableName("Free field no 8", FieldCaption("Free field no 8"));
            Caption = 'Free field name 8';

            trigger OnLookup()
            begin
                "Free field no 8" := LookupFieldNo("Free field name 8", wField.Type::OemText, "Free field no 8");
                Validate("Free field name 8");
                if (xRec."Free field no 8" <> "Free field no 8") and (xRec."Free field no 8" <> '') then begin
                    wStat.Reset;
                    wStat.SetFilter("Free field 8", '<>%1', '');
                    wStat.ModifyAll("Free field 8", '');
                end;
            end;

            trigger OnValidate()
            begin
                UpdateStatisticNameSetup("Free field name 8", "Free field no 8");
                Validate("Free field name 8");
                if (xRec."Free field no 8" <> "Free field no 8") and (xRec."Free field no 8" <> '') then begin
                    wStat.Reset;
                    wStat.SetFilter("Free field 8", '<>%1', '');
                    wStat.ModifyAll("Free field 8", '');
                end;
            end;
        }
        field(100049; "Free field no 9"; Text[30])
        {
            CaptionClass = '1,5,,' + ShowTableName("Free field no 9", FieldCaption("Free field no 9"));
            Caption = 'Free field name 9';

            trigger OnLookup()
            begin
                "Free field no 9" := LookupFieldNo("Free field name 9", wField.Type::OemText, "Free field no 9");
                Validate("Free field name 9");
                if (xRec."Free field no 9" <> "Free field no 9") and (xRec."Free field no 9" <> '') then begin
                    wStat.Reset;
                    wStat.SetFilter("Free field 9", '<>%1', '');
                    wStat.ModifyAll("Free field 9", '');
                end;
            end;

            trigger OnValidate()
            begin
                UpdateStatisticNameSetup("Free field name 9", "Free field no 9");
                Validate("Free field name 9");
                if (xRec."Free field no 9" <> "Free field no 9") and (xRec."Free field no 9" <> '') then begin
                    wStat.Reset;
                    wStat.SetFilter("Free field 9", '<>%1', '');
                    wStat.ModifyAll("Free field 9", '');
                end;
            end;
        }
        field(100050; "Free field no 10"; Text[30])
        {
            CaptionClass = '1,5,,' + ShowTableName("Free field no 10", FieldCaption("Free field no 10"));
            Caption = 'Free field name 10';

            trigger OnLookup()
            begin
                "Free field no 10" := LookupFieldNo("Free field name 10", wField.Type::OemText, "Free field no 10");
                Validate("Free field name 10");
                if (xRec."Free field no 10" <> "Free field no 10") and (xRec."Free field no 10" <> '') then begin
                    wStat.Reset;
                    wStat.SetFilter("Free field 10", '<>%1', '');
                    wStat.ModifyAll("Free field 10", '');
                end;
            end;

            trigger OnValidate()
            begin
                UpdateStatisticNameSetup("Free field name 10", "Free field no 10");
                Validate("Free field name 10");
                if (xRec."Free field no 10" <> "Free field no 10") and (xRec."Free field no 10" <> '') then begin
                    wStat.Reset;
                    wStat.SetFilter("Free field 10", '<>%1', '');
                    wStat.ModifyAll("Free field 10", '');
                end;
            end;
        }
        field(100051; "Free value no 1"; Text[30])
        {
            CaptionClass = '1,5,,' + ShowTableName("Free value no 1", FieldCaption("Free value no 1"));
            Caption = 'Free value name 1';

            trigger OnValidate()
            begin
                UpdateStatisticNameSetup("Free value name 1", "Free value no 1");
            end;
        }
        field(100052; "Free value no 2"; Text[30])
        {
            CaptionClass = '1,5,,' + ShowTableName("Free value no 2", FieldCaption("Free value no 2"));
            Caption = 'Free value name 2';

            trigger OnValidate()
            begin
                UpdateStatisticNameSetup("Free value name 2", "Free value no 2");
            end;
        }
        field(100053; "Free value no 3"; Text[30])
        {
            CaptionClass = '1,5,,' + ShowTableName("Free value no 3", FieldCaption("Free value no 3"));
            Caption = 'Free value name 3';

            trigger OnValidate()
            begin
                UpdateStatisticNameSetup("Free value name 3", "Free value no 3");
            end;
        }
        field(100054; "Free value no 4"; Text[30])
        {
            CaptionClass = '1,5,,' + ShowTableName("Free value no 4", FieldCaption("Free value no 4"));
            Caption = 'Free value name 4';

            trigger OnValidate()
            begin
                UpdateStatisticNameSetup("Free value name 4", "Free value no 4");
            end;
        }
        field(100055; "Free value no 5"; Text[30])
        {
            CaptionClass = '1,5,,' + ShowTableName("Free value no 5", FieldCaption("Free value no 5"));
            Caption = 'Free value name 5';

            trigger OnValidate()
            begin
                UpdateStatisticNameSetup("Free value name 5", "Free value no 5");
            end;
        }
        field(100056; "Free value no 6"; Text[30])
        {
            CaptionClass = '1,5,,' + ShowTableName("Free value no 6", FieldCaption("Free value no 6"));
            Caption = 'Free value name 6';

            trigger OnValidate()
            begin
                UpdateStatisticNameSetup("Free value name 6", "Free value no 6");
            end;
        }
        field(100057; "Free value no 7"; Text[30])
        {
            CaptionClass = '1,5,,' + ShowTableName("Free value no 7", FieldCaption("Free value no 7"));
            Caption = 'Free value name 7';

            trigger OnValidate()
            begin
                UpdateStatisticNameSetup("Free value name 7", "Free value no 7");
            end;
        }
        field(100058; "Free value no 8"; Text[30])
        {
            CaptionClass = '1,5,,' + ShowTableName("Free value no 8", FieldCaption("Free value no 8"));
            Caption = 'Free value name 8';

            trigger OnValidate()
            begin
                UpdateStatisticNameSetup("Free value name 8", "Free value no 8");
            end;
        }
        field(100059; "Free value no 9"; Text[30])
        {
            CaptionClass = '1,5,,' + ShowTableName("Free value no 9", FieldCaption("Free value no 9"));
            Caption = 'Free value name 9';

            trigger OnValidate()
            begin
                UpdateStatisticNameSetup("Free value name 9", "Free value no 9");
            end;
        }
        field(100060; "Free value no 10"; Text[30])
        {
            CaptionClass = '1,5,,' + ShowTableName("Free value no 10", FieldCaption("Free value no 10"));
            Caption = 'Free value name 10';

            trigger OnValidate()
            begin
                UpdateStatisticNameSetup("Free value name 10", "Free value no 10");
            end;
        }
        field(100061; "Free date no 1"; Text[30])
        {
            CaptionClass = '1,5,,' + ShowTableName("Free date no 1", FieldCaption("Free date no 1"));
            Caption = 'Free date name 1';

            trigger OnLookup()
            begin
                "Free date no 1" := LookupFieldNo("Free date name 1", wField.Type::Date, "Free date no 1");
                Validate("Free date name 1");
            end;

            trigger OnValidate()
            begin
                UpdateStatisticNameSetup("Free date name 1", "Free date no 1");
                Validate("Free date name 1");
            end;
        }
        field(100062; "Free date no 2"; Text[30])
        {
            CaptionClass = '1,5,,' + ShowTableName("Free date no 2", FieldCaption("Free date no 2"));
            Caption = 'Free date name 2';

            trigger OnLookup()
            begin
                "Free date no 2" := LookupFieldNo("Free date name 2", wField.Type::Date, "Free date no 2");
                Validate("Free date name 2");
            end;

            trigger OnValidate()
            begin
                UpdateStatisticNameSetup("Free date name 2", "Free date no 2");
                Validate("Free date name 2");
            end;
        }
        field(100063; "Free date no 3"; Text[30])
        {
            CaptionClass = '1,5,,' + ShowTableName("Free date no 3", FieldCaption("Free date no 3"));
            Caption = 'Free date name 3';

            trigger OnLookup()
            begin
                "Free date no 3" := LookupFieldNo("Free date name 3", wField.Type::Date, "Free date no 3");
                Validate("Free date name 3");
            end;

            trigger OnValidate()
            begin
                UpdateStatisticNameSetup("Free date name 3", "Free date no 3");
                Validate("Free date name 3");
            end;
        }
        field(100064; "Free date no 4"; Text[30])
        {
            CaptionClass = '1,5,,' + ShowTableName("Free date no 4", FieldCaption("Free date no 4"));
            Caption = 'Free date name 4';

            trigger OnLookup()
            begin
                "Free date no 4" := LookupFieldNo("Free date name 4", wField.Type::Date, "Free date no 4");
                Validate("Free date name 4");
            end;

            trigger OnValidate()
            begin
                UpdateStatisticNameSetup("Free date name 4", "Free date no 4");
                Validate("Free date name 4");
            end;
        }
        field(100065; "Free date no 5"; Text[30])
        {
            CaptionClass = '1,5,,' + ShowTableName("Free date no 5", FieldCaption("Free date no 5"));
            Caption = 'Free date name 5';

            trigger OnLookup()
            begin
                "Free date no 5" := LookupFieldNo("Free date name 5", wField.Type::Date, "Free date no 5");
                Validate("Free date name 5");
            end;

            trigger OnValidate()
            begin
                UpdateStatisticNameSetup("Free date name 5", "Free date no 5");
                Validate("Free date name 5");
            end;
        }
        field(100071; "Free check no 1"; Text[30])
        {
            CaptionClass = '1,5,,' + ShowTableName("Free check no 1", FieldCaption("Free check no 1"));
            Caption = 'Free check name 1';

            trigger OnLookup()
            begin
                "Free check no 1" := LookupFieldNo("Free check name 1", wField.Type::Boolean, "Free check no 1");
                Validate("Free check name 1");
            end;

            trigger OnValidate()
            begin
                UpdateStatisticNameSetup("Free check name 1", "Free check no 1");
                Validate("Free check name 1");
            end;
        }
        field(100072; "Free check no 2"; Text[30])
        {
            CaptionClass = '1,5,,' + ShowTableName("Free check no 2", FieldCaption("Free check no 2"));
            Caption = 'Free check name 2';

            trigger OnLookup()
            begin
                "Free check no 2" := LookupFieldNo("Free check name 2", wField.Type::Boolean, "Free check no 2");
                Validate("Free check name 2");
            end;

            trigger OnValidate()
            begin
                UpdateStatisticNameSetup("Free check name 2", "Free check no 2");
                Validate("Free check name 2");
            end;
        }
        field(100073; "Free check no 3"; Text[30])
        {
            CaptionClass = '1,5,,' + ShowTableName("Free check no 3", FieldCaption("Free check no 3"));
            Caption = 'Free check name  3';

            trigger OnLookup()
            begin
                "Free check no 3" := LookupFieldNo("Free check name 3", wField.Type::Boolean, "Free check no 3");
                Validate("Free check name 3");
            end;

            trigger OnValidate()
            begin
                UpdateStatisticNameSetup("Free check name 3", "Free check no 3");
                Validate("Free check name 3");
            end;
        }
        field(100074; "Free check no 4"; Text[30])
        {
            CaptionClass = '1,5,,' + ShowTableName("Free check no 4", FieldCaption("Free check no 4"));
            Caption = 'Free check name  4';

            trigger OnLookup()
            begin
                "Free check no 4" := LookupFieldNo("Free check name 4", wField.Type::Boolean, "Free check no 4");
                Validate("Free check name 4");
            end;

            trigger OnValidate()
            begin
                UpdateStatisticNameSetup("Free check name 4", "Free check no 4");
                Validate("Free check name 4");
            end;
        }
        field(100075; "Free check no 5"; Text[30])
        {
            CaptionClass = '1,5,,' + ShowTableName("Free check no 5", FieldCaption("Free check no 5"));
            Caption = 'Free check name  5';

            trigger OnLookup()
            begin
                "Free check no 5" := LookupFieldNo("Free check name 5", wField.Type::Boolean, "Free check no 5");
                Validate("Free check name 5");
            end;

            trigger OnValidate()
            begin
                UpdateStatisticNameSetup("Free check name 5", "Free check no 5");
                Validate("Free check name 5");
            end;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Period total basis" := "Period total basis"::Month;
    end;

    var
        Error1: Label 'You can''t processed before %1';
        Error2: Label 'Header criteria type required';
        Error3: Label 'Line criteria type required';
        Fenetre1: Label 'Statistic update in progress...';
        TexteEntete1: Label 'Header 1 :';
        TexteEntete2: Label 'Header 2 :';
        TexteLigne1: Label 'Line 1 :';
        TexteLigne2: Label 'Line 2 :';
        Message1: Label 'Attention : Process from date and Process to date should contain "+" or "-"';
        Message2: Label 'You must enter period length in each flow.';
        Text000: Label '%1\You cannot use the same dimension twice.';
        wField: Record "Field";
        wStat: Record "Statistic aggregate";

    [Scope('OnPrem')]
    procedure UpdateStatisticSetup(OldFieldName: Text[30]; NewFieldName: Text[30]; FieldNumber: Integer; TypeOfCriteria: Integer)
    var
        StatisticCriteria: Record "Statistic criteria";
        Dimension: Record Dimension;
        StatsExplorerFields: Record "StatsExplorer fields";
        Window: Dialog;
    begin
        if OldFieldName = NewFieldName then
            exit;
        with StatisticCriteria do begin
            case TypeOfCriteria of
                1:
                    SetRange(Type, Type::"Sort criteria");
                2:
                    SetRange(Type, Type::Flow);
                3:
                    SetRange(Type, Type::Value);
            end;
            SetRange("Field No.", FieldNumber);
            if Find('-') then begin
                Window.Open(Fenetre1);
                if NewFieldName = '' then begin
                    NewFieldName := "Source name";
                    Validate(StatisticCriteria.Enabled, false);
                end else
                    Validate(StatisticCriteria.Enabled, true);
                StatisticCriteria.Modify;
                case TypeOfCriteria of
                    1:
                        begin
                            if (FieldNumber > 200) and (FieldNumber <= 220) then begin
                                if Dimension.Get(CopyStr(NewFieldName, 1, 20)) then
                                    StatisticCriteria.Rename(StatisticCriteria.Type::"Sort criteria", Dimension."Code Caption")
                                else
                                    StatisticCriteria.Rename(StatisticCriteria.Type::"Sort criteria", "Source name");
                            end else
                                StatisticCriteria.Rename(StatisticCriteria.Type::"Sort criteria", NewFieldName);
                        end;
                    2:
                        StatisticCriteria.Rename(StatisticCriteria.Type::Flow, NewFieldName);
                    3:
                        StatisticCriteria.Rename(StatisticCriteria.Type::Value, NewFieldName);
                end;

                Window.Close;
            end;
            Reset;
        end;
    end;

    [Scope('OnPrem')]
    procedure UpdateStatisticType(TypeCritere: Option " ",Client,Article,"En-tête vente"; NumeroCritere: Integer; Prefixe: Text[12]) NomDuCritere: Text[30]
    begin
        if TypeCritere = TypeCritere::Client then begin
            case NumeroCritere of
                1:
                    exit(Prefixe + CopyStr("Customer criteria name 1", 1, 18));
                2:
                    exit(Prefixe + CopyStr("Customer criteria name 2", 1, 18));
                3:
                    exit(Prefixe + CopyStr("Customer criteria name 3", 1, 18));
                4:
                    exit(Prefixe + CopyStr("Customer criteria name 4", 1, 18));
                5:
                    exit(Prefixe + CopyStr("Customer criteria name 5", 1, 18));
                6:
                    exit(Prefixe + CopyStr("Customer criteria name 6", 1, 18));
                7:
                    exit(Prefixe + CopyStr("Customer criteria name 7", 1, 18));
                8:
                    exit(Prefixe + CopyStr("Customer criteria name 8", 1, 18));
                9:
                    exit(Prefixe + CopyStr("Customer criteria name 9", 1, 18));
                10:
                    exit(Prefixe + CopyStr("Customer criteria name 10", 1, 18));
            end;
        end;

        if TypeCritere = TypeCritere::Article then begin
            case NumeroCritere of
                1:
                    exit(Prefixe + CopyStr("Item criteria name 1", 1, 18));
                2:
                    exit(Prefixe + CopyStr("Item criteria name 2", 1, 18));
                3:
                    exit(Prefixe + CopyStr("Item criteria name 3", 1, 18));
                4:
                    exit(Prefixe + CopyStr("Item criteria name 4", 1, 18));
                5:
                    exit(Prefixe + CopyStr("Item criteria name 5", 1, 18));
                6:
                    exit(Prefixe + CopyStr("Item criteria name 6", 1, 18));
                7:
                    exit(Prefixe + CopyStr("Item criteria name 7", 1, 18));
                8:
                    exit(Prefixe + CopyStr("Item criteria name 8", 1, 18));
                9:
                    exit(Prefixe + CopyStr("Item criteria name 9", 1, 18));
                10:
                    exit(Prefixe + CopyStr("Item criteria name 10", 1, 18));
            end;
        end;
    end;

    [Scope('OnPrem')]
    procedure UpdateStatisticCriteria()
    var
        CritereStatistique: Record "Statistic criteria";
    begin
        with CritereStatistique do begin
            SetRange(Type, Type::Flow);
            if Find('-') then
                repeat
                    if ("Period total basis" <>
                       "Period total basis"::"According to every flow") or
                       (Type <> Type::Flow) or
                       (not Enabled) then begin
                        "Process aggregate by day" := false;
                        "Process aggregate by week" := false;
                        "Process aggregate by month" := false;
                        "Process aggregate by quarter" := false;
                        "Process aggregate by year" := false;
                        "Process aggregate by period" := false;
                        Modify;
                    end else
                        "Process aggregate by month" := true;
                    if ("Aggregate, real time update") and (CritereStatistique."Real-Time Update available") then
                        CritereStatistique."Real-Time Update" := true
                    else
                        CritereStatistique."Real-Time Update" := false;
                    Modify;
                until Next = 0;
        end;
    end;

    [Scope('OnPrem')]
    procedure UpdateStatisticNameSetup(var NewFieldName: Text[30]; pField: Text[30])
    var
        StatisticCriteria: Record "Statistic criteria";
        Dimension: Record Dimension;
        StatsExplorerFields: Record "StatsExplorer fields";
        Window: Dialog;
    begin
        //WITH StatisticCriteria DO BEGIN
        //Appel au form 8001437
        //   FieldSelection.InitRequest(pField);
        //   NewFieldName := COPYSTR(FieldSelection.GetFieldCaption,1,MAXSTRLEN(NewFieldName));
        //END;
    end;

    [Scope('OnPrem')]
    procedure LookupFieldNo(var pFieldName: Text[30]; pType: Integer; pField: Text[30]) Result: Text[80]
    var
        ObjectTable: Record "Object";
    begin
        ObjectTable.SetRange(Type, ObjectTable.Type::Table);
        ObjectTable.SetFilter(ID, '27|156|15|5200|167|18|23');
        /*
        CLEAR(FieldSelection);
        FieldSelection.LOOKUPMODE(TRUE);
        FieldSelection.SETTABLEVIEW(ObjectTable);
        IF pField <> '' THEN
          FieldSelection.InitRequest(pField);
        FieldSelection.SetFilters(pType);
        Result := pField;
        IF FieldSelection.RUNMODAL = ACTION::LookupOK THEN BEGIN
          Result := COPYSTR(FieldSelection.GetResult,1,MAXSTRLEN(Result));
          pFieldName := COPYSTR(FieldSelection.GetFieldCaption,1,MAXSTRLEN(pFieldName));
        END;
           */

    end;

    [Scope('OnPrem')]
    procedure ShowTableName(pField: Text[30]; pCaption: Text[30]): Text[80]
    var
        lIDTable: Integer;
    begin
        /*
        IF STRPOS(pField,'.') <> 0 THEN
          EVALUATE(lIDTable,COPYSTR(pField,1,STRPOS(pField,'.')-1));
        EXIT(pCaption + ' ' + FieldSelection.GetTableCaption(lIDTable));
        */

    end;
}

