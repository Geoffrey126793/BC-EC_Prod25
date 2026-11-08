pageextension 70241 pageextension70241 extends "Shop Supervisor Role Center"
{
    layout
    {
        addfirst(rolecenter)
        {
            part(AllEC; AllCueEC)
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        modify("Capacity Tas&k List")
        {
            Visible = false;
        }
        modify("Subcontractor - Dis&patch List")
        {
            Visible = false;
        }
        modify("Production Order Ca&lculation")
        {
            Visible = false;
        }
        modify("S&tatus")
        {
            Visible = false;
        }
        modify("Simulated Production Orders")
        {
            Visible = false;
        }
        modify("Planned Production Orders")
        {
            Visible = false;
        }
        modify("Firm Planned Production Orders")
        {
            Visible = false;
        }
        modify(Routings)
        {
            Visible = false;
        }
        modify("Registered Absence")
        {
            Visible = false;
        }
        modify("Stockkeeping Units")
        {
            Visible = false;
        }
        modify("Purchase Orders")
        {
            Visible = false;
        }
        modify("Inventory Put-aways")
        {
            Visible = false;
        }
        modify("Inventory Picks")
        {
            Visible = false;
        }
        modify(RequisitionWorksheets)
        {
            Visible = false;
        }
        modify(SubcontractingWorksheets)
        {
            Visible = false;
        }
        modify(CapacityJournals)
        {
            Visible = false;
        }
        modify(RecurringCapacityJournals)
        {
            Visible = false;
        }
        modify("&Capacity Journal")
        {
            Visible = false;
        }
        modify("Update &Unit Cost")
        {
            Visible = false;
        }
        modify("&Manufacturing Setup")
        {
            Visible = false;
        }
        modify("Work Centers")
        {
            Visible = false;
        }
        modify("Machine Centers")
        {
            Visible = false;
        }
        addafter("Sales Orders")
        {
            action("Commandes non visées")
            {
                Caption = 'Commandes non visées';
                RunObject = Page "Liste Commande Non Visé";
            }
        }
        addafter("Transfer Orders")
        {
            action("Expéditions")
            {
                Caption = 'Expéditions';
                RunObject = Page "Posted Sales Shipments";
            }
            action(Lots)
            {
                Caption = 'Lots';
                RunObject = Page "Lot No. Information List";
            }
            action(Prévisions)
            {
                Caption = 'Prévision ventes';
                RunObject = Page "Prévisions ventes";
            }
        }
        addafter("Navi&gate")
        {
            action("Liste OF")
            {
                RunObject = Report "Liste des OF";
            }
            action("Stock intermédiaire")
            {
                RunObject = Page "Production Planning Item";
            }
            action("Nomenclature multi-niveau")
            {
                RunObject = Report "Quantity Explosion of BOM";
            }
        }
    }
}

