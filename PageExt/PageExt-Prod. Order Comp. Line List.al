pageextension 70152 pageextension70152 extends "Prod. Order Comp. Line List"
{
    layout
    {
        addafter("Item No.")
        {
            field("Item to produce"; "Item to produce")
            {
            }
        }
    }
}

