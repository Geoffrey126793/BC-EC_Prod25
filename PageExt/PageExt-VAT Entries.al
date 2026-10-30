pageextension 70092 pageextension70092 extends "VAT Entries"
{
    layout
    {
        addafter("Reversed Entry No.")
        {
            field(Nom; Nom)
            {
                Caption = 'Nom donneur / preneur d''ordre';
            }
        }
    }

    var
        Nom: Text[80];
        Fourn: Record Vendor;
        Client: Record Customer;
        AB6Tool: Codeunit "Absys - tools PJ";


    trigger OnAfterGetRecord()
    begin
        if Type = Type::Purchase then
            if Fourn.Get("Bill-to/Pay-to No.") then
                Nom := Fourn.Name;
        if Type = Type::Sale then
            if Client.Get("Bill-to/Pay-to No.") then
                Nom := Client.Name;
    end;
}

