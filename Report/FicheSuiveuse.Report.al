report 50021 "Fiche Suiveuse"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/FicheSuiveuse.rdlc';
    Caption = 'Prod. Order - Job Card';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Production Order"; "Production Order")
        {

            RequestFilterFields = Status, "No.", "Source Type", "Source No.", "Starting Date";
            column(LotNo; LotNo)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(StartingDate_ProductionOrder; "Production Order"."Starting Date")
            {
            }
            column(USERID; UserId)
            {
            }
            column(CurrReport_PAGENO; 1)
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(STRSUBSTNO_TEXT0001__No___; StrSubstNo(TEXT0001, "No."))
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Production_Order_Status; Status)
            {
            }
            column(Nbremalaxage_ProductionOrder; "Production Order"."Nbre malaxage")
            {
            }
            column(Ordre_ProductionOrder; "Production Order".Ordre)
            {
            }
            column(Production_Order_No_; "No.")
            {
            }
            dataitem("Prod. Order Comment Line"; "Prod. Order Comment Line")
            {
                DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("No.");
                column(Prod__Order_Comment_Line__Prod__Order_Comment_Line__Comment; "Prod. Order Comment Line".Comment)
                {
                }
                column(Prod__Order_Comment_Line_Status; Status)
                {
                }
                column(Prod__Order_Comment_Line_Prod__Order_No_; "Prod. Order No.")
                {
                }
                column(Prod__Order_Comment_Line_Line_No_; "Line No.")
                {
                }
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            }
            dataitem("Prod. Order Line"; "Prod. Order Line")
            {
                DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("No.");
                column(Prod__Order_Line__Item_No__; "Item No.")
                {
                }
                column(Prod__Order_Line_Description; Description)
                {
                }
                column(STRSUBSTNO_TEXT0002__Prod__Order_Line__Quantity__Unit_of_Measure_Code__; StrSubstNo(TEXT0002, "Prod. Order Line".Quantity, "Unit of Measure Code"))
                {
                }
                column(TxtDecoupe_g; TxtDecoupe_g)
                {
                }
                column(TxtProduit_g; TxtProduit_g)
                {
                }
                column(TxtEpice_g; TxtEpice_g)
                {
                }
                column(TxtOrigine_g; TxtOrigine_g)
                {
                }
                column(TxtConditionnement_g; TxtConditionnement_g)
                {
                }
                column(Prod__Order_Line__Line_No__; "Line No.")
                {
                }
                column(Quantity_used_during_work__Posted_with_the_Sales_Order_Caption; Quantity_used_during_work__Posted_with_the_Sales_Order_CaptionLbl)
                {
                }
                column(ArticleCaption; ArticleCaptionLbl)
                {
                }
                column("DésignationCaption"; DésignationCaptionLbl)
                {
                }
                column(ProduitCaption; ProduitCaptionLbl)
                {
                }
                column("DécoupeCaption"; DécoupeCaptionLbl)
                {
                }
                column(EpiceCaption; EpiceCaptionLbl)
                {
                }
                column(OrigineCaption; OrigineCaptionLbl)
                {
                }
                column(Condit_Caption; Condit_CaptionLbl)
                {
                }
                column("QuantitéCaption"; QuantitéCaptionLbl)
                {
                }
                column(Prod__Order_Line_Status; Status)
                {
                }
                column(Prod__Order_Line_Prod__Order_No_; "Prod. Order No.")
                {
                }
                column(Prod__Order_Line_Routing_No_; "Routing No.")
                {
                }
                column(Prod__Order_Line_Routing_Reference_No_; "Routing Reference No.")
                {
                }
                column(Allergene; Allerg)
                {
                }
                dataitem("Prod. Order Comment Line_Tiers"; "Prod. Order Comment Line")
                {
                    DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("No.");
                    DataItemLinkReference = "Production Order";
                    column(Prod__Order_Comment_Line_Tiers_Comment; Comment)
                    {
                    }
                    column(Prod__Order_Comment_Line_Tiers_Status; Status)
                    {
                    }
                    column(Prod__Order_Comment_Line_Tiers_Prod__Order_No_; "Prod. Order No.")
                    {
                    }
                    column(Prod__Order_Comment_Line_Tiers_Line_No_; "Line No.")
                    {
                    }
                }
                dataitem("Comment Line"; "Comment Line")
                {
                    DataItemLink = "No." = FIELD("Item No.");
                    DataItemTableView = SORTING("Table Name", "No.", "Line No.") ORDER(Ascending) WHERE("Table Name" = CONST(Item));
                    column(Comment_Line__Comment_Line__Comment; "Comment Line".Comment)
                    {
                    }
                    column(Comment_Line_Table_Name; "Table Name")
                    {
                    }
                    column(Comment_Line_No_; "No.")
                    {
                    }
                    column(Comment_Line_Line_No_; "Line No.")
                    {
                    }
                }
                dataitem(ProcessTxt; "Integer")
                {
                    column(ProcessDescr; ProcessTmp."Process Description")
                    {
                    }
                    column(ProcessValue; ProcessTmp.Valeur)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if ProcessTxt.Number = 1 then
                            ProcessTmp.FindFirst
                        else
                            ProcessTmp.Next;
                        ProcessTmp.CalcFields("Process Description");
                    end;

                    trigger OnPreDataItem()
                    begin
                        ProcessTmp.Reset;
                        ProcessTxt.SetRange(Number, 1, ProcessTmp.Count);
                    end;
                }
                dataitem("Prod. Order Component"; "Prod. Order Component")
                {
                    DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("Prod. Order No."), "Prod. Order Line No." = FIELD("Line No.");
                    DataItemTableView = SORTING(Status, "Prod. Order No.", "Prod. Order Line No.", "Line No.");
                    column(Prod__Order_Component__Item_No__; "Item No.")
                    {
                    }
                    column(Prod__Order_Component_Description; Description)
                    {
                    }
                    column(STRSUBSTNO_TEXT0002__Expected_Quantity___Prod__Order_Component___Unit_of_Measure_Code__; QtyCompoTxt)
                    {
                    }
                    column(TxtProduit_g_Control1000000051; TxtProduit_g)
                    {
                    }
                    column(TxtDecoupe_g_Control1000000053; TxtDecoupe_g)
                    {
                    }
                    column(TxtEpice_g_Control1000000055; TxtEpice_g)
                    {
                    }
                    column(TxtOrigine_g_Control1000000057; TxtOrigine_g)
                    {
                    }
                    column(TxtConditionnement_g_Control1000000059; TxtConditionnement_g)
                    {
                    }
                    column(TxtAllergene; TxtAllergene)
                    {
                    }
                    column(Prod__Order_Component__Line_No__; "Line No.")
                    {
                    }
                    column("Quantité_ProduiteCaption"; Quantité_ProduiteCaptionLbl)
                    {
                    }
                    column(No_Caption; No_CaptionLbl)
                    {
                    }
                    column(Charge_NoCaption; Charge_NoCaptionLbl)
                    {
                    }
                    column(QuantityCaption; QuantityCaptionLbl)
                    {
                    }
                    column(Unit_of_MeasureCaption; Unit_of_MeasureCaptionLbl)
                    {
                    }
                    column("Matières_mises_en_oeuvre__Caption"; Matières_mises_en_oeuvre__CaptionLbl)
                    {
                    }
                    column(ArticleCaption_Control1000000095; ArticleCaption_Control1000000095Lbl)
                    {
                    }
                    column("DésignationCaption_Control1000000098"; DésignationCaption_Control1000000098Lbl)
                    {
                    }
                    column(ProduitCaption_Control1000000100; ProduitCaption_Control1000000100Lbl)
                    {
                    }
                    column("DécoupeCaption_Control1000000102"; DécoupeCaption_Control1000000102Lbl)
                    {
                    }
                    column(EpiceCaption_Control1000000104; EpiceCaption_Control1000000104Lbl)
                    {
                    }
                    column(OrigineCaption_Control1000000106; OrigineCaption_Control1000000106Lbl)
                    {
                    }
                    column(Condit_Caption_Control1000000108; Condit_Caption_Control1000000108Lbl)
                    {
                    }
                    column("QuantitéCaption_Control1000000109"; QuantitéCaption_Control1000000109Lbl)
                    {
                    }
                    column("Quantité_UtiliséeCaption"; Quantité_UtiliséeCaptionLbl)
                    {
                    }
                    column(No_Caption_Control1000000078; No_Caption_Control1000000078Lbl)
                    {
                    }
                    column(Charge_NoCaption_Control1000000082; Charge_NoCaption_Control1000000082Lbl)
                    {
                    }
                    column(QuantityCaption_Control1000000090; QuantityCaption_Control1000000090Lbl)
                    {
                    }
                    column(Unit_of_MeasureCaption_Control1000000093; Unit_of_MeasureCaption_Control1000000093Lbl)
                    {
                    }
                    column(Prod__Order_Component_Status; Status)
                    {
                    }
                    column(Prod__Order_Component_Prod__Order_No_; "Prod. Order No.")
                    {
                    }
                    column(Prod__Order_Component_Prod__Order_Line_No_; "Prod. Order Line No.")
                    {
                    }
                    column(QtyMalax; QtyMalax)
                    {
                    }
                    column(Position_ProdOrderComponent; "Prod. Order Component".Position)
                    {
                    }

                    trigger OnAfterGetRecord()
                    var
                        RecCode_l: Record "Code";
                    begin
                        if "Item No." <> '' then rItem.Get("Item No.");

                        //--> ABSYS GN 20061219
                        RecItemCrossRef_g.Reset;
                        RecItemCrossRef_g.Init;
                        Clear(TxtProduit_g);
                        Clear(TxtDecoupe_g);
                        Clear(TxtEpice_g);
                        Clear(TxtOrigine_g);
                        Clear(TxtConditionnement_g);

                        if ("Item No." <> '') then begin
                            // -- Info Stat --
                            if RecCode_l.Get(27, rItem.FieldNo(rItem."Criteria 1"), rItem."Criteria 1") then
                                TxtProduit_g := RecCode_l.Description;

                            if RecCode_l.Get(27, rItem.FieldNo(rItem."Criteria 2"), rItem."Criteria 2") then
                                TxtDecoupe_g := RecCode_l.Description;

                            if RecCode_l.Get(27, rItem.FieldNo(rItem."Criteria 3"), rItem."Criteria 3") then
                                TxtEpice_g := RecCode_l.Description;

                            TxtOrigine_g := rItem."Criteria 4";

                            if RecCode_l.Get(27, rItem.FieldNo(rItem."Criteria 5"), rItem."Criteria 5") then
                                TxtConditionnement_g := RecCode_l.Description;
                            TxtAllergene := Format(rItem."Niveau allergene");
                        end;

                        //<-- ABSYS GN 20061219

                        if "Production Order"."Nbre malaxage" > 0 then begin
                            QtyMalax := Round("Prod. Order Component"."Expected Qty. (Base)" / "Production Order"."Nbre malaxage" / (1 + "Prod. Order Component"."Scrap %" / 100), 0.01);
                            if QtyMalax > 1100 then
                                Message('Quantité par mélange > 1100 Kg');
                        end;

                        QtyCompoTxt := StrSubstNo(TEXT0002, Round("Expected Quantity" / (1 + "Prod. Order Component"."Scrap %" / 100), 0.01), "Prod. Order Component"."Unit of Measure Code");
                        //QtyCompoTxt  := STRSUBSTNO(TEXT0002,ROUND("Expected Quantity",0.01),"Prod. Order Component"."Unit of Measure Code");
                    end;

                    trigger OnPostDataItem()
                    begin
                        InComponent := false;
                    end;

                    trigger OnPreDataItem()
                    begin
                        InComponent := true;
                    end;
                }
                dataitem("Prod. Order Routing Line"; "Prod. Order Routing Line")
                {
                    DataItemLink = "Prod. Order No." = FIELD("Prod. Order No."), "Routing No." = FIELD("Routing No."), "Routing Reference No." = FIELD("Routing Reference No."), Status = FIELD(Status);
                    column(Prod__Order_Routing_Line_Description; Description)
                    {
                    }
                    column("Temps_passéCaption"; Temps_passéCaptionLbl)
                    {
                    }
                    column(Unit_of_MeasureCaption_Control1000000085; Unit_of_MeasureCaption_Control1000000085Lbl)
                    {
                    }
                    column(Unit_of_MeasureCaption_Control1000000086; Unit_of_MeasureCaption_Control1000000086Lbl)
                    {
                    }
                    column(Unit_of_MeasureCaption_Control1000000087; Unit_of_MeasureCaption_Control1000000087Lbl)
                    {
                    }
                    column(Unit_of_MeasureCaption_Control1000000088; Unit_of_MeasureCaption_Control1000000088Lbl)
                    {
                    }
                    column(Prod__Order_Routing_Line_Status; Status)
                    {
                    }
                    column(Prod__Order_Routing_Line_Prod__Order_No_; "Prod. Order No.")
                    {
                    }
                    column(Prod__Order_Routing_Line_Routing_Reference_No_; "Routing Reference No.")
                    {
                    }
                    column(Prod__Order_Routing_Line_Routing_No_; "Routing No.")
                    {
                    }
                    column(Prod__Order_Routing_Line_Operation_No_; "Operation No.")
                    {
                    }
                }
                dataitem("Sales Line"; "Sales Line")
                {
                    DataItemLink = "No." = FIELD("Item No."), "Date de production" = FIELD("Starting Date");
                    column(DocumentNo_SalesLine; "Sales Line"."Document No.")
                    {
                    }
                    column(QuantityBase_SalesLine; "Sales Line"."Quantity (Base)")
                    {
                    }
                }

                trigger OnAfterGetRecord()
                var
                    RecCode_l: Record "Code";
                    Process: Record ProcessOF;
                begin

                    if "Item No." <> '' then rItem.Get("Item No.");
                    PaletExp := '';
                    if rItem.TypePalette = 'FUMI' then
                        PaletExp := 'FUMIGENEE';
                    if rItem.PoidsPalette > 0 then begin
                        ProcessTmp.Init;
                        ProcessTmp.Process := 'POIDSPAL';
                        ProcessTmp.Valeur := Format(rItem.PoidsPalette);
                        ProcessTmp.Insert;
                    end;
                    if rItem."Criteria 2" <> '' then begin
                        rItem.CalcFields("Criteria 2 Desc");
                        ProcessTmp.Init;
                        ProcessTmp.Process := 'DECOUPE';
                        ProcessTmp.Valeur := rItem."Criteria 2 Desc";
                        ProcessTmp.Insert;
                    end;
                    if (StrPos(rItem."No.", '1-') > 0) and (rItem.Process <> '') then begin
                        ProcessTmp.Init;
                        ProcessTmp.Process := 'MACHINESDECOUPE';
                        ProcessTmp.Valeur := rItem.Process;
                        ProcessTmp.Insert;
                    end;

                    if (StrPos(rItem."No.", '5-FSV') > 0) then begin
                        ProcessTmp.Init;
                        ProcessTmp.Process := 'TYPEFILM';
                        ProcessTmp.Valeur := rItem."Criteria 12";
                        ProcessTmp.Insert;
                        ProcessTmp.Init;
                        ProcessTmp.Process := 'PASTEURISATION';
                        ProcessTmp.Valeur := rItem.Pasteurisation;
                        ProcessTmp.Insert;
                        ProcessTmp.Init;
                        ProcessTmp.Process := 'VIANDESAC';
                        ProcessTmp.Valeur := rItem."Quantité par sac";
                        ProcessTmp.Insert;
                        ProcessTmp.Init;
                        ProcessTmp.Process := 'DLC';
                        ProcessTmp.Valeur := Format(CalcDate(rItem.FormuleDLC, "Prod. Order Line"."Starting Date"));
                        ProcessTmp.Insert;
                        ProcessTmp.Init;
                        ProcessTmp.Process := 'THT';
                        ProcessTmp.Valeur := Format(CalcDate(rItem.THT, "Prod. Order Line"."Starting Date"));
                        if Format(rItem.THT) <> '' then ProcessTmp.Insert;
                        ProcessTmp.Init;
                        ProcessTmp.Process := 'MACHINESDECOUPE';
                        ProcessTmp.Valeur := rItem.Process;
                        ProcessTmp.Insert;

                    end;
                    //--> ABSYS GN 20061219
                    RecItemCrossRef_g.Reset;
                    RecItemCrossRef_g.Init;
                    Clear(TxtProduit_g);
                    Clear(TxtDecoupe_g);
                    Clear(TxtEpice_g);
                    Clear(TxtOrigine_g);
                    Clear(TxtConditionnement_g);

                    if ("Item No." <> '') then begin
                        // -- Info Stat --
                        if RecCode_l.Get(27, rItem.FieldNo(rItem."Criteria 1"), rItem."Criteria 1") then
                            TxtProduit_g := RecCode_l.Description;

                        if RecCode_l.Get(27, rItem.FieldNo(rItem."Criteria 16"), rItem."Criteria 16") then
                            TxtDecoupe_g := RecCode_l.Description;
                        if RecCode_l.Get(27, rItem.FieldNo(rItem."Criteria 2"), rItem."Criteria 2") then
                            TxtDecoupe_g := TxtDecoupe_g + ' ' + RecCode_l.Description;

                        if RecCode_l.Get(27, rItem.FieldNo(rItem."Criteria 3"), rItem."Criteria 3") then
                            TxtEpice_g := RecCode_l.Description;

                        TxtOrigine_g := rItem."Criteria 4";

                        if RecCode_l.Get(27, rItem.FieldNo(rItem."Criteria 5"), rItem."Criteria 5") then
                            TxtConditionnement_g := RecCode_l.Description;
                        if PaletExp <> '' then
                            TxtConditionnement_g := PaletExp + TxtConditionnement_g;
                        Allerg := rItem."Niveau allergene";
                    end;

                    ProdBOM.Get("Prod. Order Line"."Production BOM No.");
                    //<-- ABSYS GN 20061219
                    Process.Reset;
                    Process.SetRange("Production BOM No", "Prod. Order Line"."Production BOM No.");
                    Process.SetRange("BOM Version", "Prod. Order Line"."Production BOM Version Code");
                    if Process.FindSet then
                        repeat
                            ProcessTmp.Reset;
                            ProcessTmp.Init;
                            ProcessTmp.TransferFields(Process, true);
                            ProcessTmp.Insert;
                        until Process.Next = 0;
                end;

                trigger OnPreDataItem()
                var
                    Process: Record ProcessOF;
                begin
                end;
            }

            trigger OnAfterGetRecord()
            var
                Utils: Codeunit Utils;
            begin
                ProcessTmp.Reset;
                ProcessTmp.DeleteAll;

                if RecStatSetup_g.Get then;
                LotNo := Format("Production Order"."Starting Date", 0, '<Year,2>') + Utils.PadLeft(Format(1 + ("Production Order"."Starting Date" - DMY2Date(1, 1, Date2DMY("Production Order"."Starting Date", 3)))), '0', 3);

                if "Production Order"."Nbre malaxage" > 0 then begin
                    ProcessTmp.Init;
                    ProcessTmp.Process := 'NBREMELANG';
                    ProcessTmp.Valeur := Format("Production Order"."Nbre malaxage");
                    ProcessTmp.Insert;

                end;
            end;

            trigger OnPreDataItem()
            begin
                ProdOrderFilter := GetFilters;
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

    var
        ProdOrderFilter: Text[250];
        InComponent: Boolean;
        TEXT0001: Label 'PO - Projectkaart %1';
        TxtProduit_g: Text[30];
        TxtDecoupe_g: Text[80];
        TxtEpice_g: Text[30];
        TxtOrigine_g: Text[30];
        TxtConditionnement_g: Text[30];
        TxtAllergene: Text[10];
        RecStatSetup_g: Record "Statistics setup";
        rItem: Record Item;
        ItemProduit: Text[30];
        ItemDecoupe: Text[30];
        ItemEpice: Text[30];
        RecItemCrossRef_g: Record "Item Reference";
        TEXT0002: Label '%1 %2';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Quantity_used_during_work__Posted_with_the_Sales_Order_CaptionLbl: Label 'Quantity used during work (Posted with the Sales Order)';
        ArticleCaptionLbl: Label 'Article';
        "DésignationCaptionLbl": Label 'Désignation';
        ProduitCaptionLbl: Label 'Produit';
        "DécoupeCaptionLbl": Label 'Découpe';
        EpiceCaptionLbl: Label 'Epice';
        OrigineCaptionLbl: Label 'Origine';
        Condit_CaptionLbl: Label 'Condit.';
        "QuantitéCaptionLbl": Label 'Quantité';
        "Quantité_ProduiteCaptionLbl": Label 'Quantité Produite';
        No_CaptionLbl: Label 'No.';
        Charge_NoCaptionLbl: Label 'Lot No';
        QuantityCaptionLbl: Label 'Quantity';
        Unit_of_MeasureCaptionLbl: Label 'Unit of Measure';
        "Matières_mises_en_oeuvre__CaptionLbl": Label 'Matières mises en oeuvre :';
        ArticleCaption_Control1000000095Lbl: Label 'Article';
        "DésignationCaption_Control1000000098Lbl": Label 'Désignation';
        ProduitCaption_Control1000000100Lbl: Label 'Produit';
        "DécoupeCaption_Control1000000102Lbl": Label 'Découpe';
        EpiceCaption_Control1000000104Lbl: Label 'Epice';
        OrigineCaption_Control1000000106Lbl: Label 'Origine';
        Condit_Caption_Control1000000108Lbl: Label 'Condit.';
        "QuantitéCaption_Control1000000109Lbl": Label 'Quantité';
        "Quantité_UtiliséeCaptionLbl": Label 'Quantité Utilisée';
        No_Caption_Control1000000078Lbl: Label 'No.';
        Charge_NoCaption_Control1000000082Lbl: Label 'Lot No';
        QuantityCaption_Control1000000090Lbl: Label 'Quantity';
        Unit_of_MeasureCaption_Control1000000093Lbl: Label 'Unit of Measure';
        "Temps_passéCaptionLbl": Label 'Temps passé';
        Unit_of_MeasureCaption_Control1000000085Lbl: Label 'Unit of Measure';
        Unit_of_MeasureCaption_Control1000000086Lbl: Label 'Unit of Measure';
        Unit_of_MeasureCaption_Control1000000087Lbl: Label 'Unit of Measure';
        Unit_of_MeasureCaption_Control1000000088Lbl: Label 'Unit of Measure';
        PaletExp: Text;
        Allerg: Integer;
        ProdBOM: Record "Production BOM Header";
        ProcessTmp: Record ProcessOF temporary;
        LotNo: Code[20];
        QtyMalax: Decimal;
        QtyCompoTxt: Text;
}

