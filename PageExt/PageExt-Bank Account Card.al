pageextension 70098 pageextension70098 extends "Bank Account Card"
{

    layout
    {
        addafter(Transfer)
        {
            group(Logo)
            {
                Caption = 'Logo';
                field(Control1000000001; Logo)
                {
                }
            }
        }
    }
}

