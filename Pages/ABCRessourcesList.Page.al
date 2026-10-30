page 50053 "ABC - Ressources List"
{
    CardPageID = "ABC - Ressources Card";
    PageType = List;
    SourceTable = "ABC - Ressources";
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
                field("Description 2"; "Description 2")
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
                    P50058: Page "ABC - Parametres cas";
                begin
                    P50058.setRessource(Rec.Code);
                    P50058.RunModal();
                end;
            }
        }
    }
}

