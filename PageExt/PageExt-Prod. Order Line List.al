pageextension 70151 pageextension70151 extends "Prod. Order Line List"
{
    layout
    {
        modify("Starting Time")
        {
            Visible = false;
        }
        modify("Ending Time")
        {
            Visible = false;
        }
        modify("Starting Date")
        {
            Visible = true;
        }
        modify("Ending Date")
        {
            Visible = true;
        }
        modify("Starting Date-Time")
        {
            Visible = false;
        }
        modify("Ending Date-Time")
        {
            Visible = false;
        }
    }
}

