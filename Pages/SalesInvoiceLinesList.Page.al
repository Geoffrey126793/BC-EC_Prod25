page 50032 "Sales Invoice Lines List"
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
                field("Document No."; "Document No.")
                {
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                }
                field(Type; Type)
                {
                }
                field("No."; "No.")
                {

                    trigger OnAssistEdit()
                    var
                        PItemList: Page "Item List";
                        Items: Record Item;
                    begin
                        if Type = Type::Item then begin
                            Items.Reset;
                            Items.SetRange("No.", "No.");
                            if Items.FindFirst then;
                            Items.SetRange("No.");
                            PItemList.SetRecord(Items);
                            PItemList.SetTableView(Items);
                            PItemList.LookupMode := true;
                            if PItemList.RunModal = ACTION::LookupOK then begin
                                PItemList.GetRecord(Items);
                                Validate("No.", Items."No.");
                            end;

                        end;
                    end;
                }

                field(Description; Description)
                {
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
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #132. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesInvLines.FORM.*/
                        _ShowDimensions;

                    end;
                }
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
    procedure _ShowDimensions()
    begin
        Rec.ShowDimensions;
    end;



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

