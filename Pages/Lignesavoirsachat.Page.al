page 50007 "Lignes avoirs achat"
{
    Caption = 'Lignes avoirs achat';
    PageType = List;
    SourceTable = "Purch. Inv. Line";
    UsageCategory = ReportsAndAnalysis;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Buy-from Vendor No."; "Buy-from Vendor No.")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Line No."; "Line No.")
                {
                }
                field(Type; Type)
                {
                }
                field("No."; "No.")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field(Description; Description)
                {
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Direct Unit Cost"; "Direct Unit Cost")
                {
                }
                field(Amount; Amount)
                {
                }
                field("Amount Including VAT"; "Amount Including VAT")
                {
                }
                field("Receipt No."; "Receipt No.")
                {
                }
                field("Receipt Line No."; "Receipt Line No.")
                {
                }
                field("Order No."; "Order No.")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Order Line No."; "Order Line No.")
                {
                }
                field("Transport Customer No"; "Transport Customer No")
                {
                }
                field("Transport Sales Order No"; "Transport Sales Order No")
                {
                }
                field("Gross Weight"; "Gross Weight")
                {
                }
                field("Net Weight"; "Net Weight")
                {
                }
                field("Transport Sales Invoice No"; "Transport Sales Invoice No")
                {
                }
                field(ComptaReceipt; ComptaReceipt)
                {
                    Caption = 'Date reception';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        ComptaReceipt := 0D;

        if Receip.Get("Receipt No.") then
            ComptaReceipt := Receip."Posting Date";
    end;

    var
        ComptaReceipt: Date;
        Receip: Record "Purch. Rcpt. Header";
}

