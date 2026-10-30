query 50010 Login_Extranet
{

    elements
    {
        dataitem(Contact; Contact)
        {
            DataItemTableFilter = Responsabilites = FILTER ('*EX*');
            column(No; "No.")
            {
            }
            column(Name; Name)
            {
            }
            column(E_Mail; "E-Mail")
            {
            }
            column(Responsabilites; Responsabilites)
            {
            }
            column(Password; Password)
            {
            }
            column(ChangePw; ChangePw)
            {
            }
            column(salt; salt)
            {
            }
            column(PwdValidityUntil; PwdValidityUntil)
            {
            }
            column(LastConnection; LastConnection)
            {
            }
            column(Company_No; "Company No.")
            {
            }
            dataitem(Contact_Business_Relation; "Contact Business Relation")
            {
                DataItemLink = "Contact No." = Contact."Company No.";
                DataItemTableFilter = "Business Relation Code" = CONST ('CLI');
                column(Client; "No.")
                {
                }
                column(Contact_Name; "Contact Name")
                {
                }
            }
        }
    }
}

