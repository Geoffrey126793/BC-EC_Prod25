page 50064 "Production Planner Act EC"
{
    Caption = 'Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Manufacturing Cue";

    layout
    {
        area(content)
        {
            cuegroup("Production Orders")
            {
                Caption = 'Production Orders';
                field("Lotsbloqués"; Lotsbloqués)
                {
                    Caption = 'Lots bloqués';

                    trigger OnDrillDown()
                    begin
                        Lots.Reset;
                        Lots.SetRange(Blocked, true);
                        PAGE.Run(0, Lots);
                    end;
                }
                field("OFbloquésdujour"; OFbloquésdujour)
                {
                    Caption = 'OF bloqués du jour';

                    trigger OnDrillDown()
                    begin
                        OFs.Reset;
                        OFs.SetRange("Due Date", WorkDate);
                        if OFs.FindSet then
                            repeat
                                if Items.Get(OFs."Source No.") then begin
                                    if Items."Comment blocage lots produits" <> '' then begin
                                        OFs.Mark(true);
                                    end;
                                end;
                            until OFs.Next = 0;

                        OFs.MarkedOnly(true);
                        PAGE.Run(0, OFs);
                    end;
                }

                actions
                {
                    action("Change Production Order Status")
                    {
                        ApplicationArea = Manufacturing;
                        Caption = 'Change Production Order Status';
                        RunObject = Page "Change Production Order Status";
                        ToolTip = 'Change the production order to another status, such as Released.';
                    }
                    action("New Production Order")
                    {
                        ApplicationArea = Manufacturing;
                        Caption = 'New Production Order';
                        RunObject = Page "Planned Production Order";
                        RunPageMode = Create;
                        ToolTip = 'Prepare to produce an end item. ';
                    }
                    action(Navigate)
                    {
                        ApplicationArea = Manufacturing;
                        Caption = 'Navigate';
                        RunObject = Page Navigate;
                        ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {

        }
    }

    trigger OnAfterGetRecord()
    begin
        Lots.Reset;
        Lots.SetRange(Blocked, true);
        Lotsbloqués := Lots.Count();

        OFbloquésdujour := 0;
        OFs.Reset;
        OFs.SetRange("Due Date", WorkDate);
        if OFs.FindSet then
            repeat
                if Items.Get(OFs."Source No.") then begin
                    if Items."Comment blocage lots produits" <> '' then begin
                        OFs.Mark(true);
                        OFbloquésdujour += 1;
                    end;
                end;
            until OFs.Next = 0;
    end;

    trigger OnOpenPage()
    var
        RoleCenterNotificationMgt: Codeunit "Role Center Notification Mgt.";
    begin
        Reset;
        if not Get then begin
            Init;
            Insert;
        end;

        SetRange("User ID Filter", UserId);


    end;

    var

        PermissionManager: Codeunit "Permission Manager";
        UserTaskManagement: Codeunit "User Task Management";
        ShowIntelligentCloud: Boolean;
        "Lotsbloqués": Decimal;
        "OFbloquésdujour": Decimal;
        OFs: Record "Production Order";
        Lots: Record "Lot No. Information";
        Items: Record Item;
}

