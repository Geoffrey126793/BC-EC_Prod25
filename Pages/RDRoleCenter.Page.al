page 50045 "RD Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                ShowCaption = false;
                systempart(Control1901420308; Outlook)
                {
                }
            }
            group(Control1900724708)
            {
                ShowCaption = false;
                systempart(Control1901377608; MyNotes)
                {
                }
            }
        }
    }

    actions
    {
        area(embedding)
        {
            action(Customers)
            {
                Caption = 'Customers';
                RunObject = Page "Customer List";
            }
            action("Sales Orders")
            {
                Caption = 'Sales Orders';
                RunObject = Page "Sales Order List";
                RunPageView = WHERE ("Location Code" = CONST ('RD'),
                                    "Last Shipping No." = FILTER (''));
            }
            action(Articles)
            {
                Caption = 'Articles';
                RunObject = Page "Item List";
            }
            action("Expéditions")
            {
                Caption = 'Expéditions';
                RunObject = Page "Posted Sales Shipments";
                RunPageView = WHERE ("Location Code" = CONST ('RD'));
            }
            action("<Action1000000001>")
            {
                Caption = '<Action1000000001>';
                RunObject = Page "Transfer Orders";
            }
            action("<Action1000000002>")
            {
                Caption = '<Action1000000002>';
                RunObject = Page "Lignes RD";
            }
            action("Nomenclature de production")
            {
                Caption = 'Nomenclature de production';
                RunObject = Page "Production BOM List";
            }
        }
        area(processing)
        {
            action("Feuille article")
            {
                RunObject = Page "Item Journal";
            }
            action("OF. Lancés")
            {
                RunObject = Page "Released Production Orders";
            }
        }
        area(reporting)
        {
            action("Nomenclatures multi-Niveaux")
            {
                Caption = 'Nomenclatures multi-Niveaux';
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Quantity Explosion of BOM";
            }
            action("<Action1000000004>")
            {
                Caption = '<Action1000000004>';
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Where-Used (Top Level)";
            }
        }
    }
}

