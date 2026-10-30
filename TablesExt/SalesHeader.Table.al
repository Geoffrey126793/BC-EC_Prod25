tableextension 50055 SalesHeaderEC extends "Sales Header"
{
    fields
    {
        field(50000; "Status Visa"; Option)
        {
            Caption = 'Status Visa';
            Description = 'ADV-007';
            OptionCaption = 'On standby visa, Visa authorized';
            OptionMembers = "On standby visa ","Visa authorized";

            trigger OnValidate()
            var
                Utils: Codeunit Utils;
            begin
                //--> ADV-007 ABSYS GN 20061025
                if ("Document Type" = "Document Type"::Order) and Utils.IsInGroup('VISAV') then begin
                    if ("Status Visa" = "Status Visa"::"Visa authorized") then begin
                        if Status <> Status::Released then
                            Error('La commande n''est pas lancée');
                        "Date Visa" := WorkDate;
                        "Person in charge Visa" := UserId;
                        //    VALIDATE(Status,Status::Released);
                    end else begin
                        "Date Visa" := 0D;
                        "Person in charge Visa" := '';
                    end;
                end;
                //<-- ADV-007 ABSYS GN 20061025

                //AB60408.V2
                if ("Document Type" = "Document Type"::"Credit Memo") then begin
                    if Utils.IsInGroup('VISAVNC') then begin
                        if ("Status Visa" = "Status Visa"::"Visa authorized") then begin
                            "Date Visa" := WorkDate;
                            "Person in charge Visa" := UserId;
                            Validate(Status, Status::Released);
                        end else begin
                            "Date Visa" := 0D;
                            "Person in charge Visa" := '';
                        end;
                    end else
                        Error('Non visé');
                    //message
                end;
                //AB60408.V2
            end;
        }
        field(50001; "Person in charge Visa"; Code[50])
        {
            Caption = 'Person in charge Visa';
            Description = 'ADV-007';
        }
        field(50002; "Date Visa"; Date)
        {
            Caption = 'Date Visa';
            Description = 'ADV-007';
        }
        field(50003; "Order type"; Option)
        {
            Caption = 'Order type';
            Description = 'LOG-004';
            OptionCaption = ' ,Frais,Surgelé';
            OptionMembers = " ",Frais,"Surgelé";

            trigger OnValidate()
            var
                ShptPurchOrder: Record "Shipment Purchase Orders";
            begin

                //AB60408.V14
                if ShptPurchOrder.Get("Shipping Agent Code", "Location Code", "Promised Delivery Date", "No.") then begin
                    ShptPurchOrder."Order type" := "Order type";
                    ShptPurchOrder.Modify;
                end;
                //AB60408.V14

                if "Order type" = "Order type"::Frais then
                    Validate("Location Code", 'EC TOURNAI');
                if "Order type" = "Order type"::"Surgelé" then
                    Validate("Location Code", 'ECCONGEL');
            end;
        }
        field(50004; "Logistic unit"; Code[20])
        {
            Caption = 'Logistic unit';
            Description = 'LOG-004';
            TableRelation = "Unité logistique";

            trigger OnValidate()
            var
                ShptPurchOrder: Record "Shipment Purchase Orders";
            begin

                //AB60408.V14
                if ShptPurchOrder.Get("Shipping Agent Code", "Location Code", "Promised Delivery Date", "No.") then begin
                    ShptPurchOrder."Logistic unit" := "Logistic unit";
                    ShptPurchOrder.Modify;
                end;
                //AB60408.V14
            end;
        }
        field(50005; "Unit price/Palette"; Decimal)
        {
            Caption = 'Unit price/Palette';
            Description = 'LOG-004';
            Editable = false;
        }
        field(50006; "Territory Code"; Code[10])
        {
            Caption = 'Territory Code';
            Description = 'LOG-004';
            TableRelation = Territory;
        }
        field(50007; "Transport resource"; Code[20])
        {
            Caption = 'Transport resource';
            Description = 'LOG-004';
            TableRelation = Resource;
        }
        field(50008; "Nombre de palette confirmée"; Integer)
        {
            Caption = 'Nombre de palette confirmée';
            Description = 'LOG-004';
        }
        field(50009; "Montant total palette"; Decimal)
        {
            Caption = 'Montant total palette';
            Description = 'LOG-004';
        }
        field(50010; "Complete Pallet"; Boolean)
        {
            Caption = 'Complete Pallet';
            Description = 'AB60408.V5';

            trigger OnValidate()
            var
                ShptPurchOrder: Record "Shipment Purchase Orders";
                CuSales: Codeunit Integration_Sales;
            begin
                CuSales.TestTransportLine(Rec);  //AB60408.V5

                //AB60408.V14
                if ShptPurchOrder.Get("Shipping Agent Code", "Location Code", "Promised Delivery Date", "No.") then begin
                    ShptPurchOrder."Complete Pallet" := "Complete Pallet";
                    ShptPurchOrder.Modify;
                end;
                //AB60408.V14
            end;
        }
        field(50011; "Customer Shipment Blocked"; Boolean)
        {
            Caption = 'Customer Shipment Blocked';
            Description = 'AB60408.C8';
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
        field(50014; "Cases Quantity per Pallet"; Integer)
        {
            Caption = 'Cases Quantity per Pallet';
            Description = 'AB6.VIR';
        }
        field(50015; "Production comment"; Text[200])
        {
            Caption = 'Production comment';
            Description = 'CTD';
        }
        field(50020; "Date livraison prévue"; Date)
        {
            Caption = 'Planned delivery date';
        }
        field(50021; StatusLogo; Option)
        {
            Caption = 'StatusLogo';
            OptionCaption = 'NonDefini,Avec,Sans';
            OptionMembers = NonDefini,Avec,Sans;
        }
        field(50022; "Horaires de livraison"; Text[80])
        {
            Caption = 'Horaires de livraison';
        }
        field(50023; "Stade Relance client"; Integer)
        {
            CalcFormula = Lookup(Customer."Stade rappel calculé" WHERE("No." = FIELD("Sell-to Customer No.")));
            Caption = 'Stade Relance client';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50024; "Nom recherche client"; Code[100])
        {
            CalcFormula = Lookup(Customer."Search Name" WHERE("No." = FIELD("Sell-to Customer No.")));
            Caption = 'Nom recherche client';
            FieldClass = FlowField;
        }
        field(50025; "Confirmation envoyée"; Boolean)
        {
            Caption = 'Confirmation envoyée';
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
        field(50031; "Ligne transport existante"; Boolean)
        {
            CalcFormula = Exist("Sales Line" WHERE("Document Type" = FIELD("Document Type"),
                                                    "Document No." = FIELD("No."),
                                                    "Transport line" = CONST(true)));
            Caption = 'Ligne transport existante';
            FieldClass = FlowField;
        }
        field(50032; "EDI brut"; BLOB)
        {
            Caption = 'EDI brut';
            SubType = Memo;
        }
        field(50033; "EDI Recu"; BLOB)
        {
            Caption = 'EDI Recu';
            Compressed = false;
            SubType = Memo;
        }
        field(50034; "Validation départ demandé"; DateTime)
        {
            Editable = false;
        }
        field(50035; "Blocage des lots"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50036; "Lié avec commande n°"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Sales Header"."No." WHERE("Sell-to Customer No." = FIELD("Sell-to Customer No."),
                                                        "Location Code" = FILTER(<> 'RD'));
        }
        field(50037; "Validation départ confirmée"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
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
        field(50044; ExtranetDt; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(50045; ExtranetToConfirm; Boolean)
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
        field(50100; User; Code[50])
        {
            Caption = 'User';
            Description = 'AB6.VIR';
        }
        field(50101; "Employee BackOffice"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;
        }
        field(50102; "Price Valid from"; Date)
        {
            Caption = 'Price valid from';
            DataClassification = ToBeClassified;
        }
        field(50103; "Price Valid to"; Date)
        {
            Caption = 'Price valid until';
            DataClassification = ToBeClassified;
        }
        field(50800; "Bon Pour Expédition"; Option)
        {
            Caption = 'Bon Pour Expédition';
            Description = 'AB6.SEC';
            OptionCaption = 'On standby shipment,Shipment authorized';
            OptionMembers = "On standby shipment","Shipment authorized";

            trigger OnValidate()
            var
                Utils: Codeunit Utils;
            begin
                //VIR.120310 AB6.SEC -->
                if ("Document Type" = "Document Type"::Order) then begin
                    if Utils.IsInGroup('VISABLOK') then begin
                        if ("Bon Pour Expédition" = "Bon Pour Expédition"::"Shipment authorized") then begin
                            "Shipment Date Visa" := WorkDate;
                            "Shipment Person in charge Visa" := UserId;
                        end else begin
                            "Shipment Date Visa" := 0D;
                            "Shipment Person in charge Visa" := '';
                            "Bon Pour Expédition" := "Bon Pour Expédition"::"On standby shipment";
                        end;
                    end
                    else
                        Error('Commande non visée');
                end;
                //VIR.120310 AB6.SEC <--
            end;
        }
        field(50801; "Shipment Person in charge Visa"; Code[50])
        {
            Caption = 'Shipment Person in charge Visa';
            Description = 'AB6.SEC';
        }
        field(50802; "Shipment Date Visa"; Date)
        {
            Caption = 'Shipment Date Visa';
            Description = 'AB6.SEC';
        }
        field(66000; "Item completed"; Boolean)
        {
            Caption = 'Item completed';
            Description = 'ABS6.00';
        }
        field(66001; "Commande bloquee"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(66002; "Status credit"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Ok,"Bloqué - credit dépassé","Bloqué - Montants échus","Bloqué - Montants échus précédents","Libéré manuellement","A Calculer";

            trigger OnValidate()
            begin
                if Rec."Status credit" <> xRec."Status credit" then begin
                    Rec."Status Visa" := Rec."Status Visa"::"On standby visa ";
                    if (Rec."Status credit" = Rec."Status credit"::Ok) or (Rec."Status credit" = Rec."Status credit"::"Libéré manuellement") then begin
                        "Fin blocage" := Today;
                        if "Debut blocage" > 0D then
                            "Jours blocage" := "Jours blocage" + ("Fin blocage" - "Debut blocage");
                    end
                    else begin
                        // Nouveau blocage
                        "Debut blocage" := Today;
                    end;
                end;
            end;
        }
        field(66003; "Release Date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(66004; Reopen; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(66005; "Quantité totale"; Decimal)
        {
            CalcFormula = Sum("Sales Line"."Quantity (Base)" WHERE("Document Type" = FIELD("Document Type"),
                                                                    "Document No." = FIELD("No."),
                                                                    "No." = FILTER('1-*')));
            FieldClass = FlowField;
        }
    }

}

