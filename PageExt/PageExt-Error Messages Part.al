pageextension 70076 pageextension70076 extends "Error Messages Part"
{
    layout
    {
        modify("Description")
        {
            Visible = false;
        }

        addafter(Description)
        {
            field("Description2"; "Message")
            {
                MultiLine = true;
                Caption = 'Description';
            }
        }
    }


}