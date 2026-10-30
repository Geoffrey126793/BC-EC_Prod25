report 50034 "Liste palettes"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/Listepalettes.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Pallet; Pallet)
        {
            DataItemTableView = SORTING("SSCC No.") ORDER(Descending);
            RequestFilterFields = "Location code", "Current Quantity", "Bin code";
            column(ItemNo_Pallet; Pallet."Item No.")
            {
            }
            column(LotNo_Pallet; Pallet."Lot No.")
            {
            }
            column(DLC_Pallet; Pallet.DLC)
            {
            }
            column(CreationDate_Pallet; Pallet."Creation Date")
            {
            }
            column(SSCCNo_Pallet; Pallet."SSCC No.")
            {
            }
            column(CurrentQuantity_Pallet; Pallet."Current Quantity")
            {
            }
            column(InboundDocumentNo_Pallet; Pallet."Inbound Document No.")
            {
            }
            column(OutboundDocumentNo_Pallet; Pallet."Outbound Document No.")
            {
            }
            column(Bincode_Pallet; Pallet."Bin code")
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

