pageextension 70116 pageextension70116 extends "VAT Statement Preview"
{
    actions
    {
        addfirst(processing)
        {
            action(Consolider)
            {
                Caption = 'Consolider';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Report "Consolidation TVA";
            }
            action("Détail consolidation/rubrique")
            {
                Caption = 'Detail consolidation/rubrique';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Report "Consolidation TVA detail";
            }
        }
    }
}

