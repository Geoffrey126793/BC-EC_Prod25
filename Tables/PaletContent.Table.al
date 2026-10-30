table 50040 PaletContent
{

    fields
    {
        field(1; SSCCPalet; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; SSCCContent; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; SSCCPalet, SSCCContent)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        oldcontent.Reset;
        oldcontent.SetFilter(SSCCPalet, '<>%1', Rec.SSCCPalet);
        oldcontent.SetRange(SSCCContent, Rec.SSCCContent);
        if oldcontent.FindFirst then
            Error('Le carton est déjà associé à une autre palette');
    end;

    trigger OnModify()
    begin
        oldcontent.Reset;
        oldcontent.SetFilter(SSCCPalet, '<>%1', Rec.SSCCPalet);
        oldcontent.SetRange(SSCCContent, Rec.SSCCContent);
        if oldcontent.FindFirst then
            Error('Le carton est déjà associé à une autre palette');
    end;

    var
        oldcontent: Record PaletContent;
}

