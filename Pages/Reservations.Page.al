page 50005 Reservations
{
    Caption = 'Reservations';
    PageType = List;
    SourceTable = "Reservation Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Quantity (Base)"; "Quantity (Base)")
                {
                }
                field("Reservation Status"; "Reservation Status")
                {
                }
                field(Description; Description)
                {
                }
                field("Transferred from Entry No."; "Transferred from Entry No.")
                {
                }
                field("Source Type"; "Source Type")
                {
                }
                field("Source Subtype"; "Source Subtype")
                {
                }
                field("Source ID"; "Source ID")
                {
                }
                field("Source Batch Name"; "Source Batch Name")
                {
                }
                field("Source Prod. Order Line"; "Source Prod. Order Line")
                {
                }
                field("Source Ref. No."; "Source Ref. No.")
                {
                }
                field("Appl.-to Item Entry"; "Appl.-to Item Entry")
                {
                }
                field("Serial No."; "Serial No.")
                {
                }
                field("Created By"; "Created By")
                {
                }
                field("Changed By"; "Changed By")
                {
                }
                field(Positive; Positive)
                {
                }
                field("Qty. per Unit of Measure"; "Qty. per Unit of Measure")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Action Message Adjustment"; "Action Message Adjustment")
                {
                }
                field(Binding; Binding)
                {
                }
                field("Suppressed Action Msg."; "Suppressed Action Msg.")
                {
                }
                field("Planning Flexibility"; "Planning Flexibility")
                {
                }
                field("Qty. to Handle (Base)"; "Qty. to Handle (Base)")
                {
                }
                field("Qty. to Invoice (Base)"; "Qty. to Invoice (Base)")
                {
                }
                field("Quantity Invoiced (Base)"; "Quantity Invoiced (Base)")
                {
                }
                field("New Serial No."; "New Serial No.")
                {
                }
                field("New Lot No."; "New Lot No.")
                {
                }
                field("Lot No."; LotNo)
                {
                }
                field("Variant Code"; "Variant Code")
                {
                }
                field("Appl.-from Item Entry"; "Appl.-from Item Entry")
                {
                }
                field(Correction; Correction)
                {
                }
                field("Item Tracking"; "Item Tracking")
                {
                }
                field("Pallet Qty"; "Pallet Qty")
                {
                }
                field("Qty To Treat"; "Qty To Treat")
                {
                }
                field("Pallet Qty to Treat"; "Pallet Qty to Treat")
                {
                }
                field("Bin Code"; "Bin Code")
                {
                }
                field("Add on existing pallet"; "Add on existing pallet")
                {
                }
                field("Item Jnl Bin Code"; "Item Jnl Bin Code")
                {
                }
                field("First bin code"; "First bin code")
                {
                }
                field("Warranty Date"; DLC)
                {
                }
                field(DLCStr; DLCStr)
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
        Reserv: Record "Reservation Entry";
        ILE: Record "Item Ledger Entry";
    begin

        LotNo := "Lot No.";
        DLC := 19000101D;
        if "Item Tracking" = "Item Tracking"::None then begin
            if Reserv.Get("Entry No.", not Positive) then begin
                LotNo := Reserv."Lot No.";
                if ILE.Get(Reserv."Source Ref. No.") then begin
                    DLC := ILE."Warranty Date";
                end;
            end;
        end
        else begin
            if "Warranty Date" <> 0D then
                DLC := "Warranty Date";
        end;
        DLCStr := Format(DLC);
    end;

    var
        DLC: Date;
        LotNo: Code[50];
        DLCStr: Code[20];
}

