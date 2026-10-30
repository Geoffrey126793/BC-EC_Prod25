pageextension 70114 pageextension70114 extends "Sales Order Subform"
{
    layout
    {

        modify("Unit Price")
        {
            Visible = ShowPrice;
        }
        modify("Line Discount %")
        {
            Visible = ShowPrice;
        }
        modify("Line Amount")
        {
            Visible = ShowPrice;
        }
        modify("Line Discount Amount")
        {
            Visible = ShowPrice;
        }
        modify(Control45)
        {
            Visible = ShowPrice;
        }
        modify("TotalSalesLine.""Line Amount""")
        {
            Visible = ShowPrice;
        }
        modify("Invoice Discount Amount")
        {
            Visible = ShowPrice;
        }
        modify("Invoice Disc. Pct.")
        {
            Visible = ShowPrice;
        }
        modify(Control28)
        {
            Visible = ShowPrice;
        }
        modify("Total Amount Excl. VAT")
        {
            Visible = ShowPrice;
        }
        modify("Total VAT Amount")
        {
            Visible = ShowPrice;
        }
        modify("Total Amount Incl. VAT")
        {
            Visible = ShowPrice;
        }

        modify("No.")
        {
            StyleExpr = StyleTypeProd;
            trigger OnAssistEdit()
            var
                PItemList: Page "Item List";
                Items: Record Item;
            begin
                if Type = Type::Item then begin
                    Items.Reset;
                    Items.SetRange("No.", "No.");
                    if Items.FindFirst then;
                    Items.SetRange("No.");
                    PItemList.SetRecord(Items);
                    PItemList.SetTableView(Items);
                    PItemList.LookupMode := true;
                    if PItemList.RunModal = ACTION::LookupOK then begin
                        PItemList.GetRecord(Items);
                        Validate("No.", Items."No.");
                    end;
                end;
            end;

            trigger OnAfterValidate()
            var
                cuSales: Codeunit "Integration_Sales";
            begin
                if cuSales.AddDefaultSalesLines(Rec) then
                    CurrPage.Update(true);
            end;
        }

        modify("Item Reference No.")
        {
            Visible = true;
            trigger OnAfterValidate()
            var
                cuSales: Codeunit "Integration_Sales";
            begin
                if cuSales.AddDefaultSalesLines(Rec) then
                    CurrPage.Update(true);
            end;
        }


        addafter(Quantity)
        {
            field("Quantity (Base)"; "Quantity (Base)")
            {
                Editable = false;
            }
            field("Date de production"; "Date de production")
            {
            }
        }

        addafter("Line No.")
        {
            field("Qte commandée initiale"; "Qte commandée initiale")
            {
            }
            field("Transport line"; "Transport line")
            {
            }
            field("Reason Free Code"; "Reason Free Code")
            {
            }
            field("Forced Line Discount %"; "Forced Line Discount %")
            {
            }
            field("Forced Unit Price"; "Forced Unit Price")
            {
            }
            field("Px 3x Net"; "Px 3x Net")
            {
                Editable = false;
                Visible = ShowPrice;
            }
            field("Px Depart"; "Px Depart")
            {
                Editable = false;
                Visible = ShowPrice;
            }
            field("Article 5"; Intermediaire5)
            {
            }
            field("Stock 5"; Interm5Delivery)
            {
            }
            field("Qte commandée initiale Base"; "Qte commandée initiale Base")
            {
                Caption = 'Quantité commandée initialement par le client';
            }
        }
    }
    actions
    {
        addafter(OrderPromising)
        {
            action("OF")
            {
                Caption = 'Ordre de fabrication';

                trigger OnAction()
                var
                    "OF": Record "Production Order";
                begin
                    if "Date de production" <> 0D then begin
                        "OF".Reset;
                        "OF".SetRange("Source Type", "OF"."Source Type"::Item);
                        "OF".SetRange("Source No.", Rec."No.");
                        "OF".SetRange("Starting Date", "Date de production");
                        if "OF".FindFirst then
                            PAGE.Run(99000831, "OF");

                    end;
                end;
            }
            action("Calcul OF")
            {

                trigger OnAction()
                var
                    Rep: Report "Quantity Explosion of BOMEC";
                    Items: Record Item;
                begin
                    Rep.SetQtyProd(Rec."Qty. to Ship (Base)");
                    Items.SetFilter("No.", Rec."No.");
                    Rep.SetTableView(Items);
                    //Rep.USEREQUESTPAGE := FALSE;
                    Rep.Run();
                end;
            }
        }
    }

    var
        BomL: Record "Production BOM Line";
        rItem: Record Item;
        VersionMgt: Codeunit VersionManagement;

    var
        ShowPrice: Boolean;
        CuUtils: Codeunit "Absys - tools PJ";
        "5_no": Text;
        StyleTypeProd: Text;
        Interm5Delivery: Decimal;
        CalcStock: Codeunit "Stock EC";


    trigger OnAfterGetRecord()
    begin
        StyleTypeProd := '';
        "5_no" := '';
        Interm5Delivery := 0;
        if rItem.Get("No.") then begin
            BomL.Reset;
            BomL.SetRange("Production BOM No.", rItem."Production BOM No.");
            BomL.SetRange("Version Code", VersionMgt.GetBOMVersion(rItem."Production BOM No.", Today, true));
            BomL.SetFilter("No.", '5-F*');
            if BomL.FindSet then
                repeat
                    "5_no" := "5_no" + BomL."No.";
                until BomL.Next = 0;

            if rItem."Option production" = rItem."Option production"::"Stock standard" then
                StyleTypeProd := 'Favorable';
            if rItem."Option production" = rItem."Option production"::"Stock client" then
                StyleTypeProd := 'StrongAccent';
            if Rec."Promised Delivery Date" <> 0D then
                Interm5Delivery := CalcStock.getIntermediaireStock(rItem, Rec."Promised Delivery Date")
            else
                Interm5Delivery := CalcStock.getIntermediaireStock(rItem, Today);
        end;
    end;


    trigger OnOpenPage()
    begin
        ShowPrice := (CuUtils.GetRole('SALES-PRICES') or CuUtils.GetRole('COMMERCIAUX'));
    end;

}

