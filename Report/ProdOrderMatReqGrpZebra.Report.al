report 50025 "Prod. Order-Mat. Req Grp Zebra"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/ProdOrderMatReqGrpZebra.rdlc';
    ApplicationArea = Manufacturing;
    Caption = 'Prod. Order - Mat. Requisition';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            DataItemTableView = SORTING(Status, "No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = Status, "No.", "Source Type", "Source No.", "Starting Date";
            column(TodayFormatted; Format(Today, 0, 4))
            {
            }
            column(CompanyName; COMPANYPROPERTY.DisplayName)
            {
            }
            column(ProdOrderTableCaptionFilter; TableCaption + ':' + ProdOrderFilter)
            {
            }
            column(No_ProdOrder; "No.")
            {
            }
            column(Desc_ProdOrder; Description)
            {
            }
            column(SourceNo_ProdOrder; "Source No.")
            {
                IncludeCaption = true;
            }
            column(Status_ProdOrder; Status)
            {
            }
            column(Qty_ProdOrder; Quantity)
            {
                IncludeCaption = true;
            }
            column(Filter_ProdOrder; ProdOrderFilter)
            {
            }
            column(ProdOrderMaterialRqstnCapt; ProdOrderMaterialRqstnCaptLbl)
            {
            }
            column(CurrReportPageNoCapt; CurrReportPageNoCaptLbl)
            {
            }
            dataitem("Prod. Order Component"; "Prod. Order Component")
            {
                DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("No.");
                DataItemTableView = SORTING(Status, "Prod. Order No.", "Prod. Order Line No.", "Line No.") WHERE("Item No." = FILTER('7-EPC*' | '8-*'));
                RequestFilterFields = "Item No.";
                column(ItemNo_ProdOrderComp; "Item No.")
                {
                    IncludeCaption = true;
                }
                column(Desc_ProdOrderComp; Description)
                {
                    IncludeCaption = true;
                }
                column(Qtyper_ProdOrderComp; "Quantity per")
                {
                    IncludeCaption = true;
                }
                column(UOMCode_ProdOrderComp; "Unit of Measure Code")
                {
                    IncludeCaption = true;
                }
                column(RemainingQty_ProdOrderComp; "Remaining Quantity")
                {
                    IncludeCaption = true;
                }
                column(Scrap_ProdOrderComp; "Scrap %")
                {
                    IncludeCaption = true;
                }
                column(DueDate_ProdOrderComp; Format("Due Date"))
                {
                    IncludeCaption = false;
                }
                column(QtySansScrap; QtySansScrap)
                {
                }
                column(QtyBesoin; QtyBesoin)
                {
                }
                column(LocationCode_ProdOrderComp; "Location Code")
                {
                    IncludeCaption = true;
                }

                trigger OnAfterGetRecord()
                begin
                    if CopyStr("Prod. Order Component"."Item No.", 1, 5) = '8-GAZ' then
                        CurrReport.Skip;
                    "Prod. Order Component"."Remaining Quantity" := "Prod. Order Component"."Remaining Quantity" / (1 + "Prod. Order Component"."Scrap %" / 100);
                    with ReservationEntry do begin
                        SetCurrentKey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");

                        SetRange("Source Type", DATABASE::"Prod. Order Component");
                        SetRange("Source ID", "Production Order"."No.");
                        SetRange("Source Ref. No.", "Line No.");
                        SetRange("Source Subtype", Status);
                        SetRange("Source Batch Name", '');
                        SetRange("Source Prod. Order Line", "Prod. Order Line No.");

                        if FindSet then begin
                            RemainingQtyReserved := 0;
                            repeat
                                if ReservationEntry2.Get("Entry No.", not Positive) then
                                    if (ReservationEntry2."Source Type" = DATABASE::"Prod. Order Line") and
                                       (ReservationEntry2."Source ID" = "Prod. Order Component"."Prod. Order No.")
                                    then
                                        RemainingQtyReserved += ReservationEntry2."Quantity (Base)";
                            until Next = 0;
                            if "Prod. Order Component"."Remaining Qty. (Base)" = RemainingQtyReserved then
                                CurrReport.Skip;
                        end;
                    end;

                    QtySansScrap := "Expected Qty. (Base)" / (1 + "Scrap %" / 100);
                    if Items.Get("Item No.") then begin
                        QtyBesoin := QtySansScrap * (1 + Items."% supplémentaire à préparer" / 100);
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    SetFilter("Remaining Quantity", '<>0');
                end;
            }

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
        ProdOrderCompDueDateCapt = 'Due Date';
    }

    var
        ReservationEntry: Record "Reservation Entry";
        ReservationEntry2: Record "Reservation Entry";
        ProdOrderFilter: Text;
        RemainingQtyReserved: Decimal;
        ProdOrderMaterialRqstnCaptLbl: Label 'Prod. Order - Material Requisition';
        CurrReportPageNoCaptLbl: Label 'Page';
        QtySansScrap: Decimal;
        QtyBesoin: Decimal;
        Items: Record Item;
}

