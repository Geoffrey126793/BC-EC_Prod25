table 50049 CCP
{
    DataClassification = ToBeClassified;

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
        field(5; CCP; Text[100])
        {
        }
        field(6; Valeur; Integer)
        {
        }
        field(7; UserName; Code[250])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."Search Name" where("No." = field(User)));
            Editable = false;
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
        Key(MachineDt; Machine, Dt)
        {

        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin
        if (ID = '') then
            ID := CreateGuid();
    end;



}