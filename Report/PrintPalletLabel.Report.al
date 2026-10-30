report 50024 "Print Pallet Label"
{
    // // AC.FDQ 09/09/13 : Reformattage du report initial pour le passer en format 100 x 150 (l'ancien en A4
    //                      est sauvegardé en report 50099
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/PrintPalletLabel.rdlc';


    dataset
    {
        dataitem(Pallet; Pallet)
        {
            CalcFields = "Last Entry No.";
            RequestFilterFields = "SSCC No.";
            column(SSCC_No________; '*' + "SSCC No." + '*')
            {
            }
            column(Pallet__Item_No__; "Item No.")
            {
            }
            column(RecItem_g_Description; RecItem_g.Description)
            {
            }
            column(Pallet__Lot_No__; "Lot No.")
            {
            }
            column(Pallet_DLC; DLC)
            {
            }
            column(Pallet__Outbound_Document_No__; "Outbound Document No.")
            {
            }
            column(Pallet__Creation_Date_; "Creation Date")
            {
            }
            column(t_Weight; t_Weight)
            {
            }
            column(Pallet__Item_No__Caption; FieldCaption("Item No."))
            {
            }
            column(Pallet__Lot_No__Caption; FieldCaption("Lot No."))
            {
            }
            column(Pallet_DLCCaption; Pallet_DLCCaptionLbl)
            {
            }
            column(Pallet__Outbound_Document_No__Caption; Pallet__Outbound_Document_No__CaptionLbl)
            {
            }
            column(Pallet_SSCC_No_; "SSCC No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                if not RecItem_g.Get("Item No.") then
                    CurrReport.Skip;

                CalcFields("Current Quantity");
                if "Current Quantity" = 0 then
                    t_Weight := '     Kg'
                else
                    t_Weight := Format("Current Quantity") + ' Kg';
                //ILE.RESET;
                //ILE.SETCURRENTKEY("Item No.",Open,"Variant Code",Positive,"Location Code",
                //                  "Posting Date","Expiration Date","Lot No.","Serial No.","On Boat");
                //ILE.SETRANGE("Item No.",Pallet."Item No.");
                //ILE.SETRANGE("Lot No.",Pallet."Lot No.");
                //ILE.FIND('+');
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
        RecItem_g: Record Item;
        PalletEntry: Record "Pallet Ledger Entry";
        ILE: Record "Item Ledger Entry";
        t_Weight: Text[30];
        Pallet_DLCCaptionLbl: Label 'Date garantie';
        Pallet__Outbound_Document_No__CaptionLbl: Label 'Doc. Entrée';
}

