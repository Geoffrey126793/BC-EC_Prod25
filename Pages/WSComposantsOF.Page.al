page 50043 "WS Composants OF"
{
    Caption = 'WS Composants OF';
    PageType = List;
    SourceTable = "Prod. Order Component";
    SourceTableView = WHERE ("Item No." = FILTER (<> ''));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Status; Status)
                {
                }
                field("Prod. Order No."; "Prod. Order No.")
                {
                }
                field("Prod. Order Line No."; "Prod. Order Line No.")
                {
                }
                field("Line No."; "Line No.")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field("Expected Qty. (Base)"; "Expected Qty. (Base)")
                {
                }
                field("Item Category"; "Item Category")
                {
                }
                field("Due Date"; "Due Date")
                {
                }
                field(OFVP; OFVP)
                {
                }
                field("Due Date-Time"; "Due Date-Time")
                {
                }
                field(Description; Description)
                {
                }
                field("Item to produce"; "Item to produce")
                {
                }
                field("Scrap %"; "Scrap %")
                {
                }
                field(QtySansScrap; QtySansScrap)
                {
                }
                field(QtyBesoin; QtyBesoin)
                {
                }
                field(Allergene; Allergene)
                {
                }
                field(Machine; Machine)
                {
                }
                field(Anticipation; Anticipation)
                {
                }
                field("Stock"; Stock)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        Prod: Record "Production Order";
        Items: Record Item;
    begin
        Prod.Reset;
        Prod.SetRange("No.", "Prod. Order No.");
        if Prod.FindFirst then
            OFVP := Prod.IDVP;
        Allergene := -1;
        QtySansScrap := "Expected Qty. (Base)" / (1 + "Scrap %" / 100);
        if Items.Get("Item No.") then begin
            QtyBesoin := QtySansScrap * (1 + Items."% supplémentaire à préparer" / 100);
            Allergene := Items."Niveau allergene";
            Machine := Items."Machine sur écran";
            Anticipation := Items."Anticipation production";
        end;
        if Anticipation = 0 then Anticipation := 1;
    end;

    var
        ItemCategory: Code[20];
        Items: Record Item;
        OFVP: Code[50];
        QtySansScrap: Decimal;
        QtyBesoin: Decimal;
        Allergene: Integer;
        Machine: Text;
        Anticipation: Integer;
}

