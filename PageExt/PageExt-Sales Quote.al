pageextension 70105 pageextension70105 extends "Sales Quote"
{
    layout
    {
        modify("Sell-to Contact No.")
        {
            Importance = Standard;
        }
        modify("Sell-to Contact")
        {
            Importance = Promoted;
        }
        modify("Quote Valid Until Date")
        {
            Importance = Promoted;
        }
        modify("Your Reference")
        {
            Importance = Standard;
        }
        modify("Salesperson Code")
        {
            Importance = Standard;
            Editable = "Sell-to Customer No." = '';
        }
        modify("External Document No.")
        {
            Visible = false;
        }
        modify("Order Date")
        {
            Visible = false;
        }
        modify("Requested Delivery Date")
        {
            Visible = false;
        }
        modify("Campaign No.")
        {
            Visible = false;
        }
        modify("Opportunity No.")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify(Status)
        {
            Visible = false;
        }
        modify("Work Description")
        {
            Visible = false;
        }
        modify(WorkDescription)
        {
            Visible = false;
        }
        modify(Control1906127307)
        {
            Visible = false;
        }
        modify(Control1901314507)
        {
            Visible = false;
        }
        addafter("Due Date")
        {
            field("Price Valid from"; "Price Valid from")
            {
            }
            field("Price Valid to"; "Price Valid to")
            {
            }
        }
        addafter("Salesperson Code")
        {
            field("Employee BackOffice"; "Employee BackOffice")
            {
                Editable = "Sell-to Customer No." = '';
            }
        }
        addafter("Area")
        {
            field("VAT Registration No."; "VAT Registration No.")
            {
            }
        }
    }
}

