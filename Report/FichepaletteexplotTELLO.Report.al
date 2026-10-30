report 50087 "Fiche palette exp+lotTELLO"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/FichepaletteexplotTELLO.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Pallet; Pallet)
        {
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
            column(Lot; Pallet."Lot No.")
            {
            }
            column(DLC; Pallet.DLC)
            {
            }
            column(ItemDescription; desc)
            {
            }
            column(ExtRef; ExtRef)
            {
            }
            column(GS1_L2_txt; GS1_L2_Txt)
            {
            }
            column(GS1_L2_128; GS1_L2_128)
            {
            }
            column(GS1_L1_Txt; GS1_L1_Txt)
            {
            }
            column(GS1_L1_128; GS1_L1_128)
            {
            }

            trigger OnAfterGetRecord()
            begin

                if recExpedition.Get(Pallet."Outbound Document No.") then begin
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
                    if recCmd.Get(recCmd."Document Type"::Order, Pallet."Outbound Document No.") then begin
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



                Qty := Pallet."Quantite reception";

                ItemNo := Pallet."Item No.";
                ShowAgrementB := Pallet.Agrément = Pallet.Agrément::B102454;
                ShowAgrementKF := Pallet.Agrément = Pallet.Agrément::KF102454;


                //MESSAGE('%1    %2',TmpPal."SSCC No.",TmpPal."Item No.");
                //Congele := TRUE;

                Items.Get(ItemNo);
                //Codes.GET(27,8001305,Items."Criteria 5");
                NbreBoites := Pallet."Nbre bacs reception";
                //NbreBoites := ROUND(Qty / Codes."Poids primaire",1,'=');
                desc := Items.Description;
                if ItemTr.Get(ItemNo, '', Lng) then
                    desc := ItemTr.Description;
                SSCC := GS1.GetSSCCFromPal(Pallet."SSCC No.");

                //TM 10/02/22
                //GTIN := '0'+Items."EAN13 Code";
                GTIN := Items."CB carton";
                GS1_L1_Txt := '(02)' + GTIN + '(15)' + Format(Pallet.DLC, 0, '<Year,2><Month,2><Day,2>') + '(37)' + Utils.PadLeft(Format(NbreBoites), '0', 4) + '(3103)' + Utils.Replace(Format(Pallet."Quantite reception", 3, '<Integer>'), ' ', '0') + Utils.Replace(DelChr(Format(Pallet."Quantite reception", 3, '<Decimal>'), '=', ',.'), ' ', '0');
                GS1_L1_128 := Utils.Code128GetDisplay(GS1_L1_Txt);
                GS1_L2_Txt := '(00)' + SSCC + '(10)' + Utils.PadLeft(Pallet."Lot No.", '0', 10);
                GS1_L2_128 := Utils.Code128GetDisplay(GS1_L2_Txt);


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
                //Pallet.SETFILTER("SSCC No.", '000001316874');
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

    trigger OnPreReport()
    begin
        //  t.GET('000001316874');
    end;

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
        recExpedition: Record "Sales Shipment Header";
        recCmd: Record "Sales Header";
        GS1_L2_Txt: Text;
        GS1_L2_128: Text;
        GS1_L1_Txt: Text;
        GS1_L1_128: Text;

    [Scope('OnPrem')]
    procedure setTempRec(var tmp_palettes: Record Pallet; NoExpedition: Code[20])
    begin
    end;

    [Scope('OnPrem')]
    procedure setLanguage(LanguageCode: Code[10])
    begin
        Lng := LanguageCode;
    end;
}

