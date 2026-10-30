tableextension 50009 CustomerEC extends Customer
{
    fields
    {
        field(50000; "Name Optional Invoice"; Text[30])
        {
            Caption = 'Name Optional Invoice';
            Description = 'ADV-008';

            trigger OnValidate()
            begin
                if ("Search Name" = UpperCase(xRec.Name)) or ("Search Name" = '') then
                    "Search Name" := Name;
            end;
        }
        field(50001; "Name 2 Optional Invoice"; Text[30])
        {
            Caption = 'Name 2';
            Description = 'ADV-008';
        }
        field(50002; "Address Optional Invoice"; Text[30])
        {
            Caption = 'Address';
            Description = 'ADV-008';
        }
        field(50003; "Address 2 Optional Invoice"; Text[30])
        {
            Caption = 'Address 2';
            Description = 'ADV-008';
        }
        field(50004; "City Optional Invoice"; Text[30])
        {
            Caption = 'City';
            Description = 'ADV-008';

            trigger OnLookup()
            begin
                //PostCode.LookUpCity("City Optional Invoice","Post Code",TRUE);
            end;


        }
        field(50005; "Post Code Optional Invoice"; Code[20])
        {
            Caption = 'Post Code';
            Description = 'ADV-008';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                //PostCode.LookUpPostCode("City Optional Invoice","Post Code Optional Invoice",TRUE);
            end;


        }
        field(50006; "Country Code Optional"; Code[10])
        {
            Caption = 'Country Code';
            Description = 'ADV-008';
            TableRelation = "Country/Region".Code;
        }
        field(50007; "Sending Invoice Address"; Boolean)
        {
            Caption = 'Sending Invoice Address';
            Description = 'ADV-008';
        }
        field(50010; "Number Copy CMR"; Integer)
        {
            Caption = 'Number Copy CMR';
            Description = 'ADV-008';
        }
        field(50011; "Number copy BL"; Integer)
        {
            Caption = 'Number Copy BL';
            Description = 'ADV-008';
        }
        field(50012; "Covered date"; Date)
        {
            Caption = 'Covered date';
            Description = 'ADV-008';
        }
        field(50013; "Schedule of delivery customer"; Text[80])
        {
            Caption = 'Schedule of delivery customer';
            Description = 'ADV-008';
        }
        field(50014; "Logistic comment"; Text[80])
        {
            Caption = 'Logistic comment';
            Description = 'ADV-008,AB60408.V12';
        }
        field(50015; "Old Customer No."; Code[20])
        {
            Caption = 'Old customer No.';
            Description = 'ADV-008';
            Editable = false;
        }
        field(50016; "Logistic unit"; Code[20])
        {
            Caption = 'Logistic unit';
            Description = 'LOG-004';
            TableRelation = "Unité logistique";
        }
        field(50017; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(50018; "Complete Pallet"; Boolean)
        {
            Caption = 'Complete Pallet';
            Description = 'AB60408.V5';
        }
        field(50020; "Coface No."; Code[20])
        {
            Caption = 'Coface No.';
        }
        field(50021; "End covered date"; Date)
        {
            Caption = 'Covered end date';
        }
        field(50030; "Production comment"; Text[150])
        {
            Caption = 'Production comment';
            Description = 'ADV-009,AB6020080625';
        }
        field(50100; "Groupe crédit autorisé"; Code[20])
        {
            Caption = 'Groupe crédit autorisé';
            Description = 'ADV-004';
            TableRelation = "Groupe crédit autorisé".Code;
        }
        field(50101; "Délai régl. moyen (jours) N"; Decimal)
        {
            Caption = 'Avg. Collection Period (Days) N';
            Description = 'AB60408.V13';
        }
        field(50102; "Délai régl. moyen (jours) N -1"; Decimal)
        {
            Caption = 'Avg. Collection Period (Days) N-1';
            Description = 'AB60408.V13';
        }
        field(50120; "Average time of order"; DateFormula)
        {
            Caption = 'Average time of order';
            Description = 'ADV-006';
        }
        field(50125; "Invoice Comment"; Text[50])
        {
            Caption = 'Invoice Comment';
        }
        field(50130; "Default Ship-to Address"; Code[20])
        {
            Caption = 'Default Ship-to Address';
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("No."));
        }
        field(50150; "Ouverture Dossier COFACE"; Date)
        {
            Caption = 'Open Date';
        }
        field(50151; "Rating COFACE"; Option)
        {
            Caption = 'Credit insurance';
            OptionCaption = ' ,R,@,@@,@@@,A,0,ND,TOPLINER,URIOS';
            OptionMembers = " ",R,"@","@@","@@@",A,"0",ND,TOPLINER,URIOS;
        }
        field(50157; "Send To"; Text[50])
        {
            Caption = 'Send To';
            Description = 'email';
        }
        field(50158; "Send Cc"; Text[50])
        {
            Caption = 'Send Cc';
            Description = 'email';
        }
        field(50159; "Stade rappel calculé"; Integer)
        {
            Caption = 'Stade rappel calculé';
        }
        field(50160; "Stade manuel"; Boolean)
        {
            Caption = 'Stade manuel';
        }
        field(50161; "GLN EC"; Text[15])
        {
            Caption = 'GLN';
        }
        field(50162; "GLN Destinataire"; Text[15])
        {
            Caption = 'GLN Destinataire';
        }
        field(50163; DESADV; Boolean)
        {
            Caption = 'DESADV';
        }
        field(50164; "Repertoire Send AS2"; Text[250])
        {
            Caption = 'Repertoire Send AS2';
        }
        field(50165; "E-Mail EDI"; Text[50])
        {
            Caption = 'E-Mail EDI';
        }
        field(50166; "ID Contraload"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50167; "SFTP Server"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50168; "SFTP Dir"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50169; "SFTP Login"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50170; "SFTP Pwd"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50171; "SFTP port"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50172; "EInvoice EAS"; Code[10])
        {
            Caption = 'EInvoice e-address';
            DataClassification = ToBeClassified;
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(50172));
        }
        field(50173; "EInvoice Endpoint"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50174; MailEXV; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(50175; EtiquetteExp; Code[20])
        {
            Caption = 'Etiquette Exp';
            DataClassification = ToBeClassified;
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(50175));
        }
        field(50176; "Version DESADV"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "01B","96A","96ARegroupe";
        }
        field(50200; "N° EORI"; Code[30])
        {
            Caption = 'N° EORI';
        }
        field(50201; "Intervalle de commande"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50202; "Limite crédit interne"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Validate("Credit Limit (LCY)", "Limite crédit générale" + "Limite crédit interne" + "Limite crédit additionnelle" + "Limite crédit non dénommée");
            end;
        }
        field(50203; "Limite crédit générale"; Decimal)
        {
            Caption = 'Limite crédit externe (Coface, ...)';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Validate("Credit Limit (LCY)", "Limite crédit générale" + "Limite crédit interne" + "Limite crédit additionnelle" + "Limite crédit non dénommée");
            end;
        }
        field(50204; "Limite crédit additionnelle"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Validate("Credit Limit (LCY)", "Limite crédit générale" + "Limite crédit interne" + "Limite crédit additionnelle" + "Limite crédit non dénommée");
            end;
        }
        field(50205; "Limite crédit non dénommée"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Validate("Credit Limit (LCY)", "Limite crédit générale" + "Limite crédit interne" + "Limite crédit additionnelle" + "Limite crédit non dénommée");
            end;
        }
        field(50206; "ByPass Credit chek"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50207; tmpTVA; Text[30])
        {
            Caption = 'VAT Registration No.';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                CuCompta: Codeunit Integration_Compta;
            begin
                "VAT Registration No." := UpperCase(tmpTVA);
                if "VAT Registration No." <> xRec."VAT Registration No." then
                    VATRegistrationValidation;

                if ("VAT Registration No." <> '') or ("Enterprise No." = '') then
                    "Enterprise No." := CuCompta.ConvVatNoToEntNo("VAT Registration No.", "Country/Region Code");
            end;
        }
        field(66000; "Customer completed"; Boolean)
        {
            Caption = 'Customer completed';
            Description = 'ABS6.00';
        }
        field(8001301; "Criteria 1"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(1);
            Caption = 'Criteria 1';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001301));
        }
        field(8001302; "Criteria 2"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(2);
            Caption = 'Criteria 2';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001302));
        }
        field(8001303; "Criteria 3"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(3);
            Caption = 'Criteria 3';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001303));
        }
        field(8001304; "Criteria 4"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(4);
            Caption = 'Criteria 4';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001304));
        }
        field(8001305; "Criteria 5"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(5);
            Caption = 'Criteria 5';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001305));
        }
        field(8001306; "Criteria 6"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(6);
            Caption = 'Criteria 6';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001306));
        }
        field(8001307; "Criteria 7"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(7);
            Caption = 'Criteria 7';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001307));
        }
        field(8001308; "Criteria 8"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(8);
            Caption = 'Criteria 8';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001308));
        }
        field(8001309; "Criteria 9"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(9);
            Caption = 'Criteria 9';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001309));
        }
        field(8001310; "Criteria 10"; Code[20])
        {
            CaptionClass = wStatisticAggregate.GetCaptionsStatsExplorer(10);
            Caption = 'Criteria 10';
            TableRelation = Code.Code WHERE("Table No" = CONST(18),
                                             "Field No" = CONST(8001310));
        }

    }
    var
        wStatisticAggregate: Record "Statistic aggregate";
}

