pageextension 70087 pageextension70087 extends "Vendor Ledger Entries"
{
    layout
    {
        modify("Document No.")
        {
            Width = 15;
        }
        modify("External Document No.")
        {
            Width = 20;
        }
        modify(Description)
        {
            Width = 40;
        }


        addafter("Reversed Entry No.")
        {
            field(Commentaires; Commentaires)
            {

                trigger OnLookup(var Text: Text): Boolean
                var
                    PurchComment: Record "Purch. Comment Line";
                begin
                    PurchComment.Reset;
                    PurchComment.SetRange("No.", "Document No.");
                    PurchComment.SetRange("Document Line No.", 0);
                    if PurchComment.FindFirst then
                        PAGE.Run(68, PurchComment);
                end;
            }
        }
        addafter("Exported to Payment File")
        {
            field(NbreDocs; NbreDocs)
            {
                Caption = 'Nbre documents';

                trigger OnDrillDown()
                var
                    Docs: Record "Document Attachment";
                begin
                end;

                trigger OnLookup(var Text: Text): Boolean
                var
                    Docs: Record "Document Attachment";
                begin
                    Docs.Reset;
                    Docs.SetRange("No.", Rec."Document No.");
                    Docs.SetRange("Table ID", -1);
                    if Rec."Document Type" = Rec."Document Type"::Invoice then
                        Docs.SetRange("Table ID", 122);
                    if Rec."Document Type" = Rec."Document Type"::"Credit Memo" then
                        Docs.SetRange("Table ID", 124);
                    if Docs.Count > 0 then
                        PAGE.Run(1173, Docs);
                end;
            }
        }
    }

    var
        Docs: Record "Document Attachment";

    var
        NbreDocs: Integer;



    trigger OnAfterGetRecord()
    begin

        NbreDocs := 0;
        Docs.Reset;
        Docs.SetRange("No.", Rec."Document No.");
        Docs.SetRange("Table ID", -1);
        if Rec."Document Type" = Rec."Document Type"::Invoice then
            Docs.SetRange("Table ID", 122);
        if Rec."Document Type" = Rec."Document Type"::"Credit Memo" then
            Docs.SetRange("Table ID", 124);

        NbreDocs := Docs.Count;
    end;
}

