codeunit 50009 "Sales Price Calc. Mgt.EC"
{
    // ABC GEN 20090604 : Gestion des remises sur ressource
    //  - Modification fonctions :
    //    - FindSalesLineLineDisc()
    //    - SalesLineLineDiscExists()
    //    - FindSalesLinePrice()
    //  - Création Fonction :
    //    - FindSalesLineDiscResource();
    // 
    // ABC(OLL) - 17/07/2017 - Ajout fonctions SetUoMSalesLines(), IsInMinQtyOrder(), UpdateSalesLinePrice(), TestSalesLinePrice()
    //                       - Ajout appel de ces fonctions pour calcul du prix par quantité de commande globale
    //                       - Ajout code pour prise en compte du "prix départ" quand transporteur 'ENL' = Enlèvement
    // ABC(OLL) - 21/07/2017 - Ajout fonctions CalcBestLineDiscAmount(), SetLineDiscUnitAmount() pour gestion remises par montant unitaire
    //                       - Ajout appel de ces fonctions pour calcul des remises par quantité de commande globale
    // ------------------------------------------------------------------------------------------------------------------------------------
    // ABC(OLL) - 02/08/2017 - Ajout Test "Forced Unit amount" et "Forced Line Discount %" pour ne pas rentrer dans les recherches prix


    trigger OnRun()
    begin
    end;

    var
        GLSetup: Record "General Ledger Setup";
        Item: Record Item;
        Res: Record Resource;
        Currency: Record Currency;
        Text000: Label '%1 is less than %2 in the %3.';
        Text010: Label 'Prices including VAT cannot be calculated when %1 is %2.';
        TempSalesPrice: Record "Sales PriceEC" temporary;
        TempSalesLineDisc: Record "Sales Line DiscountEC" temporary;
        LineDiscPerCent: Decimal;
        Qty: Decimal;
        AllowLineDisc: Boolean;
        AllowInvDisc: Boolean;
        VATPerCent: Decimal;
        PricesInclVAT: Boolean;
        VATCalcType: Option "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        VATBusPostingGr: Code[20];
        QtyPerUOM: Decimal;
        PricesInCurrency: Boolean;
        CurrencyFactor: Decimal;
        ExchRateDate: Date;
        Text018: Label '%1 %2 is greater than %3 and was adjusted to %4.';
        FoundSalesPrice: Boolean;
        Text001: Label 'The %1 in the %2 must be same as in the %3.';
        TempTableErr: Label 'The table passed as a parameter must be temporary.';
        HideResUnitPriceMessage: Boolean;
        DateCaption: Text[30];
        TotalQty: Decimal;
        Text50000: Label 'Missing Price\or Minimum quantity not correct\or adding shipping cost\ on Sales %1 %2.';
        UseLineDiscUnitAmount: Boolean;
        TotalPalettes: Integer;

    procedure FindSalesLinePrice(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; CalledByFieldNo: Integer)
    var
        IsHandled: Boolean;
        recUOM: Record "Item Unit of Measure";
    begin
        IsHandled := false;
        OnBeforeFindSalesLinePrice(SalesLine, SalesHeader, CalledByFieldNo, IsHandled);
        if IsHandled then
            exit;

        with SalesLine do begin
            SetCurrency(
              SalesHeader."Currency Code", SalesHeader."Currency Factor", SalesHeaderExchDate(SalesHeader));
            SetVAT(SalesHeader."Prices Including VAT", "VAT %", "VAT Calculation Type".AsInteger(), "VAT Bus. Posting Group");
            SetUoM(Abs(Quantity), "Qty. per Unit of Measure");
            SetUoMSalesLines(SalesHeader); //ABC(OLL) - 17/07/2017
            SetLineDisc("Line Discount %", "Allow Line Disc.", "Allow Invoice Disc.");

            TestField("Qty. per Unit of Measure");
            if PricesInCurrency then
                SalesHeader.TestField("Currency Factor");

            case Type of
                Type::Item:
                    begin
                        Item.Get("No.");
                        //>> ABC(OLL) - 02/08/2017 - Si option forcer pas de calcul
                        if not SalesLine."Forced Unit Price" then begin
                            //<<
                            SalesLinePriceExists(SalesHeader, SalesLine, false);
                            CalcBestUnitPrice(TempSalesPrice);
                            //        OnAfterFindSalesLineItemPrice(SalesLine,TempSalesPrice,FoundSalesPrice);
                            if FoundSalesPrice or
                               not ((CalledByFieldNo = FieldNo(Quantity)) or
                                    (CalledByFieldNo = FieldNo("Variant Code")))
                            then begin
                                "Allow Line Disc." := TempSalesPrice."Allow Line Disc.";
                                "Allow Invoice Disc." := TempSalesPrice."Allow Invoice Disc.";
                                "Unit Price" := TempSalesPrice."Unit Price";
                                //>> ABC(OLL) - 17/07/2017
                                if (SalesHeader."Shipping Agent Code" = 'ENL') then
                                    "Unit Price" := TempSalesPrice."Unit Start Price";
                                "Px 3x Net" := TempSalesPrice."Prix 3x Net";
                                "Px Depart" := TempSalesPrice."Unit Start Price";
                            end;

                            /*
                                      IF SalesLine. "Unit of Measure Code" = TempSalesPrice."Unit of Measure Code" THEN
                                      BEGIN
                                        "Unit Price" := TempSalesPrice."Unit Price";
                                      END
                                      ELSE
                                      BEGIN
                                         IF (TempSalesPrice."Unit of Measure Code" = 'KG') AND  recUOM.GET(SalesLine."No.",SalesLine."Unit of Measure Code") THEN
                                          "Unit Price" := TempSalesPrice."Unit Price" * recUOM."Qty. per Unit of Measure";
                                      END;
                                        //>> ABC(OLL) - 17/07/2017
                                        IF (SalesHeader."Shipping Agent Code" = 'ENL') THEN
                                          IF (TempSalesPrice."Unit of Measure Code" = 'KG') AND  recUOM.GET(SalesLine."No.",SalesLine."Unit of Measure Code") THEN
                                            "Unit Price" := TempSalesPrice."Unit Start Price" * recUOM."Qty. per Unit of Measure"
                                          ELSE
                                            "Unit Price" := TempSalesPrice."Unit Start Price";
                                        "Px 3x Net" := TempSalesPrice."Prix 3x Net";
                                        "Px Depart" := TempSalesPrice."Unit Start Price";
                                        //<<
                                      END;
                            */

                            //>> ABC(OLL) - 02/08/2017 - Si option forcer pas de calcul
                        end;

                        if not SalesLine."Forced Line Discount %" then begin
                            //<<
                            if not "Allow Line Disc." then
                                "Line Discount %" := 0;
                            //>> ABC(OLL) - 24/07/2017
                            if not "Allow Line Disc." then
                                "Line Discount unit amount" := 0
                            else begin
                                if ("Line Discount %" = 0) then begin
                                    SetLineDiscUnitAmount(true);
                                    FindSalesLineLineDisc(SalesHeader, SalesLine);
                                    SetLineDiscUnitAmount(false); //ABC(OLL) - 24/07/2017
                                end;
                            end;
                            //<<
                        end; //ABC(OLL) - 02/08/2017
                    end;
                Type::Resource:
                    begin

                        //>> ABC(OLL) - 02/08/2017 - Si option forcer pas de calcul
                        if not SalesLine."Forced Unit Price" then begin
                            SetResPrice("No.", "Work Type Code", "Currency Code");

                        end;

                        if not SalesLine."Forced Line Discount %" then begin
                            //<<
                            //--> ABC GEN 20090604
                            if not "Allow Line Disc." then
                                "Line Discount %" := 0;
                            //<-- ABC GEN 20090604
                            //>> ABC(OLL) - 24/07/2017
                            if not "Allow Line Disc." then
                                "Line Discount unit amount" := 0
                            else begin
                                if ("Line Discount %" = 0) then begin
                                    SetLineDiscUnitAmount(true);
                                    FindSalesLineLineDisc(SalesHeader, SalesLine);
                                    SetLineDiscUnitAmount(false); //ABC(OLL) - 24/07/2017
                                end;
                            end;
                            //<<
                        end; //ABC(OLL) - 02/08/2017
                    end;
            end;
            //  OnAfterFindSalesLinePrice(SalesLine,SalesHeader,TempSalesPrice,ResPrice,CalledByFieldNo);
        end;

    end;

    procedure FindItemJnlLinePrice(var ItemJnlLine: Record "Item Journal Line"; CalledByFieldNo: Integer)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;

        if IsHandled then
            exit;

        with ItemJnlLine do begin
            SetCurrency('', 0, 0D);
            SetVAT(false, 0, 0, '');
            SetUoM(Abs(Quantity), "Qty. per Unit of Measure");
            TestField("Qty. per Unit of Measure");
            Item.Get("Item No.");

            FindSalesPrice(
              TempSalesPrice, '', '', '', '', "Item No.", "Variant Code",
              "Unit of Measure Code", '', "Posting Date", false);
            CalcBestUnitPrice(TempSalesPrice);
            if FoundSalesPrice or
               not ((CalledByFieldNo = FieldNo(Quantity)) or
                    (CalledByFieldNo = FieldNo("Variant Code")))
            then
                Validate("Unit Amount", TempSalesPrice."Unit Price");
            //  OnAfterFindItemJnlLinePrice(ItemJnlLine,TempSalesPrice,CalledByFieldNo,FoundSalesPrice);
        end;
    end;

    procedure FindServLinePrice(ServHeader: Record "Service Header"; var ServLine: Record "Service Line"; CalledByFieldNo: Integer)
    var
        ServCost: Record "Service Cost";
        Res: Record Resource;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeFindServLinePrice(ServLine, ServHeader, CalledByFieldNo, IsHandled);
        if IsHandled then
            exit;

        with ServLine do begin
            ServHeader.Get("Document Type", "Document No.");
            if Type <> Type::" " then begin
                SetCurrency(
                  ServHeader."Currency Code", ServHeader."Currency Factor", ServHeaderExchDate(ServHeader));
                SetVAT(ServHeader."Prices Including VAT", "VAT %", "VAT Calculation Type".AsInteger(), "VAT Bus. Posting Group");
                SetUoM(Abs(Quantity), "Qty. per Unit of Measure");
                SetLineDisc("Line Discount %", "Allow Line Disc.", false);

                TestField("Qty. per Unit of Measure");
                if PricesInCurrency then
                    ServHeader.TestField("Currency Factor");
            end;

            case Type of
                Type::Item:
                    begin
                        ServLinePriceExists(ServHeader, ServLine, false);
                        CalcBestUnitPrice(TempSalesPrice);
                        if FoundSalesPrice or
                           not ((CalledByFieldNo = FieldNo(Quantity)) or
                                (CalledByFieldNo = FieldNo("Variant Code")))
                        then begin
                            if "Line Discount Type" = "Line Discount Type"::"Line Disc." then
                                "Allow Line Disc." := TempSalesPrice."Allow Line Disc.";
                            "Unit Price" := TempSalesPrice."Unit Price";
                        end;
                        if not "Allow Line Disc." and ("Line Discount Type" = "Line Discount Type"::"Line Disc.") then
                            "Line Discount %" := 0;
                    end;
                Type::Resource:
                    begin
                        SetResPrice("No.", "Work Type Code", "Currency Code");

                    end;
                Type::Cost:
                    begin
                        ServCost.Get("No.");

                        ConvertPriceToVAT(false, '', '', ServCost."Default Unit Price");
                        ConvertPriceLCYToFCY('', ServCost."Default Unit Price");
                        "Unit Price" := ServCost."Default Unit Price";
                    end;
            end;
            //  OnAfterFindServLinePrice(ServLine,ServHeader,TempSalesPrice,ResPrice,ServCost,CalledByFieldNo);
        end;
    end;

    procedure FindSalesLineLineDisc(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    var
        IsHandled: Boolean;
    begin

        //>> ABC(OLL) - 02/08/2017 - Si option forcer pas de calcul
        if SalesLine."Forced Line Discount %" then
            exit;
        IsHandled := false;
        OnBeforeFindSalesLineLineDisc(SalesLine, SalesHeader, IsHandled);
        if IsHandled then
            exit;
        with SalesLine do begin
            SalesLine."Line Discount Amount" := 0;  //DG 260919 Forcer le recalcul

            SetCurrency(SalesHeader."Currency Code", 0, 0D);
            SetUoM(Abs(Quantity), "Qty. per Unit of Measure");
            SetUoMSalesLines(SalesHeader); //ABC(OLL) - 24/07/2017

            TestField("Qty. per Unit of Measure");

            IsHandled := false;
            //OnFindSalesLineLineDiscOnBeforeCalcLineDisc(SalesHeader,SalesLine,TempSalesLineDisc,Qty,QtyPerUOM,IsHandled);
            if not IsHandled then
                if Type = Type::Item then begin
                    SalesLineLineDiscExists(SalesHeader, SalesLine, false);
                    //>> ABC(OLL) - 24/07/2017 - Pour remise en montant unitaire
                    if UseLineDiscUnitAmount then begin
                        CalcBestLineDiscAmount(TempSalesLineDisc);
                        "Line Discount unit amount" := TempSalesLineDisc."Line Discount unit amount";
                        "Line Discount %" := 0;
                    end else begin
                        //<<
                        CalcBestLineDisc(TempSalesLineDisc);
                        "Line Discount %" := TempSalesLineDisc."Line Discount %";
                        //>> ABC(OLL) - 24/07/2017
                        "Line Discount unit amount" := 0;
                    end;
                    //<<
                end;
            //--> ABC GEN 20090604
            if SalesLine.Type = Type::Resource then begin
                //>> ABC(OLL) - 24/07/2017 - Pour remise en montant unitaire
                if UseLineDiscUnitAmount then begin
                    CalcBestLineDiscAmount(TempSalesLineDisc);
                    "Line Discount unit amount" := TempSalesLineDisc."Line Discount unit amount";
                    "Line Discount %" := 0;
                end else begin
                    //<<
                    SalesLineLineDiscExists(SalesHeader, SalesLine, false);
                    CalcBestLineDisc(TempSalesLineDisc);
                    "Line Discount %" := TempSalesLineDisc."Line Discount %";
                    //>> ABC(OLL) - 24/07/2017
                    "Line Discount unit amount" := 0;
                end;
                //<<
            end;

            //  OnAfterFindSalesLineLineDisc(SalesLine,SalesHeader,TempSalesLineDisc);
        end;
    end;

    procedure FindServLineDisc(ServHeader: Record "Service Header"; var ServLine: Record "Service Line")
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeFindServLineDisc(ServHeader, ServLine, IsHandled);
        if IsHandled then
            exit;

        with ServLine do begin
            SetCurrency(ServHeader."Currency Code", 0, 0D);
            SetUoM(Abs(Quantity), "Qty. per Unit of Measure");

            TestField("Qty. per Unit of Measure");

            if Type = Type::Item then begin
                Item.Get("No.");
                FindSalesLineDisc(
                  TempSalesLineDisc, "Bill-to Customer No.", ServHeader."Contact No.",
                  "Customer Disc. Group", '', "No.", Item."Item Disc. Group", "Variant Code",
                  "Unit of Measure Code", ServHeader."Currency Code", ServHeader."Order Date", false);
                CalcBestLineDisc(TempSalesLineDisc);
                "Line Discount %" := TempSalesLineDisc."Line Discount %";
            end;
            if Type in [Type::Resource, Type::Cost, Type::"G/L Account"] then begin
                "Line Discount %" := 0;
                "Line Discount Amount" :=
                  Round(
                    Round(CalcChargeableQty * "Unit Price", Currency."Amount Rounding Precision") *
                    "Line Discount %" / 100, Currency."Amount Rounding Precision");
                "Inv. Discount Amount" := 0;
                "Inv. Disc. Amount to Invoice" := 0;
            end;
            //  OnAfterFindServLineDisc(ServLine,ServHeader,TempSalesLineDisc);
        end;
    end;

    procedure FindStdItemJnlLinePrice(var StdItemJnlLine: Record "Standard Item Journal Line"; CalledByFieldNo: Integer)
    var
        IsHandled: Boolean;
    begin
        IsHandled := true;
        OnBeforeFindStdItemJnlLinePrice(StdItemJnlLine, CalledByFieldNo, IsHandled);
        if IsHandled then
            exit;

        with StdItemJnlLine do begin
            SetCurrency('', 0, 0D);
            SetVAT(false, 0, 0, '');
            SetUoM(Abs(Quantity), "Qty. per Unit of Measure");
            TestField("Qty. per Unit of Measure");
            Item.Get("Item No.");

            FindSalesPrice(
              TempSalesPrice, '', '', '', '', "Item No.", "Variant Code",
              "Unit of Measure Code", '', WorkDate, false);
            CalcBestUnitPrice(TempSalesPrice);
            if FoundSalesPrice or
               not ((CalledByFieldNo = FieldNo(Quantity)) or
                    (CalledByFieldNo = FieldNo("Variant Code")))
            then
                Validate("Unit Amount", TempSalesPrice."Unit Price");
            //OnAfterFindStdItemJnlLinePrice(StdItemJnlLine,TempSalesPrice,CalledByFieldNo);
        end;
    end;

    procedure FindAnalysisReportPrice(ItemNo: Code[20]; Date: Date): Decimal
    var
        UnitPrice: Decimal;
        IsHandled: Boolean;
    begin
        IsHandled := false;

        if IsHandled then
            exit(UnitPrice);

        SetCurrency('', 0, 0D);
        SetVAT(false, 0, 0, '');
        SetUoM(0, 1);
        Item.Get(ItemNo);

        FindSalesPrice(TempSalesPrice, '', '', '', '', ItemNo, '', '', '', Date, false);
        CalcBestUnitPrice(TempSalesPrice);
        if FoundSalesPrice then
            exit(TempSalesPrice."Unit Price");
        exit(Item."Unit Price");
    end;

    procedure CalcBestUnitPrice(var SalesPrice: Record "Sales PriceEC")
    var
        BestSalesPrice: Record "Sales PriceEC";
        BestSalesPriceFound: Boolean;
    begin
        //OnBeforeCalcBestUnitPrice(SalesPrice);

        with SalesPrice do begin
            FoundSalesPrice := FindSet;
            if FoundSalesPrice then
                repeat
                    if IsInMinQty("Unit of Measure Code", "Minimum Quantity") then begin
                        if IsInMinQtyOrder("Order Minimum Quantity", "Order Minimum Palettes") then begin //ABC(OLL) - 17/07/2017
                            ConvertPriceToVAT(
                              "Price Includes VAT", Item."VAT Prod. Posting Group",
                              "VAT Bus. Posting Gr. (Price)", "Unit Price");
                            ConvertPriceToUoM("Unit of Measure Code", "Unit Price");
                            ConvertPriceLCYToFCY("Currency Code", "Unit Price");

                            case true of
                                ((BestSalesPrice."Currency Code" = '') and ("Currency Code" <> '')) or
                                ((BestSalesPrice."Variant Code" = '') and ("Variant Code" <> '')):
                                    begin
                                        BestSalesPrice := SalesPrice;
                                        BestSalesPriceFound := true;
                                    end;
                                ((BestSalesPrice."Currency Code" = '') or ("Currency Code" <> '')) and
                              ((BestSalesPrice."Variant Code" = '') or ("Variant Code" <> '')):
                                    if (BestSalesPrice."Unit Price" = 0) or
                                       (CalcLineAmount(BestSalesPrice) > CalcLineAmount(SalesPrice))
                                    then begin
                                        BestSalesPrice := SalesPrice;
                                        BestSalesPriceFound := true;
                                    end;
                            end;
                        end; //ABC(OLL) - 17/07/2017
                    end;
                until Next = 0;
        end;

        //OnAfterCalcBestUnitPrice(SalesPrice);

        // No price found in agreement
        if not BestSalesPriceFound then begin
            ConvertPriceToVAT(
              Item."Price Includes VAT", Item."VAT Prod. Posting Group",
              Item."VAT Bus. Posting Gr. (Price)", Item."Unit Price");
            ConvertPriceToUoM('', Item."Unit Price");
            ConvertPriceLCYToFCY('', Item."Unit Price");

            Clear(BestSalesPrice);
            BestSalesPrice."Unit Price" := Item."Unit Price";
            BestSalesPrice."Allow Line Disc." := AllowLineDisc;
            BestSalesPrice."Allow Invoice Disc." := AllowInvDisc;
            //  OnAfterCalcBestUnitPriceAsItemUnitPrice(BestSalesPrice,Item);
        end;

        SalesPrice := BestSalesPrice;
    end;

    procedure CalcBestLineDisc(var SalesLineDisc: Record "Sales Line DiscountEC")
    var
        BestSalesLineDisc: Record "Sales Line DiscountEC";
    begin
        with SalesLineDisc do begin
            if FindSet then
                repeat
                    if IsInMinQty("Unit of Measure Code", "Minimum Quantity") then
                        if IsInMinQtyOrder("Order Minimum Quantity", 0) then begin //ABC(OLL) - 21/07/2017
                            case true of
                                ((BestSalesLineDisc."Currency Code" = '') and ("Currency Code" <> '')) or
                              ((BestSalesLineDisc."Variant Code" = '') and ("Variant Code" <> '')):
                                    BestSalesLineDisc := SalesLineDisc;
                                ((BestSalesLineDisc."Currency Code" = '') or ("Currency Code" <> '')) and
                              ((BestSalesLineDisc."Variant Code" = '') or ("Variant Code" <> '')):
                                    if ("Line Discount unit amount" = 0) then //ABC(OLL) - 24/07/2017
                                        if BestSalesLineDisc."Line Discount %" < "Line Discount %" then
                                            BestSalesLineDisc := SalesLineDisc;
                            end;
                        end; //ABC(OLL) - 21/07/2017
                until Next = 0;
        end;

        SalesLineDisc := BestSalesLineDisc;
    end;

    procedure FindSalesPrice(var ToSalesPrice: Record "Sales PriceEC"; CustNo: Code[20]; ContNo: Code[20]; CustPriceGrCode: Code[10]; CampaignNo: Code[20]; ItemNo: Code[20]; VariantCode: Code[10]; UOM: Code[10]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean)
    var
        FromSalesPrice: Record "Sales PriceEC";
        TempTargetCampaignGr: Record "Campaign Target Group" temporary;
    begin
        if not ToSalesPrice.IsTemporary then
            Error(TempTableErr);

        ToSalesPrice.Reset;
        ToSalesPrice.DeleteAll;

        //OnBeforeFindSalesPrice(ToSalesPrice,FromSalesPrice,QtyPerUOM,Qty,CustNo,ContNo,CustPriceGrCode,CampaignNo,ItemNo,VariantCode,UOM,CurrencyCode,StartingDate,ShowAll);

        with FromSalesPrice do begin
            SetRange("Item No.", ItemNo);
            SetFilter("Variant Code", '%1|%2', VariantCode, '');
            SetFilter("Ending Date", '%1|>=%2', 0D, StartingDate);
            if not ShowAll then begin
                SetFilter("Currency Code", '%1|%2', CurrencyCode, '');
                if UOM <> '' then
                    //      SETFILTER("Unit of Measure Code",'%1|%2|%3',UOM,'','KG');
                    SetFilter("Unit of Measure Code", '%1|%2', UOM, '');
                SetRange("Starting Date", 0D, StartingDate);
            end;

            SetRange("Sales Type", "Sales Type"::"All Customers");
            SetRange("Sales Code");
            CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);

            if CustNo <> '' then begin
                SetRange("Sales Type", "Sales Type"::Customer);
                SetRange("Sales Code", CustNo);
                CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);
            end;

            if CustPriceGrCode <> '' then begin
                SetRange("Sales Type", "Sales Type"::"Customer Price Group");
                SetRange("Sales Code", CustPriceGrCode);
                CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);
            end;

            if not ((CustNo = '') and (ContNo = '') and (CampaignNo = '')) then begin
                SetRange("Sales Type", "Sales Type"::Campaign);
                if ActivatedCampaignExists(TempTargetCampaignGr, CustNo, ContNo, CampaignNo) then
                    repeat
                        SetRange("Sales Code", TempTargetCampaignGr."Campaign No.");
                        CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);
                    until TempTargetCampaignGr.Next = 0;
            end;
        end;

        //OnAfterFindSalesPrice(
        //  ToSalesPrice,FromSalesPrice,QtyPerUOM,Qty,CustNo,ContNo,CustPriceGrCode,CampaignNo,
        //  ItemNo,VariantCode,UOM,CurrencyCode,StartingDate,ShowAll);
    end;

    procedure FindSalesLineDisc(var ToSalesLineDisc: Record "Sales Line DiscountEC"; CustNo: Code[20]; ContNo: Code[20]; CustDiscGrCode: Code[20]; CampaignNo: Code[20]; ItemNo: Code[20]; ItemDiscGrCode: Code[20]; VariantCode: Code[10]; UOM: Code[10]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean)
    var
        FromSalesLineDisc: Record "Sales Line DiscountEC";
        TempCampaignTargetGr: Record "Campaign Target Group" temporary;
        InclCampaigns: Boolean;
    begin
        //OnBeforeFindSalesLineDisc(
        //  ToSalesLineDisc,CustNo,ContNo,CustDiscGrCode,CampaignNo,ItemNo,ItemDiscGrCode,VariantCode,UOM,
        //  CurrencyCode,StartingDate,ShowAll);

        with FromSalesLineDisc do begin
            SetFilter("Ending Date", '%1|>=%2', 0D, StartingDate);
            SetFilter("Variant Code", '%1|%2', VariantCode, '');
            //  OnFindSalesLineDiscOnAfterSetFilters(FromSalesLineDisc);
            if not ShowAll then begin
                SetRange("Starting Date", 0D, StartingDate);
                SetFilter("Currency Code", '%1|%2', CurrencyCode, '');
                if UOM <> '' then
                    SetFilter("Unit of Measure Code", '%1|%2', UOM, '');
            end;

            ToSalesLineDisc.Reset;
            ToSalesLineDisc.DeleteAll;
            for "Sales Type" := "Sales Type"::Customer to "Sales Type"::Campaign do
                if ("Sales Type" = "Sales Type"::"All Customers") or
                   (("Sales Type" = "Sales Type"::Customer) and (CustNo <> '')) or
                   (("Sales Type" = "Sales Type"::"Customer Disc. Group") and (CustDiscGrCode <> '')) or
                   (("Sales Type" = "Sales Type"::Campaign) and
                    not ((CustNo = '') and (ContNo = '') and (CampaignNo = '')))
                then begin
                    InclCampaigns := false;

                    SetRange("Sales Type", "Sales Type");
                    case "Sales Type" of
                        "Sales Type"::"All Customers":
                            SetRange("Sales Code");
                        "Sales Type"::Customer:
                            SetRange("Sales Code", CustNo);
                        "Sales Type"::"Customer Disc. Group":
                            SetRange("Sales Code", CustDiscGrCode);
                        "Sales Type"::Campaign:
                            begin
                                InclCampaigns := ActivatedCampaignExists(TempCampaignTargetGr, CustNo, ContNo, CampaignNo);
                                SetRange("Sales Code", TempCampaignTargetGr."Campaign No.");
                            end;
                    end;

                    repeat
                        SetRange(Type, Type::Item);
                        SetRange(Code, ItemNo);
                        CopySalesDiscToSalesDisc(FromSalesLineDisc, ToSalesLineDisc);

                        if ItemDiscGrCode <> '' then begin
                            SetRange(Type, Type::"Item Disc. Group");
                            SetRange(Code, ItemDiscGrCode);
                            CopySalesDiscToSalesDisc(FromSalesLineDisc, ToSalesLineDisc);
                        end;

                        if InclCampaigns then begin
                            InclCampaigns := TempCampaignTargetGr.Next <> 0;
                            SetRange("Sales Code", TempCampaignTargetGr."Campaign No.");
                        end;
                    until not InclCampaigns;
                end;
        end;

        //OnAfterFindSalesLineDisc(
        //  ToSalesLineDisc,CustNo,ContNo,CustDiscGrCode,CampaignNo,ItemNo,ItemDiscGrCode,VariantCode,UOM,
        //  CurrencyCode,StartingDate,ShowAll);
    end;

    procedure CopySalesPrice(var SalesPrice: Record "Sales PriceEC")
    begin
        SalesPrice.DeleteAll;
        CopySalesPriceToSalesPrice(TempSalesPrice, SalesPrice);
    end;

    local procedure CopySalesPriceToSalesPrice(var FromSalesPrice: Record "Sales PriceEC"; var ToSalesPrice: Record "Sales PriceEC")
    begin
        with ToSalesPrice do begin
            if FromSalesPrice.FindSet then
                repeat
                    ToSalesPrice := FromSalesPrice;
                    Insert;
                until FromSalesPrice.Next = 0;
        end;
    end;

    local procedure CopySalesDiscToSalesDisc(var FromSalesLineDisc: Record "Sales Line DiscountEC"; var ToSalesLineDisc: Record "Sales Line DiscountEC")
    begin
        with ToSalesLineDisc do begin
            if FromSalesLineDisc.FindSet then
                repeat
                    ToSalesLineDisc := FromSalesLineDisc;
                    Insert;
                until FromSalesLineDisc.Next = 0;
        end;
    end;

    procedure SetResPrice(Code2: Code[20]; WorkTypeCode: Code[10]; CurrencyCode: Code[10])
    begin

    end;

    local procedure SetCurrency(CurrencyCode2: Code[10]; CurrencyFactor2: Decimal; ExchRateDate2: Date)
    begin
        PricesInCurrency := CurrencyCode2 <> '';
        if PricesInCurrency then begin
            Currency.Get(CurrencyCode2);
            Currency.TestField("Unit-Amount Rounding Precision");
            CurrencyFactor := CurrencyFactor2;
            ExchRateDate := ExchRateDate2;
        end else
            GLSetup.Get;
    end;

    local procedure SetVAT(PriceInclVAT2: Boolean; VATPerCent2: Decimal; VATCalcType2: Option; VATBusPostingGr2: Code[20])
    begin
        PricesInclVAT := PriceInclVAT2;
        VATPerCent := VATPerCent2;
        VATCalcType := VATCalcType2;
        VATBusPostingGr := VATBusPostingGr2;
    end;

    local procedure SetUoM(Qty2: Decimal; QtyPerUoM2: Decimal)
    begin
        Qty := Qty2;
        QtyPerUOM := QtyPerUoM2;
    end;

    local procedure SetLineDisc(LineDiscPerCent2: Decimal; AllowLineDisc2: Boolean; AllowInvDisc2: Boolean)
    begin
        LineDiscPerCent := LineDiscPerCent2;
        AllowLineDisc := AllowLineDisc2;
        AllowInvDisc := AllowInvDisc2;
    end;

    local procedure IsInMinQty(UnitofMeasureCode: Code[10]; MinQty: Decimal): Boolean
    begin
        if UnitofMeasureCode = '' then
            exit(MinQty <= QtyPerUOM * Qty);
        exit(MinQty <= Qty);
    end;

    local procedure ConvertPriceToVAT(FromPricesInclVAT: Boolean; FromVATProdPostingGr: Code[20]; FromVATBusPostingGr: Code[20]; var UnitPrice: Decimal)
    var
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        if FromPricesInclVAT then begin
            VATPostingSetup.Get(FromVATBusPostingGr, FromVATProdPostingGr);


            case VATPostingSetup."VAT Calculation Type" of
                VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
                    VATPostingSetup."VAT %" := 0;
                VATPostingSetup."VAT Calculation Type"::"Sales Tax":
                    Error(
                      Text010,
                      VATPostingSetup.FieldCaption("VAT Calculation Type"),
                      VATPostingSetup."VAT Calculation Type");
            end;

            case VATCalcType of
                VATCalcType::"Normal VAT",
                VATCalcType::"Full VAT",
                VATCalcType::"Sales Tax":
                    begin
                        if PricesInclVAT then begin
                            if VATBusPostingGr <> FromVATBusPostingGr then
                                UnitPrice := UnitPrice * (100 + VATPerCent) / (100 + VATPostingSetup."VAT %");
                        end else
                            UnitPrice := UnitPrice / (1 + VATPostingSetup."VAT %" / 100);
                    end;
                VATCalcType::"Reverse Charge VAT":
                    UnitPrice := UnitPrice / (1 + VATPostingSetup."VAT %" / 100);
            end;
        end else
            if PricesInclVAT then
                UnitPrice := UnitPrice * (1 + VATPerCent / 100);
    end;

    local procedure ConvertPriceToUoM(UnitOfMeasureCode: Code[10]; var UnitPrice: Decimal)
    begin
        if UnitOfMeasureCode = '' then
            UnitPrice := UnitPrice * QtyPerUOM;
    end;

    local procedure ConvertPriceLCYToFCY(CurrencyCode: Code[10]; var UnitPrice: Decimal)
    var
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        if PricesInCurrency then begin
            if CurrencyCode = '' then
                UnitPrice :=
                  CurrExchRate.ExchangeAmtLCYToFCY(ExchRateDate, Currency.Code, UnitPrice, CurrencyFactor);
            UnitPrice := Round(UnitPrice, Currency."Unit-Amount Rounding Precision");
        end else
            UnitPrice := Round(UnitPrice, GLSetup."Unit-Amount Rounding Precision");
    end;

    local procedure CalcLineAmount(SalesPrice: Record "Sales PriceEC"): Decimal
    begin
        with SalesPrice do begin
            if "Allow Line Disc." then
                exit("Unit Price" * (1 - LineDiscPerCent / 100));
            exit("Unit Price");
        end;
    end;

    procedure GetSalesLinePrice(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    begin
        SalesLinePriceExists(SalesHeader, SalesLine, true);

        /*with SalesLine do
            if PAGE.RunModal(PAGE::"Get Sales Price", TempSalesPrice) = ACTION::LookupOK then begin
                SetVAT(
                  SalesHeader."Prices Including VAT", "VAT %", "VAT Calculation Type", "VAT Bus. Posting Group");
                SetUoM(Abs(Quantity), "Qty. per Unit of Measure");
                SetCurrency(
                  SalesHeader."Currency Code", SalesHeader."Currency Factor", SalesHeaderExchDate(SalesHeader));

                if not "Forced Unit Price" and
                 not IsInMinQty(TempSalesPrice."Unit of Measure Code", TempSalesPrice."Minimum Quantity") then
                    Error(
                      Text000,
                      FieldCaption(Quantity),
                      TempSalesPrice.FieldCaption("Minimum Quantity"),
                      TempSalesPrice.TableCaption);
                if not (TempSalesPrice."Currency Code" in ["Currency Code", '']) then
                    Error(
                      Text001,
                      FieldCaption("Currency Code"),
                      TableCaption,
                      TempSalesPrice.TableCaption);
                if not (TempSalesPrice."Unit of Measure Code" in ["Unit of Measure Code", '']) then
                    Error(
                      Text001,
                      FieldCaption("Unit of Measure Code"),
                      TableCaption,
                      TempSalesPrice.TableCaption);
                if TempSalesPrice."Starting Date" > SalesHeaderStartDate(SalesHeader, DateCaption) then
                    Error(
                      Text000,
                      DateCaption,
                      TempSalesPrice.FieldCaption("Starting Date"),
                      TempSalesPrice.TableCaption);

                ConvertPriceToVAT(
                  TempSalesPrice."Price Includes VAT", Item."VAT Prod. Posting Group",
                  TempSalesPrice."VAT Bus. Posting Gr. (Price)", TempSalesPrice."Unit Price");
                ConvertPriceToUoM(TempSalesPrice."Unit of Measure Code", TempSalesPrice."Unit Price");
                ConvertPriceLCYToFCY(TempSalesPrice."Currency Code", TempSalesPrice."Unit Price");

                "Allow Invoice Disc." := TempSalesPrice."Allow Invoice Disc.";
                "Allow Line Disc." := TempSalesPrice."Allow Line Disc.";
                if not "Allow Line Disc." then
                    "Line Discount %" := 0;

                Validate("Unit Price", TempSalesPrice."Unit Price");
            end;*/

        //OnAfterGetSalesLinePrice(SalesHeader,SalesLine,TempSalesPrice);
    end;

    procedure GetSalesLineLineDisc(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    begin
        OnBeforeGetSalesLineLineDisc(SalesHeader, SalesLine);

        SalesLineLineDiscExists(SalesHeader, SalesLine, true);

        /*with SalesLine do
            if PAGE.RunModal(PAGE::"Get Sales Line Disc.", TempSalesLineDisc) = ACTION::LookupOK then begin
                SetCurrency(SalesHeader."Currency Code", 0, 0D);
                SetUoM(Abs(Quantity), "Qty. per Unit of Measure");

                if not IsInMinQty(TempSalesLineDisc."Unit of Measure Code", TempSalesLineDisc."Minimum Quantity")
                then
                    Error(
                      Text000, FieldCaption(Quantity),
                      TempSalesLineDisc.FieldCaption("Minimum Quantity"),
                      TempSalesLineDisc.TableCaption);
                if not (TempSalesLineDisc."Currency Code" in ["Currency Code", '']) then
                    Error(
                      Text001,
                      FieldCaption("Currency Code"),
                      TableCaption,
                      TempSalesLineDisc.TableCaption);
                if not (TempSalesLineDisc."Unit of Measure Code" in ["Unit of Measure Code", '']) then
                    Error(
                      Text001,
                      FieldCaption("Unit of Measure Code"),
                      TableCaption,
                      TempSalesLineDisc.TableCaption);
                if TempSalesLineDisc."Starting Date" > SalesHeaderStartDate(SalesHeader, DateCaption) then
                    Error(
                      Text000,
                      DateCaption,
                      TempSalesLineDisc.FieldCaption("Starting Date"),
                      TempSalesLineDisc.TableCaption);

                TestField("Allow Line Disc.");
                Validate("Line Discount %", TempSalesLineDisc."Line Discount %");
            end;
*/
        //OnAfterGetSalesLineLineDisc(SalesLine,TempSalesLineDisc);
    end;

    procedure SalesLinePriceExists(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; ShowAll: Boolean): Boolean
    var
        IsHandled: Boolean;
    begin
        with SalesLine do
            if (Type = Type::Item) and Item.Get("No.") then begin
                IsHandled := false;
                //    OnBeforeSalesLinePriceExists(
                //      SalesLine,SalesHeader,TempSalesPrice,Currency,CurrencyFactor,
                //      SalesHeaderStartDate(SalesHeader,DateCaption),Qty,QtyPerUOM,ShowAll,IsHandled);
                if not IsHandled then begin
                    FindSalesPrice(
                      TempSalesPrice, GetCustNoForSalesHeader(SalesHeader), SalesHeader."Bill-to Contact No.",
                      "Customer Price Group", '', "No.", "Variant Code", "Unit of Measure Code",
                      SalesHeader."Currency Code", SalesHeaderStartDate(SalesHeader, DateCaption), ShowAll);
                    //      OnAfterSalesLinePriceExists(SalesLine,SalesHeader,TempSalesPrice,ShowAll);
                end;
                exit(TempSalesPrice.FindFirst);
            end;
        exit(false);
    end;

    procedure SalesLineLineDiscExists(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; ShowAll: Boolean): Boolean
    var
        RecResource_l: Record Resource;
        IsHandled: Boolean;
    begin
        with SalesLine do
            if (Type = Type::Item) and Item.Get("No.") then begin
                IsHandled := false;
                //    OnBeforeSalesLineLineDiscExists(
                //      SalesLine,SalesHeader,TempSalesLineDisc,SalesHeaderStartDate(SalesHeader,DateCaption),
                //      Qty,QtyPerUOM,ShowAll,IsHandled);
                if not IsHandled then begin
                    FindSalesLineDisc(
                      TempSalesLineDisc, GetCustNoForSalesHeader(SalesHeader), SalesHeader."Bill-to Contact No.",
                      "Customer Disc. Group", '', "No.", Item."Item Disc. Group", "Variant Code", "Unit of Measure Code",
                      SalesHeader."Currency Code", SalesHeaderStartDate(SalesHeader, DateCaption), ShowAll);
                    //      OnAfterSalesLineLineDiscExists(SalesLine,SalesHeader,TempSalesLineDisc,ShowAll);
                end;
                exit(TempSalesLineDisc.FindFirst);
            end;
        //--> ABC GEN 20090604
        with SalesLine do
            if (Type = Type::Resource) and RecResource_l.Get("No.") then begin
                FindSalesLineDiscResource(
                  TempSalesLineDisc,
                  "Bill-to Customer No.",
                  SalesHeader."Bill-to Contact No.",
                  "Customer Disc. Group",
                  '',
                  "No.",
                  SalesHeader."Currency Code",
                  SalesHeaderStartDate(SalesHeader, DateCaption),
                  ShowAll);
                exit(TempSalesLineDisc.Find('-'));
            end;
        //<-- ABC GEN 20090604

        exit(false);
    end;

    procedure GetServLinePrice(ServHeader: Record "Service Header"; var ServLine: Record "Service Line")
    begin
    end;

    procedure GetServLineLineDisc(ServHeader: Record "Service Header"; var ServLine: Record "Service Line")
    begin
    end;

    local procedure GetCustNoForSalesHeader(SalesHeader: Record "Sales Header"): Code[20]
    var
        CustNo: Code[20];
    begin
        //CustNo := SalesHeader."Bill-to Customer No.";
        CustNo := SalesHeader."Sell-to Customer No.";
        OnGetCustNoForSalesHeader(SalesHeader, CustNo);
        exit(CustNo);
    end;

    local procedure ServLinePriceExists(ServHeader: Record "Service Header"; var ServLine: Record "Service Line"; ShowAll: Boolean): Boolean
    var
        IsHandled: Boolean;
    begin
        with ServLine do
            if (Type = Type::Item) and Item.Get("No.") then begin
                IsHandled := false;
                //    OnBeforeServLinePriceExists(ServLine,ServHeader,TempSalesPrice,ShowAll,IsHandled);
                if not IsHandled then
                    FindSalesPrice(
                      TempSalesPrice, "Bill-to Customer No.", ServHeader."Bill-to Contact No.",
                      "Customer Price Group", '', "No.", "Variant Code", "Unit of Measure Code",
                      ServHeader."Currency Code", ServHeaderStartDate(ServHeader, DateCaption), ShowAll);

                exit(TempSalesPrice.Find('-'));
            end;
        exit(false);
    end;

    local procedure ServLineLineDiscExists(ServHeader: Record "Service Header"; var ServLine: Record "Service Line"; ShowAll: Boolean): Boolean
    begin
        with ServLine do
            if (Type = Type::Item) and Item.Get("No.") then begin

                FindSalesLineDisc(
                  TempSalesLineDisc, "Bill-to Customer No.", ServHeader."Bill-to Contact No.",
                  "Customer Disc. Group", '', "No.", Item."Item Disc. Group", "Variant Code", "Unit of Measure Code",
                  ServHeader."Currency Code", ServHeaderStartDate(ServHeader, DateCaption), ShowAll);

                exit(TempSalesLineDisc.Find('-'));
            end;
        exit(false);
    end;

    procedure ActivatedCampaignExists(var ToCampaignTargetGr: Record "Campaign Target Group"; CustNo: Code[20]; ContNo: Code[20]; CampaignNo: Code[20]): Boolean
    var
        FromCampaignTargetGr: Record "Campaign Target Group";
        Cont: Record Contact;
    begin
        if not ToCampaignTargetGr.IsTemporary then
            Error(TempTableErr);

        with FromCampaignTargetGr do begin
            ToCampaignTargetGr.Reset;
            ToCampaignTargetGr.DeleteAll;

            if CampaignNo <> '' then begin
                ToCampaignTargetGr."Campaign No." := CampaignNo;
                ToCampaignTargetGr.Insert;
            end else begin
                SetRange(Type, Type::Customer);
                SetRange("No.", CustNo);
                if FindSet then
                    repeat
                        ToCampaignTargetGr := FromCampaignTargetGr;
                        ToCampaignTargetGr.Insert;
                    until Next = 0
                else
                    if Cont.Get(ContNo) then begin
                        SetRange(Type, Type::Contact);
                        SetRange("No.", Cont."Company No.");
                        if FindSet then
                            repeat
                                ToCampaignTargetGr := FromCampaignTargetGr;
                                ToCampaignTargetGr.Insert;
                            until Next = 0;
                    end;
            end;
            exit(ToCampaignTargetGr.FindFirst);
        end;
    end;

    local procedure SalesHeaderExchDate(SalesHeader: Record "Sales Header"): Date
    begin
        with SalesHeader do begin
            if "Posting Date" <> 0D then
                exit("Posting Date");
            exit(WorkDate);
        end;
    end;

    local procedure SalesHeaderStartDate(var SalesHeader: Record "Sales Header"; var DateCaption: Text[30]): Date
    begin
        with SalesHeader do
            if "Document Type" in ["Document Type"::Invoice, "Document Type"::"Credit Memo"] then begin
                DateCaption := FieldCaption("Posting Date");
                exit("Posting Date")
            end else begin
                //DateCaption := FIELDCAPTION("Order Date");
                DateCaption := FieldCaption("Requested Delivery Date");
                //EXIT("Order Date");
                exit("Requested Delivery Date");
            end;
    end;

    local procedure ServHeaderExchDate(ServHeader: Record "Service Header"): Date
    begin
        with ServHeader do begin
            if ("Document Type" = "Document Type"::Quote) and
               ("Posting Date" = 0D)
            then
                exit(WorkDate);
            exit("Posting Date");
        end;
    end;

    [Scope('OnPrem')]
    procedure "*** ABC GEN 20090604 ***"()
    begin
    end;

    local procedure ServHeaderStartDate(ServHeader: Record "Service Header"; var DateCaption: Text[30]): Date
    begin
        with ServHeader do
            if "Document Type" in ["Document Type"::Invoice, "Document Type"::"Credit Memo"] then begin
                DateCaption := FieldCaption("Posting Date");
                exit("Posting Date")
            end else begin
                DateCaption := FieldCaption("Order Date");
                exit("Order Date");
            end;
    end;

    [Scope('OnPrem')]
    procedure FindSalesLineDiscResource(var ToSalesLineDisc: Record "Sales Line DiscountEC"; CustNo: Code[20]; ContNo: Code[20]; CustDiscGrCode: Code[10]; CampaignNo: Code[20]; ResourceNo: Code[20]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean)
    var
        FromSalesLineDisc: Record "Sales Line DiscountEC";
        TempCampaignTargetGr: Record "Campaign Target Group" temporary;
        InclCampaigns: Boolean;
    begin
        //--> ABC GEN 20090604
        with FromSalesLineDisc do begin
            SetFilter("Ending Date", '%1|>=%2', 0D, StartingDate);
            if not ShowAll then begin
                SetRange("Starting Date", 0D, StartingDate);
                SetFilter("Currency Code", '%1|%2', CurrencyCode, '');
            end;

            ToSalesLineDisc.Reset;
            ToSalesLineDisc.DeleteAll;
            for "Sales Type" := "Sales Type"::Customer to "Sales Type"::Campaign do
                if ("Sales Type" = "Sales Type"::"All Customers") or
                   (("Sales Type" = "Sales Type"::Customer) and (CustNo <> '')) or
                   (("Sales Type" = "Sales Type"::"Customer Disc. Group") and (CustDiscGrCode <> '')) or
                   (("Sales Type" = "Sales Type"::Campaign) and
                       not ((CustNo = '') and (ContNo = '') and (CampaignNo = '')))
                then begin
                    InclCampaigns := false;

                    SetRange("Sales Type", "Sales Type");
                    case "Sales Type" of
                        "Sales Type"::"All Customers":
                            SetRange("Sales Code");
                        "Sales Type"::Customer:
                            SetRange("Sales Code", CustNo);
                        "Sales Type"::"Customer Disc. Group":
                            SetRange("Sales Code", CustDiscGrCode);
                        "Sales Type"::Campaign:
                            begin
                                InclCampaigns := ActivatedCampaignExists(TempCampaignTargetGr, CustNo, ContNo, CampaignNo);
                                SetRange("Sales Code", TempCampaignTargetGr."Campaign No.");
                            end;
                    end;

                    repeat
                        SetRange(Type, Type::Resource);
                        SetRange(Code, ResourceNo);
                        CopySalesDiscToSalesDisc(FromSalesLineDisc, ToSalesLineDisc);

                        //IF ItemDiscGrCode <> '' THEN BEGIN
                        //  SETRANGE(Type,Type::"Item Disc. Group");
                        //  SETRANGE(Code,ItemDiscGrCode);
                        //  CopySalesDiscToSalesDisc(FromSalesLineDisc,ToSalesLineDisc);
                        //END;

                        if InclCampaigns then begin
                            InclCampaigns := TempCampaignTargetGr.Next <> 0;
                            SetRange("Sales Code", TempCampaignTargetGr."Campaign No.");
                        end;
                    until not InclCampaigns;
                end;
        end;
        //<-- ABC GEN 20090604
    end;

    procedure NoOfSalesLinePrice(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; ShowAll: Boolean): Integer
    begin
        if SalesLinePriceExists(SalesHeader, SalesLine, ShowAll) then
            exit(TempSalesPrice.Count);
    end;

    local procedure SetUoMSalesLines(SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        Items: Record Item;
    begin
        //>> ABC(OLL) - 17/07/2017
        //if SalesHeader."Document Type" <> SalesHeader."Document Type"::orde then
        //  exit;

        TotalQty := 0;
        TotalPalettes := 0;
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetRange(Consign, false);
        if SalesLine.FindSet then
            repeat
                TotalQty += SalesLine."Quantity (Base)"; //Qty Base = KG
                if Items.Get(SalesLine."No.") then begin
                    if Items.PoidsPalette > 0 then
                        TotalPalettes := TotalPalettes + Round(SalesLine."Quantity (Base)" / Items.PoidsPalette, 1, '>')
                    else
                        TotalPalettes := TotalPalettes + 1;
                end;
            until SalesLine.Next = 0;
        //<<
    end;

    procedure NoOfSalesLineLineDisc(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; ShowAll: Boolean): Integer
    begin
        if SalesLineLineDiscExists(SalesHeader, SalesLine, ShowAll) then
            exit(TempSalesLineDisc.Count);
    end;

    local procedure IsInMinQtyOrder(MinQty: Decimal; MinPalettes: Integer): Boolean
    begin
        //>> ABC(OLL) - 17/07/2017
        exit((MinQty <= TotalQty) and (MinPalettes <= TotalPalettes));
        //<<
    end;

    procedure NoOfServLinePrice(ServHeader: Record "Service Header"; var ServLine: Record "Service Line"; ShowAll: Boolean): Integer
    begin
        if ServLinePriceExists(ServHeader, ServLine, ShowAll) then
            exit(TempSalesPrice.Count);
    end;

    [Scope('OnPrem')]
    procedure UpdateSalesLinePrice(SalesHeader: Record "Sales Header")
    var
        TestPriceSalesLine: Record "Sales Line";
        PriceCalcMgt: Codeunit "Sales Price Calc. Mgt.EC";
    begin
        //>> ABC(OLL) - 17/07/2017
        TestPriceSalesLine.SetRange("Document Type", SalesHeader."Document Type");
        TestPriceSalesLine.SetRange("Document No.", SalesHeader."No.");
        //DG pas de ressourece sinon => 0
        //TestPriceSalesLine.SETFILTER(Type,'%1|%2',TestPriceSalesLine.Type::Item,TestPriceSalesLine.Type::Resource);
        TestPriceSalesLine.SetFilter(Type, '%1', TestPriceSalesLine.Type::Item);
        TestPriceSalesLine.SetRange(Consign, false);
        if TestPriceSalesLine.FindSet() then
            repeat
                if not TestPriceSalesLine."Forced Unit Price" then
                    TestPriceSalesLine.Validate("Unit Price", 0);
                PriceCalcMgt.FindSalesLineLineDisc(SalesHeader, TestPriceSalesLine);
                PriceCalcMgt.FindSalesLinePrice(SalesHeader, TestPriceSalesLine, TestPriceSalesLine.FieldNo(Quantity));
                TestPriceSalesLine.Validate("Unit Price");
                TestPriceSalesLine.Modify(true);
            until TestPriceSalesLine.Next = 0;
        //<<
        TestPriceSalesLine.SetRange("Document Type", SalesHeader."Document Type");
        TestPriceSalesLine.SetRange("Document No.", SalesHeader."No.");
        //DG pas de ressourece sinon => 0
        //TestPriceSalesLine.SETFILTER(Type,'%1|%2',TestPriceSalesLine.Type::Item,TestPriceSalesLine.Type::Resource);
        TestPriceSalesLine.SetFilter(Type, '%1', TestPriceSalesLine.Type::Resource);
        TestPriceSalesLine.SetRange(Consign, false);
        TestPriceSalesLine.SetRange("Forced Unit Price", false);
        if TestPriceSalesLine.FindSet() then
            repeat
                if (TestPriceSalesLine."Prix Tpt" > 0) then
                    TestPriceSalesLine.Validate("Unit Price", TestPriceSalesLine."Prix Tpt");
                PriceCalcMgt.FindSalesLineLineDisc(SalesHeader, TestPriceSalesLine);
                TestPriceSalesLine.Validate("Unit Price");
                TestPriceSalesLine.Modify(true);
            until TestPriceSalesLine.Next = 0;
    end;

    procedure NoOfServLineLineDisc(ServHeader: Record "Service Header"; var ServLine: Record "Service Line"; ShowAll: Boolean): Integer
    begin
        if ServLineLineDiscExists(ServHeader, ServLine, ShowAll) then
            exit(TempSalesLineDisc.Count);
    end;

    [Scope('OnPrem')]
    procedure TestSalesLinePrice(SalesHeader: Record "Sales Header")
    var
        TestPriceSalesLine: Record "Sales Line";
        PriceCalcMgt: Codeunit "Sales Price Calc. Mgt.EC";
    begin

        TestPriceSalesLine.SetRange("Document Type", SalesHeader."Document Type");
        TestPriceSalesLine.SetRange("Document No.", SalesHeader."No.");
        TestPriceSalesLine.SetRange(Type, TestPriceSalesLine.Type::Item);
        TestPriceSalesLine.SetRange(Consign, false);
        TestPriceSalesLine.SetRange("Unit Price", 0);
        TestPriceSalesLine.SetFilter("Location Code", '<>%1', 'RD');
        if TestPriceSalesLine.FindFirst then;
        if not TestPriceSalesLine.IsEmpty then
            Error(Text50000, SalesHeader."Document Type", SalesHeader."No.");

        TestPriceSalesLine.Reset;
        TestPriceSalesLine.SetRange("Document Type", SalesHeader."Document Type");
        TestPriceSalesLine.SetRange("Document No.", SalesHeader."No.");
        TestPriceSalesLine.SetRange(Type, TestPriceSalesLine.Type::Item);
        TestPriceSalesLine.SetRange("Unit of Measure Code", '');

        if TestPriceSalesLine.FindFirst then;
        if not TestPriceSalesLine.IsEmpty then
            Error('Des lignes n''ont pas de code unité');
    end;

    procedure FindJobPlanningLinePrice(var JobPlanningLine: Record "Job Planning Line"; CalledByFieldNo: Integer)
    var
        Job: Record Job;
        IsHandled: Boolean;
    begin
        IsHandled := false;

        if IsHandled then
            exit;

        with JobPlanningLine do begin
            SetCurrency("Currency Code", "Currency Factor", "Planning Date");
            SetVAT(false, 0, 0, '');
            SetUoM(Abs(Quantity), "Qty. per Unit of Measure");
            SetLineDisc(0, true, true);

            case Type of
                Type::Item:
                    begin
                        Job.Get("Job No.");
                        Item.Get("No.");
                        TestField("Qty. per Unit of Measure");
                        FindSalesPrice(
                          TempSalesPrice, Job."Bill-to Customer No.", Job."Bill-to Contact No.",
                          Job."Customer Price Group", '', "No.", "Variant Code", "Unit of Measure Code",
                          Job."Currency Code", "Planning Date", false);
                        CalcBestUnitPrice(TempSalesPrice);
                        if FoundSalesPrice or
                           not ((CalledByFieldNo = FieldNo(Quantity)) or
                                (CalledByFieldNo = FieldNo("Location Code")) or
                                (CalledByFieldNo = FieldNo("Variant Code")))
                        then begin
                            "Unit Price" := TempSalesPrice."Unit Price";
                            AllowLineDisc := TempSalesPrice."Allow Line Disc.";
                        end;
                    end;
                Type::Resource:
                    begin

                    end;
            end;
        end;
        JobPlanningLineFindJTPrice(JobPlanningLine);
    end;

    local procedure CalcBestLineDiscAmount(var SalesLineDisc: Record "Sales Line DiscountEC")
    var
        BestSalesLineDisc: Record "Sales Line DiscountEC";
    begin
        //>> ABC(OLL) - 24/07/2017
        with SalesLineDisc do begin
            if Find('-') then
                repeat
                    if IsInMinQty("Unit of Measure Code", "Minimum Quantity") then
                        if IsInMinQtyOrder("Order Minimum Quantity", 0) then begin //ABC(OLL) - 21/07/2017
                            case true of
                                ((BestSalesLineDisc."Currency Code" = '') and ("Currency Code" <> '')) or
                              ((BestSalesLineDisc."Variant Code" = '') and ("Variant Code" <> '')):
                                    BestSalesLineDisc := SalesLineDisc;
                                ((BestSalesLineDisc."Currency Code" = '') or ("Currency Code" <> '')) and
                              ((BestSalesLineDisc."Variant Code" = '') or ("Variant Code" <> '')):
                                    if ("Line Discount %" = 0) then
                                        if BestSalesLineDisc."Line Discount unit amount" < "Line Discount unit amount" then
                                            BestSalesLineDisc := SalesLineDisc;
                            end;
                        end; //ABC(OLL) - 21/07/2017
                until Next = 0;
        end;

        SalesLineDisc := BestSalesLineDisc;
        //<<
    end;

    procedure JobPlanningLineFindJTPrice(var JobPlanningLine: Record "Job Planning Line")
    begin

    end;

    [Scope('OnPrem')]
    procedure SetLineDiscUnitAmount(l_UseLineDiscUnitAmount: Boolean)
    begin
        //>> ABC(OLL) - 24/07/2017
        UseLineDiscUnitAmount := l_UseLineDiscUnitAmount;
        //<<
    end;





    procedure FindJobJnlLinePrice(var JobJnlLine: Record "Job Journal Line"; CalledByFieldNo: Integer)
    var
        Job: Record Job;
        IsHandled: Boolean;
    begin
        IsHandled := false;

        if IsHandled then
            exit;

        with JobJnlLine do begin
            SetCurrency("Currency Code", "Currency Factor", "Posting Date");
            SetVAT(false, 0, 0, '');
            SetUoM(Abs(Quantity), "Qty. per Unit of Measure");

            case Type of
                Type::Item:
                    begin
                        Item.Get("No.");
                        TestField("Qty. per Unit of Measure");
                        Job.Get("Job No.");

                        FindSalesPrice(
                          TempSalesPrice, Job."Bill-to Customer No.", Job."Bill-to Contact No.",
                          "Customer Price Group", '', "No.", "Variant Code", "Unit of Measure Code",
                          "Currency Code", "Posting Date", false);
                        CalcBestUnitPrice(TempSalesPrice);
                        if FoundSalesPrice or
                           not ((CalledByFieldNo = FieldNo(Quantity)) or
                                (CalledByFieldNo = FieldNo("Variant Code")))
                        then
                            "Unit Price" := TempSalesPrice."Unit Price";
                    end;
                Type::Resource:
                    begin

                    end;
            end;
        end;

    end;



    local procedure JobPlanningLineLineDiscExists(var JobPlanningLine: Record "Job Planning Line"; ShowAll: Boolean): Boolean
    var
        Job: Record Job;
    begin
        with JobPlanningLine do
            if (Type = Type::Item) and Item.Get("No.") then begin
                Job.Get("Job No.");
                OnBeforeJobPlanningLineLineDiscExists(JobPlanningLine);
                FindSalesLineDisc(
                  TempSalesLineDisc, Job."Bill-to Customer No.", Job."Bill-to Contact No.",
                  Job."Customer Disc. Group", '', "No.", Item."Item Disc. Group", "Variant Code", "Unit of Measure Code",
                  "Currency Code", JobPlanningLineStartDate(JobPlanningLine, DateCaption), ShowAll);

                exit(TempSalesLineDisc.Find('-'));
            end;
        exit(false);
    end;

    local procedure JobPlanningLineStartDate(JobPlanningLine: Record "Job Planning Line"; var DateCaption: Text[30]): Date
    begin
        DateCaption := JobPlanningLine.FieldCaption("Planning Date");
        exit(JobPlanningLine."Planning Date");
    end;

    local procedure FindJobJnlLineLineDisc(var JobJnlLine: Record "Job Journal Line")
    begin
        with JobJnlLine do begin
            SetCurrency("Currency Code", "Currency Factor", "Posting Date");
            SetUoM(Abs(Quantity), "Qty. per Unit of Measure");
            TestField("Qty. per Unit of Measure");
            if Type = Type::Item then begin
                JobJnlLineLineDiscExists(JobJnlLine, false);
                CalcBestLineDisc(TempSalesLineDisc);
                "Line Discount %" := TempSalesLineDisc."Line Discount %";
            end;
        end;

        //OnAfterFindJobJnlLineLineDisc(JobJnlLine,TempSalesLineDisc);
    end;

    local procedure JobJnlLineLineDiscExists(var JobJnlLine: Record "Job Journal Line"; ShowAll: Boolean): Boolean
    var
        Job: Record Job;
    begin
        with JobJnlLine do
            if (Type = Type::Item) and Item.Get("No.") then begin
                Job.Get("Job No.");
                OnBeforeJobJnlLineLineDiscExists(JobJnlLine);
                FindSalesLineDisc(
                  TempSalesLineDisc, Job."Bill-to Customer No.", Job."Bill-to Contact No.",
                  Job."Customer Disc. Group", '', "No.", Item."Item Disc. Group", "Variant Code", "Unit of Measure Code",
                  "Currency Code", JobJnlLineStartDate(JobJnlLine, DateCaption), ShowAll);

                exit(TempSalesLineDisc.Find('-'));
            end;
        exit(false);
    end;

    local procedure JobJnlLineStartDate(JobJnlLine: Record "Job Journal Line"; var DateCaption: Text[30]): Date
    begin
        DateCaption := JobJnlLine.FieldCaption("Posting Date");
        exit(JobJnlLine."Posting Date");
    end;




    [IntegrationEvent(false, false)]
    local procedure OnBeforeFindSalesLinePrice(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; CalledByFieldNo: Integer; var IsHandled: Boolean)
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeFindSalesLineLineDisc(var SalesLine: Record "Sales Line"; var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFindServLinePrice(var ServiceLine: Record "Service Line"; ServiceHeader: Record "Service Header"; CalledByFieldNo: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFindServLineDisc(var ServiceHeader: Record "Service Header"; var ServiceLine: Record "Service Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFindStdItemJnlLinePrice(var StandardItemJournalLine: Record "Standard Item Journal Line"; CalledByFieldNo: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetSalesLineLineDisc(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeJobJnlLineLineDiscExists(var JobJournalLine: Record "Job Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeJobPlanningLineLineDiscExists(var JobPlanningLine: Record "Job Planning Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeJobPlanningLineFindJTPrice(var JobPlanningLine: Record "Job Planning Line"; var IsHandled: Boolean)
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnGetCustNoForSalesHeader(var SalesHeader: Record "Sales Header"; var CustomerNo: Code[20])
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, 7000, 'OnBeforeFindSalesLinePrice', '', false, false)]
    local procedure OnStdFindSalesLinePrice(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; CalledByFieldNo: Integer; var IsHandled: Boolean)
    begin
        FindSalesLinePrice(SalesHeader, SalesLine, CalledByFieldNo);
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, 7000, 'OnBeforeFindItemJnlLinePrice', '', false, false)]
    local procedure OnStdFindItemJnlLinePrice(var ItemJournalLine: Record "Item Journal Line"; CalledByFieldNo: Integer; var IsHandled: Boolean)
    begin
        FindItemJnlLinePrice(ItemJournalLine, CalledByFieldNo);
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, 7000, 'OnBeforeFindSalesLineLineDisc', '', false, false)]
    local procedure OnStdFindSalesLineLineDisc(var SalesLine: Record "Sales Line"; var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
        FindSalesLineLineDisc(SalesHeader, SalesLine);
        IsHandled := true;
    end;
}

