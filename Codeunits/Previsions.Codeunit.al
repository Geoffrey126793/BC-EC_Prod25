codeunit 50037 Previsions
{

    trigger OnRun()
    begin
        CreatePrevisionsFrom(20210731D);
    end;

    var
        Stats: Record "Statistic aggregate";
        StatisticAggregate1: Record "Statistic aggregate";
        iCount: Integer;
        iC: Integer;
        dlg: Dialog;
        NextEntry: Integer;
        Cust: Record Customer;

    [Scope('OnPrem')]
    procedure CreatePrevisionsFrom(Dt: Date)
    var
        last: Text[80];
    begin
        last := '';
        Stats.Reset;
        if Stats.FindLast then
            NextEntry := Stats."Entry No." + 1;
        dlg.Open('@1@@@@@@@@@@@@@@@@@@@@@@');
        Stats.Reset;
        Stats.SetCurrentKey("Source No.", "No.");
        Stats.SetRange("Period Length", Stats."Period Length"::Month);
        Stats.SetRange("Entry Type", 'Vente');
        Stats.SetRange(Type, Stats.Type::Item);
        Stats.SetRange("Ending Date", Dt);
        iCount := Stats.Count;
        iC := 1;
        if Stats.FindSet then
            repeat
                StatisticAggregate1.Reset;
                StatisticAggregate1.SetRange("Ending Date", CalcDate('<+1Y+CM>', Dt));
                StatisticAggregate1.SetRange("Source No.", Stats."Source No.");
                StatisticAggregate1.SetRange("No.", Stats."No.");
                StatisticAggregate1.SetRange("Entry Type", 'Previsions');
                if StatisticAggregate1.FindFirst then begin
                    if not StatisticAggregate1."Free boolean 1" then begin
                        if last <> Stats."Source No." + Stats."No." then
                            StatisticAggregate1.Quantity := Stats.Quantity
                        else
                            StatisticAggregate1.Quantity := StatisticAggregate1.Quantity + Stats.Quantity;
                    end;
                    StatisticAggregate1.Modify;
                end
                else begin
                    StatisticAggregate1.Reset;
                    StatisticAggregate1.Init;
                    StatisticAggregate1.TransferFields(Stats, false);
                    StatisticAggregate1."Customer criteria 5" := Cust."Criteria 5";
                    StatisticAggregate1."Free field 3" := Cust."Salesperson Code";
                    StatisticAggregate1."Entry No." := NextEntry;
                    StatisticAggregate1."Entry Type" := 'Previsions';
                    StatisticAggregate1."Period Length" := StatisticAggregate1."Period Length"::Month;
                    StatisticAggregate1."Ending Date" := CalcDate('<+1Y+CM>', Dt);
                    StatisticAggregate1.Quantity := Stats.Quantity;
                    StatisticAggregate1."Free boolean 1" := false;
                    StatisticAggregate1."Location Code" := '';
                    StatisticAggregate1.Insert;
                    NextEntry := NextEntry + 1;
                end;
                last := Stats."Source No." + Stats."No.";
                iC := iC + 1;
                dlg.Update(1, Round(iC / iCount * 10000, 1));
            until Stats.Next = 0;
        dlg.Close;
    end;

    [Scope('OnPrem')]
    procedure Add(Date: Date; Client: Code[10]; Article: Code[20]; Qty: Decimal)
    begin
        StatisticAggregate1.Reset;
        StatisticAggregate1.SetRange("Ending Date", Date);
        StatisticAggregate1.SetRange("Source No.", Client);
        StatisticAggregate1.SetRange("No.", Article);
        StatisticAggregate1.SetRange("Entry Type", 'Previsions');
        if StatisticAggregate1.FindFirst then
            Error('Cette prévision existe déjà');
        Stats.Reset;
        if Stats.FindLast then
            NextEntry := Stats."Entry No." + 1;
        StatisticAggregate1.Reset;
        StatisticAggregate1.Init;
        StatisticAggregate1."Entry No." := NextEntry;
        StatisticAggregate1."Entry Type" := 'Previsions';
        StatisticAggregate1."Period Length" := StatisticAggregate1."Period Length"::Month;
        StatisticAggregate1."Ending Date" := Date;
        StatisticAggregate1.Quantity := Qty;
        StatisticAggregate1."Free boolean 1" := false;
        StatisticAggregate1.Type := StatisticAggregate1.Type::Item;
        StatisticAggregate1."No." := Article;
        StatisticAggregate1."Source Type" := StatisticAggregate1."Source Type"::Customer;
        StatisticAggregate1."Source No." := Client;
        Cust.Get(Client);
        StatisticAggregate1."Customer criteria 5" := Cust."Criteria 5";
        StatisticAggregate1."Free field 3" := Cust."Salesperson Code";
        StatisticAggregate1."Free field 4" := Cust."Salesperson Code";
        StatisticAggregate1."Salespers./Purch. Code" := Cust."Salesperson Code";
        StatisticAggregate1."Location Code" := '';
        StatisticAggregate1."Free boolean 1" := (Qty > 0);
        StatisticAggregate1.Insert;
    end;

    [Scope('OnPrem')]
    procedure Modify(Date: Date; Client: Code[10]; Article: Code[20]; Qty: Decimal)
    begin

        StatisticAggregate1.Reset;
        StatisticAggregate1.SetRange("Ending Date", Date);
        StatisticAggregate1.SetRange("Source No.", Client);
        StatisticAggregate1.SetRange("No.", Article);
        StatisticAggregate1.SetRange("Entry Type", 'Previsions');
        if StatisticAggregate1.FindFirst then begin
            StatisticAggregate1.Quantity := Qty;
            StatisticAggregate1."Free boolean 1" := true;
            StatisticAggregate1.Modify;
        end
        else begin
            Add(Date, Client, Article, Qty);
        end;
    end;
}

