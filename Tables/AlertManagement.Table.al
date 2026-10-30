table 50009 "Alert Management"
{
    // --------------------------------------------------------------------------------------------------------------
    // ABS2.00
    //   Add-on Alert Management GN 20061012
    //     First living version
    // --------------------------------------------------------------------------------------------------------------

    Caption = 'Alert Management';
    DrillDownPageID = "Comment List";
    LookupPageID = "Comment List";

    fields
    {
        field(1; "Table Name"; Option)
        {
            Caption = 'Table Name';
            OptionCaption = 'G/L Account,Customer,Vendor,Item,Resource,Job,,Resource Group,Bank Account,Campaign,Fixed Asset,Insurance,Nonstock Item,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,Item,Resource,Job,,"Resource Group","Bank Account",Campaign,"Fixed Asset",Insurance,"Nonstock Item","IC Partner";
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF ("Table Name" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Table Name" = CONST(Customer)) Customer
            ELSE
            IF ("Table Name" = CONST(Vendor)) Vendor
            ELSE
            IF ("Table Name" = CONST(Item)) Item
            ELSE
            IF ("Table Name" = CONST(Resource)) Resource
            ELSE
            IF ("Table Name" = CONST(Job)) Job
            ELSE
            IF ("Table Name" = CONST("Resource Group")) "Resource Group"
            ELSE
            IF ("Table Name" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Table Name" = CONST(Campaign)) Campaign
            ELSE
            IF ("Table Name" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Table Name" = CONST(Insurance)) Insurance
            ELSE
            IF ("Table Name" = CONST("IC Partner")) "IC Partner";
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; Date; Date)
        {
            Caption = 'Date';
        }
        field(5; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(6; Comment; Text[250])
        {
            Caption = 'Comment';
        }
        field(7; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(8; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(9; Active; Boolean)
        {
            Caption = 'Active';
        }
        field(10; "Event"; Option)
        {
            Caption = 'Event';
            OptionCaption = ' ,,,,,,,,,,Customer on Sales Order,,,,,,,,,,Item on Sales Order,,,,,,,,,,Item on Purchase Order,,,,,,,,,,Vendor on Purchase Order';
            OptionMembers = " ",,,,,,,,,,"Customer on Sales Order",,,,,,,,,,"Item on Sales Order",,,,,,,,,,"Item on Purchase Order",,,,,,,,,,"Vendor on Purchase Order";
        }
        field(11; UserCode; Code[30])
        {
            Caption = 'User ID';
        }
    }

    keys
    {
        key(Key1; "Table Name", "No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Table Name", "No.", "Starting Date", "Ending Date", Active, "Event")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        Date := Today;
        UserCode := UserId;
    end;

    trigger OnModify()
    begin
        Date := Today;
        UserCode := UserId;
    end;

    [Scope('OnPrem')]
    procedure SetUpNewLine()
    var
        CommentLine: Record "Alert Management";
    begin
        CommentLine.SetRange("Table Name", "Table Name");
        CommentLine.SetRange("No.", "No.");
        CommentLine.SetRange(Date, WorkDate);
        if not CommentLine.Find('-') then
            Date := WorkDate;
    end;
}

