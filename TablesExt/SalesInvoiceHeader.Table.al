tableextension 50056 SalesInvoiceHeaderEC extends "Sales Invoice Header"
{
    fields
    {
        field(50003; "Order type"; Option)
        {
            Caption = 'Order type';
            Description = 'LOG-004';
            OptionCaption = ' ,Frais,Surgelé';
            OptionMembers = " ",Frais,"Surgelé";
        }
        field(50004; "Logistic unit"; Code[20])
        {
            Caption = 'Logistic unit';
            Description = 'LOG-004';
        }
        field(50005; "Unit price/Palette"; Decimal)
        {
            Caption = 'Unit price/Palette';
            Description = 'LOG-004';
        }
        field(50006; "Territory Code"; Code[10])
        {
            Caption = 'Territory Code';
            Description = 'LOG-004';
            TableRelation = Territory;
        }
        field(50012; "Transport Purchase Order"; Code[20])
        {
            Caption = 'Transport Purchase Order';
            Description = 'AB60408.V14';
            Editable = false;
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = CONST(Order),
                                                           "No." = FIELD("Transport Purchase Order"));
        }
        field(50013; "Transport Purchase Invoice"; Code[20])
        {
            Caption = 'Transport Purchase Order';
            Description = 'AB60408.V14';
            Editable = false;
            TableRelation = "Purch. Inv. Header"."No." WHERE("No." = FIELD("Transport Purchase Invoice"));
        }
        field(50014; "Shipment No."; Code[20])
        {
            CalcFormula = Lookup("Shipment Invoiced"."Shipment No." WHERE("Invoice No." = FIELD("No.")));
            Caption = 'Delivery No.';
            Description = 'AB6.VIR';
            FieldClass = FlowField;
        }
        field(50015; "Send To"; Text[50])
        {
            CalcFormula = Lookup(Customer."Send To" WHERE("No." = FIELD("Bill-to Customer No.")));
            Caption = 'Send To';
            Description = 'Email';
            FieldClass = FlowField;
        }
        field(50016; "Mail Send"; Boolean)
        {
            Caption = 'Mail Send';
            Description = 'Email CTD 160615';
        }
        field(50020; "Date livraison prévue"; Date)
        {
            Caption = 'Date livraison prévue';
        }
        field(50021; StatusLogo; Option)
        {
            Caption = 'StatusLogo';
            OptionCaption = 'NonDefini,Avec,Sans';
            OptionMembers = NonDefini,Avec,Sans;
        }
        field(50041; "Raison retard"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Code.Code WHERE("Table No" = CONST(36),
                                             "Field No" = CONST(50041));
        }
        field(50043; ExtranetID; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50044; ExtranetDt; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(50061; Peppol_ResponseCode; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50062; Peppol_ResponseDt; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(50063; Peppol_ResponseReasonCode; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50064; Peppol_ResponseReason; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50065; Peppol_SendStatus; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

}

