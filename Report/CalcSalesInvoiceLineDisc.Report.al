report 50013 "Calc. Sales Invoice Line Disc."
{
    // ------------------------------------------------------------------------------------------
    // ADV-001 ABSYS BT 20061102
    //   Calcul  remise : reprise Chimay
    // 
    // -----------------------------------------------------------------------------------------

    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Invoice Line"; "Sales Invoice Line")
        {
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
        DiscEntry: Record "Posted Sales Discount Entry";
        CalcDiscount: Codeunit "Calc. Sales Invoice Disc.";
        Discount: Decimal;
        Window: Dialog;
        Text001: Label 'Discount Calculation #1######  #2########, Line #3######';

    [Scope('OnPrem')]
    procedure CaculateDiscountDocument(SalesInvoiceLine: Record "Sales Invoice Line"; ShowStatus: Boolean)
    var
        SalesInvoiceLine2: Record "Sales Invoice Line";
    begin
        if ShowStatus then begin
            Window.Open(Text001);
        end;

        DeleteDiscountDocument(SalesInvoiceLine);

        SalesInvoiceLine2.Reset;
        SalesInvoiceLine2.SetRange(Type, SalesInvoiceLine.Type);
        SalesInvoiceLine2.SetRange("Document No.", SalesInvoiceLine."Document No.");
        SalesInvoiceLine2.SetFilter(Type, '>0');
        SalesInvoiceLine2.SetFilter(Quantity, '<>0');
        if SalesInvoiceLine2.Find('-') then begin
            repeat
                if ShowStatus then begin
                    Window.Update(2, SalesInvoiceLine2."Document No.");
                    Window.Update(3, SalesInvoiceLine2."Line No.");
                end;
                Discount := 0;
                CalcDiscount.DiscountSaleLine(SalesInvoiceLine2);
            until SalesInvoiceLine2.Next = 0;
        end;

        if ShowStatus then begin
            Window.Close;
        end;
    end;

    [Scope('OnPrem')]
    procedure DeleteDiscountDocument(SalesInvoiceLine: Record "Sales Invoice Line")
    var
        SalesInvoiceLine2: Record "Sales Invoice Line";
    begin
        DiscEntry.SetRange("Document Type", DiscEntry."Document Type"::"Posted Invoice");
        DiscEntry.SetRange("Document No.", SalesInvoiceLine."Document No.");

        // Absys GJ 07/04/05 ->
        DiscEntry.SetFilter("Disc. Commission Type", '%1|%2',
                               DiscEntry."Disc. Commission Type"::"Back Discount",
                               DiscEntry."Disc. Commission Type"::Commission);
        // Absys GJ 07/04/05 <-

        DiscEntry.DeleteAll;
    end;
}

