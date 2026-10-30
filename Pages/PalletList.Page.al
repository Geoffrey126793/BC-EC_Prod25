page 50004 "Pallet List"
{
    Caption = 'Pallet List';
    PageType = List;
    SourceTable = Pallet;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("SSCC No."; "SSCC No.")
                {
                }
                field("Location code"; "Location code")
                {
                }
                field("Current Quantity"; "Current Quantity")
                {
                }
                field("Current Weight"; "Current Weight")
                {
                }
                field("Inbound Document Type"; "Inbound Document Type")
                {
                }
                field("Inbound Document No."; "Inbound Document No.")
                {
                }
                field("Inbound Doc. Line No."; "Inbound Doc. Line No.")
                {
                }
                field("Outbound Document Type"; "Outbound Document Type")
                {
                }
                field("Outbound Document No."; "Outbound Document No.")
                {
                }
                field("Outbound Doc. Line No."; "Outbound Doc. Line No.")
                {
                }
                field("Last Entry No."; "Last Entry No.")
                {
                }
                field("Pallet Journal Line Exist"; "Pallet Journal Line Exist")
                {
                }
                field("Qty on pallet Jnl"; "Qty on pallet Jnl")
                {
                }
                field("Creation Date"; "Creation Date")
                {
                }
                field("Creation Time"; "Creation Time")
                {
                }
                field("No. Series"; "No. Series")
                {
                }
                field("Bin code"; "Bin code")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field("Lot No."; "Lot No.")
                {
                }
                field(DLC; DLC)
                {
                }
                field("Display order"; "Display order")
                {
                }
                field("Item Description"; "Item Description")
                {
                }
                field("Nbre bacs reception"; "Nbre bacs reception")
                {
                }
                field("Type bacs reception"; "Type bacs reception")
                {
                }
                field("Type palette reception"; "Type palette reception")
                {
                }
                field("Temperature reception"; "Temperature reception")
                {
                }
                field("Poids brut reception"; "Poids brut reception")
                {
                }
                field("Quai reception"; "Quai reception")
                {
                }
                field("User reception"; "User reception")
                {
                }
                field("Lot bloque"; "Lot bloque")
                {
                }
                field(LigneOF; LigneOF)
                {
                }
                field(NumOF; NumOF)
                {
                }
                field(ABloquer; ABloquer)
                {
                }
                field("Ligne production"; "Ligne production")
                {
                }
                field(Comment; Comment)
                {
                }
                field("Palette liee"; "Palette liee")
                {
                }
                field(Printed; Printed)
                {
                }
                field("Quantite reception"; "Quantite reception")
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
                field("Quantite lot reserve"; "Quantite lot reserve")
                {
                }
                field(BaseUnit; recItem."Base Unit of Measure")
                {
                }
                field("Current Quantity lot"; "Current Quantity lot")
                {
                }
                field("Current quantity Stock"; "Current quantity Stock")
                {
                }
                field("Current quantity ECStock"; "Current quantity ECStock")
                {
                }
                field("Current Quantity lot Prod"; "Current Quantity lot Prod")
                {
                }
                field(Type; Type)
                {
                }
                field(AskContent; AskContent)
                {
                }
                field(PoidsCarton; recItem."Poids carton")
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
        Items: Record Item;
        PalletEntry: Record "Pallet Ledger Entry";
        ExpeOTS: Record "Transfer Shipment Header";
        SalesH: Record "Sales Header";
        cuprod: Codeunit "WS Scan";
    begin
        CalcFields("Current Quantity");
        if "Current Quantity" = 0 then begin
            PalletEntry.Reset;
            PalletEntry.SetRange("SSCC No.", "SSCC No.");
            if PalletEntry.FindLast then begin
                if (PalletEntry."Entry Type" = PalletEntry."Entry Type"::Transfer) and (PalletEntry.Quantity < 0) then begin
                    if ExpeOTS.Get(PalletEntry."Document No.") then begin
                        if ExpeOTS."Transfer-to Code" = 'EC TOURNAI' then begin
                            "Location code" := 'EC TOURNAI';
                            "Bin code" := 'PROD_IQF_COMP';
                            "Quantite reception" := Abs(PalletEntry.Quantity);
                        end;
                        if ExpeOTS."Transfer-to Code" = 'EC DORMA' then begin
                            "Location code" := 'EC DORMA';
                            "Bin code" := 'DORMA';
                            "Quantite reception" := Abs(PalletEntry.Quantity);
                        end;

                    end;
                end;
            end;
        end;
        if Rec.DLC = 0D then
            Rec.DLC := 20000101D;
        if Rec."Creation Date" = 0D then
            Rec."Creation Date" := Today;

        if recItem.Get(Rec."Item No.") then begin
            recItem.CalcFields("Poids carton");
        end;

        AskContent := cuprod.IsPaletContent(Rec."SSCC No.");
    end;

    var
        "Lot No.": Code[10];
        Traca: Code[10];
        recItem: Record Item;
        AskContent: Boolean;
}

