codeunit 50026 "WS Scan"
{

    trigger OnRun()
    begin
        //PrintLabelOnPrinter('000001409089','2200000000286');
        //AddProdOF2('WB-00730463',10000,'5-FSV-00213',1,'EC TOURNAI',0,'','','','',0DT);
        //ConsoFRSIQF('WB-00725150',10000);
        TerminateOF('WB-00756213', 10000);
        //PutAwayPalletWithUser('000001142462','1-H-027-0','');
        //CancelConsumption(7251330,10);
        //TerminateOF('WB-00697574',10000);
        //ModifDtProd('WB-00645890',CREATEDATETIME(241023D,000000T));
        //PrintBesoins(CREATEDATETIME(110923D,120000T),'MALAXAGEM','2200000000187');
        //PrintLabel150('000000352059');
        //PrintLabel150('000000863664');

        //PrintLabel2('000000852077');
        //PutAwayPalletWithUser('000001121324','1-G-137-0','');
        //AddReservationToComponent('WB-00619339','000000710064',1,'');
        //AddProdOF2('WB-00618531',10000,'1-FAT-00143',60,'EC TOURNAI',0,'','2200000000217','CDV-E22-11999','',0DT);

        //AddReservationToCmd('CDV-E22-08671','000000665953',1,'');
        //DeleteReservationFromComponent('WB-00587857','7-EPC-00274','LAH330');
        //ReprintLot('7-EPC-00270','214001D');
        //MESSAGE('%1',TODAY-DMY2DATE(1,1,DATE2DMY(TODAY,3))+1);
        //ValidatePaletteProduction('000000222740');
        //TftFromProdToCongel('000000156541');
        //PutAwayPalletWithUser('000001093875','RECPROD3','');
        //AddConsoOF('',0,'7-CSS-00001',1,'test',CREATEDATETIME(190122D,010101T),'EC DORMA');
        //AddProdOF('WB-00613529',10000,'5-CRU-00299',1,'EC FORMA',0,'','');
        //AddConsoOF('',0,'8-CRT-00040',12,'23/16/19',CREATEDATETIME(131220D,010101T),'EC DORMA');
        //AddConsoOF('',0,'5-CRU-00026',12,'23/16/19',CREATEDATETIME(131220D,010101T),'EC DORMA');
        ///
        //PrintLabel('000000196838');
        //PrintLabel('000000196854');
        //PrintLabel('000000204652');
        //PrintLabel('000000258689');
        //PrintLabel('000000229573/2');
        //PrintLabelCongel('000000229573/2','2200000000170');

        //TftFromLocationToLocation('000000279026',10,'EC TOURNAI','','',FALSE);
        //TftFromLocationToLocation('000000279026/1',10,'MP','','',TRUE);

        //AddConsoOF('WB-00525559',10000,'7-EPC-00021',10,'purcha0003585738',CREATEDATETIME(160721D,010101T),'MP');
        //AddPaletConsoOF('WB-00619684',10000,'000000713560',1,FALSE,'');

        //Reclassement('7-EPC-00035','73554471AAAA','73554471BBB',150720D,1,'EC TOURNAI','test');
        //AddAllConsoOF('WB-00525638',10000);
        //AddReservationToComponent('WB-00582074','000000552559',50,'');
        //AddPaletConsoOF('WB-00547332',10000,'000000344755',100,FALSE,'');
        //TftFromTournaiToCongel('000000352857',560);
        //TftFromTournaiToCongel('000000352858',100);
        //PrintLabelEpices('000000352059');
        //PutAwayPallet('000000616101','RECPROD3');
        Message('ok');
    end;

    var
        scanMgmt: Codeunit "Scan Management";
        recPalletIn: Record Pallet;
        Params: Record "Code";
        emailmsg: codeunit "Email Message";
        emailsend: Codeunit Email;
        Utils: Codeunit Utils;
        Logs: Record "Logs OF";

    procedure PutAwayPallet(SSCCNo: Code[20]; NewBin: Code[20])
    var
        Pallet: Record Pallet;
    begin
        PutAwayPalletWithUser(SSCCNo, NewBin, '');
    end;

    procedure PutAwayPalletWithUser(SSCCNo: Code[20]; NewBin: Code[20]; User: Code[20])
    var
        Pallet: Record Pallet;
        Lot: Record "Lot No. Information";
        PalletEntry: Record "Pallet Ledger Entry";
        ExpeOTS: Record "Transfer Shipment Header";
    begin
        Pallet.Get(SSCCNo);
        if (CopyStr(Pallet."Bin code", 1, 4) = 'PROD') and (Pallet."Location code" = 'EC TOURNAI') then begin
            ValidatePaletteProduction(SSCCNo);

            TftFromTournaiToCongel(SSCCNo, Pallet."Quantite reception");
        end
        else begin
            Pallet.CalcFields("Current Quantity");
            if Pallet."Current Quantity" = 0 then begin
                PalletEntry.Reset;
                PalletEntry.SetRange("SSCC No.", SSCCNo);
                if PalletEntry.FindLast then begin
                    if (PalletEntry."Entry Type" = PalletEntry."Entry Type"::Transfer) and (PalletEntry.Quantity < 0) then begin
                        if ExpeOTS.Get(PalletEntry."Document No.") then
                            // IF ExpeOTS."Transfer-to Code" = 'EC TOURNAI' THEN
                            //   TftFromTournaiToCongel(SSCCNo,ABS(PalletEntry.Quantity));
                            TftFromLocationToCongel(SSCCNo, Abs(PalletEntry.Quantity), ExpeOTS."Transfer-to Code");
                    end
                    else begin
                        Error('Palette %1 impossible à enloger en %2 : Quantité à 0.', SSCCNo, NewBin);
                    end;
                end;
            end;
        end;

        if ((Pallet."Item No." = '5-FRS-80400') or (Pallet."Item No." = '5-FRS-80404') or (Pallet."Item No." = '5-FRS-80401') or (Pallet."Item No." = '5-FRS-80000') or (Pallet."Item No." = '5-FRS-80407')) and (Pallet."Location code" = 'EC TOURNAI') then begin
            TftFromTournaiToCongel(SSCCNo, Pallet."Quantite reception");
            PalletEntry.Reset;
            PalletEntry.SetRange("SSCC No.", SSCCNo);
            PalletEntry.SetRange("Location Code", 'EC TOURNAI');
            if PalletEntry.FindLast then begin
                PalletEntry.Quantity := 0;
                PalletEntry.Modify;
            end;
        end;

        if Pallet.ABloquer then begin
            Lot.Reset;
            Lot.SetRange("Item No.", Pallet."Item No.");
            Lot.SetRange("Lot No.", Pallet."Lot No.");
            if Lot.FindFirst then begin
                Lot.Blocked := true;
                Lot."Commentaire blocage" := Pallet.Comment;
                Lot.Modify;
            end;
            Pallet.Get(SSCCNo);
            Pallet.ABloquer := false;
            Pallet.Modify;
        end;

        scanMgmt.PutAwayPalletWithUser(SSCCNo, NewBin, User);
    end;

    procedure AddPickingPallet(SSCC: Code[20]; OrderNo: Code[20]; LineNo: Integer; Qty: Decimal)
    begin
        scanMgmt.AddPickingPallet(SSCC, OrderNo, LineNo, Qty);
    end;

    procedure AddPickingPalletWithUserReserv(SSCC: Code[20]; OrderNo: Code[20]; LineNo: Integer; Qty: Decimal; User: Code[20])
    begin
        AddPickingPalletWithUserReservPrint(SSCC, OrderNo, LineNo, Qty, User, '');
    end;

    procedure AddPickingPalletWithUserReservPrint(SSCC: Code[20]; OrderNo: Code[20]; LineNo: Integer; Qty: Decimal; User: Code[20]; Printer: Code[20])
    var
        Pallet: Record Pallet;
        Reserv: Record "Reservation Entry";
        NextSeq: Integer;
        OrderMgt: Boolean;
        TransMgt: Boolean;
        SalesHeader: Record "Sales Header";
        TransHeader: Record "Transfer Header";
    begin
        // Si reserv existe => Add Qty
        // sinon créer reserv

        OrderMgt := false;
        TransMgt := false;

        if SalesHeader.Get(SalesHeader."Document Type"::Order, OrderNo) then OrderMgt := true;
        if TransHeader.Get(OrderNo) then TransMgt := true;


        Pallet.Get(SSCC);
        scanMgmt.AddPickingPalletWithUserPrinter(SSCC, OrderNo, LineNo, Qty, User, Printer);
    end;

    procedure AddPickingPalletWithUser(SSCC: Code[20]; OrderNo: Code[20]; LineNo: Integer; Qty: Decimal; User: Code[50])
    begin
        scanMgmt.AddPickingPalletWithUserPrinter(SSCC, OrderNo, LineNo, Qty, CopyStr(User, 1, 20), '');
    end;

    procedure AddPickingPalletWithUserPrint(SSCC: Code[20]; OrderNo: Code[20]; LineNo: Integer; Qty: Decimal; User: Code[20]; Printer: Code[20])
    begin
        scanMgmt.AddPickingPalletWithUserPrinter(SSCC, OrderNo, LineNo, Qty, User, Printer);
    end;

    procedure ValidatePicking(OrderNo: Code[20])
    var
        RecSalesHeader_g: Record "Sales Header";
        TransHeader: Record "Transfer Header";
        OTS_Ship: Codeunit "TransferOrder-Post Shipment";
    begin
        ValidatePickingWithUser(OrderNo, '');
    end;

    procedure ValidatePickingWithUser(OrderNo: Code[20]; User: Code[20])
    var
        RecSalesHeader_g: Record "Sales Header";
        TransHeader: Record "Transfer Header";
        OTS_Ship: Codeunit "TransferOrder-Post Shipment";
        OTS_Rcpt: Codeunit "TransferOrder-Post Receipt";
    begin
        if RecSalesHeader_g.Get(RecSalesHeader_g."Document Type"::Order, OrderNo) then
            scanMgmt.ValidateSalesShipWithUser(RecSalesHeader_g, User);
        if TransHeader.Get(OrderNo) then begin
            scanMgmt.ValidateTransShipWithUser(TransHeader, User);
            OTS_Ship.Run(TransHeader);
            if TransHeader.Departement = 'IQF' then
                OTS_Rcpt.Run(TransHeader);
        end;
    end;

    procedure ValidatePurchOrder(Cmd: Code[20]; ExpectedReceiptDt: Date; Magasin: Code[20]) ReceiptNo: Code[20]
    var
        recReserv: Record "Reservation Entry";
        LastLot: Code[50];
        NextSeq: Integer;
        CmdL: Record "Purchase Line";
        Location: Record Location;
        PalletJnl: Record "Pallet Journal";
        NextEntry_l: Integer;
        Qty: Decimal;
        CmdH: Record "Purchase Header";
        MakeOTS: Boolean;
        recReceiptL: Record "Purch. Rcpt. Line";
        Questions: Record Questions;
        Quai: Code[20];
        LastLocation: Code[20];
        CmdL2: Record "Purchase Line";
        ReleasePurchDoc: Codeunit "Release Purchase Document";
    begin
        CmdH.Reset;
        if CmdH.Get(CmdH."Document Type"::Order, Cmd) then
            if CmdH.Status = CmdH.Status::Released then
                ReleasePurchDoc.PerformManualReopen(CmdH);

        MakeOTS := true;
        Magasin := '';

        CmdL.Reset;
        CmdL.SetRange("Document No.", Cmd);
        CmdL.SetRange("Expected Receipt Date", ExpectedReceiptDt);
        recPalletIn.Reset;

        LastLocation := '';
        if CmdL.FindSet then
            repeat
                if CmdL."Location Code" = 'MP' then begin
                    CmdL."Location Code" := 'EC TOURNAI';
                    CmdL.Modify(false);
                end;
                if CmdL."Location Code" <> '' then begin
                    if LastLocation = '' then LastLocation := CmdL."Location Code";
                    if LastLocation <> CmdL."Location Code" then Error('Commande prévue sur 2 magasins différents !');
                end;
            until CmdL.Next = 0;

        Magasin := LastLocation;
        MakeOTS := false;

        if (LastLocation = 'ECCONGEL') or (LastLocation = 'SB-DDP') then begin
            Magasin := 'ECCONGEL';
            MakeOTS := false;
        end;

        if Magasin = '' then Error('Pas de magasin sur la commande');

        PalletJnl.Reset;
        PalletJnl.SetRange("Journal Template Name", Cmd);
        PalletJnl.SetRange("Journal Batch Name", '');
        PalletJnl.DeleteAll;


        CmdL.Reset;
        CmdL.SetRange("Document No.", Cmd);
        CmdL.SetRange("Expected Receipt Date", ExpectedReceiptDt);
        if CmdL.FindSet then
            repeat
                Qty := 0;
                Location.Get(Magasin);
                recReserv.LockTable;
                LastLot := '';

                recPalletIn.SetCurrentKey("Inbound Document No.", "Inbound Doc. Line No.", "Lot No.");
                recPalletIn.SetRange("Inbound Document No.", Cmd);
                recPalletIn.SetRange("Inbound Doc. Line No.", CmdL."Line No.");
                recPalletIn.SetRange("Last Entry No.", 0);
                if recPalletIn.FindSet then
                    repeat
                        recPalletIn."Location code" := Magasin;
                        recPalletIn.Modify;
                        Quai := recPalletIn."Quai reception";
                        recPalletIn.Mark(true);
                        if recPalletIn."Lot No." <> '' then begin
                            if (LastLot <> recPalletIn."Lot No.") then begin
                                LastLot := recPalletIn."Lot No.";
                                recReserv.Reset;
                                if recReserv.FindLast then NextSeq := recReserv."Entry No." + 1;
                                recReserv.Reset;
                                recReserv.Init;
                                recReserv."Entry No." := NextSeq;
                                recReserv.Positive := true;
                                recReserv."Item No." := recPalletIn."Item No.";
                                recReserv."Location Code" := Magasin;
                                recReserv."Quantity (Base)" := 0;
                                recReserv."Source Type" := 39;
                                recReserv."Source Subtype" := 1;
                                recReserv."Source ID" := Cmd;
                                recReserv."Source Ref. No." := recPalletIn."Inbound Doc. Line No.";
                                recReserv."Expected Receipt Date" := Today;
                                recReserv."Warranty Date" := recPalletIn.DLC;
                                recReserv."Lot No." := recPalletIn."Lot No.";
                                recReserv."Item Tracking" := recReserv."Item Tracking"::"Lot No.";
                                recReserv."Reservation Status" := recReserv."Reservation Status"::Surplus;
                                recReserv."Creation Date" := WorkDate;
                                recReserv."Created By" := UserId;
                                recReserv.Insert;
                            end;
                            recReserv.Validate("Quantity (Base)", recReserv."Quantity (Base)" + recPalletIn."Quantite reception");
                            recReserv.Modify;
                        end;

                        PalletJnl.Reset;
                        PalletJnl.SetRange("Journal Template Name", Cmd);
                        PalletJnl.SetRange("Journal Batch Name", '');
                        if not PalletJnl.Find('+') then
                            NextEntry_l := 10000
                        else
                            NextEntry_l := PalletJnl.ID + 10000;

                        PalletJnl.Init;
                        PalletJnl."Journal Template Name" := Cmd;
                        PalletJnl."Journal Batch Name" := '';
                        PalletJnl."Journal Line No." := recPalletIn."Inbound Doc. Line No.";
                        PalletJnl."Document No." := Cmd;
                        PalletJnl."Document Line No." := recPalletIn."Inbound Doc. Line No.";

                        PalletJnl.ID := NextEntry_l;
                        PalletJnl."SSCC No." := recPalletIn."SSCC No.";
                        PalletJnl."Treated Quantity" := recPalletIn."Quantite reception";
                        PalletJnl."Reservation Entry" := recReserv."Entry No.";
                        PalletJnl."Lot No." := recPalletIn."Lot No.";
                        PalletJnl.Insert;
                        Qty += recPalletIn."Quantite reception";
                    until recPalletIn.Next = 0;
                CmdL2.Get(CmdL."Document Type", CmdL."Document No.", CmdL."Line No.");
                CmdL2."Location Code" := Magasin;
                CmdL2."Bin Code" := Location."Default Recept. bin";
                CmdL2.Validate("Qty. to Receive", Qty);
                CmdL2.Modify;
            until CmdL.Next = 0;
        //ERROR('ok1');

        CmdL.Reset;
        CmdL.SetRange("Document Type", CmdL."Document Type"::Order);
        CmdL.SetRange("Document No.", Cmd);
        CmdL.SetFilter("Expected Receipt Date", '<>%1', ExpectedReceiptDt);
        if CmdL.FindSet then
            repeat
                CmdL.Validate("Qty. to Receive", 0);
                CmdL.Modify;
            until CmdL.Next = 0;

        CmdH.Get(CmdH."Document Type"::Order, Cmd);
        CmdH.SetHideValidationDialog(true);
        CmdH.Validate("Posting Date", Today);
        CmdH.Receive := true;
        if (CmdH."Status Visa" = CmdH."Status Visa"::"On standby visa ") then begin
            CmdH."Status Visa" := CmdH."Status Visa"::"Visa authorized";
            CmdH."Person in charge Visa" := 'SCAN';
            CmdH."Date Visa" := Today;
        end;
        CmdH.Modify;
        CODEUNIT.Run(CODEUNIT::"Purch.-Post", CmdH);
        if MakeOTS then
            MakeOTSFromPurchOrder(Cmd, ExpectedReceiptDt, Magasin);


        CmdL.Reset;
        CmdL.SetRange("Document Type", CmdL."Document Type"::Order);
        CmdL.SetRange("Document No.", Cmd);
        if CmdL.FindSet then
            repeat
                CmdL."Location Code" := LastLocation;
                CmdL.Modify;
            until CmdL.Next = 0;


        ReceiptNo := '';

        recReceiptL.Reset;
        recReceiptL.SetRange(Type, recReceiptL.Type::Item);
        recReceiptL.SetRange("No.", recPalletIn."Item No.");
        recReceiptL.SetRange("Posting Date", Today);
        if recReceiptL.FindLast then
            ReceiptNo := recReceiptL."Document No.";

        Questions.Reset;
        Questions.SetRange(DocumentNo, Cmd + '_' + Format(ExpectedReceiptDt, 0, '<Year4><Month,2><Day,2>'));
        if Questions.FindFirst then
            repeat
                Questions.Rename(ReceiptNo, Questions.QuestionID);
                Questions.Modify;

            until not Questions.FindFirst;

        PrintReceipt(ReceiptNo, Quai);

        recPalletIn.Reset;
        recPalletIn.SetRange("Inbound Document No.", Cmd);
        recPalletIn.ModifyAll("Inbound Document No.", Cmd + 'OK');
    end;

    procedure MakeOTSFromPurchOrder(Cmd: Code[20]; ExpectedReceiptDt: Date; Magasin: Code[20])
    var
        recReserv: Record "Reservation Entry";
        LastLot: Code[20];
        NextSeq: Integer;
        CmdL: Record "Purchase Line";
        Location: Record Location;
        PalletJnl: Record "Pallet Journal";
        NextEntry_l: Integer;
        Qty: Decimal;
        CmdH: Record "Purchase Header";
        MakeOTS: Boolean;
        TftH: Record "Transfer Header";
        TftL: Record "Transfer Line";
        recReservOTS: Record "Reservation Entry";
        recReservOTS2: Record "Reservation Entry";
        TransferPostShipment: Codeunit "TransferOrder-Post Shipment";
        TransferPostReceipt: Codeunit "TransferOrder-Post Receipt";
    begin

        TftH.Reset;
        TftH.Init;
        TftH.Insert(true);
        TftH.Validate("Transfer-from Code", Magasin);
        TftH.Validate("Transfer-to Code", 'EC TOURNAI');
        TftH.Validate("In-Transit Code", '9-TFT');
        TftH.Modify(true);

        CmdL.Reset;
        CmdL.SetRange("Document No.", Cmd);
        CmdL.SetRange("Expected Receipt Date", ExpectedReceiptDt);

        if CmdL.FindSet then
            repeat
                TftL.Reset;
                TftL.Init;
                TftL."Document No." := TftH."No.";
                TftL."Line No." := CmdL."Line No.";
                TftL.Validate("Item No.", CmdL."No.");
                Location.Get(Magasin);
                TftL."Transfer-from Bin Code" := Location."Default Recept. bin";
                TftL.Insert(true);
                TftL."Transfer-from Bin Code" := Location."Default Recept. bin";
                TftL.Modify;

                Qty := 0;
                recReserv.LockTable;
                LastLot := '';
                recPalletIn.SetCurrentKey("Inbound Document No.", "Inbound Doc. Line No.", "Lot No.");
                recPalletIn.SetRange("Inbound Document No.");
                recPalletIn.SetRange("Last Entry No.");
                recPalletIn.SetRange("Inbound Doc. Line No.", CmdL."Line No.");
                recPalletIn.MarkedOnly(true);

                if recPalletIn.FindSet then
                    repeat
                        if recPalletIn."Lot No." <> '' then begin
                            if (LastLot <> recPalletIn."Lot No.") then begin
                                LastLot := recPalletIn."Lot No.";
                                recReservOTS.Reset;
                                if recReservOTS.FindLast then NextSeq := recReservOTS."Entry No." + 1;
                                recReservOTS.Reset;
                                recReservOTS.Init;
                                recReservOTS."Entry No." := NextSeq;
                                recReservOTS.Positive := false;
                                recReservOTS."Item No." := recPalletIn."Item No.";
                                recReservOTS."Location Code" := Magasin;
                                recReservOTS."Quantity (Base)" := 0;
                                recReservOTS."Source Type" := 5741;
                                recReservOTS."Source Subtype" := 0;
                                recReservOTS."Source ID" := TftH."No.";
                                recReservOTS."Source Ref. No." := TftL."Line No.";

                                recReservOTS."Shipment Date" := Today;
                                recReservOTS."Warranty Date" := recPalletIn.DLC;
                                recReservOTS."Lot No." := recPalletIn."Lot No.";
                                recReservOTS."Item Tracking" := recReservOTS."Item Tracking"::"Lot No.";
                                recReservOTS."Reservation Status" := recReservOTS."Reservation Status"::Surplus;
                                recReservOTS."Creation Date" := WorkDate;
                                recReservOTS."Created By" := UserId;
                                recReservOTS.Insert;

                                recReservOTS2.Reset;
                                if recReservOTS2.FindLast then NextSeq := recReservOTS2."Entry No." + 1;
                                recReservOTS2.Reset;
                                recReservOTS2.Init;
                                recReservOTS2."Entry No." := NextSeq;
                                recReservOTS2.Positive := true;
                                recReservOTS2."Item No." := recPalletIn."Item No.";
                                recReservOTS2."Location Code" := TftH."Transfer-to Code";
                                recReservOTS2."Quantity (Base)" := 0;
                                recReservOTS2."Source Type" := 5741;
                                recReservOTS2."Source Subtype" := 1;
                                recReservOTS2."Source ID" := TftH."No.";
                                recReservOTS2."Source Ref. No." := TftL."Line No.";
                                recReservOTS2."Expected Receipt Date" := Today;
                                recReservOTS2."Warranty Date" := recPalletIn.DLC;
                                recReservOTS2."Lot No." := recPalletIn."Lot No.";
                                recReservOTS2."Item Tracking" := recReservOTS2."Item Tracking"::"Lot No.";
                                recReservOTS2."Reservation Status" := recReservOTS2."Reservation Status"::Surplus;
                                recReservOTS2."Creation Date" := WorkDate;
                                recReservOTS2."Created By" := UserId;
                                recReservOTS2.Insert;
                            end;
                            recReservOTS.Validate("Quantity (Base)", recReservOTS."Quantity (Base)" - recPalletIn."Quantite reception");
                            recReservOTS.Modify;
                            recReservOTS2.Validate("Quantity (Base)", recReservOTS2."Quantity (Base)" + recPalletIn."Quantite reception");
                            recReservOTS2.Modify;
                        end;
                        Qty += recPalletIn."Quantite reception";
                        scanMgmt.AddPickingPallet(recPalletIn."SSCC No.", TftH."No.", TftL."Line No.", recPalletIn."Quantite reception");
                    until recPalletIn.Next = 0;
                if Qty = 0 then begin
                    TftL.Delete;
                end
                else begin
                    TftL.Validate(Quantity, Qty);
                    TftL.Modify(true);
                end;
            until CmdL.Next = 0;

        scanMgmt.ValidateTransShip(TftH);
        TransferPostShipment.Run(TftH);
        TransferPostReceipt.Run(TftH);
    end;

    procedure PrintLabelOnPrinter(SSCCNo: Code[20]; Printer: Code[20])
    var
        StreamWriter: DotNet StreamWriter;
        TcpClient: DotNet TcpClient;
        Encoding: DotNet Encoding;
        Pallet: Record Pallet;
        i: Integer;
        Items: Record Item;
        recOF: Record "Production Order";
    begin

        Pallet.Get(SSCCNo);
        Pallet."Quai reception" := Printer;
        Pallet.Modify;

        PrintLabel(SSCCNo);
    end;

    procedure PrintLabel(SSCCNo: Code[20])
    var
        StreamWriter: DotNet StreamWriter;
        TcpClient: DotNet TcpClient;
        Encoding: DotNet Encoding;
        Pallet: Record Pallet;
        i: Integer;
        Items: Record Item;
        recOF: Record "Production Order";
        rTello: Report "Fiche palette exp+lotTELLO";
    begin
        Pallet.Get(SSCCNo);

        if (Pallet."Item No." = '1-FSV-00426') then begin
            Pallet.SetFilter("SSCC No.", SSCCNo);
            rTello.SetTableView(Pallet);
            rTello.setTempRec(Pallet, Pallet."Outbound Document No.");
            rTello.UseRequestPage := false;
            rTello.Print('', 'PRINTER_' + Pallet."Quai reception");
            exit;
        end;

        if Pallet."Quai reception" = '2200000000187' then begin
            PrintLabel2(SSCCNo);
            exit;
        end;
        if Pallet."Quai reception" = '2200000000293' then begin
            PrintLabel150(SSCCNo);
            exit;
        end;
        if Pallet."Quai reception" = '2200000000279' then begin
            PrintLabel150(SSCCNo);
            exit;
        end;
        if Pallet."Quai reception" = '2200000000286' then begin
            PrintLabel150(SSCCNo);
            exit;
        end;

        if Pallet."Quai reception" <> '' then begin
            Params.SetRange("Table No", 50018);
            Params.SetRange("Field No", 55009);
            Params.SetRange(Code, 'PRINT_' + Pallet."Quai reception");
            if not Params.FindFirst then Error('Imprimante non trouvée ' + 'PRINT_' + Pallet."Quai reception");

            //PrintReceipt('REA-E18-03689',Pallet."Quai reception");



            TcpClient := TcpClient.TcpClient();
            TcpClient.Connect(Params.Description, 9100);

            // Create instance of StreamWriter class and set Encoding
            StreamWriter := StreamWriter.StreamWriter(TcpClient.GetStream(), Encoding.UTF8);

            StreamWriter.WriteLine('^XA');
            StreamWriter.WriteLine('^PW832');
            StreamWriter.WriteLine('^PON^PMN^LH0,0^JMA^LRN');

            for i := 0 to 5 do begin
                StreamWriter.WriteLine('^BY2,2,48^FT35,' + Format(675 + i * 100) + '^B3N,N,,Y,N');
                StreamWriter.WriteLine('^FD' + Pallet."SSCC No." + '^FS');
                StreamWriter.WriteLine('^FT410,' + Format(650 + i * 100) + '^ACN,18,10^FH\^FD' + Pallet."Item No." + '^FS');
                StreamWriter.WriteLine('^FT550,' + Format(650 + i * 100) + '^ACN,18,10^FH\^FDDLC ' +
                Format(Pallet.DLC, 0, '<Day,2>/<Month,2>/<Year4>') + '^FS');
                StreamWriter.WriteLine('^FT410,' + Format(680 + i * 100) + '^ACN,16,10^FH\^FDQté ' + Format(Pallet."Quantite reception") + '^FS');
                StreamWriter.WriteLine('^FT520,' + Format(680 + i * 100) + '^ACN,14,10^FH\^FDLot ' + Pallet."Lot No." + '^FS');
            end;


            StreamWriter.WriteLine('^BY3,3,120^FT50,190^B3N,N,,Y,N');
            StreamWriter.WriteLine('^FD' + Pallet."SSCC No." + '^FS');

            Pallet.CalcFields("Item Description");

            StreamWriter.WriteLine('^FT25,280^ACN,36,20^FH\^FD' + Pallet."Item Description" + '^FS');
            StreamWriter.WriteLine('^FT25,380^ADN,95,20^FH\^FD' + Pallet."Item No." + '^FS');

            if (recOF.Get(recOF.Status::Released, Pallet."Inbound Document No.")) then
                if (recOF.Ordre <> '') then
                    StreamWriter.WriteLine('^FT620,340^ADN,36,20^FH\^FD' + recOF.Ordre + '^FS');

            if (Pallet."Outbound Document No." <> '') then
                StreamWriter.WriteLine('^FT400,340^ADN,36,20^FH\^FD' + Pallet."Outbound Document No." + '^FS');

            StreamWriter.WriteLine('^FT40,440^ACN,36,20^FH\^FDLot^FS');
            StreamWriter.WriteLine('^FT150,440^ACN,36,20^FH\^FD' + Pallet."Lot No." + '^FS');
            StreamWriter.WriteLine('^FT40,490^ACN,36,20^FH\^FDDLC^FS');
            StreamWriter.WriteLine('^FT380,490^ACN,36,10^FH\^FD' + Format(Pallet.DLC, 0, '<Day,2>/<Month,2>/<Year4>') + '^FS');
            if Pallet."Quantite reception" > 0 then begin
                StreamWriter.WriteLine('^FT40,540^ACN,36,20^FH\^FDPoids^FS');
                if Items.Get(Pallet."Item No.") then
                    StreamWriter.WriteLine('^FT380,540^ACN,36,10^FH\^FD' + Format(Pallet."Quantite reception") + ' ' + Items."Base Unit of Measure" + '^FS')
                else
                    StreamWriter.WriteLine('^FT380,520^ACN,36,10^FH\^FD' + Format(Pallet."Quantite reception") + ' Kg^FS');
            end
            else begin
                StreamWriter.WriteLine('^FT40,520^ACN,36,20^FH\^FDRef^FS');
                StreamWriter.WriteLine('^FT380,520^ACN,36,10^FH\^FD' + Pallet.NumOF + '^FS')
            end;



            StreamWriter.WriteLine('^FT40,580^ACN,36,20^FH\^FDDate d''entrée^FS');
            StreamWriter.WriteLine('^FT380,580^ACN,36,10^FH\^FD' + Format(Pallet."Creation Date", 0, '<Day,2>/<Month,2>/<Year4>') + '^FS');

            StreamWriter.WriteLine('^FT620,580^ACN,36,10^FH\^FD' + 'BE B102454 CE' + '^FS');


            StreamWriter.WriteLine('^PQ1,0,1,Y^XZ');


            StreamWriter.Close();
            TcpClient.Close();
        end;
    end;

    procedure PrintLabelEpices(SSCCNo: Code[20])
    var
        StreamWriter: DotNet StreamWriter;
        TcpClient: DotNet TcpClient;
        Encoding: DotNet Encoding;
        Pallet: Record Pallet;
        i: Integer;
        Items: Record Item;
        recOF: Record "Production Order";
    begin

        //PrintReceipt('REA-E18-03600','');

        Pallet.Get(SSCCNo);
        Params.SetRange("Table No", 50018);
        Params.SetRange("Field No", 55009);
        Params.SetRange(Code, 'PRINT_' + Pallet."Quai reception");
        if not Params.FindFirst then Error('Imprimante non trouvée ' + 'PRINT_' + Pallet."Quai reception");

        //PrintReceipt('REA-E18-03689',Pallet."Quai reception");



        TcpClient := TcpClient.TcpClient();
        TcpClient.Connect(Params.Description, 9100);

        // Create instance of StreamWriter class and set Encoding
        StreamWriter := StreamWriter.StreamWriter(TcpClient.GetStream(), Encoding.UTF8);

        StreamWriter.WriteLine('^XA');
        StreamWriter.WriteLine('^PON^PMN^LH0,0^JMA^LRN');

        for i := 0 to 5 do begin
            StreamWriter.WriteLine('^BY2,2,48^FT15,' + Format(675 + i * 100) + '^B3N,N,,Y,N');
            StreamWriter.WriteLine('^FD' + Pallet."SSCC No." + '^FS');
            StreamWriter.WriteLine('^FT390,' + Format(640 + i * 100) + '^ACN,18,10^FH\^FD' + Pallet."Item No." + '^FS');
            StreamWriter.WriteLine('^FT550,' + Format(640 + i * 100) + '^ACN,18,10^FH\^FDDLC ' +
            Format(Pallet.DLC, 0, '<Day,2>/<Month,2>/<Year4>') + '^FS');
            StreamWriter.WriteLine('^FT390,' + Format(670 + i * 100) + '^ACN,16,10^FH\^FDQté ' + Format(Pallet."Quantite reception") + '^FS');
            StreamWriter.WriteLine('^FT520,' + Format(670 + i * 100) + '^ACN,16,10^FH\^FDLot ' + Pallet."Lot No." + '^FS');
            StreamWriter.WriteLine('^FT390,' + Format(700 + i * 100) + '^ACN,16,10^FH\^FDOF ' + Pallet.NumOF + '^FS');
        end;


        StreamWriter.WriteLine('^BY3,3,120^FT50,190^B3N,N,,Y,N');
        StreamWriter.WriteLine('^FD' + Pallet."SSCC No." + '^FS');

        Pallet.CalcFields("Item Description");
        StreamWriter.WriteLine('^FT25,280^ACN,36,20^FH\^FD' + Pallet."Item Description" + '^FS');
        StreamWriter.WriteLine('^FT40,400^ACN,36,20^FH\^FDLot^FS');
        StreamWriter.WriteLine('^FT150,400^ACN,36,20^FH\^FD' + Pallet."Lot No." + '^FS');
        StreamWriter.WriteLine('^FT40,460^ACN,36,20^FH\^FDDLC^FS');

        recOF.SetRange("No.", Pallet.NumOF);
        if recOF.FindFirst then begin
            StreamWriter.WriteLine('^FT25,340^ADN,36,20^FH\^FD' + Pallet."Item No." + '  ->  ' + recOF."Source No." + '^FS');
            //StreamWriter.WriteLine('^FT40,580^ACN,30,10^FH\^FD'+Pallet.NumOF + ' ' + FORMAT(recOF."Starting Date") + ' ' + recOF."Search Description"+'^FS');
            StreamWriter.WriteLine('^FT40,580^ACN,34,20^FH\^FD' + Pallet.NumOF + '^FS');
            StreamWriter.WriteLine('^FT325,580^ACN,34,10^FH\^FD' + Format(recOF."Starting Date") + ' ' + recOF."Search Description" + '^FS');
        end;
        StreamWriter.WriteLine('^FT380,460^ACN,36,10^FH\^FD' + Format(Pallet.DLC, 0, '<Day,2>/<Month,2>/<Year4>') + '^FS');
        if Pallet."Quantite reception" > 0 then begin
            StreamWriter.WriteLine('^FT40,520^ACN,36,20^FH\^FDPoids^FS');
            if Items.Get(Pallet."Item No.") then
                StreamWriter.WriteLine('^FT380,520^ACN,36,10^FH\^FD' + Format(Pallet."Quantite reception") + ' ' + Items."Base Unit of Measure" + '^FS')
            else
                StreamWriter.WriteLine('^FT380,520^ACN,36,10^FH\^FD' + Format(Pallet."Quantite reception") + ' Kg^FS');
        end
        else begin
            StreamWriter.WriteLine('^FT40,520^ACN,36,20^FH\^FDRef^FS');
            StreamWriter.WriteLine('^FT380,520^ACN,36,10^FH\^FD' + Pallet.NumOF + '^FS')
        end;



        StreamWriter.WriteLine('^PQ1,0,1,Y^XZ');


        StreamWriter.Close();
        TcpClient.Close();
    end;

    procedure PrintLabelCongel(SSCCNo: Code[20]; Printer: Code[20])
    var
        StreamWriter: DotNet StreamWriter;
        TcpClient: DotNet TcpClient;
        Encoding: DotNet Encoding;
        Pallet: Record Pallet;
        i: Integer;
        Items: Record Item;
    begin



        Pallet.Get(SSCCNo);
        Pallet.CalcFields("Item Description");
        Pallet.CalcFields("Current Quantity");
        Params.SetRange("Table No", 50018);
        Params.SetRange("Field No", 55009);
        Params.SetRange(Code, 'PRINT_' + Printer);
        if not Params.FindFirst then Error('Imprimante non trouvée ' + 'PRINT_' + Printer);


        TcpClient := TcpClient.TcpClient();
        TcpClient.Connect(Params.Description, 9100);

        // Create instance of StreamWriter class and set Encoding
        StreamWriter := StreamWriter.StreamWriter(TcpClient.GetStream(), Encoding.UTF8);

        StreamWriter.WriteLine('^XA');
        StreamWriter.WriteLine('^PON^PMN^LH0,0^JMA^LRN');


        StreamWriter.WriteLine('^BY4,3,205^FT578,55^B3R,N,,Y,N^FD' + Pallet."SSCC No." + '^FS');
        StreamWriter.WriteLine('^FT433,41^A0R,54,55^FH\^FDItem No.^FS');
        StreamWriter.WriteLine('^FT433,370^A0R,54,55^FH\^FD' + Pallet."Item No." + '^FS');
        StreamWriter.WriteLine('^FT355,42^A0R,54,55^FH\^FD' + Pallet."Item Description" + '^FS');
        StreamWriter.WriteLine('^FT275,41^A0R,54,55^FH\^FDLot No.^FS');
        StreamWriter.WriteLine('^FT275,370^A0R,54,55^FH\^FD' + Pallet."Lot No." + '^FS');
        StreamWriter.WriteLine('^FT200,41^A0R,54,55^FH\^FDDate garantie^FS');
        StreamWriter.WriteLine('^FT200,370^A0R,54,55^FH\^FD' + Format(Pallet.DLC, 0, '<Day,2>/<Month,2>/<Year4>') + '^FS');
        StreamWriter.WriteLine('^FT200,773^A0R,54,55^FH\^FD' + Format(Pallet."Current Quantity") + ' Kg^FS');
        StreamWriter.WriteLine('^FT115,42^A0R,54,55^FH\^FDDoc. Entrée^FS');
        StreamWriter.WriteLine('^FT115,370^A0R,54,55^FH\^FD' + Pallet."Inbound Document No." + '    ' + Format(Pallet."Creation Date", 0, '<Day,2>/<Month,2>/<Year4>') + '^FS');

        StreamWriter.WriteLine('^PQ1,0,1,Y^XZ');


        StreamWriter.Close();
        TcpClient.Close();
    end;

    procedure PrintReceipt(Receive: Code[20]; Quai: Code[20])
    var
        Receipt: Record "Purch. Rcpt. Header";
        ReceiptL: Record "Purch. Rcpt. Line";
        l: Integer;
        StreamWriter: DotNet StreamWriter;
        TcpClient: DotNet TcpClient;
        Encoding: DotNet Encoding;
        PalletLedg: Record "Pallet Ledger Entry";
    begin

        Params.SetRange("Table No", 50018);
        Params.SetRange("Field No", 55009);
        Params.SetRange(Code, 'PRINT_' + Quai);
        if not Params.FindFirst then Error('Imprimante non trouvée');

        TcpClient := TcpClient.TcpClient();
        TcpClient.Connect(Params.Description, 9100);

        StreamWriter := StreamWriter.StreamWriter(TcpClient.GetStream(), Encoding.UTF8);

        StreamWriter.WriteLine('^XA');
        StreamWriter.WriteLine('^PON^PMN^LH0,0^JMA^LRN');

        Receipt.Get(Receive);

        StreamWriter.WriteLine('^FT50,75^ACN,36,0^FH\^FD ' + Receipt."No." + '^FS');
        StreamWriter.WriteLine('^FT50,125^ACN,36,0^FH\^FD ' + Receipt."Order No." + '^FS');
        StreamWriter.WriteLine('^FT50,175^ACN,36,0^FH\^FD BL ' + Receipt."Vendor Shipment No." + '^FS');
        StreamWriter.WriteLine('^FT500,75^ACN,36,0^FH\^FD ' + Format(Receipt."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>') + '^FS');
        StreamWriter.WriteLine('^FT50,225^AFN,30,0^FH\^FD ' + Receipt."Buy-from Vendor No." + ' ' + Receipt."Buy-from Vendor Name" + '^FS');


        l := 275;
        ReceiptL.Reset;
        ReceiptL.SetRange("Document No.", Receive);
        ReceiptL.SetFilter(Quantity, '>0');
        if ReceiptL.FindSet then
            repeat
                if l < 900 then begin
                    StreamWriter.WriteLine('^FT50,' + Format(l) + '^ACN,24,0^FH\^FD ' + ReceiptL."No." + '^FS');
                    StreamWriter.WriteLine('^FT200,' + Format(l) + '^ACN,24,0^FH\^FD ' + ReceiptL.Description + '^FS');
                    StreamWriter.WriteLine('^FT100,' + Format(l + 30) + '^ACN,24,0^FH\^FD ' + Format(ReceiptL.Quantity) + ' ' +
                       ReceiptL."Unit of Measure" + '^FS');
                    PalletLedg.Reset;
                    PalletLedg.SetRange("Document No.", Receive);
                    PalletLedg.SetRange("Item No.", ReceiptL."No.");
                    StreamWriter.WriteLine('^FT400,' + Format(l + 30) + '^ACN,24,0^FH\^FD ' + Format(PalletLedg.Count) + ' palettes^FS');
                end;
                l := l + 75;
            until ReceiptL.Next = 0;

        StreamWriter.WriteLine('^PQ1,0,1,Y^XZ');



        StreamWriter.Close();
        TcpClient.Close();
    end;

    procedure PrintFichePaletteProduction(SSCC: Code[20]; Printer: Text[30])
    var
        Pallet: Record Pallet;
        PrinterSelect: Record "Printer Selection";
        Utils: Codeunit Utils;
        FileName: Text[250];
        SessionId: Integer;
    begin
        if StrPos(UpperCase(UserId), 'GEOFFREY') > 0 then begin
            Pallet.SetFilter("SSCC No.", SSCC);
            Pallet.FindFirst;
            Pallet."User reception" := Printer;
            Pallet.Modify;
            StartSession(SessionId, 50027, CompanyName, Pallet);
        end
        else begin

            PrinterSelect.Reset;
            PrinterSelect.SetRange("User ID", '');
            PrinterSelect.SetRange("Report ID", 50068);
            if PrinterSelect.FindFirst then begin
                PrinterSelect."Printer Name" := 'Fiche' + Printer;
                PrinterSelect.Modify;
            end
            else begin
                PrinterSelect.Init;
                PrinterSelect."User ID" := '';
                PrinterSelect."Report ID" := 50068;
                PrinterSelect."Printer Name" := 'Fiche' + Printer;
                PrinterSelect.Insert;
                ;

            end;
            Pallet.SetFilter("SSCC No.", SSCC);
            Pallet.FindFirst;
            FileName := '\\srvnavision\NavisionTemp\' + SSCC + '.pdf';
            REPORT.Run(50068, false, false, Pallet);
        end;




        //REPORT.SAVEASPDF(50068, FileName,Pallet);

        //Utils.StartProcess('C:\Program Files (x86)\Foxit Software\Foxit Reader\FoxitReader.exe',STRSUBSTNO('-t "%1" "%2"',
        //     FileName,'Fiche'+Printer));


        //Pallet.Printed := TRUE;
        //Pallet.MODIFY;
        //IF ERASE(FileName) THEN;
    end;

    procedure ValidatePaletteProduction(SSCC: Code[20])
    var
        Pallet: Record Pallet;
        ItemJnlLine: Record "Item Journal Line";
        T337: Record "Reservation Entry";
        NextSeq: Integer;
    begin
        Pallet.Get(SSCC);
        if Pallet."Inbound Document No." = 'OF VALIDE' then
            exit;

        ItemJnlLine.Init;
        ItemJnlLine."Journal Template Name" := 'O.F.';
        ItemJnlLine."Journal Batch Name" := Pallet."Quai reception";
        ItemJnlLine."Line No." := 100000;
        ItemJnlLine.Validate("Item No.", Pallet."Item No.");
        ItemJnlLine.Validate("Posting Date", Pallet."Creation Date");
        ItemJnlLine.Validate("Entry Type", ItemJnlLine."Entry Type"::Output);
        ItemJnlLine.Validate("Source No.", Pallet."Item No.");
        ItemJnlLine.Validate("Document No.", Pallet.NumOF);
        ItemJnlLine.Validate("Location Code", 'EC TOURNAI');
        ItemJnlLine.Validate(Quantity, Pallet."Quantite reception");
        ItemJnlLine.Validate("Source Code", 'PRODORDER');
        ItemJnlLine.Validate("Source Type", ItemJnlLine."Source Type"::Item);
        ItemJnlLine.Validate("Order Type", ItemJnlLine."Order Type"::Production);
        ItemJnlLine.Validate("Order No.", Pallet.NumOF);
        ItemJnlLine.Validate("Output Quantity", Pallet."Quantite reception");
        ItemJnlLine.Validate("Order Line No.", Pallet.LigneOF);

        ItemJnlLine.Validate(Type, ItemJnlLine.Type::"Work Center");
        ItemJnlLine."Operation No." := '10';
        ItemJnlLine.Validate("No.", 'ATELIERS');
        //ItemJnlLine.VALIDATE("Work Center No.",'ATELIERS');

        ItemJnlLine.Insert;

        T337.Reset;
        if T337.FindLast then
            NextSeq := T337."Entry No." + 1;
        T337.Init;
        T337."Entry No." := NextSeq;
        T337.Positive := true;
        T337."Item No." := Pallet."Item No.";
        T337."Location Code" := 'EC TOURNAI';
        T337.Validate("Quantity (Base)", Pallet."Quantite reception");
        T337."Reservation Status" := T337."Reservation Status"::Prospect;
        T337."Source Type" := 83;
        T337."Source Subtype" := 6;
        T337."Source ID" := 'O.F.';
        T337."Source Batch Name" := Pallet."Quai reception";
        T337."Source Ref. No." := 100000;
        T337."Warranty Date" := Pallet.DLC;
        T337."Lot No." := Pallet."Lot No.";
        T337."Item Tracking" := T337."Item Tracking"::"Lot No.";
        T337.Insert;

        CODEUNIT.Run(CODEUNIT::"Item Jnl.-Post", ItemJnlLine);

        Pallet.Get(SSCC);
        Pallet."Inbound Document No." := 'OF valide';
        Pallet."Bin code" := 'VALID_IQF';
        Pallet.Modify;
    end;

    procedure TftFromTournaiToCongel(SSCC: Code[20]; Qty: Decimal)
    var
        Pallet: Record Pallet;
        TftH: Record "Transfer Header";
        TftL: Record "Transfer Line";
        recReservOTS: Record "Reservation Entry";
        TransferPostShipment: Codeunit "TransferOrder-Post Shipment";
        TransferPostReceipt: Codeunit "TransferOrder-Post Receipt";
        NextSeq: Integer;
        PalletJnl: Record "Pallet Journal";
    begin

        Pallet.Get(SSCC);
        Pallet."Location code" := 'ECCONGEL';
        Pallet.Modify;




        TftH.Reset;
        TftH.Init;
        TftH.Insert(true);
        TftH.Validate("Transfer-from Code", 'EC TOURNAI');
        TftH.Validate("Transfer-to Code", 'ECCONGEL');
        TftH.Validate("In-Transit Code", '9-TFT');
        TftH.Auto := true;
        TftH.Modify(true);

        TftL.Reset;
        TftL.Init;
        TftL."Document No." := TftH."No.";
        TftL."Line No." := 10000;
        TftL.Validate("Item No.", Pallet."Item No.");
        TftL.Validate(Quantity, Qty);
        TftL."Transfer-To Bin Code" := 'RECPROD3';
        TftL.Insert(true);


        recReservOTS.Reset;
        if recReservOTS.FindLast then NextSeq := recReservOTS."Entry No." + 1;
        recReservOTS.Reset;
        recReservOTS.Init;
        recReservOTS."Entry No." := NextSeq;
        recReservOTS.Positive := false;
        recReservOTS."Item No." := Pallet."Item No.";
        recReservOTS."Location Code" := TftH."Transfer-from Code";
        recReservOTS."Quantity (Base)" := -Qty;
        recReservOTS."Qty. to Handle (Base)" := -Qty;
        recReservOTS."Qty. to Invoice (Base)" := -Qty;
        recReservOTS."Source Type" := 5741;
        recReservOTS."Source Subtype" := 0;
        recReservOTS."Source ID" := TftH."No.";
        recReservOTS."Source Ref. No." := TftL."Line No.";
        recReservOTS."Shipment Date" := Today;
        recReservOTS."Warranty Date" := Pallet.DLC;
        recReservOTS."Lot No." := Pallet."Lot No.";
        recReservOTS."Item Tracking" := recReservOTS."Item Tracking"::"Lot No.";
        recReservOTS."Reservation Status" := recReservOTS."Reservation Status"::Surplus;
        recReservOTS."Creation Date" := WorkDate;
        recReservOTS."Created By" := UserId;
        recReservOTS.Insert;

        TransferPostShipment.Run(TftH);

        recReservOTS.Reset;
        if recReservOTS.FindLast then NextSeq := recReservOTS."Entry No." + 1;
        recReservOTS.Reset;
        recReservOTS.Init;
        recReservOTS."Entry No." := NextSeq;
        recReservOTS.Positive := true;
        recReservOTS."Item No." := Pallet."Item No.";
        recReservOTS."Location Code" := TftH."Transfer-to Code";
        recReservOTS."Quantity (Base)" := Qty;
        recReservOTS."Qty. to Handle (Base)" := Qty;
        recReservOTS."Qty. to Invoice (Base)" := Qty;
        recReservOTS."Source Type" := 5741;
        recReservOTS."Source Subtype" := 1;
        recReservOTS."Source ID" := TftH."No.";
        recReservOTS."Source Ref. No." := 20000;
        recReservOTS."Source Prod. Order Line" := 10000;
        recReservOTS."Expected Receipt Date" := Today;
        recReservOTS."Warranty Date" := Pallet.DLC;
        recReservOTS."Lot No." := Pallet."Lot No.";
        recReservOTS."Item Tracking" := recReservOTS."Item Tracking"::"Lot No.";
        recReservOTS."Reservation Status" := recReservOTS."Reservation Status"::Surplus;
        recReservOTS."Creation Date" := WorkDate;
        recReservOTS."Created By" := UserId;
        recReservOTS.Insert;

        PalletJnl.Reset;
        PalletJnl.Init;
        PalletJnl."Journal Template Name" := TftH."No.";
        PalletJnl."Journal Line No." := 20000;
        PalletJnl."Document Line No." := 10000;
        PalletJnl.ID := 10000;
        PalletJnl."Reservation Entry" := recReservOTS."Entry No.";
        PalletJnl."SSCC No." := Pallet."SSCC No.";
        PalletJnl."Treated Quantity" := Qty;
        PalletJnl."Document No." := TftH."No.";
        PalletJnl."Lot No." := Pallet."Lot No.";
        PalletJnl."FF Lot No." := Pallet."Lot No.";
        PalletJnl.Insert;

        TransferPostReceipt.Run(TftH);
    end;

    procedure PalletInventory(SSCC: Code[20]; NewQuantity: Decimal; User: Code[20])
    var
        Pallet: Record Pallet;
        recReserv: Record "Reservation Entry";
        NextSeq: Integer;
        PalletJnl: Record "Pallet Journal";
        ItemJnl: Record "Item Journal Line";
        Items: Record Item;
        NextNo: Integer;
    begin

        Pallet.Get(SSCC);

        if Pallet."Location code" <> 'ECCONGEL' then
            Error('La palette n''est pas au congélateur');

        Pallet.CalcFields("Current Quantity");
        IF ABS(Pallet."Current Quantity" - NewQuantity) > 1500 THEN
            ERROR('Quantité impossible');

        if Pallet."Bin code" = '' then begin
            Pallet."Bin code" := 'RECPROD3';
            Pallet.Modify;
        end;


        ItemJnl.Reset;
        ItemJnl.SetRange("Journal Template Name", 'ARTICLE');
        ItemJnl.SetRange("Journal Batch Name", 'INVSCAN');
        ItemJnl.SetRange("Item No.", '');
        ItemJnl.DeleteAll;


        if (Pallet."Current Quantity" <> NewQuantity) then begin
            ItemJnl.Reset;
            ItemJnl.SetRange("Journal Template Name", 'ARTICLE');
            ItemJnl.SetRange("Journal Batch Name", 'INVSCAN');
            if ItemJnl.FindLast then
                NextNo := ItemJnl."Line No." + 10000
            else
                NextNo := 10000;


            ItemJnl.Reset;
            ItemJnl.Init;
            ItemJnl."Journal Template Name" := 'ARTICLE';
            ItemJnl."Journal Batch Name" := 'INVSCAN';
            ItemJnl."Line No." := NextNo;
            ItemJnl.Validate("Item No.", Pallet."Item No.");
            Items.Get(Pallet."Item No.");

            ItemJnl.Validate("Posting Date", Today);
            if Pallet."Current Quantity" > NewQuantity then begin
                ItemJnl."Entry Type" := ItemJnl."Entry Type"::"Negative Adjmt.";
            end
            else begin
                ItemJnl."Entry Type" := ItemJnl."Entry Type"::"Positive Adjmt.";
                ItemJnl."Unit Cost" := Items."Standard Cost";
            end;
            ItemJnl."Document No." := 'INVSCAN';
            ItemJnl."Location Code" := Pallet."Location code";
            ItemJnl."Bin Code" := Pallet."Bin code";
            ItemJnl.Validate(Quantity, Abs(Pallet."Current Quantity" - NewQuantity));

            ItemJnl.Insert(true);

            recReserv.Reset;
            if recReserv.FindLast then NextSeq := recReserv."Entry No." + 1;
            recReserv.Reset;
            recReserv.Init;
            recReserv."Entry No." := NextSeq;
            if ItemJnl."Entry Type" = ItemJnl."Entry Type"::"Positive Adjmt." then begin
                recReserv.Positive := true;
                recReserv."Source Subtype" := 2;
                recReserv."Expected Receipt Date" := Today;
            end
            else begin
                recReserv.Positive := false;
                recReserv."Source Subtype" := 3;
                recReserv."Shipment Date" := Today;
            end;
            recReserv."Item No." := Pallet."Item No.";
            recReserv."Location Code" := Pallet."Location code";
            recReserv."Quantity (Base)" := NewQuantity - Pallet."Current Quantity";
            recReserv."Qty. to Handle (Base)" := NewQuantity - Pallet."Current Quantity";
            recReserv."Qty. to Invoice (Base)" := NewQuantity - Pallet."Current Quantity";
            recReserv."Source Type" := 83;
            recReserv."Source ID" := 'ARTICLE';
            recReserv."Source Batch Name" := 'INVSCAN';
            recReserv."Source Ref. No." := 10000;
            recReserv."Warranty Date" := Pallet.DLC;
            recReserv."Lot No." := Pallet."Lot No.";
            recReserv."Item Tracking" := recReserv."Item Tracking"::"Lot No.";
            recReserv."Reservation Status" := recReserv."Reservation Status"::Surplus;
            recReserv."Creation Date" := WorkDate;
            recReserv."Created By" := UserId;
            recReserv.Insert;

            PalletJnl.Reset;
            PalletJnl.Init;
            PalletJnl."Journal Template Name" := 'ARTICLE';
            PalletJnl."Journal Batch Name" := 'INVSCAN';
            PalletJnl."Journal Line No." := 10000;
            PalletJnl."Document Line No." := 10000;
            PalletJnl.ID := 10000;
            PalletJnl."Reservation Entry" := recReserv."Entry No.";
            PalletJnl."SSCC No." := Pallet."SSCC No.";
            PalletJnl."Treated Quantity" := NewQuantity - Pallet."Current Quantity";
            PalletJnl."Document No." := 'INVSCAN';
            PalletJnl."Lot No." := Pallet."Lot No.";
            PalletJnl."FF Lot No." := Pallet."Lot No.";
            PalletJnl.User := User;
            PalletJnl.Insert;

            CODEUNIT.Run(CODEUNIT::"Item Jnl.-Post", ItemJnl);
        end;

        Pallet.Get(SSCC);
        Pallet."Dernier Inventaire" := CreateDateTime(Today, Time);
        Pallet.Modify;
    end;

    procedure ValidateTransport(No: Code[20])
    var
        purchH: Record "Purchase Header";
        ShipH: Record "Sales Shipment Header";
        pal: Record Pallet;
        Cmd: Record "Sales Header";
        i: Integer;
        Modif: Codeunit ModifTables;
        GS1Send: Codeunit "GS1 Send";
        NumExpe: Code[20];
        Vend: Record Vendor;
        Cust: Record Customer;
        FileMgt: Codeunit "File Management";
        TempBlob: codeunit "Temp Blob";
        InS: InStream;
        f: text;
    begin
        i := 1;
        //REPEAT
        //  ShipH.RESET;
        //  ShipH.SETRANGE("Ref Envoi",No+'_'+FORMAT(i));
        //UNTIL NOT purchH.FINDFIRST;
        NumExpe := No + '_' + Format(i);

        purchH.Reset;
        if (purchH.Get(purchH."Document Type"::Order, No)) then begin
            purchH.Validate("Transport validé", true);
            purchH.Modify;

            ShipH.Reset;
            ShipH.SetRange("Transport Purchase Order", No);
            if ShipH.FindSet then
                repeat
                    pal.Reset;
                    pal.SetRange("Outbound Document No.", ShipH."No.");
                    pal.SetRange(Type, pal.Type::Expedition);
                    pal.SetFilter("Quai reception", '<>''''');
                    if pal.FindFirst then begin
                        Modif.ExpedieShipment(ShipH."No.", NumExpe);
                        Cmd.Reset;
                        if Cmd.Get(Cmd."Document Type"::Order, ShipH."Order No.") then begin
                            Cmd."Camion parti" := true;
                            Cmd.Modify;
                            if Cust.Get(Cmd."Sell-to Customer No.") then begin
                                if Cust.DESADV then begin
                                    GS1Send.DESADV(ShipH, '\\srvnavision\NavisionTemp\' + ShipH."No.");
                                    if Cust."E-Mail EDI" <> '' then begin
                                        emailmsg.Create('g.dangremont@europacuisson.com', 'DESADV', 'DESADV', false);
                                        f := '\\srvnavision\NavisionTemp\' + ShipH."No.";
                                        if FileMgt.ServerFileExists(f) then begin
                                            FileMgt.BLOBImportFromServerFile(TempBlob, f);
                                            TempBlob.CreateInStream(InS);
                                            emailmsg.AddAttachment('desadv.pdf', 'application/pdf', InS);
                                        end;

                                        emailsend.Send(emailmsg, Enum::"Email Scenario"::Default);
                                    end;
                                end;
                            end;
                        end;
                    end;

                until ShipH.Next = 0;

            //Si F IFCSUM
            Vend.Get(purchH."Buy-from Vendor No.");
            if Vend.IFCSUM then begin
                GS1Send.IFCSUMFromshpt(NumExpe, '\\srvnavision\NavisionTemp\' + NumExpe, '3870503390001', '3870503390001');
                if Vend."E-Mail EDI" <> '' then begin
                    emailmsg.Create('g.dangremont@europacuisson.com;mailedi@dispam.fr;Sven.Dewaele@europacuisson.com', 'IFCSUM', 'IFCSUM', false);
                    f := '\\srvnavision\NavisionTemp\' + NumExpe;

                    if FileMgt.ServerFileExists(f) then begin
                        FileMgt.BLOBImportFromServerFile(TempBlob, f);
                        TempBlob.CreateInStream(InS);
                        emailmsg.AddAttachment('Factures a imprimer.pdf', 'application/pdf', InS);
                    end;
                    emailsend.Send(emailmsg, Enum::"Email Scenario"::Default);
                end;

                //  Vend."Repertoire Send AS2"

            end;



        end;
    end;

    procedure TftFromLocationToCongel(SSCC: Code[20]; Qty: Decimal; MagasinDepart: Code[20])
    var
        Pallet: Record Pallet;
        TftH: Record "Transfer Header";
        TftL: Record "Transfer Line";
        recReservOTS: Record "Reservation Entry";
        TransferPostShipment: Codeunit "TransferOrder-Post Shipment";
        TransferPostReceipt: Codeunit "TransferOrder-Post Receipt";
        NextSeq: Integer;
        PalletJnl: Record "Pallet Journal";
    begin

        Pallet.Get(SSCC);
        Pallet."Location code" := 'ECCONGEL';
        Pallet.Modify;


        TftH.Reset;
        TftH.Init;
        TftH.Insert(true);
        TftH.Validate("Transfer-from Code", MagasinDepart);
        TftH.Validate("Transfer-to Code", 'ECCONGEL');
        TftH.Validate("In-Transit Code", '9-TFT');
        TftH.Auto := true;
        TftH.Modify(true);

        TftL.Reset;
        TftL.Init;
        TftL."Document No." := TftH."No.";
        TftL."Line No." := 10000;
        TftL.Validate("Item No.", Pallet."Item No.");
        TftL.Validate(Quantity, Qty);
        TftL."Transfer-To Bin Code" := 'RECPROD3';
        TftL.Insert(true);


        recReservOTS.Reset;
        if recReservOTS.FindLast then NextSeq := recReservOTS."Entry No." + 1;
        recReservOTS.Reset;
        recReservOTS.Init;
        recReservOTS."Entry No." := NextSeq;
        recReservOTS.Positive := false;
        recReservOTS."Item No." := Pallet."Item No.";
        recReservOTS."Location Code" := TftH."Transfer-from Code";
        recReservOTS."Quantity (Base)" := -Qty;
        recReservOTS."Qty. to Handle (Base)" := -Qty;
        recReservOTS."Qty. to Invoice (Base)" := -Qty;
        recReservOTS."Source Type" := 5741;
        recReservOTS."Source Subtype" := 0;
        recReservOTS."Source ID" := TftH."No.";
        recReservOTS."Source Ref. No." := TftL."Line No.";
        recReservOTS."Shipment Date" := Today;
        recReservOTS."Warranty Date" := Pallet.DLC;
        recReservOTS."Lot No." := Pallet."Lot No.";
        recReservOTS."Item Tracking" := recReservOTS."Item Tracking"::"Lot No.";
        recReservOTS."Reservation Status" := recReservOTS."Reservation Status"::Surplus;
        recReservOTS."Creation Date" := WorkDate;
        recReservOTS."Created By" := UserId;
        recReservOTS.Insert;

        TransferPostShipment.Run(TftH);

        recReservOTS.Reset;
        if recReservOTS.FindLast then NextSeq := recReservOTS."Entry No." + 1;
        recReservOTS.Reset;
        recReservOTS.Init;
        recReservOTS."Entry No." := NextSeq;
        recReservOTS.Positive := true;
        recReservOTS."Item No." := Pallet."Item No.";
        recReservOTS."Location Code" := TftH."Transfer-to Code";
        recReservOTS."Quantity (Base)" := Qty;
        recReservOTS."Qty. to Handle (Base)" := Qty;
        recReservOTS."Qty. to Invoice (Base)" := Qty;
        recReservOTS."Source Type" := 5741;
        recReservOTS."Source Subtype" := 1;
        recReservOTS."Source ID" := TftH."No.";
        recReservOTS."Source Ref. No." := 20000;
        recReservOTS."Source Prod. Order Line" := 10000;
        recReservOTS."Expected Receipt Date" := Today;
        recReservOTS."Warranty Date" := Pallet.DLC;
        recReservOTS."Lot No." := Pallet."Lot No.";
        recReservOTS."Item Tracking" := recReservOTS."Item Tracking"::"Lot No.";
        recReservOTS."Reservation Status" := recReservOTS."Reservation Status"::Surplus;
        recReservOTS."Creation Date" := WorkDate;
        recReservOTS."Created By" := UserId;
        recReservOTS.Insert;

        PalletJnl.Reset;
        PalletJnl.Init;
        PalletJnl."Journal Template Name" := TftH."No.";
        PalletJnl."Journal Line No." := 20000;
        PalletJnl."Document Line No." := 10000;
        PalletJnl.ID := 10000;
        PalletJnl."Reservation Entry" := recReservOTS."Entry No.";
        PalletJnl."SSCC No." := Pallet."SSCC No.";
        PalletJnl."Treated Quantity" := Qty;
        PalletJnl."Document No." := TftH."No.";
        PalletJnl."Lot No." := Pallet."Lot No.";
        PalletJnl."FF Lot No." := Pallet."Lot No.";
        PalletJnl.Insert;

        TransferPostReceipt.Run(TftH);
    end;

    procedure TftFromCongelToLocation(SSCC: Code[20]; Qty: Decimal; MagasinArrivee: Code[20]; user: Code[50])
    var
        Pallet: Record Pallet;
        TftH: Record "Transfer Header";
        TftL: Record "Transfer Line";
        recReservOTS: Record "Reservation Entry";
        TransferPostShipment: Codeunit "TransferOrder-Post Shipment";
        TransferPostReceipt: Codeunit "TransferOrder-Post Receipt";
        NextSeq: Integer;
        PalletJnl: Record "Pallet Journal";
    begin

        Pallet.Get(SSCC);


        TftH.Reset;
        TftH.Init;
        TftH.Insert(true);
        TftH.Validate("Transfer-from Code", 'ECCONGEL');
        TftH.Validate("Transfer-to Code", MagasinArrivee);
        TftH.Validate("In-Transit Code", '9-TFT');
        TftH.Auto := true;
        TftH.Modify(true);

        TftL.Reset;
        TftL.Init;
        TftL."Document No." := TftH."No.";
        TftL."Line No." := 10000;
        TftL.Validate("Item No.", Pallet."Item No.");
        TftL.Validate(Quantity, Qty);
        TftL."Transfer-from Bin Code" := Pallet."Bin code";
        TftL.Insert(true);


        recReservOTS.Reset;
        if recReservOTS.FindLast then NextSeq := recReservOTS."Entry No." + 1;
        recReservOTS.Reset;
        recReservOTS.Init;
        recReservOTS."Entry No." := NextSeq;
        recReservOTS.Positive := false;
        recReservOTS."Item No." := Pallet."Item No.";
        recReservOTS."Location Code" := TftH."Transfer-from Code";
        recReservOTS."Quantity (Base)" := -Qty;
        recReservOTS."Qty. to Handle (Base)" := -Qty;
        recReservOTS."Qty. to Invoice (Base)" := -Qty;
        recReservOTS."Source Type" := 5741;
        recReservOTS."Source Subtype" := 0;
        recReservOTS."Source ID" := TftH."No.";
        recReservOTS."Source Ref. No." := TftL."Line No.";
        recReservOTS."Shipment Date" := Today;
        recReservOTS."Warranty Date" := Pallet.DLC;
        recReservOTS."Lot No." := Pallet."Lot No.";
        recReservOTS."Item Tracking" := recReservOTS."Item Tracking"::"Lot No.";
        recReservOTS."Reservation Status" := recReservOTS."Reservation Status"::Surplus;
        recReservOTS."Creation Date" := WorkDate;
        recReservOTS."Created By" := UserId;
        recReservOTS.Insert;

        AddPickingPalletWithUser(SSCC, TftH."No.", TftL."Line No.", Qty, user);

        TransferPostShipment.Run(TftH);

        recReservOTS.Reset;
        if recReservOTS.FindLast then NextSeq := recReservOTS."Entry No." + 1;
        recReservOTS.Reset;
        recReservOTS.Init;
        recReservOTS."Entry No." := NextSeq;
        recReservOTS.Positive := true;
        recReservOTS."Item No." := Pallet."Item No.";
        recReservOTS."Location Code" := TftH."Transfer-to Code";
        recReservOTS."Quantity (Base)" := Qty;
        recReservOTS."Qty. to Handle (Base)" := Qty;
        recReservOTS."Qty. to Invoice (Base)" := Qty;
        recReservOTS."Source Type" := 5741;
        recReservOTS."Source Subtype" := 1;
        recReservOTS."Source ID" := TftH."No.";
        recReservOTS."Source Ref. No." := 20000;
        recReservOTS."Source Prod. Order Line" := 10000;
        recReservOTS."Expected Receipt Date" := Today;
        recReservOTS."Warranty Date" := Pallet.DLC;
        recReservOTS."Lot No." := Pallet."Lot No.";
        recReservOTS."Item Tracking" := recReservOTS."Item Tracking"::"Lot No.";
        recReservOTS."Reservation Status" := recReservOTS."Reservation Status"::Surplus;
        recReservOTS."Creation Date" := WorkDate;
        recReservOTS."Created By" := UserId;
        recReservOTS.Insert;


        TransferPostReceipt.Run(TftH);

        Pallet.Get(SSCC);
        Pallet."Dernier Inventaire" := CreateDateTime(Today, Time);
        Pallet."Bin code" := MagasinArrivee;
        Pallet.Modify;
    end;

    procedure test(SSCCNo: Code[20])
    var
        StreamWriter: DotNet StreamWriter;
        TcpClient: DotNet TcpClient;
        Encoding: DotNet Encoding;
        Pallet: Record Pallet;
        i: Integer;
        Items: Record Item;
    begin



        TcpClient := TcpClient.TcpClient();
        TcpClient.Connect('192.168.4.145', 9100);

        // Create instance of StreamWriter class and set Encoding
        StreamWriter := StreamWriter.StreamWriter(TcpClient.GetStream(), Encoding.UTF8);

        StreamWriter.WriteLine('^XA');
        StreamWriter.WriteLine('^PON^PMN^LH0,0^JMA^LRN');



        StreamWriter.WriteLine('^BY1,3,30^FT35,60^B3N,N,,Y,N');
        StreamWriter.WriteLine('^FD' + SSCCNo + '^FS');


        StreamWriter.WriteLine('^FT50,120^ACN,10,10^FH\^FD' + 'FILET DE POULE MERE' + '^FS');
        //StreamWriter.WriteLine('^FT25,340^ADN,36,20^FH\^FD'+Pallet."Item No."+'^FS');
        //StreamWriter.WriteLine('^FT40,400^ACN,36,20^FH\^FDLot^FS');
        //StreamWriter.WriteLine('^FT150,400^ACN,36,20^FH\^FD'+Pallet."Lot No."+'^FS');
        //StreamWriter.WriteLine('^FT40,460^ACN,36,20^FH\^FDDLC^FS');
        //StreamWriter.WriteLine('^FT380,460^ACN,36,10^FH\^FD'+FORMAT(Pallet.DLC,0,'<Day,2>/<Month,2>/<Year4>')+'^FS');



        StreamWriter.WriteLine('^PQ1,0,1,Y^XZ');


        StreamWriter.Close();
        TcpClient.Close();
    end;

    procedure AddConsoOF(OrderNo: Code[20]; OrderLine: Integer; ItemCode: Code[20]; Qty: Decimal; LotNo: Code[50]; DLC: DateTime; LocationCode: Code[20]; Printer: Text)
    var
        Cu5510: Codeunit "Production Journal Mgt";
        ProdOrder: Record "Production Order";
        ItemJnlLine: Record "Item Journal Line";
        ReservEntry: Record "Reservation Entry";
        NextSeq: Integer;
        ItemProduit: Code[20];
        CuProd: Codeunit "Integration Tft and Prod";
        ProdOrderLine: Record "Prod. Order Line";
        NewLot: Code[50];
        NewDLC: Date;
    begin
        if (Qty < 0) then Error('La quantité ne peut pas être < 0');

        if OrderNo = '' then begin
            ProdOrder.Init;
            ProdOrder.Status := ProdOrder.Status::Released;
            ProdOrder.Insert(true);

            ProdOrder.Validate("Starting Date", Today);
            ProdOrder."Starting Date-Time" := CreateDateTime(Today, Time);
            ProdOrder.Validate("Ending Date", CalcDate('<+3D>', Today));
            ProdOrder."Ending Date-Time" := CreateDateTime(CalcDate('<+3D>', Today), Time);
            ProdOrder.Validate("Due Date", ProdOrder."Ending Date");
            ProdOrder.Validate("Quantité MP", Qty);
            ProdOrder.Validate("Source Type", ProdOrder."Source Type"::Item);
            if StrPos(ItemCode, '5-CRU') > 0 then begin
                ItemProduit := CuProd.GetFirstIntermediateItemProduitByItem(ItemCode);
                if StrPos(ItemProduit, '5-CRU') = 0 then
                    ItemProduit := ItemCode
            end
            else begin
                ItemProduit := CuProd.GetFirstIntermediateItemProduitByItem(ItemCode);
            end;
            ProdOrder.Validate("Source No.", ItemProduit);
            ProdOrder.Validate("Location Code", LocationCode);
            ProdOrder.Validate("Starting Date", Today);
            ProdOrder.Validate("Due Date", ProdOrder."Ending Date");
            ProdOrder.Modify(true);

            OrderNo := ProdOrder."No.";
            OrderLine := 10000;
            if (ItemCode <> ItemProduit) then begin
                ProdOrder.Reset;
                ProdOrder.SetRange("No.", OrderNo);
                if ProdOrder.FindFirst then begin
                    if (StrPos(UpperCase(UserId), 'CCSADMIN') = 0) then
                        REPORT.Run(REPORT::"Refresh Production Order", false, true, ProdOrder);
                end;
            end
            else begin

                ProdOrderLine.Init;
                ProdOrderLine.Status := ProdOrderLine.Status::Released;
                ProdOrderLine."Prod. Order No." := ProdOrder."No.";
                ProdOrderLine."Line No." := 10000;
                ProdOrderLine.Validate("Item No.", ItemProduit);
                ProdOrderLine.Validate("Location Code", LocationCode);
                ProdOrderLine.Validate(Quantity, Qty);
                ProdOrderLine.Validate("Quantity (Base)", Qty);
                ProdOrderLine.Validate("Due Date", CalcDate('<+3D>', Today));
                ProdOrderLine.Validate("Starting Date", Today);
                ProdOrderLine.Validate("Ending Date", CalcDate('<+3D>', Today));
                ProdOrderLine.Insert;
                ProdOrder.Reset;
                ProdOrder.SetRange("No.", OrderNo);
                if ProdOrder.FindFirst then begin
                    ProdOrder.Validate(Quantity, Qty);
                    ProdOrder.Modify;
                end;
                if ProdOrder.FindFirst then begin
                    REPORT.Run(REPORT::"Refresh Production Order", false, true, ProdOrder);
                end;
            end;
        end;

        //MESSAGE(OrderNo);

        NewLot := CopyStr('D-' + OrderNo + '-' + LotNo, 1, 50);

        if ((StrPos(UpperCase(UserId), 'CCSADMIN') = 0)) and (LotNo <> '') then begin

            ProdOrder.Reset;
            ProdOrder.SetRange("No.", OrderNo);
            if ProdOrder.FindFirst then begin
                if (StrPos(ItemCode, '7-CFR') > 0) or (StrPos(ItemCode, '5-CRU') > 0) then
                    NewDLC := DT2Date(DLC)
                else
                    NewDLC := CalcDate('<+8D>', Today);
                Reclassement(ItemCode, LotNo, NewLot, NewDLC, Qty, LocationCode, OrderNo);

                recPalletIn.Reset;
                recPalletIn.SetRange(NumOF, OrderNo);
                if not recPalletIn.FindFirst then begin
                    recPalletIn.Reset;
                    recPalletIn.Init;
                    recPalletIn."Lot No." := CopyStr(NewLot, 1, MaxStrLen(recPalletIn."Quai reception"));
                    //IF ProdOrder.Machine = 'X-RAY' THEN
                    //  recPalletIn."Quai reception" := '2200000000248'
                    //ELSE
                    //  recPalletIn."Quai reception" := '2200000000149';
                    recPalletIn."Quai reception" := Printer;
                    recPalletIn.NumOF := OrderNo;
                    recPalletIn."Quantite reception" := 0;
                    recPalletIn.DLC := NewDLC;
                    recPalletIn."Item No." := ItemCode;
                    recPalletIn."Location code" := 'EC DORMA';
                    recPalletIn."Creation Date" := Today;
                    recPalletIn."Creation Time" := Time;
                    recPalletIn.Insert(true);
                end;
                PrintDecongel(OrderNo);
                if Qty > 599 then  //2 etiquettes
                    PrintDecongel(OrderNo);
            end;
        end;

        CuProd.RefreshABC(OrderNo);
    end;

    procedure AddConsommationOF(OrderNo: Code[20]; OrderLine: Integer; ItemCode: Code[20]; Qty: Decimal; LotNo: Code[50]; DLC: Date)
    var
        Cu5510: Codeunit "Production Journal Mgt";
        ProdOrder: Record "Production Order";
        ItemJnlLine: Record "Item Journal Line";
        ReservEntry: Record "Reservation Entry";
        NextSeq: Integer;
        ItemProduit: Code[20];
        CuProd: Codeunit "Integration Tft and Prod";
        ProdOrderLine: Record "Prod. Order Line";
    begin



        ProdOrder.Reset;
        ProdOrder.SetRange("No.", OrderNo);
        if ProdOrder.FindFirst then begin

            ItemJnlLine.Reset;
            ItemJnlLine.SetRange("Order No.", OrderNo);
            ItemJnlLine.SetRange("Order Line No.", OrderLine);
            if ItemJnlLine.Find('-') then
                if Cu5510.ReservEntryExist(ItemJnlLine, ReservEntry) then
                    ReservEntry.DeleteAll(true);
            ItemJnlLine.DeleteAll(true);
            ItemJnlLine.Reset;
            ItemJnlLine.Init;
            ItemJnlLine."Journal Template Name" := 'CONSOMMATI';
            ItemJnlLine."Journal Batch Name" := 'AUTO';
            ItemJnlLine."Source Code" := 'FCONSO';
            ItemJnlLine."Line No." := 1;
            ItemJnlLine.Validate("Posting Date", Today);
            ItemJnlLine.Validate("Item No.", ItemCode);
            ItemJnlLine.Validate("Entry Type", ItemJnlLine."Entry Type"::Consumption);
            ItemJnlLine.Validate("Order No.", OrderNo);
            ItemJnlLine.Validate("Order Line No.", OrderLine);
            ItemJnlLine.Validate("Location Code", ProdOrder."Location Code");
            ItemJnlLine.Validate("Quantity (Base)", Qty);
            ItemJnlLine.Insert();

            ReservEntry.Reset;
            if ReservEntry.FindLast then NextSeq := ReservEntry."Entry No." + 1;
            ReservEntry.Init;
            ReservEntry."Entry No." := NextSeq;
            ReservEntry.Validate("Item No.", ItemCode);
            ReservEntry.Validate("Location Code", ProdOrder."Location Code");
            ReservEntry.Validate("Quantity (Base)", -Qty);
            ReservEntry.Positive := false;
            ReservEntry."Reservation Status" := ReservEntry."Reservation Status"::Prospect;
            ReservEntry."Source Type" := 83;
            ReservEntry."Source Subtype" := 5;
            ReservEntry."Source ID" := 'CONSOMMATI';
            ReservEntry."Source Batch Name" := 'AUTO';
            ReservEntry."Source Ref. No." := 1;
            ReservEntry."Source Prod. Order Line" := 0;
            ReservEntry."Lot No." := LotNo;
            ReservEntry."Warranty Date" := DLC;
            ReservEntry."Item Tracking" := ReservEntry."Item Tracking"::"Lot No.";
            ReservEntry.Insert;

            ItemJnlLine.PostingItemJnlFromProduction(false);

        end;
    end;

    procedure AddAllConsoOF(OrderNo: Code[20]; OrderLine: Integer; Dt: Date)
    var
        Cu5510: Codeunit "Production Journal Mgt";
        ProdOrder: Record "Production Order";
        ItemJnlLine: Record "Item Journal Line";
        ReservEntry: Record "Reservation Entry";
        NextSeq: Integer;
        RRefresh: Report "Refresh Production Order";
        ItemProduit: Code[20];
        CuProd: Codeunit "Integration Tft and Prod";
        ProdOrderLine: Record "Prod. Order Line";
        ILE: Record "Item Ledger Entry";
    begin



        ProdOrder.Reset;
        ProdOrder.SetRange("No.", OrderNo);
        if ProdOrder.FindFirst then begin

            ItemJnlLine.Reset;
            ItemJnlLine.SetRange("Order No.", OrderNo);
            ItemJnlLine.SetRange("Order Line No.", OrderLine);
            if ItemJnlLine.Find('-') then
                if Cu5510.ReservEntryExist(ItemJnlLine, ReservEntry) then
                    ReservEntry.DeleteAll(true);
            ItemJnlLine.DeleteAll(true);

            ILE.Reset;
            ILE.SetRange("Entry Type", ILE."Entry Type"::Transfer);
            ILE.SetFilter("Remaining Quantity", '>0');
            ILE.SetRange("Posting Date", CalcDate('<-7D>', ProdOrder."Starting Date"), CalcDate('<+7D>', ProdOrder."Starting Date"));
            ILE.SetFilter("Lot No.", 'D-' + ProdOrder."No." + '-*');
            ILE.SetRange("Location Code", ProdOrder."Location Code");
            if ILE.FindSet then
                repeat
                    ItemJnlLine.Reset;
                    ItemJnlLine.Init;
                    ItemJnlLine."Journal Template Name" := 'CONSOMMATI';
                    ItemJnlLine."Journal Batch Name" := 'AUTO';
                    ItemJnlLine."Source Code" := 'FCONSO';
                    ItemJnlLine."Line No." := 1;
                    ItemJnlLine.Validate("Posting Date", Dt);
                    ItemJnlLine.Validate("Item No.", ILE."Item No.");
                    ItemJnlLine.Validate("Entry Type", ItemJnlLine."Entry Type"::Consumption);
                    ItemJnlLine.Validate("Order No.", OrderNo);
                    ItemJnlLine.Validate("Order Line No.", OrderLine);
                    ItemJnlLine.Validate("Location Code", ProdOrder."Location Code");
                    ItemJnlLine.Validate("Quantity (Base)", ILE."Remaining Quantity");
                    ItemJnlLine.Insert();

                    ReservEntry.Reset;
                    if ReservEntry.FindLast then NextSeq := ReservEntry."Entry No." + 1;
                    ReservEntry.Init;
                    ReservEntry."Entry No." := NextSeq;
                    ReservEntry.Validate("Item No.", ILE."Item No.");
                    ReservEntry.Validate("Location Code", ProdOrder."Location Code");
                    ReservEntry.Validate("Quantity (Base)", -ILE."Remaining Quantity");
                    ReservEntry.Positive := false;
                    ReservEntry."Reservation Status" := ReservEntry."Reservation Status"::Prospect;
                    ReservEntry."Source Type" := 83;
                    ReservEntry."Source Subtype" := 5;
                    ReservEntry."Source ID" := 'CONSOMMATI';
                    ReservEntry."Source Batch Name" := 'AUTO';
                    ReservEntry."Source Ref. No." := 1;
                    ReservEntry."Source Prod. Order Line" := 0;
                    ReservEntry."Lot No." := ILE."Lot No.";
                    ReservEntry."Warranty Date" := ILE."Warranty Date";
                    ReservEntry."Item Tracking" := ReservEntry."Item Tracking"::"Lot No.";
                    ReservEntry.Insert;

                    ItemJnlLine.PostingItemJnlFromProduction(false);
                until ILE.Next = 0;

        end;
    end;

    procedure AddProdOF(OrderNo: Code[20]; OrderLine: Integer; ItemCode: Code[20]; Qty: Decimal; LocationCode: Code[20]; Temperature: Decimal; Suffixe: Code[10]; Printer: Code[20])
    var
        Cu5510: Codeunit "Production Journal Mgt";
        ProdOrder: Record "Production Order";
        ItemJnlLine: Record "Item Journal Line";
        ReservEntry: Record "Reservation Entry";
        NextSeq: Integer;
        SSCCNo: Code[20];
        Palet: Record Pallet;
        PaletJnl: Record "Pallet Journal";
        ILE: Record "Item Ledger Entry";
        Dt: Date;
        MinDt: Date;
        Items: Record Item;
    begin
        AddProdOF2(OrderNo, OrderLine, ItemCode, Qty, LocationCode, Temperature, Suffixe, Printer, '', '', 0DT);
    end;

    procedure AddProdOFLettre(OrderNo: Code[20]; OrderLine: Integer; ItemCode: Code[20]; Qty: Decimal; LocationCode: Code[20]; Temperature: Decimal; Suffixe: Code[10])
    var
        Cu5510: Codeunit "Production Journal Mgt";
        ProdOrder: Record "Production Order";
        ItemJnlLine: Record "Item Journal Line";
        ReservEntry: Record "Reservation Entry";
        NextSeq: Integer;
        SSCCNo: Code[20];
        Palet: Record Pallet;
        PaletJnl: Record "Pallet Journal";
    begin

        AddProdOF(OrderNo, OrderLine, ItemCode, Qty, LocationCode, Temperature, Suffixe, '2200000000149');
    end;

    procedure SetBL(OrderNo: Code[20]; BL: Text)
    var
        PurchH: Record "Purchase Header";
    begin
        if PurchH.Get(PurchH."Document Type"::Order, OrderNo) then begin
            PurchH."Vendor Shipment No." := BL;
            PurchH.Modify();
        end;
    end;

    procedure PrintDecongel(OrderNo: Text)
    begin
        recPalletIn.Reset;
        recPalletIn.SetRange(NumOF, OrderNo);
        if not recPalletIn.FindFirst then
            Error('Pas encore de palette scannee en entree');
        PrintLabel(recPalletIn."SSCC No.");
    end;

    procedure TftFromLocationToLocation(SSCC: Code[20]; Qty: Decimal; MagasinArrivee: Code[20]; user: Code[50]; Printer: Text; RegroupeArrivee: Boolean)
    var
        Pallet: Record Pallet;
        TftH: Record "Transfer Header";
        TftL: Record "Transfer Line";
        recReservOTS: Record "Reservation Entry";
        TransferPostShipment: Codeunit "TransferOrder-Post Shipment";
        TransferPostReceipt: Codeunit "TransferOrder-Post Receipt";
        NextSeq: Integer;
        PalletJnl: Record "Pallet Journal";
        Loc: Record Location;
    begin

        Pallet.Get(SSCC);


        TftH.Reset;
        TftH.Init;
        TftH.Insert(true);
        TftH.Validate("Transfer-from Code", Pallet."Location code");
        TftH.Validate("Transfer-to Code", MagasinArrivee);
        TftH.Validate("In-Transit Code", '9-TFT');
        TftH.Auto := true;
        TftH.Modify(true);

        TftL.Reset;
        TftL.Init;
        TftL."Document No." := TftH."No.";
        TftL."Line No." := 10000;
        TftL.Validate("Item No.", Pallet."Item No.");
        TftL.Validate(Quantity, Qty);
        TftL."Transfer-from Bin Code" := Pallet."Bin code";
        TftL.Insert(true);


        recReservOTS.Reset;
        if recReservOTS.FindLast then NextSeq := recReservOTS."Entry No." + 1;
        recReservOTS.Reset;
        recReservOTS.Init;
        recReservOTS."Entry No." := NextSeq;
        recReservOTS.Positive := false;
        recReservOTS."Item No." := Pallet."Item No.";
        recReservOTS."Location Code" := TftH."Transfer-from Code";
        recReservOTS."Quantity (Base)" := -Qty;
        recReservOTS."Qty. to Handle (Base)" := -Qty;
        recReservOTS."Qty. to Invoice (Base)" := -Qty;
        recReservOTS."Source Type" := 5741;
        recReservOTS."Source Subtype" := 0;
        recReservOTS."Source ID" := TftH."No.";
        recReservOTS."Source Ref. No." := TftL."Line No.";
        recReservOTS."Shipment Date" := Today;
        recReservOTS."Warranty Date" := Pallet.DLC;
        recReservOTS."Lot No." := Pallet."Lot No.";
        recReservOTS."Item Tracking" := recReservOTS."Item Tracking"::"Lot No.";
        recReservOTS."Reservation Status" := recReservOTS."Reservation Status"::Surplus;
        recReservOTS."Creation Date" := WorkDate;
        recReservOTS."Created By" := UserId;
        recReservOTS.Insert;

        Loc.Get(TftH."Transfer-from Code");
        if Loc."Pallet Management" then
            AddPickingPalletWithUser(SSCC, TftH."No.", TftL."Line No.", Qty, user);

        TransferPostShipment.Run(TftH);

        recReservOTS.Reset;
        if recReservOTS.FindLast then NextSeq := recReservOTS."Entry No." + 1;
        recReservOTS.Reset;
        recReservOTS.Init;
        recReservOTS."Entry No." := NextSeq;
        recReservOTS.Positive := true;
        recReservOTS."Item No." := Pallet."Item No.";
        recReservOTS."Location Code" := TftH."Transfer-to Code";
        recReservOTS."Quantity (Base)" := Qty;
        recReservOTS."Qty. to Handle (Base)" := Qty;
        recReservOTS."Qty. to Invoice (Base)" := Qty;
        recReservOTS."Source Type" := 5741;
        recReservOTS."Source Subtype" := 1;
        recReservOTS."Source ID" := TftH."No.";
        recReservOTS."Source Ref. No." := 20000;
        recReservOTS."Source Prod. Order Line" := 10000;
        recReservOTS."Expected Receipt Date" := Today;
        recReservOTS."Warranty Date" := Pallet.DLC;
        recReservOTS."Lot No." := Pallet."Lot No.";
        recReservOTS."Item Tracking" := recReservOTS."Item Tracking"::"Lot No.";
        recReservOTS."Reservation Status" := recReservOTS."Reservation Status"::Surplus;
        recReservOTS."Creation Date" := WorkDate;
        recReservOTS."Created By" := UserId;
        recReservOTS.Insert;

        Loc.Get(TftH."Transfer-to Code");
        if Loc."Pallet Management" then begin
            PalletJnl.Reset;
            PalletJnl.SetRange("Journal Template Name", recReservOTS."Source ID");
            PalletJnl.SetRange("Journal Batch Name", recReservOTS."Source Batch Name");
            PalletJnl.SetRange("Journal Line No.", recReservOTS."Source Ref. No.");
            if not PalletJnl.Find('+') then
                NextSeq := 10000
            else
                NextSeq := PalletJnl.ID + 10000;

            PalletJnl.Init;
            PalletJnl."Journal Template Name" := recReservOTS."Source ID";
            PalletJnl."Journal Batch Name" := recReservOTS."Source Batch Name";
            PalletJnl."Journal Line No." := recReservOTS."Source Ref. No.";
            PalletJnl."Document No." := recReservOTS."Source ID";
            PalletJnl.ID := NextSeq;
            TftL."Transfer-To Bin Code" := Loc."Default Recept. bin";
            if RegroupeArrivee then begin
                PalletJnl."SSCC No." := CopyStr(SSCC, 1, 12);
                if Pallet.Get(PalletJnl."SSCC No.") then
                    if Pallet."Bin code" <> '' then
                        TftL."Transfer-To Bin Code" := Pallet."Bin code";
            end
            else begin
                PalletJnl."SSCC No." := SSCC;
            end;
            TftL.Modify;
            PalletJnl."Treated Quantity" := recReservOTS."Quantity (Base)";
            PalletJnl."Reservation Entry" := recReservOTS."Entry No.";
            PalletJnl."Lot No." := recReservOTS."Lot No.";
            PalletJnl.Insert;
        end;


        TransferPostReceipt.Run(TftH);

        Pallet.Get(SSCC);
        Pallet."Dernier Inventaire" := CreateDateTime(Today, Time);
        Pallet."Bin code" := MagasinArrivee;
        Pallet.Modify;
    end;

    procedure TftFromLocationToLocation2(ItemNo: Code[20]; Qty: Decimal; MagasinDepart: Code[20]; MagasinArrivee: Code[20]; Lot: Code[50]; DLC: Date)
    var
        TftH: Record "Transfer Header";
        TftL: Record "Transfer Line";
        recReservOTS: Record "Reservation Entry";
        TransferPostShipment: Codeunit "TransferOrder-Post Shipment";
        TransferPostReceipt: Codeunit "TransferOrder-Post Receipt";
        NextSeq: Integer;
        Loc: Record Location;
        ILE: Integer;
    begin



        TftH.Reset;
        TftH.Init;
        TftH.Insert(true);
        TftH.Validate("Transfer-from Code", MagasinDepart);
        TftH.Validate("Transfer-to Code", MagasinArrivee);
        TftH.Validate("In-Transit Code", '9-TFT');
        TftH.Auto := true;
        TftH.Modify(true);

        TftL.Reset;
        TftL.Init;
        TftL."Document No." := TftH."No.";
        TftL."Line No." := 10000;
        TftL.Validate("Item No.", ItemNo);
        TftL.Validate(Quantity, Qty);

        TftL.Insert(true);


        recReservOTS.Reset;
        if recReservOTS.FindLast then NextSeq := recReservOTS."Entry No." + 1;
        recReservOTS.Reset;
        recReservOTS.Init;
        recReservOTS."Entry No." := NextSeq;
        recReservOTS.Positive := false;
        recReservOTS."Item No." := ItemNo;
        recReservOTS."Location Code" := TftH."Transfer-from Code";
        recReservOTS."Quantity (Base)" := -Qty;
        recReservOTS."Qty. to Handle (Base)" := -Qty;
        recReservOTS."Qty. to Invoice (Base)" := -Qty;
        recReservOTS."Source Type" := 5741;
        recReservOTS."Source Subtype" := 0;
        recReservOTS."Source ID" := TftH."No.";
        recReservOTS."Source Ref. No." := TftL."Line No.";
        recReservOTS."Shipment Date" := Today;
        recReservOTS."Warranty Date" := DLC;
        recReservOTS."Lot No." := Lot;
        recReservOTS."Item Tracking" := recReservOTS."Item Tracking"::"Lot No.";
        recReservOTS."Reservation Status" := recReservOTS."Reservation Status"::Surplus;
        recReservOTS."Creation Date" := WorkDate;
        recReservOTS."Created By" := UserId;
        recReservOTS.Insert;

        Loc.Get(TftH."Transfer-from Code");
        if Loc."Pallet Management" then
            Error('Magasin avec palette');

        TransferPostShipment.Run(TftH);

        recReservOTS.Reset;
        if recReservOTS.FindLast then NextSeq := recReservOTS."Entry No." + 1;
        recReservOTS.Reset;
        recReservOTS.Init;
        recReservOTS."Entry No." := NextSeq;
        recReservOTS.Positive := true;
        recReservOTS."Item No." := ItemNo;
        recReservOTS."Location Code" := TftH."Transfer-to Code";
        recReservOTS."Quantity (Base)" := Qty;
        recReservOTS."Qty. to Handle (Base)" := Qty;
        recReservOTS."Qty. to Invoice (Base)" := Qty;
        recReservOTS."Source Type" := 5741;
        recReservOTS."Source Subtype" := 1;
        recReservOTS."Source ID" := TftH."No.";
        recReservOTS."Source Ref. No." := 20000;
        recReservOTS."Source Prod. Order Line" := 10000;
        recReservOTS."Expected Receipt Date" := Today;
        recReservOTS."Warranty Date" := DLC;
        recReservOTS."Lot No." := Lot;
        recReservOTS."Item Tracking" := recReservOTS."Item Tracking"::"Lot No.";
        recReservOTS."Reservation Status" := recReservOTS."Reservation Status"::Surplus;
        recReservOTS."Creation Date" := WorkDate;
        recReservOTS."Created By" := UserId;
        recReservOTS.Insert;

        TransferPostReceipt.Run(TftH);
    end;

    procedure AddPaletConsoOF(OrderNo: Code[20]; OrderLine: Integer; SSCC: Code[20]; Qty: Decimal; TreatPallet: Boolean; Printer: Code[20])
    var
        Cu5510: Codeunit "Production Journal Mgt";
        ProdOrder: Record "Production Order";
        ItemJnlLine: Record "Item Journal Line";
        ReservEntry: Record "Reservation Entry";
        NextSeq: Integer;
        ItemProduit: Code[20];
        CuProd: Codeunit "Integration Tft and Prod";
        ProdOrderLine: Record "Prod. Order Line";
        PalletJnl: Record "Pallet Journal";
        Item: Record Item;
    begin
        AddPaletConsoOF2(OrderNo, OrderLine, SSCC, Qty, TreatPallet, Printer, false);
    end;

    procedure AddPaletConsoOF2(OrderNo: Code[20]; OrderLine: Integer; SSCC: Code[20]; Qty: Decimal; TreatPallet: Boolean; Printer: Code[20]; IsRecyclage: Boolean)
    var
        Cu5510: Codeunit "Production Journal Mgt";
        ProdOrder: Record "Production Order";
        ItemJnlLine: Record "Item Journal Line";
        ReservEntry: Record "Reservation Entry";
        NextSeq: Integer;
        ItemProduit: Code[20];
        CuProd: Codeunit "Integration Tft and Prod";
        ProdOrderLine: Record "Prod. Order Line";
        PalletJnl: Record "Pallet Journal";
        Item: Record Item;
        ProdOrderH: Record "Production Order";
        Dt: Date;
        ILE: Record "Item Ledger Entry";
    begin

        if (Qty < 0) then Error('La quantité ne peut pas être négative');
        recPalletIn.Get(SSCC);
        recPalletIn.CalcFields("Current Quantity");

        if TreatPallet then begin
            if recPalletIn."Current Quantity" < Qty then
                Error('Vous essayez de consommer plus que ce que la palette ne contient');
            if recPalletIn."Bin code" <> 'PROD' then
                Error('La palette ne se trouve pas en production');
        end;



        ProdOrder.Reset;
        ProdOrder.SetRange("No.", OrderNo);
        if ProdOrder.FindFirst then begin

            Item.Get(recPalletIn."Item No.");
            Item.SetFilter("Location Filter", ProdOrder."Location Code");
            Item.SetFilter("Lot No. Filter", recPalletIn."Lot No.");
            Item.CalcFields(Inventory);
            if (Item.Inventory < Qty) then begin
                Item.SetFilter("Location Filter", 'EC DORMA');
                Item.SetFilter("Lot No. Filter", recPalletIn."Lot No.");
                Item.CalcFields(Inventory);
                if (Item.Inventory >= Qty) then begin //Pas de stock sur magasin de prod, mais stock sur Dorma -> Tft
                    recPalletIn."Location code" := 'EC DORMA';
                    recPalletIn.Modify;
                    TftFromLocationToLocation(recPalletIn."SSCC No.", Qty, ProdOrder."Location Code", UserId, '', false);
                end;
                if (recPalletIn."Item No." = '5-FRS-80400') or (recPalletIn."Item No." = '5-FRS-80401') then begin
                    if recPalletIn."Current Quantity" = Qty then begin
                        Item.Get(recPalletIn."Item No.");
                        Item.SetFilter("Location Filter", 'ECCONGEL');
                        Item.SetFilter("Lot No. Filter", recPalletIn."Lot No.");
                        Item.CalcFields(Inventory);
                        if (Item.Inventory >= Qty) then begin
                            recPalletIn."Location code" := 'ECCONGEL';
                            recPalletIn.Modify;
                            TftFromLocationToLocation(recPalletIn."SSCC No.", Qty, ProdOrder."Location Code", UserId, '', false);
                        end;

                    end;
                end;
            end;

            AddComponent(OrderNo, OrderLine, Item."No.", Qty);
            ItemJnlLine.Reset;
            ItemJnlLine.SetRange("Order No.", OrderNo);
            ItemJnlLine.SetRange("Order Line No.", OrderLine);
            if ItemJnlLine.Find('-') then
                if Cu5510.ReservEntryExist(ItemJnlLine, ReservEntry) then
                    ReservEntry.DeleteAll(true);
            ItemJnlLine.DeleteAll(true);

            //Cu5510.SetTemplateAndBatchName();
            //Cu5510.InitSetupValues();
            //Cu5510.CreateJnlLines(ProdOrder,10000);
            ReservEntry.Reset;
            ReservEntry.SetRange("Source ID", 'CONSOMMATI');
            ReservEntry.SetRange("Source Batch Name", 'DEFAUT');
            ReservEntry.SetRange("Source Ref. No.", 1);
            ReservEntry.DeleteAll;

            Dt := Today;
            ILE.Reset;
            ILE.SetRange("Entry Type", ILE."Entry Type"::Consumption);
            ILE.SetRange("Order No.", OrderNo);
            if ILE.FindFirst then
                if Date2DMY(Dt, 2) <> Date2DMY(ILE."Posting Date", 2) then
                    Dt := ILE."Posting Date";


            ItemJnlLine.Reset;
            ItemJnlLine.Init;
            ItemJnlLine."Journal Template Name" := 'CONSOMMATI';
            ItemJnlLine."Journal Batch Name" := 'Defaut';
            ItemJnlLine."Source Code" := 'FCONSO';
            ItemJnlLine."Line No." := 1;
            ItemJnlLine.Validate("Posting Date", Dt);
            ItemJnlLine.Validate("Entry Type", ItemJnlLine."Entry Type"::Consumption);
            ItemJnlLine.Validate("Order No.", OrderNo);
            ItemJnlLine.Validate("Order Line No.", OrderLine);
            ItemJnlLine.Validate("Item No.", recPalletIn."Item No.");
            ItemJnlLine.Validate("Location Code", ProdOrder."Location Code");
            ItemJnlLine.Validate("Quantity (Base)", Qty);

            ItemJnlLine.Insert();

            ReservEntry.Reset;
            if ReservEntry.FindLast then NextSeq := ReservEntry."Entry No." + 1;
            ReservEntry.Init;
            ReservEntry."Entry No." := NextSeq;
            ReservEntry.Validate("Item No.", recPalletIn."Item No.");
            ReservEntry.Validate("Location Code", recPalletIn."Location code");
            ReservEntry.Validate("Quantity (Base)", -Qty);
            ReservEntry.Positive := false;
            ReservEntry."Reservation Status" := ReservEntry."Reservation Status"::Prospect;
            ReservEntry."Source Type" := 83;
            ReservEntry."Source Subtype" := 5;
            ReservEntry."Source ID" := 'CONSOMMATI';
            ReservEntry."Source Batch Name" := 'DEFAUT';
            ReservEntry."Source Ref. No." := 1;
            ReservEntry."Source Prod. Order Line" := 0;
            ReservEntry."Lot No." := recPalletIn."Lot No.";
            ReservEntry."Warranty Date" := recPalletIn.DLC;
            ReservEntry."Item Tracking" := ReservEntry."Item Tracking"::"Lot No.";
            ReservEntry.Insert;
            if TreatPallet then begin
                PalletJnl.Reset;
                PalletJnl.SetRange("Journal Template Name", 'CONSOMMATI');
                PalletJnl.SetRange("Journal Batch Name", 'DEFAUT');
                PalletJnl."Journal Line No." := 1;
                if not PalletJnl.Find('+') then
                    NextSeq := 10000
                else
                    NextSeq := PalletJnl.ID + 10000;

                PalletJnl.Init;
                PalletJnl."Journal Template Name" := 'CONSOMMATI';
                PalletJnl."Journal Batch Name" := 'DEFAUT';
                PalletJnl."Document No." := OrderNo;
                PalletJnl."Document Line No." := OrderLine;
                PalletJnl.ID := NextSeq;
                PalletJnl."SSCC No." := recPalletIn."SSCC No.";
                PalletJnl."Treated Quantity" := Qty;
                PalletJnl."Reservation Entry" := ReservEntry."Entry No.";
                PalletJnl."Lot No." := recPalletIn."Lot No.";
                PalletJnl.Insert;
            end;
            ItemJnlLine.PostingItemJnlFromProduction(false);

            if (IsRecyclage) then begin
                ProdOrder.Recyclage := true;
                ProdOrder.Modify(true);
            end;

        end;
    end;

    procedure AddComponent(OrderNo: Code[20]; OrderLine: Integer; ItemNo: Code[20]; Qty: Decimal)
    var
        ProdOrder: Record "Production Order";
        NextSeq: Integer;
        Item: Record Item;
        ProdComp: Record "Prod. Order Component";
    begin

        ProdOrder.Reset;
        ProdOrder.SetRange("No.", OrderNo);
        if ProdOrder.FindFirst then begin
            ProdComp.Reset;
            ProdComp.SetRange(Status, ProdOrder.Status);
            ProdComp.SetRange("Prod. Order No.", OrderNo);
            ProdComp.SetRange("Prod. Order Line No.", OrderLine);
            ProdComp.SetRange("Item No.", ItemNo);
            if not ProdComp.FindFirst then begin
                Item.Get(ItemNo);
                ProdComp.Reset;
                ProdComp.SetRange(Status, ProdOrder.Status);
                ProdComp.SetRange("Prod. Order No.", OrderNo);
                ProdComp.SetRange("Prod. Order Line No.", OrderLine);
                if ProdComp.FindLast then
                    NextSeq := ProdComp."Line No." + 10000
                else
                    NextSeq := 10000;
                ProdComp.Reset;
                ProdComp.Init;
                ProdComp.Status := ProdOrder.Status;
                ProdComp."Prod. Order No." := OrderNo;
                ProdComp."Prod. Order Line No." := OrderLine;
                ProdComp."Line No." := NextSeq;
                ProdComp.Validate("Item No.", ItemNo);
                ProdComp.Insert;
            end;
        end;
    end;

    procedure RegroupPallet(SSCCOrigine: Code[20]; SSCCDestination: Code[20]; Qty: Decimal)
    var
        PalOrigine: Record Pallet;
        PalDest: Record Pallet;
        RecNewPalletEntry: Record "Pallet Ledger Entry";
        Sequence: Integer;
        OldPalletEntry: Record "Pallet Ledger Entry";
    begin
        PalOrigine.Get(SSCCOrigine);
        PalDest.Get(SSCCDestination);
        PalOrigine.CalcFields("Current Quantity");
        PalDest.CalcFields("Current Quantity");
        if PalOrigine."Current Quantity" < Qty then
            Error('La palette ne contient pas la quantité voulue');
        if PalDest."Location code" = '' then
            PalDest."Location code" := PalOrigine."Location code";
        if PalDest."Location code" <> PalOrigine."Location code" then
            Error('Les 2 palettes ne sont pas sur le même magasin');

        if Qty < PalOrigine."Current Quantity" then begin
            // split
        end;
    end;

    procedure Reclassement(ItemNo: Code[20]; Lot: Code[50]; NewLot: Code[50]; NewDLC: Date; Qty: Decimal; Magasin: Code[20]; DocNo: Code[20])
    var
        ItemJnlLine: Record "Item Journal Line";
        ReservEntry: Record "Reservation Entry";
        NextSeq: Integer;
    begin
        ItemJnlLine.Reset;

        ItemJnlLine.Init;
        ItemJnlLine."Journal Template Name" := 'TRANSFERT';
        ItemJnlLine."Journal Batch Name" := 'AUTO';
        ItemJnlLine."Source Code" := 'FRECLASS';
        ItemJnlLine."Line No." := 1;
        ItemJnlLine.Validate("Posting Date", Today);
        ItemJnlLine.Validate("Item No.", ItemNo);
        ItemJnlLine.Validate("Entry Type", ItemJnlLine."Entry Type"::Transfer);
        ItemJnlLine.Validate("Document No.", DocNo);
        ItemJnlLine.Validate("Location Code", Magasin);
        ItemJnlLine.Validate("New Location Code", Magasin);
        ItemJnlLine.Validate("Quantity (Base)", Qty);
        ItemJnlLine.Insert();

        ReservEntry.Reset;
        if ReservEntry.FindLast then NextSeq := ReservEntry."Entry No." + 1;
        ReservEntry.Init;
        ReservEntry."Entry No." := NextSeq;
        ReservEntry.Validate("Item No.", ItemNo);
        ReservEntry.Validate("Location Code", Magasin);
        ReservEntry.Validate("Quantity (Base)", -Qty);
        ReservEntry."Reservation Status" := ReservEntry."Reservation Status"::Prospect;
        ReservEntry."Source Type" := 83;
        ReservEntry."Source Subtype" := 4;
        ReservEntry."Source ID" := 'TRANSFERT';
        ReservEntry."Source Batch Name" := 'AUTO';
        ReservEntry."Source Ref. No." := 1;
        ReservEntry."Source Prod. Order Line" := 0;
        ReservEntry.Positive := false;
        ReservEntry."Warranty Date" := NewDLC;
        ReservEntry."Item Tracking" := ReservEntry."Item Tracking"::"Lot No.";
        ReservEntry."New Lot No." := NewLot;
        ReservEntry."Lot No." := Lot;
        ReservEntry.Insert;

        CODEUNIT.Run(CODEUNIT::"Item Jnl.-Post", ItemJnlLine);
    end;

    procedure AddReservationToComponent(OrderNo: Code[20]; SSCC: Code[20]; Qty: Decimal; Printer: Code[20])
    var
        ReservMgmt: Codeunit "Reservation Management";
        TrckSpec: Record "Tracking Specification";
        ProdComponent: Record "Prod. Order Component";
        Prod: Record "Production Order";
        Palet: Record Pallet;
        ILE: Record "Item Ledger Entry";
        QtyReserved: Decimal;
        QtyToReserve: Decimal;
        Total: Decimal;
        recPalletIn: Record Pallet;
    begin
        Palet.Get(SSCC);
        Palet."Location code" := 'EC STOCK';
        Palet.Modify;
        TftFromLocationToLocation(SSCC, Qty, 'EC TOURNAI', 'epices', '', false);
        ProdComponent.Reset;
        ProdComponent.SetRange(Status, ProdComponent.Status::Released);
        ProdComponent.SetRange("Prod. Order No.", OrderNo);
        ProdComponent.SetRange("Item No.", Palet."Item No.");
        if ProdComponent.FindFirst then begin
            Prod.Get(Prod.Status::Released, OrderNo);
            QtyReserved := 0;
            ILE.Reset;
            ILE.SetCurrentKey("Entry No.");
            ILE.Ascending(false);
            ILE.SetRange("Item No.", Palet."Item No.");
            ILE.SetRange("Lot No.", Palet."Lot No.");
            ILE.SetRange("Location Code", Prod."Location Code");
            ILE.SetFilter("Remaining Quantity", '>0');
            if ILE.FindSet then
                repeat
                    if QtyReserved < Qty then begin
                        QtyToReserve := ILE."Remaining Quantity";
                        if QtyToReserve > Qty - QtyReserved then
                            QtyToReserve := Qty - QtyReserved;

                        ProdComponent."Remaining Qty. (Base)" := ProdComponent."Expected Qty. (Base)" * 2; //Permettre de réserver plus que calculé

                        TrckSpec.InitTrackingSpecification(32, 0, '', '', 0, ILE."Entry No.", '', Prod."Location Code", 1);
                        //ReservMgmt.SetProdOrderComponent(ProdComponent);
                        ReservMgmt.CreateReservation('', Today, QtyToReserve, QtyToReserve, TrckSpec);
                        QtyReserved += QtyToReserve;
                    end;
                until ILE.Next = 0;
        end;

        Total := TotalReserved(OrderNo, Palet."Item No.", Palet."Lot No.");
        recPalletIn.Reset;
        recPalletIn.SetRange(NumOF, OrderNo);
        recPalletIn.SetRange("Item No.", Palet."Item No.");
        recPalletIn.SetRange("Lot No.", Palet."Lot No.");
        if not recPalletIn.FindFirst then begin
            recPalletIn.Reset;
            recPalletIn.Init;
            recPalletIn.NumOF := OrderNo;
            recPalletIn."Item No." := Palet."Item No.";
            recPalletIn."Lot No." := Palet."Lot No.";
            recPalletIn."Quai reception" := Printer;
            recPalletIn."Quantite reception" := -Total;
            recPalletIn.DLC := Palet.DLC;
            recPalletIn."Location code" := Prod."Location Code";
            recPalletIn."Creation Date" := Today;
            recPalletIn."Creation Time" := Time;
            recPalletIn.Insert(true);
        end
        else begin
            recPalletIn."Quai reception" := Printer;
            recPalletIn."Quantite reception" := -Total;
            recPalletIn.Modify;
        end;
        if Printer <> '' then
            PrintLabelEpices(recPalletIn."SSCC No.");
    end;

    procedure AddReservationToComponentRestant(OrderNo: Code[20]; SSCC: Code[20]; Qty: Decimal; Printer: Code[20]; QtyRestant: Decimal)
    var
        ReservMgmt: Codeunit "Reservation Management";
        TrckSpec: Record "Tracking Specification";
        ProdComponent: Record "Prod. Order Component";
        Prod: Record "Production Order";
        Palet: Record Pallet;
        ILE: Record "Item Ledger Entry";
        QtyReserved: Decimal;
        QtyToReserve: Decimal;
        Total: Decimal;
        recPalletIn: Record Pallet;
    begin
        AddReservationToComponent(OrderNo, SSCC, Qty, Printer);

        Palet.Get(SSCC);
        Palet."Quantite reception" := QtyRestant;
        Palet."Quai reception" := Printer;
        Palet.Modify;
        if Printer <> '' then
            PrintLabel(Palet."SSCC No.");
    end;

    procedure DeleteReservationFromComponent(OrderNo: Code[20]; ItemNo: Code[20]; Lot: Code[50])
    var
        ReservMgmt: Codeunit "Reservation Management";
        ProdComponent: Record "Prod. Order Component";
        Prod: Record "Production Order";
        Reserv: Record "Reservation Entry";
        Reserv2: Record "Reservation Entry";
        ReserveEngine: Codeunit "Reservation Engine Mgt.";
        ILE: Record "Item Ledger Entry";
    begin

        ProdComponent.Reset;
        ProdComponent.SetRange(Status, ProdComponent.Status::Released);
        ProdComponent.SetRange("Prod. Order No.", OrderNo);
        ProdComponent.SetRange("Item No.", ItemNo);
        if ProdComponent.FindFirst then begin
            Prod.Get(Prod.Status::Released, OrderNo);
            Reserv.Reset;
            Reserv.SetRange("Item No.", ItemNo);
            Reserv.SetRange("Source ID", OrderNo);
            if Reserv.FindSet then
                repeat
                    Reserv2.Reset;
                    Reserv2.SetRange("Entry No.", Reserv."Entry No.");
                    Reserv2.SetRange(Positive, not Reserv.Positive);
                    Reserv2.SetRange("Lot No.", Lot);
                    if Reserv2.FindFirst then begin
                        //ReservMgmt.SetProdOrderComponent(ProdComponent);
                        ReserveEngine.CancelReservation(Reserv2);
                        ILE.Reset;
                        ILE.SetRange("Item No.", Reserv2."Item No.");
                        ILE.SetRange("Lot No.", Lot);
                        ILE.FindLast;

                        TftFromLocationToLocation2(Reserv2."Item No.", Reserv2."Quantity (Base)", 'EC TOURNAI', 'EC STOCK', Reserv2."Lot No.", ILE."Warranty Date");

                    end;
                until Reserv.Next = 0;
        end;

        recPalletIn.Reset;
        recPalletIn.SetRange(NumOF, OrderNo);
        recPalletIn.SetRange("Item No.", ItemNo);
        recPalletIn.SetRange("Lot No.", Lot);
        if recPalletIn.FindFirst then
            recPalletIn.Delete;
    end;

    procedure DeletePartialReservationFromComponent(OrderNo: Code[20]; ItemNo: Code[20]; Lot: Code[50]; QtyDeleted: Decimal; QtyReserved: Decimal)
    var
        Palet: Record Pallet;
        Printer: Text;
    begin
        recPalletIn.Reset;
        recPalletIn.SetRange(NumOF, OrderNo);
        recPalletIn.SetRange("Item No.", ItemNo);
        recPalletIn.SetRange("Lot No.", Lot);
        if recPalletIn.FindFirst then
            Printer := recPalletIn."Quai reception";
        DeleteReservationFromComponent(OrderNo, ItemNo, Lot);
        Palet.Reset;
        Palet.SetRange("Item No.", ItemNo);
        Palet.SetRange("Lot No.", Lot);
        Palet.FindFirst;

        recPalletIn.Reset;
        recPalletIn.Init;
        recPalletIn."Item No." := ItemNo;
        recPalletIn."Lot No." := Lot;
        recPalletIn."Quai reception" := Printer;
        recPalletIn."Quantite reception" := QtyDeleted;
        recPalletIn.DLC := Palet.DLC;
        recPalletIn."Location code" := 'EC STOCK';
        recPalletIn."Creation Date" := Today;
        recPalletIn."Creation Time" := Time;
        recPalletIn.Insert(true);
        PrintLabelEpices(recPalletIn."SSCC No.");

        if QtyReserved > 0 then begin
            AddReservationToComponent(OrderNo, Palet."SSCC No.", QtyReserved, '');
        end;
    end;

    local procedure TotalReserved(OrderNo: Code[20]; ItemNo: Code[20]; Lot: Code[50]): Decimal
    var
        reserv: Record "Reservation Entry";
        reserv2: Record "Reservation Entry";
        Total: Decimal;
    begin
        Total := 0;
        reserv.Reset;
        reserv.SetRange("Item No.", ItemNo);
        reserv.SetRange("Source ID", OrderNo);
        if reserv.FindSet then
            repeat
                reserv2.Reset;
                reserv2.SetRange("Entry No.", reserv."Entry No.");
                reserv2.SetRange(Positive, not reserv.Positive);
                reserv2.SetRange("Lot No.", Lot);
                if reserv2.FindFirst then begin
                    Total += reserv."Quantity (Base)";
                end;
            until reserv.Next = 0;

        exit(Total);
    end;

    procedure PrintReservationsComponents(OrderNo: Code[20]; Printer: Text[30])
    var
        ProdHeader: Record "Production Order";
        PrinterSelect: Record "Printer Selection";
        Utils: Codeunit Utils;
        FileName: Text[250];
        SessionId: Integer;
    begin

        PrinterSelect.Reset;
        PrinterSelect.SetRange("User ID", '');
        PrinterSelect.SetRange("Report ID", 50019);
        if PrinterSelect.FindFirst then begin
            PrinterSelect."Printer Name" := 'Printer_' + Printer;
            PrinterSelect.Modify;
        end
        else begin
            PrinterSelect.Init;
            PrinterSelect."User ID" := '';
            PrinterSelect."Report ID" := 50019;
            PrinterSelect."Printer Name" := 'Printer_' + Printer;
            PrinterSelect.Insert;
            ;

        end;
        ProdHeader.Reset;
        ProdHeader.SetRange("No.", OrderNo);
        ProdHeader.FindFirst;
        REPORT.Run(50019, false, false, ProdHeader);
    end;

    local procedure PrintReservation(OrderNo: Code[20]; ItemNo: Code[20]; LotNo: Code[50]; Printer: Code[20])
    var
        recPalletIn: Record Pallet;
    begin
        recPalletIn.Reset;
        recPalletIn.SetRange(NumOF, OrderNo);
        recPalletIn.SetRange("Item No.", ItemNo);
        recPalletIn.SetRange("Lot No.", LotNo);
        if recPalletIn.FindFirst then begin
            recPalletIn."Quai reception" := Printer;
            recPalletIn.Modify;
            PrintLabel(recPalletIn."SSCC No.");
        end;
    end;

    procedure AddInfoOF(OrderNo: Code[20]; LineNo: Integer; Operateur: Text; Materiel: Text)
    var
        OFLine: Record "Prod. Order Line";
    begin
        OFLine.Reset;
        OFLine.SetRange("Prod. Order No.", OrderNo);
        OFLine.SetRange("Line No.", LineNo);
        if OFLine.FindFirst then begin
            OFLine.TmpMateriel := Materiel;
            OFLine.TmpOperateur := Operateur;
            OFLine.Modify(false);
        end;
    end;

    [Scope('OnPrem')]
    procedure ReprintLot(ItemNo: Code[20]; LotNo: Code[50])
    var
        Printer: Text;
        ItemLedg: Record "Item Ledger Entry";
        AskQty: Page AskQty;
        i: Integer;
    begin
        ReprintLotPrinter(ItemNo, LotNo, '2200000000187');
    end;

    [Scope('OnPrem')]
    procedure ReprintLotPrinter(ItemNo: Code[20]; LotNo: Code[50]; Printer: Text)
    var
        ItemLedg: Record "Item Ledger Entry";
        AskQty: Page AskQty;
        i: Integer;
    begin
        if AskQty.RunModal <> ACTION::OK then
            Error('');

        ItemLedg.Reset;
        ItemLedg.SetRange("Item No.", ItemNo);
        ItemLedg.SetRange("Lot No.", LotNo);
        ItemLedg.SetRange("Entry Type", ItemLedg."Entry Type"::Purchase);
        recPalletIn.Reset;
        recPalletIn.Init;
        recPalletIn."SSCC No." := '';
        recPalletIn."Inbound Document No." := 'CDA Reprint';
        recPalletIn."Item No." := ItemNo;
        recPalletIn."Lot No." := LotNo;
        recPalletIn."Quai reception" := Printer;
        recPalletIn."Quantite reception" := AskQty.getQty();
        if ItemLedg.FindLast then begin
            recPalletIn.DLC := ItemLedg."Warranty Date"
        end
        else begin
            ItemLedg.SetRange("Entry Type");
            if ItemLedg.FindLast then
                recPalletIn.DLC := ItemLedg."Warranty Date";
        end;
        recPalletIn."Location code" := ItemLedg."Location Code";//'EC TOURNAI';
        recPalletIn."Creation Date" := Today;
        recPalletIn."Creation Time" := Time;
        recPalletIn.Insert(true);

        if AskQty.getImp = 0 then
            PrintLabel(recPalletIn."SSCC No.")
        else
            for i := 1 to AskQty.getImp do
                PrintLabel(recPalletIn."SSCC No.");
    end;

    procedure SetDuree2(OFNo: Code[20]; Effectif1: Decimal; Temps1: Decimal; Effectif2: Decimal; Temps2: Decimal; DureeTotale: Decimal)
    var
        ProdH: Record "Production Order";
    begin
        if ProdH.Get(ProdH.Status::Released, OFNo) then begin
            ProdH."Activite1 Effectif" := Effectif1;
            ProdH."Activite2 Effectif" := Effectif2;
            ProdH."Activite1 Duree" := Temps1;
            ProdH."Activite2 Duree" := Temps2;
            ProdH."Temps total" := DureeTotale;
            ProdH.Modify;
        end;
    end;

    procedure SetDuree(OFNo: Code[20]; Effectif1: Decimal; Temps1: Decimal; Effectif2: Decimal; Temps2: Decimal; DureeTotale: Decimal; EffectifSetup: Decimal; hSetup: Decimal; InterrRaison: Text; InterDuree: Decimal)
    var
        ProdH: Record "Production Order";
    begin
        if ProdH.Get(ProdH.Status::Released, OFNo) then begin
            ProdH."Activite1 Effectif" := Effectif1;
            ProdH."Activite2 Effectif" := Effectif2;
            ProdH."Activite1 Duree" := Temps1;
            ProdH."Activite2 Duree" := Temps2;
            ProdH."Temps total" := DureeTotale;
            ProdH."Setup Duree" := hSetup;
            ProdH."Setup Effectif" := EffectifSetup;
            ProdH."Setup Duree totale" := hSetup * EffectifSetup;
            ProdH."Interruption Duree" := InterDuree;
            ProdH."Interruption Raison" := InterrRaison;
            ProdH.Modify;
        end;
    end;

    procedure AddProdOF2(OrderNo: Code[20]; OrderLine: Integer; ItemCode: Code[20]; Qty: Decimal; LocationCode: Code[20]; Temperature: Decimal; Suffixe: Code[10]; Printer: Code[20]; Cmd: Code[20]; LotNo: Code[30]; DLC: DateTime): Text
    var
        Cu5510: Codeunit "Production Journal Mgt";
        ProdOrder: Record "Production Order";
        ItemJnlLine: Record "Item Journal Line";
        ReservEntry: Record "Reservation Entry";
        NextSeq: Integer;
        SSCCNo: Code[20];
        Palet: Record Pallet;
        PaletJnl: Record "Pallet Journal";
        ILE: Record "Item Ledger Entry";
        Dt: Date;
        MinDt: Date;
        Items: Record Item;
        ProdLine: Record "Prod. Order Line";
        Pallet: Record Pallet;
        r: Report "Fiche palette exp+lotZebraNEW";
        CuProd: Codeunit "Integration Tft and Prod";
        ILE2: Record "Item Ledger Entry";
        rTello: Report "Fiche palette exp+lotTELLO";
    begin
        if Qty < 0 then Error('La quantité ne peut pas être < 0');
        ProdOrder.Reset;
        ProdOrder.SetRange("No.", OrderNo);
        if ProdOrder.FindFirst then begin
            if ProdOrder.Machine = 'X-RAY' then
                Printer := '2200000000248';

            Dt := Today;
            ILE.Reset;
            ILE.SetRange("Entry Type", ILE."Entry Type"::Output);
            ILE.SetRange("Order No.", OrderNo);
            if ILE.FindFirst then
                if Date2DMY(Dt, 2) <> Date2DMY(ILE."Posting Date", 2) then
                    Dt := ILE."Posting Date";

            AddAllConsoOF(OrderNo, OrderLine, Dt);

            ItemJnlLine.Reset;
            ItemJnlLine.SetRange("Order No.", OrderNo);
            ItemJnlLine.SetRange("Order Line No.", OrderLine);
            if ItemJnlLine.Find('-') then
                if Cu5510.ReservEntryExist(ItemJnlLine, ReservEntry) then
                    ReservEntry.DeleteAll(true);
            ItemJnlLine.DeleteAll(true);

            ItemJnlLine.Reset;
            ItemJnlLine.Init;
            ItemJnlLine."Journal Template Name" := 'PRODUCTION';
            ItemJnlLine."Journal Batch Name" := 'AUTO';
            ItemJnlLine."Source Code" := 'FPRODOF';
            ItemJnlLine."Line No." := 1;
            ItemJnlLine.Validate("Posting Date", Dt);
            ItemJnlLine.Validate("Item No.", ItemCode);
            ItemJnlLine.Validate("Entry Type", ItemJnlLine."Entry Type"::Output);
            ItemJnlLine.Validate("Order No.", OrderNo);
            ItemJnlLine.Validate("Order Line No.", OrderLine);
            ItemJnlLine.Validate("Location Code", LocationCode);
            ItemJnlLine.Validate("Quantity (Base)", Qty);
            ItemJnlLine.Validate("Output Quantity (Base)", Qty);
            ItemJnlLine.Validate("Operation No.", '10');
            ItemJnlLine.Insert();

            ReservEntry.Reset;
            if ReservEntry.FindLast then NextSeq := ReservEntry."Entry No." + 1;
            ReservEntry.Init;
            ReservEntry."Entry No." := NextSeq;
            ReservEntry.Validate("Item No.", ItemCode);
            ReservEntry.Validate("Location Code", LocationCode);
            ReservEntry.Validate("Quantity (Base)", Qty);
            ReservEntry.Positive := true;
            ReservEntry."Reservation Status" := ReservEntry."Reservation Status"::Prospect;
            ReservEntry."Source Type" := 83;
            ReservEntry."Source Subtype" := 6;
            ReservEntry."Source ID" := 'PRODUCTION';
            ReservEntry."Source Batch Name" := 'AUTO';
            ReservEntry."Source Ref. No." := 1;
            ReservEntry."Source Prod. Order Line" := 0;
            ReservEntry."Lot No." := CopyStr(Format(Date2DMY(ProdOrder."Starting Date", 3)), 3, 2) + '/' + Utils.PadLeft(Format(ProdOrder."Starting Date" - DMY2Date(1, 1, Date2DMY(ProdOrder."Starting Date", 3)) + 1), '0', 3);
            if StrPos(ItemCode, '5-CRU') > 0 then
                ReservEntry."Lot No." := Format(ProdOrder."Starting Date", 0, '<Day,2><Month,2><Year>') + '-' + DelChr(OrderNo, '=', DelChr(OrderNo, '=', '1234567890'));
            if StrPos(ItemCode, '5-FSV') > 0 then
                ReservEntry."Lot No." := '5' + CopyStr(ItemCode, 9, 3) + '-' + CopyStr(Format(Date2DMY(ProdOrder."Starting Date", 3)), 3, 2) + Utils.PadLeft(Format(ProdOrder."Starting Date" - DMY2Date(1, 1, Date2DMY(ProdOrder."Starting Date", 3)) + 1), '0', 3);
            if StrPos(ItemCode, '5-HSV') > 0 then
                ReservEntry."Lot No." := '5' + CopyStr(ItemCode, 9, 3) + '-' + CopyStr(Format(Date2DMY(ProdOrder."Starting Date", 3)), 3, 2) + Utils.PadLeft(Format(ProdOrder."Starting Date" - DMY2Date(1, 1, Date2DMY(ProdOrder."Starting Date", 3)) + 1), '0', 3);
            if StrPos(ItemCode, '1-FAT') > 0 then
                ReservEntry."Lot No." := CopyStr(Format(Date2DMY(ProdOrder."Starting Date", 3)), 3, 2) + '/' + Utils.PadLeft(Format(ProdOrder."Starting Date" - DMY2Date(1, 1, Date2DMY(ProdOrder."Starting Date", 3)) + 1), '0', 3);
            if StrPos(ItemCode, '5-FPS') > 0 then
                ReservEntry."Lot No." := CopyStr(Format(Date2DMY(ProdOrder."Starting Date", 3)), 3, 2) + '/' + Utils.PadLeft(Format(ProdOrder."Starting Date" - DMY2Date(1, 1, Date2DMY(ProdOrder."Starting Date", 3)) + 1), '0', 3);
            if StrPos(ItemCode, '1-FPS') > 0 then
                ReservEntry."Lot No." := CopyStr(Format(Date2DMY(ProdOrder."Starting Date", 3)), 3, 2) + '/' + Utils.PadLeft(Format(ProdOrder."Starting Date" - DMY2Date(1, 1, Date2DMY(ProdOrder."Starting Date", 3)) + 1), '0', 3);

            if StrPos(ItemCode, '5-FRS') > 0 then
                ReservEntry."Warranty Date" := CalcDate('<+4D>', ProdOrder."Starting Date")
            else
                ReservEntry."Warranty Date" := CalcDate('<+8D>', ProdOrder."Starting Date");

            ILE.Reset;
            ILE.SetRange("Entry Type", ILE."Entry Type"::Consumption);
            ILE.SetRange("Order No.", OrderNo);
            if ILE.FindLast then begin
                if (StrPos(ILE."Item No.", '5-CRU') > 0) or (StrPos(ILE."Item No.", '7-CFR') > 0) then
                    ReservEntry."Warranty Date" := ILE."Warranty Date";
                if ((StrPos(ItemCode, '1-FSV') > 0) or (StrPos(ItemCode, '1-FPS') > 0) or (StrPos(ItemCode, '1-FPP') > 0) or (StrPos(ItemCode, '1-FHP') > 0) or (StrPos(ItemCode, '4-FPP') > 0) or (StrPos(ItemCode, '1-FAP') > 0)) then begin
                    ReservEntry."Warranty Date" := ILE."Warranty Date";
                    ReservEntry."Lot No." := DelChr(ILE."Lot No.", '=', '-');
                end;
                if ((StrPos(ItemCode, '1-FCB') > 0)) then begin
                    ReservEntry."Lot No." := DelChr(ILE."Lot No.", '=', '-');
                    ILE2.Reset;
                    ILE2.SetRange("Entry Type", ILE."Entry Type"::Output);
                    ILE2.SetRange("Item No.", ILE."Item No.");
                    ILE2.SetRange("Lot No.", ILE."Lot No.");
                    ILE2.FindLast;
                    ReservEntry."Warranty Date" := CalcDate('<+1Y+6M>', ILE2."Posting Date");
                end;
            end;
            if Items.Get(ItemCode) then
                if Format(Items.FormuleDLC) <> '' then
                    ReservEntry."Warranty Date" := CalcDate(Items.FormuleDLC, ProdOrder."Starting Date");

            if DLC > CurrentDateTime then ReservEntry."Warranty Date" := DT2Date(DLC);

            if ProdOrder.Recyclage and (ProdOrder."Recyclage VP" = 'REPASTO') then begin
                ILE.Reset;
                ILE.SetRange("Entry Type", ILE."Entry Type"::Consumption);
                ILE.SetRange("Order No.", OrderNo);
                if ILE.FindLast then begin
                    if ((StrPos(ItemCode, '5-FSV') > 0)) then begin
                        ReservEntry."Warranty Date" := CalcDate('<+15D>', ILE."Warranty Date");
                        ReservEntry."Lot No." := 'R' + ILE."Lot No.";
                    end;
                end;
            end;

            if StrPos(ItemCode, '5-CRU') > 0 then
                ReservEntry."Lot No." := 'D' + Format(ProdOrder."Starting Date", 0, '<Day,2><Month,2><Year>') + '-' + Format(Today, 0, '<Day,2>') + DelChr(OrderNo, '=', DelChr(OrderNo, '=', '1234567890')) + Suffixe;
            if StrPos(ItemCode, '5-MLX') > 0 then begin
                ILE.Reset;
                ILE.SetRange("Entry Type", ILE."Entry Type"::Output);
                ILE.SetRange("Order No.", OrderNo);
                if ILE.FindFirst then
                    ReservEntry."Lot No." := Suffixe + '-' + DelChr(OrderNo, '=', DelChr(OrderNo, '=', '1234567890')) + '-' + Format(ProdOrder."Starting Date", 0, '<Day,2><Month,2><Year>') + '-' + Format(ILE.Count + 1)
                else
                    ReservEntry."Lot No." := Suffixe + '-' + DelChr(OrderNo, '=', DelChr(OrderNo, '=', '1234567890')) + '-' + Format(ProdOrder."Starting Date", 0, '<Day,2><Month,2><Year>') + '-1';
                ReservEntry."Warranty Date" := CalcDate('<+2D>', ProdOrder."Starting Date");
                if Items.Get(ItemCode) then
                    if Format(Items.FormuleDLC) <> '' then
                        ReservEntry."Warranty Date" := CalcDate(Items.FormuleDLC, ProdOrder."Starting Date");

                ILE.Reset;
                ILE.SetRange("Entry Type", ILE."Entry Type"::Consumption);
                ILE.SetRange("Order No.", OrderNo);
                ILE.SetFilter("Item No.", '5-CRU*|7-CFR*');
                MinDt := 20491231D;
                if ILE.FindSet then
                    repeat
                        if MinDt > ILE."Warranty Date" then
                            MinDt := ILE."Warranty Date";
                    until ILE.Next = 0;
                if MinDt < ReservEntry."Warranty Date" then
                    ReservEntry."Warranty Date" := MinDt;
                if ReservEntry."Warranty Date" < Today then
                    ReservEntry."Warranty Date" := Today;

                //ReservEntry."Lot No." := 'M'+FORMAT(ProdOrder."Starting Date",0,'<Day,2><Month,2><Year>')+'-'+DELCHR(OrderNo,'=',DELCHR(OrderNo,'=','1234567890'))+Suffixe;
            end;

            if Suffixe = 'DECLAS' then
                ReservEntry."Warranty Date" := CalcDate('<+15D>', Today);
            if StrPos(UpperCase(ProdOrder.Machine), 'BOUDIN') > 0 then
                ReservEntry."Lot No." := Format(ProdOrder."Starting Date", 0, '<Day,2><Month,2><Year>') + '-boudin';
            if (Suffixe <> '') then
                ReservEntry."Lot No." := ReservEntry."Lot No." + Suffixe;

            ReservEntry."Item Tracking" := ReservEntry."Item Tracking"::"Lot No.";
            ReservEntry.Validate("Pallet Qty", 1);
            ReservEntry.Insert;
            PaletJnl.Reset;
            PaletJnl.SetRange("Reservation Entry", ReservEntry."Entry No.");
            if PaletJnl.FindFirst then begin
                Palet.Get(PaletJnl."SSCC No.");
                Palet."Quai reception" := Printer;
                Palet."Quantite reception" := Qty;
                Palet."Temperature reception" := Round(Temperature, 1, '=');
                //CuProd.calcBacs(Items,Pallet);
                if (Items.PoidsPalette <> 0) and (Items.BoitesPalette <> 0) then
                    Palet."Nbre bacs reception" := Round(Palet."Quantite reception" / (Items.PoidsPalette / Items.BoitesPalette), 1, '=');

                Palet."Outbound Document No." := Cmd;
                Palet.Modify;
            end;
            ItemJnlLine.PostingItemJnlFromProduction(false);

            //ERROR('On gg  ' + Printer + Cmd);
            if (Printer = '2200000000279') or (Printer = '2200000000286') then begin
                if (Cmd <> '') then begin

                    AddReservationToCmd(Cmd, Palet."SSCC No.", Qty, Printer);
                    Pallet.Reset;
                    Pallet.SetFilter("SSCC No.", Palet."SSCC No.");
                    if Pallet.FindFirst then
                        if Pallet."Quai reception" <> '' then begin
                            //ERROR('AAAAAA    ' + Printer + Cmd + Pallet."Item No.");
                            if (Pallet."Item No." = '1-FSV-00426') then begin
                                //ERROR('On passe ici');
                                rTello.SetTableView(Pallet);
                                rTello.UseRequestPage := false;
                                rTello.Print('', 'PRINTER_' + Pallet."Quai reception");
                            end
                            else begin
                                r.SetTableView(Pallet);
                                r.UseRequestPage := false;
                                r.Print('', 'PRINTER_' + Pallet."Quai reception");
                            end;
                            //IF (Pallet."Quantite reception" > 300) THEN
                            //  r.PRINT('','PRINTER_'+Pallet."Quai reception");
                        end;
                end
                else begin
                    PrintLabel150(Palet."SSCC No.");
                    //IF (Pallet."Quantite reception" > 300) THEN
                    //  PrintLabel150(Palet."SSCC No.");
                end;

            end
            else //ancienne version etiquette
          begin
                if (Cmd <> '') then
                    AddReservationToCmd(Cmd, Palet."SSCC No.", Qty, Printer);
                PrintLabel(Palet."SSCC No.");
            end;
            if ProdLine.Get(ProdOrder.Status, OrderNo, OrderLine) then
                if ProdLine."Finished Qty. (Base)" > ProdLine."Quantity (Base)" then begin
                    ProdLine.Validate("Quantity (Base)", ProdLine."Finished Qty. (Base)");
                    ProdLine.Modify(true);
                end;
        end;
        exit(Palet."SSCC No." + '-' + Format(IsPaletContent(Palet."SSCC No.")));
    end;

    procedure AddReservationToCmd(OrderNo: Code[20]; SSCC: Code[20]; Qty: Decimal; Printer: Code[20])
    var
        ReservMgmt: Codeunit "Reservation Management";
        TrckSpec: Record "Tracking Specification";
        ProdComponent: Record "Prod. Order Component";
        Prod: Record "Production Order";
        Palet: Record Pallet;
        ILE: Record "Item Ledger Entry";
        QtyReserved: Decimal;
        QtyToReserve: Decimal;
        Total: Decimal;
        recPalletIn: Record Pallet;
        SalesL: Record "Sales Line";
        Reserv: Record "Reservation Entry";
        NextNo: Integer;
    begin
        Palet.Get(SSCC);
        SalesL.Reset;
        SalesL.SetRange("Document Type", SalesL."Document Type"::Order);
        SalesL.SetRange("Document No.", OrderNo);
        SalesL.SetRange("No.", Palet."Item No.");
        if SalesL.FindFirst then begin
            //  ILE.RESET;
            //  ILE.SETCURRENTKEY("Entry No.");
            //  ILE.SETRANGE("Item No.",Palet."Item No.");
            //  ILE.SETRANGE("Lot No.",Palet."Lot No.");
            //  ILE.SETFILTER("Remaining Quantity",'>=%1',Qty);
            //  IF ILE.FINDLAST THEN
            //  BEGIN
            Reserv.Reset;
            if Reserv.FindLast then NextNo := Reserv."Entry No." + 1;
            Reserv.Init;
            Reserv."Entry No." := NextNo;
            Reserv."Item No." := Palet."Item No.";
            Reserv."Location Code" := SalesL."Location Code";
            Reserv.Validate("Quantity (Base)", -Qty);
            Reserv.Positive := false;
            Reserv."Source Type" := 37;
            Reserv."Source Subtype" := 1;
            Reserv."Source ID" := OrderNo;
            Reserv."Source Ref. No." := SalesL."Line No.";
            Reserv."Item Tracking" := Reserv."Item Tracking"::"Lot No.";
            Reserv."Reservation Status" := Reserv."Reservation Status"::Surplus;
            Reserv."Creation Date" := Today;
            Reserv."Shipment Date" := Today;
            Reserv."Warranty Date" := Palet.DLC;
            Reserv."Lot No." := Palet."Lot No.";
            Reserv.Insert(true);
            //  END;
        end;
    end;

    procedure DelReservation(ID: Integer)
    var
        reserv: Record "Reservation Entry";
    begin
        if reserv.Get(ID) then
            reserv.Delete;
    end;

    procedure ExpVente(CDVNo: Code[20]; NbrePal: Integer; NbreColis: Integer)
    var
        SalesH: Record "Sales Header";
        ShipH: Record "Sales Shipment Header";
        CuModif: Codeunit ModifTables;
        CuPrintEXV: Codeunit "Print EXV";
    begin
        SalesH.Reset;
        SalesH.SetRange("Document Type", SalesH."Document Type"::Order);
        SalesH.SetRange("No.", CDVNo);
        if SalesH.FindFirst then begin
            GeneratePalletExp(CDVNo);
            SalesH.Ship := true;
            SalesH.Invoice := false;
            SalesH.SetHideValidationDialog(true);
            SalesH.Validate("Posting Date", Today);
            SalesH.Modify(false);
            CODEUNIT.Run(CODEUNIT::"Sales-Post", SalesH);
            ShipH.Reset;
            ShipH.SetRange("Order No.", CDVNo);
            if ShipH.FindLast then begin
                CuModif.PaletOnShipment(ShipH."No.", NbrePal, NbreColis);
                CuPrintEXV.Run(ShipH);
            end;
        end;
    end;

    procedure PrintExp(CDVNo: Code[20]; NbrePal: Integer; NbreColis: Integer)
    var
        ShipH: Record "Sales Shipment Header";
        CuModif: Codeunit ModifTables;
        CuPrintEXV: Codeunit "Print EXV";
    begin
        ShipH.Reset;
        ShipH.SetRange("Order No.", CDVNo);
        if ShipH.FindLast then begin
            CuModif.PaletOnShipment(ShipH."No.", NbrePal, NbreColis);
            CuPrintEXV.Run(ShipH);
        end;
    end;

    procedure TerminateOF(OrderNo: Code[20]; OrderLine: Integer)
    var
        ProdLine: Record "Prod. Order Line";
        ItemJnlLine: Record "Item Journal Line";
        Compo: Record "Prod. Order Component";
        Item: Record Item;
        Cu5510: Codeunit "Production Journal Mgt";
        ReservEntry: Record "Reservation Entry";
        ProdOrder: Record "Production Order";
        ILE: Record "Item Ledger Entry";
        Conso: Decimal;
        QtyToLink: Decimal;
        RemainingQtyToLink: Decimal;
        NextSeq: Integer;
    begin
        if ProdLine.Get(ProdLine.Status::Released, OrderNo, OrderLine) then begin
            ILE.Reset;
            ILE.SetRange("Entry Type", ILE."Entry Type"::Consumption);
            ILE.SetRange("Document No.", OrderNo);
            //  IF NOT ILE.FINDFIRST THEN
            //    ERROR('Impossible de terminer');
            ILE.Reset;
            ILE.SetRange("Entry Type", ILE."Entry Type"::Output);
            ILE.SetRange("Document No.", OrderNo);
            if (not ILE.FindFirst) and (not (CopyStr(ProdLine."Item No.", 1, 5) = '5-FRS')) then
                Error('Impossible de terminer');

            AddAllConsoOF(OrderNo, OrderLine, Today);

            ProdOrder.Get(ProdOrder.Status::Released, OrderNo);
            ProdLine.Validate("Quantity (Base)", ProdLine."Finished Qty. (Base)");
            //ProdLine.VALIDATE(Termine,TRUE);
            ProdLine.Modify(true);
            ItemJnlLine.Reset;
            ItemJnlLine.SetRange("Order No.", OrderNo);
            ItemJnlLine.SetRange("Order Line No.", OrderLine);
            if ItemJnlLine.Find('-') then
                if Cu5510.ReservEntryExist(ItemJnlLine, ReservEntry) then
                    ReservEntry.DeleteAll(true);
            ItemJnlLine.DeleteAll(true);

            Compo.Reset;
            Compo.SetRange(Status, ProdLine.Status);
            Compo.SetRange("Prod. Order No.", OrderNo);
            Compo.SetRange("Prod. Order Line No.", OrderLine);
            Compo.SetFilter("Remaining Qty. (Base)", '>0');
            if Compo.FindSet then
                repeat
                    if Item.Get(Compo."Item No.") then
                        if (Item."Type de consommation" = Item."Type de consommation"::"Théorique sur OF") then begin
                            ReservEntry.Reset;
                            ReservEntry.SetRange("Source ID", 'CONSOMMATI');
                            ReservEntry.SetRange("Source Batch Name", 'DEFAUT');
                            ReservEntry.SetRange("Source Ref. No.", 1);
                            ReservEntry.DeleteAll;

                            ItemJnlLine.Reset;
                            ItemJnlLine.Init;
                            ItemJnlLine."Journal Template Name" := 'CONSOMMATI';
                            ItemJnlLine."Journal Batch Name" := 'Defaut';
                            ItemJnlLine."Source Code" := 'FCONSO';
                            ItemJnlLine."Line No." := 1;
                            ItemJnlLine.Validate("Posting Date", Today);
                            ItemJnlLine.Validate("Entry Type", ItemJnlLine."Entry Type"::Consumption);
                            ItemJnlLine.Validate("Item No.", Item."No.");
                            ItemJnlLine.Validate("Location Code", ProdOrder."Location Code");
                            ItemJnlLine.Validate("Order No.", OrderNo);
                            ItemJnlLine.Validate("Order Line No.", OrderLine);
                            ItemJnlLine.Validate("Quantity (Base)", Compo."Remaining Qty. (Base)");
                            ItemJnlLine.Insert();

                            if (Item."Item Tracking Code" = 'LOT-V-02') or (Item."Item Tracking Code" = 'LOT-V-01') then begin
                                RemainingQtyToLink := Compo."Remaining Qty. (Base)";
                                ILE.Reset;
                                ILE.SetRange("Location Code", ProdOrder."Location Code");
                                ILE.SetRange("Item No.", Item."No.");
                                ILE.SetFilter("Remaining Quantity", '>0');
                                if ILE.FindSet then
                                    repeat
                                        if ILE."Remaining Quantity" > RemainingQtyToLink then
                                            QtyToLink := RemainingQtyToLink
                                        else
                                            QtyToLink := ILE."Remaining Quantity";
                                        ReservEntry.Reset;
                                        ReservEntry.Reset;
                                        if ReservEntry.FindLast then NextSeq := ReservEntry."Entry No." + 1;
                                        ReservEntry.Init;
                                        ReservEntry."Entry No." := NextSeq;
                                        ReservEntry.Validate("Item No.", Item."No.");
                                        ReservEntry.Validate("Location Code", ProdOrder."Location Code");
                                        ReservEntry.Validate("Quantity (Base)", -QtyToLink);
                                        ReservEntry.Positive := false;
                                        ReservEntry."Reservation Status" := ReservEntry."Reservation Status"::Prospect;
                                        ReservEntry."Source Type" := 83;
                                        ReservEntry."Source Subtype" := 5;
                                        ReservEntry."Source ID" := 'CONSOMMATI';
                                        ReservEntry."Source Batch Name" := 'DEFAUT';
                                        ReservEntry."Source Ref. No." := 1;
                                        ReservEntry."Source Prod. Order Line" := 0;
                                        ReservEntry."Lot No." := ILE."Lot No.";
                                        ReservEntry."Warranty Date" := ILE."Warranty Date";
                                        ReservEntry."Item Tracking" := ReservEntry."Item Tracking"::"Lot No.";
                                        ReservEntry.Insert;

                                        RemainingQtyToLink -= QtyToLink;
                                    until (ILE.Next = 0) or (RemainingQtyToLink <= 0);
                            end;

                            ItemJnlLine.PostingItemJnlFromProduction(false);
                        end;
                until Compo.Next = 0;
            if StrPos(ProdOrder."Source No.", '1-IQF') > 0 then
                ConsoFRSIQF(OrderNo, OrderLine);
            if StrPos(ProdOrder."Source No.", '5-FAP') > 0 then
                ConsoFRSIQF(OrderNo, OrderLine);

            ProdLine.Validate(Termine, true);
            ProdLine.Modify(true);
        end;
    end;

    procedure ConsoFRSIQF(OrderNo: Code[20]; OrderLine: Integer)
    var
        ProdLine: Record "Prod. Order Line";
        ItemJnlLine: Record "Item Journal Line";
        Compo: Record "Prod. Order Component";
        Item: Record Item;
        Cu5510: Codeunit "Production Journal Mgt";
        ReservEntry: Record "Reservation Entry";
        ProdOrder: Record "Production Order";
        ILE: Record "Item Ledger Entry";
        Conso: Decimal;
        ProdOrderFRS: Record "Production Order";
    begin
        Compo.Reset;
        Compo.SetRange("Prod. Order No.", OrderNo);
        Compo.SetRange("Prod. Order Line No.", OrderLine);
        Compo.SetFilter("Remaining Qty. (Base)", '>0');
        Compo.SetFilter("Item No.", '5-FRS*|5-IQF*');
        if Compo.Count = 1 then begin
            Compo.FindFirst();
            ILE.Reset;
            ILE.SetRange("Entry Type", ILE."Entry Type"::Consumption);
            ILE.SetRange("Document No.", OrderNo);
            ILE.SetFilter("Item No.", '1*|2*|5-FRS*|5-IQF*');
            if ILE.FindSet then
                repeat
                    Conso += ILE.Quantity;
                until ILE.Next = 0;
            // Il reste Compo."Remaining Qty. (Base)" + Conso) a consommer
            Conso := Compo."Remaining Qty. (Base)" + Conso;
            ProdOrder.Get(ProdOrder.Status::Released, OrderNo);
            ProdOrderFRS.Reset;
            ProdOrderFRS.SetRange("Due Date", ProdOrder."Due Date");
            ProdOrderFRS.SetRange("Source No.", Compo."Item No.");
            if ProdOrderFRS.Count = 1 then begin
                ProdOrderFRS.FindFirst;
                if (Conso > 0) then begin
                    AddProdOF2(ProdOrderFRS."No.", 10000, Compo."Item No.", Conso, ProdOrderFRS."Location Code", 0, '', '', '', CopyStr(Format(Date2DMY(ProdOrder."Starting Date", 3)), 3, 2) + '/' + Utils.PadLeft(Format(ProdOrder."Starting Date" - DMY2Date(1, 1, Date2DMY(ProdOrder."Starting Date", 3)) + 1), '0', 3), CreateDateTime(CalcDate('<+4D>', Today), 0T));
                    AddConsommationOF(OrderNo, OrderLine, Compo."Item No.", Conso, CopyStr(Format(Date2DMY(ProdOrder."Starting Date", 3)), 3, 2) + '/' + Utils.PadLeft(Format(ProdOrder."Starting Date" - DMY2Date(1, 1, Date2DMY(ProdOrder."Starting Date", 3)) + 1), '0', 3), CalcDate('<+4D>', Today));
                end;
            end;
        end;
    end;

    procedure CreateOTS(Emplacement: Text; IsRetour: Boolean): Code[20]
    var
        OTSh: Record "Transfer Header";
        OTSl: Record "Transfer Line";
    begin
        OTSh.Init;
        if IsRetour then begin
            if StrPos(Emplacement, 'ECCONGEL') > 0 then begin
                OTSh.Validate("Transfer-to Code", 'ECCONGEL');
                OTSh.Validate("Transfer-from Code", 'EC TOURNAI');
                OTSh.Emplacement := Utils.Replace(Emplacement, 'ECCONGEL;', '');
            end
            else begin
                if StrPos(Emplacement, 'C-DESTRUCT') > 0 then begin
                    OTSh.Validate("Transfer-to Code", 'C-DESTRUCT');
                    OTSh.Validate("Transfer-from Code", 'EC TOURNAI');
                    OTSh.Emplacement := Utils.Replace(Emplacement, 'C-DESTRUCT;', '');
                end
                else begin
                    Emplacement := Utils.Replace(Emplacement, 'EC STOCK;', '');
                    OTSh.Validate("Transfer-to Code", 'EC STOCK');
                    if (Emplacement <> 'CONGEL') and (Emplacement <> 'ECCONGEL') then OTSh.Validate("Transfer-from Code", 'EC TOURNAI');
                    if Emplacement = 'CONGEL' then
                        OTSh.Validate("Transfer-from Code", 'ECCONGEL');
                    if Emplacement = 'ECCONGEL' then
                        OTSh.Validate("Transfer-from Code", 'ECCONGEL');
                    OTSh.Emplacement := Emplacement;
                end;
            end;
        end
        else begin
            OTSh.Validate("Transfer-from Code", 'EC STOCK');
            if (Emplacement <> 'CONGEL') and (Emplacement <> 'RD') then OTSh.Validate("Transfer-to Code", 'EC TOURNAI');
            //IF Emplacement = 'DORMA' THEN
            //  OTSh.VALIDATE("Transfer-to Code",'EC DORMA');
            if Emplacement = 'CONGEL' then
                OTSh.Validate("Transfer-to Code", 'ECCONGEL');
            if Emplacement = 'RD' then
                OTSh.Validate("Transfer-to Code", 'RD');

            OTSh.Emplacement := Emplacement;
        end;
        OTSh.Validate("Posting Date", Today);
        OTSh.Validate("In-Transit Code", '9-TFT');
        OTSh.Insert(true);
        OTSl.Init;
        OTSl."Document No." := OTSh."No.";
        OTSl."Line No." := 500;
        OTSl."Transfer-from Code" := OTSh."Transfer-from Code";
        OTSl."Transfer-to Code" := OTSh."Transfer-to Code";
        OTSl.Description := 'OTS Magasin stock';
        OTSl.Insert;
        exit(OTSh."No.");
    end;

    procedure AddToOTS(OTSNo: Code[20]; SSCCNo: Code[20]; Qty: Decimal; Printer: Code[20])
    var
        TftL: Record "Transfer Line";
        recReservOTS: Record "Reservation Entry";
        Pallet: Record Pallet;
        NextSeq: Integer;
        TftH: Record "Transfer Header";
        NewLot: Code[50];
        NewDLC: Date;
        Items: Record Item;
    begin
        /*
        Logs.INIT;
        Logs."OF" := OTSNo;
        Logs.Log := 'AddOTS : ' + SSCCNo + '  ' + FORMAT(Qty);
        Logs.Date := CREATEDATETIME(TODAY,TIME);
        Logs.INSERT(TRUE);
        */
        Pallet.Get(SSCCNo);
        TftH.Get(OTSNo);

        TftL.Reset;
        TftL.SetRange("Document No.", OTSNo);
        NextSeq := 10000;
        if TftL.FindLast then
            NextSeq := TftL."Line No." + 10000;

        if TftH.Emplacement = 'CONSO' then begin
            Items.Get(Pallet."Item No.");
            if Items."Type de consommation" <> Items."Type de consommation"::"Négatif sur transfert du stock" then
                Error('Cet article ne peut pas être consommé automatiquement');
        end;

        TftL.Reset;
        TftL.Init;
        TftL."Document No." := OTSNo;
        TftL."Line No." := NextSeq;
        TftL.Validate("Item No.", Pallet."Item No.");
        TftL.Validate(Quantity, Qty);
        TftL.Insert(true);

        if Pallet."Lot No." <> '' then begin
            NewLot := Pallet."Lot No.";
            NewDLC := Pallet.DLC;
            if TftH."Transfer-to Code" = 'ECCONGEL' then
                if (StrPos(Pallet."Item No.", '5-FRS') > 0) or (StrPos(Pallet."Item No.", '5-MLX') > 0) then begin
                    Reclassement(Pallet."Item No.", Pallet."Lot No.", Pallet."Lot No." + '-C', CalcDate('<+1Y>', Pallet.DLC), Qty, TftH."Transfer-from Code", 'Congel' + Format(Today));
                end;
            recReservOTS.Reset;
            if recReservOTS.FindLast then NextSeq := recReservOTS."Entry No." + 1;
            recReservOTS.Reset;
            recReservOTS.Init;
            recReservOTS."Entry No." := NextSeq;
            recReservOTS.Positive := false;
            recReservOTS."Item No." := Pallet."Item No.";
            recReservOTS."Location Code" := TftH."Transfer-from Code";
            recReservOTS."Quantity (Base)" := -Qty;
            recReservOTS."Qty. to Handle (Base)" := -Qty;
            recReservOTS."Qty. to Invoice (Base)" := -Qty;
            recReservOTS."Source Type" := 5741;
            recReservOTS."Source Subtype" := 0;
            recReservOTS."Source ID" := TftH."No.";
            recReservOTS."Source Ref. No." := TftL."Line No.";
            recReservOTS."Shipment Date" := Today;
            recReservOTS."Warranty Date" := NewDLC;
            recReservOTS."Lot No." := NewLot;
            recReservOTS."Item Tracking" := recReservOTS."Item Tracking"::"Lot No.";
            recReservOTS."Reservation Status" := recReservOTS."Reservation Status"::Surplus;
            recReservOTS."Creation Date" := WorkDate;
            recReservOTS."Created By" := UserId;
            recReservOTS.Insert;

            recReservOTS.Reset;
            if recReservOTS.FindLast then NextSeq := recReservOTS."Entry No." + 1;
            recReservOTS.Reset;
            recReservOTS.Init;
            recReservOTS."Entry No." := NextSeq;
            recReservOTS.Positive := true;
            recReservOTS."Item No." := Pallet."Item No.";
            recReservOTS."Location Code" := TftH."Transfer-to Code";
            recReservOTS."Quantity (Base)" := Qty;
            recReservOTS."Qty. to Handle (Base)" := Qty;
            recReservOTS."Qty. to Invoice (Base)" := Qty;
            recReservOTS."Source Type" := 5741;
            recReservOTS."Source Subtype" := 1;
            recReservOTS."Source ID" := TftH."No.";
            recReservOTS."Source Ref. No." := TftL."Line No.";
            recReservOTS."Expected Receipt Date" := Today;
            recReservOTS."Warranty Date" := NewDLC;
            recReservOTS."Lot No." := NewLot;
            recReservOTS."Item Tracking" := recReservOTS."Item Tracking"::"Lot No.";
            recReservOTS."Reservation Status" := recReservOTS."Reservation Status"::Surplus;
            recReservOTS."Creation Date" := WorkDate;
            recReservOTS."Created By" := UserId;
            recReservOTS.Insert;
        end;

        recPalletIn.Reset;
        recPalletIn.Init;
        recPalletIn."Item No." := Pallet."Item No.";
        recPalletIn."Lot No." := NewLot;
        recPalletIn.NumOF := TftH."No.";
        recPalletIn.LigneOF := TftL."Line No.";
        recPalletIn."Quai reception" := Printer;
        recPalletIn."Quantite reception" := Qty;
        recPalletIn.DLC := NewDLC;
        recPalletIn."Location code" := TftH."Transfer-to Code";
        recPalletIn."Creation Date" := Today;
        recPalletIn."Creation Time" := Time;
        recPalletIn.Insert(true);
        if TftH."Transfer-from Code" = 'EC STOCK' then begin
            if Printer <> '' then
                PrintLabel(recPalletIn."SSCC No.");

            Pallet.NumOF := '';
            Pallet."Quantite reception" := Pallet."Quantite reception" - Qty;
            Pallet."Quai reception" := Printer;
            Pallet.Modify;
            if Printer <> '' then
                PrintLabel(Pallet."SSCC No.");
        end;

    end;

    procedure ReprintOTSLine(OTSNo: Code[20]; LineNo: Integer; Printer: Text)
    begin
        recPalletIn.Reset;
        recPalletIn.SetRange(NumOF, OTSNo);
        recPalletIn.SetRange(LigneOF, LineNo);
        if recPalletIn.FindLast then begin
            recPalletIn."Quai reception" := Printer;
            recPalletIn.Modify;

            if Printer <> '' then
                PrintLabel(recPalletIn."SSCC No.");
        end;
    end;

    procedure SendOTS(OTSNo: Code[20]; Printer: Code[20])
    var
        TransferPostShipment: Codeunit "TransferOrder-Post Shipment";
        TftH: Record "Transfer Header";
        TransferPostReceive: Codeunit "TransferOrder-Post Receipt";
    begin
        TftH.Get(OTSNo);
        TransferPostShipment.Run(TftH);
        PrintOTS(OTSNo, Printer);
        if TftH."Transfer-to Code" = 'C-DESTRUCT' then
            TransferPostReceive.Run(TftH);
        if TftH.Emplacement = 'CONSO' then begin
            TransferPostReceive.Run(TftH);
            ConsoOTS(OTSNo);
        end;
    end;

    procedure ReceiveOTS(OTSNo: Code[20]; Printer: Code[20])
    var
        TransferPostReceipt: Codeunit "TransferOrder-Post Receipt";
        TftH: Record "Transfer Header";
    begin
        TftH.Get(OTSNo);
        TransferPostReceipt.Run(TftH);
    end;

    procedure DeleteOTSLine(OTSNo: Code[20]; LineNo: Integer)
    var
        TftL: Record "Transfer Line";
        reserv: Record "Reservation Entry";
    begin
        TftL.Get(OTSNo, LineNo);
        TftL.Delete;
        reserv.Reset;
        reserv.SetRange("Source ID", OTSNo);
        reserv.SetRange("Source Ref. No.", LineNo);
        if reserv.FindFirst then reserv.DeleteAll();
    end;

    procedure PrintOTS(OrderNo: Code[20]; Printer: Text[30])
    var
        OTS: Record "Transfer Header";
        PrinterSelect: Record "Printer Selection";
        Utils: Codeunit Utils;
        FileName: Text[250];
        SessionId: Integer;
    begin

        PrinterSelect.Reset;
        PrinterSelect.SetRange("User ID", '');
        PrinterSelect.SetRange("Report ID", 50020);
        if PrinterSelect.FindFirst then begin
            PrinterSelect."Printer Name" := 'Printer_' + Printer;
            PrinterSelect.Modify;
        end
        else begin
            PrinterSelect.Init;
            PrinterSelect."User ID" := '';
            PrinterSelect."Report ID" := 50020;
            PrinterSelect."Printer Name" := 'Printer_' + Printer;
            PrinterSelect.Insert;
            ;

        end;
        OTS.Reset;
        OTS.SetRange("No.", OrderNo);
        OTS.FindFirst;
        REPORT.Run(50020, false, false, OTS);
    end;

    procedure PrintBesoins(DateProd: DateTime; Emplacement: Code[30]; Printer: Text[30])
    var
        OFs: Record "Production Order";
        PrinterSelect: Record "Printer Selection";
        Utils: Codeunit Utils;
        FileName: Text[250];
        SessionId: Integer;
    begin

        PrinterSelect.Reset;
        PrinterSelect.SetRange("User ID", '');
        PrinterSelect.SetRange("Report ID", 50025);
        if PrinterSelect.FindFirst then begin
            PrinterSelect."Printer Name" := 'Printer_' + Printer;
            PrinterSelect.Modify;
        end
        else begin
            PrinterSelect.Init;
            PrinterSelect."User ID" := '';
            PrinterSelect."Report ID" := 50025;
            PrinterSelect."Printer Name" := 'Printer_' + Printer;
            PrinterSelect.Insert;
            ;

        end;
        OFs.Reset;
        OFs.SetRange("Due Date", DT2Date(DateProd));
        OFs.SetRange(Emplacement, Emplacement);
        OFs.SetRange("Location Code", 'EC TOURNAI');
        OFs.FindFirst;
        REPORT.Run(50025, false, false, OFs);
    end;

    procedure DeleteOTS(OTSNo: Code[20])
    var
        TftH: Record "Transfer Header";
    begin
        TftH.Get(OTSNo);
        TftH.Delete(true);
    end;

    procedure Declassement(OrderNo: Code[20]; OrderLine: Integer; Qty: Decimal; Printer: Text)
    var
        ILE: Record "Item Ledger Entry";
    begin
        ILE.Reset;
        ILE.SetRange("Entry Type", ILE."Entry Type"::Output);
        ILE.SetRange("Order No.", OrderNo);
        if ILE.FindLast then begin
            Reclassement(ILE."Item No.", ILE."Lot No.", ILE."Lot No." + '-DECLAS', CalcDate('<+15D>', Today), Qty, ILE."Location Code", OrderNo);
            recPalletIn.Reset;
            recPalletIn.Init;
            recPalletIn."Lot No." := ILE."Lot No." + '-DECLAS';
            recPalletIn."Quai reception" := Printer;
            recPalletIn.NumOF := OrderNo;
            recPalletIn."Quantite reception" := Qty;
            recPalletIn.DLC := CalcDate('<+15D>', Today);
            recPalletIn."Item No." := ILE."Item No.";
            recPalletIn."Location code" := ILE."Location Code";
            recPalletIn."Creation Date" := Today;
            recPalletIn."Creation Time" := Time;
            recPalletIn.Insert(true);
            PrintLabel(recPalletIn."SSCC No.");
        end;
    end;

    procedure DeclassementPallet(SSCCNo: Code[20]; Qty: Decimal; Printer: Text)
    var
        ILE: Record "Item Ledger Entry";
        Palet: Record Pallet;
    begin
        Palet.Get(SSCCNo);
        Reclassement(Palet."Item No.", Palet."Lot No.", Palet."Lot No." + '-DECLAS', CalcDate('<+15D>', Today), Qty, Palet."Location code", SSCCNo);
        recPalletIn.Reset;
        recPalletIn.Init;
        recPalletIn."Lot No." := Palet."Lot No." + '-DECLAS';
        recPalletIn."Quai reception" := Printer;
        recPalletIn."Quantite reception" := Qty;
        recPalletIn.DLC := CalcDate('<+15D>', Today);
        recPalletIn."Item No." := Palet."Item No.";
        recPalletIn."Location code" := Palet."Location code";
        recPalletIn."Creation Date" := Today;
        recPalletIn."Creation Time" := Time;
        recPalletIn.Insert(true);
        PrintLabel(recPalletIn."SSCC No.");
    end;

    procedure GeneratePalletExp(Cmd: Code[20])
    var
        SalesH: Record "Sales Header";
        SalesShipH: Record "Sales Shipment Header";
        CuProd: Codeunit "Integration Tft and Prod";
    begin
        if SalesH.Get(SalesH."Document Type"::Order, Cmd) then begin
            if SalesH."Last Shipping No." <> '' then
                CuProd.PalettesExp(SalesH."Last Shipping No.")
            else
                CuProd.PalettesCmd(Cmd);
        end
        else begin
            SalesShipH.Reset;
            SalesShipH.SetRange("Order No.", Cmd);
            if SalesShipH.FindFirst then
                CuProd.PalettesExp(SalesShipH."No.");
        end;
    end;

    procedure PrintPalletExp(SSCCNo: Code[20]; Cmd: Code[20])
    var
        RepFicheLot: Report "Fiche palette expedition + lot";
        RepFiche: Report "Fiche palette expedition";
        Pal: Record Pallet;
        _exv: Record "Sales Shipment Header";
        _cmd: Record "Sales Header";
        ClientNo: Code[20];
        Find: Boolean;
        RepFicheTello: Report "Fiche palette exp TELLO";
    begin
        Pal.Reset;
        if SSCCNo <> '' then
            Pal.SetRange("SSCC No.", SSCCNo);
        if Cmd <> '' then
            Pal.SetRange("Outbound Document No.", Cmd);
        if Cmd <> '' then
            if _cmd.Get(_cmd."Document Type"::Order, Cmd) then
                ClientNo := _cmd."Sell-to Customer No.";
        if Cmd <> '' then
            if _exv.Get(Cmd) then
                ClientNo := _exv."Sell-to Customer No.";

        if Pal.FindFirst then begin
            if (Pal."Lot No." <> '') then begin
                Find := true;
                if ClientNo = 'C03941' then begin
                    RepFicheTello.UseRequestPage(true);
                    RepFicheTello.setTempRec(Pal, Cmd);
                    RepFicheTello.Run();
                    Find := true;
                end;
                if not Find then begin
                    RepFicheLot.UseRequestPage(true);
                    //RepFicheLot.LANGUAGE := Language.GetLanguageID(Lng);
                    //RepFicheLot.setLanguage(Lng);
                    RepFicheLot.setTempRec(Pal, Cmd);
                    RepFicheLot.Run();
                end;
            end
            else begin
                RepFiche.UseRequestPage(true);
                RepFiche.setTempRec(Pal, Cmd);
                RepFiche.Run();
            end;
        end;
    end;

    procedure PrintLabel2(SSCCNo: Code[20])
    var
        StreamWriter: DotNet StreamWriter;
        TcpClient: DotNet TcpClient;
        Encoding: DotNet Encoding;
        Pallet: Record Pallet;
        i: Integer;
        Items: Record Item;
        recOF: Record "Production Order";
    begin

        Pallet.Get(SSCCNo);
        if Pallet."Quai reception" <> '' then begin
            Params.SetRange("Table No", 50018);
            Params.SetRange("Field No", 55009);
            Params.SetRange(Code, 'PRINT_' + Pallet."Quai reception");
            if not Params.FindFirst then Error('Imprimante non trouvée ' + 'PRINT_' + Pallet."Quai reception");

            //PrintReceipt('REA-E18-03689',Pallet."Quai reception");



            TcpClient := TcpClient.TcpClient();
            TcpClient.Connect(Params.Description, 9100);

            // Create instance of StreamWriter class and set Encoding
            StreamWriter := StreamWriter.StreamWriter(TcpClient.GetStream(), Encoding.UTF8);

            StreamWriter.WriteLine('^XA');
            StreamWriter.WriteLine('^PON^PMN^LH0,0^JMA^LRN');

            StreamWriter.WriteLine('^BY3,45,120^FT50,190^B3N,N,,Y,N');
            StreamWriter.WriteLine('^FD' + Pallet."SSCC No." + '^FS');

            Pallet.CalcFields("Item Description");

            StreamWriter.WriteLine('^FT60,260^ACN,36,20^FH\^FD' + Pallet."Item Description" + '^FS');
            StreamWriter.WriteLine('^FT60,380^ADN,105,20^FH\^FD' + Pallet."Item No." + '^FS');

            if (recOF.Get(recOF.Status::Released, Pallet."Inbound Document No.")) then
                if (recOF.Ordre <> '') then
                    StreamWriter.WriteLine('^FT620,310^ADN,36,20^FH\^FD' + recOF.Ordre + '^FS');

            if (Pallet."Outbound Document No." <> '') then
                StreamWriter.WriteLine('^FT400,310^ADN,36,20^FH\^FD' + Pallet."Outbound Document No." + '^FS');

            StreamWriter.WriteLine('^FT60,430^ACN,36,20^FH\^FDLot^FS');
            StreamWriter.WriteLine('^FT170,430^ACN,36,20^FH\^FD' + Pallet."Lot No." + '^FS');
            StreamWriter.WriteLine('^FT60,490^ACN,36,20^FH\^FDDLC^FS');
            StreamWriter.WriteLine('^FT400,490^ACN,36,10^FH\^FD' + Format(Pallet.DLC, 0, '<Day,2>/<Month,2>/<Year4>') + '^FS');
            if Pallet."Quantite reception" > 0 then begin
                StreamWriter.WriteLine('^FT60,540^ACN,36,20^FH\^FDPoids^FS');
                if Items.Get(Pallet."Item No.") then
                    StreamWriter.WriteLine('^FT380,540^ACN,36,10^FH\^FD' + Format(Pallet."Quantite reception") + ' ' + Items."Base Unit of Measure" + '^FS')
                else
                    StreamWriter.WriteLine('^FT380,540^ACN,36,10^FH\^FD' + Format(Pallet."Quantite reception") + ' Kg^FS');
            end
            else begin
                StreamWriter.WriteLine('^FT40,540^ACN,36,20^FH\^FDRef^FS');
                StreamWriter.WriteLine('^FT380,540^ACN,36,10^FH\^FD' + Pallet.NumOF + '^FS')
            end;


            StreamWriter.WriteLine('^FT620,540^ACN,36,10^FH\^FD' + 'BE B102454 CE' + '^FS');


            StreamWriter.WriteLine('^PQ1,0,1,Y^XZ');


            StreamWriter.Close();
            TcpClient.Close();
        end;
    end;

    procedure PrintLabel150(SSCCNo: Code[20])
    var
        StreamWriter: DotNet StreamWriter;
        TcpClient: DotNet TcpClient;
        Encoding: DotNet Encoding;
        Pallet: Record Pallet;
        i: Integer;
        Items: Record Item;
        recOF: Record "Production Order";
        r: Report Pallet150;
    begin
        Clear(r);
        Pallet.Reset;
        Pallet.SetFilter("SSCC No.", SSCCNo);
        if Pallet.FindFirst then
            if Pallet."Quai reception" <> '' then begin
                r.SetTableView(Pallet);
                r.UseRequestPage := false;
                r.Print('', 'PRINTER_' + Pallet."Quai reception");
            end;
    end;

    procedure ModifDtProd(ProdNo: Code[20]; NewDate: DateTime)
    var
        Prod: Record "Production Order";
        ILE: Record "Item Ledger Entry";
        ProdL: Record "Prod. Order Line";
    begin
        ILE.Reset;
        ILE.SetRange("Document No.", ProdNo);
        if ILE.FindFirst then exit;

        Prod.Reset;
        Prod.SetFilter("No.", ProdNo);
        Prod.FindFirst;
        ProdL.Reset;
        ProdL.SetRange("Prod. Order No.", ProdNo);
        if ProdL.FindFirst then
            Prod."Production BOM Version" := ProdL."Production BOM Version Code";
        Prod.Validate("Due Date", DT2Date(NewDate));
        Prod.Validate("Starting Date-Time", CreateDateTime(DT2Date(NewDate), DT2Time(Prod."Starting Date-Time")));
        Prod.Validate("Ending Date-Time", CreateDateTime(DT2Date(NewDate), DT2Time(Prod."Ending Date-Time")));

        Prod.Modify;

        REPORT.Run(REPORT::"Refresh Production Order", false, true, Prod);
    end;

    procedure PrintEpicesTournai(Printer: Text[30])
    var
        OTS: Record "Transfer Header";
        PrinterSelect: Record "Printer Selection";
        Utils: Codeunit Utils;
        FileName: Text[250];
        SessionId: Integer;
    begin

        PrinterSelect.Reset;
        PrinterSelect.SetRange("User ID", '');
        PrinterSelect.SetRange("Report ID", 50039);
        if PrinterSelect.FindFirst then begin
            PrinterSelect."Printer Name" := 'Printer_' + Printer;
            PrinterSelect.Modify;
        end
        else begin
            PrinterSelect.Init;
            PrinterSelect."User ID" := '';
            PrinterSelect."Report ID" := 50039;
            PrinterSelect."Printer Name" := 'Printer_' + Printer;
            PrinterSelect.Insert;
            ;

        end;
        REPORT.Run(50039, false, false);
    end;

    procedure CancelConsumption(EntryNo: Integer; Qty: Decimal)
    var
        ItemJnlLine: Record "Item Journal Line";
        ReservEntry: Record "Reservation Entry";
        ILE: Record "Item Ledger Entry";
        NextSeq: Integer;
    begin
        ILE.Get(EntryNo);
        ItemJnlLine.Reset;
        ItemJnlLine.Init;
        ItemJnlLine."Journal Template Name" := 'CONSOMMATI';
        ItemJnlLine."Journal Batch Name" := 'AUTO';
        ItemJnlLine."Source Code" := 'FCONSO';
        ItemJnlLine."Line No." := 1;
        ItemJnlLine.Validate("Posting Date", Today);
        ItemJnlLine.Validate("Item No.", ILE."Item No.");
        ItemJnlLine.Validate("Entry Type", ItemJnlLine."Entry Type"::Consumption);
        ItemJnlLine.Validate("Order No.", ILE."Order No.");
        ItemJnlLine.Validate("Order Line No.", ILE."Order Line No.");
        ItemJnlLine.Validate("Prod. Order Comp. Line No.", ILE."Prod. Order Comp. Line No.");
        ItemJnlLine.Validate("Item No.", ILE."Item No.");
        ItemJnlLine.Validate("Location Code", ILE."Location Code");
        ItemJnlLine.Validate("Quantity (Base)", -Qty);
        ItemJnlLine.Validate(Description, ILE.Description);
        ItemJnlLine.Insert();

        ReservEntry.Reset;
        if ReservEntry.FindLast then NextSeq := ReservEntry."Entry No." + 1;
        ReservEntry.Init;
        ReservEntry."Entry No." := NextSeq;
        ReservEntry.Validate("Item No.", ILE."Item No.");
        ReservEntry.Validate("Location Code", ILE."Location Code");
        ReservEntry.Validate("Quantity (Base)", Qty);
        ReservEntry.Positive := true;
        ReservEntry."Reservation Status" := ReservEntry."Reservation Status"::Prospect;
        ReservEntry."Source Type" := 83;
        ReservEntry."Source Subtype" := 5;
        ReservEntry."Source ID" := 'CONSOMMATI';
        ReservEntry."Source Batch Name" := 'AUTO';
        ReservEntry."Source Ref. No." := 1;
        ReservEntry."Source Prod. Order Line" := 0;
        ReservEntry."Lot No." := ILE."Lot No.";
        ReservEntry."Warranty Date" := ILE."Warranty Date";
        ReservEntry."Item Tracking" := ReservEntry."Item Tracking"::"Lot No.";
        ReservEntry."Appl.-from Item Entry" := EntryNo;
        ReservEntry.Insert;
        ItemJnlLine.PostingItemJnlFromProduction(false);
    end;

    procedure TerminateCDV(No: Code[20])
    var
        SalesH: Record "Sales Header";
        SalesL: Record "Sales Line";
        reserv: Record "Reservation Entry";
        item: Record Item;
        qty: Decimal;
    begin

        if SalesH.Get(SalesH."Document Type"::Order, No) then begin
            SalesH."Bon Pour Expédition" := SalesH."Bon Pour Expédition"::"Shipment authorized";
            SalesH.Modify(true);
            SalesL.Reset;
            SalesL.SetRange("Document Type", SalesH."Document Type");
            SalesL.SetRange("Document No.", SalesH."No.");
            SalesL.SetRange(Type, SalesL.Type::Item);
            SalesL.SetFilter("No.", '1-*');
            if SalesL.FindSet then
                repeat
                    qty := SalesL."Quantity (Base)";
                    reserv.Reset;
                    reserv.SetRange("Source Type", 37);
                    reserv.SetRange("Source ID", No);
                    reserv.SetRange("Source Ref. No.", SalesL."Line No.");
                    if reserv.FindSet then
                        repeat
                            qty += reserv."Quantity (Base)";
                        until reserv.Next = 0;
                    if qty <> 0 then begin
                        emailmsg.Create('g.dangremont@europacuisson.com;ProdToSales@europacuisson.com', 'Commande validée en production avec différence', 'Commande : ' + No + '   article    : ' + SalesL."No." + ' différence de quantité  ' + Format(SalesL."Quantity (Base)"), false);
                        emailsend.Send(emailmsg, enum::"Email Scenario"::Default);
                    end
                    else begin
                        item.Get(SalesL."No.");
                        if item."Option production" = item."Option production"::"Sur commande" then begin
                            item.CalcFields(Inventory);
                            if (item.Inventory > SalesL."Quantity (Base)") then begin
                                emailmsg.Create('g.dangremont@europacuisson.com;ProdToSales@europacuisson.com', 'Commande validée en production, mais il reste du stock client !!', 'Commande : ' + No + '   article    : ' + SalesL."No." + ' différence de quantité  ' + Format(SalesL."Quantity (Base)"), false);
                                emailsend.Send(emailmsg, enum::"Email Scenario"::Default);
                            end;

                        end;

                    end;
                until SalesL.Next = 0;

        end;
    end;

    procedure CreateOFFromConso(ItemCode: Code[20]; Emplacement: Code[20]) OrderNo: Code[20]
    var
        Cu5510: Codeunit "Production Journal Mgt";
        ProdOrder: Record "Production Order";
        ReservEntry: Record "Reservation Entry";
        NextSeq: Integer;
        ItemProduit: Code[20];
        CuProd: Codeunit "Integration Tft and Prod";
        ProdOrderLine: Record "Prod. Order Line";
    begin
        OrderNo := '';
        if (StrPos(ItemCode, '5-FSV') > 0) then begin
            OrderNo := CreateOFRepasto(ItemCode, Emplacement);
            exit;
        end;
        if (ItemCode <> '7-CTB-00001') and (ItemCode <> '7-CTB-00002') and (StrPos(ItemCode, '5-FAP') = 0) then
            Error('Pas d''ordre de production');

        ItemProduit := CuProd.GetFirstItemProduitByItem(ItemCode);
        ProdOrder.Reset;
        ProdOrder.SetRange("Due Date", Today);
        ProdOrder.SetRange("Source No.", ItemProduit);
        if ProdOrder.FindFirst then
            Error('Il existe déjà un OF');
        ProdOrder.Init;
        ProdOrder.Status := ProdOrder.Status::Released;
        ProdOrder.Insert(true);
        ProdOrder.Validate("Starting Date", Today);
        ProdOrder."Starting Date-Time" := CreateDateTime(Today, Time);
        ProdOrder.Validate("Ending Date", Today);
        ProdOrder."Ending Date-Time" := CreateDateTime(Today, Time);
        ProdOrder.Validate("Due Date", ProdOrder."Ending Date");
        ProdOrder.Validate(Quantity, 1000);
        ProdOrder.Validate("Source Type", ProdOrder."Source Type"::Item);

        ProdOrder.Validate("Source No.", ItemProduit);
        ProdOrder.Validate("Location Code", 'EC TOURNAI');
        ProdOrder.Validate("Starting Date", Today);
        ProdOrder.Validate("Due Date", ProdOrder."Ending Date");
        ProdOrder.Emplacement := Emplacement;
        ProdOrder.Modify(true);
        OrderNo := ProdOrder."No.";
        ProdOrder.Reset;
        ProdOrder.SetRange("No.", OrderNo);
        if ProdOrder.FindFirst then begin

            if (StrPos(UpperCase(UserId), 'CCSADMIN') = 0) then
                REPORT.Run(REPORT::"Refresh Production Order", false, true, ProdOrder);
        end;

        CuProd.RefreshABC(OrderNo);
    end;

    procedure CreateOFRepasto(ItemCode: Code[20]; Emplacement: Code[20]) OrderNo: Code[20]
    var
        Cu5510: Codeunit "Production Journal Mgt";
        ProdOrder: Record "Production Order";
        ReservEntry: Record "Reservation Entry";
        NextSeq: Integer;
        ItemProduit: Code[20];
        CuProd: Codeunit "Integration Tft and Prod";
        ProdOrderLine: Record "Prod. Order Line";
        Compo: Record "Prod. Order Component";
    begin
        OrderNo := '';

        //ERROR('Indisponible');

        ProdOrder.Reset;
        ProdOrder.SetRange("Due Date", Today);
        ProdOrder.SetRange("Source No.", ItemProduit);
        if ProdOrder.FindFirst then
            Error('Il existe déjà un OF');
        ProdOrder.Init;
        ProdOrder.Status := ProdOrder.Status::Released;
        ProdOrder.Insert(true);
        ProdOrder.Validate("Starting Date", Today);
        ProdOrder."Starting Date-Time" := CreateDateTime(Today, Time);
        ProdOrder.Validate("Ending Date", Today);
        ProdOrder."Ending Date-Time" := CreateDateTime(Today, Time);
        ProdOrder.Validate("Due Date", ProdOrder."Ending Date");
        ProdOrder.Validate(Quantity, 1000);
        ProdOrder.Validate("Source Type", ProdOrder."Source Type"::Item);

        ProdOrder.Validate("Source No.", ItemCode);
        ProdOrder.Validate("Location Code", 'EC TOURNAI');
        ProdOrder.Validate("Starting Date", Today);
        ProdOrder.Validate("Due Date", ProdOrder."Ending Date");
        ProdOrder.Emplacement := Emplacement;
        ProdOrder.Recyclage := true;
        ProdOrder."Recyclage VP" := 'REPASTO';
        ProdOrder.Modify(true);
        OrderNo := ProdOrder."No.";
        ProdOrder.Reset;
        ProdOrder.SetRange("No.", OrderNo);
        if ProdOrder.FindFirst then begin
            if (StrPos(UpperCase(UserId), 'CCSADMIN') = 0) then
                REPORT.Run(REPORT::"Refresh Production Order", false, true, ProdOrder);
        end;
        CuProd.RefreshABC(OrderNo);

        Compo.Reset;
        Compo.SetRange(Status, ProdOrder.Status);
        Compo.SetRange("Prod. Order No.", OrderNo);
        Compo.DeleteAll;
        Compo.Reset;
        Compo.Init;
        Compo.Status := ProdOrder.Status;
        Compo."Prod. Order No." := OrderNo;
        Compo."Prod. Order Line No." := 10000;
        Compo."Line No." := 10000;
        Compo.Validate("Item No.", ItemCode);
        Compo.Validate("Quantity per", 1);
        Compo.Validate(Quantity, 1000);
        Compo.Insert(true);
    end;

    procedure CancelProduction(SSCCNo: Code[20])
    var
        ItemJnlLine: Record "Item Journal Line";
        ReservEntry: Record "Reservation Entry";
        ILE: Record "Item Ledger Entry";
        NextSeq: Integer;
        Palet: Record Pallet;
        PaletEntry: Record "Pallet Ledger Entry";
    begin
        Palet.Get(SSCCNo);
        Palet.CalcFields("Last Entry No.");
        PaletEntry.Get(Palet."Last Entry No.");
        ILE.Get(PaletEntry."Item ledger entry No.");
        if ILE."Remaining Quantity" <> ILE.Quantity then
            Error('La palette a déjà été consommée');
        ItemJnlLine.Reset;
        ItemJnlLine.Init;
        ItemJnlLine."Journal Template Name" := 'PRODUCTION';
        ItemJnlLine."Journal Batch Name" := 'AUTO';
        ItemJnlLine."Source Code" := 'FPRODOF';
        ItemJnlLine."Line No." := 1;
        ItemJnlLine.Validate("Posting Date", Today);
        ItemJnlLine.Validate("Item No.", ILE."Item No.");
        ItemJnlLine.Validate("Entry Type", ItemJnlLine."Entry Type"::Output);
        ItemJnlLine.Validate("Order No.", ILE."Order No.");
        ItemJnlLine.Validate("Order Line No.", ILE."Order Line No.");
        ItemJnlLine.Validate("Prod. Order Comp. Line No.", ILE."Prod. Order Comp. Line No.");
        ItemJnlLine.Validate("Location Code", ILE."Location Code");
        ItemJnlLine.Validate("Item No.", ILE."Item No.");
        ItemJnlLine.Validate("Output Quantity (Base)", -ILE.Quantity);
        ItemJnlLine.Validate("Operation No.", '10');
        ItemJnlLine.Validate(Type, ItemJnlLine.Type::"Work Center");
        ItemJnlLine.Validate("No.", 'ATELIERS');

        ItemJnlLine.Insert();

        ReservEntry.Reset;
        if ReservEntry.FindLast then NextSeq := ReservEntry."Entry No." + 1;
        ReservEntry.Init;
        ReservEntry."Creation Date" := Today;
        ReservEntry."Entry No." := NextSeq;
        ReservEntry.Validate("Item No.", ILE."Item No.");
        ReservEntry.Validate("Location Code", ILE."Location Code");
        ReservEntry.Validate("Quantity (Base)", -ILE.Quantity);
        ReservEntry.Positive := false;
        ReservEntry."Reservation Status" := ReservEntry."Reservation Status"::Prospect;
        ReservEntry."Source Type" := 83;
        ReservEntry."Source Subtype" := 6;
        ReservEntry."Source ID" := 'PRODUCTION';
        ReservEntry."Source Batch Name" := 'AUTO';
        ReservEntry."Source Ref. No." := 1;
        ReservEntry."Source Prod. Order Line" := 0;
        ReservEntry."Lot No." := ILE."Lot No.";
        ReservEntry."Warranty Date" := ILE."Warranty Date";
        ReservEntry."Item Tracking" := ReservEntry."Item Tracking"::"Lot No.";
        ReservEntry."Appl.-to Item Entry" := ILE."Entry No.";
        ReservEntry.Insert;
        ItemJnlLine.PostingItemJnlFromProduction(false);

        PaletEntry.Delete;
        Palet."Inbound Document No." := Palet."Inbound Document No." + '-CANCEL';
        Palet.Modify;
    end;

    [Scope('OnPrem')]
    procedure IsPaletContent(SSCCNo: Code[20]) AskContent: Boolean
    var
        Palet: Record Pallet;
        SalesH: Record "Sales Header";
    begin
        AskContent := false;
        Palet.Get(SSCCNo);
        if Palet."Outbound Document No." <> '' then
            if SalesH.Get(SalesH."Document Type"::Order, Palet."Outbound Document No.") then
                if SalesH."Sell-to Customer No." = 'C03941' then
                    AskContent := true;
        if (Palet."Item No." = '1-FSV-00426') then AskContent := true;
        //AskContent := TRUE;
    end;

    local procedure ConsoOTS(OTSNo: Code[20])
    var
        RcptH: Record "Transfer Receipt Header";
        RcptL: Record "Transfer Receipt Line";
        ItemJnl: Record "Item Journal Line";
        NextNo: Integer;
    begin
        RcptH.Reset;
        RcptH.SetRange("Transfer Order No.", OTSNo);
        if RcptH.FindFirst then begin
            RcptL.Reset;
            RcptL.SetRange("Document No.", RcptH."No.");
            RcptL.SetFilter("Item No.", '<>''''');
            NextNo := 10000;
            if RcptL.FindSet then
                repeat
                    ItemJnl.Reset;
                    ItemJnl.SetRange("Journal Template Name", 'ARTICLE');
                    ItemJnl.SetRange("Journal Batch Name", 'CONSOAUTO');
                    ItemJnl.DeleteAll();

                    ItemJnl.Init;
                    ItemJnl."Journal Template Name" := 'ARTICLE';
                    ItemJnl."Journal Batch Name" := 'CONSOAUTO';
                    ItemJnl."Line No." := NextNo;
                    ItemJnl."Entry Type" := ItemJnl."Entry Type"::"Negative Adjmt.";
                    ItemJnl."Document No." := 'CONSOAUTO';
                    ItemJnl."Location Code" := RcptH."Transfer-to Code";
                    ItemJnl.Validate("Posting Date", Today);
                    ItemJnl.Validate("Item No.", RcptL."Item No.");
                    ItemJnl.Validate(Quantity, RcptL."Quantity (Base)");
                    ItemJnl.Insert(true);
                until RcptL.Next = 0;
        end;
    end;

    procedure SetEffectif(OFNo: Code[20]; Effectif: Integer)
    var
        ProdH: Record "Production Order";
    begin
        ProdH.Reset;
        if ProdH.Get(ProdH.Status::Released, OFNo) then begin
            ProdH."Activite1 Effectif" := Effectif;
            ProdH.Modify;
        end;
    end;
}

