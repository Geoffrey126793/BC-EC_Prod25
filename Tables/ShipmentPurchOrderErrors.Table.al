table 50017 "Shipment Purch. Order Errors"
{
    Caption = 'Shipment Purch. Order Errors';

    fields
    {
        field(1; "Error Source"; Code[20])
        {
            Caption = 'Import ID';
            Description = 'Purch Creation';
        }
        field(2; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(3; Type; Option)
        {
            Caption = 'Type';
            Description = 'Error,Warning,Info';
            OptionCaption = 'Error,Warning,Info';
            OptionMembers = Error,Warning,Info;
        }
        field(4; "Order No."; Code[20])
        {
            Caption = 'Order No.';
        }
        field(5; "Shipping Agent Code"; Code[20])
        {
            Caption = 'Shipping Agent Code';
        }
        field(6; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
        }
        field(10; "Promised Delivery Date"; Date)
        {
            Caption = 'Promised Delivery Date';
        }
        field(20; Description; Text[200])
        {
            Caption = 'Description';
            Description = 'Error/Warning description.';
        }
    }

    keys
    {
        key(Key1; "Error Source", "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        RecShptOrdersErrors: Record "Shipment Purch. Order Errors";
        iEntryNo: Integer;

    [Scope('OnPrem')]
    procedure AddError(cSource: Code[20]; cOrderNo: Code[20]; cShipagent: Code[20]; cLocation: Code[20]; dDate: Date; tErrorDescription: Text[200])
    begin
        RecShptOrdersErrors.Reset;
        RecShptOrdersErrors.LockTable();
        if RecShptOrdersErrors.Find('+') then
            iEntryNo := RecShptOrdersErrors."Entry No." + 1
        else
            iEntryNo := 1;

        RecShptOrdersErrors.Init;
        RecShptOrdersErrors."Error Source" := cSource;
        RecShptOrdersErrors."Entry No." := iEntryNo;
        RecShptOrdersErrors.Type := Type::Error;
        RecShptOrdersErrors."Order No." := cOrderNo;
        RecShptOrdersErrors."Promised Delivery Date" := dDate;
        RecShptOrdersErrors.Description := tErrorDescription;
        RecShptOrdersErrors."Shipping Agent Code" := cShipagent;
        RecShptOrdersErrors."Location Code" := cLocation;
        RecShptOrdersErrors.Insert;
    end;

    [Scope('OnPrem')]
    procedure AddWarning(cSource: Code[20]; cOrderNo: Code[20]; cShipagent: Code[20]; cLocation: Code[20]; dDate: Date; tErrorDescription: Text[200])
    begin
        RecShptOrdersErrors.Reset;
        RecShptOrdersErrors.LockTable();
        if RecShptOrdersErrors.Find('+') then
            iEntryNo := RecShptOrdersErrors."Entry No." + 1
        else
            iEntryNo := 1;

        RecShptOrdersErrors.Init;
        RecShptOrdersErrors."Error Source" := cSource;
        RecShptOrdersErrors."Entry No." := iEntryNo;
        RecShptOrdersErrors.Type := Type::Warning;
        RecShptOrdersErrors."Order No." := cOrderNo;
        RecShptOrdersErrors."Promised Delivery Date" := dDate;
        RecShptOrdersErrors.Description := tErrorDescription;
        RecShptOrdersErrors."Shipping Agent Code" := cShipagent;
        RecShptOrdersErrors."Location Code" := cLocation;
        RecShptOrdersErrors.Insert;
    end;
}

