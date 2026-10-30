table 50022 "Scan User Setup"
{
    // //AB6.VIR.220310 SEC Ajout champ
    //   50006 Location Filter : Permet de filtrer les listes de commandes, OF selon le magasin de l'utilisateur
    // //AB6.VIR.010410 SEC Ajout champ
    //   50007 Purchase Filter : Permet de filtrer les listes de commandes achat selon le magasin de l'utilisateur

    Caption = 'User Setup';

    fields
    {
        field(1; "User ID"; Code[50])
        {
            Caption = 'User ID';
            NotBlank = true;
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                LoginMgt: Codeunit "User Management";
            begin
                //LoginMgt.LookupUserID("User ID");
            end;

            trigger OnValidate()
            var
                LoginMgt: Codeunit "User Management";
            begin
                //LoginMgt.ValidateUserID("User ID");
            end;
        }
        field(2; "Allow Palet Info"; Boolean)
        {
            Caption = 'Allow Palet Info';
        }
        field(3; "Allow Put-Away"; Boolean)
        {
            Caption = 'Allow Put-Away';
        }
        field(100; "Jnl Template Name"; Code[10])
        {
            Caption = 'Jnl Template Name';
            TableRelation = "Item Journal Template";
        }
        field(101; "Jnl Batch Name"; Code[10])
        {
            Caption = 'Jnl Batch Name';
            TableRelation = "Item Journal Batch".Name WHERE ("Journal Template Name" = FIELD ("Jnl Template Name"));
        }
        field(500; "Location code"; Code[10])
        {
            Caption = 'Location code';
            TableRelation = Location;
        }
    }

    keys
    {
        key(Key1; "User ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

