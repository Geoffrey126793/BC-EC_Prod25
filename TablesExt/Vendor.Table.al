tableextension 50074 VendorEC extends Vendor
{
    fields
    {
        field(50000; "Criteria 1"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(50000);
            Caption = 'Criteria 1';
            Description = 'STA-000';
            TableRelation = Code.Code WHERE("Table No" = CONST(23),
                                             "Field No" = CONST(50000));
        }
        field(50001; "Criteria 2"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(50001);
            Caption = 'Criteria 2';
            Description = 'STA-000';
            TableRelation = Code.Code WHERE("Table No" = CONST(23),
                                             "Field No" = CONST(8001302));
        }
        field(50002; "Criteria 3"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(50003);
            Caption = 'Criteria 3';
            Description = 'STA-000';
            TableRelation = Code.Code WHERE("Table No" = CONST(23),
                                             "Field No" = CONST(8001303));
        }
        field(50003; "Criteria 4"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(50004);
            Caption = 'Criteria 4';
            Description = 'STA-000';
            TableRelation = Code.Code WHERE("Table No" = CONST(23),
                                             "Field No" = CONST(8001304));
        }
        field(50004; "Criteria 5"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(50005);
            Caption = 'Criteria 5';
            Description = 'STA-000';
            TableRelation = Code.Code WHERE("Table No" = CONST(23),
                                             "Field No" = CONST(8001305));
        }
        field(50005; "Criteria 6"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(50006);
            Caption = 'Criteria 6';
            Description = 'STA-000';
            TableRelation = Code.Code WHERE("Table No" = CONST(23),
                                             "Field No" = CONST(8001306));
        }
        field(50006; "Criteria 7"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(50007);
            Caption = 'Criteria 7';
            Description = 'STA-000';
            TableRelation = Code.Code WHERE("Table No" = CONST(23),
                                             "Field No" = CONST(8001307));
        }
        field(50007; "Criteria 8"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(50008);
            Caption = 'Criteria 8';
            Description = 'STA-000';
            TableRelation = Code.Code WHERE("Table No" = CONST(23),
                                             "Field No" = CONST(8001308));
        }
        field(50008; "Criteria 9"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(50009);
            Caption = 'Criteria 9';
            Description = 'STA-000';
            TableRelation = Code.Code WHERE("Table No" = CONST(23),
                                             "Field No" = CONST(8001309));
        }
        field(50009; "Criteria 10"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(50010);
            Caption = 'Criteria 10';
            Description = 'STA-000';
            TableRelation = Code.Code WHERE("Table No" = CONST(23),
                                             "Field No" = CONST(8001310));
        }
        field(50161; "GLN EC"; Text[15])
        {
            Caption = 'GLN';
        }
        field(50162; "GLN Destinataire"; Text[15])
        {
            Caption = 'GLN Destinataire';
        }
        field(50163; IFCSUM; Boolean)
        {
            Caption = 'IFCSUM';
        }
        field(50164; "Repertoire Send AS2"; Text[250])
        {
            Caption = 'Repertoire Send AS2';
        }
        field(50165; "E-Mail EDI"; Text[150])
        {
            Caption = 'E-Mail EDI';
        }
        field(50166; "Traitement EDI"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Non,IFCSUM,csv1;
        }
        field(50167; tmpTVA; Text[20])
        {
            Caption = 'VAT Registration No.';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "VAT Registration No." := tmpTVA;

                "VAT Registration No." := UpperCase("VAT Registration No.");
                if "VAT Registration No." <> xRec."VAT Registration No." then
                    VATRegistrationValidation;
            end;
        }
        field(50168; "Ignorer le mappage de texte"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(55000; "By Boat Vendor"; Boolean)
        {
            Caption = 'By Boat Vendor';
            Description = 'LOG-005';
        }
        field(55001; "Contenaire Mandatory"; Boolean)
        {
            Caption = 'By Boat Vendor';
            Description = 'LOG-005';
        }
        field(66000; "Vendor completed"; Boolean)
        {
            Caption = 'Vendor completed';
            Description = 'ABS6.00';
        }
    }
    fieldgroups
    {

        addlast(DropDown; "VAT Registration No.")
        {

        }

    }
    var
        wStatisticAggregate: Record "Statistic aggregate";
}

