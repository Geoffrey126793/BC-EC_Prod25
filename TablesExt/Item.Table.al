tableextension 50020 ItemEC extends Item
{
    fields
    {
        field(50000; "EAN13 Code"; Code[13])
        {
            Caption = 'CB produit (Code EAN13)';
            Description = 'ART-001';
        }
        field(50001; "Default Location Code"; Code[10])
        {
            Caption = 'Default Location Code';
            Description = 'ART-000';
            TableRelation = Location.Code;
        }
        field(50050; "Base 1"; Code[20])
        {
            Caption = 'Base 1';
            Description = 'ABC GEN 20090604';
            TableRelation = Item."No.";
        }
        field(50051; "Rendement 1"; Decimal)
        {
            Caption = 'Rendement 1';
            Description = 'ABC GEN 20090604';
        }
        field(50052; "Base 2"; Code[20])
        {
            Caption = 'Base 2';
            Description = 'ABC GEN 20090604';
            TableRelation = Item."No.";
        }
        field(50053; "Rendement 2"; Decimal)
        {
            Caption = 'Rendement 2';
            Description = 'ABC GEN 20090604';
        }
        field(50054; "Base 3"; Code[20])
        {
            Caption = 'Base 3';
            Description = 'ABC GEN 20090604';
            TableRelation = Item."No.";
        }
        field(50055; "Rendement 3"; Decimal)
        {
            Caption = 'Rendement 3';
            Description = 'ABC GEN 20090604';
        }
        field(50060; "Criteria 11"; Code[20])
        {
            Caption = 'Criteria 11';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(50060));
        }
        field(50061; "Criteria 12"; Code[20])
        {
            Caption = 'Criteria 12';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(50061));
        }
        field(50062; PoidsPalette; Decimal)
        {
            Caption = 'PoidsPalette';
        }
        field(50063; BoitesPalette; Decimal)
        {
            Caption = 'BoitesPalette';
        }
        field(50064; TypePalette; Code[20])
        {
            Caption = 'TypePalette';
            TableRelation = Code.Code WHERE("Table No" = CONST(50018),
                                             "Field No" = CONST(55005));
        }
        field(50065; FormuleDLC; DateFormula)
        {
            Caption = 'FormuleDLC';
        }
        field(50066; Drapeau; BLOB)
        {
            Caption = 'Drapeau';
            SubType = Bitmap;
        }
        field(50067; PrevisionVenteMensuelle; Decimal)
        {
            Caption = 'PrevisionVenteMensuelle';
        }
        field(50068; Planning; Code[20])
        {
            Caption = 'Planning';
        }
        field(50069; "Niveau allergene"; Integer)
        {
            Caption = 'Niveau allergene';
        }
        field(50070; "Force VP"; Boolean)
        {
            Caption = 'Force VP';
        }
        field(50071; Cadence; Integer)
        {
            Caption = 'Cadence';
        }
        field(50072; "Cout simulation"; Decimal)
        {
            Caption = 'Cout simulation';
        }
        field(50073; "Px de revient matiére simulé"; Decimal)
        {
            Caption = 'Px de revient matiére simulé';
            DecimalPlaces = 0 : 4;
            Editable = false;
        }
        field(50074; Assiette; Code[30])
        {
            Caption = 'Assiette';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(50074));
        }
        field(50075; "Px de revient matiÞre std"; Decimal)
        {
            Caption = 'Px de revient matiére standard';
            DecimalPlaces = 0 : 4;
        }
        field(50076; "Px de revient total"; Decimal)
        {
            Caption = 'Px de revient total';
        }
        field(50077; "Px de revient sans 22A"; Decimal)
        {
            Caption = 'Px de revient sans 22A';
        }
        field(50078; Process; Text[200])
        {
            Caption = 'Process';
        }
        field(50079; "Quantié consommée"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                  "Entry Type" = CONST(Consumption)));
            Caption = 'Quantié consommée';
            FieldClass = FlowField;
        }
        field(50080; "Type de production"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Simple,"Par les sous-variantes",Variante;
        }
        field(50081; "Comment blocage lots produits"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(50082; "Cout ABC"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(50083; tmp; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50084; "Option production"; Option)
        {
            Caption = 'Production options';
            DataClassification = ToBeClassified;
            OptionMembers = "Sur commande","Stock standard","Stock client";
        }
        field(50085; "Anciens ateliers"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50086; "Nouveaux ateliers"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50087; "Machine sur écran"; Text[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Code.Code WHERE("Table No" = CONST(5405),
                                             "Field No" = CONST(50005));
        }
        field(50088; "Criteria 13"; Code[20])
        {
            Caption = 'Espece';
            DataClassification = ToBeClassified;
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(50088));
        }
        field(50089; "Criteria 14"; Code[20])
        {
            Caption = 'Pièce de viande';
            DataClassification = ToBeClassified;
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(50089));
        }
        field(50090; "Criteria 15"; Code[20])
        {
            Caption = 'Famille';
            DataClassification = ToBeClassified;
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(50090));
        }
        field(50091; "Criteria 16"; Code[20])
        {
            Caption = 'Coupe';
            DataClassification = ToBeClassified;
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(50091));
        }
        field(50092; "Criteria 17"; Code[20])
        {
            Caption = 'Calibre';
            DataClassification = ToBeClassified;
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(50092));
        }
        field(50093; Emplacement; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Code.Code WHERE("Table No" = CONST(5405),
                                             "Field No" = CONST(50107));
        }
        field(50094; "Raison blocage"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Code.Code WHERE("Table No" = CONST(6505),
                                             "Field No" = CONST(50214));
        }
        field(50095; "A suivre"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50100; Consign; Boolean)
        {
            Caption = 'Consign';
            Description = 'ART-003';
        }
        field(50101; "Criteria 1 Desc"; Text[150])
        {
            CalcFormula = Lookup(Code.Description WHERE("Table No" = CONST(27),
                                                         "Field No" = CONST(8001301),
                                                         Code = FIELD("Criteria 1")));
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(11);
            Caption = 'Criteria 1';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50102; "Criteria 2 Desc"; Text[150])
        {
            CalcFormula = Lookup(Code.Description WHERE("Table No" = CONST(27),
                                                         "Field No" = CONST(8001302),
                                                         Code = FIELD("Criteria 2")));
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(12);
            Caption = 'Criteria 2';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001302));
        }
        field(50103; "Criteria 3 Desc"; Text[150])
        {
            CalcFormula = Lookup(Code.Description WHERE("Table No" = CONST(27),
                                                         "Field No" = CONST(8001303),
                                                         Code = FIELD("Criteria 3")));
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(13);
            Caption = 'Criteria 3';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50104; "Criteria 4 Desc"; Text[150])
        {
            CalcFormula = Lookup(Code.Description WHERE("Table No" = CONST(27),
                                                         "Field No" = CONST(8001304),
                                                         Code = FIELD("Criteria 4")));
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(14);
            Caption = 'Criteria 4';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50105; "Criteria 5 Desc"; Text[150])
        {
            CalcFormula = Lookup(Code.Description WHERE("Table No" = CONST(27),
                                                         "Field No" = CONST(8001305),
                                                         Code = FIELD("Criteria 5")));
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(15);
            Caption = 'Criteria 5';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50107; "Criteria 7 Desc"; Text[150])
        {
            CalcFormula = Lookup(Code.Description WHERE("Table No" = CONST(27),
                                                         "Field No" = CONST(8001307),
                                                         Code = FIELD("Criteria 7")));
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(17);
            Caption = 'Criteria 7';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50110; "Criteria 10 Desc"; Text[150])
        {
            CalcFormula = Lookup(Code.Description WHERE("Table No" = CONST(27),
                                                         "Field No" = CONST(8001310),
                                                         Code = FIELD("Criteria 10")));
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(20);
            Caption = 'Criteria 10';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50111; "Criteria 13 Desc"; Text[150])
        {
            CalcFormula = Lookup(Code.Description WHERE("Table No" = CONST(27),
                                                         "Field No" = CONST(50088),
                                                         Code = FIELD("Criteria 13")));
            Caption = 'Espece';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50112; "Criteria 14 Desc"; Text[150])
        {
            CalcFormula = Lookup(Code.Description WHERE("Table No" = CONST(27),
                                                         "Field No" = CONST(50089),
                                                         Code = FIELD("Criteria 14")));
            Caption = 'Pièce de viande';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50113; "Criteria 15 Desc"; Text[150])
        {
            CalcFormula = Lookup(Code.Description WHERE("Table No" = CONST(27),
                                                         "Field No" = CONST(50090),
                                                         Code = FIELD("Criteria 15")));
            Caption = 'Famille';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50114; "Criteria 16 Desc"; Text[150])
        {
            CalcFormula = Lookup(Code.Description WHERE("Table No" = CONST(27),
                                                         "Field No" = CONST(50091),
                                                         Code = FIELD("Criteria 16")));
            Caption = 'Coupe';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50115; "Criteria 17 Desc"; Text[150])
        {
            CalcFormula = Lookup(Code.Description WHERE("Table No" = CONST(27),
                                                         "Field No" = CONST(50092),
                                                         Code = FIELD("Criteria 17")));
            Caption = 'Calibre';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50120; "CB carton"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50130; "CB Souche"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50140; "Prix vente CT"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50141; "Prix vente LT"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50142; Pasteurisation; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(50142));
        }
        field(50143; "Quantité par sac"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(50143));
        }
        field(50144; THT; DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(50145; "Type de consommation"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Réelle sur OF","Théorique sur OF",Sans,"Négatif sur transfert du stock";
        }
        field(50146; "% supplémentaire à préparer"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50147; "Atelier MO"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50148; "Conso Moy Period"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                  "Entry Type" = CONST(Consumption)));
            FieldClass = FlowField;
        }
        field(50149; "Stock max"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50150; "Stop nomenclature VP"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50151; "Anticipation production"; Integer)
        {
            Caption = 'Anticipation production (h)';
            DataClassification = ToBeClassified;
        }
        field(50152; "Preparation ARGML"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(50153; "Delai mise à dispo"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = '(jours)  Délai analyse, décongélation, ...';
        }
        field(50154; "Kg par heartbeat"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50155; "Piece par heartbeat"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50156; "Machines pour VP"; Text[1024])
        {
            DataClassification = ToBeClassified;
        }
        field(50157; "Nbre cartons par etage"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50158; "Nbre etages par palette"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50159; "Poids brut palette"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50160; "Hauteur palette"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50161; "Poids carton"; Decimal)
        {
            CalcFormula = Lookup(Code.Poids WHERE("Table No" = CONST(27),
                                                   "Field No" = CONST(8001305),
                                                   Code = FIELD("Criteria 5")));
            Caption = 'Poids carton';
            FieldClass = FlowField;
        }
        field(50162; "Poids article"; Decimal)
        {
            CalcFormula = Lookup(Code."Poids primaire" WHERE("Table No" = CONST(27),
                                                              "Field No" = CONST(8001305),
                                                              Code = FIELD("Criteria 5")));
            Caption = 'Poids article';
            FieldClass = FlowField;
        }
        field(50163; "Delai production"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50164; "Categorie evaluation stock"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(50164));
        }
        field(50165; "Quantité minimum vente"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50200; "Tolerance Receipt"; Decimal)
        {
            Caption = 'Tolerance Receipt';
            Description = 'ABC GEN 20130524';
        }
        field(50201; "Blanket Order Qty"; Decimal)
        {
            CalcFormula = Sum("Purchase Line"."Outstanding Qty. (Base)" WHERE("No." = FIELD("No."),
                                                                               "Document Type" = CONST("Blanket Order")));
            Caption = 'Quantité sur commande achat cadre';
            FieldClass = FlowField;
        }
        field(55001; "Inventory on Boat"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
                                                                  "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                  "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                  "Location Code" = FIELD("Location Filter"),
                                                                  "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                  "Variant Code" = FIELD("Variant Filter"),
                                                                  "Lot No." = FIELD("Lot No. Filter"),
                                                                  "Serial No." = FIELD("Serial No. Filter"),
                                                                  "On Boat" = CONST(true)));
            Caption = 'Inventory on Boat';
            DecimalPlaces = 0 : 5;
            Description = 'LOG-005';
            Editable = false;
            FieldClass = FlowField;
        }
        field(66000; "Item completed"; Boolean)
        {
            Caption = 'Item completed';
            Description = 'ABS6.00';
        }
        field(8001301; "Criteria 1"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(11);
            Caption = 'Criteria 1';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001301));
        }
        field(8001302; "Criteria 2"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(12);
            Caption = 'Criteria 2';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001302));
        }
        field(8001303; "Criteria 3"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(13);
            Caption = 'Criteria 3';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001303));
        }
        field(8001304; "Criteria 4"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(14);
            Caption = 'Criteria 4';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001304));
        }
        field(8001305; "Criteria 5"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(15);
            Caption = 'Criteria 5';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001305));
        }
        field(8001306; "Criteria 6"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(16);
            Caption = 'Criteria 6';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001306));
        }
        field(8001307; "Criteria 7"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(17);
            Caption = 'Criteria 7';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001307));
        }
        field(8001308; "Criteria 8"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(18);
            Caption = 'Criteria 8';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001308));
        }
        field(8001309; "Criteria 9"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(19);
            Caption = 'Criteria 9';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001309));
        }
        field(8001310; "Criteria 10"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(20);
            Caption = 'Criteria 10';
            TableRelation = Code.Code WHERE("Table No" = CONST(27),
                                             "Field No" = CONST(8001310));
        }
    }
    var
        wStatisticAggregate: Record "Statistic aggregate";
}

