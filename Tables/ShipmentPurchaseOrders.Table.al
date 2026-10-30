table 50016 "Shipment Purchase Orders"
{
    // //AB60408.V14  EBE 21/04/08
    //    création table
    //    fonction GetSalesOrders : extraction des commandes vente
    //    fonction CheckSalesOrders : vérification des commandes vente
    //    fonction CheckPurchOrders : vérification des lignes à créer
    //    fonction CreatePurchOrders : création des commandes achat
    //    Validation visa de la commande d'achat
    // 
    // //AB627022012  VIR 27/02/12 : Gestion des tarifs d'achats de transport

    Caption = 'Shipment Purchase Orders';

    fields
    {
        field(1; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";
        }
        field(2; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(3; "Promised Delivery Date"; Date)
        {
            Caption = 'Promised Delivery Date';
            Description = 'Caption FRB : date départ confirmée';
        }
        field(4; "Purchase Order No."; Code[20])
        {
            Caption = 'Purchase Order No.';
            Editable = false;
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = CONST(Order));
        }
        field(5; "Buy-from Vendor No."; Code[20])
        {
            Caption = 'Buy-from Vendor No.';
            Editable = false;
            TableRelation = Vendor;
        }
        field(6; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            Editable = false;
            TableRelation = "Sales Header"."No." WHERE("Document Type" = CONST(Order));
        }
        field(7; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;
        }
        field(8; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Sell-to Customer No."));
        }
        field(9; "Customer Name"; Text[50])
        {
            Caption = 'Customer Name';
        }
        field(10; "Qty. to Ship"; Decimal)
        {
            Caption = 'Qty. to Ship';
            DecimalPlaces = 0 : 5;
        }
        field(11; "Quantity Shipped"; Decimal)
        {
            Caption = 'Quantity Shipped';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(19; "Order Date"; Date)
        {
            Caption = 'Order Date';
        }
        field(20; "Order type"; Option)
        {
            Caption = 'Order type';
            OptionCaption = ' ,Frais,Surgelé';
            OptionMembers = " ",Frais,"Surgelé";
        }
        field(21; "Logistic unit"; Code[20])
        {
            Caption = 'Logistic unit';
            TableRelation = "Unité logistique";
        }
        field(22; "Complete Pallet"; Boolean)
        {
            Caption = 'Complete Pallet';
        }
        field(23; "Customer Shipment Blocked"; Boolean)
        {
            Caption = 'Customer Shipment Blocked';
        }
        field(24; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(25; "Total Net Weight"; Decimal)
        {
            Caption = 'Total Net Weight';
        }
        field(26; "Pallet Quantity"; Integer)
        {
            Caption = 'Pallet Quantity';

            trigger OnValidate()
            var
                SalesHeader: Record "Sales Header";
            begin
                //AB627022012  VIR 27/02/12
                CalcTransport;
            end;
        }
        field(27; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = ' ,erreur,prévalidé,validé,terminé';
            OptionMembers = " ",erreur,"prévalidé","validé","terminé";
        }
        field(28; "Cases Quantity per Pallet"; Integer)
        {
            Caption = 'Cases Quantity per Pallet';
        }
        field(29; "Sales Invoice No"; Code[20])
        {
            Caption = 'Sales Invoice No';
            TableRelation = "Sales Invoice Header"."No." WHERE("No." = FIELD("Sales Invoice No"));
        }
        field(32; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(50005; "Unit price/Palette"; Decimal)
        {
            Caption = 'Unit price/Palette';
            Description = 'LOG-004';
        }
        field(50006; "Territory Code"; Code[10])
        {
            Caption = 'Territory Code';
            Description = 'LOG-004';
            TableRelation = Territory;
        }
        field(50009; "Unit Cost"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Unit Cost';
        }
        field(50020; "Date livraison prévue"; Date)
        {
            Caption = 'Date livraison prévue';
        }
    }

    keys
    {
        key(Key1; "Shipping Agent Code", "Location Code", "Promised Delivery Date", "Sales Order No.", "Sales Invoice No")
        {
            Clustered = true;
        }
        key(Key2; "Sell-to Customer No.", "Sales Order No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        ShippingAgent: Record "Shipping Agent";
        ShptPurchOrder: Record "Shipment Purchase Orders";
        SalesHeader: Record "Sales Header";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesLine: Record "Sales Line";
        ShptPurchErrors: Record "Shipment Purch. Order Errors";
        Text001: Label 'Ship-to Code must be filled.';
        Text002: Label 'Transport Line has not been calculated.';
        Text003: Label 'Order Type is blank. ';
        Text004: Label 'Logistic Unit must not be blank.';
        Text005: Label 'Shipping AGent has no linked Vendor.';
        Text006: Label 'Shipping Agent Code is blank.';
        Text007: Label 'Location Code is blank.';
        Text008: Label 'Promised Delivery Date is blank.';
        Text010: Label 'There is nothing to create.';
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        PurchSetup: Record "Purchases & Payables Setup";
        LastLineNo: Integer;
        Text011: Label 'Pallet quantity must not be 0,';
        Text012: Label 'Cases quantity must not be 0,';
        Text013: Label 'Le tarif de transport doit être renseigné.';
        Text014: Label 'Le secteur de livraison doit être renseigné.';
        Text015: Label 'Le type de commande doit être renseigné.';
        Text016: Label 'L''unité logistique doit être renseignée.';
        CuPurch: Codeunit Integration_Purchase;

    [Scope('OnPrem')]
    procedure GetSalesOrders(l_LocationFilter: Text[250]; l_ShippingAgentFilter: Text[250]; l_DateFilter: Text[30]; l_SalesOrderNo: Code[20])
    begin
        SalesHeader.Reset;
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);

        if l_SalesOrderNo <> '' then
            SalesHeader.SetRange(SalesHeader."No.", l_SalesOrderNo)
        else begin
            if l_LocationFilter <> '' then
                SalesHeader.SetFilter("Location Code", l_LocationFilter);
            if l_ShippingAgentFilter <> '' then
                SalesHeader.SetFilter("Shipping Agent Code", l_ShippingAgentFilter);
            if l_DateFilter <> '' then
                SalesHeader.SetFilter("Promised Delivery Date", l_DateFilter);
        end;

        if SalesHeader.Find('-') then
            repeat begin
                SalesLine.Reset;
                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                SalesLine.SetFilter("Qty. to Ship", '<>0');
                if SalesLine.Find('-') then begin
                    ShptPurchOrder.Reset;
                    ShptPurchOrder.SetRange("Shipping Agent Code", SalesHeader."Shipping Agent Code");
                    ShptPurchOrder.SetRange("Location Code", SalesHeader."Location Code");
                    ShptPurchOrder.SetRange("Promised Delivery Date", SalesHeader."Promised Delivery Date");
                    ShptPurchOrder.SetRange("Sales Order No.", SalesHeader."No.");
                    if not ShptPurchOrder.Find('-') then begin
                        ShptPurchOrder.Init;
                        ShptPurchOrder."Shipping Agent Code" := SalesHeader."Shipping Agent Code";
                        ShptPurchOrder."Location Code" := SalesHeader."Location Code";
                        ShptPurchOrder."Promised Delivery Date" := SalesHeader."Promised Delivery Date";
                        ShptPurchOrder."Sales Order No." := SalesHeader."No.";
                        ShptPurchOrder.Insert;
                    end;
                    if ShippingAgent.Get(SalesHeader."Shipping Agent Code") then
                        ShptPurchOrder."Buy-from Vendor No." := ShippingAgent."Buy-from Vendor No.";
                    ShptPurchOrder."Order type" := SalesHeader."Order type";
                    ShptPurchOrder."Logistic unit" := SalesHeader."Logistic unit";
                    ShptPurchOrder."Complete Pallet" := SalesHeader."Complete Pallet";
                    ShptPurchOrder."Customer Shipment Blocked" := SalesHeader."Customer Shipment Blocked";
                    ShptPurchOrder."Currency Code" := SalesHeader."Currency Code";
                    ShptPurchOrder."Order Date" := SalesHeader."Order Date";
                    ShptPurchOrder."Territory Code" := SalesHeader."Territory Code";
                    //ShptPurchOrder."Purchase Order No."     := SalesHeader."Transport Purchase Order";
                    ShptPurchOrder."Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
                    ShptPurchOrder."Customer Name" := SalesHeader."Sell-to Customer Name";
                    ShptPurchOrder."Ship-to Code" := SalesHeader."Ship-to Code";
                    //AB627022012  VIR 27/02/12 --->
                    ShptPurchOrder."Pallet Quantity" := SalesHeader."Nombre de palette confirmée";
                    ShptPurchOrder."Cases Quantity per Pallet" := SalesHeader."Cases Quantity per Pallet";
                    //AB627022012  VIR 27/02/12 <---
                    ShptPurchOrder."Qty. to Ship" := 0;
                    ShptPurchOrder."Quantity Shipped" := 0;
                    ShptPurchOrder."Total Net Weight" := 0;
                    //GEO120118
                    ShptPurchOrder."Date livraison prévue" := SalesHeader."Date livraison prévue";

                    repeat begin
                        // nombre de palettes et nombre de colis par palette renseignés manuellement
                        //IF SalesLine."Transport line" THEN
                        //  ShptPurchOrder."Pallet Quantity" := ROUND(SalesLine."Qty. to Ship",1)
                        //  ELSE BEGIN
                        if not SalesLine."Transport line" then begin
                            ShptPurchOrder."Total Net Weight" += SalesLine."Qty. to Ship" * SalesLine."Net Weight";
                            ShptPurchOrder."Qty. to Ship" += SalesLine."Qty. to Ship";
                            ShptPurchOrder."Quantity Shipped" += SalesLine."Quantity Shipped";
                        end;
                    end until SalesLine.Next = 0;
                    ShptPurchOrder.Modify;
                end;

            end until SalesHeader.Next = 0;
    end;

    [Scope('OnPrem')]
    procedure CheckSalesOrders(l_LocationFilter: Text[250]; l_ShippingAgentFilter: Text[250]; l_DateFilter: Text[30]; l_SalesOrderNo: Code[20])
    begin
        //Purge des erreurs précédentes
        ShptPurchErrors.DeleteAll;

        /*
        ShptPurchOrder.RESET;
        IF l_SalesOrderNo <> '' THEN
          ShptPurchOrder.SETRANGE("Sales Order No.",l_SalesOrderNo)
        ELSE BEGIN
          ShptPurchOrder.SETFILTER("Shipping Agent Code",l_ShippingAgentFilter);
          ShptPurchOrder.SETFILTER("Location Code",l_LocationFilter);
          ShptPurchOrder.SETFILTER("Promised Delivery Date",l_DateFilter);
        END;
        */

        SetFilter(Status, '<%1', ShptPurchOrder.Status::"validé");
        if Find('-') then
            repeat begin
                Status := ShptPurchOrder.Status::"prévalidé";

                //code transporteur doit être renseigné
                if "Shipping Agent Code" = '' then begin
                    ShptPurchErrors.AddError('Sales Orders', "Sales Order No.", "Shipping Agent Code",
                                              "Location Code", "Promised Delivery Date",
                                              Text006);
                    Status := ShptPurchOrder.Status::erreur;
                end;

                //code magasin doit être renseigné
                if "Location Code" = '' then begin
                    ShptPurchErrors.AddError('Sales Orders', "Sales Order No.", "Shipping Agent Code",
                                              "Location Code", "Promised Delivery Date",
                                              Text007);
                    Status := ShptPurchOrder.Status::erreur;
                end;

                //date de départ confirmée doit être renseignée
                if "Promised Delivery Date" = 0D then begin
                    ShptPurchErrors.AddError('Sales Orders', "Sales Order No.", "Shipping Agent Code",
                                              "Location Code", "Promised Delivery Date",
                                              Text008);
                    Status := ShptPurchOrder.Status::erreur;
                end;


                //avertissement si le ligne de transport n'a pas été calculée
                SalesLine.Reset;
                SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                SalesLine.SetRange("Document No.", "Sales Order No.");
                SalesLine.SetRange("Transport line", true);
                if not SalesLine.Find('-') then begin
                    ShptPurchErrors.AddWarning('Sales Orders', "Sales Order No.", "Shipping Agent Code",
                                              "Location Code", "Promised Delivery Date",
                                              Text002);
                end;

                //Type de commande doit être renseigné
                if "Order type" = ShptPurchOrder."Order type"::" " then begin
                    ShptPurchErrors.AddError('Sales Orders', "Sales Order No.", "Shipping Agent Code",
                                              "Location Code", "Promised Delivery Date",
                                              Text003);
                    Status := ShptPurchOrder.Status::erreur;
                end;

                //Unité logistique doit être renseignée
                if "Logistic unit" = '' then begin
                    ShptPurchErrors.AddError('Sales Orders', "Sales Order No.", "Shipping Agent Code",
                                              "Location Code", "Promised Delivery Date",
                                              Text004);
                    Status := ShptPurchOrder.Status::erreur;
                end;

                //code fournisseur doit être renseigné
                if "Buy-from Vendor No." = '' then begin
                    ShptPurchErrors.AddError('Sales Orders', "Sales Order No.", "Shipping Agent Code",
                                              "Location Code", "Promised Delivery Date",
                                              Text005);
                    Status := ShptPurchOrder.Status::erreur;
                end;

                Modify;

            end until Next = 0;

    end;

    [Scope('OnPrem')]
    procedure CheckPurchOrders(l_LocationFilter: Text[250]; l_ShippingAgentFilter: Text[250]; l_DateFilter: Text[30]; l_SalesOrderNo: Code[20])
    begin
        //Purge des erreurs précédentes
        ShptPurchErrors.DeleteAll;

        /*
        ShptPurchOrder.RESET;
        IF l_SalesOrderNo <> '' THEN
          ShptPurchOrder.SETRANGE("Sales Order No.",l_SalesOrderNo)
        ELSE BEGIN
          ShptPurchOrder.SETFILTER("Shipping Agent Code",l_ShippingAgentFilter);
          ShptPurchOrder.SETFILTER("Location Code",l_LocationFilter);
          ShptPurchOrder.SETFILTER("Promised Delivery Date",l_DateFilter);
        END;
        */

        SetFilter(Status, '<%1', Status::"validé");
        if Find('-') then
            repeat begin
                Status := Status::"prévalidé";
                //Nbre de palette doit être >0
                if "Pallet Quantity" = 0 then begin
                    ShptPurchErrors.AddError('Purch Orders', "Sales Order No.", "Shipping Agent Code",
                                              "Location Code", "Promised Delivery Date",
                                              Text011);
                    Status := Status::erreur;
                end;
                /*

                  //AB627022012  VIR 27/02/12 --->
                  //A REMETTRE APRES LA SAISIE DES TARIFS DE TRANSPORT PAR EUROPA CUISSON
                  IF "Territory Code" = '' THEN BEGIN
                     ShptPurchErrors.AddError('Purch Orders',"Sales Order No.","Shipping Agent Code",
                                               "Location Code","Promised Delivery Date",
                                               Text014);
                     Status := Status::erreur;
                  END;
                  IF "Order type" = "Order type"::" " THEN BEGIN
                     ShptPurchErrors.AddError('Purch Orders',"Sales Order No.","Shipping Agent Code",
                                               "Location Code","Promised Delivery Date",
                                               Text015);
                     Status := Status::erreur;
                  END;
                  IF "Logistic unit" = '' THEN BEGIN
                     ShptPurchErrors.AddError('Purch Orders',"Sales Order No.","Shipping Agent Code",
                                               "Location Code","Promised Delivery Date",
                                               Text016);
                     Status := Status::erreur;
                  END;
                  IF (Status <> Status::erreur) THEN BEGIN
                     VALIDATE("Pallet Quantity","Pallet Quantity");
                     IF "Unit Cost" = 0 THEN BEGIN
                        ShptPurchErrors.AddError('Purch Orders',"Sales Order No.","Shipping Agent Code",
                                                 "Location Code","Promised Delivery Date",
                                                 Text013);
                        Status := Status::erreur;
                     END;
                  END;
                  //A REMETTRE APRES LA SAISIE DES TARIFS DE TRANSPORT PAR EUROPA CUISSON
                  //AB627022012  VIR 27/02/12 <---

                */

                //A ENLEVER APRES LA SAISIE DES TARIFS DE TRANSPORT PAR EUROPA CUISSON
                if "Unit Cost" = 0 then
                    Validate("Pallet Quantity", "Pallet Quantity");
                //A ENLEVER APRES LA SAISIE DES TARIFS DE TRANSPORT PAR EUROPA CUISSON

                //Nbre de colis par palette doit être >0
                if "Cases Quantity per Pallet" = 0 then begin
                    ShptPurchErrors.AddError('Purch Orders', "Sales Order No.", "Shipping Agent Code",
                                              "Location Code", "Promised Delivery Date",
                                              Text012);
                    Status := Status::erreur;
                end;

                Modify(true);

            end until Next = 0;

    end;

    [Scope('OnPrem')]
    procedure CreatePurchOrders(l_LocationFilter: Text[250]; l_ShippingAgentFilter: Text[250]; l_DateFilter: Text[30]; l_SalesOrderNo: Code[20])
    begin

        PurchSetup.Get;
        PurchSetup.TestField("Transport G/L Account No.");
        PurchSetup.TestField("Order Nos.");

        //ShptPurchOrder.RESET;
        if l_SalesOrderNo <> '' then
            SetRange("Sales Order No.", l_SalesOrderNo);
        /*
        ELSE BEGIN
          ShptPurchOrder.SETFILTER("Shipping Agent Code",l_ShippingAgentFilter);
          ShptPurchOrder.SETFILTER("Location Code",l_LocationFilter);
          ShptPurchOrder.SETFILTER("Promised Delivery Date",l_DateFilter);
        END;
        */

        SetRange(Status, ShptPurchOrder.Status::"prévalidé");
        if not Find('-') then
            Message(Text010)
        else
            repeat begin
                PurchHeader.Reset;
                PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Order);
                PurchHeader.SetRange("Location Code", "Location Code");
                PurchHeader.SetRange("Buy-from Vendor No.", "Buy-from Vendor No.");
                PurchHeader.SetRange("Posting Date", "Promised Delivery Date");

                if not PurchHeader.Find('-') then begin
                    LastLineNo := 0;
                    PurchHeader.Init;
                    PurchHeader."Document Type" := PurchHeader."Document Type"::Order;
                    PurchHeader."No." := '';
                    PurchHeader."Posting Date" := "Promised Delivery Date";
                    PurchHeader.Insert(true);

                    PurchHeader.Validate("Buy-from Vendor No.", "Buy-from Vendor No.");
                    PurchHeader.Validate("Location Code", "Location Code");
                    PurchHeader."Shipping Agent Code" := "Shipping Agent Code";
                    PurchHeader."Date Visa" := WorkDate;
                    PurchHeader."Person in charge Visa" := UserId;
                    // PurchHeader.VALIDATE(Status,PurchHeader.Status::Released);
                    PurchHeader.Validate("Status Visa", PurchHeader."Status Visa"::"Visa authorized");
                    PurchHeader."Expected Receipt Date" := "Promised Delivery Date";
                    PurchHeader."Promised Receipt Date" := "Promised Delivery Date";
                    PurchHeader.Modify;
                end else begin
                    PurchLine.Reset;
                    PurchLine.SetRange("Document Type", PurchHeader."Document Type");
                    PurchLine.SetRange("Document No.", PurchHeader."No.");
                    if PurchLine.Find('+') then
                        LastLineNo := PurchLine."Line No.";
                end;

                PurchLine.Reset;
                PurchLine.SetRange("Document Type", PurchHeader."Document Type");
                PurchLine.SetRange("Document No.", PurchHeader."No.");
                PurchLine.SetRange("Transport Sales Order No", "Sales Order No.");
                PurchLine.SetRange("Transport Sales Invoice No", "Sales Invoice No");
                if not PurchLine.Find('-') then begin
                    PurchLine.Init;
                    PurchLine."Document Type" := PurchHeader."Document Type";
                    PurchLine."Buy-from Vendor No." := PurchHeader."Buy-from Vendor No.";
                    PurchLine."Document No." := PurchHeader."No.";
                    PurchLine."Line No." := LastLineNo + 10000;
                    PurchLine.Validate(Type, PurchLine.Type::"G/L Account");
                    PurchLine.Validate("No.", PurchSetup."Transport G/L Account No.");
                    PurchLine.Validate("Location Code", PurchHeader."Location Code");
                    PurchLine.Validate(Quantity, "Pallet Quantity");
                    //AB627022012  VIR 27/02/12 -->
                    PurchLine.Validate(PurchLine."Direct Unit Cost", "Unit Cost");
                    //AB627022012  VIR 27/02/12 <--
                    PurchLine."Cases Quantity per Pallet" := "Cases Quantity per Pallet";
                    PurchLine."Transport Sales Order No" := "Sales Order No.";

                    //GEO  120118
                    PurchLine."Transport Comment" := "Sales Order No." + ' - liv ' + Format("Date livraison prévue");

                    PurchLine."Transport Customer No" := "Sell-to Customer No.";
                    PurchLine."Transport Ship-to Code" := "Ship-to Code";
                    PurchLine."Transport Sales Invoice No" := "Sales Invoice No";
                    PurchLine."Net Weight" := "Total Net Weight";
                    PurchLine."Logistic unit" := "Logistic unit";
                    PurchLine.Insert;
                    CuPurch.UpdateCmdTpt(PurchLine."Document No.", PurchLine."Line No.");
                    PurchLine.ValidateShortcutDimCode(3, "Sell-to Customer No.");
                end else begin
                    PurchLine.Validate(Type, PurchLine.Type::"G/L Account");
                    PurchLine.Validate("No.", PurchSetup."Transport G/L Account No.");
                    PurchLine.Validate("Location Code", PurchHeader."Location Code");
                    PurchLine.Validate(Quantity, "Pallet Quantity");
                    PurchLine."Cases Quantity per Pallet" := "Cases Quantity per Pallet";
                    PurchLine."Transport Sales Order No" := "Sales Order No.";
                    PurchLine."Transport Customer No" := "Sell-to Customer No.";
                    PurchLine."Transport Ship-to Code" := "Ship-to Code";
                    PurchLine."Transport Sales Invoice No" := "Sales Invoice No";
                    PurchLine."Net Weight" := "Total Net Weight";
                    PurchLine."Logistic unit" := "Logistic unit";
                    //AB627022012  VIR 27/02/12 -->
                    PurchLine.Validate(PurchLine."Direct Unit Cost", "Unit Cost");
                    //AB627022012  VIR 27/02/12 <--
                    PurchLine.Modify;
                    CuPurch.UpdateCmdTpt(PurchLine."Document No.", PurchLine."Line No.");
                end;

                //Mise à jour statut ligne et No cde achat
                "Purchase Order No." := PurchHeader."No.";
                Status := ShptPurchOrder.Status::"validé";
                Modify;

                //mise à jour commande de vente
                if SalesHeader.Get(SalesHeader."Document Type"::Order, "Sales Order No.") then begin
                    SalesHeader."Transport Purchase Order" := PurchHeader."No.";
                    SalesHeader.Modify;
                end;

                //mise à jour facture de vente
                if SalesInvHeader.Get("Sales Invoice No") then begin
                    SalesInvHeader."Transport Purchase Order" := PurchHeader."No.";
                    SalesInvHeader.Modify;
                end;

            end until Next = 0;

    end;

    [Scope('OnPrem')]
    procedure UpdatePurchOrders(l_LocationFilter: Text[250]; l_ShippingAgentFilter: Text[250]; l_DateFilter: Text[30]; l_PurchOrderNo: Code[20])
    begin

        ShptPurchOrder.Reset;
        if l_PurchOrderNo <> '' then
            SetRange("Purchase Order No.", l_PurchOrderNo);

        /*
        ELSE BEGIN
          ShptPurchOrder.SETFILTER("Shipping Agent Code",l_ShippingAgentFilter);
          ShptPurchOrder.SETFILTER("Location Code",l_LocationFilter);
          ShptPurchOrder.SETFILTER("Promised Delivery Date",l_DateFilter);
        END;
        */

        SetRange(Status, ShptPurchOrder.Status::"validé");
        if not Find('-') then
            exit
        else
            repeat begin
                PurchLine.Reset;
                PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
                PurchLine.SetRange("Document No.", "Purchase Order No.");
                PurchLine.SetRange("Transport Sales Order No", "Sales Order No.");
                PurchLine.SetRange("Transport Sales Invoice No", "Sales Invoice No");
                if PurchLine.Find('-') then begin
                    PurchLine."Buy-from Vendor No." := "Buy-from Vendor No.";
                    PurchLine.Validate(Quantity, "Pallet Quantity");
                    PurchLine."Cases Quantity per Pallet" := "Cases Quantity per Pallet";
                    PurchLine."Transport Customer No" := "Sell-to Customer No.";
                    PurchLine."Transport Ship-to Code" := "Ship-to Code";
                    PurchLine."Transport Sales Invoice No" := "Sales Invoice No";
                    PurchLine."Net Weight" := "Total Net Weight";
                    PurchLine."Logistic unit" := "Logistic unit";
                    PurchLine.Modify;
                    CuPurch.UpdateCmdTpt(PurchLine."Document No.", PurchLine."Line No.");
                end;
            end until Next = 0;

    end;

    [Scope('OnPrem')]
    procedure UpdatePurchPost(l_PurchLine: Record "Purchase Line")
    begin
        ShptPurchOrder.Reset;
        ShptPurchOrder.SetRange("Purchase Order No.", l_PurchLine."Document No.");
        ShptPurchOrder.SetRange("Sales Order No.", l_PurchLine."Transport Sales Order No");
        ShptPurchOrder.SetRange("Sales Invoice No", l_PurchLine."Transport Sales Invoice No");
        ShptPurchOrder.SetRange(Status, ShptPurchOrder.Status::"validé");
        if ShptPurchOrder.Find('-') then begin
            ShptPurchOrder.Status := ShptPurchOrder.Status::"terminé";
            ShptPurchOrder.Modify;
        end;
    end;

    [Scope('OnPrem')]
    procedure CalcTransport()
    var
        fTransport: Page "Sélection Transport";
        lRecTransport: Record Transport;
    begin

        /*
        //A REMETTRE APRES SAISIE DES TARIFS
        TESTFIELD("Order type");
        TESTFIELD("Logistic unit");
        TESTFIELD("Territory Code");
        //A REMETTRE APRES SAISIE DES TARIFS
        */

        Clear(fTransport);
        "Unit Cost" := 0;
        lRecTransport.Reset;
        lRecTransport.SetRange(Type, lRecTransport.Type::Achats);
        lRecTransport.SetRange("Currency code", "Currency Code");
        lRecTransport.SetRange("Type transport", "Order type");
        lRecTransport.SetRange("Paletts type", "Logistic unit");
        lRecTransport.SetRange("Territory code", "Territory Code");
        lRecTransport.SetRange("Shipping Agent Code", "Shipping Agent Code");

        lRecTransport.SetFilter("Starting date", '%1..%2', 0D, "Promised Delivery Date");
        lRecTransport.SetFilter(lRecTransport."End date", '%1|>=%2', 0D, "Promised Delivery Date");
        lRecTransport.SetFilter("Number of Pallets", '>=%1', "Pallet Quantity");

        if lRecTransport.FindFirst then
            "Unit Cost" := lRecTransport."Paletts / Price";

    end;

    [Scope('OnPrem')]
    procedure OpenTransport()
    var
        fTransport: Page "Sélection Transport";
        lRecTransport: Record Transport;
    begin
        TestField("Order type");
        TestField("Logistic unit");
        TestField("Territory Code");
        //A COMPLETER TestTransportLine;
        Clear(fTransport);
        lRecTransport.Reset;
        lRecTransport.SetRange(Type, lRecTransport.Type::Achats);
        lRecTransport.SetRange("Currency code", "Currency Code");
        lRecTransport.SetRange("Type transport", "Order type");
        lRecTransport.SetRange("Paletts type", "Logistic unit");
        lRecTransport.SetRange("Territory code", "Territory Code");

        lRecTransport.SetFilter("Starting date", '%1..%2', 0D, "Promised Delivery Date");
        lRecTransport.SetFilter(lRecTransport."End date", '%1|>=%2', 0D, "Promised Delivery Date");

        if (lRecTransport.Count = 1) then
            "Unit Cost" := lRecTransport."Paletts / Price";

        if lRecTransport.Count > 1 then begin
            fTransport.LookupMode := true;
            fTransport.SetTableView(lRecTransport);
            if fTransport.RunModal = ACTION::LookupOK then begin
                fTransport.GetRecord(lRecTransport);
                "Unit Cost" := lRecTransport."Paletts / Price";
                Modify;
            end;
        end;
    end;

    [Scope('OnPrem')]
    procedure CheckPurchOrders2(l_LocationFilter: Text[250]; l_ShippingAgentFilter: Text[250]; l_DateFilter: Text[30]; l_SalesOrderNo: Code[20])
    begin
        //Purge des erreurs précédentes
        ShptPurchErrors.DeleteAll;

        /*
        ShptPurchOrder.RESET;
        IF l_SalesOrderNo <> '' THEN
          ShptPurchOrder.SETRANGE("Sales Order No.",l_SalesOrderNo)
        ELSE BEGIN
          ShptPurchOrder.SETFILTER("Shipping Agent Code",l_ShippingAgentFilter);
          ShptPurchOrder.SETFILTER("Location Code",l_LocationFilter);
          ShptPurchOrder.SETFILTER("Promised Delivery Date",l_DateFilter);
        END;
        */

        SetFilter(Status, '<%1', Status::"validé");
        if Find('-') then
            repeat begin
                Status := Status::"prévalidé";
                //Nbre de palette doit être >0
                if "Pallet Quantity" = 0 then begin
                    ShptPurchErrors.AddError('Purch Orders', "Sales Order No.", "Shipping Agent Code",
                                              "Location Code", "Promised Delivery Date",
                                              Text011);
                    Status := Status::erreur;
                end;

                /*
                  //AB627022012  VIR 27/02/12 --->
                  //A REMETTRE APRES LA SAISIE DES TARIFS DE TRANSPORT PAR EUROPA CUISSON
                  IF "Territory Code" = '' THEN BEGIN
                     ShptPurchErrors.AddError('Purch Orders',"Sales Order No.","Shipping Agent Code",
                                               "Location Code","Promised Delivery Date",
                                               Text014);
                     Status := Status::erreur;
                  END;
                  IF "Order type" = "Order type"::" " THEN BEGIN
                     ShptPurchErrors.AddError('Purch Orders',"Sales Order No.","Shipping Agent Code",
                                               "Location Code","Promised Delivery Date",
                                               Text015);
                     Status := Status::erreur;
                  END;
                  IF "Logistic unit" = '' THEN BEGIN
                     ShptPurchErrors.AddError('Purch Orders',"Sales Order No.","Shipping Agent Code",
                                               "Location Code","Promised Delivery Date",
                                               Text016);
                     Status := Status::erreur;
                  END;
                  IF "Unit Cost" = 0 THEN BEGIN
                     ShptPurchErrors.AddError('Purch Orders',"Sales Order No.","Shipping Agent Code",
                                              "Location Code","Promised Delivery Date",
                                              Text013);
                     Status := Status::erreur;
                  END;
                  //A REMETTRE APRES LA SAISIE DES TARIFS DE TRANSPORT PAR EUROPA CUISSON
                  //AB627022012  VIR 27/02/12 <---

                */

                //Nbre de colis par palette doit être >0
                if "Cases Quantity per Pallet" = 0 then begin
                    ShptPurchErrors.AddError('Purch Orders', "Sales Order No.", "Shipping Agent Code",
                                              "Location Code", "Promised Delivery Date",
                                              Text012);
                    Status := Status::erreur;
                end;

                Modify(true);

            end until Next = 0;

    end;
}

