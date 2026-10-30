page 50085 AskQty
{
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            field(Qty; Qty)
            {
                Caption = 'Quantité ?';
            }
            field("Nbre impressions"; Imp)
            {
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        recExp: Record "Sales Shipment Header";
        cuModif: Codeunit ModifTables;
    begin
    end;

    var
        Qty: Decimal;
        Imp: Decimal;

    [Scope('OnPrem')]
    procedure getQty(): Decimal
    begin
        exit(Qty);
    end;

    [Scope('OnPrem')]
    procedure getImp(): Decimal
    begin
        exit(Imp);
    end;
}

