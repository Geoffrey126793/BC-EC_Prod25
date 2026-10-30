pageextension 70104 pageextension70104 extends "Item Journal"
{
    actions
    {

        modify("Post")
        {
            trigger OnBeforeAction()
            begin
                if not AB6Tools.GetRole('AJUSTEMENTS') then
                    Error('Vous n''avez pas le droit de valider');
            end;
        }

        modify("Post and &Print")
        {

            trigger OnBeforeAction()
            begin
                if not AB6Tools.GetRole('AJUSTEMENTS') then
                    Error('Vous n''avez pas le droit de valider');
            end;
        }

    }

    var
        AB6Tools: Codeunit "Absys - tools PJ";
}

