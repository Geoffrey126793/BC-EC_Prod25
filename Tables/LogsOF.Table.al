table 50031 "Logs OF"
{

    fields
    {
        field(1; ID; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "OF"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Line; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; Date; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(5; Operation; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Préparation",Consommation,Production;
        }
        field(6; Operateur; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(7; Materiel; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(8; Temperature; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9; Remarque; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(10; Item; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(11; Lot; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(12; Log; Text[1024])
        {
            DataClassification = ToBeClassified;
        }
        field(13; Quantity; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; ID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        tmpLog: Record "Logs OF";
    begin
        if ID = 0 then begin
            tmpLog.Reset;
            if tmpLog.FindLast then
                ID := tmpLog.ID + 1
            else
                ID := 1;
        end;
    end;

    trigger OnModify()
    var
        ILE: Record "Item Ledger Entry";
    begin
        if Lot = 'OF' then begin
            ILE.Reset;
            ILE.SetRange("Entry Type", ILE."Entry Type"::Output);
            ILE.SetRange("Order No.", Rec."OF");
            if ILE.FindLast then
                Lot := ILE."Lot No."
            else
                Lot := '';

        end;
        if (Temperature > -999) then
            Log := Format(Date) + ' ' + Format(Operation) + ' ' + Item + ' - Lot: ' + Lot + ' = ' + Format(Quantity) + ' Kg  ' + Format(Temperature) + '°C ' + Materiel + '(' + Operateur + ')'
        else
            Log := Format(Date) + ' ' + Format(Operation) + ' ' + Item + ' - Lot: ' + Lot + ' = ' + Format(Quantity) + ' Kg  ' + Materiel + '(' + Operateur + ')';
    end;
}

