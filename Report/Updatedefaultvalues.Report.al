report 8001311 "Update default values"
{
    // //STATSEXPLORER STATSEXPLORER 01/08/00 Reprise des valeurs par défaut de l'ensemble de la table des cumuls

    Caption = 'Update default values';
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem("Statistic aggregate"; "Statistic aggregate")
        {
            DataItemTableView = SORTING ("Entry No.");
            RequestFilterFields = "Entry No.";

            trigger OnAfterGetRecord()
            begin
                RepriseValeurs.Run("Statistic aggregate");
                CptrLig := CptrLig + 1;
                Fenetre.Update(1, Round(CptrLig / NbreEnreg * 10000, 1));
            end;

            trigger OnPreDataItem()
            begin
                Fenetre.Open(Fenetre1);
                NbreEnreg := Count;
            end;
        }
    }

    requestpage
    {
        Caption = 'Update default values';

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
        RepriseValeurs: Codeunit "Aggr., Update default values";
        Fenetre1: Label 'Update default values @1@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
        Fenetre: Dialog;
        NbreEnreg: Integer;
        CptrLig: Integer;
}

