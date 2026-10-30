table 50048 Waste
{
    fields
    {
        field(1; ID; Code[50])
        {
        }
        field(2; Dt; DateTime)
        {
        }
        field(3; Machine; Code[50])
        {
        }
        field(4; User; Code[20])
        {
        }
        field(5; Emplacement; Text[50])
        {
        }
        field(6; Quantite; Decimal)
        {
        }

    }

    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
        Key(Dt; Dt)
        {

        }

    }


    trigger OnInsert()
    begin
        if (ID = '') then
            ID := CreateGuid();
    end;



}