report 50042 "CTD LFO TEMP"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/CTDLFOTEMP.rdlc';
    Permissions = TableData "Item Ledger Entry" = rimd,
                  TableData "Value Entry" = rimd;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = WHERE("Document No." = FILTER('WB-00612926'), "Entry Type" = FILTER(Consumption), Quantity = FILTER(> 0));

            trigger OnAfterGetRecord()
            begin
                "Item Ledger Entry"."Entry Type" := "Item Ledger Entry"."Entry Type"::Output;
                //MODIFY;
            end;

            trigger OnPreDataItem()
            begin
                //MESSAGE(FORMAT(COUNT));
            end;
        }
        dataitem("Value Entry"; "Value Entry")
        {
            DataItemTableView = WHERE("Document No." = FILTER('WB-00612926'), "Item Ledger Entry Quantity" = FILTER(> 0), "Item Ledger Entry Type" = FILTER(Consumption));

            trigger OnAfterGetRecord()
            begin
                "Value Entry"."Item Ledger Entry Type" := "Value Entry"."Item Ledger Entry Type"::Output;
                Modify;
            end;

            trigger OnPreDataItem()
            begin
                Message(Format(Count));
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

