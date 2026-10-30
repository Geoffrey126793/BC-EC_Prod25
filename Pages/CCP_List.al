page 50198 CCP_List
{
    PageType = List;
    Caption = 'Listing des CCP';
    SourceTable = CCP;
    UsageCategory = ReportsAndAnalysis;
    Editable = false;
    SourceTableView = sorting (dt) ORDER(descending);

    layout
    {
        area(Content)
        {
            repeater(repeater1)
            {
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
                field(UserName; UserName)
                {

                }
            }
        }
    }


}