codeunit 50004 "Create Item Free Line"
{
    // Absys ADV.14 : Gestion des remises X article A => Y article B offert.
    // 
    // Absys GJ : Prise en compte des traductions si disponibles
    // 
    // GEO ne compilait plus avant import

    TableNo = "Sales Line";

    trigger OnRun()
    var
        RecRuleItemFreeTMP_l: Record "Discount Rule" temporary;
        SalesLineExists_l: Record "Sales Line";
    begin
        //---------------------------------------
        // On ne traite pas les lignes gratuites
        //---------------------------------------
        if (Type <> Type::Item)
          or ("Source Line No. Item Free" <> 0)
          or "Free Line"
          or ("Quantity (Base)" = 0) then
            exit;

        if not SalesLineExists_l.Get("Document Type", "Document No.", "Line No.") then
            exit; //(la ligne n'existe pas encore)

        Modify;

        SearchDim();
        DeleteExistingFreeLineLinked(Rec);
        SearchRuleItemFree(Rec, RecRuleItemFreeTMP_l);
        CreateItemFreeSalesLine(Rec, RecRuleItemFreeTMP_l);
    end;

    var
        Text50005: Label 'La quantité (base) %1  saisie sur la commande %2 article %3 \dépasse la Qté (base ) maxi de %4 de la loi %5. \La maximum autorisé sur cette ligne est %6. \Le reste doit être saisi sur une autre ligne.';
        StatSetupShortcutDimCode: array[20] of Code[20];
        ExistDim: Boolean;
        RuleDimFilter: array[20] of Text[100];

    [Scope('OnPrem')]
    procedure DeleteExistingFreeLineLinked(RecSalesLine_p: Record "Sales Line")
    var
        RecSalesLine_l: Record "Sales Line";
    begin
        //---------------------------------------------------------
        // Recherche des lignes précedent créer pour les supprimer
        //---------------------------------------------------------
        with RecSalesLine_p do begin
            RecSalesLine_l.SetRange("Document Type", "Document Type");
            RecSalesLine_l.SetRange("Document No.", "Document No.");
            RecSalesLine_l.SetRange("Source Line No. Item Free", "Line No.");
            RecSalesLine_l.DeleteAll(true);
        end;
    end;

    [Scope('OnPrem')]
    procedure SearchRuleItemFree(RecSalesLine_p: Record "Sales Line"; var RecRuleItemFreeTMP_p: Record "Discount Rule" temporary)
    var
        RecRuleItemFree_l: Record "Discount Rule";
        RecSalesHeader_l: Record "Sales Header";
    begin
        //-----------------------------------------
        // Renvoi en paramètre, la liste des lois
        // Applicable sur la ligne de vente
        //-----------------------------------------

        with RecRuleItemFree_l do begin
            RecSalesHeader_l.Get(RecSalesLine_p."Document Type", RecSalesLine_p."Document No.");

            SetRange("Discount and comm. type", "Discount and comm. type"::"Item Free");
            SetFilter("Starting Date", '<=%1', RecSalesHeader_l."Order Date");
            SetFilter("Ending Date", '>=%1', RecSalesHeader_l."Order Date");

            if Find('-') then
                repeat
                    if ThisRuleIsApplicable(RecSalesLine_p, RecRuleItemFree_l) then begin
                        RecRuleItemFreeTMP_p.Init;
                        RecRuleItemFreeTMP_p.TransferFields(RecRuleItemFree_l);
                        RecRuleItemFreeTMP_p.Insert;
                    end;
                until Next = 0;

        end;
    end;

    [Scope('OnPrem')]
    procedure ThisRuleIsApplicable(RecSalesLine_p: Record "Sales Line"; RecDiscountRule_p: Record "Discount Rule"): Boolean
    var
        RecItem_l: Record Item;
        RecCustomer_l: Record Customer;
    begin
        //---------------------------------------
        // Renvoi Vrai si la loi est applicable
        //---------------------------------------

        //-- Filtre par rapport à l'entête de vente --
        if not GetSalesHeaderFilter(RecSalesLine_p, RecDiscountRule_p) then
            exit(false);

        //-- Filtre par rapport à la ligne de vente --
        if not GetSalesLineFilter(RecSalesLine_p, RecDiscountRule_p) then
            exit(false);

        //-- Filtre par rapport à l'article --
        if not GetCustFilter(RecSalesLine_p."Sell-to Customer No.", RecDiscountRule_p) then
            exit(false);

        //-- Filtre par rapport au client --
        if not GetItemFilter(RecSalesLine_p."No.", RecDiscountRule_p) then
            exit(false);

        //-- Filtre par rapport aux plafonds --
        if RecDiscountRule_p."Quantity (Base) Maximum" <> 0 then begin
            if RecDiscountRule_p.GetQtyBaseOnRuleEntry + RecSalesLine_p."Quantity (Base)"
                > RecDiscountRule_p."Quantity (Base) Maximum" then begin

                // -- test si c'est la ligne en cours qui dépasse
                if RecDiscountRule_p.GetQtyBaseOnRuleEntry < RecDiscountRule_p."Quantity (Base) Maximum" then
                    Error(Text50005, RecSalesLine_p."Quantity (Base)",
                                  RecSalesLine_p."Document No.", RecSalesLine_p."No.",
                                  RecDiscountRule_p."Quantity (Base) Maximum",
                                  RecDiscountRule_p."No.",
                                  (RecDiscountRule_p."Quantity (Base) Maximum" - RecDiscountRule_p.GetQtyBaseOnRuleEntry())
                                  );

                exit(false);
            end;
        end;

        //-- Filtre par rapport aux nombres d'application --
        if RecDiscountRule_p."Application Number Maximum" <> 0 then
            if RecDiscountRule_p.GetApplicationNumber >= RecDiscountRule_p."Application Number Maximum" then
                exit(false);


        //-- La loi est applicable --
        exit(true);
    end;

    [Scope('OnPrem')]
    procedure CreateItemFreeSalesLine(RecSalesLine_p: Record "Sales Line"; var RecRuleItemFreeTMP_p: Record "Discount Rule" temporary)
    var
        Qty_l: Decimal;
        ItemNo_l: Code[20];
        Unit_l: Code[10];
        RecNewSalesLine_l: Record "Sales Line";
        i: Integer;
        LineSpacing_l: Integer;
        NbRule_l: Integer;
        NumNewLine_l: Integer;
        DiscRulesTranslation_l: Record "Alert Management";
        Cust_l: Record Customer;
        RecSalesHeader_l: Record "Sales Header";
    begin
        //---------------------------------------
        // Insertion des lignes d'article offert
        //---------------------------------------

        with RecNewSalesLine_l do begin
            NbRule_l := RecRuleItemFreeTMP_p.Count;
            if RecRuleItemFreeTMP_p.Find('-') then
                repeat
                    CalculItemFree(RecSalesLine_p, RecRuleItemFreeTMP_p, Qty_l, ItemNo_l, Unit_l);
                    if Qty_l <> 0 then begin
                        LineSpacing_l := GetLineSpacing(RecSalesLine_p, NbRule_l);
                        i += 1;

                        //----------------------------------
                        // Insertion de la nouvelle ligne
                        //----------------------------------
                        Init;
                        "Document Type" := RecSalesLine_p."Document Type";
                        "Document No." := RecSalesLine_p."Document No.";
                        "Line No." := RecSalesLine_p."Line No." + i * LineSpacing_l;
                        NumNewLine_l := "Line No.";
                        Validate(Type, RecSalesLine_p.Type);
                        Validate("No.", ItemNo_l);
                        "Source Line No. Item Free" := RecSalesLine_p."Line No.";
                        if Unit_l <> '' then
                            Validate("Unit of Measure Code", Unit_l);
                        Insert();
                        Validate(Quantity, Qty_l);
                        Validate("Free Line", true);
                        Validate("Reason Free Code", RecRuleItemFreeTMP_p."Reason Free Code");
                        "Discount Rule of Item Free" := RecRuleItemFreeTMP_p."No.";
                        "Item Source of Item Free" := RecSalesLine_p."No.";
                        "Qty Item Source of Item Free" := RecSalesLine_p."Quantity (Base)";
                        Modify();

                        //-----------------------------------
                        // Insertion du commentaire
                        //-----------------------------------
                        LineSpacing_l := GetLineSpacing(RecSalesLine_p, NbRule_l);
                        Init;
                        "Document Type" := RecSalesLine_p."Document Type";
                        "Document No." := RecSalesLine_p."Document No.";
                        "Line No." := RecSalesLine_p."Line No." + i * LineSpacing_l;
                        Validate(Type, RecSalesLine_p.Type::" ");
                        "Attached to Line No." := NumNewLine_l;
                        Validate(Description, RecRuleItemFreeTMP_p.Description);

                        // ABSYS GJ 21/06/05 ->
                        RecSalesHeader_l.Get(RecNewSalesLine_l."Document Type", RecNewSalesLine_l."Document No.");
                        if DiscRulesTranslation_l.Get(RecRuleItemFreeTMP_p."Discount and comm. type",
                                                   RecRuleItemFreeTMP_p."No.",
                                                   RecSalesHeader_l."Language Code") then
                            Validate(Description, Format(DiscRulesTranslation_l."Event"));
                        // ABSYS GJ 21/06/05 <-

                        Insert();

                    end;
                until RecRuleItemFreeTMP_p.Next = 0;
        end;
    end;

    [Scope('OnPrem')]
    procedure CalculItemFree(RecSalesLine_p: Record "Sales Line"; RecDiscountRuleTMP_p: Record "Discount Rule" temporary; var Qty_p: Decimal; var ItemNo_p: Code[20]; var Unit_p: Code[10])
    begin
        Qty_p := 0;
        ItemNo_p := '';
        Unit_p := '';

        with RecDiscountRuleTMP_p do begin

            //---------------------------------------
            // Détermination de la quantité offerte
            //---------------------------------------
            case "Calc method of Item Free" of
                "Calc method of Item Free"::"Qty. * Coefficient":
                    Qty_p := RecSalesLine_p.Quantity * "Cofficient of Item Free";
                "Calc method of Item Free"::"Qty. (base) * Coefficient":
                    Qty_p := RecSalesLine_p."Quantity (Base)" * "Cofficient of Item Free";
                //    "Calc method of Item Free"::"Specific Base * Coefficient" :
                //      Qty_p := RecSalesLine_p."Total Volume" * "Cofficient of Item Free";
                "Calc method of Item Free"::"Qty. Fixed":
                    Qty_p := "Qty of Item Free";
            end;

            //----------------------------------------
            // Arrondi de la quantité
            //----------------------------------------
            if "Calc method of Item Free" in ["Calc method of Item Free"::"Qty. * Coefficient",
              "Calc method of Item Free"::"Qty. (base) * Coefficient",
              "Calc method of Item Free"::"Specific Base * Coefficient"] then begin
                case "Rounding Meth. of Item Free" of
                    "Rounding Meth. of Item Free"::Nearest:
                        Qty_p := Round(Qty_p, "Rounding Precis. of Item Free");
                    "Rounding Meth. of Item Free"::Up:
                        Qty_p := Round(Qty_p, "Rounding Precis. of Item Free", '>');
                    "Rounding Meth. of Item Free"::Down:
                        Qty_p := Round(Qty_p, "Rounding Precis. of Item Free", '<');
                end;
            end;

            //------------------------------------------
            // Détermination de l'article et de l'unité
            //------------------------------------------
            case "Item Free Type" of
                "Item Free Type"::"Same Item":
                    begin
                        ItemNo_p := RecSalesLine_p."No.";
                        Unit_p := RecSalesLine_p."Unit of Measure Code";
                    end;
                "Item Free Type"::"Another Item":
                    begin
                        TestField("Item Free No.");
                        TestField("Measure Unit of Item Free");
                        ItemNo_p := "Item Free No.";
                        Unit_p := "Measure Unit of Item Free";
                    end;
            end;

        end;
    end;

    [Scope('OnPrem')]
    procedure GetLineSpacing(var SalesLine: Record "Sales Line"; NbRule_p: Integer) linespacing: Integer
    var
        ToSalesLine: Record "Sales Line";
        Text50000: Label 'Le nombre de ligne est insuffisant pour insérer les articles offerts liés à la ligne %1 %2.';
    begin
        ToSalesLine.Reset;
        ToSalesLine.SetRange("Document Type", SalesLine."Document Type");
        ToSalesLine.SetRange("Document No.", SalesLine."Document No.");
        ToSalesLine := SalesLine;
        if ToSalesLine.Find('>') then begin
            linespacing := (ToSalesLine."Line No." - SalesLine."Line No.") div (1 + 2 * NbRule_p);
            if linespacing = 0 then
                Error(Text50000, SalesLine."Line No.", SalesLine."Document No.");
        end else
            linespacing := 100000;
    end;

    [Scope('OnPrem')]
    procedure GetSalesHeaderFilter(RecSalesLine_p: Record "Sales Line"; RecDiscountRule_p: Record "Discount Rule"): Boolean
    var
        RecSalesHeader_l: Record "Sales Header";
    begin
        //----------------------------------------
        // Renvoi Vrai si l'entete de
        // vente sont conforme au filtre de la loi
        // de remise
        //-----------------------------------------

        with RecSalesHeader_l do begin
            SetRange("Document Type", RecSalesLine_p."Document Type");
            SetRange("No.", RecSalesLine_p."Document No.");

            SetFilter("Salesperson Code", RecDiscountRule_p."Salespers./Purch. Filter");
            SetFilter("Customer Posting Group", RecDiscountRule_p."Source Posting Group Filter");
            SetFilter("Gen. Bus. Posting Group", RecDiscountRule_p."Gen. Bus. Posting Group filter");
            SetFilter("Customer Price Group", RecDiscountRule_p."Price code filter");
            SetFilter("Customer Disc. Group", RecDiscountRule_p."Cust./Item Disc. Gr. filter");
            SetFilter("Bill-to Customer No.", RecDiscountRule_p."Source Filter");
            SetFilter("Reason Code", RecDiscountRule_p."Reason Code filter");
            SetFilter("Currency Code", RecDiscountRule_p."Currency Filter");
            exit(Find('-'));
        end;
    end;

    [Scope('OnPrem')]
    procedure GetSalesLineFilter(RecSalesLine_p: Record "Sales Line"; RecDiscountRule_p: Record "Discount Rule"): Boolean
    var
        RecSalesLine_l: Record "Sales Line";
    begin
        //----------------------------------------
        // Renvoi Vrai si la ligne de
        // vente sont conforme au filtre de la loi
        // de remise
        //-----------------------------------------

        with RecSalesLine_l do begin
            SetRange("Document Type", RecSalesLine_p."Document Type");
            SetRange("Document No.", RecSalesLine_p."Document No.");
            SetRange("Line No.", RecSalesLine_p."Line No.");

            // Filtre sur les critères

            SetFilter("Shortcut Dimension 1 Code", RecDiscountRule_p."Global Dimension 1 Filter");
            SetFilter("Shortcut Dimension 2 Code", RecDiscountRule_p."Global Dimension 2 Filter");
            SetFilter("Gen. Prod. Posting Group", RecDiscountRule_p."Gen.Prod. Posting Group filter");
            SetFilter("Posting Group", RecDiscountRule_p."Inventory Posting Group filter");
            SetFilter("No.", RecDiscountRule_p."No. filter");
            SetFilter(Quantity, RecDiscountRule_p."Quantity filter");
            SetFilter("Job No.", RecDiscountRule_p."Job Filter");
            SetFilter("Return Reason Code", RecDiscountRule_p."Return Reason Code Filter");
            SetFilter("Reason Free Code", RecDiscountRule_p."Free Code Filter");

            // Filtre sur les qté
            SetFilter(Quantity, RecDiscountRule_p."Quantity filter");
            SetFilter("Quantity (Base)", RecDiscountRule_p."Quantity (base) filter");

            if Find('-') then
                if GetDimFilter(37, "Document Type".AsInteger(), "Document No.", "Line No.", RecDiscountRule_p) then
                    exit(true);

        end;

        exit(false);
    end;

    [Scope('OnPrem')]
    procedure GetItemFilter(ItemNo_p: Code[20]; RecDiscountRule_p: Record "Discount Rule"): Boolean
    var
        Item: Record Item;
    begin
        //--------------------------------------
        // Renvoi Vrai si l'article de la ligne
        // est conforme au filtre de la loi
        // de remise
        //--------------------------------------

        with Item do begin
            SetFilter("No.", ItemNo_p);
            SetFilter("Criteria 1", RecDiscountRule_p."Item criteria filter 1");
            SetFilter("Criteria 2", RecDiscountRule_p."Item criteria filter 2");
            SetFilter("Criteria 3", RecDiscountRule_p."Item criteria filter 3");
            SetFilter("Criteria 4", RecDiscountRule_p."Item criteria filter 4");
            SetFilter("Criteria 5", RecDiscountRule_p."Item criteria filter 5");
            SetFilter("Criteria 6", RecDiscountRule_p."Item criteria filter 6");
            SetFilter("Criteria 7", RecDiscountRule_p."Item criteria filter 7");
            SetFilter("Criteria 8", RecDiscountRule_p."Item criteria filter 8");
            SetFilter("Criteria 9", RecDiscountRule_p."Item criteria filter 9");
            SetFilter("Criteria 10", RecDiscountRule_p."Item criteria filter 10");
            SetFilter("Manufacturer Code", RecDiscountRule_p."Manufacturer Code Filter");
            SetFilter("Item Category Code", RecDiscountRule_p."Item Category Code Filter");
            SetFilter("Service Item Group", RecDiscountRule_p."Service Item Group Filter");
            SetFilter("Item Disc. Group", RecDiscountRule_p."Item/Cust. Disc. Gr. filter");
            exit(Find('-'));
        end;
    end;

    [Scope('OnPrem')]
    procedure GetCustFilter(CustNo_p: Code[20]; RecDiscountRule_p: Record "Discount Rule"): Boolean
    var
        Customer_l: Record Customer;
    begin
        //--------------------------------------
        // Renvoi Vrai si le client de la ligne
        // est conforme au filtre de la loi
        // de remise
        //--------------------------------------

        with Customer_l do begin
            SetFilter("No.", CustNo_p);
            SetFilter("Criteria 1", RecDiscountRule_p."Customer criteria filter 1");
            SetFilter("Criteria 2", RecDiscountRule_p."Customer criteria filter 2");
            SetFilter("Criteria 3", RecDiscountRule_p."Customer criteria filter 3");
            SetFilter("Criteria 4", RecDiscountRule_p."Customer criteria filter 4");
            SetFilter("Criteria 5", RecDiscountRule_p."Customer criteria filter 5");
            SetFilter("Criteria 6", RecDiscountRule_p."Customer criteria filter 6");
            SetFilter("Criteria 7", RecDiscountRule_p."Customer criteria filter 7");
            SetFilter("Criteria 8", RecDiscountRule_p."Customer criteria filter 8");
            SetFilter("Criteria 9", RecDiscountRule_p."Customer criteria filter 9");
            SetFilter("Criteria 10", RecDiscountRule_p."Customer criteria filter 10");

            // !!! A completer !!!!

            exit(Find('-'));
        end;
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
    procedure GetDimFilter(TableID: Integer; DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; DocNo: Code[20]; LineNo: Integer; Rule: Record "Discount Rule"): Boolean
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


        exit(true);
    end;
}

