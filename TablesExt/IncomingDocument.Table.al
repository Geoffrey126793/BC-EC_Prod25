tableextension 50015 IncomingDocumentEC extends "Incoming Document"
{
    fields
    {
        field(50001; Statut; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = ,"Ok Validé","En cours de validation","Pas d'annexe",Probleme;
        }
        field(50002; "Vendor Resp Center"; Code[20])
        {
            CalcFormula = Lookup(Vendor."Responsibility Center" WHERE("No." = FIELD("Vendor No.")));
            FieldClass = FlowField;
        }
    }

}

