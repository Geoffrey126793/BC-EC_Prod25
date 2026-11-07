report 50001 "Sales - Order EC"
{
    // //---------------------------------------------------------------------------------------------//
    // // AJouter la clé : VAT %,VAT Identifier,VAT Calculation Type,Tax Group Code,Use Tax,Positive  //
    // //                  Dans la table "VAT Amount Line"
    // //---------------------------------------------------------------------------------------------//
    // 
    // ABC(OLL) - 24/07/2017 - Ajout test commande lancée
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/SalesOrderEC.rdlc';

    Caption = 'Order Confirmation';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") ORDER(Ascending) WHERE("Document Type" = CONST(Order));
            RequestFilterFields = "No.";
            column(Sales_Header_Document_Type; "Document Type")
            {
            }
            column(Sales_Header_No_; "No.")
            {
            }
            column(MailBody; Body)
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
                column(RecCompanyInformation_g__Post_Code_RecCompanyInformation_g_City_RecCompanyInformation_g__Country_Region_Code_; RecCompanyInformation_g."Post Code" + ' ' + RecCompanyInformation_g.City + '-' + RecCompanyInformation_g."Country/Region Code")
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
                column(CopieEncours; CopieEncours)
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
                column("Sales_Header___Date_livraison_prévue_"; "Sales Header"."Date livraison prévue")
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
                column(TxtNum1_g; TxtNum1_g)
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
                column(RecBankAccount1_g_Logo; RecBankAccount1_g.Logo)
                {
                }
                column(RecBankAccount2_g_Logo; RecBankAccount2_g.Logo)
                {
                }
                column(RecBankAccount3_g_Logo; RecBankAccount3_g.Logo)
                {
                }
                column(RecBankAccount4_g_Logo; RecBankAccount4_g.Logo)
                {
                }
                column(TxtBic1_g; TxtBic1_g)
                {
                }
                column(TxtBic2_g; TxtBic2_g)
                {
                }
                column(TxtBic3_g; TxtBic3_g)
                {
                }
                column(TxtBic4_g; TxtBic4_g)
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
                column(MwSt__Caption; MwSt__CaptionLbl)
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
                column("Geschätztes_DatumCaption"; Geschätztes_DatumCaptionLbl)
                {
                }
                column(Ref_Caption; Ref_CaptionLbl)
                {
                }
                column(KundenreferenzCaption; KundenreferenzCaptionLbl)
                {
                }
                column(BeschreibungCaption; BeschreibungCaptionLbl)
                {
                }
                column(EinheitCaption; EinheitCaptionLbl)
                {
                }
                column("Quantität___GewichtCaption"; Quantität___GewichtCaptionLbl)
                {
                }
                column(Preis_je_EinheitCaption; Preis_je_EinheitCaptionLbl)
                {
                }
                column(Rab___Caption; Rab___CaptionLbl)
                {
                }
                column(GesamtzahlCaption; GesamtzahlCaptionLbl)
                {
                }
                column(Planned_delivery_dateCaption; Planned_delivery_dateCaptionLbl)
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
                        column(Sales_Line_Type; Type)
                        {
                        }
                        column(Sales_Line__Sales_Line__Description_Control1000000040; "Sales Line".Description)
                        {
                        }
                        column(Sales_Line__Sales_Line___Description_2_; "Sales Line"."Description 2")
                        {
                        }
                        column(TxtNumIntrastat_g; TxtNumIntrastat_g)
                        {
                        }
                        column(Sales_Line__Sales_Line___Shipment_No__; "Sales Line"."Shipment No.")
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
                        column(Sales_Line__Sales_Line___Line_Discount____Control1000000209; "Sales Line"."Line Discount %")
                        {
                            DecimalPlaces = 1 : 2;
                        }
                        column(Sales_Line__Transport_line_; "Transport line")
                        {
                        }
                        column(Sales_Line__Sales_Line___Description_2__Control1000000178; "Sales Line"."Description 2")
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
                        column(MwSt__Caption_Control1000000117; MwSt__Caption_Control1000000117Lbl)
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
                        column(Ref_Caption_Control1000000032; Ref_Caption_Control1000000032Lbl)
                        {
                        }
                        column(KundenreferenzCaption_Control1000000047; KundenreferenzCaption_Control1000000047Lbl)
                        {
                        }
                        column(BeschreibungCaption_Control1000000049; BeschreibungCaption_Control1000000049Lbl)
                        {
                        }
                        column(EinheitCaption_Control1000000053; EinheitCaption_Control1000000053Lbl)
                        {
                        }
                        column("Quantität___GewichtCaption_Control1000000064"; Quantität___GewichtCaption_Control1000000064Lbl)
                        {
                        }
                        column(Preis_je_EinheitCaption_Control1000000066; Preis_je_EinheitCaption_Control1000000066Lbl)
                        {
                        }
                        column(Rab___Caption_Control1000000076; Rab___Caption_Control1000000076Lbl)
                        {
                        }
                        column(GesamtzahlCaption_Control1000000090; GesamtzahlCaption_Control1000000090Lbl)
                        {
                        }
                        column(N__Intrastat__Caption; N__Intrastat__CaptionLbl)
                        {
                        }
                        column(Sales_Line_Document_Type; "Document Type")
                        {
                        }
                        column(Sales_Line_Document_No_; "Document No.")
                        {
                        }
                        column(Sales_Line_Line_No_; "Line No.")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            TxtNumIntrastat_g := '';
                            if "Sales Line".Type = "Sales Line".Type::Item then begin
                                if RecItem_g.Get("Sales Line"."No.") then
                                    TxtNumIntrastat_g := RecItem_g."Tariff No.";
                            end;


                            // MESSAGE('a -- %1    %2', "Line No.",IntNombreLignesDéjàImprimées_g);
                            if ("Sales Line".Type <> "Sales Line".Type::" ") and ("Sales Line"."Transport line" = false) then
                                IntNombreLignesDéjàImprimées_g += 1;
                            if ("Sales Line".Type = "Sales Line".Type::" ") and ("Sales Line"."Transport line" = false) then
                                IntNombreLignesDéjàImprimées_g += 1;
                            if ("Sales Line".Type <> "Sales Line".Type::" ") and ("Sales Line"."Transport line" = false) and
                                ("Sales Line"."Description 2" <> '') then
                                IntNombreLignesDéjàImprimées_g += 1;
                            if (TxtNumIntrastat_g <> '') and ("Sales Line"."Transport line" = false) then
                                IntNombreLignesDéjàImprimées_g += 1;
                            if ("Sales Line".Type = "Sales Line".Type::Resource) and ("Sales Line"."Transport line" = true) then
                                IntNombreLignesDéjàImprimées_g += 1;
                            if ("Sales Line".Type = "Sales Line".Type::Resource) and ("Sales Line"."Transport line" = true) and
                                ("Sales Line"."Description 2" <> '') then
                                IntNombreLignesDéjàImprimées_g += 1;
                            // MESSAGE('b -- %1    %2', "Line No.",IntNombreLignesDéjàImprimées_g);

                        end;
                    }
                    dataitem(EmptyLines; "Integer")
                    {
                        DataItemTableView = SORTING(Number) ORDER(Ascending);
                        column(EmptyLines_Number; Number)
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            //-- Détermine le nombre de ligne vide qu'il reste à imprimer, en fonction du nombre max de ligne imprimable --

                            // MESSAGE('%1   %2',IntNombreLignesDéjàImprimées_g,IntNombreLignesDernièrePage_g);

                            while IntNombreLignesDéjàImprimées_g >= IntNombreLignesDernièrePage_g do
                                IntNombreLignesDéjàImprimées_g := IntNombreLignesDéjàImprimées_g - IntNombreLignesDernièrePage_g;
                            // 7 lignes pour le total
                            if (IntNombreLignesDernièrePage_g - IntNombreLignesDéjàImprimées_g - 1) > 7 then
                                EmptyLines.SetRange(Number, 1, (IntNombreLignesDernièrePage_g - IntNombreLignesDéjàImprimées_g - 1 - 7))
                            else
                                EmptyLines.SetRange(Number, 1, (IntNombreLignesDernièrePage_g - IntNombreLignesDéjàImprimées_g - 1 +
                                IntNombreLignesDernièrePage_g - 7));
                            // MESSAGE('%1   %2',IntNombreLignesDéjàImprimées_g,IntNombreLignesDernièrePage_g);

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
                        column(DecVATBaseAmount_g; DecVATBaseAmount_g)
                        {
                            DecimalPlaces = 2 : 2;
                        }
                        column(DecVATAmount_g; DecVATAmount_g)
                        {
                            DecimalPlaces = 2 : 2;
                        }
                        column(DecTotalAmountInclVAT_g; DecTotalAmountInclVAT_g)
                        {
                            DecimalPlaces = 2 : 2;
                        }
                        column(Gesamt_zu_zahlenCaption; Gesamt_zu_zahlenCaptionLbl)
                        {
                        }
                        column(BesteuerungsgrundlageCaption; BesteuerungsgrundlageCaptionLbl)
                        {
                        }
                        column(MwStCaption; MwStCaptionLbl)
                        {
                        }
                        column(GesamtzahlCaption_Control1000000189; GesamtzahlCaption_Control1000000189Lbl)
                        {
                        }
                        column(Footer_Number; Number)
                        {
                        }
                    }
                }

                trigger OnAfterGetRecord()
                begin

                    CopieEncours += 1;


                    IntNombreLignesDéjàImprimées_g := 0;
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
                end;
            }

            trigger OnAfterGetRecord()
            var
                RecLanguage_l: Record Language;
                CUFormatAddress_l: Codeunit "Format Address";
                CUAbsysTools_l: Codeunit "Absys - tools PJ";
                RecSalesPerson_l: Record "Salesperson/Purchaser";
                cuLanguage: codeunit Language;
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

                getMailBody();
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(IntNombreCopies_g; IntNombreCopies_g)
                {
                    Caption = 'Nombre de copies';
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
    var
        RecBankAccount_l: Record "Bank Account";
    begin
        //-- Récupération des info Société --
        RecCompanyInformation_g.Get;

        //-- Création de l'image à afficher --
        RecCompanyInformation_g.CalcFields(Picture);

        //-- Nombre maximum de ligne à imprimer --
        //-- Varie en fonction de l'imprimente et de la taille du pied de page --

        IntNombreLignesDernièrePage_g := 37;

        CopieEncours := 0;
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
        TextPhone: Label 'Phone. :';
        TxtVATRegNo_g: Text[30];
        TextTVAAbsente: Label 'To be communicated';
        RecItem_g: Record Item;
        TxtNumIntrastat_g: Text[30];
        BoolAddressInvoiceOpt_g: Boolean;
        TxtAddressInvoiceOpt_g: array[8] of Text[200];
        Text50000: Label 'Order Confirmation';
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
        Text50001: Label 'You must specify the banks for this country: %1';
        CodePays_l: Code[10];
        TextErrorStatus: Label 'Order %1 must be released for being printed. (because price control is done on release)';
        CopieEncours: Integer;
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
        MwSt__CaptionLbl: Label 'VAT :';
        "PRODUZENT_VON_GEKOCHTEM_GEFLÜGELFLEISCHCaptionLbl": Label 'MANUFACTURER OF COOKED POULTRY-MEAT';
        DatumCaptionLbl: Label 'Date';
        AbrechnungsadresseCaptionLbl: Label 'Invoicing address';
        LieferungsadresseCaptionLbl: Label 'Delivery address ';
        MwSt__nrCaptionLbl: Label 'VAT no.';
        KundencodeCaptionLbl: Label 'Customer code';
        ErinnernCaptionLbl: Label 'To Remind';
        Dokumentennr_CaptionLbl: Label 'Document No.';
        Zahlungsbedingungen__CaptionLbl: Label 'Payment Terms :';
        "Geschätztes_DatumCaptionLbl": Label 'Departure estimated date';
        Ref_CaptionLbl: Label 'Ref.';
        KundenreferenzCaptionLbl: Label 'Customer Ref.';
        BeschreibungCaptionLbl: Label 'Description';
        EinheitCaptionLbl: Label 'Unit';
        "Quantität___GewichtCaptionLbl": Label 'Quantity / Weight';
        Preis_je_EinheitCaptionLbl: Label 'Unit price';
        Rab___CaptionLbl: Label 'Disc. %';
        GesamtzahlCaptionLbl: Label 'Total';
        Planned_delivery_dateCaptionLbl: Label 'Planned delivery date';
        "PRODUZENT_VON_GEKOCHTEM_GEFLÜGELFLEISCHCaption_Control1000000021Lbl": Label 'MANUFACTURER OF COOKED POULTRY-MEAT';
        Bank___Caption_Control1000000033Lbl: Label 'Banks :';
        TEL___Caption_Control1000000110Lbl: Label 'TEL. :';
        FAX__Caption_Control1000000113Lbl: Label 'FAX :';
        E_mail__Caption_Control1000000116Lbl: Label 'E-mail :';
        MwSt__Caption_Control1000000117Lbl: Label 'VAT :';
        DatumCaption_Control1000000291Lbl: Label 'Date';
        ErinnernCaption_Control1000000292Lbl: Label 'To Remind';
        Dokumentennr_Caption_Control1000000297Lbl: Label 'Document No.';
        KundencodeCaption_Control1000000299Lbl: Label 'Customer code';
        MwSt__nrCaption_Control1000000309Lbl: Label 'VAT no.';
        Zahlungsbedingungen__Caption_Control1000000312Lbl: Label 'Payment Terms :';
        "Geschätztes_DatumCaption_Control1000000001Lbl": Label 'Departure estimated date';
        Ref_Caption_Control1000000032Lbl: Label 'Ref.';
        KundenreferenzCaption_Control1000000047Lbl: Label 'Customer Ref.';
        BeschreibungCaption_Control1000000049Lbl: Label 'Description';
        EinheitCaption_Control1000000053Lbl: Label 'Unit';
        "Quantität___GewichtCaption_Control1000000064Lbl": Label 'Quantity / Weight';
        Preis_je_EinheitCaption_Control1000000066Lbl: Label 'Unit price';
        Rab___Caption_Control1000000076Lbl: Label 'Disc. %';
        GesamtzahlCaption_Control1000000090Lbl: Label 'Total';
        N__Intrastat__CaptionLbl: Label 'N° Intrastat :';
        Gesamt_zu_zahlenCaptionLbl: Label 'To be paid';
        BesteuerungsgrundlageCaptionLbl: Label 'Taxable Amount';
        MwStCaptionLbl: Label 'VAT';
        GesamtzahlCaption_Control1000000189Lbl: Label 'Total';
        Body: Text;
        TypeBody: Option Factures,"Cmd+Tpt",CmdECTournai,CmdECCongel,Rappel;
        CuSales: Codeunit Integration_Sales;
        SalesResp: Record Employee;

    local procedure getMailBody()
    var
        CRLF: Text[4];
        SalesP: Record "Salesperson/Purchaser";
    begin
        CRLF[1] := 13;
        if "Sales Header"."Confirmation envoyée" then begin
            case "Sales Header"."Language Code" of
                'FR':
                    Body := 'Annule et remplace la/les confirmation(s) précédemment envoyée(s)' + CRLF + CRLF;
                'NL':
                    Body := 'Annuleert en vervangt vorige doorgestuurde orderbevestigingen' + CRLF + CRLF;
                else
                    Body := 'Cancels and replaces the previously sent order confirmations' + CRLF + CRLF;
            end;

        end;

        if "Sales Header"."Shipping Agent Code" = 'ENL' then begin
            if "Sales Header"."Location Code" = 'EC TOURNAI' then
                Body += StrSubstNo(_GetBody(TypeBody::CmdECTournai, "Sales Header"."Language Code"), "Sales Header"."No.",
                 "Sales Header"."Promised Delivery Date");
            if "Sales Header"."Location Code" = 'ECCONGEL' then
                Body += StrSubstNo(_GetBody(TypeBody::CmdECCongel, "Sales Header"."Language Code"), "Sales Header"."No.",
                  "Sales Header"."Promised Delivery Date");
        end
        else begin
            Body += StrSubstNo(_GetBody(TypeBody::"Cmd+Tpt", "Sales Header"."Language Code"), "Sales Header"."No.",
              "Sales Header"."Date livraison prévue");
        end;

        if "Sales Header"."Bill-to Country/Region Code" = 'GB' then begin
            Body += CRLF + CRLF + 'Dear customer, please be aware that all our offers and contracts are based on today''s market conditions and UK being an EU member state.' + CRLF;
            Body += 'In case an eventual Brexit brings any changes, we will have to review our prices and commercial/logistical conditions accordingly.' + CRLF;
            Body += 'Thanks for your understanding.' + CRLF;
            Body += 'Please make sure to notify authorities about your imports via IPAFFS as from the 1st of January 2022.' + CRLF;
            Body += 'More info on https://www.gov.uk/guidance/import-of-products-animals-food-and-feed-system';





        end;

        SalesResp.Get(CuSales.GetReponsableFromSalesH("Sales Header"));
        //SalesP.GET("Sales Header"."Salesperson Code");
        Body := Body + _GetSignature(SalesResp.User);
        /*
        CASE "Sales Header"."Bill-to Country/Region Code" OF
          'BE','NL','LU' : Body := Body + _GetSignature('SJ');
          'FR','RE','GLP' : Body := Body + _GetSignature('MS');
          ELSE Body := Body + _GetSignature('SALESEXPORT');
        END;
        */

    end;

    [Scope('OnPrem')]
    procedure _GetBody(Type: Option Factures,"Cmd+Tpt",CmdECTournai,CmdECCongel,Rappel; Langue: Code[10]) bodyTxt: Text[1024]
    var
        CRLF: Text[4];
    begin
        CRLF[1] := 13;

        bodyTxt := '';

        case (Type) of
            Type::Factures:
                begin
                    case (Langue) of
                        'NL':
                            begin
                                bodyTxt := 'Beste,' + CRLF + CRLF;
                                bodyTxt := bodyTxt + 'Gelieve hierbij de faktuur Nr. %1 te vinden. Deze moet ten laatste op %2 betaald worden.'
                                + CRLF + CRLF;
                                bodyTxt := bodyTxt + 'Wij staan altijd te uwer beschikking voor bijkomende inlichtingen.' + CRLF + CRLF;
                                bodyTxt := bodyTxt + 'Met vriendelijke groeten,' + CRLF;
                            end;
                        'FR', '':
                            begin
                                bodyTxt := 'Bonjour,' + CRLF + CRLF;
                                bodyTxt := bodyTxt + 'Veuillez trouver ci-joint la facture N° %1 à régler pour au plus tard le %2' + CRLF + CRLF;
                                bodyTxt := bodyTxt + 'Nous restons à votre disposition pour toute information complémentaire.' + CRLF + CRLF;
                                bodyTxt := bodyTxt + 'Cordialement,' + CRLF;
                            end;
                        else begin
                            bodyTxt := 'Dear sir, Dear Madam,' + CRLF + CRLF;
                            bodyTxt := bodyTxt + 'Please find attached our invoice Nr. %1 to be paid by %2.' + CRLF + CRLF;
                            bodyTxt := bodyTxt + 'We remain at your disposal for any additional information.' + CRLF + CRLF;
                            bodyTxt := bodyTxt + 'Best regards,' + CRLF;
                        end;
                    end;
                end;
            Type::"Cmd+Tpt":
                begin
                    case (Langue) of
                        'NL':
                            begin
                                bodyTxt := bodyTxt + 'Beste,' + CRLF + CRLF;
                                bodyTxt := bodyTxt + 'Gelieve hierbij uw orderbevestiging Nr. %1 te vinden.';
                                bodyTxt := bodyTxt + ' De levering van uw bestelling is voorzien op %2.' + CRLF + CRLF;
                                bodyTxt := bodyTxt + 'Wij staan altijd te uwer beschikking voor bijkomende inlichtingen.' + CRLF + CRLF;
                                bodyTxt := bodyTxt + 'Met vriendelijke groeten,' + CRLF;

                            end;
                        'FR', '':
                            begin
                                bodyTxt := bodyTxt + 'Bonjour,' + CRLF + CRLF;
                                bodyTxt := bodyTxt + 'Veuillez trouver ci-joint votre confirmation de commande N° %1';
                                bodyTxt := bodyTxt + ' dont la livraison est prévue pour le %2.' + CRLF + CRLF;
                                bodyTxt := bodyTxt + 'Nous restons à votre disposition pour toute information complémentaire.' + CRLF + CRLF;
                                bodyTxt := bodyTxt + 'Cordialement,' + CRLF;

                            end;
                        else begin
                            bodyTxt := bodyTxt + 'Dear sir, Dear Madam,' + CRLF + CRLF;
                            bodyTxt := bodyTxt + 'Please find attached your order confirmation Nr. %1.';
                            bodyTxt := bodyTxt + ' The goods will be delivered on %2.' + CRLF + CRLF;
                            bodyTxt := bodyTxt + 'We remain at your disposal for any additional information.' + CRLF + CRLF;
                            bodyTxt := bodyTxt + 'Best regards,';


                        end;
                    end;
                end;
            Type::CmdECTournai:
                begin
                    case (Langue) of
                        'NL':
                            begin
                                bodyTxt := bodyTxt + 'Beste,' + CRLF + CRLF;
                                bodyTxt := bodyTxt + 'Gelieve hierbij uw orderbevestiging Nr. %1 te vinden.' + CRLF + CRLF;
                                bodyTxt := bodyTxt + 'Uw bestelling kan afgehaald worden op %2, op het volgende adres:' + CRLF + CRLF;
                                bodyTxt := bodyTxt + 'Europa Cuisson' + CRLF;
                                bodyTxt := bodyTxt + 'Rue de la Terre à Briques, 14' + CRLF;
                                bodyTxt := bodyTxt + 'B-7522 Marquain' + CRLF;
                                bodyTxt := bodyTxt + 'Wij staan altijd te uwer beschikking voor bijkomende inlichtingen.' + CRLF + CRLF;
                                bodyTxt := bodyTxt + 'Met vriendelijke groeten,' + CRLF;

                            end;
                        'FR', '':
                            begin
                                bodyTxt := bodyTxt + 'Bonjour,' + CRLF + CRLF;
                                bodyTxt := bodyTxt + 'Veuillez trouver ci-joint votre confirmation de commande N° %1.' + CRLF + CRLF;
                                bodyTxt := bodyTxt + 'Celle-ci sera disponible pour enlèvement le %2, à l''adresse suivante :' + CRLF + CRLF;
                                bodyTxt := bodyTxt + 'Europa Cuisson' + CRLF;
                                bodyTxt := bodyTxt + 'Rue de la Terre à Briques, 14' + CRLF;
                                bodyTxt := bodyTxt + 'B-7522 Marquain' + CRLF + CRLF;
                                bodyTxt := bodyTxt + 'Nous restons à votre disposition pour toute information complémentaire.' + CRLF + CRLF;
                                bodyTxt := bodyTxt + 'Cordialement,' + CRLF;

                            end;
                        else begin
                            bodyTxt := bodyTxt + 'Dear sir, Dear Madam,' + CRLF + CRLF;
                            bodyTxt := bodyTxt + 'Please find attached your order confirmation Nr. %1.' + CRLF + CRLF;
                            bodyTxt := bodyTxt + 'The goods can be collected on %2, at the following address:' + CRLF + CRLF;
                            bodyTxt := bodyTxt + 'Europa Cuisson' + CRLF;
                            bodyTxt := bodyTxt + 'Rue de la Terre à Briques, 14' + CRLF;
                            bodyTxt := bodyTxt + 'B-7522 Marquain' + CRLF + CRLF;
                            bodyTxt := bodyTxt + 'We remain at your disposal for any additional information.' + CRLF + CRLF;
                            bodyTxt := bodyTxt + 'Best regards,' + CRLF;

                        end;
                    end;
                end;
            Type::CmdECCongel:
                begin
                    case (Langue) of
                        'NL':
                            begin
                                bodyTxt := bodyTxt + 'Beste,' + CRLF + CRLF;
                                bodyTxt := bodyTxt + 'Gelieve hierbij uw orderbevestiging Nr. %1 te vinden.' + CRLF + CRLF;
                                bodyTxt := bodyTxt + 'Uw bestelling kan afgehaald worden op %2, op het volgende adres:' + CRLF + CRLF;
                                bodyTxt := bodyTxt + 'Europa Cuisson' + CRLF;
                                bodyTxt := bodyTxt + 'Rue de l''Ancienne Potence, 1' + CRLF;
                                bodyTxt := bodyTxt + 'B-7522 Marquain' + CRLF + CRLF;
                                bodyTxt := bodyTxt + 'Wij staan altijd te uwer beschikking voor bijkomende inlichtingen.' + CRLF + CRLF;
                                bodyTxt := bodyTxt + 'Met vriendelijke groeten,' + CRLF;


                            end;
                        'FR', '':
                            begin
                                bodyTxt := bodyTxt + 'Bonjour,' + CRLF + CRLF;
                                bodyTxt := bodyTxt + 'Veuillez trouver ci-joint votre confirmation de commande N° %1.' + CRLF + CRLF;
                                bodyTxt := bodyTxt + 'Celle-ci sera disponible pour enlèvement le %2, à l''adresse suivante :' + CRLF + CRLF;
                                bodyTxt := bodyTxt + 'Europa Cuisson' + CRLF;
                                bodyTxt := bodyTxt + 'Rue de l''Ancienne Potence, 1' + CRLF;
                                bodyTxt := bodyTxt + 'B-7522 Marquain' + CRLF + CRLF;
                                bodyTxt := bodyTxt + 'Nous restons à votre disposition pour toute information complémentaire.' + CRLF + CRLF;
                                bodyTxt := bodyTxt + 'Cordialement,' + CRLF;

                            end;
                        else begin
                            bodyTxt := bodyTxt + 'Dear sir, Dear Madam,' + CRLF + CRLF;
                            bodyTxt := bodyTxt + 'Please find attached your order confirmation N° %1.' + CRLF + CRLF;
                            bodyTxt := bodyTxt + 'The goods can be collected on %2, at the following address:' + CRLF + CRLF;
                            bodyTxt := bodyTxt + 'Europa Cuisson' + CRLF;
                            bodyTxt := bodyTxt + 'Rue de l''Ancienne Potence, 1' + CRLF;
                            bodyTxt := bodyTxt + 'B-7522 Marquain' + CRLF + CRLF;
                            bodyTxt := bodyTxt + 'We remain at your disposal for any additional information.' + CRLF + CRLF;
                            bodyTxt := bodyTxt + 'Best regards,' + CRLF;

                        end;
                    end;
                end;
            Type::Rappel:
                begin
                    case (Langue) of
                        'NL':
                            begin
                                bodyTxt := bodyTxt + 'Mevrouw, Mijnheer,' + CRLF + CRLF;
                                bodyTxt := bodyTxt + 'Als bijlage vindt U onze maning tot betaling ';
                                bodyTxt := bodyTxt + ' betreffend de facturen waarop wij uw betaling wachten.' + CRLF + CRLF;
                                bodyTxt := bodyTxt + 'Wij danken U alvast voor Uw begrip en blijven,' + CRLF + CRLF;
                                bodyTxt := bodyTxt + 'Hoogachtend, ' + CRLF + CRLF;
                                bodyTxt := bodyTxt + 'Boekhouding afdeling' + CRLF + CRLF;

                            end;
                        'FR', '':
                            begin
                                bodyTxt := bodyTxt + 'Madame, Monsieur,' + CRLF + CRLF;

                                bodyTxt := bodyTxt + 'Nous vous prions de trouver ci-joint un rappel de paiement';
                                bodyTxt := bodyTxt + ' pour les factures dont nous attendons le règlement.' + CRLF + CRLF;
                                bodyTxt := bodyTxt + 'Nous vous remercions d''avance de votre compréhension';
                                bodyTxt := bodyTxt + ' et vous prions de croire en nos sincères salutations.' + CRLF + CRLF;
                                bodyTxt := bodyTxt + 'Service comptabilité' + CRLF + CRLF;


                            end;
                        else begin

                            bodyTxt := bodyTxt + 'Dear Madam, dear Sir,' + CRLF + CRLF;
                            bodyTxt := bodyTxt + 'Please find hereby our payment reminder regarding the invoices';
                            bodyTxt := bodyTxt + ' for which we are waiting for the payment.' + CRLF + CRLF;
                            bodyTxt := bodyTxt + 'We thank you in advance for your understanding and remain,' + CRLF + CRLF;
                            bodyTxt := bodyTxt + 'Truly Yours,  ' + CRLF + CRLF;
                            bodyTxt := bodyTxt + 'Accounting Department ' + CRLF + CRLF;

                        end;
                    end;
                end;


        end;
    end;

    [Scope('OnPrem')]
    procedure _GetSignature(User: Code[20]) Sign: Text[1024]
    var
        CRLF: Text[4];
        Emp: Record Employee;
    begin
        CRLF[1] := 13;
        Emp.Reset;
        Emp.SetRange(User, User);
        if not Emp.FindFirst then
            Error('User %1 non trouvé pour signature', User);


        Sign := CRLF + CRLF;
        Sign := Sign + Emp."First Name" + ' ' + Emp."Last Name" + CRLF;
        Sign := Sign + Emp."Job Title" + CRLF;
        Sign := Sign + 'Tel : ' + Emp."Phone No." + CRLF;
        //Sign := Sign + 'Fax : ' + Emp."Fax No." + CRLF;
        Sign := Sign + Emp."Company E-Mail" + CRLF;
        Sign := Sign + 'www.europacuisson.com' + CRLF;
    end;
}

