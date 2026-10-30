tableextension 50034 ProdOrderLineEC extends "Prod. Order Line"
{
    fields
    {
        field(50001; "Nombre de palettes"; Integer)
        {
            CalcFormula = Count(Pallet WHERE(NumOF = FIELD("Prod. Order No."),
                                              LigneOF = FIELD("Line No.")));
            Caption = 'Nombre de palettes';
            FieldClass = FlowField;
        }
        field(50002; IDVP; Text[80])
        {
            Caption = 'IDVP';
        }
        field(50003; "Quantité utilisée"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Order Type" = CONST(Production),
                                                                  "Order No." = FIELD("Prod. Order No."),
                                                                  "Order Line No." = FIELD("Line No."),
                                                                  "Entry Type" = CONST(Consumption)));
            FieldClass = FlowField;
        }
        field(50004; TmpMateriel; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50005; TmpOperateur; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50006; Emplacement; Code[30])
        {
            CalcFormula = Lookup("Production Order".Emplacement WHERE(Status = FIELD(Status),
                                                                       "No." = FIELD("Prod. Order No.")));
            FieldClass = FlowField;
        }
        field(50117; Ligne_proprete; Code[10])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                prodH: Record "Production Order";
            begin
                if prodH.Get(Status, "Prod. Order No.") then begin
                    prodH.Ligne_proprete := Ligne_proprete;
                    prodH.Modify(false);
                end;
            end;
        }
        field(50118; "Ligne_integrité"; Code[10])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                prodH: Record "Production Order";
            begin
                if prodH.Get(Status, "Prod. Order No.") then begin
                    prodH.Ligne_integrité := Ligne_integrité;
                    prodH.Modify(false);
                end;
            end;
        }
        field(50119; Termine; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                ProdH: Record "Production Order";
            begin
                if ProdH.Get(Status, "Prod. Order No.") then begin
                    ProdH.Termine := Termine;
                    ProdH.Modify(false);
                end;
            end;
        }
        field(50120; Malaxeur; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50121; Ligne_securite; Code[10])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                ProdH: Record "Production Order";
            begin
                if ProdH.Get(Status, "Prod. Order No.") then begin
                    ProdH.Ligne_securite := Ligne_securite;
                    ProdH.Modify(false);
                end;
            end;
        }
    }
    keys
    {
        key("Starting Date-Time"; "Starting Date-Time")
        {

        }
    }

}