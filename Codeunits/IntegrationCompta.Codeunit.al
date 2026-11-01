codeunit 50025 Integration_Compta
{

    trigger OnRun()
    begin
    end;

    var
        xLBuf: Record "Excel Buffer" temporary;



    [EventSubscriber(ObjectType::Report, Report::"Intrastat Report Get Lines", OnBeforeInsertItemLedgerLineCall, '', false, false)]
    local procedure "Intrastat Report Get Lines_OnBeforeInsertItemLedgerLineCall"(var Sender: Report "Intrastat Report Get Lines"; IntrastatReportHeader: Record "Intrastat Report Header"; var IntrastatReportLine: Record "Intrastat Report Line"; var ValueEntry: Record "Value Entry"; var ItemLedgerEntry: Record "Item Ledger Entry"; var IsHandled: Boolean)
    var
        recExp: Record "Sales Shipment Header";
        recRecept: Record "Purch. Rcpt. Header";
        recNCV: Record "Sales Cr.Memo Header";
        recSalesH: Record "Sales Invoice Header";
        recPurchH: Record "Purch. Inv. Header";
    begin

        if IntrastatReportLine.Type = Enum::Microsoft.Inventory.Intrastat."Intrastat Report Line Type"::Shipment then begin
            if recExp.Get(IntrastatReportLine."Document No.") then begin
                IntrastatReportLine."No donneur / preneur ordre" := recExp."Sell-to Customer No.";
                IntrastatReportLine."Nom donneur / preneur ordre" := recExp."Bill-to Name";
                IntrastatReportLine."No TVA" := recExp."VAT Registration No.";
                recSalesH.Reset;
                recSalesH.SetRange("Order No.", recExp."Order No.");
                if recSalesH.FindFirst then
                    IntrastatReportLine."Document No.2" := recSalesH."No.";
                IntrastatReportLine.Modify();

            end;
        end;
        if IntrastatReportLine.Type = Enum::Microsoft.Inventory.Intrastat."Intrastat Report Line Type"::Receipt then begin
            if recRecept.Get(IntrastatReportLine."Document No.") then begin
                IntrastatReportLine."No donneur / preneur ordre" := recRecept."Pay-to Vendor No.";
                IntrastatReportLine."Nom donneur / preneur ordre" := recRecept."Pay-to Name";
                IntrastatReportLine."No TVA" := recRecept."VAT Registration No.";
                recPurchH.Reset;
                recPurchH.SetRange("Order No.", recRecept."Order No.");
                if recPurchH.FindFirst then
                    IntrastatReportLine."Document No.2" := recPurchH."No.";
                IntrastatReportLine.Modify();
            end;
        end;
        if ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Sales Credit Memo" then begin
            if recNCV.Get(IntrastatReportLine."Document No.") then begin
                IntrastatReportLine."No donneur / preneur ordre" := recNCV."Bill-to Customer No.";
                IntrastatReportLine."Nom donneur / preneur ordre" := recNCV."Bill-to Name";
                IntrastatReportLine."No TVA" := recNCV."VAT Registration No.";
                IntrastatReportLine."Document No.2" := recNCV."No.";
                IntrastatReportLine.Modify();
            end;

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 2000042, 'OnTransferCodBankStmtLinesOnBeforeInitGenJnlLine', '', false, false)]
    local procedure CU2000042_OnTransferCodBankStmtLinesOnBeforeInitGenJnlLine(CODAStatementLine: Record "CODA Statement Line")
    var
        l_ta_CustBankAccount: Record "Customer Bank Account";
        l_BkCount: Integer;
        GenJnlTemplate: Record "Gen. Journal Template";
    begin

        // AC.FDQ CODA 14/06/12 : Si compte bancaire non connu, ajout du compte banque client
        //                            en fiche client pour futurs matching auto
        if CODAStatementLine."Account Type" = CODAStatementLine."Account Type"::Customer then begin
            l_ta_CustBankAccount.SetRange("Customer No.", CODAStatementLine."Account No.");
            l_ta_CustBankAccount.SetRange("Bank Account No.", CODAStatementLine."Bank Account No. Other Party");
            if not (l_ta_CustBankAccount.FindSet) then begin
                l_ta_CustBankAccount.SetRange("Bank Account No.");
                l_BkCount := l_ta_CustBankAccount.Count;
                l_ta_CustBankAccount.Reset;
                l_ta_CustBankAccount.Init;
                l_ta_CustBankAccount."Customer No." := CODAStatementLine."Account No.";
                l_ta_CustBankAccount.Code := Format(l_BkCount + 1);
                l_ta_CustBankAccount."Bank Account No." := CODAStatementLine."Bank Account No. Other Party";
                if not (l_ta_CustBankAccount.Insert) then;
            end;
        end;
        // AC.FDQ //
    end;

    [EventSubscriber(ObjectType::Codeunit, 2000042, 'OnDecodeCustLedgEntryOnBeforePost', '', false, false)]
    local procedure CU2000042_OnDecodeCustLedgEntryOnBeforePost(var CustLedgerEntry: Record "Cust. Ledger Entry"; var CODAStatementLine: Record "CODA Statement Line"; var DocNo: Code[20])
    begin
        if not CustLedgerEntry.Find('-') then  //GEO Comm structurÃ©e
        begin
            CustLedgerEntry.SetFilter("Customer No.", '*' + CopyStr(CODAStatementLine."Customer Reference", 1, 3));
            CustLedgerEntry.SetRange("Document No.", 'VEN-E' + CopyStr(CODAStatementLine."Customer Reference", 4, 2) + '-' + CopyStr(CODAStatementLine."Customer Reference", 6, 5));
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 2000041, 'OnBeforeCodBankStmtLineInsert', '', false, false)]
    local procedure CU2000041_OnBeforeLinInsert(var CODAStatementSourceLine: Record "CODA Statement Source Line"; var CODAStatementLine: Record "CODA Statement Line")
    var
        Rec_BankAccount: Record "Bank Account";
    begin
        // AC.FDQ CODA 14/06/12 : Num‚rotation avec Code banque (sinon pas d'info dans les registres...)
        Rec_BankAccount.Get(CODAStatementSourceLine."Bank Account No.");
        if CODAStatementSourceLine."Posting Date" <> 0D then
            CODAStatementLine."Document No." := StrSubstNo('%1-%2-%3/%4', Rec_BankAccount."BankNo CODA",
                  Date2DMY(CODAStatementSourceLine."Posting Date", 3) - 2000, CopyStr(CODAStatementSourceLine.Data, 122, 3), CODAStatementSourceLine."Sequence No.")
    end;

    [Scope('OnPrem')]
    procedure ConvEntNoToVatNo(EnterpriseNo: Text[50]): Text[20]
    var
        VatNo: Text[20];
    begin
        EnterpriseNo := DelChr(EnterpriseNo, '=', DelChr(EnterpriseNo, '=', '0123456789'));
        if CopyStr(EnterpriseNo, 1, 1) = '0' then
            VatNo := 'BE ' + CopyStr(EnterpriseNo, 2, 3) + '.' + CopyStr(EnterpriseNo, 5, 3) + '.' + CopyStr(EnterpriseNo, 8)
        else
            VatNo := '';
        exit(VatNo);
    end;

    [Scope('OnPrem')]
    procedure ConvVatNoToEntNo(VatNo: Text[20]; "Country Code": Code[10]): Text[50]
    var
        Country: Record "Country/Region";
        EnterpriseNo: Text[50];
    begin
        if not Country.DetermineCountry("Country Code") then
            exit('');

        VatNo := DelChr(VatNo, '=', DelChr(VatNo, '=', '0123456789'));
        if StrLen(VatNo) = 9 then
            EnterpriseNo := '0' + CopyStr(VatNo, 1, 3) + '.' + CopyStr(VatNo, 4, 3) + '.' + CopyStr(VatNo, 7);
        if StrLen(VatNo) = 10 then
            EnterpriseNo := CopyStr(VatNo, 1, 4) + '.' + CopyStr(VatNo, 5, 3) + '.' + CopyStr(VatNo, 8);

        exit(EnterpriseNo);
    end;

    [EventSubscriber(ObjectType::Codeunit, 5700, 'OnBeforeCheckRespCenter2', '', false, false)]
    local procedure CU5700_CheckRespCenterEC(DocType: Option Sales,Purchase,Service; AccRespCenter: Code[10]; UserCode: Code[50]; var IsHandled: Boolean; var Result: Boolean)
    var
        RecRespCenter_l: Record "Responsibility Center";
        RecUserSetup_l: Record "User Setup";
        IsRespCntrAllowed: Boolean;
    begin
        IsRespCntrAllowed := false;
        if RecUserSetup_l.Get(UserCode) then
            if (RecUserSetup_l."Resp. Centrer Filter" <> '') then begin
                RecRespCenter_l.SetFilter(Code, RecUserSetup_l."Resp. Centrer Filter");
                RecRespCenter_l.FindSet;
                repeat
                    IsRespCntrAllowed := AccRespCenter = RecRespCenter_l.Code;
                until (RecRespCenter_l.Next = 0) or IsRespCntrAllowed; //CTD (PRespCtrCode = RecRespCenter_l.Code);
            end else
                IsRespCntrAllowed := true;
        Result := IsRespCntrAllowed;
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, 5700, 'OnBeforeGetRespCenter', '', false, false)]
    local procedure CU5700_GetRespCenterEC(DocType: Option Sales,Purchase,Service; AccRespCenter: Code[10]; var IsHandled: Boolean; var UserRespCenter: Code[20])
    var
        RecUserSetup_l: Record "User Setup";
    begin
        if RecUserSetup_l.Get(UserId) then
            UserRespCenter := RecUserSetup_l."Resp. Centrer Filter"
        else
            UserRespCenter := '';
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, 113, 'OnBeforeVendLedgEntryModify', '', false, false)]
    local procedure CU113_OnBeforeVendLedgEntryModify(var VendLedgEntry: Record "Vendor Ledger Entry"; FromVendLedgEntry: Record "Vendor Ledger Entry")
    begin
        VendLedgEntry."External Document No." := FromVendLedgEntry."External Document No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, 74, 'OnAfterPurchRcptLineSetFilters', '', false, false)]
    local procedure CU74_OnAfterPurchRcptLineSetFilters(var PurchRcptLine: Record "Purch. Rcpt. Line"; PurchaseHeader: Record "Purchase Header")
    begin
        PurchRcptLine.SetFilter("Posting Date", '>%1', CalcDate('<-24M>', Today));
    end;

    [EventSubscriber(ObjectType::Codeunit, 5802, 'OnPostInvtPostBufferOnBeforeFind', '', false, false)]
    local procedure CU5802_OnPostInvtPostBufferOnBeforeFind(var Sender: Codeunit "Inventory Posting To G/L"; var GlobalInvtPostBuf: Record "Invt. Posting Buffer")
    begin
        //Prevent GL Posting
        GlobalInvtPostBuf.SetRange("Account No.", '-1');
    end;

    [EventSubscriber(ObjectType::Codeunit, 5802, 'OnBeforeOnRun', '', false, false)]
    local procedure CU5802_OnBeforeOnRun(var ValueEntry: Record "Value Entry"; PostPerPostGroup: Boolean; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, 5802, 'OnBeforeBufferInvtPosting', '', false, false)]
    local procedure CU5802_OnBeforeBufferInvtPosting(var ValueEntry: Record "Value Entry"; var Result: Boolean; var IsHandled: Boolean)
    begin
        Result := false;
        IsHandled := true;
    end;

    [Scope('OnPrem')]
    procedure ImportXl("Journal Template Name": Code[20]; "Journal Batch Name": Code[20])
    var
        fileMgmt: Codeunit "File Management";
        ServerFileName: Text;
        SheetName: Text;
        i: Integer;
        GenJnl: Record "Gen. Journal Line";
        GenBatch: Record "Gen. Journal Batch";
        NoSeriesMgmt: Codeunit "No. Series";
        DocNo: Code[20];
    begin
        ServerFileName := fileMgmt.UploadFile('Sélectionner le fichier', '*.xlsx');
        SheetName := xLBuf.SelectSheetsName(ServerFileName);
        GenBatch.Get("Journal Template Name", "Journal Batch Name");
        DocNo := NoSeriesMgmt.PeekNextNo(GenBatch."No. Series", WorkDate);

        xLBuf.OpenBook(ServerFileName, SheetName);
        xLBuf.ReadSheet;

        i := 2;
        while (GetValueAtCell(i, 1) <> '') do begin
            GenJnl.Init;
            GenJnl."Journal Template Name" := "Journal Template Name";
            GenJnl."Journal Batch Name" := "Journal Batch Name";
            GenJnl."Line No." := i * 10000;
            GenJnl."Document No." := DocNo;
            GenJnl."Account Type" := GenJnl."Account Type"::"G/L Account";
            if CopyStr(GetValueAtCell(i, 3), 1, 1) = 'C' then
                GenJnl."Account Type" := GenJnl."Account Type"::Customer;
            if CopyStr(GetValueAtCell(i, 3), 1, 1) = 'F' then
                GenJnl."Account Type" := GenJnl."Account Type"::Vendor;

            GenJnl."Account No." := GetValueAtCell(i, 3);
            Evaluate(GenJnl."Posting Date", GetValueAtCell(i, 1));
            GenJnl.Description := GetValueAtCell(i, 5);
            Evaluate(GenJnl."Debit Amount", GetValueAtCell(i, 6));
            Evaluate(GenJnl."Credit Amount", GetValueAtCell(i, 7));
            GenJnl.Validate("Debit Amount");
            GenJnl.Validate("Credit Amount");
            GenJnl.Validate("Shortcut Dimension 1 Code", GetValueAtCell(i, 8));
            if GenJnl.Amount <> 0 then GenJnl.Insert;
            i += 1;
        end;
    end;

    procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text[1024]
    begin
        if not xLBuf.Get(RowNo, ColNo) then
            exit('');
        exit(xLBuf."Cell Value as Text");
    end;

    [Scope('OnPrem')]
    procedure ImportCoutStd("Standard Cost Worksheet Name": Code[20])
    var
        fileMgmt: Codeunit "File Management";
        ServerFileName: Text;
        SheetName: Text;
        i: Integer;
        DocNo: Code[20];
        StdJnl: Record "Standard Cost Worksheet";
    begin
        ServerFileName := fileMgmt.UploadFile('Sélectionner le fichier', '*.xlsx');
        SheetName := xLBuf.SelectSheetsName(ServerFileName);

        xLBuf.OpenBook(ServerFileName, SheetName);
        xLBuf.ReadSheet;

        i := 2;
        while (GetValueAtCell(i, 1) <> '') do begin
            StdJnl.Init;
            StdJnl."Standard Cost Worksheet Name" := "Standard Cost Worksheet Name";
            StdJnl.Validate(Type, StdJnl.Type::Item);
            StdJnl.Validate("No.", GetValueAtCell(i, 1));
            Evaluate(StdJnl."New Standard Cost", GetValueAtCell(i, 3));
            StdJnl.Validate("New Standard Cost", StdJnl."New Standard Cost");
            StdJnl.Insert;
            i += 1;
        end;
    end;

    [Scope('OnPrem')]
    procedure ImportCoutSimulation()
    var
        fileMgmt: Codeunit "File Management";
        ServerFileName: Text;
        SheetName: Text;
        i: Integer;
        DocNo: Code[20];
        StdJnl: Record "Standard Cost Worksheet";
        Item: Record Item;
    begin
        ServerFileName := fileMgmt.UploadFile('Sélectionner le fichier', '*.xlsx');
        SheetName := xLBuf.SelectSheetsName(ServerFileName);
        if not Confirm('Remplacer les couts simules par la feuille excel ?') then
            Error('Annulé');

        xLBuf.OpenBook(ServerFileName, SheetName);
        xLBuf.ReadSheet;

        i := 2;
        while (GetValueAtCell(i, 1) <> '') do begin
            if Item.Get(GetValueAtCell(i, 1)) then begin
                Evaluate(Item."Cout simulation", GetValueAtCell(i, 3));
                Item.Modify;
            end;

            i += 1;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 1400, 'OnBeforeSalesDocumentNoIsVisible', '', false, false)]
    local procedure CU1400_OnBeforeSalesDocumentNoIsVisible(DocType: Option; DocNo: Code[20]; var IsVisible: Boolean; var IsHandled: Boolean)
    begin
        IsVisible := true;
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, 297, 'OnBeforeInsertEvent', '', false, false)]
    local procedure T297_OnInsert(var Rec: Record "Issued Reminder Header"; RunTrigger: Boolean)
    begin
        Rec."Envoi automatique" := true;
    end;

    [EventSubscriber(ObjectType::Table, 295, 'OnBeforeValidateEvent', 'Customer No.', false, false)]
    local procedure T295_ValidateCust(var Rec: Record "Reminder Header"; var xRec: Record "Reminder Header"; CurrFieldNo: Integer)
    var
        Cust: Record Customer;
    begin
        Cust.Get(Rec."Customer No.");
        Rec."Salesperson Code" := Cust."Salesperson Code";
    end;


    [EventSubscriber(ObjectType::Table, 288, 'OnAfterValidateEvent', 'IBAN', false, false)]
    local procedure T288_ModifIBAN(var Rec: Record "Vendor Bank Account"; var xRec: Record "Vendor Bank Account"; CurrFieldNo: Integer)
    var
        Vend: Record Vendor;
        emailmsg: Codeunit "Email Message";
        emailsend: codeunit Email;
    begin
        if Vend.Get(Rec."Vendor No.") then;
        emailmsg.Create('JeanSebastien.beghain@europacuisson.com;Xavier.Cloquet@europacuisson.com;g.dangremont@europacuisson.com;s.rapidy@europacuisson.com', 'Modification IBAN fournisseur', 'L''IBAN du fournisseur ' + Rec."Vendor No." + Vend.Name + ' a été modifié par ' + UserId + '   ' + xRec.IBAN + '  ->  ' + Rec.IBAN, true);
        emailsend.Send(emailmsg, Enum::"Email Scenario"::Default);
    end;

    [EventSubscriber(ObjectType::Report, 795, 'OnBeforePreReport', '', false, false)]
    local procedure R795_Before(var Sender: Report "Adjust Cost - Item Entries")
    var
        usersetup: Record "User Setup";
    begin
        if UserId = 'EUROPACUISSON\GEOFFREYD' then begin
            usersetup.Get(UserId);
            usersetup."Allow Posting From" := CalcDate('<-2Y>', Today);
            usersetup.Modify;
        end;
    end;

    [EventSubscriber(ObjectType::Report, 795, 'OnAfterPreReport', '', false, false)]
    local procedure R795_After(var Sender: Report "Adjust Cost - Item Entries")
    var
        usersetup: Record "User Setup";
    begin
        if UserId = 'EUROPACUISSON\GEOFFREYD' then begin
            usersetup.Get(UserId);
            usersetup."Allow Posting From" := CalcDate('<-3M>', usersetup."Allow Posting To");
            usersetup.Modify;
        end;
    end;
}

