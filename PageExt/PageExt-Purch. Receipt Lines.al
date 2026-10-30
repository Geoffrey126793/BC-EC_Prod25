pageextension 70182 pageextension70182 extends "Purch. Receipt Lines"
{

    trigger OnOpenPage()
    begin
        SetCurrentKey("Document No.", "Line No.");
        Ascending(FALSE);
        if FindFirst then;
    end;
}

