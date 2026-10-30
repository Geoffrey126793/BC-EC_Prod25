page 50094 PBI_OF
{
    PageType = List;
    SourceTable = "Prod. Order Line";
    SourceTableView = WHERE ("Due Date" = FILTER (20200101D ..));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Status; Status)
                {
                }
                field("Prod. Order No."; "Prod. Order No.")
                {
                }
                field("Line No."; "Line No.")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field("Due Date"; "Due Date")
                {
                }
                field("Production BOM No."; "Production BOM No.")
                {
                }
                field(Version; Version)
                {
                    Caption = 'Version';
                }
                field("ProdOrder.""Activite1 Effectif"""; ProdOrder."Activite1 Effectif")
                {
                    Caption = 'Act1Effectif';
                }
                field("ProdOrder.""Activite1 Duree"""; ProdOrder."Activite1 Duree")
                {
                    Caption = 'Act1Duree';
                }
                field("ProdOrder.""Activite2 Effectif"""; ProdOrder."Activite2 Effectif")
                {
                    Caption = 'Act2Effectif';
                }
                field("ProdOrder.""Activite2 Duree"""; ProdOrder."Activite2 Duree")
                {
                    Caption = 'Ac2Duree';
                }
                field("ProdOrder.""Setup Effectif"""; ProdOrder."Setup Effectif")
                {
                    Caption = 'SetupEffectif';
                }
                field("ProdOrder.""Setup Duree"""; ProdOrder."Setup Duree")
                {
                    Caption = 'SetupDuree';
                }
                field("ProdOrder.""Setup Duree totale"""; ProdOrder."Setup Duree totale")
                {
                    Caption = 'SetupDureeTotale';
                }
                field("ProdOrder.""Interruption Duree"""; ProdOrder."Interruption Duree")
                {
                    Caption = 'InterruptionDuree';
                }
                field("ProdOrder.""Interruption Raison"""; ProdOrder."Interruption Raison")
                {
                    Caption = 'InterruptionRaison';
                }
                field("ProdOrder.""Temps total"""; ProdOrder."Temps total")
                {
                    Caption = 'DureeTotale';
                }
                field(Machine; ProdOrder.Machine)
                {
                    Caption = 'Machine';
                }
                field(Termine; Termine)
                {
                }
                field(Quantity; ProdOrder.Quantity)
                {
                }
                field("Starting Date-Time"; "Starting Date-Time")
                {
                }
                field(Emplacement; ProdOrder.Emplacement)
                {
                }
                field(QtyProduite; ProdOrder."Quantité réalisée")
                {
                }
                field(EffectifNomenclature; ProdOrder."Effectif Nomenclature")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        if not ProdOrder.Get(Rec.Status, Rec."Prod. Order No.") then;
        Version := "Production BOM Version Code";
        if Version = '' then
            Version := VersionMgt.GetBOMVersion(Rec."Item No.", Rec."Due Date", false);
        ProdOrder.CalcFields("Quantité réalisée");
    end;

    var
        ProdOrder: Record "Production Order";
        Version: Code[50];
        VersionMgt: Codeunit VersionManagement;
}

