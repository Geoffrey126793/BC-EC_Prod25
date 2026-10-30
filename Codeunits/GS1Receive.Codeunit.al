codeunit 50033 "GS1 Receive"
{

    trigger OnRun()
    begin
        //MESSAGE('----  %1',GetCheck('37610425002123456'));
        //IFCSUMFromshpt('CDA-E18-4560_01','','3870503390001');

        ReadFile('c:\tmp\test.edi');
    end;

    var
        Fichier: Text[250];
        UniqueID: Text[20];
        CRLF: Text[2];
        GLN: Text[20];
        ShptH: Record "Sales Shipment Header";
        ShptL: Record "Sales Shipment Line";
        Pal: Record Pallet;
        NbreExp: Integer;
        FileName: Text[250];
        xFile: File;
        Utils: Codeunit Utils;
        NbreSegments: Integer;
        DE: Text[1024];
        SalesH: Record "Sales Header";
        SalesL: Record "Sales Line";
        GS1Code: Record GS1Codes;
        Tmp: Text[1024];
        TmpD: Date;
        TmpT: Text[1024];
        Cust: Record Customer;
        TmpI: Integer;
        Items: Record Item;
        SegmentsTreated: Integer;
        TmpDec: Decimal;
        MemoWriterEDI: OutStream;
        MemoWriterBrut: OutStream;
        TypeFichier: Code[30];
        FichierTraite: Boolean;
        TmpBy: Code[30];
        TmpDP: Code[30];

    [Scope('OnPrem')]
    procedure ReadFile(FileName: Text[1024]): Text[1024]
    var
        MyFile: File;
        StreamInTest: InStream;
        Buffer: Text[1024];
        Segment: Text[1024];
        i: Integer;
    begin
        CRLF[1] := 13;
        CRLF[2] := 10;
        FichierTraite := false;


        MyFile.Open(FileName);
        MyFile.CreateInStream(StreamInTest);
        while not StreamInTest.EOS do begin
            StreamInTest.ReadText(Buffer);
            i := 1;
            while (i <= StrLen(Buffer)) do begin                                         //TODO ?'
                if (Buffer[i] = '''') then begin
                    SegmentToTreat(Segment);
                    Segment := '';
                end
                else begin
                    Segment += Format(Buffer[i]);
                end;
                i += 1;
            end;
        end;
        MyFile.Close;

        if not FichierTraite then Error('Fichier non traité');

        if TypeFichier = 'ORDERS' then
            exit(SalesH."No.");
        exit('');
        //MESSAGE('End of stream is reached.');
    end;

    [Scope('OnPrem')]
    procedure GetCheck("Code": Text[30]): Integer
    var
        d: Integer;
        i: Integer;
        "sum": Integer;
    begin
        Code := DelChr(Code, '=', DelChr(Code, '=', '0123456789'));
        for i := 1 to StrLen(Code) do begin
            Evaluate(d, CopyStr(Code, StrLen(Code) - i + 1, 1));
            if i mod 2 = 1 then
                sum += d * 3
            else
                sum += d;
        end;
        sum := 10 - sum mod 10;
        if sum = 10 then sum := 0;
        exit(sum);
    end;

    [Scope('OnPrem')]
    procedure SegmentToTreat(Segment: Text[1024])
    begin
        if StrPos(Segment, 'UNA+') > 0 then UNA(Utils.Replace(Segment, 'UNA+', ''));
        if StrPos(Segment, 'UNA:+') > 0 then UNA(Utils.Replace(Segment, 'UNA:+', ''));
        if StrPos(Segment, 'UNB+') > 0 then UNB(Utils.Replace(Segment, 'UNB+', ''));
        if StrPos(Segment, 'UNH+') > 0 then UNH(Utils.Replace(Segment, 'UNH+', ''));
        if TypeFichier = 'ORDERS' then begin
            MemoWriterBrut.Write(Segment + CRLF);
            if StrPos(Segment, 'BGM+') > 0 then ORDERS_BGM(Utils.Replace(Segment, 'BGM+', ''));
            if StrPos(Segment, 'DTM+') > 0 then ORDERS_DTM(Utils.Replace(Segment, 'DTM+', ''));
            if StrPos(Segment, 'PAI+') > 0 then ORDERS_PAI(Utils.Replace(Segment, 'PAI+', ''));
            if StrPos(Segment, 'ALI+') > 0 then ORDERS_ALI(Utils.Replace(Segment, 'ALI+', ''));
            if StrPos(Segment, 'FTX+') > 0 then ORDERS_FTX(Utils.Replace(Segment, 'FTX+', ''));
            if StrPos(Segment, 'RFF+') > 0 then ORDERS_RFF(Utils.Replace(Segment, 'RFF+', ''));
            if StrPos(Segment, 'NAD+') > 0 then ORDERS_NAD(Utils.Replace(Segment, 'NAD+', ''));
            if StrPos(Segment, 'LOC+') > 0 then ORDERS_LOC(Utils.Replace(Segment, 'LOC+', ''));
            if StrPos(Segment, 'FII+') > 0 then ORDERS_FII(Utils.Replace(Segment, 'FII+', ''));
            if StrPos(Segment, 'DOC+') > 0 then ORDERS_DOC(Utils.Replace(Segment, 'DOC+', ''));
            if StrPos(Segment, 'CTA+') > 0 then ORDERS_CTA(Utils.Replace(Segment, 'CTA+', ''));
            if StrPos(Segment, 'COM+') > 0 then ORDERS_COM(Utils.Replace(Segment, 'COM+', ''));
            if StrPos(Segment, 'TAX+') > 0 then ORDERS_TAX(Utils.Replace(Segment, 'TAX+', ''));
            if StrPos(Segment, 'MOA+') > 0 then ORDERS_MOA(Utils.Replace(Segment, 'MOA+', ''));
            if StrPos(Segment, 'CUX+') > 0 then ORDERS_CUX(Utils.Replace(Segment, 'CUX+', ''));
            if StrPos(Segment, 'PAT+') > 0 then ORDERS_PAT(Utils.Replace(Segment, 'PAT+', ''));
            if StrPos(Segment, 'PCD+') > 0 then ORDERS_PCD(Utils.Replace(Segment, 'PCD+', ''));
            if StrPos(Segment, 'TDT+') > 0 then ORDERS_TDT(Utils.Replace(Segment, 'TDT+', ''));
            if StrPos(Segment, 'TOD+') > 0 then ORDERS_TOD(Utils.Replace(Segment, 'TOD+', ''));
            if StrPos(Segment, 'PAC+') > 0 then ORDERS_PAC(Utils.Replace(Segment, 'PAC+', ''));
            if StrPos(Segment, 'PCI+') > 0 then ORDERS_PCI(Utils.Replace(Segment, 'PCI+', ''));
            if StrPos(Segment, 'GIN+') > 0 then ORDERS_GIN(Utils.Replace(Segment, 'GIN+', ''));
            if StrPos(Segment, 'EQD+') > 0 then ORDERS_EQD(Utils.Replace(Segment, 'EQD+', ''));
            if StrPos(Segment, 'ALC+') > 0 then ORDERS_ALC(Utils.Replace(Segment, 'ALC+', ''));
            if StrPos(Segment, 'QTY+') > 0 then ORDERS_QTY(Utils.Replace(Segment, 'QTY+', ''));
            if StrPos(Segment, 'RNG+') > 0 then ORDERS_RNG(Utils.Replace(Segment, 'RNG+', ''));
            if StrPos(Segment, 'RTE+') > 0 then ORDERS_RTE(Utils.Replace(Segment, 'RTE+', ''));
            if StrPos(Segment, 'LIN+') > 0 then ORDERS_LIN(Utils.Replace(Segment, 'LIN+', ''));
            if StrPos(Segment, 'PIA+') > 0 then ORDERS_PIA(Utils.Replace(Segment, 'PIA+', ''));
            if StrPos(Segment, 'IMD+') > 0 then ORDERS_IMD(Utils.Replace(Segment, 'IMD+', ''));
            if StrPos(Segment, 'MEA+') > 0 then ORDERS_MEA(Utils.Replace(Segment, 'MEA+', ''));
            if StrPos(Segment, 'QVR+') > 0 then ORDERS_QVR(Utils.Replace(Segment, 'QVR+', ''));
            if StrPos(Segment, 'PRI+') > 0 then ORDERS_PRI(Utils.Replace(Segment, 'PRI+', ''));
            if StrPos(Segment, 'UNS+') > 0 then ORDERS_UNS(Utils.Replace(Segment, 'UNS+', ''));
            if StrPos(Segment, 'CNT+') > 0 then ORDERS_CNT(Utils.Replace(Segment, 'CNT+', ''));
            if StrPos(Segment, 'UNT+') > 0 then ORDERS_UNT(Utils.Replace(Segment, 'UNT+', ''));
        end;
    end;

    [Scope('OnPrem')]
    procedure getGS1Code(DE: Code[20]; "Code": Code[20]): Text[1024]
    begin
        if Code = '' then exit('');

        GS1Code.Reset;
        GS1Code.SetRange(DE, DE);
        GS1Code.SetRange(Code, Code);
        if not GS1Code.FindFirst then Error('Code non trouvé ' + DE + '  ' + Code);
        exit(GS1Code.Description);
    end;

    [Scope('OnPrem')]
    procedure getGS1Traitement(DE: Code[20]; "Code": Code[20]): Text[1024]
    begin
        if Code = '' then exit('');

        GS1Code.Reset;
        GS1Code.SetRange(DE, DE);
        GS1Code.SetRange(Code, Code);
        if not GS1Code.FindFirst then Error('Code non trouvé ' + DE + '  ' + Code);
        exit(GS1Code.Traitement);
    end;

    [Scope('OnPrem')]
    procedure AddSignification(Msg: Text[1024])
    begin
        //MESSAGE('%1',Msg);
        if TypeFichier = 'ORDERS' then
            MemoWriterEDI.Write(Msg + CRLF);
    end;

    [Scope('OnPrem')]
    procedure UNA(Segment: Text[1024])
    begin
        //SegmentsTreated += 1;
        DE := Utils.Selectstr(1, Segment, '+');
        AddSignification('UNA ' + Segment);
    end;

    [Scope('OnPrem')]
    procedure UNB(Segment: Text[1024])
    begin
        //SegmentsTreated += 1;
        DE := Utils.Selectstr(1, Segment, '+'); //syntax identifier UNOx3
        DE := Utils.Selectstr(2, Segment, '+'); //Sender
        DE := Utils.Selectstr(3, Segment, '+'); //Recipient
        if (Utils.Selectstr(1, DE, ':') <> '5425005730001') and (Utils.Selectstr(1, DE, ':') <> '5425005730007') then
            Error('Erreur destinataire');
        DE := Utils.Selectstr(3, Segment, '+'); //Dt

        AddSignification('UNB ' + Segment);
    end;

    [Scope('OnPrem')]
    procedure UNH(Segment: Text[1024])
    begin
        SegmentsTreated += 1;
        UniqueID := Utils.Selectstr(1, Segment, '+');

        DE := Utils.Selectstr(2, Segment, '+');
        TypeFichier := Utils.Selectstr(1, DE, ':');


        //IF STRPOS(Segment,'ORDERS:D:01B:UN:EAN010') = 0 THEN
        //  ERROR('Erreur UNH : '+Segment);
        if TypeFichier = 'ORDERS' then begin
            SalesH.Init;
            SalesH."Document Type" := SalesH."Document Type"::Order;
            SalesH.Insert(true);
            SalesH."EDI brut".CreateOutStream(MemoWriterBrut);

            SalesL.Init;
            SalesL."Document No." := '';

            SalesH."EDI Recu".CreateOutStream(MemoWriterEDI);
        end;

        AddSignification('ID ' + UniqueID + '  version ' + Utils.Selectstr(2, Segment, '+'));
    end;

    [Scope('OnPrem')]
    procedure ORDERS_BGM(Segment: Text[1024])
    begin
        SegmentsTreated += 1;
        DE := Utils.Selectstr(1, Segment, '+'); //C002
        Tmp := getGS1Code('BGM_C002_1001', Utils.Selectstr(1, DE, ':'));
        DE := Utils.Selectstr(2, Segment, '+'); //C1006
        SalesH."External Document No." := DE;
        Tmp += ' n° ' + DE;
        DE := Utils.Selectstr(3, Segment, '+'); //1225

        Tmp += 'Version :' + getGS1Code('BGM_C002_1225', Utils.Selectstr(1, DE, ':'));
        //DG IF DE <> '9' THEN
        //DG  ERROR('il ne s''agit pas d''une commande initiale');

        AddSignification(Tmp);
    end;

    [Scope('OnPrem')]
    procedure ORDERS_DTM(Segment: Text[1024])
    var
        d: Integer;
        m: Integer;
        y: Integer;
    begin
        SegmentsTreated += 1;
        DE := Utils.Selectstr(1, Segment, '+'); //C507
        Tmp := getGS1Code('DTM', Utils.Selectstr(1, DE, ':'));
        TmpT := Utils.Selectstr(2, DE, ':');
        Evaluate(y, CopyStr(TmpT, 1, 4));
        Evaluate(m, CopyStr(TmpT, 5, 2));
        Evaluate(d, CopyStr(TmpT, 7, 2));
        if Utils.Selectstr(3, DE, ':') = '102' then //CCYYMMDD
            TmpD := DMY2Date(d, m, y);
        if Utils.Selectstr(3, DE, ':') = '203' then //CCYYMMDDHHMM
            TmpD := DMY2Date(d, m, y);
        if Utils.Selectstr(3, DE, ':') = '616' then //CCYYWW
            TmpD := DMY2Date(1, m, y);
        if Utils.Selectstr(3, DE, ':') = '718' then //CCYYMMDD-CCYYMMDD
            TmpD := DMY2Date(d, m, y);
        Tmp += Format(TmpD);
        if GS1Code.Traitement = '0' then //Date de commande
        begin
            SalesH."Order Date" := TmpD;
            SalesH.Validate("Document Date", TmpD);
        end;
        if GS1Code.Traitement = '1' then //Date enlévement
            SalesH."Requested Delivery Date" := TmpD;
        if GS1Code.Traitement = '2' then //Date livraison
        begin
            SalesH."Requested Delivery Date" := CalcDate('<-2D>', TmpD);
            SalesH."Date livraison prévue" := TmpD;
        end;
        if GS1Code.Traitement = '3' then //Date d'enlevement
        begin
            SalesH."Requested Delivery Date" := TmpD;
            SalesH."Shipping Agent Code" := 'ENL';
        end;

        AddSignification(Tmp);
    end;

    [Scope('OnPrem')]
    procedure ORDERS_PAI(Segment: Text[1024])
    begin
        SegmentsTreated += 1;
        DE := Utils.Selectstr(1, Segment, '+'); //C534
        Tmp := 'Payment :';
        if Utils.Selectstr(1, DE, ':') <> '' then
            Tmp := Tmp + getGS1Code('PAI_C534_4439', Utils.Selectstr(1, DE, ':'));
        if Utils.Selectstr(2, DE, ':') <> '' then
            Tmp := Tmp + getGS1Code('PAI_C534_4431', Utils.Selectstr(2, DE, ':'));
        if Utils.Selectstr(3, DE, ':') <> '' then
            Tmp := Tmp + getGS1Code('PAI_C534_4461', Utils.Selectstr(3, DE, ':'));

        AddSignification(Tmp);
    end;

    [Scope('OnPrem')]
    procedure ORDERS_ALI(Segment: Text[1024])
    begin
        SegmentsTreated += 1;
        Tmp := 'Conditions :';
        if Utils.Selectstr(1, Segment, '+') <> '' then
            Tmp := Tmp + 'Country ' + getGS1Code('ALI_9213', Utils.Selectstr(1, Segment, '+'));
        if Utils.Selectstr(3, Segment, '+') <> '' then
            Tmp := Tmp + getGS1Code('ALI_4183', Utils.Selectstr(3, Segment, '+'));

        AddSignification(Tmp);
    end;

    [Scope('OnPrem')]
    procedure ORDERS_FTX(Segment: Text[1024])
    begin
        SegmentsTreated += 1;
        Tmp := 'Free text : ' + Segment;
        AddSignification(Tmp);
    end;

    [Scope('OnPrem')]
    procedure ORDERS_RFF(Segment: Text[1024])
    begin
        SegmentsTreated += 1;
        Tmp := 'Reference :';
        Tmp := Tmp + getGS1Code('RFF', Utils.Selectstr(1, Segment, ':'));
        Tmp := Tmp + Utils.Selectstr(2, Segment, ':');

        AddSignification(Tmp);
    end;

    [Scope('OnPrem')]
    procedure ORDERS_NAD(Segment: Text[1024])
    var
        recLoc: Record "Ship-to Address";
        Trouve: Boolean;
    begin
        SegmentsTreated += 1;
        Tmp := 'Name & Address : ';
        TmpT := Utils.Selectstr(1, Segment, '+');
        Tmp := Tmp + getGS1Code('NAD', Utils.Selectstr(1, TmpT, ':'));
        DE := Utils.Selectstr(2, Segment, '+');
        //IF (Utils.Selectstr(3,DE,':') <> '9') THEN ERROR('NAD not GS1');
        Tmp += 'GLN : ' + Utils.Selectstr(1, DE, ':');

        if TmpT = 'BY' then begin
            TmpBy := Utils.Selectstr(1, DE, ':');
            //  Cust.RESET;
            //  Cust.SETRANGE(GLN,Utils.Selectstr(1,DE,':'));
            //  IF NOT Cust.FINDFIRST THEN ERROR('Client avec GLN %1 non trouvé', Utils.Selectstr(1,DE,':'));
            //  SalesH.VALIDATE("Sell-to Customer No.",Cust."No.");
            //  SalesH.MODIFY;
            //  Tmp += 'Client acheteur : '+Cust."No." + '  '+ Cust.Name;
        end;

        if TmpT = 'DP' then begin
            TmpDP := Utils.Selectstr(1, DE, ':');
            Cust.Reset;
            Cust.SetRange(GLN, TmpBy);
            Trouve := false;
            if Cust.FindSet then
                repeat
                    recLoc.Reset;
                    recLoc.SetRange("Customer No.", Cust."No.");
                    recLoc.SetRange(GLN, Utils.Selectstr(1, DE, ':'));
                    if not Trouve and recLoc.FindFirst then begin
                        SalesH.Validate("Sell-to Customer No.", Cust."No.");
                        SalesH.Modify;
                        SalesH.Validate("Ship-to Code", recLoc.Code);
                        Trouve := true;
                    end;
                until Cust.Next = 0;


            //IF NOT Trouve THEN ERROR('Client avec GLN %1 - %2 non trouvé %3', TmpBy,Utils.Selectstr(1,DE,':'),Cust.COUNT);
            if Cust.FindFirst then Tmp += 'Client acheteur : ' + Cust."No." + '  ' + Cust.Name;
        end;

        if TmpT = 'IV' then begin
            Cust.Reset;
            Cust.SetRange(GLN, Utils.Selectstr(1, DE, ':'));
            Trouve := false;
            if Cust.FindSet then
                repeat
                    recLoc.Reset;
                    recLoc.SetRange("Customer No.", Cust."No.");
                    recLoc.SetRange(GLN, TmpDP);
                    if not Trouve and recLoc.FindFirst then begin
                        SalesH.Validate("Sell-to Customer No.", Cust."No.");
                        SalesH.Modify;
                        SalesH.Validate("Ship-to Code", recLoc.Code);
                        Trouve := true;
                    end;
                until Cust.Next = 0;

            if not Trouve then Error('Client avec GLN %1 - %2 non trouvé %3', Utils.Selectstr(1, DE, ':'), TmpDP + TmpT, Cust.Count);


            SalesH.Validate("Bill-to Customer No.", Cust."No.");
            SalesH.Modify;
            Tmp += 'Client facture : ' + Cust."No." + '  ' + Cust.Name;
        end;

        AddSignification(Tmp);
    end;

    [Scope('OnPrem')]
    procedure ORDERS_LOC(Segment: Text[1024])
    var
        recLoc: Record "Ship-to Address";
    begin
        SegmentsTreated += 1;
        Tmp := 'Location : ';
        TmpT := Utils.Selectstr(1, Segment, '+');
        Tmp := Tmp + getGS1Code('LOC', TmpT);

        DE := Utils.Selectstr(2, Segment, '+');
        if (Utils.Selectstr(3, DE, ':') = '9') then begin
            Tmp += 'GLN : ' + Utils.Selectstr(1, DE, ':');
            if TmpT = '7' then begin
                recLoc.Reset;
                recLoc.SetRange("Customer No.", SalesH."Sell-to Customer No.");
                recLoc.SetRange(GLN, Utils.Selectstr(1, DE, ':'));
                if not recLoc.FindFirst then Error('GLN Location non trouvé %1', Utils.Selectstr(1, DE, ':'));
                if (SalesH."Ship-to Code" <> '') and (SalesH."Ship-to Code" <> recLoc.Code) then Error('2 adresses de livraisons');
                SalesH.Validate("Ship-to Code", recLoc.Code);
                Tmp += recLoc.Code + '  ' + recLoc.Name;
            end;
        end
        else begin
            Tmp += Utils.Selectstr(3, Segment, '+');
            Tmp += Utils.Selectstr(4, Segment, '+');
        end;

        AddSignification(Tmp);
    end;

    [Scope('OnPrem')]
    procedure ORDERS_FII(Segment: Text[1024])
    var
        recLoc: Record "Ship-to Address";
    begin
        SegmentsTreated += 1;
        Tmp := 'Financial institution : ' + Segment;
        AddSignification(Tmp);
    end;

    [Scope('OnPrem')]
    procedure ORDERS_DOC(Segment: Text[1024])
    var
        recLoc: Record "Ship-to Address";
    begin
        SegmentsTreated += 1;
        Tmp := 'Documents : ' + Segment;
        AddSignification(Tmp);
    end;

    [Scope('OnPrem')]
    procedure ORDERS_CTA(Segment: Text[1024])
    var
        recLoc: Record "Ship-to Address";
    begin
        SegmentsTreated += 1;
        Tmp := 'Contact : ' + Segment;
        Tmp += getGS1Code('CTA', Utils.Selectstr(1, Segment, '+'));
        Tmp += Utils.Replace(Utils.Selectstr(2, Segment, '+'), ':', ' ');
        SalesH."Sell-to Contact" := Utils.Replace(Utils.Selectstr(2, Segment, '+'), ':', ' ');
        AddSignification(Tmp);
    end;

    [Scope('OnPrem')]
    procedure ORDERS_COM(Segment: Text[1024])
    var
        recLoc: Record "Ship-to Address";
    begin
        SegmentsTreated += 1;
        Tmp := 'Communication : ';
        Tmp += Utils.Selectstr(1, Segment, ':');
        Tmp += getGS1Code('COM', Utils.Selectstr(2, Segment, ':'));
        AddSignification(Tmp);
    end;

    [Scope('OnPrem')]
    procedure ORDERS_TAX(Segment: Text[1024])
    var
        recLoc: Record "Ship-to Address";
    begin
        SegmentsTreated += 1;
        Tmp := 'Taxes : ';
        Tmp += Segment;
        AddSignification(Tmp);
    end;

    [Scope('OnPrem')]
    procedure ORDERS_MOA(Segment: Text[1024])
    var
        recLoc: Record "Ship-to Address";
    begin
        SegmentsTreated += 1;
        Tmp := 'Montant : ';
        Tmp += getGS1Code('MOA', Utils.Selectstr(1, Segment, ':'));
        Tmp += Utils.Selectstr(2, Segment, ':');
        Tmp += '  ' + Utils.Selectstr(3, Segment, ':');
        Tmp += '  ' + Utils.Selectstr(4, Segment, ':');
        Tmp += '  ' + Utils.Selectstr(5, Segment, ':');
        AddSignification(Tmp);
    end;

    [Scope('OnPrem')]
    procedure ORDERS_CUX(Segment: Text[1024])
    var
        recLoc: Record "Ship-to Address";
    begin
        SegmentsTreated += 1;
        Tmp := 'Currency : ';
        DE := Utils.Selectstr(1, Segment, '+');
        Tmp += getGS1Code('CUX', Utils.Selectstr(1, DE, ':'));
        Tmp += '  ' + Utils.Selectstr(2, DE, ':');
        Tmp += getGS1Code('CUX', Utils.Selectstr(3, DE, ':'));
        Tmp += '  ' + Utils.Selectstr(4, DE, ':');

        DE := Utils.Selectstr(2, Segment, '+');
        Tmp += '  --  ' + getGS1Code('CUX', Utils.Selectstr(1, DE, ':'));
        Tmp += '  ' + Utils.Selectstr(2, DE, ':');
        Tmp += getGS1Code('CUX', Utils.Selectstr(3, DE, ':'));
        Tmp += '  ' + Utils.Selectstr(4, DE, ':');

        Tmp += ' Taux : ' + Utils.Selectstr(3, Segment, '+');
        AddSignification(Tmp);
    end;

    [Scope('OnPrem')]
    procedure ORDERS_PAT(Segment: Text[1024])
    var
        recLoc: Record "Ship-to Address";
    begin
        SegmentsTreated += 1;
        Tmp := 'Payment terms : ';
        DE := Utils.Selectstr(1, Segment, '+');
        Tmp += getGS1Code('PAT_4279', Utils.Selectstr(1, DE, ':'));

        DE := Utils.Selectstr(2, Segment, '+');
        Tmp += '  ' + getGS1Code('PAT_4277', Utils.Selectstr(1, DE, ':'));
        Tmp += '  ' + Utils.Selectstr(2, DE, ':');
        Tmp += '  ' + Utils.Selectstr(3, DE, ':');
        Tmp += '  ' + Utils.Selectstr(4, DE, ':');
        Tmp += '  ' + Utils.Selectstr(5, DE, ':');

        DE := Utils.Selectstr(3, Segment, '+');
        Tmp += '  --  ' + getGS1Code('PAT_2475', Utils.Selectstr(1, DE, ':'));
        Tmp += '  ' + Utils.Selectstr(4, DE, ':');
        Tmp += '' + Utils.Selectstr(3, DE, ':');

        AddSignification(Tmp);
    end;

    [Scope('OnPrem')]
    procedure ORDERS_PCD(Segment: Text[1024])
    var
        recLoc: Record "Ship-to Address";
    begin
        SegmentsTreated += 1;
        Tmp := 'Percentage details : ';
        DE := Utils.Selectstr(1, Segment, '+');
        Tmp += getGS1Code('PCD', Utils.Selectstr(1, DE, ':'));
        Tmp += '  ' + Utils.Selectstr(2, DE, ':');
        Tmp += '  ' + getGS1Code('PCD', Utils.Selectstr(3, DE, ':'));

        AddSignification(Tmp);
    end;

    [Scope('OnPrem')]
    procedure ORDERS_TDT(Segment: Text[1024])
    var
        recLoc: Record "Ship-to Address";
    begin
        SegmentsTreated += 1;
        Tmp := 'Transport : ';
        Tmp += '  ' + Segment;

        AddSignification(Tmp);
    end;

    [Scope('OnPrem')]
    procedure ORDERS_TOD(Segment: Text[1024])
    var
        recLoc: Record "Ship-to Address";
    begin
        SegmentsTreated += 1;
        Tmp := 'Terms of delivery or transport : ';
        DE := Utils.Selectstr(1, Segment, '+');
        Tmp += getGS1Code('TOD', Utils.Selectstr(1, DE, ':'));
        DE := Utils.Selectstr(2, Segment, '+');
        Tmp += '  ' + getGS1Code('TOD', Utils.Selectstr(1, DE, ':'));
        DE := Utils.Selectstr(2, Segment, '+');
        Tmp += DE;

        Tmp += '  ' + Segment;

        AddSignification(Tmp);
    end;

    [Scope('OnPrem')]
    procedure ORDERS_PAC(Segment: Text[1024])
    var
        recLoc: Record "Ship-to Address";
    begin
        SegmentsTreated += 1;
        Tmp := 'Packaging : ';

        DE := Utils.Selectstr(1, Segment, '+');
        Tmp += 'Quantity : ' + DE;
        DE := Utils.Selectstr(2, Segment, '+');
        Tmp += '  Level : ' + Utils.Selectstr(1, DE, ':');
        Tmp += '  ' + getGS1Code('PAC_7233', Utils.Selectstr(2, DE, ':'));
        Tmp += '  ' + getGS1Code('PAC_7073', Utils.Selectstr(3, DE, ':'));

        DE := Utils.Selectstr(3, Segment, '+');
        Tmp += ' Type : ' + getGS1Code('PAC', Utils.Selectstr(1, DE, ':'));
        if (SalesL."Unit of Measure Code" = 'PCE') and (Utils.Selectstr(1, DE, ':') <> '') then
            SalesL.Validate("Unit of Measure Code", Utils.Selectstr(1, DE, ':'));

        DE := Utils.Selectstr(4, Segment, '+');
        Tmp += ' Identification : ' + DE;

        DE := Utils.Selectstr(4, Segment, '+');
        Tmp += ' Retour : ' + getGS1Code('PAC_8395', Utils.Selectstr(1, DE, ':'));


        AddSignification(Tmp);
    end;

    [Scope('OnPrem')]
    procedure ORDERS_PCI(Segment: Text[1024])
    var
        recLoc: Record "Ship-to Address";
    begin
        SegmentsTreated += 1;
        Tmp := 'Marking : ';

        DE := Utils.Selectstr(1, Segment, '+');
        Tmp += ' ' + getGS1Code('PCI', Utils.Selectstr(1, DE, ':'));
        ;

        DE := Utils.Selectstr(2, Segment, '+');
        Tmp += '  ' + DE;
        DE := Utils.Selectstr(3, Segment, '+');
        Tmp += '  ' + DE;
        DE := Utils.Selectstr(4, Segment, '+');
        Tmp += '  ' + DE;

        AddSignification(Tmp);
    end;

    [Scope('OnPrem')]
    procedure ORDERS_GIN(Segment: Text[1024])
    var
        recLoc: Record "Ship-to Address";
    begin
        SegmentsTreated += 1;
        Tmp := 'Goods Identity Number : ';

        DE := Utils.Selectstr(1, Segment, '+');
        Tmp += ' ' + getGS1Code('GIN', Utils.Selectstr(1, DE, ':'));
        ;

        DE := Utils.Selectstr(2, Segment, '+');
        Tmp += '  ' + DE;
        DE := Utils.Selectstr(3, Segment, '+');
        Tmp += '  ' + DE;
        DE := Utils.Selectstr(4, Segment, '+');
        Tmp += '  ' + DE;
        DE := Utils.Selectstr(5, Segment, '+');
        Tmp += '  ' + DE;
        DE := Utils.Selectstr(6, Segment, '+');
        Tmp += '  ' + DE;

        AddSignification(Tmp);
    end;

    [Scope('OnPrem')]
    procedure ORDERS_EQD(Segment: Text[1024])
    var
        recLoc: Record "Ship-to Address";
    begin
        SegmentsTreated += 1;
        Tmp := 'Equipment details : ';

        Tmp += '  ' + Segment;

        AddSignification(Tmp);
    end;

    [Scope('OnPrem')]
    procedure ORDERS_ALC(Segment: Text[1024])
    var
        recLoc: Record "Ship-to Address";
    begin
        SegmentsTreated += 1;
        Tmp := 'Allowance or charge : ';
        DE := Utils.Selectstr(1, Segment, '+');
        Tmp += ' ' + getGS1Code('ALC_5463', Utils.Selectstr(1, DE, ':'));

        DE := Utils.Selectstr(2, Segment, '+'); //C552
        Tmp += ' ' + Utils.Selectstr(1, DE, ':');
        Tmp += ' ' + getGS1Code('ALC_5189', Utils.Selectstr(2, DE, ':'));

        DE := Utils.Selectstr(3, Segment, '+'); //4471
        Tmp += ' ' + getGS1Code('ALC_4471', Utils.Selectstr(2, DE, ':'));

        DE := Utils.Selectstr(4, Segment, '+'); //1227
        Tmp += ' step ' + Utils.Selectstr(1, DE, ':');

        DE := Utils.Selectstr(5, Segment, '+'); //C214
        Tmp += ' ' + getGS1Code('ALC_7161', Utils.Selectstr(1, DE, ':'));
        Tmp += ' ' + DE;

        AddSignification(Tmp);
    end;

    [Scope('OnPrem')]
    procedure ORDERS_QTY(Segment: Text[1024])
    var
        recLoc: Record "Ship-to Address";
        IUOM: Record "Item Unit of Measure";
    begin
        SegmentsTreated += 1;
        Tmp := 'Quantity : ';
        DE := Utils.Selectstr(1, Segment, '+');
        Tmp += ' ' + getGS1Code('QTY', Utils.Selectstr(1, DE, ':'));
        Tmp += ' ' + Utils.Selectstr(2, DE, ':');
        Tmp += ' ' + getGS1Code('MEA', Utils.Selectstr(3, DE, ':'));

        if getGS1Traitement('QTY', Utils.Selectstr(1, DE, ':')) = 'QTY' then
            if getGS1Traitement('MEA', Utils.Selectstr(3, DE, ':')) <> 'KG' then begin
                if SalesL."Document No." <> '' then begin
                    Evaluate(TmpDec, Utils.Selectstr(2, DE, ':'));
                    SalesL.Validate(Quantity, TmpDec);
                    SalesL.Validate("Unit of Measure Code", Utils.Selectstr(3, DE, ':'));
                    //DG210223  on garde l'unité
                    //DG060323 pour CT
                    //DG171023 et PCE
                    if ((SalesL."Unit of Measure Code" <> 'CT') and (SalesL."Unit of Measure Code" <> 'PCE')) then begin
                        IUOM.Reset;
                        IUOM.SetRange("Item No.", SalesL."No.");
                        IUOM.SetRange(Code, Utils.Selectstr(3, DE, ':'));
                        if IUOM.FindFirst then
                            SalesL.Validate(Quantity, TmpDec * IUOM."Qty. per Unit of Measure");
                        SalesL.Validate("Unit of Measure Code", 'KG');
                    end;
                end;
            end
            else begin
                if SalesL."Document No." <> '' then begin
                    Evaluate(TmpDec, Utils.Selectstr(2, DE, ':'));
                    SalesL.Validate(Quantity, TmpDec);
                    SalesL.Validate("Unit of Measure Code", Utils.Replace(Utils.Selectstr(3, DE, ':'), 'KGM', 'KG'));
                end;
            end;

        AddSignification(Tmp);
    end;

    [Scope('OnPrem')]
    procedure ORDERS_RNG(Segment: Text[1024])
    var
        recLoc: Record "Ship-to Address";
    begin
        SegmentsTreated += 1;
        Tmp := 'Range : ';
        DE := Utils.Selectstr(1, Segment, '+');
        Tmp += ' ' + getGS1Code('RNG', Utils.Selectstr(1, DE, ':'));
        DE := Utils.Selectstr(2, Segment, '+');
        Tmp += ' ' + getGS1Code('MEA', Utils.Selectstr(1, DE, ':'));
        Tmp += ' min : ' + Utils.Selectstr(2, DE, ':');
        Tmp += ' max : ' + Utils.Selectstr(3, DE, ':');

        AddSignification(Tmp);
    end;

    [Scope('OnPrem')]
    procedure ORDERS_RTE(Segment: Text[1024])
    var
        recLoc: Record "Ship-to Address";
    begin
        SegmentsTreated += 1;
        Tmp := 'Rate details : ';
        Tmp += Segment;

        AddSignification(Tmp);
    end;

    [Scope('OnPrem')]
    procedure ORDERS_LIN(Segment: Text[1024])
    var
        recLoc: Record "Ship-to Address";
    begin
        SegmentsTreated += 1;
        Tmp := 'Line item : ';
        DE := Utils.Selectstr(1, Segment, '+'); //Line count
        Tmp += ' Count : ' + DE;
        Evaluate(TmpI, DE);
        DE := Utils.Selectstr(2, Segment, '+'); // Action request, notification description code
        Tmp += ' action req/notif : ' + DE;
        DE := Utils.Selectstr(3, Segment, '+');
        Tmp += ' item number : ' + DE;
        if ((Utils.Selectstr(2, DE, ':') = 'SRV') or (Utils.Selectstr(2, DE, ':') = 'EN')) then begin
            SalesL.Init;
            SalesL."Document Type" := SalesL."Document Type"::Order;
            SalesL."Document No." := SalesH."No.";
            SalesL."Line No." := TmpI * 10000;
            SalesL.Insert(true);

            SalesL.Validate(Type, SalesL.Type::Item);
            Items.Reset;
            TmpT := Utils.Selectstr(1, DE, ':');
            if StrLen(TmpT) > 13 then
                TmpT := CopyStr(TmpT, StrLen(TmpT) - 13, 13);
            Items.SetRange(Items."EAN13 Code", TmpT);
            if not Items.FindFirst then Error('Article non trouvé %1', TmpT);
            SalesL.Validate("No.", Items."No.");
            SalesL.Modify(true);
            Tmp += '  ARTICLE : ' + Items."No.";
        end
        else begin
            Error('Pas de GTIN dans LIN');
        end;

        DE := Utils.Selectstr(4, Segment, '+');
        Tmp += '   ' + DE;
        DE := Utils.Selectstr(5, Segment, '+');
        Tmp += '   ' + DE;
        DE := Utils.Selectstr(6, Segment, '+');
        Tmp += '   ' + DE;

        AddSignification(Tmp);
    end;

    [Scope('OnPrem')]
    procedure ORDERS_PIA(Segment: Text[1024])
    var
        recLoc: Record "Ship-to Address";
    begin
        SegmentsTreated += 1;
        Tmp := 'Additionnal Product ID : ';
        Tmp += Segment;

        AddSignification(Tmp);
    end;

    [Scope('OnPrem')]
    procedure ORDERS_IMD(Segment: Text[1024])
    var
        recLoc: Record "Ship-to Address";
    begin
        SegmentsTreated += 1;
        Tmp := 'Item description : ';

        DE := Utils.Selectstr(1, Segment, '+');
        Tmp += ' ' + getGS1Code('IMD_7077', Utils.Selectstr(1, DE, ':'));
        DE := Utils.Selectstr(2, Segment, '+');
        Tmp += ' ' + getGS1Code('IMD_7081', Utils.Selectstr(1, DE, ':'));
        DE := Utils.Selectstr(3, Segment, '+');
        Tmp += ' ' + getGS1Code('IMD_7009', Utils.Selectstr(1, DE, ':'));
        Tmp += ' ' + Utils.Selectstr(4, DE, ':');
        Tmp += ' ' + Utils.Selectstr(5, DE, ':');
        DE := Utils.Selectstr(4, Segment, '+');

        AddSignification(Tmp);
    end;

    [Scope('OnPrem')]
    procedure ORDERS_MEA(Segment: Text[1024])
    var
        recLoc: Record "Ship-to Address";
    begin
        SegmentsTreated += 1;
        Tmp := 'Measurements : ';

        DE := Utils.Selectstr(1, Segment, '+');
        Tmp += ' ' + getGS1Code('MEA_6311', Utils.Selectstr(1, DE, ':'));

        DE := Utils.Selectstr(2, Segment, '+');
        Tmp += ' ' + getGS1Code('MEA_ATTR', Utils.Selectstr(1, DE, ':'));
        Tmp += ' ' + getGS1Code('MEA_6321', Utils.Selectstr(2, DE, ':'));
        Tmp += ' ' + Utils.Selectstr(3, DE, ':');
        Tmp += ' ' + Utils.Selectstr(4, DE, ':');

        DE := Utils.Selectstr(3, Segment, '+');
        Tmp += ' ' + Utils.Selectstr(2, DE, ':');
        Tmp += ' ' + getGS1Code('MEA', Utils.Selectstr(1, DE, ':'));
        Tmp += ' min ' + Utils.Selectstr(3, DE, ':');
        Tmp += ' max ' + Utils.Selectstr(4, DE, ':');

        DE := Utils.Selectstr(4, Segment, '+');

        AddSignification(Tmp);
    end;

    [Scope('OnPrem')]
    procedure ORDERS_CNT(Segment: Text[1024])
    var
        recLoc: Record "Ship-to Address";
    begin
        SegmentsTreated += 1;
        Tmp := 'Control total : ';

        DE := Utils.Selectstr(1, Segment, '+');
        Tmp += ' ' + getGS1Code('CNT', Utils.Selectstr(1, DE, ':'));
        Tmp += ' ' + Utils.Selectstr(2, DE, ':');
        Tmp += ' ' + Utils.Selectstr(3, DE, ':');


        AddSignification(Tmp);
    end;

    [Scope('OnPrem')]
    procedure ORDERS_UNS(Segment: Text[1024])
    var
        recLoc: Record "Ship-to Address";
    begin
        SegmentsTreated += 1;
    end;

    [Scope('OnPrem')]
    procedure ORDERS_UNT(Segment: Text[1024])
    var
        recLoc: Record "Ship-to Address";
    begin
        SegmentsTreated += 1;
        Tmp := 'Message trailer : ';

        DE := Utils.Selectstr(1, Segment, '+');
        Tmp += ' Nbre segments ' + DE;
        Evaluate(TmpI, DE);
        if TmpI <> SegmentsTreated then Error('Nbre segments : %1 <> %2', TmpI, SegmentsTreated);

        DE := Utils.Selectstr(2, Segment, '+');
        Tmp += ' Reference ' + DE;
        if DE <> UniqueID then Error('Difference UNH - UNT');

        SalesH.Modify;
        SalesL.Modify;
        FichierTraite := true;
        AddSignification(Tmp);
    end;

    [Scope('OnPrem')]
    procedure ORDERS_QVR(Segment: Text[1024])
    var
        recLoc: Record "Ship-to Address";
    begin
        SegmentsTreated += 1;
        Tmp := 'Quantity variance : ';
        Tmp += ' Nbre segments ' + Segment;

        AddSignification(Tmp);
    end;

    [Scope('OnPrem')]
    procedure ORDERS_PRI(Segment: Text[1024])
    var
        recLoc: Record "Ship-to Address";
    begin
        SegmentsTreated += 1;
        Tmp := 'Price : ';

        DE := Utils.Selectstr(1, Segment, '+');
        Tmp += '  ' + getGS1Code('PRI_5125', Utils.Selectstr(1, DE, ':'));
        Tmp += '  ' + Utils.Selectstr(2, DE, ':');
        Tmp += '  ' + getGS1Code('PRI_5375', Utils.Selectstr(3, DE, ':'));
        Tmp += '  ' + getGS1Code('PRI_5387', Utils.Selectstr(4, DE, ':'));
        Tmp += '  ' + Utils.Selectstr(5, DE, ':');
        Tmp += '  ' + getGS1Code('MEA', Utils.Selectstr(6, DE, ':'));

        Evaluate(TmpDec, ConvertStr(Utils.Selectstr(2, DE, ':'), '.', ','));
        //IF TmpDec <> SalesL."Unit Price" THEN ERROR('Prix %1  <> %2', TmpDec, SalesL."Unit Price");

        AddSignification(Tmp);
    end;
}

