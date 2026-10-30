pageextension 70130 pageextension70130 extends "Salesperson/Purchaser Card"
{
    layout
    {
        addafter("Phone No.")
        {
            field("Fax No."; "Fax No.")
            {
            }
            field("GSM number"; "GSM number")
            {
            }
        }
        addafter("E-Mail")
        {
            field(Address; Address)
            {
            }
            field(Address2; Address2)
            {
            }
            field(City; City)
            {
            }
        }
        addafter("Next Task Date")
        {
            field(User; User)
            {
            }
        }
    }

}

