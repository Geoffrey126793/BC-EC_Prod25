page 50048 "Modif Prevision"
{
    PageType = List;
    SourceTable = "Statistic aggregate";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry Type"; "Entry Type")
                {
                    Editable = false;
                }
                field(Type; Type)
                {
                    Editable = false;
                }
                field("No."; "No.")
                {
                    Editable = false;
                }
                field("Source Type"; "Source Type")
                {
                    Editable = false;
                }
                field("Source No."; "Source No.")
                {
                    Editable = false;
                }
                field(Quantity; Quantity)
                {
                    Style = Favorable;
                    StyleExpr = modif;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        modif := "Free boolean 1";
    end;

    trigger OnModifyRecord(): Boolean
    begin
        "Free boolean 1" := true;
    end;

    trigger OnOpenPage()
    begin
        CurrPage.Editable(true);
    end;

    var
        modif: Boolean;
}

