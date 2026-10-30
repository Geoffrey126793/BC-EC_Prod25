report 50070 CGV
{
    RDLCLayout = './Report/rdlc/CGV.rdlc';
    DefaultLayout = Word;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }
}

