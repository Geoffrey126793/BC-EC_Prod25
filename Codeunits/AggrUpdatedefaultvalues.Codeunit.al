codeunit 8001316 "Aggr., Update default values"
{
    // -------------------------------------------------------------------------------------------
    //   STA-000 ABSYS GN 20061005 (Ajout de critáres StatsExplorer sur Vendor)
    //     Add Code :
    //       SearchCustomerOrVendor() : Ajout des critáre de la table Vendor
    // -------------------------------------------------------------------------------------------
    // 
    // //STATSEXPLORER STATSEXPLORER 01/01/00 Add values from item,customer,...
    // 
    // 
    // IMPORTANT TECHNICAL INFORMATIONS FOR DEVELOPERS :
    // -----------------------------------------------
    // 
    // You can find at the end of this codeunit several functions dedicated to take
    // specific fields in the cards : Item, Resource, Account G/L, Employee, Job, Customer, Vendor.
    // 
    // To put one of your specific fields in one of the free fields of StatsExplorer, your have to add only 3 C/AL lines :
    // 
    // 1 - Define this field description in Statistic Setup (Free Fields)
    // 
    // 2 - Add 1 C/AL line in the function SearchSpecificFieldsxxxx (xxxx = item,resource,...) like that :
    // 
    //     Stats."Free field 1" := Item."My Specific Field";
    //    Where
    //     Stats."Free field 1" could be "Free field 1" to "Free field 10",
    //     "Free date 1" to "Free date 5", "Free boolean 1" to "Free boolean 5"
    //    And Where
    //     Item."My Specific Field" could be Item,Resource,Account,Employee,Job,Customer,Vendor
    //     (You don't need to GET item, ressource, ...)
    // 
    // 3 - Create the codes and descriptions of this free field in table 8001400
    //     with the function CreateCodeAndDescription like that :
    // 
    //     a - Add your specific table which contains Code+Description of your field in C/AL locals (MyTable,Record,"My Table")
    // 
    //     b - GET the current code : MyTable.GET(Item."My Specific Field")
    // 
    //     c - Use the function CreateCodeAndDescription of this codeunit to add records with Code+Description in table 8001400 :
    // 
    //         CreateCodeAndDescription(TableNumber,FieldNumber,CodeValue,CodeDescription)
    //        Where
    //         TableNumber     = 8001300
    //         FieldNumber     = 1001..1010 for "Free field 1" to "Free field 10"
    //                           1011..1015 for "Free date 1" to "Free date 5"
    //                           1021..1025 for "Free boolean 1" to "Free boolean 5"
    // 
    //         CodeValue       = MyTable.Code
    //         CodeDescription = MyTable.Description
    // 
    // Don't forget documentation and version list ...
    // 
    // 
    // BT.AB6.20070314 : champ Volume : quantitÔÇÜ * Poids net de l'article

    TableNo = "Statistic aggregate";

    trigger OnRun()
    begin
        Stats := Rec;
        StatisticSetup.Get;

        SearchJob;
        SearchCustomerOrVendor;
        ModifyDateValues;

        if "No." <> '' then
            case Type of
                Type::Item:
                    SearchItem;
                Type::Resource:
                    SearchResource;
                Type::"Account (G/L)":
                    SearchAccountGL;
                Type::Employee:
                    SearchEmployee;
            end;

        StatisticCriteria.SetRange(Type, StatisticCriteria.Type::"Sort criteria");
        StatisticCriteria.SetRange("Field No.", 35);
        if StatisticCriteria.Find('-') and StatisticCriteria.Enabled then
            SearchFiscalDate;

        Rec := Stats;
    end;

    var
        StatisticSetup: Record "Statistics setup";
        StatisticCriteria: Record "Statistic criteria";
        Stats: Record "Statistic aggregate";
        "Code": Record "Code";
        Item: Record Item;
        Resource: Record Resource;
        Account: Record "G/L Account";
        Employee: Record Employee;
        Job: Record Job;
        Customer: Record Customer;
        "Object": Record "Object";
        Vendor: Record Vendor;

    [Scope('OnPrem')]
    procedure SearchItem()
    begin
        if Item.Get(Stats."No.") then
            with Stats do begin
                if StatisticSetup."Item criteria 1 required" then
                    Item.TestField("Criteria 1");
                if StatisticSetup."Item criteria 2 required" then
                    Item.TestField("Criteria 2");
                if StatisticSetup."Item criteria 3 required" then
                    Item.TestField("Criteria 3");
                if StatisticSetup."Item criteria 4 required" then
                    Item.TestField("Criteria 4");
                if StatisticSetup."Item criteria 5 required" then
                    Item.TestField("Criteria 5");
                if StatisticSetup."Item criteria 6 required" then
                    Item.TestField("Criteria 6");
                if StatisticSetup."Item criteria 7 required" then
                    Item.TestField("Criteria 7");
                if StatisticSetup."Item criteria 8 required" then
                    Item.TestField("Criteria 8");
                if StatisticSetup."Item criteria 9 required" then
                    Item.TestField("Criteria 9");
                if StatisticSetup."Item criteria 10 required" then
                    Item.TestField("Criteria 10");
                Volume := Quantity * Item."Net Weight";//BT ABSYS : on utilise le poids net ÔÇª la place
                "Item criteria 1" := Item."Criteria 1";
                "Item criteria 2" := Item."Criteria 2";
                "Item criteria 3" := Item."Criteria 3";
                "Item criteria 4" := Item."Criteria 4";
                "Item criteria 5" := Item."Criteria 5";
                "Item criteria 6" := Item."Criteria 6";
                "Item criteria 7" := Item."Criteria 7";
                "Item criteria 8" := Item."Criteria 8";
                "Item criteria 9" := Item."Criteria 9";
                "Item criteria 10" := Item."Criteria 10";
                if "Manufacturer Code" = '' then
                    "Manufacturer Code" := Item."Manufacturer Code";
                if "Item Category Code" = '' then
                    "Item Category Code" := Item."Item Category Code";
                if "Service Item Group" = '' then
                    "Service Item Group" := Item."Service Item Group";
                //   IF "Product Group Code" = '' THEN
                //      "Product Group Code" := Item."Product Group Code";
                if "Inventory Posting Group" = '' then
                    "Inventory Posting Group" := Item."Inventory Posting Group";
                if "Gen. Prod. Posting Group" = '' then
                    "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";

                SearchSpecificFieldsItem;

            end;
    end;

    [Scope('OnPrem')]
    procedure SearchResource()
    begin
        if Resource.Get(Stats."No.") then
            with Stats do begin

                //BT.AB6.20070314 : champ Volume : quantitÔÇÜ * Poids net de l'article
                //uniquement pour l'article, pour ne pas reprendre le transport
                //Volume := Quantity;

                if "Global Dimension 1 Code" = '' then
                    "Global Dimension 1 Code" := Resource."Global Dimension 1 Code";
                if "Global Dimension 2 Code" = '' then
                    "Global Dimension 2 Code" := Resource."Global Dimension 2 Code";
                if "Resource Group No." = '' then
                    "Resource Group No." := Resource."Resource Group No.";
                if "Gen. Prod. Posting Group" = '' then
                    "Gen. Prod. Posting Group" := Resource."Gen. Prod. Posting Group";

                SearchSpecificFieldsResource;

            end;
    end;

    [Scope('OnPrem')]
    procedure SearchAccountGL()
    begin
        if Account.Get(Stats."No.") then
            with Stats do begin
                //BT.AB6.20070314 : champ Volume : quantitÔÇÜ * Poids net de l'article
                //uniquement pour l'article, pour ne pas reprendre le transport
                //  Volume := Quantity;

                if "Global Dimension 1 Code" = '' then
                    "Global Dimension 1 Code" := Account."Global Dimension 1 Code";
                if "Global Dimension 2 Code" = '' then
                    "Global Dimension 2 Code" := Account."Global Dimension 2 Code";
                if "Consol. Debit Acc." = '' then
                    "Consol. Debit Acc." := Account."Consol. Debit Acc.";
                if "Consol. Credit Acc." = '' then
                    "Consol. Credit Acc." := Account."Consol. Credit Acc.";
                if "Gen. Prod. Posting Group" = '' then
                    "Gen. Prod. Posting Group" := Account."Gen. Prod. Posting Group";

                SearchSpecificFieldsAccount;

            end;
    end;

    [Scope('OnPrem')]
    procedure SearchEmployee()
    begin
        if Employee.Get(Stats."No.") then
            with Stats do begin
                Volume := Quantity;
                if "Global Dimension 1 Code" = '' then
                    "Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
                if "Global Dimension 2 Code" = '' then
                    "Global Dimension 2 Code" := Employee."Global Dimension 2 Code";

                SearchSpecificFieldsEmployee;

            end;
    end;

    [Scope('OnPrem')]
    procedure SearchJob()
    begin
        if Stats."Job No." <> '' then
            if Job.Get(Stats."Job No.") then
                with Stats do begin
                    if ("Source No." = '') and (Job."Bill-to Customer No." <> '') then begin
                        "Source Type" := "Source Type"::Customer;
                        "Source No." := Job."Bill-to Customer No.";
                    end;
                    "Job criteria 1" := Job."Criteria 1";
                    "Job criteria 2" := Job."Criteria 2";
                    "Job criteria 3" := Job."Criteria 3";
                    "Job criteria 4" := Job."Criteria 4";
                    "Job criteria 5" := Job."Criteria 5";
                    "Job criteria 6" := Job."Criteria 6";
                    "Job criteria 7" := Job."Criteria 7";
                    "Job criteria 8" := Job."Criteria 8";
                    "Job criteria 9" := Job."Criteria 9";
                    "Job criteria 10" := Job."Criteria 10";
                    if "Global Dimension 1 Code" = '' then
                        "Global Dimension 1 Code" := Job."Global Dimension 1 Code";
                    if "Global Dimension 2 Code" = '' then
                        "Global Dimension 2 Code" := Job."Global Dimension 2 Code";
                    if "Job Posting Group" = '' then
                        "Job Posting Group" := Job."Job Posting Group";
                    if "Person Responsible" = '' then
                        "Person Responsible" := Job."Person Responsible";

                    if Object.Get(Object.Type::Codeunit, '', 8004001) then
                        CODEUNIT.Run(CODEUNIT::Tools, Stats);

                    SearchSpecificFieldsJob;

                end;
    end;

    [Scope('OnPrem')]
    procedure SearchCustomerOrVendor()
    begin
        case Stats."Source Type" of
            Stats."Source Type"::Customer:
                begin
                    if Customer.Get(Stats."Source No.") then
                        with Stats do begin
                            if StatisticSetup."Customer criteria 1 required" then
                                Customer.TestField("Criteria 1");
                            if StatisticSetup."Customer criteria 2 required" then
                                Customer.TestField("Criteria 2");
                            if StatisticSetup."Customer criteria 3 required" then
                                Customer.TestField("Criteria 3");
                            if StatisticSetup."Customer criteria 4 required" then
                                Customer.TestField("Criteria 4");
                            if StatisticSetup."Customer criteria 5 required" then
                                Customer.TestField("Criteria 5");
                            if StatisticSetup."Customer criteria 6 required" then
                                Customer.TestField("Criteria 6");
                            if StatisticSetup."Customer criteria 7 required" then
                                Customer.TestField("Criteria 7");
                            if StatisticSetup."Customer criteria 8 required" then
                                Customer.TestField("Criteria 8");
                            if StatisticSetup."Customer criteria 9 required" then
                                Customer.TestField("Criteria 9");
                            if StatisticSetup."Customer criteria 10 required" then
                                Customer.TestField("Criteria 10");
                            "Customer criteria 1" := Customer."Criteria 1";
                            "Customer criteria 2" := Customer."Criteria 2";
                            "Customer criteria 3" := Customer."Criteria 3";
                            "Customer criteria 4" := Customer."Criteria 4";
                            "Customer criteria 5" := Customer."Criteria 5";
                            "Customer criteria 6" := Customer."Criteria 6";
                            "Customer criteria 7" := Customer."Criteria 7";
                            "Customer criteria 8" := Customer."Criteria 8";
                            "Customer criteria 9" := Customer."Criteria 9";
                            "Customer criteria 10" := Customer."Criteria 10";
                            "Country Code" := Customer."Country/Region Code";
                            if "Global Dimension 1 Code" = '' then
                                "Global Dimension 1 Code" := Customer."Global Dimension 1 Code";
                            if "Global Dimension 2 Code" = '' then
                                "Global Dimension 2 Code" := Customer."Global Dimension 2 Code";
                            if "Salespers./Purch. Code" = '' then
                                "Salespers./Purch. Code" := Customer."Salesperson Code";
                            if "Source Posting Group" = '' then
                                "Source Posting Group" := Customer."Customer Posting Group";
                            if "Gen. Bus. Posting Group" = '' then
                                "Gen. Bus. Posting Group" := Customer."Gen. Bus. Posting Group";

                            SearchSpecificFieldsCustomer;

                        end;
                end;
            Stats."Source Type"::Vendor:
                begin
                    if Vendor.Get(Stats."Source No.") then
                        with Stats do begin
                            //--> STA-000 ABSYS GN 20061006
                            if StatisticSetup."Vendor criteria 1 required" then
                                Vendor.TestField("Criteria 1");
                            if StatisticSetup."Vendor criteria 2 required" then
                                Vendor.TestField("Criteria 2");
                            if StatisticSetup."Vendor criteria 3 required" then
                                Vendor.TestField("Criteria 3");
                            if StatisticSetup."Vendor criteria 4 required" then
                                Vendor.TestField("Criteria 4");
                            if StatisticSetup."Vendor criteria 5 required" then
                                Vendor.TestField("Criteria 5");
                            if StatisticSetup."Vendor criteria 6 required" then
                                Vendor.TestField("Criteria 6");
                            if StatisticSetup."Vendor criteria 7 required" then
                                Vendor.TestField("Criteria 7");
                            if StatisticSetup."Vendor criteria 8 required" then
                                Vendor.TestField("Criteria 8");
                            if StatisticSetup."Vendor criteria 9 required" then
                                Vendor.TestField("Criteria 9");
                            if StatisticSetup."Vendor criteria 10 required" then
                                Vendor.TestField("Criteria 10");
                            "Vendor criteria 1" := Vendor."Criteria 1";
                            "Vendor criteria 2" := Vendor."Criteria 2";
                            "Vendor criteria 3" := Vendor."Criteria 3";
                            "Vendor criteria 4" := Vendor."Criteria 4";
                            "Vendor criteria 5" := Vendor."Criteria 5";
                            "Vendor criteria 6" := Vendor."Criteria 6";
                            "Vendor criteria 7" := Vendor."Criteria 7";
                            "Vendor criteria 8" := Vendor."Criteria 8";
                            "Vendor criteria 9" := Vendor."Criteria 9";
                            "Vendor criteria 10" := Vendor."Criteria 10";
                            "Country Code" := Vendor."Country/Region Code";
                            //<-- STA-000 ABSYS GN 20061006
                            if "Global Dimension 1 Code" = '' then
                                "Global Dimension 1 Code" := Vendor."Global Dimension 1 Code";
                            if "Global Dimension 2 Code" = '' then
                                "Global Dimension 2 Code" := Vendor."Global Dimension 2 Code";
                            if "Salespers./Purch. Code" = '' then
                                "Salespers./Purch. Code" := Vendor."Purchaser Code";
                            if "Source Posting Group" = '' then
                                "Source Posting Group" := Vendor."Vendor Posting Group";
                            if "Gen. Bus. Posting Group" = '' then
                                "Gen. Bus. Posting Group" := Vendor."Gen. Bus. Posting Group";

                            SearchSpecificFieldsVendor;

                        end;
                end;
        end;
    end;

    [Scope('OnPrem')]
    procedure SearchFiscalDate()
    var
        AccountingPeriod: Record "Accounting Period";
    begin
        with Stats do begin
            AccountingPeriod.SetFilter("Starting Date", '>=%1', "Ending Date");
            AccountingPeriod.SetRange("New Fiscal Year", true);
            if AccountingPeriod.Find('-') then
                "Fiscal year closing date" := AccountingPeriod."Starting Date" - 1;
        end;
    end;

    [Scope('OnPrem')]
    procedure CreateCodeAndDescription(TableNumber: Integer; FieldNumber: Integer; CodeValue: Code[20]; CodeDescription: Text[30])
    begin
        with Code do
            if not Get(TableNumber, FieldNumber, CodeValue) then begin
                Init;
                "Table No" := TableNumber;
                "Field No" := FieldNumber;
                Code := CodeValue;
                Description := CodeDescription;
                Insert;
            end else begin
                Description := CodeDescription;
                Modify;
            end;
    end;

    [Scope('OnPrem')]
    procedure ModifyDateValues()
    begin
        Stats.Year := Date2DMY(Stats."Ending Date", 3);
        Stats.Month := Date2DMY(Stats."Ending Date", 2);
        Stats.Week := Date2DWY(Stats."Ending Date", 2);
        Stats."Week Day" := Date2DWY(Stats."Ending Date", 1);
        case Stats.Month of
            1, 2, 3:
                begin
                    Stats."Half Year" := 1;
                    Stats.Quarter := 1;
                end;
            4, 5, 6:
                begin
                    Stats."Half Year" := 1;
                    Stats.Quarter := 2;
                end;
            7, 8, 9:
                begin
                    Stats."Half Year" := 2;
                    Stats.Quarter := 3;
                end;
            10, 11, 12:
                begin
                    Stats."Half Year" := 2;
                    Stats.Quarter := 4;
                end;
        end;
    end;

    [Scope('OnPrem')]
    procedure SearchFields(pFirstNo: Integer; pLastNo: Integer; pDiff: Integer; pRecRef: RecordRef)
    var
        Description: Text[30];
        lRecRef: RecordRef;
        lFieldRef: FieldRef;
        i: Integer;
        lLocField: FieldRef;
        lStatsRef: RecordRef;
        lStatsField: FieldRef;
        lStatsField2: FieldRef;
        lField: Text[30];
        lNoField: Integer;
        lTableRelation: RecordRef;
        lTableRelationField: FieldRef;
        lValue: Text[250];
        lRes: Record Resource;
        lRecordField: Record "Field";
    begin
        //PROJET
        lRecRef.GetTable(StatisticSetup);
        for i := pFirstNo to pLastNo do begin
            lFieldRef := lRecRef.Field(i);
            if Format(lFieldRef.Value) <> '' then begin
                if CopyStr(Format(lFieldRef.Value), 1, StrPos(Format(lFieldRef.Value), '.') - 1) = Format(pRecRef.Number) then begin
                    lField := CopyStr(Format(lFieldRef.Value), StrPos(Format(lFieldRef.Value), '.') + 1);
                    Evaluate(lNoField, lField);
                    Description := '';
                    if lNoField <> 0 then begin
                        lStatsRef.GetTable(Stats);
                        lLocField := pRecRef.Field(lNoField);
                        lValue := Format(lLocField);
                        if lValue <> '' then begin
                            lStatsField := lStatsRef.Field(i - pDiff);
                            if lValue <> Format(lLocField.Value) then
                                lStatsField.Value(lValue)
                            else
                                lStatsField.Value(lLocField.Value);
                            lStatsRef := lStatsField.Record;
                            lStatsRef.SetTable(Stats);
                            if lValue = Format(lLocField.Value) then      //Option
                                if pFirstNo <> 100071 then begin              //Boolean
                                    if lRecordField.Get(pRecRef.Number, lNoField) then
                                        if lRecordField.RelationTableNo <> 0 then begin
                                            lTableRelation.Open(lRecordField.RelationTableNo);
                                            lTableRelationField := lTableRelation.Field(1);
                                            case lLocField.Relation of
                                                8003929:
                                                    begin
                                                        lStatsField2 := lStatsRef.Field(5);
                                                        if Format(lStatsField2.Value) = '1' then begin
                                                            lTableRelationField.Value(3);
                                                            lTableRelation := lTableRelationField.Record;
                                                            lStatsField.Value(Item.TableCaption + ' ' + Format(lLocField.Value));
                                                            lStatsRef := lStatsField.Record;
                                                            lStatsRef.SetTable(Stats);
                                                        end;
                                                        if Format(lStatsField2.Value) = '2' then begin
                                                            lStatsField2 := lStatsRef.Field(6);
                                                            if lRes.Get(format(lStatsField2.Value)) then begin
                                                                lTableRelationField.Value(lRes.Type);
                                                                lTableRelation := lTableRelationField.Record;
                                                                lStatsField.Value(Format(lRes.Type) + ' ' + Format(lLocField.Value));
                                                                lStatsRef := lStatsField.Record;
                                                                lStatsRef.SetTable(Stats);
                                                            end;
                                                        end;
                                                        lTableRelationField := lTableRelation.Field(2);
                                                        lTableRelationField.Value(lValue);
                                                        lTableRelation := lTableRelationField.Record;
                                                    end;
                                                8001400:
                                                    begin
                                                        lTableRelationField.Value(pRecRef.Number);
                                                        lTableRelation := lTableRelationField.Record;
                                                        lTableRelationField := lTableRelation.Field(2);
                                                        lTableRelationField.Value(lNoField);
                                                        lTableRelation := lTableRelationField.Record;
                                                        lTableRelationField := lTableRelation.Field(3);
                                                        lTableRelationField.Value(lValue);
                                                        lTableRelation := lTableRelationField.Record;
                                                    end;
                                                else begin
                                                    lTableRelationField.Value(lValue);
                                                    lTableRelation := lTableRelationField.Record;
                                                    //lTableRelation.OPEN(lTableRelation.NUMBER);
                                                end;
                                            end;
                                            lTableRelation.SetRecFilter;
                                            if lTableRelation.Find('-') then begin
                                                //            MESSAGE('%1',lTableRelation.FIELD(2).VALUE);
                                                //     lTableRelation := lTableRelationField.RECORD;
                                                case lTableRelation.Number of
                                                    156, 8003929:
                                                        Description := CopyStr(Format(lTableRelation.Field(3).Value), 1, MaxStrLen(Description));
                                                    8001400:
                                                        Description := CopyStr(Format(lTableRelation.Field(4).Value), 1, MaxStrLen(Description));
                                                    else
                                                        Description := CopyStr(Format(lTableRelation.Field(2).Value), 1, MaxStrLen(Description));
                                                end;
                                                //     MESSAGE('aaaaa');
                                                //     MESSAGE('111    %1',lTableRelation.FIELD(2).VALUE);
                                                //     MESSAGE('222    %1',lTableRelationField.VALUE);

                                                //Description := COPYSTR(FORMAT(lTableRelationField.VALUE),1,MAXSTRLEN(Description));
                                                //        MESSAGE('AAAAAA');
                                            end;
                                            lValue := lStatsField.Value;
                                            //                 MESSAGE('bbbb');
                                        end
                                        else begin
                                            Description := lValue;
                                        end;
                                end;
                            CreateCodeAndDescription(8001300, i - pDiff, lValue, Description);
                        end;
                    end;
                end;
            end;
        end;
        //PROJET//
    end;

    [Scope('OnPrem')]
    procedure SearchSpecificFieldsItem()
    var
        lItemRef: RecordRef;
    begin
        lItemRef.GetTable(Item);
        SearchFields(100041, 100050, 99040, lItemRef);
        SearchFields(100061, 100065, 99050, lItemRef);
        SearchFields(100071, 100075, 99050, lItemRef);
    end;

    [Scope('OnPrem')]
    procedure SearchSpecificFieldsResource()
    var
        lResRef: RecordRef;
    begin
        lResRef.GetTable(Resource);
        SearchFields(100041, 100050, 99040, lResRef);
        SearchFields(100061, 100065, 99050, lResRef);
        SearchFields(100071, 100075, 99050, lResRef);
    end;

    [Scope('OnPrem')]
    procedure SearchSpecificFieldsAccount()
    var
        lAccRef: RecordRef;
    begin
        lAccRef.GetTable(Account);
        SearchFields(100041, 100050, 99040, lAccRef);
        SearchFields(100061, 100065, 99050, lAccRef);
        SearchFields(100071, 100075, 99050, lAccRef);
    end;

    [Scope('OnPrem')]
    procedure SearchSpecificFieldsEmployee()
    var
        lEmplRef: RecordRef;
    begin
        lEmplRef.GetTable(Employee);
        SearchFields(100041, 100050, 99040, lEmplRef);
        SearchFields(100061, 100065, 99050, lEmplRef);
        SearchFields(100071, 100075, 99050, lEmplRef);
    end;

    [Scope('OnPrem')]
    procedure SearchSpecificFieldsJob()
    var
        lJobRef: RecordRef;
    begin
        lJobRef.GetTable(Job);
        SearchFields(100041, 100050, 99040, lJobRef);
        SearchFields(100061, 100065, 99050, lJobRef);
        SearchFields(100071, 100075, 99050, lJobRef);
    end;

    [Scope('OnPrem')]
    procedure SearchSpecificFieldsCustomer()
    var
        lCustRef: RecordRef;
    begin
        lCustRef.GetTable(Customer);
        SearchFields(100041, 100050, 99040, lCustRef);
        SearchFields(100061, 100065, 99050, lCustRef);
        SearchFields(100071, 100075, 99050, lCustRef);
    end;

    [Scope('OnPrem')]
    procedure SearchSpecificFieldsVendor()
    var
        lVendRef: RecordRef;
    begin
        lVendRef.GetTable(Vendor);
        SearchFields(100041, 100050, 99040, lVendRef);
        SearchFields(100061, 100065, 99050, lVendRef);
        SearchFields(100071, 100075, 99050, lVendRef);
    end;
}

