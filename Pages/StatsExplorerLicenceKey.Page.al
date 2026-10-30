page 8001318 "StatsExplorer Licence Key"
{
    // //STATSEXPLORER STATSEXPLORER 01/10/00 Licence Key

    Caption = 'Licence Key';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Add-On Licence";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                label(Control5)
                {
                    CaptionClass = Text19051838;
                    MultiLine = true;
                    ShowCaption = false;
                }
                label(Control1100287000)
                {
                    CaptionClass = Format(StrSubstNo(tContact));
                    Editable = false;
                    MultiLine = true;
                    ShowCaption = false;
                }
                field(SERIALNUMBER; SerialNumber)
                {
                    Caption = 'Licence No.';
                    Editable = false;
                }
                field("Granule ID"; "Granule ID")
                {
                    Editable = false;
                }
                field("Granule Key"; "Granule Key")
                {

                    trigger OnValidate()
                    var
                        lReturn: Integer;
                    begin
                        //IF lCheck.CheckGranuleKey("Granule Key",SERIALNUMBER,"Granule ID",FALSE) < 0 THEN
                        //  ERROR(tBadKey);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        if not Get('8001316', SerialNumber) then begin
            "Licence ID" := SerialNumber;
            "Granule ID" := '8001316';
            Insert;
        end;
    end;

    var
        tBadKey: Label 'Bad Key';
        tContact: Label 'For more information, send an e-mail to licence@statsexplorer.com';
        Text19051838: Label 'Enter the granule key.';
}

