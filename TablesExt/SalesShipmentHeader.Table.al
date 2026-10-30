tableextension 50062 SalesShipmentHeaderEC extends "Sales Shipment Header"
{
    fields
    {
        field(50003; "Order type"; Option)
        {
            Caption = 'Order type';
            Description = 'LOG-004';
            OptionCaption = ' ,Frais,Surgelé';
            OptionMembers = " ",Frais,"Surgelé";
        }
        field(50004; "Logistic unit"; Code[20])
        {
            Caption = 'Logistic unit';
            Description = 'LOG-004';
        }
        field(50005; "Unit price/Palette"; Decimal)
        {
            Caption = 'Unit price/Palette';
            Description = 'LOG-004';
        }
        field(50006; "Territory Code"; Code[10])
        {
            Caption = 'Territory Code';
            Description = 'LOG-004';
            TableRelation = Territory;
        }
        field(50012; "Transport Purchase Order"; Code[20])
        {
            Caption = 'Transport Purchase Order';
            Description = 'AB60408.V14';
            Editable = false;
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = CONST(Order),
                                                           "No." = FIELD("Transport Purchase Order"));
        }
        field(50013; "Transport Purchase Invoice"; Code[20])
        {
            Caption = 'Transport Purchase Order';
            Description = 'AB60408.V14';
            Editable = false;
            TableRelation = "Purch. Inv. Header"."No." WHERE("No." = FIELD("Transport Purchase Invoice"));
        }
        field(50020; "Date livraison prévue"; Date)
        {
            Caption = 'Date livraison prévue';
        }
        field(50022; "Horaires de livraison"; Text[80])
        {
            Caption = 'Horaires de livraison';
        }
        field(50024; "Nom recherche client"; Code[100])
        {
            CalcFormula = Lookup(Customer."Search Name" WHERE("No." = FIELD("Sell-to Customer No.")));
            Caption = 'Nom recherche client';
            FieldClass = FlowField;
        }
        field(50026; "Délai de livraison"; Text[80])
        {
            Caption = 'Délai de livraison';
        }
        field(50027; "Camion parti"; Boolean)
        {
            Caption = 'Camion parti';
        }
        field(50030; "Commentaire CMR"; Text[80])
        {
            Caption = 'Commentaire CMR';
        }
        field(50031; "Ref Envoi"; Code[30])
        {
            Caption = 'Ref Envoi';
        }
        field(50036; "Lié avec commande n°"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50038; "Debut blocage"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50039; "Fin blocage"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50040; "Jours blocage"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50041; "Raison retard"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Code.Code WHERE("Table No" = CONST(36),
                                             "Field No" = CONST(50041));
        }
        field(50042; "Date confirmee initiale"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50043; ExtranetID; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50046; "Cout echantillon - Transport"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50047; "Cout echantillon - Produits"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51000; "Nombre de palette"; Integer)
        {
            Caption = 'Nombre de palette';
            Description = 'DOC';
        }
        field(51001; "Nombre de colis"; Integer)
        {
            Caption = 'Nombre de colis';
            Description = 'DOC';
        }
        field(51002; Montant; Decimal)
        {
            CalcFormula = Sum("Sales Shipment Line"."Item Charge Base Amount" WHERE("Document No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(52000; "Quantité totale"; Decimal)
        {
            CalcFormula = Sum("Sales Shipment Line"."Quantity (Base)" WHERE("Sell-to Customer No." = FIELD("Sell-to Customer No."),
                                                                             "Document No." = FIELD("No."),
                                                                             Type = CONST(Item)));
            FieldClass = FlowField;
        }
    }
}

