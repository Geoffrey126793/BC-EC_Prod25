table 50034 "Heures ABC"
{

    fields
    {
        field(1; "Production No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Production Line"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "OF ID"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Activite; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Ressource; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6; LineNo; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(7; Atelier; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Description Activite"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Description Ressource"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(10; Debut; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(11; Fin; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "h calcule"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "h MO"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "h Machine"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Cout Kg"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(16; "h MO prevu"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "h Machine prevu"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(18; Imputation; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Direct,Indirect;
        }
        field(19; "Operateurs prevu"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(20; Effectif; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Prod BOM"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Prod BOM Version"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Cout total"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Activite regroupement"; Text[10])
        {
            CalcFormula = Lookup ("ABC - Activites".Regroupement WHERE (Code = FIELD (Activite)));
            FieldClass = FlowField;
        }
        field(25; "Activite regroupement Desc"; Text[50])
        {
            CalcFormula = Lookup ("ABC - Activites"."Regroupement Description" WHERE (Code = FIELD (Activite)));
            FieldClass = FlowField;
        }
        field(26; OnOF; Boolean)
        {
            CalcFormula = Lookup ("ABC - Activites"."On OF" WHERE (Code = FIELD (Activite)));
            FieldClass = FlowField;
        }
        field(27; "h Pointages"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(28; "h Pointages Machine"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Production No", "Production Line", LineNo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        hABC: Record "Heures ABC";
    begin
    end;

    trigger OnModify()
    var
        hABC: Record "Heures ABC";
        ProdH: Record "Production Order";
        ABCRess: Record "ABC - Ressources";
    begin
        if "OF ID" = '' then "OF ID" := "Production No" + '-' + Format("Production Line");
        /* ????
        hABC.RESET;
        hABC.SETRANGE("Production No","Production No");
        hABC.SETRANGE("Production Line","Production Line");
        IF hABC.FINDFIRST THEN
        BEGIN
          Ressource := hABC.Ressource;
          "Description Ressource" := hABC."Description Ressource";
          "Prod BOM" := hABC."Prod BOM";
          "Prod BOM Version" := hABC."Prod BOM Version";
          Atelier := hABC.Atelier;
        END;
        
        */
        if (Debut <> 0DT) and (Fin <> 0DT) then begin
            if Activite = '999' then
                "h MO" := Effectif * "h calcule";
            if ((StrPos(Activite, 'S') = 0) or ("h calcule" = 0)) then
                "h calcule" := ((DT2Time(Fin) - DT2Time(Debut)) / 60000) / 60;
            if ABCRess.Get(Ressource) then begin
                if Effectif > 0 then
                    if ("h calcule" > 0) then
                        "h MO" := Effectif * "h calcule"
                    else
                        "h MO" := 0;
                if (ABCRess.Type = ABCRess.Type::"Machine (planifiable)") or (ABCRess.Type = ABCRess.Type::"Matériel") then begin
                    if ("h calcule" > 0) then
                        "h Machine" := "h calcule"
                    else
                        "h Machine" := 0;
                end
                else begin


                end;
            end;
        end;

    end;
}

