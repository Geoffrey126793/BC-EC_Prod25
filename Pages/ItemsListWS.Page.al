page 50006 "Items List WS"
{
    Caption = 'Items List WS';
    PageType = List;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Base Unit of Measure"; "Base Unit of Measure")
                {
                }
                field("Item Category Code"; "Item Category Code")
                {
                }
                field("Item Tracking Code"; "Item Tracking Code")
                {
                }
                field("Niveau allergene"; "Niveau allergene")
                {
                }
                field(Planning; Planning)
                {
                }
                field(Blocked; Blocked)
                {
                }
                field(Cadence; Cadence)
                {
                }
                field(Origine; Origine)
                {
                }
                field("Criteria 2"; "Criteria 2")
                {
                }
                field("Criteria 5"; "Criteria 5")
                {
                }
                field("Criteria 10"; "Criteria 10")
                {
                }
                field(Film; Film)
                {
                }
                field(Process; Process)
                {
                }
                field("Comment blocage lots produits"; "Comment blocage lots produits")
                {
                }
                field("Type de production"; "Type de production")
                {
                }
                field("Reorder Quantity"; "Reorder Quantity")
                {
                }
                field(Famille; "Criteria 15")
                {
                }
                field("Purchasing Blocked"; "Purchasing Blocked")
                {
                }
                field("Machines pour VP"; "Machines pour VP")
                {
                }
                field(First5; First5)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        cuProd: Codeunit "Integration Tft and Prod";
        BomH: Record "Production BOM Header";
    begin
        Origine := '';
        if recCodes.Get(27, 8001304, "Criteria 4") then
            Origine := recCodes.Description;

        Film := '';
        if recCodes.Get(27, 50061, "Criteria 12") then
            Film := recCodes.Description;
        First5 := '';
        if BomH.Get(Rec."Production BOM No.") then
            First5 := cuProd.GetFirst5(BomH, '');
    end;

    var
        Origine: Text[80];
        recCodes: Record "Code";
        Film: Text[80];
        First5: Code[20];
}

