report 50191 "Rolled-up Cost SharesEC"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/RolledupCostShares.rdlc';
    AdditionalSearchTerms = 'Coût multi-niveau détaillé';
    Caption = 'Rolled-up Cost Shares';


    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("No.") WHERE(Blocked = CONST(false));
            RequestFilterFields = "No.", "Search Description", "Inventory Posting Group";
            column(COMPANYNAME; CompanyName)
            {
            }
            column(Text000___FORMAT__Calc_Date__; Text000 + Format(CalculateDate))
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(USERID; UserId)
            {
            }
            column(CurrReport_PAGENO; '0')
            {
            }
            column(ShowMatriceDetail; ShowMatriceDetail)
            {
            }
            column(ShowABC; ShowABC)
            {
            }
            column(Item_TABLECAPTION__________ItemFilter; Item.TableCaption + ': ' + ItemFilter)
            {
            }
            column(ItemFilter; ItemFilter)
            {
            }
            column(Item__No__; "No.")
            {
            }
            column(Item_Description; Description)
            {
            }
            column(MatriceCostFirst; MatriceCostFirst)
            {
            }
            column(ABCCostFirst; SubTotalABC)
            {
            }
            column(Rolled_up_Cost_SharesCaption; Rolled_up_Cost_SharesCaptionLbl)
            {
            }
            column(PageCaption; PageCaptionLbl)
            {
            }
            column(CapacityCostCaption; CapacityCostCaptionLbl)
            {
            }
            column(MaterialCostCaption; MaterialCostCaptionLbl)
            {
            }
            column(BOMCompQtyBaseCaption; BOMCompQtyBaseCaptionLbl)
            {
            }
            column(ProdBOMLine_Index__DescriptionCaption; ProdBOMLine_Index__DescriptionCaptionLbl)
            {
            }
            column(ProdBOMLine_Index___No__Caption; ProdBOMLine_Index___No__CaptionLbl)
            {
            }
            column(PADSTR____Level________FORMAT_Level_Caption; PADSTR____Level________FORMAT_Level_CaptionLbl)
            {
            }
            column(CompItem__Base_Unit_of_Measure_Caption; CompItem__Base_Unit_of_Measure_CaptionLbl)
            {
            }
            dataitem(matriceLoop1; "Integer")
            {
                column(Cost; Cost)
                {
                }
                column("Matrice_tmp_Pondération"; Matrice_tmp.Pondération)
                {
                }
                column(Matrice_tmp__Description_centre_; Matrice_tmp."Description centre")
                {
                }
                column(Matrice_tmp__Centre_de_charges_; Matrice_tmp."Centre de charges")
                {
                }
                column(Atelier; Atelier)
                {
                }
                column(matriceLoop1_Number; Number)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                        Matrice_tmp.FindFirst
                    else
                        Matrice_tmp.Next;

                    Matrice_tmp.CalcFields("Description centre");
                    Centres.Get(Matrice_tmp."Centre de charges");
                    Cost := CuProd.getMatriceCostCentre(Centres."No.", CalculateDate);
                    //Atelier := COPYSTR(Matrice_tmp."Centre de charges",1,STRPOS(Matrice_tmp."Centre de charges",'_')-1);
                    Atelier := Matrice_tmp."Centre de charges";
                end;

                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, Matrice_tmp.Count);
                end;
            }
            dataitem(ABCLoop1; "Integer")
            {
                column(ABC_Params_LineNo; ABC_Params.LineNo)
                {
                }
                column(ABC_Params_Activity; ABC_Params.Activity)
                {
                }
                column(ABC_Params_Ressource; ABC_Params.Ressource)
                {
                }
                column(ABC_Params_ActivityDesc; ABC_Params."Activity description")
                {
                }
                column(ABC_Params_RessourceDesc; ABC_Params."Ressource description")
                {
                }
                column(ABC_Params_Rendement; ABC_Params."Rendement effectif")
                {
                }
                column(ABC_Params_Unite; ABC_Params.Unité)
                {
                }
                column(ABC_Params_NbreOp; ABC_Params."Nombre d'opérateurs")
                {
                }
                column(ABC_Params_CoutKg; ABC_Params."Cout Kg")
                {
                }

                trigger OnAfterGetRecord()
                var
                    recActivity: Record "ABC - Activites";
                begin
                    //MESSAGE('loop1   %1',Number);
                    if Number = 1 then
                        ABC_Params.FindFirst
                    else
                        ABC_Params.Next;
                    if recActivity.Get(ABC_Params.Activity) then
                        TxtActivity := recActivity.Description;
                    ABC_Params.CalcFields("Ressource description");
                    ABC_Params.CalcFields("Activity description");
                end;

                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, 0);
                    if (ShowABC) then SetRange(Number, 1, ABC_Params.Count);
                end;
            }
            dataitem(BOMLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                column(Item__Rolled_up_Material_Cost_; ItemMaterialCost)
                {
                    AutoFormatType = 2;
                    DecimalPlaces = 2 : 5;
                }
                column(TotalMatriceCost; TotalMatriceCost)
                {
                }
                column(TotalABC; TotalABC)
                {
                }
                column(Cost_Shares_for_this_ItemCaption; Cost_Shares_for_this_ItemCaptionLbl)
                {
                }
                column(BOMLoop_Number; Number)
                {
                }
                dataitem("Integer"; "Integer")
                {
                    DataItemTableView = SORTING(Number);
                    MaxIteration = 1;
                    column(ProdBOMLine_Index___No__; ProdBOMLine[Index]."No.")
                    {
                    }
                    column(ProdBOMLine_Index__Description; ProdBOMLine[Index].Description)
                    {
                    }
                    column(BOMCompQtyBase; BOMCompQtyBase)
                    {
                        AutoFormatType = 2;
                        DecimalPlaces = 0 : 5;
                    }
                    column(PADSTR____Level________FORMAT_Level_; PadStr('', Level, ' ') + Format(Level))
                    {
                    }
                    column(MaterialCost; MaterialCost)
                    {
                        AutoFormatType = 2;
                        DecimalPlaces = 2 : 5;
                    }
                    column(CompItem__Base_Unit_of_Measure_; CompItem."Base Unit of Measure")
                    {
                    }
                    column(ShowLine1; ProdBOMLine[Index].Type = ProdBOMLine[Index].Type::Item)
                    {
                    }
                    column(MaterialCostSim; MaterialCostSim)
                    {
                        AutoFormatType = 2;
                        DecimalPlaces = 2 : 5;
                    }
                    column(MatriceCost; MatriceCost)
                    {
                    }
                    column(TotalCostSim; TotalCostSim)
                    {
                    }
                    column(ABCCost; SubTotalABC)
                    {
                    }
                    column(Integer_Number; Number)
                    {
                    }
                    dataitem(matriceLoop; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                        column(Matrice_tmp__Centre_de_charges__Control1000000005; Matrice_tmp."Centre de charges")
                        {
                        }
                        column("Matrice_tmp_Pondération_Control1000000006"; Matrice_tmp.Pondération)
                        {
                        }
                        column(Matrice_tmp__Description_centre__Control1000000007; Matrice_tmp."Description centre")
                        {
                        }
                        column(Cost_Control1000000008; Cost)
                        {
                        }
                        column(cost_matrice; cost_matrice)
                        {
                        }
                        column(Atelier_Control1000000017; Atelier)
                        {
                        }
                        column(matriceLoop_Number; Number)
                        {
                        }

                        trigger OnAfterGetRecord()
                        var
                            CUProd: Codeunit "Integration Tft and Prod";
                        begin
                            if Number = 1 then
                                Matrice_tmp.FindFirst
                            else
                                Matrice_tmp.Next;

                            Matrice_tmp.CalcFields("Description centre");
                            Centres.Get(Matrice_tmp."Centre de charges");
                            Cost := CUProd.WorkCenter_getMatriceCost(CalculateDate, Centres);
                            cost_matrice := BOMCompQtyBase * Cost * Matrice_tmp.Pondération;
                            //MESSAGE('%1  %2  %3   %4   %5',Centres."No.",BOMCompQtyBase , Cost , Matrice_tmp.Pondération,cost_matrice);
                            //Atelier := COPYSTR(Matrice_tmp."Centre de charges",1,STRPOS(Matrice_tmp."Centre de charges",'_')-1);
                            Atelier := Matrice_tmp."Centre de charges";
                        end;

                        trigger OnPreDataItem()
                        begin
                            SetRange(Number, 1, Matrice_tmp.Count);
                        end;
                    }
                    dataitem(ABCLoop2; "Integer")
                    {
                        column(ABC_Params_LineNo2; ABC_Params.LineNo)
                        {
                        }
                        column(ABC_Params_Activity2; ABC_Params.Activity)
                        {
                        }
                        column(ABC_Params_Ressource2; ABC_Params.Ressource)
                        {
                        }
                        column(ABC_Params_ActivityDesc2; ABC_Params."Activity description")
                        {
                        }
                        column(ABC_Params_RessourceDesc2; ABC_Params."Ressource description")
                        {
                        }
                        column(ABC_Params_Rendement2; ABC_Params."Rendement effectif")
                        {
                        }
                        column(ABC_Params_Unite2; ABC_Params.Unité)
                        {
                        }
                        column(ABC_Params_NbreOp2; ABC_Params."Nombre d'opérateurs")
                        {
                        }
                        column(ABC_Params_CoutKg2; ABC_Params."Cout Kg")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            //MESSAGE('loop2   %1',Number);
                            if Number = 1 then
                                ABC_Params.FindFirst
                            else
                                ABC_Params.Next;
                            ABC_Params.CalcFields("Ressource description");
                            ABC_Params.CalcFields("Activity description");
                        end;

                        trigger OnPreDataItem()
                        begin
                            SetRange(Number, 1, 0);
                            if (ShowABC) then SetRange(Number, 1, ABC_Params.Count);
                        end;
                    }

                    trigger OnAfterGetRecord()
                    var
                        Matrice: Record "Ateliers Liens";
                    begin
                        BOMCompQtyBase := Quantity[Index] * CompItemQtyBase / LotSize[Index];
                        CapacityCost :=
                          Round(
                            BOMCompQtyBase * (CompItem."Rolled-up Capacity Cost" + CompItem."Rolled-up Subcontracted Cost"),
                            GLSetup."Unit-Amount Rounding Precision");
                        OverheadCost :=
                          Round(
                            BOMCompQtyBase * (CompItem."Rolled-up Mfg. Ovhd Cost" + CompItem."Rolled-up Cap. Overhead Cost"),
                            GLSetup."Unit-Amount Rounding Precision");
                        MaterialCost :=
                          Round(
                            BOMCompQtyBase * CompItem."Rolled-up Material Cost",
                            GLSetup."Unit-Amount Rounding Precision");
                        if (CalculateDate < Today) then begin
                            HistoCouts.Reset;
                            HistoCouts.SetRange(Item, CompItem."No.");
                            HistoCouts.SetFilter(Date, '<=%1', CalculateDate);
                            HistoCouts.SetRange(Type, HistoCouts.Type::"Cout standard");
                            if HistoCouts.FindLast then
                                MaterialCost :=
                              Round(
                                BOMCompQtyBase * HistoCouts.Cout,
                                GLSetup."Unit-Amount Rounding Precision");

                        end;

                        MaterialCostSim := 0;
                        MatriceCost := 0;
                        MatriceCost22A := 0;
                        if not CompItem.IsMfgItem then begin
                            if CompItem."Cout simulation" > 0 then begin
                                MaterialCostSim :=
                                  Round(
                                    BOMCompQtyBase * CompItem."Cout simulation",
                                    GLSetup."Unit-Amount Rounding Precision");
                            end
                            else begin
                                MaterialCostSim := MaterialCost;
                            end;
                        end
                        else begin
                            MatriceCost := Round(
                              BOMCompQtyBase * CuProd.GetMatriceCost(CompItem."No.", CalculateDate),
                              GLSetup."Unit-Amount Rounding Precision");
                            MatriceCost22A := Round(
                              BOMCompQtyBase * CuProd.GetMatriceCostWithout22A(CompItem."No.", CalculateDate),
                              GLSetup."Unit-Amount Rounding Precision");

                        end;
                        TotalCostSim += MaterialCostSim;
                        TotalCostStd += MaterialCost;
                        TotalMatriceCost += MatriceCost;
                        TotalMatriceCost22A += MatriceCost22A;

                        TotalCost := MaterialCost + CapacityCost + OverheadCost;


                        Matrice_tmp.Reset;
                        Matrice_tmp.DeleteAll;
                        /*
                        TotalCost := 0;
                        IF ShowMatriceDetail THEN
                        BEGIN
                         Centres.RESET;
                         IF Centres.FINDSET THEN
                         REPEAT
                          Matrice.RESET;
                          Matrice.SETRANGE(Article,ProdBOMLine[Index]."No.");
                          Matrice.SETRANGE("Centre de charges",Centres."No.");
                          Matrice.SETFILTER(Début,'<=%1',CalculateDate);
                          Matrice.SETFILTER(Fin,'%1|>=%2',0D,CalculateDate);
                          IF Matrice.FINDLAST THEN
                          BEGIN
                            IF Matrice.Pondération <> 0 THEN
                            BEGIN
                              Matrice_tmp.RESET;
                              Matrice_tmp.INIT;
                              Matrice_tmp.TRANSFERFIELDS(Matrice,TRUE);
                              Matrice_tmp.INSERT;
                            END;
                          END;
                         UNTIL Centres.NEXT=0;
                        END;
                        */
                        CuProd.ABC_GetMatriceAtelier(ABC_Params, Matrice_tmp, CalculateDate);

                    end;

                    trigger OnPostDataItem()
                    begin
                        Index := NextIndex;

                        if CompItem.IsMfgItem and (CompItem."Production BOM No." <> '') then begin
                            MfgItem := CompItem;
                            Level := Level + 1;
                        end;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    //MESSAGE('LOOOOOP  %1    %2',ProdBOMLine[Index].Type,);
                    ABC_Params.DeleteAll;
                    SubTotalABC := 0;
                    while ProdBOMLine[Index].Next = 0 do begin
                        if NoListType[Index] = NoListType[Index] ::Item then
                            Level := Level - 1;
                        Index := Index - 1;
                        if Index < 1 then
                            CurrReport.Break;
                        if NoListType[Index] = NoListType[Index] ::Item then
                            MfgItem.Get(NoList[Index])
                        else
                            MfgItem."Production BOM No." := NoList[Index];
                        ProdBOMLine[Index].SetRange("Production BOM No.", MfgItem."Production BOM No.");
                        ProdBOMLine[Index].SetRange("Version Code", VersionCode[Index]);
                    end;

                    NextIndex := Index;

                    CompItemQtyBase :=
                      CostCalcMgt.CalcCompItemQtyBase(
                        ProdBOMLine[Index], CalculateDate, MfgItemQtyBase[Index], MfgItem."Routing No.",
                        NoListType[Index] = NoListType[Index] ::Item);

                    Clear(CompItem);

                    case ProdBOMLine[Index].Type of
                        ProdBOMLine[Index].Type::Item:
                            begin
                                CompItem.Get(ProdBOMLine[Index]."No.");
                                if CompItem.IsMfgItem and (CompItem."Production BOM No." <> '') and (CompItem."No." <> '9-DIV-00040') then begin
                                    NextIndex := Index + 1;
                                    //VersionCode[NextIndex] := VersionMgt.GetBOMVersion(ProdBOMHeader."No.",CalculateDate,TRUE);
                                    VersionCode[NextIndex] := VersionMgt.GetBOMVersion(CompItem."Production BOM No.", CalculateDate, true);
                                    NoListType[NextIndex] := NoListType[NextIndex] ::Item;
                                    NoList[NextIndex] := CompItem."No.";

                                    Clear(ProdBOMLine[NextIndex]);
                                    ProdBOMLine[NextIndex].SetRange("Production BOM No.", CompItem."Production BOM No.");
                                    ProdBOMLine[NextIndex].SetRange("Version Code", VersionCode[NextIndex]);
                                    ProdBOMLine[NextIndex].SetFilter("Starting Date", '%1|..%2', 0D, CalculateDate);
                                    ProdBOMLine[NextIndex].SetFilter("Ending Date", '%1|%2..', 0D, CalculateDate);

                                    LotSize[NextIndex] := GetLotSize(CompItem);
                                    MfgItemQtyBase[NextIndex] := CalcMfgItemQtyBase(CompItem, VersionCode[NextIndex], LotSize[NextIndex]);
                                    Quantity[NextIndex] := Quantity[Index] * CompItemQtyBase / LotSize[Index];
                                    // IF (ShowABC) THEN
                                    // BEGIN
                                    CuProd.ABC_GetParameters(ABC_Params, CompItem."Production BOM No.", VersionCode[NextIndex], CalculateDate);
                                    SubTotalABC := 0;
                                    if ABC_Params.FindSet then
                                        repeat
                                            ABC_Params."Cout Kg" := ABC_Params."Cout Kg" * Quantity[NextIndex];
                                            ABC_Params.Modify;
                                            SubTotalABC += ABC_Params."Cout Kg";
                                        until ABC_Params.Next = 0;
                                    TotalABC += SubTotalABC;
                                    // END;
                                    //MESSAGE('---- %1   %2',CompItem."Production BOM No.",VersionCode[NextIndex]);
                                end;
                            end;
                        ProdBOMLine[Index].Type::"Production BOM":
                            begin
                                NextIndex := Index + 1;

                                ProdBOMHeader.Get(ProdBOMLine[Index]."No.");

                                VersionCode[NextIndex] := VersionMgt.GetBOMVersion(ProdBOMHeader."No.", CalculateDate, true);
                                NoListType[NextIndex] := NoListType[NextIndex] ::"Production BOM";
                                NoList[NextIndex] := ProdBOMHeader."No.";

                                Clear(ProdBOMLine[NextIndex]);
                                ProdBOMLine[NextIndex].SetRange("Production BOM No.", NoList[NextIndex]);
                                ProdBOMLine[NextIndex].SetRange("Version Code", VersionCode[NextIndex]);
                                ProdBOMLine[NextIndex].SetFilter("Starting Date", '%1|..%2', 0D, CalculateDate);
                                ProdBOMLine[NextIndex].SetFilter("Ending Date", '%1|%2..', 0D, CalculateDate);

                                LotSize[NextIndex] := LotSize[Index];
                                MfgItemQtyBase[NextIndex] := CompItemQtyBase;
                                Quantity[NextIndex] := Quantity[Index];




                            end;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    Index := 1;
                    Level := 1;


                    //VersionCode[Index] := VersionMgt.GetBOMVersion(ProdBOMHeader."No.",CalculateDate,TRUE);
                    VersionCode[Index] := VersionMgt.GetBOMVersion(Item."Production BOM No.", CalculateDate, true);
                    NoListType[Index] := NoListType[Index] ::Item;
                    NoList[Index] := Item."No.";

                    Clear(ProdBOMLine);
                    ProdBOMLine[Index].SetRange("Production BOM No.", Item."Production BOM No.");
                    ProdBOMLine[Index].SetRange("Version Code", VersionCode[Index]);
                    ProdBOMLine[Index].SetFilter("Starting Date", '%1|..%2', 0D, CalculateDate);
                    ProdBOMLine[Index].SetFilter("Ending Date", '%1|%2..', 0D, CalculateDate);

                    LotSize[Index] := GetLotSize(Item);
                    MfgItemQtyBase[Index] := CalcMfgItemQtyBase(Item, VersionCode[Index], LotSize[Index]);
                    Quantity[Index] := 1;

                    MfgItem := Item;
                    ItemMaterialCost := Item."Rolled-up Material Cost";
                    if (CalculateDate < Today) then begin
                        HistoCouts.Reset;
                        HistoCouts.SetRange(Item, Item."No.");
                        HistoCouts.SetFilter(Date, '<=%1', CalculateDate);
                        HistoCouts.SetRange(Type, HistoCouts.Type::"Cout standard");
                        if HistoCouts.FindLast then
                            ItemMaterialCost :=
                          Round(
                            HistoCouts.Cout,
                            GLSetup."Unit-Amount Rounding Precision");

                    end;
                end;
            }
            dataitem(ValidSim; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

                trigger OnAfterGetRecord()
                var
                    items: Record Item;
                    Histo: Record "Histo couts";
                begin
                    items.Reset;
                    items.Get(Item."No.");
                    items."Px de revient matiére simulé" := TotalCostSim;
                    items."Px de revient matiÞre std" := Item."Rolled-up Material Cost";
                    items."Px de revient total" := Item."Rolled-up Material Cost" + TotalMatriceCost;
                    //MESSAGE('%1',TotalMatriceCost);
                    items."Px de revient sans 22A" := Item."Rolled-up Material Cost" + TotalMatriceCost22A;
                    items."Cout ABC" := TotalABC;
                    items.Modify;

                    Histo.Reset;
                    Histo.Init;
                    Histo.Type := Histo.Type::"Prix de revient matiére";
                    Histo.Item := Item."No.";
                    Histo.Date := CalculateDate;
                    Histo.Cout := items."Px de revient matiÞre std";
                    if Histo.Insert then;

                    Histo.Reset;
                    Histo.Init;
                    Histo.Type := Histo.Type::"Prix de revient total";
                    Histo.Item := Item."No.";
                    Histo.Date := CalculateDate;
                    Histo.Cout := items."Px de revient total";
                    if Histo.Insert then;

                    Histo.Reset;
                    Histo.Init;
                    Histo.Type := Histo.Type::"Prix de revient total sans 22A";
                    Histo.Item := Item."No.";
                    Histo.Date := CalculateDate;
                    Histo.Cout := items."Px de revient sans 22A";
                    if Histo.Insert then;

                    Histo.Reset;
                    Histo.Init;
                    Histo.Type := Histo.Type::ABC;
                    Histo.Item := Item."No.";
                    Histo.Date := CalculateDate;
                    Histo.Cout := items."Cout ABC";
                    if Histo.Insert then;
                end;
            }

            trigger OnAfterGetRecord()
            var
                Matrice: Record "Ateliers Liens";
            begin
                if not IsMfgItem or ("Production BOM No." = '') then
                    CurrReport.Skip;
                TotalCostSim := 0;
                TotalCostStd := 0;
                TotalABC := 0;
                MatriceCostFirst := CuProd.GetMatriceCost(Item."No.", CalculateDate);
                TotalMatriceCost := MatriceCostFirst;
                TotalMatriceCost22A := CuProd.GetMatriceCostWithout22A(Item."No.", CalculateDate);

                Matrice_tmp.Reset;
                Matrice_tmp.DeleteAll;

                TotalCost := 0;
                /*IF ShowMatriceDetail THEN
                BEGIN
                 Centres.RESET;
                 IF Centres.FINDSET THEN
                 REPEAT
                  Matrice.RESET;
                  Matrice.SETRANGE(Article,"No.");
                  Matrice.SETRANGE("Centre de charges",Centres."No.");
                  Matrice.SETFILTER(Début,'<=%1',CalculateDate);
                  Matrice.SETFILTER(Fin,'%1|>=%2',0D,CalculateDate);
                  IF Matrice.FINDLAST THEN
                  BEGIN
                    IF Matrice.Pondération <> 0 THEN
                    BEGIN
                      Matrice_tmp.RESET;
                      Matrice_tmp.INIT;
                      Matrice_tmp.TRANSFERFIELDS(Matrice,TRUE);
                      Matrice_tmp.INSERT;
                    END;
                  END;
                 UNTIL Centres.NEXT=0;
                END;
                */
                //IF (ShowABC) THEN
                //BEGIN
                ABC_Params.DeleteAll;
                CuProd.ABC_GetParameters(ABC_Params, Item."Production BOM No.", VersionMgt.GetBOMVersion(Item."Production BOM No.", CalculateDate, true), CalculateDate);
                SubTotalABC := 0;
                if ABC_Params.FindSet then
                    repeat
                        SubTotalABC += ABC_Params."Cout Kg";

                    until ABC_Params.Next = 0;
                TotalABC += SubTotalABC;

                CuProd.ABC_GetMatriceAtelier(ABC_Params, Matrice_tmp, CalculateDate);
                //END;

            end;

            trigger OnPreDataItem()
            begin
                ItemFilter := Item.GetFilters;
                GLSetup.Get;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(CalculateDate; CalculateDate)
                    {
                        Caption = 'Calculation Date';
                    }
                    field(ShowMatriceDetail; ShowMatriceDetail)
                    {
                        Caption = 'Afficher le détail de la matrice atelier';
                    }
                    field(ShowABC; ShowABC)
                    {
                        Caption = 'Afficher détail ABC';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            CalculateDate := WorkDate;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        CalculateDate := WorkDate;
    end;

    var
        Text000: Label 'As of ';
        GLSetup: Record "General Ledger Setup";
        ProdBOMHeader: Record "Production BOM Header";
        ProdBOMVersion: Record "Production BOM Version";
        ProdBOMLine: array[99] of Record "Production BOM Line";
        MfgItem: Record Item;
        CompItem: Record Item;
        UOMMgt: Codeunit "Unit of Measure Management";
        VersionMgt: Codeunit VersionManagement;
        CostCalcMgt: Codeunit "Cost Calculation Management";
        ItemFilter: Text[250];
        CalculateDate: Date;
        Level: Integer;
        Index: Integer;
        NextIndex: Integer;
        VersionCode: array[99] of Code[20];
        NoListType: array[99] of Option Item,"Production BOM";
        NoList: array[99] of Code[20];
        LotSize: array[99] of Decimal;
        MfgItemQtyBase: array[99] of Decimal;
        Quantity: array[99] of Decimal;
        BOMCompQtyBase: Decimal;
        MaterialCost: Decimal;
        CapacityCost: Decimal;
        OverheadCost: Decimal;
        TotalCost: Decimal;
        CompItemQtyBase: Decimal;
        MaterialCostSim: Decimal;
        TotalCostSim: Decimal;
        MatriceCost: Decimal;
        TotalMatriceCost: Decimal;
        MatriceCost22A: Decimal;
        TotalMatriceCost22A: Decimal;
        MatriceCostFirst: Decimal;
        TotalCostStd: Decimal;
        Matrice_tmp: Record "Ateliers Liens" temporary;
        Cost: Decimal;
        Centres: Record "Work Center";
        ShowMatriceDetail: Boolean;
        cost_matrice: Decimal;
        Atelier: Code[20];
        Rolled_up_Cost_SharesCaptionLbl: Label 'Rolled-up Cost Shares';
        PageCaptionLbl: Label 'Page';
        CapacityCostCaptionLbl: Label 'Label26';
        MaterialCostCaptionLbl: Label 'Material Cost';
        BOMCompQtyBaseCaptionLbl: Label 'Quantity (Base)';
        ProdBOMLine_Index__DescriptionCaptionLbl: Label 'Description';
        ProdBOMLine_Index___No__CaptionLbl: Label 'No.';
        PADSTR____Level________FORMAT_Level_CaptionLbl: Label 'Level';
        CompItem__Base_Unit_of_Measure_CaptionLbl: Label 'Base Unit of Measure Code';
        Cost_Shares_for_this_ItemCaptionLbl: Label 'Cost Shares for this Item';
        CuProd: Codeunit "Integration Tft and Prod";
        ABC_Params: Record "ABC - Parametres" temporary;
        ShowABC: Boolean;
        TxtActivity: Text;
        SubTotalABC: Decimal;
        TotalABC: Decimal;
        ABC_Activity: Record "ABC - Activites";
        HistoCouts: Record "Histo couts";
        ItemMaterialCost: Decimal;

    local procedure GetLotSize(Item: Record Item): Decimal
    begin
        if Item."Lot Size" <> 0 then
            exit(Item."Lot Size");

        exit(1);
    end;

    local procedure CalcMfgItemQtyBase(Item: Record Item; VersionCode: Code[20]; LotSize: Decimal): Decimal
    begin
        exit(
          CostCalcMgt.CalcQtyAdjdForBOMScrap(LotSize, Item."Scrap %") /
          UOMMgt.GetQtyPerUnitOfMeasure(Item, VersionMgt.GetBOMUnitOfMeasure(Item."Production BOM No.", VersionCode)));
    end;

    [Scope('OnPrem')]
    procedure SetMatriceDetail(value: Boolean)
    begin
        //ShowMatriceDetail := value;
        ShowABC := true;
    end;
}

