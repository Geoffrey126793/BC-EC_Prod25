tableextension 50031 ManufacturingCueEC extends "Manufacturing Cue"
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
        field(50002; "OTS ajd vers Prod"; Integer)
        {
            CalcFormula = Count("Transfer Header" WHERE("Shipment Date" = FIELD("Date Filter Today"),
                                                         "Transfer-to Code" = CONST('EC TOURNAI')));
            Caption = 'OTS ajd vers Prod';
            FieldClass = FlowField;
        }
        field(50003; "DateFilter Demain ouvre"; Date)
        {
            Caption = 'DateFilter Demain ouvre';
            FieldClass = FlowFilter;
        }
        field(50004; "OTS ajd"; Integer)
        {
            CalcFormula = Count("Transfer Header" WHERE("Shipment Date" = FIELD("Date Filter Today")));
            Caption = 'OTS ajd';
            FieldClass = FlowField;
        }
        field(50005; "OTS demain"; Integer)
        {
            CalcFormula = Count("Transfer Header" WHERE("Shipment Date" = FIELD("DateFilter Demain ouvre")));
            Caption = 'OTS demain';
            FieldClass = FlowField;
        }
        field(50006; "OF A Faire ajd"; Integer)
        {
            CalcFormula = Count("Production Order" WHERE(Status = CONST(Released),
                                                          "Due Date" = FIELD("Date Filter Today")));
            Caption = 'OF A Faire ajd';
            FieldClass = FlowField;
        }
        field(50007; "OF Fait ajd"; Integer)
        {
            CalcFormula = Count("Production Order" WHERE(Status = CONST(Finished),
                                                          "Due Date" = FIELD("Date Filter Today")));
            Caption = 'OF Fait ajd';
            FieldClass = FlowField;
        }
        field(50008; "OF demain"; Integer)
        {
            CalcFormula = Count("Production Order" WHERE("Due Date" = FIELD("DateFilter Demain ouvre")));
            Caption = 'OF demain';
            FieldClass = FlowField;
        }
    }

}

