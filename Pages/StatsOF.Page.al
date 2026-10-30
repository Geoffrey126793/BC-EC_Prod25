page 50065 "Stats OF"
{
    PageType = List;
    SourceTable = "Stats OF";
    SourceTableView = WHERE ("Type source" = CONST ('ARTICLE'));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("OF"; "OF")
                {
                }
                field(Date; Date)
                {
                }
                field("Quantite produite"; "Quantite produite")
                {
                }
                field(Article; Article)
                {
                }
                field(source; source)
                {
                }
                field("Quantité utilisee"; "Quantité utilisee")
                {
                }
                field(Lot; Lot)
                {
                }
                field(Niveau; Niveau)
                {
                }
                field(Direction; Direction)
                {
                }
                field("Quantité nomenclature"; "Quantité nomenclature")
                {
                }
                field("Quantité intermédiaire"; "Quantité intermédiaire")
                {
                }
                field(Ecriture; Ecriture)
                {
                }
                field("Quantité intermédiaire nomencl"; "Quantité intermédiaire nomencl")
                {
                }
                field("Quantité nomenclature OF"; "Quantité nomenclature OF")
                {
                }
                field(Cru; Cru)
                {
                }
                field("Quantité intermédiaire nom OF"; "Quantité intermédiaire nom OF")
                {
                }
                field(source2; source2)
                {
                }
            }
        }
    }

    actions
    {
    }
}

