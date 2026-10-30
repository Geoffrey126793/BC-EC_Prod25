pageextension 70255 pageextension70255 extends "Sales Quotes"
{
    layout
    {
        modify("External Document No.")
        {
            Visible = false;
        }
        modify("Requested Delivery Date")
        {
            Visible = false;
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
    }
}

