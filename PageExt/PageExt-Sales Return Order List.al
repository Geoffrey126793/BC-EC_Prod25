pageextension 70259 pageextension70259 extends "Sales Return Order List"
{
    layout
    {


        modify(Status)
        {
            Visible = false;
        }
        addafter("Amount Including VAT")
        {
            field("Last Return Receipt No."; "Last Return Receipt No.")
            {
            }
        }
    }
}

