tableextension 50066 ShiToAddressEC extends "Ship-to Address"
{
    fields
    {
        field(50006; "Territory Code"; Code[10])
        {
            Caption = 'Territory Code';
            Description = 'LOG-004';
            TableRelation = Territory;
        }
        field(50007; "Horaire livraison"; Text[80])
        {
            Caption = 'Horaire livraison';
        }
        field(50008; "Délai de livraison"; Text[80])
        {
            Caption = 'Délai de livraison';
        }
        field(50009; "Commentaire CMR"; Text[80])
        {
            Caption = 'Commentaire CMR';
        }
        field(50010; "GLN EC"; Text[15])
        {
            Caption = 'GLN';
        }
        field(50011; "ID Contraload"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50012; "Primary Contact No."; Code[20])
        {
            Caption = 'Primary Contact No.';
            DataClassification = ToBeClassified;
            TableRelation = Contact;

            trigger OnLookup()
            var
                Cont: Record Contact;
                ContBusRel: Record "Contact Business Relation";
                TempCust: Record Customer temporary;
            begin
                ContBusRel.SetCurrentKey("Link to Table", "No.");
                ContBusRel.SetRange("Link to Table", ContBusRel."Link to Table"::Customer);
                ContBusRel.SetRange("No.", "Customer No.");
                if ContBusRel.FindFirst then begin
                    Cont.FilterGroup(2);
                    Cont.SetRange("Company No.", ContBusRel."Contact No.");
                end else
                    Cont.SetRange("No.", '');

                if "Primary Contact No." <> '' then
                    if Cont.Get("Primary Contact No.") then;

                if PAGE.RunModal(0, Cont) = ACTION::LookupOK then begin
                    Validate("Primary Contact No.", Cont."No.");
                end;
            end;

            trigger OnValidate()
            var
                Cont: Record Contact;
                ContBusRel: Record "Contact Business Relation";
            begin
            end;
        }
        field(50013; "GLN UC"; Text[15])
        {
            DataClassification = ToBeClassified;
        }
    }

}

