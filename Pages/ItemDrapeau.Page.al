page 50034 "Item Drapeau"
{
    Caption = 'Item Picture';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Card;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            field(Drapeau; Drapeau)
            {
            }
        }
    }

    actions
    {
    }

    var
        Text001: Label 'Do you want to replace the existing picture of %1 %2?';
        Text002: Label 'Do you want to delete the picture of %1 %2?';
        PictureExists: Boolean;
}

