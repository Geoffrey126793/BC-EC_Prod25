pageextension 70033 pageextension70033 extends "Salespersons/Purchasers"
{
    layout
    {
        addafter(Name)
        {
            field("GSM number"; "GSM number")
            {
            }
            field("E-Mail"; "E-Mail")
            {
            }
        }
        addafter("Phone No.")
        {
            field(User; User)
            {
            }
        }
    }
    actions
    {

    }
}

