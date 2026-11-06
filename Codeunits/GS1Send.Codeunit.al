codeunit 50035 "GS1 Send"
{

    trigger OnRun()
    var
        shpt: Record "Sales Shipment Header";
        SalesH: Record "Sales Invoice Header";
    begin
        //MESSAGE('----  %1',GetCheck('37610425002123456'));
        //IFCSUMFromshpt('CDA-E19-1723_1','\\srvnavision\NavisionTemp\CDA-E19-1723_2','3870503390001','3870503390001');

        shpt.SetRange("No.", 'EXV-E26-09209');
        shpt.FindFirst;
        Cust.Get(shpt."Sell-to Customer No.");
        DESADV(shpt, '\\srvnavision\NavisionTemp\Test\' + shpt."No." + '.txt');
        /*
        shpt.SETRANGE("No.",'EXV-E23-02867');
        shpt.FINDFIRST;
        DESADV(shpt,'\\srvnavision\NavisionTemp\Test\'+shpt."No."+'.txt');
        shpt.SETRANGE("No.",'EXV-E24-00963');
        shpt.FINDFIRST;
        DESADV(shpt,'\\srvnavision\NavisionTemp\Test\'+shpt."No."+'.txt');
        
        SalesH.RESET;
        SalesH.SETRANGE("No.",'VEN-E23-02748');
        IF SalesH.FINDFIRST THEN
          EINVOIC(SalesH,'\\srvnavision\NavisionTemp\Test\'+SalesH."No."+'.txt');
        */

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
        xFile: File;
        Utils: Codeunit Utils;
        NbreSegments: Integer;
        DE: Text[1024];
        GS1Code: Record GS1Codes;
        Tmp: Text[1024];
        TmpD: Date;
        TmpT: Text[1024];
        Cust: Record Customer;
        TmpI: Integer;
        Items: Record Item;
        SegmentsTreated: Integer;
        TmpDec: Decimal;
        TypeFichier: Code[30];
        FichierTraite: Boolean;
        ItemLedg: Record "Item Ledger Entry";
        TotalQty: Decimal;
        SalesH: Record "Sales Invoice Header";
        SalesL: Record "Sales Invoice Line";

    [Scope('OnPrem')]
    procedure EINVOIC(_SalesH: Record "Sales Invoice Header"; FileName: Text[250])
    var
        DecVATAmount_g: Decimal;
        DecVATBaseAmount_g: Decimal;
        DecVATDiscountAmount_g: Decimal;
        DecTotalAmountInclVAT_g: Decimal;
        RecVATAmountLine_g: array[5] of Record "VAT Amount Line" temporary;
        CUAbsysTools_l: Codeunit "Absys - tools PJ";
        i: Integer;
    begin
        NbreSegments := 0;
        SalesH.Get(_SalesH."No.");
        Cust.Get(SalesH."Sell-to Customer No.");

        Clear(xFile);
        xFile.TextMode := true;
        xFile.WriteMode := true;
        xFile.Create(FileName);

        CRLF := ' ';
        CRLF[1] := 13;
        CRLF[2] := 10;
        GLN := '5425005730001';

        TypeFichier := 'INVOIC';
        //WriteToFile(UNA());
        WriteToFile(EINVOIC_UNB(Cust."GLN Destinataire"));
        WriteToFile(EINVOIC_UNH());
        WriteToFile(EINVOIC_BGM(SalesH."No."));
        WriteToFile(EINVOIC_DTM('454', SalesH."Posting Date"));
        WriteToFile(EINVOIC_DTM('35', SalesH."Date livraison prévue"));
        WriteToFile(EINVOIC_DTM('137', Today));
        WriteToFile(EINVOIC_RFF_AAK());
        WriteToFile(EINVOIC_DTM('171', SalesH."Posting Date"));
        WriteToFile(EINVOIC_RFF_ON());
        WriteToFile(EINVOIC_RFF_ACE());
        WriteToFile(EINVOIC_DTM('171', SalesH."Order Date"));
        WriteToFile(EINVOIC_NAD_IV());
        WriteToFile(EINVOIC_RFF_VA());
        Cust.Get(SalesH."Bill-to Customer No.");
        WriteToFile(EINVOIC_NAD_BY());
        WriteToFile(EINVOIC_RFF_VA());
        WriteToFile(EINVOIC_NAD_SU());
        EINVOIC_BANKs();
        WriteToFile(EINVOIC_RFF_VA_SU());
        WriteToFile(EINVOIC_NAD_DP());
        WriteToFile(EINVOIC_CUX);
        WriteToFile(EINVOIC_PAT3);
        WriteToFile(EINVOIC_DTM('140', SalesH."Due Date"));

        TotalQty := 0;
        NbreExp := 0;
        SalesL.Reset;
        SalesL.SetRange("Document No.", SalesH."No.");
        SalesL.SetRange(Type, SalesL.Type::Item);  //??
        if SalesL.FindSet then
            repeat
                NbreExp += 1;
                Items.Get(SalesL."No.");
                WriteToFile(EINVOIC_LIN());
                WriteToFile(EINVOIC_PIA_SA());
                WriteToFile(EINVOIC_IMD());
                WriteToFile(EINVOIC_QTY('46', SalesL.Quantity));
                WriteToFile(EINVOIC_QTY('47', SalesL.Quantity));
                WriteToFile(EINVOIC_MOA203());
                WriteToFile(EINVOIC_PRI_AAA());
                WriteToFile(EINVOIC_PRI_AAB());
                WriteToFile(EINVOIC_TAX(SalesL."VAT %"));
                WriteToFile(EINVOIC_MOA125());

                if (SalesL."Line Discount %" > 0) then begin
                    WriteToFile(EINVOIC_ALC());
                    WriteToFile(EINVOIC_PCD());
                end;
            until SalesL.Next = 0;
        WriteToFile(EINVOIC_UNS());
        SalesH.CalcFields(Amount, "Amount Including VAT");
        WriteToFile(EINVOIC_MOA('77', SalesH."Amount Including VAT"));
        WriteToFile(EINVOIC_MOA('79', SalesH.Amount));
        WriteToFile(EINVOIC_MOA('150', SalesH."Amount Including VAT" - SalesH.Amount));

        CUAbsysTools_l.GetSalesInvoiceVAT(SalesH,
          DecVATAmount_g,
          DecVATBaseAmount_g,
          DecVATDiscountAmount_g,
          DecTotalAmountInclVAT_g,
          RecVATAmountLine_g);
        /////////
        for i := 1 to 4 do begin
            if RecVATAmountLine_g[i]."VAT Identifier" <> '' then begin
                WriteToFile(EINVOIC_TAX(RecVATAmountLine_g[i]."VAT %"));
                WriteToFile(EINVOIC_MOA('124', RecVATAmountLine_g[i]."VAT Amount"));
                WriteToFile(EINVOIC_MOA('04G', RecVATAmountLine_g[i]."VAT Base"));
            end;
        end;
        /////
        WriteToFile(UNT());
        WriteToFile(UNZ());


        xFile.Close();
    end;

    [Scope('OnPrem')]
    procedure DESADV(_ShptH: Record "Sales Shipment Header"; FileName: Text[250])
    var
        Adr: Record "Ship-to Address";
        TotalKg: Decimal;
        TotalColis: Integer;
        nDetail: Integer;
        codes: Record "Code";
    begin
        NbreSegments := 0;
        NbreExp := 0;
        ShptH.Get(_ShptH."No.");
        Cust.Get(ShptH."Sell-to Customer No.");

        Clear(xFile);
        xFile.TextMode := true;
        xFile.WriteMode := true;
        xFile.Create(FileName);

        CRLF := ' ';
        CRLF[1] := 13;
        CRLF[2] := 10;
        GLN := '5425005730001';

        TypeFichier := 'DESADV';

        //WriteToFile(UNA());
        WriteToFile(UNB(Cust."GLN Destinataire"));
        WriteToFile(UNH());
        WriteToFile(DESADV_BGM(ShptH."No."));
        WriteToFile(DESADV_DTM('137', Today));
        //WriteToFile(DESADV_DTM('2',TODAY));
        WriteToFile(DESADV_DTM('17', _ShptH."Date livraison prévue"));
        WriteToFile(DESADV_DTM('11', Today));
        WriteToFile(DESADV_RFF_ON());
        WriteToFile(DESADV_RFF_VN());
        WriteToFile(DESADV_NAD_BY());
        WriteToFile(DESADV_NAD_SU());
        WriteToFile(DESADV_NAD_DP());
        WriteToFile(DESADV_NAD_UD());
        Adr.Get(ShptH."Sell-to Customer No.", ShptH."Ship-to Code");
        if Adr."GLN UC" <> '' then
            WriteToFile(DESADV_NAD_UC());

        TotalQty := 0;

        Pal.Reset;
        Pal.SetRange("Outbound Document No.", ShptH."No.");
        //To do verif

        if ((Cust."Version DESADV" = Cust."Version DESADV"::"01B") or (Cust."Version DESADV" = Cust."Version DESADV"::"96A")) then begin
            WriteToFile(DESADV_CPS(1));
            WriteToFile(DESADV_PAC(Pal.Count));
            if Pal.FindSet then
                repeat
                    ItemLedg.Reset;
                    ItemLedg.SetRange("Entry Type", ItemLedg."Entry Type"::Sale);
                    ItemLedg.SetRange("Document No.", ShptH."No.");
                    ItemLedg.SetRange("Item No.", Pal."Item No.");
                    ItemLedg.SetRange("Lot No.", Pal."Lot No.");
                    ItemLedg.FindFirst();
                    Items.Get(ItemLedg."Item No.");
                    NbreExp += 1;
                    WriteToFile(DESADV_CPSDetail(NbreExp + 1));
                    WriteToFile(DESADV_PACDetail(1));
                    WriteToFile(DESADV_MEA);
                    WriteToFile(DESADV_PCI33E());
                    WriteToFile(DESADV_BJ(GetSSCCFromPal(Pal."SSCC No.")));
                    WriteToFile(DESADV_PCI41G);

                    if (Cust."Version DESADV" = Cust."Version DESADV"::"01B") then begin
                        WriteToFile(DESADV_GINDA);
                        WriteToFile(DESADV_LIN());
                        WriteToFile(DESADV_PIA_SA());
                        WriteToFile(DESADV_Lot());
                        WriteToFile(DESADV_QTY());
                        WriteToFile(DESADV_DLC());
                    end
                    else begin
                        WriteToFile(DESADV_PCI36E());
                        WriteToFile(DESADV_Lot());
                        WriteToFile(DESADV_LIN());
                        WriteToFile(DESADV_PIA_SA());
                        WriteToFile(DESADV_QTY());
                        WriteToFile(DESADV_DLC());


                    end;
                until Pal.Next = 0;
        end;
        if (Cust."Version DESADV" = Cust."Version DESADV"::"96ARegroupe") then begin
            WriteToFile(DESADV_CPS(1));
            WriteToFile(DESADV_PAC(1));
            TotalColis := 0;
            TotalKg := 0;
            if Pal.FindSet then
                repeat
                    TotalColis += Pal."Nbre bacs reception";
                    TotalKg += Pal."Quantite reception";
                until Pal.Next = 0;
            WriteToFile(DESADV_MEAq(TotalKg)); //Total livraison
                                               //Palette 1 ! et unique !
            WriteToFile(DESADV_CPSDetail(2));
            WriteToFile(DESADV_PACCarton(TotalColis));
            WriteToFile(DESADV_MEAq(TotalKg));
            if Pal.FindFirst then;
            WriteToFile(DESADV_PCI33E());
            WriteToFile(DESADV_BJ(GetSSCCFromPal(Pal."SSCC No.")));

            //detail des articles sur la palettes
            nDetail := 0;
            if Pal.FindSet then
                repeat

                    ItemLedg.Reset;
                    ItemLedg.SetRange("Entry Type", ItemLedg."Entry Type"::Sale);
                    ItemLedg.SetRange("Document No.", ShptH."No.");
                    ItemLedg.SetRange("Item No.", Pal."Item No.");
                    ItemLedg.SetRange("Lot No.", Pal."Lot No.");
                    ItemLedg.FindFirst();
                    Items.Get(ItemLedg."Item No.");
                    nDetail += 1;
                    NbreExp += 1;
                    WriteToFile(DESADV_CPSDetailArticle(nDetail + 2, 2));
                    WriteToFile(DESADV_PACCarton(Pal."Nbre bacs reception"));
                    WriteToFile(DESADV_MEAq(Pal."Quantite reception"));
                    codes.Reset;
                    codes.Get(27, 8001305, Items."Criteria 5");
                    WriteToFile(DESADV_QTYByUnit(codes.Poids / codes."Poids primaire"));
                    WriteToFile(DESADV_PCI34E());
                    WriteToFile(DESADV_GINEU());
                    WriteToFile(DESADV_PCI36E());
                    WriteToFile(DESADV_Lot());
                    WriteToFile(DESADV_PCI38E());
                    WriteToFile(DESADV_DLC36());
                    WriteToFile(DESADV_LIN());
                    WriteToFile(DESADV_QTYPCE(Pal."Nbre bacs reception" * codes.Poids / codes."Poids primaire"));
                    WriteToFile(DESADV_QTY());
                until Pal.Next = 0;
        end;



        WriteToFile(DESADV_CNT());
        WriteToFile(UNT());
        WriteToFile(UNZ());
        //UNT

        xFile.Close();
    end;

    [Scope('OnPrem')]
    procedure IFCSUMFromshpt(IDBordereau: Code[30]; Filename: Text[250]; GLNDestinataire: Code[20]; GLNFournisseur: Code[20])
    var
        PoidsTotal: Decimal;
    begin

        NbreSegments := 0;
        Clear(xFile);
        xFile.TextMode := true;
        xFile.WriteMode := true;
        xFile.Create(Filename);

        CRLF := ' ';
        CRLF[1] := 13;
        CRLF[2] := 10;
        GLN := '5425005730001';

        TypeFichier := 'IFCSUM';

        //WriteToFile(UNA());
        WriteToFile(UNB(GLNDestinataire));
        WriteToFile(UNH());
        WriteToFile(IFCSUM_BGM(IDBordereau));
        WriteToFile(IFCSUM_DTM());

        PoidsTotal := 0;
        ShptH.Reset;
        ShptH.SetRange("Ref Envoi", IDBordereau);
        if ShptH.FindSet then
            repeat
                Pal.Reset;
                Pal.SetRange("Outbound Document No.", ShptH."No.");
                Pal.SetRange(Type, Pal.Type::Expedition);
                Pal.SetFilter("Quai reception", '<>''''');
                if Pal.FindSet then
                    repeat
                        PoidsTotal += Pal."Quantite reception";
                    until Pal.Next = 0;
            until ShptH.Next = 0;

        WriteToFile(IFCSUM_CNT(PoidsTotal));
        WriteToFile(IFCSUM_TDT);
        WriteToFile(IFCSUM_LOC);
        WriteToFile(IFCSUM_NAD_CZ(GLNDestinataire));
        WriteToFile(IFCSUM_NAD_CA(GLNDestinataire));


        NbreExp := 0;
        ShptH.Reset;
        ShptH.SetRange("Ref Envoi", IDBordereau);
        if ShptH.FindSet then
            repeat
                NbreExp += 1;
                WriteToFile(IFCSUM_CNI(NbreExp, ShptH."Order No."));
                WriteToFile(IFCSUM_DTMExp(ShptH."Date livraison prévue"));
                WriteToFile(IFCSUM_NAD_DP(ShptH));

                Pal.Reset;
                Pal.SetRange("Outbound Document No.", ShptH."No.");
                Pal.SetRange(Type, Pal.Type::Expedition);
                Pal.SetFilter("Quai reception", '<>''''');
                if Pal.FindSet then
                    repeat
                        WriteToFile(IFCSUM_GID(Pal."Nbre bacs reception"));
                        WriteToFile(IFCSUM_MEA(Pal."Quantite reception"));
                        WriteToFile(IFCSUM_PCI());
                        WriteToFile(IFCSUM_GIN(GetSSCCFromPal(Pal."SSCC No.")));
                    until Pal.Next = 0;
            until ShptH.Next = 0;

        WriteToFile(UNT());
        WriteToFile(UNZ());

        xFile.Close();
    end;

    [Scope('OnPrem')]
    procedure WriteToFile(Txt: Text[1024])
    begin
        //MESSAGE(Txt);
        if (Txt = '') then
            exit;
        NbreSegments += 1;
        if (CopyStr(Txt, StrLen(Txt), 1) = '''') then
            Txt := Utils.Replace(CopyStr(Txt, 1, StrLen(Txt) - 1), '''', '?''') + ''''
        else
            Txt := Utils.Replace(Txt, '''', '?''');
        Txt := Utils.DelNonAN(Txt);
        if (Txt <> '') then
            xFile.Write(Txt);
    end;

    [Scope('OnPrem')]
    procedure GetSSCCFromPal(SSCC: Text[30]): Text[30]
    var
        tmp: Text[30];
    begin
        tmp := CopyStr(SSCC, 5, 1) + '542500573' + CopyStr(SSCC, 6, 7);
        exit(tmp + Format(GetCheck(tmp)));
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
    procedure UNA(): Text[1024]
    begin
        NbreSegments += -1;
        exit('UNA:+.?''');
    end;

    [Scope('OnPrem')]
    procedure UNB(Destinataire: Text[30]): Text[1024]
    begin
        NbreSegments += -1;
        Randomize;
        UniqueID := Format(Random(100000000));

        exit('UNB+UNOC:3+' + GLN + ':14+' + Destinataire + ':14+' + Format(Today, 0, '<Year,2><Month,2><Day,2>') + ':'
        + Format(Time, 0, '<Hours24,2><Minutes,2>') + '+' + UniqueID + '++BELU_V3''');
    end;

    [Scope('OnPrem')]
    procedure UNH(): Text[1024]
    begin
        if Cust."Version DESADV" = Cust."Version DESADV"::"01B" then
            exit('UNH+' + UniqueID + '01+' + TypeFichier + ':D:01B:UN:EAN007''');
        if Cust."Version DESADV" = Cust."Version DESADV"::"96A" then
            exit('UNH+' + UniqueID + '01+' + TypeFichier + ':D:96A:UN:EAN005''');
        if Cust."Version DESADV" = Cust."Version DESADV"::"96ARegroupe" then
            exit('UNH+' + UniqueID + '01+' + TypeFichier + ':D:96A:UN:EAN005''');
    end;

    [Scope('OnPrem')]
    procedure IFCSUM_BGM(Bordereau: Text[30]): Text[1024]
    begin
        exit('BGM+60+' + Bordereau + '+9''');
    end;

    [Scope('OnPrem')]
    procedure IFCSUM_DTM(): Text[1024]
    begin
        exit('DTM+137:' + Format(Today, 0, '<Year4,4><Month,2><Day,2>') + Format(Time, 0, '<Hours24,2><Minutes,2>') + ':203''');
    end;

    [Scope('OnPrem')]
    procedure IFCSUM_CNT(PoidsTotal: Decimal): Text[1024]
    begin
        exit('CNT+7:' + Format(PoidsTotal, 0, '<Integer><Decimals><Comma,.>') + ':KGM''');
    end;

    [Scope('OnPrem')]
    procedure IFCSUM_TDT(): Text[1024]
    begin
        exit('TDT+20++30+31''');
    end;

    [Scope('OnPrem')]
    procedure IFCSUM_LOC(): Text[1024]
    begin
        exit('LOC+5+' + GLN + '::9''');
    end;

    [Scope('OnPrem')]
    procedure IFCSUM_NAD_CA(Dest: Text[30]): Text[1024]
    begin
        exit('NAD+CA+' + Dest + '::9''');
    end;

    [Scope('OnPrem')]
    procedure IFCSUM_NAD_CZ(Dest: Text[30]): Text[1024]
    begin
        exit('NAD+CZ+' + GLN + '::9''');
    end;

    [Scope('OnPrem')]
    procedure IFCSUM_CNI(Ordre: Integer; Ref: Code[20]): Text[1024]
    begin
        exit('CNI+' + Format(Ordre) + '+' + Ref + '''');
    end;

    [Scope('OnPrem')]
    procedure IFCSUM_DTMExp(DtLivraison: Date): Text[1024]
    begin
        exit('DTM+2:' + Format(DtLivraison, 0, '<Year4,4><Month,2><Day,2>') + ':102''');
    end;

    [Scope('OnPrem')]
    procedure IFCSUM_NAD_DP(ShptH: Record "Sales Shipment Header"): Text[1024]
    begin
        exit('NAD+DP+++' + ShptH."Ship-to Name" + '+' + ShptH."Ship-to Address" + ':' + ShptH."Ship-to Address 2" + '+' + ShptH."Ship-to City" + '++'
        + ShptH."Ship-to Post Code" + '+' + ShptH."Ship-to Country/Region Code" + '''');
    end;

    [Scope('OnPrem')]
    procedure IFCSUM_GID(NbreColis: Integer): Text[1024]
    begin
        exit('GID+1+1:201::9+' + Format(NbreColis) + ':CT::9''');
    end;

    [Scope('OnPrem')]
    procedure IFCSUM_MEA(Poids: Decimal): Text[1024]
    begin
        exit('MEA+AAE+AAD+KGM:' + Format(Poids, 0, '<Integer><Decimals><Comma,.>') + '''');
    end;

    [Scope('OnPrem')]
    procedure IFCSUM_PCI(): Text[1024]
    begin
        exit('PCI+33E''');
    end;

    [Scope('OnPrem')]
    procedure IFCSUM_GIN(SSCC: Text[30]): Text[1024]
    begin
        exit('GIN+BJ+' + SSCC + '''');
    end;

    [Scope('OnPrem')]
    procedure UNT(): Text[1024]
    begin
        exit('UNT+' + Format(NbreSegments + 1) + '+' + UniqueID + '01''');
    end;

    [Scope('OnPrem')]
    procedure UNZ(): Text[1024]
    begin
        exit('UNZ+1+' + UniqueID + '''');
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
    procedure DESADV_BGM(Bordereau: Text[30]): Text[1024]
    begin
        exit('BGM+351+' + Bordereau + '+9''');
    end;

    [Scope('OnPrem')]
    procedure DESADV_DTM(Periode: Code[3]; Dt: Date): Text[1024]
    begin
        exit('DTM+' + Periode + ':' + Format(Dt, 0, '<Year4,4><Month,2><Day,2>') + ':102''');
    end;

    [Scope('OnPrem')]
    procedure DESADV_RFF_ON(): Text[1024]
    begin
        exit('RFF+ON:' + ShptH."External Document No." + '''');
    end;

    [Scope('OnPrem')]
    procedure DESADV_RFF_VN(): Text[1024]
    begin
        exit('RFF+VN:' + ShptH."Order No." + '''');
    end;

    [Scope('OnPrem')]
    procedure DESADV_RFF_DQ(): Text[1024]
    begin
        exit('RFF+DQ:' + ShptH."No." + '''');
    end;

    [Scope('OnPrem')]
    procedure DESADV_NAD_BY(): Text[1024]
    var
        Cust: Record Customer;
    begin
        Cust.Get(ShptH."Sell-to Customer No.");
        IF Cust."GLN EC" <> '' THEN
            EXIT('NAD+BY+' + Cust."GLN EC" + '::9''')
        ELSE
            EXIT('NAD+BY+' + Cust.GLN + '::9''');

    end;

    [Scope('OnPrem')]
    procedure DESADV_NAD_SU(): Text[1024]
    begin
        exit('NAD+SU+' + GLN + '::9''');
    end;

    [Scope('OnPrem')]
    procedure DESADV_NAD_DP(): Text[1024]
    var
        Adr: Record "Ship-to Address";
    begin
        Adr.Get(ShptH."Sell-to Customer No.", ShptH."Ship-to Code");
        exit('NAD+DP+' + Adr.GLN + '::9''');
    end;

    [Scope('OnPrem')]
    procedure DESADV_NAD_UC(): Text[1024]
    var
        Adr: Record "Ship-to Address";
    begin
        Adr.Get(ShptH."Sell-to Customer No.", ShptH."Ship-to Code");
        if Adr."GLN UC" = '' then
            exit('')
        else
            exit('NAD+UC+' + Adr."GLN UC" + '::9''');
    end;

    [Scope('OnPrem')]
    procedure DESADV_NAD_UD(): Text[1024]
    var
        Adr: Record "Ship-to Address";
    begin
        Cust.Get(ShptH."Sell-to Customer No.");
        exit('NAD+UD+' + Cust."GLN EC" + '::9''');
    end;

    [Scope('OnPrem')]
    procedure DESADV_CPS(n: Integer): Text[1024]
    var
        Adr: Record "Ship-to Address";
    begin
        exit('CPS+' + Format(n) + '''');
    end;

    [Scope('OnPrem')]
    procedure DESADV_CPSDetail(n: Integer): Text[1024]
    var
        Adr: Record "Ship-to Address";
    begin
        exit('CPS+' + Format(n) + '+1''');
    end;

    [Scope('OnPrem')]
    procedure DESADV_PAC(n: Integer): Text[1024]
    var
        Adr: Record "Ship-to Address";
    begin
        exit('PAC+' + Format(n) + '++201::9''');
    end;

    [Scope('OnPrem')]
    procedure DESADV_PCI33E(): Text[1024]
    var
        Adr: Record "Ship-to Address";
    begin
        exit('PCI+33E''');
    end;

    [Scope('OnPrem')]
    procedure DESADV_PCI36E(): Text[1024]
    var
        Adr: Record "Ship-to Address";
    begin
        exit('PCI+36E''');
    end;

    [Scope('OnPrem')]
    procedure DESADV_PCI41G(): Text[1024]
    var
        Adr: Record "Ship-to Address";
    begin
        exit('PCI+41G''');
    end;

    [Scope('OnPrem')]
    procedure DESADV_GINDA(): Text[1024]
    var
        Adr: Record "Ship-to Address";
    begin
        if Cust."Version DESADV" = Cust."Version DESADV"::"01B" then
            exit('GIN+DA+0662510000767''');
    end;

    [Scope('OnPrem')]
    procedure DESADV_BJ(sscc: Text): Text[1024]
    var
        Adr: Record "Ship-to Address";
    begin
        exit('GIN+BJ+' + sscc + '''');
    end;

    [Scope('OnPrem')]
    procedure DESADV_PACDetail(n: Integer): Text[1024]
    var
        Adr: Record "Ship-to Address";
    begin
        exit('PAC+' + Format(n) + '++201''');
    end;

    [Scope('OnPrem')]
    procedure DESADV_MEA(): Text[1024]
    var
        Adr: Record "Ship-to Address";
    begin
        TotalQty += Abs(ItemLedg.Quantity);
        exit('MEA+PD+AAC+KGM:' + Format(Abs(ItemLedg.Quantity)) + '''');
    end;

    [Scope('OnPrem')]
    procedure DESADV_LIN(): Text[1024]
    var
        Adr: Record "Ship-to Address";
    begin
        exit('LIN+' + Format(NbreExp) + '++' + Items."EAN13 Code" + ':EN' + '''');
    end;

    [Scope('OnPrem')]
    procedure DESADV_QTY(): Text[1024]
    var
        Adr: Record "Ship-to Address";
    begin
        TotalQty += Abs(ItemLedg.Quantity);
        exit('QTY+12:' + Format(Abs(ItemLedg.Quantity)) + ':KGM''');
    end;

    [Scope('OnPrem')]
    procedure DESADV_PIA_SA(): Text[1024]
    begin
        exit('PIA+1+' + ItemLedg."Item No." + ':SA''');
    end;

    [Scope('OnPrem')]
    procedure DESADV_Lot(): Text[1024]
    begin
        if Cust."Version DESADV" = Cust."Version DESADV"::"01B" then
            exit('PIA+1+' + ItemLedg."Lot No." + ':NB''');
        if (Cust."Version DESADV" = Cust."Version DESADV"::"96A") or (Cust."Version DESADV" = Cust."Version DESADV"::"96ARegroupe") then
            exit('GIN+BX+' + ItemLedg."Lot No." + '''');
        //EXIT('PCI+41'''+CRLF+'GIN+BX+'+ItemLedg."Lot No."+'''');
    end;

    [Scope('OnPrem')]
    procedure DESADV_DLC(): Text[1024]
    begin
        exit('DTM+361:' + Format(ItemLedg."Warranty Date", 0, '<Year4,4><Month,2><Day,2>') + ':102''');
        //EXIT('PCI+44'''+CRLF+'DTM+36:'+FORMAT(ItemLedg."Warranty Date",0,'<Year4,4><Month,2><Day,2>')+':102''');
    end;

    [Scope('OnPrem')]
    procedure DESADV_CNT(): Text[1024]
    begin
        exit('CNT+2:' + Format(NbreSegments + 2) + '''');
        //EXIT('PCI+44'''+CRLF+'DTM+36:'+FORMAT(ItemLedg."Warranty Date",0,'<Year4,4><Month,2><Day,2>')+':102''');
    end;

    [Scope('OnPrem')]
    procedure EINVOIC_UNB(Destinataire: Text[30]): Text[1024]
    begin
        NbreSegments += -1;
        Randomize;
        UniqueID := Format(Random(100000000));

        exit('UNB+UNOC:3+' + GLN + ':14+' + Destinataire + ':14+' + Format(Today, 0, '<Year,2><Month,2><Day,2>') + ':'
        + Format(Time, 0, '<Hours24,2><Minutes,2>') + '+' + UniqueID + '++INVMAT_V3''');
    end;

    [Scope('OnPrem')]
    procedure EINVOIC_UNH(): Text[1024]
    begin
        exit('UNH+' + UniqueID + '01+' + TypeFichier + ':D:01B:UN:EAN011''');
    end;

    [Scope('OnPrem')]
    procedure EINVOIC_BGM(Bordereau: Text[30]): Text[1024]
    begin
        exit('BGM+380+' + Bordereau + '+9''');
    end;

    [Scope('OnPrem')]
    procedure EINVOIC_DTM(Periode: Code[3]; Dt: Date): Text[1024]
    begin
        exit('DTM+' + Periode + ':' + Format(Dt, 0, '<Year4,4><Month,2><Day,2>') + ':102''');
    end;

    [Scope('OnPrem')]
    procedure EINVOIC_RFF_AAK(): Text[1024]
    begin
        SalesH.CalcFields("Shipment No.");
        exit('RFF+AAK:' + SalesH."Shipment No." + '''');
    end;

    [Scope('OnPrem')]
    procedure EINVOIC_RFF_ON(): Text[1024]
    begin
        exit('RFF+ON:' + SalesH."External Document No." + '''');
    end;

    [Scope('OnPrem')]
    procedure EINVOIC_RFF_DQ(): Text[1024]
    begin
        exit('RFF+DQ:' + SalesH."Shipment No." + '''');
    end;

    [Scope('OnPrem')]
    procedure EINVOIC_RFF_ACE(): Text[1024]
    begin
        exit('RFF+ACE:' + SalesH."Order No." + '''');
    end;

    [Scope('OnPrem')]
    procedure EINVOIC_NAD_IV(): Text[1024]
    begin
        exit('NAD+IV+' + Cust."GLN Destinataire" + '::9++' + Cust.Name + '+' + Cust.Address + '+' + Cust.City + '++' + Cust."Post Code" + '+' + Cust."Country/Region Code" + '''');
    end;

    [Scope('OnPrem')]
    procedure EINVOIC_RFF_VA(): Text[1024]
    begin
        exit('RFF+VA:' + Cust."VAT Registration No." + '''');
    end;

    [Scope('OnPrem')]
    procedure EINVOIC_NAD_BY(): Text[1024]
    begin
        exit('NAD+BY+' + Cust."GLN Destinataire" + '::9++' + Cust.Name + '+' + Cust.Address + '+' + Cust.City + '++' + Cust."Post Code" + '+' + Cust."Country/Region Code" + '''');
    end;

    [Scope('OnPrem')]
    procedure EINVOIC_NAD_SU(): Text[1024]
    var
        Cust: Record Customer;
    begin

        exit('NAD+SU+' + GLN + '::9++EUROPACUISSON SA+RUE TERRE A BRIQUES,14+MARQUAIN++7522+BE''');
    end;

    local procedure EINVOIC_BANKs()
    var
        CodePays_l: Code[10];
        RecCountry_g: Record "Country/Region";
        RecBankAccount1_g: Record "Bank Account";
    begin
        if SalesH."Bill-to Country/Region Code" = '' then
            CodePays_l := 'BE'
        else
            CodePays_l := SalesH."Bill-to Country/Region Code";

        if SalesH."Currency Code" = 'EUR' then
            SalesH."Currency Code" := '';

        if RecCountry_g.Get(CodePays_l) then begin
            //-- Banque 1
            if RecCountry_g."Bank Code 1" <> '' then begin
                RecBankAccount1_g.Get(RecCountry_g."Bank Code 1");
                if SalesH."Currency Code" = RecBankAccount1_g."Currency Code" then begin
                    WriteToFile(EINVOIC_FII(RecBankAccount1_g.IBAN, RecBankAccount1_g."SWIFT Code"));
                end;
            end;
            //-- Banque 2
            if RecCountry_g."Bank Code 2" <> '' then begin
                RecBankAccount1_g.Get(RecCountry_g."Bank Code 2");
                if SalesH."Currency Code" = RecBankAccount1_g."Currency Code" then begin
                    WriteToFile(EINVOIC_FII(RecBankAccount1_g.IBAN, RecBankAccount1_g."SWIFT Code"));
                end;
            end;
            //-- Banque 3
            if RecCountry_g."Bank Code 3" <> '' then begin
                RecBankAccount1_g.Get(RecCountry_g."Bank Code 3");
                if SalesH."Currency Code" = RecBankAccount1_g."Currency Code" then begin
                    WriteToFile(EINVOIC_FII(RecBankAccount1_g.IBAN, RecBankAccount1_g."SWIFT Code"));
                end;
            end;
            //-- Banque 4
            if RecCountry_g."Bank Code 4" <> '' then begin
                RecBankAccount1_g.Get(RecCountry_g."Bank Code 4");
                if SalesH."Currency Code" = RecBankAccount1_g."Currency Code" then begin
                    WriteToFile(EINVOIC_FII(RecBankAccount1_g.IBAN, RecBankAccount1_g."SWIFT Code"));
                end;
            end;
        end;
    end;

    [Scope('OnPrem')]
    procedure EINVOIC_FII(IBAN: Text; BIC: Text): Text[1024]
    var
        Cust: Record Customer;
    begin

        exit('FII+RB+' + IBAN + '+:::' + BIC + ':25:5''');
    end;

    [Scope('OnPrem')]
    procedure EINVOIC_RFF_VA_SU(): Text[1024]
    begin
        exit('RFF+VA:BE0441357423''');
    end;

    [Scope('OnPrem')]
    procedure EINVOIC_NAD_DP(): Text[1024]
    var
        Cust: Record Customer;
    begin
        exit('NAD+DP+' + GLN + '::9++EUROPACUISSON SA+RUE TERRE A BRIQUES,14+MARQUAIN++7522+BE''');
    end;

    [Scope('OnPrem')]
    procedure EINVOIC_CUX(): Text[1024]
    begin
        if SalesH."Currency Code" <> '' then
            exit('CUX+2:' + SalesH."Currency Code" + ':4''')
        else
            exit('CUX+2:EUR:4''');
    end;

    [Scope('OnPrem')]
    procedure EINVOIC_LIN(): Text[1024]
    var
        Adr: Record "Ship-to Address";
    begin
        exit('LIN+' + Format(NbreExp) + '++' + Items."EAN13 Code" + ':SRV' + '''');
    end;

    [Scope('OnPrem')]
    procedure EINVOIC_IMD(): Text[1024]
    var
        Adr: Record "Ship-to Address";
    begin
        exit('IMD+F++IN::9:' + Items.Description + '::FR''');
    end;

    [Scope('OnPrem')]
    procedure EINVOIC_QTY("Code": Code[10]; Qty: Decimal): Text[1024]
    var
        Adr: Record "Ship-to Address";
    begin
        exit('QTY+' + Code + ':' + Utils.DecimalString(Qty) + '''');
    end;

    [Scope('OnPrem')]
    procedure EINVOIC_MOA203(): Text[1024]
    var
        Adr: Record "Ship-to Address";
    begin
        //EXIT('MOA+203:'+Utils.DecimalString(SalesL."Line Amount")+'''');
        exit('MOA+203:' + Utils.DecimalString((Round(SalesL."Unit Price" - SalesL."Line Discount Amount" / SalesL."Quantity (Base)", 0.0001)) * SalesL."Quantity (Base)") + '''');
    end;

    local procedure EINVOIC_PRI_AAA(): Text
    begin
        exit('PRI+AAA:' + Utils.DecimalString(SalesL."Unit Price") + '''');
    end;

    local procedure EINVOIC_PRI_AAB(): Text
    begin
        exit('PRI+AAB:' + Utils.DecimalString(Round(SalesL."Unit Price" - SalesL."Line Discount Amount" / SalesL."Quantity (Base)", 0.0001)) + '''');
    end;

    local procedure EINVOIC_TAX(Value: Decimal): Text
    begin
        exit('TAX+7+VAT+++:::' + Utils.DecimalString(Value) + '''');
    end;

    [Scope('OnPrem')]
    procedure EINVOIC_MOA125(): Text[1024]
    var
        Adr: Record "Ship-to Address";
    begin

        //EXIT('MOA+125:'+Utils.DecimalString(SalesL."Line Amount")+'''');
        exit('MOA+125:' + Utils.DecimalString((Round(SalesL."Unit Price" - SalesL."Line Discount Amount" / SalesL."Quantity (Base)", 0.0001)) * SalesL."Quantity (Base)") + '''');
    end;

    [Scope('OnPrem')]
    procedure EINVOIC_UNS(): Text[1024]
    var
        Adr: Record "Ship-to Address";
    begin
        exit('UNS+S''');
    end;

    [Scope('OnPrem')]
    procedure EINVOIC_MOA("Code": Code[10]; Value: Decimal): Text[1024]
    var
        Adr: Record "Ship-to Address";
    begin
        exit('MOA+' + Code + ':' + Utils.DecimalString(Value) + '''');
    end;

    [Scope('OnPrem')]
    procedure EINVOIC_PIA_SA(): Text[1024]
    begin
        exit('PIA+1+' + Items."No." + ':SA''');
    end;

    [Scope('OnPrem')]
    procedure EINVOIC_MEA(): Text[1024]
    var
        Adr: Record "Ship-to Address";
    begin
        TotalQty += Abs(ItemLedg.Quantity);
        exit('MEA+PD+AAC+KGM:' + Format(Abs(SalesL.Quantity)) + '''');
    end;

    [Scope('OnPrem')]
    procedure EINVOIC_ALCPCD(): Text[1024]
    var
        Adr: Record "Ship-to Address";
    begin
        //EXIT('MOA+125:'+Utils.DecimalString(SalesL."Line Amount" - SalesL."Line Discount Amount")+'''');
        exit('ALC+PCD+1:' + Utils.DecimalString(SalesL."Line Discount %") + '''');
    end;

    local procedure EINVOIC_ALC(): Text[1024]
    begin
        exit('ALC+A++++DI::281''');
    end;

    local procedure EINVOIC_PCD(): Text[1024]
    begin
        exit('PCD+1:' + Utils.DecimalString(SalesL."Line Discount %") + '''');
    end;

    [Scope('OnPrem')]
    procedure EINVOIC_PAT3(): Text[1024]
    begin
        if SalesH."Currency Code" <> '' then
            exit('CUX+2:' + SalesH."Currency Code" + ':4''')
        else
            exit('PAT+3''');
    end;

    [Scope('OnPrem')]
    procedure DESADV_PACCarton(n: Integer): Text[1024]
    var
        Adr: Record "Ship-to Address";
    begin
        exit('PAC+' + Format(n) + '++CT::9''');
    end;

    [Scope('OnPrem')]
    procedure DESADV_MEAq(Qty: Integer): Text[1024]
    var
        Adr: Record "Ship-to Address";
    begin
        exit('MEA+PD+AAC+KGM:' + Format(Abs(Qty)) + '''');
    end;

    [Scope('OnPrem')]
    procedure DESADV_CPSDetailArticle(n: Integer; Pal: Integer): Text[1024]
    var
        Adr: Record "Ship-to Address";
    begin
        exit('CPS+' + Format(n) + '+' + Format(Pal) + '''');
    end;

    [Scope('OnPrem')]
    procedure DESADV_PCI34E(): Text[1024]
    var
        Adr: Record "Ship-to Address";
    begin
        exit('PCI+34E''');
    end;

    [Scope('OnPrem')]
    procedure DESADV_GINEU(): Text[1024]
    var
        Adr: Record "Ship-to Address";
    begin
        exit('GIN+EU+' + Items."CB carton" + '''');
    end;

    [Scope('OnPrem')]
    procedure DESADV_PCI38E(): Text[1024]
    var
        Adr: Record "Ship-to Address";
    begin
        exit('PCI+38E''');
    end;

    [Scope('OnPrem')]
    procedure DESADV_DLC36(): Text[1024]
    begin
        exit('DTM+36:' + Format(ItemLedg."Warranty Date", 0, '<Year4,4><Month,2><Day,2>') + ':102''');
        //EXIT('PCI+44'''+CRLF+'DTM+36:'+FORMAT(ItemLedg."Warranty Date",0,'<Year4,4><Month,2><Day,2>')+':102''');
    end;

    [Scope('OnPrem')]
    procedure DESADV_QTYByUnit(q: Decimal): Text[1024]
    var
        Adr: Record "Ship-to Address";
    begin
        exit('QTY+52:' + Format(q) + ':PCE''');
    end;

    [Scope('OnPrem')]
    procedure DESADV_QTYPCE(q: Decimal): Text[1024]
    var
        Adr: Record "Ship-to Address";
    begin
        exit('QTY+52:' + Format(q) + ':PCE''');
    end;
}

