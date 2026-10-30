report 50076 "Fiche palette exp + lotZebra"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/FichepaletteexplotZebra.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
            column(Pallet_Ledger_Entry_Quantity; Qty)
            {
            }
            column(TxtAddress; TxtAddress)
            {
            }
            column(Sales_Shipment_Header__Order_No__; OrderNo)
            {
            }
            column(Sales_Shipment_Header__Ship_to_Post_Code_; ShipToPostCode)
            {
            }
            column(Sales_Shipment_Header__Ship_to_County_; ShipToCountry)
            {
            }
            column(Sales_Shipment_Header__Ship_to_Address_; ShipToAddress)
            {
            }
            column(Sales_Shipment_Header__Ship_to_Name_; ShipToName)
            {
            }
            column(Sales_Shipment_Header__Ship_to_City_; ShipToCity)
            {
            }
            column(Integer_Number; Number)
            {
            }
            column(Congele; Congele)
            {
            }
            column(NbreBoites; NbreBoites)
            {
            }
            column(GS1_00_Txt; GS1_00_Txt)
            {
            }
            column(GS1_00_128; GS1_00_128)
            {
            }
            column(ItemNo; ItemNo)
            {
            }
            column(ShowAgrementKF; ShowAgrementKF)
            {
            }
            column(ShowAgrementB; ShowAgrementB)
            {
            }
            column(ExtNo; ExtNo)
            {
            }
            column(SSCC; SSCC)
            {
            }
            column(GTIN; GTIN)
            {
            }
            column(Lot; TmpPal."Lot No.")
            {
            }
            column(DLC; TmpPal.DLC)
            {
            }
            column(GS1_xx_txt; GS1_xx_txt)
            {
            }
            column(GS1_xx_128; GS1_xx_128)
            {
            }
            column(GS1_Lot_Txt; GS1_Lot_Txt)
            {
            }
            column(GS1_Lot_128; GS1_Lot_128)
            {
            }
            column(ItemDescription; desc)
            {
            }
            column(ExtRef; ExtRef)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then
                    TmpPal.FindFirst
                else
                    if TmpPal.Next = 0 then
                        CurrReport.Break;

                Qty := TmpPal."Quantite reception";

                ItemNo := TmpPal."Item No.";
                ShowAgrementB := TmpPal.Agrément = TmpPal.Agrément::B102454;
                ShowAgrementKF := TmpPal.Agrément = TmpPal.Agrément::KF102454;


                //MESSAGE('%1    %2',TmpPal."SSCC No.",TmpPal."Item No.");
                //Congele := TRUE;

                Items.Get(ItemNo);
                //Codes.GET(27,8001305,Items."Criteria 5");
                NbreBoites := TmpPal."Nbre bacs reception";
                //NbreBoites := ROUND(Qty / Codes."Poids primaire",1,'=');
                desc := Items.Description;
                if ItemTr.Get(ItemNo, '', Lng) then
                    desc := ItemTr.Description;
                SSCC := GS1.GetSSCCFromPal(TmpPal."SSCC No.");

                //TM 10/02/22
                //GTIN := '0'+Items."EAN13 Code";
                GTIN := Items."CB carton";
                GS1_00_Txt := '(00)' + SSCC;
                GS1_00_128 := Utils.Code128GetDisplay(GS1_00_Txt);
                GS1_421_Txt := '(421)' + recCountry."ISO Country/Region Code3" + ShipToPostCode;
                GS1_421_128 := Utils.Code128GetDisplay(GS1_421_Txt);
                GS1_xx_txt := '(02)' + GTIN + '(3102)' + Utils.Replace(Format(TmpPal."Quantite reception", 4, '<Integer>'), ' ', '0') + Utils.Replace(DelChr(Format(TmpPal."Quantite reception", 2, '<Decimal>'), '=', ',.'), ' ', '0') + '(37)' + Format(NbreBoites);
                GS1_xx_128 := Utils.Code128GetDisplay(GS1_xx_txt);
                GS1_Lot_Txt := '(17)' + Format(TmpPal.DLC, 0, '<Year,2><Month,2><Day,2>') + '(10)' + TmpPal."Lot No.";
                GS1_Lot_128 := Utils.Code128GetDisplay(GS1_Lot_Txt);

                recRef.Reset;
                recRef.SetRange("Item No.", ItemNo);
                recRef.SetRange("Reference Type No.", CustNo);
                if recRef.FindFirst then
                    ExtRef := recRef."Reference No."
                else
                    ExtRef := '-';
            end;

            trigger OnPreDataItem()
            begin
                if TmpNo <> '' then
                    TmpPal.SetFilter("SSCC No.", TmpNo);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(TxtPal; TxtPal)
                {
                    Caption = 'Toutes les palettes de';
                }
                field(TmpNo; TmpNo)
                {
                    Caption = 'ou No de palette à réimprimer';
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
        TxtAddressCongel: Label 'Rue de l''ancienne Potence 01 -7522 Marquain - Belgium';
        TxtAddress: Text[250];
        ShipToName: Text[80];
        ShipToAddress: Text[80];
        ShipToCity: Text[80];
        ShipToPostCode: Text[30];
        ShipToCountry: Text[30];
        ShipToCountryCode3: Text[3];
        OrderNo: Text[30];
        TmpPal: Record Pallet temporary;
        Qty: Decimal;
        NbreBoites: Integer;
        Congele: Boolean;
        recCountry: Record "Country/Region";
        GS1_00_128: Text[80];
        GS1_00_Txt: Text[80];
        GS1_421_128: Text[80];
        GS1_421_Txt: Text[80];
        Utils: Codeunit Utils;
        GS1: Codeunit "GS1 Send";
        ItemNo: Code[20];
        TmpNo: Text[30];
        TxtPal: Text[250];
        ShowAgrementKF: Boolean;
        ShowAgrementB: Boolean;
        ExtNo: Text;
        SSCC: Text;
        GTIN: Text;
        Items: Record Item;
        GS1_xx_txt: Text;
        GS1_xx_128: Text;
        GS1_Lot_Txt: Text;
        GS1_Lot_128: Text;
        Codes: Record "Code";
        Lng: Code[10];
        ItemTr: Record "Item Translation";
        desc: Text;
        CustNo: Code[20];
        ExtRef: Text;
        recRef: Record "Item Reference";

    [Scope('OnPrem')]
    procedure setTempRec(var tmp_palettes: Record Pallet; NoExpedition: Code[20])
    var
        recExpedition: Record "Sales Shipment Header";
        recCmd: Record "Sales Header";
        desc: Text;
    begin
        TxtPal := NoExpedition;
        if tmp_palettes.FindSet then
            repeat
                TmpPal.Init;
                TmpPal.Copy(tmp_palettes);
                TmpPal.Insert;
            until tmp_palettes.Next = 0;

        if recExpedition.Get(NoExpedition) then begin
            ShipToName := recExpedition."Ship-to Name";
            ShipToAddress := recExpedition."Ship-to Address" + ' ' + recExpedition."Ship-to Address 2";
            ShipToCity := recExpedition."Ship-to City";
            ShipToPostCode := recExpedition."Ship-to Post Code";
            ExtNo := recExpedition."External Document No.";
            if recCountry.Get(recExpedition."Ship-to Country/Region Code") then begin
                ShipToCountry := recCountry.Name;
                ShipToCountryCode3 := recCountry."ISO Country/Region Code3";
            end;
            OrderNo := recExpedition."Order No.";
            CustNo := recExpedition."Sell-to Customer No.";
            Congele := (recExpedition."Order type" = recExpedition."Order type"::"Surgelé");
        end
        else begin
            if recCmd.Get(recCmd."Document Type"::Order, NoExpedition) then begin
                ShipToName := recCmd."Ship-to Name";
                ShipToAddress := recCmd."Ship-to Address";
                ShipToCity := recCmd."Ship-to City";
                ShipToPostCode := recCmd."Ship-to Post Code";
                ExtNo := recCmd."External Document No.";
                if recCountry.Get(recCmd."Ship-to Country/Region Code") then begin
                    ShipToCountry := recCountry.Name;
                    ShipToCountryCode3 := recCountry."ISO Country/Region Code3";
                end;
                OrderNo := recCmd."No.";
                CustNo := recCmd."Sell-to Customer No.";
                Congele := (recCmd."Order type" = recCmd."Order type"::"Surgelé");
            end;
        end;
        if Congele then
            TxtAddress := 'Rue de l''Ancienne Potence 01 - 7522 Marquain - Belgium'
        else
            TxtAddress := 'Rue de la Terre à Briques 14 - 7522 Marquain - Belgium';
    end;

    [Scope('OnPrem')]
    procedure setLanguage(LanguageCode: Code[10])
    begin
        Lng := LanguageCode;
    end;
}

