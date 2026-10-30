pageextension 70102 pageextension70102 extends "Phys. Inventory Journal"
{
    layout
    {
        addafter("Applies-to Entry")
        {
            field("Phys Inventory Lot No."; "Phys Inventory Lot No.")
            {
            }
        }
    }
    actions
    {
        modify("P&ost")
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

