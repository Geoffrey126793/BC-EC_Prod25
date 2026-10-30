report 50068 "Fiche palette production"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/Fichepaletteproduction.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Pallet; Pallet)
        {
            RequestFilterFields = "SSCC No.";
            column(Pallet__SSCC_No__; "SSCC No.")
            {
            }
            column(Pallet__Creation_Date_; "Creation Date")
            {
            }
            column(Pallet__Item_No__; "Item No.")
            {
            }
            column(Pallet__Item_Description_; "Item Description")
            {
            }
            column(Pallet__Lot_No__; "Lot No.")
            {
            }
            column(Pallet_DLC; DLC)
            {
            }
            column(Pallet__Nbre_bacs_reception_; "Nbre bacs reception")
            {
            }
            column(Pallet__Quantite_reception_; "Quantite reception")
            {
            }
            column(TxtFr; TxtFr)
            {
            }
            column(TxtEn; TxtEn)
            {
            }
            column(recItem_Drapeau; recItem.Drapeau)
            {
            }
            column(GS1_Txt; GS1_Txt)
            {
            }
            column(GS1_128; GS1_128)
            {
            }
            column(recItem_Drapeau_HASVALUE; recItem.Drapeau.HasValue)
            {
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 .. 2));
                column(Integer_Number; Number)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                CalcFields("Current Quantity");
                TxtFr := 'Surgelé. A conserver à -18°C. après décongélation, à conserver entre 0°C et +4°C et utiliser dans les 2 jours.';
                TxtEn := 'Frozen. Store at -18°C. After thawing, keep between 0°C and +4°C and use within 2 days.';

                recItem.Get("Item No.");
                recItem.CalcFields(Drapeau);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        TxtAddressCongel: Label 'Rue de l''ancienne Potence 01 -7522 Marquain - Belgium';
        TxtFr: Text[250];
        TxtEn: Text[250];
        recItem: Record Item;
        GS1: Codeunit "GS1 Send";
        Utils: Codeunit Utils;
        GS1_Txt: Text;
        GS1_128: Text;
}

