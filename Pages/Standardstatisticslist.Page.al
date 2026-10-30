page 8001305 "Standard statistics list"
{
    // //STATSEXPLORER STATSEXPLORER 20/01/00 Standard statistics list

    Caption = 'Standard statistics list';
    CardPageID = "Standard statistic card";
    PageType = List;
    SourceTable = "Standard statistic";

    layout
    {
        area(content)
        {
            repeater(Liste)
            {
                field("Code"; Code)
                {
                }
                field(Name; Name)
                {
                }
                field("Catégory"; Catégory)
                {
                }
                field("Column Layout Name"; "Column Layout Name")
                {
                }
                field("Other Companies"; "Other Companies")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Statistic")
            {
                Caption = '&Statistic';
                action("A&utorisations")
                {
                    Caption = 'A&utorisations';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Statistics Permissions";
                    RunPageLink = Type = FILTER (Statistique),
                                  Code = FIELD (Code);
                }
                action("&Copy")
                {
                    Caption = '&Copy';
                    Image = Copy;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Report "Copy standard statistic";
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if GetFilter(Catégory) <> '' then
            FiltreCategorie := GetFilter(Catégory);

        if (not MembreSecurite.WritePermission) and (FindFirst) and (StrPos(CompanyName, 'CRONUS') <> 1) then begin
            repeat
                if PermissionStatistique.Autorisation(PermissionStatistique.Type::Statistique, Code, UserId) then
                    Mark(true);
            until Next = 0;
            FindFirst;
            MarkedOnly(true);
        end;
    end;

    var
        PermissionStatistique: Record "Statistic Permission";
        MembreSecurite: Record "Access Control";
        FiltreCategorie: Text[30];

    local procedure FiltreCategorieOnAfterValidate()
    begin
        CurrPage.Update(false);
    end;
}

