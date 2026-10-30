pageextension 70094 pageextension70094 extends "Customer Lookup"
{
    layout
    {


    }
    var
        AB6Tools: Codeunit "Absys - tools PJ";
        UserMgt: Codeunit "User Setup Management";


    trigger OnOpenPage()
    begin
        if not (AB6Tools.GetRole('SALES-CUST2') or (AB6Tools.GetRole('COMMERCIAUX'))) then
            Error('Désactivé');
        if UserMgt.GetRespCenter(0, '') <> '' then begin
            FilterGroup(2);
            SetFilter("Salesperson Code", UserMgt.GetRespCenter(0, ''));
            FilterGroup(0);
        end;
    end;
}

