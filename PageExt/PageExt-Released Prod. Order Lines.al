pageextension 70303 pageextension70303 extends "Released Prod. Order Lines"
{
    layout
    {
        modify("Routing Version Code")
        {
            Visible = false;
        }
        modify("Starting Date-Time")
        {
            Editable = false;
        }
        modify("Starting Time")
        {
            Visible = false;
        }
        modify("Starting Date")
        {
            Visible = false;
        }
        modify("Ending Date-Time")
        {
            Editable = false;
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
            Visible = true;
        }

        addafter("Remaining Quantity")
        {
            field("Nombre de palettes"; "Nombre de palettes")
            {
            }
        }
    }
    actions
    {
        moveafter("Order &Tracking"; ProductionJournal)

    }

}

