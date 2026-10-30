pageextension 70090 pageextension70090 extends "Item List"
{
    layout
    {
        modify("No.")
        {
            Width = 12;
            StyleExpr = StyleTypeProd;
        }
        modify("Cost is Adjusted")
        {
            Visible = ShowCout;
        }
        modify("Standard Cost")
        {
            Visible = ShowCout;
        }
        modify("Unit Cost")
        {
            Visible = ShowCout;
        }
        modify("Last Direct Cost")
        {
            Visible = ShowCout;
        }
        modify("Unit Price")
        {
            Visible = ShowCout;
        }
        modify("Indirect Cost %")
        {
            Visible = ShowCout;
        }
        modify(Blocked)
        {
            Visible = true;
        }
        modify(Control1901314507)
        {
            Visible = showCout;
        }
        addafter("Flushing Method")
        {
            field("Qty. on Purch. Order"; "Qty. on Purch. Order")
            {
            }
            field("Qty. on Sales Order"; "Qty. on Sales Order")
            {
            }
            field("Qty. on Prod. Order"; "Qty. on Prod. Order")
            {
            }
            field("Qty. on Component Lines"; "Qty. on Component Lines")
            {
            }
            field("Gross Weight"; "Gross Weight")
            {
            }
            field("Net Weight"; "Net Weight")
            {
            }
            field("Default Location Code"; "Default Location Code")
            {
            }
        }
        addafter("Item Tracking Code")
        {
            field("Net Change"; "Net Change")
            {
            }
            field("Criteria 1"; "Criteria 1")
            {
            }
            field("Criteria 2"; "Criteria 2")
            {
            }
            field("Criteria 3"; "Criteria 3")
            {
            }
            field("Criteria 4"; "Criteria 4")
            {
            }
            field("Criteria 5"; "Criteria 5")
            {
            }
            field("Criteria 6"; "Criteria 6")
            {
            }
            field("Criteria 7"; "Criteria 7")
            {
            }
            field("Criteria 8"; "Criteria 8")
            {
            }
            field("Criteria 9"; "Criteria 9")
            {
            }
            field("Sales (Qty.)"; "Sales (Qty.)")
            {
            }
            field("Sales (LCY)"; "Sales (LCY)")
            {
            }
            field("Purchases (Qty.)"; "Purchases (Qty.)")
            {
            }
            field("Purchases (LCY)"; "Purchases (LCY)")
            {
                Visible = ShowCout;
            }
            field("Criteria 10"; "Criteria 10")
            {
            }
            field("Criteria 11"; "Criteria 11")
            {
                Visible = ShowCrit11;
            }
            field("Criteria 12"; "Criteria 12")
            {
            }
            field(TypePalette; TypePalette)
            {
            }
            field("Px de revient matiÞre std"; "Px de revient matiÞre std")
            {
            }
            field("Px de revient sans 22A"; "Px de revient sans 22A")
            {
                Visible = ShowCout;
            }
            field("Px de revient total"; "Px de revient total")
            {
                Visible = ShowCout;
            }
            field("Quantié consommée"; "Quantié consommée")
            {
            }
            field("Cout ABC"; "Cout ABC")
            {
                Visible = ShowCout;
            }
            field("Cout simulation"; "Cout simulation")
            {
                Visible = ShowCout;
            }
            field("Px de revient matiére simulé"; "Px de revient matiére simulé")
            {
                Visible = ShowCout;
            }
            field("Comment blocage lots produits"; "Comment blocage lots produits")
            {
            }
            field("Reorder Quantity"; "Reorder Quantity")
            {
            }
            field("Reorder Point"; "Reorder Point")
            {
            }
            field("Option production"; "Option production")
            {
            }
            field("Criteria 1 Desc"; "Criteria 1 Desc")
            {
            }
            field("Criteria 2 Desc"; "Criteria 2 Desc")
            {
            }
            field("Criteria 3 Desc"; "Criteria 3 Desc")
            {
            }
            field("Criteria 4 Desc"; "Criteria 4 Desc")
            {
            }
            field("Criteria 5 Desc"; "Criteria 5 Desc")
            {
            }
            field("Criteria 7 Desc"; "Criteria 7 Desc")
            {
            }
            field("Criteria 10 Desc"; "Criteria 10 Desc")
            {
            }
            field("Criteria 13 Desc"; "Criteria 13 Desc")
            {
            }
            field("Criteria 14 Desc"; "Criteria 14 Desc")
            {
            }
            field("Criteria 15 Desc"; "Criteria 15 Desc")
            {
            }
            field("Criteria 16 Desc"; "Criteria 16 Desc")
            {
            }
            field("Criteria 17 Desc"; "Criteria 17 Desc")
            {
            }
            field("Type de consommation"; "Type de consommation")
            {
            }
            field("Prix vente CT"; "Prix vente CT")
            {
            }
            field("Prix vente LT"; "Prix vente LT")
            {
            }
            field("Stock max"; "Stock max")
            {
            }
            field("Blanket Order Qty"; "Blanket Order Qty")
            {
            }
            field(PoidsPalette; PoidsPalette)
            {
            }
            field(BoitesPalette; BoitesPalette)
            {
            }
            field("Nbre cartons par etage"; "Nbre cartons par etage")
            {
            }
            field("Nbre etages par palette"; "Nbre etages par palette")
            {
            }
            field("Conso 5 (15J)"; Interm15D)
            {
            }
            field(Cadence; Cadence)
            {

            }
        }
        addafter(Control1906840407)
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
            action("<Action1000000003>")
            {
                Caption = '<Action1000000003>';
                RunObject = Page "Logistic Unit / Item";
                RunPageLink = "Item no" = FIELD("No.");
            }
        }
    }

    var
        AB6Tools: Codeunit "Absys - tools PJ";
        ShowCout: Boolean;
        ShowCrit11: Boolean;
        Interm15D: Decimal;


    var
        StyleTypeProd: Text;


    trigger OnAfterGetRecord()
    var
        CalcStock: Codeunit "Stock EC";
    begin
        StyleTypeProd := '';
        if "Option production" = "Option production"::"Stock standard" then
            StyleTypeProd := 'Favorable';
        if "Option production" = "Option production"::"Stock client" then
            StyleTypeProd := 'StrongAccent';
        Interm15D := CalcStock.getConsoMoy15D(rec);
    end;


    trigger OnOpenPage()
    begin
        ShowCout := AB6Tools.GetRole('COUT');
        ShowCrit11 := AB6Tools.GetRole('ART-SUBST-MOD');
    end;
}

