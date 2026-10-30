pageextension 70059 pageextension70059 extends "General Ledger Entries"
{
    layout
    {
        addafter("External Document No.")
        {

            field("Document Date"; "Document Date")
            {
            }

            field(LibEcr; LibEcr)
            {
                Caption = 'Libellé ecriture';
            }
            field(Regroupement; Regroupement)
            {

            }
        }
    }

    var
        LibEcr: Text;


    trigger OnAfterGetRecord()
    var
        SalesInv: Record "Sales Invoice Header";
        PurchInv: Record "Purch. Inv. Header";
    begin

        LibEcr := '';
        if "Document Type" = "Document Type"::Invoice then
            if "Gen. Posting Type" = "Gen. Posting Type"::Purchase then begin
                if PurchInv.Get("Document No.") then
                    LibEcr := PurchInv."Posting Description";
            end
            else begin
                if "Gen. Posting Type" = "Gen. Posting Type"::Sale then
                    if SalesInv.Get("Document No.") then
                        LibEcr := SalesInv."Posting Description";

            end;
    end;
}

