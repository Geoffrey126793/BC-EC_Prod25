codeunit 50016 "Calc. Sales CredMem Disc."
{
    // // Absys GJ 12/04/05 --> copie du 50013 et modif pour Cred. Memo.
    // 
    // //COMREMISE GESWAY 11/07/02 Nouveau codeunit
    // 
    // // Absys ->
    // 
    //   ADV.5 FH : Gestion de l'affichage des lois de remise sur fact/avoirab
    // 
    //   ADV.6 FH : Gestion des gratuits
    //   - Ajout de la gestion du champ filtre code gratuit
    // 
    //   ADV.7 FH : Gestion de la base spécifique.
    // 
    //   ADV.8 FH : Gestion des prévision de promotion
    // 
    //   NW300804 : Correction bug cumulable = non
    // 
    //   ADV.22 GJ : Gestion des remises de type RFA
    // 
    // // Absys <-


    trigger OnRun()
    begin
    end;

    var
        Text001: Label 'No Discount or Commission available in then Discount Setup.';
        DiscountSetup: Record "Disc. Commission Setup";
        Rule: Record "Discount Rule";
        DiscBuffer: Record "Disc. Commission Buffer";
        SaleDiscLineEntry: Record "Posted Sales Discount Entry";
        Currency: Record Currency;
        Cust: Record Customer;
        SalesCredMemHeader2: Record "Sales Cr.Memo Header";
        SalesCredMemLine2: Record "Sales Cr.Memo Line";
        PurchHeader2: Record "Purchase Header";
        PurchLine2: Record "Purchase Line";
        BasisLCY: Decimal;
        Basis: Decimal;
        Com: Decimal;
        ComLCY: Decimal;
        TotalLineDisc: Decimal;
        TotalFootDisc: Decimal;
        TotalRFADisc: Decimal;
        TotalCom: Decimal;
        TotalLineDiscLCY: Decimal;
        TotalFootDiscLCY: Decimal;
        TotalRFADiscLCY: Decimal;
        TotalComLCY: Decimal;
        MinAmount: Decimal;
        MaxAmount: Decimal;
        AmountLCY: Decimal;
        SourceAmount: Decimal;
        Coeff: Decimal;
        CoeffLCY: Decimal;
        Date1: Date;
        Date2: Date;
        StatSetupShortcutDimCode: array[20] of Code[20];
        RuleDimFilter: array[20] of Text[100];
        ExistDim: Boolean;
        "RemiseAppliquée": Boolean;
        Text50002: Label 'La quantité (base) %1  saisie sur la commande %2 article %3 \dépasse la Qté (base ) maxi de %4 de la loi %5. \La maximum autorisé sur cette ligne est %6. \Le reste doit être saisi sur une autre ligne.';

    [Scope('OnPrem')]
    procedure DiscountSaleLine(SaleCredMemLine: Record "Sales Cr.Memo Line")
    var
        CurExchRate: Record "Currency Exchange Rate";
        SalesCredMemHeader: Record "Sales Cr.Memo Header";
        SaleCredMemLineTmp: Record "Sales Cr.Memo Line" temporary;
        l_postedCrMemoDiscount: Record "Posted Sales Discount Entry";
    begin
        TotalLineDisc := 0;
        TotalFootDisc := 0;
        TotalRFADisc := 0;
        TotalCom := 0;
        TotalLineDiscLCY := 0;
        TotalFootDiscLCY := 0;
        TotalRFADiscLCY := 0;
        TotalComLCY := 0;

        DiscountSetup.Get;
        Rule.Reset;


        if ((not DiscountSetup."Calculate Sales Line Discount") and (not DiscountSetup."Calc. Sales Line Back Disc.") and
            (not DiscountSetup."Calc. Sales Line Commission")) then begin
            Message(Text001);
            exit;
        end;

        // Absys AM
        l_postedCrMemoDiscount.Reset;
        l_postedCrMemoDiscount.SetRange(l_postedCrMemoDiscount."Document Type",
                                        l_postedCrMemoDiscount."Document Type"::"Posted Credit Memo");
        l_postedCrMemoDiscount.SetRange(l_postedCrMemoDiscount."Document No.",
                                        SaleCredMemLine."Document No.");
        l_postedCrMemoDiscount.SetRange(l_postedCrMemoDiscount."Line No.",
                                        SaleCredMemLine."Line No.");
        l_postedCrMemoDiscount.SetFilter(l_postedCrMemoDiscount."Disc. Commission Type", '=%1',
                                         l_postedCrMemoDiscount."Disc. Commission Type"::"Footer Discount");
        if l_postedCrMemoDiscount.Find('-') then begin
            repeat
                InitDiscount(l_postedCrMemoDiscount);
            until l_postedCrMemoDiscount.Next = 0;
        end;
        // Absys AM

        // Absys FH - ADV.22 ->
        // seul RFA et Commission sont (autorisés à être) calculés
        //...plus besoin de refaire des tests lors des INSERT et MODIFY
        DiscountSetup."Calculate Sales Line Discount" := false;
        // Absys FH - ADV.22 <-

        if not DiscountSetup."Calculate Sales Line Discount" then begin
            if not DiscountSetup."Calc. Sales Line Back Disc." then begin
                if not DiscountSetup."Calc. Sales Line Commission" then
                    exit
                else
                    Rule.SetFilter("Discount and comm. type", '%1',
                                    Rule."Discount and comm. type"::Commission);
            end else begin
                if not DiscountSetup."Calc. Sales Line Commission" then
                    Rule.SetFilter("Discount and comm. type", '%1',
                                    Rule."Discount and comm. type"::"Back discount")
                else
                    Rule.SetFilter("Discount and comm. type", '>=%1',
                                    Rule."Discount and comm. type"::"Back discount");
            end;
        end else begin
            if not DiscountSetup."Calc. Sales Line Back Disc." then begin
                if not DiscountSetup."Calc. Sales Line Commission" then begin
                    if ((SaleCredMemLine."Allow Invoice Disc." and (SaleCredMemLine.Type = SaleCredMemLine.Type::Item)) or
                        (SaleCredMemLine.Type <> SaleCredMemLine.Type::Item)) then
                        Rule.SetFilter("Discount and comm. type", '<=%1',
                                        Rule."Discount and comm. type"::"Footer discount")
                    else
                        Rule.SetRange("Discount and comm. type",
                                       Rule."Discount and comm. type"::"Line discount");
                end else begin
                    if ((SaleCredMemLine."Allow Invoice Disc." and (SaleCredMemLine.Type = SaleCredMemLine.Type::Item)) or
                        (SaleCredMemLine.Type <> SaleCredMemLine.Type::Item)) then
                        Rule.SetFilter("Discount and comm. type", '<>%1',
                                        Rule."Discount and comm. type"::"Back discount")
                    else
                        Rule.SetFilter("Discount and comm. type", '%1|%2',
                                        Rule."Discount and comm. type"::"Line discount",
                                        Rule."Discount and comm. type"::Commission);
                end;
            end else begin
                if not DiscountSetup."Calc. Sales Line Commission" then begin
                    if ((SaleCredMemLine."Allow Invoice Disc." and (SaleCredMemLine.Type = SaleCredMemLine.Type::Item)) or
                        (SaleCredMemLine.Type <> SaleCredMemLine.Type::Item)) then
                        Rule.SetFilter("Discount and comm. type", '<>%1',
                                        Rule."Discount and comm. type"::Commission)
                    else
                        Rule.SetFilter("Discount and comm. type", '<>%1&<>%2', Rule."Discount and comm. type"::"Footer discount",
                                        Rule."Discount and comm. type"::Commission);
                end else begin
                    if ((not SaleCredMemLine."Allow Invoice Disc.") and (SaleCredMemLine.Type = SaleCredMemLine.Type::Item)) then
                        Rule.SetFilter("Discount and comm. type", '<>%1',
                                        Rule."Discount and comm. type"::"Footer discount");
                end;
            end;
        end;

        Rule.SetRange(Type, Rule.Type::Sale);
        Rule.SetFilter("Type Filter", '%1|%2', Rule."Type Filter"::All, SaleCredMemLine.Type);

        SalesCredMemHeader.Get(SaleCredMemLine."Document No.");

        //Pour les devis et cdes prévisionnelles, la date de comptabilisation
        //est renseignée avec la date de document

        SalesCredMemHeader."Posting Date" := SalesCredMemHeader."Document Date";

        // Absys FH -> date de commande au lieu de la date de compta si cmd
        SalesCredMemHeader."Posting Date" := SalesCredMemHeader."Posting Date";
        // Absys FH <-

        Rule.SetFilter("Starting Date", '<=%1', SalesCredMemHeader."Posting Date");
        Rule.SetFilter("Ending Date", '>=%1', SalesCredMemHeader."Posting Date");

        if not Rule.Find('-') then
            exit
        else begin
            SearchDim;

            SaleCredMemLineTmp.DeleteAll;
            SalesCredMemLine2.SetRange("Document No.", SaleCredMemLine."Document No.");
            SalesCredMemLine2.SetRange("Line No.", SaleCredMemLine."Line No.");

            repeat

                // NW300804 ->
                RemiseAppliquée := false;
                // NW300804 <-

                //Conversion du coefficient
                if (Rule."Calc method" = Rule."Calc method"::"Quantité * Coefficient") or
                   (Rule."Calc method" = Rule."Calc method"::"Quantité (base) * Coefficient") then
                    Coeff := CurExchRate.ExchangeAmtLCYToFCY(
                               SalesCredMemHeader."Posting Date", SalesCredMemHeader."Currency Code",
                               Rule.Coefficient, SalesCredMemHeader."Currency Factor")
                else
                    Coeff := Rule.Coefficient;

                CoeffLCY := Rule.Coefficient;
                if SalesCredMemHeader."Currency Code" <> '' then begin
                    Currency.Get(SalesCredMemHeader."Currency Code");
                    AmountLCY := CurExchRate.ExchangeAmtFCYToLCY(
                                   SalesCredMemHeader."Posting Date", SalesCredMemHeader."Currency Code",
                                   SaleCredMemLine."Line Amount", SalesCredMemHeader."Currency Factor");
                end else begin
                    Currency.Init;
                    AmountLCY := SaleCredMemLine."Line Amount";
                end;
                SourceAmount := SaleCredMemLine."Line Amount";

                if (Rule."Amount Filter (LCY)" <> '') then begin
                    if (SalesCredMemHeader."Currency Code" = '') then begin
                        SalesCredMemLine2.SetFilter(Amount, Rule."Amount Filter (LCY)");
                        SearchSale(SaleCredMemLine);
                    end else begin
                        SaleCredMemLineTmp := SaleCredMemLine;
                        SaleCredMemLineTmp.Amount := AmountLCY;


                        SaleCredMemLineTmp.Insert;


                        SaleCredMemLineTmp.SetRange("Document No.", SaleCredMemLine."Document No.");
                        SaleCredMemLineTmp.SetRange("Line No.", SaleCredMemLine."Line No.");
                        SaleCredMemLineTmp.SetFilter("Line Amount", Rule."Amount Filter (LCY)");
                        if SaleCredMemLineTmp.Find('-') then
                            SearchSale(SaleCredMemLine);
                    end;
                end else begin
                    SalesCredMemLine2.SetFilter("Line Amount", Rule."Amount filter");
                    SearchSale(SaleCredMemLine);
                end;
                if not SearchNextRule(SaleCredMemLine."Allow Invoice Disc.", SaleCredMemLine.Type.AsInteger()) then
                    exit;
            until Rule.Next = 0;
        end;
    end;

    [Scope('OnPrem')]
    procedure SearchSale(SaleCredMemLine: Record "Sales Cr.Memo Line")
    begin
        SalesCredMemHeader2.SetRange("No.", SaleCredMemLine."Document No.");
        SalesCredMemHeader2.SetFilter("Salesperson Code", Rule."Salespers./Purch. Filter");
        SalesCredMemHeader2.SetFilter("Customer Posting Group", Rule."Source Posting Group Filter");
        SalesCredMemHeader2.SetFilter("Gen. Bus. Posting Group", Rule."Gen. Bus. Posting Group filter");
        SalesCredMemHeader2.SetFilter("Customer Price Group", Rule."Price code filter");
        SalesCredMemHeader2.SetFilter("Customer Disc. Group", Rule."Cust./Item Disc. Gr. filter");
        SalesCredMemHeader2.SetFilter("Bill-to Customer No.", Rule."Source Filter");
        SalesCredMemHeader2.SetFilter("Reason Code", Rule."Reason Code filter");
        SalesCredMemHeader2.SetFilter("Currency Code", Rule."Currency Filter");
        if SalesCredMemHeader2.Find('-') then begin
            //Customer Criteria
            Cust.Reset;
            Cust.SetFilter("No.", SalesCredMemHeader2."Bill-to Customer No.");
            Cust.SetFilter("Criteria 1", Rule."Customer criteria filter 1");
            Cust.SetFilter("Criteria 2", Rule."Customer criteria filter 2");
            Cust.SetFilter("Criteria 3", Rule."Customer criteria filter 3");
            Cust.SetFilter("Criteria 4", Rule."Customer criteria filter 4");
            Cust.SetFilter("Criteria 5", Rule."Customer criteria filter 5");
            Cust.SetFilter("Criteria 6", Rule."Customer criteria filter 6");
            Cust.SetFilter("Criteria 7", Rule."Customer criteria filter 7");
            Cust.SetFilter("Criteria 8", Rule."Customer criteria filter 8");
            Cust.SetFilter("Criteria 9", Rule."Customer criteria filter 9");
            Cust.SetFilter("Criteria 10", Rule."Customer criteria filter 10");

            if Cust.Find('-') then begin
                SalesCredMemLine2.SetFilter("Shortcut Dimension 1 Code", Rule."Global Dimension 1 Filter");
                SalesCredMemLine2.SetFilter("Shortcut Dimension 2 Code", Rule."Global Dimension 2 Filter");
                SalesCredMemLine2.SetFilter("Gen. Prod. Posting Group", Rule."Gen.Prod. Posting Group filter");
                SalesCredMemLine2.SetFilter("Posting Group", Rule."Inventory Posting Group filter");
                SalesCredMemLine2.SetFilter("No.", Rule."No. filter");
                SalesCredMemLine2.SetFilter(Quantity, Rule."Quantity filter");
                SalesCredMemLine2.SetFilter("Job No.", Rule."Job Filter");
                SalesCredMemLine2.SetFilter("Return Reason Code", Rule."Return Reason Code Filter");

                // Absys ADV.6 ADV.17 ->
                SalesCredMemLine2.SetFilter("Reason Free Code", Rule."Free Code Filter");
                SalesCredMemLine2.SetFilter("Special Discount Code", Rule."Special Discount Filter");
                SalesCredMemLine2.SetRange("Allow Invoice Disc.", true);
                // Absys ADV.6 ADV.17 <-

                if SalesCredMemLine2.Find('-') then
                    if GetDimFilter(115, SalesCredMemLine2."Document No.", SalesCredMemLine2."Line No.") then begin
                        case SalesCredMemLine2.Type of
                            SalesCredMemLine2.Type::Item:
                                if GetItemFilter(SalesCredMemLine2."No.") then
                                    InsertSaleDiscount(SalesCredMemLine2);
                            SalesCredMemLine2.Type::"G/L Account", SalesCredMemLine2.Type::Resource, SalesCredMemLine2.Type::"Charge (Item)":
                                InsertSaleDiscount(SalesCredMemLine2);
                        end;
                    end;
            end;
        end;
    end;

    [Scope('OnPrem')]
    procedure InsertSaleDiscount(SaleCredMemLine: Record "Sales Cr.Memo Line")
    var
        LineDiscEntry: Record "Posted Sales Discount Entry";
        GLSetup: Record "General Ledger Setup";
        PrecArrondi: Decimal;
        TaxAmount_l: Decimal;
        TaxAmountLCY_l: Decimal;
        RecSalesCredMemHeader_l: Record "Sales Cr.Memo Header";
        CurExchRate_l: Record "Currency Exchange Rate";
        RecItem_l: Record Item;
        QtyMaxOnCurrentLine_l: Decimal;
    begin
        GLSetup.Get;


        if not LineDiscEntry.Get(LineDiscEntry."Document Type"::"Posted Credit Memo",
        SaleCredMemLine."Document No.", SaleCredMemLine."Line No.",
               Rule."Discount and comm. type", Rule."No.") then begin
            LineDiscEntry."Document Type" := LineDiscEntry."Document Type"::"Posted Credit Memo";
            LineDiscEntry."Document No." := SaleCredMemLine."Document No.";
            LineDiscEntry."Line No." := SaleCredMemLine."Line No.";
            LineDiscEntry.Type := Rule.Type;
            LineDiscEntry."Disc. Commission Type" := Rule."Discount and comm. type";
            LineDiscEntry."Rule No." := Rule."No.";
            LineDiscEntry."Continue Calculation" := Rule."Continue calculation";
            LineDiscEntry.Basis := Rule.Basis;

            // Absys ADV.5 ->
            LineDiscEntry."Description Discount Rule" := GetRuleDescription();
            LineDiscEntry.Printable := Rule.Printable;
            LineDiscEntry."Calc method" := Rule."Calc method";
            // Absys ADV.5 <-
            LineDiscEntry."Special Offer" := Rule."Special Offer";
            // Absys ADV.6 ->
            LineDiscEntry."Reason Free Code" := SaleCredMemLine."Reason Free Code";
            LineDiscEntry."Free Line" := SaleCredMemLine."Free Line";
            // Absys ADV.6 <-
            LineDiscEntry."Posting Date" := RecSalesCredMemHeader_l."Posting Date";


            BasisCalculation(Rule, SaleCredMemLine.Quantity, SaleCredMemLine."Quantity (Base)", AmountLCY, SourceAmount, 0, 0, 0);


            // Absys ADV.8 ->
            LineDiscEntry."Quantity (base)" := SaleCredMemLine."Quantity (Base)";
            // Absys ADV.8 <-

            LineDiscEntry.Coefficient := Coeff;
            LineDiscEntry."Coefficient (LCY)" := CoeffLCY;

            CalcAmountComBase(Basis, BasisLCY, Coeff, CoeffLCY,
                              Rule, TotalLineDisc, TotalFootDisc, TotalRFADisc,
                              TotalLineDiscLCY, TotalFootDiscLCY, TotalRFADiscLCY);

            if Currency.Code <> '' then
                Com := Round(Com, Currency."Amount Rounding Precision")
            else begin
                if GLSetup."Amount Rounding Precision" <> 0 then
                    Com := Round(Com, GLSetup."Amount Rounding Precision");
            end;
            LineDiscEntry.Base := Basis;
            LineDiscEntry."Discount Amount" := Com;
            if GLSetup."Amount Rounding Precision" <> 0 then
                ComLCY := Round(ComLCY, GLSetup."Amount Rounding Precision");

            LineDiscEntry."Base (LCY)" := BasisLCY;
            LineDiscEntry."Discount Amount (LCY)" := ComLCY;
            if Com <> 0 then
            // NW300804 ->
            begin
                RemiseAppliquée := true;

                LineDiscEntry.Insert;

            end;
            // NW300804 <-
        end else begin

            BasisCalculation(Rule, SaleCredMemLine.Quantity, SaleCredMemLine."Quantity (Base)", AmountLCY, SourceAmount,
                             0, 0, 0);

            LineDiscEntry.Base := Basis;
            LineDiscEntry."Base (LCY)" := BasisLCY;
            LineDiscEntry.Coefficient := Coeff;
            LineDiscEntry."Coefficient (LCY)" := CoeffLCY;
            LineDiscEntry."Posting Date" := RecSalesCredMemHeader_l."Posting Date"; // absys


            CalcAmountComBase(Basis, BasisLCY, Coeff, CoeffLCY,
                              Rule, TotalLineDisc, TotalFootDisc, TotalRFADisc,
                              TotalLineDiscLCY, TotalFootDiscLCY, TotalRFADiscLCY);

            if Currency.Code <> '' then
                Com := Round(Com, Currency."Amount Rounding Precision")
            else
                if GLSetup."Amount Rounding Precision" <> 0 then
                    Com := Round(Com, GLSetup."Amount Rounding Precision");
            LineDiscEntry."Discount Amount" := Com;
            if GLSetup."Amount Rounding Precision" <> 0 then
                ComLCY := Round(ComLCY, GLSetup."Amount Rounding Precision");
            LineDiscEntry."Discount Amount (LCY)" := ComLCY;
            if (Com <> 0) or (ComLCY <> 0) then begin
                LineDiscEntry.Modify
            end else
                LineDiscEntry.Delete;
        end;

        // Absys ADV.16 ->
        // Test si le nombre d'application de la loi est dépassé
        if Rule."Application Number Maximum" <> 0 then
            if Rule.GetApplicationNumber() > Rule."Application Number Maximum" then
                LineDiscEntry.Delete;
        // Absys ADV.16 <-
    end;

    [Scope('OnPrem')]
    procedure DiscountPurchLine(PurchLine: Record "Purchase Line")
    var
        CurExchRate: Record "Currency Exchange Rate";
        PurchHeader: Record "Purchase Header";
        PurchLineTmp: Record "Purchase Line" temporary;
    begin
        TotalLineDisc := 0;
        TotalFootDisc := 0;
        TotalRFADisc := 0;
        TotalCom := 0;
        TotalLineDiscLCY := 0;
        TotalFootDiscLCY := 0;
        TotalRFADiscLCY := 0;
        TotalComLCY := 0;

        DiscountSetup.Get;
        Rule.Reset;

        if ((not DiscountSetup."Calc. Purch. Line Discount") and (not DiscountSetup."Calc. Purch. Line Back Disc.") and
            (not DiscountSetup."Calc. Purch. Line Commission")) then begin
            Message(Text001);
            exit;
        end;

        if not DiscountSetup."Calc. Purch. Line Discount" then begin
            if not DiscountSetup."Calc. Purch. Line Back Disc." then begin
                if not DiscountSetup."Calc. Purch. Line Commission" then
                    exit
                else
                    Rule.SetFilter("Discount and comm. type", '%1', Rule."Discount and comm. type"::Commission);
            end else begin
                if not DiscountSetup."Calc. Purch. Line Commission" then
                    Rule.SetFilter("Discount and comm. type", '%1', Rule."Discount and comm. type"::"Back discount")
                else
                    Rule.SetFilter("Discount and comm. type", '>=%1', Rule."Discount and comm. type"::"Back discount");
            end;
        end else begin
            if not DiscountSetup."Calc. Purch. Line Back Disc." then begin
                if not DiscountSetup."Calc. Purch. Line Commission" then begin
                    if ((PurchLine."Allow Invoice Disc." and (PurchLine.Type = PurchLine.Type::Item)) or
                        (PurchLine.Type <> PurchLine.Type::Item)) then
                        Rule.SetFilter("Discount and comm. type", '<=%1', Rule."Discount and comm. type"::"Footer discount")
                    else
                        Rule.SetRange("Discount and comm. type", Rule."Discount and comm. type"::"Line discount");
                end else begin
                    if ((PurchLine."Allow Invoice Disc." and (PurchLine.Type = PurchLine.Type::Item)) or
                        (PurchLine.Type <> PurchLine.Type::Item)) then
                        Rule.SetFilter("Discount and comm. type", '<>%1', Rule."Discount and comm. type"::"Back discount")
                    else
                        Rule.SetFilter("Discount and comm. type", '%1|%2', Rule."Discount and comm. type"::"Line discount",
                                      Rule."Discount and comm. type"::Commission);
                end;
            end else begin
                if not DiscountSetup."Calc. Purch. Line Commission" then begin
                    if ((PurchLine."Allow Invoice Disc." and (PurchLine.Type = PurchLine.Type::Item)) or
                        (PurchLine.Type <> PurchLine.Type::Item)) then
                        Rule.SetFilter("Discount and comm. type", '<>%1', Rule."Discount and comm. type"::Commission)
                    else
                        Rule.SetFilter("Discount and comm. type", '<>%1&<>%2', Rule."Discount and comm. type"::"Footer discount",
                                      Rule."Discount and comm. type"::Commission);
                end else begin
                    if ((not PurchLine."Allow Invoice Disc.") and (PurchLine.Type = PurchLine.Type::Item)) then
                        Rule.SetFilter("Discount and comm. type", '<>%1', Rule."Discount and comm. type"::"Footer discount");
                end;
            end;
        end;

        Rule.SetRange(Type, Rule.Type::Purchase);
        Rule.SetFilter("Type Filter", '%1|%2', Rule."Type Filter"::All, PurchLine.Type);

        PurchHeader.Get(PurchLine."Document Type", PurchLine."Document No.");

        //Pour les dde de prix et cdes prévisionnelles, la date de comptabilisation est renseignée avec la date de document
        if PurchLine."Document Type" in
           [PurchLine."Document Type"::Quote, PurchLine."Document Type"::"Blanket Order"] then
            PurchHeader."Posting Date" := PurchHeader."Document Date";
        Rule.SetFilter("Starting Date", '<=%1', PurchHeader."Posting Date");
        Rule.SetFilter("Ending Date", '>=%1', PurchHeader."Posting Date");

        if not Rule.Find('-') then
            exit
        else begin
            SearchDim;
            PurchLineTmp.DeleteAll;
            PurchLine2.SetRange("Document Type", PurchLine."Document Type");
            PurchLine2.SetRange("Document No.", PurchLine."Document No.");
            PurchLine2.SetRange("Line No.", PurchLine."Line No.");

            repeat

                //Conversion du coefficient
                if (Rule."Calc method" = Rule."Calc method"::"Quantité * Coefficient") or
                   (Rule."Calc method" = Rule."Calc method"::"Quantité (base) * Coefficient") then
                    Coeff := CurExchRate.ExchangeAmtLCYToFCY(PurchHeader."Posting Date", PurchHeader."Currency Code",
                                   Rule.Coefficient, PurchHeader."Currency Factor")
                else
                    Coeff := Rule.Coefficient;

                CoeffLCY := Rule.Coefficient;

                if PurchHeader."Currency Code" <> '' then begin
                    Currency.Get(PurchHeader."Currency Code");
                    AmountLCY := CurExchRate.ExchangeAmtFCYToLCY(PurchHeader."Posting Date",
                                       PurchHeader."Currency Code", PurchLine."Line Amount", PurchHeader."Currency Factor");
                end else begin
                    Currency.Init;
                    AmountLCY := PurchLine."Line Amount";
                end;
                SourceAmount := PurchLine."Line Amount";

                if (Rule."Amount Filter (LCY)" <> '') then begin
                    if (PurchHeader."Currency Code" = '') then begin
                        PurchLine2.SetFilter("Line Amount", Rule."Amount Filter (LCY)");
                        SearchPurchase(PurchLine);
                    end else begin
                        PurchLineTmp := PurchLine;
                        PurchLineTmp."Line Amount" := AmountLCY;
                        PurchLineTmp.Insert;
                        PurchLineTmp.SetRange("Document Type", PurchLine."Document Type");
                        PurchLineTmp.SetRange("Document No.", PurchLine."Document No.");
                        PurchLineTmp.SetRange("Line No.", PurchLine."Line No.");
                        PurchLineTmp.SetFilter("Line Amount", Rule."Amount Filter (LCY)");
                        if PurchLineTmp.Find('-') then
                            SearchPurchase(PurchLine);
                    end;
                end else begin
                    PurchLine2.SetFilter("Line Amount", Rule."Amount filter");
                    SearchPurchase(PurchLine);
                end;
                if not SearchNextRule(PurchLine."Allow Invoice Disc.", PurchLine.Type.AsInteger()) then
                    exit;
            until Rule.Next = 0;
        end;
    end;

    [Scope('OnPrem')]
    procedure SearchPurchase(PurchLine: Record "Purchase Line")
    begin
        PurchHeader2.SetRange("Document Type", PurchLine."Document Type");
        PurchHeader2.SetRange("No.", PurchLine."Document No.");
        PurchHeader2.SetFilter("Purchaser Code", Rule."Salespers./Purch. Filter");
        PurchHeader2.SetFilter("Vendor Posting Group", Rule."Source Posting Group Filter");
        PurchHeader2.SetFilter("Gen. Bus. Posting Group", Rule."Gen. Bus. Posting Group filter");
        PurchHeader2.SetFilter("Pay-to Vendor No.", Rule."Source Filter");
        PurchHeader2.SetFilter("Reason Code", Rule."Reason Code filter");
        PurchHeader2.SetFilter("Currency Code", Rule."Currency Filter");

        if PurchHeader2.Find('-') then begin
            PurchLine2.SetFilter("Shortcut Dimension 1 Code", Rule."Global Dimension 1 Filter");
            PurchLine2.SetFilter("Shortcut Dimension 2 Code", Rule."Global Dimension 2 Filter");
            PurchLine2.SetFilter("Gen. Prod. Posting Group", Rule."Gen.Prod. Posting Group filter");
            PurchLine2.SetFilter("Posting Group", Rule."Inventory Posting Group filter");
            PurchLine2.SetFilter("No.", Rule."No. filter");
            PurchLine2.SetFilter(Quantity, Rule."Quantity filter");
            PurchLine2.SetFilter(Amount, Rule."Amount filter");
            PurchLine2.SetFilter("Job No.", Rule."Job Filter");
            PurchLine2.SetFilter("Return Reason Code", Rule."Return Reason Code Filter");

            if PurchLine2.Find('-') then
                if GetDimFilter(125, PurchLine2."Document No.", PurchLine2."Line No.") then begin
                    case PurchLine2.Type of
                        PurchLine2.Type::Item:
                            if GetItemFilter(PurchLine2."No.") then
                                InsertPurchDiscount(PurchLine2);
                        PurchLine2.Type::"G/L Account", PurchLine2.Type::"Charge (Item)":
                            InsertPurchDiscount(PurchLine2);
                    end;
                end;
        end;
    end;

    [Scope('OnPrem')]
    procedure InsertPurchDiscount(PurchLine: Record "Purchase Line")
    var
        LineDiscEntry: Record "Purchase Line Disc. Entry";
        GLSetup: Record "General Ledger Setup";
        PrecArrondi: Decimal;
    begin
        GLSetup.Get;

        if not LineDiscEntry.Get(PurchLine."Document Type", PurchLine."Document No.", PurchLine."Line No.",
                             Rule."Discount and comm. type", Rule."No.") then begin
            LineDiscEntry."Document Type" := PurchLine."Document Type".AsInteger();
            LineDiscEntry."Document No." := PurchLine."Document No.";
            LineDiscEntry."Line No." := PurchLine."Line No.";
            LineDiscEntry.Type := Rule.Type;
            LineDiscEntry."Disc. Commission Type" := Rule."Discount and comm. type";
            LineDiscEntry."Rule No." := Rule."No.";
            LineDiscEntry."Continue Calculation" := Rule."Continue calculation";
            LineDiscEntry.Basis := Rule.Basis;

            BasisCalculation(Rule, PurchLine.Quantity, PurchLine."Quantity (Base)", AmountLCY, SourceAmount, 0, 0, 0);

            LineDiscEntry.Coefficient := Coeff;
            LineDiscEntry."Coefficient (LCY)" := CoeffLCY;

            CalcAmountComBase(Basis, BasisLCY, Coeff, CoeffLCY,
                              Rule, TotalLineDisc, TotalFootDisc, TotalRFADisc,
                              TotalLineDiscLCY, TotalFootDiscLCY, TotalRFADiscLCY);

            if Currency.Code <> '' then
                Com := Round(Com, Currency."Amount Rounding Precision")
            else begin
                if GLSetup."Amount Rounding Precision" <> 0 then
                    Com := Round(Com, GLSetup."Amount Rounding Precision");
            end;
            LineDiscEntry.Base := Basis;
            LineDiscEntry."Discount Amount" := Com;
            if GLSetup."Amount Rounding Precision" <> 0 then
                ComLCY := Round(ComLCY, GLSetup."Amount Rounding Precision");

            LineDiscEntry."Base (LCY)" := BasisLCY;
            LineDiscEntry."Discount Amount (LCY)" := ComLCY;

            if (PurchLine."Document Type" = PurchLine."Document Type"::"Credit Memo") and
               (Rule."Discount and comm. type" > Rule."Discount and comm. type"::"Footer discount") then begin
                LineDiscEntry."Base (LCY)" := -LineDiscEntry."Base (LCY)";
                LineDiscEntry."Discount Amount (LCY)" := -LineDiscEntry."Discount Amount (LCY)";
                LineDiscEntry.Base := -LineDiscEntry.Base;
                LineDiscEntry."Discount Amount" := -LineDiscEntry."Discount Amount";
            end;
            if Com <> 0 then begin

                LineDiscEntry.Insert;

            end
        end else begin
            BasisCalculation(Rule, PurchLine.Quantity, PurchLine."Quantity (Base)", AmountLCY, SourceAmount, 0, 0, 0);
            LineDiscEntry.Coefficient := Coeff;
            LineDiscEntry."Coefficient (LCY)" := CoeffLCY;

            CalcAmountComBase(Basis, BasisLCY, Coeff, CoeffLCY,
                              Rule, TotalLineDisc, TotalFootDisc, TotalRFADisc,
                              TotalLineDiscLCY, TotalFootDiscLCY, TotalRFADiscLCY);

            if Currency.Code <> '' then
                Com := Round(Com, Currency."Amount Rounding Precision")
            else
                if GLSetup."Amount Rounding Precision" <> 0 then
                    Com := Round(Com, GLSetup."Amount Rounding Precision");
            LineDiscEntry.Base := Basis;
            LineDiscEntry."Base (LCY)" := BasisLCY;
            LineDiscEntry."Discount Amount" := Com;
            if GLSetup."Amount Rounding Precision" <> 0 then
                ComLCY := Round(ComLCY, GLSetup."Amount Rounding Precision");
            LineDiscEntry."Discount Amount (LCY)" := ComLCY;

            if (PurchLine."Document Type" = PurchLine."Document Type"::"Credit Memo") and
               (Rule."Discount and comm. type" > Rule."Discount and comm. type"::"Footer discount") then begin
                LineDiscEntry."Base (LCY)" := -LineDiscEntry."Base (LCY)";
                LineDiscEntry."Discount Amount (LCY)" := -LineDiscEntry."Discount Amount (LCY)";
                LineDiscEntry.Base := -LineDiscEntry.Base;
                LineDiscEntry."Discount Amount" := -LineDiscEntry."Discount Amount";
            end;
            if (Com <> 0) or (ComLCY <> 0) then begin

                LineDiscEntry.Modify

            end else
                LineDiscEntry.Delete;
        end;
    end;

    [Scope('OnPrem')]
    procedure BasisCalculation(DiscRule: Record "Discount Rule"; Qty: Decimal; BasisQty: Decimal; AmountLCY: Decimal; SourceAmount: Decimal; TotalVolume_p: Decimal; TaxAmount_p: Decimal; TaxAmountLCY_p: Decimal) BaseCalc: Decimal
    begin
        case DiscRule."Calc method" of
            DiscRule."Calc method"::"Quantité * Coefficient":
                begin
                    BasisLCY := Qty;
                    Basis := Qty;
                end;

            DiscRule."Calc method"::"Quantité (base) * Coefficient":
                begin
                    BasisLCY := BasisQty;
                    Basis := BasisQty;
                end;

            DiscRule."Calc method"::"Montant * Coefficient":
                begin
                    BasisLCY := AmountLCY;
                    Basis := SourceAmount;
                end;

            DiscRule."Calc method"::"Base spécifique * Coefficient":
                begin
                    BasisLCY := 0;
                    Basis := 0;

                    // Absys ADV.7 ->
                    BasisLCY := TotalVolume_p;
                    Basis := TotalVolume_p;
                    // Absys ADV.7 <-
                end;



        end;
        BaseCalc := BasisLCY;
    end;

    [Scope('OnPrem')]
    procedure CalcAmountComBase(var BaseCalc: Decimal; var BaseCalcLCY: Decimal; Coefficient: Decimal; CoefficientLCY: Decimal; DiscRule: Record "Discount Rule"; CumulLigne: Decimal; CumulPied: Decimal; CumulRFA: Decimal; CumulLigneLCY: Decimal; CumulPiedLCY: Decimal; CumulRFALCY: Decimal): Decimal
    var
        TamponComRem: Record "Disc. Commission Buffer";
        SommeRem: Decimal;
    begin
        Rule := DiscRule;
        Basis := BaseCalc;
        BasisLCY := BaseCalcLCY;
        TotalLineDisc := CumulLigne;
        TotalFootDisc := CumulPied;
        TotalRFADisc := CumulRFA;
        TotalLineDiscLCY := CumulLigneLCY;
        TotalFootDiscLCY := CumulPiedLCY;
        TotalRFADiscLCY := CumulRFALCY;

        case Rule."Calc method" of
            Rule."Calc method"::"Base spécifique * Coefficient":
                SpecificCalculation(Rule.Coefficient);
            else begin
                case Rule.Basis of
                    Rule.Basis::Gross:
                        begin
                            Basis := Basis;
                            BasisLCY := BasisLCY;
                        end;
                    Rule.Basis::"Net line":
                        begin
                            Basis := Basis - TotalLineDisc;
                            BasisLCY := BasisLCY - TotalLineDiscLCY;
                        end;
                    Rule.Basis::"Net footer":
                        begin
                            Basis := Basis - TotalLineDisc - TotalFootDisc;
                            BasisLCY := BasisLCY - TotalLineDiscLCY - TotalFootDiscLCY;
                        end;
                    Rule.Basis::"Net back discount":
                        begin
                            Basis := Basis - TotalLineDisc - TotalFootDisc - TotalRFADisc;
                            BasisLCY := BasisLCY - TotalLineDiscLCY - TotalFootDiscLCY - TotalRFADiscLCY;
                        end;
                end;
            end;
        end;

        Com := Coefficient * Basis;
        ComLCY := CoefficientLCY * BasisLCY;

        case Rule."Discount and comm. type" of
            Rule."Discount and comm. type"::"Line discount":
                begin
                    Increment(TotalLineDisc, Com);
                    Increment(TotalLineDiscLCY, ComLCY);
                end;
            Rule."Discount and comm. type"::"Footer discount":
                begin
                    Increment(TotalFootDisc, Com);
                    Increment(TotalFootDiscLCY, ComLCY);
                end;
            Rule."Discount and comm. type"::"Back discount":
                begin
                    Increment(TotalRFADisc, Com);
                    Increment(TotalRFADiscLCY, ComLCY);
                end;
            else begin
                Increment(TotalCom, Com);
                Increment(TotalComLCY, ComLCY);
            end;
        end;

        exit(ComLCY);
    end;

    [Scope('OnPrem')]
    procedure SpecificCalculation(Coef: Decimal)
    begin
        //Calcul de la commission et de la base lorsque la méthode de calcul est Base spécifique * Coefficient
        //Le coefficient est passé en paramètre
        //Pour le calcul suivant, renseigner TotalCom

        Com := 0.0;
    end;

    [Scope('OnPrem')]
    procedure Increment(var No1: Decimal; No2: Decimal)
    begin
        No1 := No1 + No2;
    end;

    [Scope('OnPrem')]
    procedure SearchNextRule(RemiseFact: Boolean; TypeLigne: Option " ","Compte général",Article,Ressource): Boolean
    begin
        if TypeLigne <> TypeLigne::Article then
            RemiseFact := true;

        if Rule.Type = Rule.Type::Sale then begin

            case Rule."Continue calculation" of

                Rule."Continue calculation"::No:
                    // NW300804 ->
                    if RemiseAppliquée then
                        exit(false);
                // NW300804 <-

                Rule."Continue calculation"::"Line discount":
                    begin
                        if DiscountSetup."Calculate Sales Line Discount" then begin
                            if not DiscountSetup."Calc. Sales Line Back Disc." then begin
                                if not DiscountSetup."Calc. Sales Line Commission" then begin
                                    if RemiseFact then
                                        Rule.SetFilter("Discount and comm. type", '%1', Rule."Discount and comm. type"::"Footer discount")
                                    else
                                        exit(false);
                                end else begin
                                    if RemiseFact then
                                        Rule.SetFilter("Discount and comm. type", '%1|%2',
                                          Rule."Discount and comm. type"::"Footer discount", Rule."Discount and comm. type"::Commission)
                                    else
                                        exit(false);
                                end;
                            end else begin
                                if not DiscountSetup."Calc. Sales Line Commission" then begin
                                    if RemiseFact then
                                        Rule.SetFilter("Discount and comm. type", '%1|2',
                                          Rule."Discount and comm. type"::"Footer discount", Rule."Discount and comm. type"::"Back discount")
                                    else
                                        Rule.SetFilter("Discount and comm. type", '%1', Rule."Discount and comm. type"::"Back discount")
                                end else begin
                                    if RemiseFact then
                                        Rule.SetFilter("Discount and comm. type", '>%1', Rule."Discount and comm. type"::"Line discount")
                                    else
                                        Rule.SetFilter("Discount and comm. type", '>%1', Rule."Discount and comm. type"::"Footer discount");
                                end;
                            end;
                        end else begin
                            if not DiscountSetup."Calc. Sales Line Back Disc." then begin
                                if DiscountSetup."Calc. Sales Line Commission" then
                                    Rule.SetFilter("Discount and comm. type", '%1', Rule."Discount and comm. type"::Commission);
                            end else begin
                                if not DiscountSetup."Calc. Sales Line Commission" then
                                    Rule.SetFilter("Discount and comm. type", '%1', Rule."Discount and comm. type"::"Back discount")
                                else
                                    Rule.SetFilter("Discount and comm. type", '>=%1', Rule."Discount and comm. type"::"Back discount")
                            end;
                        end;
                    end;

                Rule."Continue calculation"::"Footer discount":
                    begin
                        if not DiscountSetup."Calc. Sales Line Back Disc." then begin
                            if DiscountSetup."Calc. Sales Line Commission" then
                                Rule.SetFilter("Discount and comm. type", '%1', Rule."Discount and comm. type"::Commission);
                        end else begin
                            if not DiscountSetup."Calc. Sales Line Commission" then
                                Rule.SetFilter("Discount and comm. type", '%1', Rule."Discount and comm. type"::"Back discount")
                            else
                                Rule.SetFilter("Discount and comm. type", '>=%1', Rule."Discount and comm. type"::"Back discount")
                        end;
                    end;

                Rule."Continue calculation"::"End of period discount":
                    begin
                        if DiscountSetup."Calc. Sales Line Commission" then
                            Rule.SetFilter("Discount and comm. type", '%1', Rule."Discount and comm. type"::Commission);
                    end;

            end;

            exit(true);

        end else begin

            case Rule."Continue calculation" of

                Rule."Continue calculation"::No:
                    exit(false);

                Rule."Continue calculation"::"Line discount":
                    begin
                        if DiscountSetup."Calc. Purch. Line Discount" then begin
                            if not DiscountSetup."Calc. Purch. Line Back Disc." then begin
                                if not DiscountSetup."Calc. Purch. Line Commission" then begin
                                    if RemiseFact then
                                        Rule.SetFilter("Discount and comm. type", '%1', Rule."Discount and comm. type"::"Footer discount")
                                    else
                                        exit(false);
                                end else begin
                                    if RemiseFact then
                                        Rule.SetFilter("Discount and comm. type", '%1|%2',
                                           Rule."Discount and comm. type"::"Footer discount", Rule."Discount and comm. type"::Commission)
                                    else
                                        Rule.SetFilter("Discount and comm. type", '%1', Rule."Discount and comm. type"::Commission);
                                end;
                            end else begin
                                if not DiscountSetup."Calc. Purch. Line Commission" then begin
                                    if RemiseFact then
                                        Rule.SetFilter("Discount and comm. type", '%1|2',
                                           Rule."Discount and comm. type"::"Footer discount", Rule."Discount and comm. type"::"Back discount")
                                    else
                                        Rule.SetFilter("Discount and comm. type", '%1', Rule."Discount and comm. type"::"Back discount");
                                end else begin
                                    if RemiseFact then
                                        Rule.SetFilter("Discount and comm. type", '>=%1', Rule."Discount and comm. type"::"Footer discount")
                                    else
                                        Rule.SetFilter("Discount and comm. type", '>%1', Rule."Discount and comm. type"::"Footer discount");
                                end;
                            end;
                        end else begin
                            if not DiscountSetup."Calc. Purch. Line Back Disc." then begin
                                if DiscountSetup."Calc. Purch. Line Commission" then
                                    Rule.SetFilter("Discount and comm. type", '%1', Rule."Discount and comm. type"::Commission);
                            end else begin
                                if not DiscountSetup."Calc. Purch. Line Commission" then
                                    Rule.SetFilter("Discount and comm. type", '%1', Rule."Discount and comm. type"::"Back discount")
                                else
                                    Rule.SetFilter("Discount and comm. type", '>=%1',
                                        Rule."Discount and comm. type"::"Back discount")
                            end;
                        end;
                    end;

                Rule."Continue calculation"::"Footer discount":
                    begin
                        if not DiscountSetup."Calc. Sales Line Back Disc." then begin
                            if DiscountSetup."Calc. Sales Line Commission" then
                                Rule.SetFilter("Discount and comm. type", '%1', Rule."Discount and comm. type"::Commission);
                        end else begin
                            if not DiscountSetup."Calc. Sales Line Commission" then
                                Rule.SetFilter("Discount and comm. type", '%1', Rule."Discount and comm. type"::"Back discount")
                            else
                                Rule.SetFilter("Discount and comm. type", '>=%1', Rule."Discount and comm. type"::"Back discount")
                        end;
                    end;

                Rule."Continue calculation"::"End of period discount":
                    begin
                        if DiscountSetup."Calc. Sales Line Commission" then
                            Rule.SetFilter("Discount and comm. type", '%1', Rule."Discount and comm. type"::Commission);
                    end;
            end;
            exit(true);
        end;
    end;

    [Scope('OnPrem')]
    procedure GetItemFilter(ItemNo: Code[20]): Boolean
    var
        Item: Record Item;
    begin
        with Item do begin
            SetFilter("No.", ItemNo);
            SetFilter("Criteria 1", Rule."Item criteria filter 1");
            SetFilter("Criteria 2", Rule."Item criteria filter 2");
            SetFilter("Criteria 3", Rule."Item criteria filter 3");
            SetFilter("Criteria 4", Rule."Item criteria filter 4");
            SetFilter("Criteria 5", Rule."Item criteria filter 5");
            SetFilter("Criteria 6", Rule."Item criteria filter 6");
            SetFilter("Criteria 7", Rule."Item criteria filter 7");
            SetFilter("Criteria 8", Rule."Item criteria filter 8");
            SetFilter("Criteria 9", Rule."Item criteria filter 9");
            SetFilter("Criteria 10", Rule."Item criteria filter 10");
            SetFilter("Manufacturer Code", Rule."Manufacturer Code Filter");
            SetFilter("Item Category Code", Rule."Item Category Code Filter");
            SetFilter("Service Item Group", Rule."Service Item Group Filter");
            SetFilter("Item Disc. Group", Rule."Item/Cust. Disc. Gr. filter");
            exit(Find('-'));
        end;
    end;

    [Scope('OnPrem')]
    procedure GetDimFilter(TableID: Integer; DocNo: Code[20]; LineNo: Integer): Boolean
    var
        i: Integer;
    begin
        if not ExistDim then
            exit(true);

        if ExistDim then begin
            RuleDimFilter[1] := Rule."Dimension 1 Value Code";
            RuleDimFilter[2] := Rule."Dimension 2 Value Code";
            RuleDimFilter[3] := Rule."Dimension 3 Value Code";
            RuleDimFilter[4] := Rule."Dimension 4 Value Code";
            RuleDimFilter[5] := Rule."Dimension 5 Value Code";
            RuleDimFilter[6] := Rule."Dimension 6 Value Code";
            RuleDimFilter[7] := Rule."Dimension 7 Value Code";
            RuleDimFilter[8] := Rule."Dimension 8 Value Code";
            RuleDimFilter[9] := Rule."Dimension 9 Value Code";
            RuleDimFilter[10] := Rule."Dimension 10 Value Code";
            RuleDimFilter[11] := Rule."Dimension 11 Value Code";
            RuleDimFilter[12] := Rule."Dimension 12 Value Code";
            RuleDimFilter[13] := Rule."Dimension 13 Value Code";
            RuleDimFilter[14] := Rule."Dimension 14 Value Code";
            RuleDimFilter[15] := Rule."Dimension 15 Value Code";
            RuleDimFilter[16] := Rule."Dimension 16 Value Code";
            RuleDimFilter[17] := Rule."Dimension 17 Value Code";
            RuleDimFilter[18] := Rule."Dimension 18 Value Code";
            RuleDimFilter[19] := Rule."Dimension 19 Value Code";
            RuleDimFilter[20] := Rule."Dimension 20 Value Code";
        end;
        /*
        DocDim.SETRANGE("Table ID",TableID);
        DocDim.SETRANGE("Document No.",DocNo);
        DocDim.SETRANGE("Line No.",LineNo);
        
        FOR i := 1 TO 20 DO
          IF RuleDimFilter[i] <> '' THEN BEGIN
            DocDim.SETFILTER("Dimension Code",StatSetupShortcutDimCode[i]);
            DocDim.SETFILTER("Dimension Value Code",RuleDimFilter[i]);
            IF NOT DocDim.FIND('-') THEN
              EXIT(FALSE)
            ELSE BEGIN
              DocDim.SETRANGE("Dimension Code");
              DocDim.SETRANGE("Dimension Value Code");
            END;
          END;
        */
        exit(true);

    end;

    [Scope('OnPrem')]
    procedure SearchDim()
    var
        StatisticSetup: Record "Statistics setup";
        i: Integer;
    begin
        StatisticSetup.Get;
        StatSetupShortcutDimCode[1] := StatisticSetup."Dimension 1 Code";
        StatSetupShortcutDimCode[2] := StatisticSetup."Dimension 2 Code";
        StatSetupShortcutDimCode[3] := StatisticSetup."Dimension 3 Code";
        StatSetupShortcutDimCode[4] := StatisticSetup."Dimension 4 Code";
        StatSetupShortcutDimCode[5] := StatisticSetup."Dimension 5 Code";
        StatSetupShortcutDimCode[6] := StatisticSetup."Dimension 6 Code";
        StatSetupShortcutDimCode[7] := StatisticSetup."Dimension 7 Code";
        StatSetupShortcutDimCode[8] := StatisticSetup."Dimension 8 Code";
        StatSetupShortcutDimCode[9] := StatisticSetup."Dimension 9 Code";
        StatSetupShortcutDimCode[10] := StatisticSetup."Dimension 10 Code";
        StatSetupShortcutDimCode[11] := StatisticSetup."Dimension 11 Code";
        StatSetupShortcutDimCode[12] := StatisticSetup."Dimension 12 Code";
        StatSetupShortcutDimCode[13] := StatisticSetup."Dimension 13 Code";
        StatSetupShortcutDimCode[14] := StatisticSetup."Dimension 14 Code";
        StatSetupShortcutDimCode[15] := StatisticSetup."Dimension 15 Code";
        StatSetupShortcutDimCode[16] := StatisticSetup."Dimension 16 Code";
        StatSetupShortcutDimCode[17] := StatisticSetup."Dimension 17 Code";
        StatSetupShortcutDimCode[18] := StatisticSetup."Dimension 18 Code";
        StatSetupShortcutDimCode[19] := StatisticSetup."Dimension 19 Code";
        StatSetupShortcutDimCode[20] := StatisticSetup."Dimension 20 Code";
        for i := 1 to 20 do
            if not ExistDim and (StatSetupShortcutDimCode[i] <> '') then
                ExistDim := true;
    end;

    [Scope('OnPrem')]
    procedure GetRuleDescription(): Text[50]
    var
        RecRuleTranslation_l: Record "Alert Management";
    begin
        // Absys ADV.15 ->
        /*
        IF RecRuleTranslation_l.GET(Rule."Discount and comm. type",Rule."No.",SalesCredMemHeader2."Language Code") THEN
          EXIT(RecRuleTranslation_l."Event");
        
        Rule.TESTFIELD(Description);
        EXIT(Rule.Description);
        
        // Absys ADV.15 <-
         */

    end;

    [Scope('OnPrem')]
    procedure InitDiscount(l_ledgerdiscount: Record "Posted Sales Discount Entry")
    begin
        // Absys AM
        case l_ledgerdiscount."Disc. Commission Type" of
            l_ledgerdiscount."Disc. Commission Type"::"Line Discount":
                begin
                    Increment(TotalLineDisc, l_ledgerdiscount."Discount Amount");
                    Increment(TotalLineDiscLCY, l_ledgerdiscount."Discount Amount (LCY)");
                end;
            l_ledgerdiscount."Disc. Commission Type"::"Footer Discount":
                begin
                    Increment(TotalFootDisc, l_ledgerdiscount."Discount Amount");
                    Increment(TotalFootDiscLCY, l_ledgerdiscount."Discount Amount (LCY)");
                end;
        end;
        // Absys AM
    end;
}

