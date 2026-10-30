table 50007 "Groupe crédit autorisé"
{
    // ------------------------------------------------------------------------------------------------------------------------------------
    // ADV-004
    //   Encours crédit ABSYS GN 20061013
    //     Code Non Activé pour le moment
    //     - CalcAlerteLiv()
    //     - CalcTout()
    // ------------------------------------------------------------------------------------------------------------------------------------

    Caption = 'Groupe crédit autorisé';
    DrillDownPageID = "Historique Couts";
    LookupPageID = "Historique Couts";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; "Désignation"; Text[30])
        {
            Caption = 'Désignation';
        }
        field(3; "Créd. total autorisé (DS)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Créd. total autorisé (dev soc)';
        }
        field(4; "Total  soldes (DS)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total  soldes (dev soc)';
        }
        field(5; "Total livré non fact (DS)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total livré non fact (dev soc)';
        }
        field(6; "Total cde ouverte (DS)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total cde ouverte (dev soc)';
        }
        field(7; "Total en livraison (DS)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total en livraison (dev soc)';
        }
        field(8; "Total à mettre en li (DS)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total à mettre en li (dev soc)';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Client: Record Customer;
        "GroupeComptaMarchéTVA": Record "VAT Business Posting Group";

    [Scope('OnPrem')]
    procedure CalcTotalSoldes()
    begin
        "Total  soldes (DS)" := 0;
        Client.SetRange("Groupe crédit autorisé", Code);
        if Client.Find('-') then begin
            repeat
                Client.CalcFields("Balance (LCY)");
                "Total  soldes (DS)" := "Total  soldes (DS)" + Client."Balance (LCY)";
            until Client.Next = 0;
        end;
    end;

    [Scope('OnPrem')]
    procedure CalcAlerteSaisie()
    begin
        "Total  soldes (DS)" := 0;
        "Total livré non fact (DS)" := 0;
        "Total cde ouverte (DS)" := 0;
        //--> ADV-004 ABSYS GN 20061013
        Client.SetCurrentKey("Groupe crédit autorisé", Client."No.");
        //<-- ADV-004 ABSYS GN 20061013
        Client.SetRange("Groupe crédit autorisé", Code);
        if Client.Find('-') then begin
            repeat
                Client.CalcFields("Balance (LCY)", "Shipped Not Invoiced (LCY)", "Outstanding Orders (LCY)");
                "Total  soldes (DS)" := "Total  soldes (DS)" + Client."Balance (LCY)";
                "Total livré non fact (DS)" := "Total livré non fact (DS)" + Client."Shipped Not Invoiced (LCY)";
                "Total cde ouverte (DS)" := "Total cde ouverte (DS)" + Client."Outstanding Orders (LCY)";
            until Client.Next = 0;
        end;
    end;

    [Scope('OnPrem')]
    procedure CalcAlerteLiv()
    begin
        //--> ADV-004 ABSYS GN 20061013
        //-- NON ACTIVE POUR LE MOMENT  --
        /*
        "Total  soldes (dev soc)" := 0;
        "Total livré non fact (dev soc)" := 0;
        "Total en livraison (dev soc)" := 0;
        "Total à mettre en li (dev soc)":=0;
        Client.SETRANGE("Groupe crédit autorisé",Code);
        IF Client.FIND('-') THEN BEGIN
          REPEAT
            IF NOT GroupeComptaMarchéTVA.GET(Client."VAT Bus. Posting Group") THEN
              GroupeComptaMarchéTVA."% TVA par défaut" :=0;
            Client.CALCFIELDS("Balance (LCY)","Shipped Not Invoiced (LCY)",
            "Mt en livraison (dev soc)","Mt à mettre en livr. (dev soc)") ;
            "Total  soldes (dev soc)" := "Total  soldes (dev soc)" + Client."Balance (LCY)";
            "Total livré non fact (dev soc)" := "Total livré non fact (dev soc)" + Client."Shipped Not Invoiced (LCY)";
            "Total en livraison (dev soc)" := "Total en livraison (dev soc)" +
                        (Client."Mt en livraison (dev soc)"*((100+GroupeComptaMarchéTVA."% TVA par défaut")/100));
            "Total à mettre en li (dev soc)":="Total à mettre en li (dev soc)" +
                        (Client."Mt à mettre en livr. (dev soc)"*((100+GroupeComptaMarchéTVA."% TVA par défaut")/100));
          UNTIL Client.NEXT = 0;
        END;
        */
        //<-- ADV-004 ABSYS GN 20061013

    end;

    [Scope('OnPrem')]
    procedure CalcTout()
    begin
        //--> ADV-004 ABSYS GN 20061013
        //-- NON ACTIVE POUR LE MOMENT  --
        /*
        "Total  soldes (dev soc)" := 0;
        "Total livré non fact (dev soc)" := 0;
        "Total cde ouverte (dev soc)":=0;
        "Total en livraison (dev soc)" := 0;
        "Total à mettre en li (dev soc)":=0;
        Client.SETRANGE("Groupe crédit autorisé",Code);
        IF Client.FIND('-') THEN BEGIN
          REPEAT
            IF NOT GroupeComptaMarchéTVA.GET(Client."VAT Bus. Posting Group") THEN GroupeComptaMarchéTVA."% TVA par défaut" :=0;
            Client.CALCFIELDS("Balance (LCY)"
                              ,"Shipped Not Invoiced (LCY)","Outstanding Orders (LCY)"
                              ,"Mt en livraison (dev soc)","Mt à mettre en livr. (dev soc)") ;
            "Total  soldes (dev soc)" := "Total  soldes (dev soc)" + Client."Balance (LCY)";
            "Total livré non fact (dev soc)" := "Total livré non fact (dev soc)" + Client."Shipped Not Invoiced (LCY)";
            "Total cde ouverte (dev soc)":="Total cde ouverte (dev soc)" + Client."Outstanding Orders (LCY)";
            "Total en livraison (dev soc)" := "Total en livraison (dev soc)" +
                        (Client."Mt en livraison (dev soc)"*((100+GroupeComptaMarchéTVA."% TVA par défaut")/100));
            "Total à mettre en li (dev soc)":="Total à mettre en li (dev soc)" +
                        (Client."Mt à mettre en livr. (dev soc)"*((100+GroupeComptaMarchéTVA."% TVA par défaut")/100));
          UNTIL Client.NEXT = 0;
        END;
        */
        //<-- ADV-004 ABSYS GN 20061013

    end;
}

