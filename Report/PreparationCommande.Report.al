report 50027 "Preparation Commande"
{
    // //AB60408.V12 EBE 16/04/08
    //   - agrandissement du champ commentaire logistique text 30 -> text 80 (diminution de la police)
    // //DG 210519 By Pass Comment Line
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/PreparationCommande.rdlc';

    Caption = 'Préparation Commande';

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
            column(No________; '*' + "No." + '*')
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
            column(Work_OrderCaption; Work_OrderCaptionLbl)
            {
            }
            column(Sales_Header__Order_Date_Caption; FieldCaption("Order Date"))
            {
            }
            column(Sales_Header_Document_Type; "Document Type")
            {
            }
            column(Sales_Header_Shipping_Agent_Code; "Shipping Agent Code")
            {
            }
            column(CommentaireProduction; rCust."Production comment")
            {
            }
            column(RequestedDeliveryDate_SalesHeader; "Sales Header"."Requested Delivery Date")
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

                trigger OnAfterGetRecord()
                begin
                    //Mail Sylvie 300326
                    CurrReport.Skip;
                end;
            }
            dataitem(PageLoop; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                dataitem("Sales Line"; "Sales Line")
                {
                    DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                    DataItemLinkReference = "Sales Header";
                    DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");
                    column(Sales_Line__No__; "No.")
                    {
                    }
                    column(rItem_Description; Description)
                    {
                    }
                    column(Sales_Line__Quantity__Base__; "Quantity (Base)")
                    {
                    }
                    column(Sales_Line_Type; Type)
                    {
                    }
                    column(Sales_Line__No__Caption; FieldCaption("No."))
                    {
                    }
                    column("DésignationCaption"; DésignationCaptionLbl)
                    {
                    }
                    column(Sales_Line__Quantity__Base__Caption; FieldCaption("Quantity (Base)"))
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
                    dataitem("Reservation Entry"; "Reservation Entry")
                    {
                        DataItemLink = "Source ID" = FIELD("Document No."), "Source Ref. No." = FIELD("Line No.");
                        DataItemTableView = WHERE("Source Type" = CONST(37), "Source Subtype" = CONST("1"));
                        column(STRSUBSTNO_Text50000___Reservation_Entry___Lot_No____Reservation_Entry___Warranty_Date__; StrSubstNo(Text50000, "Reservation Entry"."Lot No.", "Reservation Entry"."Warranty Date"))
                        {
                        }
                        column(Reservation_Entry__Quantity; -"Reservation Entry".Quantity)
                        {
                        }
                        column(Reservation_Entry_Entry_No_; "Entry No.")
                        {
                        }
                        column(Reservation_Entry_Positive; Positive)
                        {
                        }
                        column(Reservation_Entry_Source_ID; "Source ID")
                        {
                        }
                        column(Reservation_Entry_Source_Ref__No_; "Source Ref. No.")
                        {
                        }
                        column(Reservation_Entry_Item_No_; "Item No.")
                        {
                        }
                        column(Reservation_Entry_Lot_No_; "Lot No.")
                        {
                        }
                        column(Reservation_Entry_Location_Code; "Location Code")
                        {
                        }
                        column(Reservation_NbreColis; NbreColis)
                        {
                        }
                        dataitem(Pallet; Pallet)
                        {
                            DataItemLink = "Item No." = FIELD("Item No."), "Lot No." = FIELD("Lot No."), "Location code" = FIELD("Location Code");
                            DataItemTableView = SORTING("Item No.", "Lot No.", "Bin code");
                            column(Pallet__Bin_code_; "Bin code")
                            {
                            }
                            column(Pallet__SSCC_No__; "SSCC No.")
                            {
                            }
                            column(Pallet__Current_Quantity_; "Current Quantity")
                            {
                            }
                            column(Pallet_Item_No_; "Item No.")
                            {
                            }
                            column(Pallet_Lot_No_; "Lot No.")
                            {
                            }
                            column(Pallet_Type; rItem.TypePalette)
                            {
                            }
                            column(Pallet_Location_code; "Location code")
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin

                                Pallet.CalcFields("Current Quantity");
                                if Pallet."Current Quantity" <= 0 then CurrReport.Skip;

                            end;
                        }

                        trigger OnAfterGetRecord()
                        var
                            codes: Record "Code";
                        begin
                            NbreColis := 1;
                            codes.Reset;
                            codes.SetRange("Table No", 27);
                            codes.SetRange("Field No", 8001305);
                            codes.SetRange(Code, rItem."Criteria 5");
                            if codes.FindFirst then begin
                                if codes.Poids > 0 then
                                    NbreColis := -"Reservation Entry"."Quantity (Base)" / codes.Poids;
                            end;
                        end;
                    }

                    trigger OnAfterGetRecord()
                    var
                        RecCode_l: Record "Code";
                    begin

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

                        end;

                        //<-- ABSYS GN 20061219
                    end;

                    trigger OnPostDataItem()
                    begin
                        if PrintToExcel and ("Sales Line".Count <> 0) then begin
                            ExcelBuf.EndRange;
                            ExcelBuf.CreateRange('WorkOrderLineRange');
                        end
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
                }
            }

            trigger OnAfterGetRecord()
            var
                ResEntry: Record "Reservation Entry";
                Pal: Record Pallet;
            begin
                FormatAddr.SalesHeaderBillTo(CustAddr, "Sales Header");


                //--> ABSYS GN 20061219
                // -- Récupération Info Stat --
                if RecStatSetup_g.Get then;
                //<-- ABSYS GN 20061219


                if rCust.Get("Sell-to Customer No.") then;


                //Préparation des emplacements actuels
                ResEntry.SetRange("Source Type", 37);
                ResEntry.SetRange("Source Subtype", 1);
                ResEntry.SetRange("Source ID", "Sales Header"."No.");
                if ResEntry.Find('-') then begin
                    repeat
                        Pal.Reset;
                        Pal.SetCurrentKey("Item No.", "Lot No.", "Bin code");
                        Pal.SetRange("Item No.", ResEntry."Item No.");
                        Pal.SetRange("Lot No.", ResEntry."Lot No.");
                        Pal.SetFilter("Bin code", '<> %1', '');
                        if Pal.Find('-') then begin
                            ResEntry."First bin code" := Pal."Bin code";
                            ResEntry.Modify;
                        end;
                    until ResEntry.Next = 0;
                end;
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
          ExcelBuf.CreateSheet(Text000,Text000,COMPANYNAME,USERID);
        
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
        
          ExcelBuf.GiveUserControl;
        
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
        ExcelBuf: Record "Excel Buffer" temporary;
        FormatAddr: Codeunit "Format Address";
        CustAddr: array[8] of Text[50];
        PrintToExcel: Boolean;
        ItemProduit: Text[30];
        ItemDecoupe: Text[30];
        ItemEpice: Text[30];
        rItem: Record Item;
        RecItemCrossRef_g: Record "Item Reference";
        RecStatSetup_g: Record "Statistics setup";
        TxtProduit_g: Text[80];
        TxtDecoupe_g: Text[80];
        TxtEpice_g: Text[80];
        TxtOrigine_g: Text[80];
        TxtConditionnement_g: Text[80];
        rCust: Record Customer;
        Text50000: Label 'Batch No. : %1 - DLC : %2';
        Text000: Label 'TTT';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Sales_Order_No_CaptionLbl: Label 'Sales Order No.';
        Zugesagtes_LieferdatumCaptionLbl: Label 'Promised Delivery Date';
        Work_OrderCaptionLbl: Label 'Work Order';
        TransporteurCaptionLbl: Label 'Transporteur';
        "DésignationCaptionLbl": Label 'Désignation';
        CommentsCaptionLbl: Label 'Comments';
        NbreColis: Decimal;
        PaletExp: Text;
}

