report 50014 "Edition Bon de transport"
{
    // //AB60408.V14 EBE 30/04/08
    //    Création Edition Bon de transport
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/EditionBondetransport.rdlc';


    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = SORTING("Document Type", "No.");
            RequestFilterFields = "No.";
            column(Text001; Text001)
            {
            }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(BuyFromAddr_1_; BuyFromAddr[1])
            {
            }
            column(BuyFromAddr_2_; BuyFromAddr[2])
            {
            }
            column(BuyFromAddr_3_; BuyFromAddr[3])
            {
            }
            column(BuyFromAddr_5____BuyFromAddr_6_; BuyFromAddr[5] + BuyFromAddr[6])
            {
            }
            column(CompanyInfo__Phone_No__; 'Service transport : 0032 (0)69 76 50 57 ou 58')
            {
            }
            column(CompanyInfo__Post_Code__________CompanyInfo_City; CompanyInfo."Post Code" + ' ' + CompanyInfo.City)
            {
            }
            column(CompanyInfo_Address_________CompanyInfo__Address_2_; CompanyInfo.Address + ' ' + CompanyInfo."Address 2")
            {
            }
            column(WORKDATE; WorkDate)
            {
            }
            column(TextHeader1; TextHeader1)
            {
            }
            column("STRSUBSTNO_TextHeader2_DateEnlèvement_"; StrSubstNo(TextHeader2, DateEnlèvement))
            {
            }
            column(Vendor__Fax_No__; Vendor."Fax No.")
            {
            }
            column(BuyFromAddr_4_; BuyFromAddr[4])
            {
            }
            column(Purchase_Header__Location_Code_; "Location Code")
            {
            }
            column(LocationAddr_1_; LocationAddr[1])
            {
            }
            column(LocationAddr_2___________LocationAddr_3__; LocationAddr[2] + '  ' + LocationAddr[3])
            {
            }
            column(LocationAddr_4___________LocationAddr_5_; LocationAddr[4] + '  ' + LocationAddr[5])
            {
            }
            column(FooterComment; FooterComment)
            {
            }
            column(WORKDATECaption; WORKDATECaptionLbl)
            {
            }
            column(Telex_NoCaption; Telex_NoCaptionLbl)
            {
            }
            column(Collection_address__Caption; Collection_address__CaptionLbl)
            {
            }
            column(Purchase_Header_Document_Type; "Document Type")
            {
            }
            column(Purchase_Header_No_; "No.")
            {
            }
            column(Signature; Signature)
            {
            }
            column(Body1; Body1)
            {
            }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");
                column(HeaderComment; HeaderComment)
                {
                }
                column(Address_1____Text003___SAlesOrderNo; Address[1] + Text003 + SAlesOrderNo)
                {
                }
                column(Address_2___________Address_3_; Address[2] + '  ' + Address[3])
                {
                }
                column(Address_4___________Address_5_; Address[4] + '  ' + Address[5])
                {
                }
                column(Purchase_Line__Cases_Quantity_per_Pallet_; "Cases Quantity per Pallet")
                {
                }
                column(Purchase_Line_Quantity; Quantity)
                {
                }
                column(Purchase_Line__Net_Weight_; "Net Weight")
                {
                }
                column(Address_6___________Customer__Phone_No__; Address[6] + '  ' + Tel)
                {
                }
                column(Purchase_Line__Transport_Comment_; "Transport Comment")
                {
                }
                column(Purchase_Line__Logistic_unit_; "Logistic unit")
                {
                }
                column(Purchase_Line__Horaires_de_livraison_; "Horaires de livraison")
                {
                }
                column(PalletsCaption; PalletsCaptionLbl)
                {
                }
                column(Purchase_Line__Net_Weight_Caption; Purchase_Line__Net_Weight_CaptionLbl)
                {
                }
                column(BoxesCaption; BoxesCaptionLbl)
                {
                }
                column(Delivery_AddressCaption; Delivery_AddressCaptionLbl)
                {
                }
                column(Purchase_Line_Document_Type; "Document Type")
                {
                }
                column(Purchase_Line_Document_No_; "Document No.")
                {
                }
                column(Purchase_Line_Line_No_; "Line No.")
                {
                }

                trigger OnAfterGetRecord()
                var
                    SalesHeader: Record "Sales Header";
                    SalesInvHeader: Record "Sales Invoice Header";
                    ShipAdr: Record "Ship-to Address";
                begin
                    Clear(Address);
                    Tel := '';
                    if ("Transport Sales Order No" <> '') and SalesHeader.Get(SalesHeader."Document Type"::Order, "Transport Sales Order No") then begin
                        FormatAddr.SalesHeaderShipTo(Address, Address, SalesHeader);
                        SAlesOrderNo := SalesHeader."External Document No.";
                        if ShipAdr.Get(SalesHeader."Ship-to Code") then
                            if ShipAdr."Phone No." <> '' then
                                Tel := ShipAdr."Phone No.";
                        "Purchase Line"."Horaires de livraison" := SalesHeader."Horaires de livraison";

                    end;

                    if not Customer.Get("Transport Customer No") then
                        Clear(Customer);
                    if Tel = '' then
                        Tel := Customer."Phone No.";

                    if ("Transport Sales Invoice No" <> '') and SalesInvHeader.Get("Transport Sales Invoice No") then begin
                        FormatAddr.SalesInvShipTo(Address, Address, SalesInvHeader);
                        SAlesOrderNo := SalesInvHeader."External Document No.";
                    end;


                    ShptPurchOrder.Reset;
                    ShptPurchOrder.SetRange("Purchase Order No.", "Document No.");
                    ShptPurchOrder.SetRange("Sales Order No.", "Transport Sales Order No");
                    ShptPurchOrder.SetRange("Sales Invoice No", "Transport Sales Invoice No");
                    if not ShptPurchOrder.Find('-') then
                        Clear(ShptPurchOrder);
                end;
            }

            trigger OnAfterGetRecord()
            begin


                Signature := cuMail.GetSignature(UserId);

                FormatAddr.PurchHeaderBuyFrom(BuyFromAddr, "Purchase Header");
                FormatAddr.PurchHeaderShipTo(LocationAddr, "Purchase Header");

                if not Vendor.Get("Purchase Header"."Buy-from Vendor No.") then
                    Clear(Vendor);
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get;
                CompanyInfo.CalcFields(Picture);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(HeaderComment; HeaderComment)
                {
                    Caption = 'En-tête';
                }
                field(FooterComment; FooterComment)
                {
                    Caption = 'Pied de page';
                }
                field("DateEnlèvement"; DateEnlèvement)
                {
                    Caption = 'Date d''enlèvement';
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

    var
        Text001: Label 'FAX MESSAGE';
        Customer: Record Customer;
        Vendor: Record Vendor;
        CompanyInfo: Record "Company Information";
        ShptPurchOrder: Record "Shipment Purchase Orders";
        FormatAddr: Codeunit "Format Address";
        Address: array[8] of Text[80];
        BuyFromAddr: array[8] of Text[80];
        LocationAddr: array[8] of Text[80];
        Text003: Label '  Order No : ';
        TextHeader1: Label 'Good Morning,';
        TextHeader2: Label 'Would you please collect the following orders on %1:';
        HeaderComment: Text[250];
        TextHeader3: Label '';
        FooterComment: Text[250];
        SAlesOrderNo: Code[50];
        "DateEnlèvement": Date;
        WORKDATECaptionLbl: Label 'Date';
        Telex_NoCaptionLbl: Label 'Telex No';
        Collection_address__CaptionLbl: Label 'Collection address :';
        PalletsCaptionLbl: Label 'Pallets';
        Purchase_Line__Net_Weight_CaptionLbl: Label 'Kg';
        BoxesCaptionLbl: Label 'Boxes';
        Delivery_AddressCaptionLbl: Label 'Delivery Address';
        Body1: Label 'Veuillez trouver ci-joint notre confirmation de commande';
        Signature: Text;
        cuMail: Codeunit Integration_EMail;
        Tel: Text;

    [Scope('OnPrem')]
    procedure SetInfos(EnTete: Text[250]; Pied: Text[250]; DtLivraison: Date)
    begin
        HeaderComment := EnTete;
        FooterComment := Pied;
        DateEnlèvement := DtLivraison;
    end;
}

