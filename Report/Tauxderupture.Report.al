report 50038 "Taux de rupture"
{
    Caption = 'Taux de rupture';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Sales Shipment Line"; "Sales Shipment Line")
        {
            RequestFilterFields = "Item Category Code", "No.", "Posting Date";

            trigger OnAfterGetRecord()
            begin
                if (LastArticle <> "No.") and (LastArticle <> '') then begin
                    ExcelBuf.Init;
                    ExcelBuf.Validate("Row No.", RowNo);
                    ExcelBuf.Validate("Column No.", 1);
                    ExcelBuf."Cell Value as Text" := 'Total Article';
                    ExcelBuf.Bold := true;
                    ExcelBuf.Insert;
                    ExcelBuf.Init;
                    ExcelBuf.Validate("Row No.", RowNo);
                    ExcelBuf.Validate("Column No.", 2);
                    ExcelBuf."Cell Value as Text" := LastCategorie;
                    ExcelBuf.Insert;
                    ExcelBuf.Init;
                    ExcelBuf.Validate("Row No.", RowNo);
                    ExcelBuf.Validate("Column No.", 3);
                    ExcelBuf."Cell Value as Text" := LastArticle;
                    ExcelBuf.Insert;
                    ExcelBuf.Init;
                    ExcelBuf.Validate("Row No.", RowNo);
                    ExcelBuf.Validate("Column No.", 6);
                    ExcelBuf."Cell Value as Text" := Format(TotalLivArticle);
                    ExcelBuf.Insert;
                    ExcelBuf.Init;
                    ExcelBuf.Validate("Row No.", RowNo);
                    ExcelBuf.Validate("Column No.", 7);
                    ExcelBuf."Cell Value as Text" := Format(TotalCmdArticle);
                    ExcelBuf.Insert;
                    ExcelBuf.Init;
                    ExcelBuf.Validate("Row No.", RowNo);
                    ExcelBuf.Validate("Column No.", 8);
                    ExcelBuf."Cell Value as Text" := Format(TotalCmdArticle - TotalLivArticle);
                    ExcelBuf.Insert;
                    ExcelBuf.Init;
                    ExcelBuf.Validate("Row No.", RowNo);
                    ExcelBuf.Validate("Column No.", 9);
                    ExcelBuf."Cell Value as Text" := Format(Round(100 * (TotalCmdArticle - TotalLivArticle) / TotalCmdArticle, 0.01));
                    ExcelBuf.Insert;
                    TotalLivArticle := 0;
                    TotalCmdArticle := 0;
                    RowNo += 1;
                end;

                if (LastCategorie <> "Item Category Code") and (LastCategorie <> '') then begin
                    ExcelBuf.Init;
                    ExcelBuf.Validate("Row No.", RowNo);
                    ExcelBuf.Validate("Column No.", 1);
                    ExcelBuf."Cell Value as Text" := 'Total Catégorie';
                    ExcelBuf.Bold := true;
                    ExcelBuf.Italic := true;
                    ExcelBuf.Insert;
                    ExcelBuf.Init;
                    ExcelBuf.Validate("Row No.", RowNo);
                    ExcelBuf.Validate("Column No.", 2);
                    ExcelBuf."Cell Value as Text" := LastCategorie;
                    ExcelBuf.Insert;
                    ExcelBuf.Init;
                    ExcelBuf.Validate("Row No.", RowNo);
                    ExcelBuf.Validate("Column No.", 6);
                    ExcelBuf."Cell Value as Text" := Format(TotalLivCat);
                    ExcelBuf.Insert;
                    ExcelBuf.Init;
                    ExcelBuf.Validate("Row No.", RowNo);
                    ExcelBuf.Validate("Column No.", 7);
                    ExcelBuf."Cell Value as Text" := Format(TotalCmdCat);
                    ExcelBuf.Insert;
                    ExcelBuf.Init;
                    ExcelBuf.Validate("Row No.", RowNo);
                    ExcelBuf.Validate("Column No.", 8);
                    ExcelBuf."Cell Value as Text" := Format(TotalCmdCat - TotalLivCat);
                    ExcelBuf.Insert;
                    ExcelBuf.Init;
                    ExcelBuf.Validate("Row No.", RowNo);
                    ExcelBuf.Validate("Column No.", 9);
                    ExcelBuf."Cell Value as Text" := Format(Round(100 * (TotalCmdCat - TotalLivCat) / TotalCmdCat, 0.01));
                    ExcelBuf.Insert;
                    TotalLivCat := 0;
                    TotalCmdCat := 0;
                    RowNo += 1;
                end;
                QtyUnit := 1;
                if "Sales Shipment Line".Quantity > 0 then
                    QtyUnit := "Sales Shipment Line"."Quantity (Base)" / "Sales Shipment Line".Quantity;



                LastArticle := "No.";
                LastCategorie := "Item Category Code";
                TotalCmdCat += "Sales Shipment Line"."Qte commandée initiale" * QtyUnit;
                TotalCmdArticle += "Sales Shipment Line"."Qte commandée initiale" * QtyUnit;
                TotalLivCat += "Sales Shipment Line".Quantity * QtyUnit;
                TotalLivArticle += "Sales Shipment Line".Quantity * QtyUnit;

                if Quantity <> "Qte commandée initiale" then begin
                    ExcelBuf.Init;
                    ExcelBuf.Validate("Row No.", RowNo);
                    ExcelBuf.Validate("Column No.", 1);
                    ExcelBuf."Cell Value as Text" := 'Rupture';
                    ExcelBuf.Insert;
                    ExcelBuf.Init;
                    ExcelBuf.Validate("Row No.", RowNo);
                    ExcelBuf.Validate("Column No.", 2);
                    ExcelBuf."Cell Value as Text" := "Sales Shipment Line"."Item Category Code";
                    ExcelBuf.Insert;
                    ExcelBuf.Init;
                    ExcelBuf.Validate("Row No.", RowNo);
                    ExcelBuf.Validate("Column No.", 3);
                    ExcelBuf."Cell Value as Text" := "Sales Shipment Line"."No.";
                    ExcelBuf.Insert;
                    ExcelBuf.Init;
                    ExcelBuf.Validate("Row No.", RowNo);
                    ExcelBuf.Validate("Column No.", 4);
                    ExcelBuf."Cell Value as Text" := Format("Sales Shipment Line"."Shipment Date");
                    ExcelBuf.Insert;
                    ExcelBuf.Init;
                    ExcelBuf.Validate("Row No.", RowNo);
                    ExcelBuf.Validate("Column No.", 5);
                    ExcelBuf."Cell Value as Text" := "Sales Shipment Line"."Order No.";
                    ExcelBuf.Insert;
                    ExcelBuf.Init;
                    ExcelBuf.Validate("Row No.", RowNo);
                    ExcelBuf.Validate("Column No.", 6);
                    ExcelBuf."Cell Value as Text" := Format("Sales Shipment Line".Quantity * QtyUnit);
                    ExcelBuf.Insert;
                    ExcelBuf.Init;
                    ExcelBuf.Validate("Row No.", RowNo);
                    ExcelBuf.Validate("Column No.", 7);
                    ExcelBuf."Cell Value as Text" := Format("Sales Shipment Line"."Qte commandée initiale" * QtyUnit);
                    ExcelBuf.Insert;
                    ExcelBuf.Init;
                    ExcelBuf.Validate("Row No.", RowNo);
                    ExcelBuf.Validate("Column No.", 8);
                    ExcelBuf."Cell Value as Text" := Format("Sales Shipment Line"."Qte commandée initiale" * QtyUnit
                    - "Sales Shipment Line".Quantity * QtyUnit);
                    ExcelBuf.Insert;
                    ExcelBuf.Init;
                    ExcelBuf.Validate("Row No.", RowNo);
                    ExcelBuf.Validate("Column No.", 9);
                    // ExcelBuf."Cell Value as Text" := FORMAT(ROUND(100*("Sales Shipment Line"."Qte commandée initiale" -
                    // "Sales Shipment Line".Quantity)/"Sales Shipment Line"."Qte commandée initiale",0.01));
                    ExcelBuf.Insert;

                    RowNo += 1;
                end;
            end;

            trigger OnPostDataItem()
            begin
                ExcelBuf.Init;
                ExcelBuf.Validate("Row No.", RowNo);
                ExcelBuf.Validate("Column No.", 1);
                ExcelBuf."Cell Value as Text" := 'Total Article';
                ExcelBuf.Bold := true;
                ExcelBuf.Insert;
                ExcelBuf.Init;
                ExcelBuf.Validate("Row No.", RowNo);
                ExcelBuf.Validate("Column No.", 2);
                ExcelBuf."Cell Value as Text" := LastCategorie;
                ExcelBuf.Insert;
                ExcelBuf.Init;
                ExcelBuf.Validate("Row No.", RowNo);
                ExcelBuf.Validate("Column No.", 3);
                ExcelBuf."Cell Value as Text" := LastArticle;
                ExcelBuf.Insert;
                ExcelBuf.Init;
                ExcelBuf.Validate("Row No.", RowNo);
                ExcelBuf.Validate("Column No.", 6);
                ExcelBuf."Cell Value as Text" := Format(TotalLivArticle);
                ExcelBuf.Insert;
                ExcelBuf.Init;
                ExcelBuf.Validate("Row No.", RowNo);
                ExcelBuf.Validate("Column No.", 7);
                ExcelBuf."Cell Value as Text" := Format(TotalCmdArticle);
                ExcelBuf.Insert;
                ExcelBuf.Init;
                ExcelBuf.Validate("Row No.", RowNo);
                ExcelBuf.Validate("Column No.", 8);
                ExcelBuf."Cell Value as Text" := Format(TotalCmdArticle - TotalLivArticle);
                ExcelBuf.Insert;
                ExcelBuf.Init;
                ExcelBuf.Validate("Row No.", RowNo);
                ExcelBuf.Validate("Column No.", 9);
                ExcelBuf."Cell Value as Text" := Format(Round(100 * (TotalCmdArticle - TotalLivArticle) / TotalCmdArticle, 0.01));
                ExcelBuf.Insert;
                TotalLivArticle := 0;
                TotalCmdArticle := 0;
                RowNo += 1;


                ExcelBuf.Init;
                ExcelBuf.Validate("Row No.", RowNo);
                ExcelBuf.Validate("Column No.", 1);
                ExcelBuf."Cell Value as Text" := 'Total Catégorie';
                ExcelBuf.Bold := true;
                ExcelBuf.Italic := true;
                ExcelBuf.Insert;
                ExcelBuf.Init;
                ExcelBuf.Validate("Row No.", RowNo);
                ExcelBuf.Validate("Column No.", 2);
                ExcelBuf."Cell Value as Text" := LastCategorie;
                ExcelBuf.Insert;
                ExcelBuf.Init;
                ExcelBuf.Validate("Row No.", RowNo);
                ExcelBuf.Validate("Column No.", 6);
                ExcelBuf."Cell Value as Text" := Format(TotalLivCat);
                ExcelBuf.Insert;
                ExcelBuf.Init;
                ExcelBuf.Validate("Row No.", RowNo);
                ExcelBuf.Validate("Column No.", 7);
                ExcelBuf."Cell Value as Text" := Format(TotalCmdCat);
                ExcelBuf.Insert;
                ExcelBuf.Init;
                ExcelBuf.Validate("Row No.", RowNo);
                ExcelBuf.Validate("Column No.", 8);
                ExcelBuf."Cell Value as Text" := Format(TotalCmdCat - TotalLivCat);
                ExcelBuf.Insert;
                ExcelBuf.Init;
                ExcelBuf.Validate("Row No.", RowNo);
                ExcelBuf.Validate("Column No.", 9);
                ExcelBuf."Cell Value as Text" := Format(Round(100 * (TotalCmdCat - TotalLivCat) / TotalCmdCat, 0.01));
                ExcelBuf.Insert;
                TotalLivCat := 0;
                TotalCmdCat := 0;
                RowNo += 1;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("No.");
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

        ExcelBuf.CreateBookAndOpenExcel('', 'Taux de rupture', 'Taux de rupture', CompanyName, UserId);
    end;

    trigger OnPreReport()
    begin
        RowNo := 1;
        ExcelBuf.Init;
        ExcelBuf.Validate("Row No.", RowNo);
        ExcelBuf.Validate("Column No.", 1);
        ExcelBuf."Cell Value as Text" := 'Type';
        ExcelBuf.Bold := true;
        ExcelBuf.Insert;
        ExcelBuf.Init;
        ExcelBuf.Validate("Row No.", RowNo);
        ExcelBuf.Validate("Column No.", 2);
        ExcelBuf."Cell Value as Text" := 'Catégorie';
        ExcelBuf.Bold := true;
        ExcelBuf.Insert;
        ExcelBuf.Init;
        ExcelBuf.Validate("Row No.", RowNo);
        ExcelBuf.Validate("Column No.", 3);
        ExcelBuf."Cell Value as Text" := 'Article';
        ExcelBuf.Bold := true;
        ExcelBuf.Insert;
        ExcelBuf.Init;
        ExcelBuf.Validate("Row No.", RowNo);
        ExcelBuf.Validate("Column No.", 4);
        ExcelBuf."Cell Value as Text" := 'Date';
        ExcelBuf.Bold := true;
        ExcelBuf.Insert;
        ExcelBuf.Init;
        ExcelBuf.Validate("Row No.", RowNo);
        ExcelBuf.Validate("Column No.", 5);
        ExcelBuf."Cell Value as Text" := 'Commande';
        ExcelBuf.Bold := true;
        ExcelBuf.Insert;
        ExcelBuf.Init;
        ExcelBuf.Validate("Row No.", RowNo);
        ExcelBuf.Validate("Column No.", 6);
        ExcelBuf."Cell Value as Text" := 'Quantité livrée';
        ExcelBuf.Bold := true;
        ExcelBuf.Insert;
        ExcelBuf.Init;
        ExcelBuf.Validate("Row No.", RowNo);
        ExcelBuf.Validate("Column No.", 7);
        ExcelBuf."Cell Value as Text" := 'Quantité commandée';
        ExcelBuf.Bold := true;
        ExcelBuf.Insert;
        ExcelBuf.Init;
        ExcelBuf.Validate("Row No.", RowNo);
        ExcelBuf.Validate("Column No.", 8);
        ExcelBuf."Cell Value as Text" := 'Différence';
        ExcelBuf.Bold := true;
        ExcelBuf.Insert;
        ExcelBuf.Init;
        ExcelBuf.Validate("Row No.", RowNo);
        ExcelBuf.Validate("Column No.", 9);
        ExcelBuf."Cell Value as Text" := 'Taux de rupture';
        ExcelBuf.Bold := true;
        ExcelBuf.Insert;

        RowNo += 1;
    end;

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        TotalFor: Label 'Total ';
        ExcelBuf: Record "Excel Buffer" temporary;
        RowNo: Integer;
        LastArticle: Code[20];
        LastCategorie: Code[20];
        TotalLivArticle: Decimal;
        TotalCmdArticle: Decimal;
        TotalLivCat: Decimal;
        TotalCmdCat: Decimal;
        QtyUnit: Decimal;
        Unit: Record "Item Unit of Measure";
}

