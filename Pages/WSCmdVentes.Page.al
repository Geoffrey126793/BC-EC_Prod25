page 50042 "WS Cmd Ventes"
{
    Caption = 'WS Cmd Ventes';
    PageType = List;
    SourceTable = "Sales Line";
    SourceTableView = WHERE ("Requested Delivery Date" = FILTER (<> 0D));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; "Document Type")
                {
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Line No."; "Line No.")
                {
                }
                field(Type; Type)
                {
                }
                field("No."; "No.")
                {
                }
                field("Quantity (Base)"; "Quantity (Base)")
                {
                }
                field("Item Category Code"; "Item Category Code")
                {
                }
                field("Promised Delivery Date"; "Promised Delivery Date")
                {
                }
                field("Qty. to Ship (Base)"; "Qty. to Ship (Base)")
                {
                }
                field(CustomerName; CustomerName)
                {
                }
                field("Transport Purchase Order"; "Transport Purchase Order")
                {
                }
                field(Description; Description)
                {
                }
                field("Date de production"; "Date de production")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field(Transporteur; Tpt)
                {
                }
                field(CommentProd; CommentProd)
                {
                }
                field("Requested Delivery Date"; "Requested Delivery Date")
                {
                }
                field(Terminee; Terminee)
                {
                }
                field("Qte commandée initiale Base"; "Qte commandée initiale Base")
                {
                }
                field("SalesH.""Status credit"""; SalesH."Status credit")
                {
                }
                field(Status; SalesH.Status)
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
        recCust: Record Customer;
    begin
        Tpt := '';
        if recCust.Get("Sell-to Customer No.") then begin
            CustomerName := recCust.Name;
            CommentProd := recCust."Production comment";
        end;
        if "Date de production" = 0D then "Date de production" := 19700101D;
        if SalesH.Get("Document Type", "Document No.") then begin
            Tpt := SalesH."Shipping Agent Code";
            Terminee := (SalesH."Bon Pour Expédition" = SalesH."Bon Pour Expédition"::"Shipment authorized");
        end;
    end;

    var
        CustomerName: Text[80];
        SalesH: Record "Sales Header";
        Tpt: Code[20];
        CommentProd: Text;
        Terminee: Boolean;
}

