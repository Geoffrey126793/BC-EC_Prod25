report 50017 "Calc. Sales Inv&CredMem Disc."
{
    // ------------------------------------------------------------------------------------------
    // ADV-001 ABSYS BT 20061102
    //   Calcul  remise : reprise Chimay
    // 
    // -----------------------------------------------------------------------------------------

    ProcessingOnly = true;
    ShowPrintStatus = true;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.");

            trigger OnAfterGetRecord()
            var
                RecSalesInvHeader_l: Record "Sales Invoice Header";
                RepCalculateInvBackDiscount_l: Report "Calc. Sales Invoice Line Disc.";
            begin
                // Absys - ADV.22 ->

                RecSalesInvLine_l.SetRange("Document No.", "No.");

                i += 1;
                window.Update(1, "No.");
                window.Update(2, Round(i / nb * 10000, 1));

                if RecSalesInvLine_l.Find('-') then begin
                    RepCalculateInvBackDiscount_l.CaculateDiscountDocument(RecSalesInvLine_l, false);

                    Commit;
                end;

                // Absys - ADV.22 <-
            end;

            trigger OnPostDataItem()
            begin
                window.Close;
            end;

            trigger OnPreDataItem()
            begin
                window.Open('Sales Invoice Discount : #1########### @2@@@@@@@@@@@@@@@@@@');
                nb := Count;

                if (Start_Date <> 0D) and (End_Date <> 0D) then
                    "Sales Invoice Header".SetRange("Posting Date", Start_Date, End_Date);
            end;
        }
        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
        {
            DataItemTableView = SORTING("No.");

            trigger OnAfterGetRecord()
            var
                RecSalesCredMemLine_l: Record "Sales Cr.Memo Line";
                RecSalesCredMemHeader_l: Record "Sales Cr.Memo Header";
                RepCalculateCrMeBackDiscount_l: Report "Calc. Sales CredMem.Line Disc.";
            begin
                // Absys - ADV.22 ->

                RecSalesCredMemLine_l.SetRange("Document No.", "No.");

                i2 += 1;
                window2.Update(1, "No.");
                window2.Update(2, Round(i2 / nb2 * 10000, 1));

                if RecSalesCredMemLine_l.Find('-') then begin
                    RepCalculateCrMeBackDiscount_l.CaculateDiscountDocument(RecSalesCredMemLine_l, false);
                    Commit;
                end;

                // Absys - ADV.22 <-
            end;

            trigger OnPostDataItem()
            begin
                window2.Close;
            end;

            trigger OnPreDataItem()
            begin
                window2.Open('Sales Cred. Memo. Discount :  #1########### @2@@@@@@@@@@@@@@@@@@@');
                nb2 := Count;

                if (Start_Date <> 0D) and (End_Date <> 0D) then
                    "Sales Cr.Memo Header".SetRange("Posting Date", Start_Date, End_Date);
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
        window: Dialog;
        nb: Integer;
        i: Integer;
        Start_Date: Date;
        End_Date: Date;
        RecSalesInvLine_l: Record "Sales Invoice Line";
        window2: Dialog;
        nb2: Integer;
        i2: Integer;

    [Scope('OnPrem')]
    procedure InitRequest(StartingDate_p: Date; EndingDate_p: Date)
    begin
        Start_Date := StartingDate_p;
        End_Date := EndingDate_p;
    end;
}

