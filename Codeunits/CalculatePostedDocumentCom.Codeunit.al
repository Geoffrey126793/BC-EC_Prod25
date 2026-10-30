codeunit 8001502 "Calculate Posted Document Com."
{
    // ------------------------------------------------------------------------------------------
    // ADV-002 ABSYS GN 20061018
    //   RFA : Gestion des gratuits
    //     Add Code :
    //      - EcrireRemiseLigneVente(SalesInvLine : Record "Sales Invoice Line")
    // ------------------------------------------------------------------------------------------
    // ADV-001 ABSYS GN 20061018
    //   RFA : Gestion des gratuits
    //     Add Code :
    //      - RechercheVente(SalesInvLine : Record "Sales Invoice Line")
    //      - EcrireRemiseLigneVente(SalesInvLine : Record "Sales Invoice Line")
    // ------------------------------------------------------------------------------------------
    // ADV-001 ABSYS BT 20061102
    //       - Test si le nombre d'application de la loi est dépassé
    //       - Test si la quantité maximum de la loi est dépassé
    // 
    // ------------------------------------------------------------------------------------------
    // 
    // //+RFA+ GESWAY 11/07/02 Nouveau codeunit pour le calcul des commissions dans factures enregistrées


    trigger OnRun()
    begin
    end;

    var
        DiscountSetup: Record "Disc. Commission Setup";
        Rule: Record "Discount Rule";
        LineDiscEntry: Record "Sales Line Discount Entry";
        Devise: Record Currency;
        Article: Record Item;
        Clt: Record Customer;
        Fns: Record Vendor;
        EnTeteVente2: Record "Sales Invoice Header";
        SalesInvLine2: Record "Sales Invoice Line";
        EnTeteAchat2: Record "Purch. Inv. Header";
        LigAchat2: Record "Purch. Inv. Line";
        DiscountLine: Record "Sales Line Discount Entry";
        BaseCalculLCY: Decimal;
        BaseCalcul: Decimal;
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
        MntMin: Decimal;
        MntMax: Decimal;
        AmountLCY: Decimal;
        Text001: Label 'No Discount or Commission available in then Discount Setup.';
        SourceAmount: Decimal;
        Coeff: Decimal;
        CoeffLCY: Decimal;
        Date1: Date;
        Date2: Date;
        StatSetupShortcutDimCode: array[20] of Code[20];
        RuleDimFilter: array[20] of Text[100];
        ExistDim: Boolean;
        Text50001: Label 'La Quantité (base) saisie sur le document %1 %2 ligne %3 de %4 dépasse la Quantité (base) maximale %5 de la loi %6.';

    [Scope('OnPrem')]
    procedure RemiseLigneVente(SalesInvLine: Record "Sales Invoice Line")
    var
        TxChange: Record "Currency Exchange Rate";
        EnTeteVente: Record "Sales Invoice Header";
        SalesInvLineTmp: Record "Sales Invoice Line";
    begin
        DiscountLine.SetRange("Document Type", DiscountLine."Document Type"::"Posted Invoice");
        DiscountLine.SetRange("Document No.", SalesInvLine."Document No.");
        DiscountLine.SetRange("Line No.", SalesInvLine."Line No.");

        DiscountLine.SetRange("Disc. Commission Type", DiscountLine."Disc. Commission Type"::"Line Discount");
        DiscountLine.CalcSums("Discount Amount (LCY)", "Discount Amount");
        TotalLineDisc := DiscountLine."Discount Amount";
        TotalLineDiscLCY := DiscountLine."Discount Amount (LCY)";

        DiscountLine.SetRange("Disc. Commission Type", DiscountLine."Disc. Commission Type"::"Footer Discount");
        DiscountLine.CalcSums("Discount Amount (LCY)", "Discount Amount");
        TotalFootDisc := DiscountLine."Discount Amount";
        TotalFootDiscLCY := DiscountLine."Discount Amount (LCY)";

        DiscountLine.SetRange("Disc. Commission Type", DiscountLine."Disc. Commission Type"::"Back Discount");
        DiscountLine.CalcSums("Discount Amount (LCY)", "Discount Amount");
        TotalRFADisc := DiscountLine."Discount Amount";
        TotalRFADiscLCY := DiscountLine."Discount Amount (LCY)";

        TotalCom := 0;
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
                    Rule.SetFilter("Discount and comm. type", '%1', Rule."Discount and comm. type"::Commission);
            end else begin
                if not DiscountSetup."Calc. Sales Line Commission" then
                    Rule.SetFilter("Discount and comm. type", '%1', Rule."Discount and comm. type"::"Back discount")
                else
                    Rule.SetFilter("Discount and comm. type", '>=%1', Rule."Discount and comm. type"::"Back discount");
            end;
        end else begin
            if not DiscountSetup."Calc. Sales Line Back Disc." then begin
                if not DiscountSetup."Calc. Sales Line Commission" then begin
                    if ((SalesInvLine."Allow Invoice Disc." and (SalesInvLine.Type = SalesInvLine.Type::Item)) or
                        (SalesInvLine.Type <> SalesInvLine.Type::Item)) then
                        Rule.SetFilter("Discount and comm. type", '<=%1', Rule."Discount and comm. type"::"Footer discount")
                    else
                        Rule.SetRange("Discount and comm. type", Rule."Discount and comm. type"::"Line discount");
                end else begin
                    if ((SalesInvLine."Allow Invoice Disc." and (SalesInvLine.Type = SalesInvLine.Type::Item)) or
                        (SalesInvLine.Type <> SalesInvLine.Type::Item)) then
                        Rule.SetFilter("Discount and comm. type", '<>%1', Rule."Discount and comm. type"::"Back discount")
                    else
                        Rule.SetFilter("Discount and comm. type", '%1|%2', Rule."Discount and comm. type"::"Line discount",
                                       Rule."Discount and comm. type"::Commission);
                end;
            end else begin
                if not DiscountSetup."Calc. Sales Line Commission" then begin
                    if ((SalesInvLine."Allow Invoice Disc." and (SalesInvLine.Type = SalesInvLine.Type::Item)) or
                        (SalesInvLine.Type <> SalesInvLine.Type::Item)) then
                        Rule.SetFilter("Discount and comm. type", '<>%1', Rule."Discount and comm. type"::Commission)
                    else
                        Rule.SetFilter("Discount and comm. type", '<>%1&<>%2', Rule."Discount and comm. type"::"Footer discount",
                                      Rule."Discount and comm. type"::Commission);
                end else begin
                    if ((not SalesInvLine."Allow Invoice Disc.") and (SalesInvLine.Type = SalesInvLine.Type::Item)) then
                        Rule.SetFilter("Discount and comm. type", '<>%1', Rule."Discount and comm. type"::"Footer discount");
                end;
            end;
        end;

        Rule.SetRange(Type, Rule.Type::Sale);
        Rule.SetFilter("Type Filter", '%1|%2', Rule."Type Filter"::All, SalesInvLine.Type);

        EnTeteVente.Get(SalesInvLine."Document No.");

        Rule.SetFilter("Starting Date", '<=%1', EnTeteVente."Posting Date");
        Rule.SetFilter("Ending Date", '>=%1', EnTeteVente."Posting Date");

        if not Rule.Find('-') then
            exit
        else begin
            SearchDim;
            SalesInvLine2.SetRange("Document No.", SalesInvLine."Document No.");
            SalesInvLine2.SetRange("Line No.", SalesInvLine."Line No.");

            repeat

                //Conversion du coefficient
                if (Rule."Calc method" = Rule."Calc method"::"Quantité * Coefficient") or
                   (Rule."Calc method" = Rule."Calc method"::"Quantité (base) * Coefficient") then
                    Coeff := TxChange.ExchangeAmtLCYToFCY(EnTeteVente."Posting Date", EnTeteVente."Currency Code",
                                 Rule.Coefficient, EnTeteVente."Currency Factor")
                else
                    Coeff := Rule.Coefficient;

                CoeffLCY := Rule.Coefficient;

                if EnTeteVente."Currency Code" <> '' then begin
                    Devise.Get(EnTeteVente."Currency Code");
                    AmountLCY := TxChange.ExchangeAmtFCYToLCY(
                                     EnTeteVente."Posting Date", EnTeteVente."Currency Code",
                                     SalesInvLine."Line Amount", EnTeteVente."Currency Factor")
               ;
                end else begin
                    Devise.Init;
                    AmountLCY := SalesInvLine."Line Amount";
                end;
                SourceAmount := SalesInvLine."Line Amount";

                if (Rule."Amount Filter (LCY)" <> '') then begin
                    if (EnTeteVente."Currency Code" = '') then begin
                        SalesInvLine2.SetFilter(Amount, Rule."Amount Filter (LCY)");
                        RechercheVente(SalesInvLine);
                    end else begin
                        SalesInvLineTmp := SalesInvLine;
                        SalesInvLineTmp.Amount := AmountLCY;
                        SalesInvLineTmp.Insert;
                        SalesInvLineTmp.SetRange("Document No.", SalesInvLine."Document No.");
                        SalesInvLineTmp.SetRange("Line No.", SalesInvLine."Line No.");
                        SalesInvLineTmp.SetFilter("Line Amount", Rule."Amount Filter (LCY)");
                        if SalesInvLineTmp.Find('-') then
                            RechercheVente(SalesInvLine);
                    end;
                end else begin
                    SalesInvLine2.SetFilter("Line Amount", Rule."Amount filter");
                    RechercheVente(SalesInvLine);
                end;
            until Rule.Next = 0;
        end;
    end;

    [Scope('OnPrem')]
    procedure RechercheVente(SalesInvLine: Record "Sales Invoice Line")
    begin
        EnTeteVente2.SetRange("No.", SalesInvLine."Document No.");
        EnTeteVente2.SetFilter("Salesperson Code", Rule."Salespers./Purch. Filter");
        EnTeteVente2.SetFilter("Customer Posting Group", Rule."Source Posting Group Filter");
        EnTeteVente2.SetFilter("Gen. Bus. Posting Group", Rule."Gen. Bus. Posting Group filter");
        EnTeteVente2.SetFilter("Customer Price Group", Rule."Price code filter");
        EnTeteVente2.SetFilter("Customer Disc. Group", Rule."Cust./Item Disc. Gr. filter");
        EnTeteVente2.SetFilter("Bill-to Customer No.", Rule."Source Filter");
        EnTeteVente2.SetFilter("Reason Code", Rule."Reason Code filter");
        EnTeteVente2.SetFilter("Currency Code", Rule."Currency Filter");
        if EnTeteVente2.Find('-') then begin
            //Customer Criteria
            Clt.Reset;
            Clt.SetFilter("No.", EnTeteVente2."Bill-to Customer No.");
            Clt.SetFilter("Criteria 1", Rule."Customer criteria filter 1");
            Clt.SetFilter("Criteria 2", Rule."Customer criteria filter 2");
            Clt.SetFilter("Criteria 3", Rule."Customer criteria filter 3");
            Clt.SetFilter("Criteria 4", Rule."Customer criteria filter 4");
            Clt.SetFilter("Criteria 5", Rule."Customer criteria filter 5");
            Clt.SetFilter("Criteria 6", Rule."Customer criteria filter 6");
            Clt.SetFilter("Criteria 7", Rule."Customer criteria filter 7");
            Clt.SetFilter("Criteria 8", Rule."Customer criteria filter 8");
            Clt.SetFilter("Criteria 9", Rule."Customer criteria filter 9");
            Clt.SetFilter("Criteria 10", Rule."Customer criteria filter 10");
            if Clt.Find('-') then begin
                SalesInvLine2.SetFilter("Shortcut Dimension 1 Code", Rule."Global Dimension 1 Filter");
                SalesInvLine2.SetFilter("Shortcut Dimension 2 Code", Rule."Global Dimension 2 Filter");
                SalesInvLine2.SetFilter("Gen. Prod. Posting Group", Rule."Gen.Prod. Posting Group filter");
                SalesInvLine2.SetFilter("Posting Group", Rule."Inventory Posting Group filter");
                SalesInvLine2.SetFilter("No.", Rule."No. filter");
                SalesInvLine2.SetFilter(Quantity, Rule."Quantity filter");
                SalesInvLine2.SetFilter("Job No.", Rule."Job Filter");
                SalesInvLine2.SetFilter("Return Reason Code", Rule."Return Reason Code Filter");

                //--> ADV-001 ABSYS GN 20061018
                SalesInvLine2.SetFilter("Reason Free Code", Rule."Free Code Filter");
                //SalesInvLine2.SETFILTER("Special Discount Code",Rule."Special Discount Filter");
                SalesInvLine2.SetRange("Allow Invoice Disc.", true);
                //<-- ADV-001 ABSYS GN 20061018

                if SalesInvLine2.Find('-') then
                    if GetDimFilter(113, SalesInvLine2."Document No.", SalesInvLine2."Line No.") then begin
                        case SalesInvLine2.Type of
                            SalesInvLine2.Type::Item:
                                if GetItemFilter(SalesInvLine2."No.") then
                                    EcrireRemiseLigneVente(SalesInvLine2);
                            SalesInvLine2.Type::"G/L Account", SalesInvLine2.Type::Resource, SalesInvLine2.Type::"Charge (Item)":
                                EcrireRemiseLigneVente(SalesInvLine2);
                        end;
                        case Rule."Continue calculation" of
                            Rule."Continue calculation"::No:
                                exit;
                            else
                                if not RechercheLoiSuivante(SalesInvLine."Allow Invoice Disc.", SalesInvLine.Type.AsInteger()) then exit;
                        end;
                    end;
            end;
        end;
    end;

    [Scope('OnPrem')]
    procedure EcrireRemiseLigneVente(SalesInvLine: Record "Sales Invoice Line")
    var
        EcrRemiseLig: Record "Posted Sales Discount Entry";
        GLSetup: Record "General Ledger Setup";
        PrecArrondi: Decimal;
    begin
        GLSetup.Get;

        if not LineDiscEntry.Get(LineDiscEntry."Document Type"::"Posted Invoice", SalesInvLine."Document No.", SalesInvLine."Line No.",
                             Rule."Discount and comm. type", Rule."No.") then begin
            LineDiscEntry."Document Type" := LineDiscEntry."Document Type"::"Posted Invoice";
            LineDiscEntry."Document No." := SalesInvLine."Document No.";
            LineDiscEntry."Line No." := SalesInvLine."Line No.";
            LineDiscEntry.Type := Rule.Type;
            LineDiscEntry."Disc. Commission Type" := Rule."Discount and comm. type";
            LineDiscEntry."Rule No." := Rule."No.";
            LineDiscEntry."Continue Calculation" := Rule."Continue calculation";
            LineDiscEntry.Basis := Rule.Basis;

            //--> ADV-002 ABSYS GN 20061018
            LineDiscEntry."Special Offer" := Rule."Special Offer";
            //<-- ADV-002 ABSYS GN 20061018

            //--> ADV-001 ABSYS GN 20061018
            LineDiscEntry."Resaon Free Code" := SalesInvLine."Reason Free Code";
            LineDiscEntry."Free Line" := SalesInvLine."Free Line";
            //<-- ADV-001 ABSYS GN 20061018

            BaseACalculer(Rule, SalesInvLine.Quantity, SalesInvLine."Quantity (Base)", AmountLCY, SourceAmount);

            //--> ADV-002 ABSYS GN 20061018
            LineDiscEntry."Quantity (base)" := SalesInvLine."Quantity (Base)";
            //<-- ADV-002 ABSYS GN 20061018

            LineDiscEntry.Coefficient := Coeff;
            LineDiscEntry."Coefficient (LCY)" := CoeffLCY;
            CalculMontantComBase(BaseCalcul, BaseCalculLCY, Coeff, CoeffLCY, Rule, TotalLineDisc, TotalFootDisc, TotalRFADisc,
                                 TotalLineDiscLCY, TotalFootDiscLCY, TotalRFADiscLCY);
            if Devise.Code <> '' then
                Com := Round(Com, Devise."Amount Rounding Precision")
            else begin
                if GLSetup."Amount Rounding Precision" <> 0 then
                    Com := Round(Com, GLSetup."Amount Rounding Precision");
            end;
            LineDiscEntry.Base := BaseCalcul;
            LineDiscEntry."Discount Amount" := Com;
            if GLSetup."Amount Rounding Precision" <> 0 then
                ComLCY := Round(ComLCY, GLSetup."Amount Rounding Precision");
            LineDiscEntry."Base (LCY)" := BaseCalculLCY;
            LineDiscEntry."Discount Amount (LCY)" := ComLCY;
            if Com <> 0 then begin
                LineDiscEntry.Insert;
            end;
        end else begin
            BaseACalculer(Rule, SalesInvLine.Quantity, SalesInvLine."Quantity (Base)", AmountLCY, SourceAmount);
            LineDiscEntry.Base := BaseCalcul;
            LineDiscEntry."Base (LCY)" := BaseCalculLCY;
            LineDiscEntry.Coefficient := Coeff;
            LineDiscEntry."Coefficient (LCY)" := CoeffLCY;
            CalculMontantComBase(BaseCalcul, BaseCalculLCY, Coeff, CoeffLCY, Rule, TotalLineDisc, TotalFootDisc, TotalRFADisc,
                                 TotalLineDiscLCY, TotalFootDiscLCY, TotalRFADiscLCY);
            if Devise.Code <> '' then
                Com := Round(Com, Devise."Amount Rounding Precision")
            else
                if GLSetup."Amount Rounding Precision" <> 0 then
                    Com := Round(Com, GLSetup."Amount Rounding Precision");
            LineDiscEntry."Discount Amount" := Com;
            if GLSetup."Amount Rounding Precision" <> 0 then
                ComLCY := Round(ComLCY, GLSetup."Amount Rounding Precision");
            LineDiscEntry."Discount Amount (LCY)" := ComLCY;
            if (Com <> 0) or (ComLCY <> 0) then
                LineDiscEntry.Modify
            else
                LineDiscEntry.Delete;
        end;

        //ADV-001 ABSYS BT 20061102
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

                if Rule.GetQtyBaseOnRuleEntry() >= Rule."Quantity (Base) Maximum" - LineDiscEntry."Quantity (base)" then begin
                    //-- Cas 1 ----
                    Error(Text50001, LineDiscEntry."Document Type", LineDiscEntry."Document No.",
                        LineDiscEntry."Line No.", Rule."Quantity (Base) Maximum", Rule.GetQtyBaseOnRuleEntry(),
                        LineDiscEntry."Rule No.");
                end else begin
                    //-- Cas 2 ----
                    LineDiscEntry.Delete;
                end;
            end;
        end;
        //ADV-001 ABSYS BT 20061102<<
    end;

    [Scope('OnPrem')]
    procedure RemiseLigneAchat(LigAchat: Record "Purch. Inv. Line")
    var
        TxChange: Record "Currency Exchange Rate";
        EnTeteAchat: Record "Purch. Inv. Header";
        LigAchatTmp: Record "Purch. Inv. Line" temporary;
    begin
        DiscountLine.SetRange("Document Type", DiscountLine."Document Type"::"Posted Invoice");
        DiscountLine.SetRange("Document No.", LigAchat."Document No.");
        DiscountLine.SetRange("Line No.", LigAchat."Line No.");

        DiscountLine.SetRange("Disc. Commission Type", DiscountLine."Disc. Commission Type"::"Line Discount");
        DiscountLine.CalcSums("Discount Amount (LCY)", "Discount Amount");
        TotalLineDisc := DiscountLine."Discount Amount";
        TotalLineDiscLCY := DiscountLine."Discount Amount (LCY)";

        DiscountLine.SetRange("Disc. Commission Type", DiscountLine."Disc. Commission Type"::"Footer Discount");
        DiscountLine.CalcSums("Discount Amount (LCY)", "Discount Amount");
        TotalFootDisc := DiscountLine."Discount Amount";
        TotalFootDiscLCY := DiscountLine."Discount Amount (LCY)";

        DiscountLine.SetRange("Disc. Commission Type", DiscountLine."Disc. Commission Type"::"Back Discount");
        DiscountLine.CalcSums("Discount Amount (LCY)", "Discount Amount");
        TotalRFADisc := DiscountLine."Discount Amount";
        TotalRFADiscLCY := DiscountLine."Discount Amount (LCY)";

        TotalCom := 0;
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
                    if ((LigAchat."Allow Invoice Disc." and (LigAchat.Type = LigAchat.Type::Item)) or
                        (LigAchat.Type <> LigAchat.Type::Item)) then
                        Rule.SetFilter("Discount and comm. type", '<=%1', Rule."Discount and comm. type"::"Footer discount")
                    else
                        Rule.SetRange("Discount and comm. type", Rule."Discount and comm. type"::"Line discount");
                end else begin
                    if ((LigAchat."Allow Invoice Disc." and (LigAchat.Type = LigAchat.Type::Item)) or
                        (LigAchat.Type <> LigAchat.Type::Item)) then
                        Rule.SetFilter("Discount and comm. type", '<>%1', Rule."Discount and comm. type"::"Back discount")
                    else
                        Rule.SetFilter("Discount and comm. type", '%1|%2', Rule."Discount and comm. type"::"Line discount",
                                      Rule."Discount and comm. type"::Commission);
                end;
            end else begin
                if not DiscountSetup."Calc. Purch. Line Commission" then begin
                    if ((LigAchat."Allow Invoice Disc." and (LigAchat.Type = LigAchat.Type::Item)) or
                        (LigAchat.Type <> LigAchat.Type::Item)) then
                        Rule.SetFilter("Discount and comm. type", '<>%1', Rule."Discount and comm. type"::Commission)
                    else
                        Rule.SetFilter("Discount and comm. type", '<>%1&<>%2', Rule."Discount and comm. type"::"Footer discount",
                                      Rule."Discount and comm. type"::Commission);
                end else begin
                    if ((not LigAchat."Allow Invoice Disc.") and (LigAchat.Type = LigAchat.Type::Item)) then
                        Rule.SetFilter("Discount and comm. type", '<>%1', Rule."Discount and comm. type"::"Footer discount");
                end;
            end;
        end;

        Rule.SetRange(Type, Rule.Type::Purchase);
        Rule.SetFilter("Type Filter", '%1|%2', Rule."Type Filter"::All, LigAchat.Type);

        EnTeteAchat.Get(LigAchat."Document No.");

        Rule.SetFilter("Starting Date", '<=%1', EnTeteAchat."Posting Date");
        Rule.SetFilter("Ending Date", '>=%1', EnTeteAchat."Posting Date");

        if not Rule.Find('-') then
            exit
        else begin
            SearchDim;
            LigAchat2.SetRange("Document No.", LigAchat."Document No.");
            LigAchat2.SetRange("Line No.", LigAchat."Line No.");

            repeat

                //Conversion du coefficient
                if (Rule."Calc method" = Rule."Calc method"::"Quantité * Coefficient") or
                   (Rule."Calc method" = Rule."Calc method"::"Quantité (base) * Coefficient") then
                    Coeff := TxChange.ExchangeAmtLCYToFCY(EnTeteAchat."Posting Date", EnTeteAchat."Currency Code",
                                   Rule.Coefficient, EnTeteAchat."Currency Factor")
                else
                    Coeff := Rule.Coefficient;

                CoeffLCY := Rule.Coefficient;

                if EnTeteAchat."Currency Code" <> '' then begin
                    Devise.Get(EnTeteAchat."Currency Code");
                    AmountLCY := TxChange.ExchangeAmtFCYToLCY(EnTeteAchat."Posting Date", EnTeteAchat."Currency Code",
                                                                            LigAchat.Amount, EnTeteAchat."Currency Factor");
                end else begin
                    Devise.Init;
                    AmountLCY := LigAchat.Amount;
                end;
                SourceAmount := LigAchat.Amount;

                if (Rule."Amount Filter (LCY)" <> '') then begin
                    if (EnTeteAchat."Currency Code" = '') then begin
                        LigAchat2.SetFilter(Amount, Rule."Amount Filter (LCY)");
                        RechercheAchat(LigAchat);
                    end else begin
                        LigAchatTmp := LigAchat;
                        LigAchatTmp.Amount := AmountLCY;
                        LigAchatTmp.Insert;
                        LigAchatTmp.SetRange("Document No.", LigAchat."Document No.");
                        LigAchatTmp.SetRange("Line No.", LigAchat."Line No.");
                        LigAchatTmp.SetFilter(Amount, Rule."Amount Filter (LCY)");
                        if LigAchatTmp.Find('-') then
                            RechercheAchat(LigAchat);
                    end;
                end else begin
                    LigAchat2.SetFilter(Amount, Rule."Amount filter");
                    RechercheAchat(LigAchat);
                end;
            until Rule.Next = 0;
        end;
    end;

    [Scope('OnPrem')]
    procedure RechercheAchat(LigAchat: Record "Purch. Inv. Line")
    begin
        EnTeteAchat2.SetRange("No.", LigAchat."Document No.");
        EnTeteAchat2.SetFilter("Purchaser Code", Rule."Salespers./Purch. Filter");
        EnTeteAchat2.SetFilter("Vendor Posting Group", Rule."Source Posting Group Filter");
        EnTeteAchat2.SetFilter("Gen. Bus. Posting Group", Rule."Gen. Bus. Posting Group filter");
        EnTeteAchat2.SetFilter("Pay-to Vendor No.", Rule."Source Filter");
        EnTeteAchat2.SetFilter("Reason Code", Rule."Reason Code filter");
        EnTeteAchat2.SetFilter("Currency Code", Rule."Currency Filter");
        if EnTeteAchat2.Find('-') then begin
            LigAchat2.SetFilter("Shortcut Dimension 1 Code", Rule."Global Dimension 1 Filter");
            LigAchat2.SetFilter("Shortcut Dimension 2 Code", Rule."Global Dimension 2 Filter");
            LigAchat2.SetFilter("Gen. Prod. Posting Group", Rule."Gen.Prod. Posting Group filter");
            LigAchat2.SetFilter("Posting Group", Rule."Inventory Posting Group filter");
            LigAchat2.SetFilter("No.", Rule."No. filter");
            LigAchat2.SetFilter(Quantity, Rule."Quantity filter");
            LigAchat2.SetFilter(Amount, Rule."Amount filter");
            LigAchat2.SetFilter("Job No.", Rule."Job Filter");
            LigAchat2.SetFilter("Return Reason Code", Rule."Return Reason Code Filter");
            if LigAchat2.Find('-') then
                if GetDimFilter(123, LigAchat2."Document No.", LigAchat2."Line No.") then begin
                    case LigAchat2.Type of
                        LigAchat2.Type::Item:
                            if GetItemFilter(LigAchat2."No.") then
                                EcrireRemiseLigneAchat(LigAchat2);
                        LigAchat2.Type::"G/L Account", LigAchat2.Type::"Fixed Asset":
                            EcrireRemiseLigneAchat(LigAchat2);
                    end;
                    case Rule."Continue calculation" of
                        Rule."Continue calculation"::No:
                            exit;
                        else
                            if not RechercheLoiSuivante(LigAchat."Allow Invoice Disc.", LigAchat.Type.AsInteger()) then exit;
                    end;
                end;
        end;
    end;

    [Scope('OnPrem')]
    procedure EcrireRemiseLigneAchat(LigAchat: Record "Purch. Inv. Line")
    var
        LineDiscEntry: Record "Posted Purchase Discount Entry";
        GLSetup: Record "General Ledger Setup";
        PrecArrondi: Decimal;
    begin
        GLSetup.Get;
        if not LineDiscEntry.Get(LineDiscEntry."Document Type"::"Posted Invoice", LigAchat."Document No.", LigAchat."Line No.",
                             Rule."Discount and comm. type", Rule."No.") then begin
            LineDiscEntry."Document Type" := LineDiscEntry."Document Type"::"Posted Invoice";
            LineDiscEntry."Document No." := LigAchat."Document No.";
            LineDiscEntry."Line No." := LigAchat."Line No.";
            LineDiscEntry.Type := Rule.Type;
            LineDiscEntry."Disc. Commission Type" := Rule."Discount and comm. type";
            LineDiscEntry."Rule No." := Rule."No.";
            LineDiscEntry."Continue Calculation" := Rule."Continue calculation";
            LineDiscEntry.Basis := Rule.Basis;
            BaseACalculer(Rule, LigAchat.Quantity, LigAchat."Quantity (Base)", AmountLCY, SourceAmount);
            LineDiscEntry.Coefficient := Coeff;
            LineDiscEntry."Coefficient (LCY)" := CoeffLCY;
            CalculMontantComBase(BaseCalcul, BaseCalculLCY, Coeff, CoeffLCY, Rule, TotalLineDisc, TotalFootDisc, TotalRFADisc,
                                 TotalLineDiscLCY, TotalFootDiscLCY, TotalRFADiscLCY);
            if Devise.Code <> '' then
                Com := Round(Com, Devise."Amount Rounding Precision")
            else begin
                if GLSetup."Amount Rounding Precision" <> 0 then
                    Com := Round(Com, GLSetup."Amount Rounding Precision");
            end;
            LineDiscEntry.Base := BaseCalcul;
            LineDiscEntry."Discount Amount" := Com;
            if GLSetup."Amount Rounding Precision" <> 0 then
                ComLCY := Round(ComLCY, GLSetup."Amount Rounding Precision");
            LineDiscEntry."Base (LCY)" := BaseCalculLCY;
            LineDiscEntry."Discount Amount (LCY)" := ComLCY;
            if Com <> 0 then begin
                LineDiscEntry.Insert;
            end;
        end else begin
            BaseACalculer(Rule, LigAchat.Quantity, LigAchat."Quantity (Base)", AmountLCY, SourceAmount);
            LineDiscEntry.Base := BaseCalcul;
            LineDiscEntry."Base (LCY)" := BaseCalculLCY;
            LineDiscEntry.Coefficient := Coeff;
            LineDiscEntry."Coefficient (LCY)" := CoeffLCY;
            CalculMontantComBase(BaseCalcul, BaseCalculLCY, Coeff, CoeffLCY, Rule, TotalLineDisc, TotalFootDisc, TotalRFADisc,
                                 TotalLineDiscLCY, TotalFootDiscLCY, TotalRFADiscLCY);
            if Devise.Code <> '' then
                Com := Round(Com, Devise."Amount Rounding Precision")
            else
                if GLSetup."Amount Rounding Precision" <> 0 then
                    Com := Round(Com, GLSetup."Amount Rounding Precision");
            LineDiscEntry."Discount Amount" := Com;
            if GLSetup."Amount Rounding Precision" <> 0 then
                ComLCY := Round(ComLCY, GLSetup."Amount Rounding Precision");
            LineDiscEntry."Discount Amount (LCY)" := ComLCY;
            if (Com <> 0) or (ComLCY <> 0) then
                LineDiscEntry.Modify
            else
                LineDiscEntry.Delete;
        end;
    end;

    [Scope('OnPrem')]
    procedure BaseACalculer(DiscRule: Record "Discount Rule"; Qty: Decimal; BasisQty: Decimal; AmountLCY: Decimal; SourceAmount: Decimal) BaseCalc: Decimal
    begin
        case DiscRule."Calc method" of
            DiscRule."Calc method"::"Quantité * Coefficient":
                begin
                    BaseCalculLCY := Qty;
                    BaseCalcul := Qty;
                end;
            DiscRule."Calc method"::"Quantité (base) * Coefficient":
                begin
                    BaseCalculLCY := BasisQty;
                    BaseCalcul := BasisQty;
                end;
            DiscRule."Calc method"::"Montant * Coefficient":
                begin
                    BaseCalculLCY := AmountLCY;
                    BaseCalcul := SourceAmount;
                end;
            //Renseigner ici la Base de Calcul
            DiscRule."Calc method"::"Base spécifique * Coefficient":
                begin
                    BaseCalculLCY := 0;
                    BaseCalcul := 0;
                end;
        end;
        BaseCalc := BaseCalculLCY;
    end;

    [Scope('OnPrem')]
    procedure CalculMontantComBase(var BaseCalc: Decimal; var BaseCalcLCY: Decimal; Coefficient: Decimal; CoefficientLCY: Decimal; LoiCom: Record "Discount Rule"; CumulLigne: Decimal; CumulPied: Decimal; CumulRFA: Decimal; CumulLigneLCY: Decimal; CumulPiedLCY: Decimal; CumulRFALCY: Decimal) Remise: Decimal
    var
        TamponComRem: Record "Disc. Commission Buffer";
        SommeRem: Decimal;
    begin
        Rule := Rule;
        BaseCalcul := BaseCalc;
        BaseCalculLCY := BaseCalcLCY;
        TotalLineDisc := CumulLigne;
        TotalFootDisc := CumulPied;
        TotalRFADisc := CumulRFA;
        TotalLineDiscLCY := CumulLigneLCY;
        TotalFootDiscLCY := CumulPiedLCY;
        TotalRFADiscLCY := CumulRFALCY;

        case Rule."Calc method" of
            Rule."Calc method"::"Base spécifique * Coefficient":
                CalculSpecifique(Rule.Coefficient)
            else begin
                case Rule.Basis of
                    Rule.Basis::Gross:
                        begin
                            BaseCalcul := BaseCalcul;
                            BaseCalculLCY := BaseCalculLCY;
                        end;
                    Rule.Basis::"Net line":
                        begin
                            BaseCalcul := BaseCalcul - TotalLineDisc;
                            BaseCalculLCY := BaseCalculLCY - TotalLineDiscLCY;
                        end;
                    Rule.Basis::"Net footer":
                        begin
                            BaseCalcul := BaseCalcul - TotalLineDisc - TotalFootDisc;
                            BaseCalculLCY := BaseCalculLCY - TotalLineDiscLCY - TotalFootDiscLCY;
                        end;
                    Rule.Basis::"Net back discount":
                        begin
                            BaseCalcul := BaseCalcul - TotalLineDisc - TotalFootDisc - TotalRFADisc;
                            BaseCalculLCY := BaseCalculLCY - TotalLineDiscLCY - TotalFootDiscLCY - TotalRFADiscLCY;
                        end;
                end;
                Com := Coefficient * BaseCalcul;
                ComLCY := CoefficientLCY * BaseCalculLCY;
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
            end;
        end;
        Remise := ComLCY;
        exit(ComLCY);
    end;

    [Scope('OnPrem')]
    procedure CalculSpecifique(Coef: Decimal)
    begin
        //Calcul de la commission et de la base lorsque la méthode de calcul est Base spécifique * Coefficient
        //Le coefficient est passé en paramètre
        //Pour le calcul suivant, renseigner TotalCom

        Com := 0.0;
    end;

    [Scope('OnPrem')]
    procedure Increment(var Nombre1: Decimal; Nombre2: Decimal)
    begin
        Nombre1 := Nombre1 + Nombre2;
    end;

    [Scope('OnPrem')]
    procedure RechercheLoiSuivante(RemiseFact: Boolean; TypeLigne: Option " ","Compte général",Article,Ressource): Boolean
    begin
        if TypeLigne <> TypeLigne::Article then
            RemiseFact := true;

        if Rule.Type = Rule.Type::Sale then begin

            case Rule."Continue calculation" of

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
            Get(ItemNo);
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
}

