page 50090 "Posted Sales Inv. Lines List"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Sales Invoice Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Type; Type)
                {
                }
                field("No."; "No.")
                {
                }

                field("IC Partner Code"; "IC Partner Code")
                {
                    Visible = false;
                }
                field("Variant Code"; "Variant Code")
                {
                    Visible = false;
                }
                field(Description; Description)
                {
                }
                field("Return Reason Code"; "Return Reason Code")
                {
                    Visible = false;
                }
                field(Quantity; Quantity)
                {
                    BlankZero = true;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    Visible = false;
                }
                field("Unit Cost (LCY)"; "Unit Cost (LCY)")
                {
                    Visible = false;
                }
                field("Unit Price"; "Unit Price")
                {
                    BlankZero = true;
                }
                field("Line Amount"; "Line Amount")
                {
                    BlankZero = true;
                }
                field("Line Discount %"; "Line Discount %")
                {
                    BlankZero = true;
                }
                field("Line Discount Amount"; "Line Discount Amount")
                {
                    Visible = false;
                }
                field("Allow Invoice Disc."; "Allow Invoice Disc.")
                {
                    Visible = false;
                }
                field("Job No."; "Job No.")
                {
                    Visible = false;
                }
                field("Appl.-to Item Entry"; "Appl.-to Item Entry")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Document Date"; "Document Date")
                {
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';

                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #132. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesInvLines.FORM.*/
                        _ShowLineComments;

                    end;
                }
                action("Item &Tracking Entries")
                {
                    Caption = 'Item &Tracking Entries';
                    Image = ItemTrackingLedger;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #132. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesInvLines.FORM.*/
                        Rec.ShowItemTrackingLines();


                    end;
                }
                action("Item Shipment &Lines")
                {
                    Caption = 'Item Shipment &Lines';

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #132. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesInvLines.FORM.*/
                        _ShowItemShipmentLines;

                    end;
                }
            }
        }
    }


    [Scope('OnPrem')]
    procedure _ShowItemShipmentLines()
    begin
        if not (Type in [Type::Item, Type::"Charge (Item)"]) then
            TestField(Type);
        Rec.ShowItemShipmentLines;
    end;



    [Scope('OnPrem')]
    procedure _ShowLineComments()
    begin
        Rec.ShowLineComments;
    end;


}

