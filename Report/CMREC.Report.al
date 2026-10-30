report 50008 "CMR EC"
{
    // //AB60408.V8 EBE 16/04/08
    //    - ajout filter sur articles <> '9*' pour exclure les vidanges du calcul du poids
    // 
    // //BNC 02/12/13 Prise en compte du poids net des lignes pour le calcul du poids net total.
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/CMREC.rdlc';


    dataset
    {
        dataitem(Copie; "Integer")
        {
            DataItemTableView = SORTING(Number);
            MaxIteration = 4;
            dataitem("Sales Shipment Header"; "Sales Shipment Header")
            {
                RequestFilterFields = "No.";
                column(TxtAdrLocation_g_1_; TxtAdrLocation_g[1])
                {
                }
                column(TxtAdrLocation_g_2_; TxtAdrLocation_g[2])
                {
                }
                column(TxtAdrLocation_g_3_; TxtAdrLocation_g[3])
                {
                }
                column(TxtAdrLocation_g_4_; TxtAdrLocation_g[4])
                {
                }
                column(TxtAdrLocation_g_5_; TxtAdrLocation_g[5])
                {
                }
                column(TxtShipToAddress_g_1_; TxtShipToAddress_g[1])
                {
                }
                column(TxtShipToAddress_g_2_; TxtShipToAddress_g[2])
                {
                }
                column(TxtShipToAddress_g_3_; TxtShipToAddress_g[3])
                {
                }
                column(TxtShipToAddress_g_4_; TxtShipToAddress_g[4])
                {
                }
                column(TxtShipToAddress_g_5_; TxtShipToAddress_g[5])
                {
                }
                column(Sales_Shipment_Header__Ship_to_Country_Region_Code_; "Ship-to Country/Region Code")
                {
                }
                column(Sales_Shipment_Header__Ship_to_Post_Code_; "Ship-to Post Code")
                {
                }
                column(Sales_Shipment_Header__Ship_to_City_; "Ship-to City")
                {
                }
                column(RecLocation_g_City; RecLocation_g.City)
                {
                }
                column(RecLocation_g__Post_Code_; RecLocation_g."Post Code")
                {
                }
                column(RecLocation_g__Country_Region_Code_; RecLocation_g."Country/Region Code")
                {
                }
                column(RecLocation_g_City_Control1000000011; RecLocation_g.City)
                {
                }
                column(RecLocation_g__Post_Code__Control1000000013; RecLocation_g."Post Code")
                {
                }
                column(RecLocation_g__Country_Region_Code__Control1000000015; RecLocation_g."Country/Region Code")
                {
                }
                column(TxtAdrLocation_g_1__Control1000000017; TxtAdrLocation_g[1])
                {
                }
                column(TxtAdrLocation_g_2__Control1000000018; TxtAdrLocation_g[2])
                {
                }
                column(TxtAdrLocation_g_3__Control1000000019; TxtAdrLocation_g[3])
                {
                }
                column(TxtAdrLocation_g_4__Control1000000024; TxtAdrLocation_g[4])
                {
                }
                column(TxtAdrLocation_g_5__Control1000000025; TxtAdrLocation_g[5])
                {
                }
                column(Sales_Shipment_Header__No__; "No.")
                {
                }
                column(TotalPoidsNet_g; TotalPoidsNet_g)
                {
                }
                column(Sales_Shipment_Header__Nombre_de_palette_; "Nombre de palette")
                {
                }
                column(Sales_Shipment_Header__Nombre_de_colis_; "Nombre de colis")
                {
                }
                column(TxtConservation_g; TxtConservation_g)
                {
                }
                column(TxtShippmentAgentAddress_g_1_; TxtShippmentAgentAddress_g[1])
                {
                }
                column(TxtShippmentAgentAddress_g_2_; TxtShippmentAgentAddress_g[2])
                {
                }
                column(TxtShippmentAgentAddress_g_3_; TxtShippmentAgentAddress_g[3])
                {
                }
                column(TxtShippmentAgentAddress_g_4_; TxtShippmentAgentAddress_g[4])
                {
                }
                column(TxtShippmentAgentAddress_g_5_; TxtShippmentAgentAddress_g[5])
                {
                }
                column(Sales_Shipment_Header__Document_Date_; "Document Date")
                {
                }
                column(Sales_Shipment_Header__Document_Date__Control1000000044; "Document Date")
                {
                }
                column(Copie_Number; Copie.Number)
                {
                }
                column(Sales_Shipment_Header__Commentaire_CMR_; "Commentaire CMR")
                {
                }
                column(NE___Caption; NE___CaptionLbl)
                {
                }
                column("GEKOCHTEM_GEFLÜGELFLEISCHCaption"; GEKOCHTEM_GEFLÜGELFLEISCHCaptionLbl)
                {
                }
                column(Poids_NetCaption; Poids_NetCaptionLbl)
                {
                }
                column(Sales_Shipment_Header__Nombre_de_palette_Caption; FieldCaption("Nombre de palette"))
                {
                }
                column(Sales_Shipment_Header__Nombre_de_colis_Caption; FieldCaption("Nombre de colis"))
                {
                }
                column(KgCaption; KgCaptionLbl)
                {
                }

                trigger OnAfterGetRecord()
                var
                    RecTransporteur_l: Record "Shipping Agent";
                    RecSalesShipLine_l: Record "Sales Shipment Line";
                begin
                    // -- INIT --
                    Clear(TxtShipToAddress_g);
                    Clear(TxtShippmentAgentAddress_g);
                    Clear(TxtAdrLocation_g);


                    // -- Récupérer adresse livraison --
                    CUFormatAddress_g.SalesShptShipTo(TxtShipToAddress_g, "Sales Shipment Header");

                    // -- Récupérer adresse transporteur
                    if RecTransporteur_l.Get("Sales Shipment Header"."Shipping Agent Code") then
                        CUFormatAddress_g.FormatAddr(TxtShippmentAgentAddress_g, RecTransporteur_l.Name, '', '',
                                                                                  RecTransporteur_l.Address,
                                                                                  RecTransporteur_l."Address 2",
                                                                                  RecTransporteur_l.City,
                                                                                  RecTransporteur_l."Post Code",
                                                                                  RecTransporteur_l.County,
                                                                                  RecTransporteur_l."Country Code");


                    // -- Récupérer adresse magasin --
                    if RecLocation_g.Get("Sales Shipment Header"."Location Code") then
                        CUFormatAddress_g.FormatAddr(TxtAdrLocation_g, RecLocation_g.Name,
                                                                     RecLocation_g."Name 2",
                                                                     RecLocation_g.Contact,
                                                                     RecLocation_g.Address,
                                                                     RecLocation_g."Address 2",
                                                                     RecLocation_g.City,
                                                                     RecLocation_g."Post Code",
                                                                     RecLocation_g.County,
                                                                     RecLocation_g."Country/Region Code");


                    // -- Type conservation --
                    TxtConservation_g := '';
                    if "Sales Shipment Header"."Order type" = "Sales Shipment Header"."Order type"::Frais then
                        TxtConservation_g := Text50006;

                    if "Sales Shipment Header"."Order type" = "Sales Shipment Header"."Order type"::"Surgelé" then
                        TxtConservation_g := Text50007;


                    // -- Calcul poids net --
                    TotalPoidsNet_g := 0;
                    RecSalesShipLine_l.Init;
                    RecSalesShipLine_l.SetRange("Document No.", "Sales Shipment Header"."No.");
                    RecSalesShipLine_l.SetRange(RecSalesShipLine_l.Type, RecSalesShipLine_l.Type::Item);
                    if RecSalesShipLine_l.Find('-') then
                        repeat
                            if CopyStr(RecSalesShipLine_l."No.", 1, 1) <> '9' then //AB60408.V8
                                                                                   //BNC 02/12/13 // GD111019  bof ....
                                TotalPoidsNet_g := TotalPoidsNet_g + RecSalesShipLine_l."Quantity (Base)";
                        //TotalPoidsNet_g := TotalPoidsNet_g + (RecSalesShipLine_l.Quantity * RecSalesShipLine_l."Net Weight");
                        //BNC 02/12/13 //
                        until RecSalesShipLine_l.Next = 0;
                end;
            }
        }
    }

    requestpage
    {

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

    trigger OnInitReport()
    begin
        RecInfoCompany_g.Get;
        CUFormatAddress_g.Company(TxtAdrCompany_g, RecInfoCompany_g);
    end;

    var
        RecInfoCompany_g: Record "Company Information";
        CUFormatAddress_g: Codeunit "Format Address";
        TxtAdrCompany_g: array[8] of Text[250];
        TxtShipToAddress_g: array[8] of Text[80];
        TxtShippmentAgentAddress_g: array[8] of Text[80];
        Text50000: Label 'Cooked Pouletry Meat';
        TxtTemperature_g: Text[30];
        TxtAdrLocation_g: array[8] of Text[80];
        RecLocation_g: Record Location;
        Text50006: Label 'Produits frais sont transportés à une température <= 4°C';
        Text50007: Label 'Produits congelés sont transportés à une température <= -18°C';
        TxtConservation_g: Text[200];
        TotalPoidsNet_g: Decimal;
        NE___CaptionLbl: Label 'NE - ';
        "GEKOCHTEM_GEFLÜGELFLEISCHCaptionLbl": Label 'COOKED POULTRY-MEAT';
        Poids_NetCaptionLbl: Label 'Poids Net';
        KgCaptionLbl: Label 'Kg';
}

