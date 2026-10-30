pageextension 70167 pageextension70167 extends "Get Receipt Lines"
{

    //Unsupported feature: Property Insertion (SourceTableView) on ""Get Receipt Lines"(Page 5709)".

    layout
    {
        modify("Document No.")
        {
            Width = 15;
        }
        modify(Description)
        {
            Width = 40;
        }
        addafter("Prod. Order No.")
        {
            field("Posting Date"; "Posting Date")
            {
            }
        }
        addafter("Quantity Invoiced")
        {
            field("Transport Customer No"; "Transport Customer No")
            {
            }
            field(Name; Name)
            {
            }
            field("Facture vente"; "Facture vente")
            {
            }
            field("Ville livraison"; "Ville livraison")
            {
            }
        }
        addafter("Qty. Rcd. Not Invoiced")
        {
            field("Order No."; "Order No.")
            {
                Width = 15;
            }
            field(Container; Container)
            {
            }
            field("Transport Sales Order No"; "Transport Sales Order No")
            {
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Document No.", "Line No.");
        Rec.SetAscending("Document No.", false);
    end;

}

