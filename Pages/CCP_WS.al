page 50199 CCP_WS
{
    PageType = List;
    SourceTable = CCP;
    SourceTableView = sorting (Machine, dt) ORDER(descending);
    layout
    {
        area(Content)
        {
            repeater(repeater1)
            {
                field(ID; ID)
                {
                }
                field(Dt; Dt)
                {
                }
                field(Machine; Machine)
                {
                }
                field(User; User)
                {
                }
                field(CCP; CCP)
                {
                }
                field(Valeur; Valeur)
                {
                }
            }
        }
    }


}