page 50020 Pointages
{
    PageType = List;
    SourceTable = Pointages;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Badge; Badge)
                {
                }
                field(Dt; Dt)
                {
                }
                field(Emplacement; Emplacement)
                {
                }
                field(User; User)
                {
                }
                field(Duree; duree)
                {
                }
                field("Atelier"; Atelier)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        duree := 0;
        dureeT := 0T;
        recP.Reset;
        recP.SetRange(Badge, Badge);
        recP.SetFilter(Dt, '>%1', CreateDateTime(DT2Date(Dt), 0T));
        if recP.FindFirst then
            if DT2Date(Dt) = DT2Date(recP.Dt) then begin
                duree := (Dt - recP.Dt) / 3600000;
                //dureeT := dureeT + duree;
            end;
    end;

    var
        duree: Decimal;
        dureeT: Time;
        recP: Record Pointages;
}

