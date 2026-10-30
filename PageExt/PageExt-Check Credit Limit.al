pageextension 70095 pageextension70095 extends "Check Credit Limit"
{
    layout
    {
        addafter(CreditLimitDetails)
        {
            field("Groupe.Code"; Groupe.Code)
            {
                Caption = 'Groupe crédit autorisé';
            }
            field("Groupe.Désignation"; Groupe.Désignation)
            {
                Caption = 'Désignation';
            }
            field("Groupe.""Total  soldes (DS)"""; Groupe."Total  soldes (DS)")
            {
                Caption = 'Total Solde DS';
            }
            field("Groupe.""Total cde ouverte (DS)"""; Groupe."Total cde ouverte (DS)")
            {
                Caption = 'Total Mt en cde DS';
            }
            field("Groupe.""Total livré non fact (DS)"""; Groupe."Total livré non fact (DS)")
            {
                Caption = 'Total livré non fact DS';
            }
            field(MontantTotalGroupe; MontantTotalGroupe)
            {
                Caption = 'Montant total DS';
            }
            field("Groupe.""Créd. total autorisé (DS)"""; Groupe."Créd. total autorisé (DS)")
            {
                Caption = 'Crédit total autorisé DS';
            }
        }
    }

    var
        Groupe: Record "Groupe crédit autorisé";
        MontantTotalGroupe: Decimal;
        Text005: Label 'Le crédit autorisé du groupe a été dépassé.';

    var
        Text006: Label 'Le crédit autorisé du client a été dépassé et le crédit autorisé du groupe a été dépassé.';
        Text007: Label 'Ce client a des écritures échues et le crédit autorisé du groupe a été dépassé.';
        Text008: Label 'Il existe des écritures échues pour ce client, sa limite de crédit a été dépassée et le crédit autorisé du groupe a été dépassé.';



    trigger OnAfterGetRecord()
    begin
        CalculerAlerteSaisieGroupe();
    end;

    procedure CalculerAlerteSaisieGroupe()
    begin
        Clear(Groupe);
        MontantTotalGroupe := 0;

        if "Groupe crédit autorisé" <> '' then begin
            if Groupe.Get("Groupe crédit autorisé") then begin
                Groupe.CalcAlerteSaisie();
                //MontantTotalGroupe :=
                //Groupe."Total  soldes (DS)" + Groupe."Total livré non fact (DS)" + Groupe."Total cde ouverte (DS)"
                //- OldOrderAmountLCY + NewOrderAmountLCY;
            end;
        end;
    end;
}

