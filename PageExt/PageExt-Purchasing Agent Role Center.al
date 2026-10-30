pageextension 70240 pageextension70240 extends "Purchasing Agent Role Center"
{
    actions
    {

        addafter(Items)
        {

            action("Commandes achats non  visées")
            {
                Caption = 'Commandes achats non  visées';
                RunObject = Page "Liste Commande achat Non Visé";
            }
            action("<Action1000000002>")
            {
                Caption = '<Action1000000002>';
                RunObject = Page "Shipment Purchase Orders";
            }
            action(Transport)
            {
                Caption = 'Transport';
                RunObject = Page Transport;
            }
        }
    }
}

