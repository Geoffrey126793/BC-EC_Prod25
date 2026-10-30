pageextension 70060 pageextension70060 extends "EB Payment Journal"
{
    layout
    {
        addfirst(Control1)
        {
            field("Journal Template Name"; "Journal Template Name")
            {
            }
            field("Transférer vers feuille"; "Transférer vers feuille")
            {

                trigger OnDrillDown()
                var
                    recF: Record "Payment Journal Template";
                    P: Page "EB Payment Journal Templates";
                begin
                    if PAGE.RunModal(2000000, recF) = ACTION::LookupOK then begin
                        "Transférer vers feuille" := recF.Name;
                    end;
                end;
            }
        }
        addafter("ShortcutDimCode[7]")
        {
            field(Name; Name)
            {
            }
            field("Document Date"; "Document Date")
            {
            }

            field(DtEcheance; DtEcheance)
            {
                Caption = 'Date échéance';
            }
        }
        addafter(Control1901775801)
        {
            group("Transfert feuille")
            {
                Caption = 'Transfert feuille';
                fixed(Control100000003)
                {
                    ShowCaption = false;
                    field(TotalTft; TotalTft)
                    {
                        Caption = 'Total transfert feuille';
                        Editable = false;
                    }
                }
            }
        }
    }
    actions
    {
        addafter(ExportPaymentLines)
        {
            action(Impression)
            {
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                var
                    PayJnl: Record "Payment Journal Line";
                begin
                    PayJnl.Reset;
                    PayJnl.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    PayJnl.SetRange("Journal Template Name", "Journal Template Name");

                    if PayJnl.FindFirst then
                        REPORT.Run(50059, true, true, PayJnl);
                end;
            }
            action("Remettre en Statut créé")
            {
                trigger OnAction()

                begin
                    Rec.Status := Rec.Status::Created;
                    Rec.MODIFY;
                end;
            }
        }
    }

    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";

    var
        TotalTft: Decimal;
        Description: Text;
        DtEcheance: Date;

    trigger OnAfterGetCurrRecord()
    begin
        CalcTft;
    end;


    trigger OnAfterGetRecord()
    begin
        if "Account No." <> '' then
            case "Account Type" of
                "Account Type"::Customer:
                    begin
                        CustLedgEntry.SetCurrentKey("Document No.");
                        CustLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
                        CustLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
                        CustLedgEntry.SetRange("Customer No.", "Account No.");
                        if CustLedgEntry.Find('+') then begin
                            Description := CustLedgEntry.Description;
                            DtEcheance := CustLedgEntry."Due Date";
                        end;
                    end;
                "Account Type"::Vendor:
                    begin
                        VendLedgEntry.SetCurrentKey("Document No.");
                        VendLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
                        VendLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
                        VendLedgEntry.SetRange("Vendor No.", "Account No.");
                        if VendLedgEntry.Find('+') then begin
                            Description := VendLedgEntry.Description;
                            DtEcheance := VendLedgEntry."Due Date";
                        end;
                    end;
            end;
    end;



    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        TftToNewJnl();
    end;

    local procedure CalcTft()
    var
        PayJnl: Record "Payment Journal Line";
    begin
        TotalTft := 0;
        PayJnl.Reset;
        PayJnl.SetRange("Journal Template Name", Rec."Journal Template Name");
        PayJnl.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        PayJnl.SetFilter("Transférer vers feuille", '<>''''');
        if PayJnl.FindSet then
            repeat
                TotalTft += PayJnl."Amount (LCY)";
            until PayJnl.Next = 0;
    end;

    local procedure TftToNewJnl()
    var
        PayJnl: Record "Payment Journal Line";
        PayTmpl: Record "Payment Journal Template";
    begin
        PayJnl.Reset;
        PayJnl.SetRange("Journal Template Name", Rec."Journal Template Name");
        PayJnl.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        PayJnl.SetFilter("Transférer vers feuille", '<>''''');
        if PayJnl.FindSet then
            repeat
                PayTmpl.Get(PayJnl."Transférer vers feuille");
                PayJnl.Rename(PayJnl."Transférer vers feuille", PayJnl."Journal Batch Name", PayJnl."Line No.");
                PayJnl."Transférer vers feuille" := '';
                PayJnl.Validate("Bank Account", PayTmpl."Bank Account");
                PayJnl.Modify;
            until not PayJnl.FindFirst;
    end;
}

