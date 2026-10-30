report 50035 "Consolidation TVA detail"
{
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Business Unit"; "Business Unit")
        {
            DataItemTableView = WHERE("UnitÚ TVA" = CONST(true));

            trigger OnAfterGetRecord()
            begin
                dlg.Open("Business Unit"."Company Name" + '@1@@@@@@@@@@@@@@@@@@@@@@');

                "VAT Statement Line".Reset;
                "VAT Statement Line".ChangeCompany("Business Unit"."Company Name");
                "VAT Statement Line".SetRange(Type, "VAT Statement Line".Type::"Row Totaling");
                "VAT Statement Line".SetRange("Print on Official VAT Form", true);
                //"VAT Statement Line".SETRANGE("Line No.",2080000);
                "VAT Statement Line".SetRange("Statement Template Name", 'TVA');
                "VAT Statement Line".SetRange("Statement Name", 'DEFAUT');

                if "VAT Statement Line".FindSet then
                    repeat
                        CalcLineTotal("VAT Statement Line", TotalAmount, CorrectionAmount, NetAmount, '', 0);
                        XL.Init;
                        XL."Row No." := XLine;
                        XL.Validate("Column No.", 1);
                        XL."Cell Value as Text" := "Business Unit"."Company Name";
                        XL.Insert;
                        XL.Init;
                        XL."Row No." := XLine;
                        XL.Validate("Column No.", 2);
                        XL."Cell Value as Text" := "VAT Statement Line"."Row No.";
                        XL.Insert;
                        XL.Init;
                        XL."Row No." := XLine;
                        XL.Validate("Column No.", 3);
                        XL."Cell Value as Text" := Format(TotalAmount + CorrectionAmount);
                        //XL."Cell Value as Text" := FORMAT(TotalAmount);
                        XL.Insert;

                        XLine += 1;
                    until "VAT Statement Line".Next = 0;





                dlg.Close;
            end;

            trigger OnPreDataItem()
            begin
                //SETFILTER("Company Name",'EC Démarrage');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(DtDebut; DtDebut)
                {
                    Caption = 'Date de début';
                }
                field(DtFin; DtFin)
                {
                    Caption = 'Date de fin';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        if UpperCase(CompanyName) <> 'CONSOLIDATION' then
            Error('Vous n''êtes pas dans la société de consolidation');
    end;

    trigger OnPostReport()
    var
        FileMgt: Codeunit "File Management";
    begin
        XL.CreateBook(FileMgt.ServerTempFileName('xlsx'), 'test');
        //xlBuf.CreateBook('\\srvnavision\NavisionTemp\000.xlsx','test');
        XL.WriteSheet('rr', '', '');
        XL.CloseBook();
        XL.DownloadAndOpenExcel();
    end;

    trigger OnPreReport()
    begin

        "VAT Statement Name".Get('TVA', 'DEFAUT');
        //"VAT Statement Line".COPY(NewVATStatementLine);
        XLine := 1;
    end;

    var
        DtDebut: Date;
        DtFin: Date;
        dlg: Dialog;
        iC: Integer;
        iCount: Integer;
        XL: Record "Excel Buffer" temporary;
        XLine: Integer;
        VATEntry: Record "VAT Entry";
        Amount: Decimal;
        Amount2: Decimal;
        RowNo: array[6] of Code[10];
        i: Integer;
        ErrorText: Text;
        "VAT Statement Name": Record "VAT Statement Name";
        "VAT Statement Line": Record "VAT Statement Line";
        TotalAmount: Decimal;
        CorrectionAmount: Decimal;
        NetAmount: Decimal;

    procedure CalcLineTotal(VATStmtLine2: Record "VAT Statement Line"; var TotalAmount: Decimal; var CorrectionAmount: Decimal; var NetAmountLCY: Decimal; JournalTempl: Code[10]; Level: Integer): Boolean
    begin
        if Level = 0 then begin
            TotalAmount := 0;
            NetAmountLCY := 0;
            CorrectionAmount := 0;
        end;
        CalcCorrection(VATStmtLine2, CorrectionAmount);
        case VATStmtLine2.Type of
            VATStmtLine2.Type::"Account Totaling":
                begin

                end;
            VATStmtLine2.Type::"VAT Entry Totaling":
                begin
                    VATEntry.Reset;
                    VATEntry.ChangeCompany("Business Unit"."Company Name");
                    VATEntry.SetCurrentKey("Journal Templ. Name"
                      , Type, Closed, "VAT Bus. Posting Group", "VAT Prod. Posting Group", "Document Type", "Posting Date");
                    VATEntry.SetRange("VAT Bus. Posting Group", VATStmtLine2."VAT Bus. Posting Group");
                    VATEntry.SetRange("VAT Prod. Posting Group", VATStmtLine2."VAT Prod. Posting Group");
                    if JournalTempl <> '' then
                        VATEntry.SetRange("Journal Templ. Name", JournalTempl);
                    VATEntry.SetRange(Type, VATStmtLine2."Gen. Posting Type");
                    if VATStmtLine2."Document Type" = VATStmtLine2."Document Type"::"All except Credit Memo" then
                        VATEntry.SetFilter("Document Type", '<>%1', VATStmtLine2."Document Type"::"Credit Memo")
                    else
                        VATEntry.SetRange("Document Type", VATStmtLine2."Document Type");

                    VATEntry.SetRange("Posting Date", DtDebut, DtFin);
                    VATEntry.SetRange(Closed);

                    case VATStmtLine2."Amount Type" of
                        VATStmtLine2."Amount Type"::Amount:
                            begin
                                VATEntry.CalcSums(Amount, "Additional-Currency Amount");
                                Amount := ConditionalAdd(0, VATEntry.Amount, VATEntry."Additional-Currency Amount");
                                if VATStmtLine2."Incl. Non Deductible VAT" then begin
                                    VATEntry.CalcSums("Non Ded. VAT Amount", "Non Ded. Source Curr. VAT Amt.");
                                    Amount := ConditionalAdd(Amount, VATEntry."Non Ded. VAT Amount", VATEntry."Non Ded. Source Curr. VAT Amt.");
                                end;
                                Amount2 := Amount;
                            end;
                        VATStmtLine2."Amount Type"::Base:
                            begin
                                VATEntry.CalcSums(Base, "Additional-Currency Base", "Base Before Pmt. Disc.");
                                Amount := ConditionalAdd(0, VATEntry.Base, VATEntry."Additional-Currency Base");
                                if VATStmtLine2."Incl. Non Deductible VAT" then begin
                                    VATEntry.CalcSums("Non Ded. VAT Amount", "Non Ded. Source Curr. VAT Amt.");
                                    Amount := ConditionalAdd(Amount, -VATEntry."Non Ded. VAT Amount", -VATEntry."Non Ded. Source Curr. VAT Amt.");
                                end;
                                Amount2 := ConditionalAdd(0, VATEntry."Base Before Pmt. Disc.", 0);
                            end;
                        VATStmtLine2."Amount Type"::"Unrealized Amount":
                            begin
                                VATEntry.CalcSums("Remaining Unrealized Amount", "Add.-Curr. Rem. Unreal. Amount");
                                Amount := ConditionalAdd(0, VATEntry."Remaining Unrealized Amount", VATEntry."Add.-Curr. Rem. Unreal. Amount");
                                Amount2 := Amount;
                            end;
                        VATStmtLine2."Amount Type"::"Unrealized Base":
                            begin
                                VATEntry.CalcSums("Remaining Unrealized Base", "Add.-Curr. Rem. Unreal. Base");
                                Amount := ConditionalAdd(0, VATEntry."Remaining Unrealized Base", VATEntry."Add.-Curr. Rem. Unreal. Base");
                                Amount2 := Amount;
                            end;
                    end;
                    CalcTotalAmount(VATStmtLine2, TotalAmount, NetAmountLCY);
                end;
            VATStmtLine2.Type::"Row Totaling":
                begin
                    if Level >= ArrayLen(RowNo) then
                        exit(false);
                    Level := Level + 1;
                    RowNo[Level] := VATStmtLine2."Row No.";

                    if VATStmtLine2."Row Totaling" = '' then
                        exit(true);
                    VATStmtLine2.SetRange("Statement Template Name", VATStmtLine2."Statement Template Name");
                    VATStmtLine2.SetRange("Statement Name", VATStmtLine2."Statement Name");
                    VATStmtLine2.SetFilter("Row No.", VATStmtLine2."Row Totaling");
                    VATStmtLine2.ChangeCompany("Business Unit"."Company Name");
                    if VATStmtLine2.Find('-') then
                        repeat
                            if not CalcLineTotal(VATStmtLine2, TotalAmount, CorrectionAmount, NetAmountLCY, JournalTempl, Level) then begin
                                if Level > 5 then
                                    exit(false);
                                for i := 1 to ArrayLen(RowNo) do
                                    ErrorText := ErrorText + RowNo[i] + ' => ';
                                ErrorText := ErrorText + '...';
                                VATStmtLine2.FieldError("Row No.", ErrorText);
                            end;
                        until VATStmtLine2.Next = 0;
                end;
        end;

        exit(true);
    end;

    local procedure CalcTotalAmount(VATStmtLine2: Record "VAT Statement Line"; var TotalAmount: Decimal; var NetAmountLCY: Decimal)
    begin
        if VATStmtLine2."Calculate with" = 1 then begin
            Amount := -Amount;
            Amount2 := -Amount2;
        end;
        TotalAmount := TotalAmount + Amount;
        NetAmountLCY := NetAmountLCY + Amount2;
    end;

    procedure InitializeRequest(var NewVATStmtName: Record "VAT Statement Name"; var NewVATStatementLine: Record "VAT Statement Line")
    begin
    end;

    local procedure ConditionalAdd(Amount: Decimal; AmountToAdd: Decimal; AddCurrAmountToAdd: Decimal): Decimal
    begin
        exit(Amount + AmountToAdd);
    end;

    local procedure GetCurrency(): Code[10]
    begin

        exit('');
    end;

    local procedure CalcCorrection(VATStmtLine2: Record "VAT Statement Line"; var CorrectionAmount: Decimal)
    var
        ManualVATCorrection: Record "Manual VAT Correction";
    begin
        CalcManualVATCorrectionSums(VATStmtLine2, ManualVATCorrection);
        Amount := ConditionalAdd(0, ManualVATCorrection.Amount, ManualVATCorrection."Additional-Currency Amount");
        if VATStmtLine2."Calculate with" = VATStmtLine2."Calculate with"::"Opposite Sign" then
            Amount := -Amount;
        CorrectionAmount := CorrectionAmount + Amount;
    end;

    local procedure CalcManualVATCorrectionSums(VATStmtLine2: Record "VAT Statement Line"; var ManualVATCorrection: Record "Manual VAT Correction")
    begin
        ManualVATCorrection.ChangeCompany("Business Unit"."Company Name");
        with ManualVATCorrection do begin
            Reset;
            SetRange("Statement Template Name", VATStmtLine2."Statement Template Name");
            SetRange("Statement Name", VATStmtLine2."Statement Name");
            SetRange("Statement Line No.", VATStmtLine2."Line No.");
            SetRange("Posting Date", GetPeriodStartDate, DtFin);
            CalcSums(Amount, "Additional-Currency Amount");
        end;
    end;

    local procedure GetPeriodStartDate(): Date
    begin
        exit(DtDebut);
    end;
}

