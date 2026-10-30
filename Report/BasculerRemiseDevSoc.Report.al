report 8001501 "Basculer Remise Dev Soc"
{
    // //+RFA+ GESWAY 11/07/02 Nouvel état

    Caption = 'Discount Commission Law List';
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem("Posted Sales Discount Entry"; "Posted Sales Discount Entry")
        {
            //The property 'DataItemTableView' shouldn't have an empty value.
            //DataItemTableView = '';
            RequestFilterFields = "Disc. Commission Type";

            trigger OnAfterGetRecord()
            begin
                RecNbr += 1;
                Window.Update(1, Round(RecNbr / TotalNbr * 10000, 1));

                if "Discount Amount" = 0 then
                    "Discount Amount" := "Discount Amount (LCY)";
                if Coefficient = 0 then
                    Coefficient := "Coefficient (LCY)";
                if Base = 0 then
                    Base := "Base (LCY)";

                Modify;
            end;

            trigger OnPreDataItem()
            begin
                if not Confirm(Text002) then
                    Error(Text003);
                Window.Open(Text001);
                TotalNbr := Count;
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
        Text001: Label 'Traitement Remises @1@@@@@@@@@@';
        Window: Dialog;
        RecNbr: Integer;
        TotalNbr: Integer;
        Text002: Label 'Confirmez vous le basculement des montants remise dev.soc. vers remise ?';
        Text003: Label 'Abandon';
}

