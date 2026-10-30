pageextension 70155 pageextension70155 extends "Purch. Invoice Subform"
{
    layout
    {

        modify("Non Deductible VAT %")
        {
            Visible = true;
        }


        addafter("Appl.-to Item Entry")
        {
            field("Transport Customer No"; "Transport Customer No")
            {
            }
            field("Transport Customer Name"; "Transport Customer Name")
            {
            }
            field(Note; Note)
            {

            }
        }
    }



}

