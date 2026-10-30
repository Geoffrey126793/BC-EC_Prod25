pageextension 70309 pageextension70309 extends "Finished Prod. Order Lines"
{
    layout
    {
        modify("Starting Time")
        {
            Visible = false;
        }
        modify("Starting Date")
        {
            Visible = false;
        }
        modify("Ending Time")
        {
            Visible = false;
        }
        modify("Ending Date")
        {
            Visible = false;
        }

        modify("Production BOM Version Code")
        {
            visible = true;
        }

    }
}

