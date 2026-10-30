page 50022 UsersWS
{
    Caption = 'UsersWS';
    PageType = List;
    SourceTable = Employee;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field("First Name"; "First Name")
                {
                }
                field("Last Name"; "Last Name")
                {
                }
                field(User; User)
                {
                }
                field(InventoryScan; InventoryScan)
                {
                }
                field(Barcode; Barcode)
                {
                }
                field(Accueil; Accueil)
                {
                }
                field(Full_Name; Full_Name)
                {
                }
                field(PIN; PIN)
                {
                }
                field("Responsable tactile"; "Responsable tactile")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Full_Name := "Last Name" + ' ' + "First Name";
    end;

    var
        Full_Name: Text[250];
}

