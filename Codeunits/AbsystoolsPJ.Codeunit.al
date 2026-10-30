codeunit 50007 "Absys - tools PJ"
{
    // -------------------------------------------------------------------------------------------------
    // ABS6.00
    //   Check Form Item, Vendor, Customer
    //     Add Function
    //      - CheckFormFilled()
    // -------------------------------------------------------------------------------------------------
    // AB6.SEC VIR 22/03/10 : Ajout fonction TestStatsecurity : pour tester sécurité du Stat-explorer


    trigger OnRun()
    begin
    end;

    var
        TxtAsciiStr_g: Text[250];
        TxtAnsiStr_g: Text[250];
        TxtCharVar_g: array[32] of Char;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        TotalSalesLine: Record "Sales Line";
        TotalSalesLineLCY: Record "Sales Line";
        TempVATAmountLineRemainder: Record "VAT Amount Line" temporary;
        TempVATAmountLine: Record "VAT Amount Line" Temporary;
        GLSetup: Record "General Ledger Setup";
        SalesSetup: Record "Sales & Receivables Setup";
        RoundingLineInserted: Boolean;
        TempSalesLine: Record "Sales Line";
        LastLineRetrieved: Boolean;
        Currency: Record Currency;
        RoundingLineNo: Integer;
        SalesLineACY: Record "Sales Line";
        UseDate: Date;
        CurrExchRate: Record "Currency Exchange Rate";
        CustPostingGr: Record "Customer Posting Group";
        Text016: Label 'VAT Amount';
        Text017: Label '%1% VAT';
        Text50000: Label 'Pour générer un code EAN, Votre article doit appartenir à une catégorie article.';
        Text50001: Label 'Le No. incrémenté pour la création EAN est invalide (> 999)';
        Text50002: Label 'Cette catégorie article n''existe pas !';
        Text50003: Label 'Vous devez définir le Code génération EAN de la catégorie %1';
        Text50004: Label 'Vous devez définir le Code génération EAN de la Société : %1';

    [Scope('OnPrem')]
    procedure TrimLeft(TxtString_p: Text[250]): Text[250]
    var
        IntI_l: Integer;
    begin
        if TxtString_p = '' then begin
            exit('');
        end;

        IntI_l := 1;
        while (CopyStr(TxtString_p, IntI_l, 1) = ' ') do begin
            IntI_l += 1;
        end;

        exit(CopyStr(TxtString_p, IntI_l));
    end;

    [Scope('OnPrem')]
    procedure TrimRight(TxtString_p: Text[250]): Text[250]
    var
        IntI_l: Integer;
    begin
        if TxtString_p = '' then begin
            exit('');
        end;

        IntI_l := StrLen(TxtString_p);

        while (CopyStr(TxtString_p, IntI_l, 1) = ' ') do begin
            IntI_l -= 1;
        end;

        exit(CopyStr(TxtString_p, 1, IntI_l));
    end;

    [Scope('OnPrem')]
    procedure TrimBoth(TxtString_p: Text[250]): Text[250]
    begin
        if TxtString_p = '' then begin
            exit('');
        end;

        exit(TrimLeft(TrimRight(TxtString_p)));
    end;

    [Scope('OnPrem')]
    procedure DelLeftChar(TxtString_p: Text[250]; TxtChar_p: Text[1]): Text[250]
    var
        IntI_l: Integer;
    begin
        if TxtString_p = '' then begin
            exit('');
        end;

        IntI_l := 1;
        while (CopyStr(TxtString_p, IntI_l, 1) = TxtChar_p) do begin
            IntI_l += 1;
        end;

        exit(CopyStr(TxtString_p, IntI_l));
    end;

    [Scope('OnPrem')]
    procedure GetRole("Quel Role": Code[20]): Boolean
    var
        RoleWindows: Record "Access Control";
    begin



        RoleWindows.SetRange("User Name", UserId);
        RoleWindows.SetRange("Role ID", "Quel Role");
        if RoleWindows.Count = 0 then exit(false);
        RoleWindows.SetRange("Company Name", CompanyName);
        if RoleWindows.Find('-') then exit(true);
        RoleWindows.Reset;
        RoleWindows.SetRange("User Name", UserId);
        RoleWindows.SetRange("Role ID", "Quel Role");
        RoleWindows.SetRange("Company Name", '');
        if RoleWindows.Find('-') then exit(true);
        exit(false);
    end;

    [Scope('OnPrem')]
    procedure DelRightChar(TxtString_p: Text[250]; TxtChar_p: Text[1]): Text[250]
    var
        IntI_l: Integer;
    begin
        if TxtString_p = '' then begin
            exit('');
        end;

        IntI_l := StrLen(TxtString_p);

        while (CopyStr(TxtString_p, IntI_l, 1) = TxtChar_p) do begin
            IntI_l -= 1;
        end;

        exit(CopyStr(TxtString_p, 1, IntI_l));
    end;

    [Scope('OnPrem')]
    procedure GetSalesInvoiceVAT(RecSalesInvoiceHeader_p: Record "Sales Invoice Header"; var DecVATAmount_p: Decimal; var DecVATBaseAmount_p: Decimal; var DecVATDiscountAmount_p: Decimal; var DecTotalAmountInclVAT_p: Decimal; var TabRecVATAmountLine_p: array[5] of Record "VAT Amount Line")
    var
        RecSalesInvoiceLine_l: Record "Sales Invoice Line";
        RecVATAmountLine_l: Record "VAT Amount Line" temporary;
        IntI_l: Integer;
    begin
        //Absys AB - cette fonction permet le calcul facile des différents montants
        //relatifs à la TVA, ainsi que le remplissage d'un tableau contenant ces montants
        //pour les différentes TVA appliquées

        RecVATAmountLine_l.DeleteAll;
        Clear(TabRecVATAmountLine_p);

        RecSalesInvoiceLine_l.Reset;
        RecSalesInvoiceLine_l.SetRange("Document No.", RecSalesInvoiceHeader_p."No.");
        if RecSalesInvoiceLine_l.Find('-') then begin
            repeat

                RecVATAmountLine_l.Init;
                RecVATAmountLine_l."VAT Identifier" := RecSalesInvoiceLine_l."VAT Identifier";
                RecVATAmountLine_l."VAT Calculation Type" := RecSalesInvoiceLine_l."VAT Calculation Type";
                RecVATAmountLine_l."Tax Group Code" := RecSalesInvoiceLine_l."Tax Group Code";
                RecVATAmountLine_l."VAT %" := RecSalesInvoiceLine_l."VAT %";
                RecVATAmountLine_l."VAT Base" := RecSalesInvoiceLine_l.Amount;
                RecVATAmountLine_l."Amount Including VAT" := RecSalesInvoiceLine_l."Amount Including VAT";
                RecVATAmountLine_l."Line Amount" := RecSalesInvoiceLine_l."Line Amount";
                if RecSalesInvoiceLine_l."Allow Invoice Disc." then begin
                    RecVATAmountLine_l."Inv. Disc. Base Amount" := RecSalesInvoiceLine_l."Line Amount";
                end;
                RecVATAmountLine_l."Invoice Discount Amount" := RecSalesInvoiceLine_l."Inv. Discount Amount";
                RecVATAmountLine_l."VAT Base (Lowered)" := RecSalesInvoiceLine_l."VAT Base Amount";
                RecVATAmountLine_l.InsertLine;
            until RecSalesInvoiceLine_l.Next = 0;
        end;

        RecVATAmountLine_l.SetCurrentKey("VAT %", "VAT Identifier", "VAT Calculation Type", "Tax Group Code", "Use Tax", Positive);

        DecVATAmount_p := RecVATAmountLine_l.GetTotalVATAmount;
        DecVATBaseAmount_p := RecVATAmountLine_l.GetTotalVATBase;
        DecVATDiscountAmount_p := RecVATAmountLine_l.GetTotalVATDiscount(RecSalesInvoiceHeader_p."Currency Code",
          RecSalesInvoiceHeader_p."Prices Including VAT");
        DecTotalAmountInclVAT_p := RecVATAmountLine_l.GetTotalAmountInclVAT;

        //IF DecVATAmount_p = 0 THEN BEGIN
        //  EXIT;
        //END;

        RecVATAmountLine_l.CalcSums(
          RecVATAmountLine_l."Line Amount", RecVATAmountLine_l."Inv. Disc. Base Amount",
          RecVATAmountLine_l."Invoice Discount Amount", RecVATAmountLine_l."VAT Base (Lowered)", RecVATAmountLine_l."VAT Amount");

        for IntI_l := 1 to RecVATAmountLine_l.Count do begin
            RecVATAmountLine_l.GetLine(IntI_l);
            AddVATLineToTab(RecVATAmountLine_l, TabRecVATAmountLine_p);
        end;
    end;

    [Scope('OnPrem')]
    procedure GetSalesOrderVAT(RecSalesHeader_p: Record "Sales Header"; var DecVATAmount_p: Decimal; var DecVATBaseAmount_p: Decimal; var DecVATDiscountAmount_p: Decimal; var DecTotalAmountInclVAT_p: Decimal; var TabRecVATAmountLine_p: array[5] of Record "VAT Amount Line")
    var
        CUSalesPost_l: Codeunit "Sales-Post";
        RecSalesLine_l: Record "Sales Line" temporary;
        RecVATAmountLine_l: Record "VAT Amount Line" temporary;
        IntI_l: Integer;
    begin
        //Absys AB - cette fonction permet le calcul facile des différents montants
        //relatifs à la TVA, ainsi que le remplissage d'un tableau contenant ces montants
        //pour les différentes TVA appliquées
        Clear(RecSalesLine_l);
        Clear(CUSalesPost_l);
        RecVATAmountLine_l.DeleteAll;
        Clear(TabRecVATAmountLine_p);
        RecSalesLine_l.DeleteAll;
        CUSalesPost_l.GetSalesLines(RecSalesHeader_p, RecSalesLine_l, 0);
        RecSalesLine_l.CalcVATAmountLines(0, RecSalesHeader_p, RecSalesLine_l, RecVATAmountLine_l);
        RecSalesLine_l.UpdateVATOnLines(0, RecSalesHeader_p, RecSalesLine_l, RecVATAmountLine_l);
        DecVATAmount_p := RecVATAmountLine_l.GetTotalVATAmount;
        DecVATBaseAmount_p := RecVATAmountLine_l.GetTotalVATBase;
        DecVATDiscountAmount_p := RecVATAmountLine_l.GetTotalVATDiscount(RecSalesHeader_p."Currency Code",
          RecSalesHeader_p."Prices Including VAT");
        DecTotalAmountInclVAT_p := RecVATAmountLine_l.GetTotalAmountInclVAT;

        if DecVATAmount_p = 0 then begin
            exit;
        end;

        RecVATAmountLine_l.CalcSums(
          RecVATAmountLine_l."Line Amount", RecVATAmountLine_l."Inv. Disc. Base Amount",
          RecVATAmountLine_l."Invoice Discount Amount", RecVATAmountLine_l."VAT Base (Lowered)", RecVATAmountLine_l."VAT Amount");

        for IntI_l := 1 to RecVATAmountLine_l.Count do begin
            RecVATAmountLine_l.GetLine(IntI_l);
            AddVATLineToTab(RecVATAmountLine_l, TabRecVATAmountLine_p);
        end;
    end;

    [Scope('OnPrem')]
    procedure GetSalesOrderVATwoComm(RecSalesHeader_p: Record "Sales Header"; var DecVATAmount_p: Decimal; var DecVATBaseAmount_p: Decimal; var DecVATDiscountAmount_p: Decimal; var DecTotalAmountInclVAT_p: Decimal; var TabRecVATAmountLine_p: array[5] of Record "VAT Amount Line")
    var
        CUSalesPost_l: Codeunit "Sales-Post";
        RecSalesLine_l: Record "Sales Line" temporary;
        RecVATAmountLine_l: Record "VAT Amount Line" temporary;
        IntI_l: Integer;
    begin
        //Absys AB - cette fonction permet le calcul facile des différents montants
        //relatifs à la TVA, ainsi que le remplissage d'un tableau contenant ces montants
        //pour les différentes TVA appliquées
        Clear(RecSalesLine_l);
        Clear(CUSalesPost_l);
        RecVATAmountLine_l.DeleteAll;
        Clear(TabRecVATAmountLine_p);
        RecSalesLine_l.DeleteAll;
        GetSalesLines(RecSalesHeader_p, RecSalesLine_l, 0);
        RecSalesLine_l.CalcVATAmountLines(0, RecSalesHeader_p, RecSalesLine_l, RecVATAmountLine_l);
        RecSalesLine_l.UpdateVATOnLines(0, RecSalesHeader_p, RecSalesLine_l, RecVATAmountLine_l);
        DecVATAmount_p := RecVATAmountLine_l.GetTotalVATAmount;
        DecVATBaseAmount_p := RecVATAmountLine_l.GetTotalVATBase;
        DecVATDiscountAmount_p := RecVATAmountLine_l.GetTotalVATDiscount(RecSalesHeader_p."Currency Code",
          RecSalesHeader_p."Prices Including VAT");
        DecTotalAmountInclVAT_p := RecVATAmountLine_l.GetTotalAmountInclVAT;

        if DecVATAmount_p = 0 then begin
            exit;
        end;

        RecVATAmountLine_l.CalcSums(
          RecVATAmountLine_l."Line Amount", RecVATAmountLine_l."Inv. Disc. Base Amount",
          RecVATAmountLine_l."Invoice Discount Amount", RecVATAmountLine_l."VAT Base (Lowered)", RecVATAmountLine_l."VAT Amount");

        for IntI_l := 1 to RecVATAmountLine_l.Count do begin
            RecVATAmountLine_l.GetLine(IntI_l);
            AddVATLineToTab(RecVATAmountLine_l, TabRecVATAmountLine_p);
        end;
    end;

    [Scope('OnPrem')]
    procedure GetSalesCrMemoVAT(RecSalesCrMemoHeader_p: Record "Sales Cr.Memo Header"; var DecVATAmount_p: Decimal; var DecVATBaseAmount_p: Decimal; var DecVATDiscountAmount_p: Decimal; var DecTotalAmountInclVAT_p: Decimal; var TabRecVATAmountLine_p: array[5] of Record "VAT Amount Line")
    var
        RecSalesCrMemoLine_l: Record "Sales Cr.Memo Line";
        RecVATAmountLine_l: Record "VAT Amount Line" temporary;
        IntI_l: Integer;
    begin
        //Absys AB - cette fonction permet le calcul facile des différents montants
        //relatifs à la TVA, ainsi que le remplissage d'un tableau contenant ces montants
        //pour les différentes TVA appliquées

        RecVATAmountLine_l.DeleteAll;
        Clear(TabRecVATAmountLine_p);

        RecSalesCrMemoLine_l.Reset;
        RecSalesCrMemoLine_l.SetRange("Document No.", RecSalesCrMemoHeader_p."No.");
        if RecSalesCrMemoLine_l.Find('-') then begin
            repeat

                RecVATAmountLine_l.Init;
                RecVATAmountLine_l."VAT Identifier" := RecSalesCrMemoLine_l."VAT Identifier";
                RecVATAmountLine_l."VAT Calculation Type" := RecSalesCrMemoLine_l."VAT Calculation Type";
                RecVATAmountLine_l."Tax Group Code" := RecSalesCrMemoLine_l."Tax Group Code";
                RecVATAmountLine_l."VAT %" := RecSalesCrMemoLine_l."VAT %";
                RecVATAmountLine_l."VAT Base" := RecSalesCrMemoLine_l.Amount;
                RecVATAmountLine_l."Amount Including VAT" := RecSalesCrMemoLine_l."Amount Including VAT";
                RecVATAmountLine_l."Line Amount" := RecSalesCrMemoLine_l."Line Amount";
                if RecSalesCrMemoLine_l."Allow Invoice Disc." then begin
                    RecVATAmountLine_l."Inv. Disc. Base Amount" := RecSalesCrMemoLine_l."Line Amount";
                end;
                RecVATAmountLine_l."Invoice Discount Amount" := RecSalesCrMemoLine_l."Inv. Discount Amount";
                RecVATAmountLine_l."VAT Base (Lowered)" := RecSalesCrMemoLine_l."VAT Base Amount";
                RecVATAmountLine_l.InsertLine;
            until RecSalesCrMemoLine_l.Next = 0;
        end;

        DecVATAmount_p := RecVATAmountLine_l.GetTotalVATAmount;
        DecVATBaseAmount_p := RecVATAmountLine_l.GetTotalVATBase;
        DecVATDiscountAmount_p := RecVATAmountLine_l.GetTotalVATDiscount(RecSalesCrMemoHeader_p."Currency Code",
          RecSalesCrMemoHeader_p."Prices Including VAT");
        DecTotalAmountInclVAT_p := RecVATAmountLine_l.GetTotalAmountInclVAT;

        if DecVATAmount_p = 0 then begin
            exit;
        end;

        RecVATAmountLine_l.CalcSums(
          RecVATAmountLine_l."Line Amount", RecVATAmountLine_l."Inv. Disc. Base Amount",
          RecVATAmountLine_l."Invoice Discount Amount", RecVATAmountLine_l."VAT Base (Lowered)", RecVATAmountLine_l."VAT Amount");

        for IntI_l := 1 to RecVATAmountLine_l.Count do begin
            RecVATAmountLine_l.GetLine(IntI_l);
            AddVATLineToTab(RecVATAmountLine_l, TabRecVATAmountLine_p);
        end;
    end;

    [Scope('OnPrem')]
    procedure GetPurchaseOrderVAT(RecPurchaseHeader_p: Record "Purchase Header"; var DecVATAmount_p: Decimal; var DecVATBaseAmount_p: Decimal; var DecVATDiscountAmount_p: Decimal; var DecTotalAmountInclVAT_p: Decimal; var TabRecVATAmountLine_p: array[5] of Record "VAT Amount Line")
    var
        CUPurchasePost_l: Codeunit "Purch.-Post";
        RecPurchaseLine_l: Record "Purchase Line" temporary;
        RecVATAmountLine_l: Record "VAT Amount Line" temporary;
        IntI_l: Integer;
    begin
        //Absys AB - cette fonction permet le calcul facile des différents montants
        //relatifs à la TVA, ainsi que le remplissage d'un tableau contenant ces montants
        //pour les différentes TVA appliquées
        Clear(RecPurchaseLine_l);
        Clear(CUPurchasePost_l);
        RecVATAmountLine_l.DeleteAll;
        Clear(TabRecVATAmountLine_p);
        RecPurchaseLine_l.DeleteAll;
        CUPurchasePost_l.GetPurchLines(RecPurchaseHeader_p, RecPurchaseLine_l, 0);
        RecPurchaseLine_l.CalcVATAmountLines(0, RecPurchaseHeader_p, RecPurchaseLine_l, RecVATAmountLine_l);
        RecPurchaseLine_l.UpdateVATOnLines(0, RecPurchaseHeader_p, RecPurchaseLine_l, RecVATAmountLine_l);
        DecVATAmount_p := RecVATAmountLine_l.GetTotalVATAmount;
        DecVATBaseAmount_p := RecVATAmountLine_l.GetTotalVATBase;
        DecVATDiscountAmount_p := RecVATAmountLine_l.GetTotalVATDiscount(RecPurchaseHeader_p."Currency Code",
          RecPurchaseHeader_p."Prices Including VAT");
        DecTotalAmountInclVAT_p := RecVATAmountLine_l.GetTotalAmountInclVAT;

        if DecVATAmount_p = 0 then begin
            exit;
        end;

        RecVATAmountLine_l.CalcSums(
          RecVATAmountLine_l."Line Amount", RecVATAmountLine_l."Inv. Disc. Base Amount",
          RecVATAmountLine_l."Invoice Discount Amount", RecVATAmountLine_l."VAT Base (Lowered)", RecVATAmountLine_l."VAT Amount");

        for IntI_l := 1 to RecVATAmountLine_l.Count do begin
            RecVATAmountLine_l.GetLine(IntI_l);
            AddVATLineToTab(RecVATAmountLine_l, TabRecVATAmountLine_p);
        end;
    end;

    [Scope('OnPrem')]
    procedure AddVATLineToTab(RecVATAmountLine_p: Record "VAT Amount Line"; var TabRecVATAmountLine_p: array[5] of Record "VAT Amount Line")
    var
        IntI_l: Integer;
    begin
        //Cette fonction ajoute dans le tableau des lignes montant TVA la ligne passée en paramètre
        //le tout groupé par taux de TVA.

        IntI_l := 1;

        while (IntI_l <= 5)
          and (TabRecVATAmountLine_p[IntI_l]."VAT %" <> RecVATAmountLine_p."VAT %")
          and (TabRecVATAmountLine_p[IntI_l]."VAT Identifier" <> '') do begin
            IntI_l += 1;
        end;

        if TabRecVATAmountLine_p[IntI_l]."VAT Identifier" = '' then begin
            TabRecVATAmountLine_p[IntI_l] := RecVATAmountLine_p;
        end else begin
            TabRecVATAmountLine_p[IntI_l]."VAT Base" += RecVATAmountLine_p."VAT Base";
            TabRecVATAmountLine_p[IntI_l]."VAT Amount" += RecVATAmountLine_p."VAT Amount";
            TabRecVATAmountLine_p[IntI_l]."Amount Including VAT" += RecVATAmountLine_p."Amount Including VAT";
            TabRecVATAmountLine_p[IntI_l]."Line Amount" += RecVATAmountLine_p."Line Amount";
            TabRecVATAmountLine_p[IntI_l]."Inv. Disc. Base Amount" += RecVATAmountLine_p."Inv. Disc. Base Amount";
            TabRecVATAmountLine_p[IntI_l]."Invoice Discount Amount" += RecVATAmountLine_p."Invoice Discount Amount";
            TabRecVATAmountLine_p[IntI_l].Quantity += RecVATAmountLine_p.Quantity;
            TabRecVATAmountLine_p[IntI_l]."Calculated VAT Amount" += RecVATAmountLine_p."Calculated VAT Amount";
            TabRecVATAmountLine_p[IntI_l]."VAT Difference" += RecVATAmountLine_p."VAT Difference";
            TabRecVATAmountLine_p[IntI_l]."VAT Base (Lowered)" += RecVATAmountLine_p."VAT Base (Lowered)";
            TabRecVATAmountLine_p[IntI_l]."Pmt. Discount Amount" += RecVATAmountLine_p."Pmt. Discount Amount";
            //TabRecVATAmountLine_p[IntI_l].MODIFY;
        end;
    end;

    [Scope('OnPrem')]
    procedure GetSalesLines(var NewSalesHeader: Record "Sales Header"; var NewSalesLine: Record "Sales Line"; QtyType: Option General,Invoicing,Shipping)
    var
        OldSalesLine: Record "Sales Line";
    begin
        SalesHeader := NewSalesHeader;
        SumSalesLines2(NewSalesLine, OldSalesLine, QtyType, true);
    end;

    [Scope('OnPrem')]
    procedure GetSalesLinesTemp(var NewSalesHeader: Record "Sales Header"; var NewSalesLine: Record "Sales Line"; var OldSalesLine: Record "Sales Line"; QtyType: Option General,Invoicing,Shipping)
    begin
        SalesHeader := NewSalesHeader;
        OldSalesLine.SetSalesHeader(NewSalesHeader);
        SumSalesLines2(NewSalesLine, OldSalesLine, QtyType, true);
    end;

    [Scope('OnPrem')]
    procedure SumSalesLines(var NewSalesHeader: Record "Sales Header"; QtyType: Option General,Invoicing,Shipping; var NewTotalSalesLine: Record "Sales Line"; var NewTotalSalesLineLCY: Record "Sales Line"; var VATAmount: Decimal; var VATAmountText: Text[30]; var ProfitLCY: Decimal; var ProfitPct: Decimal)
    var
        OldSalesLine: Record "Sales Line";
    begin
        SumSalesLinesTemp(
          NewSalesHeader, OldSalesLine, QtyType, NewTotalSalesLine, NewTotalSalesLineLCY,
          VATAmount, VATAmountText, ProfitLCY, ProfitPct);
    end;

    [Scope('OnPrem')]
    procedure SumSalesLinesTemp(var NewSalesHeader: Record "Sales Header"; var OldSalesLine: Record "Sales Line"; QtyType: Option General,Invoicing,Shipping; var NewTotalSalesLine: Record "Sales Line"; var NewTotalSalesLineLCY: Record "Sales Line"; var VATAmount: Decimal; var VATAmountText: Text[30]; var ProfitLCY: Decimal; var ProfitPct: Decimal)
    var
        SalesLine: Record "Sales Line";
    begin
        with SalesHeader do begin
            SalesHeader := NewSalesHeader;
            SumSalesLines2(SalesLine, OldSalesLine, QtyType, false);
            ProfitLCY := TotalSalesLineLCY.Amount - TotalSalesLineLCY."Unit Cost (LCY)";
            if TotalSalesLineLCY.Amount = 0 then
                ProfitPct := 0
            else
                ProfitPct := Round(ProfitLCY / TotalSalesLineLCY.Amount * 100, 0.1);
            VATAmount := TotalSalesLine."Amount Including VAT" - TotalSalesLine.Amount;
            if TotalSalesLine."VAT %" = 0 then
                VATAmountText := Text016
            else
                VATAmountText := StrSubstNo(Text017, TotalSalesLine."VAT %");
            NewTotalSalesLine := TotalSalesLine;
            NewTotalSalesLineLCY := TotalSalesLineLCY;
        end;
    end;

    local procedure SumSalesLines2(var NewSalesLine: Record "Sales Line"; var OldSalesLine: Record "Sales Line"; QtyType: Option General,Invoicing,Shipping; InsertSalesLine: Boolean)
    var
        SalesLineQty: Decimal;
    begin
        /*TempVATAmountLineRemainder.DELETEALL;
        OldSalesLine.CalcVATAmountLines(QtyType,SalesHeader,OldSalesLine,TempVATAmountLine);
        WITH SalesHeader DO BEGIN
          GLSetup.GET;
          SalesSetup.GET;
          GetCurrency;
          OldSalesLine.SETRANGE("Document Type","Document Type");
          OldSalesLine.SETRANGE("Document No.","No.");
          OldSalesLine.SETFILTER(Commentaire,'%1',FALSE);
          RoundingLineInserted := FALSE;
          IF OldSalesLine.FIND('-') THEN
            REPEAT
              IF NOT RoundingLineInserted THEN
                SalesLine := OldSalesLine;
              CASE QtyType OF
                QtyType::General:
                  SalesLineQty := SalesLine.Quantity;
                QtyType::Invoicing:
                  SalesLineQty := SalesLine."Qty. to Invoice";
                QtyType::Shipping:
                  BEGIN
                    IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
                      SalesLineQty := SalesLine."Return Qty. to Receive"
                    ELSE
                      SalesLineQty := SalesLine."Qty. to Ship";
                  END;
              END;
              DivideAmount(QtyType,SalesLineQty);
              SalesLine.Quantity := SalesLineQty;
              IF SalesLineQty <> 0 THEN BEGIN
                IF (SalesLine.Amount <> 0) AND NOT RoundingLineInserted THEN
                  IF TotalSalesLine.Amount = 0 THEN
                    TotalSalesLine."VAT %" := SalesLine."VAT %"
                  ELSE
                    IF TotalSalesLine."VAT %" <> SalesLine."VAT %" THEN
                      TotalSalesLine."VAT %" := 0;
                RoundAmount(SalesLineQty);
                SalesLine := TempSalesLine;
              END;
              IF InsertSalesLine THEN BEGIN
                NewSalesLine := SalesLine;
                NewSalesLine.INSERT;
              END;
              IF RoundingLineInserted THEN
                LastLineRetrieved := TRUE
              ELSE BEGIN
                LastLineRetrieved := OldSalesLine.NEXT = 0;
                IF LastLineRetrieved AND SalesSetup."Invoice Rounding" THEN
                  InvoiceRounding(TRUE);
              END;
            UNTIL LastLineRetrieved;
        END;
         */

    end;

    local procedure GetCurrency()
    begin
        with SalesHeader do
            if "Currency Code" = '' then
                Currency.InitRoundingPrecision
            else begin
                Currency.Get("Currency Code");
                Currency.TestField("Amount Rounding Precision");
            end;
    end;

    local procedure DivideAmount(QtyType: Option General,Invoicing,Shipping; SalesLineQty: Decimal)
    begin
        if RoundingLineInserted and (RoundingLineNo = SalesLine."Line No.") then
            exit;
        with SalesLine do
            if SalesLineQty = 0 then begin
                "Line Amount" := 0;
                "Line Discount Amount" := 0;
                "Inv. Discount Amount" := 0;
                "VAT Base Amount" := 0;
                Amount := 0;
                "Amount Including VAT" := 0;
            end else begin
                TempVATAmountLine.Get("VAT Identifier", "VAT Calculation Type", "Tax Group Code", false, "Line Amount" >= 0);
                if "VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax" then
                    "VAT %" := TempVATAmountLine."VAT %";
                TempVATAmountLineRemainder := TempVATAmountLine;
                if not TempVATAmountLineRemainder.Find then begin
                    TempVATAmountLineRemainder.Init;
                    TempVATAmountLineRemainder.Insert;
                end;
                "Line Amount" := Round(SalesLineQty * "Unit Price", Currency."Amount Rounding Precision");
                if SalesLineQty <> Quantity then
                    "Line Discount Amount" :=
                      Round("Line Amount" * "Line Discount %" / 100, Currency."Amount Rounding Precision");
                "Line Amount" := "Line Amount" - "Line Discount Amount";

                if "Allow Invoice Disc." and (TempVATAmountLine."Inv. Disc. Base Amount" <> 0) then
                    if QtyType = QtyType::Invoicing then
                        "Inv. Discount Amount" := "Inv. Disc. Amount to Invoice"
                    else begin
                        TempVATAmountLineRemainder."Invoice Discount Amount" :=
                          TempVATAmountLineRemainder."Invoice Discount Amount" +
                          TempVATAmountLine."Invoice Discount Amount" * "Line Amount" /
                          TempVATAmountLine."Inv. Disc. Base Amount";
                        "Inv. Discount Amount" :=
                          Round(
                            TempVATAmountLineRemainder."Invoice Discount Amount", Currency."Amount Rounding Precision");
                        TempVATAmountLineRemainder."Invoice Discount Amount" :=
                          TempVATAmountLineRemainder."Invoice Discount Amount" - "Inv. Discount Amount";
                    end;

                if SalesHeader."Prices Including VAT" then begin
                    if (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount" = 0) or
                       ("Line Amount" = 0)
                    then begin
                        TempVATAmountLineRemainder."VAT Amount" := 0;
                        TempVATAmountLineRemainder."Amount Including VAT" := 0;
                    end else begin
                        TempVATAmountLineRemainder."VAT Amount" :=
                          TempVATAmountLineRemainder."VAT Amount" +
                          TempVATAmountLine."VAT Amount" *
                          ("Line Amount" - "Inv. Discount Amount") /
                          (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount");
                        TempVATAmountLineRemainder."Amount Including VAT" :=
                          TempVATAmountLineRemainder."Amount Including VAT" +
                          TempVATAmountLine."Amount Including VAT" *
                          ("Line Amount" - "Inv. Discount Amount") /
                          (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount");
                    end;
                    "Amount Including VAT" :=
                      Round(TempVATAmountLineRemainder."Amount Including VAT", Currency."Amount Rounding Precision");
                    Amount :=
                      Round("Amount Including VAT", Currency."Amount Rounding Precision") -
                      Round(TempVATAmountLineRemainder."VAT Amount", Currency."Amount Rounding Precision");
                    if ("VAT %" <> 0) and
                       (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount" <> 0)
                    then begin
                        TempVATAmountLineRemainder."VAT Base (Lowered)" :=
                          TempVATAmountLineRemainder."VAT Base (Lowered)" +
                          TempVATAmountLine."VAT Base" * (1 - SalesHeader."VAT Base Discount %" / 100) *
                          ("Line Amount" - "Inv. Discount Amount") /
                          (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount");
                        "VAT Base Amount" :=
                          Round(TempVATAmountLineRemainder."VAT Base (Lowered)", Currency."Amount Rounding Precision");
                        TempVATAmountLineRemainder."VAT Base (Lowered)" :=
                          TempVATAmountLineRemainder."VAT Base (Lowered)" - "VAT Base Amount";
                    end else
                        "VAT Base Amount" := Amount;
                    TempVATAmountLineRemainder."Amount Including VAT" :=
                      TempVATAmountLineRemainder."Amount Including VAT" - "Amount Including VAT";
                    TempVATAmountLineRemainder."VAT Amount" :=
                      TempVATAmountLineRemainder."VAT Amount" - "Amount Including VAT" + Amount;
                end else begin
                    if "VAT Calculation Type" = "VAT Calculation Type"::"Full VAT" then begin
                        "Amount Including VAT" := "Line Amount" - "Inv. Discount Amount";
                        Amount := 0;
                        "VAT Base Amount" := 0;
                    end else begin
                        Amount := "Line Amount" - "Inv. Discount Amount";
                        if ("VAT %" <> 0) and
                           (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount" <> 0)
                        then begin
                            TempVATAmountLineRemainder."VAT Base (Lowered)" :=
                              TempVATAmountLineRemainder."VAT Base (Lowered)" +
                              TempVATAmountLine."VAT Base" * (1 - SalesHeader."VAT Base Discount %" / 100) *
                              ("Line Amount" - "Inv. Discount Amount") /
                              (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount");
                            "VAT Base Amount" :=
                              Round(TempVATAmountLineRemainder."VAT Base (Lowered)", Currency."Amount Rounding Precision");
                            TempVATAmountLineRemainder."VAT Base (Lowered)" :=
                              TempVATAmountLineRemainder."VAT Base (Lowered)" - "VAT Base Amount";
                        end else
                            "VAT Base Amount" := Amount;
                        if TempVATAmountLine."VAT Base" = 0 then
                            TempVATAmountLineRemainder."VAT Amount" := 0
                        else
                            TempVATAmountLineRemainder."VAT Amount" :=
                             TempVATAmountLineRemainder."VAT Amount" +
                             TempVATAmountLine."VAT Amount" *
                             ("Line Amount" - "Inv. Discount Amount") /
                             (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount");
                        "Amount Including VAT" :=
                          Amount + Round(TempVATAmountLineRemainder."VAT Amount", Currency."Amount Rounding Precision");
                        TempVATAmountLineRemainder."VAT Amount" :=
                          TempVATAmountLineRemainder."VAT Amount" - "Amount Including VAT" + Amount;
                    end;
                end;

                if TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount" <> 0 then begin
                    TempVATAmountLineRemainder."Pmt. Discount Amount" :=
                      TempVATAmountLineRemainder."Pmt. Discount Amount" +
                      TempVATAmountLine."VAT Base" * SalesHeader."Payment Discount %" / 100 *
                      ("Line Amount" - "Inv. Discount Amount") /
                      (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount");
                    "Pmt. Discount Amount" :=
                      Round(TempVATAmountLineRemainder."Pmt. Discount Amount", Currency."Amount Rounding Precision");
                    TempVATAmountLineRemainder."Pmt. Discount Amount" :=
                      TempVATAmountLineRemainder."Pmt. Discount Amount" - "Pmt. Discount Amount";
                end;

                TempVATAmountLineRemainder.Modify;
            end;
    end;

    local procedure RoundAmount(SalesLineQty: Decimal)
    var
        NoVAT: Boolean;
    begin
        with SalesLine do begin
            IncrAmount(TotalSalesLine);
            Increment(TotalSalesLine."Net Weight", Round(SalesLineQty * "Net Weight", 0.00001));
            Increment(TotalSalesLine."Gross Weight", Round(SalesLineQty * "Gross Weight", 0.00001));
            Increment(TotalSalesLine."Unit Volume", Round(SalesLineQty * "Unit Volume", 0.00001));
            Increment(TotalSalesLine.Quantity, SalesLineQty);
            if "Units per Parcel" > 0 then
                Increment(
                  TotalSalesLine."Units per Parcel",
                  Round(SalesLineQty / "Units per Parcel", 1, '>'));

            TempSalesLine := SalesLine;
            SalesLineACY := SalesLine;

            if SalesHeader."Currency Code" <> '' then begin
                if ("Document Type" in ["Document Type"::"Blanket Order", "Document Type"::Quote]) and
                   (SalesHeader."Posting Date" = 0D)
                then
                    UseDate := WorkDate
                else
                    UseDate := SalesHeader."Posting Date";

                NoVAT := Amount = "Amount Including VAT";
                "Amount Including VAT" :=
                  Round(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      UseDate, SalesHeader."Currency Code",
                      TotalSalesLine."Amount Including VAT", SalesHeader."Currency Factor")) -
                        TotalSalesLineLCY."Amount Including VAT";
                if NoVAT then
                    Amount := "Amount Including VAT"
                else
                    Amount :=
                      Round(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          UseDate, SalesHeader."Currency Code",
                          TotalSalesLine.Amount, SalesHeader."Currency Factor")) -
                            TotalSalesLineLCY.Amount;
                "Line Amount" :=
                  Round(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      UseDate, SalesHeader."Currency Code",
                      TotalSalesLine."Line Amount", SalesHeader."Currency Factor")) -
                        TotalSalesLineLCY."Line Amount";
                "Line Discount Amount" :=
                  Round(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      UseDate, SalesHeader."Currency Code",
                      TotalSalesLine."Line Discount Amount", SalesHeader."Currency Factor")) -
                        TotalSalesLineLCY."Line Discount Amount";
                "Inv. Discount Amount" :=
                  Round(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      UseDate, SalesHeader."Currency Code",
                      TotalSalesLine."Inv. Discount Amount", SalesHeader."Currency Factor")) -
                        TotalSalesLineLCY."Inv. Discount Amount";
                "VAT Difference" :=
                  Round(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      UseDate, SalesHeader."Currency Code",
                      TotalSalesLine."VAT Difference", SalesHeader."Currency Factor")) -
                        TotalSalesLineLCY."VAT Difference";
                "VAT Base Amount" :=
                  Round(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      UseDate, SalesHeader."Currency Code",
                      TotalSalesLine."VAT Base Amount", SalesHeader."Currency Factor")) -
                        TotalSalesLineLCY."VAT Base Amount";
                "Pmt. Discount Amount" :=
                  Round(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      UseDate, SalesHeader."Currency Code",
                      TotalSalesLine."Pmt. Discount Amount", SalesHeader."Currency Factor")) -
                        TotalSalesLineLCY."Pmt. Discount Amount";
            end;

            IncrAmount(TotalSalesLineLCY);
            Increment(TotalSalesLineLCY."Unit Cost (LCY)", Round(SalesLineQty * "Unit Cost (LCY)"));
        end;
    end;

    local procedure InvoiceRounding(UseTempData: Boolean)
    var
        InvoiceRoundingAmount: Decimal;
        NextLineNo: Integer;
    begin
        Currency.TestField("Invoice Rounding Precision");
        InvoiceRoundingAmount :=
          -Round(
            TotalSalesLine."Amount Including VAT" -
            Round(
              TotalSalesLine."Amount Including VAT",
              Currency."Invoice Rounding Precision",
              Currency.InvoiceRoundingDirection),
            Currency."Amount Rounding Precision");
        if InvoiceRoundingAmount <> 0 then begin
            CustPostingGr.Get(SalesHeader."Customer Posting Group");
            CustPostingGr.TestField("Invoice Rounding Account");
            with SalesLine do begin
                Init;
                NextLineNo := "Line No." + 10000;
                "System-Created Entry" := true;
                if UseTempData then begin
                    "Line No." := 0;
                    Type := Type::"G/L Account";
                end else begin
                    "Line No." := NextLineNo;
                    Validate(Type, Type::"G/L Account");
                end;
                Validate("No.", CustPostingGr."Invoice Rounding Account");
                Validate(Quantity, 1);
                Validate(
                  "Unit Price",
                  Round(
                    InvoiceRoundingAmount /
                    (1 + (1 - SalesHeader."VAT Base Discount %" / 100) * "VAT %" / 100),
                    Currency."Amount Rounding Precision"));
                Validate("Amount Including VAT", InvoiceRoundingAmount);
                "Line No." := NextLineNo;

                LastLineRetrieved := false;
                RoundingLineInserted := true;
                RoundingLineNo := "Line No.";
            end;
        end;
    end;

    local procedure IncrAmount(var TotalSalesLine: Record "Sales Line")
    begin
        with SalesLine do begin
            if SalesHeader."Prices Including VAT" or
               ("VAT Calculation Type" <> "VAT Calculation Type"::"Full VAT")
            then
                Increment(TotalSalesLine."Line Amount", "Line Amount");
            Increment(TotalSalesLine.Amount, Amount);
            Increment(TotalSalesLine."VAT Base Amount", "VAT Base Amount");
            Increment(TotalSalesLine."VAT Difference", "VAT Difference");
            Increment(TotalSalesLine."Amount Including VAT", "Amount Including VAT");
            Increment(TotalSalesLine."Line Discount Amount", "Line Discount Amount");
            Increment(TotalSalesLine."Inv. Discount Amount", "Inv. Discount Amount");
            Increment(TotalSalesLine."Inv. Disc. Amount to Invoice", "Inv. Disc. Amount to Invoice");
            Increment(TotalSalesLine."Pmt. Discount Amount", "Pmt. Discount Amount");
        end;
    end;

    local procedure Increment(var Number: Decimal; Number2: Decimal)
    begin
        Number := Number + Number2;
    end;

    [Scope('OnPrem')]
    procedure Navision2Ascii(TexteNavision: Text[250]): Text[250]
    begin
        MakeVars;
        exit(ConvertStr(TexteNavision, TxtAsciiStr_g, TxtAnsiStr_g));
    end;

    [Scope('OnPrem')]
    procedure Ascii2Navision(TexteAscii: Text[250]): Text[250]
    begin
        MakeVars;
        exit(ConvertStr(TexteAscii, TxtAnsiStr_g, TxtAsciiStr_g));
    end;

    [Scope('OnPrem')]
    procedure MakeVars()
    begin
        TxtAsciiStr_g := 'ÇüéâäàåçêëèïîìÄÅÉæÆôöòûùÿÖÜø£Ø×ƒáíóúñÑªº¿®¬½¼¡«»¦¦¦¦¦ÁÂÀ©¦¦++¢¥++--+-+ãÃ++--¦-+' +
          '¤ðÐÊËÈiÍÎÏ++¦_¦Ì¯ÓßÔÒõÕµþÞÚÛÙýÝ¯´­±=¾¶§÷¸°¨·¹³²¦ ';
        TxtCharVar_g[1] := 196;
        TxtCharVar_g[2] := 197;
        TxtCharVar_g[3] := 201;
        TxtCharVar_g[4] := 242;
        TxtCharVar_g[5] := 220;
        TxtCharVar_g[6] := 186;
        TxtCharVar_g[7] := 191;
        TxtCharVar_g[8] := 188;
        TxtCharVar_g[9] := 187;
        TxtCharVar_g[10] := 193;
        TxtCharVar_g[11] := 194;
        TxtCharVar_g[12] := 192;
        TxtCharVar_g[13] := 195;
        TxtCharVar_g[14] := 202;
        TxtCharVar_g[15] := 203;
        TxtCharVar_g[16] := 200;
        TxtCharVar_g[17] := 205;
        TxtCharVar_g[18] := 206;
        TxtCharVar_g[19] := 204;
        TxtCharVar_g[20] := 175;
        TxtCharVar_g[21] := 223;
        TxtCharVar_g[22] := 213;
        TxtCharVar_g[23] := 254;
        TxtCharVar_g[24] := 218;
        TxtCharVar_g[25] := 219;
        TxtCharVar_g[26] := 217;
        TxtCharVar_g[27] := 180;
        TxtCharVar_g[28] := 177;
        TxtCharVar_g[29] := 176;
        TxtCharVar_g[30] := 185;
        TxtCharVar_g[31] := 179;
        TxtCharVar_g[32] := 178;
        TxtAnsiStr_g := 'Ã³ÚÔõÓÕþÛÙÞ´¯ý' + Format(TxtCharVar_g[1]) + Format(TxtCharVar_g[2]) + Format(TxtCharVar_g[3]) + 'µã¶÷' +
          Format(TxtCharVar_g[4]) + '¹¨ Í' + Format(TxtCharVar_g[5]) + '°úÏÎâßÝ¾·±Ð¬' + Format(TxtCharVar_g[6]) + Format(TxtCharVar_g[7]) +
          '«¼¢' + Format(TxtCharVar_g[8]) + 'í½' + Format(TxtCharVar_g[9]) + '___ªª' + Format(TxtCharVar_g[10]) +
          Format(TxtCharVar_g[11]) + Format(TxtCharVar_g[12]) + '®ªª++óÑ++--+-+Ò' + Format(TxtCharVar_g[13]) + '++--ª-+ñ­ð' +
          Format(TxtCharVar_g[14]) + Format(TxtCharVar_g[15]) + Format(TxtCharVar_g[16]) + 'i' + Format(TxtCharVar_g[17]) +
          Format(TxtCharVar_g[18]) + '¤++__ª' + Format(TxtCharVar_g[19]) + Format(TxtCharVar_g[20]) + 'Ë' + Format(TxtCharVar_g[21]) + 'ÈÊ§' +
          Format(TxtCharVar_g[22]) + 'Á' + Format(TxtCharVar_g[23]) + 'Ì' + Format(TxtCharVar_g[24]) + Format(TxtCharVar_g[25]) +
          Format(TxtCharVar_g[26]) + '²¦»' + Format(TxtCharVar_g[27]) + '¡' + Format(TxtCharVar_g[28]) + '=¥Âº¸©' +
          Format(TxtCharVar_g[29]) + '¿À' + Format(TxtCharVar_g[30]) + Format(TxtCharVar_g[31]) + Format(TxtCharVar_g[32]) + '_ ';
    end;

    [Scope('OnPrem')]
    procedure IsBeBankNoOk(tBankNo: Text[30]): Boolean
    var
        dCptNo: Decimal;
        iChkDigit: Integer;
        iModulo: Integer;
        dBankNo: Decimal;
        dValPart1: Decimal;
        dValPart2: Decimal;
        iError: Integer;
    begin
        // Retourne TRUE si le No. de banque tBankNo est un numéro de banque Belge correct
        // Accepte les formes composées de 12 chiffres et des séparateurs '.','-','/' ou ' '
        // Ex: "999-9999999-99"  "999.9999999.99"  "999/9999999/99"  "999999999999"
        //
        // Rem: Tous les séparateurs sont ôtés de l'expression avant son analyse...
        //      Accepte aussi toute expression du genre "99  999-99.99 /999" mais cette
        //      forme ne devrait normalement pas être utilisée pour représenter un numéro
        //      de banque Belge.
        //
        // tBankNo à blanc est considéré comme correct.

        if tBankNo = '' then
            exit(true);

        // Retirer les caractères séparateurs
        tBankNo := DelChr(tBankNo, '=', '.-/ ');
        if tBankNo = '' then
            // Rien que des séparateurs dans l'expression!!!
            exit(false);

        if StrLen(tBankNo) <> 12 then
            exit(false);

        dBankNo := Text2Decimal(tBankNo, iError);
        if dBankNo = 0 then
            // 000-0000000-00 -> numéro non admis
            // ou il reste dans l'expression tBankNo des caractères autres que les chiffres
            exit(false);

        dValPart1 := Text2Integer(CopyStr(tBankNo, 1, 3), iError);
        if iError <> 0 then
            exit(false);
        dValPart2 := Text2Integer(CopyStr(tBankNo, 4, 7), iError);
        if iError <> 0 then
            exit(false);
        dCptNo := (10000000 * dValPart1) + dValPart2;

        iChkDigit := Text2Integer(CopyStr(tBankNo, 11, 2), iError);
        if iError <> 0 then
            exit(false);

        if iChkDigit = 97 then
            // Les numéros de comptes terminés par 97 correspondent en fait à des
            // numéros qui auraient du avoir 00 comme Check-Digit.
            // Mais aucun compte n'est terminé par le suffixe 00...
            iChkDigit := 0;

        iModulo := (dCptNo mod 97);

        exit(iModulo = iChkDigit);
    end;

    [Scope('OnPrem')]
    procedure Text2Boolean(tVal: Text[250]; var iError: Integer) bVal: Boolean
    begin
        if not Evaluate(bVal, tVal) then begin
            iError := 1;
            bVal := false;
        end
        else
            iError := 0;

        exit(bVal);
    end;

    [Scope('OnPrem')]
    procedure Text2Integer(tVal: Text[250]; var iError: Integer) iVal: Integer
    begin
        if not Evaluate(iVal, tVal) then begin
            iError := 1;
            iVal := 0;
        end
        else
            iError := 0;

        exit(iVal);
    end;

    [Scope('OnPrem')]
    procedure Text2BigInteger(tVal: Text[250]; var iError: Integer) iVal: BigInteger
    begin
        if not Evaluate(iVal, tVal) then begin
            iError := 1;
            iVal := 0;
        end
        else
            iError := 0;

        exit(iVal);
    end;

    [Scope('OnPrem')]
    procedure Text2Decimal(tDecimal: Text[250]; var iError: Integer) dDecimal: Decimal
    begin
        if not Evaluate(dDecimal, tDecimal) then begin
            iError := 1;
            dDecimal := 0;
        end
        else
            iError := 0;

        exit(dDecimal);
    end;

    [Scope('OnPrem')]
    procedure Text2Date(tDate: Text[30]; var iError: Integer) dtDate: Date
    begin
        // Cette fonction est utile lorsque le format n'est pas spécialement
        // défini et donc il peut varier de machine à machine en fonction
        // des regionals settings. Il est alors important de travailler sur
        // la même machine (en import et en export de fichier).

        if not Evaluate(dtDate, tDate) then begin
            iError := 1;
            dtDate := 0D;
        end
        else
            iError := 0;

        exit(dtDate);
    end;

    [Scope('OnPrem')]
    procedure Decimal2Text(dInValue: Decimal): Text[250]
    begin
        // Retourne la valeur de dInValue exprimée en caractères
        // sans séparateur de millier ou autres...
        exit(Format(dInValue, 0, 1));
    end;

    [Scope('OnPrem')]
    procedure DayOfMonth(dtIn: Date): Integer
    begin
        exit(Date2DMY(dtIn, 1));
    end;

    [Scope('OnPrem')]
    procedure Year(dtIn: Date): Integer
    begin
        exit(Date2DMY(dtIn, 3));
    end;

    [Scope('OnPrem')]
    procedure Month(dtIn: Date): Integer
    begin
        exit(Date2DMY(dtIn, 2));
    end;

    [Scope('OnPrem')]
    procedure "****** ART-001 *************"()
    begin
    end;

    [Scope('OnPrem')]
    procedure GenerationEAN(RecItem_p: Record Item)
    var
        RecCompanyInfo_l: Record "Company Information";
        RecItemCat_l: Record "Item Category";
        RecItem_l: Record Item;
        TxtNumber_l: Text[12];
        NumLastSeq_l: Integer;
        NumCategorie_l: Integer;
        TxtNumSeq_l: Text[3];
        IntCheckSum_l: Integer;
        CodeEAN_l: Code[13];
    begin
        //--> ART-001 ABSYS GN 20061016
        with RecItem_p do begin
            //-- Récupération du Code Génération EAN IDC --
            if RecCompanyInfo_l.Get then
                if RecCompanyInfo_l."Code Génération EAN Company" = '' then
                    Error(Text50004, RecCompanyInfo_l.Name);

            //-- Récupération du Code Génération EAN de la catégorie article --
            if RecItem_p."Item Category Code" <> '' then begin
                if RecItemCat_l.Get(RecItem_p."Item Category Code") then begin
                    if RecItemCat_l."Code Generation  EAN" = '' then begin
                        Error(Text50003, RecItemCat_l.Description);
                    end;
                end else begin
                    Error(Text50002);
                end;
            end else begin
                Error(Text50000);
            end;

            //-- Recherche du dernier code ENA pour cette catégorie d'article --
            if RecItemCat_l."Last sequential EAN Code" = '' then begin
                RecItemCat_l."Last sequential EAN Code" := '0';
                RecItemCat_l.Modify;
            end;
            Evaluate(NumLastSeq_l, RecItemCat_l."Last sequential EAN Code");
            Evaluate(NumCategorie_l, RecItemCat_l."Code Generation  EAN");
            NumLastSeq_l := NumLastSeq_l + 1;
            if NumLastSeq_l > 999 then begin
                Error(Text50001);
            end;

            TxtNumSeq_l := StrSubstNo('%1', NumLastSeq_l);
            case StrLen(TxtNumSeq_l) of
                1:
                    TxtNumSeq_l := '00' + TxtNumSeq_l;
                2:
                    TxtNumSeq_l := '0' + TxtNumSeq_l;
            end;

            //-- Génération Du code EAN avec CheckSum --
            TxtNumber_l := RecCompanyInfo_l."Code Génération EAN Company" + RecItemCat_l."Code Generation  EAN" + TxtNumSeq_l;
            IntCheckSum_l := StrCheckSum(TxtNumber_l, '131313131313');
            CodeEAN_l := StrSubstNo('%1%2', TxtNumber_l, IntCheckSum_l);

            //-- Enregistrement Code EAN -- PAS REPRIS (Un seul champ EAN)
            "EAN13 Code" := CodeEAN_l;

            Modify;
            RecItemCat_l."Last sequential EAN Code" := StrSubstNo('%1', NumLastSeq_l);
            RecItemCat_l.Modify;
        end;
        //<-- ART-001 ABSYS GN 20061016
    end;

    [Scope('OnPrem')]
    procedure TestStatsecurity(RecStandardStatistic: Record "Standard statistic"): Boolean
    var
        RecStatisticPermission: Record "Statistic Permission";
    begin

        RecStatisticPermission.Reset;
        RecStatisticPermission.SetRange(Type, RecStatisticPermission.Type::Statistique);
        RecStatisticPermission.SetRange(Code, RecStandardStatistic.Code);
        if RecStatisticPermission.Find('-') then
            repeat
                if GetRole(RecStatisticPermission."Authorized group") then
                    exit(true);
            until RecStatisticPermission.Next = 0;

        RecStatisticPermission.SetRange(Type, RecStatisticPermission.Type::"Catégorie");
        RecStatisticPermission.SetRange(Code, RecStandardStatistic.Catégory);
        if RecStatisticPermission.Find('-') then
            repeat
                if GetRole(RecStatisticPermission."Authorized group") then
                    exit(true);
            until RecStatisticPermission.Next = 0;

        exit(false);
    end;
}

