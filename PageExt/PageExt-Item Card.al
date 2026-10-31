pageextension 70088 pageextension70088 extends "Item Card"
{
    layout
    {
        modify("No.")
        {
            StyleExpr = StyleTypeProd;
        }
        modify("Standard Cost")
        {
            Visible = ShowCout;
        }
        modify("Unit Cost")
        {
            Visible = ShowCout;
        }
        modify("Indirect Cost %")
        {
            Visible = ShowCout;
        }
        modify("Last Direct Cost")
        {
            Visible = ShowCout;
        }
        modify("Sales Blocked")
        {
            Visible = false;
        }

        modify("Maximum Inventory")
        {
            Visible = false;
        }
        modify("Reordering Policy")
        {
            Visible = false;
        }
        modify("Reorder Point")
        {
            Visible = false;
        }
        modify("Reorder Quantity")
        {
            Visible = false;
        }
        addafter("Common Item No.")
        {
            field("EAN13 Code"; "EAN13 Code")
            {
                Editable = false;
            }
            field("CB carton"; "CB carton")
            {
                Editable = false;
            }
            field("CB Souche"; "CB Souche")
            {
                Importance = Additional;
            }
        }
        addafter("Standard Cost")
        {
            field("Rolled-up Material Cost"; "Rolled-up Material Cost")
            {
                Visible = ShowCout;
            }
        }
        addafter("Unit Price")
        {
            field("Prix vente CT"; "Prix vente CT")
            {
            }
            field("Prix vente LT"; "Prix vente LT")
            {
            }
        }
        addafter("Sales Unit of Measure")
        {
            group(Simulation)
            {
                Caption = 'Simulation';
                field("Cout simulation"; "Cout simulation")
                {
                    Visible = ShowCout;
                }
                field("Px de revient matiére simulé"; "Px de revient matiére simulé")
                {
                    Visible = ShowCout;
                }
            }
        }
        addafter("Replenishment System")
        {
            field("Type de production"; "Type de production")
            {
            }
            field("Reorder QuantityEC"; "Reorder Quantity")
            {
            }
            field("Stock max"; "Stock max")
            {
            }
            field("Reorder PointEC"; "Reorder Point")
            {
            }
            field("Reordering PolicyEC"; "Reordering Policy")
            {
            }
            field("Tolerance Receipt"; "Tolerance Receipt")
            {
            }
        }
        addafter("Scrap %")
        {
            field("Raison blocage"; "Raison blocage")
            {
            }
            field("Comment blocage lots produits"; "Comment blocage lots produits")
            {
            }
        }
        addfirst(Planning)
        {
            field(PrevisionVenteMensuelle; PrevisionVenteMensuelle)
            {
            }
        }
        addafter("Identifier Code")
        {
            field("Default Location Code"; "Default Location Code")
            {
            }
        }
        addafter(Planning)
        {
            group("Critères")
            {
                Caption = 'Critères';
                field("Criteria 1"; "Criteria 1")
                {
                }
                field("Criteria 1 Desc"; "Criteria 1 Desc")
                {
                }
                field("Criteria 2"; "Criteria 2")
                {
                }
                field("Criteria 2 Desc"; "Criteria 2 Desc")
                {
                }
                field("Criteria 3"; "Criteria 3")
                {
                }
                field("Criteria 3 Desc"; "Criteria 3 Desc")
                {
                }
                field("Criteria 4"; "Criteria 4")
                {
                }
                field("Criteria 4 Desc"; "Criteria 4 Desc")
                {
                }
                field("Criteria 5"; "Criteria 5")
                {
                }
                field("Criteria 5 Desc"; "Criteria 5 Desc")
                {
                }
                field("Criteria 7"; "Criteria 7")
                {
                }
                field("Criteria 7 Desc"; "Criteria 7 Desc")
                {
                }
                field("Criteria 8"; "Criteria 8")
                {
                }
                field("Criteria 9"; "Criteria 9")
                {
                }
                field("Criteria 10"; "Criteria 10")
                {
                }
                field("Criteria 10 Desc"; "Criteria 10 Desc")
                {
                }
                field("Criteria 12"; "Criteria 12")
                {
                    Caption = 'Type de film';
                }
                field("Criteria 13"; "Criteria 13")
                {
                }
                field("Criteria 13 Desc"; "Criteria 13 Desc")
                {
                }
                field("Criteria 14"; "Criteria 14")
                {
                }
                field("Criteria 14 Desc"; "Criteria 14 Desc")
                {
                }
                field("Criteria 15"; "Criteria 15")
                {
                }
                field("Criteria 15 Desc"; "Criteria 15 Desc")
                {
                }
                field("Criteria 16"; "Criteria 16")
                {
                }
                field("Criteria 16 Desc"; "Criteria 16 Desc")
                {
                }
                field("Criteria 17"; "Criteria 17")
                {
                }
                field("Criteria 17 Desc"; "Criteria 17 Desc")
                {
                }
                field(TypePalette; TypePalette)
                {
                }
                field(PoidsPalette; PoidsPalette)
                {
                }
                field("Nbre cartons par etage"; "Nbre cartons par etage")
                {

                }
                field("Nbre etages par palette"; "Nbre etages par palette")
                {

                }
                field("Poids brut palette"; "Poids brut palette")
                {

                }
                field("Hauteur palette"; "Hauteur palette")
                {

                }
                field(BoitesPalette; BoitesPalette)
                {
                }
                field(FormuleDLC; FormuleDLC)
                {
                }
                field("Niveau allergene"; "Niveau allergene")
                {
                }
                field(Process; Process)
                {
                }
                field(Cadence; Cadence)
                {
                }
                field("Option production"; "Option production")
                {
                }
                field("Machine sur écran"; "Machine sur écran")
                {
                }
                field(Emplacement; Emplacement)
                {
                }
                field(Pasteurisation; Pasteurisation)
                {
                }
                field("Quantité par sac"; "Quantité par sac")
                {
                }
                field(THT; THT)
                {
                }
                field("Type de consommation"; "Type de consommation")
                {
                }
                field("% supplémentaire à préparer"; "% supplémentaire à préparer")
                {
                }
                field("Stop nomenclature VP"; "Stop nomenclature VP")
                {
                }
                field("Atelier MO"; "Atelier MO")
                {
                }
                field("Anticipation production"; "Anticipation production")
                {

                }
                field("Preparation ARGML"; "Preparation ARGML")
                {

                }
                field("A suivre"; "A suivre")
                {

                }
                field("Kg par heartbeat"; "Kg par heartbeat")
                {

                }
                field("Piece par heartbeat"; "Piece par heartbeat")
                {

                }
                field("Machines pour VP"; "Machines pour VP")
                {

                }
                field("Delai production"; "Delai production")
                {

                }
                field("Quantité minimum vente"; "Quantité minimum vente")
                {

                }
                field("Categorie evaluation stock"; "Categorie evaluation stock")
                {

                }


            }
        }
        addfirst(FactBoxes)
        {
            part(Stocks; "Item EC Factbox")
            {
                Caption = 'Stocks';
                SubPageLink = "No." = FIELD("No.");
            }
        }
    }
    actions
    {

        addafter(Identifiers)
        {
            separator(Action1000000002)
            {
            }
            action("Unité logistique")
            {
                Caption = 'Unité logistique';
                RunObject = Page "Logistic Unit / Item";
                RunPageLink = "Item no" = FIELD("No.");
            }
        }
        addafter("Co&mments")
        {
            action(Reprint)
            {
                Caption = 'Réimpirmer étiquette';

                trigger OnAction()
                var
                    CuScan: Codeunit "WS Scan";
                begin
                    if Rec."Item Category Code" = '' then
                        CuScan.ReprintLot(Rec."No.", '')
                    else
                        Message('Veuillez réimprimer depuis les lots');
                end;
            }
        }
        addafter(ApplyTemplate)
        {
            action("Supprimer les réservations")
            {

                trigger OnAction()
                var
                    T337: Record "Reservation Entry";
                begin
                    if (CopyStr("No.", 1, 1) = '7') then begin
                        T337.Reset;
                        T337.SetRange("Item No.", "No.");
                        if T337.Count > 100 then
                            Error('Trop de réservations');
                        T337.DeleteAll();
                    end;
                end;
            }
        }
        addafter("Skilled Resources")
        {
            action("<Action109>")
            {
                Caption = '&Picture';
                RunObject = Page "Item Drapeau";
                RunPageLink = "No." = FIELD("No."),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"),
                              "Location Filter" = FIELD("Location Filter"),
                              "Drop Shipment Filter" = FIELD("Drop Shipment Filter"),
                              "Variant Filter" = FIELD("Variant Filter");
            }
        }
        modify(CopyItem_Promoted)
        {
            Visible = false;
        }
        modify(AdjustInventory_Promoted)
        {
            Visible = false;
        }
        modify("&Create Stockkeeping Unit_Promoted")
        {
            Visible = false;
        }
        modify(ApplyTemplate_Promoted)
        {
            Visible = false;
        }
        addafter(CopyItem_Promoted)
        {
            actionref("Production BOM_PromotedEC"; "Production BOM")
            { }
            actionref("Unit of Measure_PromotedEC"; "Unit of Measure")
            { }
        }
    }

    var
        ShowCout: Boolean;
        AB6Tools: Codeunit "Absys - tools PJ";
        StyleTypeProd: Text;


    trigger OnAfterGetCurrRecord()
    begin
        StyleTypeProd := '';
        if "Option production" = "Option production"::"Stock standard" then
            StyleTypeProd := 'Favorable';
        if "Option production" = "Option production"::"Stock client" then
            StyleTypeProd := 'StrongAccent';
    end;


    trigger OnOpenPage()
    begin
        ShowCout := AB6Tools.GetRole('COUT');
    end;
}

