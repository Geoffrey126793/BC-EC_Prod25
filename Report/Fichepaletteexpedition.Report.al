report 50067 "Fiche palette expedition"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/Fichepaletteexpedition.rdlc';
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
            column(GS1_421_Txt; GS1_421_Txt)
            {
            }
            column(GS1_421_128; GS1_421_128)
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

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then
                    TmpPal.FindFirst
                else
                    if TmpPal.Next = 0 then
                        CurrReport.Break;

                Qty := TmpPal."Quantite reception";
                NbreBoites := TmpPal."Nbre bacs reception";
                ItemNo := TmpPal."Item No.";
                ShowAgrementB := TmpPal.Agrément = TmpPal.Agrément::B102454;
                ShowAgrementKF := TmpPal.Agrément = TmpPal.Agrément::KF102454;


                //MESSAGE('%1    %2',TmpPal."SSCC No.",TmpPal."Item No.");
                //Congele := TRUE;

                GS1_00_Txt := '(00)' + GS1.GetSSCCFromPal(TmpPal."SSCC No.");
                GS1_00_128 := Utils.Code128GetDisplay(GS1_00_Txt);
                GS1_421_Txt := '(421)' + recCountry."ISO Country/Region Code3" + ShipToPostCode;
                GS1_421_128 := Utils.Code128GetDisplay(GS1_421_Txt);
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

    [Scope('OnPrem')]
    procedure setTempRec(var tmp_palettes: Record Pallet; NoExpedition: Code[20])
    var
        recExpedition: Record "Sales Shipment Header";
        recCmd: Record "Sales Header";
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
                Congele := (recCmd."Order type" = recCmd."Order type"::"Surgelé");
            end;
        end;
        if Congele then
            TxtAddress := 'Rue de l''Ancienne Potence 01 - 7522 Marquain - Belgium'
        else
            TxtAddress := 'Rue de la Terre à Briques 14 - 7522 Marquain - Belgium';
    end;
}

