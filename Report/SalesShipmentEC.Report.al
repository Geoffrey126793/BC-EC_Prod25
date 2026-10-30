report 50003 "Sales - Shipment EC"
{
    // //---------------------------------------------------------------------------------------------//
    // // AJouter la clé : VAT %,VAT Identifier,VAT Calculation Type,Tax Group Code,Use Tax,Positive  //
    // //                  Dans la table "VAT Amount Line"
    // //---------------------------------------------------------------------------------------------//
    // //CTD  ALX  15/06/15 : Ajout d'une correspondance entre Unité Sales Shipment Line et Unité Item Ledger Entry (détail)
    // //                     Uniquement pour le client C01337
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/SalesShipmentEC.rdlc';

    Caption = 'Sales - Shipment';

    dataset
    {
        dataitem("Sales Shipment Header"; "Sales Shipment Header")
        {
            DataItemTableView = SORTING("No.") ORDER(Ascending);
            RequestFilterFields = "No.";
            column(Sales_Shipment_Header_No_; "No.")
            {
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
                column(DataItem1000000097; RecCompanyInformation_g."Post Code" + ' ' + RecCompanyInformation_g.City + '-' + RecCompanyInformation_g."Country/Region Code")
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
                column(Sales_Shipment_Header___Bill_to_Customer_No__; "Sales Shipment Header"."Bill-to Customer No.")
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
                column(Sales_Shipment_Header___External_Document_No__; "Sales Shipment Header"."External Document No.")
                {
                }
                column(TxtVATRegNo_g; TxtVATRegNo_g)
                {
                }
                column(Sales_Shipment_Header___No__; "Sales Shipment Header"."No.")
                {
                }
                column(RecPaymentTerms_g_Description; RecPaymentTerms_g.Description)
                {
                }
                column(TextPage_______FORMAT_CurrReport_PAGENO_; TextPage + ' 1')
                {
                }
                column(Text50003; Text50003)
                {
                }
                column(Sales_Shipment_Header___Document_Date_; "Sales Shipment Header"."Document Date")
                {
                }
                column(Sales_Shipment_Header___Order_No__; "Sales Shipment Header"."Order No.")
                {
                }
                column(RecCustomer_g__Schedule_of_delivery_customer_; RecCustomer_g."Schedule of delivery customer")
                {
                }
                column(RecCustomer_g__Phone_No__; RecCustomer_g."Phone No.")
                {
                }
                column("Sales_Shipment_Header___Date_livraison_prévue_"; "Sales Shipment Header"."Date livraison prévue")
                {
                }
                column(OutputNo; OutputNo)
                {
                }
                column(TransportType; TransportType)
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
                column(Sales_Shipment_Header___External_Document_No__Caption; "Sales Shipment Header".FieldCaption("External Document No."))
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
                column("Quantität___ChargeCaption"; Quantität___ChargeCaptionLbl)
                {
                }
                column(Sales_Shipment_Header___Order_No__Caption; "Sales Shipment Header".FieldCaption("Order No."))
                {
                }
                column(Tel___Caption_Control1000000061; Tel___Caption_Control1000000061Lbl)
                {
                }
                column(Date_de_livraisonCaption; Date_de_livraisonCaptionLbl)
                {
                }
                column(CopyLoop_Number; Number)
                {
                }
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) ORDER(Ascending) WHERE(Number = CONST(1));
                    dataitem("Sales Shipment Line"; "Sales Shipment Line")
                    {
                        DataItemLink = "Document No." = FIELD("No.");
                        DataItemLinkReference = "Sales Shipment Header";
                        DataItemTableView = SORTING("Document No.", "Line No.") ORDER(Ascending);
                        column(TxtBankName1_g_Control1000000204; TxtBankName1_g)
                        {
                        }
                        column(TxtBic1_g_Control1000000205; TxtBic1_g)
                        {
                        }
                        column(TxtNum1_g_Control1000000206; TxtNum1_g)
                        {
                        }
                        column(TxtBankName2_g_Control1000000207; TxtBankName2_g)
                        {
                        }
                        column(LabBic1_g_Control1000000208; LabBic1_g)
                        {
                        }
                        column(LabNum1_g_Control1000000209; LabNum1_g)
                        {
                        }
                        column(RecCompanyInformation_g__Fax_No___Control1000000211; RecCompanyInformation_g."Fax No.")
                        {
                        }
                        column(RecCompanyInformation_g__Phone_No___Control1000000212; RecCompanyInformation_g."Phone No.")
                        {
                        }
                        column(DataItem1000000213; RecCompanyInformation_g."Post Code" + ' ' + RecCompanyInformation_g.City + '-' + RecCompanyInformation_g."Country/Region Code")
                        {
                        }
                        column(RecCompanyInformation_g_Address_________RecCompanyInformation_g__Address_2__Control1000000214; RecCompanyInformation_g.Address + ' ' + RecCompanyInformation_g."Address 2")
                        {
                        }
                        column(RecCompanyInformation_g__E_Mail__Control1000000215; RecCompanyInformation_g."E-Mail")
                        {
                        }
                        column(BE__RecCompanyInformation_g__Enterprise_No___Control1000000216; 'BE' + RecCompanyInformation_g."Enterprise No.")
                        {
                        }
                        column(LabBic2_g_Control1000000217; LabBic2_g)
                        {
                        }
                        column(TxtBic2_g_Control1000000218; TxtBic2_g)
                        {
                        }
                        column(TxtNum2_g_Control1000000223; TxtNum2_g)
                        {
                        }
                        column(LabNum2_g_Control1000000224; LabNum2_g)
                        {
                        }
                        column(RecCompanyInformation_g__N__Registre_de_Commerce__Control1000000225; RecCompanyInformation_g."Nº Registre de Commerce")
                        {
                        }
                        column(RecCompanyInformation_g_Picture_Control1000000226; RecCompanyInformation_g.Picture)
                        {
                        }
                        column(Sales_Shipment_Header___Document_Date__Control1000000294; "Sales Shipment Header"."Document Date")
                        {
                        }
                        column(Sales_Shipment_Header___No___Control1000000296; "Sales Shipment Header"."No.")
                        {
                        }
                        column(Sales_Shipment_Header___Bill_to_Customer_No___Control1000000300; "Sales Shipment Header"."Bill-to Customer No.")
                        {
                        }
                        column(Sales_Shipment_Header___External_Document_No___Control1000000303; "Sales Shipment Header"."External Document No.")
                        {
                        }
                        column(TxtVATRegNo_g_Control1000000304; TxtVATRegNo_g)
                        {
                        }
                        column(TxtContactPersonName_g; TxtContactPersonName_g)
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
                        column(Text50003_Control1000000075; Text50003)
                        {
                        }
                        column(Sales_Shipment_Line__Sales_Shipment_Line___No__; "Sales Shipment Line"."No.")
                        {
                        }
                        column(Sales_Shipment_Line__Sales_Shipment_Line__Description; "Sales Shipment Line".Description)
                        {
                        }
                        column(Sales_Shipment_Line__Unit_of_Measure_; "Unit of Measure")
                        {
                        }
                        column(Sales_Shipment_Line_Quantity; Quantity)
                        {
                        }
                        column(Sales_Shipment_Line__Sales_Shipment_Line___Cross_Reference_No__; "Sales Shipment Line"."Item Reference No.")
                        {
                        }
                        column(Sales_Invoice_Line__Line_No__; "Line No.")
                        {
                        }
                        column(SalesLineType; LineTypeInt)
                        {
                        }
                        column(Sales_Shipment_Line__Sales_Shipment_Line___Description_2_; "Sales Shipment Line"."Description 2")
                        {
                        }
                        column(Sales_Shipment_Line__Sales_Shipment_Line__Description_Control1000000040; "Sales Shipment Line".Description)
                        {
                        }
                        column(TxtNumIntrastat_g; TxtNumIntrastat_g)
                        {
                        }
                        column(RecCompanyInformation_g__Home_Page_; '')
                        {
                        }
                        column(Text50002; Text50002)
                        {
                        }
                        column(Bank___Caption_Control1000000202; Bank___Caption_Control1000000202Lbl)
                        {
                        }
                        column("PRODUZENT_VON_GEKOCHTEM_GEFLÜGELFLEISCHCaption_Control1000000203"; PRODUZENT_VON_GEKOCHTEM_GEFLÜGELFLEISCHCaption_Control1000000203Lbl)
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
                        column(MwStCaption_Control1000000222; MwStCaption_Control1000000222Lbl)
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
                        column(Sales_Shipment_Header___External_Document_No___Control1000000303Caption; "Sales Shipment Header".FieldCaption("External Document No."))
                        {
                        }
                        column(MwSt__nrCaption_Control1000000309; MwSt__nrCaption_Control1000000309Lbl)
                        {
                        }
                        column(Invoicing_contactCaption; Invoicing_contactCaptionLbl)
                        {
                        }
                        column(Zahlungsbedingungen__Caption_Control1000000312; Zahlungsbedingungen__Caption_Control1000000312Lbl)
                        {
                        }
                        column("Quantität___ChargeCaption_Control1000000035"; Quantität___ChargeCaption_Control1000000035Lbl)
                        {
                        }
                        column(Intrastat_Nr___Caption; Intrastat_Nr___CaptionLbl)
                        {
                        }
                        column(Sales_Shipment_Line_Document_No_; "Document No.")
                        {
                        }
                        dataitem("Item Entry Relation"; "Item Entry Relation")
                        {
                            DataItemLink = "Source ID" = FIELD("Document No."), "Source Ref. No." = FIELD("Line No.");
                            DataItemTableView = SORTING("Item Entry No.") ORDER(Ascending) WHERE("Source Type" = CONST(111), "Source Subtype" = CONST("0"));
                            column(Item_Entry_Relation_Item_Entry_No_; "Item Entry No.")
                            {
                            }
                            column(Item_Entry_Relation_Source_ID; "Source ID")
                            {
                            }
                            column(Item_Entry_Relation_Source_Ref__No_; "Source Ref. No.")
                            {
                            }
                            dataitem("Item Ledger Entry"; "Item Ledger Entry")
                            {
                                DataItemLink = "Entry No." = FIELD("Item Entry No.");
                                DataItemTableView = SORTING("Entry No.") ORDER(Ascending);
                                column(STRSUBSTNO_Text50004___Lot_No____Warranty_Date__; StrSubstNo(Text50004, "Lot No.", "Warranty Date"))
                                {
                                }
                                column(QuantityILE; -QuantityILE)
                                {
                                    DecimalPlaces = 0 : 2;
                                }
                                column(Item_Ledger_Entry_Entry_No_; "Entry No.")
                                {
                                }

                                trigger OnAfterGetRecord()
                                begin
                                    /*IF "Sales Shipment Line"."Sell-to Customer No." = 'C01337' THEN BEGIN
                                      ItemUnits.SETRANGE(ItemUnits."Item No.","Item Ledger Entry"."Item No.");
                                      ItemUnits.SETRANGE(ItemUnits.Code,"Sales Shipment Line"."Unit of Measure Code");
                                      IF ItemUnits.FINDLAST THEN
                                        QuantityILE:="Item Ledger Entry".Quantity/ItemUnits."Qty. per Unit of Measure"
                                      ELSE QuantityILE:="Item Ledger Entry".Quantity;
                                    END ELSE
                                      QuantityILE:="Item Ledger Entry".Quantity;
                                    */
                                    QuantityILE := "Item Ledger Entry".Quantity / "Item Ledger Entry"."Qty. per Unit of Measure";



                                    IntNombreLignesDéjàImprimées_g += 1;

                                end;
                            }
                        }

                        trigger OnAfterGetRecord()
                        begin
                            LineTypeInt := "Sales Shipment Line".Type.AsInteger();

                            TxtNumIntrastat_g := '';
                            if "Sales Shipment Line".Type = "Sales Shipment Line".Type::Item then begin
                                if RecItem_g.Get("Sales Shipment Line"."No.") then
                                    if StrPos("Sales Shipment Line"."No.", '2-') > 0 then
                                        TxtNumIntrastat_g := RecItem_g."Tariff No." + ' Sus domesticus'
                                    else
                                        TxtNumIntrastat_g := RecItem_g."Tariff No." + ' Gallus domesticus';
                                DecTotalHT_g := DecTotalHT_g + ("Sales Shipment Line".Quantity * "Sales Shipment Line"."Unit Price");
                            end;


                            if ("Sales Shipment Line".Type <> "Sales Shipment Line".Type::" ") then
                                IntNombreLignesDéjàImprimées_g += 1;
                            if ("Sales Shipment Line".Type <> "Sales Shipment Line".Type::" ") and
                                  ("Sales Shipment Line"."Description 2" <> '') then
                                IntNombreLignesDéjàImprimées_g += 1;
                            if ("Sales Shipment Line".Type = "Sales Shipment Line".Type::" ") then
                                IntNombreLignesDéjàImprimées_g += 1;
                            if TxtNumIntrastat_g <> '' then
                                IntNombreLignesDéjàImprimées_g += 1;





                        end;
                    }
                    dataitem(Info; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
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
                        column(EmpyLines_Number; Number)
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            //-- Détermine le nombre de ligne vide qu'il reste à imprimer, en fonction du nombre max de ligne imprimable --

                            //MESSAGE('a - %1',IntNombreLignesDéjàImprimées_g);
                            while IntNombreLignesDéjàImprimées_g >= IntNombreLignesDernièrePage_g do
                                IntNombreLignesDéjàImprimées_g := IntNombreLignesDéjàImprimées_g - IntNombreLignesDernièrePage_g;
                            // 8 lignes pour le total
                            if (IntNombreLignesDernièrePage_g - IntNombreLignesDéjàImprimées_g - 1) > 7 then
                                EmptyLines.SetRange(Number, 1, (IntNombreLignesDernièrePage_g - IntNombreLignesDéjàImprimées_g - 1 - 7))
                            else
                                EmptyLines.SetRange(Number, 1, (IntNombreLignesDernièrePage_g - IntNombreLignesDéjàImprimées_g - 1 +
                                IntNombreLignesDernièrePage_g - 7));
                            //MESSAGE('b - %1',IntNombreLignesDéjàImprimées_g);

                        end;
                    }
                    dataitem(Footer; "Integer")
                    {
                        DataItemTableView = SORTING(Number) ORDER(Ascending);
                        MaxIteration = 1;
                        column(RecCompanyInformation_g__Home_Page__Control1000000318; '')
                        {
                        }
                        column(Text50002_Control1000000071; Text50002)
                        {
                        }
                        column("RecSalesReceivablesSetup_g__Logo_Contrôle_2_"; RecSalesReceivablesSetup_g."Logo Contrôle 2")
                        {
                        }
                        column("RecSalesReceivablesSetup_g__Logo_Contrôle_3_"; RecSalesReceivablesSetup_g."Logo Contrôle 3")
                        {
                        }
                        column("RecSalesReceivablesSetup_g__Logo_Contrôle_4_"; RecSalesReceivablesSetup_g."Logo Contrôle 4")
                        {
                        }
                        column("RecSalesReceivablesSetup_g__Logo_Contrôle_1_"; RecSalesReceivablesSetup_g."Logo Contrôle 1")
                        {
                        }
                        column("Unterschrift_des_Empfängers_für_Warenempfang__Caption"; Unterschrift_des_Empfängers_für_Warenempfang__CaptionLbl)
                        {
                        }
                        column(Footer_Number; Number)
                        {
                        }
                    }
                }

                trigger OnAfterGetRecord()
                begin

                    OutputNo += 1;
                    IntNombreLignesDéjàImprimées_g := 0;

                end;

                trigger OnPostDataItem()
                var
                    CUSalesShptCountPrinted_l: Codeunit "Sales Shpt.-Printed";
                begin
                    if not CurrReport.Preview then
                        CUSalesShptCountPrinted_l.Run("Sales Shipment Header");
                end;

                trigger OnPreDataItem()
                begin
                    //-- Détermine le nombre de copie --
                    IntNombreBoucles_g := rCust."Number copy BL" + 2;
                    if IntNombreBoucles_g <= 0 then begin
                        IntNombreBoucles_g := 1;
                    end;

                    CopyLoop.SetRange(Number, 1, IntNombreBoucles_g);

                    OutputNo := 0;

                end;
            }
            dataitem(Pallet; Pallet)
            {
                DataItemLink = "Outbound Document No." = FIELD("No.");
                column(SSCCNo_Pallet; Pallet."SSCC No.")
                {
                }
                column(GS1_00_Txt; GS1_00_Txt)
                {
                }
                column(GS1_00_128; GS1_00_128)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if "Sales Shipment Header"."Sell-to Customer No." <> 'C03422' then
                        CurrReport.Skip;
                    GS1_00_Txt := '(00)' + GS1.GetSSCCFromPal(Pallet."SSCC No.");
                    GS1_00_128 := Utils.Code128GetDisplay(GS1_00_Txt);
                end;
            }

            trigger OnAfterGetRecord()
            var
                RecLanguage_l: Record Language;
                CUFormatAddress_l: Codeunit "Format Address";
                CUAbsysTools_l: Codeunit "Absys - tools PJ";
                RecSalesPerson_l: Record "Salesperson/Purchaser";
                RecLocation_l: Record Location;
                cuLanguage: Codeunit Language;
            begin
                // -- INIT --
                Clear(TxtVATRegNo_g);
                Clear(TxtBillToAddress_g);
                Clear(TxtShipToAddress_g);
                DecTotalHT_g := 0;

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

                if "Sales Shipment Header"."Bill-to Country/Region Code" = '' then
                    CodePays_l := RecCompanyInformation_g."Country/Region Code"
                else
                    CodePays_l := "Sales Shipment Header"."Bill-to Country/Region Code";


                if rCust.Get("Sell-to Customer No.") then;


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
                CurrReport.Language := cuLanguage.GetLanguageIdOrDefault("Sales Shipment Header"."Language Code");

                //-- Récupération des données TVA dui client --
                RecCustomer_g.Init;
                if RecCustomer_g.Get("Sales Shipment Header"."Bill-to Customer No.") then begin
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
                CUFormatAddress_l.SalesShptShipTo(TxtShipToAddress_g, "Sales Shipment Header");
                CUFormatAddress_l.SalesShptBillTo(TxtBillToAddress_g, TxtAddressInvoiceOpt_g, "Sales Shipment Header");

                //-- Récupère le type de devise du document
                if "Sales Shipment Header"."Currency Code" <> '' then begin
                    CodeCurrency_g := "Sales Shipment Header"."Currency Code";
                end else begin
                    CodeCurrency_g := 'EUR';
                end;

                //-- Récupération données "Vendeur" --
                if RecSalesPerson_l.Get("Sales Shipment Header"."Salesperson Code") then begin
                    TxtContactPersonName_g := RecSalesPerson_l.Name;
                end else begin
                    TxtContactPersonName_g := '';
                end;

                //-- Pour pouvoir afficher la description du type de payment --
                RecPaymentTerms_g.Init;
                if RecPaymentTerms_g.Get("Sales Shipment Header"."Payment Terms Code") then;

                //-- Outils permetant de calculer les totaux, le détail TVA,...

                //CUAbsysTools_l.GetSalesOrderVAT("Sales Shipment Header",
                //  DecVATAmount_g,
                //  DecVATBaseAmount_g,
                //  DecVATDiscountAmount_g,
                //  DecTotalAmountInclVAT_g,
                //  RecVATAmountLine_g);

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
                if "Sales Shipment Header"."Order type" = "Sales Shipment Header"."Order type"::Frais then
                    TransportType := Text50006;
                if "Sales Shipment Header"."Order type" = "Sales Shipment Header"."Order type"::"Surgelé" then
                    TransportType := Text50007;
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
        RecSalesReceivablesSetup_g.Get;

        //-- Création de l'image à afficher --
        RecCompanyInformation_g.CalcFields(Picture);

        //-- Création des logo qualité --
        RecSalesReceivablesSetup_g.CalcFields("Logo Contrôle 1");
        RecSalesReceivablesSetup_g.CalcFields("Logo Contrôle 2");
        RecSalesReceivablesSetup_g.CalcFields("Logo Contrôle 3");
        RecSalesReceivablesSetup_g.CalcFields("Logo Contrôle 4");

        //-- Nombre maximum de ligne à imprimer --
        //-- Varie en fonction de l'imprimente et de la taille du pied de page --

        IntNombreLignesDernièrePage_g := 32;


        //-- Par défaut on affiche les info vétérinaire à la fin --
        BoolDisplayInfoVet_g := false;
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
        //RecVATAmountLine_g: array[5] of Record "VAT Amount Line" temporary;
        RecPaymentTerms_g: Record "Payment Terms";
        TxtContactPersonName_g: Text[40];
        TextPage: Label 'Page';
        TextPhone: Label 'Phone. :';
        TxtVATRegNo_g: Text[30];
        TextTVAAbsente: Label '';
        RecItem_g: Record Item;
        TxtNumIntrastat_g: Text[30];
        BoolAddressInvoiceOpt_g: Boolean;
        TxtAddressInvoiceOpt_g: array[8] of Text[200];
        Text50000: Label 'Despatch Note';
        DecTotalHT_g: Decimal;
        Text50001: Label 'MANUFACTURER OF COOKED POULTRY-MEAT';
        Text50002: Label 'The customer declares to have taken knowledge of the conditions of sale printed with the back and accepts explicitly them.';
        Text50003: Label 'MUST, for what follows :';
        Text50004: Label 'Batch No. : %1 - BB : %2';
        BoolDisplayInfoVet_g: Boolean;
        RecSalesReceivablesSetup_g: Record "Sales & Receivables Setup";
        Text50006: Label 'Fresh products are carried at temperature between 0 to +4°C';
        Text50007: Label 'Frozen goods are carried at temperature <-18°C';
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
        Text50005: Label 'Control by the veterinarian authorities  AFSCA/UPC/B.W. AWE';
        Text50008: Label 'Control by the veterinarian authorities  FAVV/PCE/OVL/JVT';
        rCust: Record Customer;
        UnitMeasure: Text[10];
        ItemUnits: Record "Item Unit of Measure";
        QuantityILE: Decimal;
        OutputNo: Integer;
        LineTypeInt: Integer;
        TransportType: Text[100];
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
        Zahlungsbedingungen__CaptionLbl: Label 'Payment Terms :';
        "Quantität___GewichtCaptionLbl": Label 'Quantity / Weight';
        EinheitCaptionLbl: Label 'Unit';
        BeschreibungCaptionLbl: Label 'Description';
        KundenreferenzCaptionLbl: Label 'Customer Ref.';
        Ref_CaptionLbl: Label 'Ref.';
        "Quantität___ChargeCaptionLbl": Label 'Quantity / Batch';
        Tel___Caption_Control1000000061Lbl: Label 'Tel. :';
        Date_de_livraisonCaptionLbl: Label 'Date de livraison';
        Bank___Caption_Control1000000202Lbl: Label 'Banks :';
        "PRODUZENT_VON_GEKOCHTEM_GEFLÜGELFLEISCHCaption_Control1000000203Lbl": Label 'MANUFACTURER OF COOKED POULTRY-MEAT';
        TEL___Caption_Control1000000219Lbl: Label 'TEL. :';
        FAX__Caption_Control1000000220Lbl: Label 'FAX :';
        E_mail__Caption_Control1000000221Lbl: Label 'E-mail :';
        MwStCaption_Control1000000222Lbl: Label 'VAT';
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
        Invoicing_contactCaptionLbl: Label 'Invoicing contact';
        Zahlungsbedingungen__Caption_Control1000000312Lbl: Label 'Payment Terms :';
        "Quantität___ChargeCaption_Control1000000035Lbl": Label 'Quantity / Batch';
        Intrastat_Nr___CaptionLbl: Label 'Intrastat No. :';
        "Unterschrift_des_Empfängers_für_Warenempfang__CaptionLbl": Label 'Signature of the recipient for reception goods :';
        Utils: Codeunit Utils;
        GS1_00_Txt: Text;
        GS1_00_128: Text;
        GS1: Codeunit "GS1 Send";
}

