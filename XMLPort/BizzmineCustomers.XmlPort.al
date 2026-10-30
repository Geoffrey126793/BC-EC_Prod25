xmlport 50002 "Bizzmine Customers"
{
    Direction = Export;
    FieldDelimiter = '<None>';
    FieldSeparator = ';';
    FileName = '\\srvnavision\NavisionTemp\test\Customerss.csv';
    Format = VariableText;
    FormatEvaluate = Legacy;
    TableSeparator = '<NewLine>';
    TextEncoding = UTF16;
    UseRequestPage = false;

    schema
    {
        textelement("<root>")
        {
            XmlName = 'Root';
            tableelement(Integer; Integer)
            {
                XmlName = 'Header';
                SourceTableView = WHERE (Number = CONST (1));
                textelement(No)
                {

                    trigger OnBeforePassVariable()
                    begin
                        No := 'N°';
                    end;
                }
                textelement(desc)
                {

                    trigger OnBeforePassVariable()
                    begin
                        desc := 'Nom';
                    end;
                }
                textelement(Pays)
                {

                    trigger OnBeforePassVariable()
                    begin
                        Pays := 'Code Pays/région';
                    end;
                }
                textelement(Lng)
                {

                    trigger OnBeforePassVariable()
                    begin
                        Lng := 'Code langue';
                    end;
                }
            }
            tableelement(Customer; Customer)
            {
                XmlName = 'Items';
                fieldelement(No; Customer."No.")
                {
                }
                fieldelement(Name; Customer.Name)
                {

                    trigger OnBeforePassField()
                    begin
                        Customer.Name := DelChr(Customer.Name, '=', '"');
                    end;
                }
                fieldelement(Pays; Customer."Country/Region Code")
                {
                }
                fieldelement(Lng; Customer."Language Code")
                {
                }
            }
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
}

