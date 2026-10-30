pageextension 70288 pageextension70288 extends "Prod. BOM Version List"
{

    trigger OnOpenPage()
    begin
        SetFilter(Status, '<>%1', Rec.Status::Closed);
    end;
}

