report 8001500 "Calculate Sales Line Discount"
{
    // //+RFA+ GESWAY 11/07/02 Nouveau report qui lance le calcul des remises définies dans les lois

    Caption = 'Calculate Sales Discount Line';
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem("Sales Line"; "Sales Line")
        {
            DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") WHERE(Type = FILTER(<> " "), Quantity = FILTER(<> 0));

            trigger OnAfterGetRecord()
            begin
                CaculateDiscount("Sales Line");
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
        DiscEntry: Record "Sales Line Discount Entry";
        CalcDiscount: Codeunit "Calculate Disc. and Commission";
        Discount: Decimal;
        Window: Dialog;
        Text001: Label 'Discount Calculation #1######  #2########, Line #3######';

    [Scope('OnPrem')]
    procedure CaculateDiscount(SalesLine: Record "Sales Line")
    var
        SalesLine2: Record "Sales Line";
    begin
        Window.Open(Text001);
        DeleteDiscount(SalesLine);

        SalesLine2.Reset;
        SalesLine2.SetRange("Document Type", SalesLine."Document Type");
        SalesLine2.SetRange("Document No.", SalesLine."Document No.");
        SalesLine2.SetFilter(Type, '>0');
        SalesLine2.SetFilter(Quantity, '<>0');
        if SalesLine2.Find('-') then begin
            repeat
                Window.Update(1, SalesLine2."Document Type");
                Window.Update(2, SalesLine2."Document No.");
                Window.Update(3, SalesLine2."Line No.");
                Discount := 0;
                Clear(CalcDiscount);
                CalcDiscount.DiscountSaleLine(SalesLine2);

                //Line Discount
                DiscEntry.Reset;
                DiscEntry.SetRange("Document Type", SalesLine2."Document Type");
                DiscEntry.SetRange("Document No.", SalesLine2."Document No.");
                DiscEntry.SetRange("Line No.", SalesLine2."Line No.");
                DiscEntry.SetRange(Type, DiscEntry.Type::Sale);
                DiscEntry.SetRange("Disc. Commission Type", DiscEntry."Disc. Commission Type"::"Line Discount");
                if DiscEntry.Find('-') then
                    repeat
                        Discount := Discount + DiscEntry."Discount Amount";
                    until DiscEntry.Next = 0;
                if Discount <> 0 then begin
                    SalesLine2.Validate("Rule Discount Line Amount", Discount);
                    SalesLine2.Modify;
                end;

                //Footer Discount
                Discount := 0;

                DiscEntry.SetRange("Disc. Commission Type", DiscEntry."Disc. Commission Type"::"Footer Discount");
                if DiscEntry.Find('-') then
                    repeat
                        Discount := Discount + DiscEntry."Discount Amount";
                    until DiscEntry.Next = 0;
                if Discount <> 0 then begin
                    SalesLine2.Validate("Inv. Discount Amount", Discount);
                    SalesLine2.Modify;
                end;

                Commit;
            until SalesLine2.Next = 0;
        end;
        Window.Close;
    end;

    [Scope('OnPrem')]
    procedure DeleteDiscount(SalesLine: Record "Sales Line")
    var
        SalesLine2: Record "Sales Line";
    begin
        SalesLine2.Reset;
        SalesLine2.SetRange("Document Type", SalesLine."Document Type");
        SalesLine2.SetRange("Document No.", SalesLine."Document No.");
        SalesLine2.SetFilter(Type, '>0');
        SalesLine2.SetFilter(Quantity, '<>0');
        DiscEntry.SetRange("Document Type", SalesLine."Document Type");
        DiscEntry.SetRange("Document No.", SalesLine."Document No.");
        if SalesLine2.Find('-') then begin
            //  DiscEntry.LOCKTABLE;
            repeat
                SalesLine2.Validate("Rule Discount Line Amount", 0);
                SalesLine2.Validate("Inv. Discount Amount", 0);
                SalesLine2.Modify;
                DiscEntry.SetRange("Line No.", SalesLine2."Line No.");
                if DiscEntry.Find('-') then
                    DiscEntry.DeleteAll;
            until SalesLine2.Next = 0;
            Commit;
        end;
    end;
}

