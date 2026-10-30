tableextension 50037 PurchaseCueEC extends "Purchase Cue"
{

    fields
    {
        field(50000; "Date Filter Today"; Date)
        {
            Caption = 'Date Filter Today';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(50001; "Depart ajd"; Integer)
        {
            CalcFormula = Count("Sales Line" WHERE("Completely Shipped" = CONST(false),
                                                    "Promised Delivery Date" = FIELD("Date Filter Today"),
                                                    Type = CONST(Item)));
            Caption = 'Depart ajd';
            FieldClass = FlowField;
        }
        field(50002; "OTS ajd"; Integer)
        {
            CalcFormula = Count("Transfer Header" WHERE("Shipment Date" = FIELD("Date Filter Today"),
                                                         "Transfer-from Code" = CONST('ECCONGEL')));
            Caption = 'OTS ajd';
            FieldClass = FlowField;
        }
        field(50003; "DateFilter Demain ouvre"; Date)
        {
            Caption = 'DateFilter Demain ouvre';
            FieldClass = FlowFilter;
        }
        field(50004; "Préparations demain"; Integer)
        {
            CalcFormula = Count("Sales Line" WHERE("Bin Code" = FILTER(<> 'DEPART3'),
                                                    "Promised Delivery Date" = FIELD("DateFilter Demain ouvre"),
                                                    Type = CONST(Item),
                                                    "Location Code" = CONST('ECCONGEL')));
            Caption = 'Préparations demain';
            FieldClass = FlowField;
        }
        field(50005; "Préparations demain OK"; Integer)
        {
            CalcFormula = Count("Sales Line" WHERE("Bin Code" = FILTER('DEPART3'),
                                                    "Promised Delivery Date" = FIELD("DateFilter Demain ouvre"),
                                                    Type = CONST(Item),
                                                    "Location Code" = CONST('ECCONGEL')));
            Caption = 'Préparations demain OK';
            FieldClass = FlowField;
        }
    }

}

