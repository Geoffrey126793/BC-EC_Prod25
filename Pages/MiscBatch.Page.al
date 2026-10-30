page 50069 "Misc Batch"
{
    Caption = 'Misc Batch';
    InstructionalText = 'Test';
    Permissions = TableData "Item Ledger Entry" = rimd,
                  TableData "Sales Shipment Header" = rimd,
                  TableData "Sales Shipment Line" = rimd,
                  TableData "Sales Invoice Header" = rimd,
                  TableData "Value Entry" = rimd,
                  TableData "Warehouse Entry" = rimd;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
        }
    }

    actions
    {
        area(creation)
        {
            action("1")
            {
                Caption = '1';

                trigger OnAction()
                var

                    scan: Codeunit "WS Scan";
                    pal: Record Pallet;
                    pg: Page "Prévisions ventes";
                    Items: Record Item;
                    T111: Record "Sales Shipment Line";
                    T472: Record "Job Queue Entry";
                    Vend: Record Vendor;
                    T39: Record "Purchase Line";
                    RecPallet_l: Record Pallet;
                    T32: Record "Item Ledger Entry";
                    T337: Record "Reservation Entry";
                    T83: Record "Item Journal Line";
                    i: Integer;
                    NextSeq: Integer;
                    Cu50039: Codeunit EDI;
                    T27: Record Item;
                    iC: Integer;
                    iCount: Integer;
                    T5406: Record "Prod. Order Line";
                    cuVP: Codeunit "Call WS";
                    FileMgt: Codeunit "File Management";
                    Tq: Record "Job Queue Entry";
                    r: Record "Sales Line DiscountEC";
                    r2: Record "Sales Line DiscountEC";
                    c: Record PaletContent;
                    T222b: Record "Ship-to Address";
                    emailmsg: Codeunit "Email Message";
                    emailsend: Codeunit Email;
                begin
                    emailmsg.Create('g.dangremont@europacuisson.com', 'Subject1', 'body1', true);
                    emailmsg.AppendToBody('test2');
                    emailsend.Send(emailmsg, Enum::"Email Scenario"::Default);

                    Message('ok');
                end;
            }
            action("2")
            {
                Caption = '2';

                trigger OnAction()
                var

                    scan: Codeunit "WS Scan";
                    pal: Record Pallet;
                    pg: Page "Prévisions ventes";
                    Items: Record Item;
                    T111: Record "Sales Shipment Line";
                    T472: Record "Job Queue Entry";
                    Vend: Record Vendor;
                    T39: Record "Purchase Line";
                    RecPallet_l: Record Pallet;
                    T32: Record "Item Ledger Entry";
                    T337: Record "Reservation Entry";
                    T83: Record "Item Journal Line";
                    i: Integer;
                    NextSeq: Integer;
                    CUProd: Codeunit "Integration Tft and Prod";
                    T14: Record Location;
                    CU50046: Codeunit Integration_Items;
                    T7312: Record "Warehouse Entry";
                    CU5407: Codeunit "Prod. Order Status Management";
                    r: Record "Manufacturing Setup";
                    c: Code[10];
                    CU50012: Codeunit "Prod. Order Status Manageme EC";
                begin

                    T36.Reset;
                    T36.SetRange("Location Code", 'RD');
                    T36.SetRange("Promised Delivery Date", 20210101D, 20250630D);
                    Message('%1', T36.Count);
                    T36.DeleteAll;

                    Message('ok');
                end;
            }
            action("Rééval1")
            {

                trigger OnAction()
                var
                    ILE: Record "Item Ledger Entry";
                    ItemJnl: Record "Item Journal Line";
                    Items: Record Item;
                    iC: Integer;
                    iCount: Integer;
                    dlg: Dialog;
                    cost: Decimal;
                    CLE: Record "Capacity Ledger Entry";
                    DoWork: Boolean;
                    Qty: Decimal;
                    VE: Record "Value Entry";
                    Msg: Text;
                begin
                    dlg.Open('@1@@@@@@@@@@@@@@@@@@@@@@');
                    //Items.RESET;
                    //Items.SETRANGE(Blocked,FALSE);
                    //IF Items.FINDSET THEN
                    //REPEAT
                    //  Items.PrevisionVenteMensuelle := Items.GetMatriceCost(TODAY);
                    //  Items.MODIFY;
                    //UNTIL Items.NEXT=0;

                    iC := 1;
                    ILE.Reset;
                    //ILE.SETRANGE("Posting Date",010120D,170320D);
                    ILE.SetFilter("Item No.", '1*|2*|5*');
                    //ILE.SETRANGE("Entry Type",ILE."Entry Type"::Output);
                    ILE.SetFilter("Remaining Quantity", '>0');
                    //ILE.SETFILTER("Entry No.",'<%1',4146831);
                    ILE.SetFilter("Location Code", '<>RD');
                    ILE.SetRange("Completely Invoiced", true);
                    //ILE.SETRANGE("Item No.",'1-IQF-01031');
                    ILE.SetFilter("Posting Date", '<%1', 20210801D);

                    iCount := ILE.Count;
                    if ILE.FindSet then
                        repeat
                            Items.Get(ILE."Item No.");

                            if not Items.Blocked then begin
                                ItemJnl.Reset;
                                ItemJnl.Init;
                                ItemJnl."Journal Template Name" := 'RÉÉVALUATI';
                                ItemJnl."Journal Batch Name" := 'VR';
                                ItemJnl."Source Code" := 'FREEVAL';
                                ItemJnl."Document No." := 'DEL_ATELIERS';
                                ItemJnl."Line No." := iC;
                                ItemJnl."Value Entry Type" := ItemJnl."Value Entry Type"::Revaluation;
                                ItemJnl.Validate("Item No.", ILE."Item No.");
                                ItemJnl.Validate("Applies-to Entry", ILE."Entry No.");
                                ItemJnl.Validate("Posting Date", 20210731D);
                                ItemJnl.Validate("Inventory Value (Revalued)", ItemJnl."Quantity (Base)" * GetMP(ILE, Msg));

                                if (ItemJnl."Inventory Value (Revalued)" <> 0) and (ItemJnl.Amount <> 0) then
                                    ItemJnl.Insert;

                            end;

                            iC += 1;
                            dlg.Update(1, Round(iC / iCount * 10000, 1));
                        until ILE.Next = 0;
                    dlg.Close;
                    Message(Msg);
                end;
            }
            action("Valid pal")
            {

                trigger OnAction()
                var
                    dlg: Dialog;
                    PalletJnl: Record "Pallet Journal";
                    CUscan: Codeunit "Scan Management";
                    iCount: Integer;
                    iC: Integer;
                    No: Code[20];
                    SaleL: Record "Sales Line";
                    TftL: Record "Transfer Line";
                begin
                    No := 'OTS-E21-00611';

                    dlg.Open('@1@@@@@@@@@@@@@@@@@@@@@@');
                    PalletJnl.Reset;
                    PalletJnl.SetRange("Document No.", No);
                    iCount := PalletJnl.Count;
                    iC := 1;
                    if PalletJnl.FindSet then
                        repeat
                            CUscan.PutAwayPalletWithUser(PalletJnl."SSCC No.", 'DEPART3', '');
                            iC := iC + 1;
                            dlg.Update(1, Round(iC / iCount * 10000, 1));
                        until PalletJnl.Next = 0;
                    dlg.Close;


                    SaleL.Reset;
                    SaleL.SetRange("Document Type", SaleL."Document Type"::Order);
                    SaleL.SetRange("Document No.", No);
                    if SaleL.FindSet then
                        repeat
                            SaleL."Bin Code" := 'DEPART3';
                            SaleL.Modify;
                        until SaleL.Next = 0;


                    TftL.Reset;
                    TftL.SetRange("Document No.", No);
                    if TftL.FindSet then
                        repeat
                            TftL."Transfer-from Bin Code" := 'DEPART3';
                            TftL.Modify;
                        until TftL.Next = 0;






                    Message('Fini');
                end;
            }
            action(corrPalJnl)
            {

                trigger OnAction()
                var
                    PaletJnl: Record "Pallet Journal";
                    RecPalletEntry: Record "Pallet Ledger Entry";
                    RecPalletEntryOld: Record "Pallet Ledger Entry";
                    cmd: Record "Sales Header";
                    ok: Boolean;
                    Pal: Record Pallet;
                begin
                    CorrPal('000000374035', 'DEPART3', '374035/21105-3');
                    CorrPal('000000805984', '1-A-142-1', '805984/23188-3');
                    CorrPal('000000831732', '1-E-133-3', '23171-3');
                    CorrPal('000000831733', '1-A-139-0', '23171-3');
                    CorrPal('000000831734', '1-A-147-0', '23171-3');
                    CorrPal('000000831738', '1-A-139-1', '23171-3');
                    CorrPal('000000831741', '1-A-130-2', '23171-3');
                    CorrPal('000000898155', '1-A-118-0', '23188');
                    CorrPal('000000898156', '1-A-153-0', '23188');
                    CorrPal('000000898157', '1-A-128-0', '23188');
                    CorrPal('000000907626', '1-A-160-3', '23188-3');
                    CorrPal('000000908766', '1-A-150-3', '23171');
                    CorrPal('000000908767', '1-A-158-3', '23171');
                    CorrPal('000000908768', '1-A-146-3', '23171');
                    CorrPal('000000908769', '1-A-148-3', '23171');
                    CorrPal('000000908770', '1-A-168-2', '23171');
                    CorrPal('000000908771', '1-A-156-3', '23171');
                    CorrPal('000000908772', '1-A-154-3', '23171');
                    CorrPal('000000919849', '1-A-122-3', '919849/24075-3');
                    CorrPal('000000938866', '1-A-132-0', '938866/24088-3');
                    CorrPal('000000938872', '1-A-127-0', '938872/24088-3');
                    CorrPal('000000938874', '1-A-126-0', '938874/24088-3');
                    CorrPal('000000938876', '1-A-122-0', '938876/24088-3');
                    CorrPal('000000938878', '1-A-150-0', '938878/24088-3');
                    CorrPal('000000942126', '1-D-041-3', '942126/24096-3');
                    CorrPal('000000942157', '1-D-043-3', '942157/24096-3');
                    CorrPal('000000942252', '1-D-047-3', '942252/24096-3');
                    CorrPal('000000942278', '1-D-045-3', '942278/24096-3');
                    CorrPal('000000942280', '1-A-145-1', '942280/24096-3');
                    CorrPal('000000942522', '1-D-067-2', '942522/24096-2');
                    CorrPal('000000942531', '1-D-057-3', '942531/24096-2');
                    CorrPal('000000942533', '1-D-049-3', '942533/24096-2');
                    CorrPal('000000942536', '1-D-051-3', '942536/24096-2');
                    CorrPal('000000942537', '1-A-127-2', '942537/24096-2');
                    CorrPal('000000942538', '1-A-121-3', '942538/24096-2');
                    CorrPal('000000942554', '1-A-163-2', '942554/24096-2');
                    CorrPal('000000942555', '1-A-161-2', '942555/24096-2');
                    CorrPal('000000942559', '1-A-165-1', '942559/24096-2');
                    CorrPal('000000942560', '1-A-155-2', '942560/24096-2');
                    CorrPal('000000942561', '1-A-159-1', '942561/24096-2');
                    CorrPal('000000942562', '1-A-171-2', '942562/24096-2');
                    CorrPal('000000942563', '1-A-140-2', '942563/24096-2');
                    CorrPal('000000951207', '1-A-122-1', '951207/24113-3');
                    CorrPal('000000951217', '1-A-120-2', '951217/24113-3');
                    CorrPal('000000951289', '1-A-118-1', '951289/24113-3');
                    CorrPal('000000951309', '1-A-114-2', '951309/24113-3');
                    CorrPal('000000951365', '1-A-116-2', '951365/24113-3');
                    CorrPal('000000951381', '1-A-124-2', '951381/24113-3');
                    CorrPal('000000951468', '1-A-128-2', '951468/24113-3');
                    CorrPal('000000951486', '1-A-126-2', '951486/24113-3');
                    CorrPal('000000951493', '1-A-131-1', '951493/24113-3');
                    CorrPal('000000951521', '1-A-140-0', '951521/24113-3');
                    CorrPal('000000951564', '1-A-132-1', '951564/24113-3');
                    CorrPal('000000951592', '1-A-132-2', '951592/24113-3');
                    CorrPal('000000951601', '1-A-136-2', '951601/24113-3');
                    CorrPal('000000951648', '1-A-148-2', '951648/24113-3');
                    CorrPal('000000951684', '1-A-150-2', '951684/24113-3');
                    CorrPal('000000951715', '1-A-146-1', '951715/24113-3');
                    CorrPal('000000951726', '1-A-142-2', '951726/24113-3');
                    CorrPal('000000951731', '1-A-150-1', '951731/24113-3');
                    CorrPal('000000951748', '1-A-152-1', '951748/24113-3');
                    CorrPal('000000951758', '1-A-167-1', '951758/24113-3');
                    CorrPal('000000951775', '1-A-161-0', '951775/24113-3');
                    CorrPal('000000951811', '1-A-161-1', '951811/24113-3');
                    CorrPal('000000951821', '1-A-155-0', '951821/24113-3');
                    CorrPal('000000951827', '1-A-120-3', '951827/24113-3');
                    CorrPal('000000951835', '1-A-118-3', '951835/24113-3');
                    CorrPal('000000951839', '1-A-160-1', '951839/24113-3');
                    CorrPal('000000951844', '1-A-149-0', '951844/24113-3');
                    CorrPal('000000951847', '1-A-116-3', '951847/24113-3');
                    CorrPal('000000951875', '1-A-145-2', '951875/24113-3');
                    CorrPal('000000951880', '1-A-114-3', '951880/24113-3');
                    CorrPal('000000951884', '1-A-155-1', '951884/24113-3');
                    CorrPal('000000951885', '1-A-156-2', '951885/24113-3');
                    CorrPal('000000951887', '1-A-134-3', '951887/24113-3');
                    CorrPal('000000951888', '1-A-136-3', '951888/24113-3');
                    CorrPal('000000951889', '1-A-154-1', '951889/24113-3');
                    CorrPal('000000951908', '1-A-123-2', '951908/24113-3');
                    CorrPal('000000951912', '1-A-132-3', '951912/24113-3');
                    CorrPal('000000951921', '1-A-130-3', '951921/24113-3');
                    CorrPal('000000951939', '1-A-138-3', '951939/24113-3');
                    CorrPal('000000951940', '1-A-159-0', '951940/24113-3');
                    CorrPal('000000956191', '1-A-154-2', '956191/24121-3');
                    CorrPal('000000956199', '1-A-169-1', '956199/24121-3');
                    CorrPal('000000956214', '1-A-130-4', '956214/24121-3');
                    CorrPal('000000956238', '1-A-134-3', '956238/24121-3');
                    CorrPal('000000956279', '1-A-128-4', '956279/24121-3');
                    CorrPal('000000956306', '1-A-145-3', '956306/24121-3');
                    CorrPal('000000956326', '1-A-146-2', '956326/24121-3');
                    CorrPal('000000956356', '1-A-156-1', '956356/24121-3');
                    CorrPal('000000956363', '1-A-133-2', '956363/24121-3');
                    CorrPal('000000956376', '1-A-117-3', '956376/24121-3');
                    CorrPal('000000956383', '1-A-153-1', '956383/24121-3');
                    CorrPal('000000956439', '1-B-040-0', '956439/24121-3');
                    CorrPal('000000956502', '1-B-044-3', '956502/24121-3');
                    CorrPal('000000956615', '1-A-153-3', '956615/24121-3');
                    CorrPal('000000956701', '1-A-110-4', '956701/24121-3');
                    CorrPal('000000956727', '1-A-126-4', '956727/24121-3');
                    CorrPal('000000956771', '1-A-136-4', '956771/24121-3');
                    CorrPal('000000956782', '1-A-124-4', '956782/24121-3');
                    CorrPal('000000956853', '1-A-120-4', '956853/24121-3');
                    CorrPal('000000956857', '1-A-110-3', '956857/24121-3');
                    CorrPal('000000956879', '1-A-140-1', '956879/24121-3');
                    CorrPal('000000956886', '1-A-121-2', '956886/24121-3');
                    CorrPal('000000956934', '1-A-121-1', '956934/24121-3');
                    CorrPal('000000956936', '1-A-135-2', '956936/24121-3');
                    CorrPal('000000956941', '1-A-128-1', '956941/24121-3');
                    CorrPal('000000959461', '1-A-141-2', '959461/24128-3');
                    CorrPal('000000959519', '1-A-123-1', '959519/24128-3');
                    CorrPal('000000959549', '1-A-151-1', '959549/24128-3');
                    CorrPal('000000959565', '1-A-142-0', '959565/24128-3');
                    CorrPal('000000959576', '1-A-157-0', '959576/24128-3');
                    Message('Fini');

                    //no lot source
                end;
            }
            action(TesPrintPal)
            {

                trigger OnAction()
                var
                    cu: Codeunit "WS Scan";
                begin
                    cu.PrintFichePaletteProduction('000000230017', 'IQF');
                end;
            }
            action(Divers)
            {

                trigger OnAction()
                var
                    iC: Integer;
                    iCount: Integer;
                    dlg: Dialog;
                    r: Record "Tenant Permission";
                    c: Codeunit Integration_Compta;
                    T2: Record "VAT Statement Line";
                    HistoCouts: Record "Histo couts";
                    cu: Codeunit "WS Scan";
                    totalQ: Decimal;
                    T6: Record "Customer Price Group";
                begin

                    dlg.Open('A : #1#######################');

                    dlg.Close;

                    Message('ok');
                end;
            }
            action("Reopen OF")
            {

                trigger OnAction()
                begin
                    cu50045.Reopenof('WB-00755531');
                    cu50045.Reopenof('WB-00756824');
                    cu50045.Reopenof('WB-00756238');
                    //cu50045.Reopenof('WB-00756212');






                    Message('ok');
                end;
            }
            action("Close OF")
            {

                trigger OnAction()
                begin

                    CloseOF('WB-00744092');






                    Message('ok');
                end;
            }
            action("Nettoyer RD")
            {

                trigger OnAction()
                var
                    SalesH: Record "Sales Header";
                begin
                    SalesH.Reset;
                    SalesH.SetRange("Location Code", 'RD');
                    SalesH.SetFilter("Last Shipping No.", '<>''''');
                    SalesH.SetFilter("Amt. Ship. Not Inv. (LCY)", '=0');
                    SalesH.DeleteAll;
                end;
            }
            action("warehouse entry")
            {

                trigger OnAction()
                var
                    T7312: Record "Warehouse Entry";
                begin
                    T7312.Reset;
                    T7312.Get(1294585);
                    T7312.Validate("Qty. (Base)", -570);
                    T7312.Modify;
                    T7312.Reset;
                    T7312.Get(1294586);
                    T7312.Validate("Qty. (Base)", 570);
                    T7312.Modify;
                end;
            }
            action(RenewTracaOTS)
            {

                trigger OnAction()
                var
                    T32: Record "Item Ledger Entry";
                    T337: Record "Reservation Entry";
                    NextSeq: Integer;
                    OTSNo: Code[20];
                    Ship: Record "Transfer Shipment Header";
                begin
                    OTSNo := 'OTS-E26-33673';
                    Ship.SetRange("Transfer Order No.", OTSNo);
                    if Ship.FindFirst then begin
                        T32.Reset;
                        T32.SetRange("Document No.", Ship."No.");
                        T32.SetRange("Location Code", '9-TFT');
                        if T32.FindSet then
                            repeat
                                T337.Reset;
                                if T337.FindLast then NextSeq := T337."Entry No." + 1;
                                T337.Reset;
                                T337.Init;
                                T337."Entry No." := NextSeq;
                                T337.Positive := true;
                                T337."Item No." := T32."Item No.";
                                T337."Location Code" := Ship."Transfer-to Code";
                                T337.Validate("Quantity (Base)", T32.Quantity);
                                T337."Source Type" := 5741;
                                T337."Source Subtype" := 1;
                                T337."Source ID" := OTSNo;
                                T337."Source Prod. Order Line" := T32."Order Line No.";
                                T337."Source Ref. No." := T32."Order Line No." + 10000;
                                T337."Expected Receipt Date" := T32."Posting Date";
                                T337."Warranty Date" := T32."Warranty Date";
                                T337."Lot No." := T32."Lot No.";
                                T337."Item Tracking" := T337."Item Tracking"::"Lot No.";
                                T337."Reservation Status" := T337."Reservation Status"::Surplus;
                                T337."Creation Date" := WorkDate;
                                T337."Created By" := UserId;
                                T337.Insert;
                            until T32.Next = 0;
                    end;
                    Message('ok');
                end;
            }
            action(Prev)
            {

                trigger OnAction()
                var
                    p: Codeunit Previsions;
                begin
                    p.CreatePrevisionsFrom(20250930D);
                    p.CreatePrevisionsFrom(20251031D);
                    p.CreatePrevisionsFrom(20251130D);
                    p.CreatePrevisionsFrom(20251231D);
                    p.CreatePrevisionsFrom(20260131D);
                    p.CreatePrevisionsFrom(20260228D);
                    p.CreatePrevisionsFrom(20260331D);
                    p.CreatePrevisionsFrom(20260430D);
                    p.CreatePrevisionsFrom(20260531D);
                    p.CreatePrevisionsFrom(20260630D);
                end;
            }
            action("3")
            {

                trigger OnAction()
                var
                    ots: Code[20];
                    FileMgt: Codeunit "File Management";
                begin
                    Message('%1', FileMgt.ServerTempFileName('txt'));

                    Message('ok');
                end;
            }
            action(DelPerdu)
            {

                trigger OnAction()
                var
                    i: Integer;
                    NextSeq: Integer;
                begin

                    i := 10000;
                    T32.Reset;
                    T32.SetRange("Location Code", 'PERDU');
                    T32.SetFilter("Remaining Quantity", '>0');
                    T32.SetRange("Posting Date", 20190101D, 20211231D);
                    if T32.FindSet then
                        repeat
                            T27.Reset;
                            T27.Get(T32."Item No.");
                            if T27.Blocked then begin
                                T27.Blocked := false;
                                T27.GTIN := 'BLOCK';
                                T27.Modify;
                            end;
                            T6505.Reset;
                            T6505.Get(T32."Item No.", '', T32."Lot No.");
                            if T6505.Blocked then begin
                                T6505.Blocked := false;
                                T6505."Commentaire coupe/calibre" := 'BLOCK';
                                T6505.Modify;
                            end;
                            T83.Reset;
                            T83.Init;
                            T83."Journal Template Name" := 'ARTICLE';
                            T83."Journal Batch Name" := 'GD';
                            T83."Line No." := i;
                            T83."Document No." := 'DELPERDU';
                            T83.Validate("Posting Date", Today);
                            T83.Validate("Item No.", T32."Item No.");
                            T83.Validate("Entry Type", T83."Entry Type"::"Negative Adjmt.");
                            T83.Validate("Location Code", 'PERDU');
                            T83.Validate("Quantity (Base)", T32."Remaining Quantity");
                            T83.Insert();
                            T337.Reset;
                            if T337.FindLast then NextSeq := T337."Entry No." + 1;
                            T337.Init;
                            T337."Entry No." := NextSeq;
                            T337.Validate("Item No.", T32."Item No.");
                            T337.Validate("Location Code", 'RD');
                            T337.Validate("Quantity (Base)", -T32."Remaining Quantity");
                            T337.Positive := false;
                            T337."Reservation Status" := T337."Reservation Status"::Prospect;
                            T337."Source Type" := 83;
                            T337."Source Subtype" := 3;
                            T337."Source ID" := 'ARTICLE';
                            T337."Source Batch Name" := 'GD';
                            T337."Source Ref. No." := i;
                            T337."Lot No." := T32."Lot No.";
                            T337."Warranty Date" := T32."Warranty Date";
                            T337."Item Tracking" := T337."Item Tracking"::"Lot No.";
                            T337.Insert;
                            i += 10000;

                        until T32.Next = 0;

                    Message('ok1');
                end;
            }
            action(DelPerduAfter)
            {

                trigger OnAction()
                begin
                    T27.Reset;
                    T27.SetRange(GTIN, 'BLOCK');
                    T27.ModifyAll(Blocked, true);

                    T6505.Reset;
                    T6505.SetRange("Commentaire coupe/calibre", 'BLOCK');
                    T6505.ModifyAll(Blocked, true);
                end;
            }
            action(Company)
            {

                trigger OnAction()
                var
                    comp: Record Company;
                    T84src: Record "Acc. Schedule Name";
                    T85src: Record "Acc. Schedule Line";
                    T84dst: Record "Acc. Schedule Name";
                    T85dst: Record "Acc. Schedule Line";
                    dlg: Dialog;
                    iC: Integer;
                    iCount: Integer;
                    T333src: Record "Column Layout Name";
                    T334src: Record "Column Layout";
                    T333dst: Record "Column Layout Name";
                    T334dst: Record "Column Layout";
                begin
                    dlg.Open('A : #1#######################\n#2###################');

                    comp.Reset;
                    comp.SetFilter(Name, '<>%1', CompanyName);
                    if comp.FindSet then
                        repeat
                            dlg.Update(1, comp.Name);
                            T333src.Get('DEFAUT');
                            T333dst.ChangeCompany(comp.Name);
                            T333dst.TransferFields(T333src, true);
                            if T333dst.Insert then;

                            T334src.Reset;
                            T334src.SetRange("Column Layout Name", 'DEFAUT');
                            iC := 1;
                            iCount := T334src.Count;
                            if T334src.FindSet then
                                repeat
                                    T334dst.ChangeCompany(comp.Name);
                                    T334dst.TransferFields(T334src, true);
                                    if T334dst.Insert then;
                                    iC += 1;
                                    dlg.Update(2, Round(iC / iCount * 10000, 1));
                                until T334src.Next = 0;
                        until comp.Next = 0;

                    dlg.Close;
                end;
            }
            action("Prolong Px")
            {
                /*
                                trigger OnAction()
                                var
                                    Px: Record "Sales Price";
                                    Dt: Date;
                                    NewDt: Date;
                                    px2: Record "Sales Price";
                                    cu: Codeunit Integration_Sales;
                                    item: Record Item;
                                begin
                                    Dt := 20230630D;
                                    NewDt := 20230731D;

                                    Px.Reset;
                                    if Px.FindSet then
                                        repeat
                                            if (Px."Ending Date" = Dt) then begin
                                                px2.Reset;
                                                px2.SetRange("Item No.", Px."Item No.");
                                                px2.SetRange("Sales Type", Px."Sales Type");
                                                px2.SetRange("Sales Code", Px."Sales Code");
                                                px2.SetFilter("Starting Date", '>=%1', Dt);
                                                item.Get(Px."Item No.");
                                                if (not px2.FindFirst) and (item."Criteria 4" in ['02', '21', '27', '28', '29', '31', '32']) then
                                                //    IF (NOT px2.FINDFIRST) AND (item."Criteria 4" IN ['01','03','04','05','06','07','15','17','22','24','25','30','34']) THEN
                                                //    IF NOT px2.FINDFIRST THEN
                                                begin
                                                    Px."Ending Date" := NewDt;
                                                    Px.Modify;
                                                end;
                                            end;
                                        until Px.Next = 0;

                                    //Px.RESET;
                                    //Px.SETRANGE("Ending Date",310321D);
                                    //Px.SETFILTER("Starting Date",'>310321D');
                                    //Px.MODIFYALL("Ending Date",310322D);
                                    Message('ok');
                                end;*/
            }
            action("Block cmd")
            {

                trigger OnAction()
                var
                    cu: Codeunit Integration_Sales;
                    cmd: Record "Sales Header";
                begin
                    dlg.Open('A : #1#######################\n#2###################');

                    cmd.Reset;
                    cmd.SetRange(Status, cmd.Status::Released);
                    //cmd.SETRANGE("No.",'CDV-E21-11010');

                    if cmd.FindSet then
                        repeat
                            dlg.Update(1, cmd."No.");
                            cmd."Commande bloquee" := not cu.CheckCreditClient(cmd);
                            cmd.Modify(false);
                        until cmd.Next = 0;

                    dlg.Close;
                end;
            }
            action(RefreshMachine)
            {

                trigger OnAction()
                begin
                    T5405.Reset;
                    T5405.SetRange(Status, T5405.Status::Released);
                    //T5405.SETRANGE("No.",'WB-00609644');
                    T5405.SetFilter("Source No.", '1-FPS*');

                    if T5405.FindSet then
                        repeat
                            T5405.Validate("Source No.", T5405."Source No.");
                            T5405.Modify(false);
                            cu50045.RefreshABC(T5405."No.");
                        until T5405.Next = 0;
                    Message('ok');
                end;
            }
            action("Nettoyage réservation")
            {

                trigger OnAction()
                begin
                    T337.Reset;
                    T337.SetFilter("Quantity (Base)", '>0');
                    T337.SetRange("Reservation Status", T337."Reservation Status"::Reservation);
                    T337.SetRange("Source Type", 32);
                    T337.SetRange("Source Subtype", 0);
                    //T337.SETRANGE("Item No.",'7-EPC-00058');
                    if T337.FindSet then
                        repeat

                            "T337-2".Reset;
                            "T337-2".SetFilter("Quantity (Base)", '<0');
                            "T337-2".SetRange("Reservation Status", T337."Reservation Status"::Reservation);
                            "T337-2".SetRange("Source Type", 5407);
                            "T337-2".SetRange("Source Subtype", 3);
                            "T337-2".SetRange("Entry No.", T337."Entry No.");
                            if not "T337-2".FindFirst then begin
                                //MESSAGE('%1',T337."Entry No.");
                                T337."Item Jnl Bin Code" := 'DEL';
                                T337."First bin code" := 'DEL';
                                T337.Modify;
                            end;
                        until T337.Next = 0;

                    Message('ok');
                end;
            }
            action("insert crit")
            {

                trigger OnAction()
                begin
                    ins('1-FAP-00001', 'Poulet', 'Cuisse', 'Vapeur', 'Effiloché', '/');
                    ins('1-FAP-00002', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-FAP-00003', 'Poulet', 'Filet', 'Rôti', 'Cube', '12 mm');
                    ins('1-FAP-00004', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-FAP-00005', 'Poulet', 'Filet', 'Rôti', 'Cube', '12 mm');
                    ins('1-FAP-00006', 'Poulet', 'Cuisse', 'Vapeur', 'Cube', '30 mm');
                    ins('1-FAT-00012', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-FAT-00013', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '2-3 mm');
                    ins('1-FAT-00020', 'Poulet', 'Filet', 'Rôti', 'Cube', '12 mm');
                    ins('1-FAT-00027', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-FAT-00030', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-FAT-00041', 'Poulet', 'Filet', 'Rôti', 'Tranchette longitudinale', '6-7 mm');
                    ins('1-FAT-00043', 'Poulet', 'Filet', 'Vapeur', 'Tranchette longitudinale', '6-7 mm');
                    ins('1-FAT-00050', 'Poulet', 'Filet', 'Rôti', 'Julienne', '12 mm');
                    ins('1-FAT-00060', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-FAT-00061', 'Poulet', 'Filet', 'Rôti', 'Julienne', '12 mm');
                    ins('1-FAT-00072', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-FAT-00076', 'Poulet', 'Filet', 'Rôti', 'Julienne', '10 x 10 x Xmm');
                    ins('1-FAT-00078', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-FAT-00079', 'Poulet', 'Filet', 'Rôti', 'Julienne', '10 x 10 x Xmm');
                    ins('1-FAT-00081', 'Poulet', 'Filet', 'Rôti', 'Tranchette longitudinale', '6-7 mm');
                    ins('1-FAT-00088', 'Poulet', 'Filet', 'Rôti', 'Julienne', '6 mm');
                    ins('1-FAT-00109', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-FAT-00114', 'Poulet', 'Filet', 'Rôti', 'Cube', '12 mm');
                    ins('1-FAT-00121', 'Poulet', 'Filet', 'Rôti', 'Tranchette longitudinale', '6-7 mm');
                    ins('1-FAT-00122', 'Poulet', 'Filet', 'Rôti', 'Julienne', '10 x 10 x Xmm');
                    ins('1-FAT-00143', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-FAT-00152', 'Poulet', 'Filet', 'Rôti', 'Tranchette longitudinale', '6-7 mm');
                    ins('1-FAT-00154', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-FAT-00157', 'Poulet', 'Filet', 'Rôti', 'Julienne', '10 x 10 x Xmm');
                    ins('1-FAT-00159', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-FAT-00160', 'Poulet', 'Filet', 'Rôti', 'Julienne', '10 x 10 x Xmm');
                    ins('1-FAT-00168', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-FAT-00173', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-FAT-00180', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-FAT-00190', 'Poulet', 'Filet', 'Rôti', 'Julienne', '10 x 10 x Xmm');
                    ins('1-FAT-00214', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-FAT-00215', 'Poulet', 'Filet', 'Rôti', 'Julienne', '6 mm');
                    ins('1-FAT-00216', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-FAT-00219', 'Poulet', 'Filet', 'Epicé', 'Tranchette', '6-7 mm');
                    ins('1-FAT-00221', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-FBO-00017', 'Poule', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '25 mm');
                    ins('1-FBO-00027', 'Poulet', 'Cuisse', 'Vapeur', 'Cube', '30 mm');
                    ins('1-FBO-00051', 'Poule', 'Filet', 'Vapeur', 'Julienne', '12 mm');
                    ins('1-FBO-00052', 'Poule', 'Mélange Filet/Cuisse', 'Vapeur', 'Julienne', '12 mm');
                    ins('1-FBO-00055', 'Poulet', 'Cuisse', 'Vapeur', 'Effiloché', '/');
                    ins('1-FCB-00002', 'Poulet', 'Cuisse', 'Vapeur', 'Cube', '20 mm');
                    ins('1-FCB-00012', 'Poulet', 'Cuisse', 'Vapeur', 'Effiloché', '/');
                    ins('1-FCB-00019', 'Bœuf', 'Viande', 'Vapeur', 'Effiloché', '/');
                    ins('1-FCB-00020', 'Poulet', 'Filet', 'Epicé', 'Julienne', '8 x 10 x Xmm');
                    ins('1-FCB-00023', 'Canard', 'Viande', 'Vapeur', 'Effiloché', '/');
                    ins('1-FCB-00024', 'Canard', 'Viande', 'Vapeur', 'Effiloché', '/');
                    ins('1-FPS-00007', 'Poulet', 'Filet', 'Epicé', 'Tranchette', '6-7 mm');
                    ins('1-FPS-00008', 'Poulet', 'Filet', 'Epicé', 'Tranchette', '6-7 mm');
                    ins('1-FPS-00012', 'Poulet', 'Filet', 'Epicé', 'Tranchette', '6-7 mm');
                    ins('1-FPS-00075', 'Poulet', 'Filet', 'Epicé', 'Tranchette', '6-7 mm');
                    ins('1-FPS-01000', 'Dinde', 'Viande', 'Rôti', 'Boulette', '95 g');
                    ins('1-FSV-00001', 'Poulet', 'Filet', 'Vapeur', 'Entier', 'Non calibré');
                    ins('1-FSV-00005', 'Poulet', 'Filet', 'Vapeur', 'Cube', '15 mm');
                    ins('1-FSV-00008', 'Poulet', 'Filet', 'Vapeur', 'Entier', 'Non calibré');
                    ins('1-FSV-00011', 'Poulet', 'Filet', 'Vapeur', 'Entier', 'Non calibré');
                    ins('1-FSV-00012', 'Poulet', 'Filet', 'Vapeur', 'Entier', 'Non calibré');
                    ins('1-FSV-00014', 'Poulet', 'Filet', 'Vapeur', 'Cube', '12 mm');
                    ins('1-FSV-00016', 'Poulet', 'Filet', 'Vapeur', 'Cube', '15 mm');
                    ins('1-FSV-00022', 'Poulet', 'Filet', 'Vapeur', 'Julienne', '12 mm');
                    ins('1-FSV-00024', 'Poulet', 'Filet', 'Vapeur', 'Julienne', '12 mm');
                    ins('1-FSV-00025', 'Poulet', 'Filet', 'Vapeur', 'Julienne', '12 mm');
                    ins('1-FSV-00027', 'Poulet', 'Filet', 'Rôti', 'Entier', 'Non calibré');
                    ins('1-FSV-00028', 'Poulet', 'Filet', 'Rôti', 'Entier', 'Non calibré');
                    ins('1-FSV-00029', 'Poulet', 'Filet', 'Rôti', 'Entier', 'Non calibré');
                    ins('1-FSV-00035', 'Poulet', 'Filet', 'Rôti', 'Julienne', '12 mm');
                    ins('1-FSV-00037', 'Poulet', 'Filet', 'Rôti', 'Julienne', '12 mm');
                    ins('1-FSV-00038', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-FSV-00040', 'Poulet', 'Filet', 'Rôti', 'Cube', '12 mm');
                    ins('1-FSV-00049', 'Poulet', 'Filet', 'Epicé', 'Cube', '12 mm');
                    ins('1-FSV-00054', 'Poulet', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '15 mm');
                    ins('1-FSV-00055', 'Poulet', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '15 mm');
                    ins('1-FSV-00056', 'Poulet', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '15 mm');
                    ins('1-FSV-00061', 'Poulet', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '20 mm');
                    ins('1-FSV-00062', 'Poulet', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '20 mm');
                    ins('1-FSV-00063', 'Poulet', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '20 mm');
                    ins('1-FSV-00071', 'Poulet', 'Cuisse', 'Vapeur', 'Cube', '20 mm');
                    ins('1-FSV-00074', 'Poulet', 'Cuisse', 'Vapeur', 'Cube', '20 mm');
                    ins('1-FSV-00076', 'Poulet', 'Cuisse', 'Vapeur', 'Cube', '20 mm');
                    ins('1-FSV-00088', 'Poule', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '30 mm');
                    ins('1-FSV-00089', 'Poule', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '30 mm');
                    ins('1-FSV-00090', 'Poule', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '30 mm');
                    ins('1-FSV-00095', 'Poule', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '30 mm');
                    ins('1-FSV-00096', 'Poule', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '30 mm');
                    ins('1-FSV-00105', 'Poulet', 'Cuisse', 'Vapeur', 'Cube', '15 mm');
                    ins('1-FSV-00111', 'Poulet', 'Filet', 'Rôti', 'Entier', 'Non calibré');
                    ins('1-FSV-00118', 'Poule', 'Filet', 'Vapeur', 'Effiloché', '/');
                    ins('1-FSV-00122', 'Poulet', 'Filet', 'Rôti', 'Julienne', '12 mm');
                    ins('1-FSV-00126', 'Poule', 'Filet', 'Vapeur', 'Cube', '10 mm');
                    ins('1-FSV-00131', 'Poulet', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '20 mm');
                    ins('1-FSV-00133', 'Poulet', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '30 mm');
                    ins('1-FSV-00139', 'Poulet', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '25 mm');
                    ins('1-FSV-00141', 'Poulet', 'Filet', 'Vapeur', 'Entier', 'Non calibré');
                    ins('1-FSV-00144', 'Poulet', 'Filet', 'Rôti', 'Entier', 'Non calibré');
                    ins('1-FSV-00154', 'Poulet', 'Filet', 'Rôti', 'Entier', 'Non calibré');
                    ins('1-FSV-00155', 'Poulet', 'Filet', 'Vapeur', 'Entier', 'Non calibré');
                    ins('1-FSV-00156', 'Poulet', 'Filet', 'Vapeur', 'Entier', 'Non calibré');
                    ins('1-FSV-00157', 'Poulet', 'Filet', 'Vapeur', 'Entier', 'Non calibré');
                    ins('1-FSV-00163', 'Poulet', 'Filet', 'Vapeur', 'Entier', 'Non calibré');
                    ins('1-FSV-00168', 'Poulet', 'Filet', 'Vapeur', 'Entier', 'Non calibré');
                    ins('1-FSV-00173', 'Poulet', 'Filet', 'Rôti', 'Entier', 'Non calibré');
                    ins('1-FSV-00185', 'Poulet', 'Filet', 'Vapeur', 'Julienne', '12 mm');
                    ins('1-FSV-00186', 'Poulet', 'Filet', 'Vapeur', 'Entier', 'Non calibré');
                    ins('1-FSV-00189', 'Poulet', 'Filet', 'Rôti', 'Entier', 'Non calibré');
                    ins('1-FSV-00190', 'Poulet', 'Filet', 'Vapeur', 'Entier', 'Non calibré');
                    ins('1-FSV-00191', 'Poulet', 'Filet', 'Vapeur', 'Cube', '12 mm');
                    ins('1-FSV-00192', 'Poulet', 'Filet', 'Vapeur', 'Julienne', '12 mm');
                    ins('1-FSV-00196', 'Poulet', 'Filet', 'Vapeur', 'Entier', 'Non calibré');
                    ins('1-FSV-00204', 'Poulet', 'Filet', 'Vapeur', 'Cube', '12 mm');
                    ins('1-FSV-00214', 'Poule', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '25 mm');
                    ins('1-FSV-00219', 'Poulet', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '30 mm');
                    ins('1-FSV-00235', 'Poulet', 'Filet', 'Vapeur', 'Cube', '15 mm');
                    ins('1-FSV-00240', 'Poulet', 'Filet', 'Vapeur', 'Entier', 'Non calibré');
                    ins('1-FSV-00254', 'Poulet', 'Filet', 'Vapeur', 'Cube', '20 mm');
                    ins('1-FSV-00261', 'Poule', 'Filet', 'Vapeur', 'Effiloché', '/');
                    ins('1-FSV-00273', 'Mélange Poule/Poulet', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '30 mm');
                    ins('1-FSV-00278', 'Poulet', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '15 mm');
                    ins('1-FSV-00282', 'Mélange Poule/Poulet', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '30 mm');
                    ins('1-FSV-00286', 'Mélange Poule/Poulet', 'Mélange Cuisse Poule/Poulet', 'Vapeur', 'Effiloché', '/');
                    ins('1-FSV-00290', 'Mélange Poule/Poulet', 'Mélange Cuisse Poule/Poulet', 'Vapeur', 'Effiloché', '/');
                    ins('1-FSV-00292', 'Poulet', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '25 mm');
                    ins('1-FSV-00305', 'Poulet', 'Filet', 'Vapeur', 'Entier', 'Non calibré');
                    ins('1-FSV-00306', 'Poulet', 'Filet', 'Epicé', 'Julienne', '8 x 10 x Xmm');
                    ins('1-FSV-00307', 'Mélange Poule/Poulet', 'Mélange Cuisse Poule/Poulet', 'Vapeur', 'Effiloché', '/');
                    ins('1-FSV-00308', 'Poule', 'Filet', 'Vapeur', 'Effiloché', '/');
                    ins('1-FSV-00321', 'Poulet', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '20 mm');
                    ins('1-FSV-00323', 'Poulet', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '20 mm');
                    ins('1-FSV-00335', 'Mélange Poule/Poulet', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '10 mm');
                    ins('1-FSV-00343', 'Mélange Poule/Poulet', 'Mélange Filet/Cuisse', 'Vapeur', 'Miettes', '/');
                    ins('1-FSV-00344', 'Mélange Poule/Poulet', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '14 mm');
                    ins('1-FSV-00346', 'Poule', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '30 mm');
                    ins('1-FSV-00357', 'Poulet', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '12 mm');
                    ins('1-FSV-00358', 'Poulet', 'Filet', 'Rôti', 'Julienne', '12 mm');
                    ins('1-FSV-00359', 'Poulet', 'Filet', 'Rôti', 'Entier', 'Non calibré');
                    ins('1-FSV-00360', 'Poulet', 'Cuisse', 'Vapeur', 'Cube', '15 mm');
                    ins('1-FSV-00361', 'Poulet', 'Filet', 'Rôti', 'Julienne', '12 mm');
                    ins('1-FSV-00363', 'Poulet', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '15 mm');
                    ins('1-FSV-00364', 'Poule', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '30 mm');
                    ins('1-FSV-00365', 'Poulet', 'Cuisse', 'Vapeur', 'Cube', '18 mm');
                    ins('1-FSV-00368', 'Poulet', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '12 mm');
                    ins('1-FSV-00369', 'Poulet', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '12 mm');
                    ins('1-FSV-00370', 'Poule', 'Filet', 'Vapeur', 'Cube', '20 mm');
                    ins('1-FSV-00371', 'Poulet', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '15 mm');
                    ins('1-FSV-00372', 'Poulet', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '20 mm');
                    ins('1-IQF-00003', 'Poulet', 'Filet', 'Vapeur', 'Cube', '12 mm');
                    ins('1-IQF-00009', 'Poulet', 'Filet', 'Vapeur', 'Tranchette', '6-7 mm');
                    ins('1-IQF-00010', 'Poulet', 'Filet', 'Vapeur', 'Entier', 'Non calibré');
                    ins('1-IQF-00013', 'Poulet', 'Filet', 'Vapeur', 'Cube', '12 mm');
                    ins('1-IQF-00015', 'Poulet', 'Filet', 'Vapeur', 'Cube', '12 mm');
                    ins('1-IQF-00018', 'Poulet', 'Filet', 'Vapeur', 'Julienne', '12 mm');
                    ins('1-IQF-00021', 'Poulet', 'Filet', 'Vapeur', 'Tranchette', '6-7 mm');
                    ins('1-IQF-00023', 'Poulet', 'Filet', 'Vapeur', 'Tranchette', '6-7 mm');
                    ins('1-IQF-00040', 'Poulet', 'Filet', 'Rôti', 'Entier', 'Non calibré');
                    ins('1-IQF-00043', 'Poulet', 'Filet', 'Rôti', 'Cube', '12 mm');
                    ins('1-IQF-00046', 'Poulet', 'Filet', 'Rôti', 'Julienne', '12 mm');
                    ins('1-IQF-00047', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-IQF-00050', 'Poulet', 'Filet', 'Rôti', 'Julienne', '12 mm');
                    ins('1-IQF-00062', 'Poulet', 'Cuisse', 'Epicé', 'Cube', '12 mm');
                    ins('1-IQF-00077', 'Poulet', 'Cuisse', 'Epicé', 'Cube', '12 mm');
                    ins('1-IQF-00082', 'Poulet', 'Cuisse', 'Epicé', 'Cube', '12 mm');
                    ins('1-IQF-00103', 'Poulet', 'Filet', 'Epicé', 'Tranchette', '6-7 mm');
                    ins('1-IQF-00120', 'Poulet', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '15 mm');
                    ins('1-IQF-00121', 'Poulet', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '20 mm');
                    ins('1-IQF-00143', 'Poule', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '12 mm');
                    ins('1-IQF-00170', 'Poulet', 'Filet', 'Vapeur', 'Cube', '12 mm');
                    ins('1-IQF-00181', 'Poulet', 'Cuisse', 'Vapeur', 'Entier', 'Non calibré');
                    ins('1-IQF-00183', 'Poulet', 'Cuisse', 'Vapeur', 'Cube', '19 mm');
                    ins('1-IQF-00190', 'Poule', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '24 mm');
                    ins('1-IQF-00244', 'Poulet', 'Filet', 'Epicé', 'Tranchette', '6-7 mm');
                    ins('1-IQF-00245', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-IQF-00258', 'Poulet', 'Filet', 'Rôti', 'Julienne', '10 x 10 x Xmm');
                    ins('1-IQF-00269', 'Poulet', 'Filet', 'Rôti', 'Entier', 'Non calibré');
                    ins('1-IQF-00305', 'Poulet', 'Ailes', 'Epicé', 'Ailes', 'Non calibré');
                    ins('1-IQF-00309', 'Poulet', 'Aiguillette', 'Vapeur', 'Morceaux', 'Coupé en 2');
                    ins('1-IQF-00317', 'Poulet', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '20 mm');
                    ins('1-IQF-00329', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-IQF-00334', 'Poulet', 'Filet', 'Rôti', 'Julienne', '12 mm');
                    ins('1-IQF-00335', 'Poulet', 'Filet', 'Epicé', 'Tranchette', '6-7 mm');
                    ins('1-IQF-00370', 'Poulet', 'Cuisse', 'Epicé', 'Cube', '12 mm');
                    ins('1-IQF-00371', 'Poulet', 'Cuisse', 'Epicé', 'Cube', '12 mm');
                    ins('1-IQF-00372', 'Poulet', 'Cuisse', 'Epicé', 'Cube', '12 mm');
                    ins('1-IQF-00373', 'Poulet', 'Cuisse', 'Epicé', 'Cube', '12 mm');
                    ins('1-IQF-00374', 'Poulet', 'Cuisse', 'Epicé', 'Cube', '12 mm');
                    ins('1-IQF-00875', 'Poulet', 'Filet', 'Rôti', 'Cube', '12 mm');
                    ins('1-IQF-00396', 'Poulet', 'Filet', 'Vapeur', 'Cube', '12 mm');
                    ins('1-IQF-00402', 'Poulet', 'Filet', 'Vapeur', 'Cube', '12 mm');
                    ins('1-IQF-00410', 'Poulet', 'Filet', 'Vapeur', 'Cube', '12 mm');
                    ins('1-IQF-00411', 'Poulet', 'Cuisse', 'Epicé', 'Cube', '12 mm');
                    ins('1-IQF-00412', 'Poulet', 'Cuisse', 'Epicé', 'Cube', '12 mm');
                    ins('1-IQF-00413', 'Poulet', 'Cuisse', 'Epicé', 'Cube', '12 mm');
                    ins('1-IQF-00414', 'Poulet', 'Cuisse', 'Epicé', 'Cube', '12 mm');
                    ins('1-IQF-00415', 'Poulet', 'Cuisse', 'Epicé', 'Cube', '12 mm');
                    ins('1-IQF-00427', 'Poulet', 'Ailes', 'Epicé', 'Ailes', 'Non calibré');
                    ins('1-IQF-00428', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-IQF-00442', 'Poulet', 'Filet', 'Rôti', 'Julienne', '12 mm');
                    ins('1-IQF-00445', 'Poulet', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '24 mm');
                    ins('1-IQF-00449', 'Poulet', 'Filet', 'Vapeur', 'Cube', '12 mm');
                    ins('1-IQF-00453', 'Poulet', 'Cuisse', 'Vapeur', 'Cube', '24 mm');
                    ins('1-IQF-00462', 'Poulet', 'Ailes', 'Rôti', 'Ailes', 'Non calibré');
                    ins('1-IQF-00467', 'Poulet', 'Filet', 'Epicé', 'Julienne', '12 mm');
                    ins('1-IQF-00469', 'Poulet', 'Filet', 'Epicé', 'Tranchette', '6-7 mm');
                    ins('1-IQF-00495', 'Poulet', 'Cuisse', 'Vapeur', 'Cube', '6 mm');
                    ins('1-IQF-00523', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-IQF-00531', 'Poulet', 'Filet', 'Vapeur', 'Cube', '12 mm');
                    ins('1-IQF-00532', 'Poulet', 'Filet', 'Vapeur', 'Julienne', '12 mm');
                    ins('1-IQF-00538', 'Poulet', 'Filet', 'Epicé', 'Tranchette', '6-7 mm');
                    ins('1-IQF-00546', 'Poulet', 'Filet', 'Epicé', 'Tranchette', '6-7 mm');
                    ins('1-IQF-00552', 'Dinde', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-IQF-00909', 'Poulet', 'Filet', 'Rôti', 'Emincé', '6 mm');
                    ins('1-IQF-00568', 'Poulet', 'Filet', 'Rôti', 'Entier', 'Non calibré');
                    ins('1-IQF-00572', 'Poulet', 'Filet', 'Rôti', 'Entier', 'Non calibré');
                    ins('1-IQF-00574', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-IQF-00580', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-IQF-00590', 'Poulet', 'Filet', 'Rôti', 'Cube', '6 mm');
                    ins('1-IQF-00594', 'Poulet', 'Filet', 'Rôti', 'Julienne', '6 mm');
                    ins('1-IQF-00601', 'Poulet', 'Filet', 'Vapeur', 'Cube', '12 mm');
                    ins('1-IQF-00612', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '4 mm');
                    ins('1-IQF-00614', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-IQF-00617', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '4 mm');
                    ins('1-IQF-00621', 'Poulet', 'Cuisse', 'Epicé', 'Cube', '12 mm');
                    ins('1-IQF-00624', 'Poulet', 'Cuisse', 'Epicé', 'Cube', '12 mm');
                    ins('1-IQF-00636', 'Poulet', 'Filet', 'Vapeur', 'Cube', '15 mm');
                    ins('1-IQF-00646', 'Poulet', 'Filet', 'Rôti', 'Entier', 'Non calibré');
                    ins('1-IQF-00657', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-IQF-00661', 'Poulet', 'Filet', 'Frit', 'Julienne', '10 x 10 x 25mm');
                    ins('1-IQF-00669', 'Poulet', 'Filet', 'Vapeur', 'Cube', '12 mm');
                    ins('1-IQF-00681', 'Poulet', 'Filet', 'Vapeur', 'Cube', '12 mm');
                    ins('1-IQF-00691', 'Poulet', 'Filet', 'Vapeur', 'Julienne', '6 mm');
                    ins('1-IQF-00706', 'Poulet', 'Manchon', 'Rôti', 'Manchons', 'Non calibré');
                    ins('1-IQF-00720', 'Poulet', 'Filet', 'Vapeur', 'Cube', '24 mm');
                    ins('1-IQF-00723', 'Poulet', 'Filet', 'Rôti', 'Cube', '12 mm');
                    ins('1-IQF-00724', 'Poulet', 'Cuisse', 'Rôti', 'Cube', '19 mm');
                    ins('1-IQF-00731', 'Poulet', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '12 mm');
                    ins('1-IQF-00749', 'Poulet', 'Filet', 'Vapeur', 'Julienne', '6 mm');
                    ins('1-IQF-00754', 'Poulet', 'Filet', 'Epicé', 'Cube', '12 mm');
                    ins('1-IQF-00758', 'Poule', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '15 mm');
                    ins('1-IQF-00763', 'Poulet', 'Filet', 'Rôti', 'Cube', '15 mm');
                    ins('1-IQF-00767', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '4 mm');
                    ins('1-IQF-00768', 'Poulet', 'Filet', 'Vapeur', 'Bouchée', 'env. 25 g');
                    ins('1-IQF-00785', 'Dinde', 'Filet', 'Rôti', 'Julienne', '12 x 12 x 50 mm');
                    ins('1-IQF-00789', 'Poulet', 'Filet', 'Rôti', 'Cube', '10 mm');
                    ins('1-IQF-00794', 'Poulet', 'Filet', 'Vapeur', 'Julienne', '12 mm');
                    ins('1-IQF-00805', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-IQF-00808', 'Poulet', 'Filet', 'Vapeur', 'Cube', '24 mm');
                    ins('1-IQF-00809', 'Poulet', 'Cuisse', 'Vapeur', 'Cube', '24 mm');
                    ins('1-IQF-00814', 'Poulet', 'Filet', 'Rôti', 'Entier', '125 g');
                    ins('1-IQF-00815', 'Poulet', 'Filet', 'Rôti', 'Entier', '50-70g');
                    ins('1-IQF-00816', 'Poulet', 'Filet', 'Rôti', 'Julienne', '8 x 10 x Xmm');
                    ins('1-IQF-00817', 'Poulet', 'Filet', 'Epicé', 'Cube', '12 mm');
                    ins('1-IQF-00820', 'Poulet', 'Filet', 'Vapeur', 'Effiloché', '/');
                    ins('1-IQF-00823', 'Poulet', 'Filet', 'Frit', 'Julienne', '10 x 10 x 25mm');
                    ins('1-IQF-00830', 'Poulet', 'Filet', 'Vapeur', 'Bouchée', 'env. 9 g');
                    ins('1-IQF-00832', 'Poulet', 'Filet', 'Rôti', 'Bouchée', 'env. 9 g');
                    ins('1-IQF-00841', 'Poulet', 'Filet', 'Rôti', 'Bouchée', 'env. 15 g');
                    ins('1-IQF-00843', 'Poulet', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '12 mm');
                    ins('1-IQF-00854', 'Poulet', 'Filet', 'Vapeur', 'Cube', '12 mm');
                    ins('1-IQF-00858', 'Poulet', 'Filet', 'Rôti', 'Bouchée', 'env. 15 g');
                    ins('1-IQF-00865', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-IQF-00867', 'Poulet', 'Filet', 'Rôti', 'Bouchée', 'env. 9 g');
                    ins('1-IQF-00870', 'Poulet', 'Filet', 'Rôti', 'Cube', '12 mm');
                    ins('1-IQF-00872', 'Poulet', 'Filet', 'Rôti', 'Entier', 'Non calibré');
                    ins('1-IQF-00379', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-IQF-00880', 'Poulet', 'Viande', 'Rôti', 'Cube', '10 mm');
                    ins('1-IQF-00881', 'Poulet', 'Filet', 'Rôti', 'Entier', 'Non calibré');
                    ins('1-IQF-00882', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '4 mm');
                    ins('1-IQF-00883', 'Poulet', 'Aiguillette', 'Vapeur', 'Morceaux', 'Coupé en 2');
                    ins('1-IQF-00887', 'Poulet', 'Cuisse', 'Rôti', 'Bouchée', 'env. 9 g');
                    ins('1-IQF-00894', 'Poulet', 'Filet', 'Rôti', 'Cube', '12 mm');
                    ins('1-IQF-00897', 'Poulet', 'Manchon', 'Epicé', 'Manchons', 'Non calibré');
                    ins('1-IQF-00898', 'Poulet', 'Cuisse', 'Epicé', 'Tranchette', '7 mm');
                    ins('1-IQF-00903', 'Poulet', 'Cuisse', 'Epicé', 'Lamelles', '3 mm');
                    ins('1-IQF-00906', 'Poulet', 'Cuisse', 'Epicé', 'Tranchette', '7 mm');
                    ins('1-IQF-00907', 'Poulet', 'Cuisse', 'Epicé', 'Tranchette', '7 mm');
                    ins('1-IQF-00567', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-IQF-00910', 'Poulet', 'Filet', 'Vapeur', 'Cube', '20 mm');
                    ins('1-IQF-00911', 'Poulet', 'Cuisse', 'Epicé', 'Tranchette', '7 mm');
                    ins('1-IQF-00912', 'Poulet', 'Cuisse', 'Epicé', 'Tranchette', '7 mm');
                    ins('1-IQF-00913', 'Poulet', 'Filet', 'Vapeur', 'Entier', '125 g');
                    ins('1-IQF-00914', 'Poulet', 'Cuisse', 'Rôti', 'Morceaux', '20-40g');
                    ins('1-IQF-00915', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '10 mm');
                    ins('1-IQF-00916', 'Poulet', 'Filet', 'Rôti', 'Bouchée', 'env. 9 g');
                    ins('1-IQF-00918', 'Poulet', 'Filet', 'Rôti', 'Cube', '12 mm');
                    ins('1-IQF-00919', 'Poulet', 'Manchon', 'Rôti', 'Manchons', 'Non calibré');
                    ins('1-IQF-00920', 'Poulet', 'Filet', 'Vapeur', 'Morceaux', '8 à 16 g');
                    ins('1-IQF-00921', 'Poulet', 'Filet', 'Rôti', 'Morceaux', '8 à 16 g');
                    ins('1-IQF-00923', 'Poulet', 'Cuisse', 'Rôti', 'Tranchette', '7 mm');
                    ins('1-IQF-00925', 'Poulet', 'Cuisse', 'Rôti', 'Morceaux', '70 -150 g');
                    ins('1-IQF-00926', 'Poulet', 'Cuisse', 'Epicé', 'Tranchette', '7 mm');
                    ins('1-IQF-00927', 'Poulet', 'Cuisse', 'Epicé', 'Tranchette', '7 mm');
                    ins('1-IQF-00928', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-IQF-00932', 'Poulet', 'Cuisse', 'Epicé', 'Tranchette', '7 mm');
                    ins('1-IQF-00933', 'Poulet', 'Cuisse', 'Rôti', 'Tranchette', '7 mm');
                    ins('1-IQF-00939', 'Poulet', 'Aiguillette', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-IQF-00940', 'Poulet', 'Ailes', 'Vapeur', 'Ailes', 'Non calibré');
                    ins('1-IQF-00941', 'Poulet', 'Ailes', 'Epicé', 'Ailes', 'Non calibré');
                    ins('1-IQF-00942', 'Poulet', 'Ailes', 'Epicé', 'Ailes', 'Non calibré');
                    ins('1-IQF-00944', 'Poulet', 'Manchon', 'Epicé', 'Manchons', 'Non calibré');
                    ins('1-IQF-00946', 'Poulet', 'Viande', 'Rôti', 'Tranchette', '6 mm');
                    ins('1-IQF-00947', 'Poulet', 'Filet', 'Rôti', 'Cube', '12 mm');
                    ins('1-IQF-00948', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '8 mm');
                    ins('1-IQF-00950', 'Poulet', 'Filet', 'Rôti', 'Emincé', '6 mm');
                    ins('1-IQF-00951', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-IQF-00952', 'Poulet', 'Cuisse', 'Epicé', 'Tranchette', '7 mm');
                    ins('1-IQF-00953', 'Poulet', 'Cuisse', 'Rôti', 'Tranchette', '7 mm');
                    ins('1-IQF-00954', 'Poulet', 'Filet', 'Rôti', 'Entier', '125 g');
                    ins('1-IQF-00955', 'Poulet', 'Filet', 'Vapeur', 'Entier', '150 g');
                    ins('1-IQF-00956', 'Poulet', 'Filet', 'Rôti', 'Entier', '125 g');
                    ins('1-IQF-00959', 'Poulet', 'Ailes', 'Epicé', 'Ailes', 'Non calibré');
                    ins('1-IQF-00960', 'Poulet', 'Cuisse', 'Rôti', 'Tranchette', '7 mm');
                    ins('1-IQF-00962', 'Poulet', 'Ailes', 'Epicé', 'Ailes', 'Non calibré');
                    ins('1-IQF-00964', 'Poulet', 'Cuisse', 'Epicé', 'Tranchette', '7 mm');
                    ins('1-IQF-00965', 'Poulet', 'Cuisse', 'Epicé', 'Tranchette', '7 mm');
                    ins('1-IQF-00967', 'Poulet', 'Filet', 'Rôti', 'Julienne', '10 x 12 x 35 mm');
                    ins('1-IQF-00968', 'Poulet', 'Filet', 'Vapeur', 'Cube', '19 mm');
                    ins('1-IQF-00971', 'Poulet', 'Filet', 'Rôti', 'Cube', '10 mm');
                    ins('1-IQF-00973', 'Poulet', 'Aiguillette', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-IQF-00975', 'Poulet', 'Aiguillette', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-IQF-00976', 'Poulet', 'Filet', 'Rôti', 'Cube', '10 mm');
                    ins('1-IQF-00977', 'Poulet', 'Ailes', 'Epicé', 'Ailes', 'Calibrées');
                    ins('1-IQF-00978', 'Poulet', 'Ailes', 'Epicé', 'Ailes', '55-65g');
                    ins('1-IQF-00979', 'Poulet', 'Aiguillette', 'Rôti', 'Tranchette', '12 mm');
                    ins('1-IQF-00980', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-IQF-00981', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-IQF-00983', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-IQF-00984', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-IQF-00985', 'Poulet', 'Filet', 'Rôti', 'Julienne', '6 mm');
                    ins('1-IQF-00986', 'Poulet', 'Cuisse', 'Epicé', 'Cube', '12 mm');
                    ins('1-IQF-00987', 'Poulet', 'Cuisse', 'Epicé', 'Cube', '12 mm');
                    ins('1-IQF-00988', 'Poulet', 'Cuisse', 'Epicé', 'Cube', '12 mm');
                    ins('1-IQF-00989', 'Poulet', 'Cuisse', 'Epicé', 'Cube', '12 mm');
                    ins('1-IQF-00990', 'Poulet', 'Cuisse', 'Epicé', 'Cube', '12 mm');
                    ins('1-IQF-00991', 'Poulet', 'Cuisse', 'Epicé', 'Cube', '12 mm');
                    ins('1-IQF-00995', 'Poulet', 'Filet', 'Vapeur', 'Cube', '12 mm');
                    ins('1-IQF-00996', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '8 mm');
                    ins('1-IQF-00997', 'Poulet', 'Viande', 'Rôti', 'Tranchette', '6 mm');
                    ins('1-IQF-00998', 'Poulet', 'Filet', 'Vapeur', 'Entier', '90 g');
                    ins('1-IQF-00999', 'Poulet', 'Aiguillette', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-IQF-01000', 'Poulet', 'Filet', 'Rôti', 'Mini Julienne', '12 x 7 X 35 mm');
                    ins('1-IQF-01002', 'Poulet', 'Cuisse', 'Rôti', 'Effiloché', '/');
                    ins('1-IQF-01003', 'Poulet', 'Ailes', 'Epicé', 'Ailes', 'Non calibré');
                    ins('1-IQF-01004', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '8 mm');
                    ins('1-IQF-01007', 'Poulet', 'Filet', 'Rôti', 'Entier', 'Non calibré');
                    ins('1-IQF-01013', 'Poulet', 'Ailes', 'Epicé', 'Ailes', 'Non calibré');
                    ins('1-IQF-01015', 'Poulet', 'Filet', 'Vapeur', 'Julienne', '12 mm');
                    ins('1-IQF-01019', 'Poulet', 'Ailes', 'Epicé', 'Ailes', 'Non calibré');
                    ins('1-IQF-01020', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '8 mm');
                    ins('1-IQF-01021', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '8 mm');
                    ins('1-IQF-01023', 'Poulet', 'Cuisse', 'Rôti', 'Cube', '10 mm');
                    ins('1-IQF-01024', 'Poulet', 'Viande', 'Rôti', 'Cube', '10 mm');
                    ins('1-IQF-01025', 'Poulet', 'Filet', 'Rôti', 'Tranchette', '6-7 mm');
                    ins('1-IQF-01026', 'Poulet', 'Filet', 'Rôti', 'Entier', 'Non calibré');
                    ins('1-IQF-01027', 'Poulet', 'Viande', 'Rôti', 'Tranchette', '6 mm');
                    ins('1-IQF-20000', 'Poulet', 'Viande', 'Vapeur', 'Boulette', '3,5 - 4,5 g');
                    ins('1-IQF-20025', 'Poulet', 'Viande', 'Vapeur', 'Boulette', '3 g');
                    ins('1-IQF-22000', 'Poulet', 'Viande', 'Pané', 'Nugget', '21 - 22 g');
                    ins('1-IQF-22001', 'Poulet', 'Viande', 'Pané', 'Burger', '95 g');
                    ins('1-IQF-22005', 'Poulet', 'Aiguillette', 'Pané', 'Aiguillette', 'env. 46 g');
                    ins('1-IQF-22010', 'Poulet', 'Ailes', 'Pané', 'Ailes', 'Non calibré');
                    ins('1-IQF-22013', 'Poulet', 'Aiguillette', 'Pané', 'Aiguillette', 'env. 46 g');
                    ins('1-IQF-22014', 'Poulet', 'Aiguillette', 'Pané', 'Aiguillette', 'env. 46 g');
                    ins('1-IQF-22015', 'Poulet', 'Filet', 'Pané', 'Entier', '80 g');
                    ins('1-IQF-22016', 'Poulet', 'Filet', 'Pané', 'Entier', '80 g');
                    ins('1-IQF-22126', 'Poulet', 'Filet', 'Pané', 'Bouchée', 'Donnée manquante');
                    ins('1-IQF-22130', 'Poulet', 'Filet', 'Pané', 'Morceaux', 'env. 25 g');
                    ins('1-IQF-22131', 'Poulet', 'Filet', 'Pané', 'Entier', 'Non calibré');
                    ins('1-IQF-22132', 'Poulet', 'Filet', 'Pané', 'Entier', '125 g');
                    ins('1-IQF-22134', 'Poulet', 'Aiguillette', 'Pané', 'Aiguillette', 'Non calibré');
                    ins('1-IQF-22135', 'Poulet', 'Filet', 'Pané', 'Morceaux', 'env. 25 g');
                    ins('1-IQF-22136', 'Poulet', 'Ailes', 'Pané', 'Ailes', 'Non calibré');
                    ins('1-IQF-22137', 'Poulet', 'Aiguillette', 'Pané', 'Aiguillette', 'Non calibré');
                    ins('1-LQF-00001', 'Poulet', 'Viande', 'Vapeur', 'Boulette', '3,5 - 4,5 g');
                    ins('1-LQF-00002', 'Poulet', 'Viande', 'Vapeur', 'Boulette', '3,5 - 4,5 g');
                    ins('1-LQF-00003', 'Poulet', 'VSM', 'Vapeur', 'Boulette', '3,5 - 4,5 g');
                    ins('1-LQF-00004', 'Poulet', 'VSM', 'Vapeur', 'Boulette', '3,5 - 4,5 g');
                    ins('1-LQF-00005', 'Poulet', 'VSM', 'Vapeur', 'Boulette', '3,5 - 4,5 g');
                    ins('1-LQF-00006', 'Poulet', 'Viande', 'Vapeur', 'Boulette', '15 g');
                    ins('1-LSV-00001', '0', '0', 'Vapeur', 'Cube', '30 mm');
                    ins('1-LSV-00002', 'Poulet', 'Mélange Filet/Cuisse', 'Vapeur', 'Cube', '20 mm');
                    ins('2-IQF-00001', 'Porc', 'Poitrine', 'Rôti', 'Tranchette', '2 mm');
                end;
            }
            action(createprocess)
            {

                trigger OnAction()
                var
                    BOM: Record "Production BOM Header";
                    Version: Record "Production BOM Version";
                    Process: Record ProcessOF;
                begin

                    T27.Reset;
                    T27.SetFilter("No.", '1-*');
                    if T27.FindSet then
                        repeat
                            BOM.Reset;
                            BOM.SetRange("No.", T27."Production BOM No.");
                            if BOM.FindSet then
                                repeat

                                    AddProcess(BOM."No.", '', 'MACHINESDECOUPE', T27.Process);
                                    Version.Reset;
                                    Version.SetRange("Production BOM No.", BOM."No.");
                                    if Version.FindSet then
                                        repeat
                                            AddProcess(BOM."No.", Version."Version Code", 'MACHINESDECOUPE', T27.Process);


                                        until Version.Next = 0;


                                until BOM.Next = 0;
                        until T27.Next = 0;
                end;
            }
            action(regoup)
            {

                trigger OnAction()
                begin
                    s := 'R001';
                    insertregroup('000', 'Stockage MP Congelateur', false, false);
                    insertregroup('001', 'Réception des viandes', false, false);
                    insertregroup('002', 'Déballage viande fraiche et mise en dolav', true, true);
                    insertregroup('003', 'Dégélation Dorma', true, true);
                    insertregroup('004', 'Dégélation Dorma', true, true);
                    insertregroup('005', 'Dégélation GEA', true, true);
                    insertregroup('007', 'Déchargement des tumblers et pesage', true, true);
                    insertregroup('008', 'Transfert des viandes Dorma-->Usine', false, false);
                    insertregroup('009', 'Découpe, parage, séparation mignon', true, true);
                    insertregroup('010', 'Contrôle X-ray', true, true);
                    insertregroup('011', 'Séparateur os', true, true);
                    insertregroup('012', 'Portionnage TSM', true, true);
                    insertregroup('013', 'Portionnage I-CUT Marel', true, true);
                    insertregroup('100', 'Fabrication de la saumure', true, true);
                    insertregroup('101', 'Hachage', true, true);
                    insertregroup('102', 'Injection', true, true);
                    insertregroup('103', 'Mélangeur', true, true);
                    insertregroup('104', 'Nettoyage des aiguilles d''injection', false, true);
                    insertregroup('105', 'Malaxage', true, true);
                    insertregroup('107', 'Déchargement des mlx et pesage', true, true);
                    insertregroup('108', 'Lavage bacs de dégel', false, true);
                    insertregroup('109', 'Lavage Dolav', false, true);
                    insertregroup('110', 'Cutterage/Emulsion', true, true);
                    insertregroup('200', 'Chargement manuel du four', true, true);
                    insertregroup('201', 'Formage Revo', true, true);
                    insertregroup('202', 'Cuisson mode vapeur', false, false);
                    insertregroup('203', 'Cuisson mode rôti', false, false);
                    insertregroup('204', 'Fabrication lécithine', true, true);
                    insertregroup('205', 'Refroidissement Giro', false, true);
                    insertregroup('206', 'Surgélation Giro', false, true);
                    insertregroup('207', 'Mise en bac sortie Gir', true, true);
                    insertregroup('208', 'Embossage', true, true);
                    insertregroup('209', 'Nettoyage des bacs sorties Giro', false, true);
                    insertregroup('210', 'Formage Revo', true, true);
                    insertregroup('211', 'Ligne panée', true, true);
                    insertregroup('212', 'Formage Boulette', true, true);
                    insertregroup('213', 'Embossage', true, true);
                    insertregroup('214', 'Tranchage Bacon Avant cuisson', true, true);
                    insertregroup('215', 'Formage Brochette', true, true);
                    insertregroup('300', 'Coupe MTV', true, true);
                    insertregroup('301', 'Coupe MTV', true, true);
                    insertregroup('302', 'Emballage Thermoformeuses', true, true);
                    insertregroup('303', 'Emballage Thermoformeuses', true, true);
                    insertregroup('304', 'Emballage Thermoformeuses', true, true);
                    insertregroup('305', 'Emballage Thermoformeuses', true, true);
                    insertregroup('306', 'Emballage Thermoformeuses', true, true);
                    insertregroup('307', 'Emballage Thermoformeuses', true, true);
                    insertregroup('308', 'Cuisson/Pasteurisation Lutétia', false, true);
                    insertregroup('309', 'Pasteurisation Autoclave', false, true);
                    insertregroup('310', 'Refroidissement rapide Actron', false, true);
                    insertregroup('311', 'Vide chariot mise en Dolav', true, true);
                    insertregroup('319', 'Coupe FAT', true, true);
                    insertregroup('320', 'Coupe FAT', true, true);
                    insertregroup('321', 'Operculage barquette', true, true);
                    insertregroup('322', 'Mise caisse', true, true);
                    insertregroup('323', 'Mise caisse', true, true);
                    insertregroup('324', 'Coupe FAT', true, true);
                    insertregroup('325', 'Coupe FAT', true, true);
                    insertregroup('326', 'Operculage barquette', true, true);
                    insertregroup('327', 'Coupe FAT', true, true);
                    insertregroup('328', 'Operculage barquette', true, true);
                    insertregroup('329', 'Operculage barquette', true, true);
                    insertregroup('500', 'Coupe IQF', true, true);
                    insertregroup('501', 'Coupe IQF', true, true);
                    insertregroup('502', 'ChargementTumbler-Epiçage', true, true);
                    insertregroup('510', 'Coupe IQF', true, true);
                    insertregroup('520', 'Ensachage IQF', true, true);
                    insertregroup('521', 'Ensachage IQF', true, true);
                    insertregroup('522', 'Ensachage IQF', true, true);
                    insertregroup('523', 'Ensachage IQF', true, true);
                    insertregroup('550', 'Emballage Carton/palettisation', true, true);
                    insertregroup('551', 'Emballage Carton/palettisation', true, true);
                    insertregroup('552', 'Emballage Carton/palettisation', true, true);
                    insertregroup('553', 'Emballage Carton/palettisation', true, true);
                    insertregroup('600', 'EmballageFSV', true, true);
                    insertregroup('601', 'EmballageFSV', true, true);
                    insertregroup('602', 'EmballageFSV', true, true);
                    insertregroup('800', 'Traitement HPP', false, false);
                    insertregroup('810', 'Supervision ARGML (halal)', false, false);
                    insertregroup('811', 'Analyse libératoire', false, false);
                    insertregroup('812', 'Sous-traitance production de boulette', false, false);
                    insertregroup('813', 'Sous-traitance désossage cuisse CDC Colruyt', true, true);
                    insertregroup('814', 'Traitement des déchêts CAT 4', false, false);
                    insertregroup('850', 'Entrée PF au congélateur', false, false);
                    insertregroup('901', 'Expédition Frais', false, false);
                    insertregroup('902', 'Encodage +CMR', false, false);
                    insertregroup('903', 'Transport allée-retour HPP Belgium', false, false);
                    insertregroup('907', 'Expédition Surgelé', false, false);
                    insertregroup('999', 'Interruptions', true, true);
                    insertregroup('S001', 'Setup: Préparation Ligne Injecteur', true, true);
                    insertregroup('S002', 'Setup: Changement des aiguilles', true, true);
                    insertregroup('S003', 'Setup: Préparation Ligne Cuisson', true, true);
                    insertregroup('S004', 'Setup: Préparation Formeuse REVO', true, true);
                    insertregroup('S005', 'Setup: Préparation Ligne Pané', true, true);
                    insertregroup('S006', 'Setup: Préparation Ligne IQF', true, true);
                    insertregroup('S007', 'Setup: Préparation Ligne boulette', true, true);
                    insertregroup('S008', 'Setup: Montage Gaz (ensacheuse)', true, true);
                    insertregroup('S009', 'Setup: Montage Ligne MTV', true, true);
                    insertregroup('S010', 'Setup: Montage Ligne Mondini', true, true);
                    insertregroup('S011', 'Setup: Changement format Mondini', true, true);
                    insertregroup('S012', 'Setup: Préparartion Ligne Embossage', true, true);
                    insertregroup('S013', 'Setup: Montage Broyeur', true, true);
                    insertregroup('S014', 'Setup: Préparation ligne TSM', true, true);
                    insertregroup('S015', 'Setup: Contrôle du nettoyage ARGML', false, false);
                    insertregroup('S016', 'Setup: Trancheuse Bacon', true, true);
                    insertregroup('S017', 'Setup:Chargement Produit IQF', true, true);
                    insertregroup('S018', 'Setup:Chargement Produit FSV', true, true);
                    insertregroup('S019', 'Setup: Multiformeuse Brochette', true, true);
                    Message('fini');
                end;
            }
            action(resend)
            {

                trigger OnAction()
                var
                    SalesHP: Record "Sales Invoice Header";
                    SalesHPSend: Record "Sales Invoice Header";
                    modif: Codeunit ModifTables;
                    CuMail: Codeunit Integration_EMail;
                    TypeLogo: Option NonDefini,Avec,Sans;
                begin
                    SalesHP.Reset;
                    SalesHP.SetFilter("No.", 'VEN-E25-09970..VEN-E25-10004');
                    if SalesHP.FindSet then
                        repeat
                            if (CuMail._GetEMailsRespForEntity(DATABASE::Customer, SalesHP."Bill-to Customer No.", 'S01') = '') then begin
                            end
                            else begin

                                SalesHPSend.Reset;
                                SalesHPSend.SetFilter("No.", '%1', SalesHP."No.");
                                if SalesHPSend.FindFirst then
                                    if SalesHPSend.Count < 10 then begin
                                        modif.InvoiceLogo(SalesHPSend."No.", TypeLogo::Avec);
                                        SalesHPSend.EmailRecords(false);
                                        modif.InvoiceLogo(SalesHPSend."No.", TypeLogo::NonDefini);
                                    end;
                            end;
                            SalesHP.CalcFields("Shipment No.");

                        until SalesHP.Next = 0;
                end;
            }
            action(RecreatePal)
            {

                trigger OnAction()
                var
                    Pal: Record Pallet;
                    PalLedg: Record "Pallet Ledger Entry";
                    Ledg2: Record "Pallet Ledger Entry";
                begin
                    dlg.Open('#1#########################');

                    PalLedg.Reset;
                    PalLedg.SetRange("Posting Date", 20240819D, 20240822D);
                    if PalLedg.FindSet then
                        repeat
                            Pal.Reset;
                            if not Pal.Get(PalLedg."SSCC No.") then begin
                                Ledg2.Reset;
                                Ledg2.SetRange("SSCC No.", PalLedg."SSCC No.");
                                if Ledg2.FindLast then;
                                Pal.Reset;
                                Pal.Init;
                                Pal."SSCC No." := PalLedg."SSCC No.";
                                Pal."Location code" := Ledg2."Location Code";
                                Pal."Creation Date" := Today;
                                Pal."Bin code" := Ledg2."Bin Code";
                                Pal."Item No." := Ledg2."Item No.";
                                Pal."Lot No." := Ledg2."Lot No.";

                                Pal.Insert;
                            end;
                            dlg.Update(1, PalLedg."Entry No.");

                        until PalLedg.Next = 0;
                    dlg.Close;
                end;
            }
            action(RecreatePal2)
            {

                trigger OnAction()
                var
                    Pal: Record Pallet;
                    PalLedg: Record "Pallet Ledger Entry";
                    Ledg2: Record "Pallet Ledger Entry";
                    ile: Record "Item Ledger Entry";
                begin
                    dlg.Open('#1#########################');

                    Pal.Reset;
                    Pal.SetRange("Creation Date", Today);
                    if Pal.FindSet then
                        repeat
                            if Pal.DLC = 0D then begin
                                ile.Reset;
                                ile.SetRange("Item No.", Pal."Item No.");
                                ile.SetRange("Lot No.", Pal."Lot No.");
                                if ile.FindLast then begin
                                    Pal.DLC := ile."Warranty Date";
                                    Pal.Modify;
                                end;

                            end;
                            dlg.Update(1, Pal."SSCC No.");

                        until Pal.Next = 0;
                    dlg.Close;
                end;
            }
        }
    }

    var
        No: Code[20];
        T5405: Record "Production Order";
        T5406: Record "Prod. Order Line";
        T5407: Record "Prod. Order Component";
        T5409: Record "Prod. Order Routing Line";
        ILE: Record "Item Ledger Entry";
        T7312: Record "Warehouse Entry";
        T50025: Record "Ateliers Liens";
        T27: Record Item;
        sessionId1: Integer;
        scan: Codeunit "WS Scan";
        T6505: Record "Lot No. Information";
        T5740: Record "Transfer Header";
        T5741: Record "Transfer Line";
        T337: Record "Reservation Entry";
        T32: Record "Item Ledger Entry";
        T50018: Record Pallet;
        T83: Record "Item Journal Line";
        T8001300: Record "Statistic aggregate";
        Utils: Codeunit Utils;
        T113: Record "Sales Invoice Line";
        T256: Record "VAT Statement Line";
        T5802: Record "Value Entry";
        T36: Record "Sales Header";
        T112: Record "Sales Invoice Header";
        Xl: Record "Excel Buffer" temporary;
        T50006: Record "ABC - Parametres";
        FileName: Text;
        T99000771: Record "Production BOM Header";
        T99000772: Record "Production BOM Line";
        T50028: Record "Stats OF";
        T18: Record Customer;
        T110: Record "Sales Shipment Header";
        CU50022: Codeunit NAS;
        T84: Record "Acc. Schedule Name";
        T85: Record "Acc. Schedule Line";
        comp: Record Company;
        T333: Record "Column Layout Name";
        T334: Record "Column Layout";
        "T84-1": Record "Acc. Schedule Name";
        "T85-1": Record "Acc. Schedule Line";
        T15: Record "G/L Account";
        CUItems: Codeunit Integration_Items;
        CU50030: Codeunit "Stock EC";
        dlg: Dialog;
        cu50045: Codeunit "Integration Tft and Prod";
        "T337-2": Record "Reservation Entry";
        s: Code[10];
        T99000779: Record "Production BOM Version";
        TProc: Record ProcessOF;
        T37: Record "Sales Line";
        VersionMgt: Codeunit VersionManagement;
        T5067: Record "Contact Job Responsibility";
        SalesPriceMgt: Codeunit "Sales Price Calc. Mgt.EC";
        T222: Record "Ship-to Address";

    local procedure AddProcess(BOM: Code[20]; Version: Code[20]; Proc: Code[20]; Value: Text)
    var
        Process: Record ProcessOF;
    begin
        if Value <> '' then begin
            Process.Reset;
            Process.Init;
            Process."Production BOM No" := BOM;
            Process."BOM Version" := Version;
            Process.Process := Proc;
            Process.Valeur := Value;
            Process.Insert;

        end;
    end;

    local procedure Halal(No: Text; v: Text)
    var
        item: Record Item;
    begin
        item.Get(No);
        item."Criteria 10" := v;
        item.Modify(false);
    end;

    local procedure Translate(No: Code[20]; Int: Text; FR: Text; EN: Text; NL: Text)
    var
        item: Record Item;
        tr: Record "Item Translation";
    begin
        item.Get(No);
        tr.Init;
        tr."Language Code" := 'EC';
        tr."Item No." := No;
        tr.Description := item.Description;
        tr.Insert;

        item.Description := Int;
        item.Modify(false);

        tr.Reset;
        tr.Init;
        tr."Language Code" := 'FR';
        tr."Item No." := No;
        tr.Description := FR;
        if not tr.Insert(false) then
            tr.Modify(false);

        tr.Reset;
        tr.Init;
        tr."Language Code" := 'EN';
        tr."Item No." := No;
        tr.Description := EN;
        if not tr.Insert(false) then
            tr.Modify(false);

        tr.Reset;
        tr.Init;
        tr."Language Code" := 'NL';
        tr."Item No." := No;
        tr.Description := NL;
        if not tr.Insert(false) then
            tr.Modify(false);
    end;

    local procedure UpdVend(No: Code[20]; Gest: Code[20]; Pay: Code[20])
    var
        vend: Record Vendor;
        Purch: Record "Purchase Header";
    begin
        //vend.RESET;
        //vend.MODIFYALL("Responsibility Center",'DR');

        vend.Get(No);
        vend."Responsibility Center" := Gest;
        vend."Payment Terms Code" := Pay;
        vend.Modify;

        Purch.Reset;
        Purch.SetRange("Buy-from Vendor No.", No);
        Purch.SetRange("Posting Date", 20190101D, 20221231D);
        Purch.ModifyAll("Responsibility Center", Gest);
    end;

    local procedure Reopenof(No: Code[20])
    begin


        T5405.Reset;
        T5405.SetRange("No.", No);
        if T5405.FindSet then
            repeat
                T5405.Rename(T5405.Status::Released, T5405."No.");

            until T5405.Next = 0;

        T5406.Reset;
        T5406.SetRange("Prod. Order No.", No);
        if T5406.FindSet then
            repeat
                T5406.Rename(T5406.Status::Released, T5406."Prod. Order No.", T5406."Line No.");

            until T5406.Next = 0;

        T5407.Reset;
        T5407.SetRange("Prod. Order No.", No);
        if T5407.FindSet then
            repeat
                T5407.Rename(T5407.Status::Released, T5407."Prod. Order No.", T5407."Prod. Order Line No.", T5407."Line No.");

            until T5407.Next = 0;

        T5409.Reset;
        T5409.SetRange("Prod. Order No.", No);
        if T5409.FindSet then
            repeat
                T5409.Rename(T5409.Status::Released, T5409."Prod. Order No.", T5409."Routing Reference No.", T5409."Routing No.", T5409."Operation No.");

            until T5409.Next = 0;
    end;

    local procedure Reajust(ItemNo: Code[20])
    begin
        ILE.Reset;
        ILE.SetRange("Posting Date", 20170101D, 20201031D);
        ILE.SetRange("Item No.", ItemNo);
        ILE.ModifyAll("Applied Entry to Adjust", false);

        T27.Get(ItemNo);
        T27."Cost is Adjusted" := true;
        T27.Modify;
    end;

    local procedure GetMP(ILE: Record "Item Ledger Entry"; var Msg: Text): Decimal
    var
        Stats: Record "Stats OF";
        ILE2: Record "Item Ledger Entry";
    begin
        ILE2.Reset;
        ILE2.SetRange("Item No.", ILE."Item No.");
        ILE2.SetRange("Entry Type", ILE2."Entry Type"::Output);
        ILE2.SetRange("Lot No.", ILE."Lot No.");
        if ILE2.FindFirst then begin

            Stats.Reset;
            Stats.SetRange("OF", ILE2."Order No." + '-' + Format(ILE2."Order Line No."));
            Stats.SetRange(Direction, 'PRODUCTION');
            if Stats.FindFirst then
                exit(Stats."Cout total" / Stats."Quantite produite");
        end
        else begin
            Stats.Reset;
            Stats.SetRange(Article, ILE."Item No.");
            Stats.SetRange(Direction, 'PRODUCTION');
            if Stats.FindLast then
                exit(Stats."Cout total" / Stats."Quantite produite");
            //  Msg += ILE."Item No."+ILE."Lot No."+'\n';
            exit(0);
        end;
    end;

    local procedure CloseOF(No: Code[20])
    var
        CU50012: Codeunit "Prod. Order Status Manageme EC";
    begin

        T5405.Reset;
        T5405.SetRange("No.", No);
        T5405.SetRange(Status, T5405.Status::Released);
        if T5405.FindSet then
            repeat

            //CU50012.ChangeStatusOnProdOrder(T5405, T5405.Status::Finished, T5405."Starting Date", false);

            until T5405.Next = 0;
    end;

    local procedure ins(No: Code[20]; crit13: Text; crit14: Text; crit15: Text; crit16: Text; crit17: Text)
    var
        Item: Record Item;
        cod: Record "Code";
    begin
        Item.Get(No);
        Item."Criteria 13" := getcrit(50088, crit13);
        Item."Criteria 14" := getcrit(50089, crit14);
        Item."Criteria 15" := getcrit(50090, crit15);
        Item."Criteria 16" := getcrit(50091, crit16);
        Item."Criteria 17" := getcrit(50092, crit17);
        Item.Modify;
    end;

    local procedure getcrit("field": Integer; val: Text): Code[10]
    var
        cod: Record "Code";
        next: Code[10];
    begin
        cod.Reset;
        cod.SetRange("Table No", 27);
        cod.SetRange("Field No", field);
        cod.SetRange(Description, val);
        if cod.FindFirst then begin
            exit(cod.Code);
        end
        else begin
            cod.SetRange(Description);
            if cod.FindLast then
                next := IncStr(cod.Code)
            else
                next := '001';
            cod.Reset;
            cod.Init;
            cod."Table No" := 27;
            cod."Field No" := field;
            cod.Description := val;
            cod.Code := next;
            cod.Insert;
            exit(next);
        end;
    end;

    local procedure insertregroup(Act: Code[10]; regr: Text[80]; onof: Boolean; capt: Boolean)
    var
        T1: Record "ABC - Activites";
        T2: Record "ABC - Activites";
    begin

        T1.Reset;
        T1.SetRange(Description, regr);
        T1.SetRange(Imputation, T1.Imputation::Regroupement);
        if not T1.FindFirst then begin
            T1.Reset;
            T1.Init;
            T1.Imputation := T1.Imputation::Regroupement;
            T1.Description := regr;
            T1.Code := s;
            T1.Insert;
            s := IncStr(s);

        end;

        T2.Reset;
        T2.Get(Act);
        T2."On OF" := onof;
        T2.Capte := capt;
        T2.Regroupement := T1.Code;
        T2.Modify;
    end;

    local procedure CorrPal(sscc: Text; bin: Text; lot: Text)
    var
        Pal: Record Pallet;
    begin
        Pal.Reset;
        Pal.Init;
        Pal."SSCC No." := sscc;
        Pal."Location code" := 'ECCONGEL';
        Pal."Bin code" := bin;
        Pal."Item No." := '1-IQF-22142';
        Pal."Lot No." := lot;
        Pal.Insert;
    end;
}

