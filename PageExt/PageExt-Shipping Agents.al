pageextension 70107 pageextension70107 extends "Shipping Agents"
{
    layout
    {
        modify("Internet Address")
        {
            Visible = false;
        }
        addafter(Name)
        {
            field("Buy-from Vendor No."; "Buy-from Vendor No.")
            {
            }
            field("Phone No."; "Phone No.")
            {
            }
            field("Country Code"; "Country Code")
            {
            }
            field("Post Code"; "Post Code")
            {
            }
            field(City; City)
            {
            }
            field(Address; Address)
            {
            }

        }
    }

    procedure GetSelectionFilter(): Code[80]
    var
        ShippingAgent: Record "Shipping Agent";
        FirstShipAgent: Code[20];
        LastShipAgent: Code[20];
        SelectionFilter: Code[250];
        ShipAgentCount: Integer;
        More: Boolean;
    begin
        CurrPage.SetSelectionFilter(ShippingAgent);
        ShipAgentCount := ShippingAgent.Count;
        if ShipAgentCount > 0 then begin
            ShippingAgent.Find('-');
            while ShipAgentCount > 0 do begin
                ShipAgentCount := ShipAgentCount - 1;
                ShippingAgent.MarkedOnly(false);
                FirstShipAgent := ShippingAgent.Code;
                LastShipAgent := FirstShipAgent;
                More := (ShipAgentCount > 0);
                while More do
                    if ShippingAgent.Next = 0 then
                        More := false
                    else
                        if not ShippingAgent.Mark then
                            More := false
                        else begin
                            LastShipAgent := ShippingAgent.Code;
                            ShipAgentCount := ShipAgentCount - 1;
                            if ShipAgentCount = 0 then
                                More := false;
                        end;
                if SelectionFilter <> '' then
                    SelectionFilter := SelectionFilter + '|';
                if FirstShipAgent = LastShipAgent then
                    SelectionFilter := SelectionFilter + FirstShipAgent
                else
                    SelectionFilter := SelectionFilter + FirstShipAgent + '..' + LastShipAgent;
                if ShipAgentCount > 0 then begin
                    ShippingAgent.MarkedOnly(true);
                    ShippingAgent.Next;
                end;
            end;
        end;
        exit(SelectionFilter);
    end;
}

