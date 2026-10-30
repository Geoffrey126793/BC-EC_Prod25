report 50078 Pallet150
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/Pallet150.rdlc';

    dataset
    {
        dataitem(Pallet; Pallet)
        {
            column(SSCCNo_Pallet; Pallet."SSCC No.")
            {
            }
            column(ItemNo_Pallet; Pallet."Item No.")
            {
            }
            column(LotNo_Pallet; Pallet."Lot No.")
            {
            }
            column(DLC_Pallet; Pallet.DLC)
            {
            }
            column(ItemDescription_Pallet; Pallet."Item Description")
            {
            }
            column(Quantitereception_Pallet; Pallet."Quantite reception")
            {
            }
            column(Qty; Qty)
            {
            }
            column(Ordre; Ordre)
            {
            }

            trigger OnAfterGetRecord()
            var
                recOF: Record "Production Order";
                Items: Record Item;
            begin
                Ordre := '';
                Qty := '';

                if (Pallet."Outbound Document No." <> '') then
                    Ordre := Pallet."Outbound Document No.";

                if (recOF.Get(recOF.Status::Released, Pallet."Inbound Document No.")) then
                    if (recOF.Ordre <> '') then
                        Ordre := Ordre + ' ' + recOF.Ordre;

                if Pallet."Quantite reception" > 0 then begin
                    Qty := '';

                    if Items.Get(Pallet."Item No.") then
                        Qty := Qty + Format(Pallet."Quantite reception") + ' ' + Items."Base Unit of Measure"
                    else
                        Qty := Qty + Format(Pallet."Quantite reception") + ' Kg';
                end
                else begin
                    Qty := 'Ref ' + Pallet.NumOF;
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
        Ordre: Text;
        Qty: Text;
}

