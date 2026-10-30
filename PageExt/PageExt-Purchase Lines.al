pageextension 70141 pageextension70141 extends "Purchase Lines"
{
    layout
    {
        addafter("Outstanding Amount (LCY)")
        {
            field("Qty. to Invoice"; "Qty. to Invoice")
            {
            }
            field("Qty. to Receive"; "Qty. to Receive")
            {
            }
        }
        addafter("Amt. Rcd. Not Invoiced (LCY)")
        {
            field(Amount; Amount)
            {
            }
            field("Amount Including VAT"; "Amount Including VAT")
            {
            }
            field("Qty. Rcd. Not Invoiced"; "Qty. Rcd. Not Invoiced")
            {
            }
            field("Quantity Invoiced"; "Quantity Invoiced")
            {
            }
            field("Receipt No."; "Receipt No.")
            {
            }
            field("Quantity Received"; "Quantity Received")
            {
            }
            field("Qty. Received (Base)"; "Qty. Received (Base)")
            {
            }
            field("Qty. to Receive (Base)"; "Qty. to Receive (Base)")
            {
            }
            field("Vendor Name"; "Vendor Name")
            {
            }
            field("Responsibility Center"; "Responsibility Center")
            {
            }
            field("DLC mini à réception"; "DLC mini à réception")
            {
            }
            field(Shelf; Shelf)
            {
            }
        }
    }

    var
        Items: Record Item;

    var
        Traca: Code[10];
        Shelf: Code[20];

    trigger OnAfterGetRecord()
    begin
        if Items.Get(Rec."No.") then
            Shelf := Items."Shelf No.";
    end;
}

