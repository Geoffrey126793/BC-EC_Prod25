codeunit 50020 ModifTables
{
    Permissions = TableData "Sales Shipment Header" = rm,
                  TableData "Sales Invoice Header" = rm,
                  TableData "VAT Entry" = rimd,
                  TableData "Issued Reminder Header" = rm;

    trigger OnRun()
    begin
    end;

    [Scope('OnPrem')]
    procedure InvoiceSend(No: Code[20])
    var
        SalesInvHeader: Record "Sales Invoice Header";
    begin
        SalesInvHeader.Reset;
        if SalesInvHeader.Get(No) then begin
            SalesInvHeader."Mail Send" := true;
            SalesInvHeader.Modify;
        end;
    end;

    [Scope('OnPrem')]
    procedure ReminderSend(No: Code[20])
    var
        ReminderHeader: Record "Issued Reminder Header";
    begin
        ReminderHeader.Reset;
        if ReminderHeader.Get(No) then begin
            ReminderHeader."E-Mail envoyé" := true;
            ReminderHeader.Modify;
        end;
    end;

    [Scope('OnPrem')]
    procedure InvoiceLogo(No: Code[20]; Logo: Option NonDefini,Avec,Sans)
    var
        SalesInvHeader: Record "Sales Invoice Header";
    begin
        SalesInvHeader.Reset;
        if SalesInvHeader.Get(No) then begin
            SalesInvHeader.StatusLogo := Logo;
            SalesInvHeader.Modify;
        end;
    end;

    [Scope('OnPrem')]
    procedure ModifVATEntry(Entry: Record "VAT Entry")
    begin
        if not Entry.Insert then
            Entry.Modify;
    end;

    [Scope('OnPrem')]
    procedure DelVATEntry(Entry: Record "VAT Entry")
    begin
        Entry.Delete;
    end;

    [Scope('OnPrem')]
    procedure ExpedieShipment(No: Code[20]; Ref: Code[30])
    var
        ShptH: Record "Sales Shipment Header";
    begin
        ShptH.Reset;
        if ShptH.Get(No) then begin
            ShptH."Ref Envoi" := Ref;
            ShptH.Modify;
        end;
    end;

    [Scope('OnPrem')]
    procedure PaletOnShipment(NoExp: Code[20]; NbrPal: Integer; NbrColis: Integer)
    var
        recExp: Record "Sales Shipment Header";
    begin
        recExp.Get(NoExp);
        recExp."Nombre de colis" := NbrColis;
        recExp."Nombre de palette" := NbrPal;
        recExp.Modify;
    end;
}

