report 50015 Pointages
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/Pointages.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Pointages; Pointages)
        {
            RequestFilterFields = Badge, Dt;
            column(Badges; recP.Badge)
            {
            }
            column(Dt; recP.Dt)
            {
            }
            column(Start; TStart)
            {
            }
            column("End"; TEnd)
            {
            }
            column(Total; Total)
            {
            }
            column(Pause; Pause)
            {
            }
            column(TotalPause; "Total-Pause")
            {
            }
            column(msg; msg)
            {
            }

            trigger OnAfterGetRecord()
            begin
                msg := '';
                Pause := 0;
                Total := 0;
                "Total-Pause" := 0;
                recP.Reset;
                recP.SetRange(Badge, Badge);
                recP.SetRange(Dt, CreateDateTime(DT2Date(Dt), 0T), CreateDateTime(DT2Date(Dt), 235900T));
                recP.SetFilter(ID, '>%1', ID);
                if recP.FindFirst then begin
                    CurrReport.Skip;
                end
                else begin
                    recP.Reset;
                    recP.SetRange(Badge, Badge);
                    recP.SetRange(Dt, CreateDateTime(DT2Date(Dt), 0T), CreateDateTime(DT2Date(Dt), 235900T));
                    if recP.FindFirst then
                        TStart := DT2Time(recP.Dt);
                    if recP.FindLast then
                        TEnd := DT2Time(recP.Dt);
                    Total := TEnd - TStart;
                    startPause := 0T;
                    LastT := TStart;
                    if recP.FindSet then
                        repeat
                            if LastT <> DT2Time(recP.Dt) then begin
                                if (DT2Time(recP.Dt) > TStart) and (DT2Time(recP.Dt) < TEnd) and (startPause = 0T) then begin
                                    startPause := DT2Time(recP.Dt);
                                end
                                else
                                    if (DT2Time(recP.Dt) > TStart) and (DT2Time(recP.Dt) < TEnd) and (startPause > 0T) then begin
                                        Pause := Pause + (DT2Time(recP.Dt) - startPause);
                                        startPause := 0T;
                                    end;
                            end;
                            LastT := DT2Time(recP.Dt);
                        until recP.Next = 0;
                end;
                Total := Total / 3600000;
                Pause := Pause / 3600000;
                "Total-Pause" := Total - Pause;
                if (startPause <> 0T) then
                    msg := '!!!';
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        recP: Record Pointages;
        TStart: Time;
        TEnd: Time;
        Pause: Decimal;
        Total: Decimal;
        "Total-Pause": Decimal;
        startPause: Time;
        LastT: Time;
        msg: Text;
}

