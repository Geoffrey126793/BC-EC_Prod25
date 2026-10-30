page 50029 "Liste palettes"
{
    Caption = 'Liste palettes';
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = Pallet;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("SSCC No."; "SSCC No.")
                {
                }
                field("Current Quantity"; "Current Quantity")
                {
                }
                field("Location code"; "Location code")
                {
                }
                field("Inbound Document Type"; "Inbound Document Type")
                {
                }
                field("Inbound Document No."; "Inbound Document No.")
                {
                }
                field("Outbound Document Type"; "Outbound Document Type")
                {
                }
                field("Outbound Document No."; "Outbound Document No.")
                {
                }
                field("Creation Date"; "Creation Date")
                {
                }
                field("Creation Time"; "Creation Time")
                {
                }
                field("Last Entry No."; "Last Entry No.")
                {
                }
                field("Bin code"; "Bin code")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field("Ligne production"; "Ligne production")
                {
                }
                field(ABloquer; ABloquer)
                {
                }
                field(Comment; Comment)
                {
                }
                field("Quantite reception"; "Quantite reception")
                {
                }
                field(DLC; DLC)
                {
                }
                field(Printed; Printed)
                {
                }
                field("Item Description"; "Item Description")
                {
                }
                field("Lot No."; "Lot No.")
                {
                    Width = 30;
                }
                field("Type palette Txt"; "Type palette Txt")
                {
                }
                field("Temperature reception"; "Temperature reception")
                {
                }
                field("Temperature secondaire"; "Temperature secondaire")
                {
                }
                field("Date Temperature secondaire"; "Date Temperature secondaire")
                {
                }
                field("Dernier Inventaire"; "Dernier Inventaire")
                {
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action(Imprimer)
            {
                Caption = 'Imprimer';

                trigger OnAction()
                var
                    recPal: Record Pallet;
                begin
                    recPal.Reset;
                    recPal.SetFilter("SSCC No.", "SSCC No.");
                    REPORT.Run(50024, true, false, recPal);
                end;
            }
        }
        area(processing)
        {
            action(Perdu)
            {

                trigger OnAction()
                begin
                    Rec.CalcFields("Current Quantity");
                    scan.TftFromCongelToLocation(Rec."SSCC No.", Rec."Current Quantity", 'PERDU', CopyStr(UserId, 1, 20));
                    Message('ok');
                end;
            }
        }
    }

    var
        scan: Codeunit "WS Scan";

    [Scope('OnPrem')]
    procedure UpdateForm(SetSaveRecord: Boolean)
    begin
        CurrPage.Update(SetSaveRecord);
    end;

    [Scope('OnPrem')]
    procedure GetRecords(var recPallets: Record Pallet)
    begin
        CurrPage.SetSelectionFilter(recPallets);
    end;
}

