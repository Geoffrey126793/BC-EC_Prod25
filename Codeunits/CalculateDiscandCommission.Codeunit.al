codeunit 8001500 "Calculate Disc. and Commission"
{
    // 
    // 
    // ------------------------------------------------------------------------------------------
    // ADV-002 ABSYS GN 20061018
    //   RFA : Gestion des gratuits
    //     Add Code :
    //      - InsertSaleDiscount(SaleLine : Record "Sales Line")
    // ------------------------------------------------------------------------------------------
    // ADV-001 ABSYS GN 20061018
    //   RFA : Gestion des gratuits
    //     Add Code :
    //      - SearchSale(SaleLine : Record "Sales Line")
    // ------------------------------------------------------------------------------------------
    // ADV-001 ABSYS BT 20061102
    //      - Test si le nombre d'application de la loi est dépassé
    //      - Test si la quantité maximum de la loi est dépassé
    // ------------------------------------------------------------------------------------------
    // BT 20061215 : correction NW sur la base Chimay
    //   --> NW300804 : Correction bug cumulable = non
    // 
    // 
    // 
    // //+RFA+ GESWAY 11/07/02 Nouveau codeunit


    trigger OnRun()
    begin
    end;

    var
        Text001: Label 'No Discount or Commission available in then Discount Setup.';
        DiscountSetup: Record "Disc. Commission Setup";
        Rule: Record "Discount Rule";
        DiscBuffer: Record "Disc. Commission Buffer";
        SaleDiscLineEntry: Record "Sales Line Discount Entry";
        Currency: Record Currency;
        Cust: Record Customer;
        SalesHeader2: Record "Sales Header";
        SalesLine2: Record "Sales Line";
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
        EndSearch: Boolean;
        Text50002: Label 'La quantité (base) %1  saisie sur la commande %2 article %3 \dépasse la Qté (base ) maxi de %4 de la loi %5. \La maximum autorisé sur cette ligne est %6. \Le reste doit être saisi sur une autre ligne.';
        "RemiseAppliquée": Boolean;

    [Scope('OnPrem')]
    procedure DiscountSaleLine(SaleLine: Record "Sales Line")
    var
        CurExchRate: Record "Currency Exchange Rate";
        SalesHeader: Record "Sales Header";
        SaleLineTmp: Record "Sales Line" temporary;
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
                    if ((SaleLine."Allow Invoice Disc." and (SaleLine.Type = SaleLine.Type::Item)) or
                        (SaleLine.Type <> SaleLine.Type::Item)) then
                        Rule.SetFilter("Discount and comm. type", '<=%1',
                                        Rule."Discount and comm. type"::"Footer discount")
                    else
                        Rule.SetRange("Discount and comm. type",
                                       Rule."Discount and comm. type"::"Line discount");
                end else begin
                    if ((SaleLine."Allow Invoice Disc." and (SaleLine.Type = SaleLine.Type::Item)) or
                        (SaleLine.Type <> SaleLine.Type::Item)) then
                        Rule.SetFilter("Discount and comm. type", '<>%1',
                                        Rule."Discount and comm. type"::"Back discount")
                    else
                        Rule.SetFilter("Discount and comm. type", '%1|%2',
                                        Rule."Discount and comm. type"::"Line discount",
                                        Rule."Discount and comm. type"::Commission);
                end;
            end else begin
                if not DiscountSetup."Calc. Sales Line Commission" then begin
                    if ((SaleLine."Allow Invoice Disc." and (SaleLine.Type = SaleLine.Type::Item)) or
                        (SaleLine.Type <> SaleLine.Type::Item)) then
                        Rule.SetFilter("Discount and comm. type", '<>%1',
                                        Rule."Discount and comm. type"::Commission)
                    else
                        Rule.SetFilter("Discount and comm. type", '<>%1&<>%2', Rule."Discount and comm. type"::"Footer discount",
                                        Rule."Discount and comm. type"::Commission);
                end else begin
                    if ((not SaleLine."Allow Invoice Disc.") and (SaleLine.Type = SaleLine.Type::Item)) then
                        Rule.SetFilter("Discount and comm. type", '<>%1',
                                        Rule."Discount and comm. type"::"Footer discount");
                end;
            end;
        end;

        Rule.SetRange(Type, Rule.Type::Sale);
        Rule.SetFilter("Type Filter", '%1|%2', Rule."Type Filter"::All, SaleLine.Type);

        SalesHeader.Get(SaleLine."Document Type", SaleLine."Document No.");

        //Pour les devis et cdes prévisionnelles, la date de comptabilisation
        //est renseignée avec la date de document

        if SaleLine."Document Type" in
           [SaleLine."Document Type"::Quote, SaleLine."Document Type"::"Blanket Order"] then
            SalesHeader."Posting Date" := SalesHeader."Document Date";

        Rule.SetFilter("Starting Date", '<=%1', SalesHeader."Posting Date");
        Rule.SetFilter("Ending Date", '>=%1', SalesHeader."Posting Date");

        if not Rule.Find('-') then
            exit
        else begin
            SearchDim;
            SaleLineTmp.DeleteAll;
            SalesLine2.SetRange("Document Type", SaleLine."Document Type");
            SalesLine2.SetRange("Document No.", SaleLine."Document No.");
            SalesLine2.SetRange("Line No.", SaleLine."Line No.");

            repeat
                // NW300804 ->   reprise code Chimay
                RemiseAppliquée := false;
                // NW300804 <-


                //Conversion du coefficient
                if (Rule."Calc method" = Rule."Calc method"::"Quantité * Coefficient") or
                   (Rule."Calc method" = Rule."Calc method"::"Quantité (base) * Coefficient") then
                    Coeff := CurExchRate.ExchangeAmtLCYToFCY(
                               SalesHeader."Posting Date", SalesHeader."Currency Code",
                               Rule.Coefficient, SalesHeader."Currency Factor")
                else
                    Coeff := Rule.Coefficient;

                CoeffLCY := Rule.Coefficient;
                if SalesHeader."Currency Code" <> '' then begin
                    Currency.Get(SalesHeader."Currency Code");
                    AmountLCY := CurExchRate.ExchangeAmtFCYToLCY(
                                   SalesHeader."Posting Date", SalesHeader."Currency Code",
                                   SaleLine."Line Amount", SalesHeader."Currency Factor");
                end else begin
                    Currency.Init;
                    AmountLCY := SaleLine."Line Amount";
                end;
                SourceAmount := SaleLine."Line Amount";

                if (Rule."Amount Filter (LCY)" <> '') then begin
                    if (SalesHeader."Currency Code" = '') then begin
                        SalesLine2.SetFilter(Amount, Rule."Amount Filter (LCY)");
                        SearchSale(SaleLine);
                    end else begin
                        SaleLineTmp := SaleLine;
                        SaleLineTmp.Amount := AmountLCY;
                        SaleLineTmp.Insert;
                        SaleLineTmp.SetRange("Document Type", SaleLine."Document Type");
                        SaleLineTmp.SetRange("Document No.", SaleLine."Document No.");
                        SaleLineTmp.SetRange("Line No.", SaleLine."Line No.");
                        SaleLineTmp.SetFilter("Line Amount", Rule."Amount Filter (LCY)");
                        if SaleLineTmp.Find('-') then
                            SearchSale(SaleLine);
                    end;
                end else begin
                    SalesLine2.SetFilter("Line Amount", Rule."Amount filter");
                    SearchSale(SaleLine);
                end;
                if (Rule."Discount and comm. type" >= Rule."Discount and comm. type"::"Back discount") then begin
                    if not SearchNextRule(SaleLine."Allow Invoice Disc.", SaleLine.Type.AsInteger()) then
                        exit;
                end else
                    if EndSearch then
                        exit;
            until Rule.Next = 0;
        end;
    end;

    [Scope('OnPrem')]
    procedure SearchSale(SaleLine: Record "Sales Line")
    begin
        SalesHeader2.SetRange("Document Type", SaleLine."Document Type");
        SalesHeader2.SetRange("No.", SaleLine."Document No.");
        SalesHeader2.SetFilter("Salesperson Code", Rule."Salespers./Purch. Filter");
        SalesHeader2.SetFilter("Customer Posting Group", Rule."Source Posting Group Filter");
        SalesHeader2.SetFilter("Gen. Bus. Posting Group", Rule."Gen. Bus. Posting Group filter");
        SalesHeader2.SetFilter("Customer Price Group", Rule."Price code filter");
        SalesHeader2.SetFilter("Customer Disc. Group", Rule."Cust./Item Disc. Gr. filter");
        SalesHeader2.SetFilter("Bill-to Customer No.", Rule."Source Filter");
        SalesHeader2.SetFilter("Reason Code", Rule."Reason Code filter");
        SalesHeader2.SetFilter("Currency Code", Rule."Currency Filter");
        if SalesHeader2.Find('-') then begin
            //Customer Criteria
            Cust.Reset;
            Cust.SetFilter("No.", SalesHeader2."Bill-to Customer No.");
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
                SalesLine2.SetFilter("Shortcut Dimension 1 Code", Rule."Global Dimension 1 Filter");
                SalesLine2.SetFilter("Shortcut Dimension 2 Code", Rule."Global Dimension 2 Filter");
                SalesLine2.SetFilter("Gen. Prod. Posting Group", Rule."Gen.Prod. Posting Group filter");
                SalesLine2.SetFilter("Posting Group", Rule."Inventory Posting Group filter");
                SalesLine2.SetFilter("No.", Rule."No. filter");
                SalesLine2.SetFilter(Quantity, Rule."Quantity filter");
                SalesLine2.SetFilter("Job No.", Rule."Job Filter");
                SalesLine2.SetFilter("Return Reason Code", Rule."Return Reason Code Filter");

                //--> ADV-001 ABSYS GN 20061018
                SalesLine2.SetFilter("Reason Free Code", Rule."Free Code Filter");
                //SalesLine2.SETFILTER("Special Discount Code",Rule."Special Discount Filter");
                SalesLine2.SetRange("Allow Invoice Disc.", true);
                //<-- ADV-001 ABSYS GN 20061018

                if SalesLine2.Find('-') then
                    if GetDimFilter(37, SalesLine2."Document Type".AsInteger(),
                                       SalesLine2."Document No.", SalesLine2."Line No.") then begin
                        case SalesLine2.Type of
                            SalesLine2.Type::Item:
                                if GetItemFilter(SalesLine2."No.") then
                                    InsertSaleDiscount(SalesLine2);
                            SalesLine2.Type::"G/L Account", SalesLine2.Type::Resource, SalesLine2.Type::"Charge (Item)":
                                InsertSaleDiscount(SalesLine2);
                        end;
                    end;
            end;
        end;
    end;

    [Scope('OnPrem')]
    procedure InsertSaleDiscount(SaleLine: Record "Sales Line")
    var
        LineDiscEntry: Record "Sales Line Discount Entry";
        GLSetup: Record "General Ledger Setup";
        PrecArrondi: Decimal;
        QtyMaxOnCurrentLine_l: Decimal;
    begin
        GLSetup.Get;

        if not LineDiscEntry.Get(SaleLine."Document Type", SaleLine."Document No.", SaleLine."Line No.",
               Rule."Discount and comm. type", Rule."No.") then begin
            LineDiscEntry."Document Type" := SaleLine."Document Type".AsInteger();
            LineDiscEntry."Document No." := SaleLine."Document No.";
            LineDiscEntry."Line No." := SaleLine."Line No.";
            LineDiscEntry.Type := Rule.Type;
            LineDiscEntry."Disc. Commission Type" := Rule."Discount and comm. type";
            LineDiscEntry."Rule No." := Rule."No.";
            LineDiscEntry."Continue Calculation" := Rule."Continue calculation";
            LineDiscEntry.Basis := Rule.Basis;
            //--> ADV-002 ABSYS GN 20061018
            LineDiscEntry."Special Offer" := Rule."Special Offer";
            //<-- ADV-002 ABSYS GN 20061018

            //--> ADV-001 ABSYS GN 20061018
            LineDiscEntry."Resaon Free Code" := SaleLine."Reason Free Code";
            LineDiscEntry."Free Line" := SaleLine."Free Line";
            //<-- ADV-001 ABSYS GN 20061018

            BasisCalculation(Rule, SaleLine.Quantity, SaleLine."Quantity (Base)", AmountLCY, SourceAmount);

            //--> ADV-002 ABSYS GN 20061018
            LineDiscEntry."Quantity (base)" := SaleLine."Quantity (Base)";
            //<-- ADV-002 ABSYS GN 20061018

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
            if (SaleLine."Document Type" = SaleLine."Document Type"::"Credit Memo") and
               (Rule."Discount and comm. type" > Rule."Discount and comm. type"::"Footer discount") then begin
                LineDiscEntry."Base (LCY)" := -LineDiscEntry."Base (LCY)";
                LineDiscEntry."Discount Amount (LCY)" := -LineDiscEntry."Discount Amount (LCY)";
                LineDiscEntry.Base := -LineDiscEntry.Base;
                LineDiscEntry."Discount Amount" := -LineDiscEntry."Discount Amount";
            end;
            if Com <> 0 then
            // NW300804 ->
            begin
                RemiseAppliquée := true;
                LineDiscEntry.Insert;
            end;
            // NW300804 <-

        end else begin
            BasisCalculation(Rule, SaleLine.Quantity, SaleLine."Quantity (Base)", AmountLCY, SourceAmount);
            LineDiscEntry.Base := Basis;
            LineDiscEntry."Base (LCY)" := BasisLCY;
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
            LineDiscEntry."Discount Amount" := Com;
            if GLSetup."Amount Rounding Precision" <> 0 then
                ComLCY := Round(ComLCY, GLSetup."Amount Rounding Precision");
            LineDiscEntry."Discount Amount (LCY)" := ComLCY;
            if (SaleLine."Document Type" = SaleLine."Document Type"::"Credit Memo") and
               (Rule."Discount and comm. type" > Rule."Discount and comm. type"::"Footer discount") then begin
                LineDiscEntry."Base (LCY)" := -LineDiscEntry."Base (LCY)";
                LineDiscEntry."Discount Amount (LCY)" := -LineDiscEntry."Discount Amount (LCY)";
                LineDiscEntry.Base := -LineDiscEntry.Base;
                LineDiscEntry."Discount Amount" := -LineDiscEntry."Discount Amount";
            end;
            if (Com <> 0) or (ComLCY <> 0) then
                LineDiscEntry.Modify
            else
                LineDiscEntry.Delete;
        end;

        // ADV-001 ABSYS BT 20061102 >>
        // Test si le nombre d'application de la loi est dépassé
        if Rule."Application Number Maximum" <> 0 then
            if Rule.GetApplicationNumber() > Rule."Application Number Maximum" then
                LineDiscEntry.Delete;

        // Test si la quantité maximum de la loi est dépassé
        if Rule."Quantity (Base) Maximum" <> 0 then begin
            //--------------------------------------------------------------
            // 2 cas :
            //  1. c'est la ligne en cours qui fait le dépassement
            //    alors on met un message d'erreur pour que la personne
            //    eclate la ligne
            //  2. ce n'est pas la ligne courante qui génère le dépassement
            //    alors on garde pas la remise
            //--------------------------------------------------------------

            // !!! A ajouter : changer le signe de la base si avoir !!!

            if Rule.GetQtyBaseOnRuleEntry() > Rule."Quantity (Base) Maximum" then begin

                // test si c la ligne en cours qui dépassent
                if Rule.GetQtyBaseOnRuleEntry() - LineDiscEntry."Quantity (base)" < Rule."Quantity (Base) Maximum" then begin
                    //-- Cas 1 ----

                    // la quantité (base) %1  saisie sur la commande %2 article %3
                    // \ dépasse la Qté (base ) maxi de %4 de la loi %5.
                    // \ La maximum autorisé sur cette ligne est de %4 - %1 = %6.
                    // \ Le reste doit être saisi sur une autre ligne.
                    QtyMaxOnCurrentLine_l := Rule."Quantity (Base) Maximum" - (Rule.GetQtyBaseOnRuleEntry() - LineDiscEntry."Quantity (base)");

                    Error(Text50002, SaleLine."Quantity (Base)", SaleLine."Document No.", SaleLine."No.",
                      Rule."Quantity (Base) Maximum", LineDiscEntry."Rule No.",
                      QtyMaxOnCurrentLine_l);

                end else begin
                    //-- Cas 2 ----
                    if LineDiscEntry.Delete then;
                end;
            end;
        end;
        //ADV-001 ABSYS BT 20061102<<



        if (Rule."Discount and comm. type" < Rule."Discount and comm. type"::"Back discount") then
            if not SearchNextRule(SaleLine."Allow Invoice Disc.", SaleLine.Type.AsInteger()) then
                EndSearch := true;
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
                if (Rule."Discount and comm. type" >= Rule."Discount and comm. type"::"Back discount") then begin
                    if not SearchNextRule(PurchLine."Allow Invoice Disc.", PurchLine.Type.AsInteger()) then
                        exit;
                end else
                    if EndSearch then
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
                if GetDimFilter(39, PurchLine2."Document Type".AsInteger(), PurchLine2."Document No.", PurchLine2."Line No.") then begin
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

            BasisCalculation(Rule, PurchLine.Quantity, PurchLine."Quantity (Base)", AmountLCY, SourceAmount);

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
            if Com <> 0 then
                LineDiscEntry.Insert;
        end else begin
            BasisCalculation(Rule, PurchLine.Quantity, PurchLine."Quantity (Base)", AmountLCY, SourceAmount);
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
            if (Com <> 0) or (ComLCY <> 0) then
                LineDiscEntry.Modify
            else
                LineDiscEntry.Delete;
        end;

        if (Rule."Discount and comm. type" < Rule."Discount and comm. type"::"Back discount") then
            if not SearchNextRule(PurchLine."Allow Invoice Disc.", PurchLine.Type.AsInteger()) then
                EndSearch := true;
    end;

    [Scope('OnPrem')]
    procedure BasisCalculation(DiscRule: Record "Discount Rule"; Qty: Decimal; BasisQty: Decimal; AmountLCY: Decimal; SourceAmount: Decimal) BaseCalc: Decimal
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
            //Renseigner ici la Base de Calcul
            DiscRule."Calc method"::"Base spécifique * Coefficient":
                begin
                    BasisLCY := 0;
                    Basis := 0;
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

        BaseCalc := Basis;
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
    procedure GetDimFilter(TableID: Integer; DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; DocNo: Code[20]; LineNo: Integer): Boolean
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
        DocDim.SETRANGE("Document Type",DocType);
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
}

