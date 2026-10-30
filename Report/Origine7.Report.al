report 50073 "Origine 7"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/Origine7.rdlc';

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = WHERE(Blocked = CONST(false));
            RequestFilterFields = "No.";
            column(Description_Item; Item.Description)
            {
            }
            column(No_Item; Item."No.")
            {
            }
            column(Origine; Origine)
            {
            }
            column(MP; MP)
            {
            }

            trigger OnAfterGetRecord()
            begin
                recItem.Reset;
                recItem.SetFilter("No.", Item."No.");
                if recItem.FindFirst then begin
                    MP := '';
                    Origine := '';
                    Codes.Reset;
                    Codes.SetRange("Table No", 27);
                    Codes.SetRange("Field No", 8001304);
                    Codes.SetRange(Code, recItem."Criteria 4");
                    if Codes.FindFirst then Origine := Codes.Description;
                    BOMBuf.Reset;
                    BOMBuf.DeleteAll;
                    CUBOM.SetItemFilter(recItem);
                    CUBOM.GenerateTreeForItems(recItem, BOMBuf, 0);
                    BOMBuf.SetFilter("No.", '7-C*');

                    if BOMBuf.FindSet then
                        repeat
                            if StrPos(MP, BOMBuf."No.") <= 0 then
                                MP += BOMBuf."No." + ' ';
                        until BOMBuf.Next = 0;

                end;
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
        recItem: Record Item;
        BOMBuf: Record "BOM Buffer" temporary;
        CUBOM: Codeunit "Calculate BOM Tree";
        MP: Text;
        Origine: Text;
        Codes: Record "Code";
}

