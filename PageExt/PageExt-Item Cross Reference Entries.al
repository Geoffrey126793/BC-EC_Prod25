pageextension 70168 pageextension70168 extends "Item Reference Entries"
{
    layout
    {
        addafter(Description)
        {
            field("Observation Description"; "Observation Description")
            {
            }
            field("Item No."; "Item No.")
            {
            }
            field("Nom Tiers"; CustVendorName)
            {
            }
        }
        addafter("Description 2")
        {
            field(GTIN; GTIN)
            {
            }
        }
    }

    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        CustVendorName: Text[80];


    trigger OnAfterGetRecord()
    begin
        if "Reference Type" = "Reference Type"::Customer then
            if Customer.Get("Reference Type No.") then
                CustVendorName := Customer.Name;

        if "Reference Type" = "Reference Type"::Vendor then
            if Vendor.Get("Reference Type No.") then
                CustVendorName := Vendor.Name;

    end;
}

