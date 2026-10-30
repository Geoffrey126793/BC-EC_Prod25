page 50010 "Logistic Unit / Item"
{
    Caption = 'Logistic Unit / Item';
    PageType = List;
    SourceTable = "Unité logistique / article";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Logistic unit"; "Logistic unit")
                {
                }
                field("Item no"; "Item no")
                {
                }
                field("Palette weight"; "Palette weight")
                {
                }
            }
        }
    }

    actions
    {
    }
}

