xmlport 50029 "Transport ACHAT maj"
{
    Direction = Import;
    FieldSeparator = ';';
    Format = VariableText;

    schema
    {
        textelement(root)
        {
            tableelement(Transport; Transport)
            {
                XmlName = 'Transport';
                fieldelement(Type; Transport.Type)
                {
                }
                fieldelement(Territorycode; Transport."Territory code")
                {
                }
                textelement(Typetransport)
                {
                }
                fieldelement(Palettstype; Transport."Paletts type")
                {
                }
                fieldelement(NumberofPallets; Transport."Number of Pallets")
                {
                }
                fieldelement(Currencycode; Transport."Currency code")
                {
                }
                fieldelement(Startingdate; Transport."Starting date")
                {
                }
                fieldelement(Enddate; Transport."End date")
                {
                }
                fieldelement(NettoPrice; Transport."Netto Price")
                {
                }
                textelement(trfrais)
                {
                }
                fieldelement(ShippingAgentCode; Transport."Shipping Agent Code")
                {
                }

                trigger OnAfterInitRecord()
                begin

                    Transport."Territory code" := '';
                    Transport."Paletts type" := '';
                    Transport."Number of Pallets" := 0;
                    Transport."Currency code" := '';
                    Transport."Starting date" := 0D;
                    Transport."End date" := 0D;
                    Transport."Paletts / Price" := 0;
                    Transport.Transport := '';
                    Transport."Shipping Agent Code" := '';
                end;

                trigger OnBeforeInsertRecord()
                var
                    tpt: Record Transport;
                begin
                    Transport."Type transport" := Transport."Type transport"::Frais;
                    if StrPos(Typetransport, 'Surge') > 0 then
                        Transport."Type transport" := Transport."Type transport"::"Surgelé";


                    if tpt.Get(Transport.Type, Transport."Territory code", Transport."Type transport", Transport."Paletts type",
                      Transport."Number of Pallets", Transport."Currency code", Transport."Starting date",
                      Transport."Shipping Agent Code") then
                        tpt.Delete;
                    Transport."Paletts / Price" := Transport."Netto Price";
                end;
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

    trigger OnPreXmlPort()
    begin
        Transport.SetRange(Type, Transport.Type::Achats);
    end;

    var
        trfrais1: Text;
}

