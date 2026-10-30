codeunit 8001402 Security
{
    // //BGW-PKI GESWAY 29/11/00 Gestion des sÔÇÜcuritÔÇÜs Add-On


    trigger OnRun()
    begin
    end;

    [Scope('OnPrem')]
    procedure CreerSecurite(Groupe: Code[20]; NomGroupe: Text[30]; TypeObjet: Option "Table Data","Table",Form,"Report",Dataport,"Codeunit",,,,,System; Lecture: Option " ",Oui,Indirect; Ecriture: Option " ",Oui,Indirect; NumeroTableDebut: Integer; NumeroTableFin: Integer)
    var

        Objet: Record "Object";
        NewTypeObjet: Option "Table Data","Table",Form,"Report",Dataport,"Codeunit",,,,,System;
    begin
        if (StrPos(CompanyName, 'CRONUS') = 1) then begin

            NewTypeObjet := TypeObjet;
            if NewTypeObjet = 0 then
                NewTypeObjet := 1;
            repeat
                if (NumeroTableDebut = 2000000001) or (TypeObjet = TypeObjet::System) or (Objet.Get(NewTypeObjet, '', NumeroTableDebut)) then
                    CreerAutorisation(Groupe, NumeroTableDebut, TypeObjet, Lecture, Ecriture);
                NumeroTableDebut := NumeroTableDebut + 1;
            until NumeroTableDebut > NumeroTableFin;
        end;
    end;

    [Scope('OnPrem')]
    procedure CreerAutorisation(Groupe: Code[20]; NumeroTable: Integer; TypeObjet: Option "Table Data","Table",Form,"Report",Dataport,"Codeunit",,,,,System; Lecture: Option " ",Oui,Indirect; Ecriture: Option " ",Oui,Indirect)

    begin

    end;
}

