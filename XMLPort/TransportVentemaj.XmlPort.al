xmlport 50028 "Transport Vente maj"
{
    Direction = Import;
    FieldSeparator = ';';
    Format = VariableText;

    schema
    {
        textelement(Root)
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
                fieldelement(StartingDate; Transport."Starting date")
                {
                }
                fieldelement(EndDate; Transport."End date")
                {
                }
                fieldelement(PalletsPrice; Transport."Paletts / Price")
                {
                }
                fieldelement(Transport; Transport.Transport)
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
                    if StrPos(UpperCase(Typetransport), 'SURGE') > 0 then
                        Transport."Type transport" := Transport."Type transport"::"Surgelé";

                    if tpt.Get(Transport.Type, Transport."Territory code", Transport."Type transport", Transport."Paletts type",
                      Transport."Number of Pallets", Transport."Currency code", Transport."Starting date",
                      Transport."Shipping Agent Code") then
                        tpt.Delete;
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

    trigger OnInitXmlPort()
    begin
        Transport.SetRange(Type, Transport.Type::Vente);
    end;

    var
        TypeTpt: Text[30];
}

