codeunit 8001503 "Aggregate, Footer & Line Disc."
{
    // //+RFA+ GESWAY 11/07/02 Calcul du total remise ligne et pied.

    TableNo = "Statistic aggregate";

    trigger OnRun()
    begin
        SaleDiscEntry.SetRange(Type, Type);
        SaleDiscEntry.SetRange("No.", "No.");
        SaleDiscEntry.SetRange("Customer No.", "Source No.");
        SaleDiscEntry.SetRange("Location Code", "Location Code");
        SaleDiscEntry.SetRange("Inventory Posting Group", "Inventory Posting Group");
        SaleDiscEntry.SetRange("Cust. Posting Group", "Source Posting Group");
        SaleDiscEntry.SetRange("Gen. Bus. Posting Group", "Gen. Bus. Posting Group");
        SaleDiscEntry.SetRange("Gen. Prod. Posting Group", "Gen. Prod. Posting Group");
        SaleDiscEntry.SetRange("Salesperson Code", "Salespers./Purch. Code");
        SaleDiscEntry.SetRange("Global Dimension 1 Code", "Global Dimension 1 Code");
        SaleDiscEntry.SetRange("Global Dimension 2 Code", "Global Dimension 2 Code");
        SaleDiscEntry.SetRange("Reason Code", "Reason Code");
        SaleDiscEntry.SetRange("Ending Date", "Ending Date");
        SaleDiscEntry.SetRange("Job No.", "Job No.");
        SaleDiscEntry.SetRange("Return Reason Code", "Return Reason Code");
        SaleDiscEntry.SetRange("Dimension 1 Code", "Dimension 1 Value Code");
        SaleDiscEntry.SetRange("Dimension 2 Code", "Dimension 2 Value Code");
        SaleDiscEntry.SetRange("Dimension 3 Code", "Dimension 3 Value Code");
        SaleDiscEntry.SetRange("Dimension 4 Code", "Dimension 4 Value Code");
        SaleDiscEntry.SetRange("Dimension 5 Code", "Dimension 5 Value Code");
        SaleDiscEntry.SetRange("Dimension 6 Code", "Dimension 6 Value Code");
        SaleDiscEntry.SetRange("Dimension 7 Code", "Dimension 7 Value Code");
        SaleDiscEntry.SetRange("Dimension 8 Code", "Dimension 8 Value Code");
        SaleDiscEntry.SetRange("Dimension 9 Code", "Dimension 9 Value Code");
        SaleDiscEntry.SetRange("Dimension 10 Code", "Dimension 10 Value Code");
        SaleDiscEntry.SetRange("Dimension 11 Code", "Dimension 11 Value Code");
        SaleDiscEntry.SetRange("Dimension 12 Code", "Dimension 12 Value Code");
        SaleDiscEntry.SetRange("Dimension 13 Code", "Dimension 13 Value Code");
        SaleDiscEntry.SetRange("Dimension 14 Code", "Dimension 14 Value Code");
        SaleDiscEntry.SetRange("Dimension 15 Code", "Dimension 15 Value Code");
        SaleDiscEntry.SetRange("Dimension 16 Code", "Dimension 16 Value Code");
        SaleDiscEntry.SetRange("Dimension 17 Code", "Dimension 17 Value Code");
        SaleDiscEntry.SetRange("Dimension 18 Code", "Dimension 18 Value Code");
        SaleDiscEntry.SetRange("Dimension 19 Code", "Dimension 19 Value Code");
        SaleDiscEntry.SetRange("Dimension 20 Code", "Dimension 20 Value Code");

        SaleDiscEntry.SetRange("Disc. Commission Type", SaleDiscEntry."Disc. Commission Type"::"Line Discount");
        "Lines discount total" := 0;
        if SaleDiscEntry.Find('-') then
            repeat
                "Lines discount total" := "Lines discount total" + SaleDiscEntry."Discount Amount (LCY)";
            until SaleDiscEntry.Next = 0;

        SaleDiscEntry.SetRange("Disc. Commission Type", SaleDiscEntry."Disc. Commission Type"::"Footer Discount");
        "Document discount total" := 0;
        if SaleDiscEntry.Find('-') then
            repeat
                "Document discount total" := "Document discount total" + SaleDiscEntry."Discount Amount (LCY)";
            until SaleDiscEntry.Next = 0;

        if ("Lines discount total" <> 0) or ("Document discount total" <> 0) then
            Modify;
    end;

    var
        SaleDiscEntry: Record "Sales Disc. Commission Entry";
}

