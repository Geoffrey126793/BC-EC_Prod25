page 50018 Questions
{
    Caption = 'Questions';
    PageType = List;
    SourceTable = Questions;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(DocumentNo; DocumentNo)
                {
                }
                field(QuestionID; QuestionID)
                {
                }
                field(boolValue; boolValue)
                {
                }
                field(Commentaire; Commentaire)
                {
                }
                field(Type; Type)
                {
                }
            }
        }
    }

    actions
    {
    }
}

