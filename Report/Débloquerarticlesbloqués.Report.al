report 50030 "Débloquer articles bloqués"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {

            trigger OnAfterGetRecord()
            begin
                Item.Blocked := false;
                Modify;
            end;

            trigger OnPreDataItem()
            begin
                Item.SetCurrentKey("No.");
                Item.SetRange(Blocked, true);
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
}

