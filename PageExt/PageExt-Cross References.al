pageextension 70169 pageextension70169 extends "Item References"
{
    layout
    {


        addafter(Description)
        {
            field("Cross-Reference Type"; "Reference Type")
            {
            }
            field("Cross-Reference Type No."; "Reference Type No.")
            {
            }
            field("Intern Description"; "Intern Description")
            {
            }
            field("Nom Tiers"; CustVendorName)
            {
            }
            field("DLC mini"; "DLC mini")
            {

            }
            field("Image"; "ImageTxt")
            {
                Visible = false;
            }
            field("Units"; "Units")
            {
                visible = false;
            }
            field(DescriptionTranslated; DescriptionTranslated)
            {
                Visible = false;
            }
            field(Gamme; Gamme)
            {
                Visible = false;
            }
            field(Magasin; Magasin)
            {
                visible = false;
            }
            field(EAN; EAN)
            {
                Visible = false;
            }
            field(QtyUVC; QtyUVC)
            {
                Visible = false;
            }
            field(Prices; Prices)
            {
                Visible = false;
            }
            field(DescriptionEN; DescriptionEN)
            {

            }
            field(DescriptionES; DescriptionES)
            {

            }
            field(DescriptionFR; DescriptionFR)
            {

            }
            field(DescriptionNL; DescriptionNL)
            {

            }
        }
    }

    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        CustVendorName: Text[50];
        ImageTxt: Text;
        Units: Text;
        DescriptionTranslated: Text;
        Gamme: Text;
        Magasin: text;
        EAN: Text;
        QtyUVC: decimal;
        Prices: Text;
        DescriptionFR: Text;
        DescriptionEN: Text;
        DescriptionNL: Text;
        DescriptionES: Text;


    trigger OnAfterGetRecord()
    var
        TenantMedia: Record "Tenant Media";
        Item: Record Item;
        inS: InStream;
        outS: OutStream;
        Base64Convert: Codeunit "Base64 Convert";
        ItemTanslate: record "Item Translation";
        SalesPrices: record "Sales PriceEC";
        TempIUOM: record "Item Unit of Measure" temporary;
        IUOM: record "Item Unit of Measure";
        codes: record "Code";

    begin

        Clear(Customer);
        Clear(Vendor);
        Clear(CustVendorName);
        CLEAR(ImageTxt);
        CLEAR(Gamme);
        CLEAR(Magasin);
        CLEAR(EAN);
        CLEAR(QtyUVC);

        if item.Get(Rec."Item No.") THEN begin
            if Item.Picture.COUNT > 0 then
                IF TenantMedia.GET(Item.Picture.ITEM(1)) then begin
                    TenantMedia.CalcFields(Content);
                    IF TenantMedia.Content.HasValue then begin
                        TenantMedia.Content.CreateInStream(inS);
                        ImageTxt := Base64Convert.ToBase64(InS);
                    end;
                end;
            DescriptionTranslated := Item.Description;
            EAN := Item.GTIN;
            Magasin := Item."Default Location Code";
            Gamme := Item."Item Category Code";
            codes.RESET;
            codes.SETRANGE("Table No", 27);
            codes.SETRANGE("Field No", 8001305);
            codes.SETRANGE(Code, Item."Criteria 5");
            IF (codes.FINDFIRST) THEN
                QtyUVC := codes.Poids;
        end;
        if "Reference Type" = "Reference Type"::Customer then
            if Customer.Get("Reference Type No.") then begin
                CustVendorName := Customer.Name;
                if ItemTanslate.get(Rec."Item No.", Rec."Variant Code", Customer."Language Code") then
                    DescriptionTranslated := ItemTanslate.Description;
                if ItemTanslate.get(Rec."Item No.", Rec."Variant Code", 'EN') then
                    DescriptionEN := ItemTanslate.Description;
                if ItemTanslate.get(Rec."Item No.", Rec."Variant Code", 'NL') then
                    DescriptionNL := ItemTanslate.Description;
                if ItemTanslate.get(Rec."Item No.", Rec."Variant Code", 'FR') then
                    DescriptionFR := ItemTanslate.Description;
                if ItemTanslate.get(Rec."Item No.", Rec."Variant Code", 'ES') then
                    DescriptionES := ItemTanslate.Description;
                Prices := '[';
                SalesPrices.RESET;
                SalesPrices.SETRANGE("Sales Type", SalesPrices."Sales Type"::Customer);
                SalesPrices.SetRange("Sales Code", Customer."No.");
                SalesPrices.SetRange("Item No.", Rec."Item No.");
                //SalesPrices.SetFilter("Starting Date", '<=%1', Today);
                SalesPrices.SetFilter("Ending Date", '>=%1', Today);
                if SalesPrices.FindSet() then
                    repeat
                        if NOT TempIUOM.GET(rec."Item No.", SalesPrices."Unit of Measure Code") then begin
                            TempIUOM.INIT;
                            TempIUOM."Item No." := rec."Item No.";
                            TempIUOM."Code" := SalesPrices."Unit of Measure Code";
                            IUOM.Reset();
                            IF IUOM.GET(rec."Item No.", SalesPrices."Unit of Measure Code") then
                                TempIUOM."Qty. per Unit of Measure" := IUOM."Qty. per Unit of Measure";
                            TempIUOM.INSERT;
                        end;
                        if Prices <> '[' then Prices += ',';
                        Prices += '{"Start":"' + format(CreateDateTime(SalesPrices."Starting Date", 010000T), 0, 9) + '","UnitPrice":' + format(SalesPrices."Unit Price").Replace(',', '.') + ',"QtyMin":' + format(SalesPrices."Minimum Quantity") + ',"Unit":"' + SalesPrices."Unit of Measure Code" + '","QtyMinOrder":' + format(SalesPrices."Order Minimum Quantity") + '}'
                    until SalesPrices.Next() = 0;
                if (Customer."Customer Price Group" <> '') then begin
                    SalesPrices.SETRANGE("Sales Type", SalesPrices."Sales Type"::"Customer Price Group");
                    SalesPrices.SetRange("Sales Code", Customer."Customer Price Group");
                    SalesPrices.SetRange("Item No.", Rec."Item No.");
                    //SalesPrices.SetFilter("Starting Date", '<=%1', Today);
                    SalesPrices.SetFilter("Ending Date", '>=%1', Today);
                    if SalesPrices.FindSet() then
                        repeat
                            if NOT TempIUOM.GET(rec."Item No.", SalesPrices."Unit of Measure Code") then begin
                                TempIUOM.INIT;
                                TempIUOM."Item No." := rec."Item No.";
                                TempIUOM."Code" := SalesPrices."Unit of Measure Code";
                                IUOM.Reset();
                                IF IUOM.GET(rec."Item No.", SalesPrices."Unit of Measure Code") then
                                    TempIUOM."Qty. per Unit of Measure" := IUOM."Qty. per Unit of Measure";
                                TempIUOM.INSERT;
                            end;
                            if Prices <> '[' then Prices += ',';
                            Prices += '{"Start":"' + format(CreateDateTime(SalesPrices."Starting Date", 010000T), 0, 9) + '","UnitPrice":' + format(SalesPrices."Unit Price").Replace(',', '.') + ',"UnitStartPrice":' + format(SalesPrices."Unit Start Price").Replace(',', '.') + ',"QtyMin":' + format(SalesPrices."Minimum Quantity") + ',"Unit":"' + SalesPrices."Unit of Measure Code" + '","QtyMinOrder":' + format(SalesPrices."Order Minimum Quantity") + '}'
                        until SalesPrices.Next() = 0;
                end;
                Prices += ']';
                Units := '[';
                if TempIUOM.FindSet() then
                    repeat
                        if Units <> '[' then Units += ',';
                        Units += '{"unit":"' + TempIUOM.Code + '","QtyPerUnit":' + format(TempIUOM."Qty. per Unit of Measure").Replace(',', '.') + '}'
                    until TempIUOM.next = 0;
                Units += ']';
            end;

        if "Reference Type" = "Reference Type"::Vendor then
            if Vendor.Get("Reference Type No.") then
                CustVendorName := Vendor.Name;


    end;
}

