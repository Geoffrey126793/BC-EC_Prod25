table 8001408 "Add-On Licence"
{
    // //+BGW GESWAY 01/11/99 Add-On Licence
    //               24/03/04 Suppression de la variale report8001300 inutilisÚe et dÚpendante de StatsExplorer

    Caption = 'Add-On Licence';
    DataPerCompany = false;

    fields
    {
        field(1; "Granule ID"; Code[20])
        {
            Caption = 'Granule ID';
        }
        field(2; "Licence ID"; Code[30])
        {
            Caption = 'Licence ID';
        }
        field(10; "Granule Key"; Code[20])
        {
            Caption = 'Granule KEY';
        }
    }

    keys
    {
        key(Key1; "Granule ID", "Licence ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

