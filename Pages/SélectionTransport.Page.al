page 50012 "Sélection Transport"
{
    Caption = 'Sélection Transport';
    DataCaptionFields = "Type transport";
    PageType = ListPlus;
    SourceTable = Transport;

    layout
    {
        area(content)
        {
            field(nbPalette; nbPalette)
            {
                Caption = 'Nombre palette théorique';
                Enabled = false;
            }
            field(nbPaletteConf; nbPaletteConf)
            {
                Caption = 'Nombre palette confirmée';
            }
            repeater(Group)
            {
                field(Type; Type)
                {
                }
                field("Shipping Agent Code"; "Shipping Agent Code")
                {
                }
                field("Territory code"; "Territory code")
                {
                }
                field("Type transport"; "Type transport")
                {
                }
                field("Paletts type"; "Paletts type")
                {
                }
                field("Number of Pallets"; "Number of Pallets")
                {
                }
                field("Currency code"; "Currency code")
                {
                }
                field("Starting date"; "Starting date")
                {
                }
                field("End date"; "End date")
                {
                }
                field("Paletts / Price"; "Paletts / Price")
                {
                }
                field(Transport; Transport)
                {
                }
            }
        }
    }

    actions
    {
    }

    var
        nbPalette: Integer;
        nbPaletteConf: Integer;

    [Scope('OnPrem')]
    procedure SetNbPalette(lNPalette: Integer)
    begin
        nbPalette := lNPalette;
        nbPaletteConf := lNPalette;
    end;

    [Scope('OnPrem')]
    procedure GetNbPalette(): Integer
    begin
        exit(nbPaletteConf);
    end;
}

