pageextension 70031 pageextension70031 extends "Posted Purch. Invoice Subform"
{
    actions
    {
        addafter(DocumentLineTracking)
        {
            action("Ecritures valeurs")
            {

                trigger OnAction()
                var
                    ValueEntry: Record "Value Entry";
                begin
                    ValueEntry.Reset;
                    ValueEntry.SetRange("Document No.", "Document No.");
                    //IF ValueEntry.FINDFIRST THEN
                    PAGE.Run(0, ValueEntry);
                end;
            }
        }
    }
}

