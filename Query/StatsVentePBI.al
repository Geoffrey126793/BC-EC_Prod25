query 50089 StatsVentePBI
{
    QueryType = Normal;

    elements
    {
        dataitem(Stat; "Statistic aggregate")
        {
            DataItemTableFilter =
                "Period Length" = const (Day),
                Type = const (1);

            column(Entry_No; "Entry No.")
            {
            }

            column(BasePeriode; "Period Length")
            {
            }

            column(Datefin; "Ending Date")
            {
            }

            column(TypeEcriture; "Entry Type")
            {
            }

            column(TypeStat; Type)
            {
            }

            column(No; "No.")
            {
            }

            column(Source_Type; "Source Type")
            {
            }

            column(Source_No; "Source No.")
            {
            }

            column(CodeMagasin; "Location Code")
            {
            }

            column(Inventory_Posting_Group; "Inventory Posting Group")
            {
            }

            column(Source_Posting_Group; "Source Posting Group")
            {
            }

            column(Gen_Bus_Posting_Group; "Gen. Bus. Posting Group")
            {
            }

            column(Gen_Prod_Posting_Group; "Gen. Prod. Posting Group")
            {
            }

            column(Salespers_Purch_Code; "Salespers./Purch. Code")
            {
            }

            column(Global_Dimension_1_Code; "Global Dimension 1 Code")
            {
            }

            column(Global_Dimension_2_Code; "Global Dimension 2 Code")
            {
            }

            column(Country_Code; "Country Code")
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

            column(YearStat; Year)
            {
            }

            column(Half_Year; "Half Year")
            {
            }

            column(Quarter; Quarter)
            {
            }

            column(MonthStat; Month)
            {
            }

            column(WeekStat; Week)
            {
            }

            column(Fiscal_year_closing_date; "Fiscal year closing date")
            {
            }

            column(Week_Day; "Week Day")
            {
            }

            column(Business_Unit_Code; "Business Unit Code")
            {
            }

            column(Consol_Debit_Acc; "Consol. Debit Acc.")
            {
            }

            column(Consol_Credit_Acc; "Consol. Credit Acc.")
            {
            }

            column(Job_No; "Job No.")
            {
            }

            column(Phase_Code; "Phase Code")
            {
            }

            column(Task_Code; "Task Code")
            {
            }

            column(Step_Code; "Step Code")
            {
            }

            column(Work_Type_Code; "Work Type Code")
            {
            }

            column(Reason_Code; "Reason Code")
            {
            }

            column(Job_Posting_Group; "Job Posting Group")
            {
            }

            column(Resource_Group_No; "Resource Group No.")
            {
            }

            column(Person_Responsible; "Person Responsible")
            {
            }

            column(Campaign_No; "Campaign No.")
            {
            }

            column(Produit; "Item criteria 1")
            {
            }

            column(Decoupe; "Item criteria 2")
            {
            }

            column(Epice; "Item criteria 3")
            {
            }

            column(Origine; "Item criteria 4")
            {
            }

            column(Emballage; "Item criteria 5")
            {
            }

            column(TypeProduit; "Item criteria 6")
            {
            }

            column(Etiquette; "Item criteria 7")
            {
            }

            column(CritereClient; "Item criteria 8")
            {
            }

            column(FicheTechnique; "Item criteria 9")
            {
            }

            column(Halal; "Item criteria 10")
            {
            }

            column(Groupement; "Customer criteria 1")
            {
            }

            column(Region; "Customer criteria 2")
            {
            }

            column(Departement; "Customer criteria 3")
            {
            }

            column(Groupe; "Customer criteria 4")
            {
            }

            column(Customer_Criteria_5; "Customer criteria 5")
            {
            }

            column(Customer_Criteria_6; "Customer criteria 6")
            {
            }

            column(Types; "Customer criteria 10")
            {
            }

            column(MontantDevise; "Free value 1")
            {
            }

            column(MontantDepart; "Free value 2")
            {
            }

            column(FraisFixes; "Free value 3")
            {
            }

            column(RFAEstime; "Free value 4")
            {
            }

            column(Montant3xNet; "Free value 5")
            {
            }

            column(MontantTarifExp; "Free value 6")
            {
            }

            column(MontantRistourne; "Free value 7")
            {
            }

            column(CoutReel; "Free value 8")
            {
            }

            column(CoutReelMP; "Free value 9")
            {
            }

            column(ABCCostMO; "Free value 10")
            {
            }

            column(Lines_Discount_Total; "Lines discount total")
            {
            }

            column(Document_Discount_Total; "Document discount total")
            {
            }

            column(Back_Discount_Total; "Back discount total")
            {
            }

            column(Commissions_Total; "Commissions total")
            {
            }

            column(Back_Disc_Commission_Rule_No; "Back disc./commission rule No.")
            {
            }

            column(Item_Charge_No; "Item Charge No.")
            {
            }

            column(Variant_Code; "Variant Code")
            {
            }

            column(Return_Reason_Code; "Return Reason Code")
            {
            }

            column(Manufacturer_Code; "Manufacturer Code")
            {
            }

            column(Item_Category_Code; "Item Category Code")
            {
            }

            column(Product_Group_Code; "Product Group Code")
            {
            }

            column(Service_Item_Group; "Service Item Group")
            {
            }

            column(CodeDevise; "Free field 1")
            {
            }

            column(MotifGratuit; "Free field 2")
            {
            }

            column(CodeVendeur; "Free field 3")
            {
            }

            column(Commercial; "Free field 4")
            {
            }

            column(GroupeClient; "Free field 5")
            {
            }

            column(GroupePrixClient; "Free field 6")
            {
            }

            column(DateCommande; "Free date 1")
            {
            }

            column(Codeclient; "Dimension 1 Value Code")
            {
            }

            column(Dimension_2_Value_Code; "Dimension 2 Value Code")
            {
            }

            // Utilisé pour filtrer dans Power BI sans ajouter
            // Ending Date une seconde fois dans les résultats.
            filter(DatefinFilter; "Ending Date")
            {
            }

            filter(QuantityFilter; Quantity)
            {
            }

            dataitem(CodeTable; Code)
            {
                DataItemLink =
                    Code = Stat."Free field 3";

                SQLJoinType = LeftOuterJoin;

                DataItemTableFilter =
                "Table No" = const (8001300),
                "Field No" = const (1004);

                column(Vendeur; Description)
                {
                }
            }
        }
    }

}