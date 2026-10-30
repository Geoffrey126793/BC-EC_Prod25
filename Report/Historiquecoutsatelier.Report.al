report 50033 "Historique couts atelier"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/Historiquecoutsatelier.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Ateliers; "Work Center")
        {
            DataItemTableView = WHERE("Work Center Group Code" = CONST('ATELIERS'));
            column(Atelier_No; Atelier)
            {
            }
            dataitem("Work Center"; "Work Center")
            {
                DataItemTableView = WHERE("Work Center Group Code" = CONST('ATELIERS'));
                column(WC_No; "Work Center"."No.")
                {
                }
                column(WC_Name; "Work Center".Name)
                {
                }
                dataitem("Ateliers Couts"; "Ateliers Couts")
                {
                    DataItemLink = "Centre de charges" = FIELD("No.");
                    DataItemTableView = SORTING("Centre de charges", Debut);
                    RequestFilterFields = Debut;
                    column(Cout_Debut; "Ateliers Couts".Debut)
                    {
                    }
                    column(Cout_Fin; "Ateliers Couts".Fin)
                    {
                    }
                    column(Cout_Cout; "Ateliers Couts".Cout)
                    {
                    }
                    column(Cout_Dif; Dif)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        Dif := 0;
                        if LastCout <> 0 then
                            Dif := "Ateliers Couts".Cout - LastCout;

                        LastCout := "Ateliers Couts".Cout;


                        d := "Ateliers Couts".Debut;
                        repeat
                            atelier_tmp.Reset;
                            if atelier_tmp.Get(Atelier, d) then begin
                                atelier_tmp.Cout += Cout;
                                atelier_tmp.Modify;
                            end
                            else begin
                                atelier_tmp.Init;
                                atelier_tmp."Centre de charges" := Atelier;
                                atelier_tmp.Cout := Cout;
                                atelier_tmp.Debut := d;
                                atelier_tmp.Fin := d;
                                atelier_tmp.Insert;
                            end;
                            d := CalcDate('<+1D>', d);
                        until (d > "Ateliers Couts".Fin) or ("Ateliers Couts".Fin = 0D)
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    LastCout := 0;
                end;

                trigger OnPreDataItem()
                begin
                    "Work Center".SetFilter("No.", Atelier + '*');
                end;
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = FILTER(0 ..));
                column(Atelier_Debut; atelier_resume.Debut)
                {
                }
                column(Atelier_Fin; atelier_resume.Fin)
                {
                }
                column(Atelier_Cout; atelier_resume.Cout)
                {
                }
                column(Atelier_Dif; Dif)
                {
                }

                trigger OnAfterGetRecord()
                begin




                    if Number = 0 then begin
                        Dif := 0;
                        if not atelier_resume.FindFirst then
                            CurrReport.Break;
                    end
                    else begin
                        if atelier_resume.Next = 0 then begin
                            atelier_resume.Reset;
                            atelier_resume.DeleteAll;
                            CurrReport.Break;
                        end;
                        Dif := atelier_resume.Cout - LastCout;
                    end;
                    LastCout := atelier_resume.Cout;
                end;

                trigger OnPreDataItem()
                var
                    LastCout: Decimal;
                begin
                    atelier_tmp.Reset;
                    LastCout := -1;
                    if atelier_tmp.FindSet then
                        repeat
                            if atelier_tmp.Cout <> LastCout then begin
                                LastCout := atelier_tmp.Cout;
                                atelier_resume.Init;
                                atelier_resume."Centre de charges" := atelier_tmp."Centre de charges";
                                atelier_resume.Debut := atelier_tmp.Debut;
                                atelier_resume.Fin := atelier_tmp.Fin;
                                atelier_resume.Cout := atelier_tmp.Cout;
                                atelier_resume.Insert;
                            end
                            else
                                atelier_resume.Fin := atelier_tmp.Fin;
                            atelier_resume.Modify;
                            begin
                            end;
                        until atelier_tmp.Next = 0;
                    atelier_tmp.Reset;
                    atelier_tmp.DeleteAll;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                //Atelier := COPYSTR("No.",1,STRPOS("No.",'_')-1);
                Atelier := "No.";
                if Atelier = LastAtelier then
                    CurrReport.Skip
                else
                    LastAtelier := Atelier;
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
        LastCout: Decimal;
        Dif: Decimal;
        atelier_tmp: Record "Ateliers Couts" temporary;
        atelier_resume: Record "Ateliers Couts" temporary;
        Atelier: Code[20];
        d: Date;
        LastAtelier: Code[20];
}

