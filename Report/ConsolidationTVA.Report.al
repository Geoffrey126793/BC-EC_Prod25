report 50036 "Consolidation TVA"
{
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Business Unit"; "Business Unit")
        {
            DataItemTableView = WHERE ("UnitÚ TVA" = CONST (true));

            trigger OnAfterGetRecord()
            begin
                dlg.Open("Business Unit"."Company Name" + '@1@@@@@@@@@@@@@@@@@@@@@@');

                VATEntry.Reset;
                VATEntry.ChangeCompany("Business Unit"."Company Name");
                VATEntry.SetRange("Posting Date", DtDebut, DtFin);
                iCount := VATEntry.Count;
                iC := 1;
                if VATEntry.FindSet then
                    repeat
                        NewVATEntry.Init;
                        NewVATEntry.TransferFields(VATEntry, false);
                        NewVATEntry."Bill-to/Pay-to No." := CopyStr("Business Unit"."Company Name", 1, 20);
                        NewVATEntry."Entry No." := NextNo;
                        NextNo := NextNo + 1;
                        cuModif.ModifVATEntry(NewVATEntry);
                        iC := iC + 1;
                        dlg.Update(1, Round(iC / iCount * 10000, 1));
                    until VATEntry.Next = 0;
                dlg.Close;

                dlg.Open("Business Unit"."Company Name" + ' Correction @1@@@@@@@@@@@@@@@@@@@@@@');

                VATCorr.Reset;
                VATCorr.ChangeCompany("Business Unit"."Company Name");
                VATCorr.SetRange("Posting Date", DtDebut, DtFin);
                VATCorr.SetRange("Statement Name", 'DEFAUT');
                iCount := VATCorr.Count;
                iC := 1;
                if VATCorr.FindSet then
                    repeat
                        VATCorr.CalcFields("Row No.");

                        VATLSrc.Reset;
                        VATLSrc.ChangeCompany("Business Unit"."Company Name");
                        VATLSrc.Get(VATCorr."Statement Template Name", VATCorr."Statement Name", VATCorr."Statement Line No.");

                        VATL.Reset;
                        VATL.SetRange("Statement Template Name", VATCorr."Statement Template Name");
                        VATL.SetRange("Statement Name", VATCorr."Statement Name");
                        VATL.SetRange("Row No.", VATCorr."Row No.");
                        VATL.SetRange("VAT Bus. Posting Group", VATLSrc."VAT Bus. Posting Group");
                        VATL.SetRange("VAT Prod. Posting Group", VATLSrc."VAT Prod. Posting Group");
                        VATL.FindFirst;
                        NoL := VATL."Line No.";


                        newVATCorr.Reset;
                        newVATCorr.SetRange("Statement Template Name", VATCorr."Statement Template Name");
                        newVATCorr.SetRange("Statement Name", VATCorr."Statement Name");
                        newVATCorr.SetRange("Statement Line No.", NoL);
                        newVATCorr.SetRange("Posting Date", VATCorr."Posting Date");
                        if newVATCorr.FindFirst then begin
                            newVATCorr.Amount := newVATCorr.Amount + VATCorr.Amount;
                            newVATCorr.Modify;
                        end
                        else begin
                            newVATCorr.Reset;
                            newVATCorr.Init;
                            newVATCorr.TransferFields(VATCorr, true);
                            newVATCorr."Statement Line No." := NoL;
                            newVATCorr.Insert;
                        end;
                        iC := iC + 1;
                        dlg.Update(1, Round(iC / iCount * 10000, 1));
                    until VATCorr.Next = 0;
                dlg.Close;
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

    trigger OnPreReport()
    begin
        dlg.Open('Suppression @1@@@@@@@@@@@@@@@@@@@@@@');
        iC := 1;
        VATEntry.Reset;
        VATEntry.SetRange("Posting Date", DtDebut, DtFin);
        iCount := VATEntry.Count;
        if VATEntry.FindSet then
            repeat
                cuModif.DelVATEntry(VATEntry);
                iC := iC + 1;
                dlg.Update(1, Round(iC / iCount * 10000, 1));

            until VATEntry.Next = 0;
        dlg.Close;

        dlg.Open('Suppression @1@@@@@@@@@@@@@@@@@@@@@@');
        iC := 1;
        VATCorr.Reset;
        VATCorr.SetRange("Posting Date", DtDebut, DtFin);
        iCount := VATCorr.Count;
        if VATCorr.FindSet then
            repeat
                VATCorr.Delete;
                iC := iC + 1;
                dlg.Update(1, Round(iC / iCount * 10000, 1));
            until VATCorr.Next = 0;
        dlg.Close;


        VATEntry.Reset;
        if VATEntry.FindLast then
            NextNo := VATEntry."Entry No." + 1;
    end;

    var
        DtDebut: Date;
        DtFin: Date;
        VATEntry: Record "VAT Entry";
        NextNo: Integer;
        NewVATEntry: Record "VAT Entry";
        cuModif: Codeunit ModifTables;
        dlg: Dialog;
        iC: Integer;
        iCount: Integer;
        VATCorr: Record "Manual VAT Correction";
        newVATCorr: Record "Manual VAT Correction";
        VATL: Record "VAT Statement Line";
        VATLSrc: Record "VAT Statement Line";
        NoL: Integer;
}

