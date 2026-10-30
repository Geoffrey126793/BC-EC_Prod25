report 50032 "Reception palettes"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/Receptionpalettes.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Purch. Rcpt. Header"; "Purch. Rcpt. Header")
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Buy-from Vendor No.", "Posting Date";
            column(Purch__Rcpt__Header__No__; "No.")
            {
            }
            column(Purch__Rcpt__Header__Buy_from_Vendor_No__; "Buy-from Vendor No.")
            {
            }
            column(Purch__Rcpt__Header__Buy_from_Vendor_Name_; "Buy-from Vendor Name")
            {
            }
            column(Purch__Rcpt__Header__Posting_Date_; "Posting Date")
            {
            }
            column(Purch__Rcpt__Header__Order_No__; "Order No.")
            {
            }
            dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = WHERE(Quantity = FILTER(> 0));
                PrintOnlyIfDetail = true;
                column(Purch__Rcpt__Line__No__; "No.")
                {
                }
                column(Purch__Rcpt__Line_Description; Description)
                {
                }
                column(Purch__Rcpt__Line_Quantity; Quantity)
                {
                }
                column(Purch__Rcpt__Line__Unit_of_Measure_; "Unit of Measure")
                {
                }
                column(Purch__Rcpt__Line_Document_No_; "Document No.")
                {
                }
                column(Purch__Rcpt__Line_Line_No_; "Line No.")
                {
                }
                dataitem(Pallet; Pallet)
                {
                    column(Pallet__SSCC_No__; "SSCC No.")
                    {
                    }
                    column(Pallet__Item_No__; "Item No.")
                    {
                    }
                    column(Pallet__Lot_No__; "Lot No.")
                    {
                    }
                    column(Pallet_DLC; DLC)
                    {
                    }
                    column(Pallet__Item_Description_; "Item Description")
                    {
                    }
                    column(Pallet__Nbre_bacs_reception_; "Nbre bacs reception")
                    {
                    }
                    column(Pallet__Type_bacs_reception_; "Type bacs reception")
                    {
                    }
                    column(Pallet__Type_palette_reception_; "Type palette reception")
                    {
                    }
                    column(Pallet__Temperature_reception_; "Temperature reception")
                    {
                    }
                    column(Pallet__Poids_brut_reception_; "Poids brut reception")
                    {
                    }
                    column(Pallet__Quantite_reception_; "Quantite reception")
                    {
                    }
                    column(Pallet__Quai_reception_Txt_; "Quai reception Txt")
                    {
                    }
                    column(Pallet__User_reception_Txt_; "User reception Txt")
                    {
                    }
                    column(Pallet__Type_bacs_Txt_; "Type bacs Txt")
                    {
                    }
                    column(Pallet__Type_palette_Txt_; "Type palette Txt")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        Pallet.CalcFields("User reception Txt");
                    end;

                    trigger OnPreDataItem()
                    begin
                        Pallet.Reset;
                        Pallet.SetFilter("Inbound Document No.", '%1', "Purch. Rcpt. Line"."Order No." + '*');
                        Pallet.SetRange("Inbound Doc. Line No.", "Purch. Rcpt. Line"."Order Line No.");
                        Pallet.SetRange("Creation Date", "Purch. Rcpt. Line"."Posting Date");
                        //MESSAGE('%1',"Purch. Rcpt. Line"."Order Line No.");
                    end;
                }
            }
            dataitem(Questions; Questions)
            {
                DataItemLink = DocumentNo = FIELD("No.");
                column(Questions_boolValue; boolValue)
                {
                }
                column(Questions_Commentaire; Commentaire)
                {
                }
                column(Questions_Texte; Texte)
                {
                }
                column(Questions_DocumentNo; DocumentNo)
                {
                }
                column(Questions_QuestionID; QuestionID)
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

    labels
    {
    }
}

