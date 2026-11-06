table 50037 PointagesProd
{
    // OF+Ligne  pour les start/stop OF
    // Machine+ActiviteRegroup=R999 pour les interruptions
    // Salarie pour les start/stop pointage
    // Machine+Activité S* pour setup


    fields
    {
        field(1; ID; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; Machine; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(3; DtDebut; DateTime)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if (Abs(DtDebut - CurrentDateTime) > 3 * 60 * 60 * 1000) and (DtFin = 0DT) then
                    DtDebut := CurrentDateTime;
            end;
        }
        field(4; DtFin; DateTime)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if Date2DMY(DT2Date(DtFin), 3) > 2000 then begin
                    if DtDebut > DtFin then
                        DtFin := CreateDateTime(DT2Date(DtDebut), DT2Time(DtFin));
                    if DtDebut > DtFin then
                        DtFin := CurrentDateTime;
                end;
            end;
        }
        field(5; Salarie; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "OF"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(7; LigneOF; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(8; ActiviteRegroup; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(9; ActiviteRegroupDesc; Text[50])
        {
            CalcFormula = Lookup("ABC - Activites".Description WHERE(Code = FIELD(ActiviteRegroup)));
            FieldClass = FlowField;
        }
        field(10; Comment; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(11; NomSalarie; Code[250])
        {
            CalcFormula = Lookup(Employee."Search Name" WHERE("No." = FIELD(Salarie)));
            FieldClass = FlowField;
        }
        field(12; Minutes; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(14; DtDebutEncodee; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(15; DtFinEncodee; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(16; tmp_nbreOF; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(17; Traitement; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Pointage,Error,NotDistributed;
        }
        field(18; Traite; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Temps interruption"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Interruption machine"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(21; Emplacement; Code[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; ID)
        {
            Clustered = true;
        }
        key(Key2; Salarie)
        {
        }
        key(Key3; "OF", ActiviteRegroup)
        {
        }
        key(Key4; Salarie, DtDebut)
        {
        }
        key(Key5; Machine, DtDebut)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        recTmp: Record PointagesProd;
    begin
        if ID = 0 then begin
            recTmp.Reset;
            if recTmp.FindLast then
                ID := recTmp.ID + 1
            else
                ID := 1;
        end;
    end;

    trigger OnModify()
    begin
        if ((ActiviteRegroup = 'R999') AND (DtFin <> 0DT)) then begin
            "Interruption machine" := ROUND((DtFin - DtDebut) / 60000, 1, '=') / 60;
        end;
    end;

}

