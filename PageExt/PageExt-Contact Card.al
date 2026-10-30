pageextension 70123 pageextension70123 extends "Contact Card"
{
    trigger OnClosePage()
    var
        Contact: Record Contact;
    begin
        Contact.TouchContact("No.");
    end;
}

