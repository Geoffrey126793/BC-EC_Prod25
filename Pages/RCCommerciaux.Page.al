page 50049 "RC Commerciaux"
{
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            part(Control100000000; "RC Commerciaux 1")
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Prévisions")
            {
                RunObject = Page "Prévisions ventes";
            }
            action("Commandes de vente")
            {
                RunObject = Page "Sales Order List";
            }
            action(Clients)
            {
                RunObject = Page "Customer List";
                RunPageMode = View;
            }
            action("Expéditions")
            {
                RunObject = Page "Posted Sales Shipments";
            }
            action("Tarifs Transport")
            {
                RunObject = Page Transport;
            }
            action(Articles)
            {
                RunObject = Page "Item List";
            }
            action("Lignes factures")
            {
                RunObject = Page "Posted Sales Invoice Lines";
            }
        }
    }
}

