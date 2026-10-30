report 50016 "Calc. Sales CredMem.Line Disc."
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
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
        CalcDiscount: Codeunit "Calc. Sales CredMem Disc.";
        Discount: Decimal;
        Window: Dialog;
        Text001: Label 'Discount Calculation #1######  #2########, Line #3######';

    [Scope('OnPrem')]
    procedure CaculateDiscountDocument(SalesCredMemLine: Record "Sales Cr.Memo Line"; ShowStatus: Boolean)
    var
        SalesCredMemLine2: Record "Sales Cr.Memo Line";
    begin
        if ShowStatus then begin
            Window.Open(Text001);
        end;

        DeleteDiscountDocument(SalesCredMemLine);

        SalesCredMemLine2.Reset;
        SalesCredMemLine2.SetRange(Type, SalesCredMemLine.Type);
        SalesCredMemLine2.SetRange("Document No.", SalesCredMemLine."Document No.");
        SalesCredMemLine2.SetFilter(Type, '>0');
        SalesCredMemLine2.SetFilter(Quantity, '<>0');
        if SalesCredMemLine2.Find('-') then begin
            repeat
                if ShowStatus then begin
                    Window.Update(2, SalesCredMemLine2."Document No.");
                    Window.Update(3, SalesCredMemLine2."Line No.");
                end;
                Discount := 0;
                CalcDiscount.DiscountSaleLine(SalesCredMemLine2);
            until SalesCredMemLine2.Next = 0;
        end;

        if ShowStatus then begin
            Window.Close;
        end;
    end;

    [Scope('OnPrem')]
    procedure DeleteDiscountDocument(SalesCredMemLine: Record "Sales Cr.Memo Line")
    var
        SalesCredMemLine2: Record "Sales Cr.Memo Line";
    begin
        DiscEntry.SetRange("Document Type", DiscEntry."Document Type"::"Posted Credit Memo");
        DiscEntry.SetRange("Document No.", SalesCredMemLine."Document No.");

        // Absys GJ 07/04/05 ->
        DiscEntry.SetFilter("Disc. Commission Type", '%1|%2',
                               DiscEntry."Disc. Commission Type"::"Back Discount",
                               DiscEntry."Disc. Commission Type"::Commission);
        // Absys GJ 07/04/05 <-

        DiscEntry.DeleteAll;
    end;
}

