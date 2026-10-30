codeunit 50098 ProdEC
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Report, 50058, 'OnBeforeCalcProdOrder', '', false, false)]
    local procedure R99001025_OnBeforeRecalculate(var ProductionOrder: Record "Production Order")
    var
        Item: Record Item;
        BomH: Record "Production BOM Header";
        tmp: Decimal;
    begin
        if (DT2Time(ProductionOrder."Starting Date-Time") <> ProductionOrder."Starting Time") then begin
            ProductionOrder."Starting Time" := DT2Time(ProductionOrder."Starting Date-Time");  //recalcul Time, erreur via WebService UTC
            ProductionOrder."Starting Date" := DT2Date(ProductionOrder."Starting Date-Time");
        end;
        if (DT2Time(ProductionOrder."Ending Date-Time") <> ProductionOrder."Ending Time") then begin
            ProductionOrder."Ending Time" := DT2Time(ProductionOrder."Ending Date-Time");
            ProductionOrder."Ending Date" := DT2Date(ProductionOrder."Ending Date-Time");
        end;
        if Item.Get(ProductionOrder."Source No.") then
            if BomH.Get(Item."Production BOM No.") then begin
                tmp := GetTotalMPPerUnit(BomH, ProductionOrder."Production BOM Version");
                if (ProductionOrder."Quantité MP" > 0) and (ProductionOrder.Quantity = 0) then begin
                    if (tmp = 0) then tmp := 1;
                    ProductionOrder.Quantity := ProductionOrder."Quantité MP" / tmp;
                end
                else begin
                    ProductionOrder."Quantité MP" := ProductionOrder.Quantity * tmp;
                end;
            end;
    end;

    [EventSubscriber(ObjectType::Report, 50058, 'OnAfterRefreshProdOrder', '', false, false)]
    local procedure R99001025_OnAfterRecalculate(var ProductionOrder: Record "Production Order"; ErrorOccured: Boolean)
    begin
        RefreshABC(ProductionOrder."No.");
    end;

    [Scope('OnPrem')]
    procedure GetTotalMPPerUnit(rec: Record "Production BOM Header"; Version: Code[50]): Decimal
    var
        BomLine: Record "Production BOM Line";
        BomH: Record "Production BOM Header";
        VersionMgt: Codeunit VersionManagement;
        Items: Record Item;
        Total: Decimal;
    begin
        BomLine.Reset;
        BomLine.SetRange("Production BOM No.", rec."No.");
        if Version = '' then
            BomLine.SetRange("Version Code", VersionMgt.GetBOMVersion(rec."No.", WorkDate, true))
        else
            BomLine.SetRange("Version Code", Version);

        BomLine.SetFilter("Starting Date", '%1|..%2', 0D, WorkDate);
        BomLine.SetFilter("Ending Date", '%1|%2..', 0D, WorkDate);
        if BomLine.FindSet then
            repeat
                if BomLine.Type = BomLine.Type::Item then
                    if Items.Get(BomLine."No.") then
                        if (((CopyStr(Items."Item Category Code", 1, 5) = '7-MP1') or (CopyStr(Items."Item Category Code", 1, 5) = '5-CRU')) and (Items."Item Category Code" <> '7-MP1-4DV')) then begin
                            Total := Total + BomLine.Quantity;
                        end
                        else begin
                            if Items.IsMfgItem then begin
                                if BomH.Get(Items."Production BOM No.") then
                                    Total := Total + BomLine.Quantity * GetTotalMPPerUnit(BomH, '');
                            end;
                        end;

            until BomLine.Next = 0;
        exit(Total);

    end;

    [Scope('OnPrem')]
    procedure RefreshABC(ProductionNo: Code[20])
    var
        ABCHeures: Record "Heures ABC";
        ABCParameters: Record "ABC - Parametres";
        ProdL: Record "Prod. Order Line";
        ABCRess: Record "ABC - Ressources";
        ABCActivites: Record "ABC - Activites";
    begin
        ABCHeures.Reset;
        ABCHeures.SetRange("Production No", ProductionNo);
        ABCHeures.SetFilter("h calcule", '<>0');
        ABCHeures.SetFilter(Debut, '<>%1', 0DT);
        if not ABCHeures.FindFirst then begin
            ABCHeures.Reset;
            ABCHeures.SetRange("Production No", ProductionNo);
            ABCHeures.DeleteAll;
            ProdL.Reset;
            ProdL.SetRange("Prod. Order No.", ProductionNo);
            if ProdL.FindSet then
                repeat
                    ABCParameters.Reset;
                    ABCParameters.SetRange("Production BOM No", ProdL."Production BOM No.");
                    ABCParameters.SetRange("BOM Version", ProdL."Production BOM Version Code");
                    if ABCParameters.FindSet then
                        repeat
                            ABCHeures.Reset;
                            ABCHeures.Init;
                            ABCHeures."Production No" := ProductionNo;
                            ABCHeures."Production Line" := ProdL."Line No.";
                            ABCHeures.LineNo := ABCParameters.LineNo;
                            ABCHeures."OF ID" := ProductionNo + '-' + Format(ProdL."Line No.");
                            ABCHeures.Activite := ABCParameters.Activity;
                            ABCHeures.Ressource := ABCParameters.Ressource;
                            ABCRess.Get(ABCParameters.Ressource);
                            ABCHeures."Description Ressource" := ABCRess.Description;
                            ABCActivites.Get(ABCParameters.Activity);
                            ABCHeures.Atelier := ABCActivites.Atelier;
                            ABCHeures."Description Activite" := ABCActivites.Description;
                            ABCHeures.Imputation := ABCActivites.Imputation;
                            ABCHeures."Operateurs prevu" := ABCParameters."Nombre d'opérateurs";
                            ABCHeures."Prod BOM" := ABCParameters."Production BOM No";
                            ABCHeures."Prod BOM Version" := ABCParameters."BOM Version";
                            ABCHeures.Insert;
                        until ABCParameters.Next = 0;
                until ProdL.Next = 0;

        end;
    end;


    var
        myInt: Integer;
}