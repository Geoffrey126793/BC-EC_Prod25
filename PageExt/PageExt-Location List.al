pageextension 70040 pageextension70040 extends "Location List"
{

    trigger OnOpenPage()
    begin
        SetFilter(Disabled, '%1', false);
    end;

    procedure GetSelectionFilterMulti(): Code[80]
    var
        Location: Record Location;
        FirstLocation: Code[20];
        LastLocation: Code[20];
        SelectionFilter: Code[250];
        LocationCount: Integer;
        More: Boolean;
    begin
        CurrPage.SetSelectionFilter(Location);
        LocationCount := Location.Count;
        if LocationCount > 0 then begin
            Location.Find('-');
            while LocationCount > 0 do begin
                LocationCount := LocationCount - 1;
                Location.MarkedOnly(false);
                FirstLocation := Location.Code;
                LastLocation := FirstLocation;
                More := (LocationCount > 0);
                while More do
                    if Location.Next = 0 then
                        More := false
                    else
                        if not Location.Mark then
                            More := false
                        else begin
                            LastLocation := Location.Code;
                            LocationCount := LocationCount - 1;
                            if LocationCount = 0 then
                                More := false;
                        end;
                if SelectionFilter <> '' then
                    SelectionFilter := SelectionFilter + '|';
                if FirstLocation = LastLocation then
                    SelectionFilter := SelectionFilter + FirstLocation
                else
                    SelectionFilter := SelectionFilter + FirstLocation + '..' + LastLocation;
                if LocationCount > 0 then begin
                    Location.MarkedOnly(true);
                    Location.Next;
                end;
            end;
        end;
        exit(SelectionFilter);
    end;
}

