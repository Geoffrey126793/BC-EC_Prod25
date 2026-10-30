tableextension 50010 CustomerPricGroupEC extends "Customer Price Group"
{
    fields
    {
        field(50001; "Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
    }

}

