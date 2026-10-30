report 50012 "Transfer Order EC"
{
    // 
    // //AB6.VIR  27/03/10  Ajout de l'impression de la traçabilité en expédition
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/TransferOrderEC.rdlc';

    Caption = 'Transfer Order';

    dataset
    {
        dataitem("Transfer Header"; "Transfer Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Transfer-from Code", "Transfer-to Code";
            RequestFilterHeading = 'Transfer Order';
            column(Transfer_Header_No_; "No.")
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                column(OutputNo; OutputNo)
                {
                }
                column(CopyLoop_Number; Number)
                {
                }
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(CompanyAddr_1_; CompanyAddr[1])
                    {
                    }
                    column(CompanyAddr_2_; CompanyAddr[2])
                    {
                    }
                    column(CompanyAddr_3_; CompanyAddr[3])
                    {
                    }
                    column(CompanyAddr_4_; CompanyAddr[4])
                    {
                    }
                    column(CompanyAddr_5_; CompanyAddr[5])
                    {
                    }
                    column(STRSUBSTNO_Text002_FORMAT_CurrReport_PAGENO__; StrSubstNo(Text002, '1'))
                    {
                    }
                    column(STRSUBSTNO_Text001__Transfer_Header___No___; StrSubstNo(Text001, "Transfer Header"."No."))
                    {
                    }
                    column(TransferToAddr_1_; TransferToAddr[1])
                    {
                    }
                    column(TransferFromAddr_1_; TransferFromAddr[1])
                    {
                    }
                    column(TransferToAddr_2_; TransferToAddr[2])
                    {
                    }
                    column(TransferFromAddr_2_; TransferFromAddr[2])
                    {
                    }
                    column(TransferToAddr_3_; TransferToAddr[3])
                    {
                    }
                    column(TransferFromAddr_3_; TransferFromAddr[3])
                    {
                    }
                    column(TransferToAddr_4_; TransferToAddr[4])
                    {
                    }
                    column(TransferFromAddr_4_; TransferFromAddr[4])
                    {
                    }
                    column(TransferToAddr_5_; TransferToAddr[5])
                    {
                    }
                    column(TransferToAddr_6_; TransferToAddr[6])
                    {
                    }
                    column(TransferToAddr_7_; TransferToAddr[7])
                    {
                    }
                    column(TransferToAddr_8_; TransferToAddr[8])
                    {
                    }
                    column(TransferFromAddr_5_; TransferFromAddr[5])
                    {
                    }
                    column(TransferFromAddr_6_; TransferFromAddr[6])
                    {
                    }
                    column(Transfer_Header___Posting_Date_; "Transfer Header"."Posting Date")
                    {
                    }
                    column(Transfer_Header___Shipment_Date_; "Transfer Header"."Shipment Date")
                    {
                    }
                    column(TransferFromAddr_7_; TransferFromAddr[7])
                    {
                    }
                    column(Destination___Delivery_LocationCaption; Destination___Delivery_LocationCaptionLbl)
                    {
                    }
                    column(Provenance___Loading_PlaceCaption; Provenance___Loading_PlaceCaptionLbl)
                    {
                    }
                    column(Loading_dateCaption; Loading_dateCaptionLbl)
                    {
                    }
                    column(Order_dateCaption; Order_dateCaptionLbl)
                    {
                    }
                    column(PageLoop_Number; Number)
                    {
                    }
                }
                dataitem("Transfer Line"; "Transfer Line")
                {
                    DataItemLink = "Document No." = FIELD("No.");
                    DataItemLinkReference = "Transfer Header";
                    DataItemTableView = SORTING("Document No.", "Line No.") WHERE("Derived From Line No." = CONST(0));
                    column(Transfer_Line__Item_No__; "Item No.")
                    {
                    }
                    column(Transfer_Line_Description; Description)
                    {
                    }
                    column(Transfer_Line_Quantity; Quantity)
                    {
                    }
                    column(Transfer_Line__Unit_of_Measure_; "Unit of Measure")
                    {
                    }
                    column(Transfer_Line__Quantity__Base__; "Quantity (Base)")
                    {
                    }
                    column(Transfer_Line__Vendor_Item_No__; "Vendor Item No.")
                    {
                    }
                    column(ShipmentMethod_Description; ShipmentMethod.Description)
                    {
                    }
                    column(Transfer_Line__Item_No__Caption; FieldCaption("Item No."))
                    {
                    }
                    column(Transfer_Line_DescriptionCaption; FieldCaption(Description))
                    {
                    }
                    column(Transfer_Line_QuantityCaption; FieldCaption(Quantity))
                    {
                    }
                    column(Transfer_Line__Unit_of_Measure_Caption; FieldCaption("Unit of Measure"))
                    {
                    }
                    column(Quantity__Netto___KG_Caption; Quantity__Netto___KG_CaptionLbl)
                    {
                    }
                    column("Vérification_de_l_autorité_vétérinaire___AFSCA_6_H_N_BW_AWECaption"; Vérification_de_l_autorité_vétérinaire___AFSCA_6_H_N_BW_AWECaptionLbl)
                    {
                    }
                    column("Produits_congelés_sont_transportés_à_une_température_____18_CCaption"; Produits_congelés_sont_transportés_à_une_température_____18_CCaptionLbl)
                    {
                    }
                    column("Produits_frais_sont_transportés_à_une_température_____4_CCaption"; Produits_frais_sont_transportés_à_une_température_____4_CCaptionLbl)
                    {
                    }
                    column(ShipmentMethod_DescriptionCaption; ShipmentMethod_DescriptionCaptionLbl)
                    {
                    }
                    column(Transfer_Line_Document_No_; "Document No.")
                    {
                    }
                    column(Transfer_Line_Line_No_; "Line No.")
                    {
                    }
                    dataitem("Reservation Entry"; "Reservation Entry")
                    {
                        DataItemLink = "Source ID" = FIELD("Document No."), "Source Ref. No." = FIELD("Line No.");
                        DataItemTableView = SORTING("Entry No.", Positive) ORDER(Ascending) WHERE("Source Type" = CONST(5741), "Source Subtype" = CONST("0"));
                        column(STRSUBSTNO_Text50000___Reservation_Entry___Lot_No____Reservation_Entry___Warranty_Date__; StrSubstNo(Text50000, "Reservation Entry"."Lot No.", "Reservation Entry"."Warranty Date"))
                        {
                        }
                        column(Reservation_Entry__Reservation_Entry__Quantity; Abs("Reservation Entry".Quantity))
                        {
                        }
                        column(Reservation_Entry_Entry_No_; "Entry No.")
                        {
                        }
                        column(Reservation_Entry_Positive; Positive)
                        {
                        }
                        column(Reservation_Entry_Source_ID; "Source ID")
                        {
                        }
                        column(Reservation_Entry_Source_Ref__No_; "Source Ref. No.")
                        {
                        }
                        column(Reservation_Entry_Item_No_; "Item No.")
                        {
                        }
                        column(Reservation_Entry_Lot_No_; "Lot No.")
                        {
                        }
                        column(Reservation_Entry_Location_Code; "Location Code")
                        {
                        }
                        dataitem(Pallet; Pallet)
                        {
                            DataItemLink = "Item No." = FIELD("Item No."), "Lot No." = FIELD("Lot No."), "Location code" = FIELD("Location Code");
                            DataItemTableView = SORTING("Item No.", "Lot No.", "Bin code");
                            column(Pallet__SSCC_No__; "SSCC No.")
                            {
                            }
                            column(Pallet__Bin_code_; "Bin code")
                            {
                            }
                            column(Pallet__Current_Quantity_; "Current Quantity")
                            {
                            }
                            column(TxtBloque; TxtBloque)
                            {
                            }
                            column(Pallet_Item_No_; "Item No.")
                            {
                            }
                            column(Pallet_Lot_No_; "Lot No.")
                            {
                            }
                            column(Pallet_Location_code; "Location code")
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if not ShowPallet then CurrReport.Skip;
                                Pallet.CalcFields("Current Quantity");
                                if Pallet."Current Quantity" <= 0 then CurrReport.Skip;
                                CalcFields("Lot bloque");
                                TxtBloque := '';
                                if "Lot bloque" then TxtBloque := '!!! Lot bloque !!!';
                            end;
                        }
                    }
                    dataitem(ReservationExpedie; "Reservation Entry")
                    {
                        DataItemLink = "Source ID" = FIELD("Document No."), "Source Prod. Order Line" = FIELD("Line No.");
                        DataItemTableView = SORTING("Entry No.", Positive) ORDER(Ascending) WHERE("Source Type" = CONST(5741), Positive = CONST(true));
                        column(STRSUBSTNO_Text50000__ReservationExpedie__Lot_No___ReservationExpedie__Warranty_Date__; StrSubstNo(Text50000, ReservationExpedie."Lot No.", ReservationExpedie."Warranty Date"))
                        {
                        }
                        column(ReservationExpedie_ReservationExpedie_Quantity; ReservationExpedie.Quantity)
                        {
                        }
                        column(ReservationExpedie_Entry_No_; "Entry No.")
                        {
                        }
                        column(ReservationExpedie_Positive; Positive)
                        {
                        }
                        column(ReservationExpedie_Source_ID; "Source ID")
                        {
                        }
                        column(ReservationExpedie_Source_Prod__Order_Line; "Source Prod. Order Line")
                        {
                        }
                    }
                }
                dataitem("Record Link"; "Record Link")
                {
                    column(NoteText; NoteText)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        CalcFields(Note);
                        if Note.HasValue then begin
                            Clear(TxtNote);

                            Note.CreateInStream(Stream, TEXTENCODING::UTF8);
                            //  Stream.READTEXT(NoteText);
                            TxtNote.Read(Stream);
                            TxtNote.GetSubText(NoteText, 2);
                        end;
                    end;

                    trigger OnPreDataItem()
                    begin
                        RecRef.GetTable("Transfer Header");
                        SetRange("Record ID", RecRef.RecordId);
                        //SETFILTER("Record ID","Transfer Header"."No.");
                        //SETFILTER(Company,COMPANYNAME);
                        SetRange(Type, "Record Link".Type::Note);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then
                        CopyText := Text000;
                    OutputNo += 1;
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Abs(NoOfCopies) + 1;
                    CopyText := '';
                    SetRange(Number, 1, NoOfLoops);
                    OutputNo := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin


                //FormatAddr.TransferHeaderTransferFrom(TransferFromAddr,"Transfer Header");
                FormatAddr.FormatAddr(TransferFromAddr, "Transfer Header"."Transfer-from Name",
                                                       "Transfer Header"."Transfer-from Name 2",
                                                       "Transfer Header"."Transfer-from Contact",
                                                       "Transfer Header"."Transfer-from Address",
                                                       "Transfer Header"."Transfer-from Address 2",
                                                       "Transfer Header"."Transfer-from City",
                                                       "Transfer Header"."Transfer-from Post Code",
                                                       "Transfer Header"."Transfer-from County",
                                                       "Transfer Header"."Trsf.-from Country/Region Code");

                //FormatAddr.TransferHeaderTransferTo(TransferToAddr,"Transfer Header");
                FormatAddr.FormatAddr(TransferToAddr, "Transfer Header"."Transfer-to Name",
                                                       "Transfer Header"."Transfer-to Name 2",
                                                       "Transfer Header"."Transfer-to Contact",
                                                       "Transfer Header"."Transfer-to Address",
                                                       "Transfer Header"."Transfer-to Address 2",
                                                       "Transfer Header"."Transfer-to City",
                                                       "Transfer Header"."Transfer-to Post Code",
                                                       "Transfer Header"."Transfer-to County",
                                                       "Transfer Header"."Trsf.-to Country/Region Code");


                if not ShipmentMethod.Get("Shipment Method Code") then
                    ShipmentMethod.Init;
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

    trigger OnInitReport()
    begin
        CompanyInfo.Get;
        FormatAddr.Company(CompanyAddr, CompanyInfo);
        ShowPallet := false;
    end;

    var
        Text000: Label 'COPY';
        Text001: Label 'Transfer Order %1';
        Text002: Label 'Page %1';
        ShipmentMethod: Record "Shipment Method";
        FormatAddr: Codeunit "Format Address";
        TransferFromAddr: array[8] of Text[50];
        TransferToAddr: array[8] of Text[50];
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        CompanyInfo: Record "Company Information";
        CompanyAddr: array[8] of Text[100];
        Text50000: Label 'Batch No. : %1 - DLC : %2';
        OutputNo: Integer;
        ShowPallet: Boolean;
        TxtBloque: Text[50];
        Destination___Delivery_LocationCaptionLbl: Label 'Destination / Delivery Location';
        Provenance___Loading_PlaceCaptionLbl: Label 'Provenance / Loading Place';
        Loading_dateCaptionLbl: Label 'Loading date';
        Order_dateCaptionLbl: Label 'Order date';
        Quantity__Netto___KG_CaptionLbl: Label 'Quantity (Netto - KG)';
        "Vérification_de_l_autorité_vétérinaire___AFSCA_6_H_N_BW_AWECaptionLbl": Label 'Vérification de l''autorité vétérinaire : AFSCA/6/H.N.BW/AWE';
        "Produits_congelés_sont_transportés_à_une_température_____18_CCaptionLbl": Label 'Produits congelés sont transportés à une température </=-18°C';
        "Produits_frais_sont_transportés_à_une_température_____4_CCaptionLbl": Label 'Produits frais sont transportés à une température </= 4°C';
        ShipmentMethod_DescriptionCaptionLbl: Label 'Shipment Method';
        RecRef: RecordRef;
        TxtNote: BigText;
        Stream: InStream;
        NoteText: Text;

    [Scope('OnPrem')]
    procedure SetShowPallet(value: Boolean)
    begin
        ShowPallet := value;
    end;
}

