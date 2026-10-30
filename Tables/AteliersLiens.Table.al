table 50025 "Ateliers Liens"
{
    Caption = 'Ateliers Liens';

    fields
    {
        field(1; Article; Code[20])
        {
            Caption = 'Article';
        }
        field(2; "Centre de charges"; Code[20])
        {
            Caption = 'Centre de charges';
            TableRelation = "Work Center" WHERE("Work Center Group Code" = CONST('ATELIERS'));
        }
        field(3; "Pondération"; Decimal)
        {
            Caption = 'Pondération';
        }
        field(4; "Début"; Date)
        {
            Caption = 'Début';
        }
        field(5; Fin; Date)
        {
            Caption = 'Fin';
        }
        field(6; "Description centre"; Text[100])
        {
            CalcFormula = Lookup("Work Center".Name WHERE("No." = FIELD("Centre de charges")));
            Caption = 'Description centre';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; Article, "Centre de charges", "Début")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        Matrice.Reset;
        Matrice.SetRange(Article, Article);
        Matrice.SetRange("Centre de charges", "Centre de charges");
        if Matrice.FindSet then
            repeat
                if (Matrice.Fin = 0D) or ((Matrice.Début <= Rec.Fin) and ((Matrice.Fin = 0D) or (Matrice.Fin >= Rec.Début))) then
                    Error('Il y a déjà une valeur pour cette période');
            until Matrice.Next = 0;
    end;

    trigger OnModify()
    begin
        Matrice.Reset;
        Matrice.SetRange(Article, Article);
        Matrice.SetRange("Centre de charges", "Centre de charges");
        Matrice.SetFilter(Début, '<>%1', xRec.Début);
        if Matrice.FindSet then
            repeat
                if (Matrice.Fin = 0D) or ((Matrice.Début <= Rec.Fin) and ((Matrice.Fin = 0D) or (Matrice.Fin >= Rec.Début))) then
                    Error('Il y a déjà une valeur pour cette période');
            until Matrice.Next = 0;
    end;

    var
        Matrice: Record "Ateliers Liens";

    [Scope('OnPrem')]
    procedure Copie(ItemSrc: Code[20]; ItemDst: Code[20])
    var
        LiensSrc: Record "Ateliers Liens";
        LiensDst: Record "Ateliers Liens";
    begin
        LiensDst.Reset;
        LiensDst.SetRange(Article, ItemDst);
        LiensDst.DeleteAll;

        LiensSrc.Reset;
        LiensSrc.SetRange(Article, ItemSrc);
        if LiensSrc.FindSet then
            repeat
                LiensDst.Init;
                LiensDst.TransferFields(LiensSrc, true);
                LiensDst.Article := ItemDst;
                LiensDst.Insert;
            until LiensSrc.Next = 0;
    end;
}

