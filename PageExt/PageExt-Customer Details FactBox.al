pageextension 70249 pageextension70249 extends "Customer Details FactBox"
{
    layout
    {
        addafter(Contact)
        {
            field(Contacts; NbContacts)
            {

                trigger OnDrillDown()
                begin
                    ShowContact();
                end;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    ShowContact();
                end;
            }
        }
    }

    var
        ContBusRel: Record "Contact Business Relation";
        Cont: Record Contact;

    var
        NbContacts: Integer;


    trigger OnAfterGetRecord()
    begin
        NbContacts := 0;
        ContBusRel.SetCurrentKey("Link to Table", "No.");
        ContBusRel.SetRange("Link to Table", ContBusRel."Link to Table"::Customer);
        ContBusRel.SetRange("No.", "No.");
        if ContBusRel.Find('-') then begin
            Cont.SetCurrentKey("Company Name", "Company No.", Type, Name);
            Cont.SetRange("Company No.", ContBusRel."Contact No.");
            NbContacts := Cont.Count;
        end;
    end;
}

