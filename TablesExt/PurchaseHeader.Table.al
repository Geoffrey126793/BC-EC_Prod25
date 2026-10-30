tableextension 50038 PurchaseHeaderEC extends "Purchase Header"
{
    fields
    {
        field(50000; "Blanket Order N°"; Code[20])
        {
            CalcFormula = Lookup("Purchase Line"."Blanket Order No." WHERE("Document Type" = FIELD("Document Type"),
                                                                            "Document No." = FIELD("No."),
                                                                            "Blanket Order No." = FILTER(<> '')));
            Caption = 'Blanket Order';
            Description = 'ACH-003';
            FieldClass = FlowField;
        }
        field(50001; "Status Visa"; Option)
        {
            Caption = 'Status Visa';
            Description = 'ACH-003';
            OptionCaption = 'On standby visa, Visa authorized';
            OptionMembers = "On standby visa ","Visa authorized";

            trigger OnValidate()
            begin
                //ContrŽóÔé¼ôle déporté dans le FORM 50013

                //--> ADV-007 ABSYS GN 20061025

                //IF AB6Tool.GetRole('VISAA') THEN BEGIN

                //IF ("Status Visa" = "Status Visa"::"Visa authorized") AND ("Document Type" = "Document Type"::Order) THEN BEGIN
                //  "Date Visa" := WORKDATE;
                //  "Person in charge Visa" := USERID;
                //  VALIDATE(Status,Status::Released);
                // END ELSE BEGIN
                //  "Date Visa" := 0D;
                //  "Person in charge Visa" := '';
                // END;
                //END
                //ELSE BEGIN
                // IF ("Status Visa" = "Status Visa"::"Visa authorized") AND ("Document Type" = "Document Type"::Order) THEN
                //   ERROR(Text50000);
                //END;

                //<-- ADV-007 ABSYS GN 20061025
            end;
        }
        field(50002; "Person in charge Visa"; Code[50])
        {
            Caption = 'Person in charge Visa';
            Description = 'ACH-003';
        }
        field(50003; "Date Visa"; Date)
        {
            Caption = 'Date Visa';
            Description = 'ACH-003';
        }
        field(50004; Container; Text[30])
        {
            Caption = 'Container';
            Description = 'FON-001';
        }
        field(50007; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            Description = 'AB60408.V14';
            TableRelation = "Shipping Agent";
        }
        field(50008; "Transport validé"; Boolean)
        {
            Caption = 'Transport validé';
        }
        field(50009; "Nombre de camions prévus"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "Vérification Montant TTC"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50011; "Status Visa2"; Option)
        {
            Caption = 'Status Visa';
            DataClassification = ToBeClassified;
            Description = 'ACH-003';
            OptionCaption = 'On standby visa, Visa authorized';
            OptionMembers = "On standby visa ","Visa authorized";
        }
        field(50012; "Person in charge Visa2"; Code[50])
        {
            Caption = 'Person in charge Visa';
            DataClassification = ToBeClassified;
            Description = 'ACH-003';
        }
        field(50013; "Date Visa2"; Date)
        {
            Caption = 'Date Visa';
            DataClassification = ToBeClassified;
            Description = 'ACH-003';
        }
        field(50100; User; Code[50])
        {
            Caption = 'User';
            Description = 'AB6.VIR';
        }
        field(55000; "By boat"; Boolean)
        {
            Caption = 'By boat';
            Description = 'LOG-005';
        }
        field(55001; "Boat to be liberated"; Boolean)
        {
            Caption = 'Boat to be liberated';
            Description = 'LOG-005';
        }
        field(55002; "Sales Availability date"; Date)
        {
            Caption = 'Sales Availability date';
            Description = 'LOG-005';

            trigger OnValidate()
            var
                "**** MBI-050 *****": Integer;
                PurchMgt: Codeunit "Purch.-Post";
                Txt55000: Label 'Do you want to change Availability date on each quarantine ?';
            begin
                //--> LOG-005 ABSYS GN 20061113
                //IF ("Sales Availability date" <> xRec."Sales Availability date") AND ("Boat to be liberated") THEN BEGIN
                //  IF CONFIRM(Txt55000) THEN BEGIN
                //    PurchMgt.ChangeAvailabilityDate("No.","Sales Availability date");
                //  END;
                //END;
                //<-- LOG-005 ABSYS GN 20061113
            end;
        }
        field(55003; Note; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(55004; "Type commande"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Qualite,Production,HR,RD,Finance,Logistique,Transport,Technique,Securite;
        }
    }

}

