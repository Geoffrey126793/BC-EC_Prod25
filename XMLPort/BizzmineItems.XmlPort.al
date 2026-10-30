xmlport 50001 "Bizzmine Items"
{
    Direction = Export;
    FieldDelimiter = '<None>';
    FieldSeparator = ';';
    FileName = '\\srvnavision\NavisionTemp\test\Items.csv';
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
                        desc := 'Désignation';
                    end;
                }
            }
            tableelement(Item; Item)
            {
                XmlName = 'Items';
                SourceTableView = WHERE ("No." = FILTER (<> ''), Blocked = CONST (false));
                fieldelement(No; Item."No.")
                {
                }
                fieldelement(Description; Item.Description)
                {

                    trigger OnBeforePassField()
                    begin
                        Item.Description := DelChr(Item.Description, '=', '"');
                    end;
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

