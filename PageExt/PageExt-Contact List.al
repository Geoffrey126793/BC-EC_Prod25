pageextension 70124 pageextension70124 extends "Contact List"
{
    layout
    {
        addafter("Language Code")
        {
            field(Responsabilites; Responsabilites)
            {
            }
            field("First Name"; "First Name")
            {
            }
            field(Address; Address)
            {
            }
            field(City; City)
            {
            }
        }
    }
    actions
    {
        addafter(NewSalesQuote)
        {
            action("Créer contact lié")
            {
                Caption = 'Créer contact lié';
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Cont: Record Contact;
                begin
                    Cont.Reset;
                    Cont.Init;
                    Cont."No." := '';
                    Cont.Validate(Type, Cont.Type::Person);
                    Cont.Validate("Company No.", GetFilter("Company No."));
                    Cont.Insert(true);
                    PAGE.Run(5050, Cont);
                end;
            }
        }
    }



}

