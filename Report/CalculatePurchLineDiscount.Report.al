report 8001505 "Calculate Purch. Line Discount"
{
    // //+RFA+ GESWAY 11/07/02 Nouveau report qui lance le calcul des remises définies dans les lois

    Caption = 'Calculate Purch. Discount Line';
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem("Purchase Line"; "Purchase Line")
        {
            DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") WHERE(Type = FILTER(<> " "), Quantity = FILTER(<> 0));

            trigger OnAfterGetRecord()
            begin
                CalcDocDiscount("Purchase Line");
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
        CalcDiscount: Codeunit "Calculate Disc. and Commission";
        DiscEntry: Record "Purchase Line Disc. Entry";
        Discount: Decimal;
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        Window: Dialog;
        Text001: Label 'Order Discounts Calculation #1########, line #2######';

    [Scope('OnPrem')]
    procedure CalcDocDiscount(PurchaseLine: Record "Purchase Line")
    begin
        Window.Open(Text001);
        DeleteDocDiscount(PurchaseLine);

        PurchLine.Reset;
        PurchLine.SetRange("Document Type", PurchaseLine."Document Type");
        PurchLine.SetRange("Document No.", PurchaseLine."Document No.");
        PurchLine.SetFilter(Quantity, '<>0');
        if PurchLine.Find('-') then begin
            repeat
                Window.Update(1, PurchLine."Document No.");
                Window.Update(2, PurchLine."Line No.");
                Clear(Discount);
                CalcDiscount.DiscountPurchLine(PurchLine);

                //Remise ligne
                DiscEntry.SetRange("Document Type", PurchLine."Document Type");
                DiscEntry.SetRange("Document No.", PurchLine."Document No.");
                DiscEntry.SetRange("Line No.", PurchLine."Line No.");
                DiscEntry.SetRange("Disc. Commission Type", DiscEntry."Disc. Commission Type"::"Line Discount");
                DiscEntry.SetRange(Type, DiscEntry.Type::Order);

                if DiscEntry.Find('-') then
                    repeat
                        Discount := Discount + DiscEntry."Discount Amount";
                    until DiscEntry.Next = 0;
                if Discount <> 0 then begin
                    PurchLine.Validate("Rule Discount Line Amount", Discount);
                    PurchLine.Modify;
                end;

                //Remise pied
                Clear(Discount);
                DiscEntry.SetRange("Disc. Commission Type");
                DiscEntry.SetRange("Disc. Commission Type", DiscEntry."Disc. Commission Type"::"Footer Discount");

                if DiscEntry.Find('-') then
                    repeat
                        Discount := Discount + DiscEntry."Discount Amount";
                    until DiscEntry.Next = 0;
                if Discount <> 0 then begin
                    PurchLine.Validate("Inv. Discount Amount", Discount);
                    PurchLine.Modify;
                end;

                Commit;
            until PurchLine.Next = 0;
        end;
        Window.Close;
    end;

    [Scope('OnPrem')]
    procedure DeleteDocDiscount(PurchaseLine: Record "Purchase Line")
    var
        LigAchat: Record "Purchase Line";
        EcrRemise: Record "Purchase Line Disc. Entry";
    begin
        PurchLine.Reset;
        PurchLine.SetRange("Document Type", PurchaseLine."Document Type");
        PurchLine.SetRange("Document No.", PurchaseLine."Document No.");
        PurchLine.SetFilter(Quantity, '<>0');
        DiscEntry.SetRange("Document Type", PurchaseLine."Document Type");
        DiscEntry.SetRange("Document No.", PurchaseLine."Document No.");
        if PurchLine.Find('-') then begin
            //  DiscEntry.LOCKTABLE;
            repeat
                PurchLine.Validate("Rule Discount Line Amount", 0);
                PurchLine.Validate("Inv. Discount Amount", 0);
                PurchLine.Modify;
                DiscEntry.SetRange("Line No.", PurchLine."Line No.");
                if DiscEntry.Find('-') then
                    DiscEntry.DeleteAll;
            until PurchLine.Next = 0;
            Commit;
        end;
    end;
}

