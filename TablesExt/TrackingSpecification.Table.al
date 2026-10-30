tableextension 50067 TrackingSpecificationEC extends "Tracking Specification"
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
                if "Pallet Qty" <> 0 then begin
                    PalletJnl.SetCurrentKey("Reservation Entry");
                    PalletJnl.SetRange("Reservation Entry", "Entry No.");
                    PalletJnl.DeleteAll;

                    ScanMgt.CreatePalletJournalFromTrack(Rec);

                end;
            end;
        }
        field(51002; "Reservation Entry No."; Integer)
        {
            Caption = 'Reservation Entry No.';
        }
    }

}

