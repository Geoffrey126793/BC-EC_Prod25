codeunit 50021 "Periodic Update"
{

    trigger OnRun()
    begin
        UpdateStade();
    end;

    var
        Cust: Record Customer;
        CustLedg: Record "Cust. Ledger Entry";
        CustLedg2: Record "Cust. Ledger Entry";

    [Scope('OnPrem')]
    procedure UpdateDelaiReglement()
    var
        NbreInv: Integer;
        NbreJ: Integer;
    begin
        //Formules issues de Form 302
        Cust.Reset;
        if Cust.FindSet then
            repeat
                CustLedg.Reset;
                CustLedg.SetRange("Customer No.", Cust."No.");
                CustLedg.SetRange("Posting Date", CalcDate('<-2Y+CY+1D>', Today), CalcDate('<-1Y+CY>', Today));
                CustLedg.SetRange("Document Type", CustLedg."Document Type"::Invoice);
                CustLedg.SetRange(Open, false);
                NbreInv := 0;
                NbreJ := 0;
                if CustLedg.FindSet then
                    repeat
                        NbreInv := NbreInv + 1;
                        if CustLedg."Closed at Date" > CustLedg."Posting Date" then begin
                            NbreJ := NbreJ + (CustLedg."Closed at Date" - CustLedg."Posting Date");
                        end
                        else begin
                            if CustLedg."Closed by Entry No." > 0 then begin
                                if CustLedg2.Get(CustLedg."Closed by Entry No.") then
                                    NbreJ := NbreJ + (CustLedg2."Posting Date" - CustLedg."Posting Date");
                            end
                            else begin
                                CustLedg2.SetCurrentKey("Closed by Entry No.");
                                CustLedg2.SetRange("Closed by Entry No.", CustLedg."Entry No.");
                                if CustLedg2.FindLast then
                                    NbreJ := NbreJ + (CustLedg2."Posting Date" - CustLedg."Posting Date");
                            end;
                        end;
                    until CustLedg.Next = 0;
                if NbreInv > 0 then
                    Cust."Délai régl. moyen (jours) N -1" := Round(NbreJ / NbreInv, 1, '>')
                else
                    Cust."Délai régl. moyen (jours) N -1" := 0;
                CustLedg.Reset;
                CustLedg.SetRange("Customer No.", Cust."No.");
                CustLedg.SetRange("Posting Date", CalcDate('<-1Y+CY+1D>', Today), CalcDate('<CY>', Today));
                CustLedg.SetRange("Document Type", CustLedg."Document Type"::Invoice);
                CustLedg.SetRange(Open, false);
                NbreInv := 0;
                NbreJ := 0;
                if CustLedg.FindSet then
                    repeat
                        NbreInv := NbreInv + 1;
                        if CustLedg."Closed at Date" > CustLedg."Posting Date" then begin
                            NbreJ := NbreJ + (CustLedg."Closed at Date" - CustLedg."Posting Date");
                        end
                        else begin
                            if CustLedg."Closed by Entry No." > 0 then begin
                                if CustLedg2.Get(CustLedg."Closed by Entry No.") then
                                    NbreJ := NbreJ + (CustLedg2."Posting Date" - CustLedg."Posting Date");
                            end
                            else begin
                                CustLedg2.SetCurrentKey("Closed by Entry No.");
                                CustLedg2.SetRange("Closed by Entry No.", CustLedg."Entry No.");
                                if CustLedg2.FindLast then
                                    NbreJ := NbreJ + (CustLedg2."Posting Date" - CustLedg."Posting Date");
                            end;
                        end;
                    until CustLedg.Next = 0;
                if NbreInv > 0 then
                    Cust."Délai régl. moyen (jours) N" := Round(NbreJ / NbreInv, 1, '>')
                else
                    Cust."Délai régl. moyen (jours) N" := 0;

                Cust.Modify;
            until Cust.Next = 0;
    end;

    [Scope('OnPrem')]
    procedure UpdateStade()
    var
        remindLvl: Record "Reminder Level";
        NextRemind: Date;
    begin
        Cust.Reset;
        Cust.SetRange("Stade manuel", false);

        if Cust.FindSet then
            repeat
                Cust."Stade rappel calculé" := 0;
                Cust.CalcFields("Balance (LCY)");
                if Cust."Balance (LCY)" > 0 then begin
                    CustLedg.SetCurrentKey("Customer No.", Open, Positive, "Due Date", "Currency Code");
                    CustLedg.SetRange("Customer No.", Cust."No.");
                    CustLedg.SetRange(Open, true);
                    CustLedg.SetRange(Positive, true);
                    if CustLedg.FindFirst then begin
                        NextRemind := CustLedg."Due Date";
                        remindLvl.Reset;
                        remindLvl.SetRange("Reminder Terms Code", Cust."Reminder Terms Code");
                        if remindLvl.FindSet then
                            repeat
                                NextRemind := CalcDate(remindLvl."Grace Period", NextRemind);
                                if NextRemind < Today then
                                    Cust."Stade rappel calculé" := remindLvl."No.";
                            until remindLvl.Next = 0;
                    end;
                end;
                Cust.Modify;
            until Cust.Next = 0;
    end;
}

