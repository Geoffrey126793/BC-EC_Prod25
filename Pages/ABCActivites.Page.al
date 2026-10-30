page 50052 "ABC - Activites"
{
    PageType = List;
    SourceTable = "ABC - Activites";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Code)
                {
                }
                field(Description; Description)
                {
                }
                field(Atelier; Atelier)
                {
                }
                field(Imputation; Imputation)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Cas d'emploi")
            {

                trigger OnAction()
                var
                    param: Record "ABC - Parametres";
                    P50058: Page "ABC - Parametres cas";
                    VersionMgt: Codeunit VersionManagement;
                    paramTmp: Record "ABC - Parametres" temporary;
                begin
                    P50058.setActivity(Rec.Code);
                    P50058.RunModal();
                end;
            }
        }
    }
}

