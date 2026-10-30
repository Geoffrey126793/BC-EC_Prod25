page 50081 "Vente Planning Detail"
{
    Caption = 'Vente Planning Detail';
    PageType = Card;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            group("Général")
            {
                field("No."; "No.")
                {
                    Editable = false;
                }
                field(Description; Description)
                {
                    Editable = false;
                }
                group(Stock)
                {
                    field(Besoins; Besoin)
                    {
                        Editable = false;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            T37: Record "Sales Line";
                        begin
                            calcPlanning.getPlanningVentes(recItem, PeriodStart, PeriodEnd, true);
                        end;
                    }
                    field(Stockinit; Stock)
                    {
                        Caption = 'Stock initial';
                        Editable = false;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            T32: Record "Item Ledger Entry";
                        begin
                            calcPlanning.getPlanningStock(recItem, PeriodStart, PeriodEnd, true);
                        end;
                    }
                    field(Vendu; VentesConsommees)
                    {
                        Editable = false;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            T37: Record "Sales Line";
                        begin
                            calcPlanning.getPlanningVentesConsommees(recItem, PeriodStart, PeriodEnd, true);
                        end;
                    }
                    field(Achats; Commande)
                    {
                        Editable = false;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            T39: Record "Purchase Line";
                        begin
                            calcPlanning.getPlanningCommandesAchats(recItem, PeriodStart, PeriodEnd, true);
                        end;
                    }
                    field(Production; Produit)
                    {
                        Editable = false;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            T5406: Record "Prod. Order Line";
                        begin
                            calcPlanning.getPlanningProduction(recItem, PeriodStart, PeriodEnd, true);
                        end;
                    }
                    field("Stock théorique"; Total)
                    {
                        Editable = false;
                        Style = Unfavorable;
                        StyleExpr = PrevisionOK;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            PeriodStart := PeriodStart; // Dummy
                        end;
                    }
                }
                group("Prévisions")
                {
                    field(Minimum; Minimum)
                    {
                        Caption = 'Stock minimum';
                        Editable = false;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            PeriodStart := PeriodStart; // Dummy
                        end;
                    }
                    field(Moy3; Moy3)
                    {
                        Caption = 'Ventes moyennes mensuelle (3 mois)';
                        Editable = false;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            calcPlanning.getPlanningMoy3(recItem, true);
                        end;
                    }
                    field(Moy12; Moy12)
                    {
                        Caption = 'Ventes moyennes mensuelle (12 mois)';
                        Editable = false;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            calcPlanning.getPlanningMoy12(recItem, true);
                        end;
                    }
                    field(Prev; Prev)
                    {
                        Caption = 'Ventes mensuelles prévues';
                        Editable = false;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            PeriodStart := PeriodStart; // Dummy
                        end;
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        recItem.Get("No.");

        Stock := calcPlanning.getPlanningStock(recItem, PeriodStart, PeriodEnd, false);
        Besoin := calcPlanning.getPlanningVentes(recItem, PeriodStart, PeriodEnd, false);
        VentesConsommees := calcPlanning.getPlanningVentesConsommees(recItem, PeriodStart, PeriodEnd, false);
        Commande := calcPlanning.getPlanningCommandesAchats(recItem, PeriodStart, PeriodEnd, false);
        Produit := calcPlanning.getPlanningProduction(recItem, PeriodStart, PeriodEnd, false);
        Minimum := calcPlanning.getPlanningMinimum(recItem);
        Moy3 := calcPlanning.getPlanningMoy3(recItem, false);
        Moy12 := calcPlanning.getPlanningMoy12(recItem, false);
        Prev := calcPlanning.getPlanningPrev(recItem);

        Total := Stock + Commande + Produit - VentesConsommees - Minimum;
        PrevisionOK := (Besoin > Total);

        CurrPage.Caption('Etat du stock au ' + Format(PeriodEnd));
    end;

    var
        PeriodStart: Date;
        PeriodEnd: Date;
        recItem: Record Item;
        Besoin: Decimal;
        Stock: Decimal;
        VentesConsommees: Decimal;
        Commande: Decimal;
        Produit: Decimal;
        Total: Decimal;
        PrevisionOK: Boolean;
        calcPlanning: Codeunit "Stock EC";
        Minimum: Decimal;
        Moy3: Decimal;
        Moy12: Decimal;
        Prev: Decimal;

    [Scope('OnPrem')]
    procedure setDate(_StartDate: Date; _EndDate: Date)
    begin
        PeriodStart := _StartDate;
        PeriodEnd := _EndDate;
    end;
}

