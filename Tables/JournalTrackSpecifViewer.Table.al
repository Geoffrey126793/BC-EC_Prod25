table 50000 "Journal Track. Specif Viewer"
{
    // ----------------------------------------------------------------------------------------------
    // LOG-003 ABSYS GN 20061030
    //   Arborescence Traçabilité
    // ------------------------------------------------------------------------------------------

    Caption = 'Journal Track. Specif Viewer';

    fields
    {
        field(1; "Journal Name"; Code[20])
        {
            Caption = 'Journal Name';
        }
        field(2; "Journal Description"; Text[30])
        {
            Caption = 'Journal Description';
        }
        field(3; "Item Filter"; Text[250])
        {
            Caption = 'Item Filter';
            TableRelation = Item;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(4; "Lot No. Filter"; Text[250])
        {
            Caption = 'Lot No. Filter';
            TableRelation = "Lot No. Information"."Lot No." WHERE ("Item No." = FIELD ("Item Filter"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(5; Direction; Option)
        {
            Caption = 'Direction';
            OptionCaption = 'Up,Down';
            OptionMembers = Up,Down;
        }
        field(6; "Item Filter Finish"; Text[250])
        {
            Caption = 'Item Filter Finish';
            TableRelation = Item;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(7; "Only Distinct of Last Level"; Boolean)
        {
            Caption = 'Only Distinct of Last Level';
        }
    }

    keys
    {
        key(Key1; "Journal Name")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

