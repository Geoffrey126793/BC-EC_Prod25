report 8001314 "Translate demo data"
{
    // //STATSEXPLORER STATSEXPLORER 01/01/00 Tool

    ProcessingOnly = true;

    dataset
    {
        dataitem("Standard statistic"; "Standard statistic")
        {
            DataItemTableView = SORTING(Code);

            trigger OnAfterGetRecord()
            begin
                Name := TranslateDescription(Name, MaxStrLen(Name));
                Modify;
            end;
        }
        dataitem("Column style name"; "Column style name")
        {
            DataItemTableView = SORTING(Code);

            trigger OnAfterGetRecord()
            begin
                Description := TranslateDescription(Description, MaxStrLen(Description));
                Modify;
            end;
        }
        dataitem("Statistic column"; "Statistic column")
        {
            DataItemTableView = SORTING(Code, "Line No.");

            trigger OnAfterGetRecord()
            begin
                "Column Layout Name" := TranslateDescription("Column Layout Name", MaxStrLen("Column Layout Name"));
                Modify;
            end;
        }
        dataitem("Statistic sort criteria"; "Statistic sort criteria")
        {
            DataItemTableView = SORTING(Type, Code);

            trigger OnAfterGetRecord()
            begin
                Description := TranslateDescription(Description, MaxStrLen(Description));
                Modify;
            end;
        }
        dataitem("Statistic category"; "Statistic category")
        {
            DataItemTableView = SORTING(Code);

            trigger OnAfterGetRecord()
            begin
                Description := TranslateDescription(Description, MaxStrLen(Description));
                Modify;
            end;
        }
        dataitem("Statistic Scheduler header"; "Statistic Scheduler header")
        {
            DataItemTableView = SORTING(Code);

            trigger OnAfterGetRecord()
            begin
                Description := TranslateDescription(Description, MaxStrLen(Description));
                Modify;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    [Scope('OnPrem')]
    procedure TranslateDescription(pSource: Text[100]; pLengh: Integer) Return: Text[100]
    var
        TableTranslation: Record "Statistics translations";
    begin
        if TableTranslation.Get(pSource, GlobalLanguage) then
            pSource := CopyStr(TableTranslation.Translation, 1, pLengh);
        exit(pSource);
    end;
}

