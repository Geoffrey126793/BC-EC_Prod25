page 50038 "WS Prod Header"
{
    Caption = 'WS Prod Header';
    PageType = List;
    SourceTable = "Production Order";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field("Source Type"; "Source Type")
                {
                }
                field("Source No."; "Source No.")
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Ending Date"; "Ending Date")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("No. Series"; "No. Series")
                {
                }
                field(Status; Status)
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Due Date"; "Due Date")
                {
                }
                field(IDVP; IDVP)
                {
                }
                field(Bookmark; Bookmark)
                {
                }
                field("Starting Date-Time"; "Starting Date-Time")
                {
                }
                field("Ending Date-Time"; "Ending Date-Time")
                {
                }
                field("Quantite total composants"; "Quantite total composants")
                {
                }
                field("Quantité MP"; "Quantité MP")
                {
                }
                field(Malaxage; Malaxage)
                {
                }
                field(Injection; Injection)
                {
                }
                field("Qty max malaxage"; "Qty Max malaxage")
                {
                }
                field(Machine; Machine)
                {
                }
                field("Commentaires VP"; "Commentaires VP")
                {
                }
                field("Recyclage VP"; "Recyclage VP")
                {
                }
                field("Production BOM Version"; "Production BOM Version")
                {
                }
                field(StopNomenclature; StopNomenclature)
                {
                }
                field(MP; MP)
                {
                }
                field(Effectif; Effectif)
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
        Items: Record Item;
        tmp: Decimal;
        BomHMLX: Record "Production BOM Header";
        BomL: Record "Production BOM Line";
        ABC: Record "ABC - Parametres";
        ProdL: Record "Prod. Order Line";
    begin
        //CLEAR(RecRef);
        //RecRef.OPEN(DATABASE::"Production Order");
        //RecRef.SETPOSITION(GETPOSITION);
        //Bookmark := FORMAT(RecRef.RECORDID,0,10);  //10 = base64 encoding

        Bookmark := GetUrl(CLIENTTYPE::Web, CompanyName, OBJECTTYPE::Page, 99000831, Rec);

        if Items.Get("Source No.") then begin
            if BomH.Get(Items."Production BOM No.") then begin
                MP := CuProd.GetAllMP(BomH, '', Rec.Quantity);
                Malaxage := BomH."Programme malaxage";
                Injection := BomH."Programme injection";
                BomL.Reset;
                BomL.SetRange("Production BOM No.", BomH."No.");
                BomL.SetFilter("No.", '5-MLX*');
                if BomL.FindFirst then begin
                    if Items.Get(BomL."No.") then begin
                        if BomH.Get(Items."Production BOM No.") then
                            tmp := CuProd.GetTotalMPPerUnit(BomH, '');
                        if tmp <> 0 then
                            "Qty Max malaxage" := BomH."Quantite par malaxage" / tmp
                        else
                            "Qty Max malaxage" := BomH."Quantite par malaxage";
                    end;
                end
                else begin //Encore utile?
                    tmp := CuProd.GetTotalMPPerUnit(BomH, '');
                    if tmp <> 0 then
                        "Qty Max malaxage" := BomH."Quantite par malaxage" / tmp
                    else
                        "Qty Max malaxage" := BomH."Quantite par malaxage";
                end;
            end;
            StopNomenclature := Items."Stop nomenclature VP";
        end;
        ProdL.Reset;
        ProdL.SetRange(Status, Status);
        ProdL.SetRange("Prod. Order No.", "No.");
        Effectif := 0;
        if ProdL.FindFirst then begin
            ABC.Reset;
            ABC.SetRange("Production BOM No", ProdL."Production BOM No.");
            ABC.SetRange("BOM Version", ProdL."Production BOM Version Code");
            ABC.SetFilter(Activity, '<>S*');
            ABC.SetFilter(Type, '<>%1', ABC.Type::"Main d'oeuvre");
            ABC.SetRange("Imputation Ressource", ABC."Imputation Ressource"::Direct);
            if ABC.FindSet then
                repeat
                    Effectif += ABC."Nombre d'opérateurs";
                until ABC.Next = 0;


        end;
    end;

    var
        Bookmark: Text[250];
        RecRef: RecordRef;
        BomH: Record "Production BOM Header";
        Malaxage: Code[40];
        Injection: Code[40];
        "Qty Max malaxage": Decimal;
        CuProd: Codeunit "Integration Tft and Prod";
        StopNomenclature: Boolean;
        MP: Text;
        Effectif: Decimal;
}

