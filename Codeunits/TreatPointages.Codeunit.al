codeunit 50017 TreatPointages
{

    trigger OnRun()
    var
        PointagesToTreat: Record PointagesProd;
        Last: Text;
        OFs: Record "Production Order";
        PointagesToTreat2: Record PointagesProd;
        hABC: Record "Heures ABC";
        canWork: Boolean;
        CuProd: Codeunit "Integration Tft and Prod";
    begin
        Last := '';
        //Test
        PointagesToTreat.Reset;
        PointagesToTreat.SetFilter(DtDebut, '>=%1', CreateDateTime(CalcDate('<-1M>', Today), 0T));
        PointagesToTreat.SetRange(Traite, true);
        PointagesToTreat.ModifyAll(Traite, false);
        PointagesToTreat.Reset;
        PointagesToTreat.SetFilter(DtDebut, '>=%1', CreateDateTime(CalcDate('<-1M>', Today), 0T));
        PointagesToTreat.SetRange(Traitement, PointagesToTreat.Traitement::Error);
        PointagesToTreat.ModifyAll(Traitement, PointagesToTreat.Traitement::Pointage);
        //
        //
        //TODO Diviser Les Pointages sur 2 jours
        //Traiter les Machines sur 2 jours
        //
        //

        PointagesToTreat.Reset;
        PointagesToTreat.SetCurrentKey(Machine, DtDebut);
        PointagesToTreat.SetRange(Traite, false);
        //PointagesToTreat.SETFILTER(DtDebut,'>=%1',CREATEDATETIME(010124D,0T));
        PointagesToTreat.SetFilter(DtDebut, '>=%1', CreateDateTime(CalcDate('<-1M>', Today), 0T));


        if PointagesToTreat.FindSet then
            repeat // On reset tout dans une boucle pour pouvoir gérer les prod sur plusieurs jours
                if PointagesToTreat."OF" <> '' then begin
                    hABC.SetRange("Production No", PointagesToTreat."OF");
                    hABC.ModifyAll("h Pointages", 0);
                    hABC.ModifyAll("h Pointages Machine", 0);
                end;
                PointagesToTreat."Temps interruption" := 0;

                PointagesToTreat.Modify;
            until PointagesToTreat.Next = 0;

        //CalcWork('LIGNE IQF 2',050325D);

        if PointagesToTreat.FindSet then
            repeat
                if PointagesToTreat.Machine + Format(DT2Date(PointagesToTreat.DtDebut)) <> Last then begin
                    Last := PointagesToTreat.Machine + Format(DT2Date(PointagesToTreat.DtDebut));
                    canWork := true;
                    PointagesToTreat2.Reset;
                    PointagesToTreat2.SetRange(Machine, PointagesToTreat.Machine);
                    PointagesToTreat2.SetRange(DtDebut, CreateDateTime(DT2Date(PointagesToTreat.DtDebut), 0T), CreateDateTime(DT2Date(PointagesToTreat.DtDebut), 235959T));
                    PointagesToTreat2.SetFilter("OF", '<>''''');
                    if PointagesToTreat2.FindSet then
                        repeat
                            OFs.Reset;
                            OFs.SetRange("No.", PointagesToTreat2."OF");
                            if OFs.FindFirst and (OFs.Status <> OFs.Status::Finished) then
                                CuProd.EndOF(OFs."No.");
                            //canWork := FALSE;
                        until PointagesToTreat2.Next = 0;

                    if canWork then
                        CalcWork(PointagesToTreat.Machine, DT2Date(PointagesToTreat.DtDebut));
                end;
            until PointagesToTreat.Next = 0;

        Message('fini');
    end;

    local procedure CalcWork(Machine: Text; Dt: Date)
    var
        Heures: Record PointagesProd temporary;
        ActivitesR: Record PointagesProd temporary;
        Pointages: Record PointagesProd;
        Msg: Text;
        CRLF: Text[2];
        i: Integer;
        Debut: DateTime;
        Fin: DateTime;
        ToDistrib: Record PointagesProd temporary;
        hABC: Record "Heures ABC";
        totalMOPrevu: Decimal;
        Pointages2: Record PointagesProd;
    begin
        RoundTimes(Machine, Dt);
        i := 1;
        CRLF[1] := 10;
        Pointages.Reset;  // List chaque période découpée et chaque activité
        Pointages.SetRange(Machine, Machine);
        Pointages.SetRange(DtDebut, CreateDateTime(Dt, 000000T), CreateDateTime(Dt, 235959T));
        Pointages.SetRange(Traitement, Pointages.Traitement::Pointage);
        if Pointages.FindSet then
            repeat
                Heures.Reset;
                Heures.SetRange(DtDebut, Pointages.DtDebut);
                if not Heures.FindFirst then begin
                    Heures.Reset;
                    Heures.Init;
                    Heures.ID := i;
                    i += 1;
                    Heures.DtDebut := Pointages.DtDebut;
                    Heures.Insert(false);
                end;
                Heures.Reset;
                Heures.SetRange(DtDebut, Pointages.DtFin);
                if not Heures.FindFirst then begin
                    Heures.Reset;
                    Heures.Init;
                    Heures.ID := i;
                    i += 1;
                    Heures.DtDebut := Pointages.DtFin;
                    Heures.Insert(false);
                end;
                ActivitesR.Reset;
                ActivitesR.SetRange(ActiviteRegroup, Pointages.ActiviteRegroup);
                if not ActivitesR.FindFirst then begin
                    ActivitesR.Reset;
                    ActivitesR.Init;
                    ActivitesR.ID := i;
                    i += 1;
                    ActivitesR.ActiviteRegroup := Pointages.ActiviteRegroup;
                    ActivitesR.Insert(false);
                end;
                Pointages.Traite := true;
                Pointages.Modify;
            until Pointages.Next = 0;

        ActivitesR.Reset;
        if ActivitesR.FindSet then
            repeat
            //  Msg += 'Activite : '+ActivitesR.ActiviteRegroup+CRLF;
            until ActivitesR.Next = 0;

        i := 1;
        Debut := 0DT;
        Heures.Reset; // Parcours chaque période et chaque activité pour créer un découpage à distribuer des heures personnel
        Heures.SetCurrentKey(DtDebut);
        if Heures.FindSet then
            repeat
                ActivitesR.Reset;
                if ActivitesR.FindSet then
                    repeat
                        if Debut <> 0DT then begin
                            Pointages.Reset;
                            Pointages.SetFilter(Salarie, '<>''''');
                            Pointages.SetRange(ActiviteRegroup, ActivitesR.ActiviteRegroup);

                            if CopyStr(ActivitesR.ActiviteRegroup, 1, 1) = 'S' then begin
                                Pointages.SetRange(Machine, Machine);
                                Pointages.SetFilter(DtDebut, '<=%1', Debut);
                                Pointages.SetFilter(DtFin, '>=%1', Heures.DtDebut);
                                Pointages.SetRange(Traitement, Pointages.Traitement::Pointage);
                                Pointages.SetFilter(Salarie, '''''');
                                Pointages.SetRange(ActiviteRegroup, ActivitesR.ActiviteRegroup);
                                if Pointages.FindFirst then
                                    Pointages.SetRange(ActiviteRegroup);
                                Pointages.SetFilter(Salarie, '<>''''');
                            end;
                            Pointages.SetRange(Machine, Machine);
                            Pointages.SetFilter(DtDebut, '<=%1', Debut);
                            Pointages.SetFilter(DtFin, '>=%1', Heures.DtDebut);
                            Pointages.SetRange(Traitement, Pointages.Traitement::Pointage);
                            if Pointages.FindSet then begin
                                repeat
                                    ToDistrib.Reset;
                                    ToDistrib.Init;
                                    ToDistrib.ID := i;
                                    ToDistrib.DtDebut := Debut;
                                    ToDistrib.DtFin := Heures.DtDebut;
                                    ToDistrib.Machine := Machine;
                                    ToDistrib.Salarie := Pointages.Salarie;
                                    ToDistrib.ActiviteRegroup := ActivitesR.ActiviteRegroup;
                                    ToDistrib.Minutes += Round((Heures.DtDebut - Debut) / 60000, 1, '=');
                                    ToDistrib.Insert(false);
                                    i := i + 1;
                                until Pointages.Next = 0;
                            end
                            else begin
                                ToDistrib.Reset;
                                ToDistrib.Init;
                                ToDistrib.ID := i;
                                ToDistrib.DtDebut := Debut;
                                ToDistrib.DtFin := Heures.DtDebut;
                                ToDistrib.Machine := Machine;
                                ToDistrib.Salarie := '0';
                                ToDistrib.ActiviteRegroup := ActivitesR.ActiviteRegroup;
                                ToDistrib.Minutes := 0;
                                ToDistrib.Insert(false);
                                i := i + 1;
                            end;
                        end;
                    until ActivitesR.Next = 0;
                Debut := Heures.DtDebut;
                //Msg += FORMAT(Heures.DtDebut)+CRLF;
            until Heures.Next = 0;

        ToDistrib.Reset;
        if ToDistrib.FindSet then
            repeat
            //  Msg += 'ToDistrib '+FORMAT(ToDistrib.DtDebut) + ' ->  '+FORMAT(ToDistrib.DtFin) + '  :  ' + ToDistrib.ActiviteRegroup + '   ' + FORMAT(ToDistrib.Minutes)+CRLF;
            until ToDistrib.Next = 0;

        ToDistrib.Reset;  // Calcule le Nombre d'OF impactés pour chaque période
        ToDistrib.SetFilter(ActiviteRegroup, '<>S*');
        if ToDistrib.FindSet then
            repeat
                //En combien d'OF doit-on diviser
                ToDistrib.tmp_nbreOF := 0;
                Pointages.Reset;
                Pointages.SetFilter("OF", '<>''''');
                Pointages.SetRange(Machine, Machine);
                Pointages.SetRange(ActiviteRegroup, '''''');
                Pointages.SetFilter(DtDebut, '<=%1', ToDistrib.DtDebut);
                Pointages.SetFilter(DtFin, '>=%1', ToDistrib.DtFin);
                if Pointages.FindSet then
                    repeat
                        hABC.Reset;
                        hABC.SetRange("Production No", Pointages."OF");
                        hABC.SetRange("Activite regroupement", ToDistrib.ActiviteRegroup);
                        if hABC.FindFirst or (ToDistrib.ActiviteRegroup = 'R999') then
                            ToDistrib.tmp_nbreOF += 1;

                    until Pointages.Next = 0;
                ToDistrib.Modify;
                //Msg += FORMAT(ToDistrib.DtDebut) + ' ->  '+FORMAT(ToDistrib.DtFin) + '  :  ' + ToDistrib.ActiviteRegroup + '   ' + FORMAT(ToDistrib.Minutes)+CRLF;
            until ToDistrib.Next = 0;

        //on divise
        ToDistrib.Reset;  //Distribue pour chaque période vers les OF impactés
        ToDistrib.SetFilter(ActiviteRegroup, '<>S*');
        ToDistrib.SetFilter(tmp_nbreOF, '>0');
        if ToDistrib.FindSet then
            repeat
                Pointages.Reset;
                Pointages.SetFilter("OF", '<>''''');
                Pointages.SetRange(Machine, Machine);
                Pointages.SetRange(ActiviteRegroup, '''''');
                Pointages.SetFilter(DtDebut, '<=%1', ToDistrib.DtDebut);
                Pointages.SetFilter(DtFin, '>=%1', ToDistrib.DtFin);
                if Pointages.FindSet then
                    repeat
                        totalMOPrevu := 0;
                        hABC.Reset;
                        hABC.SetRange("Production No", Pointages."OF");
                        hABC.SetRange("Activite regroupement", ToDistrib.ActiviteRegroup);
                        if hABC.FindSet then
                            repeat //Si plusieurs activites regroupes, distrib au prorata
                                totalMOPrevu += hABC."h MO prevu";
                                hABC.Modify;
                            until hABC.Next = 0;
                        hABC.Reset;
                        hABC.SetRange("Production No", Pointages."OF");
                        hABC.SetRange("Activite regroupement", ToDistrib.ActiviteRegroup);
                        if hABC.FindSet then
                            repeat //Si plusieurs activites regroupes, distrib au prorata
                                if hABC."h MO prevu" > 0 then
                                    hABC."h Pointages" += (((ToDistrib.Minutes / ToDistrib.tmp_nbreOF) / totalMOPrevu) * hABC."h MO prevu") / 60;
                                //Msg += hABC."Production No" + '   ' + FORMAT(hABC."h Pointages")+CRLF;
                                hABC.Modify;
                            until hABC.Next = 0;
                    until Pointages.Next = 0;
                Pointages.Reset;
                Pointages.SetFilter("OF", '<>''''');
                Pointages.SetRange(Machine, Machine);
                Pointages.SetFilter(ActiviteRegroup, '<>''''');  // Interruptions
                Pointages.SetFilter(DtDebut, '<=%1', ToDistrib.DtDebut);
                Pointages.SetFilter(DtFin, '>=%1', ToDistrib.DtFin);
                if Pointages.FindSet then
                    repeat
                        Pointages."Temps interruption" += ((ToDistrib.Minutes / ToDistrib.tmp_nbreOF)) / 60;
                        Pointages."Interruption machine" := Round((Pointages.DtFin - Pointages.DtDebut) / 60000, 1, '=') / 60;
                        Pointages.Modify;
                    until Pointages.Next = 0;
                ToDistrib.Minutes := 0;
                ToDistrib.Modify;
                //Msg += FORMAT(ToDistrib.DtDebut) + ' ->  '+FORMAT(ToDistrib.DtFin) + '  :  ' + ToDistrib.ActiviteRegroup + '   ' + FORMAT(ToDistrib.Minutes)+CRLF;
            until ToDistrib.Next = 0;

        ToDistrib.Reset;
        ToDistrib.SetRange(Salarie, '0');
        ToDistrib.DeleteAll();

        //Il reste ce qui n'a pas pu être distribué directement sur des OF

        ToDistrib.Reset;  // Calcule le Nombre d'OF impactés pour chaque période de setup
        ToDistrib.SetFilter(ActiviteRegroup, 'S*');
        if ToDistrib.FindSet then
            repeat
                //En combien d'OF doit-on diviser (OF qui ont commencé la première fois après le setup )
                ToDistrib.tmp_nbreOF := 0;
                Pointages.Reset;
                Pointages.SetFilter("OF", '<>''''');
                Pointages.SetRange(Machine, Machine);
                Pointages.SetRange(ActiviteRegroup, '''''');
                Pointages.SetRange(DtDebut, ToDistrib.DtFin, CreateDateTime(DT2Date(ToDistrib.DtFin), 235959T));
                Pointages.SetRange(Traitement, Pointages.Traitement::Pointage);
                if Pointages.FindSet then
                    repeat
                        Pointages2.Reset;  //Si pas commencé avant sur une autre ligne pointage
                        Pointages2.SetFilter("OF", Pointages."OF");
                        Pointages2.SetRange(Machine, Machine);
                        Pointages2.SetFilter(DtDebut, '<%1', ToDistrib.DtDebut);
                        if not Pointages2.FindFirst then begin
                            hABC.Reset;
                            hABC.SetRange("Production No", Pointages."OF");
                            hABC.SetRange(Activite, ToDistrib.ActiviteRegroup);
                            if hABC.FindFirst then
                                ToDistrib.tmp_nbreOF += Round((Pointages.DtFin - Pointages.DtDebut) / 60000, 1, '=');
                        end;
                    until Pointages.Next = 0;
                ToDistrib.Modify;
                //  Msg += 'S:'+FORMAT(ToDistrib.DtDebut) + ' ->  '+FORMAT(ToDistrib.DtFin) + '  :  ' + ToDistrib.ActiviteRegroup + '   ' + FORMAT(ToDistrib.Minutes) + '  ' +  FORMAT(ToDistrib.tmp_nbreOF)+CRLF;
            until ToDistrib.Next = 0;

        ToDistrib.Reset;  // Distribue les setup par OF
        ToDistrib.SetFilter(ActiviteRegroup, 'S*');
        ToDistrib.SetFilter(tmp_nbreOF, '>0');
        if ToDistrib.FindSet then
            repeat
                Pointages.Reset;
                Pointages.SetFilter("OF", '<>''''');
                Pointages.SetRange(Machine, Machine);
                Pointages.SetRange(ActiviteRegroup, '''''');
                Pointages.SetRange(DtDebut, ToDistrib.DtFin, CreateDateTime(DT2Date(ToDistrib.DtFin), 235959T));
                Pointages.SetRange(Traitement, Pointages.Traitement::Pointage);
                if Pointages.FindSet then
                    repeat
                        Pointages2.Reset;
                        Pointages2.SetFilter("OF", Pointages."OF");
                        Pointages2.SetRange(Machine, Machine);
                        Pointages2.SetFilter(DtDebut, '<%1', ToDistrib.DtDebut);
                        if not Pointages2.FindFirst then begin
                            hABC.Reset;
                            hABC.SetRange("Production No", Pointages."OF");
                            hABC.SetRange(Activite, ToDistrib.ActiviteRegroup);
                            if hABC.FindFirst then begin
                                hABC."h Pointages" += (Round((Pointages.DtFin - Pointages.DtDebut) / 60000, 1, '=') * (ToDistrib.Minutes / ToDistrib.tmp_nbreOF)) / 60;
                                hABC.Modify;
                            end;
                        end;
                    until Pointages.Next = 0;
                ToDistrib.Minutes := 0;
                ToDistrib.Modify;
                //  Msg += 'S : ' + FORMAT(ToDistrib.DtDebut) + ' ->  '+FORMAT(ToDistrib.DtFin) + '  :  ' + ToDistrib.ActiviteRegroup + '   ' + FORMAT(ToDistrib.Minutes)+CRLF;
            until ToDistrib.Next = 0;


        Pointages.Reset; //Heures machine
        Pointages.SetFilter("OF", '<>''''');
        Pointages.SetRange(Machine, Machine);
        Pointages.SetRange(ActiviteRegroup, '''''');
        Pointages.SetRange(DtDebut, CreateDateTime(Dt, 000000T), CreateDateTime(Dt, 235959T));
        Pointages.SetRange(Traitement, Pointages.Traitement::Pointage);
        if Pointages.FindSet then
            repeat
                hABC.Reset;
                hABC.SetRange("Production No", Pointages."OF");
                if hABC.FindSet then
                    repeat //Si plusieurs activites regroupes, distrib au prorata
                        if hABC."h Machine prevu" > 0 then
                            hABC."h Pointages Machine" += Round((Pointages.DtFin - Pointages.DtDebut) / 60000, 1, '=') / 60;
                        hABC.Modify;
                    until hABC.Next = 0;
            until Pointages.Next = 0;



        Pointages.Reset;
        Pointages.SetRange(Machine, Machine);
        Pointages.SetRange(DtDebut, CreateDateTime(Dt, 0T));
        Pointages.SetRange(DtFin, CreateDateTime(Dt, 235959T));
        Pointages.SetRange(Traitement, Pointages.Traitement::NotDistributed);
        Pointages.DeleteAll;

        ToDistrib.Reset;  //Il reste à distibuer
        ToDistrib.SetFilter(Minutes, '>0');
        if ToDistrib.FindSet then
            repeat
                Pointages.Reset;
                Pointages.SetRange(Machine, Machine);
                Pointages.SetRange(DtDebut, CreateDateTime(Dt, 0T));
                Pointages.SetRange(DtFin, CreateDateTime(Dt, 235959T));
                Pointages.SetRange(Traitement, Pointages.Traitement::NotDistributed);
                Pointages.SetRange(Salarie, ToDistrib.Salarie);
                if not Pointages.FindFirst then begin
                    Pointages.Reset;
                    Pointages.Init;
                    Pointages.ID := 0;
                    Pointages.Machine := Machine;
                    Pointages.DtDebut := CreateDateTime(Dt, 0T);
                    Pointages.DtFin := CreateDateTime(Dt, 235959T);
                    Pointages.Traitement := Pointages.Traitement::NotDistributed;
                    Pointages.Salarie := ToDistrib.Salarie;
                    Pointages.Traite := true;
                    Pointages.Insert(true);
                end;
                Msg += Machine + '   ' + Format(ToDistrib.DtDebut) + ' ->  ' + Format(ToDistrib.DtFin) + '  :  ' + ToDistrib.Salarie + '  :  ' + ToDistrib.ActiviteRegroup + '   ' + Format(ToDistrib.Minutes) + CRLF;
                Pointages.Minutes += ToDistrib.Minutes;
                Pointages.Modify;
            until ToDistrib.Next = 0;



        //MESSAGE(Msg);
    end;

    local procedure RoundTimes(Machine: Text; Dt: Date)
    var
        Pointages: Record PointagesProd;
        PointagesOF: Record PointagesProd;
    begin
        Pointages.Reset;
        Pointages.SetRange(Machine, Machine);
        Pointages.SetRange(DtDebut, CreateDateTime(Dt, 000000T), CreateDateTime(Dt, 235959T));
        if Pointages.FindSet then
            repeat
                if Pointages.DtDebutEncodee = 0DT then begin
                    Pointages.DtDebutEncodee := Pointages.DtDebut;
                    Pointages.DtFinEncodee := Pointages.DtFin;
                    Pointages.Modify;
                end;
                if Pointages.DtFinEncodee = 0DT then begin
                    Pointages.DtFinEncodee := Pointages.DtFin;
                    Pointages.Modify;
                end;
                if Pointages.DtFin = 0DT then begin
                    Pointages.Traitement := Pointages.Traitement::Error;
                    Pointages.Traite := true;
                    Pointages.Modify;
                end
                else begin
                    if Pointages.DtDebut > Pointages.DtFin then begin
                        Pointages.DtFin := CreateDateTime(DT2Date(Pointages.DtDebut), DT2Time(Pointages.DtFin));
                        if Pointages.DtDebut > Pointages.DtFin then
                            Pointages.Traitement := Pointages.Traitement::Error;
                        Pointages.Modify;
                    end;
                end;
            until Pointages.Next = 0;

        PointagesOF.Reset;
        PointagesOF.SetFilter("OF", '<>''''');
        PointagesOF.SetFilter(ActiviteRegroup, '''''');
        PointagesOF.SetRange(Machine, Machine);
        PointagesOF.SetRange(Traitement, Pointages.Traitement::Pointage);
        Pointages.Reset;
        Pointages.SetRange(Machine, Machine);
        Pointages.SetRange(DtDebut, CreateDateTime(Dt, 000000T), CreateDateTime(Dt, 235959T));
        Pointages.SetRange(Traitement, Pointages.Traitement::Pointage);
        if Pointages.FindSet then
            repeat
                if (Pointages."OF" <> '') and (Pointages.ActiviteRegroup = '') then begin  // On arrondi les OF
                    Pointages.DtDebut := RoundTime5(Pointages.DtDebutEncodee);
                    Pointages.DtFin := RoundTime5(Pointages.DtFinEncodee);
                    if Pointages.DtDebut > Pointages.DtFin then begin
                        Pointages.DtFin := CreateDateTime(DT2Date(Pointages.DtDebut), DT2Time(Pointages.DtFin));
                        if Pointages.DtDebut > Pointages.DtFin then
                            Pointages.Traitement := Pointages.Traitement::Error;
                    end;
                end
                else begin // Si un Of dans les 5 min, on prend sa valeur, sinon, on arrondi
                    PointagesOF.SetRange(DtFinEncodee);
                    PointagesOF.SetFilter(DtDebutEncodee, '%1..%2', Pointages.DtDebut - 5 * 60 * 1000, Pointages.DtDebut + 5 * 60 * 1000);
                    if PointagesOF.FindFirst then
                        Pointages.DtDebut := PointagesOF.DtDebut
                    else
                        Pointages.DtDebut := RoundTime5(Pointages.DtDebutEncodee);
                    PointagesOF.SetRange(DtDebutEncodee);
                    PointagesOF.SetFilter(DtFinEncodee, '%1..%2', Pointages.DtFin - 5 * 60 * 1000, Pointages.DtFin + 5 * 60 * 1000);
                    if PointagesOF.FindFirst then
                        Pointages.DtFin := PointagesOF.DtFin
                    else
                        Pointages.DtFin := RoundTime5(Pointages.DtFinEncodee);

                end;
                if Pointages.DtDebut = Pointages.DtFin then begin
                    Pointages.Traitement := Pointages.Traitement::Error;
                    Pointages.Traite := true;
                end;
                Pointages.Modify;
            until Pointages.Next = 0;
    end;

    local procedure RoundTime5(Dt: DateTime): DateTime
    var
        Utils: Codeunit Utils;
        m: Integer;
        s: Integer;
    begin
        m := Utils.Dt2Minutes(Dt);
        s := Utils.Dt2Seconds(Dt);

        if (m mod 10 = 0) or (m mod 10 = 1) then
            exit(CreateDateTime(DT2Date(Dt), Utils.HMS2Time(Utils.Dt2Hours(Dt), (m div 10) * 10, 0)));
        if (m mod 10 = 3) or (m mod 10 = 4) or (m mod 10 = 5) or (m mod 10 = 6) then
            exit(CreateDateTime(DT2Date(Dt), Utils.HMS2Time(Utils.Dt2Hours(Dt), (m div 10) * 10 + 5, 0)));
        if (m mod 10 = 8) or (m mod 10 = 9) then
            exit(CreateDateTime(DT2Date(Dt), Utils.HMS2Time(Utils.Dt2Hours(Dt), (m div 10) * 10 + 10, 0)));
        if (m mod 10 = 2) then begin
            if (s < 30) then
                exit(CreateDateTime(DT2Date(Dt), Utils.HMS2Time(Utils.Dt2Hours(Dt), (m div 10) * 10, 0)))
            else
                exit(CreateDateTime(DT2Date(Dt), Utils.HMS2Time(Utils.Dt2Hours(Dt), (m div 10) * 10 + 5, 0)))
        end;
        if (m mod 10 = 7) then begin
            if (s < 30) then
                exit(CreateDateTime(DT2Date(Dt), Utils.HMS2Time(Utils.Dt2Hours(Dt), (m div 10) * 10 + 5, 0)))
            else
                exit(CreateDateTime(DT2Date(Dt), Utils.HMS2Time(Utils.Dt2Hours(Dt), (m div 10) * 10 + 10, 0)))
        end;
    end;
}

