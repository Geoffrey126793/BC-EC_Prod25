report 50039 EpicesTournai
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/EpicesTournai.rdlc';

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = WHERE("Item No." = FILTER('7-EPC-*'), "Location Code" = CONST('EC TOURNAI'), "Remaining Quantity" = FILTER(> 0));
            column(ItemNo_ItemLedgerEntry; "Item Ledger Entry"."Item No.")
            {
            }
            column(Description_ItemLedgerEntry; "Item Ledger Entry".Description)
            {
            }
            column(RemainingQuantity_ItemLedgerEntry; "Item Ledger Entry"."Remaining Quantity")
            {
            }
            column(LotNo_ItemLedgerEntry; "Item Ledger Entry"."Lot No.")
            {
            }
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

