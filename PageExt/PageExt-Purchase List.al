pageextension 70149 pageextension70149 extends "Purchase List"
{
    layout
    {
        addafter("Assigned User ID")
        {
            field("Responsibility Center"; "Responsibility Center")
            {
            }
            field(User; User)
            {
            }
            field("Status Visa"; "Status Visa")
            {
            }
        }
    }
}

