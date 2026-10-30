pageextension 70150 pageextension70150 extends "Purchase Order Subform"
{
    layout
    {

        modify("Quantity")
        {
            trigger OnAfterValidate()
            begin
                Demandé := Quantity;
                //Rec.Modify(false);
            end;

        }

        addafter("Item Reference No.")
        {
            field("Vendor Item No."; "Vendor Item No.")
            {
            }
        }
        addafter("Direct Unit Cost")
        {
            field("Frais annexes estimatifs unit"; "Frais annexes estimatifs unit")
            {
            }
            field("Currency Code"; "Currency Code")
            {
            }
        }
        addafter("Job Task No.")
        {
            field("Responsibility Center"; "Responsibility Center")
            {
            }
        }
        addafter(ShortcutDimCode7)
        {
            field("Transport Customer Name"; "Transport Customer Name")
            {
            }
            field("Transport Comment"; "Transport Comment")
            {
            }
            field("Transport Sales Invoice No"; "Transport Sales Invoice No")
            {
            }

            field("DLC mini à réception"; "DLC mini à réception")
            {
            }
            field("Cases Quantity per Pallet"; "Cases Quantity per Pallet")
            {
            }
        }
    }
}

