report 50004 "Reminder EC"
{
    // //--> ABSYS GN 20070409
    //  - Affichage des cumules
    //  - Sous Totaux
    // //<-- ABSYS GN 20070409
    // 
    // //-- AB6.VR 24/10/07
    //      - Changement affichage des coordonnées bancaires (on n'imprime plus le NAme, BIC et IBAN texte inversé)
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/ReminderEC.rdlc';

    Caption = 'Reminder';

    dataset
    {
        dataitem("Issued Reminder Header"; "Issued Reminder Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "No. Printed", "Salesperson Code";
            RequestFilterHeading = 'Reminder';
            column(Issued_Reminder_Header_No_; "No.")
            {
            }
            column(MailBody; Body)
            {
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
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
                column(CompanyInfo__Fax_No__; CompanyInfo."Fax No.")
                {
                }
                column(CompanyInfo__Phone_No__; CompanyInfo."Phone No.")
                {
                }
                column(CompanyInfo__Post_Code__________CompanyInfo_City______CompanyInfo__Country_Region_Code_; CompanyInfo."Post Code" + ' ' + CompanyInfo.City + '-' + CompanyInfo."Country/Region Code")
                {
                }
                column(CompanyInfo_Address_________CompanyInfo__Address_2_; CompanyInfo.Address + ' ' + CompanyInfo."Address 2")
                {
                }
                column(CompanyInfo__E_Mail_; CompanyInfo."E-Mail")
                {
                }
                column(BE__CompanyInfo__Enterprise_No__; 'BE' + CompanyInfo."Enterprise No.")
                {
                }
                column(LabBic2_g; LabBic2_g)
                {
                }
                column(TxtBic2_g; TxtBic2_g)
                {
                }
                column(CompanyInfo_Picture; CompanyInfo.Picture)
                {
                }
                column(TxtNum2_g; TxtNum2_g)
                {
                }
                column(LabNum2_g; LabNum2_g)
                {
                }
                column(CompanyInfo__N__Registre_de_Commerce_; CompanyInfo."Nº Registre de Commerce")
                {
                }
                column(Issued_Reminder_Header___Document_Date_; "Issued Reminder Header"."Document Date")
                {
                }
                column(Issued_Reminder_Header___No__; "Issued Reminder Header"."No.")
                {
                }
                column(Issued_Reminder_Header___Customer_No__; "Issued Reminder Header"."Customer No.")
                {
                }
                column(gtxt_remindertext; gtxt_remindertext)
                {
                }
                column(Issued_Reminder_Header___Your_Reference_; "Issued Reminder Header"."Your Reference")
                {
                }
                column(Issued_Reminder_Header___VAT_Registration_No__; "Issued Reminder Header"."VAT Registration No.")
                {
                }
                column(Issued_Reminder_Header___Customer_No___Control1000000085; "Issued Reminder Header"."Customer No.")
                {
                }
                column(ReferenceText; ReferenceText)
                {
                }
                column(CustAddr_6_; CustAddr[6])
                {
                }
                column(CustAddr_5_; CustAddr[5])
                {
                }
                column(CustAddr_4_; CustAddr[4])
                {
                }
                column(CustAddr_3_; CustAddr[3])
                {
                }
                column(CustAddr_2_; CustAddr[2])
                {
                }
                column(CustAddr_1_; CustAddr[1])
                {
                }
                column(WFax; WFax)
                {
                }
                column(WEmail; WEmail)
                {
                }
                column(TxtBankName1_g_Control1000000055; TxtBankName1_g)
                {
                }
                column(TxtBic1_g_Control1000000056; TxtBic1_g)
                {
                }
                column(TxtNum1_g_Control1000000057; TxtNum1_g)
                {
                }
                column(LabBic1_g_Control1000000058; LabBic1_g)
                {
                }
                column(LabNum1_g_Control1000000059; LabNum1_g)
                {
                }
                column(CompanyInfo__Fax_No___Control1000000061; CompanyInfo."Fax No.")
                {
                }
                column(CompanyInfo__Phone_No___Control1000000062; CompanyInfo."Phone No.")
                {
                }
                column(CompanyInfo__Post_Code__________CompanyInfo_City______CompanyInfo__Country_Region_Code__Control1000000063; CompanyInfo."Post Code" + ' ' + CompanyInfo.City + '-' + CompanyInfo."Country/Region Code")
                {
                }
                column(CompanyInfo_Address_________CompanyInfo__Address_2__Control1000000064; CompanyInfo.Address + ' ' + CompanyInfo."Address 2")
                {
                }
                column(CompanyInfo__E_Mail__Control1000000065; CompanyInfo."E-Mail")
                {
                }
                column(TxtBankName2_g_Control1000000066; TxtBankName2_g)
                {
                }
                column(BE__CompanyInfo__Enterprise_No___Control1000000097; 'BE' + CompanyInfo."Enterprise No.")
                {
                }
                column(LabBic2_g_Control1000000099; LabBic2_g)
                {
                }
                column(TxtBic2_g_Control1000000100; TxtBic2_g)
                {
                }
                column(CompanyInfo_Picture_Control1000000101; CompanyInfo.Picture)
                {
                }
                column(TxtNum2_g_Control1000000102; TxtNum2_g)
                {
                }
                column(LabNum2_g_Control1000000103; LabNum2_g)
                {
                }
                column(CompanyInfo__N__Registre_de_Commerce__Control1000000104; CompanyInfo."Nº Registre de Commerce")
                {
                }
                column("PRODUZENT_VON_GEKOCHTEM_GEFLÜGELFLEISCHCaption"; PRODUZENT_VON_GEKOCHTEM_GEFLÜGELFLEISCHCaptionLbl)
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
                column(MwStCaption; MwStCaptionLbl)
                {
                }
                column(Issued_Reminder_Header___No__Caption; Issued_Reminder_Header___No__CaptionLbl)
                {
                }
                column(DateCaption; DateCaptionLbl)
                {
                }
                column(ErinnernCaption; ErinnernCaptionLbl)
                {
                }
                column(Customer_codeCaption; Customer_codeCaptionLbl)
                {
                }
                column(Issued_Reminder_Header___Customer_No___Control1000000085Caption; "Issued Reminder Header".FieldCaption("Customer No."))
                {
                }
                column(MwSt__nrCaption; MwSt__nrCaptionLbl)
                {
                }
                column(Bank___Caption_Control1000000053; Bank___Caption_Control1000000053Lbl)
                {
                }
                column("PRODUZENT_VON_GEKOCHTEM_GEFLÜGELFLEISCHCaption_Control1000000054"; PRODUZENT_VON_GEKOCHTEM_GEFLÜGELFLEISCHCaption_Control1000000054Lbl)
                {
                }
                column(TEL___Caption_Control1000000067; TEL___Caption_Control1000000067Lbl)
                {
                }
                column(FAX__Caption_Control1000000086; FAX__Caption_Control1000000086Lbl)
                {
                }
                column(E_mail__Caption_Control1000000090; E_mail__Caption_Control1000000090Lbl)
                {
                }
                column(MwStCaption_Control1000000098; MwStCaption_Control1000000098Lbl)
                {
                }
                column(Integer_Number; Number)
                {
                }
                dataitem(IssuedReminderLine1; "Issued Reminder Line")
                {
                    DataItemLink = "Reminder No." = FIELD("No.");
                    DataItemLinkReference = "Issued Reminder Header";
                    DataItemTableView = SORTING("Reminder No.", "Line No.");
                    column(IssuedReminderLine1_Description; Description)
                    {
                    }
                    column(IssuedReminderLine1_Reminder_No_; "Reminder No.")
                    {
                    }
                    column(IssuedReminderLine1_Line_No_; "Line No.")
                    {
                    }

                    trigger OnPreDataItem()
                    begin
                        if Find('-') then begin
                            StartLineNo := 0;
                            repeat
                                Continue := Type = Type::" ";
                                if Continue and (Description = '') then
                                    StartLineNo := "Line No.";
                            until (Next = 0) or not Continue;
                        end;
                        if Find('+') then begin
                            EndLineNo := "Line No." + 1;
                            repeat
                                Continue := Type = Type::" ";
                                if Continue and (Description = '') then
                                    EndLineNo := "Line No.";
                            until (Next(-1) = 0) or not Continue;
                        end;

                        SetFilter("Line No.", '<%1', StartLineNo);
                    end;
                }
                dataitem("Issued Reminder Line"; "Issued Reminder Line")
                {
                    DataItemLink = "Reminder No." = FIELD("No.");
                    DataItemLinkReference = "Issued Reminder Header";
                    DataItemTableView = SORTING("Reminder No.", "Line No.");
                    column(Issued_Reminder_Line__Document_Date_; "Document Date")
                    {
                    }
                    column(Issued_Reminder_Line__Document_No__; "Document No.")
                    {
                    }
                    column(Issued_Reminder_Line__Due_Date_; "Due Date")
                    {
                    }
                    column(Issued_Reminder_Line__Remaining_Amount_; "Remaining Amount")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(Issued_Reminder_Line__Original_Amount_; "Original Amount")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(Issued_Reminder_Line__Document_Type_; "Document Type")
                    {
                    }
                    column(DecTotalCumule_g; DecTotalCumule_g)
                    {
                    }
                    column(LineType; LineType)
                    {
                    }
                    column(DecTotalCumulDue_g; DecTotalCumulDue_g)
                    {
                    }
                    column(Issued_Reminder_Line__Remaining_Amount__Control1000000017; "Remaining Amount")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(Issued_Reminder_Line__Original_Amount__Control1000000018; "Original Amount")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(Issued_Reminder_Line__Due_Date__Control1000000019; "Due Date")
                    {
                    }
                    column(Issued_Reminder_Line__Document_No___Control1000000020; "Document No.")
                    {
                    }
                    column(Issued_Reminder_Line__Document_Type__Control1000000021; "Document Type")
                    {
                    }
                    column(Issued_Reminder_Line__Document_Date__Control1000000022; "Document Date")
                    {
                    }
                    column(DecTotalCumulNotDue_g; DecTotalCumulNotDue_g)
                    {
                    }
                    column(Issued_Reminder_Line__Remaining_Amount__Control1000000024; "Remaining Amount")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(Issued_Reminder_Line__Original_Amount__Control1000000025; "Original Amount")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(Issued_Reminder_Line__Due_Date__Control1000000026; "Due Date")
                    {
                    }
                    column(Issued_Reminder_Line__Document_No___Control1000000027; "Document No.")
                    {
                    }
                    column(Issued_Reminder_Line__Document_Type__Control1000000105; "Document Type")
                    {
                    }
                    column(Issued_Reminder_Line__Document_Date__Control1000000106; "Document Date")
                    {
                    }
                    column(Issued_Reminder_Line_Description; Description)
                    {
                    }
                    column(Issued_Reminder_Line__Remaining_Amount__Control38; "Remaining Amount")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(Issued_Reminder_Line__No__; "No.")
                    {
                    }
                    column(Issued_Reminder_Line__Remaining_Amount__Control95; "Remaining Amount")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(Issued_Reminder_Line_Description_Control96; Description)
                    {
                    }
                    column(ReminderInterestAmount; ReminderInterestAmount)
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(DecTotalCumulDue_g_Control1000000107; DecTotalCumulDue_g)
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(DecTotalCumulNotDue_g_Control1000000108; DecTotalCumulNotDue_g)
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(Text55000; Text55000)
                    {
                    }
                    column(Text55001; Text55001)
                    {
                    }
                    column(Remaining_Amount____ReminderInterestAmount; "Remaining Amount" + ReminderInterestAmount)
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(TotalText; TotalText)
                    {
                    }
                    column(Remaining_Amount____ReminderInterestAmount____VAT_Amount_; "Remaining Amount" + ReminderInterestAmount + "VAT Amount")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(TotalInclVATText; TotalInclVATText)
                    {
                    }
                    column(Issued_Reminder_Line__VAT_Amount_; "VAT Amount")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(Issued_Reminder_Line__Document_Date_Caption; FieldCaption("Document Date"))
                    {
                    }
                    column(Belegnr_Caption; Belegnr_CaptionLbl)
                    {
                    }
                    column("FälligkeitsdatumCaption"; FälligkeitsdatumCaptionLbl)
                    {
                    }
                    column(Issued_Reminder_Line__Remaining_Amount_Caption; Issued_Reminder_Line__Remaining_Amount_CaptionLbl)
                    {
                    }
                    column(Issued_Reminder_Line__Original_Amount_Caption; FieldCaption("Original Amount"))
                    {
                    }
                    column(Issued_Reminder_Line__Document_Type_Caption; FieldCaption("Document Type"))
                    {
                    }
                    column(Added_amount_Caption; Added_amount_CaptionLbl)
                    {
                    }
                    column(Issued_Reminder_Line__Remaining_Amount_Caption_Control1000000035; Issued_Reminder_Line__Remaining_Amount_Caption_Control1000000035Lbl)
                    {
                    }
                    column(Issued_Reminder_Line__Original_Amount_Caption_Control1000000036; FieldCaption("Original Amount"))
                    {
                    }
                    column("FälligkeitsdatumCaption_Control1000000037"; FälligkeitsdatumCaption_Control1000000037Lbl)
                    {
                    }
                    column(Belegnr_Caption_Control1000000038; Belegnr_Caption_Control1000000038Lbl)
                    {
                    }
                    column(BelegartCaption; BelegartCaptionLbl)
                    {
                    }
                    column(Issued_Reminder_Line__Document_Date_Caption_Control1000000040; FieldCaption("Document Date"))
                    {
                    }
                    column(Added_amount_Caption_Control1000000014; Added_amount_Caption_Control1000000014Lbl)
                    {
                    }
                    column(ReminderInterestAmountCaption; ReminderInterestAmountCaptionLbl)
                    {
                    }
                    column(Issued_Reminder_Line__VAT_Amount_Caption; FieldCaption("VAT Amount"))
                    {
                    }
                    column(Issued_Reminder_Line_Reminder_No_; "Reminder No.")
                    {
                    }
                    column(Issued_Reminder_Line_Line_No_; "Line No.")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        VATAmountLine.Init;
                        VATAmountLine."VAT Identifier" := "VAT Identifier";
                        VATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
                        VATAmountLine."Tax Group Code" := "Tax Group Code";
                        VATAmountLine."VAT %" := "VAT %";
                        VATAmountLine."VAT Base" := Amount;
                        VATAmountLine."VAT Amount" := "VAT Amount";
                        VATAmountLine."Amount Including VAT" := Amount + "VAT Amount";
                        VATAmountLine."VAT Base" := Amount;
                        VATAmountLine.InsertLine;

                        case Type of
                            Type::"G/L Account":
                                "Remaining Amount" := Amount;
                            Type::"Customer Ledger Entry":
                                ReminderInterestAmount := Amount;
                        end;

                        //--> ABYSS GN 20070405
                        DecTotalCumule_g := DecTotalCumule_g + "Remaining Amount";
                        if "Issued Reminder Line"."Not Due" then begin
                            DecTotalCumulNotDue_g := DecTotalCumulNotDue_g + "Remaining Amount";
                            BoolDisplayNotDue_g := true;
                        end else begin
                            DecTotalCumulDue_g := DecTotalCumulDue_g + "Remaining Amount";
                        end;
                        //<-- ABYSS GN 20070405
                        LineType := Type.AsInteger();
                    end;

                    trigger OnPreDataItem()
                    begin

                        VATAmountLine.DeleteAll;
                        SetFilter("Line No.", '>%1&<%2', StartLineNo, EndLineNo);

                    end;
                }
                dataitem(IssuedReminderLine2; "Issued Reminder Line")
                {
                    DataItemLink = "Reminder No." = FIELD("No.");
                    DataItemLinkReference = "Issued Reminder Header";
                    DataItemTableView = SORTING("Reminder No.", "Line No.");
                    column(IssuedReminderLine2_Description; Description)
                    {
                    }
                    column(IssuedReminderLine2_Reminder_No_; "Reminder No.")
                    {
                    }
                    column(IssuedReminderLine2_Line_No_; "Line No.")
                    {
                    }

                    trigger OnPreDataItem()
                    begin
                        SetFilter("Line No.", '>=%1', EndLineNo);
                    end;
                }
                dataitem(VATCounter; "Integer")
                {
                    DataItemTableView = SORTING(Number);
                    column(VATAmountLine__Amount_Including_VAT_; VATAmountLine."Amount Including VAT")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VATAmountLine__VAT_Amount_; VATAmountLine."VAT Amount")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VATAmountLine__VAT_Base_; VATAmountLine."VAT Base")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VATAmountLine__Amount_Including_VAT__Control70; VATAmountLine."Amount Including VAT")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VATAmountLine__VAT_Amount__Control71; VATAmountLine."VAT Amount")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VATAmountLine__VAT_Base__Control72; VATAmountLine."VAT Base")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VATAmountLine__VAT___; VATAmountLine."VAT %")
                    {
                    }
                    column(VATAmountLine__Amount_Including_VAT__Control78; VATAmountLine."Amount Including VAT")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VATAmountLine__VAT_Amount__Control79; VATAmountLine."VAT Amount")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VATAmountLine__VAT_Base__Control80; VATAmountLine."VAT Base")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VATAmountLine__VAT_Amount__Control82; VATAmountLine."VAT Amount")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VATAmountLine__VAT_Base__Control83; VATAmountLine."VAT Base")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VATAmountLine__Amount_Including_VAT__Control85; VATAmountLine."Amount Including VAT")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VATAmountLine__Amount_Including_VAT__Control70Caption; VATAmountLine__Amount_Including_VAT__Control70CaptionLbl)
                    {
                    }
                    column(VATAmountLine__VAT_Amount__Control71Caption; VATAmountLine__VAT_Amount__Control71CaptionLbl)
                    {
                    }
                    column(VATAmountLine__VAT_Base__Control72Caption; VATAmountLine__VAT_Base__Control72CaptionLbl)
                    {
                    }
                    column(VATAmountLine__VAT___Caption; VATAmountLine__VAT___CaptionLbl)
                    {
                    }
                    column(VAT_Amount_SpecificationCaption; VAT_Amount_SpecificationCaptionLbl)
                    {
                    }
                    column(VATAmountLine__VAT_Base_Caption; VATAmountLine__VAT_Base_CaptionLbl)
                    {
                    }
                    column(VATAmountLine__VAT_Base__Control80Caption; VATAmountLine__VAT_Base__Control80CaptionLbl)
                    {
                    }
                    column(VATAmountLine__VAT_Base__Control83Caption; VATAmountLine__VAT_Base__Control83CaptionLbl)
                    {
                    }
                    column(VATCounter_Number; Number)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        VATAmountLine.GetLine(Number);
                    end;

                    trigger OnPreDataItem()
                    begin
                        if "Issued Reminder Line"."VAT Amount" = 0 then
                            CurrReport.Break;
                        SetRange(Number, 1, VATAmountLine.Count);

                    end;
                }
                dataitem(EmptyLines; "Integer")
                {
                    DataItemTableView = SORTING(Number);

                    trigger OnPreDataItem()
                    begin
                        EmptyLines.SetRange(Number, 1, (IntNombreLignesDernièrePage_g - IntNombreLignesDéjàImprimées_g));
                    end;
                }
                dataitem(Footer; "Integer")
                {
                    DataItemTableView = SORTING(Number);
                    MaxIteration = 1;
                    column(Text002_______FORMAT_CurrReport_PAGENO_; Text002 + ' 1')
                    {
                    }
                    column(Footer_Number; Number)
                    {
                    }
                }
            }

            trigger OnAfterGetRecord()
            var
                RecReminderLine_l: Record "Issued Reminder Line";
            begin
                getMailBody();
                //--> ABYSS GN 20070405
                DecTotalCumule_g := 0;
                DecTotalCumulDue_g := 0;
                DecTotalCumulNotDue_g := 0;
                BoolDisplayNotDue_g := false;
                //<-- ABYSS GN 20070405

                //--> GN CER1 (16/03/2006)
                // Compteur les ligne relance pour la gestion du saut de page
                RecReminderLine_l.SetRange("Reminder No.", "Issued Reminder Header"."No.");
                RecReminderLine_l.SetFilter(Type, '<> %1', RecReminderLine_l.Type::" ");
                IntNbRememberLine_g := RecReminderLine_l.Count;
                //MESSAGE('%1',IntNbRememberLine_g);
                //<-- GN CER1 (16/03/2006)

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

                if "Issued Reminder Header"."Country/Region Code" = '' then
                    CodePays_l := CompanyInfo."Country/Region Code"
                else
                    CodePays_l := "Issued Reminder Header"."Country/Region Code";

                if RecCountry_g.Get(CodePays_l) then begin
                    if (RecCountry_g."Bank Code 1" = '') and (RecCountry_g."Bank Code 2" = '') then
                        Error(Text60000, RecCountry_g.Name);

                    //-- Banque 1
                    if RecCountry_g."Bank Code 1" <> '' then begin
                        RecBankAccount_g.Get(RecCountry_g."Bank Code 1");
                        TxtBankName1_g := 'BIC : ' + RecBankAccount_g."SWIFT Code";
                        LabBic1_g := 'IBAN :';
                        TxtBic1_g := RecBankAccount_g.IBAN;
                        LabNum1_g := 'N°';
                        TxtNum1_g := RecBankAccount_g."Bank Account No.";
                    end;
                    //-- Banque 2
                    if RecCountry_g."Bank Code 2" <> '' then begin
                        RecBankAccount_g.Get(RecCountry_g."Bank Code 2");
                        TxtBankName2_g := 'BIC : ' + RecBankAccount_g."SWIFT Code";
                        LabBic2_g := 'IBAN :';
                        TxtBic2_g := RecBankAccount_g.IBAN;
                        LabNum2_g := 'N°';
                        TxtNum2_g := RecBankAccount_g."Bank Account No.";
                    end;

                end;


                CurrReport.Language := CuLanguage.GetLanguageIdOrDefault("Language Code");

                if RecCustomer.Get("Issued Reminder Header"."Customer No.") then begin
                    WFax := 'Fax : ' + RecCustomer."Fax No.";
                    WEmail := 'E-mail : ' + RecCustomer."E-Mail";
                end;
                FormatAddrCodeunit.Customer(CustAddr, RecCustomer);
                if "Your Reference" = '' then
                    ReferenceText := ''
                else
                    ReferenceText := FieldCaption("Your Reference");
                if "VAT Registration No." = '' then
                    VATNoText := ''
                else
                    VATNoText := FieldCaption("VAT Registration No.");
                if "Currency Code" = '' then begin
                    GLSetup.TestField("LCY Code");
                    TotalText := StrSubstNo(Text000, GLSetup."LCY Code");
                    TotalInclVATText := StrSubstNo(Text001, GLSetup."LCY Code");
                end else begin
                    TotalText := StrSubstNo(Text000, "Currency Code");
                    TotalInclVATText := StrSubstNo(Text001, "Currency Code");
                end;

                TxtLRAR := '';
                TxtPhoneNo := CompanyInfo."Phone No.";
                case "Reminder Level" of
                    1:
                        gtxt_remindertext := Text1000000000;
                    2:
                        gtxt_remindertext := Text1000000001;
                    else begin
                        gtxt_remindertext := Text1000000002;
                        TxtLRAR := TEXT1000000013;
                    end
                end;

                if not CurrReport.Preview then begin
                    IncrNoPrinted;
                end;

                WFax := '';
                WEmail := '';
                RecSalesSetup.Get;

                RecContBusRel.Reset;
                RecContBusRel.SetCurrentKey("Link to Table", "No.");
                RecContBusRel.SetRange("Link to Table", RecContBusRel."Link to Table"::Customer);
                RecContBusRel.SetRange("No.", "Issued Reminder Header"."Customer No.");
                if RecContBusRel.Find('-') then begin
                    RecContact.SetRange("Company No.", RecContBusRel."Contact No.");
                    if RecContact.Find('-') then begin
                        repeat
                            if RecContact."Organizational Level Code" = RecSalesSetup."Organizational Level Code" then begin
                                if RecContact."Fax No." <> '' then
                                    WFax := 'Fax : ' + RecContact."Fax No.";
                                if RecContact."E-Mail" <> '' then
                                    WEmail := 'E-mail : ' + RecContact."E-Mail";
                            end;
                        until RecContact.Next = 0;
                    end;
                end;
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
    begin
        GLSetup.Get;
        CompanyInfo.Get;
        CompanyInfo.CalcFields(CompanyInfo.Picture);
        FormatAddrCodeunit.Company(CompanyAddr, CompanyInfo);

        //60 lignes par pages, moins les 7 lignes du pied : 53 lignes disponibles
        IntNombreLignesDernièrePage_g := 65;
    end;

    var
        Text000: Label 'Total %1';
        Text001: Label 'Total %1 Incl. VAT';
        Text002: Label 'Page';
        GLSetup: Record "General Ledger Setup";
        CompanyInfo: Record "Company Information";
        VATAmountLine: Record "VAT Amount Line" temporary;
        CuLanguage: Codeunit Language;
        FormatAddrCodeunit: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        CustAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        VATNoText: Text[30];
        ReferenceText: Text[30];
        TotalText: Text[50];
        TotalInclVATText: Text[50];
        DimText: Text[120];
        OldDimText: Text[75];
        gtxt_dL1: Text[250];
        gtxt_dL2: Text[250];
        gtxt_dL3: Text[250];
        gtxt_remindertext: Text[30];
        ReminderInterestAmount: Decimal;
        StartLineNo: Integer;
        EndLineNo: Integer;
        Continue: Boolean;
        ShowInternalInfo: Boolean;
        LogInteraction: Boolean;
        Text50000: Label 'After control in ous books, we note the invoices remain unpaid.';
        Text50001: Label 'Could you please check above statement on your side and settle the outstanding invoices as soon as possible.';
        Text50002: Label 'Should your payment been effected in the meanwhile, please consider our reminder as nil and void.';
        Text1000000000: Label 'Reminder';
        Text1000000001: Label 'Ultimate Reminder';
        Text1000000002: Label 'Ultimate Reminder';
        TxtLRAR: Text[50];
        TEXT1000000013: Label 'Letter registered with acknowledgement of delivery';
        TxtPhoneNo: Text[30];
        "IntNombreLignesDéjàImprimées_g": Integer;
        "IntNombreLignesDernièrePage_g": Integer;
        IntNbRememberLine_g: Integer;
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
        "*** ABSYS GN 20070409 ***": Integer;
        DecTotalCumule_g: Decimal;
        DecTotalCumulDue_g: Decimal;
        DecTotalCumulNotDue_g: Decimal;
        BoolDisplayNotDue_g: Boolean;
        Text55000: Label 'Total Due Amount';
        Text55001: Label 'Total Amounts Not Due';
        RecCustomer: Record Customer;
        RecContact: Record Contact;
        WFax: Text[150];
        WEmail: Text[150];
        RecContBusRel: Record "Contact Business Relation";
        RecSalesSetup: Record "Sales & Receivables Setup";
        LineType: Integer;
        "PRODUZENT_VON_GEKOCHTEM_GEFLÜGELFLEISCHCaptionLbl": Label 'MANUFACTURER OF COOKED POULTRY-MEAT';
        Bank___CaptionLbl: Label 'Banks :';
        TEL___CaptionLbl: Label 'TEL. :';
        FAX__CaptionLbl: Label 'FAX :';
        E_mail__CaptionLbl: Label 'E-mail :';
        MwStCaptionLbl: Label 'VAT';
        Issued_Reminder_Header___No__CaptionLbl: Label 'Reminder No.';
        DateCaptionLbl: Label 'Date';
        ErinnernCaptionLbl: Label 'To Remind';
        Customer_codeCaptionLbl: Label 'Customer code';
        MwSt__nrCaptionLbl: Label 'VAT no.';
        Bank___Caption_Control1000000053Lbl: Label 'Banks :';
        "PRODUZENT_VON_GEKOCHTEM_GEFLÜGELFLEISCHCaption_Control1000000054Lbl": Label 'MANUFACTURER OF COOKED POULTRY-MEAT';
        TEL___Caption_Control1000000067Lbl: Label 'TEL. :';
        FAX__Caption_Control1000000086Lbl: Label 'FAX :';
        E_mail__Caption_Control1000000090Lbl: Label 'E-mail :';
        MwStCaption_Control1000000098Lbl: Label 'VAT';
        Header_DimensionsCaptionLbl: Label 'Header Dimensions';
        Belegnr_CaptionLbl: Label 'Document No.';
        "FälligkeitsdatumCaptionLbl": Label 'Due Date';
        Issued_Reminder_Line__Remaining_Amount_CaptionLbl: Label 'Due amount';
        Added_amount_CaptionLbl: Label 'Added amount ';
        Issued_Reminder_Line__Remaining_Amount_Caption_Control1000000035Lbl: Label 'Due amount';
        "FälligkeitsdatumCaption_Control1000000037Lbl": Label 'Due Date';
        Belegnr_Caption_Control1000000038Lbl: Label 'Document No.';
        BelegartCaptionLbl: Label 'Document Type';
        Added_amount_Caption_Control1000000014Lbl: Label 'Added amount ';
        ReminderInterestAmountCaptionLbl: Label 'Interest Amount';
        VATAmountLine__Amount_Including_VAT__Control70CaptionLbl: Label 'Amount Including VAT';
        VATAmountLine__VAT_Amount__Control71CaptionLbl: Label 'VAT Amount';
        VATAmountLine__VAT_Base__Control72CaptionLbl: Label 'VAT Base';
        VATAmountLine__VAT___CaptionLbl: Label 'VAT %';
        VAT_Amount_SpecificationCaptionLbl: Label 'VAT Amount Specification';
        VATAmountLine__VAT_Base_CaptionLbl: Label 'Continued';
        VATAmountLine__VAT_Base__Control80CaptionLbl: Label 'Continued';
        VATAmountLine__VAT_Base__Control83CaptionLbl: Label 'Total';
        Body: Text;

    local procedure getMailBody()
    var
        CRLF: Text[4];
    begin
        CRLF[1] := 13;

        Body := _GetBody("Issued Reminder Header"."Language Code");
        Body += _GetSignature('COMPTA');
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
        Sign := Sign + Emp."Company E-Mail" + CRLF;
        Sign := Sign + 'www.europacuisson.com' + CRLF;
    end;
}

