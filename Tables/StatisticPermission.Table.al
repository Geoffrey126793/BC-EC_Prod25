table 8001310 "Statistic Permission"
{
    // //STATSEXPLORER STATSEXPLORER 01/10/01 Statistic Permission

    Caption = 'Statistic Permission';

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Statistic,Category';
            OptionMembers = Statistique,"Catégorie";
        }
        field(10; "Code"; Code[10])
        {
            Caption = 'Code';
            TableRelation = IF (Type = FILTER(Statistique)) "Standard statistic".Code
            ELSE
            IF (Type = FILTER("Catégorie")) "Statistic category".Code;
        }
        field(20; "Authorized group"; Code[20])
        {
            Caption = 'Authorized group';
        }
    }

    keys
    {
        key(Key1; Type, "Code", "Authorized group")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    [Scope('OnPrem')]
    procedure Autorisation(TypeSecurite: Option Statistique,"Catégorie"; CodeStatistique: Code[10]; User: Code[50]) Permission: Boolean
    var
        StatistiquePredefinie: Record "Standard statistic";
        lSID: Text[100];
        lLoginMgt: Codeunit "User Management";
    begin

        Reset;
        //lSID := lLoginMgt.GetSID(USERID);

        exit(WINAutorisation(TypeSecurite, CodeStatistique, UserId))
    end;

    [Scope('OnPrem')]
    procedure DBAutorisation(TypeSecurite: Option Statistique,"Catégorie"; CodeStatistique: Code[10]; User: Code[50]) Permission: Boolean
    var
        StatistiquePredefinie: Record "Standard statistic";
        lSID: Text[100];
        lLoginMgt: Codeunit "User Management";
    begin
        /*RESET;
        // Recherche des administrateurs
        MembreSecurite.SETRANGE("User ID",User);
        MembreSecurite.SETFILTER("Role ID",'%1','SUPER*');
        IF NOT MembreSecurite.ISEMPTY THEN
           EXIT(TRUE);
        
        MembreSecurite.SETRANGE(Company,COMPANYNAME);
        IF NOT MembreSecurite.ISEMPTY THEN
           EXIT(TRUE);
        MembreSecurite.RESET;
        
        //IF (MembreSecurite.WRITEPERMISSION) OR (NOT FIND('-')) OR (STRPOS(COMPANYNAME,'CRONUS') = 1) THEN
        IF ISEMPTY OR (STRPOS(COMPANYNAME,'CRONUS') = 1) THEN
           EXIT(TRUE)
        ELSE BEGIN
        // On recherche une permission sur la stat
           SETRANGE(Type,TypeSecurite);
           SETRANGE(Code,CodeStatistique);
           IF NOT ISEMPTY THEN BEGIN
              FINDFIRST;
              REPEAT
               IF MembreSecurite.GET(User,"Authorized group") THEN
                  EXIT(TRUE);
               IF MembreSecurite.GET(User,"Authorized group",COMPANYNAME) THEN
                  EXIT(TRUE);
              UNTIL (NEXT = 0) OR (Permission);
           END;
        
        // Sinon on recherche une permission sur la catégorie
              IF (StatistiquePredefinie.GET(CodeStatistique))AND(StatistiquePredefinie.Catégory <> '') THEN BEGIN
                 SETRANGE(Type,Type::Catégorie);
                 SETRANGE(Code,StatistiquePredefinie.Catégory);
                 IF NOT ISEMPTY THEN BEGIN
                    FINDFIRST;
                    REPEAT
                      IF MembreSecurite.GET(User,"Authorized group") THEN
                         EXIT(TRUE);
                      IF MembreSecurite.GET(User,"Authorized group",COMPANYNAME) THEN
                         EXIT(TRUE);
                    UNTIL (NEXT = 0) OR (Permission);
                 END;
              END;
        
              EXIT(FALSE);
        END;
         */

    end;

    [Scope('OnPrem')]
    procedure WINAutorisation(TypeSecurite: Option Statistique,"Catégorie"; CodeStatistique: Code[10]; User: Text[100]) Permission: Boolean
    var
        WindowsAccessCtrl: Record "Access Control";
        StatistiquePredefinie: Record "Standard statistic";
    begin
        Reset;
        // Recherche des administrateurs
        WindowsAccessCtrl.SetRange("User Name", User);
        WindowsAccessCtrl.SetFilter("Role ID", '%1', 'SUPER*');
        if not WindowsAccessCtrl.IsEmpty then
            exit(true);

        WindowsAccessCtrl.SetRange("Company Name", CompanyName);
        if not WindowsAccessCtrl.IsEmpty then
            exit(true);
        WindowsAccessCtrl.Reset;

        //IF (WindowsAccessCtrl.WRITEPERMISSION) OR (NOT FIND('-')) OR (STRPOS(COMPANYNAME,'CRONUS') = 1) THEN
        if IsEmpty or (StrPos(CompanyName, 'CRONUS') = 1) then
            exit(true)
        else begin
            // On recherche une permission sur la stat
            SetRange(Type, TypeSecurite);
            SetRange(Code, CodeStatistique);
            if not IsEmpty then begin
                FindFirst;
                repeat
                    //////////////////////////
                    // EXIT(TRUE);
                    WindowsAccessCtrl.Reset;
                    WindowsAccessCtrl.SetRange("User Name", User);
                    WindowsAccessCtrl.SetRange("Role ID", "Authorized group");
                    if WindowsAccessCtrl.FindFirst then
                        exit(true);

                until (Next = 0) or (Permission);
            end;

            // Sinon on recherche une permission sur la catégorie
            if (StatistiquePredefinie.Get(CodeStatistique)) and (StatistiquePredefinie.Catégory <> '') then begin
                SetRange(Type, Type::"Catégorie");
                SetRange(Code, StatistiquePredefinie.Catégory);
                if not IsEmpty then begin
                    FindFirst;
                    repeat
                        WindowsAccessCtrl.Reset;
                        WindowsAccessCtrl.SetRange("User Name", User);
                        WindowsAccessCtrl.SetRange("Role ID", "Authorized group");
                        if WindowsAccessCtrl.FindFirst then
                            exit(true);
                    ////////
                    //EXIT(TRUE);
                    until (Next = 0) or (Permission);
                end;
            end;

            exit(false);
        end;
    end;
}

