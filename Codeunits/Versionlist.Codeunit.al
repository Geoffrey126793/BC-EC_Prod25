codeunit 8001410 "Version list"
{
    // //VERSION GESWAY 01/12/01 ContrÔÇ£le de la Version List (appel depuis le CodeUnit 1)
    // 
    // Syntaxe de la version List  : XXXX.vv.rr
    //   XXXX est une suite de caractáres quelconques (sauf '.') et de longueur indiffÔÇÜrente (ex : REF3 ou NAVW13)
    //   vv est le numÔÇÜro de version
    //   rr est le numÔÇÜro de rÔÇÜvision optionnel (il n'y a pas de rÔÇÜvision .00)
    // 
    // La VersionList qui suit la REF3.01.05 est REF3.01.06 ou REF3.02
    //       et celle qui suit la REF3.02    est REF3.02.01 ou REF3.03
    // 
    // Une nouvelle VERSION inclut toutes les REVISIONs intermÔÇÜdiaires.
    // Ainsi par exemple, tous les objets REF3.01.01 ÔÇª REF3.01.99 deviennent REF3.02.
    // Par contre les objets REF3.01 sont inchangÔÇÜs.


    trigger OnRun()
    var
        lNextVersion: Text[80];
        lNextRevision: Text[80];
    begin
        Object.Get(Object.Type::Table, '', 8001410);
        if not VersionList.Find('+') then
            InsertVersionList(1)
        else
            if Object."Version List" = VersionList."Version List" then begin
                exit
            end else begin
                NextVersionList(VersionList."Version List", lNextRevision, lNextVersion);
                if (Object."Version List" = lNextRevision) or (Object."Version List" = lNextVersion) or
                  (VersionList."Version List" = CopyStr(Object."Version List", 1, StrLen(Object."Version List") - 1)) then
                    InsertVersionList(VersionList."Entry ID" + 1)
                else
                    Error(tVersionOrder, VersionList."Version List", Object."Version List");
            end;
    end;

    var
        "Object": Record "Object";
        VersionList: Record "Version List";
        tVersionOrder: Label 'Versions was not installed in proped order.\You can''t upgrade from %1 to %2.';
        tDotCount: Label 'Version List : %1 must be format as XXX9.99 or XXX9.99.99';
        tSyntaxError: Label 'Version List %1 Syntax Error (XXXX.vv.rr)';

    [Scope('OnPrem')]
    procedure NextVersionList(pVersionList: Text[80]; var pNextRevision: Text[80]; var pNextVersion: Text[80])
    var
        i: Integer;
        j: Integer;
        lRevision: Text[80];
        lVersion: Text[80];
    begin
        i := StrPos(pVersionList, '.');
        if (i = 0) or (StrPos(pVersionList, ',') <> 0) then
            Error(tSyntaxError, pVersionList);
        j := StrPos(CopyStr(pVersionList, i + 1), '.');
        if j = 0 then begin
            lVersion := CopyStr(pVersionList, i + 1);
            lRevision := '00';
        end else begin
            lVersion := CopyStr(pVersionList, i + 1, j - 1);
            lRevision := CopyStr(pVersionList, i + j + 1);
        end;
        pNextRevision := CopyStr(pVersionList, 1, i - 1) + '.' + lVersion + '.' + IncStr(lRevision);
        pNextVersion := CopyStr(pVersionList, 1, i - 1) + '.' + IncStr(lVersion);
    end;

    [Scope('OnPrem')]
    procedure InsertVersionList(EntryID: Integer)
    begin
        VersionList."Entry ID" := EntryID;
        VersionList."Version List" := Object."Version List";
        VersionList.Date := Today;
        VersionList.Time := Time;
        VersionList.Insert;
    end;
}

