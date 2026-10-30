report 50000 "Sales - Invoice EC"
{
    // //--> ABSYS GN 20070406
    //   Correction Saut de page :
    //     - Toutes les propriété KeepwithNext des section est mise à Yes
    //     - Suppression des sections Inutile
    //     - Désactivation du code suivant dans certaines section :
    //         IF IntNombreLignesDernièrePage_g - IntNombreLignesDéjàImprimées_g = 0 THEN BEGIN
    //           CurrReport.SHOWOUTPUT(FALSE);
    //         END ELSE BEGIN
    //         ...
    // 
    // //<-- ABSYS GN 20070406
    // 
    // //---------------------------------------------------------------------------------------------//
    // // AJouter la clé : VAT %,VAT Identifier,VAT Calculation Type,Tax Group Code,Use Tax,Positive  //
    // //                  Dans la table "VAT Amount Line"
    // //---------------------------------------------------------------------------------------------//
    // 
    // // AC BDU 160112D Ajout Var. G. ShowPicture
    //                         Code C/AL OnInitReport & OnPredataitem
    //                         Ctrl.
    // //CTD CEK 26/06/14 Mise en commentaire du Show picture
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/SalesInvoiceEC.rdlc';

    AdditionalSearchTerms = 'Impression factures ventes';
    Caption = 'Invoice';
    Permissions = TableData "Bank Account" = r;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.") ORDER(Ascending);
            RequestFilterFields = "No.";
            column(Sales_Invoice_Header_No_; "No.")
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
                column(Sales_Invoice_Header___Document_Date_; "Sales Invoice Header"."Document Date")
                {
                }
                column(Sales_Invoice_Header___Bill_to_Customer_No__; "Sales Invoice Header"."Bill-to Customer No.")
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
                column(Sales_Invoice_Header___External_Document_No__; "Sales Invoice Header"."External Document No.")
                {
                }
                column(TxtVATRegNo_g; TxtVATRegNo_g)
                {
                }
                column(Sales_Invoice_Header___Order_No__; "Sales Invoice Header"."Order No.")
                {
                }
                column(Sales_Invoice_Header___No__; "Sales Invoice Header"."No.")
                {
                }
                column(RecPaymentTerms_g_Description; RecPaymentTerms_g.Description)
                {
                }
                column(TextPage_______FORMAT_CurrReport_PAGENO_; TextPage + ' ')
                {
                }
                column(STRSUBSTNO_Text50001_CopyText_; StrSubstNo(Text50001, CopyText))
                {
                }
                column(RecCompanyInformation_g_Address_________RecCompanyInformation_g__Address_2_; RecCompanyInformation_g.Address + ' ' + RecCompanyInformation_g."Address 2")
                {
                }
                column(RecCompanyInformation_g__Post_Code__________RecCompanyInformation_g_City; RecCompanyInformation_g."Post Code" + ' ' + RecCompanyInformation_g.City)
                {
                }
                column(RecCompanyInformation_g__Fax_No__; RecCompanyInformation_g."Fax No.")
                {
                }
                column(RecCompanyInformation_g__Phone_No__; RecCompanyInformation_g."Phone No.")
                {
                }
                column(RecCompanyInformation_g__E_Mail_; RecCompanyInformation_g."E-Mail")
                {
                }
                column(TxtBankName1_g; TxtBankName1_g)
                {
                }
                column(LabBic1_g; LabBic1_g)
                {
                }
                column(TxtBankName2_g; TxtBankName2_g)
                {
                }
                column(BE__RecCompanyInformation_g__Enterprise_No__; 'BE' + RecCompanyInformation_g."Enterprise No.")
                {
                }
                column(LabBic2_g; LabBic2_g)
                {
                }
                column(TxtBic1_g; TxtBic1_g)
                {
                }
                column(TxtBic2_g; TxtBic2_g)
                {
                }
                column(RecCompanyInformation_g__N__Registre_de_Commerce_; RecCompanyInformation_g."Nº Registre de Commerce")
                {
                }
                column(TxtCountryCompanyg; TxtCountryCompanyg)
                {
                }
                column(RecCompanyInformation_g_Picture; RecCompanyInformation_g.Picture)
                {
                }
                column(OutputNo; OutputNo)
                {
                }
                column(ShowPicture; ShowPicture)
                {
                }
                column(TxtBic3_g; TxtBic3_g)
                {
                }
                column(LabBic3_g; LabBic3_g)
                {
                }
                column(TxtBankName3_g; TxtBankName3_g)
                {
                }
                column(Com; Com)
                {
                }
                column(TxtBic4_g; TxtBic4_g)
                {
                }
                column(TxtNum1_g; TxtNum1_g)
                {
                }
                column(TxtNum3_g; TxtNum3_g)
                {
                }
                column(TxtNum4_g; TxtNum4_g)
                {
                }
                column(TxtNum2_g; TxtNum2_g)
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
                column(RecBankAccount1_g_Logo_HASVALUE; RecBankAccount1_g.Logo.HasValue)
                {
                }
                column(RecBankAccount3_g_Logo_HASVALUE; RecBankAccount3_g.Logo.HasValue)
                {
                }
                column(RecBankAccount4_g_Logo_HASVALUE; RecBankAccount4_g.Logo.HasValue)
                {
                }
                column(RecBankAccount2_g_Logo_HASVALUE; RecBankAccount2_g.Logo.HasValue)
                {
                }
                column(RecBankAccount5_g_Logo_HASVALUE; RecBankAccount5_g.Logo.HasValue)
                {
                }
                column(RecBankAccount5_g_Logo; RecBankAccount5_g.Logo)
                {
                }
                column(TxtNum5_g; TxtNum5_g)
                {
                }
                column(TxtBic5_g; TxtBic5_g)
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
                column(Sales_Invoice_Header___External_Document_No__Caption; "Sales Invoice Header".FieldCaption("External Document No."))
                {
                }
                column(MwSt__nrCaption; MwSt__nrCaptionLbl)
                {
                }
                column(Unsere_AuftragsnummerCaption; Unsere_AuftragsnummerCaptionLbl)
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
                column(KundenreferenzCaption; KundenreferenzCaptionLbl)
                {
                }
                column(Ref_Caption; Ref_CaptionLbl)
                {
                }
                column(Rab___Caption; Rab___CaptionLbl)
                {
                }
                column(BeschreibungCaption; BeschreibungCaptionLbl)
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
                column(Bank___Caption; Bank___CaptionLbl)
                {
                }
                column(MwStCaption; MwStCaptionLbl)
                {
                }
                column(CopyLoop_Number; Number)
                {
                }
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) ORDER(Ascending) WHERE(Number = CONST(1));
                    dataitem("Sales Invoice Line"; "Sales Invoice Line")
                    {
                        DataItemLink = "Document No." = FIELD("No.");
                        DataItemLinkReference = "Sales Invoice Header";
                        column(Sales_Invoice_Header___Document_Date__Control1000000294; "Sales Invoice Header"."Document Date")
                        {
                        }
                        column(Sales_Invoice_Header___No___Control1000000296; "Sales Invoice Header"."No.")
                        {
                        }
                        column(Sales_Invoice_Header___Bill_to_Customer_No___Control1000000300; "Sales Invoice Header"."Bill-to Customer No.")
                        {
                        }
                        column(Sales_Invoice_Header___External_Document_No___Control1000000303; "Sales Invoice Header"."External Document No.")
                        {
                        }
                        column(TxtVATRegNo_g_Control1000000304; TxtVATRegNo_g)
                        {
                        }
                        column(Sales_Invoice_Header___Order_No___Control1000000305; "Sales Invoice Header"."Order No.")
                        {
                        }
                        column(RecPaymentTerms_g_Description_Control1000000307; RecPaymentTerms_g.Description)
                        {
                        }
                        column(TextPage_______FORMAT_CurrReport_PAGENO__Control1000000316; TextPage + ' ')
                        {
                        }
                        column(STRSUBSTNO_Text50001_CopyText__Control1000000121; StrSubstNo(Text50001, CopyText))
                        {
                        }
                        column(RecCompanyInformation_g_Address_________RecCompanyInformation_g__Address_2__Control1000000245; RecCompanyInformation_g.Address + ' ' + RecCompanyInformation_g."Address 2")
                        {
                        }
                        column(RecCompanyInformation_g__Phone_No___Control1000000243; RecCompanyInformation_g."Phone No.")
                        {
                        }
                        column(RecCompanyInformation_g__Fax_No___Control1000000242; RecCompanyInformation_g."Fax No.")
                        {
                        }
                        column(RecCompanyInformation_g__E_Mail__Control1000000246; RecCompanyInformation_g."E-Mail")
                        {
                        }
                        column(BE__RecCompanyInformation_g__Enterprise_No___Control1000000306; 'BE' + RecCompanyInformation_g."Enterprise No.")
                        {
                        }
                        column(RecCompanyInformation_g__N__Registre_de_Commerce__Control1000000335; RecCompanyInformation_g."Nº Registre de Commerce")
                        {
                        }
                        column(RecCompanyInformation_g__Post_Code__________RecCompanyInformation_g_City_Control1000000074; RecCompanyInformation_g."Post Code" + ' ' + RecCompanyInformation_g.City)
                        {
                        }
                        column(TxtCountryCompanyg_Control1000000089; TxtCountryCompanyg)
                        {
                        }
                        column(RecCompanyInformation_g_Picture_Control1000000090; RecCompanyInformation_g.Picture)
                        {
                        }
                        column(Sales_Invoice_Line__Sales_Invoice_Line___No__; "Sales Invoice Line"."No.")
                        {
                        }
                        column(Sales_Invoice_Line__Sales_Invoice_Line__Description; "Sales Invoice Line".Description)
                        {
                        }
                        column(Sales_Invoice_Line__Unit_of_Measure_; "Unit of Measure Code")
                        {
                        }
                        column(Sales_Invoice_Line_Quantity; Quantity)
                        {
                        }
                        column(Sales_Invoice_Line__Unit_Price_; "Unit Price")
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode;
                            AutoFormatType = 2;
                            DecimalPlaces = 2 : 2;
                        }
                        column(Sales_Invoice_Line__Line_Amount_; "Line Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(Sales_Invoice_Line__Sales_Invoice_Line___Cross_Reference_No__; "Sales Invoice Line"."Item Reference No.")
                        {
                        }
                        column(Sales_Invoice_Line__Sales_Invoice_Line___Line_Discount___; "Sales Invoice Line"."Line Discount %")
                        {
                            DecimalPlaces = 1 : 2;
                        }
                        column(SalesLineType; LineTypeInt)
                        {
                        }
                        column(Sales_Invoice_Line__Line_No__; "Line No.")
                        {
                        }
                        column(TxtTemperature; TxtTemperature)
                        {
                        }
                        column(Sales_Invoice_Line__Sales_Invoice_Line__Description_Control1000000040; "Sales Invoice Line".Description)
                        {
                        }
                        column(Sales_Invoice_Line__Sales_Invoice_Line___Description_2_; "Sales Invoice Line"."Description 2")
                        {
                        }
                        column(TxtNumIntrastat_g; TxtNumIntrastat_g)
                        {
                        }
                        column(Sales_Invoice_Line__Sales_Invoice_Line__Description_Control1000000346; "Sales Invoice Line".Description)
                        {
                        }
                        column(Sales_Invoice_Line__Line_Amount__Control1000000347; "Line Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(Sales_Invoice_Line__Sales_Invoice_Line___Line_Discount____Control1000000212; "Sales Invoice Line"."Line Discount %")
                        {
                            DecimalPlaces = 1 : 2;
                        }
                        column(Sales_Invoice_Line__Transport_line_; "Transport line")
                        {
                        }
                        column(Sales_Invoice_Line__Sales_Invoice_Line___Description_2__Control1000000184; "Sales Invoice Line"."Description 2")
                        {
                        }
                        column(TxtExemptionTVA_g; TxtExemptionTVA_g)
                        {
                        }
                        column(RecCompanyInformation_g__Home_Page_; '')
                        {
                        }
                        column(RecCompanyInformation_g__Home_Page__Control1000000319; '')
                        {
                        }
                        column(TxtExemptionTVA_g_Control1000000390; TxtExemptionTVA_g)
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
                        column(Sales_Invoice_Header___External_Document_No___Control1000000303Caption; "Sales Invoice Header".FieldCaption("External Document No."))
                        {
                        }
                        column(MwSt__nrCaption_Control1000000309; MwSt__nrCaption_Control1000000309Lbl)
                        {
                        }
                        column(Unsere_AuftragsnummerCaption_Control1000000310; Unsere_AuftragsnummerCaption_Control1000000310Lbl)
                        {
                        }
                        column(Zahlungsbedingungen__Caption_Control1000000312; Zahlungsbedingungen__Caption_Control1000000312Lbl)
                        {
                        }
                        column(Rab___Caption_Control1000000165; Rab___Caption_Control1000000165Lbl)
                        {
                        }
                        column("PRODUZENT_VON_GEKOCHTEM_GEFLÜGELFLEISCHCaption_Control1000000235"; PRODUZENT_VON_GEKOCHTEM_GEFLÜGELFLEISCHCaption_Control1000000235Lbl)
                        {
                        }
                        column(TEL___Caption_Control1000000251; TEL___Caption_Control1000000251Lbl)
                        {
                        }
                        column(FAX__Caption_Control1000000252; FAX__Caption_Control1000000252Lbl)
                        {
                        }
                        column(E_mail__Caption_Control1000000253; E_mail__Caption_Control1000000253Lbl)
                        {
                        }
                        column(MwStCaption_Control1000000311; MwStCaption_Control1000000311Lbl)
                        {
                        }
                        column(Bank___Caption_Control1000000234; Bank___Caption_Control1000000234Lbl)
                        {
                        }
                        column(Intrastat_Nr_Caption; Intrastat_Nr_CaptionLbl)
                        {
                        }
                        column(DataItem1000000279; Der_Kunde_akzeptiert_Lbl)
                        {
                        }
                        column(DataItem1000000313; Der_Kunde_akzeptie000Lbl)
                        {
                        }
                        column(Sales_Invoice_Line_Document_No_; "Document No.")
                        {
                        }
                        dataitem("Information Lot"; "Integer")
                        {
                            DataItemTableView = SORTING(Number);
                            column(STRSUBSTNO_Text50009__TempItemLedgerEntry_g__Document_No____TempItemLedgerEntry_g__Document_Date__; StrSubstNo(Text50009, TempItemLedgerEntry_g."Document No.", TempItemLedgerEntry_g."Document Date"))
                            {
                            }
                            column(TxtInfoLot; TxtInfoLot)
                            {
                            }
                            column(STRSUBSTNO_Text50004__TempItemLedgerEntry_g__Lot_No___TempItemLedgerEntry_g__Warranty_Date__; StrSubstNo(Text50004, TempItemLedgerEntry_g."Lot No.", TempItemLedgerEntry_g."Warranty Date"))
                            {
                            }
                            column(TempItemLedgerEntry_g_Quantity; TempItemLedgerEntry_g.Quantity)
                            {
                                DecimalPlaces = 0 : 0;
                            }
                            column(Information_Lot_Number; Number)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if IntNbrLine_g > 0 then begin
                                    if FirstRec then begin
                                        FirstRec := false
                                    end else begin
                                        TempItemLedgerEntry_g.Next;
                                    end;
                                end;
                                TxtInfoLot := StrSubstNo(Text50009, TempItemLedgerEntry_g."Document No.", TempItemLedgerEntry_g."Document Date");
                                IntNombreLignesDéjàImprimées_g += 1;
                            end;

                            trigger OnPreDataItem()
                            begin
                                //-- Information Lot --
                                IntNbrLine_g := TempItemLedgerEntry_g.Count;
                                if IntNbrLine_g > 0 then begin

                                    "Information Lot".SetRange(Number, 1, 1);


                                    TempItemLedgerEntry_g.Find('-');
                                    FirstRec := true;
                                    DisplayShippingInfo := true;
                                end else begin

                                    "Information Lot".SetRange(Number, 0, -1);

                                end;
                                TxtInfoLot := '';
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            //MESSAGE('A %1   %2', "Sales Invoice Line"."No.",IntNombreLignesDéjàImprimées_g);
                            LineTypeInt := "Sales Invoice Line".Type.AsInteger();
                            TxtNumIntrastat_g := '';
                            if "Sales Invoice Line".Type = "Sales Invoice Line".Type::Item then begin
                                if RecItem_g.Get("Sales Invoice Line"."No.") then begin
                                    if RecCountry_g.IsEUCountry(RecCountry_g.Code) then
                                        TxtNumIntrastat_g := StrSubstNo(Intrastat_Nr_CaptionLbl, RecItem_g."Tariff No.")
                                    else
                                        if StrPos(RecItem_g."No.", '2-IQF') > 0 then
                                            TxtNumIntrastat_g := StrSubstNo(Intrastat_NotEU, RecItem_g."Tariff No.", RecItem_g."Tariff No." + '90', 'ES')
                                        else
                                            TxtNumIntrastat_g := StrSubstNo(Intrastat_NotEU, RecItem_g."Tariff No.", RecItem_g."Tariff No." + '90', 'BE');
                                end;

                            end;
                            TempItemLedgerEntry_g.Reset;
                            //-- Information LOT --
                            TempItemLedgerEntry_g.Reset;
                            TempItemLedgerEntry_g.DeleteAll;

                            if (Type = Type::Item) then begin
                                cuSales.CallPostedItemTrackingDocument(TempItemLedgerEntry_g, "Document No.", "Line No.");
                            end;


                            if ("Sales Invoice Line".Type <> "Sales Invoice Line".Type::" ") and ("Sales Invoice Line"."Transport line" = false) then
                                IntNombreLignesDéjàImprimées_g += 1;
                            if ("Sales Invoice Line".Type = "Sales Invoice Line".Type::" ") then
                                IntNombreLignesDéjàImprimées_g += 1;
                            if ("Sales Invoice Line".Type <> "Sales Invoice Line".Type::" ") and ("Sales Invoice Line"."Transport line" = false) and
                                ("Sales Invoice Line"."Description 2" <> '') then
                                IntNombreLignesDéjàImprimées_g += 1;
                            if TxtNumIntrastat_g <> '' then
                                IntNombreLignesDéjàImprimées_g += 1;
                            if ("Sales Invoice Line".Type = "Sales Invoice Line".Type::Resource) and ("Sales Invoice Line"."Transport line" = true) then
                                IntNombreLignesDéjàImprimées_g += 1;
                            if ("Sales Invoice Line".Type = "Sales Invoice Line".Type::Resource) and ("Sales Invoice Line"."Transport line" = true) and
                                ("Sales Invoice Line"."Description 2" <> '') then
                                IntNombreLignesDéjàImprimées_g += 1;

                            //MESSAGE('B %1   %2', "Sales Invoice Line"."No.",IntNombreLignesDéjàImprimées_g);
                        end;
                    }
                    dataitem(Info; "Integer")
                    {
                        DataItemTableView = SORTING(Number) ORDER(Ascending);
                        MaxIteration = 1;
                        column(TxtBankName1_g_Control1000000256; TxtBankName1_g)
                        {
                        }
                        column(TxtBic1_g_Control1000000260; TxtBic1_g)
                        {
                        }
                        column(TxtNum1_g_Control1000000264; TxtNum1_g)
                        {
                        }
                        column(TxtBankName2_g_Control1000000265; TxtBankName2_g)
                        {
                        }
                        column(TxtBic2_g_Control1000000266; TxtBic2_g)
                        {
                        }
                        column(TxtNum2_g_Control1000000267; TxtNum2_g)
                        {
                        }
                        column(STRSUBSTNO_Text50001_CopyText__Control1000000268; StrSubstNo(Text50001, CopyText))
                        {
                        }
                        column(LabBic1_g_Control1000000269; LabBic1_g)
                        {
                        }
                        column(LabNum1_g_Control1000000273; LabNum1_g)
                        {
                        }
                        column(LabBic2_g_Control1000000274; LabBic2_g)
                        {
                        }
                        column(LabNum2_g_Control1000000275; LabNum2_g)
                        {
                        }
                        column(TextPage_______FORMAT_CurrReport_PAGENO__Control1000000276; TextPage + ' 1')
                        {
                        }
                        column(RecCompanyInformation_g_Address_________RecCompanyInformation_g__Address_2__Control1000000278; RecCompanyInformation_g.Address + ' ' + RecCompanyInformation_g."Address 2")
                        {
                        }
                        column(RecCompanyInformation_g__Phone_No___Control1000000280; RecCompanyInformation_g."Phone No.")
                        {
                        }
                        column(RecCompanyInformation_g__Fax_No___Control1000000281; RecCompanyInformation_g."Fax No.")
                        {
                        }
                        column(RecCompanyInformation_g__E_Mail__Control1000000282; RecCompanyInformation_g."E-Mail")
                        {
                        }
                        column(BE__RecCompanyInformation_g__Enterprise_No___Control1000000283; 'BE' + RecCompanyInformation_g."Enterprise No.")
                        {
                        }
                        column(RecCompanyInformation_g__N__Registre_de_Commerce__Control1000000284; RecCompanyInformation_g."Nº Registre de Commerce")
                        {
                        }
                        column(Sales_Invoice_Header___External_Document_No___Control1000000329; "Sales Invoice Header"."External Document No.")
                        {
                        }
                        column(TxtVATRegNo_g_Control1000000341; TxtVATRegNo_g)
                        {
                        }
                        column(RecPaymentTerms_g_Description_Control1000000354; RecPaymentTerms_g.Description)
                        {
                        }
                        column(Sales_Invoice_Header___Document_Date__Control1000000356; "Sales Invoice Header"."Document Date")
                        {
                        }
                        column(Sales_Invoice_Header___No___Control1000000358; "Sales Invoice Header"."No.")
                        {
                        }
                        column(Sales_Invoice_Header___Bill_to_Customer_No___Control1000000360; "Sales Invoice Header"."Bill-to Customer No.")
                        {
                        }
                        column(Sales_Invoice_Header___Order_No___Control1000000362; "Sales Invoice Header"."Order No.")
                        {
                        }
                        column(RecCompanyInformation_g__Post_Code__________RecCompanyInformation_g_City_Control1000000052; RecCompanyInformation_g."Post Code" + ' ' + RecCompanyInformation_g.City)
                        {
                        }
                        column(TxtCountryCompanyg_Control1000000053; TxtCountryCompanyg)
                        {
                        }
                        column(RecCompanyInformation_g_Picture_Control1000000093; RecCompanyInformation_g.Picture)
                        {
                        }
                        column(Text50007; Text50007)
                        {
                        }
                        column(Text50006; Text50006)
                        {
                        }
                        column(TxtCommentaireVet_g; TxtCommentaireVet_g)
                        {
                        }
                        column(RecCompanyInformation_g__Home_Page__Control1000000386; '')
                        {
                        }
                        column(TxtExemptionTVA_g_Control1000000389; TxtExemptionTVA_g)
                        {
                        }
                        column("PRODUZENT_VON_GEKOCHTEM_GEFLÜGELFLEISCHCaption_Control1000000204"; PRODUZENT_VON_GEKOCHTEM_GEFLÜGELFLEISCHCaption_Control1000000204Lbl)
                        {
                        }
                        column(Bank___Caption_Control1000000226; Bank___Caption_Control1000000226Lbl)
                        {
                        }
                        column(ErinnernCaption_Control1000000287; ErinnernCaption_Control1000000287Lbl)
                        {
                        }
                        column(TEL___Caption_Control1000000342; TEL___Caption_Control1000000342Lbl)
                        {
                        }
                        column(FAX__Caption_Control1000000348; FAX__Caption_Control1000000348Lbl)
                        {
                        }
                        column(E_mail__Caption_Control1000000349; E_mail__Caption_Control1000000349Lbl)
                        {
                        }
                        column(MwStCaption_Control1000000350; MwStCaption_Control1000000350Lbl)
                        {
                        }
                        column(DatumCaption_Control1000000351; DatumCaption_Control1000000351Lbl)
                        {
                        }
                        column(Dokumentennr_Caption_Control1000000352; Dokumentennr_Caption_Control1000000352Lbl)
                        {
                        }
                        column(KundencodeCaption_Control1000000353; KundencodeCaption_Control1000000353Lbl)
                        {
                        }
                        column("MUSS_für_das__was_folgt_Caption_Control1000000363"; MUSS_für_das__was_folgt_Caption_Control1000000363Lbl)
                        {
                        }
                        column(Sales_Invoice_Header___External_Document_No___Control1000000329Caption; "Sales Invoice Header".FieldCaption("External Document No."))
                        {
                        }
                        column(MwSt__nrCaption_Control1000000379; MwSt__nrCaption_Control1000000379Lbl)
                        {
                        }
                        column(Unsere_AuftragsnummerCaption_Control1000000380; Unsere_AuftragsnummerCaption_Control1000000380Lbl)
                        {
                        }
                        column(Zahlungsbedingungen__Caption_Control1000000381; Zahlungsbedingungen__Caption_Control1000000381Lbl)
                        {
                        }
                        column(GesamtzahlCaption_Control1000000095; GesamtzahlCaption_Control1000000095Lbl)
                        {
                        }
                        column(Rab___Caption_Control1000000103; Rab___Caption_Control1000000103Lbl)
                        {
                        }
                        column(Preis_je_EinheitCaption_Control1000000109; Preis_je_EinheitCaption_Control1000000109Lbl)
                        {
                        }
                        column("Quantität___GewichtCaption_Control1000000147"; Quantität___GewichtCaption_Control1000000147Lbl)
                        {
                        }
                        column(BeschreibungCaption_Control1000000183; BeschreibungCaption_Control1000000183Lbl)
                        {
                        }
                        column(KundenreferenzCaption_Control1000000218; KundenreferenzCaption_Control1000000218Lbl)
                        {
                        }
                        column(Ref_Caption_Control1000000258; Ref_Caption_Control1000000258Lbl)
                        {
                        }
                        column(DataItem1000000385; Der_Kunde_akzeptie001Lbl)
                        {
                        }
                        column(Info_Number; Number)
                        {
                        }
                    }
                    dataitem(EmptyLines; "Integer")
                    {
                        DataItemTableView = SORTING(Number) ORDER(Ascending);
                        column(EmpyLines_Number; Number)
                        {
                        }
                        column(NbreLignesVides; NbreLignesVides)
                        {
                        }
                        column(DummyText; DummyText)
                        {
                        }

                        trigger OnPreDataItem()
                        var
                            i: Integer;
                        begin
                            //-- Détermine le nombre de ligne vide qu'il reste à imprimer, en fonction du nombre max de ligne imprimable --
                            //MESSAGE('%1   %2',IntNombreLignesDéjàImprimées_g,IntNombreLignesDernièrePage_g);

                            while IntNombreLignesDéjàImprimées_g >= IntNombreLignesDernièrePage_g do
                                IntNombreLignesDéjàImprimées_g := IntNombreLignesDéjàImprimées_g - IntNombreLignesDernièrePage_g;
                            // 7 lignes pour le total
                            if (IntNombreLignesDernièrePage_g - IntNombreLignesDéjàImprimées_g - 1) > 7 then
                                //EmptyLines.SETRANGE(Number, 1, (IntNombreLignesDernièrePage_g - IntNombreLignesDéjàImprimées_g - 1 - 7))
                                NbreLignesVides := (IntNombreLignesDernièrePage_g - IntNombreLignesDéjàImprimées_g - 1 - 7)
                            else
                                //EmptyLines.SETRANGE(Number, 1, (IntNombreLignesDernièrePage_g - IntNombreLignesDéjàImprimées_g - 1 + IntNombreLignesDernièrePage_g - 7));
                                NbreLignesVides := (IntNombreLignesDernièrePage_g - IntNombreLignesDéjàImprimées_g - 1 + IntNombreLignesDernièrePage_g - 7);
                            //MESSAGE('%1   %2',IntNombreLignesDéjàImprimées_g,IntNombreLignesDernièrePage_g);

                            DummyText := '';
                            for i := 1 to NbreLignesVides + 1 do begin
                                DummyText := DummyText + ' |';
                            end;
                            EmptyLines.SetRange(Number, 1, 1);
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
                        column(Sales_Invoice_Header___Due_Date_; "Sales Invoice Header"."Due Date")
                        {
                        }
                        column(RecCompanyInformation_g__Home_Page__Control1000000318; '')
                        {
                        }
                        column(TxtExemptionTVA_g_Control1000000388; TxtExemptionTVA_g)
                        {
                        }
                        column(RecCustomer_g__Invoice_Comment_; RecCustomer_g."Invoice Comment")
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
                        column(DataItem1000000314; Der_Kunde_akzeptie002Lbl)
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

                    end;
                    if TxtTemperature = '' then
                        IntNombreLignesDéjàImprimées_g := 0
                    else
                        IntNombreLignesDéjàImprimées_g := 1;

                end;

                trigger OnPostDataItem()
                var
                    CUSalesInvCountPrinted_l: Codeunit "Sales Inv.-Printed";
                begin
                    if not CurrReport.Preview then
                        CUSalesInvCountPrinted_l.Run("Sales Invoice Header");
                end;

                trigger OnPreDataItem()
                begin
                    //-- Détermine le nombre de copie --
                    //IntNombreBoucles_g := ABS(IntNombreCopies_g) + 1;
                    //GEO 070218
                    //IntNombreBoucles_g := ABS(IntNombreCopies_g) + RecCustomer_g."Invoice Copies" + 1;
                    IntNombreBoucles_g := Abs(IntNombreCopies_g) + RecCustomer_g."Invoice Copies";
                    if IntNombreBoucles_g <= 0 then begin
                        IntNombreBoucles_g := 1;
                    end;
                    CopyText := '';
                    CopyLoop.SetRange(Number, 1, IntNombreBoucles_g);

                    OutputNo := 1;
                    if TxtTemperature = '' then
                        IntNombreLignesDéjàImprimées_g := 0
                    else
                        IntNombreLignesDéjàImprimées_g := 1;

                end;
            }

            trigger OnAfterGetRecord()
            var
                CuLanguage: Codeunit Language;
                CUFormatAddress_l: Codeunit "Format Address";
                CUAbsysTools_l: Codeunit "Absys - tools PJ";
                RecSalesPerson_l: Record "Salesperson/Purchaser";
                RecLocation_l: Record Location;
                CuMail: Codeunit Integration_EMail;
                CuSales: Codeunit Integration_Sales;
            begin
                if (UserSetup.Get(UserId)) and (UserSetup."Resp. Centrer Filter" <> '') then begin
                    FilterGroup(2);
                    SetFilter("Salesperson Code", UserSetup."Resp. Centrer Filter");
                    FilterGroup(0);
                end;

                getMailBody();


                if StatusLogo = StatusLogo::Avec then ShowPicture := true;
                if StatusLogo = StatusLogo::Sans then ShowPicture := false;

                if PrintOnly then begin
                    ShowPicture := false;
                    if (CuMail._GetEMailsRespForEntity(DATABASE::Customer, "Bill-to Customer No.", 'S01') <> '') then
                        CurrReport.Skip;
                end;

                if ShowPicture then
                    RecCompanyInformation_g.CalcFields(Picture);

                // -- INIT --
                Clear(TxtVATRegNo_g);
                Clear(TxtBillToAddress_g);
                Clear(TxtShipToAddress_g);

                //-- Information Banques en fonction du pays de facturation --
                Clear(TxtBankName1_g);
                Clear(TxtBankName2_g);
                Clear(TxtBankName3_g);
                Clear(LabBic1_g);
                Clear(TxtBic1_g);
                Clear(LabBic2_g);
                Clear(TxtBic2_g);
                Clear(LabNum1_g);
                Clear(TxtNum1_g);
                Clear(LabNum2_g);
                Clear(TxtNum2_g);

                Clear(LabBic3_g);
                Clear(TxtBic3_g);
                Clear(LabNum3_g);
                Clear(TxtNum3_g);

                Clear(TxtBic4_g);
                Clear(TxtNum4_g);

                Clear(TxtBic5_g);
                Clear(TxtNum5_g);

                RecCountry_g.Init;

                if "Sales Invoice Header"."Bill-to Country/Region Code" = '' then
                    CodePays_l := RecCompanyInformation_g."Country/Region Code"
                else
                    CodePays_l := "Sales Invoice Header"."Bill-to Country/Region Code";

                if "Sales Invoice Header"."Currency Code" = 'EUR' then
                    "Sales Invoice Header"."Currency Code" := '';


                if RecCountry_g.Get(CodePays_l) then begin
                    if (RecCountry_g."Bank Code 1" = '') and (RecCountry_g."Bank Code 2" = '') then
                        Error(Text60000, RecCountry_g.Name);

                    //-- Banque 1
                    if RecCountry_g."Bank Code 1" <> '' then begin
                        RecBankAccount1_g.Get(RecCountry_g."Bank Code 1");
                        if "Sales Invoice Header"."Currency Code" = RecBankAccount1_g."Currency Code" then begin
                            RecBankAccount1_g.CalcFields(Logo);
                            TxtBic1_g := RecBankAccount1_g."SWIFT Code";
                            TxtNum1_g := RecBankAccount1_g.IBAN;
                        end
                        else begin
                            Clear(RecBankAccount1_g);
                        end;
                    end;
                    //-- Banque 2
                    if RecCountry_g."Bank Code 2" <> '' then begin
                        RecBankAccount2_g.Get(RecCountry_g."Bank Code 2");
                        if "Sales Invoice Header"."Currency Code" = RecBankAccount2_g."Currency Code" then begin
                            RecBankAccount2_g.CalcFields(Logo);
                            TxtBic2_g := RecBankAccount2_g."SWIFT Code";
                            TxtNum2_g := RecBankAccount2_g.IBAN;
                        end;
                    end;
                    //-- Banque 3
                    if RecCountry_g."Bank Code 3" <> '' then begin
                        RecBankAccount3_g.Get(RecCountry_g."Bank Code 3");
                        if "Sales Invoice Header"."Currency Code" = RecBankAccount3_g."Currency Code" then begin
                            RecBankAccount3_g.CalcFields(Logo);
                            TxtBic3_g := RecBankAccount3_g."SWIFT Code";
                            TxtNum3_g := RecBankAccount3_g.IBAN;
                        end;
                    end;
                    //-- Banque 4
                    if RecCountry_g."Bank Code 4" <> '' then begin
                        RecBankAccount4_g.Get(RecCountry_g."Bank Code 4");
                        if "Sales Invoice Header"."Currency Code" = RecBankAccount4_g."Currency Code" then begin
                            RecBankAccount4_g.CalcFields(Logo);
                            TxtBic4_g := RecBankAccount4_g."SWIFT Code";
                            TxtNum4_g := RecBankAccount4_g.IBAN;
                        end;
                    end;
                    //-- Banque 5
                    if RecCountry_g."Bank Code 5" <> '' then begin
                        RecBankAccount5_g.Get(RecCountry_g."Bank Code 5");
                        if "Sales Invoice Header"."Currency Code" = RecBankAccount5_g."Currency Code" then begin
                            RecBankAccount5_g.CalcFields(Logo);
                            TxtBic5_g := RecBankAccount5_g."SWIFT Code";
                            TxtNum5_g := RecBankAccount5_g.IBAN;
                        end;
                    end;

                end;

                //-- Détermine la langue du document --
                CurrReport.Language := CuLanguage.GetLanguageIdOrDefault("Sales Invoice Header"."Language Code");

                //-- Récupération des données TVA dui client --
                RecCustomer_g.Init;
                if RecCustomer_g.Get("Sales Invoice Header"."Bill-to Customer No.") then begin
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



                //-- Récupère le type de devise du document
                if "Sales Invoice Header"."Currency Code" <> '' then begin
                    CodeCurrency_g := "Sales Invoice Header"."Currency Code";
                end else begin
                    CodeCurrency_g := 'EUR';
                end;

                //-- Récupération données "Vendeur" --
                if RecSalesPerson_l.Get("Sales Invoice Header"."Salesperson Code") then begin
                    TxtContactPersonName_g := RecSalesPerson_l.Name;
                end else begin
                    TxtContactPersonName_g := '';
                end;

                //-- Pour pouvoir afficher la description du type de payment --
                RecPaymentTerms_g.Init;
                if RecPaymentTerms_g.Get("Sales Invoice Header"."Payment Terms Code") then;

                //-- Outils permetant de calculer les totaux, le détail TVA,...
                CUAbsysTools_l.GetSalesInvoiceVAT("Sales Invoice Header",
                  DecVATAmount_g,
                  DecVATBaseAmount_g,
                  DecVATDiscountAmount_g,
                  DecTotalAmountInclVAT_g,
                  RecVATAmountLine_g);

                //-- Récupère les adresse Formaté, Dans un Tableaux

                //--> ABSYS GN 20070123
                if "Sales Invoice Header"."Bill-to Country/Region Code" = 'BE' then begin
                    "Sales Invoice Header"."Bill-to Country/Region Code" := '';
                end;
                CUFormatAddress_l.SalesInvBillTo(TxtBillToAddress_g, "Sales Invoice Header");

                if "Sales Invoice Header"."Ship-to Country/Region Code" = 'BE' then begin
                    "Sales Invoice Header"."Ship-to Country/Region Code" := '';
                end;

                CUFormatAddress_l.SalesInvShipTo(TxtShipToAddress_g, TxtCusAddress_g, "Sales Invoice Header");
                //--> ABSYS GN 20070123


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

                //--> TEST EXEMPTION TVA
                Clear(TxtExemptionTVA_g);
                if DecVATAmount_g = 0 then begin
                    if RecCountry_g.IsEUCountry(RecCountry_g.Code) then
                        TxtExemptionTVA_g := Text50010
                    else
                        TxtExemptionTVA_g := Text50011;
                end;
                //<-- TEST EXEMPTION TVA

                TxtTemperature := '';
                if "Sales Invoice Header"."Order type" = "Sales Invoice Header"."Order type"::"Surgelé" then
                    TxtTemperature := Text50007;
                if "Sales Invoice Header"."Order type" = "Sales Invoice Header"."Order type"::Frais then
                    TxtTemperature := Text50006;

                Com := CuSales.GetCommunicationForInvoice("Sales Invoice Header");
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
                    Caption = 'Nombre de copie';
                }
                field(ShowPicture; ShowPicture)
                {
                    Caption = 'Afficher logo';
                }
                field(PrintOnly; PrintOnly)
                {
                    Caption = 'Seulement à imprimer';
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
        Country: Record "Country/Region";
    begin
        //-- Récupération des info Société --
        RecCompanyInformation_g.Get;
        Clear(TxtCountryCompanyg);
        if Country.Get(RecCompanyInformation_g."Country/Region Code") then begin
            TxtCountryCompanyg := Country.Name;
        end;

        // AC BDU 160112D
        //RecCompanyInformation_g.CALCFIELDS(Picture);

        //-- Init Nombre de copie
        IntNombreCopies_g := 1;

        //-- Création de l'image à afficher --
        // AC BDU 160112D
        //RecCompanyInformation_g.CALCFIELDS(Picture);

        //-- Nombre maximum de ligne à imprimer --
        //-- Varie en fonction de l'imprimente et de la taille du pied de page --

        IntNombreLignesDernièrePage_g := 32;

        //-- Par défaut on affiche les info vétérinaire à la fin --
        BoolDisplayInfoVet_g := false;
        ShowPicture := true;
    end;

    trigger OnPostReport()
    begin
        // MESSAGE('%1',IntNombreLignesDéjàImprimées_g);
    end;

    var
        IntNombreCopies_g: Integer;
        IntNombreBoucles_g: Integer;
        "IntNombreLignesDernièrePage_g": Integer;
        "IntNombreLignesDéjàImprimées_g": Integer;
        RecCompanyInformation_g: Record "Company Information";
        TxtBillToAddress_g: array[8] of Text[200];
        TxtCusAddress_g: array[8] of Text[200];
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
        Text50005: Label 'Control by the veterinarian authorities  AFSCA/UPC/B.W. AWE';
        BoolDisplayInfoVet_g: Boolean;
        Text50006: Label 'Chilled products are carried at temperature between 0 to +4°C';
        Text50007: Label 'Frozen goods are carried at temperature <-18°C';
        Text50000: Label 'COPY';
        Text50001: Label '%1 Invoice';
        CopyText: Text[30];
        "**** BANQUES ****": Integer;
        TxtBankName1_g: Text[60];
        TxtBankName2_g: Text[60];
        TxtBankName3_g: Text[30];
        LabBic1_g: Text[30];
        TxtBic1_g: Text[30];
        LabBic2_g: Text[30];
        LabBic3_g: Text[30];
        TxtBic2_g: Text[30];
        TxtBic3_g: Text[30];
        TxtBic4_g: Text[30];
        TxtBic5_g: Text[30];
        LabNum1_g: Text[30];
        LabNum3_g: Text[30];
        TxtNum1_g: Text[30];
        TxtNum3_g: Text[30];
        TxtNum4_g: Text[30];
        TxtNum5_g: Text[30];
        LabNum2_g: Text[30];
        TxtNum2_g: Text[30];
        RecCountry_g: Record "Country/Region";
        RecBankAccount_g: Record "Bank Account";
        RecBankAccount1_g: Record "Bank Account";
        RecBankAccount2_g: Record "Bank Account";
        RecBankAccount3_g: Record "Bank Account";
        RecBankAccount4_g: Record "Bank Account";
        RecBankAccount5_g: Record "Bank Account";
        CodePays_l: Code[10];
        Text50004: Label 'Batch No. : %1 - BB : %2';
        Text60000: Label 'Vous devez spécifier les banques pour ce pays : %1';
        Text50008: Label 'Control by the veterinarian authorities  FAVV/PCE/OVL/JVT';
        "*** Comment Vet ***": Integer;
        TxtCommentaireVet_g: Text[100];
        CUItemTrackingManagement_g: Codeunit "Item Tracking Management";
        TempItemLedgerEntry_g: Record "Item Ledger Entry" temporary;
        IntNbrLine_g: Integer;
        "*** Info Lot ***": Integer;
        NumBL: Text[30];
        DateBL: Date;
        NumLot: Text[30];
        DateGarantieLot: Date;
        "QuantitéLot": Integer;
        FirstRec: Boolean;
        Text50009: Label 'Shipping No. : %1 - Date : %2';
        DisplayShippingInfo: Boolean;
        Text50010: Label 'VAT free art. 39bis';
        TxtExemptionTVA_g: Text[200];
        TxtCountryCompanyg: Text[30];
        ShowPicture: Boolean;
        OutputNo: Integer;
        TxtInfoLot: Text[80];
        TxtTemperature: Text[120];
        LineTypeInt: Integer;
        Com: Text[30];
        Logo1: Variant;
        Text50011: Label 'VAT free art. 39';
        DatumCaptionLbl: Label 'Date';
        AbrechnungsadresseCaptionLbl: Label 'Invoicing address';
        LieferungsadresseCaptionLbl: Label 'Delivery address ';
        MwSt__nrCaptionLbl: Label 'VAT no.';
        Unsere_AuftragsnummerCaptionLbl: Label 'Our order no.';
        KundencodeCaptionLbl: Label 'Customer code';
        ErinnernCaptionLbl: Label 'To Remind';
        Dokumentennr_CaptionLbl: Label 'Document No.';
        "MUSS_für_das__was_folgt_CaptionLbl": Label 'MUST, for what follows :';
        Zahlungsbedingungen__CaptionLbl: Label 'Payment Terms :';
        GesamtzahlCaptionLbl: Label 'Total';
        Preis_je_EinheitCaptionLbl: Label 'Unit price';
        "Quantität___GewichtCaptionLbl": Label 'Quantity / Weight';
        KundenreferenzCaptionLbl: Label 'Customer Ref.';
        Ref_CaptionLbl: Label 'Ref.';
        Rab___CaptionLbl: Label 'Disc. %';
        BeschreibungCaptionLbl: Label 'Description';
        "PRODUZENT_VON_GEKOCHTEM_GEFLÜGELFLEISCHCaptionLbl": Label 'MANUFACTURER OF COOKED POULTRY-MEAT';
        TEL___CaptionLbl: Label 'TEL. :';
        FAX__CaptionLbl: Label 'FAX :';
        E_mail__CaptionLbl: Label 'E-mail :';
        Bank___CaptionLbl: Label 'Bank :';
        MwStCaptionLbl: Label 'VAT';
        GesamtzahlCaption_Control1000000032Lbl: Label 'Total';
        Preis_je_EinheitCaption_Control1000000047Lbl: Label 'Unit price';
        "Quantität___GewichtCaption_Control1000000049Lbl": Label 'Quantity / Weight';
        BeschreibungCaption_Control1000000064Lbl: Label 'Description';
        KundenreferenzCaption_Control1000000066Lbl: Label 'Customer Ref.';
        Ref_Caption_Control1000000076Lbl: Label 'Ref.';
        "MUSS_für_das__was_folgt_Caption_Control1000000160Lbl": Label 'MUST, for what follows :';
        DatumCaption_Control1000000291Lbl: Label 'Date';
        ErinnernCaption_Control1000000292Lbl: Label 'To Remind';
        Dokumentennr_Caption_Control1000000297Lbl: Label 'Document No.';
        KundencodeCaption_Control1000000299Lbl: Label 'Customer code';
        MwSt__nrCaption_Control1000000309Lbl: Label 'VAT no.';
        Unsere_AuftragsnummerCaption_Control1000000310Lbl: Label 'Our order no.';
        Zahlungsbedingungen__Caption_Control1000000312Lbl: Label 'Payment Terms :';
        Rab___Caption_Control1000000165Lbl: Label 'Disc. %';
        "PRODUZENT_VON_GEKOCHTEM_GEFLÜGELFLEISCHCaption_Control1000000235Lbl": Label 'MANUFACTURER OF COOKED POULTRY-MEAT';
        TEL___Caption_Control1000000251Lbl: Label 'TEL. :';
        FAX__Caption_Control1000000252Lbl: Label 'FAX :';
        E_mail__Caption_Control1000000253Lbl: Label 'E-mail :';
        MwStCaption_Control1000000311Lbl: Label 'VAT';
        Bank___Caption_Control1000000234Lbl: Label 'Bank :';
        Intrastat_Nr_CaptionLbl: Label 'Intrastat No. %1';
        Intrastat_NotEU: Label 'Intrastat Nr. %1,   HS Code %2,   Origin  %3';
        "Der_Kunde_akzeptiert_Lbl": Label 'The customer declares to have taken knowledge of the conditions of sale printed with the back and accepts explicitly them.';
        "Der_Kunde_akzeptie000Lbl": Label 'The customer declares to have taken knowledge of the conditions of sale printed with the back and accepts explicitly them.';
        "PRODUZENT_VON_GEKOCHTEM_GEFLÜGELFLEISCHCaption_Control1000000204Lbl": Label 'MANUFACTURER OF COOKED POULTRY-MEAT';
        Bank___Caption_Control1000000226Lbl: Label 'Bank :';
        ErinnernCaption_Control1000000287Lbl: Label 'To Remind';
        TEL___Caption_Control1000000342Lbl: Label 'TEL. :';
        FAX__Caption_Control1000000348Lbl: Label 'FAX :';
        E_mail__Caption_Control1000000349Lbl: Label 'E-mail :';
        MwStCaption_Control1000000350Lbl: Label 'VAT';
        DatumCaption_Control1000000351Lbl: Label 'Date';
        Dokumentennr_Caption_Control1000000352Lbl: Label 'Document No.';
        KundencodeCaption_Control1000000353Lbl: Label 'Customer code';
        "MUSS_für_das__was_folgt_Caption_Control1000000363Lbl": Label 'MUST, for what follows :';
        MwSt__nrCaption_Control1000000379Lbl: Label 'VAT no.';
        Unsere_AuftragsnummerCaption_Control1000000380Lbl: Label 'Our order no.';
        Zahlungsbedingungen__Caption_Control1000000381Lbl: Label 'Payment Terms :';
        GesamtzahlCaption_Control1000000095Lbl: Label 'Total';
        Rab___Caption_Control1000000103Lbl: Label 'Disc. %';
        Preis_je_EinheitCaption_Control1000000109Lbl: Label 'Unit price';
        "Quantität___GewichtCaption_Control1000000147Lbl": Label 'Quantity / Weight';
        BeschreibungCaption_Control1000000183Lbl: Label 'Description';
        KundenreferenzCaption_Control1000000218Lbl: Label 'Customer Ref.';
        Ref_Caption_Control1000000258Lbl: Label 'Ref.';
        "Der_Kunde_akzeptie001Lbl": Label 'The customer declares to have taken knowledge of the conditions of sale printed with the back and accepts explicitly them.';
        MwStCaption_Control1000000001Lbl: Label 'VAT';
        BasisCaptionLbl: Label 'Base';
        BesteuerungsgrundlageCaptionLbl: Label 'Taxable Amount';
        MwStCaption_Control1000000018Lbl: Label 'VAT';
        GesamtzahlCaption_Control1000000019Lbl: Label 'Total';
        Zu_zahlende_GesamtzahlCaptionLbl: Label 'To be paid';
        "FälligkeitsterminCaptionLbl": Label 'Due date';
        "Der_Kunde_akzeptie002Lbl": Label 'The customer declares to have taken knowledge of the conditions of sale printed with the back and accepts explicitly them.';
        Body: Text;
        NbreLignesVides: Integer;
        test: Text;
        CRLF: Text[3];
        DummyText: Text;
        cuSales: Codeunit Integration_Sales;
        UserSetup: Record "User Setup";
        PrintOnly: Boolean;

    local procedure getMailBody()
    var
        CRLF: Text[4];
    begin
        CRLF[1] := 13;

        Body := StrSubstNo(_GetBody("Sales Invoice Header"."Language Code"), "Sales Invoice Header"."No.", "Sales Invoice Header"."Due Date");

        Body += CRLF + CRLF;
        Body += 'Accounting Department' + CRLF;
        Body += 'Tel : +32 69 76 50 50' + CRLF;
        Body += 'Billing@europacuisson.com' + CRLF;
        Body += 'www.europacuisson.com' + CRLF;
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

    [Scope('OnPrem')]
    procedure SetPrintOnly()
    begin
        PrintOnly := true;
    end;
}

