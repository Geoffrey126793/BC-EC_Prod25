page 50035 "Palettes expedition"
{
    Caption = 'Palettes expedition';
    PageType = List;
    PopulateAllFields = true;
    SourceTable = Pallet;

    layout
    {
        area(content)
        {
            field(test; test)
            {
            }
            repeater(Group)
            {
                field("SSCC No."; "SSCC No.")
                {
                    Editable = false;
                }
                field("Quantite reception"; "Quantite reception")
                {
                    Caption = 'Poids Net';

                    trigger OnValidate()
                    begin
                        //calcBacs();
                    end;
                }
                field("Nbre bacs reception"; "Nbre bacs reception")
                {
                    Caption = 'Boites';
                }
                field("Agrément"; Agrément)
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field("Lot No."; "Lot No.")
                {
                }
                field(DLC; DLC)
                {
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            group(tt)
            {
                Caption = 'tt';
                Enabled = true;
            }
            action("Imprimer les fiches")
            {
                Caption = 'Imprimer les fiches';
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                var
                    RepFiche: Report "Fiche palette expedition";
                    RepFicheLot: Report "Fiche palette expedition + lot";
                    Language: Codeunit Language;
                    cmd: Record "Sales Header";
                    exv: Record "Sales Shipment Header";
                    NoClient: Code[20];
                    RepLLBG: Report "Fiche palette expedition LLBG";
                    Cust: Record Customer;
                    RepGS1: Report "Fiche palette expedition GS1";
                    RepTello: Report "Fiche palette exp TELLO";
                    RepGAC: Report "Fiche palette expedition GAC";
                    RepFF: Report "Fiche palette expedition FF";
                begin
                    if (Rec."Lot No." <> '') then begin
                        NoClient := '';
                        if cmd.Get(cmd."Document Type"::Order, NoExpedition) then
                            NoClient := cmd."Sell-to Customer No.";
                        if exv.Get(NoExpedition) then
                            NoClient := exv."Sell-to Customer No.";
                        Cust.Get(NoClient);
                        case Cust.EtiquetteExp of
                            'TELLO':
                                begin
                                    RepTello.UseRequestPage(true);
                                    RepTello.Language := Language.GetLanguageID(Lng);
                                    RepTello.setLanguage(Lng);
                                    RepTello.setTempRec(Rec, NoExpedition);
                                    RepTello.Run();
                                end;
                            'LLBG':
                                begin
                                    RepLLBG.UseRequestPage(true);
                                    RepLLBG.Language := Language.GetLanguageID(Lng);
                                    RepLLBG.setLanguage(Lng);
                                    RepLLBG.setTempRec(Rec, NoExpedition);
                                    RepLLBG.Run();
                                end;
                            'BASE_GS1':
                                begin
                                    RepGS1.UseRequestPage(true);
                                    RepGS1.Language := Language.GetLanguageID(Lng);
                                    RepGS1.setLanguage(Lng);
                                    RepGS1.setTempRec(Rec, NoExpedition);
                                    RepGS1.Run();
                                end;
                            'FF':
                                begin
                                    RepFF.UseRequestPage(true);
                                    RepFF.Language := Language.GetLanguageID(Lng);
                                    RepFF.setLanguage(Lng);
                                    RepFF.setTempRec(Rec, NoExpedition);
                                    RepFF.Run();
                                end;
                            'GAC':
                                begin
                                    RepGAC.UseRequestPage(true);
                                    RepGAC.Language := Language.GetLanguageID(Lng);
                                    RepGAC.setLanguage(Lng);
                                    RepGAC.setTempRec(Rec, NoExpedition);
                                    RepGAC.Run();
                                end;
                            else begin
                                RepFicheLot.UseRequestPage(true);
                                RepFicheLot.Language := Language.GetLanguageID(Lng);
                                RepFicheLot.setLanguage(Lng);
                                RepFicheLot.setTempRec(Rec, NoExpedition);
                                RepFicheLot.Run();
                            end;
                        end;
                    end
                    else begin
                        RepFiche.UseRequestPage(true);
                        RepFiche.setTempRec(Rec, NoExpedition);
                        RepFiche.Run();

                    end;
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        InvtSetup: Record "Inventory Setup";
        NoSeriesMgt: Codeunit "No. Series";
    begin

        InvtSetup.Get;
        InvtSetup.TestField("Pallet Nos.");
        "SSCC No." := NoSeriesMgt.GetNextNo(InvtSetup."Pallet Nos.", TODAY);
        "Outbound Document No." := NoExpedition;

        Agrément := xRec.Agrément;
    end;

    trigger OnOpenPage()
    begin
        Rec.SetRange(Type);
        Rec.SetFilter("Inbound Document No.", '<>*CANCEL');
    end;

    var
        i: Integer;
        test: Text[30];
        NoExpedition: Code[20];
        Pal: Record Pallet;
        Lng: Code[10];
        CuProd: Codeunit "Integration Tft and Prod";

    [Scope('OnPrem')]
    procedure setExpedition(No: Code[20])
    var
        PaletEntry: Record "Pallet Ledger Entry";
        Palet: Record Pallet;
        ShptL: Record "Sales Shipment Line";
        Items: Record Item;
        ShptH: Record "Sales Shipment Header";
    begin
        NoExpedition := No;
        CuProd.PalettesExp(No);
    end;

    [Scope('OnPrem')]
    procedure setCommande(No: Code[20])
    var
        PaletJnl: Record "Pallet Journal";
        Palet: Record Pallet;
        SalesL: Record "Sales Line";
        Items: Record Item;
        Qty: Decimal;
        Reserv: Record "Reservation Entry";
        SalesH: Record "Sales Header";
    begin
        NoExpedition := No;
        CuProd.PalettesCmd(No);
    end;
}

