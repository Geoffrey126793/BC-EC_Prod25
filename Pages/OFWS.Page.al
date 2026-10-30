page 50033 "OF WS"
{
    Caption = 'OF WS';
    PageType = List;
    SourceTable = "Prod. Order Line";
    SourceTableView = SORTING("Starting Date-Time");

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Prod. Order No."; "Prod. Order No.")
                {
                }
                field("Line No."; "Line No.")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Quantity (Base)"; "Quantity (Base)")
                {
                }
                field("Remaining Qty. (Base)"; "Remaining Qty. (Base)")
                {
                }
                field("Finished Qty. (Base)"; "Finished Qty. (Base)")
                {
                }
                field(ExpectedDLC; ExpectedDLC)
                {
                }
                field(ExpectedPoidsPalette; ExpectedPoidsPalette)
                {
                }
                field(ExpectedNbreBoites; ExpectedNbreBoites)
                {
                }
                field(TypePalette; TypePalette)
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field(Status; Status)
                {
                }
                field("Quantité utilisée"; "Quantité utilisée")
                {
                }
                field(FirstConso; FirstConso)
                {
                }
                field(FirstConsoDLC; FirstConsoDLC)
                {
                    Caption = 'FirstConsoDLC';
                }
                field("Due Date"; "Due Date")
                {
                }
                field(QtyAttente; QtyAttente)
                {
                }
                field("Programme injection"; BOMHeader."Programme injection")
                {
                }
                field("Programme malaxage"; BOMHeader."Programme malaxage")
                {
                }
                field("Programme malaxage extra"; BOMHeader."Programme malaxage extra")
                {
                }
                field(Melangeur; BOMHeader.Melangeur)
                {
                }
                field("Melangeur phase 2"; BOMHeader."Melangeur phase 2")
                {
                }
                field("T finale malaxage"; BOMHeader."T° finale malaxage")
                {
                }
                field(Broyeur; BOMHeader.Broyeur)
                {
                }
                field(CommentMalax; CommentMalax)
                {
                }
                field(TmpMateriel; TmpMateriel)
                {
                }
                field(TmpOperateur; TmpOperateur)
                {
                }
                field(Process; Process)
                {
                }
                field(Duree; ProdHeader."Temps total")
                {
                }
                field(PictureText; PictureText)
                {
                    Caption = 'PictureText';
                }
                field(Machine; ProdHeader.Machine)
                {
                }
                field(Emplacement; Emplacement)
                {
                }
                field("ProdHeader.""Activite1 Effectif"""; ProdHeader."Activite1 Effectif")
                {
                    Caption = 'Act1Effectif';
                }
                field("ProdHeader.""Activite1 Duree"""; ProdHeader."Activite1 Duree")
                {
                    Caption = 'Act1Duree';
                }
                field("ProdHeader.""Activite2 Effectif"""; ProdHeader."Activite2 Effectif")
                {
                    Caption = 'Act2Effectif';
                }
                field("ProdHeader.""Activite2 Duree"""; ProdHeader."Activite2 Duree")
                {
                    Caption = 'Act2Duree';
                }
                field("ProdHeader.""Setup Effectif"""; ProdHeader."Setup Effectif")
                {
                    Caption = 'SetupEffectif';
                }
                field("ProdHeader.""Setup Duree"""; ProdHeader."Setup Duree")
                {
                    Caption = 'SetupDuree';
                }
                field("ProdHeader.""Interruption Duree"""; ProdHeader."Interruption Duree")
                {
                    Caption = 'InterrDuree';
                }
                field("ProdHeader.""Interruption Raison"""; ProdHeader."Interruption Raison")
                {
                    Caption = 'InterrRaison';
                }
                field("ProdHeader.Confirmed"; ProdHeader.Confirmed)
                {
                    Caption = 'Confirmed';
                }
                field("Production BOM No."; "Production BOM No.")
                {
                }
                field("Production BOM Version Code"; "Production BOM Version Code")
                {
                }
                field(NbreMalax; ProdHeader."Nbre malaxage")
                {
                }
                field(Ligne_proprete; Ligne_proprete)
                {
                }
                field("Ligne_integrité"; Ligne_integrité)
                {
                }
                field(Termine; Termine)
                {
                }
                field(NoMalaxage; ProdHeader."No malaxage")
                {
                }
                field(NoOrdre; ProdHeader."No Ordre")
                {
                }
                field(Malaxeur; Malaxeur)
                {
                }
                field(Ligne_securite; Ligne_securite)
                {
                }
                field(Allergenes; Allergenes)
                {
                }
                field(PoidsCarton; Items."Poids carton")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        CommentLines: Record "Manufacturing Comment Line";
        TempBlob: Codeunit "Temp Blob";
        base64convert: Codeunit "Base64 Convert";
    begin
        CRLF[1] := 13;
        CRLF[2] := 10;
        PictureText := '';

        FirstConso := '';
        FirstConsoDLC := Today;

        if Items.Get("Item No.") then begin
            Items.CalcFields("Poids article", "Poids carton");
            ExpectedDLC := CalcDate(Items.FormuleDLC, Today);
            ExpectedPoidsPalette := Items.PoidsPalette;
            ExpectedNbreBoites := Items.BoitesPalette;
            Allergenes := Items."Niveau allergene";
            if Codes.Get(50018, 55005, Items.TypePalette) then
                TypePalette := Codes.Description;
            if "Location Code" = 'EC DORMA' then begin
                ILE.Reset;
                ILE.SetRange("Order Type", ILE."Order Type"::Production);
                ILE.SetRange("Order No.", Rec."Prod. Order No.");
                ILE.SetRange("Order Line No.", Rec."Line No.");
                ILE.SetRange("Entry Type", ILE."Entry Type"::Consumption);
                ILE.SetFilter("Item Category Code", '7-MP*');
                if ILE.FindFirst then begin
                    FirstConso := ILE."Item No.";
                    FirstConsoDLC := ILE."Warranty Date";
                end
                else begin
                    // ILE.SETFILTER("Item Category Code",'*');
                    // IF ILE.FINDFIRST THEN
                    //   FirstConso := ILE."Item No.";
                end;

                if FirstConso = '' then begin
                    ILE.Reset;
                    ILE.SetCurrentKey("Lot No.");
                    ILE.SetFilter("Lot No.", 'D-' + Rec."Prod. Order No." + '-*');
                    if ILE.FindSet then
                        repeat
                            if (ILE."Entry Type" = ILE."Entry Type"::Transfer) and (StrPos(ILE."Item Category Code", '7-MP') > 0) then begin
                                FirstConso := ILE."Item No.";
                                FirstConsoDLC := ILE."Warranty Date";
                            end;
                        until (ILE.Next = 0) or (FirstConso <> '');
                end;

                if FirstConso = '' then begin
                    // Component 7 en MP....
                    Components.Reset;
                    Components.SetRange(Status, Components.Status::Released);
                    Components.SetRange("Prod. Order No.", Rec."Prod. Order No.");
                    Components.SetRange("Prod. Order Line No.", Rec."Line No.");
                    Components.SetFilter("Item Category", '7-MP*|5-*');
                    if Components.FindFirst then
                        FirstConso := Components."Item No.";
                end;
                PictureText := '';

                //IF ItemFirst.GET(FirstConso) THEN
                //PictureText := Items."No." + FORMAT(Items.Picture.COUNT);


            end;
            Process := Items.Process;
            if Items.PoidsPalette > 0 then
                Process := Process + CRLF + 'Poids palettes : ' + Format(Items.PoidsPalette);
            if Items."Poids brut palette" > 0 then
                Process := Process + CRLF + 'Poids brut : ' + Format(Items."Poids brut palette") + ' Kg , hauteur : ' + Format(Items."Hauteur palette") + ' m';
            if Items.TypePalette <> '' then
                Process := Process + CRLF + 'Type palettes : ' + Items.TypePalette;
            if (StrPos(Items."No.", 'IQF') > 0) and (Items.Picture.Count > 0) then begin
                TenantMedia.Get(Items.Picture.Item(1));
                TenantMedia.CalcFields(Content);
                if (TenantMedia.Content.HasValue) then begin
                    Clear(PictureText);
                    Clear(PictureInStream);
                    TenantMedia.Content.CreateInStream(PictureInStream);
                    PictureText := base64convert.ToBase64(PictureInStream);
                end;
            end;

        end;

        QtyAttente := 0;
        ILE.Reset;
        ILE.SetCurrentKey("Lot No.");
        ILE.SetFilter("Lot No.", 'D-' + Rec."Prod. Order No." + '-*');
        if ILE.FindSet then
            repeat
                if (ILE."Entry Type" = ILE."Entry Type"::Transfer) and ((StrPos(ILE."Item Category Code", '7-MP') > 0) or (StrPos(ILE."Item Category Code", '5-PSF') > 0) or (StrPos(ILE."Item Category Code", '5-CRU') > 0)) then
                    QtyAttente += ILE."Remaining Quantity";
            until ILE.Next = 0;


        BOMHeader.Reset;
        BOMHeader.SetRange("No.", "Production BOM No.");
        if BOMHeader.FindFirst then begin

            CommentMalax := BOMHeader."Message malaxage" + CRLF;

            CommentLines.Reset;
            CommentLines.SetRange("Table Name", CommentLines."Table Name"::"Production BOM Header");
            CommentLines.SetRange("No.", BOMHeader."No.");
            if CommentLines.FindSet then
                repeat
                    CommentMalax += CommentLines.Comment + CRLF;
                until CommentLines.Next = 0;

        end;
        Effectif := 0;
        ProdL.Reset;
        ProdL.SetRange(Status, Rec.Status);
        ProdL.SetRange("Prod. Order No.", Rec."Prod. Order No.");
        if ProdL.FindFirst then begin
            ABC.Reset;
            ABC.SetRange("Production BOM No", ProdL."Production BOM No.");
            ABC.SetRange("BOM Version", ProdL."Production BOM Version Code");
            ABC.SetFilter(Activity, '<>S*');
            ABC.SetFilter(Type, '<>%1', ABC.Type::"Main d'oeuvre");
            if ABC.FindSet then
                repeat
                    Effectif += ABC."Nombre d'opérateurs";
                until ABC.Next = 0;
        end;
        if Effectif > 0 then
            Process += CRLF + Format(Effectif) + ' operateurs prévus';
        if ProdHeader.Get(Rec.Status, Rec."Prod. Order No.") then;
    end;

    var
        ExpectedDLC: Date;
        ExpectedPoidsPalette: Decimal;
        ExpectedNbreBoites: Integer;
        TypePalette: Text[50];
        Items: Record Item;
        Codes: Record "Code";
        FirstConso: Code[20];
        FirstConsoDLC: Date;
        ILE: Record "Item Ledger Entry";
        CuProd: Codeunit "Integration Tft and Prod";
        Components: Record "Prod. Order Component";
        QtyAttente: Decimal;
        BOMHeader: Record "Production BOM Header";
        CommentMalax: Text;
        CRLF: Text[3];
        Process: Text;
        ProdHeader: Record "Production Order";
        TenantMedia: Record "Tenant Media";
        PictureText: Text;
        PictureInStream: InStream;
        PictureOutStream: OutStream;
        Effectif: Decimal;
        ABC: Record "ABC - Parametres";
        ProdL: Record "Prod. Order Line";
        Allergenes: Integer;
}

