query 50001 "Statistics aggregate"
{

    elements
    {
        dataitem(Statistic_aggregate; "Statistic aggregate")
        {
            DataItemTableFilter = "Period Length" = CONST (Day), "Entry Type" = CONST ('Vente'), Type = CONST (Item), "Ending Date" = FILTER (20170101D ..);
            column(Date; "Ending Date")
            {
            }
            column(Article; "No.")
            {
            }
            column(Client; "Source No.")
            {
            }
            column(Magasin; "Location Code")
            {
            }
            column(Inventory_Posting_Group; "Inventory Posting Group")
            {
            }
            column(Gen_Bus_Posting_Group; "Gen. Bus. Posting Group")
            {
            }
            column(Gen_Prod_Posting_Group; "Gen. Prod. Posting Group")
            {
            }
            column(Vendeur; "Salespers./Purch. Code")
            {
            }
            column(Pays; "Country Code")
            {
            }
            column(Quantity; Quantity)
            {
            }
            column(Volume; Volume)
            {
            }
            column(Amount; Amount)
            {
            }
            column(Cost; Cost)
            {
            }
            column(Week; Week)
            {
            }
            column(MontantDevise; "Free value 1")
            {
            }
            column("MontantDépart"; "Free value 2")
            {
            }
            column(FraisFixes; "Free value 3")
            {
            }
            column("RFA_Estimé"; "Free value 4")
            {
            }
            column(Montan_3x_Net; "Free value 5")
            {
            }
            column(Code_Vendeur; "Free field 3")
            {
            }
            column(Groupe_client; "Free field 5")
            {
            }
            column(Cout_Reel; "Free value 8")
            {
            }
            column(Cout_Reel_MP; "Free value 9")
            {
            }
            column(Item_Category_Code; "Item Category Code")
            {
            }
            column(Entry_Type; "Entry Type")
            {
            }
            column(Type; Type)
            {
            }
        }
    }
}

