pageextension 70198 pageextension70198 extends "Lot No. Information Card"
{
    layout
    {

        addafter(General)
        {
            group("Qualité")
            {
                Caption = 'Qualité';
                field("Date controle"; "Date controle")
                {
                }
                field("Poids moyen"; "Poids moyen")
                {
                }
                field("Commentaire coupe/calibre"; "Commentaire coupe/calibre")
                {
                }
                field("Commentaire couleur/odeur"; "Commentaire couleur/odeur")
                {
                }
                field("Commentaire packaging/livraiso"; "Commentaire packaging/livraiso")
                {
                }
                field("Raison du blocage"; "Raison du blocage")
                {
                }
                field("Commentaire blocage"; "Commentaire blocage")
                {
                }
                field(Decision; Decision)
                {
                }
                field("Commentaire decision"; "Commentaire decision")
                {
                }
                field("Statut du blocage"; "Statut du blocage")
                {

                }
                field(Destination; Destination)
                {

                }
                field(Recyclage; Recyclage)
                {

                }
            }

            field("En vente"; "En vente")
            {
                Caption = 'En traça vente';
            }
        }
        addafter(Inventory)
        {
            group("Traçabilité")
            {
                Caption = 'Traçabilité';
                group(Elevage)
                {
                    Caption = 'Elevage';
                    field(ElevagePays; ElevagePays)
                    {
                        Caption = 'Pays';
                        ShowMandatory = true;
                    }
                    field(ElevageVille; ElevageVille)
                    {
                        Caption = 'Ville';
                    }
                }
                group(Abattage)
                {
                    Caption = 'Abattage';
                    field(AbattagePays; AbattagePays)
                    {
                        Caption = 'Pays';
                        ShowMandatory = true;
                    }
                    field(AbattageVille; AbattageVille)
                    {
                        Caption = 'Ville';
                    }
                    field(AbattageCP; AbattageCP)
                    {
                        Caption = 'CodePostal';
                    }
                    field(AbattageDu; AbattageDu)
                    {
                        Caption = 'Du';
                        ShowMandatory = true;
                    }
                    field(AbattageAu; AbattageAu)
                    {
                        Caption = 'Au';
                        ShowMandatory = true;
                    }
                }
                group("Découpe")
                {
                    Caption = 'Découpe';
                    field(DecoupePays; DecoupePays)
                    {
                        Caption = 'Pays';
                        ShowMandatory = true;
                    }
                    field(DecoupeVille; DecoupeVille)
                    {
                        Caption = 'Ville';
                    }
                    field(DecoupeCP; DecoupeCP)
                    {
                        Caption = 'CodePostal';
                    }
                    field(DecoupeDu; DecoupeDu)
                    {
                        Caption = 'Du';
                        ShowMandatory = true;
                    }
                    field(DecoupeAu; DecoupeAu)
                    {
                        Caption = 'Au';
                        ShowMandatory = true;
                    }
                }
            }
        }
    }
    actions
    {
        addafter(ButtonFunctions)
        {
            action(Reprint)
            {
                Caption = 'Réimpirmer étiquette';

                trigger OnAction()
                var
                    CuScan: Codeunit "WS Scan";
                begin
                    CuScan.ReprintLot("Item No.", "Lot No.");
                end;
            }
            action(ReprintPrinter)
            {
                Caption = 'Réimpirmer étiquette/Imprimante';

                trigger OnAction()
                var
                    CuScan: Codeunit "WS Scan";
                    P_Codes: Page Codes;
                    Codes: Record "Code";
                begin
                    Codes.Reset;
                    Codes.SetRange("Table No", 50018);
                    Codes.SetRange("Field No", 55009);
                    if Codes.FindFirst then;
                    P_Codes.SetTableView(Codes);
                    P_Codes.SetRecord(Codes);
                    P_Codes.LookupMode := true;
                    if P_Codes.RunModal = ACTION::LookupOK then begin
                        P_Codes.GetRecord(Codes);
                        CuScan.ReprintLotPrinter("Item No.", "Lot No.", Codes.Code);
                    end;
                end;
            }
            action("Traca viandes")
            {

                trigger OnAction()
                var
                    PTraca: Page "Item TracingEC";
                    ile: Record "Item Ledger Entry";
                begin
                    ile.Reset;
                    ile.SetRange("Item No.", "Item No.");
                    ile.SetRange("Entry Type", ile."Entry Type"::Output);
                    ile.SetRange("Lot No.", "Lot No.");
                    if ile.FindLast then
                        PTraca.AddTracking("Item No.", "Lot No.", Inventory, ile."Posting Date", ile."Entry No.");
                    PTraca.Run;
                end;
            }
        }
        addafter(Navigate)
        {
            group("Fichier Attaché")
            {
                action(Import)
                {

                    trigger OnAction()
                    var
                        FileMgmt: Codeunit "File Management";
                        iStream: InStream;
                        FilePath: Text;
                        oStream: OutStream;
                    begin
                        UploadIntoStream('Veuillez sélectionner le fichier', '', '', FilePath, iStream);
                        Rec.AttachedFile.CreateOutStream(oStream);
                        CopyStream(oStream, iStream);
                        Rec.Modify;
                    end;
                }
                action(Export)
                {

                    trigger OnAction()
                    var
                        FileMgmt: Codeunit "File Management";
                        iStream: InStream;
                        FilePath: Text;
                        oStream: OutStream;
                    begin
                        Rec.CalcFields(AttachedFile);
                        if not Rec.AttachedFile.HasValue then
                            exit;
                        Rec.AttachedFile.CreateInStream(iStream);
                        FilePath := "Item No." + '-' + "Lot No." + '.pdf';
                        DownloadFromStream(iStream, '', '', '', FilePath);
                    end;
                }
            }
        }
    }
}

