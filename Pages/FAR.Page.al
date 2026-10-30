page 50062 FAR
{
    Caption = 'FAR : Factures à recevoir';
    PageType = List;
    SourceTable = FAR;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            field("Date de fin"; DtEnd)
            {
            }
            repeater(Group)
            {
                field("Document No."; "Document No.")
                {
                }
                field("Line No."; "Line No.")
                {
                }
                field(Type; Type)
                {
                }
                field("No."; "No.")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Expected Receipt Date"; "Expected Receipt Date")
                {
                }
                field(Description; Description)
                {
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Unit Cost (LCY)"; "Unit Cost (LCY)")
                {
                }
                field("Qty. Rcd. Not Invoiced"; "Qty. Rcd. Not Invoiced")
                {
                }
                field("Quantity Invoiced"; "Quantity Invoiced")
                {
                }
                field("Order No."; "Order No.")
                {
                }
                field("Order Line No."; "Order Line No.")
                {
                }
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                {
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Responsibility Center"; "Responsibility Center")
                {
                }
                field("Item Category Code"; "Item Category Code")
                {
                }
                field("Buy-from Vendor Name"; "Buy-from Vendor Name")
                {
                }
                field("Total FAR"; "Total FAR")
                {
                }
                field("Status facture"; "Status facture")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Générer la liste")
            {

                trigger OnAction()
                begin
                    CuFAR.GenerateFARList(DtEnd);
                end;
            }
            action("Envoyer en compta")
            {

                trigger OnAction()
                begin
                    CuFAR.FARToGL(DtEnd);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetFilter("Status facture", '%1', "Status facture"::"A recevoir");
    end;

    var
        DtEnd: Date;
        CuFAR: Codeunit FAR;
}

