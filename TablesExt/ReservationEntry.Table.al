tableextension 50049 ReservationEntreyEC extends "Reservation Entry"
{
    fields
    {
        field(51001; "Pallet Qty"; Integer)
        {
            Caption = 'Pallet Qty';

            trigger OnValidate()
            var
                PalletJnl: Record "Pallet Journal";
                ScanMgt: Codeunit "Scan Management";
            begin
                if "Source Type" <> 37 then begin
                    if "Pallet Qty" <> 0 then begin
                        PalletJnl.SetCurrentKey("Reservation Entry");
                        PalletJnl.SetRange("Reservation Entry", "Entry No.");
                        PalletJnl.DeleteAll;
                        ScanMgt.CreatePalletJournal(Rec);
                    end else begin
                        PalletJnl.SetCurrentKey("Reservation Entry");
                        PalletJnl.SetRange("Reservation Entry", "Entry No.");
                        PalletJnl.DeleteAll;
                    end;
                end;

                if ("Source Type" = 37) and ("Source Subtype" = 5) then begin
                    if "Pallet Qty" <> 0 then begin
                        PalletJnl.SetCurrentKey("Reservation Entry");
                        PalletJnl.SetRange("Reservation Entry", "Entry No.");
                        PalletJnl.DeleteAll;
                        ScanMgt.CreatePalletJournal(Rec);
                    end else begin
                        PalletJnl.SetCurrentKey("Reservation Entry");
                        PalletJnl.SetRange("Reservation Entry", "Entry No.");
                        PalletJnl.DeleteAll;
                    end;
                end;
            end;
        }
        field(51002; "Qty To Treat"; Decimal)
        {
            CalcFormula = Sum("Pallet Journal"."Treated Quantity" WHERE("Reservation Entry" = FIELD("Entry No.")));
            Caption = 'Qty To Treat';
            Editable = false;
            FieldClass = FlowField;
        }
        field(51003; "Pallet Qty to Treat"; Integer)
        {
            CalcFormula = Count("Pallet Journal" WHERE("Reservation Entry" = FIELD("Entry No.")));
            Caption = 'Pallet Qty to Treat';
            Editable = false;
            FieldClass = FlowField;
        }
        field(51004; "Bin Code"; Code[20])
        {
            CalcFormula = Lookup("Sales Line"."Bin Code" WHERE("Document Type" = CONST(Order),
                                                                "Document No." = FIELD("Source ID"),
                                                                "Line No." = FIELD("Source Ref. No.")));
            Caption = 'Bin Code';
            FieldClass = FlowField;
        }
        field(51100; "Add on existing pallet"; Boolean)
        {
            Caption = 'Add on existing pallet';
        }
        field(51101; "Item Jnl Bin Code"; Code[20])
        {
            CalcFormula = Lookup("Item Journal Line"."Bin Code" WHERE("Journal Template Name" = CONST('ARTICLE'),
                                                                       "Journal Batch Name" = FIELD("Source Batch Name"),
                                                                       "Line No." = FIELD("Source Ref. No.")));
            Caption = 'Item Jnl Bin Code';
            FieldClass = FlowField;
        }
        field(52001; "First bin code"; Code[20])
        {
            Caption = 'First bin code';
        }
    }

}

