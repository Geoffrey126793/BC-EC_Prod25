report 50079 "CB employee"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/CBemployee.rdlc';

    dataset
    {
        dataitem(Employee; Employee)
        {
            column(Employee__No__; "No.")
            {
            }
            column(Employee__First_Name_; "First Name")
            {
            }
            column(Employee__Last_Name_; "Last Name")
            {
            }
            column(Employee_Barcode; Barcode)
            {
            }
            column(Employee_User; User)
            {
            }
            column(tmp_EAN13; tmp_EAN13)
            {
            }

            trigger OnAfterGetRecord()
            begin
                tmp_EAN13 := CuUtils.EAN13GetDisplay(Barcode);
            end;
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

    var
        tmp_EAN13: Text[30];
        CuUtils: Codeunit Utils;
}

