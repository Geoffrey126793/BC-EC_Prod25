table 50003 "Tracking Specif. Viewer"
{
    // ----------------------------------------------------------------------------------------------
    // LOG-003 ABSYS GN 20061030
    //   Arborescence Traçabilité
    // ------------------------------------------------------------------------------------------

    Caption = 'Tracking Specif. Viewer';

    fields
    {
        field(1; "Journal Name"; Code[20])
        {
            Caption = 'Journal Name';
            TableRelation = "Journal Track. Specif Viewer"."Journal Name";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Nomenclature,Composant';
            OptionMembers = Nomenclature,Composant;
        }
        field(4; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Purchase,Sale,Positive Adjmt.,Negative Adjmt.,Transfer,Consumption,Output';
            OptionMembers = Purchase,Sale,"Positive Adjmt.","Negative Adjmt.",Transfer,Consumption,Output;
        }
        field(8; "Interractiv bitmap"; Code[1])
        {
            Caption = 'Interractiv bitmap';
        }
        field(9; "Code"; Code[100])
        {
            Caption = 'Code';
            TableRelation = Item;

            trigger OnLookup()
            var
                EntProd: Record "Production BOM Header";
                Art: Record Item;
            begin
                Art.Get(Code);
                PAGE.RunModal(0, Art);
            end;
        }
        field(10; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(15; "Parent Line No."; Integer)
        {
            Caption = 'Parent Line No.';
        }
        field(100; Indentation; Integer)
        {
            Caption = 'Indentation';
        }
        field(101; Open; Boolean)
        {
            Caption = 'Open';
        }
        field(102; Visible; Boolean)
        {
            Caption = 'Visible';
        }
        field(104; "Last Level"; Boolean)
        {
            CalcFormula = - Exist("Tracking Specif. Viewer" WHERE("Journal Name" = FIELD("Journal Name"),
                                                                  "Parent Line No." = FIELD("Line No.")));
            Caption = 'Last Level';
            FieldClass = FlowField;
        }
        field(200; "Quality Status"; Option)
        {
            Caption = 'Quality Status';
            OptionCaption = ' ,Rejected,Warning,OK';
            OptionMembers = " ",Rejected,Warning,OK;
        }
        field(501; "Consumption Quantity"; Decimal)
        {
            Caption = 'Consumption Quantity';
        }
        field(503; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
        }
        field(600; "Lot no."; Code[250])
        {
            Caption = 'Lot no.';
        }
        field(601; "Item Legder Entry No."; Integer)
        {
            Caption = 'Item Legder Entry No.';
            TableRelation = "Item Ledger Entry";
        }
        field(603; "Item Legder Entry Qty"; Decimal)
        {
            Caption = 'Item Legder Entry Qty';
        }
        field(604; "Prod. Order No."; Code[20])
        {
            Caption = 'Prod. Order No.';
        }
        field(605; "Prod. Order Line No."; Integer)
        {
            Caption = 'Prod. Order Line No.';
        }
        field(610; "Item Ledger Entry No Filter"; Text[250])
        {
            Caption = 'Item Ledger Entry No Filter';
        }
        field(621; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = IF ("Entry Type" = CONST(Sale)) Customer."No."
            ELSE
            IF ("Entry Type" = CONST(Purchase)) Vendor."No.";
        }
        field(700; "Item Filter"; Code[20])
        {
            Caption = 'Item Filter';
            FieldClass = FlowFilter;
            TableRelation = Item."No.";
        }
        field(701; "Lot Filter"; Code[30])
        {
            Caption = 'Lot Filter';
            FieldClass = FlowFilter;
            TableRelation = IF ("Item Filter" = FILTER(<> '')) "Lot No. Information"."Lot No." WHERE("Item No." = FIELD("Item Filter"));
        }
        field(702; "Hide Output Entry"; Boolean)
        {
            Caption = 'Hide Output Entry';
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(Key1; "Journal Name", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Entry Type", "Prod. Order No.", "Prod. Order Line No.", Indentation)
        {
        }
    }

    fieldgroups
    {
    }
}

