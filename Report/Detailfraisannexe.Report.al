report 50080 "Detail frais annexe"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/Detailfraisannexe.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = WHERE("Entry Type" = CONST(Purchase));
            RequestFilterFields = "Posting Date", "Item No.", "Source No.";
            column(Item_Ledger_Entry__Document_No__; "Document No.")
            {
            }
            column(Item_Ledger_Entry_Quantity; Quantity)
            {
            }
            column(Item_Ledger_Entry__Posting_Date_; "Posting Date")
            {
            }
            column(Item_Ledger_Entry__Item_No__; "Item No.")
            {
            }
            column(Item_Ledger_Entry__Document_Line_No__; "Document Line No.")
            {
            }
            column(Item_Ledger_Entry__Source_No__; "Source No.")
            {
            }
            column(Item_Ledger_Entry_Entry_No_; "Entry No.")
            {
            }
            dataitem("Value Entry"; "Value Entry")
            {
                DataItemLink = "Item Ledger Entry No." = FIELD("Entry No.");
                DataItemTableView = WHERE("Item Charge No." = FILTER(<> ''));
                column(Value_Entry__Posting_Date_; "Posting Date")
                {
                }
                column(Value_Entry__Item_Charge_No__; "Item Charge No.")
                {
                }
                column(Value_Entry_Description; Description)
                {
                }
                column(Value_Entry__Cost_Amount__Actual__; "Cost Amount (Actual)")
                {
                }
                column(Value_Entry__Source_No__; "Source No.")
                {
                }
                column(Value_Entry__Document_No__; "Document No.")
                {
                }
                column(Value_Entry_Entry_No_; "Entry No.")
                {
                }
                column(Value_Entry_Item_Ledger_Entry_No_; "Item Ledger Entry No.")
                {
                }
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

