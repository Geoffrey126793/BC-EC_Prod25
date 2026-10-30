tableextension 50054 SalesCueEC extends "Sales Cue"
{
    fields
    {
        field(50001; "Expedition ajd"; Integer)
        {
            CalcFormula = Count("Sales Header" WHERE("Document Type" = FILTER(Order),
                                                      Status = FILTER(Released),
                                                      Ship = FILTER(true),
                                                      "Promised Delivery Date" = FIELD("Date Filter2")));
            Caption = 'Ready to Ship';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002; "SOs Shipped Not Invoiced"; Integer)
        {
            CalcFormula = Count("Sales Header" WHERE("Document Type" = CONST(Order),
                                                      "Completely Shipped" = CONST(true),
                                                      Invoice = CONST(false)));
            Caption = 'SOs Shipped Not Invoiced';
            FieldClass = FlowField;
        }
        field(50003; "Cdes vente non conf"; Integer)
        {
            CalcFormula = Count("Sales Header" WHERE("Document Type" = CONST(Order),
                                                      "Completely Shipped" = CONST(false),
                                                      "Confirmation envoyée" = CONST(false),
                                                      Status = CONST(Released)));
            Caption = 'SOs Shipped Not Invoiced';
            Editable = false;
            FieldClass = FlowField;
        }
    }

}

