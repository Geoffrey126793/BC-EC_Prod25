page 50082 AskPal
{
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            field(NbrPal; NbrPal)
            {
                Caption = 'Nombre de palettes';
            }
            field(NbrColis; NbrColis)
            {
                Caption = 'Nombre de colis';
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
        cuModif.PaletOnShipment(ExpNo, NbrPal, NbrColis);
    end;

    var
        NbrPal: Integer;
        NbrColis: Integer;
        ExpNo: Code[20];
        recExp: Record "Sales Shipment Header";

    [Scope('OnPrem')]
    procedure setExp(No: Code[20])
    begin
        ExpNo := No;

        recExp.Get(ExpNo);
    end;
}

