pageextension 70267 pageextension70267 extends "Sales Quote Subform"
{
    layout
    {
        modify("Substitution Available")
        {
            Visible = false;
        }
        modify(Nonstock)
        {
            Visible = false;
        }
        modify("Unit Cost (LCY)")
        {
            Visible = false;
        }
        modify(PriceExists)
        {
            Visible = false;
        }
        modify(LineDiscExists)
        {
            Visible = false;
        }
        modify("Line Discount Amount")
        {
            Visible = false;
        }
        modify("Allow Invoice Disc.")
        {
            Visible = false;
        }
        modify("Allow Item Charge Assignment")
        {
            Visible = false;
        }
        modify("Qty. to Assign")
        {
            Visible = false;
        }
        modify("Qty. Assigned")
        {
            Visible = false;
        }
        modify("Shipping Agent Code")
        {
            Visible = false;
        }
        modify("Shipping Agent Service Code")
        {
            Visible = false;
        }
        modify("Work Type Code")
        {
            Visible = false;
        }
        modify("Appl.-to Item Entry")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 1 Code")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = false;
        }
        modify(Control53)
        {
            Visible = false;
        }
        modify(Control49)
        {
            Visible = false;
        }
        modify("Subtotal Excl. VAT")
        {
            Visible = false;
        }
        modify("Invoice Discount Amount")
        {
            Visible = false;
        }
        modify("Invoice Disc. Pct.")
        {
            Visible = false;
        }
        modify(Control35)
        {
            Visible = false;
        }
        modify("Total Amount Excl. VAT")
        {
            Visible = false;
        }
        modify("Total VAT Amount")
        {
            Visible = false;
        }
        modify("Total Amount Incl. VAT")
        {
            Visible = false;
        }
        addafter("Unit of Measure")
        {
            field("Minimum de commande"; "Minimum de commande")
            {
            }
            field("Prix unitaire départ"; "Prix unitaire départ")
            {
            }
            field("Transport Unit Price"; "Transport Unit Price")
            {
            }
        }
        addafter("Unit Price")
        {
            field("Poids par palette"; "Poids par palette")
            {
            }
        }
    }
}

