pageextension 70186 pageextension70186 extends "Standard Cost Worksheet"
{
    actions
    {
        modify("Roll Up Standard Cost")
        {
            Visible = false;
        }
        addafter("Roll Up Standard Cost")
        {
            Action("Calculer coût std multi-niv")
            {
                trigger OnAction()
                var
                    RollUpStdCost: Report "Roll Up Standard Cost";
                    Item: Record Item;
                begin
                    Clear(RollUpStdCost);
                    //Item.SetRange("Costing Method",Item."Costing Method"::Standard);
                    RollUpStdCost.SetTableView(Item);
                    RollUpStdCost.SetStdCostWksh(Rec."Standard Cost Worksheet Name");
                    RollUpStdCost.RunModal;
                end;
            }
        }

        addafter("&Implement Standard Cost Changes")
        {
            action("Importer Excel standrad")
            {
                Caption = 'Importer Excel standrad';

                trigger OnAction()
                var
                    Cu50025: Codeunit Integration_Compta;
                begin

                    Cu50025.ImportCoutStd(Rec."Standard Cost Worksheet Name");
                end;
            }
            action("Importer Excel couts simulés")
            {
                Caption = 'Importer Excel couts simulés';

                trigger OnAction()
                var
                    Cu50025: Codeunit Integration_Compta;
                begin

                    Cu50025.ImportCoutSimulation();
                end;
            }
        }
    }
}

