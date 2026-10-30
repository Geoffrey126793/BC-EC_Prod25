pageextension 70135 pageextension70135 extends "Sales Lines"
{
    layout
    {
        addafter("Document No.")
        {
            field(ClientBloque; ClientBloque)
            {
                Caption = 'Autorisation livraison';
                Style = Unfavorable;
                StyleExpr = ClientBloque <> 'OK';
            }
        }
        addafter(Reserve)
        {
            field("Quantity (Base)"; "Quantity (Base)")
            {
            }
        }
        addafter("Shipment Date")
        {
            field("Qty. Shipped Not Invoiced"; "Qty. Shipped Not Invoiced")
            {
            }
            field("Quantity Shipped"; "Quantity Shipped")
            {
            }
            field("Quantity Invoiced"; "Quantity Invoiced")
            {
            }
            field("Shipment No."; "Shipment No.")
            {
            }
        }
        addafter("Outstanding Quantity")
        {
            field("Qty. to Invoice"; "Qty. to Invoice")
            {
            }
            field("Promised Delivery Date"; "Promised Delivery Date")
            {
            }
            field("Nom client"; "Nom client")
            {
            }
        }
    }

    var
        SalesH: Record "Sales Header";

    var
        ClientBloque: Text[30];

    trigger OnAfterGetRecord()
    begin
        if SalesH.Get("Document Type", "Document No.") then
            if SalesH."Customer Shipment Blocked" then
                ClientBloque := 'LIVRAISON BLOQUEE'
            else
                ClientBloque := 'OK';
    end;
}

