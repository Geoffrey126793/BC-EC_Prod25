table 50023 Questions
{
    Caption = 'Questions';

    fields
    {
        field(1; DocumentNo; Code[30])
        {
            Caption = 'DocumentNo';
        }
        field(2; QuestionID; Code[10])
        {
            Caption = 'QuestionID';
        }
        field(3; boolValue; Boolean)
        {
            Caption = 'boolValue';
        }
        field(4; Commentaire; Text[250])
        {
            Caption = 'Commentaire';
        }
        field(5; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Boolean';
            OptionMembers = Boolean;
        }
        field(6; Texte; Text[250])
        {
            CalcFormula = Lookup (Questions.Commentaire WHERE (QuestionID = FIELD (QuestionID),
                                                              DocumentNo = CONST ('CONFIG')));
            Caption = 'Texte';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; DocumentNo, QuestionID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

