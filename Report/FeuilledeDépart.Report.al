report 50010 "Feuille de Départ"
{
    // //AB60408.V12 EBE 16/04/08
    //   - agrandissement du champ commentaire logistique text 30 -> text 80 (diminution de la police)
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/FeuilledeDépart.rdlc';

    Caption = 'Work Order';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Order));
            RequestFilterFields = "No.", "Sell-to Customer No.";
            RequestFilterHeading = 'Sales Order';
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(CurrReport_PAGENO; 1)
            {
            }
            column(Sales_Header__Sales_Header___No__; "Sales Header"."No.")
            {
            }
            column(Sales_Header__Promised_Delivery_Date_; "Promised Delivery Date")
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(Sales_Header__Ship_to_Name_; "Ship-to Name")
            {
            }
            column(Sales_Header__Ship_to_Address_; "Ship-to Address")
            {
            }
            column(Sales_Header__Ship_to_Address_2_; "Ship-to Address 2")
            {
            }
            column(Sales_Header__Ship_to_City_; "Ship-to City")
            {
            }
            column(Sales_Header__Logistic_unit_; "Logistic unit")
            {
            }
            column(Sales_Header__Ship_to_Post_Code_; "Ship-to Post Code")
            {
            }
            column(USERID; UserId)
            {
            }
            column(Sales_Header__Order_Date_; "Order Date")
            {
            }
            column(Sales_Header__Sell_to_Customer_No__; "Sell-to Customer No.")
            {
            }
            column(OrderType; OrderType)
            {
            }
            column(FORMAT_TODAY_0_4__Control3; Format(Today, 0, 4))
            {
            }
            column(CurrReport_PAGENO_Control4; 1)
            {
            }
            column(USERID_Control5; UserId)
            {
            }
            column(Sales_Header__Sales_Header___No___Control16; "Sales Header"."No.")
            {
            }
            column(Sales_Header__Promised_Delivery_Date__Control18; "Promised Delivery Date")
            {
            }
            column(COMPANYNAME_Control2; CompanyName)
            {
            }
            column(Sales_Header__Ship_to_Name__Control1000000001; "Ship-to Name")
            {
            }
            column(Sales_Header__Ship_to_Address__Control1000000003; "Ship-to Address")
            {
            }
            column(Sales_Header__Ship_to_Address_2__Control1000000005; "Ship-to Address 2")
            {
            }
            column(Sales_Header__Ship_to_City__Control1000000007; "Ship-to City")
            {
            }
            column(Sales_Header__Ship_to_Post_Code__Control1000000009; "Ship-to Post Code")
            {
            }
            column(Sales_Header__Logistic_unit__Control1000000011; "Logistic unit")
            {
            }
            column(Sales_Header__Order_Date__Control1000000078; "Order Date")
            {
            }
            column(Sales_Header__Sell_to_Customer_No___Control1000000034; "Sell-to Customer No.")
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Sales_Order_No_Caption; Sales_Order_No_CaptionLbl)
            {
            }
            column(Zugesagtes_LieferdatumCaption; Zugesagtes_LieferdatumCaptionLbl)
            {
            }
            column(B_102454_______________________KF_102454Caption; B_102454_______________________KF_102454CaptionLbl)
            {
            }
            column(Work_OrderCaption; Work_OrderCaptionLbl)
            {
            }
            column(Type_de_PaletteCaption; Type_de_PaletteCaptionLbl)
            {
            }
            column(Sales_Header__Order_Date_Caption; FieldCaption("Order Date"))
            {
            }
            column(Work_OrderCaption_Control1; Work_OrderCaption_Control1Lbl)
            {
            }
            column(CurrReport_PAGENO_Control4Caption; CurrReport_PAGENO_Control4CaptionLbl)
            {
            }
            column(Sales_Order_No_Caption_Control15; Sales_Order_No_Caption_Control15Lbl)
            {
            }
            column(Zugesagtes_LieferdatumCaption_Control17; Zugesagtes_LieferdatumCaption_Control17Lbl)
            {
            }
            column(B_102454______________________KF_102454Caption; B_102454______________________KF_102454CaptionLbl)
            {
            }
            column(Type_de_PaletteCaption_Control1000000012; Type_de_PaletteCaption_Control1000000012Lbl)
            {
            }
            column(Sales_Header__Order_Date__Control1000000078Caption; FieldCaption("Order Date"))
            {
            }
            column(Nombre_de_PalettesCaption; Nombre_de_PalettesCaptionLbl)
            {
            }
            column(Nombre_de_ColisCaption; Nombre_de_ColisCaptionLbl)
            {
            }
            column(Type_de_VidangesCaption; Type_de_VidangesCaptionLbl)
            {
            }
            column(Nombre_de_VidangesCaption; Nombre_de_VidangesCaptionLbl)
            {
            }
            column(Sales_Header_Document_Type; "Document Type")
            {
            }
            column(Sales_Header_Shipping_Agent_Code; "Shipping Agent Code")
            {
            }
            column(PaletExp; PaletExp)
            {
            }
            dataitem("Shipping Agent"; "Shipping Agent")
            {
                DataItemLink = Code = FIELD("Shipping Agent Code");
                column(Shipping_Agent_Name; Name)
                {
                }
                column(TransporteurCaption; TransporteurCaptionLbl)
                {
                }
                column(Shipping_Agent_Code; Code)
                {
                }
            }
            dataitem("Comment Line"; "Comment Line")
            {
                DataItemLink = "No." = FIELD("Sell-to Customer No.");
                DataItemTableView = SORTING("Table Name", "No.", "Line No.") WHERE("Table Name" = CONST(Customer));
                column(Comment_Line_Comment; Comment)
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
            dataitem(PageLoop; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                dataitem("Sales Line"; "Sales Line")
                {
                    DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                    DataItemLinkReference = "Sales Header";
                    DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");
                    column(rCust__Production_comment_; rCust."Production comment")
                    {
                    }
                    column(Sales_Line__No__; "No.")
                    {
                    }
                    column(rItem_Description; rItem.Description)
                    {
                    }
                    column(TxtProduit_g; TxtProduit_g)
                    {
                    }
                    column(TxtDecoupe_g; TxtDecoupe_g)
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
                    column(Sales_Line__Quantity__Base__; "Quantity (Base)")
                    {
                    }
                    column(Sales_Line__Base_Unit_; "Base Unit")
                    {
                    }
                    column(TypeLine; TypeLine)
                    {
                    }
                    column(RecItemCrossRef_g__Observation_Description_; RecItemCrossRef_g."Observation Description")
                    {
                    }
                    column(Quantity_used_during_work__Posted_with_the_Sales_Order_Caption; Quantity_used_during_work__Posted_with_the_Sales_Order_CaptionLbl)
                    {
                    }
                    column(Sales_Line__No__Caption; FieldCaption("No."))
                    {
                    }
                    column("DésignationCaption"; DésignationCaptionLbl)
                    {
                    }
                    column("QuantitéCaption"; QuantitéCaptionLbl)
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
                    column("UnitéCaption"; UnitéCaptionLbl)
                    {
                    }
                    column(BeobachtungCaption; BeobachtungCaptionLbl)
                    {
                    }
                    column(Sales_Line_Document_Type; "Document Type")
                    {
                    }
                    column(Sales_Line_Document_No_; "Document No.")
                    {
                    }
                    column(item5_No; "5_no")
                    {
                    }
                    column(item5_Desc; "5_Desc")
                    {
                    }
                    column(Sales_Line_Line_No_; "Line No.")
                    {
                    }

                    trigger OnAfterGetRecord()
                    var
                        RecCode_l: Record "Code";
                    begin
                        if PrintToExcel then
                            MakeWOLine;

                        ItemProduit := '';
                        ItemDecoupe := '';
                        ItemEpice := '';


                        if (Type = Type::Item) and ("No." <> '') then rItem.Get("No.");

                        //--> ABSYS GN 20061219
                        RecItemCrossRef_g.Reset;
                        RecItemCrossRef_g.Init;
                        Clear(TxtProduit_g);
                        Clear(TxtDecoupe_g);
                        Clear(TxtEpice_g);
                        Clear(TxtOrigine_g);
                        Clear(TxtConditionnement_g);

                        if (Type = Type::Item) and ("No." <> '') then begin
                            // -- Gestion des réf Extern Article --
                            RecItemCrossRef_g.SetRange("Item No.", "Sales Line"."No.");
                            RecItemCrossRef_g.SetRange("Reference Type", RecItemCrossRef_g."Reference Type"::Customer);
                            RecItemCrossRef_g.SetRange("Reference Type No.", "Sales Header"."Sell-to Customer No.");
                            if RecItemCrossRef_g.Find('-') then;
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
                            "5_no" := '';
                            "5_Desc" := '';

                            BomL.Reset;
                            BomL.SetRange("Production BOM No.", rItem."Production BOM No.");
                            BomL.SetRange("Version Code", VersionMgt.GetBOMVersion(rItem."Production BOM No.", Today, true));
                            BomL.SetFilter("No.", '5*|4*');
                            if BomL.FindSet then
                                repeat
                                    "5_no" := "5_no" + BomL."No.";
                                    "5_Desc" := "5_Desc" + BomL.Description;
                                until BomL.Next = 0;

                        end;

                        //<-- ABSYS GN 20061219
                        TypeLine := "Sales Line".Type.AsInteger();
                    end;

                    trigger OnPostDataItem()
                    begin
                        if PrintToExcel and ("Sales Line".Count <> 0) then begin
                            ExcelBuf.EndRange;
                            ExcelBuf.CreateRange('WorkOrderLineRange');
                        end
                    end;

                    trigger OnPreDataItem()
                    begin
                        if PrintToExcel then
                            MakeWOLineHeader;
                    end;
                }
                dataitem("Sales Comment Line"; "Sales Comment Line")
                {
                    DataItemLink = "Document Type" = FIELD("Document Type"), "No." = FIELD("No.");
                    DataItemLinkReference = "Sales Header";
                    DataItemTableView = SORTING("Document Type", "No.", "Line No.");
                    column(Sales_Comment_Line_Date; Date)
                    {
                    }
                    column(Sales_Comment_Line_Code; Code)
                    {
                    }
                    column(Sales_Comment_Line_Comment; Comment)
                    {
                    }
                    column(CommentsCaption; CommentsCaptionLbl)
                    {
                    }
                    column(Sales_Comment_Line_DateCaption; FieldCaption(Date))
                    {
                    }
                    column(Sales_Comment_Line_CodeCaption; FieldCaption(Code))
                    {
                    }
                    column(Sales_Comment_Line_CommentCaption; FieldCaption(Comment))
                    {
                    }
                    column(Sales_Comment_Line_Document_Type; "Document Type")
                    {
                    }
                    column(Sales_Comment_Line_No_; "No.")
                    {
                    }
                    column(Sales_Comment_Line_Document_Line_No_; "Document Line No.")
                    {
                    }
                    column(Sales_Comment_Line_Line_No_; "Line No.")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if PrintToExcel then
                            MakeWOCommentLine;
                    end;

                    trigger OnPostDataItem()
                    begin
                        if PrintToExcel and ("Sales Comment Line".Count <> 0) then begin
                            ExcelBuf.EndRange;
                            ExcelBuf.CreateRange('WorkOrderCommentLineRange');
                        end
                    end;

                    trigger OnPreDataItem()
                    begin
                        if PrintToExcel then
                            MakeWOCommentLineHeader;
                    end;
                }
                dataitem("Extra Lines"; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
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
                    column(Extra_Item_Resource_used_during_work__Posted_with_Item_or_Resource_Journals_Caption; Extra_Item_Resource_used_during_work__Posted_with_Item_or_Resource_Journals_CaptionLbl)
                    {
                    }
                    column(Extra_Lines_Number; Number)
                    {
                    }

                    trigger OnPostDataItem()
                    begin
                        if PrintToExcel and ("Sales Line".Count <> 0) then begin
                            ExcelBuf.EndRange;
                            ExcelBuf.CreateRange('WorkOrderExtraLineRange');

                            ExcelBuf.NewRow;
                            ExcelBuf.NewRow;
                            ExcelBuf.NewRow;
                            ExcelBuf.NewRow;
                        end;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if PrintToExcel then
                            MakeWOExtraLineHeader;
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                FormatAddr.SalesHeaderBillTo(CustAddr, "Sales Header");

                //IF PrintToExcel THEN
                //  MakeWOHeader;

                //--> ABSYS GN 20061219
                // -- Récupération Info Stat --
                if RecStatSetup_g.Get then;
                //<-- ABSYS GN 20061219


                if rCust.Get("Sell-to Customer No.") then;
                OrderType := "Sales Header"."Order type";
                PaletExp := '';
                if "Sales Header"."Ship-to Country/Region Code" = 'GB' then
                    PaletExp := '!! FUMIGENEE';
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

    trigger OnPostReport()
    begin
        /*
        IF PrintToExcel THEN BEGIN
          ExcelBuf.UpdateBook(Text000,Text000,COMPANYNAME,USERID);
        
          IF NOT "Sales Header".ISEMPTY THEN BEGIN
            IF NOT "Sales Line".ISEMPTY THEN
              ExcelBuf.AutoFit('WorkOrderLineRange');
            IF NOT "Sales Line".ISEMPTY THEN
              ExcelBuf.BorderAround('WorkOrderLineRange');
            IF NOT "Sales Comment Line".ISEMPTY THEN
              ExcelBuf.BorderAround('WorkOrderCommentLineRange');
            IF NOT "Sales Line".ISEMPTY THEN
              ExcelBuf.BorderAround('WorkOrderExtraLineRange');
          END;
        
          ExcelBuf.UpdateBookStream;
        
          ERROR('');
        END;
        */

    end;

    trigger OnPreReport()
    begin
        //IF PrintToExcel THEN
        //  ExcelBuf.CreateBook;
    end;

    var
        Text000: Label 'Work Order';
        Text001: Label 'Sales Order No.';
        Text002: Label 'Quantity used during work (Posted with the Sales Order)';
        Text003: Label 'Quantity Used';
        Text004: Label 'Comments';
        Text005: Label 'Extra Item/Resource used during work (Posted with Item or Resource Journals)';
        ExcelBuf: Record "Excel Buffer" temporary;
        FormatAddr: Codeunit "Format Address";
        CustAddr: array[8] of Text[50];
        PrintToExcel: Boolean;
        Text006: Label 'Date';
        ItemProduit: Text[30];
        ItemDecoupe: Text[30];
        ItemEpice: Text[30];
        rItem: Record Item;
        RecItemCrossRef_g: Record "Item Reference";
        RecStatSetup_g: Record "Statistics setup";
        TxtProduit_g: Text[30];
        TxtDecoupe_g: Text[30];
        TxtEpice_g: Text[30];
        TxtOrigine_g: Text[30];
        TxtConditionnement_g: Text[30];
        rCust: Record Customer;
        TypeLine: Integer;
        OrderType: Integer;
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Sales_Order_No_CaptionLbl: Label 'Sales Order No.';
        Zugesagtes_LieferdatumCaptionLbl: Label 'Promised Delivery Date';
        B_102454_______________________KF_102454CaptionLbl: Label 'B 102454             /         KF 102454';
        Work_OrderCaptionLbl: Label 'Work Order';
        Type_de_PaletteCaptionLbl: Label 'Type de Palette';
        Work_OrderCaption_Control1Lbl: Label 'Work Order';
        CurrReport_PAGENO_Control4CaptionLbl: Label 'Page';
        Sales_Order_No_Caption_Control15Lbl: Label 'Sales Order No.';
        Zugesagtes_LieferdatumCaption_Control17Lbl: Label 'Promised Delivery Date';
        B_102454______________________KF_102454CaptionLbl: Label 'B 102454            /         KF 102454';
        Type_de_PaletteCaption_Control1000000012Lbl: Label 'Type de Palette';
        Nombre_de_PalettesCaptionLbl: Label 'Nombre de Palettes';
        Nombre_de_ColisCaptionLbl: Label 'Nombre de Colis';
        Type_de_VidangesCaptionLbl: Label 'Type de Vidanges';
        Nombre_de_VidangesCaptionLbl: Label 'Nombre de Vidanges';
        TransporteurCaptionLbl: Label 'Transporteur';
        Quantity_used_during_work__Posted_with_the_Sales_Order_CaptionLbl: Label 'Quantity used during work (Posted with the Sales Order)';
        "DésignationCaptionLbl": Label 'Désignation';
        "QuantitéCaptionLbl": Label 'Quantité';
        ProduitCaptionLbl: Label 'Produit';
        "DécoupeCaptionLbl": Label 'Découpe';
        EpiceCaptionLbl: Label 'Epice';
        OrigineCaptionLbl: Label 'Origine';
        Condit_CaptionLbl: Label 'Condit.';
        "UnitéCaptionLbl": Label 'Unité';
        BeobachtungCaptionLbl: Label 'Observation ';
        CommentsCaptionLbl: Label 'Comments';
        No_CaptionLbl: Label 'No.';
        Charge_NoCaptionLbl: Label 'Lot No';
        QuantityCaptionLbl: Label 'Quantity';
        Unit_of_MeasureCaptionLbl: Label 'Unit of Measure';
        Extra_Item_Resource_used_during_work__Posted_with_Item_or_Resource_Journals_CaptionLbl: Label 'Extra Item/Resource used during work (Posted with Item or Resource Journals)';
        "5_no": Text;
        "5_Desc": Text;
        VersionMgt: Codeunit VersionManagement;
        BomL: Record "Production BOM Line";
        PaletExp: Text;

    local procedure MakeWOHeader()
    begin
        /*ExcelBuf.NewRow;
        
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(CustAddr[1],FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn(FORMAT(Text001),FALSE,'',TRUE,FALSE,FALSE,'');
        ExcelBuf.AddColumn("Sales Header"."No.",FALSE,'',TRUE,FALSE,FALSE,'');
        
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(CustAddr[2],FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn("Sales Header".FIELDCAPTION("Shipment Date"),FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn("Sales Header"."Shipment Date",FALSE,'',FALSE,FALSE,FALSE,'');
        
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(CustAddr[3],FALSE,'',FALSE,FALSE,FALSE,'');
        
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(CustAddr[4],FALSE,'',FALSE,FALSE,FALSE,'');
        
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(CustAddr[5],FALSE,'',FALSE,FALSE,FALSE,'');
        
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(CustAddr[6],FALSE,'',FALSE,FALSE,FALSE,'');
        
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(CustAddr[7],FALSE,'',FALSE,FALSE,FALSE,'');
        
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(CustAddr[8],FALSE,'',FALSE,FALSE,FALSE,'');
        */

    end;

    local procedure MakeWOLineHeader()
    var
        HeaderLineNo: Integer;
    begin
        /*IF "Sales Line".ISEMPTY THEN
          EXIT;
        
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(FORMAT(Text002),FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn( "Sales Line".FIELDCAPTION(Type),FALSE,'',TRUE,FALSE,TRUE,'');
        
        ExcelBuf.StartRange;
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION("No."),FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION(Description),FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION(Quantity),FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION("Unit of Measure"),FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.AddColumn(FORMAT(Text003),FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION("Unit of Measure"),FALSE,'',TRUE,FALSE,TRUE,'');
        */

    end;

    local procedure MakeWOLine()
    begin
        /*
        IF "Sales Line".ISEMPTY THEN
          EXIT;
        
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(FORMAT("Sales Line".Type),FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn("Sales Line"."No.",FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn("Sales Line".Description,FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn("Sales Line".Quantity,FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn("Sales Line"."Unit of Measure",FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        */

    end;

    local procedure MakeWOCommentLineHeader()
    begin
        /*
        IF "Sales Comment Line".ISEMPTY THEN
          EXIT;
        
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(FORMAT(Text004),FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn("Sales Comment Line".FIELDCAPTION(Code),FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.StartRange;
        
        ExcelBuf.AddColumn("Sales Comment Line".FIELDCAPTION(Comment),FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.AddColumn("Sales Comment Line".FIELDCAPTION(Date),FALSE,'',TRUE,FALSE,TRUE,'');
        */

    end;

    local procedure MakeWOCommentLine()
    begin
        /*
        IF "Sales Comment Line".ISEMPTY THEN
          EXIT;
        
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn("Sales Comment Line".Code,FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn("Sales Comment Line".Comment,FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn("Sales Comment Line".Date,FALSE,'',FALSE,FALSE,TRUE,'');
        */

    end;

    local procedure MakeWOExtraLineHeader()
    begin
        /*IF "Sales Line".ISEMPTY THEN
          EXIT;
        
        ExcelBuf.NewRow;
        ExcelBuf.NewRow;
        
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(FORMAT(Text005),FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn( "Sales Line".FIELDCAPTION(Type),FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.StartRange;
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION("No."),FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION(Description),FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION(Quantity),FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.AddColumn("Sales Line".FIELDCAPTION("Unit of Measure"),FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.AddColumn(FORMAT(Text006),FALSE,'',TRUE,FALSE,TRUE,'');
        
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,TRUE,'');
        */

    end;
}

