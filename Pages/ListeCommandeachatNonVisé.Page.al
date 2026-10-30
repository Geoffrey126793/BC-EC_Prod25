page 50013 "Liste Commande achat Non Visé"
{
    Caption = 'Liste Commande achat Non Visé';
    CardPageID = "Purchase Order";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Purchase Header";
    SourceTableView = SORTING("Document Type", "No.")
                      ORDER(Ascending)
                      WHERE("Document Type" = FILTER(Order | "Blanket Order"),
                            "Status Visa" = CONST("On standby visa "),
                            Status = CONST(Released));
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
                field("No."; "No.")
                {
                }
                field("Pay-to Vendor No."; "Pay-to Vendor No.")
                {
                }
                field("Purchaser Code"; "Purchaser Code")
                {
                }
                field("Pay-to Name"; "Pay-to Name")
                {
                }
                field("Order Date"; "Order Date")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field(Amount; Amount)
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Viser)
            {
                Caption = 'Viser';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'F11';

                trigger OnAction()
                var
                    smtp: Codeunit "EMail";
                    emailMsg: Codeunit "Email Message";
                begin

                    if AB6Tool.GetRole('VISAA') then begin
                        Rec.CalcFields(Amount);
                        if ("Status Visa" <> "Status Visa"::"Visa authorized") then begin
                            "Status Visa" := "Status Visa"::"Visa authorized";
                            "Date Visa" := WorkDate;
                            "Person in charge Visa" := UserId;
                            if UpperCase(UserId) <> 'EUROPACUISSON\BENOITC' then begin
                                "Status Visa2" := "Status Visa"::"Visa authorized";
                                "Date Visa2" := WorkDate;
                                "Person in charge Visa2" := UserId;
                            end;
                            Validate(Status, Status::Released);
                            if (Rec."Type commande" = Rec."Type commande"::Qualite) or (Rec."Type commande" = Rec."Type commande"::Production) or (Rec."Type commande" = Rec."Type commande"::Logistique) or (Rec."Type commande" = Rec."Type commande"::Securite) then begin
                                emailMsg.Create('YannFoucray@europacuisson.com', 'Validation Nouaim', 'Commande visée');
                                smtp.Send(emailMsg, Enum::"Email Scenario"::Default);
                            end;

                            Modify;
                        end else begin
                            "Status Visa" := "Status Visa"::"On standby visa ";
                            "Date Visa" := 0D;
                            "Person in charge Visa" := '';
                            Modify;
                        end;
                    end
                    else begin

                        Error(Text50000);
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        UserSetUp: Record "User Setup";
    begin
        //AB6.VIR.040110 --->
        if (UserSetUp.Get(UserId)) and (UserSetUp."Purchase Filter" <> '') then begin
            FilterGroup(2);
            SetFilter("Responsibility Center", UserSetUp."Purchase Filter");
            FilterGroup(0);
        end;
        if (UserSetUp.Get(UserId)) and (UserSetUp."Location Filter" <> '') then begin
            FilterGroup(2);
            SetFilter("Location Code", UserSetUp."Location Filter");
            FilterGroup(0);
        end;

        if UserId = 'EUROPACUISSON\NOUAIMH' then begin
            FilterGroup(2);
            SetFilter("Type commande", '%1|%2|%3|%4|%5', "Type commande"::Qualite, "Type commande"::Production, "Type commande"::Logistique, "Type commande"::Securite, "Type commande"::Technique);
            FilterGroup(0);
        end;
        //AB6.VIR.040110 <---
    end;

    var
        UserMgt: Codeunit "User Setup Management";
        AB6Tool: Codeunit "Absys - tools PJ";
        Text50000: Label 'Vous n''avez pas le droit de modifier le visa d''une commande d''achat.';
}

