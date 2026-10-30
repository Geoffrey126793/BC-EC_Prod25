report 50009 "Sales - Credit Memo EC"
{
    // //---------------------------------------------------------------------------------------------//
    // // AJouter la clé : VAT %,VAT Identifier,VAT Calculation Type,Tax Group Code,Use Tax,Positive  //
    // //                  Dans la table "VAT Amount Line"
    // //---------------------------------------------------------------------------------------------//
    // 
    // //AB60408.V7 EBE 16/04/08
    //    - modification titre Sales Credit Memo -> Sales Credit Note for caption ENU
    // //AC.CTD.ADA 300512 Ajout afficher logo comme R50000
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/SalesCreditMemoEC.rdlc';

    Caption = 'Sales - Credit Memo';

    dataset
    {
        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
        {
            DataItemTableView = SORTING("No.") ORDER(Ascending);
            RequestFilterFields = "No.";
            column(Sales_Cr_Memo_Header_No_; "No.")
            {
            }
            column(MailBody; Body)
            {
            }
            dataitem("Page Address"; "Integer")
            {
                DataItemTableView = SORTING(Number);
                MaxIteration = 1;
                column(TxtAddressInvoiceOpt_g_1_; TxtAddressInvoiceOpt_g[1])
                {
                }
                column(TxtAddressInvoiceOpt_g_2_; TxtAddressInvoiceOpt_g[2])
                {
                }
                column(TxtAddressInvoiceOpt_g_3_; TxtAddressInvoiceOpt_g[3])
                {
                }
                column(TxtAddressInvoiceOpt_g_4_; TxtAddressInvoiceOpt_g[4])
                {
                }
                column(TxtAddressInvoiceOpt_g_5_; TxtAddressInvoiceOpt_g[5])
                {
                }
                column(TxtAddressInvoiceOpt_g_6_; TxtAddressInvoiceOpt_g[6])
                {
                }
                column(RecCustomer_g__Sending_Invoice_Address_; Format(RecCustomer_g."Sending Invoice Address", 1, 2))
                {
                }
                column(Page_Address_Number; Number)
                {
                }

                trigger OnPostDataItem()
                begin

                end;
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number) ORDER(Ascending);
                column(TxtBankName1_g; TxtBankName1_g)
                {
                }
                column(TxtBic1_g; TxtBic1_g)
                {
                }
                column(TxtNum1_g; TxtNum1_g)
                {
                }
                column(TxtBankName2_g; TxtBankName2_g)
                {
                }
                column(LabBic1_g; LabBic1_g)
                {
                }
                column(LabNum1_g; LabNum1_g)
                {
                }
                column(RecCompanyInformation_g__Fax_No__; RecCompanyInformation_g."Fax No.")
                {
                }
                column(RecCompanyInformation_g__Phone_No__; RecCompanyInformation_g."Phone No.")
                {
                }
                column(DataItem1000000159; RecCompanyInformation_g."Post Code" + ' ' + RecCompanyInformation_g.City + '-' + RecCompanyInformation_g."Country/Region Code")
                {
                }
                column(RecCompanyInformation_g_Address_________RecCompanyInformation_g__Address_2_; RecCompanyInformation_g.Address + ' ' + RecCompanyInformation_g."Address 2")
                {
                }
                column(RecCompanyInformation_g__E_Mail_; RecCompanyInformation_g."E-Mail")
                {
                }
                column(BE__RecCompanyInformation_g__Enterprise_No__; 'BE' + RecCompanyInformation_g."Enterprise No.")
                {
                }
                column(LabBic2_g; LabBic2_g)
                {
                }
                column(TxtBic2_g; TxtBic2_g)
                {
                }
                column(TxtNum2_g; TxtNum2_g)
                {
                }
                column(LabNum2_g; LabNum2_g)
                {
                }
                column(RecCompanyInformation_g__N__Registre_de_Commerce_; RecCompanyInformation_g."Nº Registre de Commerce")
                {
                }
                column(RecCompanyInformation_g_Picture; RecCompanyInformation_g.Picture)
                {
                }
                column(Sales_Cr_Memo_Header___Document_Date_; "Sales Cr.Memo Header"."Document Date")
                {
                }
                column(Sales_Cr_Memo_Header___Bill_to_Customer_No__; "Sales Cr.Memo Header"."Bill-to Customer No.")
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
                column(TxtShipToAddress_g_6_; TxtShipToAddress_g[6])
                {
                }
                column(TxtVATRegNo_g; TxtVATRegNo_g)
                {
                }
                column(Sales_Cr_Memo_Header___No__; "Sales Cr.Memo Header"."No.")
                {
                }
                column(TxtContactPersonName_g; TxtContactPersonName_g)
                {
                }
                column(RecPaymentTerms_g_Description; RecPaymentTerms_g.Description)
                {
                }
                column(TextPage_______FORMAT_CurrReport_PAGENO_; TextPage + ' 1')
                {
                }
                column(STRSUBSTNO_Text50001_CopyText_; StrSubstNo(Text50001, CopyText))
                {
                }
                column(Sales_Cr_Memo_Header___External_Document_No__; "Sales Cr.Memo Header"."External Document No.")
                {
                }
                column(ShowPicture; ShowPicture)
                {
                }
                column(OutputNo; OutputNo)
                {
                }
                column(Bank___Caption; Bank___CaptionLbl)
                {
                }
                column("PRODUZENT_VON_GEKOCHTEM_GEFLÜGELFLEISCHCaption"; PRODUZENT_VON_GEKOCHTEM_GEFLÜGELFLEISCHCaptionLbl)
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
                column(MwStCaption; MwStCaptionLbl)
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
                column(AbrechnungskontaktCaption; AbrechnungskontaktCaptionLbl)
                {
                }
                column("MUSS_für_das__was_folgt_Caption"; MUSS_für_das__was_folgt_CaptionLbl)
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
                column(Sales_Cr_Memo_Header___External_Document_No__Caption; "Sales Cr.Memo Header".FieldCaption("External Document No."))
                {
                }
                column(CopyLoop_Number; Number)
                {
                }
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) ORDER(Ascending) WHERE(Number = CONST(1));
                    dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
                    {
                        DataItemLink = "Document No." = FIELD("No.");
                        DataItemLinkReference = "Sales Cr.Memo Header";
                        DataItemTableView = SORTING("Document No.", "Line No.") ORDER(Ascending);
                        column(TxtBankName1_g_Control1000000207; TxtBankName1_g)
                        {
                        }
                        column(TxtBic1_g_Control1000000208; TxtBic1_g)
                        {
                        }
                        column(TxtNum1_g_Control1000000209; TxtNum1_g)
                        {
                        }
                        column(TxtBankName2_g_Control1000000210; TxtBankName2_g)
                        {
                        }
                        column(LabBic1_g_Control1000000211; LabBic1_g)
                        {
                        }
                        column(LabNum1_g_Control1000000212; LabNum1_g)
                        {
                        }
                        column(RecCompanyInformation_g__Fax_No___Control1000000214; RecCompanyInformation_g."Fax No.")
                        {
                        }
                        column(RecCompanyInformation_g__Phone_No___Control1000000215; RecCompanyInformation_g."Phone No.")
                        {
                        }
                        column(DataItem1000000216; RecCompanyInformation_g."Post Code" + ' ' + RecCompanyInformation_g.City + '-' + RecCompanyInformation_g."Country/Region Code")
                        {
                        }
                        column(RecCompanyInformation_g_Address_________RecCompanyInformation_g__Address_2__Control1000000217; RecCompanyInformation_g.Address + ' ' + RecCompanyInformation_g."Address 2")
                        {
                        }
                        column(RecCompanyInformation_g__E_Mail__Control1000000218; RecCompanyInformation_g."E-Mail")
                        {
                        }
                        column(BE__RecCompanyInformation_g__Enterprise_No___Control1000000223; 'BE' + RecCompanyInformation_g."Enterprise No.")
                        {
                        }
                        column(LabBic2_g_Control1000000225; LabBic2_g)
                        {
                        }
                        column(TxtBic2_g_Control1000000226; TxtBic2_g)
                        {
                        }
                        column(TxtNum2_g_Control1000000227; TxtNum2_g)
                        {
                        }
                        column(LabNum2_g_Control1000000228; LabNum2_g)
                        {
                        }
                        column(RecCompanyInformation_g__N__Registre_de_Commerce__Control1000000229; RecCompanyInformation_g."Nº Registre de Commerce")
                        {
                        }
                        column(RecCompanyInformation_g_Picture_Control1000000179; RecCompanyInformation_g.Picture)
                        {
                        }
                        column(Sales_Cr_Memo_Header___Document_Date__Control1000000294; "Sales Cr.Memo Header"."Document Date")
                        {
                        }
                        column(Sales_Cr_Memo_Header___No___Control1000000296; "Sales Cr.Memo Header"."No.")
                        {
                        }
                        column(Sales_Cr_Memo_Header___Bill_to_Customer_No___Control1000000300; "Sales Cr.Memo Header"."Bill-to Customer No.")
                        {
                        }
                        column(TxtVATRegNo_g_Control1000000304; TxtVATRegNo_g)
                        {
                        }
                        column(TxtContactPersonName_g_Control1000000306; TxtContactPersonName_g)
                        {
                        }
                        column(RecPaymentTerms_g_Description_Control1000000307; RecPaymentTerms_g.Description)
                        {
                        }
                        column(TextPage_______FORMAT_CurrReport_PAGENO__Control1000000316; TextPage + ' 1')
                        {
                        }
                        column(STRSUBSTNO_Text50001_CopyText__Control1000000329; StrSubstNo(Text50001, CopyText))
                        {
                        }
                        column(STRSUBSTNO_Text50001_CopyText__Control1000000121; StrSubstNo(Text50001, CopyText))
                        {
                        }
                        column(Sales_Cr_Memo_Header___External_Document_No___Control1000000124; "Sales Cr.Memo Header"."External Document No.")
                        {
                        }
                        column(Sales_Cr_Memo_Line__Sales_Cr_Memo_Line___No__; "Sales Cr.Memo Line"."No.")
                        {
                        }
                        column(Sales_Cr_Memo_Line__Sales_Cr_Memo_Line__Description; "Sales Cr.Memo Line".Description)
                        {
                        }
                        column(Sales_Cr_Memo_Line__Unit_of_Measure_; "Unit of Measure")
                        {
                        }
                        column(Sales_Cr_Memo_Line_Quantity; Quantity)
                        {
                        }
                        column(Sales_Cr_Memo_Line__Unit_Price_; "Unit Price")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Line".GetCurrencyCode;
                            AutoFormatType = 1;
                            DecimalPlaces = 2 : 2;
                        }
                        column(Sales_Cr_Memo_Line__Line_Amount_; "Line Amount")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(Sales_Invoice_Line__Line_No__; "Line No.")
                        {
                        }
                        column(SalesLineType; LineTypeInt)
                        {
                        }
                        column(Sales_Cr_Memo_Line__Sales_Cr_Memo_Line___Description_2_; "Sales Cr.Memo Line"."Description 2")
                        {
                        }
                        column(Sales_Cr_Memo_Line__Sales_Cr_Memo_Line__Description_Control1000000040; "Sales Cr.Memo Line".Description)
                        {
                        }
                        column(TxtNumIntrastat_g; TxtNumIntrastat_g)
                        {
                        }
                        column(RecCompanyInformation_g__Home_Page_; '')
                        {
                        }
                        column(Bank___Caption_Control1000000205; Bank___Caption_Control1000000205Lbl)
                        {
                        }
                        column("PRODUZENT_VON_GEKOCHTEM_GEFLÜGELFLEISCHCaption_Control1000000206"; PRODUZENT_VON_GEKOCHTEM_GEFLÜGELFLEISCHCaption_Control1000000206Lbl)
                        {
                        }
                        column(TEL___Caption_Control1000000219; TEL___Caption_Control1000000219Lbl)
                        {
                        }
                        column(FAX__Caption_Control1000000220; FAX__Caption_Control1000000220Lbl)
                        {
                        }
                        column(E_mail__Caption_Control1000000221; E_mail__Caption_Control1000000221Lbl)
                        {
                        }
                        column(MwStCaption_Control1000000224; MwStCaption_Control1000000224Lbl)
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
                        column("MUSS_für_das__was_folgt_Caption_Control1000000160"; MUSS_für_das__was_folgt_Caption_Control1000000160Lbl)
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
                        column(VAT_no_Caption; VAT_no_CaptionLbl)
                        {
                        }
                        column(AbrechnungskontaktCaption_Control1000000311; AbrechnungskontaktCaption_Control1000000311Lbl)
                        {
                        }
                        column(Zahlungsbedingungen__Caption_Control1000000312; Zahlungsbedingungen__Caption_Control1000000312Lbl)
                        {
                        }
                        column(Sales_Cr_Memo_Header___External_Document_No___Control1000000124Caption; "Sales Cr.Memo Header".FieldCaption("External Document No."))
                        {
                        }
                        column(Intrastat_Nr_Caption; Intrastat_Nr_CaptionLbl)
                        {
                        }
                        column(DataItem1000000313; Der_Kunde_akzeptiert_Lbl)
                        {
                        }
                        column(Sales_Cr_Memo_Line_Document_No_; "Document No.")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            LineTypeInt := "Sales Cr.Memo Line".Type.AsInteger();
                            TxtNumIntrastat_g := '';
                            if "Sales Cr.Memo Line".Type = "Sales Cr.Memo Line".Type::Item then begin
                                if RecItem_g.Get("Sales Cr.Memo Line"."No.") then
                                    TxtNumIntrastat_g := RecItem_g."Tariff No.";
                            end;

                            if ("Sales Cr.Memo Line".Type <> "Sales Cr.Memo Line".Type::" ") then
                                IntNombreLignesDéjàImprimées_g += 1;
                            if ("Sales Cr.Memo Line".Type = "Sales Cr.Memo Line".Type::" ") then
                                IntNombreLignesDéjàImprimées_g += 1;
                            if ("Sales Cr.Memo Line".Type <> "Sales Cr.Memo Line".Type::" ") and
                                ("Sales Cr.Memo Line"."Description 2" <> '') then
                                IntNombreLignesDéjàImprimées_g += 1;
                            if ("Sales Cr.Memo Line".Type = "Sales Cr.Memo Line".Type::Resource) then
                                IntNombreLignesDéjàImprimées_g += 1;
                            if ("Sales Cr.Memo Line".Type = "Sales Cr.Memo Line".Type::Resource) and
                                ("Sales Cr.Memo Line"."Description 2" <> '') then
                                IntNombreLignesDéjàImprimées_g += 1;

                        end;
                    }
                    dataitem(Info; "Integer")
                    {
                        DataItemTableView = SORTING(Number) ORDER(Ascending);
                        MaxIteration = 1;
                        column(Text50007; Text50007)
                        {
                        }
                        column(Text50006; Text50006)
                        {
                        }
                        column(TxtCommentaireVet_g; TxtCommentaireVet_g)
                        {
                        }
                        column(Info_Number; Number)
                        {
                        }
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
                        column(DecVATBaseAmount_g; DecVATBaseAmount_g)
                        {
                            DecimalPlaces = 2 : 2;
                        }
                        column(DecTotalAmountInclVAT_g; DecTotalAmountInclVAT_g)
                        {
                            DecimalPlaces = 2 : 2;
                        }
                        column(DecVATAmount_g; DecVATAmount_g)
                        {
                            DecimalPlaces = 2 : 2;
                        }
                        column(CodeCurrency_g_________FORMAT_DecTotalAmountInclVAT_g__0____Precision_2_2__Standard_Format_0___; CodeCurrency_g + ' ' + Format(DecTotalAmountInclVAT_g, 0, '<Precision,2:2><Standard Format,0>'))
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
                        column(RecVATAmountLine_g_4___VAT_Amount_; RecVATAmountLine_g[4]."VAT Amount")
                        {
                        }
                        column(RecVATAmountLine_g_4___VAT_Base_; RecVATAmountLine_g[4]."VAT Base")
                        {
                        }
                        column(RecVATAmountLine_g_3___VAT_Amount_; RecVATAmountLine_g[3]."VAT Amount")
                        {
                        }
                        column(RecVATAmountLine_g_3___VAT_Base_; RecVATAmountLine_g[3]."VAT Base")
                        {
                        }
                        column(RecVATAmountLine_g_2___VAT_Amount_; RecVATAmountLine_g[2]."VAT Amount")
                        {
                        }
                        column(RecVATAmountLine_g_2___VAT_Base_; RecVATAmountLine_g[2]."VAT Base")
                        {
                        }
                        column(RecVATAmountLine_g_2___VAT___; RecVATAmountLine_g[2]."VAT %")
                        {
                            DecimalPlaces = 0 : 2;
                        }
                        column(RecVATAmountLine_g_3___VAT___; RecVATAmountLine_g[3]."VAT %")
                        {
                            DecimalPlaces = 0 : 2;
                        }
                        column(RecVATAmountLine_g_4___VAT___; RecVATAmountLine_g[4]."VAT %")
                        {
                            DecimalPlaces = 0 : 2;
                        }
                        column(Sales_Cr_Memo_Header___Due_Date_; "Sales Cr.Memo Header"."Due Date")
                        {
                        }
                        column(RecCompanyInformation_g__Home_Page__Control1000000318; '')
                        {
                        }
                        column(MwStCaption_Control1000000001; MwStCaption_Control1000000001Lbl)
                        {
                        }
                        column(BasisCaption; BasisCaptionLbl)
                        {
                        }
                        column(BesteuerungsgrundlageCaption; BesteuerungsgrundlageCaptionLbl)
                        {
                        }
                        column(MwStCaption_Control1000000018; MwStCaption_Control1000000018Lbl)
                        {
                        }
                        column(GesamtzahlCaption_Control1000000019; GesamtzahlCaption_Control1000000019Lbl)
                        {
                        }
                        column(Zu_zahlende_GesamtzahlCaption; Zu_zahlende_GesamtzahlCaptionLbl)
                        {
                        }
                        column("FälligkeitsterminCaption"; FälligkeitsterminCaptionLbl)
                        {
                        }
                        column(DataItem1000000314; Der_Kunde_akzeptie000Lbl)
                        {
                        }
                        column(Footer_Number; Number)
                        {
                        }
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                        CopyText := Text50000;

                        OutputNo += 1;
                        IntNombreLignesDéjàImprimées_g := 0;

                    end;

                end;

                trigger OnPostDataItem()
                var
                    CUSalesCrMemoCountPrinted_l: Codeunit "Sales Cr. Memo-Printed";
                begin
                    if not CurrReport.Preview then
                        CUSalesCrMemoCountPrinted_l.Run("Sales Cr.Memo Header");
                end;

                trigger OnPreDataItem()
                begin
                    //-- Détermine le nombre de copie --
                    //IntNombreBoucles_g := ABS(IntNombreCopies_g) + 1;
                    IntNombreBoucles_g := Abs(IntNombreCopies_g);
                    if IntNombreBoucles_g <= 0 then begin
                        IntNombreBoucles_g := 1;
                    end;
                    CopyText := '';
                    CopyLoop.SetRange(Number, 1, IntNombreBoucles_g);

                    OutputNo := 1;
                    IntNombreLignesDéjàImprimées_g := 0;

                end;
            }

            trigger OnAfterGetRecord()
            var
                CuLanguage: Codeunit Language;
                CUFormatAddress_l: Codeunit "Format Address";
                CUAbsysTools_l: Codeunit "Absys - tools PJ";
                RecSalesPerson_l: Record "Salesperson/Purchaser";
                RecLocation_l: Record Location;
            begin
                getMailBody();


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
                RecCountry_g.Init;

                if "Bill-to Country/Region Code" = '' then
                    CodePays_l := RecCompanyInformation_g."Country/Region Code"
                else
                    CodePays_l := "Bill-to Country/Region Code";

                if RecCountry_g.Get(CodePays_l) then begin
                    if (RecCountry_g."Bank Code 1" = '') and (RecCountry_g."Bank Code 2" = '') then
                        Error(Text60000, RecCountry_g.Name);

                    //-- Banque 1
                    if RecCountry_g."Bank Code 1" <> '' then begin
                        RecBankAccount_g.Get(RecCountry_g."Bank Code 1");
                        TxtBankName1_g := RecBankAccount_g.Name + ' - ' + RecBankAccount_g."SWIFT Code";
                        LabBic1_g := 'BIC :';
                        TxtBic1_g := RecBankAccount_g.IBAN;
                        LabNum1_g := 'N°';
                        TxtNum1_g := RecBankAccount_g."Bank Account No.";
                    end;
                    //-- Banque 2
                    if RecCountry_g."Bank Code 2" <> '' then begin
                        RecBankAccount_g.Get(RecCountry_g."Bank Code 2");
                        TxtBankName2_g := RecBankAccount_g.Name + ' - ' + RecBankAccount_g."SWIFT Code";
                        LabBic2_g := 'BIC :';
                        TxtBic2_g := RecBankAccount_g.IBAN;
                        LabNum2_g := 'N°';
                        TxtNum2_g := RecBankAccount_g."Bank Account No.";
                    end;
                end;

                //-- Détermine la langue du document --
                CurrReport.Language := CuLanguage.GetLanguageIdOrDefault("Sales Cr.Memo Header"."Language Code");

                //-- Récupération des données TVA dui client --
                RecCustomer_g.Init;
                if RecCustomer_g.Get("Sales Cr.Memo Header"."Bill-to Customer No.") then begin
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
                CUFormatAddress_l.SalesCrMemoBillTo(TxtBillToAddress_g, "Sales Cr.Memo Header");
                CUFormatAddress_l.SalesCrMemoShipTo(TxtShipToAddress_g, TxtAddressInvoiceOpt_g, "Sales Cr.Memo Header");

                //-- Récupère le type de devise du document
                if "Sales Cr.Memo Header"."Currency Code" <> '' then begin
                    CodeCurrency_g := "Sales Cr.Memo Header"."Currency Code";
                end else begin
                    CodeCurrency_g := 'EUR';
                end;

                //-- Récupération données "Vendeur" --
                if RecSalesPerson_l.Get("Sales Cr.Memo Header"."Salesperson Code") then begin
                    TxtContactPersonName_g := RecSalesPerson_l.Name;
                end else begin
                    TxtContactPersonName_g := '';
                end;

                //-- Pour pouvoir afficher la description du type de payment --
                RecPaymentTerms_g.Init;
                if RecPaymentTerms_g.Get("Sales Cr.Memo Header"."Payment Terms Code") then;

                //-- Outils permetant de calculer les totaux, le détail TVA,...
                CUAbsysTools_l.GetSalesCrMemoVAT("Sales Cr.Memo Header",
                  DecVATAmount_g,
                  DecVATBaseAmount_g,
                  DecVATDiscountAmount_g,
                  DecTotalAmountInclVAT_g,
                  RecVATAmountLine_g);

                //-- Commentaire Vétérinaire --
                TxtCommentaireVet_g := '';
                if RecLocation_l.Get("Location Code") then begin
                    case RecLocation_l."Veterinian Comment Type" of
                        RecLocation_l."Veterinian Comment Type"::"Type 1 (TEMSE)":
                            begin
                                TxtCommentaireVet_g := Text50008;
                                BoolDisplayInfoVet_g := true;
                            end;
                        RecLocation_l."Veterinian Comment Type"::"Type 2 (WB)":
                            begin
                                TxtCommentaireVet_g := Text50005;
                                BoolDisplayInfoVet_g := true;
                            end;
                        RecLocation_l."Veterinian Comment Type"::" ":
                            begin
                                BoolDisplayInfoVet_g := false;
                            end;
                    end;
                end;
            end;

            trigger OnPreDataItem()
            begin
                // AC BDU 160112D BEGIN
                if ShowPicture then
                    RecCompanyInformation_g.CalcFields(Picture);
                // AC BDU 160112D END
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
                field(ShowPicture; ShowPicture)
                {
                    Caption = 'Afficher logo';
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            ShowPicture := true;
        end;
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

        //-- Init Nombre de copie
        IntNombreCopies_g := 1;



        //-- Création de l'image à afficher --
        //RecCompanyInformation_g.CALCFIELDS(Picture);

        //-- Nombre maximum de ligne à imprimer --
        //-- Varie en fonction de l'imprimente et de la taille du pied de page --

        IntNombreLignesDernièrePage_g := 31;


        //-- Par défaut on affiche les info vétérinaire à la fin --
        BoolDisplayInfoVet_g := false;
        ShowPicture := true;
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
        TxtNumIntrastat_g: Text[30];
        BoolAddressInvoiceOpt_g: Boolean;
        TxtAddressInvoiceOpt_g: array[8] of Text[200];
        BoolDisplayInfoVet_g: Boolean;
        Text50006: Label 'Produits frais sont transportés à une température <= 4°C';
        Text50007: Label 'Produits congelés sont transportés à une température <= -18°C';
        Text50000: Label 'COPY';
        Text50001: Label '%1 Sales Credit Note';
        CopyText: Text[30];
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
        CodePays_l: Code[10];
        Text60000: Label 'Vous devez spécifier les banques pour ce pays : %1';
        "*** Comment Vet ***": Integer;
        TxtCommentaireVet_g: Text[100];
        Text50008: Label 'Control by the veterinarian authorities  FAVV/PCE/OVL/JVT';
        Text50005: Label 'Control by the veterinarian authorities  AFSCA/UPC/B.W. AWE';
        ShowPicture: Boolean;
        OutputNo: Integer;
        LineTypeInt: Integer;
        Bank___CaptionLbl: Label 'Banks :';
        "PRODUZENT_VON_GEKOCHTEM_GEFLÜGELFLEISCHCaptionLbl": Label 'MANUFACTURER OF COOKED POULTRY-MEAT';
        TEL___CaptionLbl: Label 'TEL. :';
        FAX__CaptionLbl: Label 'FAX :';
        E_mail__CaptionLbl: Label 'E-mail :';
        MwStCaptionLbl: Label 'VAT';
        DatumCaptionLbl: Label 'Date';
        AbrechnungsadresseCaptionLbl: Label 'Invoicing address';
        LieferungsadresseCaptionLbl: Label 'Delivery address ';
        MwSt__nrCaptionLbl: Label 'VAT no.';
        KundencodeCaptionLbl: Label 'Customer code';
        ErinnernCaptionLbl: Label 'To Remind';
        Dokumentennr_CaptionLbl: Label 'Document No.';
        AbrechnungskontaktCaptionLbl: Label 'Invoicing contact';
        "MUSS_für_das__was_folgt_CaptionLbl": Label 'MUST, for what follows :';
        Zahlungsbedingungen__CaptionLbl: Label 'Payment Terms :';
        GesamtzahlCaptionLbl: Label 'Total';
        Preis_je_EinheitCaptionLbl: Label 'Unit price';
        "Quantität___GewichtCaptionLbl": Label 'Quantity / Weight';
        EinheitCaptionLbl: Label 'Unit';
        BeschreibungCaptionLbl: Label 'Description';
        KundenreferenzCaptionLbl: Label 'Customer Ref.';
        Ref_CaptionLbl: Label 'Ref.';
        Bank___Caption_Control1000000205Lbl: Label 'Banks :';
        "PRODUZENT_VON_GEKOCHTEM_GEFLÜGELFLEISCHCaption_Control1000000206Lbl": Label 'MANUFACTURER OF COOKED POULTRY-MEAT';
        TEL___Caption_Control1000000219Lbl: Label 'TEL. :';
        FAX__Caption_Control1000000220Lbl: Label 'FAX :';
        E_mail__Caption_Control1000000221Lbl: Label 'E-mail :';
        MwStCaption_Control1000000224Lbl: Label 'VAT';
        GesamtzahlCaption_Control1000000032Lbl: Label 'Total';
        Preis_je_EinheitCaption_Control1000000047Lbl: Label 'Unit price';
        "Quantität___GewichtCaption_Control1000000049Lbl": Label 'Quantity / Weight';
        EinheitCaption_Control1000000053Lbl: Label 'Unit';
        BeschreibungCaption_Control1000000064Lbl: Label 'Description';
        KundenreferenzCaption_Control1000000066Lbl: Label 'Customer Ref.';
        Ref_Caption_Control1000000076Lbl: Label 'Ref.';
        "MUSS_für_das__was_folgt_Caption_Control1000000160Lbl": Label 'MUST, for what follows :';
        DatumCaption_Control1000000291Lbl: Label 'Date';
        ErinnernCaption_Control1000000292Lbl: Label 'To Remind';
        Dokumentennr_Caption_Control1000000297Lbl: Label 'Document No.';
        KundencodeCaption_Control1000000299Lbl: Label 'Customer code';
        VAT_no_CaptionLbl: Label 'VAT no.';
        AbrechnungskontaktCaption_Control1000000311Lbl: Label 'Invoicing contact';
        Zahlungsbedingungen__Caption_Control1000000312Lbl: Label 'Payment Terms :';
        Intrastat_Nr_CaptionLbl: Label 'Intrastat No.';
        "Der_Kunde_akzeptiert_Lbl": Label 'The customer declares to have taken knowledge of the conditions of sale printed with the back and accepts explicitly them.';
        MwStCaption_Control1000000001Lbl: Label 'VAT';
        BasisCaptionLbl: Label 'Base';
        BesteuerungsgrundlageCaptionLbl: Label 'Taxable Amount';
        MwStCaption_Control1000000018Lbl: Label 'VAT';
        GesamtzahlCaption_Control1000000019Lbl: Label 'Total';
        Zu_zahlende_GesamtzahlCaptionLbl: Label 'To be paid';
        "FälligkeitsterminCaptionLbl": Label 'Due date';
        "Der_Kunde_akzeptie000Lbl": Label 'The customer declares to have taken knowledge of the conditions of sale printed with the back and accepts explicitly them.';
        Body: Text;

    local procedure getMailBody()
    var
        CRLF: Text[4];
    begin
        CRLF[1] := 13;

        Body := StrSubstNo(_GetBody("Sales Cr.Memo Header"."Language Code"), "Sales Cr.Memo Header"."No.");



        Body := Body + _GetSignature('SR');
    end;

    [Scope('OnPrem')]
    procedure _GetBody(Langue: Code[10]) bodyTxt: Text[1024]
    var
        CRLF: Text[4];
    begin
        CRLF[1] := 13;

        bodyTxt := '';


        case (Langue) of
            'NL':
                begin
                    bodyTxt := 'Beste,' + CRLF + CRLF;
                    bodyTxt := bodyTxt + 'Gelieve hierbij de faktuur Nr. %1 te vinden.'
                    + CRLF + CRLF;
                    bodyTxt := bodyTxt + 'Wij staan altijd te uwer beschikking voor bijkomende inlichtingen.' + CRLF + CRLF;
                    bodyTxt := bodyTxt + 'Met vriendelijke groeten,' + CRLF;
                end;
            'FR', '':
                begin
                    bodyTxt := 'Bonjour,' + CRLF + CRLF;
                    bodyTxt := bodyTxt + 'Veuillez trouver ci-joint la note de crédit N° %1' + CRLF + CRLF;
                    bodyTxt := bodyTxt + 'Nous restons à votre disposition pour toute information complémentaire.' + CRLF + CRLF;
                    bodyTxt := bodyTxt + 'Cordialement,' + CRLF;
                end;
            else begin
                bodyTxt := 'Dear sir, Dear Madam,' + CRLF + CRLF;
                bodyTxt := bodyTxt + 'Please find attached our credit note Nr. %1.' + CRLF + CRLF;
                bodyTxt := bodyTxt + 'We remain at your disposal for any additional information.' + CRLF + CRLF;
                bodyTxt := bodyTxt + 'Best regards,' + CRLF;
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
        if Emp.FindFirst then begin
            Sign := CRLF + CRLF;
            Sign := Sign + Emp."First Name" + ' ' + Emp."Last Name" + CRLF;
            Sign := Sign + Emp."Job Title" + CRLF;
            Sign := Sign + 'Tel : ' + Emp."Phone No." + CRLF;
            Sign := Sign + 'Fax : ' + Emp."Fax No." + CRLF;
            Sign := Sign + Emp."Company E-Mail" + CRLF;
            Sign := Sign + 'www.europacuisson.com' + CRLF;
        end;
    end;
}

