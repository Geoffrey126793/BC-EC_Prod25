tableextension 50036 ProductionOrderEC extends "Production Order"
{
    fields
    {
        field(50001; IDVP; Text[80])
        {
            Caption = 'IDVP';
        }
        field(50002; "Quantité MP"; Decimal)
        {
            Caption = 'Quantité MP';
            DecimalPlaces = 0 : 0;
        }
        field(50003; "Quantité réalisée"; Decimal)
        {
            CalcFormula = Sum("Prod. Order Line"."Finished Quantity" WHERE(Status = FIELD(Status),
                                                                            "Prod. Order No." = FIELD("No.")));
            Caption = 'Quantité réalisée';
            FieldClass = FlowField;
        }
        field(50004; "Quantite total composants"; Decimal)
        {
            CalcFormula = Sum("Prod. Order Component"."Expected Quantity" WHERE("Prod. Order No." = FIELD("No."),
                                                                                 Status = FIELD(Status)));
            Caption = 'Quantite total composants';
            FieldClass = FlowField;
        }
        field(50005; Machine; Text[250])
        {
            DataClassification = ToBeClassified;
            Description = 'Machine (N° de four, malaxeur, ...)';
            TableRelation = Code.Code WHERE("Table No" = CONST(5405),
                                             "Field No" = CONST(50005));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                Machine := UpperCase(Machine);
            end;
        }
        field(50006; "Quantité utilisée"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Order Type" = CONST(Production),
                                                                  "Order No." = FIELD("No."),
                                                                  "Entry Type" = CONST(Consumption),
                                                                  "Item Category Code" = FILTER(<> '7-E*' & <> '8*' & <> '9*')));
            Caption = 'Quantité utilisée';
            FieldClass = FlowField;
        }
        field(50007; Effectif; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Temps total" := Effectif * "Durée (h)";
            end;
        }
        field(50008; "Durée (h)"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Temps total" := Effectif * "Durée (h)";
            end;
        }
        field(50009; "Temps total"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50100; "Production BOM Version"; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnLookup()
            var
                Version: Record "Production BOM Version";
                ProdLine: Record "Prod. Order Line";
                ProdOrder: Record "Production Order";
            begin
                ProdLine.Reset;
                ProdLine.SetRange(Status, Status);
                ProdLine.SetRange("Prod. Order No.", "No.");
                ProdLine.SetRange("Line No.", 10000);
                if ProdLine.FindFirst then begin
                    Version.Reset;
                    Version.SetRange("Production BOM No.", ProdLine."Production BOM No.");
                    if PAGE.RunModal(0, Version) = ACTION::LookupOK then begin
                        //    "Production BOM Version" := Version."Version Code";
                        //    COMMIT;
                        Validate("Production BOM Version", Version."Version Code");
                        Modify;
                    end;

                end;
            end;

            trigger OnValidate()
            var
                ProdOrder: Record "Production Order";
            begin
            end;
        }
        field(50101; "No Ordre"; Integer)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "No Ordre" > 0 then
                    Ordre := Format(Date2DWY("Due Date", 1)) + '-' + Format("No Ordre")
                else
                    Ordre := '';
            end;
        }
        field(50102; Ordre; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50103; "Activite1 Effectif"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50104; "Activite1 Duree"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50105; "Activite2 Effectif"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50106; "Activite2 Duree"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50107; Emplacement; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Code.Code WHERE("Table No" = CONST(5405),
                                             "Field No" = CONST(50107));
        }
        field(50108; "Setup Effectif"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50109; "Setup Duree"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50110; "Setup Duree totale"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50111; "Interruption Duree"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50112; "Interruption Raison"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(50113; "Commentaires VP"; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
        field(50114; "Recyclage VP"; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
        field(50115; Confirmed; Boolean)
        {
            Caption = 'Confirmed';
            DataClassification = ToBeClassified;
        }
        field(50116; "Nbre malaxage"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50117; Ligne_proprete; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50118; "Ligne_integrité"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50119; Termine; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50120; "No malaxage"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(50121; Malaxeur; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50122; Recyclage; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50123; Ligne_securite; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50124; Halal; Code[20])
        {
            CalcFormula = Lookup(Item."Criteria 10" WHERE("No." = FIELD("Source No.")));
            FieldClass = FlowField;
        }
        field(50125; LastStartDate; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50126; "Effectif Nomenclature"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

}

