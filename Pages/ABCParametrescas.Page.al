page 50058 "ABC - Parametres cas"
{
    AutoSplitKey = true;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "ABC - Parametres";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Production BOM No"; "Production BOM No")
                {
                }
                field("BOM Version"; "BOM Version")
                {
                }
                field(Activity; Activity)
                {
                }
                field(Ressource; Ressource)
                {
                }
                field("Rendement nominal"; "Rendement nominal")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("OEE (%)"; "OEE (%)")
                {
                }
                field("Rendement effectif"; "Rendement effectif")
                {
                }
                field("Unité"; Unité)
                {

                    trigger OnValidate()
                    begin
                        EditStdBatch := (Unité = Unité::"Heure/Batch");
                    end;
                }
                field("Nombre d'opérateurs"; "Nombre d'opérateurs")
                {
                }
                field("Batch standard"; "Batch standard")
                {
                    Editable = EditStdBatch;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        EditStdBatch := (Unité = Unité::"Heure/Batch");
    end;

    var
        EditStdBatch: Boolean;

    [Scope('OnPrem')]
    procedure setActivity(Activity: Code[20])
    var
        param: Record "ABC - Parametres";
        VersionMgt: Codeunit VersionManagement;
    begin
        param.Reset;
        param.SetRange(Activity, Activity);
        if param.FindSet then
            repeat
                if param."BOM Version" = VersionMgt.GetBOMVersion(param."Production BOM No", Today, true) then begin
                    Rec.Init;
                    Rec.TransferFields(param, true);
                    Rec.Insert;
                end;
            until param.Next = 0;
    end;

    [Scope('OnPrem')]
    procedure setRessource(Ressource: Code[20])
    var
        param: Record "ABC - Parametres";
        VersionMgt: Codeunit VersionManagement;
    begin
        param.Reset;
        param.SetRange(Ressource, Ressource);
        if param.FindSet then
            repeat
                if param."BOM Version" = VersionMgt.GetBOMVersion(param."Production BOM No", Today, true) then begin
                    Rec.Init;
                    Rec.TransferFields(param, true);
                    Rec.Insert;
                end;
            until param.Next = 0;
    end;
}

