pageextension 70034 pageextension70034 extends "Posted Sales Shipments"
{
    layout
    {
        modify("No.")
        {
            Width = 15;
        }

        modify("Ship-to Country/Region Code")
        {
            visible = true;
        }

        modify("Salesperson Code")
        {
            Visible = true;
        }

        modify("Posting Date")
        {
            visible = true;
        }

        addafter("Shipping Agent Code")
        {
            field("Territory Code"; "Territory Code")
            {
            }
            field("Nombre de palette"; "Nombre de palette")
            {
            }
            field("Nombre de colis"; "Nombre de colis")
            {
            }
            field("User ID"; "User ID")
            {
            }
            field("Your Reference"; "Your Reference")
            {
            }
            field("Logistic unit"; "Logistic unit")
            {
            }
            field("Nom recherche client"; "Nom recherche client")
            {
            }
            field("Order No."; "Order No.")
            {
            }
            field(TotalNetWeight; TotalNetWeight)
            {
                Caption = 'Poids Net';
            }
            field("Raison retard"; "Raison retard")
            {

            }
        }
        addafter("Shipping Agent Service Code")
        {
            field("Date livraison prévue"; "Date livraison prévue")
            {
            }
        }
        addafter("Package Tracking No.")
        {
            field("Order Date"; "Order Date")
            {
            }
            field(Montant; Montant)
            {
            }
            field("Quantité totale"; "Quantité totale")
            {
            }
        }
    }

    var
        TotalNetWeight: Decimal;
        UserMgt: Codeunit "User Setup Management";
        CuUtils: Codeunit "Absys - tools PJ";



    trigger OnAfterGetRecord()
    var
        SalesShptLine: Record "Sales Shipment Line";
    begin

        TotalNetWeight := 0;
        SalesShptLine.SetRange("Document No.", "No.");
        if SalesShptLine.Find('-') then
            repeat
                TotalNetWeight := TotalNetWeight + (SalesShptLine.Quantity * SalesShptLine."Net Weight");
            until SalesShptLine.Next = 0;
    end;


    trigger OnOpenPage()
    begin
        if UserMgt.GetRespCenter(0, '') <> '' then begin
            FilterGroup(2);
            SetFilter("Salesperson Code", UserMgt.GetRespCenter(0, ''));
            FilterGroup(0);
        end;

    end;
}

