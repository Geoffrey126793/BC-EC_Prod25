codeunit 50022 NAS
{
    SingleInstance = true;
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        RAutomateCalcul: Report "Launch Statistic Scheduler";
        Items: Record Item;
        xml1: XMLport "Bizzmine Items";
        xml2: XMLport "Bizzmine Customers";
        f: File;
        Stream: OutStream;
        cuEInvoice: Codeunit Trigger_einvoice;
    begin
        //Eval0RD();
        //Nettoyage();

        //Reminder();

        case "Parameter String" of
            'DELAIS':
                Cu50021.UpdateDelaiReglement();
            'STADES':
                begin
                    Cu50021.UpdateStade();
                    Cu50048.CheckCreditClientAll();
                end;
            'STATS':
                begin
                    REPORT.Run(8001301, false, false);
                end;
            'STATSMANON1':
                begin
                    RAutomateCalcul.SetCode('MANON1');
                    RAutomateCalcul.UseRequestPage := false;
                    RAutomateCalcul.Run();
                    RAutomateCalcul.SetCode('MANON2');
                    RAutomateCalcul.UseRequestPage := false;
                    RAutomateCalcul.Run();
                end;
            'STATSOF':
                begin
                    statsOF.Run();
                end;
            'ROLLEDCOST':
                begin
                    Clear(RolledCost);
                    //RolledCost.SetMatriceDetail(TRUE);
                    Items.Reset;
                    //    Items.SETFILTER("No.",'1*');
                    RolledCost.SetTableView(Items);
                    RolledCost.SaveAsPdf('\\srvnavision\NavisionTemp\HistoCouts\Histo_'
                    + Format(Date2DMY(Today, 3)) + Format(Date2DMY(Today, 2)) + Format(Date2DMY(Today, 1)) + '.pdf');
                end;
            'STDCOST':
                begin
                    StdCost.Run();
                end;
            'NETTOYAGE':
                begin
                    Nettoyage();
                    Eval0RD();

                end;
            'CONTRALOAD':
                begin
                    EDI.Contraload(CalcDate('<-1D>', Today));

                end;
            'REORDERPOINT':
                begin
                    CUItems.MinReorder();
                    CUItems.AlerteStockOF();
                    CUItems."Cmd Retard"();
                    CUItems.AlerteStockCmd();
                    CUItems.ProdASuivre();
                end;
            'ALERTEDLC':
                begin
                    CUItems.AlerteDLC();
                end;
            'UNBLOCKLOTS':
                begin
                    UnBlockLots();
                end;
            'DLC':
                begin
                    CUProd.BlockDLC();
                end;
            'BIZZMINE':
                begin
                    //xml1.EXPORT();
                    //xml2.EXPORT();
                    f.Create('\\srvnavision.europacuisson.local\NavisionTemp\Bizzmine\Items.csv');
                    f.CreateOutStream(Stream);
                    XMLPORT.Export(50001, Stream);
                    Clear(f);
                    Clear(Stream);
                    f.Create('\\srvnavision.europacuisson.local\NavisionTemp\Bizzmine\Customers.csv');
                    f.CreateOutStream(Stream);
                    XMLPORT.Export(50002, Stream);
                end;
            'CHECKPEPPOL':
                begin
                    cuEInvoice.CheckInbox();
                end;
            'UPDPEPPOL':
                begin
                    cuEInvoice.GetPeppolList;
                    cuEInvoice.CheckAllCust();
                end;
            'REMINDER':
                begin
                    Reminder();

                end;

        end;
    end;

    var
        Company: Record "Company Information";
        Cu50021: Codeunit "Periodic Update";
        RUpdateStats: Report "Process aggregate";
        statsOF: Codeunit "Stats OF";
        RolledCost: Report "Rolled-up Cost Shares";
        StdCost: Codeunit "Update Cost";
        EDI: Codeunit EDI;
        CUItems: Codeunit Integration_Items;
        CUProd: Codeunit "Integration Tft and Prod";
        Cu50048: Codeunit Integration_Sales;

    [Scope('OnPrem')]
    procedure Nettoyage()
    var
        SalesH: Record "Sales Header";
        i: Integer;
        T32: Record "Item Ledger Entry";
        T337: Record "Reservation Entry";
        T27: Record Item;
        T6505: Record "Lot No. Information";
        T27Tmp: Record Item temporary;
        T6505Tmp: Record "Lot No. Information" temporary;
        T83: Record "Item Journal Line";
        NextSeq: Integer;
    begin


        //Destruction chez le client
        T83.Reset;
        T83.SetRange("Journal Template Name", 'ARTICLE');
        T83.SetRange("Journal Batch Name", 'AUTO NETT');
        T83.DeleteAll;

        i := 10000;
        T32.Reset;
        T32.SetRange("Location Code", 'EXT DESTRU');
        T32.SetFilter("Remaining Quantity", '>0');
        if T32.FindSet then begin
            repeat
                T27.Reset;
                T27.Get(T32."Item No.");
                if T27.Blocked then begin
                    T27.Blocked := false;
                    T27.Modify;
                    T27Tmp.Init;
                    T27Tmp.TransferFields(T27, true);
                    if T27Tmp.Insert() then;

                end;
                T6505.Reset;
                T6505.Get(T32."Item No.", '', T32."Lot No.");
                if T6505.Blocked then begin
                    T6505.Blocked := false;
                    T6505.Modify;
                    T6505Tmp.Init;
                    T6505Tmp.TransferFields(T6505, true);
                    if T6505Tmp.Insert() then;
                end;
                T83.Reset;
                T83.Init;
                T83."Journal Template Name" := 'ARTICLE';
                T83."Journal Batch Name" := 'AUTO NETT';
                T83."Line No." := i;
                T83."Document No." := 'EXT DESTRU';
                T83.Validate("Posting Date", Today);
                T83.Validate("Entry Type", T83."Entry Type"::"Negative Adjmt.");
                T83.Validate("Item No.", T32."Item No.");
                T83.Validate("Location Code", 'EXT DESTRU');
                T83.Validate("Quantity (Base)", T32."Remaining Quantity");
                T83.Insert();
                T337.Reset;
                if T337.FindLast then NextSeq := T337."Entry No." + 1;
                T337.Init;
                T337."Entry No." := NextSeq;
                T337.Validate("Item No.", T32."Item No.");
                T337.Validate("Location Code", 'EXT DESTRU');
                T337.Validate("Quantity (Base)", -T32."Remaining Quantity");
                T337.Positive := false;
                T337."Reservation Status" := T337."Reservation Status"::Prospect;
                T337."Source Type" := 83;
                T337."Source Subtype" := 3;
                T337."Source ID" := 'ARTICLE';
                T337."Source Batch Name" := 'AUTO NETT';
                T337."Source Ref. No." := i;
                T337."Lot No." := T32."Lot No.";
                T337."Warranty Date" := T32."Warranty Date";
                T337."Item Tracking" := T337."Item Tracking"::"Lot No.";
                T337.Insert;
                i += 10000;
            until T32.Next = 0;
            CODEUNIT.Run(CODEUNIT::"Item Jnl.-Post", T83);
        end;

        if T27Tmp.FindSet then
            repeat
                T27.Get(T27Tmp."No.");
                T27.Blocked := true;
                T27.Modify;
            until T27Tmp.Next = 0;
        if T6505Tmp.FindSet then
            repeat
                T6505.Get(T6505Tmp."Item No.", T6505Tmp."Variant Code", T6505Tmp."Lot No.");
                T6505.Blocked := true;
                T6505.Modify;
            until T6505Tmp.Next = 0;



        //c-destruct
        T83.Reset;
        T83.SetRange("Journal Template Name", 'ARTICLE');
        T83.SetRange("Journal Batch Name", 'AUTO NETT');
        T83.DeleteAll;

        i := 10000;
        T32.Reset;
        T32.SetRange("Location Code", 'C-DESTRUCT');
        T32.SetFilter("Remaining Quantity", '>0');
        //T32.SETRANGE("Posting Date",010105D,311219D);
        if T32.FindSet then begin
            repeat
                T27.Reset;
                T27.Get(T32."Item No.");
                if T27.Blocked then begin
                    T27.Blocked := false;
                    T27.Modify;
                    T27Tmp.Init;
                    T27Tmp.TransferFields(T27, true);
                    if T27Tmp.Insert() then;

                end;

                T83.Reset;
                T83.Init;
                T83."Journal Template Name" := 'ARTICLE';
                T83."Journal Batch Name" := 'AUTO NETT';
                T83."Line No." := i;
                T83."Document No." := 'C-DESTRUCT';
                T83.Validate("Posting Date", Today);
                T83.Validate("Entry Type", T83."Entry Type"::"Negative Adjmt.");
                T83.Validate("Item No.", T32."Item No.");
                T83.Validate("Location Code", 'C-DESTRUCT');
                T83.Validate("Quantity (Base)", T32."Remaining Quantity");
                T83.Insert();
                if T32."Lot No." <> '' then begin
                    T6505.Reset;
                    T6505.Get(T32."Item No.", '', T32."Lot No.");
                    if T6505.Blocked then begin
                        T6505.Blocked := false;
                        T6505.Modify;
                        T6505Tmp.Init;
                        T6505Tmp.TransferFields(T6505, true);
                        if T6505Tmp.Insert() then;
                    end;
                    T337.Reset;
                    if T337.FindLast then NextSeq := T337."Entry No." + 1;
                    T337.Init;
                    T337."Entry No." := NextSeq;
                    T337.Validate("Item No.", T32."Item No.");
                    T337.Validate("Location Code", 'C-DESTRUCT');
                    T337.Validate("Quantity (Base)", -T32."Remaining Quantity");
                    T337.Positive := false;
                    T337."Reservation Status" := T337."Reservation Status"::Prospect;
                    T337."Source Type" := 83;
                    T337."Source Subtype" := 3;
                    T337."Source ID" := 'ARTICLE';
                    T337."Source Batch Name" := 'AUTO NETT';
                    T337."Source Ref. No." := i;
                    T337."Lot No." := T32."Lot No.";
                    T337."Warranty Date" := T32."Warranty Date";
                    T337."Item Tracking" := T337."Item Tracking"::"Lot No.";
                    T337.Insert;
                end;
                i += 10000;
            until T32.Next = 0;
            CODEUNIT.Run(CODEUNIT::"Item Jnl.-Post", T83);
        end;

        if T27Tmp.FindSet then
            repeat
                T27.Get(T27Tmp."No.");
                T27.Blocked := true;
                T27.Modify;
            until T27Tmp.Next = 0;
        if T6505Tmp.FindSet then
            repeat
                T6505.Get(T6505Tmp."Item No.", T6505Tmp."Variant Code", T6505Tmp."Lot No.");
                T6505.Blocked := true;
                T6505.Modify;
            until T6505Tmp.Next = 0;
    end;

    [Scope('OnPrem')]
    procedure Eval0RD()
    var
        ILE: Record "Item Ledger Entry";
        iC: Integer;
        iCount: Integer;
        ItemJnl: Record "Item Journal Line";
        dlg: Dialog;
        Items: Record Item;
        T27: Record Item;
        T6505: Record "Lot No. Information";
        T27Tmp: Record Item temporary;
        T6505Tmp: Record "Lot No. Information" temporary;
    begin
        ItemJnl.Reset;
        ItemJnl.SetRange("Journal Template Name", 'RÉÉVALUATI');
        ItemJnl.SetRange("Journal Batch Name", 'RD');
        ItemJnl.SetRange("Source Code", 'FREEVAL');
        ItemJnl.SetRange("Document No.", 'RD0');
        ItemJnl.DeleteAll();

        iC := 1;
        ILE.Reset;
        //ILE.SETRANGE("Posting Date",010120D,TODAY);
        ILE.SetFilter(Quantity, '>0');
        ILE.SetRange("Location Code", 'RD');
        ILE.SetFilter("Cost Amount (Actual)", '>0');

        ILE.SetFilter("Item No.", '<>1-DIV-00001');
        //ILE.SETRANGE("Item No.",'1-IQF-00080');

        ILE.SetRange("Completely Invoiced", true);
        dlg.Open('@1@@@@@@@@@@@@@@@@@@@@@@');
        iCount := ILE.Count;
        if ILE.FindSet then begin
            repeat
                Items.Get(ILE."Item No.");
                T27.Reset;
                T27.Get(ILE."Item No.");
                if T27.Blocked then begin
                    T27.Blocked := false;
                    T27.Modify;
                    T27Tmp.Init;
                    T27Tmp.TransferFields(T27, true);
                    if T27Tmp.Insert() then;
                end;
                T6505.Reset;
                if T6505.Get(ILE."Item No.", '', ILE."Lot No.") then
                    if T6505.Blocked then begin
                        T6505.Blocked := false;
                        T6505.Modify;
                        T6505Tmp.Init;
                        T6505Tmp.TransferFields(T6505, true);
                        if T6505Tmp.Insert() then;
                    end;

                ItemJnl.Reset;
                ItemJnl.Init;
                ItemJnl."Journal Template Name" := 'RÉÉVALUATI';
                ItemJnl."Journal Batch Name" := 'RD';
                ItemJnl."Source Code" := 'FREEVAL';
                ItemJnl."Document No." := 'RD0';
                ItemJnl."Line No." := iC;
                ItemJnl."Value Entry Type" := ItemJnl."Value Entry Type"::Revaluation;
                ItemJnl."Entry Type" := ItemJnl."Entry Type"::Sale;
                ItemJnl.Validate("Item No.", ILE."Item No.");
                ItemJnl.Validate("Applies-to Entry", ILE."Entry No.");
                ItemJnl.Validate("Unit Cost (Revalued)", 0);
                ItemJnl.Insert;
                iC += 1;
                dlg.Update(1, Round(iC / iCount * 10000, 1));
            until ILE.Next = 0;
            CODEUNIT.Run(CODEUNIT::"Item Jnl.-Post", ItemJnl);
        end;

        if T27Tmp.FindSet then
            repeat
                T27.Get(T27Tmp."No.");
                T27.Blocked := true;
                T27.Modify;
            until T27Tmp.Next = 0;
        if T6505Tmp.FindSet then
            repeat
                T6505.Get(T6505Tmp."Item No.", T6505Tmp."Variant Code", T6505Tmp."Lot No.");
                T6505.Blocked := true;
                T6505.Modify;
            until T6505Tmp.Next = 0;

        dlg.Close;
    end;

    local procedure UnBlockLots()
    var
        Lot: Record "Lot No. Information";
        ILE: Record "Item Ledger Entry";
    begin
        //Supprimé, MArion 02/22
        /*Lot.RESET;
        Lot.SETRANGE(Blocked,TRUE);
        Lot.SETFILTER("Commentaire qualité",'Viande pas assez congel*');
        IF Lot.FINDSET THEN
        REPEAT
          ILE.RESET;
          ILE.SETRANGE("Item No.",Lot."Item No.");
          ILE.SETRANGE("Lot No.",Lot."Lot No.");
          ILE.SETRANGE("Entry Type",ILE."Entry Type"::Output);
          ILE.SETFILTER("Posting Date",'<%1',CALCDATE('<-4D>',TODAY));
          IF ILE.FINDSET THEN
          BEGIN
            Lot."Commentaire qualité" := 'Viande pas assez congelée - ok 4J';
            Lot.MODIFY(TRUE);
          END;
        UNTIL Lot.NEXT=0;
        
        Lot.RESET;
        Lot.SETRANGE(Blocked,TRUE);
        Lot.SETRANGE("Commentaire qualité",'Viande pas assez congelée - ok 4J');
        Lot.MODIFYALL(Blocked,FALSE);
        */

    end;

    local procedure Reminder()
    var
        reminderH: Record "Reminder Header";
        CreateReminder: Report "Create Reminders";
        IssuedReminder: Record "Issued Reminder Header";
    begin


        CreateReminder.InitializeRequest(Today, Today, true, false, false);
        CreateReminder.Run();

        reminderH.Reset;
        reminderH.SetRange("Posting Date", Today);
        reminderH.SetFilter("Remaining Amount", '>50');
        REPORT.Run(REPORT::"Issue Reminders", false, true, reminderH);

        IssuedReminder.Reset;
        IssuedReminder.SetRange("Posting Date", Today);
        REPORT.Run(50098, false, true, IssuedReminder);

        reminderH.Reset;
        reminderH.DeleteAll;
    end;
}

