pageextension 70062 pageextension70062 extends "CODA Statement Lines"
{
    layout
    {
        addafter("Bank Reference No.")
        {
            field("Name Other Party"; "Name Other Party")
            {
            }
            field("Applies-to ID"; "Applies-to ID")
            {
            }
            field(Type; Type)
            {
            }
        }
    }
    actions
    {

        addfirst(processing)
        {
            action(Lettrer)
            {
                Caption = 'Lettrer';
                trigger OnAction()
                begin
                    Apply();
                end;
            }
        }
    }
}

