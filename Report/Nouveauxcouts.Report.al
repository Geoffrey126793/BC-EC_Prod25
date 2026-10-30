report 50040 "Nouveaux couts"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/Nouveauxcouts.rdlc';

    dataset
    {
        dataitem("Histo couts"; "Histo couts")
        {
            DataItemTableView = WHERE(Type = CONST("Cout standard"));
            RequestFilterFields = Item;
            column(Histo_couts_Item; Item)
            {
            }
            column(Histo_couts_Cout; Cout)
            {
            }
            column(OldCout; OldCout)
            {
            }
            column(OldDt; OldDt)
            {
            }
            column(Cout___OldCout; Cout - OldCout)
            {
            }
            column(Cout___OldCoutM1; Cout - OldCoutM1)
            {
            }
            column(OldDtM1; OldDtM1)
            {
            }
            column(OldCoutM1; OldCoutM1)
            {
            }
            column(Desc; Desc)
            {
            }
            column(Histo_coutsCaption; Histo_coutsCaptionLbl)
            {
            }
            column(AuparavantCaption; AuparavantCaptionLbl)
            {
            }
            column(M_1Caption; M_1CaptionLbl)
            {
            }
            column(Histo_couts_Date; Date)
            {
            }
            column(Histo_couts_Type; Type)
            {
            }

            trigger OnAfterGetRecord()
            begin
                OldCout := 0;
                OldCoutM1 := 0;
                OldDt := 0D;
                OldDtM1 := 0D;

                Old.Reset;
                Old.SetRange(Type, Type);
                Old.SetRange(Item, Item);
                Old.SetFilter(Date, '<%1', Date);
                if Old.FindLast then begin
                    OldCout := Old.Cout;
                    OldDt := Old.Date;
                end;

                Old.Reset;
                Old.SetRange(Type, Type);
                Old.SetRange(Item, Item);
                Old.SetFilter(Date, '<%1', CalcDate('<-1M>', Date));
                if Old.FindLast then begin
                    OldCoutM1 := Old.Cout;
                    OldDtM1 := Old.Date;
                end;
                n += 1;

                if recItem.Get(Item) then
                    Desc := recItem.Description;
            end;

            trigger OnPreDataItem()
            begin
                SetRange(Date, Today);
                n := 0;
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
        Old: Record "Histo couts";
        OldCout: Decimal;
        OldDt: Date;
        OldCoutM1: Decimal;
        OldDtM1: Date;
        n: Integer;
        Desc: Text[80];
        recItem: Record Item;
        Histo_coutsCaptionLbl: Label 'Nouveaux couts standards';
        AuparavantCaptionLbl: Label 'Auparavant';
        M_1CaptionLbl: Label 'M-1';

    [Scope('OnPrem')]
    procedure getCount(): Integer
    begin
        exit(n);
    end;
}

