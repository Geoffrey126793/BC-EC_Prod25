page 50061 "WS OTS"
{
    PageType = List;
    SourceTable = "Transfer Line";
    SourceTableView = WHERE ("Derived From Line No." = CONST (0));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; "Document No.")
                {
                }
                field("Line No."; "Line No.")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Quantity (Base)"; "Quantity (Base)")
                {
                }
                field("Qty. to Ship (Base)"; "Qty. to Ship (Base)")
                {
                }
                field("Qty. Shipped (Base)"; "Qty. Shipped (Base)")
                {
                }
                field("Qty. to Receive (Base)"; "Qty. to Receive (Base)")
                {
                }
                field("Qty. Received (Base)"; "Qty. Received (Base)")
                {
                }
                field("Transfer-from Code"; "Transfer-from Code")
                {
                }
                field("Transfer-to Code"; "Transfer-to Code")
                {
                }
                field(Emplacement; Emplacement)
                {
                }
                field(TrackingCode; TrackingCode)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        OTS.Get("Document No.");
        Emplacement := OTS.Emplacement;
        if recItem.Get(Rec."Item No.") then
            TrackingCode := recItem."Item Tracking Code";
    end;

    var
        Emplacement: Code[30];
        OTS: Record "Transfer Header";
        recItem: Record Item;
        TrackingCode: Code[20];
}

