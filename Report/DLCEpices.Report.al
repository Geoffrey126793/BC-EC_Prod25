report 50023 "DLC Epices"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/DLCEpices.rdlc';

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = WHERE("Item No." = FILTER('7-EPC*' | '5-FRS*' | '7-CFR*'), Open = CONST(true), "Remaining Quantity" = FILTER(> 0));
            column(ItemNo_ItemLedgerEntry; "Item Ledger Entry"."Item No.")
            {
            }
            column(RemainingQuantity_ItemLedgerEntry; "Item Ledger Entry"."Remaining Quantity")
            {
            }
            column(LotNo_ItemLedgerEntry; "Item Ledger Entry"."Lot No.")
            {
            }
            column(WarrantyDate_ItemLedgerEntry; "Item Ledger Entry"."Warranty Date")
            {
            }

            trigger OnPreDataItem()
            begin
                "Item Ledger Entry".SetFilter("Warranty Date", '<=%', CalcDate('<+2M>', Today));
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
}

