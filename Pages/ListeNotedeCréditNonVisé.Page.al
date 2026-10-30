page 50017 "Liste Note de Crédit Non Visé"
{
    Caption = 'Liste Note de Crédit Non Visé';
    CardPageID = "Sales Credit Memo";
    Editable = false;
    PageType = List;
    SourceTable = "Sales Header";
    SourceTableView = SORTING ("Document Type", "No.")
                      WHERE ("Status Visa" = CONST ("On standby visa "),
                            "Document Type" = CONST ("Credit Memo"));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Status Visa"; "Status Visa")
                {
                }
                field("Bill-to Customer No."; "Bill-to Customer No.")
                {
                }
                field("Order type"; "Order type")
                {
                }
                field("Requested Delivery Date"; "Requested Delivery Date")
                {
                }
                field("Promised Delivery Date"; "Promised Delivery Date")
                {
                }
                field("Bill-to Name"; "Bill-to Name")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Viser)
            {
                Caption = 'Viser';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    "Status Visa" := "Status Visa"::"Visa authorized";
                    Modify;
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        UserSetUp: Record "User Setup";
    begin
        if (UserSetUp.Get(UserId)) and (UserSetUp."Location Filter" <> '') then begin
            FilterGroup(2);
            SetFilter("Location Code", UserSetUp."Location Filter");
            FilterGroup(0);
        end;
    end;

    var
        UserMgt: Codeunit "User Setup Management";
}

