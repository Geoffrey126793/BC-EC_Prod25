table 8001425 "Sort Key"
{
    // //+BGW+SORT CW 21/07/03 Sort

    Caption = 'Sort Key';

    fields
    {
        field(1; TableNo; Integer)
        {
            Caption = 'Table ID';
            TableRelation = Object.ID WHERE(Type = CONST(Table));
        }
        field(2; SortKey; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; SortFields; Text[250])
        {
            Caption = 'Key';
        }
        field(4; Print; Option)
        {
            Caption = 'Print Detail';
            OptionCaption = 'If not Null,Always,Never';
            OptionMembers = "If not Null",Always,Never;
        }
    }

    keys
    {
        key(Key1; TableNo, SortKey)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        lSortLine: Record "Sort Field";
    begin
        lSortLine.SetCurrentKey(TableNo, SortKey);
        lSortLine.SetRange(TableNo, TableNo);
        lSortLine.SetRange(SortKey, SortKey);
        lSortLine.DeleteAll(true);
    end;
}

