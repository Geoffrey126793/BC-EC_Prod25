report 50011 "Sales - Invoice PRO FORMA"
{
    // //---------------------------------------------------------------------------------------------//
    // // AJouter la clé : VAT %,VAT Identifier,VAT Calculation Type,Tax Group Code,Use Tax,Positive  //
    // //                  Dans la table "VAT Amount Line"
    // //---------------------------------------------------------------------------------------------//
    // 
    // ABC(OLL) - 24/07/2017 - Ajout test commande lancée
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/SalesInvoicePROFORMA.rdlc';

    Caption = 'Order Confirmation';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") ORDER(Ascending) WHERE("Document Type" = CONST(Order));
            RequestFilterFields = "Document Type", "No.";
            column(Sales_Header_Document_Type; "Document Type")
            {
            }
            column(Sales_Header_No_; "No.")
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number) ORDER(Ascending);
                column(RecCompanyInformation_g__Fax_No__; RecCompanyInformation_g."Fax No.")
                {
                }
                column(RecCompanyInformation_g__Phone_No__; RecCompanyInformation_g."Phone No.")
                {
                }
                column(DataItem1000000156; RecCompanyInformation_g."Post Code" + ' ' + RecCompanyInformation_g.City + '-' + RecCompanyInformation_g."Country/Region Code")
                {
                }
                column(RecCompanyInformation_g_Address_________RecCompanyInformation_g__Address_2_; RecCompanyInformation_g.Address + ' ' + RecCompanyInformation_g."Address 2")
                {
                }
                column(RecCompanyInformation_g_Picture; RecCompanyInformation_g.Picture)
                {
                }
                column(RecCompanyInformation_g__E_Mail_; RecCompanyInformation_g."E-Mail")
                {
                }
                column(BE__RecCompanyInformation_g__Enterprise_No__; 'BE' + RecCompanyInformation_g."Enterprise No.")
                {
                }
                column(TxtBankName1_g; TxtBankName1_g)
                {
                }
                column(LabBic1_g; LabBic1_g)
                {
                }
                column(LabNum1_g; LabNum1_g)
                {
                }
                column(LabNum2_g; LabNum2_g)
                {
                }
                column(LabBic2_g; LabBic2_g)
                {
                }
                column(TxtBankName2_g; TxtBankName2_g)
                {
                }
                column(RecCompanyInformation_g__N__Registre_de_Commerce_; RecCompanyInformation_g."Nº Registre de Commerce")
                {
                }
                column(RecBankAccount4_g_Logo; RecBankAccount4_g.Logo)
                {
                }
                column(TxtNum2_g; TxtNum2_g)
                {
                }
                column(TxtNum3_g; TxtNum3_g)
                {
                }
                column(TxtNum4_g; TxtNum4_g)
                {
                }
                column(TxtNum1_g; TxtNum1_g)
                {
                }
                column(RecBankAccount3_g_Logo; RecBankAccount3_g.Logo)
                {
                }
                column(RecBankAccount2_g_Logo; RecBankAccount2_g.Logo)
                {
                }
                column(TxtBic4_g; TxtBic4_g)
                {
                }
                column(TxtBic3_g; TxtBic3_g)
                {
                }
                column(RecBankAccount1_g_Logo; RecBankAccount1_g.Logo)
                {
                }
                column(TxtBic2_g; TxtBic2_g)
                {
                }
                column(RecBankAccount4_g_Logo_HASVALUE; RecBankAccount4_g.Logo.HasValue)
                {
                }
                column(RecBankAccount3_g_Logo_HASVALUE; RecBankAccount3_g.Logo.HasValue)
                {
                }
                column(RecBankAccount2_g_Logo_HASVALUE; RecBankAccount2_g.Logo.HasValue)
                {
                }
                column(RecBankAccount1_g_Logo_HASVALUE; RecBankAccount1_g.Logo.HasValue)
                {
                }
                column(TxtBic1_g; TxtBic1_g)
                {
                }
                column(Sales_Header___Document_Date_; "Sales Header"."Document Date")
                {
                }
                column(Sales_Header___Bill_to_Customer_No__; "Sales Header"."Bill-to Customer No.")
                {
                }
                column(TxtBillToAddress_g_1_; TxtBillToAddress_g[1])
                {
                }
                column(TxtBillToAddress_g_3_; TxtBillToAddress_g[3])
                {
                }
                column(TxtBillToAddress_g_5_; TxtBillToAddress_g[5])
                {
                }
                column(TxtBillToAddress_g_2_; TxtBillToAddress_g[2])
                {
                }
                column(TxtBillToAddress_g_4_; TxtBillToAddress_g[4])
                {
                }
                column(TxtBillToAddress_g_6_; TxtBillToAddress_g[6])
                {
                }
                column(TxtShipToAddress_g_1_; TxtShipToAddress_g[1])
                {
                }
                column(TxtShipToAddress_g_3_; TxtShipToAddress_g[3])
                {
                }
                column(TxtShipToAddress_g_5_; TxtShipToAddress_g[5])
                {
                }
                column(TxtShipToAddress_g_2_; TxtShipToAddress_g[2])
                {
                }
                column(TxtShipToAddress_g_4_; TxtShipToAddress_g[4])
                {
                }
                column(Text50000; Text50000)
                {
                }
                column(Sales_Header___External_Document_No__; "Sales Header"."External Document No.")
                {
                }
                column(TxtVATRegNo_g; TxtVATRegNo_g)
                {
                }
                column(Sales_Header___No__; "Sales Header"."No.")
                {
                }
                column(RecPaymentTerms_g_Description; RecPaymentTerms_g.Description)
                {
                }
                column(TextPage_______FORMAT_CurrReport_PAGENO_; TextPage + ' 1')
                {
                }
                column(Sales_Header___Promised_Delivery_Date_; "Sales Header"."Promised Delivery Date")
                {
                }
                column(OutputNo; OutputNo)
                {
                }
                column(Bank___Caption; Bank___CaptionLbl)
                {
                }
                column(TEL___Caption; TEL___CaptionLbl)
                {
                }
                column(FAX__Caption; FAX__CaptionLbl)
                {
                }
                column(E_mail__Caption; E_mail__CaptionLbl)
                {
                }
                column(MwSt_Caption; MwSt_CaptionLbl)
                {
                }
                column("PRODUZENT_VON_GEKOCHTEM_GEFLÜGELFLEISCHCaption"; PRODUZENT_VON_GEKOCHTEM_GEFLÜGELFLEISCHCaptionLbl)
                {
                }
                column(DatumCaption; DatumCaptionLbl)
                {
                }
                column(AbrechnungsadresseCaption; AbrechnungsadresseCaptionLbl)
                {
                }
                column(LieferungsadresseCaption; LieferungsadresseCaptionLbl)
                {
                }
                column(Sales_Header___External_Document_No__Caption; "Sales Header".FieldCaption("External Document No."))
                {
                }
                column(MwSt__nrCaption; MwSt__nrCaptionLbl)
                {
                }
                column(KundencodeCaption; KundencodeCaptionLbl)
                {
                }
                column(ErinnernCaption; ErinnernCaptionLbl)
                {
                }
                column(Dokumentennr_Caption; Dokumentennr_CaptionLbl)
                {
                }
                column(Zahlungsbedingungen__Caption; Zahlungsbedingungen__CaptionLbl)
                {
                }
                column(GesamtzahlCaption; GesamtzahlCaptionLbl)
                {
                }
                column(Preis_je_EinheitCaption; Preis_je_EinheitCaptionLbl)
                {
                }
                column("Quantität___GewichtCaption"; Quantität___GewichtCaptionLbl)
                {
                }
                column(EinheitCaption; EinheitCaptionLbl)
                {
                }
                column(BeschreibungCaption; BeschreibungCaptionLbl)
                {
                }
                column(KundenreferenzCaption; KundenreferenzCaptionLbl)
                {
                }
                column(Ref_Caption; Ref_CaptionLbl)
                {
                }
                column("Geschätztes_DatumCaption"; Geschätztes_DatumCaptionLbl)
                {
                }
                column(Rab___Caption; Rab___CaptionLbl)
                {
                }
                column(CopyLoop_Number; Number)
                {
                }
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) ORDER(Ascending) WHERE(Number = CONST(1));
                    dataitem("Sales Line"; "Sales Line")
                    {
                        DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                        DataItemLinkReference = "Sales Header";

                        column(TxtBankName1_g_Control1000000035; TxtBankName1_g)
                        {
                        }
                        column(TxtBankName2_g_Control1000000043; TxtBankName2_g)
                        {
                        }
                        column(LabBic1_g_Control1000000045; LabBic1_g)
                        {
                        }
                        column(LabNum1_g_Control1000000071; LabNum1_g)
                        {
                        }
                        column(RecCompanyInformation_g__Fax_No___Control1000000086; RecCompanyInformation_g."Fax No.")
                        {
                        }
                        column(RecCompanyInformation_g__Phone_No___Control1000000097; RecCompanyInformation_g."Phone No.")
                        {
                        }
                        column(DataItem1000000101; RecCompanyInformation_g."Post Code" + ' ' + RecCompanyInformation_g.City + '-' + RecCompanyInformation_g."Country/Region Code")
                        {
                        }
                        column(RecCompanyInformation_g_Address_________RecCompanyInformation_g__Address_2__Control1000000102; RecCompanyInformation_g.Address + ' ' + RecCompanyInformation_g."Address 2")
                        {
                        }
                        column(RecCompanyInformation_g__E_Mail__Control1000000104; RecCompanyInformation_g."E-Mail")
                        {
                        }
                        column(BE__RecCompanyInformation_g__Enterprise_No___Control1000000105; 'BE' + RecCompanyInformation_g."Enterprise No.")
                        {
                        }
                        column(LabBic2_g_Control1000000108; LabBic2_g)
                        {
                        }
                        column(RecCompanyInformation_g_Picture_Control1000000118; RecCompanyInformation_g.Picture)
                        {
                        }
                        column(LabNum2_g_Control1000000120; LabNum2_g)
                        {
                        }
                        column(RecCompanyInformation_g__N__Registre_de_Commerce__Control1000000121; RecCompanyInformation_g."Nº Registre de Commerce")
                        {
                        }
                        column(Sales_Header___Document_Date__Control1000000294; "Sales Header"."Document Date")
                        {
                        }
                        column(Sales_Header___No___Control1000000296; "Sales Header"."No.")
                        {
                        }
                        column(Sales_Header___Bill_to_Customer_No___Control1000000300; "Sales Header"."Bill-to Customer No.")
                        {
                        }
                        column(Sales_Header___External_Document_No___Control1000000303; "Sales Header"."External Document No.")
                        {
                        }
                        column(TxtVATRegNo_g_Control1000000304; TxtVATRegNo_g)
                        {
                        }
                        column(RecPaymentTerms_g_Description_Control1000000307; RecPaymentTerms_g.Description)
                        {
                        }
                        column(TextPage_______FORMAT_CurrReport_PAGENO__Control1000000316; TextPage + ' 1')
                        {
                        }
                        column(Text50000_Control1000000062; Text50000)
                        {
                        }
                        column(Sales_Header___Promised_Delivery_Date__Control1000000017; "Sales Header"."Promised Delivery Date")
                        {
                        }
                        column(Sales_Line__Sales_Line___No__; "Sales Line"."No.")
                        {
                        }
                        column(Sales_Line__Sales_Line__Description; "Sales Line".Description)
                        {
                        }
                        column(Sales_Line__Unit_of_Measure_; "Unit of Measure")
                        {
                        }
                        column(Sales_Line_Quantity; Quantity)
                        {
                        }
                        column(Sales_Line__Unit_Price_; "Unit Price")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 2;
                            DecimalPlaces = 2 : 2;
                        }
                        column(Sales_Line__Line_Amount_; "Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Sales_Line__Cross_Reference_No__; "Item Reference No.")
                        {
                        }
                        column(Sales_Line__Sales_Line___Line_Discount___; "Sales Line"."Line Discount %")
                        {
                            DecimalPlaces = 1 : 2;
                        }
                        column(SalesLineType; LineTypeInt)
                        {
                        }
                        column(Sales_Invoice_Line__Line_No__; "Line No.")
                        {
                        }
                        column(Sales_Line__Transport_line_; "Transport line")
                        {
                        }
                        column(Sales_Line__Sales_Line___Description_2_; "Sales Line"."Description 2")
                        {
                        }
                        column(Sales_Line__Sales_Line__Description_Control1000000040; "Sales Line".Description)
                        {
                        }
                        column(TxtNumIntrastat_g; TxtNumIntrastat_g)
                        {
                        }
                        column(Sales_Line__Sales_Line__Description_Control1000000084; "Sales Line".Description)
                        {
                        }
                        column(Sales_Line__Line_Amount__Control1000000085; "Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Sales_Line__Sales_Line___Line_Discount____Control1000000232; "Sales Line"."Line Discount %")
                        {
                            DecimalPlaces = 1 : 2;
                        }
                        column(Sales_Line__Sales_Line___Description_2__Control1000000218; "Sales Line"."Description 2")
                        {
                        }
                        column(RecCompanyInformation_g__Home_Page_; '')
                        {
                        }
                        column("PRODUZENT_VON_GEKOCHTEM_GEFLÜGELFLEISCHCaption_Control1000000021"; PRODUZENT_VON_GEKOCHTEM_GEFLÜGELFLEISCHCaption_Control1000000021Lbl)
                        {
                        }
                        column(Bank___Caption_Control1000000033; Bank___Caption_Control1000000033Lbl)
                        {
                        }
                        column(TEL___Caption_Control1000000110; TEL___Caption_Control1000000110Lbl)
                        {
                        }
                        column(FAX__Caption_Control1000000113; FAX__Caption_Control1000000113Lbl)
                        {
                        }
                        column(E_mail__Caption_Control1000000116; E_mail__Caption_Control1000000116Lbl)
                        {
                        }
                        column(MwSt_Caption_Control1000000117; MwSt_Caption_Control1000000117Lbl)
                        {
                        }
                        column(GesamtzahlCaption_Control1000000032; GesamtzahlCaption_Control1000000032Lbl)
                        {
                        }
                        column(Preis_je_EinheitCaption_Control1000000047; Preis_je_EinheitCaption_Control1000000047Lbl)
                        {
                        }
                        column("Quantität___GewichtCaption_Control1000000049"; Quantität___GewichtCaption_Control1000000049Lbl)
                        {
                        }
                        column(EinheitCaption_Control1000000053; EinheitCaption_Control1000000053Lbl)
                        {
                        }
                        column(BeschreibungCaption_Control1000000064; BeschreibungCaption_Control1000000064Lbl)
                        {
                        }
                        column(KundenreferenzCaption_Control1000000066; KundenreferenzCaption_Control1000000066Lbl)
                        {
                        }
                        column(Ref_Caption_Control1000000076; Ref_Caption_Control1000000076Lbl)
                        {
                        }
                        column(DatumCaption_Control1000000291; DatumCaption_Control1000000291Lbl)
                        {
                        }
                        column(ErinnernCaption_Control1000000292; ErinnernCaption_Control1000000292Lbl)
                        {
                        }
                        column(Dokumentennr_Caption_Control1000000297; Dokumentennr_Caption_Control1000000297Lbl)
                        {
                        }
                        column(KundencodeCaption_Control1000000299; KundencodeCaption_Control1000000299Lbl)
                        {
                        }
                        column(Sales_Header___External_Document_No___Control1000000303Caption; "Sales Header".FieldCaption("External Document No."))
                        {
                        }
                        column(MwSt__nrCaption_Control1000000309; MwSt__nrCaption_Control1000000309Lbl)
                        {
                        }
                        column(Zahlungsbedingungen__Caption_Control1000000312; Zahlungsbedingungen__Caption_Control1000000312Lbl)
                        {
                        }
                        column("Geschätztes_DatumCaption_Control1000000001"; Geschätztes_DatumCaption_Control1000000001Lbl)
                        {
                        }
                        column(Rab___Caption_Control1000000222; Rab___Caption_Control1000000222Lbl)
                        {
                        }
                        column(Intrastat_Nr___Caption; Intrastat_Nr___CaptionLbl)
                        {
                        }
                        column(DataItem1000000313; Der_Kunde_akzeptie000Lbl)
                        {
                        }
                        column(Sales_Line_Document_Type; "Document Type")
                        {
                        }
                        column(Sales_Line_Document_No_; "Document No.")
                        {
                        }
                        dataitem("Reservation Entry"; "Reservation Entry")
                        {
                            DataItemLink = "Source ID" = FIELD("Document No."), "Source Ref. No." = FIELD("Line No.");
                            DataItemTableView = WHERE("Entry No." = CONST(999));
                            column(Reserv_Lot; "Reservation Entry"."Lot No.")
                            {
                            }
                            column(Reserv_Qty; "Reservation Entry"."Quantity (Base)")
                            {
                            }
                            column(Reserv_DLC; "Reservation Entry"."Warranty Date")
                            {
                            }
                            column(Reserv_TxtLot; TxtLot)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin

                                TxtLot := StrSubstNo(LotTxt, "Reservation Entry"."Lot No.", "Reservation Entry"."Warranty Date");
                            end;

                            trigger OnPreDataItem()
                            begin
                                TxtLot := '';
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin


                            TxtNumIntrastat_g := '';
                            if "Sales Line".Type = "Sales Line".Type::Item then begin
                                if RecItem_g.Get("Sales Line"."No.") then begin
                                    if RecCountry_g.IsEUCountry(RecCountry_g.Code) then
                                        TxtNumIntrastat_g := StrSubstNo(Intrastat_Nr_CaptionLbl, RecItem_g."Tariff No.")
                                    else
                                        if StrPos(RecItem_g."No.", '2-IQF') > 0 then
                                            TxtNumIntrastat_g := StrSubstNo(Intrastat_NotEU, RecItem_g."Tariff No.", RecItem_g."Tariff No." + '90', 'ES')
                                        else
                                            TxtNumIntrastat_g := StrSubstNo(Intrastat_NotEU, RecItem_g."Tariff No.", RecItem_g."Tariff No." + '90', 'BE');
                                end;

                            end;


                            if ("Sales Line".Type <> "Sales Line".Type::" ") and ("Sales Line"."Transport line" = false) then
                                IntNombreLignesDéjàImprimées_g += 1;
                            if ("Sales Line".Type = "Sales Line".Type::" ") then
                                IntNombreLignesDéjàImprimées_g += 1;
                            if ("Sales Line".Type <> "Sales Line".Type::" ") and ("Sales Line"."Transport line" = false) and
                                ("Sales Line"."Description 2" <> '') then
                                IntNombreLignesDéjàImprimées_g += 1;
                            if TxtNumIntrastat_g <> '' then
                                IntNombreLignesDéjàImprimées_g += 1;
                            if ("Sales Line".Type = "Sales Line".Type::Resource) and ("Sales Line"."Transport line" = true) then
                                IntNombreLignesDéjàImprimées_g += 1;
                            if ("Sales Line".Type = "Sales Line".Type::Resource) and ("Sales Line"."Transport line" = true) and
                                ("Sales Line"."Description 2" <> '') then
                                IntNombreLignesDéjàImprimées_g += 1;


                            LineTypeInt := Type.AsInteger();
                        end;
                    }
                    dataitem(EmptyLines; "Integer")
                    {
                        DataItemTableView = SORTING(Number) ORDER(Ascending);
                        column(EmpyLines_Number; Number)
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            //-- Détermine le nombre de ligne vide qu'il reste à imprimer, en fonction du nombre max de ligne imprimable --
                            //MESSAGE('%1   %2',IntNombreLignesDéjàImprimées_g,IntNombreLignesDernièrePage_g);

                            while IntNombreLignesDéjàImprimées_g >= IntNombreLignesDernièrePage_g do
                                IntNombreLignesDéjàImprimées_g := IntNombreLignesDéjàImprimées_g - IntNombreLignesDernièrePage_g;
                            // 7 lignes pour le total
                            if (IntNombreLignesDernièrePage_g - IntNombreLignesDéjàImprimées_g - 1) > 7 then
                                EmptyLines.SetRange(Number, 1, (IntNombreLignesDernièrePage_g - IntNombreLignesDéjàImprimées_g - 1 - 7))
                            else
                                EmptyLines.SetRange(Number, 1, (IntNombreLignesDernièrePage_g - IntNombreLignesDéjàImprimées_g - 1 +
                                IntNombreLignesDernièrePage_g - 7));
                            //MESSAGE('%1   %2',IntNombreLignesDéjàImprimées_g,IntNombreLignesDernièrePage_g);

                        end;
                    }
                    dataitem(Footer; "Integer")
                    {
                        DataItemTableView = SORTING(Number) ORDER(Ascending);
                        MaxIteration = 1;
                        column(RecCompanyInformation_g__Home_Page__Control1000000318; '')
                        {
                        }
                        column(CodeCurrency_g_________FORMAT_DecTotalAmountInclVAT_g__0____Precision_2_2__Standard_Format_0___; CodeCurrency_g + ' ' + Format(DecTotalAmountInclVAT_g, 0, '<Precision,2:2><Standard Format,0>'))
                        {
                        }
                        column(Sales_Header___Due_Date_; "Sales Header"."Due Date")
                        {
                        }
                        column(DecVATBaseAmount_g; DecVATBaseAmount_g)
                        {
                            DecimalPlaces = 2 : 2;
                        }
                        column(RecVATAmountLine_g_4___VAT___; RecVATAmountLine_g[4]."VAT %")
                        {
                            DecimalPlaces = 0 : 2;
                        }
                        column(RecVATAmountLine_g_3___VAT___; RecVATAmountLine_g[3]."VAT %")
                        {
                            DecimalPlaces = 0 : 2;
                        }
                        column(DecVATAmount_g; DecVATAmount_g)
                        {
                            DecimalPlaces = 2 : 2;
                        }
                        column(RecVATAmountLine_g_4___VAT_Base_; RecVATAmountLine_g[4]."VAT Base")
                        {
                        }
                        column(RecVATAmountLine_g_3___VAT_Base_; RecVATAmountLine_g[3]."VAT Base")
                        {
                        }
                        column(RecVATAmountLine_g_2___VAT_Base_; RecVATAmountLine_g[2]."VAT Base")
                        {
                        }
                        column(RecVATAmountLine_g_2___VAT___; RecVATAmountLine_g[2]."VAT %")
                        {
                            DecimalPlaces = 0 : 2;
                        }
                        column(DecTotalAmountInclVAT_g; DecTotalAmountInclVAT_g)
                        {
                            DecimalPlaces = 2 : 2;
                        }
                        column(RecVATAmountLine_g_4___VAT_Amount_; RecVATAmountLine_g[4]."VAT Amount")
                        {
                        }
                        column(RecVATAmountLine_g_3___VAT_Amount_; RecVATAmountLine_g[3]."VAT Amount")
                        {
                        }
                        column(RecVATAmountLine_g_2___VAT_Amount_; RecVATAmountLine_g[2]."VAT Amount")
                        {
                        }
                        column(RecVATAmountLine_g_1___VAT___; RecVATAmountLine_g[1]."VAT %")
                        {
                            DecimalPlaces = 0 : 2;
                        }
                        column(RecVATAmountLine_g_1___VAT_Base_; RecVATAmountLine_g[1]."VAT Base")
                        {
                        }
                        column(RecVATAmountLine_g_1___VAT_Amount_; RecVATAmountLine_g[1]."VAT Amount")
                        {
                        }
                        column(DataItem1000000314; Der_Kunde_akzeptie000Lbl)
                        {
                        }
                        column(Gesamt_zu_zahlenCaption; Gesamt_zu_zahlenCaptionLbl)
                        {
                        }
                        column("FälligkeitsterminCaption"; FälligkeitsterminCaptionLbl)
                        {
                        }
                        column(BesteuerungsgrundlageCaption; BesteuerungsgrundlageCaptionLbl)
                        {
                        }
                        column(MwStCaption; MwStCaptionLbl)
                        {
                        }
                        column(GesamtzahlCaption_Control1000000195; GesamtzahlCaption_Control1000000195Lbl)
                        {
                        }
                        column(MwStCaption_Control1000000201; MwStCaption_Control1000000201Lbl)
                        {
                        }
                        column(BasisCaption; BasisCaptionLbl)
                        {
                        }
                        column(Footer_Number; Number)
                        {
                        }
                    }
                }

                trigger OnAfterGetRecord()
                begin

                end;

                trigger OnPostDataItem()
                var
                    CUSalesCountPrinted_l: Codeunit "Sales-Printed";
                begin
                    if not CurrReport.Preview then
                        CUSalesCountPrinted_l.Run("Sales Header");
                end;

                trigger OnPreDataItem()
                begin
                    //-- Détermine le nombre de copie --
                    IntNombreBoucles_g := Abs(IntNombreCopies_g) + 1;
                    if IntNombreBoucles_g <= 0 then begin
                        IntNombreBoucles_g := 1;
                    end;

                    CopyLoop.SetRange(Number, 1, IntNombreBoucles_g);


                    OutputNo := 1;
                    IntNombreLignesDéjàImprimées_g := 0;

                end;
            }

            trigger OnAfterGetRecord()
            var
                cuLanguage: codeunit Language;
                CUFormatAddress_l: Codeunit "Format Address";
                CUAbsysTools_l: Codeunit "Absys - tools PJ";
                RecSalesPerson_l: Record "Salesperson/Purchaser";
            begin


                //>> ABC(OLL) - 24/07/2017
                if ("Sales Header".Status = "Sales Header".Status::Open) then
                    Error(TextErrorStatus, "Sales Header"."No.");
                //<<

                // -- INIT --
                Clear(TxtVATRegNo_g);
                Clear(TxtBillToAddress_g);
                Clear(TxtShipToAddress_g);

                //-- Information Banques en fonction du pays de facturation --
                Clear(TxtBankName1_g);
                Clear(TxtBankName2_g);
                Clear(LabBic1_g);
                Clear(TxtBic1_g);
                Clear(LabBic2_g);
                Clear(TxtBic2_g);
                Clear(LabNum1_g);
                Clear(TxtNum1_g);
                Clear(LabNum2_g);
                Clear(TxtNum2_g);

                Clear(TxtBic3_g);
                Clear(TxtNum3_g);
                Clear(TxtBic4_g);
                Clear(TxtNum4_g);

                RecCountry_g.Init;

                if "Sales Header"."Bill-to Country/Region Code" = '' then
                    CodePays_l := RecCompanyInformation_g."Country/Region Code"
                else
                    CodePays_l := "Sales Header"."Bill-to Country/Region Code";



                if RecCountry_g.Get(CodePays_l) then begin
                    if (RecCountry_g."Bank Code 1" = '') and (RecCountry_g."Bank Code 2" = '') then
                        Error(Text50001, RecCountry_g.Name);
                    //-- Banque 1
                    if RecCountry_g."Bank Code 1" <> '' then begin
                        RecBankAccount1_g.Get(RecCountry_g."Bank Code 1");
                        if "Sales Header"."Currency Code" = RecBankAccount1_g."Currency Code" then begin
                            RecBankAccount1_g.CalcFields(Logo);
                            TxtBic1_g := RecBankAccount1_g."SWIFT Code";
                            TxtNum1_g := RecBankAccount1_g.IBAN;
                        end;
                    end;
                    //-- Banque 2
                    if RecCountry_g."Bank Code 2" <> '' then begin
                        RecBankAccount2_g.Get(RecCountry_g."Bank Code 2");
                        if "Sales Header"."Currency Code" = RecBankAccount2_g."Currency Code" then begin
                            RecBankAccount2_g.CalcFields(Logo);
                            TxtBic2_g := RecBankAccount2_g."SWIFT Code";
                            TxtNum2_g := RecBankAccount2_g.IBAN;
                        end;
                    end;
                    //-- Banque 3
                    if RecCountry_g."Bank Code 3" <> '' then begin
                        RecBankAccount3_g.Get(RecCountry_g."Bank Code 3");
                        if "Sales Header"."Currency Code" = RecBankAccount3_g."Currency Code" then begin
                            RecBankAccount3_g.CalcFields(Logo);
                            TxtBic3_g := RecBankAccount3_g."SWIFT Code";
                            TxtNum3_g := RecBankAccount3_g.IBAN;
                        end;
                    end;
                    //-- Banque 4
                    if RecCountry_g."Bank Code 4" <> '' then begin
                        RecBankAccount4_g.Get(RecCountry_g."Bank Code 4");
                        if "Sales Header"."Currency Code" = RecBankAccount4_g."Currency Code" then begin
                            RecBankAccount4_g.CalcFields(Logo);
                            TxtBic4_g := RecBankAccount4_g."SWIFT Code";
                            TxtNum4_g := RecBankAccount4_g.IBAN;
                        end;
                    end;



                end;


                //-- Détermine la langue du document --
                CurrReport.Language := cuLanguage.GetLanguageIdOrDefault("Sales Header"."Language Code");

                //-- Récupération des données TVA dui client --
                RecCustomer_g.Init;
                if RecCustomer_g.Get("Sales Header"."Bill-to Customer No.") then begin
                    TxtVATRegNo_g := RecCustomer_g."VAT Registration No.";
                    if RecCustomer_g."Sending Invoice Address" then begin
                        CUFormatAddress_l.FormatAddr(TxtAddressInvoiceOpt_g, RecCustomer_g."Name Optional Invoice",
                                                                            RecCustomer_g."Name 2 Optional Invoice",
                                                                            '',
                                                                            RecCustomer_g."Address Optional Invoice",
                                                                            RecCustomer_g."Address 2 Optional Invoice",
                                                                            RecCustomer_g."City Optional Invoice",
                                                                            RecCustomer_g."Post Code Optional Invoice",
                                                                            '',
                                                                            RecCustomer_g."Country Code Optional");

                    end;
                end;

                //-- Récupère les adresse Formaté, Dans un Tableaux
                CUFormatAddress_l.SalesHeaderBillTo(TxtBillToAddress_g, "Sales Header");
                CUFormatAddress_l.SalesHeaderShipTo(TxtShipToAddress_g, TxtAddressInvoiceOpt_g, "Sales Header");

                //-- Récupère le type de devise du document
                if "Sales Header"."Currency Code" <> '' then begin
                    CodeCurrency_g := "Sales Header"."Currency Code";
                end else begin
                    CodeCurrency_g := 'EUR';
                end;

                //-- Récupération données "Vendeur" --
                if RecSalesPerson_l.Get("Sales Header"."Salesperson Code") then begin
                    TxtContactPersonName_g := RecSalesPerson_l.Name;
                end else begin
                    TxtContactPersonName_g := '';
                end;

                //-- Pour pouvoir afficher la description du type de payment --
                RecPaymentTerms_g.Init;
                if RecPaymentTerms_g.Get("Sales Header"."Payment Terms Code") then;

                //-- Outils permetant de calculer les totaux, le détail TVA,...
                CUAbsysTools_l.GetSalesOrderVAT("Sales Header",
                  DecVATAmount_g,
                  DecVATBaseAmount_g,
                  DecVATDiscountAmount_g,
                  DecTotalAmountInclVAT_g,
                  RecVATAmountLine_g);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    var
        RecBankAccount_l: Record "Bank Account";
    begin
        //-- Récupération des info Société --
        RecCompanyInformation_g.Get;

        //-- Création de l'image à afficher --
        RecCompanyInformation_g.CalcFields(Picture);

        //-- Nombre maximum de ligne à imprimer --
        //-- Varie en fonction de l'imprimente et de la taille du pied de page --

        IntNombreLignesDernièrePage_g := 33;

    end;

    var
        IntNombreCopies_g: Integer;
        IntNombreBoucles_g: Integer;
        "IntNombreLignesDernièrePage_g": Integer;
        "IntNombreLignesDéjàImprimées_g": Integer;
        RecCompanyInformation_g: Record "Company Information";
        TxtBillToAddress_g: array[8] of Text[200];
        TxtShipToAddress_g: array[8] of Text[200];
        CodeCurrency_g: Code[10];
        RecCustomer_g: Record Customer;
        DecVATAmount_g: Decimal;
        DecVATBaseAmount_g: Decimal;
        DecVATDiscountAmount_g: Decimal;
        DecTotalAmountInclVAT_g: Decimal;
        RecVATAmountLine_g: array[5] of Record "VAT Amount Line" temporary;
        RecPaymentTerms_g: Record "Payment Terms";
        TxtContactPersonName_g: Text[40];
        TextPage: Label 'Page';
        TextPhone: Label 'Phone : ';
        TxtVATRegNo_g: Text[30];
        TextTVAAbsente: Label 'To be communicated';
        RecItem_g: Record Item;
        TxtNumIntrastat_g: Text;
        BoolAddressInvoiceOpt_g: Boolean;
        TxtAddressInvoiceOpt_g: array[8] of Text[200];
        Text50000: Label 'Proforma Invoice';
        "**** BANQUES ****": Integer;
        TxtBankName1_g: Text[60];
        TxtBankName2_g: Text[60];
        LabBic1_g: Text[30];
        TxtBic1_g: Text[30];
        LabBic2_g: Text[30];
        TxtBic2_g: Text[30];
        LabNum1_g: Text[30];
        TxtNum1_g: Text[30];
        LabNum2_g: Text[30];
        TxtNum2_g: Text[30];
        RecCountry_g: Record "Country/Region";
        RecBankAccount_g: Record "Bank Account";
        Text50001: Label 'Vous devez spécifier les banques pour ce pays : %1';
        CodePays_l: Code[10];
        TextErrorStatus: Label 'Order %1 must be released for being printed. (because price control is done on release)';
        OutputNo: Integer;
        LineTypeInt: Integer;
        RecBankAccount1_g: Record "Bank Account";
        RecBankAccount2_g: Record "Bank Account";
        RecBankAccount3_g: Record "Bank Account";
        RecBankAccount4_g: Record "Bank Account";
        TxtBic3_g: Text[30];
        TxtBic4_g: Text[30];
        TxtNum3_g: Text[30];
        TxtNum4_g: Text[30];
        Bank___CaptionLbl: Label 'Banks :';
        TEL___CaptionLbl: Label 'TEL. :';
        FAX__CaptionLbl: Label 'FAX :';
        E_mail__CaptionLbl: Label 'E-mail :';
        MwSt_CaptionLbl: Label 'VAT :';
        "PRODUZENT_VON_GEKOCHTEM_GEFLÜGELFLEISCHCaptionLbl": Label 'MANUFACTURER OF COOKED POULTRY-MEAT';
        DatumCaptionLbl: Label 'Date';
        AbrechnungsadresseCaptionLbl: Label 'Invoicing address';
        LieferungsadresseCaptionLbl: Label 'Delivery address ';
        MwSt__nrCaptionLbl: Label 'VAT no.';
        KundencodeCaptionLbl: Label 'Customer code';
        ErinnernCaptionLbl: Label 'To Remind';
        Dokumentennr_CaptionLbl: Label 'Document No.';
        Zahlungsbedingungen__CaptionLbl: Label 'Payment Terms :';
        GesamtzahlCaptionLbl: Label 'Total';
        Preis_je_EinheitCaptionLbl: Label 'Unit price';
        "Quantität___GewichtCaptionLbl": Label 'Quantity / Weight';
        EinheitCaptionLbl: Label 'Unit';
        BeschreibungCaptionLbl: Label 'Description';
        KundenreferenzCaptionLbl: Label 'Customer Ref.';
        Ref_CaptionLbl: Label 'Ref.';
        "Geschätztes_DatumCaptionLbl": Label 'Date estimated';
        Rab___CaptionLbl: Label 'Disc. %';
        "PRODUZENT_VON_GEKOCHTEM_GEFLÜGELFLEISCHCaption_Control1000000021Lbl": Label 'MANUFACTURER OF COOKED POULTRY-MEAT';
        Bank___Caption_Control1000000033Lbl: Label 'Banks :';
        TEL___Caption_Control1000000110Lbl: Label 'TEL. :';
        FAX__Caption_Control1000000113Lbl: Label 'FAX :';
        E_mail__Caption_Control1000000116Lbl: Label 'E-mail :';
        MwSt_Caption_Control1000000117Lbl: Label 'VAT :';
        GesamtzahlCaption_Control1000000032Lbl: Label 'Total';
        Preis_je_EinheitCaption_Control1000000047Lbl: Label 'Unit price';
        "Quantität___GewichtCaption_Control1000000049Lbl": Label 'Quantity / Weight';
        EinheitCaption_Control1000000053Lbl: Label 'Unit';
        BeschreibungCaption_Control1000000064Lbl: Label 'Description';
        KundenreferenzCaption_Control1000000066Lbl: Label 'Customer Ref.';
        Ref_Caption_Control1000000076Lbl: Label 'Ref.';
        DatumCaption_Control1000000291Lbl: Label 'Date';
        ErinnernCaption_Control1000000292Lbl: Label 'To Remind';
        Dokumentennr_Caption_Control1000000297Lbl: Label 'Document No.';
        KundencodeCaption_Control1000000299Lbl: Label 'Customer code';
        MwSt__nrCaption_Control1000000309Lbl: Label 'VAT no.';
        Zahlungsbedingungen__Caption_Control1000000312Lbl: Label 'Payment Terms :';
        "Geschätztes_DatumCaption_Control1000000001Lbl": Label 'Date estimated';
        Rab___Caption_Control1000000222Lbl: Label 'Disc. %';
        Intrastat_Nr___CaptionLbl: Label 'Intrastat No. :';
        "Der_Kunde_akzeptie000Lbl": Label 'The customer declares to have taken knowledge of the conditions of sale printed with the back and accepts explicitly them.';
        Gesamt_zu_zahlenCaptionLbl: Label 'To be paid';
        "FälligkeitsterminCaptionLbl": Label 'Due date';
        BesteuerungsgrundlageCaptionLbl: Label 'Taxable Amount';
        MwStCaptionLbl: Label 'VAT';
        GesamtzahlCaption_Control1000000195Lbl: Label 'Total';
        MwStCaption_Control1000000201Lbl: Label 'VAT';
        BasisCaptionLbl: Label 'Base';
        Intrastat_NotEU: Label 'Intrastat Nr. %1,   HS Code %2,   Origin  %3';
        Intrastat_Nr_CaptionLbl: Label 'Intrastat Nr. %1';
        LotTxt: Label 'Lot %1   DLC %2';
        TxtLot: Text;
}

