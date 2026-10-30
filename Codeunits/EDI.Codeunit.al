codeunit 50039 EDI
{

    trigger OnRun()
    var
        dt: Date;
    begin
        //ContraloadMonterrat(010123D);

        Tello('EXV-E26-09635');

        //MESSAGE('%1',IsAllBLReceived('CDA-E19-0619'));
        //Import_ECPoland('\\srvnavision\NavisionTemp\1275.xlsx');
        //Import_ECPoland('\\srvnavision\NavisionTemp\276.xlsx');
        //SetTraca('CDA-E19-0619');

        //FichierTFE('\\srvnavision\NavisionTemp\testTFE.csv','CDA-E25-1536');
        Message('ok');
    end;

    var
        xLBuf: Record "Excel Buffer" temporary;
        utils: Codeunit Utils;

    [Scope('OnPrem')]
    procedure Import_ECPoland(FilePath: Text[1024]) CmdNo: Code[20]
    var
        i: Integer;
        Cmd: Code[20];
        BL: Code[20];
        rev: Code[20];
        _PaletNo: Text[250];
        _ItemNo: Text[250];
        _LotNo: Text[250];
        _DLC: Text[250];
        _NbreBox: Text[250];
        _Net: Text[250];
        _Brut: Text[250];
        recBL: Record "Sales Line DiscountEC";
        d: Integer;
        m: Integer;
        y: Integer;
        DejaRecu: Boolean;
        LastPalNo: Text;
        Items: Record Item;
    begin
    end;

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text[1024]
    begin
        if not xLBuf.Get(RowNo, ColNo) then
            exit('');
        exit(xLBuf."Cell Value as Text");
    end;

    [Scope('OnPrem')]
    procedure IsAllBLReceived(PurchaseNo: Code[20]): Boolean
    var
        recPurch: Record "Purchase Header";
        recBL: Record "Sales Line DiscountEC";
        i: Integer;
        LastBL: Code[20];
    begin
    end;

    [Scope('OnPrem')]
    procedure ProcessOrder(PurchaseNo: Code[20])
    var
        recPurch: Record "Purchase Header";
        recPurchL: Record "Purchase Line";
        recBL: Record "Sales Line DiscountEC";
        i: Integer;
        recReserv: Record "Reservation Entry";
        ReleasePurchDoc: Codeunit "Release Purchase Document";
    begin
    end;

    [Scope('OnPrem')]
    procedure SetTraca(PurchaseNo: Code[20])
    var
        recPurch: Record "Purchase Header";
        recPurchL: Record "Purchase Line";
        recBL: Record "Sales Line DiscountEC";
        i: Integer;
        LastBL: Code[20];
        BLs: Text[1024];
        BLTab: array[50] of Code[20];
    begin
    end;

    [Scope('OnPrem')]
    procedure SetTracaForBL(PurchaseNo: Code[20]; BL: Code[20])
    var
        recPurch: Record "Purchase Header";
        recPurchL: Record "Purchase Line";
        recBL: Record "Sales Line DiscountEC";
        i: Integer;
        LastBL: Code[20];
        BLs: Text[1024];
        BLTab: array[50] of Code[20];
        recReserv: Record "Reservation Entry";
        ReleasePurchDoc: Codeunit "Release Purchase Document";
        tmp: Decimal;
        Loc: Record Location;
    begin
    end;

    [Scope('OnPrem')]
    procedure FichierTFE(FileName: Text[1024]; PurchNo: Code[20])
    var
        xfile: File;
        OutStream: OutStream;
        PurchL: Record "Purchase Line";
        SalesH: Record "Sales Header";
        PurchH: Record "Purchase Header";
        CRLF: Text[4];
    begin
        CRLF[1] := 13;
        CRLF[2] := 10;

        //CLEAR(xFile);
        //xFile.TEXTMODE := TRUE;
        //xFile.WRITEMODE := TRUE;
        //xFile.CREATE(FileName);

        //xFile.WRITE(Txt);


        xfile.Create(FileName);
        xfile.CreateOutStream(OutStream);

        PurchL.Reset;
        PurchL.SetRange("Document No.", PurchNo);
        PurchH.Get(PurchH."Document Type"::Order, PurchNo);
        if PurchL.FindSet then
            repeat
                PurchL.CalcFields("Horaires de livraison");
                SalesH.Get(SalesH."Document Type"::Order, PurchL."Transport Sales Order No");
                OutStream.WriteText(PurchL."Transport Sales Order No");
                OutStream.WriteText(';');
                OutStream.WriteText(PurchNo);
                OutStream.WriteText(';');
                // OutStream.WRITETEXT('');
                // OutStream.WRITETEXT(';');
                OutStream.WriteText(SalesH."Ship-to Name");
                OutStream.WriteText(';');
                OutStream.WriteText(SalesH."Ship-to Address");
                OutStream.WriteText(';');
                OutStream.WriteText(SalesH."Ship-to City");
                OutStream.WriteText(';');
                OutStream.WriteText(SalesH."Ship-to Post Code");
                OutStream.WriteText(';');
                OutStream.WriteText(Format(PurchL.Quantity));
                OutStream.WriteText(';');
                OutStream.WriteText(PurchL."Logistic unit");
                OutStream.WriteText(';');
                OutStream.WriteText(Format(PurchL."Cases Quantity per Pallet"));
                OutStream.WriteText(';');

                OutStream.WriteText(Format(PurchL."Net Weight"));
                OutStream.WriteText(';');
                OutStream.WriteText(SalesH."External Document No." + '  ' + PurchL."Horaires de livraison");
                OutStream.WriteText(';');
                OutStream.WriteText('TFE');
                OutStream.WriteText(';');
                OutStream.WriteText(SalesH."Ship-to Country/Region Code");
                OutStream.WriteText(';');
                if PurchH."Location Code" = 'ECCONGEL' then
                    OutStream.WriteText('SU')
                else
                    OutStream.WriteText('FR');
                OutStream.WriteText(';');
                OutStream.WriteText(Format(PurchH."Posting Date"));
                OutStream.WriteText(';');
                OutStream.WriteText(Format(SalesH."Date livraison prévue"));
                OutStream.WriteText(';');
                OutStream.WriteText(CRLF);







            until PurchL.Next = 0;
        xfile.Close();
    end;

    [Scope('OnPrem')]
    procedure Contraload(Dt: Date)
    var
        WinSCPSesh: DotNet Session;
        WinSCPSessionOptions: DotNet SessionOptions;
        WinSCPTransferOptions: DotNet TransferOptions;
        WinSCPProtocol: DotNet Protocol;
        WinSCPTransferResumeSupport: DotNet TransferResumeSupport;
        WinSCPTransferResumeSupportState: DotNet TransferResumeSupportState;
        WinSCPTransferResult: DotNet TransferOperationResult;
        filename: Text;
        OutStream: OutStream;
        xfile: File;
        ShipH: Record "Sales Shipment Header";
        ShipL: Record "Sales Shipment Line";
        ShipAdr: Record "Ship-to Address";
        ContraLoadID: Code[20];
        MsgErr: Text;
        Cust: Record Customer;
        CRLF: Text[4];
    begin
        CRLF[1] := 13;
        CRLF[2] := 10;
        filename := 'contraload' + Format(Dt, 0, '<Year><Month,2><Day,2>') + '-' + Format(CurrentDateTime, 0, '<Year><Month,2><Day,2><Hours24><Minutes,2><Seconds,2>') + '.csv';

        ShipL.Reset;
        //ShipL.SETRANGE("Posting Date",CALCDATE('<-30D>',Dt),Dt);
        //ShipL.SETRANGE("Posting Date",011222D,280223D);
        ShipL.SetRange("Posting Date", Dt);

        ShipL.SetFilter("No.", '9-VID-00015|9-VID-00021|9-DIV-00037|9-VID-00023');

        if ShipL.FindFirst then begin
            xfile.Create('\\srvnavision\NavisionTemp\' + filename);
            xfile.CreateOutStream(OutStream);
            OutStream.WriteText('"Sender","Receiver","Date","Direction","Reference","Item","Quantity"');
            OutStream.WriteText(CRLF);
            if ShipL.FindSet then
                repeat
                    ContraLoadID := '';
                    ShipH.Get(ShipL."Document No.");
                    if ShipH."Ship-to Code" = '' then begin
                        Cust.Get(ShipH."Sell-to Customer No.");
                        ContraLoadID := Cust."ID Contraload";
                    end
                    else begin
                        ShipAdr.Get(ShipH."Sell-to Customer No.", ShipH."Ship-to Code");
                        ContraLoadID := ShipAdr."ID Contraload";
                    end;
                    if ContraLoadID = '' then
                        MsgErr += 'ID contraload manquant sur ' + ShipH."No."
                    else begin
                        OutStream.WriteText('"1BE-060410-VNA1"');  //sender
                        OutStream.WriteText(',');
                        OutStream.WriteText('"' + ContraLoadID + '"');  //receiver
                        OutStream.WriteText(',');
                        OutStream.WriteText('"' + Format(ShipL."Posting Date", 0, '<Day,2>/<Month,2>/<Year4,4>') + '"'); //Date
                        OutStream.WriteText(',');
                        OutStream.WriteText('"out"');
                        OutStream.WriteText(',');
                        OutStream.WriteText('"' + ShipL."Document No." + '_' + Format(ShipL."Line No.") + '"');  //Ref
                        OutStream.WriteText(',');
                        if ShipL."No." = '9-VID-00015' then OutStream.WriteText('"15"');  //item
                        if ShipL."No." = '9-VID-00021' then OutStream.WriteText('"03"');  //item
                        if ShipL."No." = '9-DIV-00037' then OutStream.WriteText('"04"');  //item
                        if ShipL."No." = '9-VID-00023' then OutStream.WriteText('"133"');  //item
                        OutStream.WriteText(',');
                        OutStream.WriteText('"' + Format(ShipL.Quantity, 0, '<Integer>') + '"');
                        OutStream.WriteText(CRLF);
                    end;
                until ShipL.Next = 0;
            xfile.Close();

            if (MsgErr <> '') and GuiAllowed then Message(MsgErr);


            WinSCPSessionOptions := WinSCPSessionOptions.SessionOptions();
            WinSCPSessionOptions.Protocol := WinSCPProtocol.Sftp;
            //  WinSCPSessionOptions.HostName := 'sftp.contraload.com';
            //  WinSCPSessionOptions.PortNumber := 22;
            //  WinSCPSessionOptions.UserName := 'EUROPA_CUISSON';
            //  WinSCPSessionOptions.Password := 'FW2n9@RjGj7OmoiSZ3vd';
            WinSCPSessionOptions.HostName := '20.86.224.73';
            WinSCPSessionOptions.PortNumber := 22;
            WinSCPSessionOptions.UserName := 'EUROPA_CUISSON';
            WinSCPSessionOptions.Password := 'eZLLEziGk2AbX%1irHZwam%%';

            WinSCPSessionOptions.GiveUpSecurityAndAcceptAnySshHostKey := true;

            WinSCPSesh := WinSCPSesh.Session();
            WinSCPSesh.Open(WinSCPSessionOptions);
            if WinSCPSesh.Opened then begin
                WinSCPTransferOptions := WinSCPTransferOptions.TransferOptions();
                WinSCPTransferOptions.TransferMode := 0;
                WinSCPTransferResumeSupport := WinSCPTransferOptions.ResumeSupport;
                WinSCPTransferResumeSupport.State(WinSCPTransferResumeSupportState.Off);
                if WinSCPSesh.FileExists('./DECLARE/' + filename) then
                    WinSCPSesh.RemoveFiles('./' + filename);
                // WinSCPTransferResult := WinSCPSesh.PutFiles('\\srvnavision\NavisionTemp\'+filename,'./DECLARE/'+filename,FALSE,WinSCPTransferOptions);
                WinSCPTransferResult := WinSCPSesh.PutFiles('\\srvnavision\NavisionTemp\' + filename, './DECLARE/' + filename, false, WinSCPTransferOptions);
                WinSCPTransferResult.Check();
            end
            else begin
                Error('Connection failed');
            end;
            if WinSCPSesh.Opened then WinSCPSesh.Dispose();

        end;
    end;

    [Scope('OnPrem')]
    procedure ATC(NoExpedition: Code[50])
    var
        Exp: Record "Sales Shipment Header";
        ILE: Record "Item Ledger Entry";
        FileMgt: Codeunit "File Management";
        i: Integer;
        ILESrc: Record "Item Ledger Entry";
        StatsOF: Record "Stats OF";
        LotInfo: Record "Lot No. Information";
        Qty: Decimal;
        LastLot: Text;
        StatsOFCu: Codeunit "Stats OF";
        OFTmp: Record "Production Order" temporary;
    begin
        i := 8;
        ILE.Reset;
        ILE.SetRange("Entry Type", ILE."Entry Type"::Sale);
        ILE.SetFilter("Item No.", '1*|2*');
        ILE.SetFilter("Document No.", NoExpedition);
        if ILE.FindSet then
            repeat
                xLBuf.EnterCell(xLBuf, i, 1, '2', false, false, false);
                xLBuf.EnterCell(xLBuf, i, 2, 'EC', false, false, false);
                xLBuf.EnterCell(xLBuf, i, 3, ILE."Document No.", false, false, false);
                xLBuf.EnterCell(xLBuf, i, 4, ILE."Posting Date", false, false, false);
                xLBuf.EnterCell(xLBuf, i, 5, ILE."Item No.", false, false, false);
                //xLBuf.EnterCell(xLBuf,i,6,ILE.Description,FALSE,FALSE,FALSE);
                xLBuf.EnterCell(xLBuf, i, 7, ILE."Lot No.", false, false, false);
                xLBuf.EnterCell(xLBuf, i, 8, ILE."Warranty Date", false, false, false);


                ILESrc.Reset;
                ILESrc.SetRange("Entry Type", ILESrc."Entry Type"::Output);
                ILESrc.SetRange("Item No.", ILE."Item No.");
                ILESrc.SetRange("Lot No.", ILE."Lot No.");
                if ILESrc.FindLast then begin
                    if (ILESrc."Posting Date" >= CalcDate('<-5D>', Today)) then begin
                        StatsOFCu.Update(ILESrc."Order No.", ILESrc."Order Line No.");
                    end;
                    StatsOF.Reset;
                    StatsOF.SetCurrentKey("OF", source, Lot);
                    StatsOF.SetRange("OF", ILESrc."Order No." + '-' + Format(ILESrc."Order Line No."));
                    StatsOF.SetFilter(source, '7-C*');
                    StatsOF.SetFilter("Quantité utilisee", '>0');
                    LastLot := '';
                    if StatsOF.FindSet then
                        repeat
                            LotInfo.Reset;
                            LotInfo.Get(StatsOF.source, '', StatsOF.Lot);
                            if LastLot <> StatsOF.Lot then begin
                                if (LastLot <> '') then begin
                                    xLBuf.EnterCell(xLBuf, i, 32, Qty, false, false, false);
                                    i += 1;
                                end;
                                Qty := 0;
                                LastLot := StatsOF.Lot;
                                xLBuf.EnterCell(xLBuf, i, 11, LotInfo.ElevagePays, false, false, false);
                                xLBuf.EnterCell(xLBuf, i, 13, LotInfo.ElevageVille, false, false, false);
                                xLBuf.EnterCell(xLBuf, i, 14, LotInfo.AbattagePays, false, false, false);
                                xLBuf.EnterCell(xLBuf, i, 15, LotInfo.AbattageVille, false, false, false);
                                xLBuf.EnterCell(xLBuf, i, 16, LotInfo.AbattageCP, false, false, false);
                                xLBuf.EnterCell(xLBuf, i, 17, LotInfo.AbattageDu, false, false, false);
                                xLBuf.EnterCell(xLBuf, i, 18, LotInfo.AbattageAu, false, false, false);
                                xLBuf.EnterCell(xLBuf, i, 19, LotInfo.DecoupePays, false, false, false);
                                xLBuf.EnterCell(xLBuf, i, 20, LotInfo.DecoupeVille, false, false, false);
                                xLBuf.EnterCell(xLBuf, i, 21, LotInfo.DecoupeCP, false, false, false);
                                xLBuf.EnterCell(xLBuf, i, 22, LotInfo.DecoupeDu, false, false, false);
                                xLBuf.EnterCell(xLBuf, i, 23, LotInfo.DecoupeAu, false, false, false);
                                xLBuf.EnterCell(xLBuf, i, 30, StatsOF.source, false, false, false);
                                xLBuf.EnterCell(xLBuf, i, 31, StatsOF.Lot, false, false, false);
                                xLBuf.EnterCell(xLBuf, i, 33, ILE.Quantity, false, false, false);

                            end;
                            Qty := Qty + ILE.Quantity * StatsOF."Quantité utilisee" / StatsOF."Quantite produite";

                        until StatsOF.Next = 0;
                    xLBuf.EnterCell(xLBuf, i, 32, Qty, false, false, false);

                end;

                if not xLBuf.Insert then xLBuf.Modify;
                i += 1;
            until ILE.Next = 0;





        FileMgt.CopyServerFile('\\srvnavision\NavisionTemp\ATC.xlsx', '\\srvnavision\NavisionTemp\ATC' + NoExpedition + '.xlsx', true);
        xLBuf.UpdateBookExcel('\\srvnavision\NavisionTemp\ATC' + NoExpedition + '.xlsx', 'Input', false);
        xLBuf.WriteSheet('', '', '');

        xLBuf.CloseBook();
        xLBuf.SetFriendlyFilename('ATC' + NoExpedition);
        xLBuf.DownloadAndOpenExcel();
    end;

    [Scope('OnPrem')]
    procedure ContraloadMonterrat(Dt: Date)
    var
        WinSCPSesh: DotNet Session;
        WinSCPSessionOptions: DotNet SessionOptions;
        WinSCPTransferOptions: DotNet TransferOptions;
        WinSCPProtocol: DotNet Protocol;
        WinSCPTransferResumeSupport: DotNet TransferResumeSupport;
        WinSCPTransferResumeSupportState: DotNet TransferResumeSupportState;
        WinSCPTransferResult: DotNet TransferOperationResult;
        filename: Text;
        OutStream: OutStream;
        xfile: File;
        ShipH: Record "Sales Shipment Header";
        ShipL: Record "Sales Shipment Line";
        ShipAdr: Record "Ship-to Address";
        ContraLoadID: Code[20];
        MsgErr: Text;
        Cust: Record Customer;
        CRLF: Text[4];
    begin
        CRLF[1] := 13;
        CRLF[2] := 10;
        filename := 'contraload' + Format(Dt, 0, '<Year><Month,2><Day,2>') + '-' + Format(CurrentDateTime, 0, '<Year><Month,2><Day,2><Hours24><Minutes,2><Seconds,2>') + '.csv';

        ShipL.Reset;
        //ShipL.SETRANGE("Posting Date",CALCDATE('<-30D>',Dt),Dt);
        //ShipL.SETRANGE("Posting Date",011222D,280223D);
        ShipL.SetRange("Posting Date", 20220501D, 20230331D);
        ShipL.SetRange("Sell-to Customer No.", 'C01675');

        ShipL.SetFilter("No.", '9-VID-00015|9-VID-00021|9-DIV-00037|9-VID-00023');

        if ShipL.FindFirst then begin
            xfile.Create('\\srvnavision\NavisionTemp\' + filename);
            xfile.CreateOutStream(OutStream);
            OutStream.WriteText('"Sender","Receiver","Date","Direction","Reference","Item","Quantity"');
            OutStream.WriteText(CRLF);
            if ShipL.FindSet then
                repeat
                    ContraLoadID := '';
                    ShipH.Get(ShipL."Document No.");
                    if ShipH."Ship-to Code" = '' then begin
                        Cust.Get(ShipH."Sell-to Customer No.");
                        ContraLoadID := Cust."ID Contraload";
                    end
                    else begin
                        ShipAdr.Get(ShipH."Sell-to Customer No.", ShipH."Ship-to Code");
                        ContraLoadID := ShipAdr."ID Contraload";
                    end;
                    if ContraLoadID = '' then
                        MsgErr += 'ID contraload manquant sur ' + ShipH."No."
                    else begin
                        OutStream.WriteText('"1BE-060410-VNA1"');  //sender
                        OutStream.WriteText(',');
                        OutStream.WriteText('"' + ContraLoadID + '"');  //receiver
                        OutStream.WriteText(',');
                        OutStream.WriteText('"' + Format(ShipL."Posting Date", 0, '<Day,2>/<Month,2>/<Year4,4>') + '"'); //Date
                        OutStream.WriteText(',');
                        OutStream.WriteText('"out"');
                        OutStream.WriteText(',');
                        OutStream.WriteText('"' + ShipL."Document No." + '_' + Format(ShipL."Line No.") + '"');  //Ref
                        OutStream.WriteText(',');
                        if ShipL."No." = '9-VID-00015' then OutStream.WriteText('"15"');  //item
                        if ShipL."No." = '9-VID-00021' then OutStream.WriteText('"03"');  //item
                        if ShipL."No." = '9-DIV-00037' then OutStream.WriteText('"04"');  //item
                        if ShipL."No." = '9-VID-00023' then OutStream.WriteText('"133"');  //item
                        OutStream.WriteText(',');
                        OutStream.WriteText('"' + Format(ShipL.Quantity, 0, '<Integer>') + '"');
                        OutStream.WriteText(CRLF);
                    end;
                until ShipL.Next = 0;
            xfile.Close();

            if (MsgErr <> '') and GuiAllowed then Message(MsgErr);


            WinSCPSessionOptions := WinSCPSessionOptions.SessionOptions();
            WinSCPSessionOptions.Protocol := WinSCPProtocol.Sftp;
            //  WinSCPSessionOptions.HostName := 'sftp.contraload.com';
            //  WinSCPSessionOptions.PortNumber := 22;
            //  WinSCPSessionOptions.UserName := 'EUROPA_CUISSON';
            //  WinSCPSessionOptions.Password := 'FW2n9@RjGj7OmoiSZ3vd';
            WinSCPSessionOptions.HostName := '20.86.224.73';
            WinSCPSessionOptions.PortNumber := 22;
            WinSCPSessionOptions.UserName := 'EUROPA_CUISSON';
            WinSCPSessionOptions.Password := 'eZLLEziGk2AbX%1irHZwam%%';

            WinSCPSessionOptions.GiveUpSecurityAndAcceptAnySshHostKey := true;

            WinSCPSesh := WinSCPSesh.Session();
            WinSCPSesh.Open(WinSCPSessionOptions);
            if WinSCPSesh.Opened then begin
                WinSCPTransferOptions := WinSCPTransferOptions.TransferOptions();
                WinSCPTransferOptions.TransferMode := 0;
                WinSCPTransferResumeSupport := WinSCPTransferOptions.ResumeSupport;
                WinSCPTransferResumeSupport.State(WinSCPTransferResumeSupportState.Off);
                if WinSCPSesh.FileExists('./' + filename) then
                    WinSCPSesh.RemoveFiles('./' + filename);
                // WinSCPTransferResult := WinSCPSesh.PutFiles('\\srvnavision\NavisionTemp\'+filename,'./DECLARE/'+filename,FALSE,WinSCPTransferOptions);
                WinSCPTransferResult := WinSCPSesh.PutFiles('\\srvnavision\NavisionTemp\' + filename, './' + filename, false, WinSCPTransferOptions);
                WinSCPTransferResult.Check();
            end
            else begin
                Error('Connection failed');
            end;
            if WinSCPSesh.Opened then WinSCPSesh.Dispose();

        end;
    end;

    local procedure Tello(No: Code[20])
    var
        i: Integer;
        Palet: Record Pallet;
        PaletContent: Record PaletContent;
        Item: Record Item;
        j: Integer;
        GS1: Codeunit "GS1 Send";
    begin

        Palet.Reset;
        Palet.SetRange("Outbound Document No.", No);
        i := 1;
        xLBuf.EnterCell(xLBuf, i, 1, 'CAJAS', false, false, false);
        xLBuf.EnterCell(xLBuf, i, 2, 'EAN CAJA (01)', false, false, false);
        xLBuf.EnterCell(xLBuf, i, 3, 'CONSUMO PREFERENTE (15)', false, false, false);
        xLBuf.EnterCell(xLBuf, i, 4, 'PESO NETO (3103)', false, false, false);
        xLBuf.EnterCell(xLBuf, i, 5, 'SSCC CAJA (00)', false, false, false);
        xLBuf.EnterCell(xLBuf, i, 6, 'LOTE (10)', false, false, false);
        xLBuf.EnterCell(xLBuf, i, 7, 'Nº PIEZAS (30)', false, false, false);
        xLBuf.EnterCell(xLBuf, i, 8, 'SSCC PALET (00)', false, false, false);
        i := 2;

        if Palet.FindSet then
            repeat
                j := 1;
                Item.Get(Palet."Item No.");
                Item.CalcFields("Poids carton", "Poids article");
                PaletContent.Reset;
                PaletContent.SetRange(SSCCPalet, Palet."SSCC No.");
                if PaletContent.FindSet then
                    repeat
                        xLBuf.EnterCell(xLBuf, i, 1, Format(j), false, false, false);
                        xLBuf.EnterCell(xLBuf, i, 2, Item."CB carton", false, false, false);
                        xLBuf.EnterCell(xLBuf, i, 3, Format(Palet.DLC, 0, '<Year,2><Month,2><Day,2>'), false, false, false);
                        xLBuf.EnterCell(xLBuf, i, 4, utils.Replace(Format(Item."Poids carton", 3, '<Integer>'), ' ', '0') + utils.Replace(DelChr(Format(Item."Poids carton", 3, '<Decimal>'), '=', ',.'), ' ', '0'), false, false, false);
                        xLBuf.EnterCell(xLBuf, i, 5, PaletContent.SSCCContent, false, false, false);
                        xLBuf.EnterCell(xLBuf, i, 6, utils.PadLeft(Palet."Lot No.", '0', 10), false, false, false);
                        xLBuf.EnterCell(xLBuf, i, 7, utils.PadLeft(Format(Item."Poids carton" / Item."Poids article"), '0', 4), false, false, false);
                        xLBuf.EnterCell(xLBuf, i, 8, GS1.GetSSCCFromPal(Palet."SSCC No."), false, false, false);
                        j += 1;
                        i += 1;
                    until PaletContent.Next = 0;
            until Palet.Next = 0;


        xLBuf.CreateBookAndOpenExcel('\\srvnavision.europacuisson.local\NavisionTemp\tello.xlsx', 'Tello', 'Tello', CompanyName, UserId);
    end;
}

