report 50072 "Liste des OF"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/ListedesOF.rdlc';
    AdditionalSearchTerms = 'Liste des OF';
    Caption = 'Liste des O.F. ';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Production Order"; "Production Order")
        {

            RequestFilterFields = "Source No.", "Starting Date";
            column(Machine_ProductionOrder; "Production Order".Machine)
            {
            }
            column(CommentairesVP_ProductionOrder; "Production Order"."Commentaires VP")
            {
            }
            column(StartingDateTime_ProductionOrder; "Production Order"."Starting Date-Time")
            {
            }
            dataitem("Prod. Order Line"; "Prod. Order Line")
            {
                DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("No.");
                column(ItemNo_ProdOrderLine; "Prod. Order Line"."Item No.")
                {
                }
                column(ProdOrderNo_ProdOrderLine; "Prod. Order Line"."Prod. Order No.")
                {
                }
                column(Description_ProdOrderLine; "Prod. Order Line".Description)
                {
                }
                column(StartingDate_ProdOrderLine; "Prod. Order Line"."Starting Date")
                {
                }
                column(Quantity_ProdOrderLine; "Prod. Order Line".Quantity)
                {
                }
                column(Lot; Lot)
                {
                }
                column(First5; First5)
                {
                }
                column(FormatBarquette; FormatBarquette)
                {
                }
                dataitem("Reservation Entry"; "Reservation Entry")
                {
                    DataItemLink = "Source ID" = FIELD("Prod. Order No."), "Source Prod. Order Line" = FIELD("Line No.");
                    column(WarrantyDate_ReservationEntry; "Reservation Entry"."Warranty Date")
                    {
                    }
                    column(LotNo_ReservationEntry; "Reservation Entry"."Lot No.")
                    {
                    }
                }
                dataitem("Sales Line"; "Sales Line")
                {
                    DataItemLink = "No." = FIELD("Item No."), "Date de production" = FIELD("Starting Date");
                    column(DocumentNo_SalesLine; "Sales Line"."Document No.")
                    {
                    }
                    column(QuantityBase_SalesLine; "Sales Line"."Quantity (Base)")
                    {
                    }
                    column(NomClient; NomClient)
                    {
                    }
                    column(PromisedDeliveryDate_SalesLine; "Sales Line"."Promised Delivery Date")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        recCust.Get("Sales Line"."Sell-to Customer No.");
                        NomClient := recCust.Name;
                    end;
                }
                dataitem("Integer"; "Integer")
                {
                    DataItemTableView = SORTING(Number) ORDER(Ascending) WHERE(Number = CONST(1));
                    column(QTYProdOrder; "Prod. Order Line".Quantity)
                    {
                    }
                }

                trigger OnAfterGetRecord()
                var
                    Items: Record Item;
                    Comp: Record "Prod. Order Component";
                begin
                    if Items.Get("Prod. Order Line"."Item No.") then begin
                        FormatBarquette := Items."Criteria 9";
                    end;
                    First5 := '';
                    Comp.SetRange(Status, "Prod. Order Line".Status);
                    Comp.SetRange("Prod. Order No.", "Prod. Order Line"."Prod. Order No.");
                    Comp.SetRange("Prod. Order Line No.", "Prod. Order Line"."Line No.");
                    Comp.SetFilter("Item No.", '4*|5*&<>5-SAU*');
                    if Comp.FindSet then
                        repeat
                            First5 := First5 + '  ' + Comp."Item No.";
                        until Comp.Next = 0;
                    Lot := Format("Prod. Order Line"."Starting Date", 2, '<Year,2>') + Utils.PadLeft(Format("Prod. Order Line"."Starting Date" - DMY2Date(1, 1, Date2DMY("Prod. Order Line"."Starting Date", 3)) + 1), '0', 3);
                end;

                trigger OnPreDataItem()
                var
                    Items: Record Item;
                begin
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if Items.Get("Production Order"."Source No.") then begin
                    if Items."Criteria 12" <> '' then
                        "Commentaires VP" := Items."Criteria 12" + "Commentaires VP";
                end;
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

    var
        FormatBarquette: Text;
        NomClient: Text;
        recCust: Record Customer;
        First5: Code[50];
        Lot: Code[20];
        Utils: Codeunit Utils;
        Items: Record Item;
}

