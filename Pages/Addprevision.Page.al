page 50047 "Add prevision"
{
    Caption = 'Add prevision';

    layout
    {
        area(content)
        {
            field(Client; Client)
            {
                Caption = 'Client';
                TableRelation = Customer;
            }
            field(Article; Article)
            {
                Caption = 'Article';
                TableRelation = Item WHERE(Blocked = CONST(false));
            }
        }
    }

    actions
    {
    }

    var
        Client: Code[10];
        Article: Code[20];

    [Scope('OnPrem')]
    procedure GetClient(): Code[10]
    begin
        exit(Client);
    end;

    [Scope('OnPrem')]
    procedure GetArticle(): Code[20]
    begin
        exit(Article);
    end;
}

