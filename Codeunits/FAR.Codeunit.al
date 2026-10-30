codeunit 50019 FAR
{

    trigger OnRun()
    begin
        //GenerateFARList(311219D);
        FARToGL(20191231D);
    end;

    var
        ReceiptL: Record "Purch. Rcpt. Line";
        FARL: Record FAR;
        dlg: Dialog;
        iC: Integer;
        iCount: Integer;

    [Scope('OnPrem')]
    procedure GenerateFARList(EndDt: Date)
    begin

        ReceiptL.SetFilter("Posting Date", '%1..%2', 20190901D, EndDt);
        ReceiptL.SetFilter("Buy-from Vendor No.", '<>F00257');

        dlg.Open('@1@@@@@@@@@@@@@@@@@@@@@@');
        iC := 1;
        iCount := ReceiptL.Count;
        if ReceiptL.FindSet then
            repeat
                if FARL.Get(ReceiptL."Document No.", ReceiptL."Line No.") then begin
                    if FARL."Status facture" = FARL."Status facture"::"A recevoir" then begin
                        if ReceiptL."Qty. Invoiced (Base)" <> ReceiptL."Quantity (Base)" then begin
                            FARL.TransferFields(ReceiptL, false);
                            FARL."Status facture" := FARL."Status facture"::"A recevoir";
                            FARL."Total FAR" := (ReceiptL."Quantity (Base)" - ReceiptL."Qty. Invoiced (Base)") * ReceiptL."Unit Cost (LCY)";
                            FARL.Modify;
                        end
                        else begin
                            FARL."Status facture" := FARL."Status facture"::"Reçue";
                            FARL."Total FAR" := 0;
                            FARL.Modify;
                        end;
                    end;
                end
                else begin
                    if ReceiptL."Qty. Invoiced (Base)" <> ReceiptL."Quantity (Base)" then begin
                        FARL.Init;
                        FARL.TransferFields(ReceiptL, true);
                        FARL."Status facture" := FARL."Status facture"::"A recevoir";
                        FARL."Total FAR" := (ReceiptL."Quantity (Base)" - ReceiptL."Qty. Invoiced (Base)") * ReceiptL."Unit Cost (LCY)";
                        FARL.Insert;
                    end;
                end;
                iC += 1;
                dlg.Update(1, Round(iC / iCount * 10000, 1));
            until ReceiptL.Next = 0;
        dlg.Close;
    end;

    [Scope('OnPrem')]
    procedure FARToGL(EndDt: Date)
    var
        GLJnl: Record "Gen. Journal Line";
        GLJnl2: Record "Gen. Journal Line";
        n: Integer;
        GLSetup: Record "General Posting Setup";
        AccountNo: Code[10];
    begin
        FARL.Reset;
        FARL.SetRange("Status facture", FARL."Status facture"::"A recevoir");

        n := 10000;

        dlg.Open('@1@@@@@@@@@@@@@@@@@@@@@@');
        iC := 1;
        iCount := FARL.Count;
        if FARL.FindSet then
            repeat
                AccountNo := '';
                if (FARL.Type = FARL.Type::Item) or (FARL.Type = FARL.Type::"Charge (Item)") then begin
                    GLSetup.Get(FARL."Gen. Bus. Posting Group", FARL."Gen. Prod. Posting Group");
                    AccountNo := GLSetup."Purch. Account";
                end;
                if FARL.Type = FARL.Type::"G/L Account" then begin
                    AccountNo := FARL."No.";
                end;

                GLJnl.Reset;
                GLJnl.SetRange("Journal Template Name", 'G-FAR');
                GLJnl.SetRange("Journal Batch Name", 'FAR');
                GLJnl.SetRange("Account No.", GLSetup."Purch. Account");
                if GLJnl.FindFirst then begin
                    GLJnl.Validate(Amount, GLJnl.Amount + FARL."Total FAR");
                    GLJnl.Modify;
                end
                else begin
                    GLJnl."Journal Template Name" := 'G-FAR';
                    GLJnl."Journal Batch Name" := 'FAR';
                    GLJnl."Line No." := n;
                    GLJnl."Posting Date" := EndDt;
                    GLJnl."Account Type" := GLJnl."Account Type"::"G/L Account";
                    GLJnl."Document No." := 'FAR' + Format(EndDt);
                    GLJnl.Description := 'FAR' + Format(EndDt);
                    GLJnl.Validate("Account No.", AccountNo);
                    if (AccountNo = '') then
                        Error('Pas de compte : %1  %2', FARL."Document No.", FARL."Line No.");

                    GLJnl."Bal. Account Type" := GLJnl."Bal. Account Type"::"G/L Account";
                    GLJnl.Validate("Bal. Account No.", '444012');
                    GLJnl.Validate(Amount, FARL."Total FAR");
                    GLJnl.Validate("Shortcut Dimension 1 Code", '999999');
                    GLJnl.Insert;
                    n += 10000;
                end;
                iC += 1;
                dlg.Update(1, Round(iC / iCount * 10000, 1));
            until FARL.Next = 0;
        dlg.Close;

        GLJnl.Reset;
        GLJnl.SetRange("Journal Template Name", 'G-FAR');
        GLJnl.SetRange("Journal Batch Name", 'FAR');
        GLJnl.SetRange("Posting Date", EndDt);
        if GLJnl.FindSet then
            repeat
                GLJnl2.Init;
                GLJnl2.TransferFields(GLJnl, true);
                GLJnl2."Line No." := GLJnl."Line No." + 1;
                GLJnl2.Validate("Posting Date", CalcDate('<+1D>', GLJnl."Posting Date"));
                GLJnl2.Validate(Amount, -GLJnl.Amount);
                GLJnl2.Validate("Shortcut Dimension 1 Code", '999999');
                GLJnl2.Insert;
            until GLJnl.Next = 0;
    end;
}

